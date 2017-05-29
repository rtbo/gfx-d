module gfx.foundation.typecons;

/// template that resolves to true if an object of type T can be assigned to null
template isNullAssignable(T) {
    enum isNullAssignable =
        is(typeof((inout int = 0) {
            T t = T.init;
            t = null;
        }));
}

version(unittest) {
    interface   ITest {}
    class       CTest {}
    struct      STest {}
    static assert( isNullAssignable!ITest);
    static assert( isNullAssignable!CTest);
    static assert(!isNullAssignable!STest);
    static assert( isNullAssignable!(STest*));
}

/// constructs an option from a value
Option!T some(T)(T val) {
    return Option!T(val);
}

/// symbolic value that constructs an Option in none state
enum none(T) = Option!(T).init;


struct Option(T) if (!isNullAssignable!T)
{
    private T _val          = T.init;
    private bool _isSome    = false;

    this(inout T val) inout {
        _val = val;
        _isSome = true;
    }

    @property bool isSome() const {
        return _isSome;
    }

    @property bool isNone() const {
        return !_isSome;
    }

    void setNone() {
        .destroy(_val);
        _isSome = false;
    }

    void opAssign()(T val) {
        _val = val;
        _isSome = true;
    }

    // casting to type that have implicit cast available (e.g Option!int to Option!uint)
    auto opCast(V : Option!U, U)() if (is(T : U)) {
        return Option!U(val_);
    }

    @property ref inout(T) get() inout @safe pure nothrow
    {
        enum message = "Called `get' on none Option!" ~ T.stringof ~ ".";
        assert(isSome, message);
        return _val;
    }

    alias get this;

    template toString()
    {
        import std.format : FormatSpec, formatValue;
        // Needs to be a template because of DMD @@BUG@@ 13737.
        void toString()(scope void delegate(const(char)[]) sink, FormatSpec!char fmt)
        {
            if (isNull)
            {
                sink.formatValue("Option.none", fmt);
            }
            else
            {
                sink.formatValue(_value, fmt);
            }
        }

        // Issue 14940
        void toString()(scope void delegate(const(char)[]) @safe sink, FormatSpec!char fmt)
        {
            if (isNull)
            {
                sink.formatValue("Option.none", fmt);
            }
            else
            {
                sink.formatValue(_value, fmt);
            }
        }
    }
}



