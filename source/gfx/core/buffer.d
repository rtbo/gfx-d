module gfx.core.buffer;

import gfx.core : Resource, ResourceHolder, untypeSlice;
import gfx.core.rc : RefCounted, Rc, RcCode;
import gfx.core.context : Context;

enum BufferRole {
    Vertex,
    Index,
    Constant, // uniform blocks
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

struct BufferSliceInfo {
    size_t offset;
    size_t size;
}

interface BufferRes : Resource {
    void bind();
    void update(BufferSliceInfo slice, const(ubyte)[] data);
}

abstract class RawBuffer : ResourceHolder {
    mixin RcCode!();

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
        _res.nullify();
    }

    final @property bool pinned() const {
        return _res.assigned;
    }
    void pinResources(Context context) {
        Context.BufferCreationDesc desc;
        desc.role = _role;
        desc.usage = _usage;
        desc.size = _size;
        _res = context.makeBuffer(desc, _initData);
        _initData = [];
    }

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
        super(role, usage, access, data.length, ElType.sizeof, untypeSlice(data));
    }
}


class VertexBuffer(T) : Buffer!T {
    this(size_t count) {
        super(BufferRole.Vertex, BufferUsage.Const, MapAccess.None, count);
    }
    this(const(T)[] data) {
        super(BufferRole.Vertex, BufferUsage.Const, MapAccess.None, data);
    }
}

/// determines if T is valid for index buffers
template isIndexType(T) {
    enum isIndexType = is(T == ushort) || is(T == uint);
}


class IndexBuffer(T) : Buffer!T if (isIndexType!T) {
    this(size_t count) {
        super(BufferRole.Index, BufferUsage.Const, MapAccess.None, count);
    }
    this(const(T)[] data) {
        super(BufferRole.Index, BufferUsage.Const, MapAccess.None, data);
    }
}


class ConstBuffer(T) : RawPlainBuffer {
    alias ElType = T;

    this() {
        super(BufferRole.Constant, BufferUsage.Const, MapAccess.None,
                1, ElType.sizeof, []);
    }

    this(in T value) {
        auto buf = new ubyte[T.sizeof];
        auto ptr = cast(T*)buf.ptr;
        *ptr = value;
        super(BufferRole.Constant, BufferUsage.Const, MapAccess.None,
                1, ElType.sizeof, buf);
    }
}



// class ComposedBuffer : RawBuffer {
//     RawBufferSlice[] _slices;
//     bool _needUpdateAtResPin;

//     this(BufferUsage usage, MapAccess access, RawBufferSlice[] slices) {
//         import std.algorithm : map, sum, all;
//         _slices = slices;
//         ubyte[] data;
//         immutable size = _slices.map!(s => s.size).sum();
//         immutable makeInitData = slices.all!(s => s._initData.length != 0);
//         if (makeInitData) {
//             data.reserve(size);
//             size_t offset = 0;
//             foreach(s; slices) {
//                 s._info.offset = offset;
//                 data ~= s._initData;
//                 offset += s._initData.length;
//                 s._initData = [];
//             }
//             assert(data.length == size);
//         }
//         super(BufferRole.Vertex, usage, access, size, data);
//         _needUpdateAtResPin = !makeInitData;
//     }

//     override void pinResources(Context context) {
//         import std.algorithm : filter, each;
//         super.pinResources(context);
//         if(_needUpdateAtResPin) {
//             _slices.filter!(s => s._initData.length != 0).each!(s => {
//                 _res.update(s.info, s._initData);
//             });
//         }
//     }
// }


// abstract class RawBufferSlice {
//     private BufferSliceInfo _info;
//     private ubyte[] _initData;

//     this(size_t size, ubyte[] data) {
//         _info.size = size;
//         _initData = data;
//     }

//     final @property size_t offset() const { return _info.offset; }
//     final @property size_t size() const { return _info.size; }
//     final @property BufferSliceInfo info() const { return _info; }
// }

// class BufferSlice(T) : RawBufferSlice {
//     alias ElType = T;
//     private size_t _count;

//     this(size_t count) {
//         super(count*T.sizeof, []);
//         _count = count;
//     }
//     this(T[] data) {
//         super(data.length*T.sizeof, untypeSlice(data));
//         _count = data.length;
//     }

//     final @property size_t count() const { return _count; }
// }