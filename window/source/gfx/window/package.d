/// Optional window package, mainly to run gfx-d examples
module gfx.window;

import gfx.core.rc : AtomicRefCounted;
import gfx.graal : Backend, Instance;

alias MouseHandler = void delegate(uint x, uint y);
alias KeyHandler = void delegate(uint key);
alias CloseHandler = bool delegate();

interface Display : AtomicRefCounted
{
    @property Instance instance();
    @property Window[] windows();
    Window createWindow();
    void pollAndDispatch();
}

interface Window
{
    import gfx.graal.presentation : Surface;

    void show(uint width, uint height);
    void close();

    @property Surface surface();
    @property bool closeFlag() const;
    @property void closeFlag(in bool flag);

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
        enum useWayland = false;
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
        return new Win32Display;
    }
    else {
        pragma(msg, "Unsupported platform");
        assert(false, "Unsupported platform");
    }
}
