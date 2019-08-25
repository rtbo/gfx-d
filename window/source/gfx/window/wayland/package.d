/// wayland window impl
module gfx.window.wayland;

version(linux):

import gfx.core.log : LogTag;
import gfx.graal : Backend, Instance;
import gfx.graal.presentation;
import gfx.vulkan.wsi;
import gfx.window;
import gfx.window.keys;
import gfx.window.xkeyboard;
import gfx.window.wayland.xdg_shell;

import wayland.client;
import wayland.cursor;
import wayland.native.util;
import wayland.util;

enum gfxWlLogMask = 0x0800_0000;
package immutable gfxWlLog = LogTag("GFX-WL", gfxWlLogMask);

class WaylandDisplay : Display
{
    import gfx.core.rc : atomicRcCode, Rc;
    mixin(atomicRcCode);

    private WlDisplay display;
    private WlCompositor compositor;
    private WlShm shm;
    private WlSeat seat;
    private WlPointer pointer;
    private WlKeyboard kbd;
    private XKeyboard xkb;

    private WlCursorTheme cursorTheme;
    private WlCursor[string] cursors;
    private WlSurface cursorSurf;

    private WlShell wlShell;
    private XdgWmBase xdgShell;

    private Rc!Instance _instance;

    private WaylandWindowBase[] wldWindows;
    private WaylandWindowBase pointedWindow;
    private WaylandWindowBase kbdFocus;
    private Window[] _windows;

    this(DisplayCreateInfo createInfo)
    {
        import std.exception : enforce;

        {
            // Only vulkan is supported.
            import gfx.vulkan : createVulkanInstance, debugReportInstanceExtensions,
                    lunarGValidationLayers, VulkanCreateInfo, vulkanInit;
            import gfx.vulkan.wsi : waylandSurfaceInstanceExtensions;

            foreach (b; createInfo.backendCreateOrder) {
                if (b != Backend.vulkan) {
                    gfxWlLog.warningf("Backend %s is not supported with Wayland.");
                    continue;
                }
                vulkanInit();
                VulkanCreateInfo vci;
                vci.mandatoryExtensions = waylandSurfaceInstanceExtensions;
                vci.optionalExtensions = createInfo.debugCallbackEnabled ?
                        debugReportInstanceExtensions : [];
                vci.optionalLayers = createInfo.validationEnabled ?
                        lunarGValidationLayers : [];
                _instance = createVulkanInstance(vci);
                break;
            }
        }

        gfxWlLog.info("Opening Wayland display");

        display = WlDisplay.connect();
        auto reg = display.getRegistry();
        reg.onGlobal = (WlRegistry reg, uint name, string iface, uint ver) {
            import std.algorithm : min;
            if(iface == WlCompositor.iface.name)
            {
                compositor = cast(WlCompositor)reg.bind(
                    name, WlCompositor.iface, min(ver, 4)
                );
            }
            else if (iface == WlShm.iface.name)
            {
                shm = cast(WlShm)reg.bind(
                    name, WlShm.iface, min(ver, 1)
                );
                cursorTheme = enforce(
                    WlCursorTheme.load(null, 24, shm),
                    "Unable to load default cursor theme"
                );
                const cursorIds = [
                    "default", "n-resize", "ne-resize", "e-resize", "se-resize",
                    "s-resize", "sw-resize", "w-resize", "nw-resize"
                ];
                foreach (cid; cursorIds) {
                    cursors[cid] = enforce(
                        cursorTheme.cursor(cid), "Unable to load "~cid~" from the default cursor theme"
                    );
                }
            }
            else if(iface == WlSeat.iface.name)
            {
                seat = cast(WlSeat)reg.bind(
                    name, WlSeat.iface, min(ver, 2)
                );
                seat.onCapabilities = &seatCapChanged;
            }
            else if(iface == WlShell.iface.name)
            {
                wlShell = cast(WlShell)reg.bind(
                    name, WlShell.iface, min(ver, 1)
                );
            }
            else if (iface == XdgWmBase.iface.name)
            {
                xdgShell = cast(XdgWmBase)reg.bind(
                    name, XdgWmBase.iface, min(ver, 1)
                );
                xdgShell.onPing = (XdgWmBase shell, uint serial) {
                    shell.pong(serial);
                };
            }
        };
        display.roundtrip();
        reg.destroy();
        cursorSurf = compositor.createSurface();
    }

