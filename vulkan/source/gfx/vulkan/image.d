/// Vulkan image module
module gfx.vulkan.image;

package:

import gfx.bindings.vulkan;

import gfx.core.rc;
import gfx.graal.image;
import gfx.graal.memory;
import gfx.vulkan;
import gfx.vulkan.conv;
import gfx.vulkan.device;
import gfx.vulkan.error;
import gfx.vulkan.memory;

class VulkanImageBase : ImageBase
{
    this(VkImage vkObj, VulkanDevice dev, ImageInfo info)
    {
        _vkObj = vkObj;
        _dev = dev;
        _info = info;
        _vk = dev.vk;
    }

    final @property VkImage vkObj()
    {
        return _vkObj;
    }

    final @property VulkanDevice dev()
    {
        return _dev;
    }

    final @property VkDevice vkDev()
    {
        return _dev.vkObj;
    }

    final @property VkDeviceCmds vk() {
        return _vk;
    }

    final override @property ImageInfo info() {
        return _info;
    }

    override VulkanImageView createView(ImageType viewType, ImageSubresourceRange isr, Swizzle swizzle)
    {
        const it = _info.type;
        VkImageViewCreateInfo ivci;
        ivci.sType = VK_STRUCTURE_TYPE_IMAGE_VIEW_CREATE_INFO;
        ivci.image = vkObj;
        ivci.viewType = viewType.toVkView();
        ivci.format = _info.format.toVk();
        ivci.subresourceRange = isr.toVk();
        ivci.components = swizzle.toVk();

        VkImageView vkIv;
        vulkanEnforce(
            vk.CreateImageView(vkDev, &ivci, null, &vkIv),
            "Could not create Vulkan View"
        );

        return new VulkanImageView(vkIv, this, isr, swizzle);
    }

    private VkImage _vkObj;
    private VulkanDevice _dev;
    private VkDeviceCmds _vk;
    private ImageInfo _info;
}

final class VulkanImage : VulkanImageBase, Image
{
    mixin(atomicRcCode);

    this(VkImage vkObj, VulkanDevice dev, ImageInfo info)
    {
        super(vkObj, dev, info);
        dev.retain();
    }

    override void dispose() {
        vk.DestroyImage(vkDev, vkObj, null);
        if (_vdm) _vdm.release();
        dev.release();
    }

    override Device device() {
        return dev;
    }

    override @property MemoryRequirements memoryRequirements() {
        VkMemoryRequirements vkMr;
        vk.GetImageMemoryRequirements(vkDev, vkObj, &vkMr);
        return vkMr.toGfx();
    }

    override void bindMemory(DeviceMemory mem, in size_t offset)
    {
        assert(!_vdm, "Bind the same buffer twice");
        _vdm = enforce(cast(VulkanDeviceMemory)mem, "Did not pass a Vulkan memory");
        vulkanEnforce(
            vk.BindImageMemory(vkDev, vkObj, _vdm.vkObj, offset),
            "Could not bind image memory"
        );
        _vdm.retain();
    }

    override @property DeviceMemory boundMemory() {
        return _vdm;
    }

    VulkanDeviceMemory _vdm;
}

class VulkanImageView : VulkanDevObj!(VkImageView, "DestroyImageView"), ImageView
{
    mixin(atomicRcCode);

    this(VkImageView vkObj, VulkanImageBase img, ImageSubresourceRange isr, Swizzle swizzle)
    {
        super(vkObj, img.dev);
        _img = img;
        _isr = isr;
        _swizzle = swizzle;
    }

    override void dispose()
    {
        super.dispose();
        _img = null;
    }

    override @property VulkanImageBase image() {
        return _img;
    }

    override @property ImageSubresourceRange subresourceRange() {
        return _isr;
    }

    override @property Swizzle swizzle() {
        return _swizzle;
    }

    private VulkanImageBase _img;
    private ImageSubresourceRange _isr;
    private Swizzle _swizzle;
}

final class VulkanSampler : VulkanDevObj!(VkSampler, "DestroySampler"), Sampler
{
    mixin(atomicRcCode);
    this(VkSampler sampler, VulkanDevice dev) {
        super(sampler, dev);
    }
    override @property Device device() {
        return dev;
    }
}
