module gfx.memalloc.pool;

package:

import gfx.graal.device :   Device;
import gfx.graal.memory :   DeviceMemory, MemoryHeap, MemoryProperties,
                            MemoryRequirements, MemoryType;
import gfx.memalloc;

final class PoolAllocator : Allocator
{
    import gfx.core.rc : atomicRcCode, Rc;

    mixin(atomicRcCode);

    Rc!Device _device;
    AllocatorOptions _options;
    MemoryProperties _memProps;
    MemoryPool[] _pools;

    this(Device device, AllocatorOptions options)
    {
        _device = device;
        _options = options;
        _memProps = device.physicalDevice.memoryProperties;

        foreach (uint i, mh; _memProps.heaps) {
            const heapOpts = _options.heapOptions.length>i ? _options.heapOptions[i] : HeapOptions.init;
            _pools ~= new MemoryPool(this, i, heapOpts, mh, _memProps.types);
        }
    }

    override void dispose()
    {
        _device.unload();
    }

    override @property Device device() {
        return _device.obj;
    }

    override @property Allocation allocate(MemoryRequirements requirements)
    {
        foreach (i; 0 .. cast(uint)_memProps.types.length) {
            if ((requirements.memTypeMask >> i) & 1) {
                auto pool = _pools[_memProps.types[i].heapIndex];
                auto alloc = pool.allocate(i, requirements.alignment, requirements.size);
                if (alloc) return alloc;
            }
        }

        if (_options.flags & AllocatorFlags.returnNull) {
            return null;
        }
        else {
            import std.format : format;
            throw new Exception(format(
                "Could not allocate memory for requirements %s", requirements
            ));
        }
    }

}

private:

enum size_t largeHeapThreshold = 1024*1024*1024;
enum size_t largeHeapBlockSize =  256*1024*1024;


/// Represent an entire heap of memory.
/// It is made of several MemoryBlock, each of which is associated to a single
/// DeviceMemory object.
class MemoryPool
{
    PoolAllocator _allocator;
    uint _memTypeIndex;
    MemoryHeap _heap;
    MemoryType[] _types;

    size_t _blockSize;
    size_t _maxUsage;
    size_t _used;

    MemoryBlock[] _blocks;

    this (PoolAllocator allocator, uint memTypeIndex, HeapOptions options, MemoryHeap heap, MemoryType[] types) {
        _allocator = allocator;
        _memTypeIndex = memTypeIndex;
        _heap = heap;
        _types = types;
        _blockSize = options.blockSize;
        _maxUsage = options.maxUsage;

        if (_maxUsage == size_t.max) {
            _maxUsage = heap.size;
        }
        if (_blockSize == 0 || _blockSize > _maxUsage) {
            if (heap.size > largeHeapThreshold) {
                _blockSize = largeHeapBlockSize;
            }
            else {
                import std.math : isPowerOf2, nextPow2;
                auto target = heap.size / 8;
                if (!isPowerOf2(target)) {
                    target = nextPow2(target) / 2;
                }
            }
        }
        if (_blockSize > _maxUsage) {
            _blockSize = _maxUsage;
        }
    }

    // Return null if allocation cannot be satisfied
    Allocation allocate(uint memTypeIndex, size_t alignment, size_t size)
    {
        import std.algorithm : filter;
        foreach (b; _blocks.filter!(b => (b._typeIndex == memTypeIndex && !b._dedicated))) {
            auto alloc = b.allocate(alignment, size);
            if (alloc) return alloc;
        }
        if (size > (_maxUsage-_used)) return null;
        return newBlockAllocation(memTypeIndex, size);
    }

    void free(MemoryBlock block) {
        import std.algorithm : remove;
        _used += block._size;
        _blocks = _blocks.remove!(b => b is block);
    }

    Allocation newBlockAllocation(uint memTypeIndex, size_t size) {
        Device dev = _allocator._device;
        DeviceMemory dm;
        try {
            dm = dev.allocateMemory(memTypeIndex, size);
        }
        catch (Exception ex) {
            return null;
        }
        auto b = new MemoryBlock(_allocator, this, dm, size>=_blockSize);
        _used -= size;
        _blocks ~= b;
        return b.allocate(0, size);
    }

}

