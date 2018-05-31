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

    override bool tryAllocate(in MemoryRequirements requirements,
                              in uint memTypeIndex, ref AllocResult result)
    {
        try {
            result.mem = _device.allocateMemory(memTypeIndex, requirements.size);
            result.offset = 0;
            result.ret = this;
            result.retData = null;
            return true;
        }
        catch (Exception ex) {
            return false;
        }
    }

    // nothing to do here
    override void free(Object returnData) {}

}
