/// wayland window impl
module gfx.window.wayland;

version(GfxVulkanWayland):

import gfx.graal : Instance;
import gfx.graal.image : Surface;
import gfx.vulkan.wsi;
import gfx.window;

import wayland.client;
import wayland.util;


class WaylandWindow : Window
{
    this() {
        refDisplay(this);
    }

    override void show (Instance instance, uint width, uint height) {
        wlSurface = dpy.compositor.createSurface();
		wlShellSurface = dpy.shell.getShellSurface(wlSurface);
		wlShellSurface.onPing = (WlShellSurface ss, uint serial)
		{
			ss.pong(serial);
		};

		wlShellSurface.setToplevel();

        gfxSurface = createVulkanWaylandSurface(instance, dpy.display, wlSurface);
    }

    override void close() {
        wlShellSurface.destroy();
        wlShellSurface = null;
        wlSurface.destroy();
        wlSurface = null;
        unrefDisplay(this);
    }

    override @property void mouseMove(MouseHandler handler) {
        moveHandler = handler;
    }
    override @property void mouseOn(MouseHandler handler) {
        onHandler = handler;
    }
    override @property void mouseOff(MouseHandler handler) {
        offHandler = handler;
    }

    override @property Surface surface() {
        return gfxSurface;
    }

    private void pointerButton(WlPointer, uint serial, uint time, uint button,
                        WlPointer.ButtonState state)
    {
        final switch (state) {
        case WlPointer.ButtonState.pressed:
            events ~= MouseEvent(0, curX, curY);
            break;
        case WlPointer.ButtonState.released:
            events ~= MouseEvent(1, curX, curY);
            break;
        }
    }

    private void pointerMotion(WlPointer, uint, WlFixed surfaceX, WlFixed surfaceY)
    {
        curX = surfaceX;
        curY = surfaceY;
        events ~= MouseEvent(2, curX, curY);
    }

    private void pointerFrame(WlPointer)
    {
        foreach (e; events) {
            switch (e.type) {
            case 0:
                if (onHandler) {
                    onHandler(cast(int)e.curX, cast(int)e.curY);
                }
                break;
            case 1:
                if (offHandler) {
                    offHandler(cast(int)e.curX, cast(int)e.curY);
                }
                break;
            case 2:
                if (moveHandler) {
                    moveHandler(cast(int)e.curX, cast(int)e.curY);
                }
                break;
            default:
                assert(false);
            }
        }
        events = [];
    }

    private void pointerEnter(WlFixed x, WlFixed y) {
        curX = x; curY = y;
    }

    private void pointerLeave() {}

    private WlSurface wlSurface;
    private WlShellSurface wlShellSurface;

    private Surface gfxSurface;

    private MouseHandler moveHandler;
    private MouseHandler onHandler;
    private MouseHandler offHandler;
    private WlFixed curX;
    private WlFixed curY;
    MouseEvent[] events;

    struct MouseEvent {
        int type; // 0: on, 1: off, 2: motion
        WlFixed curX;
        WlFixed curY;
    }
}



private:

// FIXME: multithreading

class Display {
    WlDisplay display;
    WlCompositor compositor;
    WlShell shell;
    WlSeat seat;
    WlPointer pointer;

    WaylandWindow[] windows;

    this() {
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
            else if(iface == WlShell.iface.name)
            {
                shell = cast(WlShell)reg.bind(
                    name, WlShell.iface, min(ver, 1)
                );
            }
            else if(iface == WlSeat.iface.name)
            {
                seat = cast(WlSeat)reg.bind(
                    name, WlSeat.iface, min(ver, 2)
                );
                pointer = seat.getPointer();
                pointer.onEnter = &pointerEnter;
                pointer.onLeave = &pointerLeave;
            }
        };
        display.roundtrip();
        reg.destroy();
    }

    void pointerEnter(WlPointer pointer, uint serial, WlSurface surface,
                        WlFixed surfaceX, WlFixed surfaceY)
    {
        foreach (w; windows) {
            if (w.wlSurface is surface) {
                pointer.onButton = &w.pointerButton;
                pointer.onMotion = &w.pointerMotion;
                pointer.onFrame = &w.pointerFrame;
                w.pointerEnter(surfaceX, surfaceY);
            }
        }
    }

    void pointerLeave(WlPointer pointer, uint serial, WlSurface surface)
    {
        pointer.onButton = null;
        pointer.onMotion = null;
        pointer.onFrame = null;
        foreach (w; windows) {
            if (w.wlSurface is surface) {
                w.pointerLeave();
            }
        }
    }


    void close() {
        if (pointer) {
            pointer.destroy();
            pointer = null;
        }
        if (seat) {
            seat.destroy();
            seat = null;
        }
        if (shell) {
            shell.destroy();
            shell = null;
        }
        if (compositor) {
            compositor.destroy();
            compositor = null;
        }
        display.disconnect();
        display = null;
    }
}

Display dpy;
uint refCount;

void refDisplay(WaylandWindow w) {
    if (refCount == 0) {
        dpy = new Display();
        dpy.windows ~= w;
    }
    ++refCount;
}

void unrefDisplay(WaylandWindow w) {
    --refCount;
    if (refCount == 0) {
        import std.algorithm : remove;
        dpy.windows = dpy.windows.remove!(ww => ww is w);
        dpy.close();
        dpy = null;
    }
}
