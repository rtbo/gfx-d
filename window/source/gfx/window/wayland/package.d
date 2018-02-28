/// wayland window impl
module gfx.window.wayland;

version(linux):

import gfx.graal : Instance;
import gfx.graal.presentation;
import gfx.vulkan.wsi;
import gfx.window;
import gfx.window.wayland.zxdg_shell_v6;

import wayland.client;
import wayland.native.util;
import wayland.util;

// FIXME: multithreading


class WaylandDisplay : Display
{
    import gfx.core.rc : atomicRcCode, Rc;
    mixin(atomicRcCode);

    private WlDisplay display;
    private WlCompositor compositor;
    private WlSeat seat;
    private WlPointer pointer;
    private WlKeyboard kbd;

    private WlShell wlShell;
    private ZxdgShellV6 xdgShell;

    private Rc!Instance _instance;

    private WaylandWindowBase[] wldWindows;
    private WaylandWindowBase pointedWindow;
    private WaylandWindowBase focusWindow;
    private Window[] _windows;

    this() {
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
            else if (iface == ZxdgShellV6.iface.name)
            {
                xdgShell = cast(ZxdgShellV6)reg.bind(
                    name, ZxdgShellV6.iface, min(ver, 1)
                );
                xdgShell.onPing = (ZxdgShellV6 shell, uint serial) {
                    shell.pong(serial);
                };
            }
        };
        display.roundtrip();
        reg.destroy();
    }

    override @property Instance instance() {
        return _instance;
    }

    override @property Window[] windows() {
        return _windows;
    }

    override Window createWindow() {
        if (xdgShell) {
            auto w = new XdgWaylandWindow(this, _instance, xdgShell);
            wldWindows ~= w;
            _windows ~= w;
            return w;
        }
        else if (wlShell) {
            auto w = new WaylandWindow(this, _instance, wlShell);
            wldWindows ~= w;
            _windows ~= w;
            return w;
        }
        else {
            return null;
        }
    }

    override void pollAndDispatch() {
        while (display.prepareRead() != 0) {
            display.dispatchPending();
        }
        display.flush();
        display.readEvents();
        display.dispatchPending();
    }


    package void unrefWindow(WaylandWindowBase window) {
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
                w.pointerEnter(surfaceX, surfaceY);
                break;
            }
        }
    }

    private void pointerButton(WlPointer, uint serial, uint time, uint button,
                        WlPointer.ButtonState state)
    {
        if (pointedWindow) {
            pointedWindow.pointerButton(state);
            focusWindow = pointedWindow;
        }
    }

    private void pointerMotion(WlPointer, uint, WlFixed surfaceX, WlFixed surfaceY)
    {
        if (pointedWindow) {
            pointedWindow.pointerMotion(surfaceX, surfaceY);
        }
    }

    private void pointerLeave(WlPointer pointer, uint serial, WlSurface surface)
    {
        if (pointedWindow && pointedWindow.wlSurface is surface) {
            pointedWindow.pointerLeave();
            pointedWindow = null;
        }
        else {
            foreach (w; wldWindows) {
                if (w.wlSurface is surface) {
                    w.pointerLeave();
                    break;
                }
            }
        }
    }

    private void kbdKey(WlKeyboard keyboard, uint serial, uint time, uint key,
            WlKeyboard.KeyState state)
    {
        if (focusWindow) {
            focusWindow.key(key, state);
        }
        else if (wldWindows.length) {
            wldWindows[0].key(key, state);
        }
    }


    override void dispose()
    {
        if (wldWindows.length) {
            auto ws = wldWindows.dup;
            foreach (w; ws) w.close();
        }
        assert(!wldWindows.length);
        assert(!_windows.length);

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
        display.disconnect();
        display = null;
    }
}

private abstract class WaylandWindowBase : Window
{
    this(WaylandDisplay display, Instance instance)
    {
        this.dpy = display;
        this.instance = instance;
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
    }

    abstract protected void closeShell();

    override @property void mouseMove(MouseHandler handler) {
        moveHandler = handler;
    }
    override @property void mouseOn(MouseHandler handler) {
        onHandler = handler;
    }
    override @property void mouseOff(MouseHandler handler) {
        offHandler = handler;
    }
    override @property void keyOn(KeyHandler handler) {
        keyOnHandler = handler;
    }
    override @property void keyOff(KeyHandler handler) {
        keyOffHandler = handler;
    }

    override @property Surface surface() {
        return gfxSurface;
    }

    private void pointerButton(WlPointer.ButtonState state) {
        switch (state) {
        case WlPointer.ButtonState.pressed:
            if (onHandler) onHandler(cast(int)curX, cast(int)curY);
            break;
        case WlPointer.ButtonState.released:
            if (offHandler) offHandler(cast(int)curX, cast(int)curY);
            break;
        default:
            break;
        }
    }

    private void pointerMotion(WlFixed x, WlFixed y) {
        curX = x; curY = y;
        if (moveHandler) {
            moveHandler(cast(int)x, cast(int)y);
        }
    }


    private void pointerEnter(WlFixed x, WlFixed y) {
        curX = x; curY = y;
    }

    private void pointerLeave() {}

    private void key(uint key, WlKeyboard.KeyState state) {
        switch (state) {
        case WlKeyboard.KeyState.pressed:
            if (keyOnHandler) keyOnHandler(key);
            break;
        case WlKeyboard.KeyState.released:
            if (keyOffHandler) keyOffHandler(key);
            break;
        default:
            break;
        }
    }

    private WaylandDisplay dpy;
    private Instance instance;

    private WlSurface wlSurface;
    private Surface gfxSurface;

    private MouseHandler moveHandler;
    private MouseHandler onHandler;
    private MouseHandler offHandler;
    private KeyHandler keyOnHandler;
    private KeyHandler keyOffHandler;
    private WlFixed curX;
    private WlFixed curY;
}

private class WaylandWindow : WaylandWindowBase
{
    this (WaylandDisplay display, Instance instance, WlShell wlShell) {
        super(display, instance);
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
    }

    override protected void closeShell() {
        wlShellSurf.destroy();
    }

    private WlShell wlShell;
    private WlShellSurface wlShellSurf;
}

private class XdgWaylandWindow : WaylandWindowBase
{
    this (WaylandDisplay display, Instance instance, ZxdgShellV6 xdgShell)
    {
        super(display, instance);
        this.xdgShell = xdgShell;
    }

    override protected void prepareShell(WlSurface wlSurf)
    {
        xdgSurf = xdgShell.getXdgSurface(wlSurf);
        xdgTopLevel = xdgSurf.getToplevel();

		xdgTopLevel.onConfigure = &onTLConfigure;
		xdgTopLevel.onClose = &onTLClose;
		xdgTopLevel.setTitle("Gfx-d Wayland window");

		xdgSurf.onConfigure = (ZxdgSurfaceV6 surf, uint serial)
		{
			surf.ackConfigure(serial);
			configured = true;
		};
    }

  	void onTLConfigure(ZxdgToplevelV6, int width, int height, wl_array* states)
	{
	}

	void onTLClose(ZxdgToplevelV6)
	{
	}

    override protected void closeShell() {
        xdgTopLevel.destroy();
        xdgSurf.destroy();
    }

    private bool configured;
    private ZxdgShellV6 xdgShell;
    private ZxdgSurfaceV6 xdgSurf;
    private ZxdgToplevelV6 xdgTopLevel;
}
