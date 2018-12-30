/// High level routines to choose and open a device
module gfx.hl.device;

import gfx.core.rc : AtomicRefCounted, Rc;
import gfx.graal : Instance;
import gfx.graal.device : PhysicalDevice;
import gfx.graal.format : Format;
import gfx.graal.presentation : Surface;
import std.typecons : Flag, Yes;

/// Find a device suitable for both hardware accelerated graphics and
/// presentation.
/// A physical device that has the same queue for graphics and presentation will
/// be favored.
/// A physical device that is missing one of graphics or presentation capability
/// will be discarded.
/// A device that only supports software rendering will be discarded.
/// A surface is necessary to check the presentation capability of a queue. It
/// can be any surface, and the operation is not to be repeated for other
/// surfaces that may created afterwards.
/// Params:
///     instance        = Instance to fetch the devices from
///     surface         = A valid surface
///     graphicsQueue   = Receive the graphics queue family index of the
///                       returned device.
///     presentQueue    = Receive the present queue family index of the returned
///                       device.
/// Returns: A physical device suitable for both hardware accelerated graphics
/// and presentation.
PhysicalDevice findGraphicsDevice(Instance instance, Surface surface,
        out uint graphicsQueue, out uint presentQueue)
{
    import std.algorithm : filter, map, sort;
    import std.array : array;

    static struct DeviceScore {
        PhysicalDevice dev;
        int score;
        uint graphicsQueue;
        uint presentQueue;
    }

    auto dss = instance.devices
        .map!((PhysicalDevice dev) {
            DeviceScore ds = { dev: dev };
            ds.score = graphicsDeviceScore(dev, surface, graphicsQueue, presentQueue);
            return ds;
        })
        .filter!(ds => ds.score > 0 && ds.graphicsQueue != uint.max && ds.presentQueue != uint.max)
        .array;

    if (!dss.length)
        return null;

    dss.sort!"a.score > b.score";

    // Hardware rendering get better score, so only the first is checked.
    if (dss[0].dev.softwareRendering)
        return null;

    graphicsQueue = dss[0].graphicsQueue;
    presentQueue = dss[0].presentQueue;
    return dss[0].dev;
}

/// Get the compatibility score of a device for graphics and presentation
/// operations. Call this function on all available devices to choose the right
/// one in the common scenario of presenting graphics to a surface.
/// This also gives the queue indices for graphics and presentation
/// (will often be the same one). These indices will be `uint.max` if graphics
/// or presentation respectively is not supported.
int graphicsDeviceScore(PhysicalDevice dev, Surface surface,
        out uint graphicsQueue, out uint presentQueue)
{
    import gfx.graal.queue : QueueCap;

    int score;

    static struct Aspect {
        int score;
        uint queueIndex = uint.max;
    }

    Aspect graphicsAspect;
    Aspect presentAspect;

    foreach (uint i, qf; dev.queueFamilies) {
        const graphics = qf.cap & QueueCap.graphics;
        const present = dev.supportsSurface(i, surface);

        int qs = graphics || present ? 1 : 0;

        // if a queue has both graphics and present capabilities, choose it.
        if (graphics && present) {
            qs *= 10;
        }

        qs *= qf.count;

        if (qs > score) {
            score = qs;
            if (graphics)
                graphicsAspect = Aspect(qs, i);
            if (present)
                presentAspect = Aspect(qs, i);
        }
        else if (graphics && graphicsAspect.queueIndex == uint.max) {
            graphicsAspect = Aspect(qs, i);
        }
        else if (present && presentAspect.queueIndex == uint.max) {
            presentAspect = Aspect(qs, i);
        }
    }

    if (!dev.softwareRendering) {
        score *= 100;
    }

    graphicsQueue = graphicsAspect.queueIndex;
    presentQueue = presentAspect.queueIndex;

    return score;
}

/// Opening options for GraphicsDevice
struct GraphicsDeviceOptions
{
    /// The length of queuePriorities specifies the number parallel queues to
    /// be allocated. The value of each specifies the relative
    /// priority of each from 0 (lowest priority) to 1 (highest priority).
    /// Device may give more processing time to queues that have higher priority.
    /// If the device does not support the desired amount of queues, it will
    /// be open with priorities specified from the beginning of queuePriorities.
    /// By default, one graphics queue will be allocated with maximum priority.
    float[] queuePriorities;
}

/// Default options for opening graphics device
GraphicsDeviceOptions defaultOpts()
{
    return GraphicsDeviceOptions([ 1f ]);
}

/// Open a graphics device with the options provided.
GraphicsDevice openGraphicsDevice(Instance instance, Surface surf,
        GraphicsDeviceOptions opts = defaultOpts())
{
    import std.exception : enforce;

    uint graphicsQueueInd=void;
    uint presentQueueInd=void;
    auto phd = enforce(
        findGraphicsDevice(instance, surf, graphicsQueueInd, presentQueueInd),
        "Could not find any graphics device!"
    );

    return new GraphicsDevice(phd, graphicsQueueInd, presentQueueInd, opts);
}

