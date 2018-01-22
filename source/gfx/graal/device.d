module gfx.graal.device;

import core.time : Duration;

import gfx.core.rc;
import gfx.graal.buffer;
import gfx.graal.cmd;
import gfx.graal.format;
import gfx.graal.image;
import gfx.graal.memory;
import gfx.graal.pipeline;
import gfx.graal.presentation;
import gfx.graal.queue;
import gfx.graal.renderpass;
import gfx.graal.sync;

import std.typecons : Flag;

struct DeviceFeatures {
    bool presentation;
}

struct DeviceLimits {
    ShaderLanguage supportedShaderLanguages;
}

enum DeviceType {
    other,
    integratedGpu,
    discreteGpu,
    virtualGpu,
    cpu
}

/// A request for a queue family and each queue to be created within that family.
/// The amount of queue to be created is given by priorities.length.
/// Priorities represent the relative priority to be given to each queue (from 0 to 1)
struct QueueRequest
{
    uint familyIndex;
    float[] priorities;
}

/// Represent a physical device. This interface is meant to describe a graphics
/// device and open a logical device out of it.
interface PhysicalDevice : AtomicRefCounted
{
    @property uint apiVersion();

    @property uint driverVersion();

    @property uint vendorId();

    @property uint deviceId();

    @property string name();

    @property DeviceType type();
    final @property bool softwareRendering() {
        return type == DeviceType.cpu;
    }

    @property DeviceFeatures features();

    @property DeviceLimits limits();

    @property MemoryProperties memoryProperties();

    @property QueueFamily[] queueFamilies();

    FormatProperties formatProperties(in Format format);

    bool supportsSurface(uint queueFamilyIndex, Surface surface);
    SurfaceCaps surfaceCaps(Surface surface);
    Format[] surfaceFormats(Surface surface);
    PresentMode[] surfacePresentModes(Surface surface);

    /// Open a logical device with the specified queues.
    /// Returns: null if it can't meet all requested queues, the opened device otherwise.
    Device open(in QueueRequest[] queues)
    in {
        assert(queues.isConsistentWith(queueFamilies));
    }
}

/// Checks that the requests are consistent with families
private bool isConsistentWith(in QueueRequest[] requests, in QueueFamily[] families)
{
    // TODO
    return true;
}

struct MappedMemorySet
{
    package(gfx) struct MM {
        DeviceMemory dm;
        size_t offset;
        size_t size;
    }

    package(gfx) void addMM(MM mm) {
        (cast(RcHack!DeviceMemory)mm.dm).retain();
        mms ~= mm;
    }


    package(gfx) MM[] mms;

    this(this) {
        import std.algorithm : each;
        mms.each!(m => (cast(RcHack!DeviceMemory)m.dm).retain());
    }

    ~this() {
        import std.algorithm : each;
        mms.each!(m => (cast(RcHack!DeviceMemory)m.dm).release());
    }
}

/// Handle to a logical device
interface Device : AtomicRefCounted
{
    /// Wait that device finishes all operations in progress
    void waitIdle();

    Queue getQueue(uint queueFamilyIndex, uint queueIndex);

    CommandPool createCommandPool(uint queueFamilyIndex);

    DeviceMemory allocateMemory(uint memPropIndex, size_t size);
    void flushMappedMemory(MappedMemorySet set);
    void invalidateMappedMemory(MappedMemorySet set);

    Buffer createBuffer(BufferUsage usage, size_t size);

    Image createImage(ImageType type, ImageDims dims, Format format,
                      ImageUsage usage, uint samples, uint levels=1);

    Semaphore createSemaphore();
    Fence createFence(Flag!"signaled" signaled);
    void resetFences(Fence[] fences);
    void waitForFances(Fence[] fences, Flag!"waitAll" waitAll, Duration timeout);

    Swapchain createSwapchain(Surface surface, PresentMode pm, uint numImages,
                              Format format, uint[2] size, ImageUsage usage,
                              CompositeAlpha alpha, Swapchain former=null);

    RenderPass createRenderPass(in AttachmentDescription[] attachments,
                                in SubpassDescription[] subpasses,
                                in SubpassDependency[] dependencies);

    Framebuffer createFramebuffer(RenderPass rp, ImageView[] attachments,
                                  uint width, uint height, uint layers);

    ShaderModule createShaderModule(ShaderLanguage language, string code, string entryPoint);

    PipelineLayout createPipelineLayout();

    Pipeline[] createPipelines(PipelineInfo[] infos);
}
