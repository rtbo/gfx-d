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
            if (ct.info.color.isSome || ct.info.alpha.isSome) {
                Blend blend;
                if (ct.info.color.isSome) blend.color = ct.info.color.get();
                if (ct.info.alpha.isSome) blend.color = ct.info.alpha.get();
                _output.colors[ct.slot].blend = blend;
            }
        }
    }

    @property ref const(VertexAttribDesc[]) input() const { return _input; }
    @property ref const(OutputMerger) output() const { return _output; }

    void drop() {
        _prog.unload();
    }

    void bind() {
    }
}