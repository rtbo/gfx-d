
module gfx.vulkan.memory;

package:

import gfx.bindings.vulkan;

import gfx.core.rc;
import gfx.graal.memory;
import gfx.vulkan.device;

class VulkanDeviceMemory : VulkanDevObj!(VkDeviceMemory, "FreeMemory"), DeviceMemory
{
    mixin(atomicRcCode);

    this(VkDeviceMemory vkObj, VulkanDevice dev, in MemProps props, in size_t size, in uint typeIndex)
    {
        super(vkObj, dev);
        _props = props;
        _size = size;
        _typeIndex = typeIndex;
    }

    override @property Device device() {
        return dev;
    }

    override @property MemProps props() {
        return _props;
    }

    override @property size_t size() {
        return _size;
    }

    override @property uint typeIndex() {
        return _typeIndex;
    }

    void* mapRaw(in size_t offset, in size_t size) {
        void *data;
        vulkanEnforce(
            vk.MapMemory(vkDev, vkObj, offset, size, 0, &data),
            "Could not map device memory"
        );
        return data;
    }

    void unmapRaw() {
        vk.UnmapMemory(vkDev, vkObj);
    }

    private MemProps _props;
    private size_t _size;
    private uint _typeIndex;
}
