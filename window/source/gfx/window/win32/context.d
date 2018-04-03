module gfx.window.win32.context;

version(Windows):

import core.sys.windows.wingdi;
import gfx.bindings.core;
import gfx.bindings.opengl.gl : Gl, GL_TRUE;
import gfx.bindings.opengl.wgl;
import gfx.gl3.context : GlAttribs, GlContext, GlProfile, glVersions;

/// Helper to get an attrib list to pass to wglChoosePixelFormatARB
public int[] getAttribList(in GlAttribs attribs) {
    import gfx.graal.format :   formatDesc, colorBits, depthBits, stencilBits;

    const cd = formatDesc(attribs.colorFormat);
    const dsd = formatDesc(attribs.depthStencilFormat);

    int[] attribList = [
        WGL_DRAW_TO_WINDOW_ARB,     GL_TRUE,
        WGL_SUPPORT_OPENGL_ARB,     GL_TRUE,
        WGL_DOUBLE_BUFFER_ARB,      GL_TRUE,
        WGL_PIXEL_TYPE_ARB,         WGL_TYPE_RGBA_ARB,
        WGL_COLOR_BITS_ARB,         colorBits(cd.surfaceType),
        WGL_DEPTH_BITS_ARB,         depthBits(dsd.surfaceType),
        WGL_STENCIL_BITS_ARB,       stencilBits(dsd.surfaceType),
    ];
    if (attribs.samples > 1) {
        attribList ~= [
            WGL_SAMPLE_BUFFERS_ARB,     GL_TRUE,
            WGL_SAMPLES_ARB,            attribs.samples,
        ];
    }
    return attribList ~ 0;
}

/// Helper to fill a struct for ChoosePixelFormat
public void setupPFD(in GlAttribs attribs, PIXELFORMATDESCRIPTOR* pfd)
{
    pfd.nSize = PIXELFORMATDESCRIPTOR.sizeof;
    pfd.nVersion = 1;

    pfd.dwFlags = PFD_SUPPORT_OPENGL | PFD_DRAW_TO_WINDOW;
    if (attribs.doublebuffer) pfd.dwFlags |= PFD_DOUBLEBUFFER;

    pfd.iPixelType = PFD_TYPE_RGBA;

    import gfx.graal.format :   formatDesc, alphaBits, redBits, greenBits,
                                blueBits, colorBits, alphaShift, redShift,
                                greenShift, blueShift, depthBits, stencilBits;

    const cd = formatDesc(attribs.colorFormat);
    const dsd = formatDesc(attribs.depthStencilFormat);

    pfd.cColorBits = cast(ubyte)colorBits(cd.surfaceType);
    pfd.cRedBits = cast(ubyte)redBits(cd.surfaceType);
    pfd.cRedShift = cast(ubyte)redShift(cd.surfaceType);
    pfd.cGreenBits = cast(ubyte)greenBits(cd.surfaceType);
    pfd.cGreenShift = cast(ubyte)greenShift(cd.surfaceType);
    pfd.cBlueBits = cast(ubyte)blueBits(cd.surfaceType);
    pfd.cBlueShift = cast(ubyte)blueShift(cd.surfaceType);
    pfd.cAlphaBits = cast(ubyte)alphaBits(cd.surfaceType);
    pfd.cAlphaShift = cast(ubyte)alphaShift(cd.surfaceType);
    pfd.cDepthBits = cast(ubyte)depthBits(dsd.surfaceType);
    pfd.cStencilBits = cast(ubyte)stencilBits(dsd.surfaceType);

    pfd.iLayerType = PFD_MAIN_PLANE;
}

/// Wgl implementation of GlContext
public class Win32GlContext : GlContext
{
    import core.sys.windows.windows;
    import gfx.core.rc : atomicRcCode, Disposable;
    import gfx.window.win32 : registerWindowClass, wndClassName;
    import std.exception : enforce;
    import std.experimental.logger : tracef;

    mixin(atomicRcCode);

