/// A memory allocator for Gfx-d
module gfx.memalloc;

import gfx.core.log :       LogTag;
import gfx.core.rc :        AtomicRefCounted, IAtomicRefCounted;
import gfx.graal.device :   Device;
import gfx.graal.memory :   DeviceMemory, MemoryProperties, MemoryRequirements,
                            MemoryType, MemProps;

enum gfxMemallocLogMask = 0x1000_0000;
package immutable gfxMemallocLog = LogTag("GFX-MEMALLOC", gfxMemallocLogMask);

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
enum AllocFlags {
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
struct AllocOptions {
    /// Control flags
    AllocFlags flags;
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

    /// Initializes an AllocOptions with usage
    static @property AllocOptions forUsage(MemoryUsage usage) {
        AllocOptions options;
        options.usage = usage;
        return options;
    }
    /// set flags to options
    AllocOptions withFlags(AllocFlags flags) {
        this.flags = flags;
        return this;
    }
    /// set preferredProps to options
    AllocOptions withPreferredProps(MemProps props) {
        this.preferredProps = props;
        return this;
    }
    /// set requiredProps to options
    AllocOptions withRequiredBits(MemProps props) {
        this.requiredProps = props;
        return this;
    }
    /// set type index mask to options
    AllocOptions withTypeIndexMask(uint indexMask) {
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
    import gfx.core.rc : Rc;
    import gfx.graal.buffer : BufferUsage;
    import gfx.graal.image : ImageInfo;

    package Device _device;
    package AllocatorOptions _options;
    package MemoryProperties _memProps;
    package size_t _linearOptimalGranularity;

    package this(Device device, AllocatorOptions options)
    {
        import gfx.core.rc : retainObj;

        _device = retainObj(device);
        _options = options;
        _memProps = device.physicalDevice.memoryProperties;
        _linearOptimalGranularity = device.physicalDevice.limits.linearOptimalGranularity;

        import std.algorithm : all;
        import std.exception : enforce;
        enforce(_memProps.types.all!(mt => mt.heapIndex < _memProps.heaps.length));
    }

    override void dispose()
    {
        import gfx.core.rc : releaseObj;

        releaseObj(_device);
    }

    /// Device this allocator is bound to.
    final @property Device device() {
        return _device;
    }

    /// Allocate memory for the given requirements
    /// Returns: A MemAlloc object
    /// Throws: An Exception if memory could not be allocated
    final MemAlloc allocate (in MemoryRequirements requirements,
                             in AllocOptions options=AllocOptions.init)
    {
        AllocResult res;
        if (allocateRaw(requirements, options, ResourceLayout.unknown, res)) {
            return new MemAlloc(
                res.mem, res.offset, requirements.size, res.block, res.blockData
            );
        }
        else {
            import std.format : format;
            throw new Exception(format(
                "Could not allocate memory for requirements: %s", requirements
            ));
        }
    }

    /// Create a buffer, then allocate and bind memory for its requirements
    final BufferAlloc allocateBuffer (in BufferUsage usage, in size_t size,
                                      in AllocOptions options=AllocOptions.init)
    {
        auto buf = _device.createBuffer(usage, size);
        const requirements = buf.memoryRequirements;
        AllocResult res;
        if (allocateRaw(requirements, options, ResourceLayout.linear, res)) {
            buf.bindMemory(res.mem, res.offset);
            return new BufferAlloc(
                buf, res.offset, requirements.size, res.block, res.blockData
            );
        }
        else {
            import std.format : format;
            throw new Exception(format(
                "Could not allocate memory for buffer with usage %s and size %s",
                usage, size
            ));
        }
    }

    /// Create an image, then allocate and bind memory for its requirements
    final ImageAlloc allocateImage (in ImageInfo info,
                                    in AllocOptions options=AllocOptions.init)
    {
        import gfx.graal.image : ImageTiling;

        auto img = _device.createImage(info);
        const requirements = img.memoryRequirements;
        const layout = info.tiling == ImageTiling.optimal ? ResourceLayout.optimal : ResourceLayout.linear;
        AllocResult res;
        if (allocateRaw(requirements, options, layout, res)) {
            img.bindMemory(res.mem, res.offset);
            return new ImageAlloc(
                img, res.offset, requirements.size, res.block, res.blockData
            );
        }
        else {
            import std.format : format;
            throw new Exception(format(
                "Could not allocate memory for image with info %s", info
            ));
        }
    }

    AllocStats collectStats() {
        return AllocStats.init;
    }

    /// Attempt to allocate memory for the given index and for given requirements.
    /// If successful, result is filled with necessary data.
    /// Returns: true if successful, false otherwise.
    abstract protected bool tryAllocate (in MemoryRequirements requirements,
                                         in uint memoryTypeIndex,
                                         in AllocOptions options,
                                         in ResourceLayout layout,
                                         ref AllocResult result)
    in {
        assert(memoryTypeIndex < _memProps.types.length);
        assert(
            ((1 << memoryTypeIndex) & requirements.memTypeMask) != 0,
            "memoryTypeIndex is not compatible with requirements"
        );
    }

    private final bool allocateRaw (in MemoryRequirements requirements,
                                    in AllocOptions options,
                                    in ResourceLayout layout,
                                    ref AllocResult result)
    {
        uint allowedMask = requirements.memTypeMask;
        uint index = findMemoryTypeIndex(_memProps.types, allowedMask, options);
        if (index != uint.max) {
            if (tryAllocate(requirements, index, options, layout, result)) return true;

            while (allowedMask != 0) {
                // retrieve former index from possible choices
                allowedMask &= ~(1 << index);
                index = findMemoryTypeIndex(_memProps.types, allowedMask, options);
                if (index == uint.max) continue;
                if (tryAllocate(requirements, index, options, layout, result)) return true;
            }
        }

        return false;
    }
}


/// Represent a single allocation within a DeviceMemory
class MemAlloc : AtomicRefCounted
{
    import gfx.core.rc : Rc;
    import gfx.graal.memory : MemoryMap;

