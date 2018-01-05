module gfx.hal.device;

import gfx.core.rc;
import gfx.hal.memory;
import gfx.hal.queue;

struct DeviceFeatures {
}

struct DeviceLimits {
}

enum DeviceType {
    other,
    integratedGpu,
    discreteGpu,
    virtualGpu,
    cpu
}

/// Represent a physical device. This interface is meant to describe the device
/// and open it.
interface PhysicalDevice : AtomicRefCounted
{
    @property uint apiVersion();
    @property uint driverVersion();
    @property uint vendorId();
    @property uint deviceId();
    @property string name();
    @property DeviceType type();
    @property DeviceFeatures features();
    @property DeviceLimits limits();
    @property MemoryProperties memoryProperties();
    @property QueueFamily[] queueFamilies();

    Device open();
}


/// Handle to a physical device
interface Device : AtomicRefCounted
{
    DeviceMemory allocateMemory(uint memPropIndex, size_t size);
}
