/// wayland window impl
module gfx.window.wayland;

version(linux):

import gfx.core.log : LogTag;
import gfx.graal : Instance;
import gfx.graal.presentation;
import gfx.vulkan.wsi;
import gfx.window;
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

    private WlCursorTheme cursorTheme;
    private WlCursor[string] cursors;
    private WlSurface cursorSurf;

    private WlShell wlShell;
    private XdgWmBase xdgShell;

    private Rc!Instance _instance;

    private WaylandWindowBase[] wldWindows;
    private WaylandWindowBase pointedWindow;
    private WaylandWindowBase focusWindow;
    private Window[] _windows;

    this()
    {
        import std.exception : enforce;

        {
            // Only vulkan is supported. Let failure throw it.
            import gfx.vulkan : createVulkanInstance, vulkanInit;
            vulkanInit();
            _instance = createVulkanInstance();
        }

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
        if (window is focusWindow) focusWindow = null;
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
            kbd.onKey = &kbdKey;
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
            pointedWindow.pointerButton(state, serial);
            focusWindow = pointedWindow;
        }
    }

    private void pointerMotion(WlPointer, uint serial, WlFixed surfaceX, WlFixed surfaceY)
    {
        if (pointedWindow) {
            pointedWindow.pointerMotion(surfaceX, surfaceY, serial);
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

    private void kbdKey(WlKeyboard keyboard, uint serial, uint time, uint key,
            WlKeyboard.KeyState state)
    {
        if (focusWindow) {
            focusWindow.key(key, state, serial);
        }
        else if (wldWindows.length) {
            wldWindows[0].key(key, state, serial);
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

    private void pointerButton(WlPointer.ButtonState state, uint serial)
    {
        switch (state) {
        case WlPointer.ButtonState.pressed:
            const side = checkResizeArea();
            if (side != Side.none) {
                startResize(side, serial);
            }
            else {
                if (onHandler) onHandler(cast(int)curX, cast(int)curY);
            }
            break;
        case WlPointer.ButtonState.released:
            if (offHandler) offHandler(cast(int)curX, cast(int)curY);
            break;
        default:
            break;
        }
    }

    private void pointerMotion(WlFixed x, WlFixed y, uint serial)
    {
        curX = x; curY = y;

        const side = checkResizeArea();
        if (side != currentSide) {
            dpy.setCursor(side.sideToCursor(), serial);
            currentSide = side;
        }
        if (moveHandler) {
            moveHandler(cast(int)x, cast(int)y);
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

    private void key(uint key, WlKeyboard.KeyState state, uint serial)
    {
        switch (state) {
        case WlKeyboard.KeyState.pressed:
            if (onKeyOnHandler) onKeyOnHandler(key);
            break;
        case WlKeyboard.KeyState.released:
            if (onKeyOffHandler) onKeyOffHandler(key);
            break;
        default:
            break;
        }
    }

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
