module gfx.decl.engine;

import gfx.core.rc : Disposable;
import gfx.core.typecons : Option;
import gfx.graal.format : Format;
import sdlang;

class GfxSDLErrorException : Exception
{
    string msg;
    Location location;

    this(string msg, Location location) {
        import std.format : format;
        this.msg = msg;
        this.location = location;
        super(format("%s:(%s,%s): Gfx-SDL error: %s", location.file, location.line, location.col, msg));
    }
}

class NoSuchStructException : GfxSDLErrorException
{
    string structName;

    this(string structName, Location location=Location.init)
    {
        import std.format : format;
        this.structName = structName;
        super(format("no such struct: %s", structName), location);
    }
}

class NoSuchFieldException : GfxSDLErrorException
{
    string structName;
    string fieldName;

    this(string structName, string fieldName, Location location=Location.init)
    {
        import std.format : format;
        this.structName = structName;
        this.fieldName = fieldName;
        super(format("no such field: %s.%s", structName, fieldName), location);
    }
}

class UnknownFieldFormatException : GfxSDLErrorException
{
    string structName;
    string fieldName;

    this(string structName, string fieldName, Location location=Location.init)
    {
        import std.format : format;
        this.structName = structName;
        this.fieldName = fieldName;
        super(format("field format is not known for: %s.%s", structName, fieldName), location);
    }
}

class DeclarativeEngine : Disposable
{
    import gfx.core.rc : Rc;
    import gfx.decl.store : DeclarativeStore;
    import gfx.graal.device : Device;
    import gfx.graal.pipeline;
    import std.exception : enforce;
    import std.format : format;

    private Rc!Device _device;
    private DeclarativeStore _store;
    private string[] _assetPaths;
    private immutable(void)[][string] _views;
    private StructDecl[] _structDecls;
    private int _storeAnonKey;


    this(Device device) {
        _device = device;
        _store = new DeclarativeStore;
    }

    override void dispose() {
        _store.dispose();
        _store = null;
        _device.unload();
    }

    @property DeclarativeStore store() {
        return _store;
    }

    void addAssetPath(in string path) {
        _assetPaths ~= path;
    }

    void addView(string name)() {
        _views[name] = cast(immutable(void)[])import(name);
    }

    void declareStruct(T)() {
        _structDecls ~= StructDecl.makeFor!T();
    }

    void runSDLSource(string sdl, string filename=null)
    {
        auto root = parseSource(sdl, filename);
        runSDL(root);
    }

    void runSDLFile(string filename)
    {
        auto root = parseFile(filename);
        runSDL(root);
    }


    private void runSDL(Tag root)
    {
        PipelineInfo[] plis;
        string[] plKeys;

        foreach (t; root.namespaces["graal"].tags) {
            if (t.name == "descriptorSetLayout") {
                DescriptorSetLayout dsl;
                const key = parseDescriptorSetLayout(t, dsl);
                store.store!DescriptorSetLayout(key, dsl);
            }
            else if (t.name == "pipelineLayout") {
                PipelineLayout pll;
                const key = parsePipelineLayout(t, pll);
                store.store!PipelineLayout(key, pll);
            }
            else if (t.name == "pipeline") {
                PipelineInfo pli = void;
                plKeys ~= parsePipelineInfo(t, pli, true);
                plis ~= pli;
            }
            else if (t.name == "pipelineInfo") {
                PipelineInfo pli = void;
                const key = parsePipelineInfo(t, pli, false);
                store.store!PipelineInfo(key, pli);
            }
        }

        if (plis.length) {
            static void releaseSh(ShaderModule shm) {
                if (shm) shm.release();
            }
            auto pls = _device.createPipelines(plis);
            foreach(i, pl; pls) {
                store.store!Pipeline(plKeys[i], pl);
                releaseSh(plis[i].shaders.vertex);
                releaseSh(plis[i].shaders.tessControl);
                releaseSh(plis[i].shaders.tessEval);
                releaseSh(plis[i].shaders.geometry);
                releaseSh(plis[i].shaders.fragment);
            }
        }
    }

    private string parseDescriptorSetLayout(Tag tag, out DescriptorSetLayout dsl)
    {
        import std.conv : to;

        string storeKey = tag.getTagValue!string("store");
        if (!storeKey) storeKey = newAnonKey();

        PipelineLayoutBinding[] bindings;
        auto btags = tag.expectTag("bindings");
        foreach (bt; btags.all.tags) {
            PipelineLayoutBinding binding;
            binding.binding = bt.expectValue!int();
            binding.descriptorType = bt.expectAttribute!string("descriptorType").to!DescriptorType;
            binding.descriptorCount = bt.expectAttribute!int("descriptorCount");
            binding.stages = bt.expectAttribute!string("stages").parseFlags!ShaderStage();
            bindings ~= binding;
        }

        dsl = _device.createDescriptorSetLayout(bindings);
        return storeKey;
    }

