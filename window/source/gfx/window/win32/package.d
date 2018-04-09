/// Win32 Window interface for Gfx-d
module gfx.window.win32;

version(Windows):

import core.sys.windows.windows;
import gfx.graal.presentation;
import gfx.window;

import std.exception;
import std.experimental.logger;

class Win32Display : Display
{
    import gfx.core.rc : atomicRcCode;
    import gfx.graal : Backend, Instance;

    mixin(atomicRcCode);

    private Win32Window[HWND] _windows;
    private Window[] _iwindows;
    private Instance _instance;

    this(in Backend[] loadOrder) {
        assert(!g_dpy);
        g_dpy = this;

        registerWindowClass();
        import std.experimental.logger : info, trace, warningf;
        assert(!_instance);

        foreach (b; loadOrder) {
            final switch (b) {
            case Backend.vulkan:
                try {
                    trace("Attempting to instantiate Vulkan");
                    import gfx.vulkan : createVulkanInstance, vulkanInit;
                    vulkanInit();
                    _instance = createVulkanInstance();
                    info("Creating a Vulkan instance");
                }
                catch (Exception ex) {
                    warningf("Vulkan is not available. %s", ex.msg);
                }
                break;
            case Backend.gl3:
                try {
                    trace("Attempting to instantiate OpenGL");
                    import gfx.core.rc : makeRc;
                    import gfx.gl3 : GlInstance;
                    import gfx.gl3.context : GlAttribs;
                    import gfx.window.win32.context : Win32GlContext;
                    auto ctx = makeRc!Win32GlContext(GlAttribs.init);
                    trace("Creating an OpenGL instance");
                    _instance = new GlInstance(ctx);
                }
                catch (Exception ex) {
                    warningf("OpenGL is not available. %s", ex.msg);
                }
                break;
            }
            if (_instance) break;
        }

        if (!_instance) {
            throw new Exception("Could not instantiate a backend");
        }
    }

    override void dispose() {
        auto openWindows = _iwindows;
        foreach (w; openWindows) { // Window.close modifies _iwindows
            w.close();
        }
        assert(!_iwindows.length);
    }

    override @property Instance instance() {
        return _instance;
    }
    override @property Window[] windows() {
        return _iwindows;
    }
    override Window createWindow() {
        return new Win32Window(this);
    }
    override void pollAndDispatch() {
        MSG msg;
        while (PeekMessageW(&msg, null, 0, 0, PM_REMOVE)) {
            TranslateMessage(&msg);
            DispatchMessageW(&msg);
        }
    }


    private void registerWindow(HWND hWnd, Win32Window w)
    {
        _windows[hWnd] = w;
        _iwindows ~= w;
    }

    private void unregisterWindow(HWND hWnd)
    {
        import std.algorithm : remove;
        _windows.remove(hWnd);
        _iwindows = _iwindows.remove!((Window w) {
            return (cast(Win32Window)w).hWnd == hWnd;
        });
    }

    private Win32Window findWithHWnd(HWND hWnd)
    {
        Win32Window *w = (hWnd in _windows);
        return w ? *w : null;
    }

    private bool wndProc(HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam, out LRESULT res)
    {
        res = 0;

        Win32Window wnd = findWithHWnd(hWnd);
        if (!wnd) {
            return false;
        }

        switch(msg)
        {
            case WM_CLOSE:
                if (wnd.closeHandler) {
                    wnd._closeFlag = wnd.closeHandler();
                }
                else {
                    wnd._closeFlag = true;
                }
                return true;
            case WM_LBUTTONDOWN:
            case WM_LBUTTONUP:
            case WM_MBUTTONDOWN:
            case WM_MBUTTONUP:
            case WM_RBUTTONDOWN:
            case WM_RBUTTONUP:
            case WM_MOUSEMOVE:
            case WM_MOUSELEAVE:
                return wnd.handleMouse(msg, wParam, lParam);
            case WM_KEYDOWN:
            case WM_KEYUP:
            case WM_CHAR:
                return wnd.handleKey(msg, wParam, lParam);
            default:
                return false;
        }
    }

}

class Win32Window : Window
{
    import gfx.core.rc : Rc;

