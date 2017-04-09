module gfx.pipeline.surface;

import gfx.device : Device, Resource, ResourceHolder, MaybeBuiltin, Size;
import gfx.foundation.rc : Rc, rcCode;
import gfx.device.factory : Factory;
import gfx.pipeline.format : isFormatted, Formatted, Format, Swizzle, isRenderSurface, isDepthOrStencilSurface;
import gfx.pipeline.view : RenderTargetView, DepthStencilView;

import std.typecons : BitFlags;


enum SurfaceUsage {
    None            = 0,
    RenderTarget    = 1,
    DepthStencil    = 2,
}
alias SurfUsageFlags = BitFlags!SurfaceUsage;


interface SurfaceRes : Resource {
    void bind();
}

/// surface that is created by the window
interface BuiltinSurfaceRes : SurfaceRes {
    void updateSize(Size s);
}

abstract class RawSurface : ResourceHolder, MaybeBuiltin {
    mixin(rcCode);

    Rc!SurfaceRes _res;
    SurfUsageFlags _usage;
    Size _size;
    Format _format;
    ubyte _samples;

    this(SurfUsageFlags usage, Size size, Format format, ubyte samples) {
        _usage = usage;
        _size = size;
        _format = format;
        _samples = samples;
    }

    final @property inout(SurfaceRes) res() inout { return _res.obj; }


    final void pinResources(Device device) {
        Factory.SurfaceCreationDesc desc;
        desc.usage = _usage;
        desc.size = _size;
        desc.format = _format;
        desc.samples = _samples;
        _res = device.factory.makeSurface(desc);
    }

    final void dispose() {
        _res.unload();
    }

    @property bool builtin() const {
        return false;
    }

    final @property Size size() const {
        return _size;
    }
}


class Surface(T) : RawSurface if (isFormatted!T) {
    alias Fmt = Formatted!T;

    static assert (isRenderSurface!(Fmt.Surface) || isDepthOrStencilSurface!(Fmt.Surface),
            "what is this surface for?");

    this(Size size, ubyte samples) {
        import gfx.pipeline.format : format;
        SurfUsageFlags usage;
        static if (isRenderSurface!(Fmt.Surface)) {
            usage |= SurfaceUsage.RenderTarget;
        }
        static if (isDepthOrStencilSurface!(Fmt.Surface)) {
            usage |= SurfaceUsage.DepthStencil;
        }
        super(usage, size, format!T(), samples);
    }

    final RenderTargetView!T viewAsRenderTarget() {
        import gfx.pipeline.view : SurfaceRenderTargetView;
        return new SurfaceRenderTargetView!T(this);
    }

    final DepthStencilView!T viewAsDepthStencil() {
        import gfx.pipeline.view : SurfaceDepthStencilView;
        return new SurfaceDepthStencilView!T(this);
    }
}

class BuiltinSurface(T) : Surface!T
{
    this(BuiltinSurfaceRes res, Size size, ubyte samples)
    in { assert(res, "gfx-d: a valid resource must be provided to BuiltinSurface"); }
    body
    {
        super(size, samples);
        _res = res;
    }

    final void updateSize(Size size) {
        import gfx.foundation.util : unsafeCast;
        _size = size;
        unsafeCast!BuiltinSurfaceRes(_res.obj).updateSize(size);
    }

    final override @property bool builtin() const {
        return true;
    }
}