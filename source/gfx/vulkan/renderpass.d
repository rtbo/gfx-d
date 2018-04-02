module gfx.vulkan.renderpass;

package:

import gfx.bindings.vulkan;

import gfx.core.rc;
import gfx.graal.device;
import gfx.graal.image;
import gfx.graal.renderpass;
import gfx.vulkan.device;

class VulkanRenderPass : VulkanDevObj!(VkRenderPass, "destroyRenderPass"), RenderPass
{
    mixin(atomicRcCode);

    this(VkRenderPass vkObj, VulkanDevice dev) {
        super(vkObj, dev);
    }
}

class VulkanFramebuffer : VulkanDevObj!(VkFramebuffer, "destroyFramebuffer"), Framebuffer
{
    mixin(atomicRcCode);

    this(VkFramebuffer vkObj, VulkanDevice dev, ImageView[] views) {
        super(vkObj, dev);
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
