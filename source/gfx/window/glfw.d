module gfx.window.glfw;

import gfx.device.gl3 :    GlDevice, createGlDevice;
import gfx.device :           Device, Size;
import gfx.foundation.rc :        RefCounted, Rc, rcCode;
import gfx.pipeline.format :    isFormatted, Formatted, SurfaceType, ChannelType,
                            isRender, isDepth, isStencil, isDepthOrStencil, hasDepthOrStencilSurface,
                            redBits, greenBits, blueBits, alphaBits, depthBits, stencilBits,
                            hasChannel;
import gfx.pipeline.surface :   Surface;

import derelict.glfw3.glfw3;
import derelict.opengl3.gl3;

import std.meta : allSatisfy;
import std.typecons : Flag;


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
        import std.experimental.logger : errorf;
        import std.string : fromStringz;
        errorf("GLFW error: %s: %s", code, fromStringz(str));
    }
    catch(Exception) {}
}

extern(C)
private void handleClose(GLFWwindow* window) nothrow {
    RawWindow w = cast(RawWindow)glfwGetWindowUserPointer(window);
    if (w && w._closeDg) {
        try { w._closeDg(); }
        catch(Exception) {}
    }
    if (w.shouldClose) {
        // will actually close
        glfwSetWindowUserPointer(window, null);
    }
}

extern(C)
private void handleSize(GLFWwindow* window, int width, int height) nothrow {
    RawWindow w = cast(RawWindow)glfwGetWindowUserPointer(window);
    if (w && w._resizeDg) {
        try { w._resizeDg(Size(cast(ushort)width, cast(ushort)height)); }
        catch(Exception) {}
    }
}

extern(C)
private void handleFbSize(GLFWwindow* window, int width, int height) nothrow {
    RawWindow w = cast(RawWindow)glfwGetWindowUserPointer(window);
    if (w && w._fbResizeDg) {
        try { w._fbResizeDg(Size(cast(ushort)width, cast(ushort)height)); }
        catch(Exception) {}
    }
}

extern(C)
private void handleIconify(GLFWwindow* window, int iconified) nothrow {
    RawWindow w = cast(RawWindow)glfwGetWindowUserPointer(window);
    if (w && w._iconifyDg) {
        import std.typecons : Yes, No;
        immutable flag = iconified==0 ? No.iconified : Yes.iconified;
        try { w._iconifyDg(flag); }
        catch(Exception) {}
    }
}

extern(C)
private void handleFocus(GLFWwindow* window, int focused) nothrow {
    RawWindow w = cast(RawWindow)glfwGetWindowUserPointer(window);
    if (w && w._focusDg) {
        import std.typecons : Yes, No;
        immutable flag = focused==0 ? No.focused : Yes.focused;
        try { w._focusDg(flag); }
        catch(Exception) {}
    }
}

extern(C)
private void handleKey(GLFWwindow* window, int key, int scancode, int action, int mods) nothrow {
    RawWindow w = cast(RawWindow)glfwGetWindowUserPointer(window);
    if (w && w._keyDg) {
        try { w._keyDg(key, scancode, action, mods); }
        catch(Exception) {}
    }
}

extern(C)
private void handleChar(GLFWwindow* window, uint codepoint) nothrow {
    RawWindow w = cast(RawWindow)glfwGetWindowUserPointer(window);
    if (w && w._charDg) {
        try { w._charDg(codepoint); }
        catch(Exception) {}
    }
}

extern(C)
private void handleCursorPos(GLFWwindow* window, double xpos, double ypos) nothrow {
    RawWindow w = cast(RawWindow)glfwGetWindowUserPointer(window);
    if (w && w._cursorPosDg) {
        try { w._cursorPosDg(xpos, ypos); }
        catch(Exception) {}
    }
}

extern(C)
private void handleCursorEnter(GLFWwindow* window, int enter) nothrow {
    RawWindow w = cast(RawWindow)glfwGetWindowUserPointer(window);
    if (w && w._cursorEnterDg) {
        import std.typecons : Yes, No;
        immutable flag = enter==0 ? No.enter : Yes.enter;
        try { w._cursorEnterDg(flag); }
        catch(Exception) {}
    }
}

extern(C)
private void handleMouseButton(GLFWwindow* window, int button, int action, int mods) nothrow {
    RawWindow w = cast(RawWindow)glfwGetWindowUserPointer(window);
    if (w && w._mouseButtonDg) {
        try { w._mouseButtonDg(button, action, mods); }
        catch(Exception) {}
    }
}

