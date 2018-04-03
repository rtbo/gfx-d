/// Win32 Window interface for Gfx-d
module gfx.window.win32;

version(Windows):

import core.sys.windows.windows;
import gfx.graal.presentation;
import gfx.window;

import std.exception;

class Win32Display : Display
{
    import gfx.core.rc : atomicRcCode;
    import gfx.graal : Instance;

    mixin(atomicRcCode);

    private Win32Window[HWND] _windows;
    private Window[] _iwindows;
    private Instance _instance;

    this() {
        assert(!g_dpy);
        g_dpy = this;

        registerWindowClass();

        import gfx.vulkan : createVulkanInstance, vulkanInit;
        vulkanInit();
        _instance = createVulkanInstance();
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
    private void registerWindowClass()
    {
        import std.algorithm : canFind;
        import std.conv : to;
        import std.utf : toUTF16z;

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
                wnd.close();
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
    private Win32Display dpy;
    private HWND hWnd;
    private Surface gfxSurface;

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
        import std.conv : to;
        import std.utf : toUTF16z;

        HINSTANCE hInstance = GetModuleHandle(null);

        hWnd = CreateWindowEx(
                    WS_EX_CLIENTEDGE,
                    wndClassName.toUTF16z,
                    "null",
                    WS_OVERLAPPEDWINDOW,
                    CW_USEDEFAULT,
                    CW_USEDEFAULT,
                    CW_USEDEFAULT,
                    CW_USEDEFAULT,
                    null, null, hInstance, null);

        if (hWnd is null) {
            throw new Exception("Win32 window could not be created from class "~wndClassName.to!string);
        }

        import gfx.vulkan.wsi : createWin32VulkanSurface;
        gfxSurface = createWin32VulkanSurface(dpy.instance, GetModuleHandle(null), hWnd);

        dpy.registerWindow(hWnd, this);
    }

    override void show(uint width, uint height) {
        RECT r;
        GetClientRect(hWnd, &r);
        SetWindowPos(hWnd, HWND_TOP, r.left, r.top, width, height, SWP_SHOWWINDOW);
    }

    override void close() {
		DestroyWindow(hWnd);
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
        return gfxSurface;
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

private:

private __gshared Win32Display g_dpy;
private immutable wstring wndClassName = "GfxDWin32WindowClass"w;



int GET_X_LPARAM(in LPARAM lp) pure
{
    return cast(int)(lp & 0x0000ffff);
}

int GET_Y_LPARAM(in LPARAM lp) pure
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
