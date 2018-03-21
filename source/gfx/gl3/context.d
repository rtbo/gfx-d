module gfx.gl3.context;

import gfx.bindings.opengl.gl : Gl;
import gfx.core.rc : AtomicRefCounted;
import gfx.graal.format : Format;

enum GlProfile
{
    core,
    compatibility
}

struct GlAttribs
{
    enum profile = GlProfile.core;
    enum doublebuffer = true;

    enum uint majorVersion = 3;
    enum uint minorVersion = 0;

    uint samples = 1;

    @property Format colorFormat() const pure {
        return _colorFormat;
    }
    @property Format depthStencilFormat() const pure {
        return _depthStencilFormat;
    }

    private Format _colorFormat = Format.rgba8_uNorm;
    private Format _depthStencilFormat = Format.d24s8_uNorm;

    @property int decimalVersion() const pure {
        return majorVersion * 10 + minorVersion;
    }
}

interface GlContext : AtomicRefCounted
{
    @property Gl gl();

    @property GlAttribs attribs();

    bool makeCurrent(size_t nativeHandle);

    void doneCurrent();

    @property bool current();

    @property int swapInterval()
    in { assert(current); }

    @property void swapInterval(int interval)
    in { assert(current); }

    void swapBuffers(size_t nativeHandle)
    in { assert(current); }

    size_t createDummy();
    void releaseDummy(size_t dummy);
}

immutable string[] glRequiredExtensions = [
    "GL_ARB_framebuffer_object"
];
immutable string[] glOptionalExtensions = [
    "GL_ARB_buffer_storage",
    "GL_ARB_texture_storage",
    "GL_ARB_sampler_object"
];

string[] glAvailableExtensions(Gl gl)
{
    import gfx.bindings.opengl.gl : GLint, GL_EXTENSIONS, GL_NUM_EXTENSIONS;

    GLint num;
    gl.GetIntegerv(GL_NUM_EXTENSIONS, &num);
    string[] exts;
    foreach (i; 0 .. num)
    {
        import std.string : fromStringz;
        auto cStr = cast(const(char)*)gl.GetStringi(GL_EXTENSIONS, i);
        exts ~= fromStringz(cStr).idup;
    }
    return exts;
}
