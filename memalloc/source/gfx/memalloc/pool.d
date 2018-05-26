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
            _pools ~= new MemoryPool(i, heapOpts, mh, _memProps.types);
        }

        import gfx.core.rc : retainArr;
        retainArr(_pools);
    }

    override void dispose()
    {
        import gfx.core.rc : releaseArr;
        releaseArr(_pools);
        _device.unload();
    }

    override @property Device device() {
        return _device.obj;
    }

    override @property Allocation allocate(MemoryRequirements requirements)
    {
        import gfx.core.rc : rc;

        foreach (i; 0 .. cast(uint)_memProps.types.length) {
            if ((requirements.memTypeMask >> i) & 1) {
                auto pool = _pools[_memProps.types[i].heapIndex];
                auto alloc = pool.allocate(i, requirements);
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

class MemoryPool : MemReturn
{
    import gfx.core.rc : atomicRcCode, Rc;

    mixin(atomicRcCode);

    uint _memTypeIndex;
    HeapOptions _options;
    MemoryHeap _heap;
    MemoryType[] _types;

    this (uint memTypeIndex, HeapOptions options, MemoryHeap heap, MemoryType[] types) {
        _memTypeIndex = memTypeIndex;
        _options = options;
        _heap = heap;
        _types = types;
    }

    override void dispose() {

    }

    Allocation allocate(uint memTypeIndex, MemoryRequirements requirements)
    {
        return null;
    }

    override void free(size_t offset, size_t size)
    {

    }
}
