/// GrAAL buffer module
module gfx.graal.buffer;

import gfx.core.rc;
import gfx.graal.format;
import gfx.graal.memory;
import gfx.graal.pipeline : BufferDescriptor, TexelBufferDescriptor;

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

    /// The size in bytes of the buffer
    @property size_t size();

    /// The usage this buffer was created for
    @property BufferUsage usage();

    /// The memory allocation requirements for this buffer
    @property MemoryRequirements memoryRequirements();

    /// Bind a the buffer to a device memory
    ///
    /// The buffer will use the memory allocated in the device memory
    /// starting at the specified offset in bytes, and spanning up
    /// to the offset + size member of memoryRequirments.
    /// The buffer keeps a reference to the device memory.
    void bindMemory(DeviceMemory mem, in size_t offset);

    /// The memory this buffer is bound to
    @property DeviceMemory boundMemory();

    /// Build a view to a part of this buffer to be used as texel buffer
    /// The returned resource keeps a reference to this buffer.
    TexelBufferView createTexelView(Format format, size_t offset, size_t size);

    /// build a descriptor for this resource
    final BufferDescriptor descriptor(in size_t offset = 0, in size_t size = 0)
    {
        const sz = size == 0 ? this.size - offset : size;
        return BufferDescriptor(this, offset, sz);
    }
}

/// A texel view to a buffer
interface TexelBufferView : IAtomicRefCounted
{
    /// The texel format
    @property Format format();
    /// The underlying buffer resource
    @property Buffer buffer();
    /// The offset in bytes from the buffer
    @property size_t offset();
    /// The amount of texel bytes in this view
    @property size_t size();

    /// Build a descriptor for this resource
    final TexelBufferDescriptor descriptor()
    {
        return TexelBufferDescriptor(this);
    }
}
