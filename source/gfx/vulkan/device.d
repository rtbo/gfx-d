/// Vulkan device module
module gfx.vulkan.device;

package:

import core.time : Duration;

import erupted;

import gfx.core.rc;
import gfx.graal.cmd;
import gfx.graal.device;
import gfx.graal.image;
import gfx.graal.memory;
import gfx.graal.presentation;
import gfx.graal.queue;
import gfx.graal.sync;
import gfx.vulkan;
import gfx.vulkan.buffer;
import gfx.vulkan.cmd;
import gfx.vulkan.conv;
import gfx.vulkan.error;
import gfx.vulkan.image;
import gfx.vulkan.memory;
import gfx.vulkan.queue;
import gfx.vulkan.sync;
import gfx.vulkan.wsi;

import std.typecons : Flag;

class VulkanDevObj(VkType, alias destroyFn) : Disposable
{
    this (VkType vk, VulkanDevice dev)
    {
        _vk = vk;
        _dev = dev;
        _dev.retain();
    }

    override void dispose() {
        destroyFn(vkDev, vk, null);
        _dev.release();
        _dev = null;
    }

    final @property VkType vk() {
        return _vk;
    }

    final @property VulkanDevice dev() {
        return _dev;
    }

    final @property VkDevice vkDev() {
        return _dev.vk;
    }

    VkType _vk;
    VulkanDevice _dev;
}

final class VulkanDevice : VulkanObj!(VkDevice, vkDestroyDevice), Device
{
    mixin(atomicRcCode);

    this (VkDevice vk, VulkanPhysicalDevice pd)
    {
        super(vk);
        _pd = pd;
        _pd.retain();
    }

    override void dispose() {
        super.dispose();
        _pd.release();
        _pd = null;
    }

    @property VulkanPhysicalDevice pd() {
        return _pd;
    }

    override void waitIdle() {
        vulkanEnforce(
            vkDeviceWaitIdle(vk),
            "Problem waiting for device"
        );
    }

    override Queue getQueue(uint queueFamilyIndex, uint queueIndex) {
        VkQueue vkQ;
        vkGetDeviceQueue(vk, queueFamilyIndex, queueIndex, &vkQ);

        foreach (q; _queues) {
            if (q.vk is vkQ) {
                return q;
            }
        }

        auto q = new VulkanQueue(vkQ);
        _queues ~= q;
        return q;
    }

    override CommandPool createCommandPool(uint queueFamilyIndex) {
        VkCommandPoolCreateInfo cci;
        cci.sType = VK_STRUCTURE_TYPE_COMMAND_POOL_CREATE_INFO;
        cci.queueFamilyIndex = queueFamilyIndex;
        cci.flags = VK_COMMAND_POOL_CREATE_RESET_COMMAND_BUFFER_BIT;

        VkCommandPool vkPool;
        vulkanEnforce(
            vkCreateCommandPool(vk, &cci, null, &vkPool),
            "Could not create vulkan command pool"
        );

        return new VulkanCommandPool(vkPool, this);
    }

    override DeviceMemory allocateMemory(uint memTypeIndex, size_t size)
    {
        VkMemoryAllocateInfo mai;
        mai.sType = VK_STRUCTURE_TYPE_MEMORY_ALLOCATE_INFO;
        mai.allocationSize = size;
        mai.memoryTypeIndex = memTypeIndex;

        VkDeviceMemory vkMem;
        vulkanEnforce(vkAllocateMemory(vk, &mai, null, &vkMem), "Could not allocate device memory");

        return new VulkanDeviceMemory(vkMem, this, memTypeIndex, size);
    }

    override void flushMappedMemory(MappedMemorySet set)
    {
        import std.algorithm : map;
        import std.array : array;
        VkMappedMemoryRange[] mmrs = set.mms.map!((MappedMemorySet.MM mm) {
            VkMappedMemoryRange mmr;
            mmr.sType = VK_STRUCTURE_TYPE_MAPPED_MEMORY_RANGE;
            mmr.memory = (cast(VulkanDeviceMemory)mm.dm).vk;
            mmr.offset = mm.offset;
            mmr.size = mm.size;
            return mmr;
        }).array;

        vkFlushMappedMemoryRanges(vk, cast(uint)mmrs.length, mmrs.ptr);
    }

    override void invalidateMappedMemory(MappedMemorySet set) {
        import std.algorithm : map;
        import std.array : array;
        VkMappedMemoryRange[] mmrs = set.mms.map!((MappedMemorySet.MM mm) {
            VkMappedMemoryRange mmr;
            mmr.sType = VK_STRUCTURE_TYPE_MAPPED_MEMORY_RANGE;
            mmr.memory = (cast(VulkanDeviceMemory)mm.dm).vk;
            mmr.offset = mm.offset;
            mmr.size = mm.size;
            return mmr;
        }).array;

        vkInvalidateMappedMemoryRanges(vk, cast(uint)mmrs.length, mmrs.ptr);
    }

