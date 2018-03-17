module gfx.gl3.conv;

package:

import gfx.bindings.opengl.gl;
import gfx.graal.buffer : BufferUsage;
import gfx.graal.format : Format;
import gfx.graal.image : ImageType;

GLenum toGl(in BufferUsage usage) pure {
    switch (usage) {
    case BufferUsage.transferSrc: return GL_COPY_READ_BUFFER;
    case BufferUsage.transferDst: return GL_COPY_WRITE_BUFFER;
    case BufferUsage.uniform: return GL_UNIFORM_BUFFER;
    case BufferUsage.index: return GL_ELEMENT_ARRAY_BUFFER;
    case BufferUsage.vertex: return GL_ARRAY_BUFFER;
    case BufferUsage.indirect: return GL_DRAW_INDIRECT_BUFFER;
    default: return 0;
    }
}

GLenum toGlTexTarget(in ImageType type, in bool ms) pure {
    final switch (type) {
    case ImageType.d1:          return GL_TEXTURE_1D;
    case ImageType.d1Array:     return GL_TEXTURE_1D_ARRAY;
    case ImageType.d2:
        return ms ? GL_TEXTURE_2D_MULTISAMPLE : GL_TEXTURE_2D;
    case ImageType.d2Array:
        return ms ? GL_TEXTURE_2D_MULTISAMPLE_ARRAY : GL_TEXTURE_2D_ARRAY;
    case ImageType.d3:          return GL_TEXTURE_3D;
    case ImageType.cube:        return GL_TEXTURE_CUBE_MAP;
    case ImageType.cubeArray:   return GL_TEXTURE_CUBE_MAP_ARRAY;
    }
}

GLenum toGlImgFmt(in Format graalFormat) pure {
    switch (graalFormat) {
    case Format.r8_uNorm:       return GL_R8;
    case Format.rg8_uNorm:      return GL_RG8;
    case Format.rgba8_uNorm:    return GL_RGBA8;
    case Format.r8_sInt:        return GL_R8I;
    case Format.rg8_sInt:       return GL_RG8I;
    case Format.rgba8_sInt:     return GL_RGBA8I;
    case Format.r8_uInt:        return GL_R8UI;
    case Format.rg8_uInt:       return GL_RG8UI;
    case Format.rgba8_uInt:     return GL_RGBA8UI;
    case Format.r16_uNorm:      return GL_R16;
    case Format.rg16_uNorm:     return GL_RG16;
    case Format.rgba16_uNorm:   return GL_RGBA16;
    case Format.r16_sInt:       return GL_R16I;
    case Format.rg16_sInt:      return GL_RG16I;
    case Format.rgba16_sInt:    return GL_RGBA16I;
    case Format.r16_uInt:       return GL_R16UI;
    case Format.rg16_uInt:      return GL_RG16UI;
    case Format.rgba16_uInt:    return GL_RGBA16UI;
    case Format.d16_uNorm:      return GL_DEPTH_COMPONENT16;
    case Format.x8d24_uNorm:    return GL_DEPTH_COMPONENT24;
    case Format.d32_sFloat:     return GL_DEPTH_COMPONENT32F;
    case Format.d24s8_uNorm:    return GL_DEPTH24_STENCIL8;
    case Format.s8_uInt:        return GL_STENCIL_INDEX8;
    default:
        import std.format : format;
        throw new Exception(format("Gfx-GL3: Format.%s is not supported.", graalFormat));
    }
}
