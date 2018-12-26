module gfx.gl3;

import gfx.core.log : LogTag;
import gfx.core.rc : AtomicRefCounted;
import gfx.graal : DebugCallback, Instance;
import gfx.graal.device : PhysicalDevice;

enum gfxGlLogMask = 0x2000_0000;
package immutable gfxGlLog = LogTag("GFX-GL", gfxGlLogMask);

final class GlInstance : Instance
{
    import gfx.core.rc : atomicRcCode, Rc;
    import gfx.gl3.context : GlContext;
    import gfx.graal : ApiProps, Backend;

    mixin(atomicRcCode);

    private Rc!GlContext _ctx;
    private Rc!GlShare _share;
    private PhysicalDevice _phd;

    this(GlContext ctx) {
        _ctx = ctx;
        _share = new GlShare(_ctx);
        _phd = new GlPhysicalDevice(this);
    }

    override void dispose() {
        _share.unload();
        _ctx.unload();
    }

    override @property Backend backend() {
        return Backend.gl3;
    }

    override @property ApiProps apiProps()
    {
        import gfx.math.proj : ndc, XYClip, ZClip;

        return ApiProps(
            "gl3", ndc(XYClip.leftHand, ZClip.minusOneToOne)
        );
    }

    override PhysicalDevice[] devices() {
        return [ _phd ];
    }

    override void setDebugCallback(DebugCallback callback) {
        _share._callback = callback;
    }

    @property GlShare share() {
        return _share.obj;
    }
    @property GlContext ctx() {
        return _ctx.obj;
    }
}

package:

import gfx.bindings.opengl.gl : Gl;

struct GlInfo
{
    ushort glVer;
    ushort glslVer;
    bool bufferStorage;
    bool textureStorage;
    bool textureStorageMS;
    bool samplerObject;
    bool drawElementsBaseVertex;
    bool baseInstance;
    bool viewportArray;
    bool polygonOffsetClamp;

    private static GlInfo fetchAndCheck (Gl gl, uint glVer) {
        import gfx.bindings.opengl.gl : GL_VERSION, GL_SHADING_LANGUAGE_VERSION;
        import gfx.gl3.context : glAvailableExtensions, glRequiredExtensions, glslVersion;
        import std.algorithm : canFind;
        import std.string : fromStringz;

        const exts = glAvailableExtensions(gl);

        foreach (glE; glRequiredExtensions) {
            import std.exception : enforce;
            import std.format : format;
            enforce(exts.canFind(glE), format(glE ~ " is required but was not found"));
        }

        bool checkVersion(uint ver) {
            return glVer >= ver;
        }

        bool checkFeature(uint ver, in string ext) {
            return glVer >= ver || exts.canFind(ext);
        }

        GlInfo gi;
        gi.glVer = cast(ushort)glVer;
        gi.glslVer = cast(ushort)glslVersion(glVer);
        gi.bufferStorage            = checkFeature(44, "GL_ARB_buffer_storage");
        gi.textureStorage           = checkFeature(42, "GL_ARB_texture_storage");
        gi.textureStorageMS         = checkFeature(43, "GL_ARB_texture_storage_multisample");
        gi.samplerObject            = checkFeature(33, "GL_ARB_sampler_objects");
        gi.drawElementsBaseVertex   = checkFeature(32, "ARB_draw_elements_base_vertex");
        gi.baseInstance             = checkFeature(42, "ARB_base_instance");
        gi.viewportArray            = checkFeature(41, "ARB_viewport_array");
        gi.polygonOffsetClamp       = exts.canFind("GL_EXT_polygon_offset_clamp");
        return gi;
    }
}


final class GlShare : AtomicRefCounted
{
    import gfx.core.rc : Rc;
    import gfx.gl3.context : GlContext;

    private Rc!GlContext _ctx;
    private Gl _gl;
    private GlInfo _info;
    private DebugCallback _callback;

    this(GlContext ctx)
    {
        import std.exception : enforce;

        _ctx = ctx;
        enforce(_ctx.current, "The OpenGL context must be made current before initializing instance");
        _gl = ctx.gl;
        _info = GlInfo.fetchAndCheck(_gl, ctx.attribs.decimalVersion);
    }

    override void dispose() {
        _ctx.unload();
    }

    @property inout(GlContext) ctx() inout {
        return _ctx.obj;
    }
    @property inout(Gl) gl() inout {
        return _gl;
    }
    @property GlInfo info() const {
        return _info;
    }
}


