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
module gfx.pipeline.pso;

import gfx.device : Device, Resource, ResourceHolder;
import gfx.foundation.rc : Rc, gfxRcCode, GfxRefCounted;
import gfx.foundation.typecons : Option, none, some;
import gfx.pipeline.buffer : RawBuffer;
import gfx.pipeline.format : Format, SurfaceType, Formatted;
import gfx.pipeline.program : Program, VarType, ProgramVars;
import gfx.pipeline.pso.meta : isMetaStruct;
import gfx.pipeline.state : Rasterizer, ColorMask, ColorFlags, BlendChannel, Blend, DepthTest, StencilTest;
import gfx.pipeline.texture : Sampler;
import gfx.pipeline.view : RawShaderResourceView, RawRenderTargetView, RawDepthStencilView;

import std.experimental.logger;

immutable size_t maxVertexAttribs = 16;
immutable size_t maxColorTargets = 4;

alias AttribMask = ushort;
alias ColorTargetMask = ubyte;

static assert(maxVertexAttribs <= 8*AttribMask.sizeof);
static assert(maxColorTargets <= 8*ColorTargetMask.sizeof);

enum Primitive {
    points,
    lines,
    lineStrip,
    triangles,
    triangleStrip,
}

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

struct ResourceViewDesc {
    string name;
    ubyte slot;
    Format format;
}

struct SamplerDesc {
    string name;
    ubyte slot;
}


struct ColorInfo {
    ColorMask mask;
    Option!Blend blend;

    this (ColorMask mask) {
        this.mask = mask;
        this.blend = none!Blend;
    }

    this(Blend blend) {
        this.mask = ColorMask(ColorFlags.all);
        this.blend = some(blend);
    }

    this(ColorMask mask, Blend blend) {
        this.mask = mask;
        this.blend = some(blend);
    }
}


struct ColorTargetDesc {
    string name;
    ubyte slot;
    Format format;
    ColorInfo info;
}

struct DepthStencilDesc {
    SurfaceType surface;

    Option!DepthTest depth;
    Option!StencilTest stencil;

    this(SurfaceType surface, DepthTest depth) {
        this.surface = surface;
        this.depth = some(depth);
    }
    this(SurfaceType surface, StencilTest stencil) {
        this.surface = surface;
        this.stencil = some(stencil);
    }
    this(SurfaceType surface, DepthTest depth, StencilTest stencil) {
        this.surface = surface;
        this.depth = some(depth);
        this.stencil = some(stencil);
    }
}


struct PipelineDescriptor {
    Primitive   primitive;
    Rasterizer  rasterizer;
    bool        scissor;

    VertexAttribDesc[]      vertexAttribs;
    ConstantBlockDesc[]     constantBlocks;
    ResourceViewDesc[]      resourceViews;
    SamplerDesc[]           samplers;
    ColorTargetDesc[]       colorTargets;
    Option!DepthStencilDesc depthStencil;

    @property bool needsToFetchSlots() const {
        foreach(at; vertexAttribs) {
            if (at.slot == ubyte.max) return true;
        }
        foreach(cb; constantBlocks) {
            if (cb.slot == ubyte.max) return true;
        }
        foreach(rv; resourceViews) {
            if (rv.slot == ubyte.max) return true;
        }
        foreach(s; samplers) {
            if (s.slot == ubyte.max) return true;
        }
        foreach(ct; colorTargets) {
            if (ct.slot == ubyte.max) return true;
        }
        return false;
    }
}


// data structs

struct ResourceSet(ElemT, string fieldName) if (is(ElemT : GfxRefCounted))
{
    import std.format : format;

    private ElemT[] _elems;
    mixin(format("@property inout(ElemT)[] %s() inout { return _elems; }", fieldName));

    void add(ElemT elem) {
        elem.retain();
        _elems ~= elem;
    }

    this(this) {
        import std.algorithm : each;
        _elems.each!(e => e.retain());
    }
    ~this() {
        import std.algorithm : each;
        _elems.each!(e => e.release());
    }
}

alias VertexBufferSet = ResourceSet!(RawBuffer, "buffers");
alias ConstantBlockSet = ResourceSet!(RawBuffer, "blocks");
alias ResourceViewSet = ResourceSet!(RawShaderResourceView, "views");
alias SamplerSet = ResourceSet!(Sampler, "samplers");


/// A complete set of render targets to be used for pixel export in PSO.
struct PixelTargetSet {

    /// Array of color target views
    RawRenderTargetView[] colors;

    /// DepthTest target view
    Rc!RawDepthStencilView depth;
    /// StencilTest target view
    Rc!RawDepthStencilView stencil;

    /// Rendering dimensions
    ushort[2] size;

