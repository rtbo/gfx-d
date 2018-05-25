module gfx.memalloc.allocator;

import gfx.core.rc : AtomicRefCounted;
import gfx.graal.device : Device;
import gfx.graal.memory : DeviceMemory;

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
    size_t maxUsage;
    /// Size of a single DeviceMemory on this heap.
    /// set to 0 to use default behavior for this heap
    size_t blockSize;
}

/// Options for the creation of an Allocator
struct AllocatorOptions
{
    /// option flags
    AllocatorFlags flags;
    /// One HeapOption per heap in the device, or empty to use default behavior.
    /// Default behavior is to allow use of entire heap. Default block size is
    /// 256Mb for heaps > 1Gb, and heapSize/8 for smaller ones.
    HeapOptions[] options;
}

/// Create an Allocator for device and options
Allocator createAllocator(Device device, AllocatorOptions options)
{
    import gfx.memalloc.dedicated : DedicatedAllocator;
    return new DedicatedAllocator(device, options);
}

/// Memory allocator for a device
interface Allocator : AtomicRefCounted
{
    /// Device this allocator is bound to.
    @property Device device();

    /// Allocate memory of the given type
    Allocation allocate(uint memTypeIndex, size_t size);
}


/// Represent a single allocation within a DeviceMemory
final class Allocation : AtomicRefCounted
{
    import gfx.core.rc : atomicRcCode, Rc;

    mixin(atomicRcCode);

    private size_t _offset;
    private size_t _size;
    private Rc!DeviceMemory _mem;
    private Rc!Allocator _alloc;

    package this(size_t offset, size_t size, DeviceMemory mem, Allocator alloc)
    {
        _offset = offset;
        _size = size;
        _mem = mem;
        _alloc = alloc;
    }

    override void dispose()
    {
        _mem.unload();
        _alloc.unload();
    }
}


package:

/// A pool of memory associated to one memory type
interface MemoryPool {
    Allocation allocate(size_t size);
}