template SafeUnion(Specs...) {

    import std.meta : AliasSeq, Filter;
    import std.traits : fullyQualifiedName;
    import std.typecons : Tuple, tuple;
    import std.algorithm : canFind;
    import std.format : format;

    template FieldSpec(string n, T...) {
        enum name = n;
        alias Types = T;
        enum upperName = buildUpperName();

        string buildUpperName() {
            import std.uni : toUpper;
            import std.utf : stride;

            immutable fstCharLen = stride(name);
            return format("%s%s",
                toUpper(name[0 .. fstCharLen]), name[fstCharLen .. $]
            );
        }
    }

    alias FieldSpecs = parseSpecs!Specs;
    alias TypedFieldSpecs = Filter!(isTypedFieldSpec, FieldSpecs);


    template MatchSpec(string n, alias f) {
        alias name = n;
        alias fun = f;
    }


    struct SafeUnion {
    private:
        mixin("union Data_ {" ~ unionContentInject() ~ "}");
        mixin("enum Tag_ {" ~ tagContentInject() ~ "}");

        mixin("Data_ data_ = " ~ unionInitInject() ~ ";");
        mixin("Tag_ tag_ = " ~ tagInitInject() ~ ";");

        this(Data_ d, Tag_ t) {
            data_ = d;
            tag_ = t;
        }

    public:

        mixin(tagAliasesInject());

        @property Tag_ tag() const { return tag_; }

        mixin(ctorsInject());
        mixin(testsInject());
        mixin(gettersInject());
        static if(isComparable!()) {
            mixin(cmpInject());
        }
        mixin(toStringInject());

        auto match(MatchSpecs...)() {
            alias matchSpecs = parseMatchSpecs!MatchSpecs;
            static assert(matchNamesFit!(matchSpecs)(), "SafeUnion mismatch");
            foreach(ms; matchSpecs) {
                static if (ms.name == "default") {
                    return ms.fun();
                }
                else {
                    mixin("alias TagEl = Tag_."~ms.name~";");
                    if(tag == TagEl) {
                        foreach(spec; FieldSpecs) {
                            static if(spec.name == ms.name) {
                                static if(spec.Types.length == 0) {
                                    return ms.fun();
                                }
                                else {
                                    mixin("return ms.fun("~fieldList!(spec)()~");\n");
                                }
                            }
                        }
                    }
                }
            }
            assert(false, "SafeUnion mismatch");
        }
    }


    template UntilNotString(size_t N, Specs...) {
        static if (Specs.length == 0 || is(typeof(Specs[0]) : string)) {
            alias Num = N;
        }
        else {
            alias UNS = UntilNotString!(N+1, Specs[1..$]);
            alias Num = UNS.Num;
        }
    }

    template parseSpecs(Specs...) {
        static if(Specs.length == 0) {
            alias parseSpecs = AliasSeq!();
        }
        else {
            static assert (is(typeof(Specs[0]) : string));
            alias UNS = UntilNotString!(0, Specs[1..$]);
            alias parseSpecs = AliasSeq!(
                FieldSpec!(Specs[0..1+UNS.Num]),
                parseSpecs!(Specs[1+UNS.Num..$]));
        }
    }
    template isTypedFieldSpec(alias Spec) {
        enum isTypedFieldSpec = Spec.Types.length > 0;
    }


    template parseMatchSpecs(MatchSpecs...) {
        static if (MatchSpecs.length == 0) {
            alias parseMatchSpecs = AliasSeq!();
        }
        else {
            static assert (is(typeof(MatchSpecs[0]) : string));
            static assert (MatchSpecs.length % 2 == 0);
            alias parseMatchSpecs = AliasSeq!(
                MatchSpec!(MatchSpecs[0 .. 2]),
                parseMatchSpecs!(MatchSpecs[2 .. $])
            );
        }
    }

    template isComparable() {
        import std.meta : allSatisfy;

        enum isComparable = allSatisfy!(isSpecComparable, FieldSpecs);

        template isSpecComparable(alias Spec) {
            enum isSpecComparable = allSatisfy!(isFieldComparable, Spec.Types);
        }

        template isFieldComparable(T) {
            enum isFieldComparable = is(typeof(T.init < T.init));
        }
    }


    string structString() {
        string s;
        foreach(i, spec; FieldSpecs) {
            s ~= spec.name;
            foreach(j, T; spec.Types) {
                if (j==0) {
                    s ~= "(";
                }
                s ~= fullyQualifiedName!T;
                if (j==spec.Types.length-1) {
                    s ~= ")";
                }
                else {
                    s ~= ", ";
                }
            }
            if (i != FieldSpecs.length -1) {
                s ~= ", ";
            }
        }
        return s;
    }

    string fieldType(alias fs)() {
        static assert(fs.Types.length > 0);
        string type;
        if (fs.Types.length == 1) {
            type = fullyQualifiedName!(fs.Types[0]);
        }
        else {
            type = "Tuple!(";
            foreach(i, T; fs.Types) {
                type ~= fullyQualifiedName!T;
                if(i != fs.Types.length-1) {
                    type ~= ", ";
                }
            }
            type ~= ")";
        }
        return type;
    }

    string[] fieldTypes(alias fs)() {
        string[] types;
        foreach(T; fs.Types) {
            types ~= fullyQualifiedName!T;
        }
        return types;
    }

    string fieldList(alias fs)() {
        static assert(fs.Types.length > 0);
        string list;
        if (fs.Types.length == 1) {
            list ~= "data_.memb"~fs.name;
        }
        else {
            foreach(i, T; fs.Types) {
                list ~= format("data_.memb%s[%s]", fs.name, i);
                if(i != fs.Types.length-1) {
                    list ~= ", ";
                }
            }
        }
        return list;
    }

    bool matchNamesFit(mss...)() {
        string[] names;
        bool hasDefault = false;
        foreach(i, ms; mss) {
            if(names.canFind(ms.name)) {
                return false;
            }
            static if (ms.name == "default") {
                if(i != mss.length-1) {
                    return false;
                }
                hasDefault = true;
                break;
            }
            else {
                bool found = false;
                foreach(spec; FieldSpecs) {
                    if(spec.name == ms.name) {
                        found = true;
                        break;
                    }
                }
                if(!found) return false;
                names ~= ms.name;
            }
        }
        if(!hasDefault) {
            foreach(spec; FieldSpecs) {
                if(!names.canFind(spec.name)) {
                    return false;
                }
            }
        }
        return true;
    }

    bool matchHasDefault(mss...)() {
        foreach(ms; mss) {
            static if(ms.name == "default") {
                return true;
            }
        }
        return false;
    }



    string tagContentInject() {
        string s;
        foreach(i, spec; FieldSpecs) {
            s ~= spec.name;
            if (i != FieldSpecs.length-1) {
                s ~= ", ";
            }
        }
        return s;
    }

    string tagInitInject() {
        import std.format : format;
        alias spec = FieldSpecs[0];
        return format("Tag_.%s", spec.name);
    }

    string tagAliasesInject() {
        import std.format : format;
        string s;
        foreach(spec; FieldSpecs) {
            s ~= format("alias %1$s = Tag_.%1$s;\n", spec.name);
        }
        return s;
    }

    string unionContentInject() {
        import std.format : format;
        string s;
        foreach(spec; TypedFieldSpecs) {
            s ~= format("%s memb%s;\n", fieldType!spec(), spec.name);
        }
        return s;
    }

    string unionInitInject() {
        import std.format : format;
        string s;
        alias spec = FieldSpecs[0];
        static if (spec.Types.length > 0) {
            s ~= format("{ memb%s : (%s).init }", spec.name, fieldType!spec());
        }
        else {
            s ~= "Data_.init";
        }
        return s;
    }

    string ctorsInject() {
        import std.conv : to;
        string s;
        foreach(spec; FieldSpecs) {
            immutable fts = fieldTypes!spec();
            s ~= format("static SafeUnion make%s(", spec.upperName);
            foreach(i, T; spec.Types) {
                string ind;
                if(spec.Types.length > 1) {
                    ind = (i+1).to!string;
                }
                s ~= format("%s val%s", fullyQualifiedName!T, ind);
                if(i != spec.Types.length-1) {
                    s ~= ", ";
                }
            }
            s ~= ") {\n";
            s ~= "    auto data = Data_.init;\n";
            if (spec.Types.length == 1) {
                s ~= format("    data.memb%s = val;\n", spec.name);
            }
            else if (spec.Types.length > 1) {
                string tup = "tuple(";
                foreach(i; 0..spec.Types.length) {
                    tup ~= "val"~(i+1).to!string;
                    if(i != spec.Types.length-1) {
                        tup ~= ", ";
                    }
                }
                tup ~= ")";
                s ~= format("    data.memb%s = %s;\n", spec.name, tup);
            }
            s ~= format("    auto tag = Tag_.%s;\n", spec.name);
            s ~= "    return SafeUnion(data, tag);\n";
            s ~= "}\n";
        }
        return s;
    }

    string testsInject() {
        string s;
        foreach(spec; FieldSpecs) {
            s ~= "@property bool is"~spec.upperName~"() const {\n";
            s ~= "    return tag == Tag_."~spec.name~";\n";
            s ~= "}\n";
        }
        return s;
    }

    string gettersInject() {
        string s;
        foreach(spec; TypedFieldSpecs) {
            s ~= "@property "~fieldType!spec()~" get"~spec.upperName~"() const {\n";
            s ~= "    assert(is"~spec.upperName~");\n";
            s ~= "    return data_.memb"~spec.name~";\n";
            s ~= "}\n";
        }
        return s;
    }

    string cmpInject() {
        import std.format : format;
        string s;
        s ~= "int opCmp(ref const SafeUnion su) const {\n";
        s ~= "    if(tag_ != su.tag_) return tag_ < su.tag_ ? -1 : +1;\n";
        s ~= "    final switch(tag_) {\n";
        foreach(spec; FieldSpecs) {
            s ~= format("    case Tag_.%s:\n", spec.name);
            if (spec.Types.length > 0) {
                string memb = format("data_.memb%s", spec.name);
                s ~= format("        if(%1$s == su.%1$s) return 0;\n", memb);
                s ~= format("        return %1$s < su.%1$s ? -1 : +1;\n", memb);
            }
            else {
                s ~= "        return 0;\n";
            }
        }
        s ~= "    }\n";
        s ~= "}\n";
        return s;
    }

    string toStringInject() {
        import std.format : format;
        string s;
        s ~= "string toString() const @safe {\n";
        s ~= "    import std.conv : to;\n";
        s ~= "    final switch(tag_) {\n";
        foreach(spec; FieldSpecs) {
            s ~= format("    case Tag_.%s:\n", spec.name);
            if (spec.Types.length == 0) {
                s ~= format("        return \"%s\";\n", spec.name);
            }
            else if (spec.Types.length == 1) {
                string memb = format("data_.memb%s", spec.name);
                s ~= format("        return \"%s(\"~%s.to!string~\")\";\n", spec.name, memb);
            }
            else {
                string memb = format("data_.memb%s", spec.name);
                string list;
                foreach(i, T; spec.Types) {
                    list ~= format("%s[%s].to!string~", memb, i);
                }
                s ~= format("        return \"%s(\"~%s\")\";\n", spec.name, list);
            }
        }
        s ~= "    }\n";
        s ~= "}\n";
        return s;
    }

}



unittest
{
    alias Option(T) = SafeUnion!(
        "some", T,
        "none"
    );

    alias ContType = SafeUnion!(
        "single",
        "vector", size_t,
        "matrix", bool, size_t, size_t,
    );

    alias OptionInt = Option!int;

    auto sing = ContType.makeSingle();
    auto vec = ContType.makeVector(3);
    auto mat = ContType.makeMatrix(true, 4, 4);

    sing.match!(
        "single", () {},
        "vector", (size_t d) { assert(false); },
        "matrix", (bool cm, size_t d1, size_t d2) { assert(false); },
    )();
    vec.match!(
        "vector", (size_t d) { assert(d == 3); },
        "default", () { assert(false); },
    )();
    mat.match!(
        "vector", (size_t d) { assert(false); },
        "default", () {},
    )();
}
