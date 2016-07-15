module gfx.core.render_target;

import gfx.core;
import gfx.core.rc;
import gfx.core.context;
import gfx.core.format;
import gfx.core.texture;

import std.typecons : BitFlags;


enum DSVReadOnly {
    None = 0,
    Depth = 1,
    Stencil = 2,
}
alias DSVReadOnlyFlags = BitFlags!DSVReadOnly;


interface RenderTargetViewRes : Resource {}

interface DepthStencilViewRes : Resource {}


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