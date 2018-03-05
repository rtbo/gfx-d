module gfx.gl3.context;

import gfx.bindings.opengl.gl : GlCmds30;
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
    @property GlCmds30 cmds();

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

immutable string[] glRequiredExtensions = [];
immutable string[] glOptionalExtensions = [];

string[] extensionsToLoad(in string[] availableExts,
                          in string[] requiredExtensions,
                          in string[] optionalExtensions)
{
    string[] toLoad;
    foreach (ext; optionalExtensions) {
        import std.algorithm : canFind;
        if (availableExts.canFind(ext)) toLoad ~= ext;
    }
    return requiredExtensions ~ toLoad;
}

string[] glExtensionsToLoad(in string[] availableExts) {
    return extensionsToLoad(
        availableExts, glRequiredExtensions, glOptionalExtensions
    );
}

string[] glAvailableExtensions(GlCmds30 gl)
{
    import gfx.bindings.opengl.gl : GLint, GL_EXTENSIONS, GL_NUM_EXTENSIONS;

    GLint num;
    gl.getIntegerv(GL_NUM_EXTENSIONS, &num);
    string[] exts;
    foreach (i; 0 .. num)
    {
        import std.string : fromStringz;
        auto cStr = cast(const(char)*)gl.getStringi(GL_EXTENSIONS, i);
        exts ~= fromStringz(cStr).idup;
    }
    return exts;
}
