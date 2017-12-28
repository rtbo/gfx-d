module gfx.device;

import gfx.device.factory : Factory;
import gfx.foundation.rc : GfxRefCounted;
import gfx.pipeline.draw : CommandBuffer;
import gfx.pipeline.surface : BuiltinSurfaceRes;

import std.traits;



interface Resource : GfxRefCounted {}

interface ResourceHolder : GfxRefCounted {

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

interface Device : GfxRefCounted {

    @property string name() const;
    @property Caps caps() const;

    @property Factory factory();

    @property BuiltinSurfaceRes builtinSurface();

    CommandBuffer makeCommandBuffer();
    void submit(CommandBuffer buffer);
}
