module gfx.device.gl3.view;

import gfx.device.gl3.buffer : GlBuffer;
import gfx.device.gl3.texture : GlTexture, formatToGlInternalFormat;
import gfx.foundation.rc : Rc, gfxRcCode;
import gfx.foundation.typecons : Option;
import gfx.device.factory : Factory;
import gfx.pipeline.format : Format;
import gfx.pipeline.buffer : RawBuffer;
import gfx.pipeline.texture : RawTexture;
import gfx.pipeline.surface : RawSurface;
import gfx.pipeline.view : ShaderResourceViewRes, RenderTargetViewRes, DepthStencilViewRes;

import derelict.opengl3.gl3;


abstract class GlShaderResourceView : ShaderResourceViewRes {
    mixin(gfxRcCode);
    abstract @property GLenum target() const;
    abstract @property GLuint texName() const;
}

class GlBufferShaderResourceView : GlShaderResourceView {

    GLuint _texName;
    GLenum _internalFormat;
    Rc!GlBuffer _buf;

    this(RawBuffer buf, Format fmt) {
        import gfx.foundation.util : unsafeCast;
        assert(buf.pinned);
        _buf = unsafeCast!GlBuffer(buf.res);

        _internalFormat = formatToGlInternalFormat(fmt);
        glGenTextures(1, &_texName);
        glBindTexture(GL_TEXTURE_BUFFER, _texName);
        glTexBuffer(GL_TEXTURE_BUFFER, _internalFormat, _buf.name);
    }

    final void dispose() {
        _buf.unload();
        glDeleteBuffers(1, &_texName);
    }

    final void bind() {
        glBindTexture(GL_TEXTURE_BUFFER, _texName);
    }

    final override @property GLenum target() const {
        return GL_TEXTURE_BUFFER;
    }
    final override @property GLuint texName() const {
        return _texName;
    }
}

class GlTextureShaderResourceView : GlShaderResourceView {

    Rc!GlTexture _tex;

    this(RawTexture tex, Factory.TexSRVCreationDesc desc) {
        import gfx.foundation.util : unsafeCast;
        assert(tex.pinned);
        _tex = unsafeCast!GlTexture(tex.res);
    }

    final void dispose() {
        _tex.unload();
    }

    final void bind() {
        _tex.bind();
    }

    final override @property GLenum target() const {
        return _tex.target;
    }
    final override @property GLuint texName() const {
        return _tex.name;
    }
}



abstract class GlTargetView : RenderTargetViewRes, DepthStencilViewRes {
    mixin(gfxRcCode);

    abstract void bind(GLenum point, GLenum attachment);
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

    final void dispose() {
        _tex.unload();
    }

    final override void bind(GLenum point, GLenum attachment) {
        import gfx.device.gl3.texture : GlTexture;
        import gfx.foundation.util : unsafeCast;
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

    final void dispose() {
        _surf.unload();
    }

    final override void bind(GLenum point, GLenum attachment) {
        import gfx.device.gl3.texture : GlSurface;
        import gfx.foundation.util : unsafeCast;
        immutable name = unsafeCast!GlSurface(_surf.res).name;
        glFramebufferRenderbuffer(point, attachment, GL_RENDERBUFFER, name);
    }
}