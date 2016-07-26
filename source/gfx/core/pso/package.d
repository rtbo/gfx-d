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

import gfx.core :   Device, Resource, ResourceHolder, Primitive,
                    maxVertexAttribs, maxColorTargets, AttribMask, ColorTargetMask;
import gfx.core.rc : Rc, rcCode, RefCounted;
import gfx.core.typecons : Option, none;
import gfx.core.state : Rasterizer, ColorMask, ColorFlags, BlendChannel, Blend;
import gfx.core.format : Format;
import gfx.core.buffer : RawBuffer;
import gfx.core.program : Program, VarType, ProgramVars;
import gfx.core.view : RawShaderResourceView, RawRenderTargetView, RawDepthStencilView;
import gfx.core.pso.meta : isMetaStruct;


// descriptor structs

struct StructField {
    VarType type;
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

struct ConstantBlockDesc {
    string name;
    ubyte slot;
}

struct ShaderResourceDesc {
    string name;
    ubyte slot;
    Format format;
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

    VertexAttribDesc[] vertexAttribs;
    ConstantBlockDesc[] constantBlocks;
    ShaderResourceDesc[] shaderResources;
    ColorTargetDesc[] colorTargets;

    @property bool needsToFetchSlots() const {
        foreach(at; vertexAttribs) {
            if (at.slot == ubyte.max) return true;
        }
        foreach(cb; constantBlocks) {
            if (cb.slot == ubyte.max) return true;
        }
        foreach(sr; shaderResources) {
            if (sr.slot == ubyte.max) return true;
        }
        foreach(ct; colorTargets) {
            if (ct.slot == ubyte.max) return true;
        }
        return false;
    }
}


// data structs

struct ResourceSet(ElemT, string fieldName) if (is(ElemT : RefCounted))
{
    import std.format : format;

    private ElemT[] _elems;
    mixin(format("@property inout(ElemT)[] %s() inout { return _elems; }", fieldName));

    void add(ElemT elem) {
        elem.addRef();
        _elems ~= elem;
    }

    this(this) {
        import std.algorithm : each;
        _elems.each!(e => e.addRef());
    }
    ~this() {
        import std.algorithm : each;
        _elems.each!(e => e.release());
    }
}

alias VertexBufferSet = ResourceSet!(RawBuffer, "buffers");
alias ConstantBlockSet = ResourceSet!(RawBuffer, "blocks");
alias ShaderResourceSet = ResourceSet!(RawShaderResourceView, "views");


/// A complete set of render targets to be used for pixel export in PSO.
struct PixelTargetSet {

    /// Array of color target views
    RawRenderTargetView[] colors;

    /// Depth target view
    Rc!RawDepthStencilView depth;
    /// Stencil target view
    Rc!RawDepthStencilView stencil;
    /// Rendering dimensions
    ushort width;
    /// ditto
    ushort height;


    /// Add a color view to the specified slot
    void addColor(RawRenderTargetView view) {
        import gfx.core.rc : rc;
        import std.algorithm : max;

        view.addRef();
        colors ~= view;
    }

    /// Add a depth or stencil view to the specified slot
    void addDepthStencil(RawDepthStencilView view, bool hasDepth, bool hasStencil) {
        import std.algorithm : max;

        if(hasDepth) {
            depth = view;
        }
        if(hasStencil) {
            stencil = view;
        }
    }

    this(this) {
        import std.algorithm : each;
        colors.each!(rtv => rtv.addRef());
    }

    ~this() {
        import std.algorithm : each;
        colors.each!(rtv => rtv.release());
    }
}


struct RawDataSet {
    VertexBufferSet vertexBuffers;
    ConstantBlockSet constantBlocks;
    ShaderResourceSet shaderResources;
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

    final @property inout(PipelineStateRes) res() inout { return _res.obj; }

    @property inout(Program) program() inout { return _prog.obj; }

    @property Primitive primitive() const { return _descriptor.primitive; }
    @property Rasterizer rasterizer() const { return _descriptor.rasterizer; }
    @property bool scissors() const { return _descriptor.scissors; }
    @property inout(VertexAttribDesc)[] vertexAttribs() inout { return _descriptor.vertexAttribs; }
    @property inout(ColorTargetDesc)[] colorTargets() inout { return _descriptor.colorTargets; }

