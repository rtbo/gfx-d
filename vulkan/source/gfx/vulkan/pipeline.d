module gfx.vulkan.pipeline;

package:

import gfx.bindings.vulkan;

import gfx.core.rc;
import gfx.graal.pipeline;
import gfx.vulkan;
import gfx.vulkan.device;

class VulkanShaderModule : VulkanDevObj!(VkShaderModule, "DestroyShaderModule"), ShaderModule
{
    mixin(atomicRcCode);
    this(VkShaderModule vkObj, VulkanDevice dev, string entryPoint)
    {
        super(vkObj, dev);
        _entryPoint = entryPoint;
    }

    override @property Device device() {
        return dev;
    }

    override @property string entryPoint() {
        return _entryPoint;
    }

    private string _entryPoint;
}

class VulkanPipelineLayout : VulkanDevObj!(VkPipelineLayout, "DestroyPipelineLayout"), PipelineLayout
{
    mixin(atomicRcCode);

    this(VkPipelineLayout vkObj, VulkanDevice dev,
            DescriptorSetLayout[] descriptorLayouts,
            in PushConstantRange[] pushConstantRanges)
    {
        super(vkObj, dev);
        _descriptorLayouts = descriptorLayouts;
        _pushConstantRanges = pushConstantRanges;
        retainArr(_descriptorLayouts);
    }

    override void dispose()
    {
        releaseArr(_descriptorLayouts);
        super.dispose();
    }

    override @property Device device() {
        return dev;
    }

    override @property DescriptorSetLayout[] descriptorLayouts()
    {
        return _descriptorLayouts;
    }

    override @property const(PushConstantRange)[] pushConstantRanges()
    {
        return _pushConstantRanges;
    }

    private DescriptorSetLayout[] _descriptorLayouts;
    private const(PushConstantRange)[] _pushConstantRanges;
}

class VulkanPipeline : VulkanDevObj!(VkPipeline, "DestroyPipeline"), Pipeline
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

    override @property Device device() {
        return dev;
    }

    private Rc!PipelineLayout pl;
}

class VulkanDescriptorSetLayout : VulkanDevObj!(VkDescriptorSetLayout, "DestroyDescriptorSetLayout"), DescriptorSetLayout
{
    mixin(atomicRcCode);
    this(VkDescriptorSetLayout vkObj, VulkanDevice dev)
    {
        super(vkObj, dev);
    }

    override @property Device device() {
        return dev;
    }
}

class VulkanDescriptorPool : VulkanDevObj!(VkDescriptorPool, "DestroyDescriptorPool"), DescriptorPool
{
    mixin(atomicRcCode);
    this(VkDescriptorPool vkObj, VulkanDevice dev)
    {
        super(vkObj, dev);
    }

    override @property Device device() {
        return dev;
    }

    override DescriptorSet[] allocate(DescriptorSetLayout[] layouts)
    {
        import std.algorithm : map;
        import std.array : array;

        auto vkLayouts = layouts.map!(
            l => enforce(
                cast(VulkanDescriptorSetLayout)l,
                "VulkanDescriptorPool.allocate: Did not supply a Vulkan DescriptorSetLayout"
            ).vkObj
        ).array;

        VkDescriptorSetAllocateInfo ai;
        ai.sType = VK_STRUCTURE_TYPE_DESCRIPTOR_SET_ALLOCATE_INFO;
        ai.descriptorPool = vkObj;
        ai.descriptorSetCount = cast(uint)vkLayouts.length;
        ai.pSetLayouts = vkLayouts.ptr;

        auto vkSets = new VkDescriptorSet[vkLayouts.length];
        vulkanEnforce(
            vk.AllocateDescriptorSets(vkDev, &ai, &vkSets[0]),
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
            vk.ResetDescriptorPool(vkDev, vkObj, 0),
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
