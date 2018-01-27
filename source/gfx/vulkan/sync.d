module gfx.vulkan.sync;

package:

import core.time : dur, Duration;

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

    override void reset()
    {
        auto vkF = vk;
        vulkanEnforce(
            vkResetFences(vkDev, 1, &vkF),
            "Could not reset Vulkan fence"
        );
    }

    override void wait(Duration timeout=dur!"seconds"(-1))
    {
        const nsecs = timeout.total!"nsecs";
        const vkTimeout = nsecs < 0 ? ulong.max : cast(ulong)nsecs;
        auto vkF = vk;

        vulkanEnforce(
            vkWaitForFences(vkDev, 1, &vkF, VK_TRUE, vkTimeout),
            "Could not wait for Vulkan fence"
        );
    }
}