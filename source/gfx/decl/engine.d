module gfx.decl.engine;

import gfx.core.rc : Disposable;
import gfx.core.typecons : Option;
import gfx.graal.format : Format;

class NoSuchStructException : Exception
{
    string structName;

    this(string structName)
    {
        import std.format : format;
        this.structName = structName;
        super(format("no such struct: %s", structName));
    }
}

class NoSuchFieldException : Exception
{
    string structName;
    string fieldName;

    this(string structName, string fieldName)
    {
        import std.format : format;
        this.structName = structName;
        this.fieldName = fieldName;
        super(format("no such field: %s.%s", structName, fieldName));
    }
}

class UnknownFieldFormatException : Exception
{
    string structName;
    string fieldName;

    this(string structName, string fieldName)
    {
        import std.format : format;
        this.structName = structName;
        this.fieldName = fieldName;
        super(format("field format is not known for: %s.%s", structName, fieldName));
    }
}

class DeclarativeEngine : Disposable
{
    import gfx.core.rc : Rc;
    import gfx.decl.store : DeclarativeStore;
    import gfx.graal.device : Device;
    import gfx.graal.pipeline;
    import sdlang;

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
        return null;
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
}

private:


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

    size_t getSize(in string field) const
    {
        foreach(f; fields) {
            if (f.name == field)
                return f.size;
        }
        throw new NoSuchFieldException(name, field);
    }

    size_t getOffset(in string field) const
    {
        foreach(f; fields) {
            if (f.name == field)
                return f.offset;
        }
        throw new NoSuchFieldException(name, field);
    }

    Format getFormat(in string field) const
    {
        foreach(f; fields) {
            if (f.name == field) {
                if (f.format.isSome) {
                    return f.format.get;
                }
                else {
                    throw new UnknownFieldFormatException(name, field);
                }
            }
        }
        throw new NoSuchFieldException(name, field);
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
