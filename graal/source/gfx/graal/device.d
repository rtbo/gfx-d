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
    bool anisotropy;

    static @property DeviceFeatures all() {
        return DeviceFeatures(
            true, true
        );
    }
    static @property DeviceFeatures none() {
        return DeviceFeatures(
            false, false
        );
    }
}

struct DeviceLimits
{
    size_t linearOptimalGranularity=1;
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
interface PhysicalDevice
{
    import gfx.graal : Instance;

    /// The instance this physical device is issued from
    @property Instance instance();
    @property string name();

    @property DeviceType type();
    final @property bool softwareRendering() {
        return type == DeviceType.cpu;
    }

    @property DeviceFeatures features();

    @property DeviceLimits limits();

    @property MemoryProperties memoryProperties();

    /// Get the queue families for the device
    /// See_Also: QueueFamily
    @property QueueFamily[] queueFamilies();

    /// Get the features supported for the given format
    FormatProperties formatProperties(in Format format);

    /// Check whether the given queue family supports presentation on the
    /// give surface.
    bool supportsSurface(uint queueFamilyIndex, Surface surface);

    /// Get the capabilities of surface on this device.
    SurfaceCaps surfaceCaps(Surface surface);

    /// Get the formats supported by the given surface.
    /// Params:
    ///     surface = the Surface to query the formats from
    /// Returns: the formats supported by the surface. `[ Formats.undefined ]`
    ///         can be returned to indicate that any format is supported.
    Format[] surfaceFormats(Surface surface);

    /// Get the present mode supported by the given surface.
    PresentMode[] surfacePresentModes(Surface surface);

    /// Open a logical device with the specified queues.
    /// Returns: null if it can't meet all requested queues, the opened device otherwise.
    Device open(in QueueRequest[] queues, in DeviceFeatures features=DeviceFeatures.all)
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
    package(gfx) static struct MM {
        DeviceMemory dm;
        size_t offset;
        size_t size;
    }

    package(gfx) void addMM(MM mm) {
        mms ~= mm;
    }

    package(gfx) MM[] mms;
}

/// Handle to a logical device
interface Device : IAtomicRefCounted
{
    import gfx.graal : Instance;

    @property PhysicalDevice physicalDevice();
    @property Instance instance();

    /// Wait that device finishes all operations in progress
    void waitIdle();

    Queue getQueue(uint queueFamilyIndex, uint queueIndex);

    CommandPool createCommandPool(uint queueFamilyIndex);

    DeviceMemory allocateMemory(uint memPropIndex, size_t size)
    in {
        assert(size > 0, "cannot allocate memory of null size");
    }
    void flushMappedMemory(MappedMemorySet set);
    void invalidateMappedMemory(MappedMemorySet set);

    Buffer createBuffer(BufferUsage usage, size_t size)
    in {
        assert(size > 0, "cannot create a buffer of null size");
    }

    Image createImage(in ImageInfo info);

    Sampler createSampler(in SamplerInfo info);

    Semaphore createSemaphore();
    Fence createFence(Flag!"signaled" signaled);
    void resetFences(Fence[] fences);
    void waitForFences(Fence[] fences, Flag!"waitAll" waitAll, Duration timeout);

    Swapchain createSwapchain(Surface surface, PresentMode pm, uint numImages,
                              Format format, uint[2] size, ImageUsage usage,
                              CompositeAlpha alpha, Swapchain former=null);

    RenderPass createRenderPass(in AttachmentDescription[] attachments,
                                in SubpassDescription[] subpasses,
                                in SubpassDependency[] dependencies);

    Framebuffer createFramebuffer(RenderPass rp, ImageView[] attachments,
                                  uint width, uint height, uint layers);

    ShaderModule createShaderModule(const(uint)[] spirV, string entryPoint);

    DescriptorSetLayout createDescriptorSetLayout(in PipelineLayoutBinding[] bindings);

    PipelineLayout createPipelineLayout(DescriptorSetLayout[] layouts, in PushConstantRange[] ranges);

    DescriptorPool createDescriptorPool(in uint maxSets, in DescriptorPoolSize[] sizes);

    void updateDescriptorSets(WriteDescriptorSet[] writeOps, CopyDescritporSet[] copyOps);

    Pipeline[] createPipelines(PipelineInfo[] infos);
}
