module gfx.backend.gl3.texture;

import gfx.backend.gl3.buffer : GlBuffer;
import gfx.backend.gl3.view : GlShaderResourceView;
import gfx.core : Size;
import gfx.core.rc : Rc, rcCode;
import gfx.core.format : Format, SurfaceType, ChannelType;
import gfx.core.texture;
import gfx.core.surface : SurfaceRes, BuiltinSurfaceRes;
import gfx.core.buffer : RawBuffer;
import gfx.core.view : ShaderResourceViewRes;
import gfx.core.factory : Factory;
import gfx.core.error;


import derelict.opengl3.gl3;

import std.typecons : Tuple, Flag;
import std.experimental.logger;


GLenum[2] filterToGl(FilterMethod filter) {
    final switch (filter) {                     // minification                 // magnification
        case FilterMethod.Scale:        return [ GL_NEAREST,                    GL_NEAREST];
        case FilterMethod.Mipmap:       return [ GL_NEAREST_MIPMAP_NEAREST,     GL_NEAREST];
        case FilterMethod.Bilinear:     return [ GL_LINEAR_MIPMAP_NEAREST,      GL_LINEAR];
        case FilterMethod.Trilinear:    return [ GL_LINEAR_MIPMAP_LINEAR,       GL_LINEAR];
        case FilterMethod.Anisotropic:  return [ GL_LINEAR_MIPMAP_LINEAR,       GL_LINEAR];
    }
}

GLenum wrapToGl(WrapMode wrap) {
    final switch (wrap) {
        case WrapMode.Tile:     return GL_REPEAT;
        case WrapMode.Mirror:   return GL_MIRRORED_REPEAT;
        case WrapMode.Clamp:    return GL_CLAMP_TO_EDGE;
        case WrapMode.Border:   return GL_CLAMP_TO_BORDER;
    }
}


abstract class GlSampler : SamplerRes {
    mixin (rcCode);

    abstract void bind(ubyte slot);
}


class GlSamplerWithObj : GlSampler {
    GLuint _sampler;

    this(ShaderResourceViewRes, SamplerInfo info) {
        glGenSamplers(1, &_sampler);

        if (info.filter == FilterMethod.Anisotropic) {
            glSamplerParameteri(_sampler, GL_TEXTURE_MAX_ANISOTROPY_EXT, info.anisotropyMax);
        }
        immutable filter = filterToGl(info.filter);
        glSamplerParameteri(_sampler, GL_TEXTURE_MIN_FILTER, filter[0]);
        glSamplerParameteri(_sampler, GL_TEXTURE_MAG_FILTER, filter[1]);

        glSamplerParameteri(_sampler, GL_TEXTURE_WRAP_S, wrapToGl(info.wrapMode[0]));
        glSamplerParameteri(_sampler, GL_TEXTURE_WRAP_T, wrapToGl(info.wrapMode[1]));
        glSamplerParameteri(_sampler, GL_TEXTURE_WRAP_R, wrapToGl(info.wrapMode[2]));
        immutable border = cast(float[4])info.border;
        glSamplerParameterfv(_sampler, GL_TEXTURE_BORDER_COLOR, &border[0]);

        glSamplerParameterf(_sampler, GL_TEXTURE_LOD_BIAS, cast(float)info.lodBias);
        glSamplerParameterf(_sampler, GL_TEXTURE_MIN_LOD, cast(float)info.lodRange[0]);
        glSamplerParameterf(_sampler, GL_TEXTURE_MAX_LOD, cast(float)info.lodRange[1]);

        if (info.comparison.isSome) {
            import gfx.backend.gl3.command : comparisonToGl;
            glSamplerParameteri(_sampler, GL_TEXTURE_COMPARE_MODE, GL_COMPARE_REF_TO_TEXTURE);
            glSamplerParameteri(_sampler, GL_TEXTURE_COMPARE_FUNC, comparisonToGl(info.comparison));
        }
        else {
            glSamplerParameteri(_sampler, GL_TEXTURE_COMPARE_MODE, GL_NONE);
        }
    }

    final void drop() {
        glDeleteSamplers(1, &_sampler);
    }

    final override void bind(ubyte slot) {
        glBindSampler(slot, _sampler);
    }
}


class GlSamplerWithoutObj : GlSampler {
    SamplerInfo _info;
    GLenum _target;

