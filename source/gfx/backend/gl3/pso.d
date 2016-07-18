module gfx.backend.gl3.pso;

import gfx.core.rc : Rc, rcCode;
import gfx.core.pso : PipelineStateRes, PipelineDescriptor;
import gfx.core.program : Program;

import derelict.opengl3.gl3;

class GlPipelineState : PipelineStateRes {
    mixin(rcCode);

    GLuint _vao;
    Rc!Program _prog;

    this(Program prog, PipelineDescriptor descriptor) {
        _prog = prog;
        glGenVertexArrays(1, &_vao);
    }

    void drop() {
        glDeleteVertexArrays(1, &_vao);
    }

    void bind() {
        glBindVertexArray(_vao);
    }
}