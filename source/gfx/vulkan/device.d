/// Vulkan device module
module gfx.vulkan.device;

package:

import erupted;

import gfx.core.rc;
import gfx.graal.device;
import gfx.graal.memory;
import gfx.vulkan;
import gfx.vulkan.error;
import gfx.vulkan.memory;

final class VulkanDevice : Device
{
    mixin(atomicRcCode);

    this (VkDevice vk, VulkanPhysicalDevice pd)
    {
        _vk = vk;
        _pd = pd;
        _pd.retain();
    }

    override void dispose() {
        vkDestroyDevice(_vk, null);
        _vk = null;
        _pd.release();
        _pd = null;
    }

    @property VkDevice vk() {
        return _vk;
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
        vulkanEnforce(vkAllocateMemory(_vk, &mai, null, &vkMem), "Could not allocate device memory");

        return new VulkanDeviceMemory(vkMem, this, memTypeIndex, size);
    }

    void flushMappedMemory(MappedMemorySet set)
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

        vkFlushMappedMemoryRanges(_vk, cast(uint)mmrs.length, mmrs.ptr);
    }
    void invalidateMappedMemory(MappedMemorySet set) {
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

        vkInvalidateMappedMemoryRanges(_vk, cast(uint)mmrs.length, mmrs.ptr);
    }

    VkDevice _vk;
    VulkanPhysicalDevice _pd;
}
