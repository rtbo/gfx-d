module gfx.backend.gl3.texture;

import gfx.backend.gl3;
import gfx.core.rc;
import gfx.core.format;
import gfx.core.texture;
import gfx.core.context;
import gfx.core.error;


import derelict.opengl3.gl3;

import std.typecons : Tuple;


package TextureRes makeTextureImpl(Context.TextureCreationDesc desc, bool hasStorage, const(ubyte)[][] data) {

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
            import std.exception : enforce;
            enforce(hasStorage, "opengl backend needs GL_ARB_texture_storage extension to instantiate cube arrays");
            return new GlTextureCubeArray(desc.format, desc.imgInfo.levels, desc.imgInfo.width, desc.imgInfo.numSlices);
        }
    }
    auto res = makeType();

    if (data.length != 0) {
        int numSlices = 1;
        switch(desc.type) {
        case TextureType.D1Array: 
            numSlices = desc.imgInfo.height;
            break;
        case TextureType.D2Array:
            numSlices = desc.imgInfo.depth;
            break;
        default: break;
        }
    }

    return res;
}

abstract class GlTexture : TextureRes {
    mixin RcCode!();

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

    void drop() {
        glDeleteTextures(1, &_name);
    }
    void bind() {
        glBindTexture(_target, _name);
    }

    void update(ImageSliceInfo slice, const(ubyte)[] data) {}
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
            void doFace(GLenum face) {
                glTexImage2D(face, 0, _internalFormat, _dim, _dim, 0, _format, _type, null);
            }
            doFace(GL_TEXTURE_CUBE_MAP_POSITIVE_X);
            doFace(GL_TEXTURE_CUBE_MAP_POSITIVE_Y);
            doFace(GL_TEXTURE_CUBE_MAP_POSITIVE_Z);
            doFace(GL_TEXTURE_CUBE_MAP_NEGATIVE_X);
            doFace(GL_TEXTURE_CUBE_MAP_NEGATIVE_Y);
            doFace(GL_TEXTURE_CUBE_MAP_NEGATIVE_Z);
        }
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



private GLenum textureTypeToGlTarget(in TextureType type) {
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

private GLenum formatToGlInternalFormat(in Format format) {
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


private GLenum formatToGlFormat(in Format format) {
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

private GLenum formatToGlType(in Format format) {
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