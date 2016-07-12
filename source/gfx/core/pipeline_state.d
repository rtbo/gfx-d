module gfx.core.pipeline_state;

import gfx.core.rc;
import gfx.core.context;

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
/// for other backends, the pipeline switch is emulated in a straightforward way

template PipelineState(VT) {

    import std.traits;
    import std.meta;

    template VertexAttrib(string n, T) {
        alias name = n;
        alias Type = T;
    }

    alias FNames = FieldNameTuple!VT;
    alias FTypes = Fields!VT;
    enum FCount = FNames.length;
    static assert(FNames.length == FTypes.length);

    template ParseAttribs(size_t n) {
        static if(n == FCount) {
            alias ParseAttribs = AliasSeq!();
        }
        else {
            alias ParseAttribs = AliasSeq!(
                VertexAttrib!(FNames[0], FTypes[0]),
                ParseAttribs!(n+1)
            );
        }
    }

    alias Attribs = ParseAttribs!0;


    class PipelineState {
        alias VertexType = VT;
    }

}