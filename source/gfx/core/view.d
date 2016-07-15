module gfx.core.view;

import gfx.core : Resource, ResourceHolder;
import gfx.core.rc : Rc, rcCode;
import gfx.core.context : Context;
import gfx.core.format : isFormatted, Formatted;
import gfx.core.buffer : Buffer;
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
        _res.nullify();
    }

    @property bool pinned() const {
        return _res.assigned;
    }
}


class BufferShaderResourceView(T) : RawShaderResourceView if(isFormatted!T) {
    private alias Fmt = Formatted!T;
    private Rc!(Buffer!T) _buf;

    void drop() {
        _buf.nullify();
        super.drop();
    }

    void pinResources(Context context) {
        import gfx.core.format : format;
        if(!_buf.pinned) _buf.pinResources(context);
        immutable fmt = format!T;
        _res = context.viewAsShaderResource(_buf, fmt);
    }
}


class TextureShaderResourceView(T) : RawShaderResourceView if(isFormatted!T) {
    private alias Fmt = Formatted!T;
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

    void drop() {
        _tex.nullify();
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

    void drop() {
        _res.nullify();
    }

    @property bool pinned() const {
        return _res.assigned;
    }
}

class RenderTargetView(T) : RawRenderTargetView if(isFormatted!T) {
    alias Fmt = Formatted!T;

    Rc!(Texture!T) _tex;
    ubyte _level;
    ubyte _layer;

    this(Texture!T tex, ubyte level, ubyte layer=ubyte.max) {
        _tex = tex;
        _level = level;
        _layer = layer;
    }

    void pinResources(Context context) {
        if(!_tex.pinned) _tex.pinResources(context);
        Context.TexRTVCreationDesc desc;
        desc.channel = Fmt.Channel.channelType;
        desc.level = _level;
        if(_layer != ubyte.max) desc.layer = _layer;
        _res = context.viewAsRenderTarget(_tex.obj, desc);
    }

    void drop() {
        _tex.nullify();
        super.drop();
    }

}


abstract class RawDepthStencilView : ResourceHolder {
    mixin(rcCode);

    Rc!DepthStencilViewRes _res;

    void drop() {
        _res.nullify();
    }

    @property bool pinned() const {
        return _res.assigned;
    }
}

class DepthStencilView(T) : RawDepthStencilView if(isFormatted!T) {
    alias Fmt = Formatted!T;

    Rc!(Texture!T) _tex;
    ubyte _level;
    ubyte _layer;

    this(Texture!T tex, ubyte level, ubyte layer=ubyte.max) {
        _tex = tex;
        _level = level;
        _layer = layer;
    }

    void pinResources(Context context) {
        if(!_tex.pinned) _tex.pinResources(context);
        Context.TexRTVCreationDesc desc;
        desc.channel = Fmt.Channel.channelType;
        desc.level = _level;
        if(_layer != ubyte.max) desc.layer = _layer;
        _res = context.viewAsDepthStencil(_tex.obj, desc);
    }

    void drop() {
        _tex.nullify();
        super.drop();
    }

}