    override Buffer createBuffer(BufferUsage usage, size_t size)
    {
        VkBufferCreateInfo bci;
        bci.sType = VK_STRUCTURE_TYPE_BUFFER_CREATE_INFO;
        bci.size = size;
        bci.usage = bufferUsageToVk(usage);

        VkBuffer vkBuf;
        vulkanEnforce(vkCreateBuffer(vk, &bci, null, &vkBuf), "Could not create a Vulkan buffer");

        return new VulkanBuffer(vkBuf, this, usage, size);
    }

    override Image createImage(ImageType type, ImageDims dims, Format format,
                               ImageUsage usage, uint samples, uint levels=1)
    {
        VkImageCreateInfo ici;
        ici.sType = VK_STRUCTURE_TYPE_IMAGE_CREATE_INFO;
        if (type.isCube) ici.flags |= VK_IMAGE_CREATE_CUBE_COMPATIBLE_BIT;
        ici.imageType = type.toVk();
        ici.format = format.toVk();
        ici.extent = VkExtent3D(dims.width, dims.height, dims.depth);
        ici.mipLevels = levels;
        ici.arrayLayers = dims.layers;
        ici.samples = cast(typeof(ici.samples))samples;
        ici.tiling = VK_IMAGE_TILING_OPTIMAL;
        ici.usage = imageUsageToVk(usage);
        ici.sharingMode = VK_SHARING_MODE_EXCLUSIVE;

        VkImage vkImg;
        vulkanEnforce(vkCreateImage(vk, &ici, null, &vkImg), "Could not create a Vulkan image");

        return new VulkanImage(vkImg, this, type, dims);
    }

    override Semaphore createSemaphore()
    {
        VkSemaphoreCreateInfo sci;
        sci.sType = VK_STRUCTURE_TYPE_SEMAPHORE_CREATE_INFO;

        VkSemaphore vkSem;
        vulkanEnforce(vkCreateSemaphore(vk, &sci, null, &vkSem), "Could not create a Vulkan semaphore");

        return new VulkanSemaphore(vkSem, this);
    }

    override Fence createFence(Flag!"signaled" signaled)
    {
        VkFenceCreateInfo fci;
        fci.sType = VK_STRUCTURE_TYPE_FENCE_CREATE_INFO;
        if (signaled) {
            fci.flags = VK_FENCE_CREATE_SIGNALED_BIT;
        }
        VkFence vkF;
        vulkanEnforce(vkCreateFence(vk, &fci, null, &vkF), "Could not create a Vulkan fence");

        return new VulkanFence(vkF, this);
    }

    override void resetFences(Fence[] fences) {
        import std.algorithm : map;
        import std.array : array;

        auto vkFs = fences.map!(
            f => enforce(cast(VulkanFence)f, "Did not pass a Vulkan fence").vk
        ).array;

        vulkanEnforce(
            vkResetFences(vk, cast(uint)vkFs.length, &vkFs[0]),
            "Could not reset vulkan fences"
        );
    }

    override void waitForFances(Fence[] fences, Flag!"waitAll" waitAll, Duration timeout)
    {
        import std.algorithm : map;
        import std.array : array;

        auto vkFs = fences.map!(
            f => enforce(cast(VulkanFence)f, "Did not pass a Vulkan fence").vk
        ).array;

        const vkWaitAll = waitAll ? VK_TRUE : VK_FALSE;
        const nsecs = timeout.total!"nsecs";
        const vkTimeout = nsecs < 0 ? ulong.max : cast(ulong)nsecs;

        vulkanEnforce(
            vkWaitForFences(vk, cast(uint)vkFs.length, &vkFs[0], vkWaitAll, vkTimeout),
            "could not wait for vulkan fences"
        );
    }


    override Swapchain createSwapchain(Surface graalSurface, PresentMode pm, uint numImages,
                                       Format format, uint[2] size, ImageUsage usage,
                                       CompositeAlpha alpha, Swapchain old=null)
    {
        auto surf = enforce(
            cast(VulkanSurface)graalSurface,
            "Did not pass a Vulkan surface"
        );

        auto oldSc = old ? enforce(
            cast(VulkanSwapchain)old, "Did not pass a vulkan swapchain"
        ) : null;

        VkSwapchainCreateInfoKHR sci;
        sci.sType = VK_STRUCTURE_TYPE_SWAPCHAIN_CREATE_INFO_KHR;
        sci.surface = surf.vk;
        sci.minImageCount = numImages;
        sci.imageFormat = format.toVk;
        sci.imageExtent = VkExtent2D(size[0], size[1]);
        sci.imageArrayLayers = 1;
        sci.imageUsage = imageUsageToVk(usage);
        sci.imageColorSpace = VK_COLOR_SPACE_SRGB_NONLINEAR_KHR;
        sci.preTransform = VK_SURFACE_TRANSFORM_IDENTITY_BIT_KHR;
        sci.clipped = VK_TRUE;
        sci.presentMode = pm.toVk;
        sci.compositeAlpha = compositeAlphaToVk(alpha);
        sci.oldSwapchain = oldSc ? oldSc.vk : null;

        VkSwapchainKHR vkSc;
        vulkanEnforce(
            vkCreateSwapchainKHR(vk, &sci, null, &vkSc),
            "Could not create a Vulkan Swap chain"
        );

        return new VulkanSwapchain(vkSc, this, size);
    }

    private VulkanPhysicalDevice _pd;
    private VulkanQueue[] _queues;
}