    private string parsePipelineLayout(Tag tag, out PipelineLayout pll)
    {
        string storeKey = tag.getTagValue!string("store");
        if (!storeKey) storeKey = newAnonKey();

        DescriptorSetLayout[] layouts;
        auto layoutsTag = tag.getTag("layouts");
        if (layoutsTag) {
            foreach (lt; layoutsTag.all.tags) {
                layouts ~= parseStoreRefOrLiteral!(DescriptorSetLayout, parseDescriptorSetLayout)(lt);
            }
        }

        PushConstantRange[] ranges;
        auto rangesTag = tag.getTag("ranges");
        if (rangesTag) {
            foreach (rt; rangesTag.all.tags) {
                PushConstantRange pcr;
                pcr.stages = rt.expectAttribute!string("stages").parseFlags!ShaderStage();
                pcr.size = expectSizeOffsetAttr(rt, "size");
                pcr.offset = expectSizeOffsetAttr(rt, "offset");
                ranges ~= pcr;
            }
        }

        pll = _device.createPipelineLayout(layouts, ranges);
        return storeKey;
    }

    private string parsePipelineInfo(Tag tag, out PipelineInfo plInfo, bool willReleaseShaders)
    {
        return null;
    }

    private string newAnonKey()
    {
        import std.conv : to;
        const key = ++_storeAnonKey;
        return key.to!string;
    }

    private T parseStoreRefOrLiteral(T, alias parseF)(Tag tag)
    {
        import std.format : format;

        string storeStr = tag.getValue!string();
        const hasChildren = tag.all.tags.length > 0;

        if (storeStr && hasChildren) {
            throw new GfxSDLErrorException(
                format("Cannot parse %s: both value and children specified", T.stringof),
                tag.location
            );
        }
        if (!storeStr && !hasChildren) {
            // likely value was not a string, or only attributes specified
            throw new GfxSDLErrorException(
                format("Cannot parse %s", T.stringof), tag.location
            );
        }
        T res;
        if (storeStr) {
            import std.algorithm : startsWith;
            if (!storeStr.startsWith("store:")) {
                throw new GfxSDLErrorException(
                    format("Cannot parse DescriptorSetLayout: " ~
                        "must specify a store reference or a literal " ~
                        "(\"%s\" is not a valid store reference)", storeStr),
                    tag.location
                );
            }
            const key = storeStr["store:".length .. $];
            res = _store.expect!T(key);
        }
        else {
            const key = parseF(tag, res);
            _store.store(key, res);
        }
        return enforce(res);
    }


    private uint expectSizeOffsetAttr(Tag tag, in string attrName)
    {
        auto attr = tag.findAttr(attrName);
        if (!attr) {
            throw new GfxSDLErrorException(
                "Could not find attribute "~attrName, tag.location
            );
        }

        if (attr.value.convertsTo!int) {
            return attr.value.get!int();
        }

        import std.algorithm : findSplit, startsWith;
        string s = attr.value.get!string();
        if (s.startsWith("sizeof:")) {
            const sf = s["sizeof:".length .. $].findSplit(".");
            const struct_ = sf[0];
            const field = sf[2];
            const sd = findStruct(struct_, attr.location);
            if (field) {
                return cast(uint)sd.getSize(field, attr.location);
            }
            else {
                return cast(uint)sd.size;
            }
        }
        if (s.startsWith("offsetof:")) {
            const sf = s["offsetof:".length .. $].findSplit(".");
            const struct_ = sf[0];
            const field = sf[2];
            if (!field.length) {
                throw new GfxSDLErrorException(
                    format("\"%s\" cannot resolve to a struct field (required by \"offsetof:\"", sf),
                    attr.location
                );
            }
            return cast(uint)findStruct(struct_, attr.location).getOffset(field, attr.location);
        }
        throw new GfxSDLErrorException(
            "Could not find attribute "~attrName, tag.location
        );
    }

    private StructDecl findStruct(in string name, Location location) {
        foreach (ref sd; _structDecls) {
            if (sd.name == name) return sd;
        }
        throw new NoSuchStructException(name, location);
    }
}

private:

Attribute findAttr(Tag tag, string attrName)
{
    foreach (attr; tag.attributes)
        if (attr.name == attrName) return attr;
    return null;
}

E parseFlags(E)(in string s) if (is(E == enum))
{
    import std.array : split;
    import std.string : strip;
    import std.conv : to;

    const fl = s.split('|');
    E res = cast(E)0;
    foreach (f; fl) {
        res |= f.strip().to!E;
    }
    return res;
}


struct FieldDecl
{
    string name;
    size_t size;
    size_t offset;
    Option!Format format;
}

struct StructDecl
{
    string name;
    size_t size;
    FieldDecl[] fields;