    private DeviceMemory _mem;
    private size_t _offset;
    private size_t _size;
    private MemBlock _block;
    private Object _blockData;
    private size_t _mapCount;
    private void* _mapPtr;
    private bool _dedicated;

    package this(DeviceMemory mem, size_t offset, size_t size,
                 MemBlock block, Object blockData)
    {
        import gfx.core.rc : retainObj;

        _mem = retainObj(mem);
        _offset = offset;
        _size = size;
        _block = retainObj(block);
        _blockData = blockData;
        _dedicated = mem.size == size;
    }

    override void dispose()
    {
        import gfx.core.rc : releaseObj;

        _block.free(_blockData);
        releaseObj(_mem);
        releaseObj(_block);
    }

    final @property size_t offset() const {
        return _offset;
    }

    final @property size_t size() const {
        return _size;
    }

    final @property DeviceMemory mem() {
        return _mem;
    }

    /// Artificially increment the mapping reference count in order
    /// to keep the memory mapped even if no MemoryMap is alive
    final void retainMap() {
        if (_dedicated) {
            dedicatedMap();
        }
        else {
            _block.map();
        }
    }

    final void releaseMap() {
        if (_dedicated) {
            dedicatedUnmap();
        }
        else {
            _block.unmap();
        }
    }

    final MemoryMap map(in size_t offset=0, in size_t size=size_t.max)
    {
        import std.algorithm : min;

        const off = this.offset + offset;
        const sz = min(this.size-offset, size);
        void* ptr;
        void delegate() unmap;

        if (_dedicated) {
            dedicatedMap();
            ptr = _mapPtr;
            unmap = &dedicatedUnmap;
        }
        else {
            ptr = _block.map();
            unmap = &_block.unmap;
        }

        auto data = ptr[off .. off+sz];
        return MemoryMap (_mem, off, data, unmap);
    }

    private void dedicatedMap() {
        if (!_mapCount) _mapPtr = _mem.mapRaw(0, _mem.size);
        ++_mapCount;
    }

    private void dedicatedUnmap() {
        --_mapCount;
        if (!_mapCount) {
            _mem.unmapRaw();
            _mapPtr = null;
        }
    }
}

final class BufferAlloc : MemAlloc
{
    import gfx.graal.buffer : Buffer;

    private Buffer _buffer;

    package this (Buffer buffer, size_t offset, size_t size, MemBlock block, Object blockData)
    {
        import gfx.core.rc : retainObj;

        super(buffer.boundMemory, offset, size, block, blockData);
        _buffer = retainObj(buffer);
    }

    override void dispose()
    {
        import gfx.core.rc : releaseObj;

        releaseObj(_buffer);
        super.dispose();
    }

