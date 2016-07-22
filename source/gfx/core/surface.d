module gfx.core.surface;

import gfx.core : Resource, ResourceHolder, untypeSlices;
import gfx.core.rc : Rc, rcCode;
import gfx.core.context : Context;
import gfx.core.format : isFormatted, Formatted, Format, Swizzle, isRenderSurface, isDepthStencilSurface;
import gfx.core.view : RenderTargetView;

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

abstract class RawSurface : ResourceHolder {
    mixin(rcCode);

    Rc!SurfaceRes _res;
    SurfUsageFlags _usage;
    ushort _width;
    ushort _height;
    Format _format;
    ubyte _samples;

    this(SurfUsageFlags usage, ushort width, ushort height, Format format, ubyte samples) {
        _usage = usage;
        _width = width;
        _height = height;
        _format = format;
        _samples = samples;
    }

    @property inout(SurfaceRes) res() inout { return _res.obj; }

    @property bool pinned() const {
        return _res.assigned;
    }

    void pinResources(Context context) {
        Context.SurfaceCreationDesc desc;
        desc.usage = _usage;
        desc.width = _width;
        desc.height = _height;
        desc.format = _format;
        desc.samples = _samples;
        _res = context.makeSurface(desc);
    }

    void drop() {
        _res.nullify();
    }
}


class Surface(T) : RawSurface if (isFormatted!T) {
    alias Fmt = Formatted!T;

    static assert (isRenderSurface!(Fmt.Surface) || isDepthStencilSurface!(Fmt.Surface),
            "what is this surface for?");

    this(ushort width, ushort height, ubyte samples) {
        import gfx.core.format : format;
        SurfUsageFlags usage;
        static if (isRenderSurface!(Fmt.Surface)) {
            usage |= SurfaceUsage.RenderTarget;
        }
        static if (isDepthStencil!(Fmt.Surface)) {
            usage |= SurfaceUsage.DepthStencil;
        }
        super(usage, width, height, format!T(), samples);
    }

    RenderTargetView!T viewAsRenderTarget() {
        import gfx.core.view : SurfaceRenderTargetView;
        return new SurfaceRenderTargetView!T(this);
    }

    DepthStencilView!T viewAsDepthStencil() {
        import gfx.core.view : SurfaceDepthStencilView;
        return new SurfaceDepthStencilView!T(this);
    }
}