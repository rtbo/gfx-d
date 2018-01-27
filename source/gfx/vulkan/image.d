/// Vulkan image module
module gfx.vulkan.image;

package:

import erupted;

import gfx.core.rc;
import gfx.graal.image;
import gfx.graal.memory;
import gfx.vulkan;
import gfx.vulkan.conv;
import gfx.vulkan.device;
import gfx.vulkan.error;
import gfx.vulkan.memory;

class VulkanImage : Image
{
    this(VkImage vk, VulkanDevice dev, ImageType type, ImageDims dims, Format format)
    {
        _vk = vk;
        _dev = dev;
        _type = type;
        _dims = dims;
        _format = format;
    }

    final @property VkImage vk()
    {
        return _vk;
    }

    final @property VulkanDevice dev()
    {
        return _dev;
    }

    final @property VkDevice vkDev()
    {
        return _dev.vk;
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
        ivci.image = vk;
        ivci.viewType = viewType.toVkView();
        ivci.format = format.toVk();
        ivci.subresourceRange = isr.toVk();
        ivci.components = swizzle.toVk();

        VkImageView vkIv;
        vulkanEnforce(
            vkCreateImageView(vkDev, &ivci, null, &vkIv),
            "Could not create Vulkan View"
        );

        return new VulkanImageView(vkIv, this, isr, swizzle);
    }

    private VkImage _vk;
    private VulkanDevice _dev;
    private ImageType _type;
    private ImageDims _dims;
    private Format _format;
    private uint _levels;
}

class VulkanImageRc : VulkanImage, ImageRc
{
    mixin(atomicRcCode);

    this(VkImage vk, VulkanDevice dev, ImageType type, ImageDims dims, Format format)
    {
        super(vk, dev, type, dims, format);
        dev.retain();
    }

    override void dispose() {
        vkDestroyImage(vkDev, vk, null);
        dev.release();
    }

    override @property MemoryRequirements memoryRequirements() {
        VkMemoryRequirements vkMr;
        vkGetImageMemoryRequirements(vkDev, vk, &vkMr);
        return vkMr.toGfx();
    }

    override void bindMemory(DeviceMemory mem, in size_t offset)
    {
        auto vulkanMem = cast(VulkanDeviceMemory)mem;
        vulkanEnforce(
            vkBindImageMemory(vkDev, vk, vulkanMem.vk, offset),
            "Could not bind image memory"
        );
    }
}

class VulkanImageView : VulkanDevObj!(VkImageView, vkDestroyImageView), ImageView
{
    mixin(atomicRcCode);

    this(VkImageView vk, VulkanImage img, ImageSubresourceRange isr, Swizzle swizzle)
    {
        super(vk, img.dev);
        _img = img;
        _isr = isr;
        _swizzle = swizzle;
    }

    override void dispose()
    {
        super.dispose();
        _img = null;
    }

    override @property VulkanImage image() {
        return _img;
    }

    override @property ImageSubresourceRange subresourceRange() {
        return _isr;
    }

    override @property Swizzle swizzle() {
        return _swizzle;
    }

    private VulkanImage _img;
    private ImageSubresourceRange _isr;
    private Swizzle _swizzle;
}