    this(ShaderResourceViewRes srv, SamplerInfo info) {
        import gfx.core.util : unsafeCast;
        _info = info;
        _target = unsafeCast!GlShaderResourceView(srv).target;
    }
    final void drop() {}
    final override void bind(ubyte) {
        if (_info.filter == FilterMethod.Anisotropic) {
            glTexParameteri(_target, GL_TEXTURE_MAX_ANISOTROPY_EXT, _info.anisotropyMax);
        }
        immutable filter = filterToGl(_info.filter);
        glTexParameteri(_target, GL_TEXTURE_MIN_FILTER, filter[0]);
        glTexParameteri(_target, GL_TEXTURE_MAG_FILTER, filter[1]);

        glTexParameteri(_target, GL_TEXTURE_WRAP_S, wrapToGl(_info.wrapMode[0]));
        glTexParameteri(_target, GL_TEXTURE_WRAP_T, wrapToGl(_info.wrapMode[1]));
        glTexParameteri(_target, GL_TEXTURE_WRAP_R, wrapToGl(_info.wrapMode[2]));
        //immutable border = cast(float[4])_info.border;
        //glTexParameterfv(_target, GL_TEXTURE_BORDER_COLOR, &border[0]);

        //glTexParameterf(_target, GL_TEXTURE_LOD_BIAS, cast(float)_info.lodBias);
        glTexParameterf(_target, GL_TEXTURE_MIN_LOD, cast(float)_info.lodRange[0]);
        glTexParameterf(_target, GL_TEXTURE_MAX_LOD, cast(float)_info.lodRange[1]);

        if (_info.comparison.isSome) {
            import gfx.backend.gl3.command : comparisonToGl;
            glTexParameteri(_target, GL_TEXTURE_COMPARE_MODE, GL_COMPARE_REF_TO_TEXTURE);
            glTexParameteri(_target, GL_TEXTURE_COMPARE_FUNC, comparisonToGl(_info.comparison));
        }
        else {
            glTexParameteri(_target, GL_TEXTURE_COMPARE_MODE, GL_NONE);
        }
    }
}




package TextureRes makeTextureImpl(in bool hasStorage, Factory.TextureCreationDesc desc, const(ubyte)[][] data) {

    import std.exception : enforce;

    GlTexture makeHasStorage(alias GlTexType, Args...)(Args args) {
        if(hasStorage) return new GlTexType!true(desc.type, desc.format, args);
        else return new GlTexType!false(desc.type, desc.format, args);
    }
    GlTexture makeType() {
        final switch(desc.type) {
        case TextureType.D1:
            return makeHasStorage!GlTexture1D(desc.imgInfo.levels, desc.imgInfo.width);
        case TextureType.D1Array:
            return makeHasStorage!GlTexture2D(desc.imgInfo.levels, desc.imgInfo.width, desc.imgInfo.numSlices);
        case TextureType.D2:
            return makeHasStorage!GlTexture2D(desc.imgInfo.levels, desc.imgInfo.width, desc.imgInfo.height);
        case TextureType.D2Array:
            return makeHasStorage!GlTexture3D(desc.imgInfo.levels, desc.imgInfo.width, desc.imgInfo.height, desc.imgInfo.numSlices);
        case TextureType.D3:
            return makeHasStorage!GlTexture3D(desc.imgInfo.levels, desc.imgInfo.width, desc.imgInfo.height, desc.imgInfo.depth);
        case TextureType.D2Multisample:
            return makeHasStorage!GlTexture2DMultisample(desc.samples, true, desc.imgInfo.width, desc.imgInfo.height);
        case TextureType.D2ArrayMultisample:
            return makeHasStorage!GlTexture3DMultisample(desc.samples, true, desc.imgInfo.width, desc.imgInfo.height, desc.imgInfo.numSlices);
        case TextureType.Cube:
            if (hasStorage) {
                return new GlTextureCube!true(desc.format, desc.imgInfo.levels, desc.imgInfo.width);
            }
            else {
                return new GlTextureCube!false(desc.format, desc.imgInfo.levels, desc.imgInfo.width);
            }
        case TextureType.CubeArray:
            enforce(hasStorage, "opengl backend needs GL_ARB_texture_storage extension to instantiate cube arrays");
            return new GlTextureCubeArray(desc.format, desc.imgInfo.levels, desc.imgInfo.width, desc.imgInfo.numSlices);
        }
    }
    auto res = makeType();

    // data initialization
    if (data.length != 0) {
        immutable slices = desc.imgInfo.numSlices;
        immutable mips = desc.imgInfo.levels;
        immutable cube = desc.type.isCube();
        immutable faces = cube ? 6 : 1;

        enforce(data.length == slices * mips * faces, "incorrect texture initialization data");

        foreach(sl; 0..slices) {
            foreach(ubyte f; 0..faces) {
                foreach(ubyte m; 0..mips) {
                    auto imgData = data[(sl * faces + f) * mips + m];
                    auto sliceInfo = desc.imgInfo.levelSliceInfo(m);
                    switch(desc.type) {
                    case TextureType.D1Array:
                        assert(sliceInfo.height == 1);
                        sliceInfo.yoffset = cast(ushort)sl;
                        break;
                    case TextureType.D2Array:
                    case TextureType.CubeArray:
                        assert(sliceInfo.depth == 1);
                        sliceInfo.zoffset = cast(ushort)sl;
                        break;
                    default:
                        break;
                    }
                    if(cube) {
                        sliceInfo.face = cubeFaces[f];
                    }
                    res.update(sliceInfo, imgData);
                }
            }
        }
    }

    return res;
}


