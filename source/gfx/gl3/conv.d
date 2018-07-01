module gfx.gl3.conv;

package:

import gfx.bindings.opengl.gl;
import gfx.graal.buffer : BufferUsage, IndexType;
import gfx.graal.format : Format;
import gfx.graal.image : CompSwizzle, Filter, ImageType, Swizzle, WrapMode;
import gfx.graal.pipeline : BlendOp, BlendFactor, CompareOp, FrontFace,
                            PolygonMode, Primitive, ShaderStage, StencilOp;

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

GLenum toSubImgFmt(in Format graalFormat) pure {
    switch(graalFormat) {
    case Format.r8_uNorm:       return GL_RED;
    case Format.rg8_uNorm:      return GL_RG;
    case Format.rgba8_uNorm:    return GL_RGBA;
    case Format.r8_sInt:        return GL_RED;
    case Format.rg8_sInt:       return GL_RG;
    case Format.rgba8_sInt:     return GL_RGBA;
    case Format.r8_uInt:        return GL_RED;
    case Format.rg8_uInt:       return GL_RG;
    case Format.rgba8_uInt:     return GL_RGBA;
    case Format.r16_uNorm:      return GL_RED;
    case Format.rg16_uNorm:     return GL_RG;
    case Format.rgba16_uNorm:   return GL_RGBA;
    case Format.r16_sInt:       return GL_RED;
    case Format.rg16_sInt:      return GL_RG;
    case Format.rgba16_sInt:    return GL_RGBA;
    case Format.r16_uInt:       return GL_RED;
    case Format.rg16_uInt:      return GL_RG;
    case Format.rgba16_uInt:    return GL_RGBA;
    case Format.d16_uNorm:      return GL_DEPTH_COMPONENT;
    case Format.x8d24_uNorm:    return GL_DEPTH_COMPONENT;
    case Format.d32_sFloat:     return GL_DEPTH_COMPONENT;
    case Format.d24s8_uNorm:    return GL_DEPTH_COMPONENT;
    case Format.s8_uInt:        return GL_STENCIL_INDEX;
    default:
        import std.format : format;
        throw new Exception(format("Gfx-GL3: Format.%s is not supported.", graalFormat));
    }
}

GLenum toSubImgType(in Format graalFormat) pure {
    switch(graalFormat) {
    case Format.r8_uNorm:
    case Format.rg8_uNorm:
    case Format.rgba8_uNorm:
    case Format.r8_sInt:
    case Format.rg8_sInt:
    case Format.rgba8_sInt:
    case Format.r8_uInt:
    case Format.rg8_uInt:
    case Format.rgba8_uInt:
        return GL_UNSIGNED_BYTE;
    case Format.r16_uNorm:
    case Format.rg16_uNorm:
    case Format.rgba16_uNorm:
    case Format.r16_sInt:
    case Format.rg16_sInt:
    case Format.rgba16_sInt:
    case Format.r16_uInt:
    case Format.rg16_uInt:
    case Format.rgba16_uInt:
    case Format.d16_uNorm:
        return GL_UNSIGNED_SHORT;
    case Format.x8d24_uNorm:
        return GL_UNSIGNED_INT;
    case Format.d32_sFloat:
        return GL_FLOAT;
    case Format.d24s8_uNorm:
        return GL_UNSIGNED_INT;
    case Format.s8_uInt:
        return GL_UNSIGNED_BYTE;
    default:
        import std.format : format;
        throw new Exception(format("Gfx-GL3: Format.%s is not supported.", graalFormat));
    }
}

GLenum toGlMag(in Filter filter) pure {
    final switch(filter) {
    case Filter.nearest: return GL_NEAREST;
    case Filter.linear: return GL_LINEAR;
    }
}
GLenum toGlMin(in Filter filter, in Filter mipmap) pure {
    final switch(filter) {
    case Filter.nearest:
        final switch (mipmap) {
        case Filter.nearest:    return GL_NEAREST_MIPMAP_NEAREST;
        case Filter.linear:     return GL_NEAREST_MIPMAP_LINEAR;
        }
    case Filter.linear:
        final switch (mipmap) {
        case Filter.nearest:    return GL_LINEAR_MIPMAP_NEAREST;
        case Filter.linear:     return GL_LINEAR_MIPMAP_LINEAR;
        }
    }
}
GLenum toGl(in WrapMode mode) pure {
    final switch (mode) {
    case WrapMode.repeat:       return GL_REPEAT;
    case WrapMode.mirrorRepeat: return GL_MIRRORED_REPEAT;
    case WrapMode.clamp:        return GL_CLAMP_TO_EDGE;
    case WrapMode.border:       return GL_CLAMP_TO_BORDER;
    }
}