extern(C)
private void handleScroll(GLFWwindow* window, double xoff, double yoff) nothrow {
    RawWindow w = cast(RawWindow)glfwGetWindowUserPointer(window);
    if (w && w._scrollDg) {
        try { w._scrollDg(xoff, yoff); }
        catch(Exception) {}
    }
}


// window event types
alias CloseDg = void delegate ();
alias ResizeDg = void delegate (Size size);
alias FbResizeDg = void delegate (Size size);
alias IconifyDg = void delegate (Flag!"iconified" inconified);
alias FocusDg = void delegate (Flag!"focused" focused);

// input event types
alias KeyDg = void delegate (int key, int scancode, int action, int mods);
alias CharDg = void delegate (uint codepoint);
alias CursorPosDg = void delegate (double xpos, double ypos);
alias CursorEnterDg = void delegate (Flag!"enter" enter);
alias MouseButtonDg = void delegate (int button, int action, int mods);
alias ScrollDg = void delegate (double xoffset, double yoffset);


class RawWindow : RefCounted {
    mixin(rcCode);

    private GLFWwindow *_window;
    private Rc!GlDevice _device;

    private CloseDg _closeDg;
    private ResizeDg _resizeDg;
    private FbResizeDg _fbResizeDg;
    private IconifyDg _iconifyDg;
    private FocusDg _focusDg;

    private KeyDg _keyDg;
    private CharDg _charDg;
    private CursorPosDg _cursorPosDg;
    private CursorEnterDg _cursorEnterDg;
    private MouseButtonDg _mouseButtonDg;
    private ScrollDg _scrollDg;

    /// constructor without depth/stencil buffer
    this(string title, Size size, ubyte samples, SurfaceType colorSurf)
    {
        setupGlContext();
        setupColor(colorSurf);
        glfwWindowHint(GLFW_DEPTH_BITS, 0);
        glfwWindowHint(GLFW_STENCIL_BITS, 0);
        setupMisc(samples);
        setupWindow(title, size);
    }

    /// constructor with a depth and/or stencil buffer
    this(string title, Size size, ubyte samples,
            SurfaceType colorSurf, SurfaceType dsSurf)
    {
        setupGlContext();
        setupColor(colorSurf);
        setupDs(dsSurf);
        setupMisc(samples);
        setupWindow(title, size);
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
    }

    private void setupDs(SurfaceType dsSurf) {
        assert(isDepthOrStencil(dsSurf));
        glfwWindowHint(GLFW_DEPTH_BITS, dsSurf.depthBits);
        glfwWindowHint(GLFW_STENCIL_BITS, dsSurf.stencilBits);
    }

    private void setupMisc(ubyte samples) {
        glfwWindowHint(GLFW_SAMPLES,        samples);
        glfwWindowHint(GLFW_DOUBLEBUFFER,   1);
    }

    private void setupWindow(string title, Size size) {
        import std.exception : enforce;
        import std.string : toStringz;

        _window = glfwCreateWindow(size.w, size.h, toStringz(title), null, null);
        enforce(_window);
        glfwSetWindowUserPointer(_window, cast(void*)this);

        makeCurrent();
        glfwSwapInterval(1);

        shared static bool reloaded = false;
        if (!reloaded) {
            DerelictGL3.reload();
            reloaded = true;
        }

        _device = new GlDevice();
    }


    void dispose() {
        _device.unload();
    }

    final @property inout(GLFWwindow)* glfwWindow() inout nothrow {
        return _window;
    }

    final @property inout(Device) device() inout { return _device.obj; }


    final @property void onClose(CloseDg dg) nothrow {
        _closeDg = dg;
    }
    final @property void onResize(ResizeDg dg) nothrow {
        glfwSetWindowSizeCallback(_window, &handleSize);
        _resizeDg = dg;
    }
    final @property void onFbResize(ResizeDg dg) nothrow {
        glfwSetFramebufferSizeCallback(_window, &handleFbSize);
        _fbResizeDg = dg;
    }
    final @property void onIconify(IconifyDg dg) nothrow {
        glfwSetWindowIconifyCallback(_window, &handleIconify);
        _iconifyDg = dg;
    }
    final @property void onFocus(FocusDg dg) nothrow {
        glfwSetWindowFocusCallback(_window, &handleFocus);
        _focusDg = dg;
    }