class GlSurface : SurfaceRes {
    mixin(rcCode);

    GLuint _name;
    GLenum _internalFormat;
    GLsizei _width;
    GLsizei _height;
    GLsizei _samples;

    /// constructor for regular surface
    this(Factory.SurfaceCreationDesc desc) {
        _internalFormat = formatToGlInternalFormat(desc.format);
        _width = desc.size.w;
        _height = desc.size.h;
        _samples = desc.samples;

        glGenRenderbuffers(1, &_name);
        glBindRenderbuffer(GL_RENDERBUFFER, _name);
        if (samples <= 1) {
            glRenderbufferStorage(GL_RENDERBUFFER, _internalFormat, _width, _height);
        }
        else {
            glRenderbufferStorageMultisample(GL_RENDERBUFFER, samples, _internalFormat, _width, _height);
        }
    }

    /// constructor for builtin surface
    private this(Flag!"builtin") {}

    void drop() {
        glDeleteRenderbuffers(1, &_name);
    }

    void bind() {
        glBindRenderbuffer(GL_RENDERBUFFER, _name);
    }

    final @property GLuint name() const { return _name; }
    final @property GLsizei width() const { return _width; }
    final @property GLsizei height() const { return _height; }
    final @property GLsizei samples() const { return _samples; }
}


class GlBuiltinSurface : GlSurface, BuiltinSurfaceRes {

    this() {
        import std.typecons : Yes;
        super(Yes.builtin);
    }

    final override void drop() {}
    final override void bind() {}

    final void updateSize(Size s) {
        _width = s.w;
        _height = s.h;
    }

}



abstract class GlTexture : TextureRes {
    mixin(rcCode);

    GLuint _name;
    GLenum _target;
    GLenum _internalFormat;
    GLenum _format;
    GLenum _type;

    this(TextureType type, Format format) {
        _target = textureTypeToGlTarget(type);
        _internalFormat = formatToGlInternalFormat(format);
        _format = formatToGlFormat(format);
        _type = formatToGlType(format);
        glGenTextures(1, &_name);
    }

    final void drop() {
        glDeleteTextures(1, &_name);
    }
    final void bind() {
        glBindTexture(_target, _name);
    }

    final @property GLuint name() const { return _name; }
    final @property GLenum target() const { return _target; }
}


class GlTexture1D(bool UseStorage) : GlTexture {
    GLsizei _dim;
    GLsizei _levels;

    this(TextureType type, Format format, ubyte levels, ushort dim) {
        super(type, format);
        bind();

        _dim = dim;
        import std.algorithm : min;
        _levels = min(levels, mipmaps(_dim));

        static if(UseStorage) {
            glTexStorage1D(_target, _levels, _internalFormat, _dim);
        }
        else {
            glTexImage1D(_target, 0, _internalFormat, _dim, 0, _format, _type, null);
        }
    }

    final void update(in ImageSliceInfo slice, const(ubyte)[] data) {
        bind();
        glTexSubImage1D(_target, slice.level, slice.xoffset, slice.width,
                _format, _type, cast(const(GLvoid)*)data.ptr);
    }
}


class GlTexture2D(bool UseStorage) : GlTexture {
    GLsizei[2] _dims;
    GLsizei _levels;

