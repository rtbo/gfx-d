/// pipeline state objects (pso) embed a part of the pipeline state
/// in order to allow fast rendering context switches.
/// PSOs have a layout part and a data part.
/// the layout part is defined at compile time. when data is filled into a PSO,
/// it is checked at runtime that the data fits the layout.
/// pso embed the following layout:
///    program layout (inputs, uniforms, outputs)
///    vertex data layout (the type of vertex is specified at compile time and defines program input)
///    TODO: exhaustive description
/// backends that natively support psos are Vulkan and DX12 (none implemented at this stage)
/// for other backends, the pipeline switch is emulated
module gfx.core.pso;

import gfx.core : Resource, ResourceHolder;
import gfx.core.rc : Rc, rcCode;
import gfx.core.context : Context;
import gfx.core.buffer : BufferRes;
import gfx.core.program : Program;
import gfx.core.pso.meta : GfxName, isMetaStruct, PipelineInit, PipelineData;

import std.traits : FieldNameTuple, Fields, getSymbolsByUDA, getUDAs;
import std.meta : AliasSeq;




struct VertexBufferSet {

}



struct RawDataSet {
    Rc!BufferRes[] vertexBuffers;
}


interface PipelineStateRes : Resource {}

class RawPipelineState : ResourceHolder {
    mixin(rcCode);

    Rc!PipelineStateRes _res;
    Rc!Program _prog;

    @property bool pinned() const {
        return _res.assigned;
    }

    void pinResources(Context context) {
        if (!_prog.pinned) _prog.pinResources(context);
    }

    void drop() {
        _prog.nullify();
        _res.nullify();
    }
}


class PipelineState(MS) : RawPipelineState if (isMetaStruct!MS) {
    alias Init = PipelineInit!MS;
    alias Data = PipelineData!MS;
}