    override @property Instance instance()
    {
        return _instance;
    }

    override @property Window[] windows()
    {
        return _windows;
    }

    override Window createWindow(in string title)
    {
        if (xdgShell) {
            auto w = new XdgWaylandWindow(this, _instance, xdgShell, title);
            wldWindows ~= w;
            _windows ~= w;
            return w;
        }
        else if (wlShell) {
            auto w = new WaylandWindow(this, _instance, wlShell, title);
            wldWindows ~= w;
            _windows ~= w;
            return w;
        }
        throw new Exception("No shell available. Can't create any Wayland window.");
    }

    override void pollAndDispatch()
    {
        while (display.prepareRead() != 0) {
            display.dispatchPending();
        }
        display.flush();
        display.readEvents();
        display.dispatchPending();
    }

    package void unrefWindow(WaylandWindowBase window)
    {
        import std.algorithm : remove;
        wldWindows = wldWindows.remove!(w => w is window);
        _windows = _windows.remove!(w => w is window);
        if (window is pointedWindow) pointedWindow = null;
        if (window is kbdFocus) kbdFocus = null;
    }

    private void seatCapChanged (WlSeat seat, WlSeat.Capability cap)
    {
        if ((cap & WlSeat.Capability.pointer) && !pointer)
        {
            pointer = seat.getPointer();
            pointer.onEnter = &pointerEnter;
            pointer.onButton = &pointerButton;
            pointer.onMotion = &pointerMotion;
            pointer.onLeave = &pointerLeave;
        }
        else if (!(cap & WlSeat.Capability.pointer) && pointer)
        {
            pointer.destroy();
            pointer = null;
        }

        if ((cap & WlSeat.Capability.keyboard) && !kbd)
        {
            kbd = seat.getKeyboard();
            kbd.onKeymap = &kbdKeymap;
            kbd.onEnter = &kbdEnter;
            kbd.onLeave = &kbdLeave;
            kbd.onKey = &kbdKey;
            kbd.onModifiers = &kbdModifiers;
        }
        else if (!(cap & WlSeat.Capability.keyboard) && kbd)
        {
            kbd.destroy();
            kbd = null;
        }
    }

    private void pointerEnter(WlPointer pointer, uint serial, WlSurface surface,
                        WlFixed surfaceX, WlFixed surfaceY)
    {
        foreach (w; wldWindows) {
            if (w.wlSurface is surface) {
                pointedWindow = w;
                w.pointerEnter(surfaceX, surfaceY, serial);
                break;
            }
        }
    }

    private void pointerButton(WlPointer, uint serial, uint time, uint button,
                        WlPointer.ButtonState state)
    {
        if (pointedWindow) {
            pointedWindow.pointerButton(state, serial, xkb ? xkb.mods : KeyMods.init);
        }
    }

    private void pointerMotion(WlPointer, uint serial, WlFixed surfaceX, WlFixed surfaceY)
    {
        if (pointedWindow) {
            pointedWindow.pointerMotion(surfaceX, surfaceY, serial, xkb ? xkb.mods : KeyMods.init);
        }
    }

    private void pointerLeave(WlPointer pointer, uint serial, WlSurface surface)
    {
        if (pointedWindow && pointedWindow.wlSurface is surface) {
            pointedWindow.pointerLeave(serial);
            pointedWindow = null;
        }
        else {
            foreach (w; wldWindows) {
                if (w.wlSurface is surface) {
                    w.pointerLeave(serial);
                    break;
                }
            }
        }
    }

