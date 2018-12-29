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
    import gfx.graal.device : Device;
    import gfx.graal.queue : Queue;

    private Rc!Device _device;
    private Queue[] _graphicsQueues;
    private Queue _presentQueue;

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
    }

    override void dispose()
    {
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
}
