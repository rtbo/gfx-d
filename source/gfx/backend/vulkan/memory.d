
module gfx.backend.vulkan.memory;

package:

import erupted;

import gfx.backend.vulkan.device;
import gfx.core.rc;
import gfx.graal.memory;

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

    @property VkDeviceMemory vk() {
        return _vk;
    }

    override @property uint typeIndex() {
        return _typeIndex;
    }

    override @property size_t size() {
        return _size;
    }

    void* map(in size_t offset, in size_t size) {
        void *data;
        vulkanEnforce(
            vkMapMemory(_dev.vk, _vk, offset, size, 0, &data),
            "Could not map device memory"
        );
        return data;
    }

    void unmap() {
        vkUnmapMemory(_dev.vk, _vk);
    }

    private VkDeviceMemory _vk;
    private VulkanDevice _dev;
    private uint _typeIndex;
    private size_t _size;
}