    private Win32Display dpy;
    private HWND hWnd;
    private Rc!Surface gfxSurface;

    private MouseHandler moveHandler;
    private MouseHandler onHandler;
    private MouseHandler offHandler;
    private KeyHandler keyOnHandler;
    private KeyHandler keyOffHandler;
    private CloseHandler closeHandler;
    private bool mouseOut;
    private bool _closeFlag;

    this(Win32Display dpy) {
        this.dpy = dpy;
        import std.utf : toUTF16z;

        HINSTANCE hInstance = GetModuleHandle(null);

        hWnd = enforce(
            CreateWindowEx(
                WS_EX_CLIENTEDGE, // | WS_EX_LAYERED,
                wndClassName.toUTF16z,
                "null",
                WS_OVERLAPPEDWINDOW,
                CW_USEDEFAULT,
                CW_USEDEFAULT,
                CW_USEDEFAULT,
                CW_USEDEFAULT,
                null, null, hInstance, null
            ),
            "could not create win32 window"
        );

        // What follow is a non-portable way to have alpha value of framebuffer used in desktop composition
        // (by default composition makes window completely opaque)
        // only works on Windows 7 and therefore disabled

        // DWM_BLURBEHIND bb;
        // bb.dwFlags = DWM_BB_ENABLE;
        // bb.fEnable = TRUE;
        // bb.hRgnBlur = NULL;
        // DwmEnableBlurBehindWindow(hWnd, &bb);
        // MARGINS m = { -1 };
        // DwmExtendFrameIntoClientArea(hWnd, &m);

        import gfx.graal : Backend;
        final switch (dpy.instance.backend) {
        case Backend.vulkan:
            import gfx.vulkan.wsi : createVulkanWin32Surface;
            gfxSurface = createVulkanWin32Surface(dpy.instance, GetModuleHandle(null), hWnd);
            break;

        case Backend.gl3:
            import gfx.gl3 : GlInstance;
            import gfx.gl3.swapchain : GlSurface;
            import gfx.window.win32.context : Win32GlContext;

            gfxSurface = new GlSurface(cast(size_t)hWnd);
            auto glInst = cast(GlInstance)dpy.instance;
            auto ctx = cast(Win32GlContext)glInst.ctx;
            ctx.setPixelFormat(hWnd);
            ctx.makeCurrent(cast(size_t)hWnd);
            break;
        }

        dpy.registerWindow(hWnd, this);
    }

    override void show(uint width, uint height) {
        RECT r;
        r.right = width;
        r.bottom = height;
        AdjustWindowRectEx(&r, WS_BORDER | WS_CAPTION, FALSE, 0);
        SetWindowPos(hWnd, HWND_TOP, 0, 0, r.right - r.left, r.bottom - r.top, SWP_SHOWWINDOW | SWP_NOMOVE);
    }

    override void close() {
		DestroyWindow(hWnd);
        gfxSurface.unload();
        dpy.unregisterWindow(hWnd);
    }

    override @property bool closeFlag() const {
        return _closeFlag;
    }
    override @property void closeFlag(in bool flag) {
        _closeFlag = flag;
    }

    override @property void onMouseMove(MouseHandler handler) {
        moveHandler = handler;
    }
    override @property void onMouseOn(MouseHandler handler) {
        onHandler = handler;
    }
    override @property void onMouseOff(MouseHandler handler) {
        offHandler = handler;
    }
    override @property void onKeyOn(KeyHandler handler) {
        keyOnHandler = handler;
    }
    override @property void onKeyOff(KeyHandler handler) {
        keyOffHandler = handler;
    }
    override @property void onClose(CloseHandler handler) {
        closeHandler = handler;
    }

    override @property Surface surface() {
        return gfxSurface.obj;
    }

