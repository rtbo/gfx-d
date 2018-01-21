module gfx.vulkan.renderpass;

package:

import erupted;

import gfx.core.rc;
import gfx.graal.device;
import gfx.graal.image;
import gfx.graal.renderpass;
import gfx.vulkan.device;

class VulkanRenderPass : VulkanDevObj!(VkRenderPass, vkDestroyRenderPass), RenderPass
{
    mixin(atomicRcCode);

    this(VkRenderPass vk, VulkanDevice dev) {
        super(vk, dev);
    }
}

class VulkanFramebuffer : VulkanDevObj!(VkFramebuffer, vkDestroyFramebuffer), Framebuffer
{
    mixin(atomicRcCode);

    this(VkFramebuffer vk, VulkanDevice dev, ImageView[] views) {
        super(vk, dev);
        _views = views;
        retainArray(_views);
    }

    override void dispose() {
        releaseArray(_views);
        _views = [];
        super.dispose();
    }

    ImageView[] _views;
}
