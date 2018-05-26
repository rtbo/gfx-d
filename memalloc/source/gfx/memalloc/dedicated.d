module gfx.memalloc.dedicated;

package:

import gfx.graal.device : Device;
import gfx.graal.memory : DeviceMemory, MemoryProperties, MemoryRequirements;
import gfx.memalloc;

class DedicatedAllocator : Allocator, MemReturn
{
    this (Device device, AllocatorOptions options) {
        super(device, options);
    }

    override @property Allocation allocate(MemoryRequirements requirements)
    {
        import gfx.core.rc : rc;

        foreach (i; 0 .. cast(uint)_memProps.types.length) {
            if (((uint(1) << i) & requirements.memTypeMask) != 0) {
                auto dm = _device.allocateMemory(i, requirements.size).rc;
                if (dm) return new Allocation(0, requirements.size, dm, this, null);
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

    // nothing to do here
    override void free(Object returnData) {}

}
