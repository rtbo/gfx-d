
module gfx.vulkan.memory;

package:

import gfx.bindings.vulkan;

import gfx.core.rc;
import gfx.graal.memory;
import gfx.vulkan.device;

class VulkanDeviceMemory : VulkanDevObj!(VkDeviceMemory, "freeMemory"), DeviceMemory
{
    mixin(atomicRcCode);

    this(VkDeviceMemory vk, VulkanDevice dev, in uint typeIndex, in size_t size)
    {
        super(vk, dev);
        _typeIndex = typeIndex;
        _size = size;
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
            cmds.mapMemory(vkDev, vk, offset, size, 0, &data),
            "Could not map device memory"
        );
        return data;
    }

    void unmap() {
        cmds.unmapMemory(vkDev, vk);
    }

    private uint _typeIndex;
    private size_t _size;
}
