/// A memory allocator for Gfx-d
module gfx.memalloc;

import gfx.core.rc :        AtomicRefCounted;
import gfx.graal.device :   Device;
import gfx.graal.memory :   DeviceMemory, MemoryProperties, MemoryRequirements,
                            MemoryType, MemProps;

/// Option flags for creating an Allocator
enum AllocatorFlags
{
    /// Default behavior, no flag set
    none = 0,
    /// If set, each allocation will have a dedicated DeviceMemory
    /// Even if not set, some backends (i.e. OpenGL) require a dedicated DeviceMemory
    /// per allocation and will do so regardless of this flag.
    dedicatedOnly = 1,
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

/// Flags controlling an allocation of memory
enum AllocationFlags {
    /// default behavior, no flags.
    none            = 0,
    /// Set to force the creation of a new DeviceMemory, that will be dedicated for the allocation.
    dedicated       = 1,
    /// Set to prohib the creation of a new DeviceMemory. This forces the use of an existing chunk, and fails if it cannot find one.
    neverAllocate   = 2,
}

/// Describes the usage of a memory allocation
enum MemoryUsage {
    /// No intended usage. The type of memory will not be influenced by the usage.
    unknown,
    /// Memory will be used on device only (MemProps.deviceLocal) and having it mappable
    /// on host is not requested (although it is possible on some devices).
    /// Usage:
    /// $(UL
    ///   $(LI Resources written and read by device, e.g. images used as attachments. )
    ///   $(LI Resources transferred from host once or infrequently and read by device multiple times,
    ///        e.g. textures, vertex bufers, uniforms etc. )
    /// )
    gpuOnly,
    /// Memory will be mappable on host. It usually means CPU (system) memory.
    /// Resources created for this usage may still be accessible to the device,
    /// but access to them can be slower. Guarantees to be MemProps.hostVisible and MemProps.hostCoherent.
    /// Usage:
    /// $(UL $(LI Staging copy of resources used as transfer source.))
    cpuOnly,
    /// Memory that is both mappable on host (guarantees to be MemProps.hostVisible)
    /// and preferably fast to access by GPU. CPU reads may be uncached and very slow.
    /// Usage:
    /// $(UL $(LI Resources written frequently by host (dynamic), read by device.
    /// E.g. textures, vertex buffers, uniform buffers updated every frame or every draw call.))
    cpuToGpu,
    /// Memory mappable on host (guarantees to be MemProps.hostVisible) and cached.
    /// Usage:
    /// $(UL
    ///     $(LI Resources written by device, read by host - results of some computations,
    ///          e.g. screen capture, average scene luminance for HDR tone mapping.)
    ///     $(LI Any resources read or accessed randomly on host, e.g. CPU-side copy of
    ///          vertex buffer used as source of transfer, but also used for collision detection.)
    /// )
    gpuToCpu,
}

/// Structure controlling an allocation of memory
struct AllocationInfo {
    /// Control flags
    AllocationFlags flags;
    /// Intended usage. Will affect preferredBits and requiredBits;
    MemoryUsage usage;
    /// MemProps bits that are optional but are preferred to be present.
    /// Allocation will favor memory types with these bits if available, but may
    /// fallback to other memory types.
    MemProps preferredProps;
    /// MemProps bits that must be set.
    /// Allocation will fail if it can't allocate a memory type satisfies all bits.
    MemProps requiredProps;
    /// mask of memory type indices (0b0101 means indices 0 and 2) that, if not
    /// zero, will constrain MemoryRequirement.memTypeMask
    uint memTypeIndexMask;