    void drop() {
        _prog.unload();
        _res.unload();
    }
}


class PipelineState(MS) : RawPipelineState if (isMetaStruct!MS)
{
    import gfx.core.pso.meta : PipelineInit, PipelineData;
    import std.traits : Fields, FieldNameTuple;

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

    private void initDescriptor(in Init initStruct) {
        import gfx.core.pso.meta :  metaVertexInputFields,
                                    metaConstantBlockFields,
                                    metaShaderResourceFields,
                                    metaColorOutputFields;
        import std.format : format;
        foreach (vif; metaVertexInputFields!MS) {
            _descriptor.vertexAttribs ~= mixin(format("initStruct.%s[]", vif.name));
        }
        foreach (cbf; metaConstantBlockFields!MS) {
            _descriptor.constantBlocks ~= mixin(format("initStruct.%s", cbf.name));
        }
        foreach (srf; metaShaderResourceFields!MS) {
            _descriptor.shaderResources ~= mixin(format("initStruct.%s", srf.name));
        }
        foreach (cof; metaColorOutputFields!MS) {
            _descriptor.colorTargets ~= mixin(format("initStruct.%s", cof.name));
        }
    }

    void pinResources(Device device) {
        if (!_prog.pinned) _prog.pinResources(device);
        if (_descriptor.needsToFetchSlots) {
            import std.exception : enforce;
            import std.algorithm : find;
            import std.range : takeOne, empty, front;
            import std.format : format;
            enforce(device.hasIntrospection);
            ProgramVars vars = _prog.fetchVars();
            foreach(ref at; _descriptor.vertexAttribs) {
                if (at.slot != ubyte.max) continue;
                auto var = vars.attributes
                        .find!(v => v.name == at.name)
                        .takeOne();
                enforce(!var.empty, format("cannot find attribute %s in pipeline", at.name));
                at.slot = var.front.loc;
            }
            foreach(ref cb; _descriptor.constantBlocks) {
                if (cb.slot != ubyte.max) continue;
                auto var = vars.constBuffers
                        .find!(b => b.name == cb.name)
                        .takeOne();
                enforce(!var.empty, format("cannot find block %s in pipeline", cb.name));
                cb.slot = var.front.loc;
            }
            foreach(ref srv; _descriptor.shaderResources) {
                if (srv.slot != ubyte.max) continue;
                auto var = vars.textures
                        .find!(v => v.name == srv.name)
                        .takeOne();
                enforce(!var.empty, format("cannot find texture %s in pipeline", srv.name));
                srv.slot = var.front.loc;
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
        _res = device.factory.makePipeline(_prog.obj, _descriptor);
    }


    RawDataSet makeDataSet(Data dataStruct) {
        import gfx.core.pso.meta :  metaVertexInputFields,
                                    metaConstantBlockFields,
                                    metaShaderResourceFields,
                                    metaColorOutputFields;
        import std.format : format;
        import std.traits : Fields;

        RawDataSet res;

        // each resource is added here in the order that it is declared in the pipeline meta struct
        // the same order is used in the descriptor and in the init struct
        // this how link is made between all structs

        foreach (vif; metaVertexInputFields!MS) {
            foreach (i, va; Fields!(vif.VertexType)) {
                res.vertexBuffers.add(mixin(format("dataStruct.%s", vif.name)));
            }
        }
        foreach (cbf; metaConstantBlockFields!MS) {
            foreach (i, cb; Fields!(cbf.BlockType)) {
                res.constantBlocks.add(mixin(format("dataStruct.%s", cbf.name)));
            }
        }
        foreach (srv; metaShaderResourceFields!MS) {
            res.shaderResources.add(mixin(format("dataStruct.%s", srv.name)));
        }
        foreach (rtf; metaColorOutputFields!MS) {
            res.pixelTargets.addColor(mixin(format("dataStruct.%s", rtf.name)));
        }

        return res;
    }

}



