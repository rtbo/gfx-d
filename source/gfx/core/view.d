module gfx.core.view;

import gfx.core : Device, Resource, ResourceHolder, MaybeBuiltin;
import gfx.core.typecons : Option;
import gfx.core.rc : Rc, rcCode;
import gfx.core.factory : Factory;
import gfx.core.format : isFormatted, Formatted, Swizzle;
import gfx.core.buffer : ShaderResourceBuffer;
import gfx.core.texture : Texture;
import gfx.core.surface : Surface;

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

    @property inout(ShaderResourceViewRes) res() inout { return _res.obj; }

    void drop() {
        _res.unload();
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

    void pinResources(Device device) {
        import gfx.core.format : format;
        if(!_buf.pinned) _buf.pinResources(device);
        immutable fmt = format!T;
        _res = device.factory.viewAsShaderResource(_buf, fmt);
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

    void pinResources(Device device) {
        if(!_tex.pinned) _tex.pinResources(device);
        Factory.TexSRVCreationDesc desc;
        desc.channel = Fmt.Channel.channelType;
        desc.minLevel = _minLevel;
        desc.maxLevel = _maxLevel;
        desc.swizzle = _swizzle;
        _res = device.factory.makeShaderResourceView(_tex, desc);
    }
}


abstract class RawRenderTargetView : ResourceHolder, MaybeBuiltin {
    mixin(rcCode);

    Rc!RenderTargetViewRes _res;

    @property bool builtin() const {
        return false;
    }

    final @property inout(RenderTargetViewRes) res() inout {
        return _res.obj;
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

    void pinResources(Device device) {
        if(!_tex.pinned) _tex.pinResources(device);
        Factory.TexRTVCreationDesc desc;
        desc.channel = Fmt.Channel.channelType;
        desc.level = _level;
        desc.layer = _layer;
        _res = device.factory.makeRenderTargetView(_tex.obj, desc);
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

    void pinResources(Device device) {
        if(!_surf.pinned) _surf.pinResources(device);
        _res = device.factory.makeRenderTargetView(_surf.obj);
    }

    void drop() {
        _surf.unload();
        _res.unload();
    }

    override @property bool builtin() const {
        return _surf.loaded && _surf.builtin;
    }
}


abstract class RawDepthStencilView : ResourceHolder, MaybeBuiltin {
    mixin(rcCode);

    Rc!DepthStencilViewRes _res;

    @property bool builtin() const {
        return false;
    }

    @property inout(DepthStencilViewRes) res() inout {
        return _res.obj;
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

    void pinResources(Device device) {
        if(!_tex.pinned) _tex.pinResources(device);
        Factory.TexDSVCreationDesc desc;
        desc.level = _level;
        desc.layer = _layer;
        desc.flags = _flags;
        _res = device.factory.makeDepthStencilView(_tex.obj, desc);
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

    void pinResources(Device device) {
        if(!_surf.pinned) _surf.pinResources(device);
        _res = device.factory.makeDepthStencilView(_surf.obj);
    }

    void drop() {
        _surf.unload();
        _res.unload();
    }

    override @property bool builtin() const {
        return _surf.loaded && _surf.builtin;
    }
}
