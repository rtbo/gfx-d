module gfx.vulkan.shader;

package:

import erupted;

import gfx.core.rc;
import gfx.graal.shader;
import gfx.vulkan.device;

class VulkanShaderModule : VulkanDevObj!(VkShaderModule, vkDestroyShaderModule), ShaderModule
{
    mixin(atomicRcCode);
    this(VkShaderModule vk, VulkanDevice dev)
    {
        super(vk, dev);
    }
}
