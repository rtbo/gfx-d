module gfx.vulkan.renderpass;

package:

import erupted;

import gfx.core.rc;
import gfx.graal.device;
import gfx.graal.renderpass;
import gfx.vulkan.device;

class VulkanRenderPass : VulkanDevObj!(VkRenderPass, vkDestroyRenderPass), RenderPass
{
    mixin(atomicRcCode);

    this(VkRenderPass vk, VulkanDevice dev) {
        super(vk, dev);
    }
}
