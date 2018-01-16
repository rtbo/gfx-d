/// Vulkan command module
module gfx.vulkan.cmd;

package:

import erupted;

import gfx.core.rc;
import gfx.graal.cmd;
import gfx.vulkan.device;
import gfx.vulkan.error;

class VulkanCommandPool : VulkanDevObj!(VkCommandPool, vkDestroyCommandPool), CommandPool
{
    mixin(atomicRcCode);

    this (VkCommandPool pool, VulkanDevice dev) {
        super(pool, dev);
    }

    override void reset() {
        vulkanEnforce(vkResetCommandPool(vkDev, vk, 0), "Could not reset command buffer");
    }
}