// linked list of memory chunks
// each chunk can be occupied (and is then associated to a single allocation)
// or free and is then merged with its free neighboors
final class MemoryChunk {
    size_t offset;
    size_t size;

    Allocation alloc; // null if chunk is free space

    MemoryChunk prev;
    MemoryChunk next;

    this (size_t offset, size_t size, MemoryChunk prev=null, MemoryChunk next=null) {
        this.offset = offset;
        this.size = size;
        this.prev = prev;
        this.next = next;
    }

    this (size_t offset, size_t size, Allocation alloc, MemoryChunk prev=null, MemoryChunk next=null) {
        this.offset = offset;
        this.size = size;
        this.alloc = alloc;
        this.prev = prev;
        this.next = next;
    }

    @property bool free() {
        return alloc is null;
    }
}

size_t nextAligned(in size_t address, in size_t alignment) pure nothrow @nogc
{
    return ((address + alignment - 1) / alignment) * alignment;
}


/// Represent a single DeviceMemory
class MemoryBlock : MemReturn
{
    import gfx.core.rc : atomicRcCode, Rc;

    mixin(atomicRcCode);

    Rc!PoolAllocator _allocator; // needed to maintain it alive as long allocations are alive
    MemoryPool _pool;
    Rc!DeviceMemory _memory;
    bool _dedicated;
    size_t _size;
    uint _typeIndex;

    MemoryChunk _chunk0;

    this (PoolAllocator allocator, MemoryPool pool, DeviceMemory memory, bool dedicated) {
        _allocator = allocator;
        _pool = pool;
        _memory = memory;
        _dedicated = dedicated;
        _size = memory.size;
        _typeIndex = memory.typeIndex;

        // start with a single free chunk that occupies the whole block
        _chunk0 = new MemoryChunk(0, _size);
    }

    override void dispose() {
        _pool.free(this);
        _memory.unload();
        _allocator.unload();
    }

    Allocation allocate(size_t alignment, size_t size) {
        for (auto chunk=_chunk0; chunk !is null; chunk=chunk.next) {

            if (!chunk.free) continue;

            const offset = nextAligned(chunk.offset, alignment);
            if (offset+size > chunk.offset+chunk.size) continue;

            return allocateHere(chunk, offset, size);
        }

        return null;
    }

    override void free(Object returnData) {
        import gfx.core.util : unsafeCast;
        auto chunk = unsafeCast!MemoryChunk(returnData);
        chunk.alloc = null;
        // merge this chunk with previous and next one if they are free
        if (chunk.prev && chunk.prev.free) {
            auto cp = chunk.prev;
            cp.next = chunk.next;
            if (cp.next) cp.next.prev = cp;
            cp.size = chunk.size+chunk.offset - cp.offset;
            chunk = cp;
        }
        if (chunk.next && chunk.next.free) {
            auto cn = chunk.next;
            chunk.next = cn.next;
            if (chunk.next) chunk.next.prev = chunk;
            chunk.size = cn.size+cn.offset - chunk.offset;
        }
    }

    Allocation allocateHere(MemoryChunk chunk, in size_t offset, in size_t size) {
        assert(chunk);
        assert(chunk.free);
        assert(chunk.offset <= offset);
        const shift = offset - chunk.offset;
        assert(chunk.size >= shift+size);

        if (offset != chunk.offset) {
            // alignment padding necessary
            // we create shift bytes of external fragmentation
            chunk.offset = offset;
            chunk.size -= shift;
        }
        if (size < chunk.size) {
            // trim right
            auto c = new MemoryChunk(offset+size, chunk.size-size, chunk, chunk.next);
            chunk.next = c;
            if (c.next) c.next.prev = c;
            chunk.size = size;
        }

        chunk.alloc = new Allocation(offset, size, _memory.obj, this, chunk);
        return chunk.alloc;
    }

    invariant {
        assert(_chunk0 && _chunk0.offset == 0);
    }
}
