module gfx.backend.gl3.pso;

import gfx.core : maxVertexAttribs, maxColorTargets, AttribMask, ColorTargetMask;
import gfx.core.rc : Rc, rcCode;
import gfx.core.typecons : Option;
import gfx.core.state : Stencil, Depth, Color, Blend;
import gfx.core.pso : PipelineStateRes, PipelineDescriptor, VertexAttribDesc;
import gfx.core.program : Program;

import derelict.opengl3.gl3;


struct OutputMerger {
    Option!Stencil stencil;
    Option!Depth depth;
    ColorTargetMask mask;
    Color[maxColorTargets] colors;
}

class GlPipelineState : PipelineStateRes {
    mixin(rcCode);

    Rc!Program _prog;

    VertexAttribDesc[] _input;
    OutputMerger _output;

    this(Program prog, PipelineDescriptor descriptor) {
        _prog = prog;

        _input = descriptor.vertexAttribs;

        if (descriptor.depthStencil.isSome) {
            _output.depth = descriptor.depthStencil.depth;
            _output.stencil = descriptor.depthStencil.stencil;
        }
        foreach(ct; descriptor.colorTargets) {
            _output.mask |= 1 << ct.slot;
            _output.colors[ct.slot].mask = ct.info.mask;
            if (ct.info.blend.isSome) {
                _output.colors[ct.slot].blend = ct.info.blend;
            }
        }
    }

    final @property ref const(VertexAttribDesc[]) input() const { return _input; }
    final @property ref const(OutputMerger) output() const { return _output; }

    final void drop() {
        _prog.unload();
    }

    final void bind() {
    }
}