    private bool handleMouse(UINT msg, WPARAM wParam, LPARAM lParam) {
        const x = GET_X_LPARAM(lParam);
        const y = GET_Y_LPARAM(lParam);

        switch (msg) {
        case WM_LBUTTONDOWN:
        case WM_MBUTTONDOWN:
        case WM_RBUTTONDOWN:
            if (onHandler) {
                onHandler(x, y);
                return true;
            }
            break;
        case WM_LBUTTONUP:
        case WM_MBUTTONUP:
        case WM_RBUTTONUP:
            if (offHandler) {
                offHandler(x, y);
                return true;
            }
            break;
        case WM_MOUSEMOVE:
            if (mouseOut) {
                mouseOut = false;
                // mouse was out, deliver enter event (TODO)
                // and register for leave event
                TRACKMOUSEEVENT tm;
                tm.cbSize = TRACKMOUSEEVENT.sizeof;
                tm.dwFlags = TME_LEAVE;
                tm.hwndTrack = hWnd;
                tm.dwHoverTime = 0;
                TrackMouseEvent(&tm);
            }
            if (moveHandler) {
                moveHandler(x, y);
                return true;
            }
            break;
        case WM_MOUSELEAVE:
            mouseOut = true;
            // TODO: deliver leave event
            break;
        default:
            break;
        }

        return false;
    }

    private bool handleKey(UINT msg, WPARAM wParam, LPARAM lParam) {
        KeyHandler handler;
        if (msg == WM_KEYDOWN) {
            handler = keyOnHandler;
        }
        else if (msg == WM_KEYUP) {
            handler = keyOffHandler;
        }

        if (handler) {
            handler(cast(int)lParam); // TODO: sym, text, scancode and repeat from dgt
            return true;
        }
        else {
            return false;
        }
    }
}

private __gshared Win32Display g_dpy;
package immutable wstring wndClassName = "GfxDWin32WindowClass"w;


package void registerWindowClass()
{
    import std.utf : toUTF16z;

    static bool registered;
    if (registered) return;
    registered = true;

    WNDCLASSEX wc;
    wc.cbSize        = WNDCLASSEX.sizeof;
    wc.style         = CS_OWNDC;
    wc.lpfnWndProc   = &win32WndProc;
    wc.cbClsExtra    = 0;
    wc.cbWndExtra    = 0;
    wc.hInstance     = GetModuleHandle(null);
    wc.hIcon         = LoadIcon(null, IDI_APPLICATION);
    wc.hCursor       = LoadCursor(null, IDC_ARROW);
    wc.hbrBackground = null;
    wc.lpszMenuName  = null;
    wc.lpszClassName = wndClassName.toUTF16z;
    wc.hIconSm       = LoadIcon(null, IDI_APPLICATION);

    enforce(RegisterClassExW(&wc), "could not register win32 window class");
}

package int GET_X_LPARAM(in LPARAM lp) pure
{
    return cast(int)(lp & 0x0000ffff);
}

package int GET_Y_LPARAM(in LPARAM lp) pure
{
    return cast(int)((lp & 0xffff0000) >> 16);
}

extern(Windows) nothrow
private LRESULT win32WndProc (HWND hwnd, UINT msg, WPARAM wParam, LPARAM lParam)
{
    import std.exception : collectExceptionMsg;
    LRESULT res;
    try
    {
        if (!g_dpy || !g_dpy.wndProc(hwnd, msg, wParam, lParam, res))
        {
            res = DefWindowProc(hwnd, msg, wParam, lParam);
        }
    }
    catch(Exception ex)
    {
        import std.experimental.logger : errorf;
        try { errorf("Win32 Proc exception: %s", ex.msg); }
        catch(Exception) {}
    }
    return res;
}

// a few missing bindings

private:

// see comment in Win32Window ctor

// struct DWM_BLURBEHIND {
//     DWORD dwFlags;
//     BOOL  fEnable;
//     HRGN  hRgnBlur;
//     BOOL  fTransitionOnMaximized;
// }

// struct MARGINS {
//     int left; int right; int top; int bottom;
// }

// enum DWM_BB_ENABLE = 0x00000001;

// extern(Windows) HRESULT DwmEnableBlurBehindWindow(
//     HWND hWnd,
//     const(DWM_BLURBEHIND)* pBlurBehind
// );
// extern(Windows) HRESULT DwmExtendFrameIntoClientArea(
//     HWND    hWnd,
//     const(MARGINS)* pMarInset
// );
