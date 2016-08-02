module gfx.backend.gl3.state;

import gfx.core.typecons : Option;
import gfx.core.state :     Rasterizer, FrontFace, CullFace, RasterMethod, Offset,
                            Blend, BlendValue, Equation, Factor, ColorFlags;
import gfx.core.pso : ColorInfo;

import derelict.opengl3.gl3;


GLenum frontFaceToGl(in FrontFace ff) {
    final switch(ff) {
        case FrontFace.ClockWise: return GL_CW;
        case FrontFace.CounterClockWise: return GL_CCW;
    }
}

GLenum equationToGl(in Equation eq) {
    final switch(eq) {
        case Equation.Add:      return GL_FUNC_ADD;
        case Equation.Sub:      return GL_FUNC_SUBTRACT;
        case Equation.RevSub:   return GL_FUNC_REVERSE_SUBTRACT;
        case Equation.Min:      return GL_MIN;
        case Equation.Max:      return GL_MAX;
    }
}



GLenum factorToGl(in Factor f) {
    final switch (f.tag) {
        case Factor.Zero:                       return GL_ZERO;
        case Factor.One:                        return GL_ONE;
        case Factor.SourceAlphaSaturated:       return GL_SRC_ALPHA_SATURATE;
        case Factor.ZeroPlus:
            final switch (f.getZeroPlus()) {
                case BlendValue.SourceColor:    return GL_SRC_COLOR;
                case BlendValue.SourceAlpha:    return GL_SRC_ALPHA;
                case BlendValue.DestColor:      return GL_DST_COLOR;
                case BlendValue.DestAlpha:      return GL_DST_ALPHA;
                case BlendValue.ConstColor:     return GL_CONSTANT_COLOR;
                case BlendValue.ConstAlpha:     return GL_CONSTANT_ALPHA;
            }
        case Factor.OneMinus:
            final switch (f.getZeroPlus()) {
                case BlendValue.SourceColor:    return GL_ONE_MINUS_SRC_COLOR;
                case BlendValue.SourceAlpha:    return GL_ONE_MINUS_SRC_ALPHA;
                case BlendValue.DestColor:      return GL_ONE_MINUS_DST_COLOR;
                case BlendValue.DestAlpha:      return GL_ONE_MINUS_DST_ALPHA;
                case BlendValue.ConstColor:     return GL_ONE_MINUS_CONSTANT_COLOR;
                case BlendValue.ConstAlpha:     return GL_ONE_MINUS_CONSTANT_ALPHA;
            }
    }
}


void setRasterMethod(in RasterMethod method, in Option!Offset offset) {
    void doit(GLenum polygonMode, GLenum glOffset) {
        glPolygonMode(GL_FRONT_AND_BACK, polygonMode);
        if (offset.isNone) {
            glDisable(glOffset);
        }
        else {
            glPolygonOffset(offset.slope, offset.units);
            glEnable(glOffset);

        }
    }

    final switch(method.tag) {
        case RasterMethod.Point:
            doit(GL_POINT, GL_POLYGON_OFFSET_POINT);
            break;
        case RasterMethod.Line:
            glLineWidth(method.getLine());
            doit(GL_LINE, GL_POLYGON_OFFSET_LINE);
            break;
        case RasterMethod.Fill:
            doit(GL_FILL, GL_POLYGON_OFFSET_FILL);
            break;
    }
}

void setRasterizer(in Rasterizer rasterizer) {
    glFrontFace(frontFaceToGl(rasterizer.frontFace));

    final switch (rasterizer.cullFace) {
        case CullFace.None:
            glDisable(GL_CULL_FACE);
            break;
        case CullFace.Front:
            glEnable(GL_CULL_FACE);
            glCullFace(GL_FRONT);
            break;
        case CullFace.Back:
            glEnable(GL_CULL_FACE);
            glCullFace(GL_BACK);
            break;
    }

    setRasterMethod(rasterizer.method, rasterizer.offset);

    if (rasterizer.samples) {
        glEnable(GL_MULTISAMPLE);
    }
    else {
        glDisable(GL_MULTISAMPLE);
    }
}


void bindBlend(in ColorInfo info) {
    if (info.blend.isSome) {
        glEnable(GL_BLEND);
        glBlendEquationSeparate(
            equationToGl(info.blend.color.equation),
            equationToGl(info.blend.alpha.equation),
        );
        glBlendFuncSeparate(
            factorToGl(info.blend.color.source),
            factorToGl(info.blend.color.destination),
            factorToGl(info.blend.alpha.source),
            factorToGl(info.blend.alpha.destination),
        );
    }
    else {
        glDisable(GL_BLEND);
    }
    glColorMask(
        (info.mask & ColorFlags.Red) ? GL_TRUE : GL_FALSE,
        (info.mask & ColorFlags.Green) ? GL_TRUE : GL_FALSE,
        (info.mask & ColorFlags.Blue) ? GL_TRUE : GL_FALSE,
        (info.mask & ColorFlags.Alpha) ? GL_TRUE : GL_FALSE,
    );
}


void bindBlendSlot(ColorInfo info, ubyte slot) {
    immutable buf = GLuint(slot);
    if (info.blend.isSome) {
        glEnablei(GL_BLEND, buf);
        glBlendEquationSeparateiARB(buf,
            equationToGl(info.blend.color.equation),
            equationToGl(info.blend.alpha.equation),
        );
        glBlendFuncSeparateiARB(buf,
            factorToGl(info.blend.color.source),
            factorToGl(info.blend.color.destination),
            factorToGl(info.blend.alpha.source),
            factorToGl(info.blend.alpha.destination),
        );
    }
    else {
        glDisablei(GL_BLEND, buf);
    }
    glColorMaski(buf,
        (info.mask & ColorFlags.Red) ? GL_TRUE : GL_FALSE,
        (info.mask & ColorFlags.Green) ? GL_TRUE : GL_FALSE,
        (info.mask & ColorFlags.Blue) ? GL_TRUE : GL_FALSE,
        (info.mask & ColorFlags.Alpha) ? GL_TRUE : GL_FALSE,
    );
}
