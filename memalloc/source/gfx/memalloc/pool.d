module gfx.memalloc.pool;

package:

import gfx.graal.device :   Device;
import gfx.graal.memory :   DeviceMemory, MemoryHeap, MemoryProperties,
                            MemoryRequirements, MemoryType;
import gfx.memalloc;

final class PoolAllocator : Allocator
{
    MemoryPool[] _pools;

    this(Device device, AllocatorOptions options)
    {
        super(device, options);

        foreach (i, mh; _memProps.heaps) {
            const heapOpts = _options.heapOptions.length>i ? _options.heapOptions[i] : HeapOptions.init;
            _pools ~= new MemoryPool(this, cast(uint)i, heapOpts, mh, _memProps.types);
        }
    }

    override AllocStats collectStats() {
        AllocStats stats;
        stats.linearOptimalGranularity = _linearOptimalGranularity;
        foreach (p; _pools) {
            p.feedStats(stats);
        }
        return stats;
    }

    override bool tryAllocate(in MemoryRequirements requirements,
                              in uint memTypeIndex, in AllocOptions options,
                              in ResourceLayout layout, ref AllocResult result)
    {
        auto pool = _pools[_memProps.types[memTypeIndex].heapIndex];
        return pool.allocate(memTypeIndex, requirements.alignment, requirements.size, options, layout, result);
    }

}

private:

enum size_t largeHeapThreshold = 1024*1024*1024;
enum size_t largeHeapBlockSize =  256*1024*1024;


/// Represent an entire heap of memory.
/// It is made of several MemoryBlock, each of which is associated to a single
/// DeviceMemory object.
final class MemoryPool
{
    PoolAllocator _allocator;
    uint _memTypeIndex;
    MemoryHeap _heap;
    MemoryType[] _types;

    size_t _maxUsage;
    size_t _blockSize;
    size_t _used;

    MemoryBlock[] _blocks;

    this (PoolAllocator allocator, uint memTypeIndex, HeapOptions options, MemoryHeap heap, MemoryType[] types) {
        _allocator = allocator;
        _memTypeIndex = memTypeIndex;
        _heap = heap;
        _types = types;
        _maxUsage = options.maxUsage;
        _blockSize = options.blockSize;

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

    bool allocate(uint memTypeIndex, size_t alignment, size_t size,
                  in AllocOptions options, in ResourceLayout layout,
                  ref AllocResult result)
    {
        import std.algorithm : filter;
        if (!(options.flags & AllocFlags.dedicated)) {
            foreach (b; _blocks.filter!(b => (b._typeIndex == memTypeIndex && !b._dedicated))) {
                if (b.allocate(alignment, size, layout, result)) return true;
            }
        }
        if (options.flags & AllocFlags.neverAllocate) return false;
        if (size > (_maxUsage-_used)) return false;
        return newBlockAllocation(memTypeIndex, size, options, layout, result);
    }

    void free(MemoryBlock block) {
        import std.algorithm : remove;
        _used += block._size;
        _blocks = _blocks.remove!(b => b is block);
    }

    void feedStats(ref AllocStats stats) {
        foreach (b; _blocks) {
            b.feedStats(stats);
        }
    }

    private bool newBlockAllocation(in uint memTypeIndex, in size_t size,
                                    in AllocOptions options,
                                    in ResourceLayout layout,
                                    ref AllocResult result) {
        Device dev = _allocator._device;
        DeviceMemory dm;
        try {
            import std.algorithm : max;
            auto sz = max(_blockSize, size);
            if (options.flags & AllocFlags.dedicated) {
                sz = size;
            }
            dm = dev.allocateMemory(memTypeIndex, sz);
        }
        catch (Exception ex) {
            return false;
        }
        auto b = new MemoryBlock(_allocator, this, dm, dm.size == size);
        _used -= size;
        _blocks ~= b;
        return b.allocate(0, size, layout, result);
    }

}

// linked list of memory chunks
// each chunk can be occupied (and is then associated to a single allocation)
// or free and is then merged with its free neighboors
final class MemoryChunk {
    size_t offset;
    size_t size;

    ResourceLayout layout;
    bool occupied;

    MemoryChunk prev;
    MemoryChunk next;

    this (size_t offset, size_t size, MemoryChunk prev=null, MemoryChunk next=null) {
        this.offset = offset;
        this.size = size;
        this.prev = prev;
        this.next = next;
    }

    size_t pageBeg(in size_t granularity) {
        return page(offset, granularity);
    }

    size_t pageEnd(in size_t granularity) {
        return page(offset+size-1, granularity);
    }
}

size_t alignUp(in size_t address, in size_t alignment) pure nothrow @nogc
{
    if (alignment == 0) return address;
    return ((address + alignment - 1) / alignment) * alignment;
}

size_t page(in size_t addr, in size_t granularity) pure nothrow @nogc
{
    return addr & ~(granularity-1);
}

bool onSamePage(in size_t prevOffset, in size_t prevSize, in size_t nextOffset, in size_t granularity)
{
    const prevPage = page(prevOffset+prevSize-1, granularity);
    const nextPage = page(nextOffset, granularity);
    return prevPage == nextPage;
}

/// Represent a single DeviceMemory
class MemoryBlock : MemBlock
{
    import gfx.core.rc : atomicRcCode, Rc;

