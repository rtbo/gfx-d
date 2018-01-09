/// Vulkan image module
module gfx.vulkan.image;

package:

import erupted;

import gfx.core.rc;
import gfx.graal.image;
import gfx.graal.memory;
import gfx.vulkan.device;
import gfx.vulkan.error;
import gfx.vulkan.memory;

class VulkanImage : VulkanDevObj!(VkImage, vkDestroyImage), Image
{
    mixin(atomicRcCode);

    this(VkImage vk, VulkanDevice dev, ImageDims dims)
    {
        super(vk, dev);
        _dims = dims;
    }

    override @property ImageDims dims() {
        return _dims;
    }

    override @property MemoryRequirements memoryRequirements() {
        VkMemoryRequirements vkMr;
        vkGetImageMemoryRequirements(vkDev, vk, &vkMr);
        return vkMr.fromVk();
    }

    override void bindMemory(DeviceMemory mem, in size_t offset)
    {
        auto vulkanMem = cast(VulkanDeviceMemory)mem;
        vulkanEnforce(
            vkBindImageMemory(vkDev, vk, vulkanMem.vk, offset),
            "Could not bind image memory"
        );
    }

    private ImageDims _dims;
}
