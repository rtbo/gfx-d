module gfx.gl3.resource;

package:

import gfx.graal.buffer : Buffer;
import gfx.graal.memory : DeviceMemory;

final class GlDeviceMemory : DeviceMemory
{
    import gfx.core.rc : atomicRcCode;
    import gfx.graal.memory : MemProps;

    mixin(atomicRcCode);

    private uint _typeIndex;
    private MemProps _props;
    private size_t _size;
    private GlBuffer _buffer;


    this (in uint typeIndex, in MemProps props, in size_t size) {
        _typeIndex = typeIndex;
        _props = props;
        _size = size;
    }

    override void dispose() {
    }

    override @property uint typeIndex() {
        return _typeIndex;
    }
    override @property MemProps props() {
        return _props;
    }
    override @property size_t size() {
        return _size;
    }

    override void* map(in size_t offset, in size_t size) {
        import std.exception : enforce;
        enforce(_buffer, "GL backend does not support mapping without bound buffer");
        return _buffer.map(offset, size);
    }

    override void unmap() {
        import std.exception : enforce;
        enforce(_buffer, "GL backend does not support mapping without bound buffer");
        _buffer.unmap();
    }
}


final class GlBuffer : Buffer
{
    import gfx.bindings.opengl.gl;
    import gfx.core.rc : atomicRcCode, Rc;
    import gfx.gl3 : GlExts, GlShare;
    import gfx.gl3.context : GlContext;
    import gfx.graal.buffer : BufferUsage, BufferView;
    import gfx.graal.format : Format;
    import gfx.graal.memory : DeviceMemory, MemoryRequirements;

    mixin(atomicRcCode);

    private GlExts exts;
    private Gl gl;
    private BufferUsage _usage;
    private size_t _size;
    private GLuint _handle;
    private GLbitfield _accessFlags;
    private Rc!GlDeviceMemory _mem;

    this(GlShare share, in BufferUsage usage, in size_t size) {
        import gfx.gl3.conv : toGl;
        gl = share.gl;
        exts = share.exts;
        _usage = usage;
        _size = size;
        gl.GenBuffers(1, &_handle);
    }

    override void dispose() {
        gl.DeleteBuffers(1, &_handle);
        _handle = 0;
        _mem.unload();
    }

    override @property size_t size() {
        return _size;
    }
    override @property BufferUsage usage() {
        return _usage;
    }
    override @property MemoryRequirements memoryRequirements() {
        import gfx.graal.memory : MemProps;
        MemoryRequirements mr;
        mr.alignment = 4;
        mr.size = _size;
        mr.memTypeMask = 1;
        return mr;
    }

    override void bindMemory(DeviceMemory mem, in size_t offset) {
        _mem = cast(GlDeviceMemory)mem;
        _mem._buffer = this;

        const props = mem.props;

        gl.BindBuffer(GL_ARRAY_BUFFER, _handle);

        if (exts.bufferStorage) {
            GLbitfield flags = 0;
            if (props.hostVisible) flags |= (GL_MAP_READ_BIT | GL_MAP_WRITE_BIT);
            if (props.hostCoherent) flags |= GL_MAP_COHERENT_BIT;
            gl.BufferStorage(GL_ARRAY_BUFFER, cast(GLsizeiptr)_size, null, flags);
        }
        else {
            const glUsage = GL_STATIC_DRAW; //?
            gl.BufferData(GL_ARRAY_BUFFER, cast(GLsizeiptr)_size, null, glUsage);
        }

        gl.BindBuffer(GL_ARRAY_BUFFER, 0);
    }

    override @property DeviceMemory boundMemory() {
        return _mem.obj;
    }

    override BufferView createView(Format format, size_t offset, size_t size) {
        return null;
    }

    private void* map(in size_t offset, in size_t size) {
        const props = _mem.props;

        GLbitfield flags = GL_MAP_INVALIDATE_RANGE_BIT;
        if (props.hostVisible) flags |= (GL_MAP_READ_BIT | GL_MAP_WRITE_BIT);
        if (props.hostCoherent) flags |= GL_MAP_COHERENT_BIT;
        else flags |= GL_MAP_FLUSH_EXPLICIT_BIT;

        gl.BindBuffer(GL_ARRAY_BUFFER, _handle);
        auto ptr = gl.MapBufferRange(GL_ARRAY_BUFFER, cast(GLintptr)offset, cast(GLsizeiptr)size, flags);
        gl.BindBuffer(GL_ARRAY_BUFFER, 0);
        return ptr;
    }

    private void unmap() {
        gl.BindBuffer(GL_ARRAY_BUFFER, _handle);
        gl.UnmapBuffer(GL_ARRAY_BUFFER);
        gl.BindBuffer(GL_ARRAY_BUFFER, 0);
    }
}