    private void kbdKeymap(WlKeyboard, WlKeyboard.KeymapFormat format, int fd, uint size)
    {
        import std.exception : enforce;

        enforce(format == WlKeyboard.KeymapFormat.xkbV1, "Unsupported wayland keymap format");

        if (xkb) xkb.dispose();
        xkb = new WaylandKeyboard(fd, size);
    }

    private void kbdEnter(WlKeyboard, uint serial, WlSurface surf, wl_array* keys)
    {
        foreach (w; wldWindows) {
            if (w.wlSurface is surf) {
                kbdFocus = w;
                break;
            }
        }
    }

    private void kbdLeave(WlKeyboard, uint serial, WlSurface surf)
    {
        if (kbdFocus && kbdFocus.wlSurface !is surf) {
            gfxWlLog.warningf("Leaving window that was not entered");
        }
        kbdFocus = null;
    }

    private void kbdModifiers(WlKeyboard, uint serial, uint modsDepressed,
                              uint modsLatched, uint modsLocked, uint group)
    {
        if (xkb) {
            xkb.updateState(modsDepressed, modsLatched, modsLocked, 0, 0, group);
        }
    }

    private void kbdKey(WlKeyboard, uint serial, uint time, uint key,
                        WlKeyboard.KeyState state)
    {
        if (xkb) {
            WaylandWindowBase w = kbdFocus;
            if (!w && wldWindows.length) w = wldWindows[0];

            switch (state) {
            case WlKeyboard.KeyState.pressed:
                xkb.processKeyDown(key+8, kbdFocus ? kbdFocus.onKeyOnHandler : null);
                break;
            case WlKeyboard.KeyState.released:
                xkb.processKeyUp(key+8, kbdFocus ? kbdFocus.onKeyOffHandler : null);
                break;
            default:
                break;
            }
        }
    }

    private void setCursor(string cursorId, uint serial)
    {
        auto cursor = cursors[cursorId];
        if (cursor.images.length > 1) {
            gfxWlLog.warning("animated cursors are not supported, only showing first frame");
        }
        auto img = cursor.images[0];
        auto buf = img.buffer;
        if (!buf) return;
        pointer.setCursor(serial, cursorSurf, img.hotspotX, img.hotspotY);
        cursorSurf.attach(buf, 0, 0);
        cursorSurf.damage(0, 0, img.width, img.height);
        cursorSurf.commit();
    }

    override void dispose()
    {
        if (wldWindows.length) {
            auto ws = wldWindows.dup;
            foreach (w; ws) w.close();
        }
        assert(!wldWindows.length);
        assert(!_windows.length);

        cursors = null;
        if (cursorTheme) {
            cursorTheme.destroy();
            cursorTheme = null;
        }
        if (cursorSurf) {
            cursorSurf.destroy();
            cursorSurf = null;
        }
        if (xkb) {
            xkb.dispose();
            xkb = null;
        }
        if (kbd) {
            kbd.destroy();
            kbd = null;
        }
        if (pointer) {
            pointer.destroy();
            pointer = null;
        }
        if (seat) {
            seat.destroy();
            seat = null;
        }
        if (wlShell) {
            wlShell.destroy();
            wlShell = null;
        }
        if (compositor) {
            compositor.destroy();
            compositor = null;
        }
        _instance.unload();
        display.disconnect();
        display = null;
    }
}

private class WaylandKeyboard : XKeyboard
{
    this (int fd, uint size)
    {
        import core.sys.posix.sys.mman;
        import core.sys.posix.unistd : close;
        import std.exception : enforce;
        import xkbcommon.xkbcommon;

        void* buf = mmap(null, size, PROT_READ, MAP_SHARED, fd, 0);
        enforce(buf != MAP_FAILED, "Could not mmap the wayland keymap");
        scope(exit) {
            munmap(buf, size);
            close(fd);
        }

        auto ctx = enforce(
            xkb_context_new(XKB_CONTEXT_NO_FLAGS), "Could not alloc XKB context"
        );
        scope(failure) xkb_context_unref(ctx);

        auto keymap = enforce(
            xkb_keymap_new_from_buffer(
                ctx, cast(char*)buf, size-1,
                XKB_KEYMAP_FORMAT_TEXT_V1, XKB_KEYMAP_COMPILE_NO_FLAGS
            ),
            "Could not read keymap from mmapped file"
        );
        scope(failure) xkb_keymap_unref(keymap);

        auto state = xkb_state_new(keymap);

        super(ctx, keymap, state);
    }

}

