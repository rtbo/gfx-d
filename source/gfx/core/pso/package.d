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

import gfx.core : Resource, ResourceHolder, Primitive, maxVertexAttribs, maxColorTargets;
import gfx.core.rc : Rc, rcCode;
import gfx.core.context : Context;
import gfx.core.state : Rasterizer, ColorMask, ColorFlags, BlendChannel, Blend;
import gfx.core.format : Format;
import gfx.core.buffer : BufferRes;
import gfx.core.program : Program, VarType, ProgramVars;
import gfx.core.pso.meta : isMetaStruct, PipelineInit, PipelineData, VertexBuffer, RenderTarget;

import std.typecons : Nullable;




// descriptor structs

struct StructField {
    Format format;
    size_t offset;
    size_t size;
    size_t alignment;
}

struct VertexAttribDesc {
    string name;
    ubyte slot;
    StructField field;
    ubyte instanceRate;
}


struct ColorInfo {
    ColorMask mask;
    Nullable!BlendChannel color;
    Nullable!BlendChannel alpha;

    static ColorInfo from(ColorMask mask) {
        return ColorInfo(mask, Nullable!(BlendChannel).init, Nullable!(BlendChannel).init);
    }

    static ColorInfo from(Blend blend) {
        ColorInfo info;
        info.mask = ColorFlags.All;
        info.color = blend.color;
        info.alpha = blend.alpha;
        return info;
    }
}


struct ColorTargetDesc {
    string name;
    ubyte slot;
    Format format;
    ColorInfo info;
}


struct PipelineDescriptor {
    Primitive primitive;
    Rasterizer rasterizer;
    bool scissors;
    VertexAttribDesc[] vertexAttribs;
    ColorTargetDesc[] colorTargets;

    @property bool needsToFetchSlots() const {
        foreach(at; vertexAttribs) {
            if (at.slot == ubyte.max) return true;
        }
        foreach(ct; colorTargets) {
            if (ct.slot == ubyte.max) return true;
        }
        return false;
    }
}


// data structs

struct VertexBufferSet {
    Rc!BufferRes[maxVertexAttribs] buffers;
}

struct RawDataSet {
    VertexBufferSet vertexBuffers;
}


interface PipelineStateRes : Resource {
    void bind();
}

abstract class RawPipelineState : ResourceHolder {
    mixin(rcCode);

    PipelineDescriptor _descriptor;

    Rc!PipelineStateRes _res;
    Rc!Program _prog;
    RawDataSet _dataSet;

    this(Program program, Primitive primitive, Rasterizer rasterizer) {
        _prog = program;
        _descriptor.primitive = primitive;
        _descriptor.rasterizer = rasterizer;
    }

    @property bool pinned() const {
        return _res.assigned;
    }

    void pinResources(Context context) {
        if (!_prog.pinned) _prog.pinResources(context);

        if (_descriptor.needsToFetchSlots) {
            import std.exception : enforce;
            import std.algorithm : find;
            import std.range : takeOne, empty, front;
            import std.format : format;

            enforce(context.hasIntrospection);
            ProgramVars vars = _prog.fetchVars();
            foreach(ref at; _descriptor.vertexAttribs) {
                if (at.slot != ubyte.max) continue;
                auto var = vars.attributes
                        .find!(v => v.name == at.name)
                        .takeOne();
                enforce(!var.empty, format("cannot find attribute %s in pipeline", at.name));
                at.slot = var.front.loc;
            }
            foreach(ref ct; _descriptor.colorTargets) {
                if (ct.slot != ubyte.max) continue;
                auto var = vars.outputs
                        .find!(v => v.name == ct.name)
                        .takeOne();
                enforce(!var.empty, format("cannot find color target %s in pipeline", ct.name));
                ct.slot = var.front.index;
            }
            enforce(!_descriptor.needsToFetchSlots);
        }

        _res = context.makePipeline(_prog.obj, _descriptor);
    }

    void drop() {
        _prog.nullify();
        _res.nullify();
    }

    void validate() {}
}


class PipelineState(MS) : RawPipelineState if (isMetaStruct!MS) {
    alias Init = PipelineInit!MS;
    alias Data = PipelineData!MS;

    this(Program prog, Primitive primitive, Rasterizer rasterizer) {
        super(prog, primitive, rasterizer);
        initDescriptor(Init.defValue);
    }

    this(Program prog, Primitive primitive, Rasterizer rasterizer, Init initStruct) {
        super(prog, primitive, rasterizer);
        initDescriptor(initStruct);
    }

    void initDescriptor(Init initStruct) {
        import std.traits : Fields, FieldNameTuple;
        import std.format : format;
        foreach(i, MF; Fields!MS) {
            alias field = FieldNameTuple!MS[i];
            static if (is(MF == VertexBuffer!T, T)) {
                _descriptor.vertexAttribs ~= mixin(format("initStruct.%s[]", field));
            }
            static if (is(MF == RenderTarget!T, T)) {
                _descriptor.colorTargets ~= mixin(format("initStruct.%s", field));
            }
        }
    }

    void setData(Data dataStruct) {

    }

}



