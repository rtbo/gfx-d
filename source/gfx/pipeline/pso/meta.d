module gfx.pipeline.pso.meta;

import gfx.foundation.rc : Rc;
import gfx.pipeline.format : SurfaceType, ChannelType, Format, Formatted, isFormatted;
import gfx.pipeline.program : BaseType, VarType, varBaseType, varDim1, varDim2;
import gfx.pipeline.buffer : VertexBuffer, Buffer, ConstBuffer;
import gfx.pipeline.texture : Sampler;
import gfx.pipeline.view : RenderTargetView, DepthStencilView, ShaderResourceView;
import gfx.pipeline.pso :   StructField, PipelineDescriptor, ColorInfo,
                        VertexAttribDesc, ConstantBlockDesc,
                        ResourceViewDesc, SamplerDesc, ColorTargetDesc;
import gfx.pipeline.state : ColorFlags, ColorMask, Depth, Stencil, Blend;

import std.typecons : Tuple, tuple;


/// UDA struct to associate names of shader symbols at compile time
struct GfxName {
    string value;
}

/// UDA struct to associate slots of shader symbols at compile time
struct GfxSlot {
    ubyte value;
}

/// UDA struct to associate depth state to depth targets at compile time
struct GfxDepth {
    Depth value;
}

/// UDA struct to associate stencil state to stencil targets at compile time
struct GfxStencil {
    Stencil value;
}

/// UDA struct to associate blend state to blend targets at compile time
struct GfxColorMask {
    ColorMask value;
}

/// UDA struct to associate blend state to blend targets at compile time
struct GfxBlend {
    Blend value;
}



// input attributes
struct VertexInput(T) {
    import std.traits : Fields;

    alias VertexType = T;

    alias Param = VertexAttribDesc[Fields!VertexType.length];
    alias Data = Rc!(VertexBuffer!VertexType);
}

// constant blocks
struct ConstantBlock(T) {
    alias BlockType = T;

    alias Param = ConstantBlockDesc;
    alias Data = Rc!(ConstBuffer!BlockType);
}

// resources
struct ResourceView(T) if (isFormatted!T) {
    alias FormatType = T;

    alias Param = ResourceViewDesc;
    alias Data = Rc!(ShaderResourceView!FormatType);
}
struct ResourceSampler {
    alias Param = SamplerDesc;
    alias Data = Rc!Sampler;
}

// output targets
struct ColorOutput(T) if (isFormatted!T) {
    alias FormatType = T;

    alias Param = ColorTargetDesc;
    alias Data = Rc!(RenderTargetView!FormatType);
}
struct BlendOutput(T) if (isFormatted!T) {
    alias FormatType = T;

    alias Param = ColorTargetDesc;
    alias Data = Rc!(RenderTargetView!FormatType);
}
struct DepthOutput(T) if (isFormatted!T) {
    alias FormatType = T;

    alias Param = Depth;
    alias Data = Rc!(DepthStencilView!FormatType);
}
struct StencilOutput(T) if (isFormatted!T) {
    alias FormatType = T;

    alias Param = Stencil;
    alias Data = Tuple!(Rc!(DepthStencilView!FormatType), ubyte[2]);
}
struct DepthStencilOutput(T) if (isFormatted!T) {
    alias FormatType = T;

    alias Param = Tuple!(Depth, Stencil);
    alias Data = Tuple!(Rc!(DepthStencilView!FormatType), ubyte[2]);
}

struct Scissor {
    alias Param = void;
    alias Data = ushort[4];
}



