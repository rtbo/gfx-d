/// command buffer module
module gfx.graal.cmd;

import gfx.core.rc;


interface CommandPool : AtomicRefCounted
{
    void reset();

    CommandBuffer[] allocate(size_t count);

    void free(CommandBuffer[] buffers)
    in {
        import std.algorithm : all;
        assert(buffers.all!(b => b.pool is this));
    }
}

interface CommandBuffer
{
    @property CommandPool pool();

    void reset();

    void begin(bool multipleSubmissions);
    void end();
}
