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
    this(VkImage vkObj, VulkanDevice dev, ImageType type, ImageDims dims, Format format)
    {
        _vkObj = vkObj;
        _dev = dev;
        _type = type;
        _dims = dims;
        _format = format;
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

    final override @property ImageType type() {
        return _type;
    }
    final @property Format format() {
        return _format;
    }
    final override @property ImageDims dims() {
        return _dims;
    }
    final @property uint levels() {
        return _levels;
    }

    override VulkanImageView createView(ImageType viewType, ImageSubresourceRange isr, Swizzle swizzle)
    {
        const it = type;
        VkImageViewCreateInfo ivci;
        ivci.sType = VK_STRUCTURE_TYPE_IMAGE_VIEW_CREATE_INFO;
        ivci.image = vkObj;
        ivci.viewType = viewType.toVkView();
        ivci.format = format.toVk();
        ivci.subresourceRange = isr.toVk();
        ivci.components = swizzle.toVk();

        VkImageView vkIv;
        vulkanEnforce(
            vk.createImageView(vkDev, &ivci, null, &vkIv),
            "Could not create Vulkan View"
        );

        return new VulkanImageView(vkIv, this, isr, swizzle);
    }

    private VkImage _vkObj;
    private VulkanDevice _dev;
    private VkDeviceCmds _vk;
    private ImageType _type;
    private ImageDims _dims;
    private Format _format;
    private uint _levels;
}

class VulkanImage : VulkanImageBase, Image
{
    mixin(atomicRcCode);

    this(VkImage vkObj, VulkanDevice dev, ImageType type, ImageDims dims, Format format)
    {
        super(vkObj, dev, type, dims, format);
        dev.retain();
    }

    override void dispose() {
        vk.destroyImage(vkDev, vkObj, null);
        if (_vdm) _vdm.release();
        dev.release();
    }

    override @property MemoryRequirements memoryRequirements() {
        VkMemoryRequirements vkMr;
        vk.getImageMemoryRequirements(vkDev, vkObj, &vkMr);
        return vkMr.toGfx();
    }

    override void bindMemory(DeviceMemory mem, in size_t offset)
    {
        assert(!_vdm, "Bind the same buffer twice");
        _vdm = enforce(cast(VulkanDeviceMemory)mem, "Did not pass a Vulkan memory");
        vulkanEnforce(
            vk.bindImageMemory(vkDev, vkObj, _vdm.vkObj, offset),
            "Could not bind image memory"
        );
        _vdm.retain();
    }

    VulkanDeviceMemory _vdm;
}

class VulkanImageView : VulkanDevObj!(VkImageView, "destroyImageView"), ImageView
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

class VulkanSampler : VulkanDevObj!(VkSampler, "destroySampler"), Sampler
{
    mixin(atomicRcCode);
    this(VkSampler sampler, VulkanDevice dev) {
        super(sampler, dev);
    }
}
