module gfx.pipeline.view;

import gfx.device : Device, Resource, ResourceHolder, MaybeBuiltin;
import gfx.foundation.typecons : Option;
import gfx.foundation.rc : Rc, rcCode;
import gfx.device.factory : Factory;
import gfx.pipeline.format : isFormatted, Formatted, Swizzle;
import gfx.pipeline.buffer : ShaderResourceBuffer;
import gfx.pipeline.texture : Texture;
import gfx.pipeline.surface : Surface;

import std.typecons : BitFlags;


enum DSVReadOnly {
    None = 0,
    Depth = 1,
    Stencil = 2,
}
alias DSVReadOnlyFlags = BitFlags!DSVReadOnly;



interface ShaderResourceViewRes : Resource {
    void bind();
}

interface RenderTargetViewRes : Resource {}

interface DepthStencilViewRes : Resource {}



abstract class RawShaderResourceView : ResourceHolder {
    mixin(rcCode);

    private Rc!ShaderResourceViewRes _res;

    final @property inout(ShaderResourceViewRes) res() inout { return _res.obj; }

    void dispose() {
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

    final override void dispose() {
        _buf.unload();
        super.dispose();
    }

    final void pinResources(Device device) {
        import gfx.pipeline.format : format;
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

    final override void dispose() {
        _tex.unload();
        super.dispose();
    }

    final void pinResources(Device device) {
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
    ushort[2] _size;

    this(ushort w, ushort h) {
        _size = size;
    }

    @property bool builtin() const {
        return false;
    }

    final @property inout(RenderTargetViewRes) res() inout {
        return _res.obj;
    }

    final @property ushort[2] size() const {
        return _size;
    }
}

abstract class RenderTargetView(T) : RawRenderTargetView if (isFormatted!T) {
    alias Fmt = Formatted!T;

    this(ushort w, ushort h) {
        super(w, h);
    }
}

class TextureRenderTargetView(T) : RenderTargetView!T {

    Rc!(Texture!T) _tex;
    ubyte _level;
    Option!ubyte _layer;

    this(Texture!T tex, ubyte level, Option!ubyte layer) {
        super(tex.width, tex.height);
        _tex = tex;
        _level = level;
        _layer = layer;
    }

    final void pinResources(Device device) {
        if(!_tex.pinned) _tex.pinResources(device);
        Factory.TexRTVCreationDesc desc;
        desc.channel = Fmt.Channel.channelType;
        desc.level = _level;
        desc.layer = _layer;
        _res = device.factory.makeRenderTargetView(_tex.obj, desc);
    }

    final void dispose() {
        _tex.unload();
        _res.unload();
    }

}

class SurfaceRenderTargetView(T) : RenderTargetView!T {
    Rc!(Surface!T) _surf;

    this(Surface!T surf) {
        super(surf.width, surf.height);
        _surf = surf;
    }

    final void pinResources(Device device) {
        if(!_surf.pinned) _surf.pinResources(device);
        _res = device.factory.makeRenderTargetView(_surf.obj);
    }

    final void dispose() {
        _surf.unload();
        _res.unload();
    }

    final override @property bool builtin() const {
        return _surf.loaded && _surf.builtin;
    }
}


abstract class RawDepthStencilView : ResourceHolder, MaybeBuiltin {
    mixin(rcCode);

    Rc!DepthStencilViewRes _res;
    ushort[2] _size;

    this(ushort w, ushort h) {
        _size = [w, h];
    }


    @property bool builtin() const {
        return false;
    }

    final @property inout(DepthStencilViewRes) res() inout {
        return _res.obj;
    }

    final @property ushort[2] size() const {
        return _size;
    }

    final @property ushort width() const { return _size[0]; }
    final @property ushort height() const { return _size[1]; }
}

abstract class DepthStencilView(T) : RawDepthStencilView if (isFormatted!T) {
    alias Fmt = Formatted!T;

    this(ushort w, ushort h) {
        super(w, h);
    }
}

class TextureDepthStencilView(T) : DepthStencilView!T {

    Rc!(Texture!T) _tex;
    ubyte _level;
    Option!ubyte _layer;
    DSVReadOnlyFlags _flags;

    this(Texture!T tex, ubyte level, Option!ubyte layer, DSVReadOnlyFlags flags) {
        super(tex.width, tex.height);
        _tex = tex;
        _level = level;
        _layer = layer;
        _flags = flags;
    }

    final void pinResources(Device device) {
        if(!_tex.pinned) _tex.pinResources(device);
        Factory.TexDSVCreationDesc desc;
        desc.level = _level;
        desc.layer = _layer;
        desc.flags = _flags;
        _res = device.factory.makeDepthStencilView(_tex.obj, desc);
    }

    final void dispose() {
        _tex.unload();
        _res.unload();
    }

}

class SurfaceDepthStencilView(T) : DepthStencilView!T {
    Rc!(Surface!T) _surf;

    this(Surface!T surf) {
        super(surf.width, surf.height);
        _surf = surf;
    }

    final void pinResources(Device device) {
        if(!_surf.pinned) _surf.pinResources(device);
        _res = device.factory.makeDepthStencilView(_surf.obj);
    }

    final void dispose() {
        _surf.unload();
        _res.unload();
    }

    final override @property bool builtin() const {
        return _surf.loaded && _surf.builtin;
    }
}
