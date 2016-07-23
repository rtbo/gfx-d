module gfx.window.glfw;

import gfx.backend.gl3 :    GlDevice, createGlDevice;
import gfx.core :           Device;
import gfx.core.rc :        RefCounted, Rc, rcCode;
import gfx.core.format :    isFormatted, Formatted, SurfaceType, ChannelType,
                            isRender, isDepth, isStencil, isDepthStencil,
                            redBits, greenBits, blueBits, alphaBits, depthBits, stencilBits,
                            hasChannel;

import derelict.glfw3.glfw3;
import derelict.opengl3.gl3;

import std.meta : allSatisfy;

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

    /// constructor without depth/stencil buffer
    this(string title, ushort width, ushort height, ubyte samples, SurfaceType colorSurf)
    {
        preInit(colorSurf, samples);
        postInit(title, width, height);
    }

    /// constructor with a depth and/or stencil buffer
    this(string title, ushort width, ushort height, ubyte samples,
            SurfaceType colorSurf, SurfaceType dsSurf)
    {
        preInit(colorSurf, samples);
        initDs(dsSurf);
        postInit(title, width, height);
    }

    /// constructor with a depth and a stencil buffer
    this(string title, ushort width, ushort height, ubyte samples,
            SurfaceType colorSurf, SurfaceType dsSurf1, SurfaceType dsSurf2)
    {
        /// TODO: assert depth xor stencil
        preInit(colorSurf, samples);
        initDs(dsSurf1); initDs(dsSurf2);
        postInit(title, width, height);
    }

    private void initDs(SurfaceType dsSurf) {
        assert(isDepthStencil(dsSurf));
        if (dsSurf.isDepth) glfwWindowHint(GLFW_DEPTH_BITS, dsSurf.depthBits);
        if (dsSurf.isStencil) glfwWindowHint(GLFW_STENCIL_BITS, dsSurf.stencilBits);
    }

    private void preInit(SurfaceType colorSurf, ubyte samples) {
        import std.exception : enforce;

        assert(isRender(colorSurf));

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
        glfwWindowHint(GLFW_SRGB_CAPABLE,   colorSurf.hasChannel(ChannelType.Srgb));
        glfwWindowHint(GLFW_SAMPLES,        samples);
        glfwWindowHint(GLFW_DOUBLEBUFFER,   1);

    }

    private void postInit(string title, ushort width, ushort height) {
        import std.exception : enforce;
        import std.string : toStringz;

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

    /// swap front and back buffer
    void swapBuffers() {
        glfwSwapBuffers(_window);
    }
}

template hasDepthStencilSurface(Fmt) if (isFormatted!Fmt) {
    import gfx.core.format : isDepthStencilSurface;
    enum hasDepthStencilSurface = isDepthStencilSurface!(Formatted!Fmt.Surface);
}

template hasRenderSurface(Fmt) if (isFormatted!Fmt) {
    import gfx.core.format : isRenderSurface;
    enum hasRenderSurface = isRenderSurface!(Formatted!Fmt.Surface);
}


class Window(Col, DepSten...) : RawWindow if (allSatisfy!(hasDepthStencilSurface, DepSten)) {

    import gfx.core.format : isFormatted, Formatted, isRenderSurface;

    static assert(isFormatted!Col,
                    Col.stringof~" is not a valid color format");
    static assert(isRenderSurface!(Formatted!Col.Surface),
                    Col.stringof~" is not a valid color format");

    this(string title, ushort width, ushort height, ubyte samples=1) {
        import gfx.core.format : format;
        immutable colF = format!Col;
        static if (DepSten.length == 0) {
            super(title, width, height, samples, colF.surface);
        }
        else static if (DepSten.length == 1) {
            immutable dsF = format!(DepSten[0]);
            super(title, width, height, samples, colF.surface, dsF.surface);
        }
        else static if (DepSten.length == 2) {
            immutable dsF1 = format!(DepSten[0]);
            immutable dsF2 = format!(DepSten[1]);
            super(title, width, height, samples, colF.surface, dsF1.surface, dsF2.surface);
        }
    }
}



auto gfxGlfwWindow(Col, DepSten...)(string title, ushort width, ushort height, ubyte samples=1)
{
    return new Window!(Col, DepSten)(title, width, height, samples);
}