    private Wgl _wgl;
    private Gl _gl;
    private GlAttribs _attribs;
    private HGLRC _ctx;
    private int _pixelFormat;
    private DummyWindow[size_t] dummies;
    private size_t hiddenDummy;

    this(in GlAttribs attribs) {
        _attribs = attribs;

        registerWindowClass();

        hiddenDummy = Win32GlContext.createDummy();

        auto dc = GetDC(cast(HWND)hiddenDummy);
        scope(exit) ReleaseDC(cast(HWND)hiddenDummy, dc);

        PIXELFORMATDESCRIPTOR pfd;
        setupPFD(_attribs, &pfd);
        const chosen = ChoosePixelFormat(dc, &pfd);
        SetPixelFormat(dc, chosen, &pfd);

        import gfx.bindings.core : loadSharedSym;
        auto lib = loadGlLib();
        PFN_wglGetProcAddress getProcAddress = cast(PFN_wglGetProcAddress)enforce(
            loadSharedSym(lib, "wglGetProcAddress"), "could not load wglGetProcAddress"
        );
        SharedSym loader (in string symbol) {
            import std.string : toStringz;
            auto proc = cast(SharedSym)getProcAddress(toStringz(symbol));
            if (!proc) {
                proc = cast(SharedSym)loadSharedSym(lib, symbol);
            }
            import std.stdio;
            //writefln("%s = %x", symbol, proc);
            return proc;
        }

        {
            PFN_wglCreateContext _createContext = cast(PFN_wglCreateContext)enforce(
                loadSharedSym(lib, "wglCreateContext"), "could not load wglCreateContext"
            );
            PFN_wglMakeCurrent _makeCurrent = cast(PFN_wglMakeCurrent)enforce(
                loadSharedSym(lib, "wglMakeCurrent"), "could not load wglMakeCurrent"
            );
            PFN_wglDeleteContext _deleteContext = cast(PFN_wglDeleteContext)enforce(
                loadSharedSym(lib, "wglDeleteContext"), "could not load wglDeleteContext"
            );
            // creating and binding a dummy temporary context
            auto ctx = enforce(_createContext(dc), "could not create legacy wgl context");
            scope(exit) _deleteContext(ctx);
            enforce(_makeCurrent(dc, ctx), "could not make legacy context current");
            _wgl = new Wgl(&loader);
        }

        auto attribList = getAttribList(attribs);
        uint nf;
        _wgl.ChoosePixelFormatARB(dc, attribList.ptr, null, 1, &_pixelFormat, &nf);
        enforce(nf > 0, "wglChoosePixelFormatARB failed");

        GlAttribs attrs = attribs;
        foreach (const glVer; glVersions) {
            attrs.majorVersion = glVer / 10;
            attrs.minorVersion = glVer % 10;
            if (attrs.decimalVersion < attribs.decimalVersion) break;

            const ctxAttribs = getCtxAttribs(attrs);
            tracef("attempting to create OpenGL %s.%s context", attrs.majorVersion, attrs.minorVersion);

            _ctx = _wgl.CreateContextAttribsARB(dc, null, &ctxAttribs[0]);

            if (_ctx) break;
        }

        enforce(_ctx, "Failed creating Wgl context");
        tracef("created OpenGL %s.%s context", attrs.majorVersion, attrs.minorVersion);
        _attribs = attrs;
        Win32GlContext.makeCurrent(hiddenDummy);
        _gl = new Gl(&loader);
    }

    override void dispose() {
        import gfx.core.rc : disposeArray;

        disposeArray(dummies);

        _wgl.DeleteContext(_ctx);
        tracef("destroyed GL/WGL context");
    }

    override @property Gl gl() {
        return _gl;
    }

    override @property GlAttribs attribs() {
        return _attribs;
    }

    void setPixelFormat(HWND hwnd) {
        PIXELFORMATDESCRIPTOR pfd;
        setupPFD(attribs, &pfd);
        auto dc = GetDC(hwnd);
        SetPixelFormat(dc, _pixelFormat, &pfd);
        ReleaseDC(hwnd, dc);
    }

