/// Optional window package, mainly to run gfx-d examples
module gfx.window;

alias MouseHandler = void delegate(uint x, uint y);

interface Window
{
    void show(uint width, uint height);
    void close();

    @property void mouseMove(MouseHandler handler);
    @property void mouseOn(MouseHandler handler);
    @property void mouseOff(MouseHandler handler);
}

Window createWindow()
{
    version(GfxVulkanWayland) {
        import gfx.window.wayland : WaylandWindow;
        return new WaylandWindow;
    }
    else {
        pragma(msg, "unsupported window");
        return null;
    }
}