final class GlPhysicalDevice : PhysicalDevice
{
    import gfx.bindings.opengl.gl : Gl;
    import gfx.gl3.context : GlContext;
    import gfx.graal.device : Device, DeviceFeatures, DeviceLimits, DeviceType,
                              QueueRequest;
    import gfx.graal.format : Format, FormatProperties;
    import gfx.graal.memory : MemoryProperties;
    import gfx.graal.queue : QueueFamily;
    import gfx.graal.presentation : PresentMode, Surface, SurfaceCaps;

    private GlInstance _inst;
    private string _name;

    this(GlInstance instance) {
        _inst = instance;

        import gfx.bindings.opengl.gl : GL_RENDERER;
        import std.string : fromStringz;
        _name = fromStringz(cast(const(char)*)_inst.share.gl.GetString(GL_RENDERER)).idup;
    }

    override @property Instance instance()
    {
        import gfx.core.rc : lockObj, giveAwayObj;

        auto inst = lockObj(_inst);
        if (!inst) return null;
        return giveAwayObj(inst);
    }

    override @property string name() {
        return _name;
    }

    override @property DeviceType type() {
        return DeviceType.other;
    }

    override @property DeviceFeatures features() {
        // TODO
        return DeviceFeatures.all();
    }

    override @property DeviceLimits limits() {
        return DeviceLimits.init;
    }

    override @property MemoryProperties memoryProperties() {
        import gfx.graal.memory : MemoryHeap, MemProps, MemoryType;
        const props = MemProps.deviceLocal | MemProps.hostVisible | MemProps.hostCoherent;
        // TODO: buffer storage
        return MemoryProperties(
            [ MemoryHeap(size_t.max, true) ],
            [ MemoryType(props, 0) ]
        );
    }

    override @property QueueFamily[] queueFamilies() {
        import gfx.graal.queue : QueueCap;
        return [
            QueueFamily(QueueCap.graphics, 1)
        ];
    }

    override FormatProperties formatProperties(in Format format) {
        import gfx.graal.format : FormatFeatures;

        const color = FormatFeatures.sampledImage |
                      FormatFeatures.colorAttachment | FormatFeatures.blit;
        const depthStencil = FormatFeatures.depthStencilAttachment;

        switch (format) {
        case Format.r8_uNorm:
        case Format.rg8_uNorm:
        case Format.rgba8_uNorm:
        case Format.r8_sInt:
        case Format.rg8_sInt:
        case Format.rgba8_sInt:
        case Format.r8_uInt:
        case Format.rg8_uInt:
        case Format.rgba8_uInt:
        case Format.r16_uNorm:
        case Format.rg16_uNorm:
        case Format.rgba16_uNorm:
        case Format.r16_sInt:
        case Format.rg16_sInt:
        case Format.rgba16_sInt:
        case Format.r16_uInt:
        case Format.rg16_uInt:
        case Format.rgba16_uInt:
            return FormatProperties(
                color, color, FormatFeatures.init
            );
        case Format.d16_uNorm:
        case Format.x8d24_uNorm:
        case Format.d32_sFloat:
        case Format.d24s8_uNorm:
        case Format.s8_uInt:
            return FormatProperties(
                depthStencil, depthStencil, FormatFeatures.init
            );
        default:
            return FormatProperties.init;
        }
    }

    override bool supportsSurface(uint queueFamilyIndex, Surface surface) {
        return true;
    }

    override SurfaceCaps surfaceCaps(Surface surface) {
        import gfx.graal.image : ImageUsage;
        import gfx.graal.presentation : CompositeAlpha;
        return SurfaceCaps(
            2, 4, [4, 4], [16384, 16384], 1,
            ImageUsage.colorAttachment | ImageUsage.sampled | ImageUsage.transfer,
            CompositeAlpha.inherit
        );
    }

    override Format[] surfaceFormats(Surface surface) {
        return [ Format.rgba8_uNorm ];
    }

    override PresentMode[] surfacePresentModes(Surface surface) {
        return [ PresentMode.fifo ];
    }

    /// Open a logical device with the specified queues.
    /// Returns: null if it can't meet all requested queues, the opened device otherwise.
    override Device open(in QueueRequest[], in DeviceFeatures)
    {
        import gfx.core.rc : lockObj, releaseObj;
        import gfx.gl3.device : GlDevice;
        auto inst = lockObj(_inst);
        scope(exit) releaseObj(inst);
        if (!inst) return null;
        else return new GlDevice(this, inst);
    }
}