GLenum toGl(in CompareOp op) pure {
    final switch (op) {
    case CompareOp.never:           return GL_NEVER;
    case CompareOp.less:            return GL_LESS;
    case CompareOp.equal:           return GL_EQUAL;
    case CompareOp.lessOrEqual:     return GL_LEQUAL;
    case CompareOp.greater:         return GL_GREATER;
    case CompareOp.notEqual:        return GL_NOTEQUAL;
    case CompareOp.greaterOrEqual:  return GL_GEQUAL;
    case CompareOp.always:          return GL_ALWAYS;
    }
}

GLenum toGl(in StencilOp op) pure {
    final switch (op) {
    case StencilOp.keep:                return GL_KEEP;
    case StencilOp.zero:                return GL_ZERO;
    case StencilOp.replace:             return GL_REPLACE;
    case StencilOp.incrementAndClamp:   return GL_INCR;
    case StencilOp.decrementAndClamp:   return GL_DECR;
    case StencilOp.invert:              return GL_INVERT;
    case StencilOp.incrementAndWrap:    return GL_INCR_WRAP;
    case StencilOp.decrementAndWrap:    return GL_DECR_WRAP;
    }
}

GLenum toGl(in ShaderStage stage) pure {
    switch (stage) {
    case ShaderStage.vertex:                    return GL_VERTEX_SHADER;
    case ShaderStage.tessellationControl:       return GL_TESS_CONTROL_SHADER;
    case ShaderStage.tessellationEvaluation:    return GL_TESS_EVALUATION_SHADER;
    case ShaderStage.geometry:                  return GL_GEOMETRY_SHADER;
    case ShaderStage.fragment:                  return GL_FRAGMENT_SHADER;
    case ShaderStage.compute:                   return GL_COMPUTE_SHADER;
    default: assert(false);
    }
}

GLenum toGl(in IndexType type) pure {
    final switch (type) {
    case IndexType.u16: return GL_UNSIGNED_SHORT;
    case IndexType.u32: return GL_UNSIGNED_INT;
    }
}

GLenum toGl(in Primitive primitive) pure {
    final switch (primitive) {
    case Primitive.pointList:               return GL_POINTS;
    case Primitive.lineList:                return GL_LINES;
    case Primitive.lineStrip:               return GL_LINE_STRIP;
    case Primitive.triangleList:            return GL_TRIANGLES;
    case Primitive.triangleStrip:           return GL_TRIANGLE_STRIP;
    case Primitive.triangleFan:             return GL_TRIANGLE_FAN;
    case Primitive.lineListAdjacency:       return GL_LINES_ADJACENCY;
    case Primitive.lineStripAdjacency:      return GL_LINE_STRIP_ADJACENCY;
    case Primitive.triangleListAdjacency:   return GL_TRIANGLES_ADJACENCY;
    case Primitive.triangleStripAdjacency:  return GL_TRIANGLE_STRIP_ADJACENCY;
    case Primitive.patchList:               return GL_PATCHES;
    }
}

GLenum toGl(in FrontFace ff) pure {
    final switch (ff) {
    case FrontFace.ccw: return GL_CCW;
    case FrontFace.cw:  return GL_CW;
    }
}

GLenum toGl(in PolygonMode pm) pure {
    final switch (pm) {
    case PolygonMode.point: return GL_POINT;
    case PolygonMode.line:  return GL_LINE;
    case PolygonMode.fill:  return GL_FILL;
    }
}

GLenum toGl(in BlendOp op) {
    final switch(op) {
        case BlendOp.add:               return GL_FUNC_ADD;
        case BlendOp.subtract:          return GL_FUNC_SUBTRACT;
        case BlendOp.reverseSubtract:   return GL_FUNC_REVERSE_SUBTRACT;
        case BlendOp.min:               return GL_MIN;
        case BlendOp.max:               return GL_MAX;
    }
}

