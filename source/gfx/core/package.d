module gfx.core;

import gfx.core.rc : RefCounted;
import gfx.core.factory : Factory;
import gfx.core.command : CommandBuffer;
import gfx.core.surface : BuiltinSurfaceRes;

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

    @property inout(Resource) res() inout;

    @property bool pinned() const;

    void pinResources(Device device)
    in { assert(!pinned); }
    out { assert(pinned); }

}

/// implemented by objects that can hold or be builtin surfaces
interface MaybeBuiltin {
    /// returns true if implementer holds or is a builtin surface
    @property bool builtin() const;
}

interface Device : RefCounted {

    @property bool hasIntrospection() const;

    @property string name() const;

    @property Factory factory();

    @property BuiltinSurfaceRes builtinSurface();

    CommandBuffer makeCommandBuffer();
    void submit(CommandBuffer buffer);
}

/// a rectangle of screen
struct Rect {
    ushort x; ushort y; ushort w; ushort h;
}