/// GraphicsDevice is a high level entity on top of Graal.
/// It has purpose of graphics rendering on one or more Surfaces.
/// GraphicsDevice distinguishes between two types of queues : queues for graphics
/// rendering and queues for presentation. There can be one or more queues for
/// graphics rendering and one queue for presentation, which may be common with
/// a graphics queue.
final class GraphicsDevice : AtomicRefCounted
{
    import gfx.graal.buffer : Buffer, BufferUsage;
    import gfx.graal.cmd : CommandBuffer, CommandPool;
    import gfx.graal.device : Device;
    import gfx.graal.format : FormatFeatures;
    import gfx.graal.image : Image, ImageInfo, ImageTiling;
    import gfx.graal.memory : MemProps, MemoryRequirements;
    import gfx.graal.queue : Queue;
    import std.traits : isArray;

    private Rc!Device _device;
    private Queue[] _graphicsQueues;
    private Queue _presentQueue;
    private Rc!CommandPool _graphicsCmdPool;

    /// Opens a graphics device.
    /// Params:
    ///     phd                 = PhysicalDevice to open the device on.
    ///     graphicsQueueInd    = The index of queue family for graphics
    ///                           rendering.
    ///     presentQueueInd     = The index of queue family for presentation.
    ///                           It may be the same than graphicsQueueInd.
    ///     opts                = Options for graphics device opening.
    this (PhysicalDevice phd, uint graphicsQueueInd, uint presentQueueInd,
            GraphicsDeviceOptions opts = defaultOpts())
    {
        import gfx.graal.device : QueueRequest;
        import std.exception : enforce;

        auto qf = phd.queueFamilies[graphicsQueueInd];

        if (!opts.queuePriorities.length)
            opts.queuePriorities = [ 1f ];
        if (opts.queuePriorities.length > qf.count)
            opts.queuePriorities = opts.queuePriorities[0 .. qf.count];

        QueueRequest[] qrs = [ QueueRequest(graphicsQueueInd, opts.queuePriorities) ];
        if (graphicsQueueInd != presentQueueInd) {
            qrs ~= QueueRequest(presentQueueInd, [ 1f ]);
        }

        _device = enforce(phd.open(qrs), "Could not open graphics device");

        _graphicsQueues = new Queue[opts.queuePriorities.length];
        foreach (i; 0 .. opts.queuePriorities.length) {
            _graphicsQueues[i] = _device.getQueue(graphicsQueueInd, cast(uint)i);
        }
        _presentQueue = _device.getQueue(presentQueueInd, 0);

        _graphicsCmdPool = _device.createCommandPool(graphicsQueueInd);
    }

    override void dispose()
    {
        _graphicsCmdPool.unload();
        _device.unload();
    }

    /// Get the PhysicalDevice
    @property PhysicalDevice physicalDevice()
    {
        return _device.physicalDevice;
    }

    /// Get the Graal device of this GraphicsDevice
    @property Device device()
    {
        return _device.obj;
    }

    /// Unknown calls are forwarded to device
    alias device this;

    /// Graphics queues
    @property Queue[] graphicsQueues()
    {
        return _graphicsQueues;
    }

    /// Get a graphics queue
    Queue graphicsQueue(in size_t index=0)
    in (index < _graphicsQueues.length)
    {
        return _graphicsQueues[index];
    }

    /// Present queue
    @property Queue presentQueue()
    {
        return _presentQueue;
    }

    /// CommandPool allocated for execution in a  graphics queue
    @property CommandPool graphicsCmdPool()
    {
        return _graphicsCmdPool;
    }

    /// Find a format supported by the device for the given tiling and features
    Format findSupportedFormat(in Format[] candidates, in ImageTiling tiling,
                               in FormatFeatures features)
    {
        foreach (f; candidates) {
            const props = physicalDevice.formatProperties(f);
            if (tiling == ImageTiling.optimal &&
                    (props.optimalTiling & features) == features) {
                return f;
            }
            if (tiling == ImageTiling.linear &&
                    (props.linearTiling & features) == features) {
                return f;
            }
        }
        throw new Exception("could not find supported format");
    }

    /// Find a supported depth format
    Format findDepthFormat()
    {
        return findSupportedFormat(
            [
                Format.d32_sFloat, Format.d32s8_sFloat, Format.d24s8_uNorm,
                Format.d16_uNorm, Format.d16s8_uNorm
            ],
            ImageTiling.optimal, FormatFeatures.depthStencilAttachment
        );
    }

