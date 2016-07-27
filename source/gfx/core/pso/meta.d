module gfx.core.pso.meta;

import gfx.core.rc : Rc;
import gfx.core.format : SurfaceType, ChannelType, Format, Formatted, isFormatted;
import gfx.core.program : BaseType, VarType, varBaseType, varDim1, varDim2;
import gfx.core.buffer : VertexBuffer, Buffer, ConstBuffer;
import gfx.core.view : RenderTargetView, DepthStencilView, ShaderResourceView;
import gfx.core.pso :   StructField, PipelineDescriptor, ColorInfo,
                        VertexAttribDesc, ConstantBlockDesc,
                        ShaderResourceDesc, ColorTargetDesc;
import gfx.core.state : ColorFlags, ColorMask, Depth;



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

// input attributes
struct VertexInput(T) {
    alias VertexType = T;
}

// constant blocks
struct ConstantBlock(T) {
    alias BlockType = T;
}

// resources
struct ShaderResource(T) if (isFormatted!T) {
    alias FormatType = T;
}
struct ShaderSampler(T) if (isFormatted!T) {
    alias FormatType = T;
}

// output targets
struct ColorOutput(T) if (isFormatted!T) {
    alias FormatType = T;
}
struct DepthOutput(T) if (isFormatted!T) {
    alias FormatType = T;
}
struct StencilOutput(T) if (isFormatted!T) {
    alias FormatType = T;
}
struct DepthStencilOutput(T) if (isFormatted!T) {
    alias FormatType = T;
}




template InitType(MF) if (isMetaField!MF)
{
    import std.traits : Fields;

    static if (isMetaVertexInputField!MF) {
        alias InitType = VertexAttribDesc[(Fields!(MF.VertexType)).length];
    }
    else static if (isMetaConstantBlockField!MF) {
        alias InitType = ConstantBlockDesc;
    }
    else static if (isMetaShaderResourceField!MF) {
        alias InitType = ShaderResourceDesc;
    }
    else static if (isMetaColorOutputField!MF) {
        alias InitType = ColorTargetDesc;
    }
    else static if (isMetaDepthOutputField!MF) {
        alias InitType = Depth;
    }
    else {
        static assert(false, "Unsupported pipeline meta type: "~MF.stringof);
    }
}


template DataType(MF) if (isMetaField!MF)
{
    static if (isMetaVertexInputField!MF) {
        alias DataType = Rc!(VertexBuffer!(MF.VertexType));
    }
    else static if (isMetaConstantBlockField!MF) {
        alias DataType = Rc!(ConstBuffer!(MF.BlockType));
    }
    else static if (isMetaShaderResourceField!MF) {
        alias DataType = Rc!(ShaderResourceView!(MF.FormatType));
    }
    else static if (isMetaColorOutputField!MF) {
        alias DataType = Rc!(RenderTargetView!(MF.FormatType));
    }
    else static if (isMetaDepthOutputField!MF) {
        alias DataType = Rc!(DepthStencilView!(MF.FormatType));
    }
    else {
        static assert(false, "Unsupported pipeline meta type: "~MF.stringof);
    }
}


template isMetaField(MF) {
    enum isMetaField =  isMetaVertexInputField!MF ||
                        isMetaConstantBlockField!MF ||
                        isMetaShaderResourceField!MF ||
                        isMetaColorOutputField!MF ||
                        isMetaDepthOutputField!MF;
}

template isMetaStruct(M) {
    import std.meta : allSatisfy;
    import std.traits : Fields;

    enum isMetaStruct = allSatisfy!(isMetaField, Fields!M);
}



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

template isMetaShaderResourceField(MF) {
    enum isMetaShaderResourceField = is(MF == ShaderResource!T, T);
}
alias MetaShaderResourceField(MS, string f) = MetaFormattedField!(MS, f);
alias metaShaderResourceFields(MS) = metaResolveFields!(MS, isMetaShaderResourceField, MetaShaderResourceField);

template isMetaShaderSamplerField(MF) {
    enum isMetaShaderSamplerField = is(MF == ShaderSampler!T, T);
}
alias MetaShaderSamplerField(MS, string f) = MetaFormattedField!(MF, f);
alias metaShaderSamplerFields(MS) = metaResolveFields!(MS, isMetaShaderSamplerField, MetaShaderSamplerField);




