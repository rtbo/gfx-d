module gfx.graal.device;

import gfx.core.rc;
import gfx.graal.buffer;
import gfx.graal.format;
import gfx.graal.image;
import gfx.graal.memory;
import gfx.graal.queue;

struct DeviceFeatures {
    bool presentation;
}

struct DeviceLimits {}

enum DeviceType {
    other,
    integratedGpu,
    discreteGpu,
    virtualGpu,
    cpu
}

/// A request for a specific queue and its priority level when opening a device.
struct QueueRequest
{
    uint familyIndex;
    float priority;
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
    @property DeviceFeatures features();
    @property DeviceLimits limits();
    @property MemoryProperties memoryProperties();
    @property QueueFamily[] queueFamilies();
    FormatProperties formatProperties(in Format format);

    bool supportsSurface(uint queueFamilyIndex, Surface surface);

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
    DeviceMemory allocateMemory(uint memPropIndex, size_t size);
    void flushMappedMemory(MappedMemorySet set);
    void invalidateMappedMemory(MappedMemorySet set);

    Buffer createBuffer(BufferUsage usage, size_t size);

    Image createImage(ImageType type, ImageDims dims, Format format,
                      ImageUsage usage, uint samples, uint levels=1);
}