    private void takeSize(ushort[2] size) {
        import std.exception : enforce;
        enforce(!this.size[0] || !this.size[1] || this.size == size);
        this.size = size;
    }

    /// Add a color view to the specified slot
    void addColor(RawRenderTargetView view) {
        takeSize(view.size);
        view.retain();
        colors ~= view;
    }

    void setDepth(RawDepthStencilView view) {
        takeSize(view.size);
        depth = view;
    }

    void setStencil(RawDepthStencilView view) {
        takeSize(view.size);
        stencil = view;
    }

    void setDepthStencil(RawDepthStencilView view) {
        takeSize(view.size);
        depth = view;
        stencil = view;
    }

    this(this) {
        import std.algorithm : each;
        colors.each!(rtv => rtv.retain());
    }

    ~this() {
        import std.algorithm : each;
        colors.each!(rtv => rtv.release());
    }
}


struct RawDataSet {
    VertexBufferSet vertexBuffers;
    ConstantBlockSet constantBlocks;
    ResourceViewSet resourceViews;
    SamplerSet samplers;
    PixelTargetSet pixelTargets;
    ushort[4] scissor;
    float[4] blendRef = [0, 0, 0, 0];
    ubyte[2] stencilRef;
}


interface PipelineStateRes : Resource {
    void bind();
}

class RawPipelineState : ResourceHolder {
    mixin(gfxRcCode);

    private PipelineDescriptor _descriptor;

    private Rc!PipelineStateRes _res;
    private Rc!Program _prog;
    private string _name;

    this (Program program, PipelineDescriptor descriptor, string name="")
    {
        _prog = program;
        _descriptor = descriptor;
        _name = name;
    }

    protected this(Program program, Primitive primitive, Rasterizer rasterizer, string name) {
        _prog = program;
        _descriptor.primitive = primitive;
        _descriptor.rasterizer = rasterizer;
        _name = name;
    }

    final @property inout(PipelineStateRes) res() inout { return _res.obj; }

    final @property inout(Program) program() inout { return _prog.obj; }

    final @property string name() const { return _name; }

    final @property ref inout(PipelineDescriptor) descriptor() inout { return _descriptor; }

    final void dispose() {
        _prog.unload();
        _res.unload();
    }

    final void pinResources(Device device) {
        if (!_prog.pinned) _prog.pinResources(device);
        if (_descriptor.needsToFetchSlots) {
            import std.exception : enforce;
            import std.algorithm : find;
            import std.range : takeOne, empty, front;
            import std.format : format;

            enforce(device.caps.introspection);
            ProgramVars vars = _prog.fetchVars();

            foreach(ref at; _descriptor.vertexAttribs) {
                if (at.slot != ubyte.max) continue;
                auto var = vars.attributes
                        .find!(v => v.name == at.name)
                        .takeOne();
                if (!var.empty) {
                    at.slot = var.front.loc;
                }
                else {
                    errorf("Failure to find var with name %s", at.name);
                }
                //enforce(!var.empty, format("cannot find attribute %s in pipeline %s", at.name, MS.stringof));
            }
            foreach(ref cb; _descriptor.constantBlocks) {
                if (cb.slot != ubyte.max) continue;
                auto var = vars.constBuffers
                        .find!(b => b.name == cb.name)
                        .takeOne();
                enforce(!var.empty, format("cannot find block %s in pipeline %s", cb.name, _name));
                cb.slot = var.front.loc;
            }
            foreach(ref srv; _descriptor.resourceViews) {
                if (srv.slot != ubyte.max) continue;
                auto var = vars.textures
                        .find!(v => v.name == srv.name)
                        .takeOne();
                enforce(!var.empty, format("cannot find texture %s in pipeline %s", srv.name, _name));
                srv.slot = var.front.loc;
            }
            foreach(ref sampler; _descriptor.samplers) {
                if (sampler.slot != ubyte.max) continue;
                auto var = vars.samplers
                        .find!(v => v.name == sampler.name)
                        .takeOne();
                enforce(!var.empty, format("cannot find sampler %s in pipeline %s", sampler.name, _name));
                sampler.slot = var.front.slot;
            }
            foreach(ref ct; _descriptor.colorTargets) {
                if (ct.slot != ubyte.max) continue;
                auto var = vars.outputs
                        .find!(v => v.name == ct.name)
                        .takeOne();
                enforce(!var.empty, format("cannot find color target %s in pipeline %s", ct.name, _name));
                ct.slot = var.front.index;
            }
            //enforce(!_descriptor.needsToFetchSlots);
        }
        _res = device.factory.makePipeline(_prog.obj, _descriptor);
    }
}


class PipelineState(MS) : RawPipelineState if (isMetaStruct!MS)
{
    import gfx.pipeline.pso.meta : PipelineParam, PipelineData;
    import std.traits : Fields, FieldNameTuple;