    override bool makeCurrent(size_t nativeHandle)
    {
        auto wnd = cast(HWND)nativeHandle;
        auto dc = GetDC(wnd);
        scope(exit) ReleaseDC(wnd, dc);
        auto res = _wgl.MakeCurrent(dc, _ctx) != 0;
        if (!res) {
            import std.experimental.logger : errorf;
            const err = GetLastError();
            LPSTR messageBuffer = null;
            size_t size = FormatMessageA(FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_SYSTEM | FORMAT_MESSAGE_IGNORE_INSERTS,
                                        null, err, MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT), cast(LPSTR)&messageBuffer, 0, null);
            auto buf = new char[size];
            buf[] = messageBuffer[0 .. size];
            errorf(buf.idup);
        }
        return true;
    }

    override void doneCurrent()
    {
        _wgl.MakeCurrent(null, null);
    }

    override @property bool current() const
    {
        return _wgl.GetCurrentContext() == _ctx;
    }

    override @property int swapInterval()
    {
        return _wgl.GetSwapIntervalEXT();
    }

    override @property void swapInterval(int interval)
    {
        _wgl.SwapIntervalEXT(interval);
    }

    override void swapBuffers(size_t nativeHandle)
    {
        auto wnd = cast(HWND)nativeHandle;
        auto dc = GetDC(wnd);
        scope(exit) ReleaseDC(wnd, dc);
        SwapBuffers(dc);
    }

    override size_t createDummy() {
        if (hiddenDummy) {
            const d = hiddenDummy;
            hiddenDummy = 0;
            return d;
        }
        auto dummy = new DummyWindow();
        const hdl = cast(size_t)dummy.hWnd;
        dummies[hdl] = dummy;
        return hdl;
    }

    override void releaseDummy(size_t dummy) {
        auto d = dummy in dummies;
        if (d) {
            auto win = *d;
            win.dispose();
            dummies.remove(dummy);
        }
    }

    private static class DummyWindow : Disposable
    {
        HWND hWnd;

        this () {
            import std.utf : toUTF16z;

            hWnd = enforce(
                CreateWindowEx(
                    WS_EX_CLIENTEDGE,
                    wndClassName.toUTF16z,
                    null,
                    WS_OVERLAPPEDWINDOW,
                    CW_USEDEFAULT,
                    CW_USEDEFAULT,
                    CW_USEDEFAULT,
                    CW_USEDEFAULT,
                    null, null, GetModuleHandle(null), null
                ),
                "could not create win32 dummy window"
            );
        }

        override void dispose() {
            DestroyWindow(hWnd);
        }

    }

}

int[] getCtxAttribs(in GlAttribs attribs) {
    int[] ctxAttribs = [
        WGL_CONTEXT_MAJOR_VERSION_ARB, attribs.majorVersion,
        WGL_CONTEXT_MINOR_VERSION_ARB, attribs.minorVersion
    ];
    if (attribs.decimalVersion >= 32) {
        ctxAttribs ~= WGL_CONTEXT_PROFILE_MASK_ARB;
        if (attribs.profile == GlProfile.core) {
            ctxAttribs ~= WGL_CONTEXT_CORE_PROFILE_BIT_ARB;
        }
        else {
            ctxAttribs ~= WGL_CONTEXT_COMPATIBILITY_PROFILE_BIT_ARB;
        }
    }
    return ctxAttribs ~ 0;
}

private SharedLib loadGlLib()
{
    import gfx.bindings.core : openSharedLib;

    immutable glLibNames = [ "opengl32.dll" ];

    foreach (ln; glLibNames) {
        auto lib = openSharedLib(ln);
        if (lib) {
            import std.experimental.logger : tracef;
            tracef("opening shared library %s", ln);
            return lib;
        }
    }

    import std.conv : to;
    throw new Exception("could not load any of these libraries: " ~ glLibNames.to!string);
}
