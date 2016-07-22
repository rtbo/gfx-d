module gfx.backend.gl3.view;

import gfx.backend : unsafeCast;
import gfx.backend.gl3.buffer : GlBuffer;
import gfx.backend.gl3.texture : GlTexture, formatToGlInternalFormat;
import gfx.core.rc : Rc, rcCode;
import gfx.core.context : Context;
import gfx.core.format : Format;
import gfx.core.buffer : RawBuffer;
import gfx.core.texture : RawTexture;
import gfx.core.view : ShaderResourceViewRes, RenderTargetViewRes, DepthStencilViewRes;

import derelict.opengl3.gl3;



class GlBufferShaderResourceView : ShaderResourceViewRes {
    mixin(rcCode);

    GLuint _texName;
    GLenum _internalFormat;
    Rc!GlBuffer _buf;

    this(RawBuffer buf, Format fmt) {
        assert(buf.pinned);
        _buf = unsafeCast!GlBuffer(buf.res);

        _internalFormat = formatToGlInternalFormat(fmt);
        glGenTextures(1, &_texName);
        glBindTexture(GL_TEXTURE_BUFFER, _texName);
        glTexBuffer(GL_TEXTURE_BUFFER, _internalFormat, _buf.name);
    }

    void drop() {
        _buf.nullify();
        glDeleteBuffers(1, &_texName);
    }
}

class GlTextureShaderResourceView : ShaderResourceViewRes {
    mixin(rcCode);

    Rc!GlTexture _tex;

    this(RawTexture tex, Context.TexSRVCreationDesc desc) {
        assert(tex.pinned);
        _tex = unsafeCast!GlTexture(tex.res);
    }

    void drop() {
        _tex.nullify();
    }
}



abstract class GlTargetView : RenderTargetViewRes, DepthStencilViewRes {
    mixin(rcCode);
}

class GlTextureTargetView : GlTargetView {
    Rc!RawTexture _tex;

    this(RawTexture tex, Context.TexRTVCreationDesc desc) {
        _tex = tex;
    }

    this(RawTexture tex, Context.TexDSVCreationDesc desc) {
        _tex = tex;
    }

    void drop() {
        _tex.nullify();
    }
}


class GlSurfaceTargetView {
}