
module gfx.backend.vulkan.memory;

import erupted;

import gfx.backend.vulkan.device;
import gfx.core.rc;
import gfx.hal.memory;

class VulkanDeviceMemory : DeviceMemory
{
    mixin(atomicRcCode);

    this(VkDeviceMemory vk, VulkanDevice dev, in uint typeIndex, in size_t size)
    {
        _vk = vk;
        _dev = dev;
        _dev.retain();
        _typeIndex = typeIndex;
        _size = size;
    }

    override void dispose() {
        vkFreeMemory(_dev.vk, _vk, null);
        _dev.release();
    }

    override @property uint typeIndex() {
        return _typeIndex;
    }

    override @property size_t size() {
        return _size;
    }

    private VkDeviceMemory _vk;
    private VulkanDevice _dev;
    private uint _typeIndex;
    private size_t _size;
}
