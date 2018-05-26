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

    override @property Allocation allocate(MemoryRequirements requirements,
                                           uint memTypeIndex)
    {
        try {
            return new Allocation(
                0, requirements.size,
                _device.allocateMemory(memTypeIndex, requirements.size),
                this, null
            );
        }
        catch (Exception ex) {
            return null;
        }
    }

    // nothing to do here
    override void free(Object returnData) {}

}