    alias Param = PipelineParam!MS;
    alias Data = PipelineData!MS;

    this(Program prog, Primitive primitive, Rasterizer rasterizer, Param paramStruct=Param.init) {
        super(prog, primitive, rasterizer, MS.stringof);
        initDescriptor(paramStruct);
    }

    private void initDescriptor(in Param paramStruct) {
        import gfx.pipeline.pso.meta :  metaVertexInputFields,
                                    metaConstantBlockFields,
                                    metaResourceViewFields,
                                    metaResourceSamplerFields,
                                    metaColorOutputFields,
                                    metaBlendOutputFields,
                                    metaDepthOutputFields,
                                    metaStencilOutputFields,
                                    metaDepthStencilOutputFields,
                                    metaScissorFields;
        import std.format : format;
        foreach (vif; metaVertexInputFields!MS) {
            _descriptor.vertexAttribs ~= mixin(format("paramStruct.%s[]", vif.name));
        }
        foreach (cbf; metaConstantBlockFields!MS) {
            _descriptor.constantBlocks ~= mixin(format("paramStruct.%s", cbf.name));
        }
        foreach (rvf; metaResourceViewFields!MS) {
            _descriptor.resourceViews ~= mixin(format("paramStruct.%s", rvf.name));
        }
        foreach (rsf; metaResourceSamplerFields!MS) {
            _descriptor.samplers ~= mixin(format("paramStruct.%s", rsf.name));
        }
        foreach (cof; metaColorOutputFields!MS) {
            _descriptor.colorTargets ~= mixin(format("paramStruct.%s", cof.name));
        }
        foreach (bof; metaBlendOutputFields!MS) {
            _descriptor.colorTargets ~= mixin(format("paramStruct.%s", bof.name));
        }
        enum numDS = metaDepthOutputFields!MS.length +
                    metaStencilOutputFields!MS.length +
                    metaDepthStencilOutputFields!MS.length;
        static assert(numDS == 0 || numDS == 1,
                MS.stringof~" has too many depth-stencil targets (should be one at most)");
        foreach (dof; metaDepthOutputFields!MS) {
            alias Fmt = Formatted!(dof.FormatType);
            _descriptor.depthStencil = some(DepthStencilDesc(
                Fmt.Surface.surfaceType, mixin(format("paramStruct.%s", dof.name))
            ));
        }
        foreach (sof; metaStencilOutputFields!MS) {
            alias Fmt = Formatted!(sof.FormatType);
            _descriptor.depthStencil = some(DepthStencilDesc(
                Fmt.Surface.surfaceType, mixin(format("paramStruct.%s", sof.name))
            ));
        }
        foreach (sof; metaDepthStencilOutputFields!MS) {
            alias Fmt = Formatted!(sof.FormatType);
            _descriptor.depthStencil = some(DepthStencilDesc(
                Fmt.Surface.surfaceType,
                mixin(format("paramStruct.%s[0]", dof.name)), mixin(format("paramStruct.%s[1]", dof.name))
            ));
        }
        foreach (i, sf; metaScissorFields!MS) {
            static assert(i == 0, "one scissor field allowed");
            _descriptor.scissor = true;
        }
    }
    mixin(paramPropertiesCode!MS());

    final RawDataSet makeDataSet(Data dataStruct) {
        import gfx.pipeline.pso.meta :  metaVertexInputFields,
                                    metaConstantBlockFields,
                                    metaResourceViewFields,
                                    metaResourceSamplerFields,
                                    metaColorOutputFields,
                                    metaBlendOutputFields,
                                    metaDepthOutputFields,
                                    metaStencilOutputFields,
                                    metaDepthStencilOutputFields,
                                    metaScissorFields;
        import std.format : format;
        import std.traits : Fields;

        RawDataSet res;

        // each resource is added here in the order that it is declared in the pipeline meta struct
        // the same order is used in the descriptor and in the init struct
        // this how link is made between all structs

        foreach (vif; metaVertexInputFields!MS) {
            foreach (va; Fields!(vif.VertexType)) {
                res.vertexBuffers.add(mixin(format("dataStruct.%s", vif.name)));
            }
        }
        foreach (cbf; metaConstantBlockFields!MS) {
            res.constantBlocks.add(mixin(format("dataStruct.%s", cbf.name)));
        }
        foreach (rvf; metaResourceViewFields!MS) {
            res.resourceViews.add(mixin(format("dataStruct.%s", rvf.name)));
        }
        foreach (rsf; metaResourceSamplerFields!MS) {
            res.samplers.add(mixin(format("dataStruct.%s", rsf.name)));
        }
        foreach (cof; metaColorOutputFields!MS) {
            res.pixelTargets.addColor(mixin(format("dataStruct.%s", cof.name)));
        }
        foreach (bof; metaBlendOutputFields!MS) {
            res.pixelTargets.addColor(mixin(format("dataStruct.%s", bof.name)));
        }
        foreach (dof; metaDepthOutputFields!MS) {
            res.pixelTargets.setDepth(mixin(format("dataStruct.%s", dof.name)));
        }
        foreach (sof; metaStencilOutputFields!MS) {
            res.pixelTargets.setStencil(mixin(format("dataStruct.%s[0]", sof.name)));
            res.stencilRef = mixin(format("dataStruct.%s[1]", sof.name));
        }
        foreach (dsof; metaDepthStencilOutputFields!MS) {
            res.pixelTargets.setDepthStencil(mixin(format("dataStruct.%s[0]", dsof.name)));
            res.stencilRef = mixin(format("dataStruct.%s[1]", dsof.name));
        }
        foreach (sf; metaScissorFields!MS) {
            res.scissor = mixin(format("dataStruct.%s", sf.name));
        }
        return res;
    }

}