template ParamInitValue(MS, string field) if (isMetaStruct!MS) {

    alias MF = FieldType!(MS, field);
    alias IF = MF.Param;

    static if (isMetaVertexInputField!MF) {
        string initCode() {
            import std.format : format;
            alias gfxFields = GfxStructFields!(MF.VertexType);
            string res = "[";
            foreach(f; gfxFields) {
                res ~= format("VertexAttribDesc(\"%s\", %s, " ~
                            "StructField(VarType(BaseType.%s, %s, %s), %s, %s, %s, %s), 0),\n",
                    f.gfxName, f.gfxSlot, f.vtBaseType, f.vtDim1, f.vtDim2,
                    f.offset, f.size, f.alignment, MF.VertexType.sizeof);
            }
            return res ~ "]";
        }
        enum ParamInitValue = mixin(initCode());
    }
    else static if (isMetaConstantBlockField!MF) {
        enum ParamInitValue = ConstantBlockDesc(resolveGfxName!(MS, field), resolveGfxSlot!(MS, field));
    }
    else static if (isMetaResourceViewField!MF) {
        import gfx.pipeline.format : format;
        enum ParamInitValue = ResourceViewDesc(
            resolveGfxName!(MS, field), resolveGfxSlot!(MS, field), format!(MF.FormatType)
        );
    }
    else static if (isMetaResourceSamplerField!MF) {
        enum ParamInitValue = SamplerDesc(
            resolveGfxName!(MS, field), resolveGfxSlot!(MS, field)
        );
    }
    else static if (isMetaColorOutputField!MF) {
        import gfx.pipeline.format : format;
        enum ParamInitValue = ColorTargetDesc(
            resolveGfxName!(MS, field), resolveGfxSlot!(MS, field),
            format!(MF.FormatType), ColorInfo(
                resolveUDAValue!(GfxColorMask, MS, field, ColorMask, ColorMask(ColorFlags.all))
            )
        );
    }
    else static if (isMetaBlendOutputField!MF) {
        import gfx.pipeline.format : format;
        enum ParamInitValue = ColorTargetDesc(
            resolveGfxName!(MS, field), resolveGfxSlot!(MS, field),
            format!(MF.FormatType), ColorInfo(
                resolveUDAValue!(GfxColorMask, MS, field, ColorMask, ColorMask(ColorFlags.all)),
                resolveUDAValue!(GfxBlend, MS, field, Blend, Blend.init)
            )
        );
    }
    else static if (isMetaDepthOutputField!MF) {
        enum ParamInitValue = resolveUDAValue!(GfxDepth, MS, field, Depth, Depth.init);
    }
    else static if (isMetaStencilOutputField!MF) {
        enum ParamInitValue = resolveUDAValue!(GfxStencil, MS, field, Stencil, Stencil.init);
    }
    else static if (isMetaDepthStencilOutputField!MF) {
        enum ParamInitValue = tuple(
            resolveUDAValue!(GfxDepth, MS, field, Depth, Depth.init),
            resolveUDAValue!(GfxStencil, MS, field, Stencil, Stencil.init),
        );
    }
}


template isMetaField(MF) {
    enum isMetaField =  isMetaVertexInputField!MF ||
                        isMetaConstantBlockField!MF ||
                        isMetaResourceViewField!MF ||
                        isMetaResourceSamplerField!MF ||
                        isMetaColorOutputField!MF ||
                        isMetaBlendOutputField!MF ||
                        isMetaDepthOutputField!MF ||
                        isMetaStencilOutputField!MF ||
                        isMetaDepthStencilOutputField!MF ||
                        isMetaScissorField!MF;
}

template isMetaStruct(M) {
    import std.meta : allSatisfy;
    import std.traits : Fields;

    enum isMetaStruct = allSatisfy!(isMetaField, Fields!M);
}



template ParamTrait(MS, string field) if (isMetaStruct!MS) {
    alias Type = FieldType!(MS, field).Param;
    enum defValue = ParamInitValue!(MS, field);
}

template DataTrait(MS, string field) if (isMetaStruct!MS) {
    alias Type = FieldType!(MS, field).Data;
}