    /// Return the index of a memory type supporting all of props,
    /// or uint.max if none was found.
    uint findMemType(MemoryRequirements mr, MemProps props)
    {
        const devMemProps = physicalDevice.memoryProperties;
        foreach (i, mt; devMemProps.types) {
            if ((mr.memTypeMask & (1 << i)) != 0 && (mt.props & props) == props) {
                return cast(uint)i;
            }
        }
        return uint.max;
    }

    /// Create a buffer for usage, bind memory of dataSize with memProps
    /// Return null if no memory type can be found
    Buffer createBuffer(size_t dataSize, BufferUsage usage, MemProps props)
    {
        import gfx.core.rc : rc;

        auto buf = device.createBuffer( usage, dataSize ).rc;

        const mr = buf.memoryRequirements;
        const memTypeInd = findMemType(mr, props);
        if (memTypeInd == uint.max) return null;

        auto mem = device.allocateMemory(memTypeInd, mr.size).rc;
        buf.bindMemory(mem, 0);

        return buf.giveAway();
    }

    /// Create a buffer, binds memory to it, and leave content undefined
    /// The buffer will be host visible and host coherent such as content
    /// can be updated without staging buffer
    Buffer createDynamicBuffer(size_t dataSize, BufferUsage usage)
    {
        return createBuffer(dataSize, usage, MemProps.hostVisible | MemProps.hostCoherent);
    }

    /// Create a buffer, and bind it with memory filled with data.
    /// The bound memory will be deviceLocal, without guarantee to be host visible.
    Buffer createStaticBuffer(const(void)[] data, BufferUsage usage)
    {
        import gfx.core.rc : rc;
        import gfx.graal.device : DeviceType;
        import std.exception : enforce;

        const dataSize = data.length;

        // On embedded gpus, device local memory is often also host visible.
        // Attempting to create one that way.
        if (physicalDevice.type != DeviceType.discreteGpu) {
            auto buf = createBuffer(
                dataSize, usage,
                MemProps.hostVisible | MemProps.hostCoherent | MemProps.deviceLocal
            ).rc;
            if (buf) {
                auto mm = buf.boundMemory.map(0, dataSize);
                mm[] = data;
                return buf.giveAway();
            }
        }

        // did not happen :-(
        // will go the usual way: staging buffer then device local buffer

        // create staging buffer
        auto stagingBuf = enforce(createBuffer(
            dataSize, BufferUsage.transferSrc, MemProps.hostVisible | MemProps.hostCoherent
        )).rc;

        // populate data
        {
            auto mm = stagingBuf.boundMemory.map(0, dataSize);
            mm[] = data;
        }

        // create actual buffer
        auto buf = enforce(createBuffer(
            dataSize, usage | BufferUsage.transferDst, MemProps.deviceLocal
        )).rc;

        auto b = autoCmdBuf().rc;

        // copy from staging buffer
        copyBuffer(stagingBuf, buf, dataSize, b.cmdBuf);

        // return data
        return buf.giveAway();
    }

    /// ditto
    Buffer createStaticBuffer(T)(const(T)[] data, BufferUsage usage)
    if (!is(T == void))
    {
        return createStaticBuffer(untypeSlice(data), usage);
    }

    /// ditto
    Buffer createStaticBuffer(T)(in T data, BufferUsage usage)
    if (!isArray!T)
    {
        const start = cast(const(void)*)&data;
        return createStaticBuffer(start[0 .. data.sizeof], usage);
    }

    /// Allocate memory for the image and bind it to it.
    bool bindImageMemory(Image img, MemProps props=MemProps.deviceLocal)
    {
        import gfx.core.rc : rc;

        const mr = img.memoryRequirements;
        const memTypeInd = findMemType(mr, props);
        if (memTypeInd == uint.max) return false;

        auto mem = device.allocateMemory(memTypeInd, mr.size).rc;
        img.bindMemory(mem, 0);
        return true;
    }

    /// Create an image to be used as texture.
    Image createTextureImage(const(void)[] data, in ImageInfo info)
    {
        import gfx.core.rc : rc;
        import gfx.graal.cmd : Access, ImageMemoryBarrier, PipelineStage,
                               queueFamilyIgnored;
        import gfx.graal.image : ImageAspect, ImageLayout,
                                 ImageSubresourceRange, ImageUsage;
        import gfx.graal.types : trans;
        import std.exception : enforce;

        const FormatFeatures requirement = FormatFeatures.sampledImage;
        const formatProps = physicalDevice.formatProperties(info.format);
        enforce( (formatProps.optimalTiling & requirement) == requirement );

        // create staging buffer
        auto stagingBuf = enforce(createBuffer(
            data.length, BufferUsage.transferSrc, MemProps.hostVisible | MemProps.hostCoherent
        )).rc;

        // populate data to buffer
        {
            auto mm = stagingBuf.boundMemory.map(0, data.length);
            mm[] = data;
        }

        // create an image
        auto img = enforce(device.createImage(
            info.withUsage(info.usage | ImageUsage.sampled | ImageUsage.transferDst)
        )).rc;

        // allocate memory image
        if (!bindImageMemory(img)) return null;

        {
            auto b = autoCmdBuf().rc;

            b.cmdBuf.pipelineBarrier(
                trans(PipelineStage.topOfPipe, PipelineStage.transfer), [], [
                    ImageMemoryBarrier(
                        trans(Access.none, Access.transferWrite),
                        trans(ImageLayout.undefined, ImageLayout.transferDstOptimal),
                        trans(queueFamilyIgnored, queueFamilyIgnored),
                        img, ImageSubresourceRange(ImageAspect.color)
                    )
                ]
            );
            copyBufferToImage(stagingBuf, img, b.cmdBuf);
        }

        return img.giveAway();
    }

