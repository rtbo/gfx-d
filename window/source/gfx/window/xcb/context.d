module gfx.window.xcb.context;

import gfx.gl3.context : GlContext;

class XcbGlContext : GlContext
{
    import gfx.bindings.core : SharedLib, SharedSym;
    import gfx.bindings.opengl.gl : GlCmds30;
    import gfx.bindings.opengl.glx : GlxCmds13, GLXContext;
    import gfx.core.rc : atomicRcCode;
    import gfx.gl3.context : GlAttribs;
    import X11.Xlib : XDisplay = Display;

    mixin(atomicRcCode);

    private XDisplay* _dpy;
    private int _mainScreenNum;
    private GlAttribs _attribs;
    private SharedLib _lib;
    private GlxCmds13 _glxCmds;
    private GlCmds30 _cmds;
    private string[] _glxAvailExts;
    private string[] _glAvailExts;
    private GLXContext _ctx;

    this (XDisplay* dpy, in int mainScreenNum, in GlAttribs attribs)
    {
        import gfx.bindings.core : openSharedLib, loadSharedSym;
        import gfx.bindings.opengl : splitExtString;
        import gfx.bindings.opengl.gl : GL_EXTENSIONS;
        import gfx.bindings.opengl.glx : PFN_glXGetProcAddressARB;
        import gfx.gl3.context : extensionsToLoad;
        import std.algorithm : canFind;
        import std.conv : to;
        import std.exception : enforce;

        _dpy = dpy;
        _mainScreenNum = mainScreenNum;
        _attribs = attribs;

        immutable glLibNames = ["libGL.so.1", "libGL.so"];
        foreach (ln; glLibNames) {
            _lib = openSharedLib(ln);
            if (_lib) break;
        }
        enforce(_lib, "could not load any of these libraries: " ~ glLibNames.to!string);

        auto getProcAddress = cast(PFN_glXGetProcAddressARB)enforce(loadSharedSym(_lib, "glXGetProcAddressARB"));
        SharedSym loadSymbol(in string symbol) {
            import std.string : toStringz;
            return cast(SharedSym)getProcAddress(cast(const(ubyte)*)toStringz(symbol));
        }

        _glxCmds = new GlxCmds13(&loadSymbol);
        _glxAvailExts = splitExtString(_glxCmds.queryExtensionsString(_dpy, _mainScreenNum));

        const string[] requiredExts = [ ];
        const optionalExts = [ "GLX_MESA_query_renderer" ];
        const swapIntExts = [
            "GLX_EXT_swap_control", "GLX_MESA_swap_control"
        ];

        string[] extsToLoad = extensionsToLoad(_glxAvailExts, requiredExts, optionalExts);
        foreach(ext; swapIntExts) {
            if (_glxAvailExts.canFind(ext)) {
                extsToLoad ~= ext;
                break;
            }
        }
        _glxCmds.loadExtensions(&loadSymbol, extsToLoad);
        enforce( _glxCmds.GLX_ARB_create_context && (
            _glxCmds.GLX_MESA_swap_control ||
            _glxCmds.GLX_EXT_swap_control
        ));


        _cmds = new GlCmds30(&loadSymbol);
        _glAvailExts = splitExtString(cast(const(char)*)_cmds.getString(GL_EXTENSIONS));

        import std.experimental.logger : trace;
        trace("loaded GL/GLX bindings");
    }

    override void dispose() {
        import gfx.bindings.core : closeSharedLib;
        _glxCmds.destroyContext(_dpy, _ctx);
        closeSharedLib(_lib);
    }


    override @property GlCmds30 cmds() {
        return _cmds;
    }

    override @property GlAttribs attribs() {
        return _attribs;
    }

    override bool makeCurrent(size_t nativeHandle)
    {
        import gfx.bindings.opengl.glx : GLXDrawable;
        return _glxCmds.makeCurrent(_dpy, cast(GLXDrawable)nativeHandle, _ctx) != 0;
    }

    override void doneCurrent()
    {
        _glxCmds.makeCurrent(_dpy, 0, null);
    }

    override @property bool current() const
    {
        return _glxCmds.getCurrentContext() is _ctx;
    }

    override @property int swapInterval()
    {
        import gfx.bindings.opengl.glx : GLXDrawable;
        if (_glxCmds.GLX_MESA_swap_control) {
            return _glxCmds.getSwapIntervalMESA();
        }
        else if (_glxCmds.GLX_EXT_swap_control) {
            GLXDrawable drawable = _glxCmds.getCurrentDrawable();
            uint swap;

            if (drawable) {
                import gfx.bindings.opengl.glx : GLX_SWAP_INTERVAL_EXT;
                _glxCmds.queryDrawable(_dpy, drawable, GLX_SWAP_INTERVAL_EXT, &swap);
                return swap;
            }
            else {
                import std.experimental.logger : warningf;
                warningf("could not get glx drawable to get swap interval");
                return -1;
            }

        }
        return -1;
    }

    override @property void swapInterval(int interval)
    {
        import gfx.bindings.opengl.glx : GLXDrawable;
        if (_glxCmds.GLX_MESA_swap_control) {
            _glxCmds.swapIntervalMESA(interval);
        }
        else if (_glxCmds.GLX_EXT_swap_control) {
            GLXDrawable drawable = _glxCmds.getCurrentDrawable();

            if (drawable) {
                _glxCmds.swapIntervalEXT(_dpy, drawable, interval);
            }
            else {
                import std.experimental.logger : warningf;
                warningf("could not get glx drawable to set swap interval");
            }
        }
    }

    override void swapBuffers(size_t nativeHandle)
    {
        import gfx.bindings.opengl.glx : GLXDrawable;
        _glxCmds.swapBuffers(_dpy, cast(GLXDrawable)nativeHandle);
    }
}
