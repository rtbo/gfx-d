/// Vulkan device module
module gfx.vulkan.device;

package:

import erupted;

import gfx.core.rc;
import gfx.graal.device;
import gfx.graal.image;
import gfx.graal.memory;
import gfx.graal.sync;
import gfx.vulkan;
import gfx.vulkan.buffer;
import gfx.vulkan.conv;
import gfx.vulkan.error;
import gfx.vulkan.image;
import gfx.vulkan.memory;
import gfx.vulkan.sync;

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

    VulkanPhysicalDevice _pd;
}