    this(TextureType type, Format format, ubyte levels, ushort dim1, ushort dim2) {
        super(type, format);
        bind();

        _dims[0] = dim1;
        _dims[1] = dim2;
        import std.algorithm : min;
        _levels = min(levels, mipmaps(_dims[0], _dims[1]));

        static if(UseStorage) {
            glTexStorage2D(_target, _levels, _internalFormat, _dims[0], _dims[1]);
        }
        else {
            glTexImage2D(_target, 0, _internalFormat, _dims[0], _dims[1], 0, _format, _type, null);
        }
    }

    final void update(in ImageSliceInfo slice, const(ubyte)[] data) {
        bind();
        glTexSubImage2D(_target, slice.level,
                slice.xoffset, slice.yoffset,
                slice.width, slice.height,
                _format, _type, cast(const(GLvoid)*)data.ptr);
    }
}


class GlTexture2DMultisample(bool UseStorage) : GlTexture {
    GLsizei[2] _dims;
    GLsizei _samples;

    this(TextureType type, Format format, ubyte samples, bool fixedLoc, ushort dim1, ushort dim2) {
        super(type, format);
        bind();

        _dims[0] = dim1;
        _dims[1] = dim2;
        _samples = samples;

        static if(UseStorage) {
            glTexStorage2DMultisample(_target, _samples, _internalFormat,
                    _dims[0], _dims[1], fixedLoc);
        }
        else {
            glTexImage2DMultisample(_target, _samples, _internalFormat,
                    _dims[0], _dims[1], fixedLoc);
        }
    }

    final void update(in ImageSliceInfo slice, const(ubyte)[] data) {
        warningf("ignoring attempt to upload data to Multisample Texture");
    }
}


class GlTexture3D(bool UseStorage) : GlTexture {
    GLsizei[3] _dims;
    GLsizei _levels;

    this(TextureType type, Format format, ubyte levels, ushort dim1, ushort dim2, ushort dim3) {
        super(type, format);
        bind();

        _dims[0] = dim1;
        _dims[1] = dim2;
        _dims[2] = dim3;
        import std.algorithm : min;
        _levels = min(levels, mipmaps(_dims[0], _dims[1], _dims[2]));

        static if(UseStorage) {
            glTexStorage3D(_target, _levels, _internalFormat, _dims[0], _dims[1], _dims[2]);
        }
        else {
            glTexImage3D(_target, 0, _internalFormat, _dims[0], _dims[1], _dims[2], 0, _format, _type, null);
        }
    }

    final void update(in ImageSliceInfo slice, const(ubyte)[] data) {
        bind();
        glTexSubImage3D(_target, slice.level,
                slice.xoffset, slice.yoffset, slice.zoffset,
                slice.width, slice.height, slice.depth,
                _format, _type, cast(const(GLvoid)*)data.ptr);
    }
}


class GlTexture3DMultisample(bool UseStorage) : GlTexture {
    GLsizei[3] _dims;
    GLsizei _samples;

    this(TextureType type, Format format, ubyte samples, bool fixedLoc, ushort dim1, ushort dim2, ushort dim3) {
        super(type, format);
        bind();

        _dims[0] = dim1;
        _dims[1] = dim2;
        _dims[2] = dim3;
        _samples = samples;

        static if(UseStorage) {
            glTexStorage3DMultisample(_target, _samples, _internalFormat,
                    _dims[0], _dims[1], _dims[2], fixedLoc);
        }
        else {
            glTexImage3DMultisample(_target, _samples, _internalFormat,
                    _dims[0], _dims[1], _dims[2], fixedLoc);
        }
    }

    final void update(in ImageSliceInfo slice, const(ubyte)[] data) {
        warningf("ignoring attempt to upload data to Multisample Texture");
    }
}




immutable glCubeFaces = [
    GL_TEXTURE_CUBE_MAP_POSITIVE_X,
    GL_TEXTURE_CUBE_MAP_NEGATIVE_X,
    GL_TEXTURE_CUBE_MAP_POSITIVE_Y,
    GL_TEXTURE_CUBE_MAP_NEGATIVE_Y,
    GL_TEXTURE_CUBE_MAP_POSITIVE_Z,
    GL_TEXTURE_CUBE_MAP_NEGATIVE_Z,
];