    /// Initializes an AllocationInfo with usage
    static @property AllocationInfo forUsage(MemoryUsage usage) {
        AllocationInfo info;
        info.usage = usage;
        return info;
    }
    /// set flags to info
    AllocationInfo withFlags(AllocationFlags flags) {
        this.flags = flags;
        return this;
    }
    /// set preferredProps to info
    AllocationInfo withPreferredProps(MemProps props) {
        this.preferredProps = props;
        return this;
    }
    /// set requiredProps to info
    AllocationInfo withRequiredBits(MemProps props) {
        this.requiredProps = props;
        return this;
    }
    /// set type index mask to info
    AllocationInfo withTypeIndexMask(uint indexMask) {
        this.memTypeIndexMask = indexMask;
        return this;
    }
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
    final Allocation allocate(in MemoryRequirements requirements,
                              in AllocationInfo info=AllocationInfo.init)
    {
        uint allowedMask = requirements.memTypeMask;
        uint index = findMemoryTypeIndex(_memProps.types, allowedMask, info);
        if (index != uint.max) {
            auto alloc = allocate(requirements, index);
            if (alloc) return alloc;

            while (allowedMask != 0) {
                // retrieve former index from possible choices
                allowedMask &= ~(1 << index);
                index = findMemoryTypeIndex(_memProps.types, allowedMask, info);
                if (index == uint.max) continue;
                alloc = allocate(requirements, index);
                if (alloc) return alloc;
            }
        }

        return null;
    }

    /// Allocate memory for the given index and for given requirements
    abstract Allocation allocate(MemoryRequirements requirements,
                                 uint memoryTypeIndex)
    in {
        assert(memoryTypeIndex < _memProps.types.length);
        assert(
            ((1 << memoryTypeIndex) & requirements.memTypeMask) != 0,
            "memoryTypeIndex is not compatible with requirements"
        );
    }
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

    @property size_t offset() const {
        return _offset;
    }

    @property size_t size() const {
        return _size;
    }

    @property DeviceMemory mem() {
        return _mem;
    }
}

/// Find a memory type index suitable for the given allowedIndexMask and info.
/// Params:
///     types               = the memory types obtained from a device
///     allowedIndexMask    = the mask obtained from MemoryRequirements.memTypeMask
///     info                = an optional AllocationInfo that will constraint the
///                           choice
/// Returns: the found index of memory type, or uint.max if none could satisfy requirements
uint findMemoryTypeIndex(in MemoryType[] types,
                         in uint allowedIndexMask,
                         in AllocationInfo info=AllocationInfo.init)
{
    const allowedMask = info.memTypeIndexMask != 0 ?
            allowedIndexMask & info.memTypeIndexMask :
            allowedIndexMask;

    MemProps preferred = info.preferredProps;
    MemProps required = info.requiredProps;

    switch (info.usage) {
    case MemoryUsage.gpuOnly:
        preferred |= MemProps.deviceLocal;
        break;
    case MemoryUsage.cpuOnly:
        required |= MemProps.hostVisible | MemProps.hostCoherent;
        break;
    case MemoryUsage.cpuToGpu:
        required |= MemProps.hostVisible;
        preferred |= MemProps.deviceLocal;
        break;
    case MemoryUsage.gpuToCpu:
        required |= MemProps.hostVisible;
        preferred |= MemProps.hostCoherent | MemProps.hostCached;
        break;
    case MemoryUsage.unknown:
    default:
        break;
    }

    uint maxValue = uint.max;
    uint index = uint.max;

    foreach (i; 0 .. cast(uint)types.length) {
        const mask = 1 << i;
        // is this type allowed?
        if ((allowedMask & mask) != 0) {
            const props = types[i].props;
            // does it have the required properties?
            if ((props & required) == required) {
                // it is a valid candidate. calcaulate its value as number of
                // preferred flags present
                import core.bitop : popcnt;
                const value = popcnt(cast(uint)(props & preferred));
                if (maxValue == uint.max || value > maxValue) {
                    index = i;
                    maxValue = value;
                }
            }
        }
    }
    return index;
}

package:

/// A pool of memory associated to one memory type
interface MemReturn : AtomicRefCounted
{
    void free(Object returnData);
}
