/// Optional window package, mainly to run gfx-d examples
module gfx.window;

import gfx.core.rc : AtomicRefCounted;
import gfx.graal : Instance;

alias MouseHandler = void delegate(uint x, uint y);
alias KeyHandler = void delegate(uint key);

interface Display : AtomicRefCounted
{
    @property Window[] windows();
    Window createWindow(Instance instance);
    void pollAndDispatch();
}

interface Window
{
    import gfx.graal.presentation : Surface;

    void show(uint width, uint height);
    void close();

    @property Surface surface();

    @property void mouseMove(MouseHandler handler);
    @property void mouseOn(MouseHandler handler);
    @property void mouseOff(MouseHandler handler);
    @property void keyOn(KeyHandler handler);
    @property void keyOff(KeyHandler handler);
}

Display createDisplay()
{
    version(linux) {
        import gfx.window.xcb : XcbDisplay;
        return new XcbDisplay;
        // import gfx.window.wayland : WaylandDisplay;
        // return new WaylandDisplay;
    }
    else {
        pragma(msg, "Unsupported platform");
        assert(false, "Unsupported platform");
    }
}
