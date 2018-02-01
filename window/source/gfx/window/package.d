/// Optional window package, mainly to run gfx-d examples
module gfx.window;

import gfx.graal : Instance;
import gfx.graal.presentation;

alias MouseHandler = void delegate(uint x, uint y);
alias KeyHandler = void delegate(uint key);

interface Window
{
    void prepareSurface();
    void show(uint width, uint height);
    void close();

    @property Surface surface();

    @property void mouseMove(MouseHandler handler);
    @property void mouseOn(MouseHandler handler);
    @property void mouseOff(MouseHandler handler);
    @property void keyOn(KeyHandler handler);
    @property void keyOff(KeyHandler handler);

    void pollAndDispatch();
}

Window createWindow(Instance instance)
{
    version(linux) {
        import gfx.window.wayland : refDisplay, unrefDisplay;
        auto dpy = refDisplay();
        scope(exit) unrefDisplay();
        auto win = dpy.createWindow(instance);
        win.prepareSurface();
        return win;
    }
    else {
        pragma(msg, "unsupported window");
        return null;
    }
}
