module gfx.gl3.device;

package:

import gfx.graal.cmd : CommandPool;
import gfx.graal.device : Device;
import gfx.graal.sync : Fence, Semaphore;

class GlDevice : Device
{
    import core.time :              Duration;
    import gfx.core.rc :            atomicRcCode, Rc;
    import gfx.gl3 :                GlInstance, GlPhysicalDevice, GlShare;
    import gfx.gl3.queue :          GlQueue;
    import gfx.graal :              Instance;
    import gfx.graal.buffer :       Buffer, BufferUsage;
    import gfx.graal.device :       MappedMemorySet;
    import gfx.graal.format :       Format;
    import gfx.graal.image :        Image, ImageInfo, ImageUsage, ImageView,
                                    Sampler, SamplerInfo;
    import gfx.graal.memory :       DeviceMemory, MemoryProperties;
    import gfx.graal.presentation : CompositeAlpha, PresentMode, Surface,
                                    Swapchain;
    import gfx.graal.queue :        Queue;
    import gfx.graal.renderpass :   AttachmentDescription, Framebuffer,
                                    RenderPass, SubpassDependency,
                                    SubpassDescription;
    import gfx.graal.pipeline :     CopyDescritporSet, DescriptorSet,
                                    DescriptorSetLayout, DescriptorPool,
                                    DescriptorPoolSize, Pipeline, PipelineInfo,
                                    PipelineLayout, PipelineLayoutBinding,
                                    PushConstantRange, ShaderModule,
                                    WriteDescriptorSet;
    import std.typecons : Flag;

    mixin(atomicRcCode);

    private GlPhysicalDevice _phd;
    private Rc!Instance _inst;
    private Rc!GlShare _share;
    private MemoryProperties _memProps;
    private GlQueue _queue;


    this (GlPhysicalDevice phd, GlInstance inst) {
        _phd = phd;
        _inst = inst;
        _share = inst.share;
        _memProps = phd.memoryProperties;
        _queue = new GlQueue(_share, this, 0);
    }

    override void dispose() {
        _queue.dispose();
        _share.unload();
        _inst.unload();
    }

    override GlPhysicalDevice physicalDevice() {
        return _phd;
    }

    override Instance instance() {
        return _inst;
    }

    override void waitIdle() {}

    override Queue getQueue(uint queueFamilyIndex, uint queueIndex) {
        return _queue;
    }

    CommandPool createCommandPool(uint queueFamilyIndex) {
        import gfx.gl3.queue : GlCommandPool;
        return new GlCommandPool(_queue);
    }

    DeviceMemory allocateMemory(uint memPropIndex, size_t size) {
        import gfx.gl3.resource : GlDeviceMemory;
        return new GlDeviceMemory(this, memPropIndex, _memProps.types[memPropIndex].props, size);
    }

    void flushMappedMemory(MappedMemorySet set) {}
    void invalidateMappedMemory(MappedMemorySet set) {}

    Buffer createBuffer(BufferUsage usage, size_t size) {
        import gfx.gl3.resource : GlBuffer;
        return new GlBuffer(this, _share, usage, size);
    }

    Image createImage(in ImageInfo info) {
        import gfx.gl3.resource : GlImage;
        return new GlImage(this, _share, info);
    }

    Sampler createSampler(in SamplerInfo info) {
        import gfx.gl3.resource : GlSampler;
        return new GlSampler(this, _share, info);
    }

    Semaphore createSemaphore() {
        return new GlSemaphore(this);
    }

    Fence createFence(Flag!"signaled" signaled) {
        return new GlFence(this, signaled);
    }

    void resetFences(Fence[] fences) {}
    void waitForFences(Fence[] fences, Flag!"waitAll" waitAll, Duration timeout) {}

    Swapchain createSwapchain(Surface surface, PresentMode pm, uint numImages,
                              Format format, uint[2] size, ImageUsage usage,
                              CompositeAlpha alpha, Swapchain former=null) {
        import gfx.gl3.swapchain : GlSwapchain;
        return new GlSwapchain(this, _share, surface, pm, numImages, format, size, usage, alpha, former);
    }

    RenderPass createRenderPass(in AttachmentDescription[] attachments,
                                in SubpassDescription[] subpasses,
                                in SubpassDependency[] dependencies) {
        import gfx.gl3.pipeline : GlRenderPass;
        return new GlRenderPass(this, attachments, subpasses, dependencies);
    }

    Framebuffer createFramebuffer(RenderPass rp, ImageView[] attachments,
                                  uint width, uint height, uint layers) {
        import gfx.gl3.pipeline : GlFramebuffer, GlRenderPass;
        import gfx.gl3.resource : GlImageView;
        import std.algorithm : map;
        import std.array : array;

        return new GlFramebuffer(_share, cast(GlRenderPass)rp,
            attachments.map!(iv => cast(GlImageView)iv).array,
            width, height, layers);
    }

    ShaderModule createShaderModule(const(uint)[] code, string entryPoint) {
        import gfx.gl3.pipeline : GlShaderModule;
        import std.exception : enforce;

        enforce(entryPoint == "main");
        return new GlShaderModule(this, _share, code);
    }

    DescriptorSetLayout createDescriptorSetLayout(in PipelineLayoutBinding[] bindings) {
        import gfx.gl3.pipeline : GlDescriptorSetLayout;
        return new GlDescriptorSetLayout(this, bindings);
    }

    PipelineLayout createPipelineLayout(DescriptorSetLayout[] layouts, in PushConstantRange[] ranges) {
        import gfx.gl3.pipeline : GlPipelineLayout;
        return new GlPipelineLayout(this, layouts, ranges);
    }

    DescriptorPool createDescriptorPool(in uint maxSets, in DescriptorPoolSize[] sizes) {
        import gfx.gl3.pipeline : GlDescriptorPool;
        return new GlDescriptorPool(this, maxSets, sizes);
    }

    void updateDescriptorSets(WriteDescriptorSet[] writeOps, CopyDescritporSet[] copyOps) {
        import gfx.gl3.pipeline : GlDescriptorSet;
        foreach (wo; writeOps) {
            auto glSet = cast(GlDescriptorSet)wo.dstSet;
            glSet.write(wo.dstBinding, wo.dstArrayElem, wo.write);
        }
    }

    Pipeline[] createPipelines(PipelineInfo[] infos) {
        import gfx.gl3.pipeline : GlPipeline;
        import std.algorithm : map;
        import std.array : array;
        return infos.map!(pi => cast(Pipeline)new GlPipeline(this, _share, pi)).array;
    }
}

private final class GlSemaphore : Semaphore {
    import gfx.core.rc : atomicRcCode, Rc;
    mixin(atomicRcCode);

    private Rc!GlDevice _dev;

    this(GlDevice dev) {
        _dev = dev;
    }
    override void dispose() {
        _dev.unload();
    }
    override @property GlDevice device() {
        return _dev;
    }
}

private final class GlFence : Fence {
    import core.time : Duration;
    import gfx.core.rc : atomicRcCode, Rc;
    mixin(atomicRcCode);

    private Rc!GlDevice _dev;
    private bool _signaled;

    this(GlDevice dev, bool signaled) {
        _dev = dev;
        _signaled = signaled;
    }
    override void dispose() {
        _dev.unload();
    }
    override @property GlDevice device() {
        return _dev;
    }
    override @property bool signaled() { return _signaled; }
    override void reset() {}
    override void wait(Duration timeout) {}
}

