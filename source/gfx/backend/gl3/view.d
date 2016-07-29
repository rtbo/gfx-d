module gfx.backend.gl3.view;

import gfx.backend.gl3.buffer : GlBuffer;
import gfx.backend.gl3.texture : GlTexture, formatToGlInternalFormat;
import gfx.core.rc : Rc, rcCode;
import gfx.core.typecons : Option;
import gfx.core.factory : Factory;
import gfx.core.format : Format;
import gfx.core.buffer : RawBuffer;
import gfx.core.texture : RawTexture;
import gfx.core.surface : RawSurface;
import gfx.core.view : ShaderResourceViewRes, RenderTargetViewRes, DepthStencilViewRes;

import derelict.opengl3.gl3;


abstract class GlShaderResourceView : ShaderResourceViewRes {
    mixin(rcCode);
    abstract @property GLenum target() const;
}

class GlBufferShaderResourceView : GlShaderResourceView {

    GLuint _texName;
    GLenum _internalFormat;
    Rc!GlBuffer _buf;

    this(RawBuffer buf, Format fmt) {
        import gfx.core.util : unsafeCast;
        assert(buf.pinned);
        _buf = unsafeCast!GlBuffer(buf.res);

        _internalFormat = formatToGlInternalFormat(fmt);
        glGenTextures(1, &_texName);
        glBindTexture(GL_TEXTURE_BUFFER, _texName);
        glTexBuffer(GL_TEXTURE_BUFFER, _internalFormat, _buf.name);
    }

    void drop() {
        _buf.unload();
        glDeleteBuffers(1, &_texName);
    }

    final void bind() {
        glBindTexture(GL_TEXTURE_BUFFER, _texName);
    }

    final override @property GLenum target() const {
        return GL_TEXTURE_BUFFER;
    }
}

class GlTextureShaderResourceView : GlShaderResourceView {

    Rc!GlTexture _tex;

    this(RawTexture tex, Factory.TexSRVCreationDesc desc) {
        import gfx.core.util : unsafeCast;
        assert(tex.pinned);
        _tex = unsafeCast!GlTexture(tex.res);
    }

    void drop() {
        _tex.unload();
    }

    final void bind() {
        _tex.bind();
    }

    final override @property GLenum target() const {
        return _tex.target;
    }
}



abstract class GlTargetView : RenderTargetViewRes, DepthStencilViewRes {
    mixin(rcCode);

    void bind(GLenum point, GLenum attachment);
}

class GlTextureTargetView : GlTargetView {
    Rc!RawTexture _tex;
    ubyte _level;
    Option!ubyte _layer;

    this(RawTexture tex, Factory.TexRTVCreationDesc desc) {
        _tex = tex;
        _level = desc.level;
        _layer = desc.layer;
    }

    this(RawTexture tex, Factory.TexDSVCreationDesc desc) {
        _tex = tex;
        _level = desc.level;
        _layer = desc.layer;
    }

    void drop() {
        _tex.unload();
    }

    override void bind(GLenum point, GLenum attachment) {
        import gfx.backend.gl3.texture : GlTexture;
        import gfx.core.util : unsafeCast;
        immutable name = unsafeCast!GlTexture(_tex.res).name;
        if (_layer.isSome) {
            glFramebufferTextureLayer(point, attachment, name, _level, _layer.get());
        }
        else {
            glFramebufferTexture(point, attachment, name, _level);
        }
    }
}


class GlSurfaceTargetView : GlTargetView {
    Rc!RawSurface _surf;

    this(RawSurface surf) {
        _surf = surf;
    }

    void drop() {
        _surf.unload();
    }

    override void bind(GLenum point, GLenum attachment) {
        import gfx.backend.gl3.texture : GlSurface;
        import gfx.core.util : unsafeCast;
        immutable name = unsafeCast!GlSurface(_surf.res).name;
        glFramebufferRenderbuffer(point, attachment, GL_RENDERBUFFER, name);
    }
}