module gfx.hal.device;

import gfx.core.rc;
import gfx.hal.memory;


/// Represent a physical device. This interface is meant to describe the device
/// and open it.
interface PhysicalDevice {
    MemoryProperties memoryProperties();
    Device open();
}


/// Handle to a physical device
interface Device : AtomicRefCounted
{
    DeviceMemory allocateMemory(uint memPropIndex, size_t size);
}
