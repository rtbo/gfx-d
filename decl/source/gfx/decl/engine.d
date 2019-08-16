module gfx.decl.engine;

import gfx.core.rc : Disposable;
import gfx.core.typecons : Option;
import gfx.graal.format : Format;
import gfx.decl.sdlang;

class GfxSDLErrorException : Exception
{
    string msg;
    Location location;

    this(string msg, Location location) {
        import std.format : format;
        this.msg = msg;
        this.location = location;
        super(format("%s:(%s,%s): Gfx-SDL error: %s", location.file, location.line+1, location.col+1, msg));
    }
}

class NoSuchAssetException : GfxSDLErrorException
{
    string assetPath;

    this(string assetPath, Location location=Location.init)
    {
        import std.format : format;
        this.assetPath = assetPath;
        super(format("no such asset: %s", assetPath), location);
    }
}

class NoSuchViewException : GfxSDLErrorException
{
    string viewName;

    this(string viewName, Location location=Location.init)
    {
        import std.format : format;
        this.viewName = viewName;
        super(format("no such view: %s", viewName), location);
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
    import gfx.core.typecons;
    import gfx.decl.store : DeclarativeStore;
    import gfx.graal.cmd : Access, PipelineStage;
    import gfx.graal.device : Device;
    import gfx.graal.image : ImageLayout;
    import gfx.graal.pipeline;
    import gfx.graal.renderpass;
    import gfx.graal.types;
    import std.exception : enforce;
    import std.format : format;

    private Rc!Device _device;
    private DeclarativeStore _store;
    private string[] _assetPaths;
    private immutable(void)[][string] _views;
    private StructDecl[] _structDecls;
    private string[] _localKeys;
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

    void parseSDLSource(string sdl, string filename=null)
    {
        auto root = parseSource(sdl, filename);
        parseSDL(root);
    }

    void parseSDLFile(string filename)
    {
        auto root = parseFile(filename);
        parseSDL(root);
    }

    void parseSDLView(string name)()
    {
        const sdl = cast(string)import(name);
        auto root = parseSource(sdl, name);
        parseSDL(root);
    }


    private void parseSDL(Tag root)
    {
        PipelineInfo[] plis;
        string[] plKeys;

        foreach (t; root.namespaces["graal"].tags) {
            if (t.name == "RenderPass") {
                RenderPass rp;
                const key = parseRenderPass(t, rp);
                _store.store!RenderPass(key, rp);
            }
            else if (t.name == "DescriptorSetLayout") {
                DescriptorSetLayout dsl;
                const key = parseDescriptorSetLayout(t, dsl);
                _store.store!DescriptorSetLayout(key, dsl);
            }
            else if (t.name == "PipelineLayout") {
                PipelineLayout pll;
                const key = parsePipelineLayout(t, pll);
                _store.store!PipelineLayout(key, pll);
            }
            else if (t.name == "ShaderModule") {
                ShaderModule sm;
                const key = parseShaderModule(t, sm);
                _store.store!ShaderModule(key, sm);
            }
            else if (t.name == "Pipeline") {
                PipelineInfo pli = void;
                plKeys ~= parsePipelineInfo(t, pli);
                plis ~= pli;
            }
            else if (t.name == "PipelineInfo") {
                PipelineInfo pli = void;
                const key = parsePipelineInfo(t, pli);
                _store.store!PipelineInfo(key, pli);
            }
        }

        if (plis.length) {
            auto pls = _device.createPipelines(plis);
            foreach(i, pl; pls) {
                _store.store!Pipeline(plKeys[i], pl);
            }
        }

        foreach (k; _localKeys) _store.remove(k);
    }

    private string parseRenderPass(Tag tag, out RenderPass rp)
    {
        auto attachments = parseAttachmentDescriptions(tag.getTag("attachments"));
        auto subpasses = parseSubpassDescriptions(tag);
        auto dependencies = parseSubpassDependencies(tag);

        rp = _device.createRenderPass(attachments, subpasses, dependencies);

        return getStoreKey(tag);
    }

    private AttachmentDescription[] parseAttachmentDescriptions(Tag tag)
    {
        import std.conv : to;
        import std.typecons : Flag;
        if(!tag) return [];

        AttachmentDescription[] res;

        foreach (adt; tag.tags) {
            AttachmentDescription ad;
            ad.samples = cast(uint)adt.getAttribute!int("samples", ad.samples);
            ad.mayAlias = cast(Flag!"mayAlias")adt.getAttribute!bool("mayAlias", cast(bool)ad.mayAlias);
            foreach (c; adt.tags) {
                if (c.name == "format") {
                    ad.format = expectLiteralOrStoreValValue!Format(c);
                }
                else if (c.name == "layout") {
                    ad.layoutTrans.from = c.expectAttribute!string("from").to!ImageLayout;
                    ad.layoutTrans.to = c.expectAttribute!string("to").to!ImageLayout;
                }
            }
            if (adt.name == "color" || adt.name == "depth") {
                ad.ops = parseAttachmentOps(adt.expectTag("ops"));
            }
            else if (adt.name == "stencil") {
                ad.stencilOps = parseAttachmentOps(adt.expectTag("ops"));
            }
            else if (adt.name == "depthStencil") {
                ad.ops = parseAttachmentOps(adt.expectTag("depthOps"));
                ad.stencilOps = parseAttachmentOps(adt.expectTag("stencilOps"));
            }
            else {
                throw new GfxSDLErrorException("unexpected attachment type: "~adt.name, adt.location);
            }
            res ~= ad;
        }
        return res;
    }

    AttachmentOps parseAttachmentOps(Tag tag)
    {
        import std.conv : to;
        AttachmentOps ops;
        ops.load = tag.expectAttribute!string("load").to!LoadOp;
        ops.store = tag.expectAttribute!string("store").to!StoreOp;
        return ops;
    }

    SubpassDescription[] parseSubpassDescriptions(Tag tag)
    {
        import std.algorithm : filter;

        SubpassDescription[] res;
        foreach(sdt; tag.tags.filter!(t => t.name == "subpass")) {
            SubpassDescription sd;
            foreach (t; sdt.tags) {
                if (t.name == "input") {
                    sd.inputs ~= parseAttachmentRef(t);
                }
                else if (t.name == "color") {
                    sd.colors ~= parseAttachmentRef(t);
                }
                else if (t.name == "depthStencil") {
                    sd.depthStencil = parseAttachmentRef(t);
                }
                else if (t.name == "preserves") {
                    import std.algorithm : map;
                    import std.array : array;
                    sd.preserves = t.values.map!(v => cast(uint)v.get!int()).array();
                }
            }
            res ~= sd;
        }
        return res;
    }

    AttachmentRef parseAttachmentRef(Tag tag)
    {
        import std.conv : to;
        AttachmentRef res=void;
        res.attachment = cast(uint)tag.expectAttribute!int("attachment");
        res.layout = tag.expectAttribute!string("layout").to!ImageLayout;
        return res;
    }

    SubpassDependency[] parseSubpassDependencies(Tag tag)
    {
        import std.algorithm : filter;
        import std.conv : to;

        SubpassDependency[] res;
        foreach(sdt; tag.tags.filter!(t => t.name == "dependency")) {
            SubpassDependency sd=void;
            auto t = sdt.expectTag("subpass");
            sd.subpass.from = parseSubpassRef(t, "from");
            sd.subpass.to = parseSubpassRef(t, "to");
            t = sdt.expectTag("stageMask");
            sd.stageMask.from = t.expectAttribute!string("from").parseFlags!PipelineStage();
            sd.stageMask.to = t.expectAttribute!string("to").parseFlags!PipelineStage();
            t = sdt.expectTag("accessMask");
            sd.accessMask.from = t.expectAttribute!string("from").parseFlags!Access();
            sd.accessMask.to = t.expectAttribute!string("to").parseFlags!Access();
            res ~= sd;
        }
        return res;
    }

    uint parseSubpassRef(Tag tag, string attrName)
    {
        import std.conv : to;
        int val;
        string str;
        if (tryGetAttr!int(tag, attrName, val)) {
            return cast(uint)val;
        }
        if (tryGetAttr!string(tag, attrName, str)) {
            if (str == "external") {
                return subpassExternal;
            }
        }
        throw new GfxSDLErrorException(
            "could not resolve subpass", tag.location
        );
    }

    private string parseDescriptorSetLayout(Tag tag, out DescriptorSetLayout dsl)
    {
        import std.conv : to;

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
        return getStoreKey(tag);
    }

    private string parsePipelineLayout(Tag tag, out PipelineLayout pll)
    {
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
        return getStoreKey(tag);
    }

    private string parseShaderModule(Tag tag, out ShaderModule mod)
    {
        immutable(uint)[] src;
        auto st = tag.expectTag("source");
        string srcStr;
        ubyte[] srcData;
        if (st.tryGetValue!string(srcStr)) {
            src = getShaderSrcFromString(srcStr, st.location);
        }
        else if (st.tryGetValue!(ubyte[])(srcData)) {
            import std.exception : assumeUnique;
            src = assumeUnique(cast(uint[])srcData);
        }
        else {
            throw new GfxSDLErrorException(
                "ill-formed source tag in graal:ShaderModule", tag.location
            );
        }

        const ep = tag.getTagValue!string("entryPoint", "main");

        mod = _device.createShaderModule(src, ep);
        return getStoreKey(tag);
    }

    private string parseShaderModuleAttr(Tag tag, out ShaderModule mod)
    {
        immutable(uint)[] src;
        auto srcAttr = enforce(findAttr(tag, "source"), new GfxSDLErrorException(
            "source attribute is mandatory in graal:ShaderModule", tag.location
        ));
        string srcStr;
        ubyte[] srcData;
        if (srcAttr.tryGetValue!string(srcStr)) {
            src = getShaderSrcFromString(srcStr, srcAttr.location);
        }
        else if (srcAttr.tryGetValue!(ubyte[])(srcData)) {
            import std.exception : assumeUnique;
            src = assumeUnique(cast(uint[])srcData);
        }
        else {
            throw new GfxSDLErrorException(
                "ill-formed source attribute in graal:ShaderModule", tag.location
            );
        }

        const ep = tag.getAttribute!string("entryPoint", "main");

        mod = _device.createShaderModule(src, ep);
        return getStoreKeyAttr(tag);
    }

    immutable(uint)[] getShaderSrcFromString(in string srcStr, in Location location)
    {
        import std.algorithm : startsWith;

        if (srcStr.startsWith("view:")) {
            const name = srcStr["view:".length .. $];
            return cast(immutable(uint)[])getView(name, location);
        }
        else if (srcStr.startsWith("asset:")) {
            const name = srcStr["asset:".length .. $];
            return cast(immutable(uint)[])getAsset(name, location);
        }
        else {
            throw new GfxSDLErrorException(
                format("\"%s\" could not lead to a shader source file", srcStr),
                location
            );
        }
    }

    private string parsePipelineInfo(Tag tag, out PipelineInfo plInfo)
    {
        foreach (t; tag.expectTag("shaders").tags) {
            ShaderModule sm;
            if (t.attributes.length) {
                // inline shader
                const key = parseShaderModuleAttr(t, sm);
                _store.store!ShaderModule(key, sm);
            }
            else {
                // literal or alreadystored
                sm = parseStoreRefOrLiteral!(ShaderModule, parseShaderModule)(t);
            }
            switch (t.name) {
            case "vertex":      plInfo.shaders.vertex = sm; break;
            case "tessControl": plInfo.shaders.tessControl = sm; break;
            case "tessEval":    plInfo.shaders.tessEval = sm; break;
            case "geometry":    plInfo.shaders.geometry = sm; break;
            case "fragment":    plInfo.shaders.fragment = sm; break;
            default:
                throw new GfxSDLErrorException(
                    "Unknown shader stage: " ~ t.name, t.location
                );
            }
        }

        foreach(t; tag.expectTag("inputBindings").tags) {
            VertexInputBinding vib;
            vib.binding = t.expectValue!int();
            vib.stride = expectSizeOffsetAttr(t, "stride");
            import std.typecons : Flag;
            vib.instanced = cast(Flag!"instanced")t.getAttribute!bool("instanced", false);
            plInfo.inputBindings ~= vib;
        }

        foreach(t; tag.expectTag("inputAttribs").tags) {
            VertexInputAttrib via;
            via.location = t.expectValue!int();
            via.binding = t.expectAttribute!int("binding");
            auto attr = t.findAttr("member");
            if (attr) {
                import std.algorithm : findSplit;
                const ms = attr.value.get!string();
                const sf = ms.findSplit(".");
                if (!sf[2].length) {
                    throw new GfxSDLErrorException(format(
                        "could not resolve \"%s\" to a struct field", ms
                    ), attr.location);
                }
                const s = findStruct(sf[0], attr.location);
                via.format = s.getFormat(sf[2], attr.location);
                via.offset = s.getOffset(sf[2], attr.location);
            }
            else {
                via.format = expectFormatAttr(t, "format");
                via.offset = expectSizeOffsetAttr(t, "offset");
            }
            plInfo.inputAttribs ~= via;
        }

        plInfo.assembly = parseInputAssembly(tag.expectTag("assembly"));
        plInfo.rasterizer = parseRasterizer(tag.expectTag("rasterizer"));
        plInfo.viewports = parseViewportConfigs(tag);
        plInfo.depthInfo = parseDepthInfo(tag.getTag("depthInfo"));
        plInfo.stencilInfo = parseStencilInfo(tag.getTag("stencilInfo"));
        plInfo.blendInfo = parseColorBlendInfo(tag.expectTag("blendInfo"));
        auto dynTag = tag.getTag("dynamicStates");
        if (dynTag) {
            import std.algorithm : map;
            import std.array : array;
            import std.conv : to;
            plInfo.dynamicStates = dynTag.values.map!(v => v.get!string.to!DynamicState).array;
        }
        plInfo.layout = parseStoreRefOrLiteral!(PipelineLayout, parsePipelineLayout)(tag.expectTag("layout"));
        auto rpTag = tag.expectTag("renderPass");
        plInfo.renderPass = expectStoreRef!RenderPass(rpTag);
        plInfo.subpassIndex = rpTag.expectAttribute!int("subpass");

        return getStoreKey(tag);
    }

    private InputAssembly parseInputAssembly(Tag tag)
    {
        import std.conv : to;
        import std.typecons : Flag;

        InputAssembly assembly;
        assembly.primitive = tag.expectAttribute!string("primitive").to!Primitive;
        assembly.primitiveRestart =
                cast(Flag!"primitiveRestart")tag.getAttribute!bool("primitiveRestart", false);
        return assembly;
    }

    private Rasterizer parseRasterizer(Tag tag)
    {
        import std.conv : to;
        import std.typecons : Flag;
        import gfx.core.typecons : some;

        Rasterizer res;
        res.mode = tag.expectAttribute!string("polygonMode").to!PolygonMode;
        res.cull = tag.getAttribute!string("cull", "none").parseFlags!Cull;
        res.front = tag.getAttribute!string("front", "ccw").to!FrontFace;
        res.depthClamp = cast(Flag!"depthClamp")tag.getAttribute!bool("depthClamp", false);
        res.lineWidth = tag.getAttribute!float("lineWidth", 1f);
        auto dbt = tag.getTag("depthBias");
        if (dbt) {
            DepthBias db;
            db.slopeFactor = dbt.expectAttribute!float("slope");
            db.constantFactor = dbt.expectAttribute!float("const");
            db.clamp = dbt.getAttribute!float("clamp", 0f);
            res.depthBias = some(db);
        }
        return res;
    }

    private ViewportConfig[] parseViewportConfigs(Tag plTag)
    {
        Viewport[] vps;
        Rect[] scs;
        Location loc;
        auto vpt = plTag.getTag("viewports");
        if (vpt) {
            foreach(t; plTag.tags) {
                if (t.name == "viewport") {
                    vps ~= parseViewport(t);
                }
                else if (t.name == "scissors") {
                    scs ~= parseRect(t);
                }
            }
            loc = vpt.location;
        }
        else {
            vpt = plTag.getTag("viewport");
            if (vpt) {
                vps ~= parseViewport(vpt);
                loc = vpt.location;
            }
        }

        if (!vps.length && !scs.length) return null;
        if (scs.length && scs.length != vps.length) {
            throw new GfxSDLErrorException("must state the same number of viewport and scissors", loc);
        }

        ViewportConfig[] configs;
        if (vps.length == scs.length) {
            foreach (i; 0 .. vps.length) {
                configs ~= ViewportConfig(vps[i], scs[i]);
            }
        }
        else {
            assert(vps.length && !scs.length);
            foreach (vp; vps) {
                const sc = Rect(cast(uint)vp.x, cast(uint)vp.y, cast(uint)vp.width, cast(uint)vp.height);
                configs ~= ViewportConfig(vp, sc);
            }
        }
        return configs;
    }


    private Viewport parseViewport(Tag tag)
    {
        Viewport vp = void;
        vp.x = expectLiteralOrStoreValAttr!float(tag, "x");
        vp.y = expectLiteralOrStoreValAttr!float(tag, "y");
        vp.width = expectLiteralOrStoreValAttr!float(tag, "width");
        vp.height = expectLiteralOrStoreValAttr!float(tag, "height");
        vp.minDepth = getLiteralOrStoreValAttr!float(tag, "minDepth", 0f);
        vp.minDepth = getLiteralOrStoreValAttr!float(tag, "maxDepth", 1f);
        return vp;
    }

    private Rect parseRect(Tag tag)
    {
        Rect r = void;
        r.x = expectLiteralOrStoreValAttr!int(tag, "x");
        r.y = expectLiteralOrStoreValAttr!int(tag, "y");
        r.width = expectLiteralOrStoreValAttr!int(tag, "width");
        r.height = expectLiteralOrStoreValAttr!int(tag, "height");
        return r;
    }

    private DepthInfo parseDepthInfo(Tag tag)
    {
        import std.conv : to;
        import std.typecons : Flag;

        DepthInfo res;
        // no tag = disabled = init
        if (tag) {
            // can optionally specify on/off as value (defaults to on)
            res.enabled = cast(Flag!"enabled")tag.getValue!bool(true);
            if (res.enabled) {
                res.write = cast(Flag!"write")tag.expectAttribute!bool("write");
                res.compareOp = tag.expectAttribute!string("compareOp").to!CompareOp;
                auto bt = tag.getTag("boundsTest");
                if (bt) {
                    // same as depth test, on/off is optional and defaults to on
                    res.boundsTest = cast(Flag!"boundsTest")tag.getValue!bool(true);
                    if (res.boundsTest) {
                        res.minBounds = expectLiteralOrStoreValAttr!float(bt, "min");
                        res.maxBounds = expectLiteralOrStoreValAttr!float(bt, "max");
                    }
                }
            }
        }
        return res;
    }

    StencilInfo parseStencilInfo(Tag tag)
    {
        import std.typecons : Flag;

        StencilInfo res;
        if (tag) {
            res.enabled = cast(Flag!"enabled")tag.getValue!bool(true);
            res.front = parseStencilOpState(tag.getTag("front"));
            res.back = parseStencilOpState(tag.getTag("back"));
        }
        return res;
    }

    StencilOpState parseStencilOpState(Tag tag)
    {
        import std.conv : to;

        if (!tag) return StencilOpState.init;

        StencilOpState res = void;
        res.compareOp = tag.expectAttribute!string("compareOp").to!CompareOp;
        string ops;
        if (tag.tryGetAttr!string("op", ops)) {
            const op = ops.to!StencilOp;
            res.failOp = op; res.passOp = op; res.depthFailOp = op;
        }
        else {
            res.failOp = tag.expectAttribute!string("failOp").to!StencilOp;
            res.passOp = tag.expectAttribute!string("passOp").to!StencilOp;
            res.depthFailOp = tag.expectAttribute!string("depthFailOp").to!StencilOp;
        }
        int mask;
        if (tag.tryGetAttr!int("mask", mask)) {
            res.compareMask = mask; res.writeMask = mask; res.refMask = mask;
        }
        else {
            res.compareMask = tag.expectAttribute!int("compareMask");
            res.writeMask = tag.expectAttribute!int("writeMask");
            res.refMask = tag.expectAttribute!int("refMask");
        }
        return res;
    }

    private ColorBlendInfo parseColorBlendInfo(Tag tag)
    {
        import gfx.core.typecons : some;
        import std.conv : to;

        ColorBlendInfo res;

        bool lopEnabled;
        string lopStr;
        if (tag.tryGetAttr!bool("logicOp", lopEnabled)) {
            if (lopEnabled) {
                throw new GfxSDLErrorException("logicOp can only be set to off or to LogicOp value", tag.location);
            }
        }
        else if (tag.tryGetAttr!string("logicOp", lopStr)) {
            res.logicOp = some(lopStr.to!LogicOp);
        }

        auto attTag = tag.getTag("attachments");
        if (attTag) foreach(t; attTag.tags) {
            ColorBlendAttachment attachment;
            if (t.name == "blend") {
                import std.typecons : Yes;
                attachment.enabled = Yes.enabled;
                auto stateT = t.getTag("state");
                if (stateT) {
                    const state = parseBlendState(stateT);
                    attachment.colorBlend = state;
                    attachment.alphaBlend = state;
                }
                else {
                    attachment.colorBlend = parseBlendState(t.expectTag("color"));
                    attachment.alphaBlend = parseBlendState(t.expectTag("alpha"));
                }
            }
            else if (t.name != "solid") {
                throw new GfxSDLErrorException(format(
                    "tag \"%s\" is not allowed in color attachments", t.name
                ), t.location);
            }
            string maskStr;
            if (t.tryGetAttr!string("colorMask", maskStr)) {
                attachment.colorMask = maskStr.to!ColorMask;
            }
            else {
                attachment.colorMask = ColorMask.all;
            }
            res.attachments ~= attachment;
        }

        auto constTag = tag.getTag("blendConstants");
        if (constTag) {
            import std.algorithm : map;
            import std.array : array;

            const bc = constTag.values.map!(v => v.coerce!float).array;
            if (bc.length != 4) {
                throw new GfxSDLErrorException("blendConstants must have 4 floats", constTag.location);
            }
            res.blendConstants = bc;
        }

        return res;
    }

    private BlendState parseBlendState(Tag tag)
    {
        import std.conv : to;

        BlendState state;
        state.factor.from = tag.expectAttribute!string("srcFactor").to!BlendFactor;
        state.factor.to = tag.expectAttribute!string("dstFactor").to!BlendFactor;
        state.op = tag.expectAttribute!string("op").to!BlendOp;
        return state;
    }

    private string getStoreKey(Tag tag)
    {
        auto t = tag.getTag("store");
        if (t) return t.expectValue!string();
        t = tag.getTag("local-store");
        if (t) {
            const key = t.expectValue!string();
            _localKeys ~= key;
            return key;
        }
        else {
            const key = newAnonKey();
            _localKeys ~= key;
            return key;
        }
    }

    private string getStoreKeyAttr(Tag tag)
    {
        foreach (attr; tag.attributes) {
            if (attr.name == "store") {
                return attr.value.get!string();
            }
            if (attr.name == "local-store") {
                const key = attr.value.get!string();
                _localKeys ~= key;
                return key;
            }
        }
        {
            const key = newAnonKey();
            _localKeys ~= key;
            return key;
        }
    }

    private string newAnonKey()
    {
        import std.conv : to;
        const key = ++_storeAnonKey;
        return key.to!string;
    }

    private immutable(void)[] getAsset(in string name, in Location location)
    {
        import std.algorithm : map;
        import std.file : exists, read;
        import std.path : buildPath;
        import std.exception : assumeUnique;

        foreach (p; _assetPaths.map!(ap => buildPath(ap, name))) {
            if (exists(p)) {
                return assumeUnique(read(p));
            }
        }
        throw new NoSuchAssetException(name, location);
    }

    private immutable(void)[] getView(in string name, in Location location)
    {
        auto p = name in _views;
        if (!p) {
            throw new NoSuchViewException(name, location);
        }
        return *p;
    }

    private T expectStoreRef(T)(Tag tag)
    {
        import std.algorithm : startsWith;

        string storeStr = tag.expectValue!string();
        if (!storeStr.startsWith("store:")) {
            throw new GfxSDLErrorException(
                format("Cannot parse %s: " ~
                    "must specify a store reference or a literal " ~
                    "(\"%s\" is not a valid store reference)", T.stringof, storeStr),
                tag.location
            );
        }
        const key = storeStr["store:".length .. $];
        return _store.expect!T(key);
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
                    format("Cannot parse %s: " ~
                        "must specify a store reference or a literal " ~
                        "(\"%s\" is not a valid store reference)", T.stringof, storeStr),
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

    private T getLiteralOrStoreValValue(T)(Tag tag, T def=T.init)
    {
        T res;
        if (!literalOrStoreValValue!T(tag, res)) {
            res = def;
        }
        return res;
    }

    private T expectLiteralOrStoreValValue(T)(Tag tag)
    {
        T res;
        if (!literalOrStoreValValue!T(tag, res)) {
            throw new GfxSDLErrorException(
                format("Could not resolve %s value", T.stringof),
                tag.location
            );
        }
        return res;
    }

    private bool literalOrStoreValValue(T)(Tag tag, out T res)
    {
        import std.algorithm : startsWith;

        static if (!is(T == enum)) {
            if (tryGetValue(tag, res)) {
                return true;
            }
        }

        string str;
        if (tryGetValue(tag, str)) {
            if (str.startsWith("store:")) {
                const key = str["store:".length .. $];
                res = _store.expect!T(key);
                return true;
            }
            static if (is(T == enum)) {
                import std.conv : to;
                res = str.to!T;
                return true;
            }
        }
        return false;
    }

    private T getLiteralOrStoreValAttr(T)(Tag tag, in string attrName, T def=T.init)
    {
        T res;
        if (!literalOrStoreValAttr!T(tag, attrName, res)) {
            res = def;
        }
        return res;
    }

    private T expectLiteralOrStoreValAttr(T)(Tag tag, in string attrName)
    {
        T res;
        if (!literalOrStoreValAttr!T(tag, attrName, res)) {
            throw new GfxSDLErrorException(
                format("Could not resolveValue %s value from attribute \"%s\"", T.stringof, attrName),
                tag.location
            );
        }
        return res;
    }

    private bool literalOrStoreValAttr(T)(Tag tag, in string attrName, out T res)
    {
        import std.algorithm : startsWith;

        static if (!is(T == enum)) {
            if (tag.tryGetAttr!T(attrName, res)) {
                return true;
            }
        }

        string str;
        if (tryGetAttr(tag, attrName, str)) {
            if (str.startsWith("store:")) {
                const key = str["store:".length .. $];
                res = _store.expect!T(key);
                return true;
            }
            static if (is(T == enum)) {
                import std.conv : to;
                return str.to!T;
            }
        }
        return false;
    }

    private T getLiteralOrStoreValTagValue(T)(Tag tag, in string tagName, T def=T.init)
    {
        T res;
        if (!literalOrStoreValTagValue!T(tag, tagName, res)) {
            res = def;
        }
        return res;
    }

    private T expectLiteralOrStoreValTagValue(T)(Tag tag, in string tagName)
    {
        T res;
        if (!literalOrStoreValTagValue!T(tag, tagName, res)) {
            throw new GfxSDLErrorException(
                format("Could not resolveValue %s value from tag \"%s\"", T.stringof, tagName),
                tag.location
            );
        }
        return res;
    }


    private bool literalOrStoreValTagValue(T)(Tag tag, in string tagName, out T res)
    {
        import std.algorithm : startsWith;

        static if (!is(T == enum)) {
            if (tag.tryGetTagValue!T(tagName, res)) {
                return true;
            }
        }

        string str;
        if (tryGetTagValue(tag, tagName, str)) {
            if (str.startsWith("store:")) {
                const key = str["store:".length .. $];
                res = _store.expect!T(key);
                return true;
            }
            static if (is(T == enum)) {
                import std.conv : to;
                res = str.to!T;
                return true;
            }
        }
        return false;
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
            if (field.length) {
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


    private Format expectFormatAttr(Tag tag, in string attrName="format")
    {
        import std.algorithm : findSplit, startsWith;

        auto formatStr = tag.expectAttribute!string(attrName);
        if (formatStr.startsWith("formatof:")) {
            const sf = formatStr["formatof:".length .. $].findSplit(".");
            const struct_ = sf[0];
            const field = sf[2];
            if (!field.length) {
                throw new GfxSDLErrorException(
                    format("\"%s\" cannot resolve to a struct field (required by \"formatof:\"", sf),
                    tag.location
                );
            }
            return findStruct(struct_, tag.location).getFormat(field, tag.location);
        }
        else {
            import std.conv : to;
            return formatStr.to!Format;
        }
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

bool tryGetValue(T)(Tag tag, out T val)
{
    foreach (ref v; tag.values) {
        if (v.convertsTo!T) {
            val = v.get!T();
            return true;
        }
    }
    return false;
}

bool tryGetValue(T)(Attribute attr, out T val)
{
    if (attr.value.convertsTo!T) {
        val = attr.value.get!T();
        return true;
    }
    return false;
}

bool tryGetAttr(T)(Tag tag, in string name, out T val)
{
    foreach (attr; tag.attributes) {
        if (attr.name == name) {
            if (attr.value.convertsTo!T) {
                val = attr.value.get!T();
                return true;
            }
        }
    }
    return false;
}

bool tryGetTagValue(T)(Tag tag, in string name, out T val)
{
    foreach (t; tag.tags) {
        if (t.name == name) {
            foreach (v; t.values) {
                if (v.convertsTo!T) {
                    val = v.get!T();
                    return true;
                }
            }
        }
    }
    return false;
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
