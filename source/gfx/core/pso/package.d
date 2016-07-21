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

import gfx.core : Resource, ResourceHolder, Primitive, maxVertexAttribs, maxColorTargets, AttribMask, ColorTargetMask;
import gfx.core.rc : Rc, rcCode;
import gfx.core.typecons : Option, none;
import gfx.core.context : Context;
import gfx.core.state : Rasterizer, ColorMask, ColorFlags, BlendChannel, Blend;
import gfx.core.format : Format;
import gfx.core.buffer : BufferRes;
import gfx.core.program : Program, VarType, ProgramVars;
import gfx.core.view : RawRenderTargetView, RawDepthStencilView;
import gfx.core.pso.meta : isMetaStruct, PipelineInit, PipelineData, VertexBuffer, RenderTarget;




// descriptor structs

struct StructField {
    Format format;
    size_t offset;
    size_t size;
    size_t alignment;
    size_t stride;
}

struct VertexAttribDesc {
    string name;
    ubyte slot;
    StructField field;
    ubyte instanceRate;
}


struct ColorInfo {
    ColorMask mask;
    Option!BlendChannel color;
    Option!BlendChannel alpha;

    static ColorInfo from(ColorMask mask) {
        return ColorInfo(mask, none!BlendChannel, none!BlendChannel);
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

    AttribMask attribMask;
    VertexAttribDesc[maxVertexAttribs] vertexAttribs;

    ColorTargetMask colorTargetMask;
    ColorTargetDesc[maxColorTargets] colorTargets;
}


// data structs

struct VertexBufferSet {
    Rc!BufferRes[maxVertexAttribs] buffers;
}

/// A complete set of render targets to be used for pixel export in PSO.
struct PixelTargetSet {

    /// Array of color target views
    Rc!RawRenderTargetView[maxColorTargets] colors;
    /// Depth target view
    Rc!RawDepthStencilView depth;
    /// Stencil target view
    Rc!RawDepthStencilView stencil;
    /// Rendering dimensions
    ushort width;
    /// ditto
    ushort height;


    /// Add a color view to the specified slot
    void addColor(ubyte slot, RawRenderTargetView view, ushort w, ushort h) {
        import std.algorithm : max;

        colors[slot] = view;
        height = max(h, height);
    }

    /// Add a depth or stencil view to the specified slot
    void addDepthStencil(RawDepthStencilView view, bool hasDepth, bool hasStencil, ushort w, ushort h) {
        import std.algorithm : max;

        if(hasDepth) {
            depth = view;
        }
        if(hasStencil) {
            stencil = view;
        }
        width = max(w, width);
        height = max(h, height);
    }
}


struct RawDataSet {
    VertexBufferSet vertexBuffers;
    PixelTargetSet pixelTargets;
}


interface PipelineStateRes : Resource {
    void bind();
}

abstract class RawPipelineState : ResourceHolder {
    mixin(rcCode);

    PipelineDescriptor _descriptor;

    Rc!PipelineStateRes _res;
    Rc!Program _prog;

    this(Program program, Primitive primitive, Rasterizer rasterizer) {
        _prog = program;
        _descriptor.primitive = primitive;
        _descriptor.rasterizer = rasterizer;
    }

    @property inout(PipelineStateRes) res() inout { return _res.obj; }

    @property inout(Program) program() inout { return _prog.obj; }

    @property Primitive primitive() const { return _descriptor.primitive; }
    @property Rasterizer rasterizer() const { return _descriptor.rasterizer; }
    @property bool scissors() const { return _descriptor.scissors; }
    @property inout(VertexAttribDesc)[] vertexAttribs() inout { return _descriptor.vertexAttribs; }

    @property bool pinned() const {
        return _res.assigned;
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

    Init _initStruct;

    this(Program prog, Primitive primitive, Rasterizer rasterizer) {
        super(prog, primitive, rasterizer);
        _initStruct = Init.defValue;
    }

    this(Program prog, Primitive primitive, Rasterizer rasterizer, Init initStruct) {
        super(prog, primitive, rasterizer);
        _initStruct = initStruct;
    }

    private static bool needsToFetchSlots(in Init initStruct) {
        import std.traits : Fields, FieldNameTuple;
        import std.format : format;
        foreach (i, MF; Fields!MS) {
            alias field = FieldNameTuple!MS[i];
            static if (is(MF == VertexBuffer!T, T)) {
                foreach(at; mixin(format("initStruct.%s[]", field))) {
                    if (at.slot == ubyte.max) return true;
                }
            }
            static if (is(MF == RenderTarget!T, T)) {
                if (mixin(format("initStruct.%s.slot", field)) == ubyte.max) return true;
            }
        }
        return false;
    }

    void pinResources(Context context) {
        import std.traits : Fields, FieldNameTuple;
        import std.format : format;

        if (!_prog.pinned) _prog.pinResources(context);

        if (needsToFetchSlots(_initStruct)) {
            import std.exception : enforce;
            import std.algorithm : find;
            import std.range : takeOne, empty, front;

            enforce(context.hasIntrospection);
            ProgramVars vars = _prog.fetchVars();

            foreach (i, MF; Fields!MS) {
                alias field = FieldNameTuple!MS[i];
                static if (is(MF == VertexBuffer!T, T)) {
                    foreach(ref at; mixin(format("_initStruct.%s[]", field))) {
                        if (at.slot != ubyte.max) continue;
                        auto var = vars.attributes
                                .find!(v => v.name == at.name)
                                .takeOne();
                        enforce(!var.empty, format("cannot find attribute %s in pipeline", at.name));
                        at.slot = var.front.loc;
                        enforce(at.slot < maxVertexAttribs);
                    }
                }
                static if (is(MF == RenderTarget!T, T)) {
                    auto ct = mixin(format("_initStruct.%s", field));
                    if (ct.slot != ubyte.max) continue;
                    auto var = vars.outputs
                            .find!(v => v.name == ct.name)
                            .takeOne();
                    enforce(!var.empty, format("cannot find color target %s in pipeline", ct.name));
                    ct.slot = var.front.index;
                    enforce(ct.slot < maxColorTargets);
                    mixin(format("_initStruct.%s = ct;", field));
                }
            }

            enforce(!needsToFetchSlots(_initStruct));
        }

        foreach(i, MF; Fields!MS) {
            alias field = FieldNameTuple!MS[i];
            static if (is(MF == VertexBuffer!T, T)) {
                foreach(at; mixin(format("_initStruct.%s[]", field))) {
                    _descriptor.vertexAttribs[at.slot] = at;
                    _descriptor.attribMask |= (1 << at.slot);
                }
            }
            static if (is(MF == RenderTarget!T, T)) {
                auto ct = mixin(format("_initStruct.%s", field));
                _descriptor.colorTargets[ct.slot] = ct;
                _descriptor.colorTargetMask |= (1 << ct.slot);
            }
        }

        _res = context.makePipeline(_prog.obj, _descriptor);
    }

    RawDataSet makeDataSet(Data dataStruct) {
        import gfx.core.pso.meta : metaVertexBufferFields;
        import std.format : format;
        import std.traits : Fields;

        assert(pinned);
        RawDataSet res;

        foreach (vbf; metaVertexBufferFields!MS) {
            foreach (i, va; Fields!(vbf.VertexType)) {
                auto at = mixin(format("_initStruct.%s[%s]", vbf.name, i));
                res.vertexBuffers.buffers[at.slot] = mixin(format("dataStruct.%s.res", vbf.name));
            }
        }

        return res;
    }

}



