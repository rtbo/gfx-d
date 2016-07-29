module gfx.core.buffer;

import gfx.core : Device, Resource, ResourceHolder;
import gfx.core.rc : RefCounted, Rc, rcCode;
import gfx.core.factory : Factory;
import gfx.core.format : Formatted;
import gfx.core.view : ShaderResourceView, BufferShaderResourceView;


enum BufferRole {
    Vertex,
    Index,
    Constant,        // uniform blocks
    ShaderResource,  // storage for texture
}

enum BufferUsage {
    GpuOnly,
    Const,
    Dynamic,
    CpuOnly,
}

enum MapAccess {
    None,
    Readable,
    Writable,
    RW
}


/// determines if T is valid for index buffers
template isIndexType(T) {
    enum isIndexType = is(T == ushort) || is(T == uint);
}


interface BufferRes : Resource {
    void bind();
    void update(size_t offset, const(ubyte)[] data);
}

abstract class RawBuffer : ResourceHolder {
    mixin(rcCode);

    private Rc!BufferRes _res;
    private BufferRole _role;
    private BufferUsage _usage;
    private MapAccess _access;
    private size_t _size;
    private const(ubyte)[] _initData;

    this(BufferRole role, BufferUsage usage, MapAccess access,
        size_t size, const(ubyte)[] initData) {
        _role = role; _usage = usage; _access = access;
        _size = size; _initData = initData;
    }

    final void drop() {
        _res.unload();
    }

    final void pinResources(Device device) {
        Factory.BufferCreationDesc desc;
        desc.role = _role;
        desc.usage = _usage;
        desc.size = _size;
        _res = device.factory.makeBuffer(desc, _initData);
        _initData = [];
    }

    final @property inout(BufferRes) res() inout { return _res.obj; }
    final @property BufferRole role() const { return _role; }
    final @property BufferUsage usage() const { return _usage; }
    final @property MapAccess access() const { return _access; }
    final @property size_t size() const { return _size; }
}


abstract class RawPlainBuffer : RawBuffer {

    private size_t _count;
    private size_t _stride;

    this(BufferRole role, BufferUsage usage, MapAccess access, size_t count,
            size_t stride, const(ubyte)[] initData) {
        super(role, usage, access, count*stride, initData);
        _count = count;
        _stride = stride;
    }

    final @property size_t count() const { return _count; }
    final @property size_t stride() const { return _stride; }
}


class Buffer(T) : RawPlainBuffer {
    alias ElType = T;

    this(in BufferRole role, in BufferUsage usage, in MapAccess access, in size_t count) {
        super(role, usage, access, count, ElType.sizeof, []);
    }
    this(in BufferRole role, in BufferUsage usage, in MapAccess access, in const(T)[] data) {
        import gfx.core.util : untypeSlice;
        super(role, usage, access, data.length, ElType.sizeof, untypeSlice(data));
    }
}

class VertexBuffer(T) : Buffer!T {
    this(const(T)[] data) {
        super(BufferRole.Vertex, BufferUsage.Const, MapAccess.None, data);
    }
}

class IndexBuffer(T) : Buffer!T if (isIndexType!T) {
    this(const(T)[] data) {
        super(BufferRole.Index, BufferUsage.Const, MapAccess.None, data);
    }
}

class ConstBuffer(T) : Buffer!T {
    this(size_t num=1) {
        super(BufferRole.Constant, BufferUsage.Dynamic, MapAccess.None, num);
    }
}

class ShaderResourceBuffer(T) : Buffer!T if (isFormatted!T) {
    this(in BufferUsage usage, in MapAccess access, in const(T)[] data) {
        super(BufferRole.ShaderResource, usage, access, data);
    }

    final ShaderResourceView!T viewAsShaderResource() {
        return new BufferShaderResourceView!T(this);
    }
}


enum IndexType {
    None, U16, U32,
}

/// Represents a slice into a vertex buffer. This is how index buffers are to be used
struct VertexBufferSlice {
    import gfx.core.typecons : Option;
    import gfx.core.draw : Instance;

    IndexType type;
    size_t start;
    size_t end;
    size_t baseVertex;
    Option!Instance instances;
    Rc!RawBuffer buffer;

    this(T)(IndexBuffer!T ibuf) {
        static if (is(T == ushort)) {
            type = IndexType.U16;
        }
        else static if (is(T == uint)) {
            type = IndexType.U32;
        }
        end = ibuf.count;
        buffer = ibuf;
    }

    this(size_t count) {
        type = IndexType.None;
        end = count;
    }
}