    final @property Buffer buffer() {
        return _buffer;
    }
}

final class ImageAlloc : MemAlloc
{
    import gfx.graal.image : Image;

    private Image _image;

    package this (Image image, size_t offset, size_t size, MemBlock block, Object blockData)
    {
        import gfx.core.rc : retainObj;

        super(image.boundMemory, offset, size, block, blockData);
        _image = retainObj(image);
    }

    override void dispose()
    {
        import gfx.core.rc : releaseObj;

        releaseObj(_image);
        super.dispose();
    }

    final @property Image image() {
        return _image;
    }
}


/// Find a memory type index suitable for the given allowedIndexMask and info.
/// Params:
///     types               = the memory types obtained from a device
///     allowedIndexMask    = the mask obtained from MemoryRequirements.memTypeMask
///     options             = an optional AllocOptions that will constraint the
///                           choice
/// Returns: the found index of memory type, or uint.max if none could satisfy requirements
uint findMemoryTypeIndex(in MemoryType[] types,
                         in uint allowedIndexMask,
                         in AllocOptions options=AllocOptions.init)
{
    const allowedMask = options.memTypeIndexMask != 0 ?
            allowedIndexMask & options.memTypeIndexMask :
            allowedIndexMask;

    MemProps preferred = options.preferredProps;
    MemProps required = options.requiredProps;

    switch (options.usage) {
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

/// Layout of a resource
/// This is important to determined whether a page alignment or simple alignemnt
/// is necessary between two consecutive resources
enum ResourceLayout {
    /// layout is unknown
    unknown,
    /// layout of buffers and linear images
    linear,
    /// layout of optimal images
    optimal,
}

/// Some stats of an allocator that can be collected with Allocator.collectStats
struct AllocStats
{
    /// A chunk is a suballocation from a block
    static struct Chunk
    {
        size_t start;
        size_t end;
        bool occupied;
        ResourceLayout layout;
    }

    /// A block is a one to one mapping on a DeviceMemory
    static struct Block
    {
        size_t size;
        Chunk[] chunks;
    }

    size_t totalReserved;
    size_t totalUsed;
    size_t totalFrag;
    size_t linearOptimalGranularity;
    Block[] blocks;

    string toString()
    {
        import std.format : format;
        string res = "AllocStats (\n";

        res ~= format("  total reserved: %s\n", totalReserved);
        res ~= format("  total used    : %s\n", totalUsed);
        res ~= format("  total frag    : %s\n", totalFrag);
        res ~= format("  granularity   : %s\n", linearOptimalGranularity);

        foreach (b; blocks) {
            res ~= "  DeviceMemory (\n";
            res ~= format("    size: %s\n", b.size);
            foreach (c; b.chunks) {
                res ~= "    Resource (\n";

                res ~= format("      start   : %s\n", c.start);
                res ~= format("      end     : %s\n", c.end);
                res ~= format("      occupied: %s\n", c.occupied);
                res ~= format("      layout  : %s\n", c.layout);

                res ~= "    )\n";
            }

            res ~= "  )\n";
        }

        res ~= ")\n";
        return res;
    }
}


package:

/// A block of memory associated to one DeviceMemory
interface MemBlock : IAtomicRefCounted
{
    /// increase map count and return cached pointer
    /// if map count was zero, it maps the memory to the cached pointer before
    void* map();
    /// decrease map count and unmap memory if it reaches zero
    void unmap();
    /// called by MemAlloc when it is disposed to notify its memory block
    void free(Object blockData);
}

/// The result of allocation request
struct AllocResult
{
    DeviceMemory mem;
    size_t offset;
    MemBlock block;
    Object blockData;
}

/// whether two adjacent block should check for granularity alignment
bool granularityMatters(in ResourceLayout l1, in ResourceLayout l2) pure
{
    if (l1 == ResourceLayout.unknown || l2 == ResourceLayout.unknown) return true;
    return l1 != l2;
}

unittest {
    assert(!granularityMatters(ResourceLayout.linear, ResourceLayout.linear));
    assert(!granularityMatters(ResourceLayout.optimal, ResourceLayout.optimal));
    assert( granularityMatters(ResourceLayout.linear, ResourceLayout.optimal));
    assert( granularityMatters(ResourceLayout.optimal, ResourceLayout.linear));
}
