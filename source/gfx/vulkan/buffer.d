/// Vulkan buffer module
module gfx.vulkan.buffer;

package:

import erupted;

import gfx.core.rc;
import gfx.graal.buffer;
import gfx.vulkan.device;
import gfx.vulkan.error;
import gfx.vulkan.memory;

class VulkanBuffer : VulkanDevObj!(VkBuffer, vkDestroyBuffer), Buffer
{
    mixin(atomicRcCode);

    this (VkBuffer vk, VulkanDevice dev, BufferUsage usage, size_t size)
    {
        super(vk, dev);
        _usage = usage;
        _size = size;
    }

    @property BufferUsage usage() {
        return _usage;
    }

    @property size_t size() {
        return _size;
    }

    override @property MemoryRequirements memoryRequirements() {
        VkMemoryRequirements vkMr;
        vkGetBufferMemoryRequirements(vkDev, vk, &vkMr);
        return vkMr.fromVk();
    }

    override void bindMemory(DeviceMemory mem, in size_t offset)
    {
        auto vulkanMem = cast(VulkanDeviceMemory)mem;
        vulkanEnforce(
            vkBindBufferMemory(vkDev, vk, vulkanMem.vk, offset),
            "Could not bind image memory"
        );
    }

    private BufferUsage _usage;
    private size_t _size;
}