private alias Side = XdgToplevel.ResizeEdge;

private string sideToCursor(Side side)
{
    final switch (side)
    {
    case Side.none:         return "default";
    case Side.top:          return "n-resize";
    case Side.bottom:       return "s-resize";
    case Side.left:         return "w-resize";
    case Side.right:        return "e-resize";
    case Side.topLeft:      return "nw-resize";
    case Side.topRight:     return "ne-resize";
    case Side.bottomLeft:   return "sw-resize";
    case Side.bottomRight:  return "se-resize";
    }
}


private abstract class WaylandWindowBase : Window
{
    this(WaylandDisplay display, Instance instance, string title)
    {
        this.dpy = display;
        this.instance = instance;
        this._title = title;
    }

    override @property string title()
    {
        return _title;
    }

    override void setTitle(in string title)
    {
        _title = title;
    }

    override void close() {
        closeShell();
        wlSurface.destroy();
        wlSurface = null;
        dpy.unrefWindow(this);
    }

    abstract protected void prepareShell(WlSurface wlSurf);

    override void show (uint width, uint height)
    {
        import std.exception : enforce;

        wlSurface = dpy.compositor.createSurface();
        prepareShell(wlSurface);
        gfxSurface = enforce(
            createVulkanWaylandSurface(instance, dpy.display, wlSurface),
            "Could ont create a Vulkan surface"
        );
        wlSurface.commit();
        this.width = width;
        this.height = height;
    }

    abstract protected void closeShell();

    override @property void onResize(ResizeHandler handler) {
        resizeHandler = handler;
    }
    override @property void onMouseMove(MouseHandler handler) {
        moveHandler = handler;
    }
    override @property void onMouseOn(MouseHandler handler) {
        onHandler = handler;
    }
    override @property void onMouseOff(MouseHandler handler) {
        offHandler = handler;
    }
    override @property void onKeyOn(KeyHandler handler) {
        onKeyOnHandler = handler;
    }
    override @property void onKeyOff(KeyHandler handler) {
        onKeyOffHandler = handler;
    }
    override @property void onClose(CloseHandler handler) {
        onCloseHandler = handler;
    }

    override @property Surface surface() {
        return gfxSurface;
    }

    override @property bool closeFlag() const {
        return _closeFlag;
    }

    override @property void closeFlag(in bool flag) {
        _closeFlag = flag;
    }

    private void pointerButton(WlPointer.ButtonState state, uint serial, KeyMods mods)
    {
        const ev = MouseEvent (cast(int)curX, cast(int)curY, mods);

        switch (state) {
        case WlPointer.ButtonState.pressed:
            const side = checkResizeArea();
            if (side != Side.none) {
                startResize(side, serial);
            }
            else {
                if (onHandler) onHandler(ev);
            }
            break;
        case WlPointer.ButtonState.released:
            if (offHandler) offHandler(ev);
            break;
        default:
            break;
        }
    }

    private void pointerMotion(WlFixed x, WlFixed y, uint serial, KeyMods mods)
    {
        curX = x; curY = y;

        const side = checkResizeArea();
        if (side != currentSide) {
            dpy.setCursor(side.sideToCursor(), serial);
            currentSide = side;
        }
        if (moveHandler) {
            auto ev = MouseEvent(cast(int)x, cast(int)y, mods);
            moveHandler(ev);
        }
    }


    private void pointerEnter(WlFixed x, WlFixed y, uint serial)
    {
        curX = x; curY = y;
        const side = checkResizeArea();
        dpy.setCursor(side.sideToCursor(), serial);
        currentSide = side;
    }

