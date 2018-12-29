module highlevel;

private:

import gfx.core.rc : Disposable;

final class HighLevel : Disposable
{
    import gfx.core.rc : Rc;
    import gfx.graal : Instance;
    import gfx.hl.device : GraphicsDevice, openGraphicsDevice;
    import gfx.hl.surface : chooseSurfaceFormat, GraphicsSurface;
    import gfx.math : FMat4, FVec3, FVec4, NDC;
    import gfx.window : createDisplay, Display, Window;

    string title;
    string[] args;

    Rc!Display display;
    Window window;
    Rc!Instance instance;

    Rc!GraphicsDevice device;
    Rc!GraphicsSurface surface;

    NDC ndc;

    override void dispose()
    {
        surface.unload();
        device.unload();
        instance.unload();
        display.unload();
    }

    struct Vertex
    {
        FVec3 position;
        FVec3 normal;
        FVec4 color;
    }

    struct Matrices
    {
        FMat4 mvp;
        FMat4 normal;
    }

    enum maxLights = 5;

    struct Light
    {
        FVec4 direction;
        FVec4 color;
    }

    struct Lights
    {
        Light[maxLights] lights;
        uint num;
    }

    this (string title, string[] args=[])
    {
        this.title = title;
        this.args = args;
    }

    void prepare()
    {
        import gfx.graal : Backend, Severity;
        import gfx.graal.presentation : PresentMode;
        import gfx.hl.device : findGraphicsDevice;
        import std.exception : enforce;

        bool noVulkan = false;
        foreach (a; args) {
            if (a == "--no-vulkan" || a == "nv") {
                noVulkan = true;
                break;
            }
        }
        Backend[] backendLoadOrder;
        if (!noVulkan) {
            backendLoadOrder ~= Backend.vulkan;
        }
        backendLoadOrder ~= Backend.gl3;

        // Create a display for the running platform.
        // The instance is created by the display. Backend is chosen at runtime
        // depending on detected API support. (i.e. Vulkan is preferred)
        display = createDisplay(backendLoadOrder);
        instance = display.instance;
        ndc = instance.apiProps.ndc;
        // Create a window. The surface is created during the call to show.
        window = display.createWindow();
        window.show(640, 480);

        instance.setDebugCallback((Severity sev, string msg) {
            import std.stdio : writefln;
            if (sev == Severity.warning) {
                writefln("Gfx backend %s message: %s", sev, msg);
            }
            else if (sev == Severity.error) {
                // debug break
                asm { int 0x03; }
            }
        });

        device = openGraphicsDevice(instance.obj, window.surface);
        const format = chooseSurfaceFormat(device.physicalDevice, window.surface);
        surface = new GraphicsSurface(device.device, window.surface, format, PresentMode.fifo);

    }

}

void main(string[] args)
{
    auto example = new HighLevel("High-Level example", args);
    scope(exit) example.dispose();

    example.prepare();
}