GLenum faceToGl(in CubeFace face) {
    final switch(face) {
    case CubeFace.None: assert(false);
    case CubeFace.PosX: return GL_TEXTURE_CUBE_MAP_POSITIVE_X;
    case CubeFace.NegX: return GL_TEXTURE_CUBE_MAP_NEGATIVE_X;
    case CubeFace.PosY: return GL_TEXTURE_CUBE_MAP_POSITIVE_Y;
    case CubeFace.NegY: return GL_TEXTURE_CUBE_MAP_NEGATIVE_Y;
    case CubeFace.PosZ: return GL_TEXTURE_CUBE_MAP_POSITIVE_Z;
    case CubeFace.NegZ: return GL_TEXTURE_CUBE_MAP_NEGATIVE_Z;
    }
}

/// translate a face into the gl cube map array face index
int faceIndex(in CubeFace face)
in { assert(face != CubeFace.None); }
body { return cast(int)face -1; }

unittest {
    assert(faceIndex(CubeFace.PosX) == 0);
    assert(faceIndex(CubeFace.NegX) == 1);
    assert(faceIndex(CubeFace.PosY) == 2);
    assert(faceIndex(CubeFace.NegY) == 3);
    assert(faceIndex(CubeFace.PosZ) == 4);
    assert(faceIndex(CubeFace.NegZ) == 5);
}


class GlTextureCube(bool UseStorage) : GlTexture {
    GLsizei _dim;
    GLsizei _levels;

    this(Format format, ubyte levels, ushort dim) {
        super(TextureType.Cube, format);
        bind();
        _dim = dim;

        import std.algorithm : min;
        _levels = min(levels, mipmaps(_dim, _dim));

        static if(UseStorage) {
            glTexStorage2D(_target, _levels, _internalFormat, _dim, _dim);
        }
        else {
            foreach(face; glCubeFaces) {
                glTexImage2D(face, 0, _internalFormat, _dim, _dim, 0, _format, _type, null);
            }
        }
    }

    final void update(in ImageSliceInfo slice, const(ubyte)[] data) {
        bind();
        immutable face = faceToGl(slice.face);
        glTexSubImage2D(face, slice.level,
                slice.xoffset, slice.yoffset,
                slice.width, slice.height,
                _format, _type, cast(const(GLvoid)*)data.ptr);
    }
}

class GlTextureCubeArray : GlTexture {
    GLsizei _dim;
    GLsizei _slices;
    GLsizei _levels;

    this(Format format, ubyte levels, ushort dim, ushort slices) {
        super(TextureType.Cube, format);
        bind();
        _dim = dim;
        _slices = slices;

        import std.algorithm : min;
        _levels = min(levels, mipmaps(_dim, _dim));

        glTexStorage3D(_target, _levels, _internalFormat, _dim, _dim, _slices);

    }

    final void update(in ImageSliceInfo slice, const(ubyte)[] data) {
        bind();
        immutable face = faceToGl(slice.face);
        immutable zoffset = slice.zoffset*6 + faceIndex(slice.face);
        glTexSubImage3D(face, slice.level,
                slice.xoffset, slice.yoffset, zoffset,
                slice.width, slice.height, slice.depth,
                _format, _type, cast(const(GLvoid)*)data.ptr);
    }
}



GLsizei mipmaps(GLsizei w) {
    import std.math : log2;
    return cast(GLsizei)(log2(w) + 1);
}

GLsizei mipmaps(GLsizei w, GLsizei h) {
    import std.algorithm : max;
    return mipmaps(max(w, h));
}

GLsizei mipmaps(GLsizei w, GLsizei h, GLsizei d) {
    import std.algorithm : max;
    return mipmaps(max(w, h, d));
}



package GLenum textureTypeToGlTarget(in TextureType type) {
    final switch(type) {
    case TextureType.D1:                    return GL_TEXTURE_1D;
    case TextureType.D1Array:               return GL_TEXTURE_1D_ARRAY;
    case TextureType.D2:                    return GL_TEXTURE_2D;
    case TextureType.D2Array:               return GL_TEXTURE_2D_ARRAY;
    case TextureType.D2Multisample:         return GL_TEXTURE_2D_MULTISAMPLE;
    case TextureType.D2ArrayMultisample:    return GL_TEXTURE_2D_MULTISAMPLE_ARRAY;
    case TextureType.D3:                    return GL_TEXTURE_3D;
    case TextureType.Cube:                  return GL_TEXTURE_CUBE_MAP;
    case TextureType.CubeArray:             return GL_TEXTURE_CUBE_MAP_ARRAY;
    }
}

