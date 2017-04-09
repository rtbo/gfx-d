module gfx.device;

import gfx.device.factory : Factory;
import gfx.foundation.rc : RefCounted;
import gfx.pipeline.draw : CommandBuffer;
import gfx.pipeline.surface : BuiltinSurfaceRes;

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

    final @property bool pinned() const {
        return res !is null;
    }

    void pinResources(Device device)
    in { assert(!pinned); }
    out { assert(pinned); }

}

/// implemented by objects that can hold or be builtin surfaces
interface MaybeBuiltin {
    /// returns true if implementer holds or is a builtin surface
    @property bool builtin() const;
}


struct Caps {
    import std.bitmanip : bitfields;

    mixin(bitfields!(
        bool, "introspection", 1,
        bool, "instanceDraw", 1,
        bool, "instanceBase", 1,
        bool, "instanceRate", 1,
        bool, "vertexBase", 1,
        bool, "separateBlendSlots", 1,
        bool, "srgbFramebuffer", 1,
        byte, "", 1,
    ));
}

interface Device : RefCounted {

    @property string name() const;
    @property Caps caps() const;

    @property Factory factory();

    @property BuiltinSurfaceRes builtinSurface();

    CommandBuffer makeCommandBuffer();
    void submit(CommandBuffer buffer);
}
