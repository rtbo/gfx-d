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

class VulkanDescriptorSetLayout : VulkanDevObj!(VkDescriptorSetLayout, "destroyDescriptorSetLayout"), DescriptorSetLayout
{
    mixin(atomicRcCode);
    this(VkDescriptorSetLayout vk, VulkanDevice dev)
    {
        super(vk, dev);
    }
}

class VulkanDescriptorPool : VulkanDevObj!(VkDescriptorPool, "destroyDescriptorPool"), DescriptorPool
{
    mixin(atomicRcCode);
    this(VkDescriptorPool vk, VulkanDevice dev)
    {
        super(vk, dev);
    }

    override DescriptorSet[] allocate(DescriptorSetLayout[] layouts)
    {
        import std.algorithm : map;
        import std.array : array;

        auto vkLayouts = layouts.map!(
            l => enforce(cast(VulkanDescriptorSetLayout)l).vk
        ).array;

        VkDescriptorSetAllocateInfo ai;
        ai.sType = VK_STRUCTURE_TYPE_DESCRIPTOR_SET_ALLOCATE_INFO;
        ai.descriptorPool = vk;
        ai.descriptorSetCount = cast(uint)vkLayouts.length;
        ai.pSetLayouts = vkLayouts.ptr;

        auto vkSets = new VkDescriptorSet[vkLayouts.length];
        vulkanEnforce(
            cmds.allocateDescriptorSets(vkDev, &ai, &vkSets[0]),
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
            cmds.resetDescriptorPool(vkDev, vk, 0),
            "Could not reset Descriptor pool"
        );
        _allocatedSets = [];
    }

    DescriptorSet[] _allocatedSets;
}

class VulkanDescriptorSet : VulkanObj!(VkDescriptorSet), DescriptorSet
{
    this (VkDescriptorSet vk, VulkanDescriptorPool pool)
    {
        super(vk);
        _pool = pool;
    }

    @property DescriptorPool pool() {
        return _pool;
    }

    VulkanDescriptorPool _pool;
}