package GLenum formatToGlInternalFormat(in Format format) {
    import std.typecons : tuple;
    alias S = SurfaceType;
    alias C = ChannelType;
    enum GL_RGB565 = 0x8D62; // apparently not defined in derelict

    immutable ch = format.channel;

    switch(format.surface) {
    case S.R4_G4_B4_A4:
        if (ch == C.Unorm) return GL_RGBA4;
        break;
    case S.R5_G5_B5_A1:
        if (ch == C.Unorm) return GL_RGB5_A1;
        break;
    case S.R5_G6_B5:
        if (ch == C.Unorm) return GL_RGB565;
        break;
    case S.R8:
        switch (ch) {
            case C.Int: return GL_R8I;
            case C.Uint: return GL_R8UI;
            case C.Inorm: return GL_R8_SNORM;
            case C.Unorm: return GL_R8;
            default: break;
        }
        break;
    case S.R8_G8:
        switch (ch) {
            case C.Int: return GL_RG8I;
            case C.Uint: return GL_RG8UI;
            case C.Inorm: return GL_RG8_SNORM;
            case C.Unorm: return GL_RG8;
            default: break;
        }
        break;
    case S.R8_G8_B8_A8:
        switch (ch) {
            case C.Int: return GL_RGBA8I;
            case C.Uint: return GL_RGBA8UI;
            case C.Inorm: return GL_RGBA8_SNORM;
            case C.Unorm: return GL_RGBA8;
            case C.Srgb: return GL_SRGB8_ALPHA8;
            default: break;
        }
        break;
    case S.R10_G10_B10_A2:
        switch (ch) {
            case C.Uint: return GL_RGB10_A2UI;
            case C.Unorm: return GL_RGB10_A2;
            default: break;
        }
        break;
    case S.R11_G11_B10:
        if (ch == C.Float) return GL_R11F_G11F_B10F;
        break;
    case S.R16:
        switch (ch) {
            case C.Int: return GL_R16I;
            case C.Uint: return GL_R16UI;
            case C.Float: return GL_R16F;
            default: break;
        }
        break;
    case S.R16_G16:
        switch (ch) {
            case C.Int: return GL_RG16I;
            case C.Uint: return GL_RG16UI;
            case C.Float: return GL_RG16F;
            default: break;
        }
        break;
    case S.R16_G16_B16:
        switch (ch) {
            case C.Int: return GL_RGB16I;
            case C.Uint: return GL_RGB16UI;
            case C.Float: return GL_RGB16F;
            default: break;
        }
        break;
    case S.R16_G16_B16_A16:
        switch (ch) {
            case C.Int: return GL_RGBA16I;
            case C.Uint: return GL_RGBA16UI;
            case C.Float: return GL_RGBA16F;
            default: break;
        }
        break;
    case S.R32:
        switch (ch) {
            case C.Int: return GL_R32I;
            case C.Uint: return GL_R32UI;
            case C.Float: return GL_R32F;
            default: break;
        }
        break;
    case S.R32_G32:
        switch (ch) {
            case C.Int: return GL_RG32I;
            case C.Uint: return GL_RG32UI;
            case C.Float: return GL_RG32F;
            default: break;
        }
        break;
    case S.R32_G32_B32:
        switch (ch) {
            case C.Int: return GL_RGB32I;
            case C.Uint: return GL_RGB32UI;
            case C.Float: return GL_RGB32F;
            default: break;
        }
        break;
    case S.R32_G32_B32_A32:
        switch (ch) {
            case C.Int: return GL_RGBA32I;
            case C.Uint: return GL_RGBA32UI;
            case C.Float: return GL_RGBA32F;
            default: break;
        }
        break;
    case S.D16:     return GL_DEPTH_COMPONENT16;
    case S.D24:     return GL_DEPTH_COMPONENT24;
    case S.D24_S8:  return GL_DEPTH24_STENCIL8;
    case S.D32:     return GL_DEPTH_COMPONENT32F;
    default:        break;
    }

    throw new FormatTextureCreationError(format.surface, ch);
}