GLenum toGl(in BlendFactor f) {
    final switch (f) {
        case BlendFactor.zero:                  return GL_ZERO;
        case BlendFactor.one:                   return GL_ONE;
        case BlendFactor.srcColor:              return GL_SRC_COLOR;
        case BlendFactor.oneMinusSrcColor:      return GL_ONE_MINUS_SRC_COLOR;
        case BlendFactor.dstColor:              return GL_DST_COLOR;
        case BlendFactor.oneMinusDstColor:      return GL_ONE_MINUS_DST_COLOR;
        case BlendFactor.srcAlpha:              return GL_SRC_ALPHA;
        case BlendFactor.oneMinusSrcAlpha:      return GL_ONE_MINUS_SRC_ALPHA;
        case BlendFactor.dstAlpha:              return GL_DST_ALPHA;
        case BlendFactor.oneMinusDstAlpha:      return GL_ONE_MINUS_DST_ALPHA;
        case BlendFactor.constantColor:         return GL_CONSTANT_COLOR;
        case BlendFactor.oneMinusConstantColor: return GL_ONE_MINUS_CONSTANT_COLOR;
        case BlendFactor.constantAlpha:         return GL_CONSTANT_ALPHA;
        case BlendFactor.oneMinusConstantAlpha: return GL_ONE_MINUS_CONSTANT_ALPHA;
        case BlendFactor.srcAlphaSaturate:      return GL_SRC_ALPHA_SATURATE;
        case BlendFactor.src1Color:             return GL_SRC1_COLOR;
        case BlendFactor.oneMinusSrc1Color:     return GL_ONE_MINUS_SRC1_COLOR;
        case BlendFactor.src1Alpha:             return GL_SRC1_ALPHA;
        case BlendFactor.oneMinusSrc1Alpha:     return GL_ONE_MINUS_SRC1_ALPHA;
    }
}

GLint toGl(in CompSwizzle cs)
{
    switch (cs)
    {
    case CompSwizzle.zero:  return GL_ZERO;
    case CompSwizzle.one:   return GL_ONE;
    case CompSwizzle.r:     return GL_RED;
    case CompSwizzle.g:     return GL_GREEN;
    case CompSwizzle.b:     return GL_BLUE;
    case CompSwizzle.a:     return GL_ALPHA;
    default: assert(false);
    }
}

GLint[4] toGl(in Swizzle swizzle)
{
    const GLint[4] glSw = [
        swizzle[0] == CompSwizzle.identity ? GL_RED : toGl(swizzle[0]),
        swizzle[1] == CompSwizzle.identity ? GL_GREEN : toGl(swizzle[1]),
        swizzle[2] == CompSwizzle.identity ? GL_BLUE : toGl(swizzle[2]),
        swizzle[3] == CompSwizzle.identity ? GL_ALPHA : toGl(swizzle[3]),
    ];
    return glSw;
}

bool vertexFormatSupported(in Format f) pure {
    import std.algorithm : canFind;
    return supportedVertexFormats.canFind(f);
}

/// Specifies the function to define the VAO vertex attribs
enum VAOAttribFun {
    /// glVertexAttribPointer
    f,
    /// glVertexAttribIPointer
    i,
    /// glVertexAttribLPointer
    d
}

struct GlVertexFormat {
    VAOAttribFun fun;
    GLint size;
    GLenum type;
    GLboolean normalized;
}

GlVertexFormat glVertexFormat(in Format f)
in {
    assert(vertexFormatSupported(f));
}
body {
    return glVertexFormats[cast(size_t)f];
}

private:

// TODO: support more formats (unorms, integer...)

immutable(GlVertexFormat[]) glVertexFormats;

immutable(Format[]) supportedVertexFormats = [
    Format.r32_sFloat,
    Format.rg32_sFloat,
    Format.rgb32_sFloat,
    Format.rgba32_sFloat,
];

shared static this() {
    import gfx.graal.format : formatDesc, numComponents;
    import std.algorithm : map, maxElement;
    import std.exception : assumeUnique;

    const len = 1 + supportedVertexFormats
            .map!(f => cast(int)f)
            .maxElement;
    auto vertexFormats = new GlVertexFormat[len];
    foreach (f; supportedVertexFormats) {
        const fd = formatDesc(f);
        const size = numComponents(fd.surfaceType);
        vertexFormats[cast(int)f] = GlVertexFormat(
            VAOAttribFun.f, size, GL_FLOAT, GL_FALSE
        );
    }

    glVertexFormats = assumeUnique(vertexFormats);
}
