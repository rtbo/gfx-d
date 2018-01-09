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

class VulkanImage : Image
{
    mixin(atomicRcCode);

    this(VkImage vk, VulkanDevice dev, ImageDims dims)
    {
        _vk = vk;
        _dev = dev;
        _dev.retain();
        _dims = dims;
    }

    override void dispose() {
        vkDestroyImage(_dev.vk, _vk, null);
        _dev.release();
    }

    final @property VkImage vk() {
        return _vk;
    }

    override @property ImageDims dims() {
        return _dims;
    }

    override @property MemoryRequirements memoryRequirements() {
        VkMemoryRequirements vkMr;
        vkGetImageMemoryRequirements(_dev.vk, _vk, &vkMr);
        return memoryRequirementsFromVk(vkMr);
    }

    override void bindMemory(DeviceMemory mem, in size_t offset)
    {
        auto vulkanMem = cast(VulkanDeviceMemory)mem;
        vulkanEnforce(
            vkBindImageMemory(_dev.vk, vk, vulkanMem.vk, offset),
            "Could not bind image memory"
        );
    }

    private VkImage _vk;
    private VulkanDevice _dev;
    private ImageDims _dims;
}
