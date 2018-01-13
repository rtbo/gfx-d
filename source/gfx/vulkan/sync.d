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