    /// Create an image for depth attachment usage
    Image createDepthImage(uint width, uint height)
    {
        import gfx.core.rc : rc;
        import gfx.graal.image : ImageUsage;
        import std.exception : enforce;

        // find the format of the image
        const f = findDepthFormat();

        // create an image
        auto img = enforce(device.createImage(
            ImageInfo.d2(width, height)
                    .withFormat(f)
                    .withUsage(ImageUsage.depthStencilAttachment)
        )).rc;

        // allocate memory image
        if (!bindImageMemory(img)) return null;

        return img.giveAway();
    }

    /// Create an image for stencil attachment usage
    Image createStencilImage(uint width, uint height)
    {
        import gfx.core.rc : rc;
        import gfx.graal.image : ImageUsage;
        import std.exception : enforce;

        // assume s8_uInt is supported
        const f = Format.s8_uInt;

        // create an image
        auto img = enforce(device.createImage(
            ImageInfo.d2(width, height)
                    .withFormat(f)
                    .withUsage(ImageUsage.depthStencilAttachment)
        )).rc;

        // allocate memory image
        if (!bindImageMemory(img)) return null;

        return img.giveAway();
    }

    /// copy the content of one buffer to another
    /// srcBuf and dstBuf must support transferSrc and transferDst respectively.
    void copyBuffer(Buffer srcBuf, Buffer dstBuf, size_t size, CommandBuffer cmdBuf)
    {
        import gfx.graal.cmd : CopyRegion;
        import gfx.graal.types : trans;

        cmdBuf.copyBuffer(
            trans(srcBuf, dstBuf), [ CopyRegion(trans!size_t(0, 0), size) ]
        );
    }

    /// copy the content of one buffer to an image.
    /// the image layout must be transferDstOptimal buffer the call
    void copyBufferToImage(Buffer srcBuf, Image dstImg, CommandBuffer cmdBuf)
    {
        import gfx.graal.cmd : BufferImageCopy;
        import gfx.graal.image : ImageLayout;

        const dims = dstImg.info.dims;

        BufferImageCopy region;
        region.extent = [dims.width, dims.height, dims.depth];
        const regions = (&region)[0 .. 1];
        cmdBuf.copyBufferToImage(srcBuf, dstImg, ImageLayout.transferDstOptimal, regions);
    }

    /// Get a RAII command buffer that is meant to be trashed after usage.
    /// Returned buffer is ready to record data, and execute commands on the graphics queue
    /// at end of scope.
    AutoCmdBuf autoCmdBuf(CommandPool pool=null, size_t graphicsQueueIndex=0)
    {
        import std.exception : enforce;

        Rc!CommandPool cmdPool = pool ? pool : _graphicsCmdPool;
        return new AutoCmdBuf(cmdPool, graphicsQueues[graphicsQueueIndex]);
    }
}

/// Utility command buffer for a one time submission that automatically submit
/// when disposed.
/// Generally used for transfer operations.
class AutoCmdBuf : AtomicRefCounted
{
    import gfx.graal.cmd : CommandBuffer, CommandPool;
    import gfx.graal.device : Device;
    import gfx.graal.queue : Queue;

    private Rc!CommandPool pool;
    private Queue queue;
    private Rc!Device device; // device holds queue,
    CommandBuffer cmdBuf;

    this(CommandPool pool, Queue queue)
    {
        import std.typecons : No;

        this.pool = pool;
        this.queue = queue;
        this.device = queue.device;
        this.cmdBuf = this.pool.allocate(1)[0];
        this.cmdBuf.begin(No.persistent);
    }

    override void dispose()
    {
        import gfx.graal.queue : Submission;

        this.cmdBuf.end();
        this.queue.submit([
            Submission([], [], [ this.cmdBuf ])
        ], null);
        this.queue.waitIdle();
        this.pool.free([ this.cmdBuf ]);
        this.pool.unload();
        this.device.unload();
    }
}
