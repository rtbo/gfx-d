module gfx.window.glfw;

import gfx.backend.gl3 :    GlDevice, createGlDevice;
import gfx.core :           Device;
import gfx.core.rc :        RefCounted, Rc, rcCode;
import gfx.core.format :    isFormatted, Formatted, SurfaceType, ChannelType,
                            isRender, isDepth, isStencil, isDepthStencil, hasDepthStencilSurface,
                            redBits, greenBits, blueBits, alphaBits, depthBits, stencilBits,
                            hasChannel;

import derelict.glfw3.glfw3;
import derelict.opengl3.gl3;

import std.meta : allSatisfy;


shared static this() {
    import std.exception : enforce;
    DerelictGLFW3.load();
    DerelictGL3.load();
    glfwSetErrorCallback(&handleError);
    enforce(glfwInit());
}

shared static ~this() {
    glfwMakeContextCurrent(null);
    glfwTerminate();
}


extern(C)
private void handleError(int code, const(char)*str) nothrow {
    try {
        import std.experimental.logger;
        import std.string : fromStringz;
        errorf("GLFW error: %s: %s", code, fromStringz(str));
    }
    catch(Throwable th) {}
}

extern(C)
private void handleClose(GLFWwindow* window) nothrow {
    glfwSetWindowUserPointer(window, null);
}


class RawWindow : RefCounted {
    mixin(rcCode);

    private GLFWwindow *_window;
    private Rc!GlDevice _device;


    /// constructor without depth/stencil buffer
    this(string title, ushort width, ushort height, ubyte samples, SurfaceType colorSurf)
    {
        setupGlContext();
        setupColor(colorSurf);
        setupMisc(samples);
        setupWindow(title, width, height);
    }

    /// constructor with a depth and/or stencil buffer
    this(string title, ushort width, ushort height, ubyte samples,
            SurfaceType colorSurf, SurfaceType dsSurf)
    {
        setupGlContext();
        setupColor(colorSurf);
        setupDs(dsSurf);
        setupMisc(samples);
        setupWindow(title, width, height);
    }

    /// constructor with a depth and a stencil buffer
    this(string title, ushort width, ushort height, ubyte samples,
            SurfaceType colorSurf, SurfaceType dsSurf1, SurfaceType dsSurf2)
    {
        /// TODO: assert depth xor stencil
        setupGlContext();
        setupColor(colorSurf);
        setupDs(dsSurf1); setupDs(dsSurf2);
        setupMisc(samples);
        setupWindow(title, width, height);
    }

    private void setupGlContext() {
        glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
        glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
        glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
    }

    private void setupColor(SurfaceType colSurf) {
        assert(isRender(colSurf));
        glfwWindowHint(GLFW_RED_BITS,       colSurf.redBits);
        glfwWindowHint(GLFW_GREEN_BITS,     colSurf.greenBits);
        glfwWindowHint(GLFW_BLUE_BITS,      colSurf.blueBits);
        glfwWindowHint(GLFW_ALPHA_BITS,     colSurf.alphaBits);
        glfwWindowHint(GLFW_SRGB_CAPABLE,   colSurf.hasChannel(ChannelType.Srgb));

        // forget previous setup
        glfwWindowHint(GLFW_DEPTH_BITS, 0);
        glfwWindowHint(GLFW_STENCIL_BITS, 0);
    }

    private void setupDs(SurfaceType dsSurf) {
        assert(isDepthStencil(dsSurf));
        if (dsSurf.isDepth) glfwWindowHint(GLFW_DEPTH_BITS, dsSurf.depthBits);
        if (dsSurf.isStencil) glfwWindowHint(GLFW_STENCIL_BITS, dsSurf.stencilBits);
    }

    private void setupMisc(ubyte samples) {
        glfwWindowHint(GLFW_SAMPLES,        samples);
        glfwWindowHint(GLFW_DOUBLEBUFFER,   1);
    }

    private void setupWindow(string title, ushort width, ushort height) {
        import std.exception : enforce;
        import std.string : toStringz;

        _window = glfwCreateWindow(width, height, toStringz(title), null, null);
        enforce(_window);
        glfwSetWindowUserPointer(_window, cast(void*)this);

        makeCurrent();
        shared static bool reloaded = false;
        if (!reloaded) DerelictGL3.reload();

        _device = new GlDevice();
    }



    void drop() {
        _device.unload();
    }

    @property inout(GLFWwindow)* glfwWindow() inout {
        return _window;
    }

    @property inout(Device) device() inout { return _device.obj; }

    @property bool shouldClose() const {
        return cast(bool)glfwWindowShouldClose(cast(GLFWwindow*)_window);
    }

    @property void shouldClose(bool val) {
        glfwSetWindowShouldClose(_window, val);
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


class Window(Col, DepSten...) : RawWindow if (allSatisfy!(hasDepthStencilSurface, DepSten)) {

    import gfx.core.format : hasRenderSurface;

    static assert(hasRenderSurface!Col, Col.stringof~" is not a valid color format");

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
        else {
            static assert(false, "supplied to many buffer configurations");
        }
    }
}



auto gfxGlfwWindow(Col, DepSten...)(string title, ushort width, ushort height, ubyte samples=1)
{
    return new Window!(Col, DepSten)(title, width, height, samples);
}
