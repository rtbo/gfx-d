module gfx.vulkan.sync;

package:

import core.time : dur, Duration;

import gfx.bindings.vulkan;

import gfx.core.rc;
import gfx.graal.sync;
import gfx.vulkan.device;

class VulkanSemaphore : VulkanDevObj!(VkSemaphore, "DestroySemaphore"), Semaphore
{
    mixin(atomicRcCode);

    this(VkSemaphore vkObj, VulkanDevice dev) {
        super(vkObj, dev);
    }

    override @property Device device() {
        return dev;
    }
}

class VulkanFence : VulkanDevObj!(VkFence, "DestroyFence"), Fence
{
    mixin(atomicRcCode);

    this (VkFence vkObj, VulkanDevice dev) {
        super(vkObj, dev);
    }

    override @property Device device() {
        return dev;
    }

    override @property bool signaled() {
        return vk.GetFenceStatus(vkDev, vkObj) == VK_SUCCESS;
    }

    override void reset()
    {
        auto vkF = vkObj;
        vulkanEnforce(
            vk.ResetFences(vkDev, 1, &vkF),
            "Could not reset Vulkan fence"
        );
    }

    override void wait(Duration timeout=dur!"seconds"(-1))
    {
        const nsecs = timeout.total!"nsecs";
        const vkTimeout = nsecs < 0 ? ulong.max : cast(ulong)nsecs;
        auto vkF = vkObj;

        vulkanEnforce(
            vk.WaitForFences(vkDev, 1, &vkF, VK_TRUE, vkTimeout),
            "Could not wait for Vulkan fence"
        );
    }
}
