module gfx.backend.gl3.state;

import gfx.core.typecons : Option;
import gfx.core.state : Rasterizer, FrontFace, CullFace, RasterMethod, Offset;

import derelict.opengl3.gl3;


GLenum frontFaceToGl(in FrontFace ff) {
    final switch(ff) {
        case FrontFace.ClockWise: return GL_CW;
        case FrontFace.CounterClockWise: return GL_CCW;
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