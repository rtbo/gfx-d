module gfx.vulkan.pipeline;

package:

import gfx.bindings.vulkan;

import gfx.core.rc;
import gfx.graal.pipeline;
import gfx.vulkan;
import gfx.vulkan.device;

class VulkanShaderModule : VulkanDevObj!(VkShaderModule, "destroyShaderModule"), ShaderModule
{
    mixin(atomicRcCode);
    this(VkShaderModule vkObj, VulkanDevice dev, string entryPoint)
    {
        super(vkObj, dev);
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
    this(VkPipelineLayout vkObj, VulkanDevice dev)
    {
        super(vkObj, dev);
    }
}

class VulkanPipeline : VulkanDevObj!(VkPipeline, "destroyPipeline"), Pipeline
{
    mixin(atomicRcCode);
    this(VkPipeline vkObj, VulkanDevice dev, PipelineLayout pl)
    {
        super(vkObj, dev);
        this.pl = pl;
    }

    override void dispose() {
        pl.unload();
        super.dispose();
    }

    private Rc!PipelineLayout pl;
}

class VulkanDescriptorSetLayout : VulkanDevObj!(VkDescriptorSetLayout, "destroyDescriptorSetLayout"), DescriptorSetLayout
{
    mixin(atomicRcCode);
    this(VkDescriptorSetLayout vkObj, VulkanDevice dev)
    {
        super(vkObj, dev);
    }
}

class VulkanDescriptorPool : VulkanDevObj!(VkDescriptorPool, "destroyDescriptorPool"), DescriptorPool
{
    mixin(atomicRcCode);
    this(VkDescriptorPool vkObj, VulkanDevice dev)
    {
        super(vkObj, dev);
    }

    override DescriptorSet[] allocate(DescriptorSetLayout[] layouts)
    {
        import std.algorithm : map;
        import std.array : array;

        auto vkLayouts = layouts.map!(
            l => enforce(cast(VulkanDescriptorSetLayout)l).vkObj
        ).array;

        VkDescriptorSetAllocateInfo ai;
        ai.sType = VK_STRUCTURE_TYPE_DESCRIPTOR_SET_ALLOCATE_INFO;
        ai.descriptorPool = vkObj;
        ai.descriptorSetCount = cast(uint)vkLayouts.length;
        ai.pSetLayouts = vkLayouts.ptr;

        auto vkSets = new VkDescriptorSet[vkLayouts.length];
        vulkanEnforce(
            vk.allocateDescriptorSets(vkDev, &ai, &vkSets[0]),
            "Could not allocate Vulkan descriptor sets"
        );

        auto sets = vkSets.map!(
            vkS => cast(DescriptorSet)new VulkanDescriptorSet(vkS, this)
        ).array;

        _allocatedSets ~= sets;

        return sets;
    }

    override void reset() {
        vulkanEnforce(
            vk.resetDescriptorPool(vkDev, vkObj, 0),
            "Could not reset Descriptor pool"
        );
        _allocatedSets = [];
    }

    DescriptorSet[] _allocatedSets;
}

class VulkanDescriptorSet : VulkanObj!(VkDescriptorSet), DescriptorSet
{
    this (VkDescriptorSet vkObj, VulkanDescriptorPool pool)
    {
        super(vkObj);
        _pool = pool;
    }

    @property DescriptorPool pool() {
        return _pool;
    }

    VulkanDescriptorPool _pool;
}