package GLenum formatToGlFormat(in Format format) {
    GLenum r() {
        switch(format.channel) {
        case ChannelType.Int:
        case ChannelType.Uint:
            return GL_RED_INTEGER;
        default:
            return GL_RED;
        }
    }
    GLenum rg() {
        switch(format.channel) {
        case ChannelType.Int:
        case ChannelType.Uint:
            return GL_RG_INTEGER;
        default:
            return GL_RG;
        }
    }
    GLenum rgb() {
        switch(format.channel) {
        case ChannelType.Int:
        case ChannelType.Uint:
            return GL_RGB_INTEGER;
        default:
            return GL_RGB;
        }
    }
    GLenum rgba() {
        switch(format.channel) {
        case ChannelType.Int:
        case ChannelType.Uint:
            return GL_RGBA_INTEGER;
        default:
            return GL_RGBA;
        }
    }

    final switch(format.surface) {
        case SurfaceType.R8:
        case SurfaceType.R16:
        case SurfaceType.R32:
            return r();
        case SurfaceType.R4_G4:
        case SurfaceType.R8_G8:
        case SurfaceType.R16_G16:
        case SurfaceType.R32_G32:
            return rg();
        case SurfaceType.R5_G6_B5:
        case SurfaceType.R11_G11_B10:
        case SurfaceType.R16_G16_B16:
        case SurfaceType.R32_G32_B32:
            return rgb();
        case SurfaceType.R4_G4_B4_A4:
        case SurfaceType.R5_G5_B5_A1:
        case SurfaceType.R8_G8_B8_A8:
        case SurfaceType.R10_G10_B10_A2:
        case SurfaceType.R16_G16_B16_A16:
        case SurfaceType.R32_G32_B32_A32:
            return rgba();
        case SurfaceType.D16:
        case SurfaceType.D24:
        case SurfaceType.D32:
            return GL_DEPTH;
        case SurfaceType.D24_S8:
            return GL_DEPTH_STENCIL;
    }
}

package GLenum formatToGlType(in Format format) {
    GLenum t8() {
        switch(format.channel) {
            case ChannelType.Int:
            case ChannelType.Inorm:
                return GL_BYTE;
            case ChannelType.Uint:
            case ChannelType.Unorm:
            case ChannelType.Srgb:
                return GL_UNSIGNED_BYTE;
            default:
                throw new FormatTextureCreationError(format.surface, format.channel);
        }
    }
    GLenum t16() {
        final switch(format.channel) {
            case ChannelType.Int:
            case ChannelType.Inorm:
                return GL_SHORT;
            case ChannelType.Uint:
            case ChannelType.Unorm:
            case ChannelType.Srgb:
                return GL_UNSIGNED_SHORT;
            case ChannelType.Float:
                return GL_HALF_FLOAT;
        }
    }
    GLenum t32() {
        final switch(format.channel) {
            case ChannelType.Int:
            case ChannelType.Inorm:
                return GL_INT;
            case ChannelType.Uint:
            case ChannelType.Unorm:
            case ChannelType.Srgb:
                return GL_UNSIGNED_INT;
            case ChannelType.Float:
                return GL_FLOAT;
        }
    }
    switch(format.surface) {
        case SurfaceType.R8:
        case SurfaceType.R8_G8:
        case SurfaceType.R8_G8_B8_A8:
            return t8();
        case SurfaceType.R16:
        case SurfaceType.R16_G16:
        case SurfaceType.R16_G16_B16:
        case SurfaceType.R16_G16_B16_A16:
            return t16();
        case SurfaceType.R32:
        case SurfaceType.R32_G32:
        case SurfaceType.R32_G32_B32:
        case SurfaceType.R32_G32_B32_A32:
            return t32();
        //case SurfaceType.R4_G4:
        case SurfaceType.R4_G4_B4_A4:
            return GL_UNSIGNED_SHORT_4_4_4_4;
        case SurfaceType.R5_G5_B5_A1:
            return GL_UNSIGNED_SHORT_4_4_4_4;
        case SurfaceType.R5_G6_B5:
            return GL_UNSIGNED_SHORT_5_6_5;
        case SurfaceType.R10_G10_B10_A2:
            return GL_UNSIGNED_INT_10_10_10_2;
        case SurfaceType.D16:
            return GL_UNSIGNED_SHORT;
        case SurfaceType.D24:
            return GL_UNSIGNED_INT;
        case SurfaceType.D24_S8:
            return GL_UNSIGNED_INT_24_8;
        case SurfaceType.D32:
            return GL_FLOAT;
        default:
            throw new FormatTextureCreationError(format.surface, format.channel);
    }
}