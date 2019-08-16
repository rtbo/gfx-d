/// Optional window package, mainly to run gfx-d examples
module gfx.window;

import gfx.core.rc : IAtomicRefCounted;
import gfx.core.log : LogTag;
import gfx.graal : Backend, Instance;
public import gfx.window.keys;

enum gfxWindowLogMask = 0x0800_0000;
package immutable gfxWindowLog = LogTag("GFX-WINDOW", gfxWindowLogMask);

struct KeyEvent
{
    KeySym sym;
    KeyCode code;
    KeyMods mods;
    string text;
}

struct MouseEvent
{
    uint x; uint y;
    KeyMods mods;
}

alias MouseHandler = void delegate(MouseEvent ev);
alias KeyHandler = void delegate(KeyEvent ev);
alias ResizeHandler = void delegate(uint width, uint height);
alias CloseHandler = bool delegate();

interface Display : IAtomicRefCounted
{
    @property Instance instance();
    @property Window[] windows();
    Window createWindow(string title="Gfx-d Window");
    void pollAndDispatch();
}

interface Window
{
    import gfx.graal.presentation : Surface;

    void show(uint width, uint height);
    void close();

    @property string title();
    void setTitle(string title);

    @property Surface surface();
    @property bool closeFlag() const;
    @property void closeFlag(in bool flag);

    @property void onResize(ResizeHandler handler);
    @property void onMouseMove(MouseHandler handler);
    @property void onMouseOn(MouseHandler handler);
    @property void onMouseOff(MouseHandler handler);
    @property void onKeyOn(KeyHandler handler);
    @property void onKeyOff(KeyHandler handler);
    @property void onClose(CloseHandler handler);
}

/// The backend load order is the order into which backend load attempts
/// will be performed.
/// This array provides a default value for createDisplay parameter
immutable Backend[] defaultBackendLoadOrder = [
    Backend.vulkan,
    Backend.gl3,
];


/// Create a display for the running platform.
/// The display will load a backend instance during startup.
/// It will try the backends in the provided loadOrder
Display createDisplay(in Backend[] loadOrder=defaultBackendLoadOrder)
{
    version(linux) {
        enum useWayland = true;
        static if (useWayland) {
            import gfx.window.wayland : WaylandDisplay;
            return new WaylandDisplay;
        }
        else {
            import gfx.window.xcb : XcbDisplay;
            return new XcbDisplay(loadOrder);
        }
    }
    else version(Windows) {
        import gfx.window.win32 : Win32Display;
        return new Win32Display(loadOrder);
    }
    else {
        pragma(msg, "Unsupported platform");
        assert(false, "Unsupported platform");
    }
}