    mixin(atomicRcCode);

    Rc!PoolAllocator _allocator; // needed to maintain it alive as long allocations are alive
    MemoryPool _pool;
    Rc!DeviceMemory _memory;
    bool _dedicated;
    size_t _size;
    size_t _mapCount;
    void* _mapPtr;
    uint _typeIndex;
    size_t _granularity;

    MemoryChunk _chunk0;

    this (PoolAllocator allocator, MemoryPool pool, DeviceMemory memory, bool dedicated) {
        _allocator = allocator;
        _pool = pool;
        _memory = memory;
        _dedicated = dedicated;
        _size = memory.size;
        _typeIndex = memory.typeIndex;
        _granularity = allocator._linearOptimalGranularity;

        // start with a single free chunk that occupies the whole block
        _chunk0 = new MemoryChunk(0, _size);
    }

    override void dispose() {
        _pool.free(this);
        _memory.unload();
        _allocator.unload();
    }

    bool allocate(size_t alignment, size_t size, ResourceLayout layout, ref AllocResult result)
    {
        for (auto chunk=_chunk0; chunk !is null; chunk=chunk.next) {

            if (chunk.occupied) continue;

            size_t offset = alignUp(chunk.offset, alignment);

            // align up if page conflict in previous chunks
            if (_granularity > 1) {
                bool pageConflict;
                const thisPage = page(offset, _granularity);
                auto prev = chunk.prev;
                while (prev) {
                    if (prev.pageEnd(_granularity) == thisPage) {
                        if (prev.occupied && granularityMatters(prev.layout, layout)) {
                            pageConflict = true;
                            break;
                        }
                    }
                    else {
                        break;
                    }
                    prev = prev.prev;
                }
                if (pageConflict) {
                    offset = alignUp(offset, _granularity);
                }
            }

            if (offset+size > chunk.offset+chunk.size) continue;

            // discard this chunk if page conflict in next chunks
            if (_granularity > 1) {
                bool pageConflict;
                const thisPage = page(offset+size-1, _granularity);
                auto next = chunk.next;
                while (next) {
                    if (next.pageBeg(_granularity) == thisPage) {
                        if (next.occupied && granularityMatters(next.layout, layout)) {
                            pageConflict = true;
                            break;
                        }
                    }
                    else {
                        break;
                    }
                    next = next.next;
                }
                if (pageConflict) {
                    continue;
                }
            }

            return allocateHere(chunk, offset, size, layout, result);
        }

        return false;
    }

    override void *map()
    {
        if (!_mapCount) {
            _mapPtr = _memory.mapRaw(0, _size);
        }
        _mapCount++;
        return _mapPtr;
    }

    override void unmap()
    {
        _mapCount--;
        if (!_mapCount) {
            _memory.unmapRaw();
            _mapPtr = null;
        }
    }

    override void free(Object returnData) {
        import gfx.core.util : unsafeCast;
        auto chunk = unsafeCast!MemoryChunk(returnData);
        chunk.occupied = false;
        chunk.layout = ResourceLayout.unknown;
        // merge this chunk with previous and next one if they are free
        if (chunk.prev && !chunk.prev.occupied) {
            auto cp = chunk.prev;
            cp.next = chunk.next;
            if (cp.next) cp.next.prev = cp;
            cp.size = chunk.size+chunk.offset - cp.offset;
            chunk = cp;
        }
        if (chunk.next && !chunk.next.occupied) {
            auto cn = chunk.next;
            chunk.next = cn.next;
            if (chunk.next) chunk.next.prev = chunk;
            chunk.size = cn.size+cn.offset - chunk.offset;
        }
    }

    bool allocateHere(MemoryChunk chunk, in size_t offset, in size_t size,
                      in ResourceLayout layout, ref AllocResult result) {
        assert(chunk);
        assert(!chunk.occupied);
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

        chunk.occupied = true;
        chunk.layout = layout;
        result.mem = _memory.obj;
        result.offset = offset;
        result.block = this;
        result.blockData = chunk;
        return true;
    }

    void feedStats(ref AllocStats stats) {
        stats.totalReserved += _size;
        AllocStats.Block sb;
        sb.size = _size;
        size_t lastEnd;
        bool lastOccupied;
        for (auto chunk=_chunk0; chunk !is null; chunk = chunk.next) {
            AllocStats.Chunk sc;
            sc.start = chunk.offset;
            sc.end = chunk.offset+chunk.size;
            sc.layout = chunk.layout;
            sc.occupied = chunk.occupied;
            sb.chunks ~= sc;
            if (chunk.occupied) {
                stats.totalUsed += chunk.size;
                if (lastOccupied) {
                    stats.totalFrag += chunk.offset-lastEnd;
                }
            }
            lastOccupied = chunk.occupied;
            lastEnd = sc.end;
        }
        stats.blocks ~= sb;
    }

    invariant {
        assert(_chunk0 && _chunk0.offset == 0);
    }
}
