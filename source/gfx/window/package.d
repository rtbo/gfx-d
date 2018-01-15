/// Optional window package, mainly to run gfx-d examples
module gfx.window;

import gfx.graal : Instance;
import gfx.graal.presentation;

alias MouseHandler = void delegate(uint x, uint y);

interface Window
{
    void show(uint width, uint height);
    void close();

    @property Surface surface();

    @property void mouseMove(MouseHandler handler);
    @property void mouseOn(MouseHandler handler);
    @property void mouseOff(MouseHandler handler);

    void pollAndDispatch();
    void waitAndDispatch();
}

Window createWindow(Instance instance)
{
    version(GfxVulkanWayland) {
        import gfx.window.wayland : WaylandWindow;
        return new WaylandWindow(instance);
    }
    else {
        pragma(msg, "unsupported window");
        return null;
    }
}
