module gfx.memalloc.dedicated;

package:

import gfx.graal.device : Device;
import gfx.graal.memory : DeviceMemory, MemoryProperties, MemoryRequirements;
import gfx.memalloc;

class DedicatedAllocator : Allocator, MemBlock
{
    this (Device device, AllocatorOptions options) {
        super(device, options);
    }

    override bool tryAllocate(in MemoryRequirements requirements,
                              in uint memTypeIndex, in AllocOptions options,
                              in ResourceLayout layout, ref AllocResult result)
    {
        try {
            result.mem = _device.allocateMemory(memTypeIndex, requirements.size);
            result.offset = 0;
            result.block = this;
            result.blockData = null;
            return true;
        }
        catch (Exception ex) {
            return false;
        }
    }

    // nothing to do here
    override void free(Object returnData) {}


    // should not be called
    override void *map()
    {
        assert(false);
    }

    // should not be called
    override void unmap()
    {
        assert(false);
    }

}
