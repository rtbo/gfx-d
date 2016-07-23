module gfx.core;

import gfx.core.rc : RefCounted;
import gfx.core.factory : Factory;
import gfx.core.command : CommandBuffer;

import std.traits;


immutable size_t maxVertexAttribs = 16;
immutable size_t maxColorTargets = 4;

alias AttribMask = ushort;
alias ColorTargetMask = ubyte;

static assert(maxVertexAttribs <= 8*AttribMask.sizeof);
static assert(maxColorTargets <= 8*ColorTargetMask.sizeof);

enum Primitive {
    Points,
    Lines,
    LineStrip,
    Triangles,
    TriangleStrip,
}

enum IndexType {
    U16, U32,
}


interface Resource : RefCounted {}

interface ResourceHolder : RefCounted {

    @property bool pinned() const;

    void pinResources(Device device)
    in { assert(!pinned); }
    out { assert(pinned); }

}


interface Device : RefCounted {

    @property bool hasIntrospection() const;

    @property string name() const;

    @property Factory factory();

    void submit(CommandBuffer buffer);
}

/// a rectangle of screen
struct Rect {
    ushort x; ushort y; ushort w; ushort h;
}

/// cast a typed slice into a blob of bytes
/// (same representation; no copy is made)
ubyte[] untypeSlice(T)(T[] slice) if(!is(T == const)) {
    if (slice.length == 0) return [];
    auto loc = cast(ubyte*)slice.ptr;
    return loc[0 .. slice.length*T.sizeof];
}

/// cast a typed const slice into a blob of bytes
/// (same representation; no copy is made)
const(ubyte)[] untypeSlice(T)(const(T)[] slice) {
    if (slice.length == 0) return [];
    auto loc = cast(const(ubyte)*)slice.ptr;
    return loc[0 .. slice.length*T.sizeof];
}

/// cast a blob of bytes into a typed slice
T[] retypeSlice(T)(ubyte[] slice) if (!is(T == const)){
    if(slice.length == 0) return [];
    assert((slice.length % T.sizeof) == 0);
    auto loc = cast(T*)slice.ptr;
    return loc[0 .. slice.length / T.sizeof];
}

/// cast a blob of bytes into a typed slice
const(T)[] retypeSlice(T)(const(ubyte)[] slice) {
    if(slice.length == 0) return [];
    assert((slice.length % T.sizeof) == 0);
    auto loc = cast(const(T)*)slice.ptr;
    return loc[0 .. slice.length / T.sizeof];
}

unittest {
    int[] slice = [1, 2, 3, 4];
    auto bytes = untypeSlice(slice);
    auto ints = retypeSlice!int(bytes);
    assert(bytes.length == 16);
    version(LittleEndian) {
        assert(bytes == [
            1, 0, 0, 0,
            2, 0, 0, 0,
            3, 0, 0, 0,
            4, 0, 0, 0,
        ]);
    }
    else {
        assert(bytes == [
            0, 0, 0, 1,
            0, 0, 0, 2,
            0, 0, 0, 3,
            0, 0, 0, 4,
        ]);
    }
    assert(ints.length == 4);
    assert(ints == slice);
    assert(ints.ptr == slice.ptr);
}

ubyte[][] untypeSlices(T)(T[][] slices) if (!is(T == const)) {
    ubyte[][] res = new ubyte[][slices.length];
    foreach(i, s; slices) {
        res[i] = untypeSlice(s);
    }
    return res;
}

const(ubyte)[][] untypeSlices(T)(const(T)[][] slices) {
    const(ubyte)[][] res = new const(ubyte)[][slices.length];
    foreach(i, s; slices) {
        res[i] = untypeSlice(s);
    }
    return res;
}

unittest {
    int[][] texels = [ [1, 2], [3, 4] ];
    auto bytes = untypeSlices(texels);
    assert(bytes.length == 2);
    assert(bytes[0].length == 8);
    assert(bytes[1].length == 8);
    version(LittleEndian) {
        assert(bytes == [
            [   1, 0, 0, 0,
                2, 0, 0, 0, ],
            [   3, 0, 0, 0,
                4, 0, 0, 0, ],
        ]);
    }
    else {
        assert(bytes == [
            [   0, 0, 0, 1,
                0, 0, 0, 2, ],
            [   0, 0, 0, 3,
                0, 0, 0, 4, ],
        ]);
    }
}
