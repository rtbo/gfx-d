/// Optional window package, mainly to run gfx-d examples
module gfx.window;

import gfx.core.rc : IAtomicRefCounted;
import gfx.core.log : LogTag;
import gfx.graal : Backend, Instance;
public import gfx.window.keys;

import std.typecons : Flag, No, Yes;

enum gfxWindowLogMask = 0x0800_0000;
package immutable gfxWindowLog = LogTag("GFX-WINDOW", gfxWindowLogMask);

struct KeyEvent
{
    KeySym sym;
    KeyCode code;
    KeyMods mods;
    string text;
}

struct MouseEvent
{
    uint x;
    uint y;
    KeyMods mods;
}

alias MouseHandler = void delegate(MouseEvent ev);
alias KeyHandler = void delegate(KeyEvent ev);
alias ResizeHandler = void delegate(uint width, uint height);
alias CloseHandler = bool delegate();

interface Display : IAtomicRefCounted
{
    @property Instance instance();
    @property Window[] windows();
    Window createWindow(string title = "Gfx-d Window");
    void pollAndDispatch();
}

interface Window
{
    import gfx.graal.presentation : Surface;

    void show(uint width, uint height);
    void close();

    @property string title();
    void setTitle(string title);

    @property Surface surface();
    @property bool closeFlag() const;
    @property void closeFlag(in bool flag);

    @property void onResize(ResizeHandler handler);
    @property void onMouseMove(MouseHandler handler);
    @property void onMouseOn(MouseHandler handler);
    @property void onMouseOff(MouseHandler handler);
    @property void onKeyOn(KeyHandler handler);
    @property void onKeyOff(KeyHandler handler);
    @property void onClose(CloseHandler handler);
}

version (linux)
{
    /// Identifier of the display to use on linux
    enum LinuxDisplay
    {
        /// Instantiate a wayland display
        /// (no Client Side Decorations at this point)
        wayland,
        /// Instantiate an XCB display (X windowing system)
        xcb,
    }
}

debug
{
    private enum defaultDebugCb = Yes.debugCallback;
    private enum defaultValidation = Yes.validation;
}
else
{
    private enum defaultDebugCb = No.debugCallback;
    private enum defaultValidation = No.validation;
}


/// Options that influence how the display is created, and how it will create
/// a Gfx-D instance.
struct DisplayCreateInfo
{
    /// Order into which backend creation is tried.
    /// The first successfully created backend is used.
    /// If empty, Vulkan is tried first, and OpenGL3 is tried as fallback if enabled and available
    Backend[] backendCreateOrder;

    version (linux)
    {
        /// Order into which display creation is tried on linux.
        /// The first successfully created display is used.
        /// If empty, Wayland will be tried if available and VkWayland enabled, and XCB will be used as fallback.
        LinuxDisplay[] linuxDisplayCreateOrder;
    }

    /// Whether DebugCallback should be available. Only meaningful with Vulkan backend.
    Flag!"debugCallback" debugCallbackEnabled = defaultDebugCb;
    /// Whether validation should be enabled. Only meaningful with Vulkan backend.
    Flag!"validation" validationEnabled = defaultValidation;
}

/// Create a display for the running platform.
/// The display will load a backend instance during startup.
/// It will try the backends in the provided loadOrder.
/// On linux, more than one display implementation are provided. You may
/// use linuxDisplayOrder to choose. The first succesfully created display is returned.
Display createDisplay(DisplayCreateInfo createInfo)
{
    if (createInfo.backendCreateOrder.length == 0)
    {
        version(GfxGl3)
            createInfo.backendCreateOrder = [Backend.vulkan, Backend.gl3];
        else
            createInfo.backendCreateOrder = [Backend.vulkan];
    }

    version (linux)
    {
        import gfx.window.xcb : XcbDisplay;
        import std.process : environment;

        auto order = createInfo.linuxDisplayCreateOrder;
        if (order.length == 0)
        {
            version (VkWayland) {
                order = environment["XDG_SESSION_TYPE"] == "wayland" ? [
                    LinuxDisplay.wayland, LinuxDisplay.xcb
                ] : [LinuxDisplay.xcb];
            }
            else {
                order = [LinuxDisplay.xcb];
            }
        }

        foreach (ld; order)
        {
            try
            {
                final switch (ld)
                {
                case LinuxDisplay.wayland:
                    version (VkWayland) {
                        import gfx.window.wayland : WaylandDisplay;

                        return new WaylandDisplay(createInfo);
                    }
                    else {
                        assert(false, "Wayland support is disabled");
                    }
                case LinuxDisplay.xcb:
                    return new XcbDisplay(createInfo);
                }
            }
            catch (Exception ex)
            {
                gfxWindowLog.warningf("Failed to create %s linux display:\n%s", ld, ex.msg);
            }
        }
        throw new Exception("Could not create a functional display");
    }
    else version (Windows)
    {
        import gfx.window.win32 : Win32Display;

        return new Win32Display(createInfo);
    }
    else
    {
        pragma(msg, "Unsupported platform");
        assert(false, "Unsupported platform");
    }
}
