module gfx.vulkan.renderpass;

package:

import gfx.bindings.vulkan;

import gfx.core.rc;
import gfx.graal.device;
import gfx.graal.image;
import gfx.graal.renderpass;
import gfx.vulkan.device;

class VulkanRenderPass : VulkanDevObj!(VkRenderPass, "DestroyRenderPass"), RenderPass
{
    mixin(atomicRcCode);

    this(VkRenderPass vkObj, VulkanDevice dev) {
        super(vkObj, dev);
    }

    override @property Device device() {
        return dev;
    }
}

class VulkanFramebuffer : VulkanDevObj!(VkFramebuffer, "DestroyFramebuffer"), Framebuffer
{
    mixin(atomicRcCode);

    this(VkFramebuffer vkObj, VulkanDevice dev, ImageView[] views) {
        super(vkObj, dev);
        _views = views;
        retainArr(_views);
    }

    override void dispose() {
        releaseArr(_views);
        _views = [];
        super.dispose();
    }

    override @property Device device() {
        return dev;
    }

    ImageView[] _views;
}
