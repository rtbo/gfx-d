module gfx.hal.memory;

import gfx.core.rc;

/// Properties of memory allocated by the device
enum MemProps {
    deviceLocal     = 0x01,
    hostVisible     = 0x02,
    hostCoherent    = 0x04,
    hostCached      = 0x08,
    lazilyAllocated = 0x10,
}

/// Structure representing all heaps and types of memory from a device.
/// A device can have different heaps each supporting different types.
struct MemoryProperties {
    MemoryHeap[] heaps;
    MemoryType[] types;
}

struct MemoryHeap {
    size_t size;
    MemProps props;
    bool deviceLocal;
}

struct MemoryType {
    uint index;
    uint heapIndex;
    size_t heapSize;
    MemProps props;
}


interface DeviceMemory : AtomicRefCounted
{
    @property MemProps props();
    @property size_t size();
}