template PipelineStruct(MS, alias Trait, bool hasDefValue) if (isMetaStruct!MS) {
    import std.traits : Fields, FieldNameTuple;
    import std.format : format;

    string fieldsCode() {
        string res;
        foreach(f; FieldNameTuple!MS) {
            static if (!is(Trait!(MS, f).Type == void)) {
                enum fieldCode = "Trait!(MS, \"%s\").Type %s".format(f, f);
                static if (hasDefValue) {
                    enum defVal = " = Trait!(MS, \"%s\").defValue".format(f);
                }
                else {
                    enum defVal = "";
                }
                res ~= "%s%s;\n".format(fieldCode, defVal);
            }
        }
        return res;
    }

    struct Struct {
        mixin(fieldsCode());
    }

    alias PipelineStruct = Struct;
}

alias PipelineParam(MS) = PipelineStruct!(MS, ParamTrait, true);
alias PipelineData(MS) = PipelineStruct!(MS, DataTrait, false);


// input attributes

template isMetaVertexInputField(MF) {
    enum isMetaVertexInputField = is(MF == VertexInput!T, T);
}
template MetaVertexInputField(MS, string f) if (isMetaStruct!MS) {
    alias MF = FieldType!(MS, f);
    static assert(isMetaVertexInputField!MF);

    enum name = f;
    alias VertexType = MF.VertexType;
}
alias metaVertexInputFields(MS) = metaResolveFields!(MS, isMetaVertexInputField, MetaVertexInputField);



// constant blocks

template isMetaConstantBlockField(MF) {
    enum isMetaConstantBlockField = is(MF == ConstantBlock!T, T);
}
template MetaConstantBlockField(MS, string f) if (isMetaStruct!MS) {
    alias MF = FieldType!(MS, f);
    static assert(isMetaConstantBlockField!MF);

    enum name = f;
    alias BlockType = MF.BlockType;
}
alias metaConstantBlockFields(MS) = metaResolveFields!(MS, isMetaConstantBlockField, MetaConstantBlockField);



// shader resources

template isMetaResourceViewField(MF) {
    enum isMetaResourceViewField = is(MF == ResourceView!T, T);
}
alias MetaResourceViewField(MS, string f) = MetaFormattedField!(MS, f);
alias metaResourceViewFields(MS) = metaResolveFields!(MS, isMetaResourceViewField, MetaResourceViewField);

template isMetaResourceSamplerField(MF) {
    enum isMetaResourceSamplerField = is(MF == ResourceSampler);
}
template MetaResourceSamplerField(MS, string f) {
    alias MF = FieldType!(MS, f);
    static assert(isMetaResourceSamplerField!MF);
    enum name = f;
}
alias metaResourceSamplerFields(MS) = metaResolveFields!(MS, isMetaResourceSamplerField, MetaResourceSamplerField);



// output targets

template isMetaColorOutputField(MF) {
    enum isMetaColorOutputField = is(MF == ColorOutput!T, T);
}
alias MetaColorOutputField(MS, string f) = MetaFormattedField!(MS, f);
alias metaColorOutputFields(MS) = metaResolveFields!(MS, isMetaColorOutputField, MetaColorOutputField);



template isMetaBlendOutputField(MF) {
    enum isMetaBlendOutputField = is(MF == BlendOutput!T, T);
}
alias MetaBlendOutputField(MS, string f) = MetaFormattedField!(MS, f);
alias metaBlendOutputFields(MS) = metaResolveFields!(MS, isMetaBlendOutputField, MetaBlendOutputField);



template isMetaDepthOutputField(MF) {
    enum isMetaDepthOutputField = is(MF == DepthOutput!T, T);
}
alias MetaDepthOutputField(MS, string f) = MetaFormattedField!(MS, f);
alias metaDepthOutputFields(MS) = metaResolveFields!(MS, isMetaDepthOutputField, MetaDepthOutputField);



template isMetaStencilOutputField(MF) {
    enum isMetaStencilOutputField = is(MF == StencilOutput!T, T);
}
alias MetaStencilOutputField(MS, string f) = MetaFormattedField!(MS, f);
alias metaStencilOutputFields(MS) = metaResolveFields!(MS, isMetaStencilOutputField, MetaStencilOutputField);



