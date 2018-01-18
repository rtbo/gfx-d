module gfx.vulkan.sync;

package:

import erupted;

import gfx.core.rc;
import gfx.graal.sync;
import gfx.vulkan.device;

class VulkanSemaphore : VulkanDevObj!(VkSemaphore, vkDestroySemaphore), Semaphore
{
    mixin(atomicRcCode);

    this(VkSemaphore vk, VulkanDevice dev) {
        super(vk, dev);
    }
}

class VulkanFence : VulkanDevObj!(VkFence, vkDestroyFence), Fence
{
    mixin(atomicRcCode);

    this (VkFence vk, VulkanDevice dev) {
        super(vk, dev);
    }

    override @property bool signaled() {
        return vkGetFenceStatus(vkDev, vk) == VK_SUCCESS;
    }
}