    private void pointerLeave(uint serial)
    {}

    protected abstract void startResize(Side side, uint serial);

    private Side checkResizeArea()
    {
        const x = cast(int)curX;
        const y = cast(int)curY;

        Side side = Side.none;

        if (x <= resizeMargin) side |= Side.left;
        else if (x >= width - resizeMargin) side |= Side.right;

        if (y <= resizeMargin) side |= Side.top;
        else if (y >= height - resizeMargin) side |= Side.bottom;

        return side;
    }

    private WaylandDisplay dpy;
    private Instance instance;
    private WlSurface wlSurface;
    private Surface gfxSurface;

    // event handlers
    private ResizeHandler resizeHandler;
    private MouseHandler moveHandler;
    private MouseHandler onHandler;
    private MouseHandler offHandler;
    private KeyHandler onKeyOnHandler;
    private KeyHandler onKeyOffHandler;
    private CloseHandler onCloseHandler;

    // state handling
    private bool _closeFlag;
    private string _title;
    private WlFixed curX;
    private WlFixed curY;
    private uint width;
    private uint height;
    private Side currentSide;

    // parameters
    private enum resizeMargin = 5;
}

private class WaylandWindow : WaylandWindowBase
{
    this (WaylandDisplay display, Instance instance, WlShell wlShell, string title)
    {
        super(display, instance, title);
        this.wlShell = wlShell;
    }

    override protected void prepareShell(WlSurface wlSurf)
    {
        wlShellSurf = wlShell.getShellSurface(wlSurf);
        wlShellSurf.onPing = (WlShellSurface ss, uint serial)
        {
            ss.pong(serial);
        };

        wlShellSurf.setToplevel();
        wlShellSurf.onConfigure = &onConfigure;
    }

    override protected void closeShell()
    {
        wlShellSurf.destroy();
    }

    override protected void startResize(Side side, uint serial)
    {
        wlShellSurf.resize(dpy.seat, serial, cast(WlShellSurface.Resize)side);
    }

    private void onConfigure(WlShellSurface, WlShellSurface.Resize, int width, int height)
    {
        if (resizeHandler) resizeHandler(width, height);
    }

    private WlShell wlShell;
    private WlShellSurface wlShellSurf;
}

private class XdgWaylandWindow : WaylandWindowBase
{
    this (WaylandDisplay display, Instance instance, XdgWmBase xdgShell, string title)
    {
        super(display, instance, title);
        this.xdgShell = xdgShell;
    }

    override protected void prepareShell(WlSurface wlSurf)
    {
        xdgSurf = xdgShell.getXdgSurface(wlSurf);
        xdgTopLevel = xdgSurf.getToplevel();

        xdgTopLevel.onConfigure = &onTLConfigure;
        xdgTopLevel.onClose = &onTLClose;
        xdgTopLevel.setTitle(title);

        xdgSurf.onConfigure = (XdgSurface xdgSurf, uint serial)
        {
            xdgSurf.ackConfigure(serial);
        };
    }

    override void setTitle(in string title)
    {
        _title = title;
        if (xdgTopLevel) xdgTopLevel.setTitle(title);
    }

      void onTLConfigure(XdgToplevel, int width, int height, wl_array* states)
    {
        if (width != 0) {
            this.width = width;
        }
        if (height != 0) {
            this.height = height;
        }
        if (resizeHandler) resizeHandler(this.width, this.height);
    }

    void onTLClose(XdgToplevel)
    {
        if (onCloseHandler) {
            _closeFlag = onCloseHandler();
        }
        else {
            _closeFlag = true;
        }
    }

    override protected void closeShell()
    {
        xdgTopLevel.destroy();
        xdgSurf.destroy();
    }

    override protected void startResize(Side side, uint serial)
    {
        xdgTopLevel.resize(dpy.seat, serial, cast(uint)side);
    }

    private bool configured;
    private bool geometrySet;
    private XdgWmBase xdgShell;
    private XdgSurface xdgSurf;
    private XdgToplevel xdgTopLevel;
}