    final @property void onKey(KeyDg dg) nothrow {
        glfwSetKeyCallback(_window, &handleKey);
        _keyDg = dg;
    }
    final @property void onChar(CharDg dg) nothrow {
        glfwSetCharCallback(_window, &handleChar);
        _charDg = dg;
    }
    final @property void onCursorPos(CursorPosDg dg) nothrow {
        glfwSetCursorPosCallback(_window, &handleCursorPos);
        _cursorPosDg = dg;
    }
    final @property void onCursorEnter(CursorEnterDg dg) nothrow {
        glfwSetCursorEnterCallback(_window, &handleCursorEnter);
        _cursorEnterDg = dg;
    }
    final @property void onMouseButton(MouseButtonDg dg) nothrow {
        glfwSetMouseButtonCallback(_window, &handleMouseButton);
        _mouseButtonDg = dg;
    }
    final @property void onScroll(ScrollDg dg) nothrow {
        glfwSetScrollCallback(_window, &handleScroll);
        _scrollDg = dg;
    }


    final @property bool visible() const nothrow {
        return glfwGetWindowAttrib(cast(GLFWwindow*)_window, GLFW_VISIBLE) != 0;
    }

    final @property void visible(in bool visible) nothrow {
        if (visible) {
            glfwShowWindow(_window);
        }
        else {
            glfwHideWindow(_window);
        }
    }

    final @property bool iconified() const nothrow {
        return glfwGetWindowAttrib(cast(GLFWwindow*)_window, GLFW_ICONIFIED) != 0;
    }

    final @property void iconified(in bool iconified) nothrow {
        if (iconified) {
            glfwIconifyWindow(_window);
        }
        else {
            glfwRestoreWindow(_window);
        }
    }

    final @property bool maximized() const nothrow {
        return glfwGetWindowAttrib(cast(GLFWwindow*)_window, GLFW_MAXIMIZED) != 0;
    }

    final void maximize() nothrow {
        glfwMaximizeWindow(_window);
    }


    final @property bool focused() const nothrow {
        return glfwGetWindowAttrib(cast(GLFWwindow*)_window, GLFW_FOCUSED) != 0;
    }

    final void focus() nothrow {
        glfwFocusWindow(_window);
    }


    final @property Size size() const {
        int w =void;
        int h =void;
        glfwGetFramebufferSize(cast(GLFWwindow*)_window, &w, &h);
        return Size(cast(ushort)w, cast(ushort)h);
    }


    final @property bool shouldClose() const nothrow {
        return cast(bool)glfwWindowShouldClose(cast(GLFWwindow*)_window);
    }

    final @property void shouldClose(bool val) nothrow {
        glfwSetWindowShouldClose(_window, val);
    }

    void pollEvents() nothrow {
        glfwPollEvents();
    }

    final void makeCurrent() nothrow {
        glfwMakeContextCurrent(_window);
    }

    final void doneCurrent() nothrow {
        glfwMakeContextCurrent(null);
    }

    /// swap front and back buffer
    final void swapBuffers() nothrow {
        glfwSwapBuffers(_window);
    }
}


class Window(Col, DepSten...) : RawWindow if (allSatisfy!(hasDepthOrStencilSurface, DepSten)) {

    import gfx.pipeline.format : hasRenderSurface;

    this(string title, ushort width, ushort height, ubyte samples=0) {
        this(title, Size(width, height), samples);
    }

    this(string title, Size size, ubyte samples=0) {
        import gfx.pipeline.format : format;
        import gfx.pipeline.surface : BuiltinSurface;

        immutable colF = format!Col;
        static if (DepSten.length == 0) {
            super(title, size, samples, colF.surface);
        }
        else static if (DepSten.length == 1) {
            immutable dsF = format!(DepSten[0]);
            super(title, size, samples, colF.surface, dsF.surface);
        }
        else {
            static assert(false, "supplied to many buffer configurations");
        }

        _colorSurface = new BuiltinSurface!Col(device.builtinSurface, size, samples);
        static if (DepSten.length == 1) {
            _depthStencilSurface = new BuiltinSurface!(DepSten[0])(device.builtinSurface, size, samples);
        }
    }

    override void dispose() {
        _colorSurface.unload();
        static if (DepSten.length == 1) {
            _depthStencilSurface.unload();
        }
        else static if (DepSten.length == 2) {
            _depthSurface.unload();
            _stencilSurface.unload();
        }
        super.dispose();
    }

    static assert(hasRenderSurface!Col, Col.stringof~" is not a valid color format");

    private Rc!(Surface!Col) _colorSurface;

    final public @property Surface!Col colorSurface() {
        return _colorSurface.obj;
    }


    static if (DepSten.length == 1) {

        static assert (hasDepthOrStencilSurface!(DepSten[0]));

        private Rc!(Surface!(DepSten[0])) _depthStencilSurface;

        final public @property Surface!(DepSten[0]) depthStencilSurface() {
            return _depthStencilSurface.obj;
        }

    }

}



auto gfxGlfwWindow(Col, DepSten...)(string title, ushort width, ushort height, ubyte samples=0)
{
    return new Window!(Col, DepSten)(title, width, height, samples);
}