private:

string paramPropertiesCode(MS)()
if (isMetaStruct!MS)
{
    import gfx.pipeline.pso.meta :  metaVertexInputFields,
                                metaConstantBlockFields,
                                metaResourceViewFields,
                                metaResourceSamplerFields,
                                metaColorOutputFields,
                                metaBlendOutputFields,
                                metaDepthOutputFields,
                                metaStencilOutputFields,
                                metaDepthStencilOutputFields,
                                metaScissorFields;
    import std.format : format;
    import std.traits : Fields, FieldNameTuple;

    string code;
    int ind;
    foreach (vif; metaVertexInputFields!MS) {
        code ~= format("final @property ref inout(VertexAttribDesc) %s(string f)() inout {\n", vif.name);
        alias Names = FieldNameTuple!(vif.VertexType);
        alias Types = Fields!(vif.VertexType);
        foreach (fi, va; Types) {
            code ~= format(`%sstatic if (f == "%s") {`, fi?"else ":"", Names[fi]);
            code ~= format("\n     return _descriptor.vertexAttribs[%s];\n", ind++);
            code ~= "}\n";
        }
        static if (Types.length) {
            code ~= "else {\n";
            code ~= format(`   static assert(false, "unknwon field \"%s."~f~"\"");`, vif.name);
            code ~= "\n}\n";
        }
        code ~= "}\n";
    }
    foreach (fi, cbf; metaConstantBlockFields!MS) {
        code ~= format("final @property ref inout(ConstantBlockDesc) %s() inout {\n", cbf.name);
        code ~= format("    return _descriptor.constantBlocks[%s];\n", fi);
        code ~= "}\n";
    }
    foreach (fi, rvf; metaResourceViewFields!MS) {
        code ~= format("final @property ref inout(ResourceViewDesc) %s() inout {\n", rvf.name);
        code ~= format("    return _descriptor.resourceViews[%s];\n", fi);
        code ~= "}\n";
    }
    foreach (fi, cbf; metaResourceSamplerFields!MS) {
        code ~= format("final @property ref inout(SamplerDesc) %s() inout {\n", cbf.name);
        code ~= format("    return _descriptor.samplers[%s];\n", fi);
        code ~= "}\n";
    }
    ind = 0;
    foreach (cof; metaColorOutputFields!MS) {
        code ~= format("final @property ref inout(ColorTargetDesc) %s() inout {\n", cof.name);
        code ~= format("    return _descriptor.colorTargets[%s];\n", ind++);
        code ~= "}\n";
    }
    foreach (bof; metaBlendOutputFields!MS) {
        code ~= format("final @property ref inout(ColorTargetDesc) %s() inout {\n", bof.name);
        code ~= format("    return _descriptor.colorTargets[%s];\n", ind++);
        code ~= "}\n";
    }
    foreach (dsof; metaDepthOutputFields!MS) {
        code ~= format("final @property ref inout(DepthStencilDesc) %s() inout {\n", dsof.name);
        code ~= format("    return _descriptor.depthStencil.get();\n");
        code ~= "}\n";
    }
    foreach (dsof; metaStencilOutputFields!MS) {
        code ~= format("final @property ref inout(DepthStencilDesc) %s() inout {\n", dsof.name);
        code ~= format("    return _descriptor.depthStencil.get();\n");
        code ~= "}\n";
    }
    foreach (dsof; metaDepthStencilOutputFields!MS) {
        code ~= format("final @property ref inout(DepthStencilDesc) %s() inout {\n", dsof.name);
        code ~= format("    return _descriptor.depthStencil.get();\n");
        code ~= "}\n";
    }
    return code;
}

