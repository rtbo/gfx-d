module gfx.vulkan.pipeline;

package:

import gfx.bindings.vulkan;

import gfx.core.rc;
import gfx.graal.pipeline;
import gfx.vulkan.device;

class VulkanShaderModule : VulkanDevObj!(VkShaderModule, "destroyShaderModule"), ShaderModule
{
    mixin(atomicRcCode);
    this(VkShaderModule vk, VulkanDevice dev, string entryPoint)
    {
        super(vk, dev);
        _entryPoint = entryPoint;
    }

    override @property string entryPoint() {
        return _entryPoint;
    }

    private string _entryPoint;
}

class VulkanPipelineLayout : VulkanDevObj!(VkPipelineLayout, "destroyPipelineLayout"), PipelineLayout
{
    mixin(atomicRcCode);
    this(VkPipelineLayout vk, VulkanDevice dev)
    {
        super(vk, dev);
    }
}

class VulkanPipeline : VulkanDevObj!(VkPipeline, "destroyPipeline"), Pipeline
{
    mixin(atomicRcCode);
    this(VkPipeline vk, VulkanDevice dev, PipelineLayout pl)
    {
        super(vk, dev);
        this.pl = pl;
    }

    override void dispose() {
        pl.unload();
        super.dispose();
    }

    private Rc!PipelineLayout pl;
}