template isMetaDepthStencilOutputField(MF) {
    enum isMetaDepthStencilOutputField = is(MF == DepthStencilOutput!T, T);
}
alias MetaDepthStencilOutputField(MS, string f) = MetaFormattedField!(MS, f);
alias metaDepthStencilOutputFields(MS) =
            metaResolveFields!(MS, isMetaDepthStencilOutputField, MetaDepthStencilOutputField);


template isMetaScissorField(MF) {
    enum isMetaScissorField = is(MF == Scissor);
}
template MetaScissorField(MS, string f) {
    alias MF = FieldType!(MS, f);
    static assert(isMetaScissorField!MF);
    enum name = f;
}
alias metaScissorFields(MS) = metaResolveFields!(MS, isMetaScissorField, MetaScissorField);


template isMetaFormattedField(MF) {
    enum isMetaFormattedField =     isMetaResourceViewField!MF ||
                                    isMetaColorOutputField!MF ||
                                    isMetaBlendOutputField!MF ||
                                    isMetaDepthOutputField!MF ||
                                    isMetaStencilOutputField!MF ||
                                    isMetaDepthStencilOutputField!MF;
}
template MetaFormattedField(MS, string f) if (isMetaStruct!MS) {
    alias MF = FieldType!(MS, f);
    static assert(isMetaFormattedField!MF);

    enum name = f;
    alias FormatType = MF.FormatType;
}

template metaResolveFields(MS, alias test, alias FieldTplt) if (isMetaStruct!MS) {
    import std.traits : Fields, FieldNameTuple;
    import std.meta : AliasSeq;

    template resolve(size_t n) {
        static if (n == Fields!(MS).length) {
            alias resolve = AliasSeq!();
        }
        else static if (test!(Fields!MS[n])) {
            alias resolve = AliasSeq!(
                FieldTplt!(MS, FieldNameTuple!MS[n]),
                resolve!(n+1)
            );
        }
        else {
            alias resolve = resolve!(n+1);
        }
    }

    alias metaResolveFields = resolve!0;
}


template FieldIndex(StructT, string field) {
    import std.traits : FieldNameTuple;
    import std.meta : staticIndexOf;

    enum index = staticIndexOf!(field, FieldNameTuple!StructT);
    static assert(index != -1, format("type %s has no field named %s", StructT.stringof, field));

    enum FieldIndex = index;
}

template FieldType(StructT, string field) {
    import std.traits : Fields;
    import std.meta : staticIndexOf;

    alias FieldType = Fields!StructT[FieldIndex!(StructT, field)];
}

version(unittest) {
    struct TestS {
        int memb1;
        long memb2;
        char memb3;
    }
    static assert(FieldIndex!(TestS, "memb1") == 0);
    static assert(FieldIndex!(TestS, "memb2") == 1);
    static assert(FieldIndex!(TestS, "memb3") == 2);
    static assert(is(FieldType!(TestS, "memb1") == int));
    static assert(is(FieldType!(TestS, "memb2") == long));
    static assert(is(FieldType!(TestS, "memb3") == char));
}


template isValueUDA(UDA) {
    import std.traits : FieldNameTuple;

    enum isValueUDA = FieldNameTuple!UDA.length == 1 && FieldNameTuple!UDA[0] == "value";
}

template UDAValueType(UDA) if (isValueUDA!UDA) {
    import std.traits : Fields;

    alias UDAValueType = Fields!UDA[0];
}

template resolveUDAValue(UDA, StructT, string field, DefType, DefType def)
        if (isValueUDA!UDA && is(DefType == UDAValueType!UDA)) {
    import std.traits :/+ getSymbolsByUDA,+/ getUDAs;

    alias UDAs = getSymbolsByUDA!(StructT, UDA);

    template resolve(size_t n) {
        static if (n == UDAs.length) {
            enum resolve = def;
        }
        else static if (UDAs[n].stringof == field) {
            enum resolve = getUDAs!(UDAs[n], UDA)[0].value;
        }
        else {
            enum resolve = resolve!(n+1);
        }
    }

    enum resolveUDAValue = resolve!0;
}