    static StructDecl makeFor(T)()
    {
        import std.traits : FieldNameTuple, Fields, getUDAs;

        alias F = Fields!T;
        alias N = FieldNameTuple!T;

        const offsets = T.init.tupleof.offsetof;

        StructDecl sd;
        sd.name = T.stringof;
        sd.size = T.sizeof;
        foreach(i, FT; F) {
            FieldDecl fd;
            fd.name = N[i];
            fd.size = FT.sizeof;
            fd.offset = offsets[i];

            auto udas = getUDAs!(__traits(getMember, T, N[i]), Format);
            static if (udas.length) {
                fd.format = udas[0];
            }
            else {
                fd.format = inferFieldFormat!FT();
            }

            sd.fields ~= fd;
        }
        return sd;
    }

    size_t getSize(in string field, in Location location=Location.init) const
    {
        foreach(f; fields) {
            if (f.name == field)
                return f.size;
        }
        throw new NoSuchFieldException(name, field, location);
    }

    size_t getOffset(in string field, in Location location=Location.init) const
    {
        foreach(f; fields) {
            if (f.name == field)
                return f.offset;
        }
        throw new NoSuchFieldException(name, field, location);
    }

    Format getFormat(in string field, in Location location=Location.init) const
    {
        foreach(f; fields) {
            if (f.name == field) {
                if (f.format.isSome) {
                    return f.format.get;
                }
                else {
                    throw new UnknownFieldFormatException(name, field, location);
                }
            }
        }
        throw new NoSuchFieldException(name, field, location);
    }
}

///
version(unittest)
{
    struct SomeVecType
    {
        private float[3] rep;
    }

    struct SomeVertexType
    {
        SomeVecType pos;

        float[3] normal;

        @(Format.rgba32_sFloat)
        float[4] color;

        @(Format.rgba8_uInt)
        ubyte[4] otherField;

        ubyte[4] yetAnotherField;

        @(Format.rgba16_sFloat)
        float[3] problemField;
    }

    unittest {
        const sd = StructDecl.makeFor!SomeVertexType();
        assert(sd.name == "SomeVertexType");
        assert(sd.size == SomeVertexType.sizeof);
        assert(sd.fields[0].name == "pos");
        assert(sd.fields[1].name == "normal");
        assert(sd.fields[2].name == "color");
        assert(sd.fields[3].name == "otherField");
        assert(sd.fields[4].name == "yetAnotherField");
        assert(sd.fields[5].name == "problemField");

        assert(sd.getSize("pos") == SomeVertexType.pos.sizeof);
        assert(sd.getSize("normal") == SomeVertexType.normal.sizeof);
        assert(sd.getSize("color") == SomeVertexType.color.sizeof);
        assert(sd.getSize("otherField") == SomeVertexType.otherField.sizeof);
        assert(sd.getSize("yetAnotherField") == SomeVertexType.yetAnotherField.sizeof);
        assert(sd.getSize("problemField") == SomeVertexType.problemField.sizeof);

        assert(sd.getOffset("pos") == SomeVertexType.pos.offsetof);
        assert(sd.getOffset("normal") == SomeVertexType.normal.offsetof);
        assert(sd.getOffset("color") == SomeVertexType.color.offsetof);
        assert(sd.getOffset("otherField") == SomeVertexType.otherField.offsetof);
        assert(sd.getOffset("yetAnotherField") == SomeVertexType.yetAnotherField.offsetof);
        assert(sd.getOffset("problemField") == SomeVertexType.problemField.offsetof);

        assert(sd.getFormat("pos") == Format.rgb32_sFloat);
        assert(sd.getFormat("normal") == Format.rgb32_sFloat);
        assert(sd.getFormat("color") == Format.rgba32_sFloat);
        assert(sd.getFormat("otherField") == Format.rgba8_uInt);
        assert(sd.getFormat("problemField") == Format.rgba16_sFloat);

        import std.exception : assertThrown;
        assertThrown!NoSuchFieldException(sd.getSize("jfidjf"));
        assertThrown!UnknownFieldFormatException(sd.getFormat("yetAnotherField"));
    }
}

Option!Format inferFieldFormat(T)()
{
    import gfx.core.typecons : none, some;
    import std.traits : RepresentationTypeTuple;

    alias rtt = RepresentationTypeTuple!T;

    static if (is(T == float)) {
        return some(Format.r32_sFloat);
    }
    else static if (is(T V : V[N], int N)) {
        static if (is(V == float) && N == 1) {
            return some(Format.r32_sFloat);
        }
        else static if (is(V == float) && N == 2) {
            return some(Format.rg32_sFloat);
        }
        else static if (is(V == float) && N == 3) {
            return some(Format.rgb32_sFloat);
        }
        else static if (is(V == float) && N == 4) {
            return some(Format.rgba32_sFloat);
        }
        else {
            return none!Format;
        }
    }
    else static if (rtt.length == 1 && !is(rtt[0] == T)) {
        return inferFieldFormat!(rtt[0])();
    }
    else {
        return none!Format;
    }
}
