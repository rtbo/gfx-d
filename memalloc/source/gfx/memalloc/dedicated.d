module gfx.memalloc.dedicated;

package:

import gfx.memalloc.allocator;
import gfx.graal.device : Device;

class DedicatedAllocator : Allocator
{
    import gfx.core.rc : atomicRcCode, Rc;

    mixin(atomicRcCode);

    private Rc!Device _device;
    private AllocatorOptions _options;

    this (Device device, AllocatorOptions options) {
        _device = device;
        _options = options;
    }

    override void dispose() {
        _device.unload();
    }

    override @property Device device() {
        return _device.obj;
    }

    override @property Allocation allocate(uint memTypeIndex, size_t size)
    {
        import gfx.core.rc : rc;

        auto dm = _device.allocateMemory(memTypeIndex, size).rc;
        if (dm) {
            return new Allocation(0, size, dm.obj, this);
        }
        else if (_options.flags & AllocatorFlags.returnNull) {
            return null;
        }
        else {
            import std.format : format;
            throw new Exception(format(
                "Could not allocate %s bytes of memory index %s", size, memTypeIndex
            ));
        }
    }
}
