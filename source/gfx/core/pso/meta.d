module gfx.core.pso.meta;

import gfx.core.rc : Rc;
import gfx.core.format : SurfaceType, ChannelType, Format, Formatted, isFormatted;
import gfx.core.buffer : Buffer;
import gfx.core.view : RenderTargetView;
import gfx.core.pso : VertexAttribDesc, ColorTargetDesc, StructField, PipelineDescriptor, ColorInfo;
import gfx.core.state : ColorFlags, ColorMask;



/// UDA struct to associate names of shader symbols at compile time
struct GfxName {
    string value;
}

/// UDA struct to associate slots of shader symbols at compile time
struct GfxSlot {
    ubyte value;
}


struct VertexInput(T) {}

struct ColorOutput(T) if (isFormatted!T) {}




template InitType(MF) if (isMetaField!MF) {
    import std.traits : Fields;

    static if (is(MF == VertexInput!T, T)) {
        alias InitType = VertexAttribDesc[(Fields!T).length];
    }
    else static if (is(MF == ColorOutput!T, T)) {
        alias InitType = ColorTargetDesc;
    }
    else {
        static assert(false, "Unsupported pipeline meta type: "~MF.stringof);
    }
}


template DataType(MF) if (isMetaField!MF) {
    static if (is(MF == VertexInput!T, T)) {
        alias DataType = Rc!(Buffer!T);
    }
    else static if (is(MF == ColorOutput!T, T)) {
        alias DataType = Rc!(RenderTargetView!T);
    }
    else {
        static assert(false, "Unsupported pipeline meta type: "~MF.stringof);
    }
}


template isMetaField(MF) {
    static if (is(MF == VertexInput!T, T)) {
        enum isMetaField = true;
    }
    else static if (is(MF == ColorOutput!T, T)) {
        enum isMetaField = true;
    }
    else {
        enum isMetaField = false;
    }
}

template isMetaStruct(M) {
    import std.meta : allSatisfy;
    import std.traits : Fields;

    enum isMetaStruct = allSatisfy!(isMetaField, Fields!M);
}


template isMetaVertexInputField(MF) {
    enum isMetaVertexInputField = is(MF == VertexInput!T, T);
}

template MetaVertexInputField(MS, string f) if (isMetaStruct!MS) {
    alias MF = FieldType!(MS, f);
    enum name = f;

    static if (is(MF == VertexInput!T, T)) {
        alias VertexType = T;
    }
    else {
        static assert(false, T.stringof ~ " is not a vertex buffer meta field");
    }
}

alias metaVertexInputFields(MS) = metaResolveFields!(MS, isMetaVertexInputField, MetaVertexInputField);


template isMetaColorOutputField(MF) {
    enum isMetaColorOutputField = is(MF == ColorOutput!T, T);
}

template MetaColorOutputField(MS, string f) if (isMetaStruct!MS) {
    alias MF = FieldType!(MS, f);
    enum name = f;

    static if (is(MF == ColorOutput!T, T)) {
        alias SurfaceType = T;
    }
    else {
        static assert(false, T.stringof ~ " is not a render target meta field");
    }
}

alias metaColorOutputFields(MS) = metaResolveFields!(MS, isMetaColorOutputField, MetaColorOutputField);


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
    import std.format : format;

    alias MF = FieldType!(MS, field);
    alias IF = InitType!MF;

    static if (is(MF == VertexInput!T, T)) {
        alias gfxFields = GfxStructFields!(T);
        string initCode() {
            string res = "[";
            foreach(f; gfxFields) {
                res ~= format("VertexAttribDesc(\"%s\", %s, " ~
                            "StructField(Format(SurfaceType.%s, ChannelType.%s), %s, %s, %s, %s), 0),\n",
                    f.gfxName, f.gfxSlot, f.Fmt.Surface.surfaceType, f.Fmt.Channel.channelType,
                    f.offset, f.size, f.alignment, T.sizeof);
            }
            return res ~ "]";
        }
        enum InitValue = mixin(initCode());
    }
    else static if (is(MF == ColorOutput!T, T)) {
        string initCode() {
            alias Fmt = Formatted!T;
            return format("ColorTargetDesc(\"%s\", %s, " ~
                    "Format(SurfaceType.%s, ChannelType.%s), " ~
                    "ColorInfo.from(cast(ColorMask)ColorFlags.All))",
                    resolveGfxName!(MS, field), resolveGfxSlot!(MS, field),
                    Fmt.Surface.surfaceType, Fmt.Channel.channelType);
        }
        enum InitValue = mixin(initCode());
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
    alias Fmt = Formatted!T;
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