alias resolveGfxName(StructT, string field) = resolveUDAValue!(GfxName, StructT, field, string, field);
alias resolveGfxSlot(StructT, string field) = resolveUDAValue!(GfxSlot, StructT, field, ubyte, ubyte.max);


version(unittest) {
    struct TestNoUDA {
        float[2] pos;
        float[3] col;
    }
    struct TestMixedUDA {
        @GfxName("a_Pos")   float[2] pos;
        @GfxSlot(1)         float[3] col;
    }

    static assert(resolveGfxName!(TestNoUDA,	"pos") == "pos");
    static assert(resolveGfxSlot!(TestNoUDA,	"col") == ubyte.max);
    static assert(resolveGfxName!(TestMixedUDA, "pos") == "a_Pos");
    static assert(resolveGfxSlot!(TestMixedUDA,	"col") == 1);
    static assert(resolveGfxName!(TestMixedUDA, "col") == "col");
    static assert(resolveGfxSlot!(TestMixedUDA, "pos") == ubyte.max);
}



/// template representing a struct field (such as vertex or constant block) at compile time
template GfxStructField(T, size_t o, string f, string g, ubyte s) {
    alias Field = T;
    enum vtBaseType = varBaseType!T;
    enum vtDim1 = varDim1!T;
    enum vtDim2 = varDim2!T;
    enum offset = o;
    enum size = T.sizeof;
    enum alignment = T.alignof;
    enum field = f;
    enum gfxName = g;
    enum gfxSlot = s;
}

template GfxStructFields(T) {
    import std.traits : FieldNameTuple, Fields;
    import std.meta : AliasSeq;

    alias Names = FieldNameTuple!T;
    alias Types = Fields!T;

    template parseFields(size_t n, size_t off) {
        static if (n == Names.length) {
            alias parseFields = AliasSeq!();
        }
        else {
            alias parseFields = AliasSeq!(
                GfxStructField!(Types[n], off, Names[n], resolveGfxName!(T, Names[n]), resolveGfxSlot!(T, Names[n])),
                parseFields!(n+1, off+fieldAlignment!(Types[n]))
            );
        }
    }

    alias GfxStructFields = parseFields!(0, 0);
}

private:


size_t fieldAlignment(T)() {
    size_t n=0;
    while(n*T.alignof < T.sizeof) ++n;
    return n*T.alignof;
}


/// phobos #15874 and PR #4164 are merged into master but not into stable
/// here is the fixed version of getSymbolsByUDA
template getSymbolsByUDA(alias symbol, alias attribute) {
    import std.format : format;
    import std.meta : AliasSeq, Filter;
    import std.traits : hasUDA;

    // translate a list of strings into symbols. mixing in the entire alias
    // avoids trying to access the symbol, which could cause a privacy violation
    template toSymbols(names...) {
        static if (names.length == 0)
            alias toSymbols = AliasSeq!();
        else
            mixin("alias toSymbols = AliasSeq!(symbol.%s, toSymbols!(names[1..$]));"
                  .format(names[0]));
    }

    enum hasSpecificUDA(string name) = mixin("hasUDA!(symbol.%s, attribute)".format(name));

    alias membersWithUDA = toSymbols!(Filter!(hasSpecificUDA, __traits(allMembers, symbol)));

    // if the symbol itself has the UDA, tack it on to the front of the list
    static if (hasUDA!(symbol, attribute))
        alias getSymbolsByUDA = AliasSeq!(symbol, membersWithUDA);
    else
        alias getSymbolsByUDA = membersWithUDA;
}

version(unittest) {
    enum Attr;
    struct Test {
        int field1;
        int field2;
    }
    static assert(getSymbolsByUDA!(Test, Attr).length == 0);
}
