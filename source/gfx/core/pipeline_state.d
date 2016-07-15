module gfx.core.pipeline_state;

import gfx.core.rc;
import gfx.core.context;

import std.traits;
import std.meta;

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



enum VertexInput;
enum ConstantInput;



/// UDA struct to associate vertex struct member name to vertex input attrib name
/// it is to be applied on the vertex structure fields directly
/// if a vertex structure field has no AttribName attribute, the member name is
/// assumed as attribute name in the vertex shader
struct AttribName {
    string attrib;
}

/// template that represent a vertex attrib
template VertexAttrib(T, string m, string a) {
    alias Type = T;
    enum member = m;
    enum attrib = a;
}

/// template that analyses a vertex struct and resolves as an
/// AliasSeq of VertexAttrib (in declaration order)
template VertexAttribs(VT) if(is(VT == struct)) {
    alias FNames = FieldNameTuple!VT;
    alias FTypes = Fields!VT;
    enum FCount = FNames.length;
    static assert(FNames.length == FTypes.length);

    alias AttribNameUDAs = getSymbolsByUDA!(VT, AttribName);

    template ResolveAttribName(string memberName, size_t n) {
        static if (n == AttribNameUDAs.length) {
            enum ResolveAttribName = memberName; // defaults to member name
        }
        else {
            static if (AttribNameUDAs[n].stringof == memberName) {
                enum ResolveAttribName = getUDAs!(AttribNameUDAs[n], AttribName)[0].attrib;
            }
            else {
                enum ResolveAttribName = ResolveAttribName!(memberName, n+1);
            }
        }
    }

    template ParseAttribs(size_t n) {
        static if(n == FCount) {
            alias ParseAttribs = AliasSeq!();
        }
        else {
            alias ParseAttribs = AliasSeq!(
                VertexAttrib!(FTypes[n], FNames[n], ResolveAttribName!(FNames[n], 0)),
                ParseAttribs!(n+1)
            );
        }
    }

    alias VertexAttribs = ParseAttribs!0;
}


version(unittest) {

    struct Vertex {
        @AttribName("a_Pos")
        float[4] position;

        float[4] color;
    }

    alias attribs = VertexAttribs!Vertex;

    static assert(attribs.length == 2);
    static assert(attribs[0].member == "position");
    static assert(attribs[0].attrib == "a_Pos");
    static assert(attribs[1].member == "color");
    static assert(attribs[1].attrib == "color");
}





template PipelineState(VT) {

    class PipelineState {
        alias VertexType = VT;
        alias Attribs = VertexAttribs!VertexType;


    }

}