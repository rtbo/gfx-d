module gfx.gl3;

import gfx.graal : Instance;
import gfx.graal.device : PhysicalDevice;

class GlInstance : Instance
{
    import gfx.core.rc : atomicRcCode, Rc;
    import gfx.gl3.context : GlContext;
    import gfx.graal : ApiProps, CoordSystem;

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

    override @property ApiProps apiProps() {
        return ApiProps(
            "gl3", CoordSystem.leftHanded
        );
    }

    override PhysicalDevice[] devices() {
        return [ _phd.obj ];
    }
}

class GlPhysicalDevice : PhysicalDevice
{
    import gfx.bindings.opengl.gl : GlCmds30;
    import gfx.core.rc : atomicRcCode;
    import gfx.gl3.context : GlContext;
    import gfx.graal.device : Device, DeviceFeatures, DeviceLimits, DeviceType;
    import gfx.graal.format : Format, FormatProperties;
    import gfx.graal.memory : MemoryProperties;
    import gfx.graal.queue : QueueFamily, QueueRequest;
    import gfx.graal.presentation : PresentMode, Surface, SurfaceCaps;

    mixin(atomicRcCode);

    private GlContext _ctx;
    private GlCmds30 gl;
    private string _name;

    this(GlContext ctx) {
        _ctx = ctx;
        gl = ctx.cmds;

        import gfx.bindings.opengl.gl : GL_RENDERER;
        import std.string : fromStringz;
        _name = fromStringz(cast(const(char)*)gl.getString(GL_RENDERER)).idup;
    }

    override void dispose() {}

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
        const props = MemProps.deviceLocal | MemProps.hostVisible |
                      MemProps.hostCoherent | MemProps.hostCached;
        // TODO: buffer storage
        return MemoryProperties(
            [ MemoryHeap(size_t.max, props, true) ],
            [ MemoryType(0, 0, size_t.max, props) ]
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
        return new GlDevice(_ctx);
    }
}
