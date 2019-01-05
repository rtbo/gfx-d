module gfx.gl3.context;

import gfx.bindings.opengl.gl : Gl;
import gfx.core.rc : IAtomicRefCounted;
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

    uint majorVersion = 3;
    uint minorVersion = 1;

    uint samples = 1;

    @property Format colorFormat() const pure {
        return _colorFormat;
    }
    @property Format depthStencilFormat() const pure {
        return _depthStencilFormat;
    }

    private Format _colorFormat = Format.rgba8_uNorm;
    private Format _depthStencilFormat = Format.d24s8_uNorm;

    @property uint decimalVersion() const pure {
        return majorVersion * 10 + minorVersion;
    }
}

/// The list of OpenGL versions that gfx-d is compatible with.
immutable uint[] glVersions = [
    46, 45, 44, 43, 42, 41, 40,
    33, 32, 31, // 30
    // 21, 20,
    // 15, 14, 13, 12, 11, 10,
];

/// The GLSL version for the passed OpenGL version.
uint glslVersion(in uint glVersion) pure {
    if (glVersion >= 33) return 10*glVersion;
    switch(glVersion) {
    case 32:    return 150;
    case 31:    return 140;
    case 30:    return 130;
    case 21:    return 120;
    case 20:    return 110;
    default:    assert(false);
    }
}

interface GlContext : IAtomicRefCounted
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
}

immutable string[] glRequiredExtensions = [
    "GL_ARB_framebuffer_object"
];
immutable string[] glOptionalExtensions = [
    "GL_ARB_buffer_storage",
    "GL_ARB_texture_storage",
    "GL_ARB_texture_storage_multisample",
    "GL_ARB_sampler_object",
    "ARB_draw_elements_base_vertex",
    "ARB_base_instance",
    "ARB_viewport_array",
    "GL_EXT_polygon_offset_clamp",
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
