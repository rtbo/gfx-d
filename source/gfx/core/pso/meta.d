module gfx.core.pso.meta;

import gfx.core.format : SurfaceType, ChannelType, Format, Formatted, isFormatted;
import gfx.core.buffer : Buffer;
import gfx.core.view : RenderTargetView;



/// UDA struct to associate names of shader symbols at compile time
struct GfxName {
    string name;
}


struct StructField {
    string name;
    Format format;
    size_t offset;
    size_t size;
    size_t alignment;
}

struct VertexBuffer(T) {}

struct RenderTarget(T) if (isFormatted!T) {}



template isMetaField(M) {
    static if (is(M == VertexBuffer!T, T)) {
        enum isMetaField = true;
    }
    else static if (is(M == RenderTarget!T, T)) {
        enum isMetaField = true;
    }
    else {
        enum isMetaField = false;
    }
}


template InitType(MF) if (isMetaField!MF) {
    import std.traits : Fields;

    static if (is(MF == VertexBuffer!T, T)) {
        alias InitType = StructField[(Fields!T).length];
    }
    else static if (is(MF == RenderTarget!T, T)) {
        alias InitType = string;
    }
    else {
        static assert(false, "Unsupported pipeline meta type: "~MF.stringof);
    }
}


template InitValue(MS, string field) if (isMetaStruct!MS) {
    import std.format : format;

    alias MF = FieldType!(MS, field);
    alias IF = InitType!MF;

    static if (is(MF == VertexBuffer!T, T)) {
        alias gfxFields = GfxStructFields!(T);
        string initCode() {
            string res = "[";
            foreach(f; gfxFields) {
                res ~= format("StructField(\"%s\", Format(SurfaceType.%s, ChannelType.%s), %s, %s, %s),\n",
                    f.gfxName, f.Fmt.Surface.surfaceType, f.Fmt.Channel.channelType,
                    f.offset, f.size, f.alignment);
            }
            return res ~ "]";
        }
        enum InitValue = mixin(initCode());
    }
    else static if (is(MF == RenderTarget!T, T)) {
        enum InitValue = ResolveGfxName!(MS, field);
    }
}

template DataType(MF) if (isMetaField!MF) {
    static if (is(MF == VertexBuffer!T, T)) {
        alias DataType = Buffer!T;
    }
    else static if (is(MF == RenderTarget!T, T)) {
        alias DataType = RenderTargetView!T;
    }
    else {
        static assert(false, "Unsupported pipeline meta type: "~MF.stringof);
    }
}

template InitTrait(MS, string field) if (isMetaStruct!MS) {
    alias Type = InitType!(FieldType!(MS, field));
    enum defValue = InitValue!(MS, field);
}

template DataTrait(MS, string field) if (isMetaStruct!MS) {
    alias Type = DataType!(FieldType!(MS, field));
}



template isMetaStruct(M) {
    import std.meta : allSatisfy;
    import std.traits : Fields;

    enum isMetaStruct = allSatisfy!(isMetaField, Fields!M);
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


template ResolveGfxName(StructT, string field) {
    import std.traits : getSymbolsByUDA, getUDAs;

    alias GfxNameUDAs = getSymbolsByUDA!(StructT, GfxName);

    template Resolver(size_t n) {
        static if (n == GfxNameUDAs.length) {
            enum Resolver = field;
        }
        else static if (GfxNameUDAs[n].stringof == field) {
            enum Resolver = getUDAs!(GfxNameUDAs[n], GfxName)[0].name;
        }
        else {
            enum Resolver = Resolver!(n+1);
        }

    }

    enum ResolveGfxName = Resolver!0;
}


/// template representing a struct field (such as vertex or constant block) at compile time
template GfxStructField(T, size_t o, string f, string g) {
    alias Field = T;
    alias Fmt = Formatted!T;
    enum offset = o;
    enum size = T.sizeof;
    enum alignment = T.alignof;
    enum field = f;
    enum gfxName = g;
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
                GfxStructField!(Types[n], off, Names[n], ResolveGfxName!(T, Names[n])),
                parseFields!(n+1, off+Types[n].alignof)
            );
        }
    }

    alias GfxStructFields = parseFields!(0, 0);
}