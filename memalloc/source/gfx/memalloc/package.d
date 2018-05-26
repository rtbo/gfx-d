module gfx.memalloc;

import gfx.core.rc : AtomicRefCounted;
import gfx.graal.device : Device;
import gfx.graal.memory : DeviceMemory, MemoryProperties, MemoryRequirements;

/// Option flags for creating an Allocator
enum AllocatorFlags
{
    /// Default behavior, no flag set
    none = 0,
    /// If set, each allocation will have a dedicated DeviceMemory
    /// Even if not set, some backends (i.e. OpenGL) require a dedicated DeviceMemory
    /// per allocation and will do so regardless of this flag.
    dedicatedOnly = 1,
    /// The default behavior when an allocation cannot be granted is to throw
    /// an exception. Set this flag if you prefer the allocator to return null.
    returnNull = 2,
}

/// Option to define allocation behavior for each heap of the device
struct HeapOptions
{
    /// How many bytes may be use on the heap.
    /// set to 0 to forbid use of a specific heap and to size_t.max to allow entire use
    size_t maxUsage = size_t.max;
    /// Size of a single DeviceMemory on this heap.
    /// set to 0 to use default behavior for this heap
    size_t blockSize = 0;
}

/// Options for the creation of an Allocator
struct AllocatorOptions
{
    /// option flags
    AllocatorFlags flags;
    /// One HeapOption per heap in the device, or empty to use default behavior.
    /// Default behavior is to allow use of entire heap. Default block size is
    /// 256Mb for heaps > 1Gb, and heapSize/8 for smaller ones.
    HeapOptions[] heapOptions;
}

/// Create an Allocator for device and options
Allocator createAllocator(Device device, AllocatorOptions options)
{
    import gfx.graal : Backend;
    if ((options.flags & AllocatorFlags.dedicatedOnly) || device.instance.backend == Backend.gl3) {
        import gfx.memalloc.dedicated : DedicatedAllocator;
        return new DedicatedAllocator(device, options);
    }
    else {
        import gfx.memalloc.pool : PoolAllocator;
        return new PoolAllocator(device, options);
    }
}

/// Memory allocator for a device
abstract class Allocator : AtomicRefCounted
{
    import gfx.core.rc : atomicRcCode, Rc;

    mixin(atomicRcCode);

    package Rc!Device _device;
    package AllocatorOptions _options;
    package MemoryProperties _memProps;

    package this(Device device, AllocatorOptions options)
    {
        _device = device;
        _options = options;
        _memProps = device.physicalDevice.memoryProperties;

        import std.algorithm : all;
        import std.exception : enforce;
        enforce(_memProps.types.all!(mt => mt.heapIndex < _memProps.heaps.length));
    }

    override void dispose() {
        _device.unload();
    }

    /// Device this allocator is bound to.
    final @property Device device() {
        return _device.obj;
    }

    /// Allocate memory for the given requirements
    abstract Allocation allocate(MemoryRequirements requirements);
}


/// Represent a single allocation within a DeviceMemory
final class Allocation : AtomicRefCounted
{
    import gfx.core.rc : atomicRcCode, Rc;

    mixin(atomicRcCode);

    private size_t _offset;
    private size_t _size;
    private Rc!DeviceMemory _mem;
    private Rc!MemReturn _return;
    private Object _returnData;

    package this(size_t offset, size_t size, DeviceMemory mem, MemReturn return_, Object returnData)
    {
        _offset = offset;
        _size = size;
        _mem = mem;
        _return = return_;
        _returnData = returnData;
    }

    override void dispose()
    {
        _return.free(_returnData);
        _mem.unload();
        _return.unload();
    }
}

package:

/// A pool of memory associated to one memory type
interface MemReturn : AtomicRefCounted
{
    void free(Object returnData);
}
