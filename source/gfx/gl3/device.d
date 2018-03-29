module gfx.gl3.device;

package:

import gfx.graal.cmd : CommandPool;
import gfx.graal.device : Device;
import gfx.graal.sync : Fence, Semaphore;

class GlDevice : Device
{
    import core.time :              Duration;
    import gfx.core.rc :            atomicRcCode, Rc;
    import gfx.gl3 :                GlPhysicalDevice, GlShare;
    import gfx.gl3.queue :          GlQueue;
    import gfx.graal.buffer :       Buffer, BufferUsage;
    import gfx.graal.device :       MappedMemorySet;
    import gfx.graal.format :       Format;
    import gfx.graal.image :        Image, ImageDims, ImageTiling, ImageType,
                                    ImageView, ImageUsage, Sampler, SamplerInfo;
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

    private Rc!GlShare _share;
    private MemoryProperties _memProps;
    private GlQueue _queue;


    this (GlPhysicalDevice phd, GlShare share) {
        _share = share;
        _memProps = phd.memoryProperties;
        _queue = new GlQueue(_share, this);
    }

    override void dispose() {
        _share.unload();
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
        return new GlDeviceMemory(memPropIndex, _memProps.types[memPropIndex].props, size);
    }

    void flushMappedMemory(MappedMemorySet set) {}
    void invalidateMappedMemory(MappedMemorySet set) {}

    Buffer createBuffer(BufferUsage usage, size_t size) {
        import gfx.gl3.resource : GlBuffer;
        return new GlBuffer(_share, usage, size);
    }

    Image createImage(ImageType type, ImageDims dims, Format format,
                      ImageUsage usage, ImageTiling tiling, uint samples,
                      uint levels=1) {
        import gfx.gl3.resource : GlImage;
        return new GlImage(_share, type, dims, format, usage, tiling, samples, levels);
    }

    Sampler createSampler(in SamplerInfo info) {
        import gfx.gl3.resource : GlSampler;
        return new GlSampler(_share, info);
    }

    Semaphore createSemaphore() {
        return new GlSemaphore;
    }

    Fence createFence(Flag!"signaled" signaled) {
        return new GlFence(signaled);
    }

    void resetFences(Fence[] fences) {}
    void waitForFences(Fence[] fences, Flag!"waitAll" waitAll, Duration timeout) {}

    Swapchain createSwapchain(Surface surface, PresentMode pm, uint numImages,
                              Format format, uint[2] size, ImageUsage usage,
                              CompositeAlpha alpha, Swapchain former=null) {
        import gfx.gl3.swapchain : GlSwapchain;
        return new GlSwapchain(_share, this, surface, pm, numImages, format, size, usage, alpha, former);
    }

    RenderPass createRenderPass(in AttachmentDescription[] attachments,
                                in SubpassDescription[] subpasses,
                                in SubpassDependency[] dependencies) {
        import gfx.gl3.pipeline : GlRenderPass;
        return new GlRenderPass(attachments, subpasses, dependencies);
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
        return new GlShaderModule(_share, code);
    }

    DescriptorSetLayout createDescriptorSetLayout(in PipelineLayoutBinding[] bindings) {
        import gfx.gl3.pipeline : GlDescriptorSetLayout;
        return new GlDescriptorSetLayout(bindings);
    }

    PipelineLayout createPipelineLayout(DescriptorSetLayout[] layouts, PushConstantRange[] ranges) {
        import gfx.gl3.pipeline : GlPipelineLayout;
        return new GlPipelineLayout(layouts, ranges);
    }

    DescriptorPool createDescriptorPool(in uint maxSets, in DescriptorPoolSize[] sizes) {
        import gfx.gl3.pipeline : GlDescriptorPool;
        return new GlDescriptorPool(maxSets, sizes);
    }

    void updateDescriptorSets(WriteDescriptorSet[] writeOps, CopyDescritporSet[] copyOps) {}

    Pipeline[] createPipelines(PipelineInfo[] infos) {
        import gfx.gl3.pipeline : GlPipeline;
        import std.algorithm : map;
        import std.array : array;
        return infos.map!(pi => cast(Pipeline)new GlPipeline(_share, pi)).array;
    }
}

private final class GlSemaphore : Semaphore {
    import gfx.core.rc : atomicRcCode;
    mixin(atomicRcCode);
    this() {}
    override void dispose() {}
}

private final class GlFence : Fence {
    import core.time : Duration;
    import gfx.core.rc : atomicRcCode;
    mixin(atomicRcCode);
    private bool _signaled;
    this(bool signaled) {
        _signaled = signaled;
    }
    override void dispose() {}
    override @property bool signaled() { return _signaled; }
    override void reset() {}
    override void wait(Duration timeout) {}
}

