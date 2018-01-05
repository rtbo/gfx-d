/// Vulkan device module
module gfx.backend.vulkan.device;

package:

import erupted;

import gfx.backend.vulkan;
import gfx.core.rc;
import gfx.hal.device;
import gfx.hal.memory;

class VulkanDevice : Device
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

    override DeviceMemory allocateMemory(uint memPropIndex, size_t size)
    {
        return null;
    }

    VkDevice _vk;
    VulkanPhysicalDevice _pd;
}
