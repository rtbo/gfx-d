module gfx.gl3.resource;

package:

import gfx.graal.buffer : Buffer;
import gfx.graal.memory : DeviceMemory;

final class GlDeviceMemory : DeviceMemory
{
    import gfx.core.rc : atomicRcCode;
    import gfx.graal.memory : MemProps;

    mixin(atomicRcCode);

    private struct ResBinding {
        size_t offset;
        size_t size;
        GlResource res;
        void *map;
    }
    private uint _typeIndex;
    private MemProps _props;
    private size_t _size;
    private ResBinding[] _bindings;
    private ResBinding[] _mapping;
    private void[] _cache;
    private size_t _mapOffset;
    private size_t _mapSize;



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
        _mapOffset = offset;
        _mapSize = size;
        _mapping = bindingOverlap(offset, size);
        if (_mapping.length == 1) {
            const bo = _mapping[0].offset;
            const bs = _mapping[0].size;
            if (offset >= bo && offset+size <= bs) {
                _mapping[0].map = null;
                return _mapping[0].res.map(offset-bo, size);
            }
        }
        if (!_cache.length) _cache = new void[_size];
        foreach (ref b; _mapping) {
            import std.algorithm : max, min;
            const bStart = offset > b.offset ? offset-b.offset : 0;
            const bSize = min(b.size, offset+size-bStart);
            const cStart = max(offset, bStart);
            const cSize = bSize;
            b.map = b.res.map(bStart, bSize);
            _cache[cStart .. cStart + cSize] = b.map[0 .. bSize];
        }
        return &_cache[offset];
    }

    override void unmap() {
        foreach (ref b; _mapping) {
            if (_cache.length && b.map !is null) {
                import std.algorithm : max, min;
                const bStart = _mapOffset > b.offset ? _mapOffset-b.offset : 0;
                const bSize = min(b.size, _mapOffset+_mapSize-bStart);
                const cStart = max(_mapOffset, bStart);
                const cSize = bSize;
                b.map[0 .. bSize] = _cache[cStart .. cStart+bSize];
                b.map = null;
            }
            b.res.unmap();
        }
    }

    ResBinding[] bindingOverlap(in size_t offset, in size_t size) {
        size_t start=size_t.max;
        size_t end=size_t.max;
        foreach (i, b; _bindings) {
            if (offset < b.offset+b.size && offset+size > b.offset) {
                if (start == size_t.max) start = i;
                end = i;
            }
        }
        if (start == size_t.max) return null;
        return _bindings[start .. end+1];
    }
}

private interface GlResource {
    void* map(in size_t offset, in size_t size);
    void unmap();
}

final class GlBuffer : Buffer
{
    import gfx.bindings.opengl.gl : GlCmds30, GLenum, GLuint;
    import gfx.core.rc : atomicRcCode, Rc;
    import gfx.gl3.context : GlContext;
    import gfx.graal.buffer : BufferUsage, BufferView;
    import gfx.graal.format : Format;
    import gfx.graal.memory : DeviceMemory, MemoryRequirements;

    mixin(atomicRcCode);

    private Rc!GlContext _ctx;
    private GlCmds30 gl;
    private GLuint _handle;
    private BufferUsage _usage;
    private size_t _size;
    private GLenum _target;
    private Rc!GlDeviceMemory _mem;
    private size_t _offset;

    this(GlContext ctx, in BufferUsage usage, in size_t size) {
        import gfx.gl3.conv : toGl;
        _ctx = ctx;
        gl = _ctx.cmds;
        _usage = usage;
        _size = size;
        _target = usage.toGl();
        gl.genBuffers(1, &_handle);
    }

    override void dispose() {
        gl.deleteBuffers(1, &_handle);
        _handle = 0;
        _mem.unload();
        _ctx.unload();
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
        _offset = offset;
        auto ptr = _mem.map(_offset, _size);
        scope(exit) _mem.unmap();


    }

    override @property DeviceMemory boundMemory() {
        return _mem.obj;
    }

    override BufferView createView(Format format, size_t offset, size_t size) {
        return null;
    }
}
