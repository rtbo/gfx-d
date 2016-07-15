module gfx.core.shader_resource;

import gfx.core;
import gfx.core.rc;
import gfx.core.context;
import gfx.core.format;
import gfx.core.buffer;
import gfx.core.texture;


interface ShaderResourceViewRes : Resource {}

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