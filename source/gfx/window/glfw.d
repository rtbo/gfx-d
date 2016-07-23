module gfx.window.glfw;

import gfx.backend.gl3 :    GlDevice, createGlDevice;
import gfx.core :           Device;
import gfx.core.rc :        RefCounted, Rc, rcCode;
import gfx.core.format :    Formatted, SurfaceType, ChannelType, isRender, isDepthStencil,
                            redBits, greenBits, blueBits, alphaBits, depthBits, stencilBits,
                            hasChannel;

import derelict.glfw3.glfw3;
import derelict.opengl3.gl3;


extern(C)
void handleError(int code, const(char)*str) nothrow {
    try {
        import std.experimental.logger;
        import std.string : fromStringz;
        errorf("GLFW error: %s: %s", code, fromStringz(str));
    }
    catch(Throwable th) {}
}


class RawWindow : RefCounted {
    mixin(rcCode);

    private GLFWwindow *_window;
    private Rc!GlDevice _device;

    this(string title, ushort width, ushort height,
            SurfaceType colorSurf, SurfaceType depthStencilSurf, ubyte samples=1)
    {
        import std.string : toStringz;
        import std.exception : enforce;
        assert(isRender(colorSurf) && isDepthStencil(depthStencilSurf));

        DerelictGLFW3.load();
        DerelictGL3.load();

        enforce(glfwInit());

        glfwSetErrorCallback(&handleError);

        glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
        glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
        glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);

        glfwWindowHint(GLFW_RED_BITS,       colorSurf.redBits);
        glfwWindowHint(GLFW_GREEN_BITS,     colorSurf.greenBits);
        glfwWindowHint(GLFW_BLUE_BITS,      colorSurf.blueBits);
        glfwWindowHint(GLFW_ALPHA_BITS,     colorSurf.alphaBits);
        glfwWindowHint(GLFW_DEPTH_BITS,     colorSurf.depthBits);
        glfwWindowHint(GLFW_STENCIL_BITS,   colorSurf.stencilBits);
        glfwWindowHint(GLFW_SRGB_CAPABLE,   colorSurf.hasChannel(ChannelType.Srgb));
        glfwWindowHint(GLFW_SAMPLES,        samples);
        glfwWindowHint(GLFW_DOUBLEBUFFER,   1);

        _window = glfwCreateWindow(width, height, toStringz(title), null, null);
        enforce(_window);

        makeCurrent();
        DerelictGL3.reload();

        _device = new GlDevice();
    }

    void drop() {
        _device.unload();
        glfwMakeContextCurrent(null);
        glfwTerminate();
    }

    @property inout(GLFWwindow)* glfwWindow() inout {
        return _window;
    }

    @property inout(Device) device() inout { return _device.obj; }

    @property bool shouldClose() const {
        return cast(bool)glfwWindowShouldClose(cast(GLFWwindow*)_window);
    }

    void pollEvents() {
        glfwPollEvents();
    }

    void makeCurrent() {
        glfwMakeContextCurrent(_window);
    }

    void doneCurrent() {
        glfwMakeContextCurrent(null);
    }

    void swapBuffers() {
        glfwSwapBuffers(_window);
    }
}


class Window(Col, DepSten) : RawWindow {

    import gfx.core.format : isFormatted, Formatted, isRenderSurface, isDepthStencilSurface;

    static assert(isFormatted!Col,
                    Col.stringof~" is not a valid color format");
    static assert(isRenderSurface!(Formatted!Col.Surface),
                    Col.stringof~" is not a valid color format");
    static assert(isFormatted!DepSten,
                    DepSten.stringof~" is not a valid depth-stencil format");
    static assert(isDepthStencilSurface!(Formatted!DepSten.Surface),
                    DepSten.stringof~" is not a valid depth-stencil format");

    this(string title, ushort width, ushort height, ubyte samples=1) {
        import gfx.core.format : format;
        immutable colF = format!Col;
        immutable dsF = format!DepSten;
        super(title, width, height, colF.surface, dsF.surface, samples);
    }
}



auto gfxGlfwWindow(Col, DepSten)(string title, ushort width, ushort height, ubyte samples=1)
{
    return new Window!(Col, DepSten)(title, width, height, samples);
}