template isMetaColorOutputField(MF) {
    enum isMetaColorOutputField = is(MF == ColorOutput!T, T);
}
alias MetaColorOutputField(MF, string f) = MetaFormattedField!(MF, f);
alias metaColorOutputFields(MS) = metaResolveFields!(MS, isMetaColorOutputField, MetaColorOutputField);



template isMetaDepthOutputField(MF) {
    enum isMetaDepthOutputField = is(MF == DepthOutput!T, T);
}
alias MetaDepthOutputField(MF, string f) = MetaFormattedField!(MF, f);
alias metaDepthOutputFields(MS) = metaResolveFields!(MS, isMetaDepthOutputField, MetaDepthOutputField);



template isMetaStencilOutputField(MF) {
    enum isMetaStencilOutputField = is(MF == StencilOutput!T, T);
}
alias MetaStencilOutputField(MF, string f) = MetaFormattedField!(MF, f);
alias metaStencilOutputFields(MS) = metaResolveFields!(MS, isMetaStencilOutputField, MetaStencilOutputField);



template isMetaDepthStencilOutputField(MF) {
    enum isMetaDepthStencilOutputField = is(MF == DepthStencilOutput!T, T);
}
alias MetaDepthStencilOutputField(MF, string f) = MetaFormattedField!(MF, f);
alias metaDepthStencilOutputFields(MS) =
            metaResolveFields!(MS, isMetaDepthStencilOutputField, MetaDepthStencilOutputField);



template isMetaFormattedField(MF) {
    enum isMetaFormattedField =     isMetaShaderResourceField!MF ||
                                    isMetaColorOutputField!MF ||
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


template InitValue(MS, string field) if (isMetaStruct!MS) {

    alias MF = FieldType!(MS, field);
    alias IF = InitType!MF;

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
        enum InitValue = mixin(initCode());
    }
    else static if (isMetaConstantBlockField!MF) {
        enum InitValue = ConstantBlockDesc(resolveGfxName!(MS, field), resolveGfxSlot!(MS, field));
    }
    else static if (isMetaShaderResourceField!MF) {
        import gfx.core.format : format;
        enum InitValue = ShaderResourceDesc(
            resolveGfxName!(MS, field), resolveGfxSlot!(MS, field), format!(MF.FormatType)
        );
    }
    else static if (isMetaColorOutputField!MF) {
        import gfx.core.format : format;
        enum InitValue = ColorTargetDesc(
            resolveGfxName!(MS, field), resolveGfxSlot!(MS, field),
            format!(MF.FormatType), ColorInfo.from(cast(ColorMask)ColorFlags.All)
        );
    }
    else static if (isMetaDepthOutputField!MF) {
        enum InitValue = resolveUDAValue!(GfxDepth, MS, field, Depth, Depth.init);
    }
}



template InitTrait(MS, string field) if (isMetaStruct!MS) {
    alias Type = InitType!(FieldType!(MS, field));
    enum defValue = InitValue!(MS, field);
}

template DataTrait(MS, string field) if (isMetaStruct!MS) {
    alias Type = DataType!(FieldType!(MS, field));
}


template PipelineStruct(MS, alias Trait, bool hasDefValue) if (isMetaStruct!MS) {
    import std.traits : Fields, FieldNameTuple;
    import std.format : format;

    string fieldCode(string field)() {
        return format("Trait!(MS, \"%s\").Type %s", field, field);
    }

    string fieldsCode() {
        string res;
        foreach(f; FieldNameTuple!MS) {
            res ~= format("%s;\n", fieldCode!f());
        }
        return res;
    }

    static if (hasDefValue) {
        string defValueCode() {
            string res = "enum defValue = Struct (";
            foreach(i, f; FieldNameTuple!MS) {
                res ~= format("Trait!(MS, \"%s\").defValue, ", f);
            }
            return res ~ ");";
        }
    }

    struct Struct {
        mixin(fieldsCode());

        static if(hasDefValue) {
            mixin(defValueCode());
        }
    }

    alias PipelineStruct = Struct;
}

alias PipelineInit(M) = PipelineStruct!(M, InitTrait, true);
alias PipelineData(M) = PipelineStruct!(M, DataTrait, false);


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