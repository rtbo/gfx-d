/// GrAAL buffer module
module gfx.graal.buffer;

import gfx.core.rc;
import gfx.graal.format;
import gfx.graal.memory;

enum BufferUsage
{
    transferSrc     = 0x0001,
    transferDst     = 0x0002,
    uniformTexel    = 0x0004,
    storageTexel    = 0x0008,
    uniform         = 0x0010,
    storage         = 0x0020,
    index           = 0x0040,
    vertex          = 0x0080,
    indirect        = 0x0100,
}

enum IndexType {
    u16, u32
}

interface Buffer : IAtomicRefCounted
{
    import gfx.graal.device : Device;

    /// Get the parent device
    @property Device device();

    @property size_t size();
    @property BufferUsage usage();
    @property MemoryRequirements memoryRequirements();

    /// The buffer keeps a reference to the device memory
    void bindMemory(DeviceMemory mem, in size_t offset);

    @property DeviceMemory boundMemory();

    BufferView createView(Format format, size_t offset, size_t size);
}

interface BufferView : IAtomicRefCounted
{
    @property Format format();
    @property Buffer buffer();
    @property size_t offset();
    @property size_t size();
}
