module gfx.gl3;

import gfx.core.rc : AtomicRefCounted;
import gfx.graal : Instance;
import gfx.graal.device : PhysicalDevice;

class GlInstance : Instance
{
    import gfx.core.rc : atomicRcCode, Rc;
    import gfx.gl3.context : GlContext;
    import gfx.graal : ApiProps, Backend, CoordSystem;

    mixin(atomicRcCode);

    private GlContext _ctx;
    private Rc!PhysicalDevice _phd;

    this(GlContext ctx) {
        _ctx = ctx;
        _phd = new GlPhysicalDevice(_ctx);
    }

    override void dispose() {
        _phd.unload();
    }

    override @property Backend backend() {
        return Backend.gl3;
    }

    override @property ApiProps apiProps() {
        return ApiProps(
            "gl3", CoordSystem.leftHanded
        );
    }

    override PhysicalDevice[] devices() {
        return [ _phd.obj ];
    }
}

package:

import gfx.bindings.opengl.gl : Gl;

struct GlExts
{
    bool bufferStorage;
    bool textureStorage;
    bool samplerObject;

    private static GlExts fetchAndCheck (Gl gl) {
        import gfx.gl3.context : glAvailableExtensions, glRequiredExtensions;
        import std.algorithm : canFind;

        const exts = glAvailableExtensions(gl);

        foreach (glE; glRequiredExtensions) {
            import std.exception : enforce;
            import std.format : format;
            enforce(exts.canFind(glE), format(glE ~ " is required but was not found"));
        }

        GlExts ge;
        ge.bufferStorage = exts.canFind("GL_ARB_buffer_storage");
        ge.textureStorage = exts.canFind("GL_ARB_texture_storage");
        ge.samplerObject = exts.canFind("GL_ARB_sampler_object");
        return ge;
    }
}


class GlShare : AtomicRefCounted
{
    import gfx.core.rc : atomicRcCode, Rc;
    import gfx.gl3.context : GlContext;

    mixin(atomicRcCode);

    private Rc!GlContext _ctx;
    private size_t _dummyWin;
    private Gl _gl;
    private GlExts _exts;

    this(GlContext ctx) {
        _ctx = ctx;
        _dummyWin = _ctx.createDummy();
        _ctx.makeCurrent(_dummyWin);
        _gl = ctx.gl;
        _exts = GlExts.fetchAndCheck(_gl);
    }

    override void dispose() {
        _ctx.doneCurrent();
        _ctx.releaseDummy(_dummyWin);
        _ctx.unload();
    }

    @property inout(GlContext) ctx() inout {
        return _ctx.obj;
    }
    @property inout(Gl) gl() inout {
        return _gl;
    }
    @property GlExts exts() const {
        return _exts;
    }
}


class GlPhysicalDevice : PhysicalDevice
{
    import gfx.bindings.opengl.gl : Gl;
    import gfx.core.rc : atomicRcCode, Rc;
    import gfx.gl3.context : GlContext;
    import gfx.graal.device : Device, DeviceFeatures, DeviceLimits, DeviceType,
                              QueueRequest;
    import gfx.graal.format : Format, FormatProperties;
    import gfx.graal.memory : MemoryProperties;
    import gfx.graal.queue : QueueFamily;
    import gfx.graal.presentation : PresentMode, Surface, SurfaceCaps;

    mixin(atomicRcCode);

    private Rc!GlShare _share;
    private string _name;

    this(GlContext ctx) {
        _share = new GlShare(ctx);

        import gfx.bindings.opengl.gl : GL_RENDERER;
        import std.string : fromStringz;
        _name = fromStringz(cast(const(char)*)ctx.gl.GetString(GL_RENDERER)).idup;
    }

    override void dispose() {
        _share.unload();
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
        import gfx.graal.pipeline : ShaderLanguage;
        return DeviceLimits(ShaderLanguage.glsl);
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
        assert(false, "unimplemented");
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
            CompositeAlpha.opaque | CompositeAlpha.inherit
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
        import gfx.gl3.device : GlDevice;
        return new GlDevice(this, _share);
    }
}
