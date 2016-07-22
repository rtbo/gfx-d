module gfx.core.view;

import gfx.core : Resource, ResourceHolder;
import gfx.core.typecons : Option;
import gfx.core.rc : Rc, rcCode;
import gfx.core.context : Context;
import gfx.core.format : isFormatted, Formatted;
import gfx.core.buffer : ShaderResourceBuffer;
import gfx.core.texture : Texture;

import std.typecons : BitFlags;


enum DSVReadOnly {
    None = 0,
    Depth = 1,
    Stencil = 2,
}
alias DSVReadOnlyFlags = BitFlags!DSVReadOnly;



interface ShaderResourceViewRes : Resource {}

interface RenderTargetViewRes : Resource {}

interface DepthStencilViewRes : Resource {}



abstract class RawShaderResourceView : ResourceHolder {
    mixin(rcCode);

    private Rc!ShaderResourceViewRes _res;

    void drop() {
        _res.unload();
    }

    @property bool pinned() const {
        return _res.loaded;
    }
}

abstract class ShaderResourceView(T) : RawShaderResourceView {
    private alias Fmt = Formatted!T;
}


class BufferShaderResourceView(T) : ShaderResourceView!T if (isFormatted!T) {
    private Rc!(ShaderResourceBuffer!T) _buf;

    this(ShaderResourceBuffer!T buf) {
        _buf = buf;
    }

    override void drop() {
        _buf.unload();
        super.drop();
    }

    void pinResources(Context context) {
        import gfx.core.format : format;
        if(!_buf.pinned) _buf.pinResources(context);
        immutable fmt = format!T;
        _res = context.viewAsShaderResource(_buf, fmt);
    }
}


class TextureShaderResourceView(T) : ShaderResourceView!T if(isFormatted!T) {
    private Rc!(Texture!T) _tex;
    private ubyte _minLevel;
    private ubyte _maxLevel;
    private Swizzle _swizzle;

    this(Texture!T tex, ubyte minLevel, ubyte maxLevel, Swizzle swizzle) {
        _tex = tex;
        _minLevel = minLevel;
        _maxLevel = maxLevel;
        _swizzle = swizzle;
    }

    override void drop() {
        _tex.unload();
        super.drop();
    }

    void pinResources(Context context) {
        if(!_tex.pinned) _tex.pinResources(context);
        Context.TexSRVCreationDesc desc;
        desc.channel = Fmt.Surface;
        desc.minLevel = _minLevel;
        desc.maxLevel = _maxLevel;
        desc.swizzle = _swizzle;
        _tex = context.viewAsShaderResource(_tex, desc);
    }
}


abstract class RawRenderTargetView : ResourceHolder {
    mixin(rcCode);

    Rc!RenderTargetViewRes _res;

    @property bool pinned() const {
        return _res.loaded;
    }
}

abstract class RenderTargetView(T) : RawRenderTargetView if (isFormatted!T) {
    alias Fmt = Formatted!T;
}

class TextureRenderTargetView(T) : RenderTargetView!T {

    Rc!(Texture!T) _tex;
    ubyte _level;
    Option!ubyte _layer;

    this(Texture!T tex, ubyte level, Option!ubyte layer) {
        _tex = tex;
        _level = level;
        _layer = layer;
    }

    void pinResources(Context context) {
        if(!_tex.pinned) _tex.pinResources(context);
        Context.TexRTVCreationDesc desc;
        desc.channel = Fmt.Channel.channelType;
        desc.level = _level;
        desc.layer = _layer;
        _res = context.viewAsRenderTarget(_tex.obj, desc);
    }

    void drop() {
        _tex.unload();
        _res.unload();
    }

}

class SurfaceRenderTargetView(T) : RenderTargetView!T {
    Rc!(Surface!T) _surf;

    this(Surface!T surf) {
        _surf = surf;
    }

    void pinResources(Context context) {
        if(!_surf.pinned) _surf.pinResources(context);
        _res = context.viewAsRenderTarget(_surf.obj);
    }

    void drop() {
        _surf.unload();
        _res.unload();
    }
}


abstract class RawDepthStencilView : ResourceHolder {
    mixin(rcCode);

    Rc!DepthStencilViewRes _res;

    @property bool pinned() const {
        return _res.loaded;
    }
}

abstract class DepthStencilView(T) : RawDepthStencilView if (isFormatted!T) {
    alias Fmt = Formatted!T;
}

class TextureDepthStencilView(T) : DepthStencilView!T {

    Rc!(Texture!T) _tex;
    ubyte _level;
    Option!ubyte _layer;
    DSVReadOnlyFlags _flags;

    this(Texture!T tex, ubyte level, Option!ubyte layer, DSVReadOnlyFlags flags) {
        _tex = tex;
        _level = level;
        _layer = layer;
        _flags = flags;
    }

    void pinResources(Context context) {
        if(!_tex.pinned) _tex.pinResources(context);
        Context.TexDSVCreationDesc desc;
        desc.level = _level;
        desc.layer = _layer;
        desc.flags = _flags;
        _res = context.viewAsDepthStencil(_tex.obj, desc);
    }

    void drop() {
        _tex.unload();
        _res.unload();
    }

}

class SurfaceDepthStencilView(T) : DepthStencilView!T {
    Rc!(Surface!T) _surf;

    this(Surface!T surf) {
        _surf = surf;
    }

    void pinResources(Context context) {
        if(!_surf.pinned) _surf.pinResources(context);
        _res = context.viewAsDepthStencil(_surf.obj);
    }

    void drop() {
        _surf.unload();
        _res.unload();
    }
}
