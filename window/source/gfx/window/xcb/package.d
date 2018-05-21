module gfx.window.xcb;

version(linux):

import gfx.graal : Instance;
import gfx.window;
import xcb.xcb;

/// List of X atoms that are fetched automatically
enum Atom
{
    UTF8_STRING,

    WM_PROTOCOLS,
    WM_DELETE_WINDOW,
    WM_TRANSIENT_FOR,
    WM_CHANGE_STATE,
    WM_STATE,
    _NET_WM_STATE,
    _NET_WM_STATE_MODAL,
    _NET_WM_STATE_STICKY,
    _NET_WM_STATE_MAXIMIZED_VERT,
    _NET_WM_STATE_MAXIMIZED_HORZ,
    _NET_WM_STATE_SHADED,
    _NET_WM_STATE_SKIP_TASKBAR,
    _NET_WM_STATE_SKIP_PAGER,
    _NET_WM_STATE_HIDDEN,
    _NET_WM_STATE_FULLSCREEN,
    _NET_WM_STATE_ABOVE,
    _NET_WM_STATE_BELOW,
    _NET_WM_STATE_DEMANDS_ATTENTION,
    _NET_WM_STATE_FOCUSED,
    _NET_WM_NAME,
}

/// get the response_type field masked for
@property ubyte xcbEventType(EvT)(EvT* e)
{
    return (e.response_type & ~0x80);
}

class XcbDisplay : Display
{
    import gfx.core.rc : atomicRcCode, Rc;
    import gfx.graal : Backend;
    import X11.Xlib : XDisplay = Display;

    mixin(atomicRcCode);

    private XDisplay *_dpy;
    private xcb_connection_t* _conn;
    private xcb_atom_t[Atom] _atoms;
    private int _mainScreenNum;
    private xcb_screen_t*[] _screens;

    private Rc!Instance _instance;

    private Window[] _windows;
    private XcbWindow[] _xcbWindows;

    this(in Backend[] loadOrder)
    {
        import std.exception : enforce;
        import std.experimental.logger : trace;
        import X11.Xlib : XCloseDisplay, XDefaultScreen, XOpenDisplay;
        import X11.Xlib_xcb : XGetXCBConnection, XSetEventQueueOwner, XCBOwnsEventQueue;

        trace("opening X display");
        _dpy = enforce(XOpenDisplay(null));
        scope(failure) {
            XCloseDisplay(_dpy);
        }
        _conn = enforce(XGetXCBConnection(_dpy));
        XSetEventQueueOwner(_dpy, XCBOwnsEventQueue);
        _mainScreenNum = XDefaultScreen(_dpy);

        initializeAtoms();
        initializeScreens();
        initializeInstance(loadOrder);
    }

    override void dispose()
    {
        import std.experimental.logger : trace;
        import X11.Xlib : XCloseDisplay;

        if (_windows.length) {
            auto ws = _windows.dup;
            foreach (w; ws) w.close();
        }
        assert(!_windows.length);

        _instance.unload();
        trace("closing X display");
        XCloseDisplay(_dpy);
    }

    private void initializeAtoms()
    {
        import core.stdc.stdlib : free;
        import std.conv : to;
        import std.string : toStringz;
        import std.traits : EnumMembers;

        xcb_intern_atom_cookie_t[] cookies;
        cookies.reserve(EnumMembers!Atom.length);

        foreach (immutable atom; EnumMembers!Atom) // static foreach
        {
            auto name = atom.to!string;
            cookies ~= xcb_intern_atom(_conn, 1,
                    cast(ushort)name.length, toStringz(name));
        }

        foreach (i, immutable atom; EnumMembers!Atom) // static foreach
        {
            immutable name = atom.to!string;
            xcb_generic_error_t* err;
            auto reply = xcb_intern_atom_reply(_conn, cookies[i], &err);
            if (err)
            {
                throw new Exception("failed initializing atom " ~ name ~ ": ",
                        (*err).to!string);
            }
            if (reply.atom == XCB_ATOM_NONE)
            {
                throw new Exception("could not retrieve atom " ~ name);
            }
            _atoms[atom] = reply.atom;
            free(reply);
        }
    }

    private void initializeScreens()
    {
        xcb_screen_iterator_t iter;
        for (iter = xcb_setup_roots_iterator(xcb_get_setup(_conn)); iter.rem;
                xcb_screen_next(&iter))
        {
            _screens ~= iter.data;
        }
    }

    private void initializeInstance(in Backend[] loadOrder)
    {
        import std.experimental.logger : info, trace, warningf;
        assert(!_instance);

        foreach (b; loadOrder) {
            final switch (b) {
            case Backend.vulkan:
                try {
                    trace("Attempting to instantiate Vulkan");
                    import gfx.vulkan : createVulkanInstance, vulkanInit;
                    vulkanInit();
                    _instance = createVulkanInstance();
                    info("Creating a Vulkan instance");
                }
                catch (Exception ex) {
                    warningf("Vulkan is not available. %s", ex.msg);
                }
                break;
            case Backend.gl3:
                try {
                    import gfx.core.rc : makeRc;
                    import gfx.gl3 : GlInstance;
                    import gfx.gl3.context : GlAttribs;
                    import gfx.window.xcb.context : XcbGlContext;
                    trace("Attempting to instantiate OpenGL");
                    auto w = new XcbWindow(this, null, true);
                    w.show(10, 10);
                    scope(exit) w.close();
                    auto ctx = makeRc!XcbGlContext(_dpy, _mainScreenNum, GlAttribs.init, w._win);
                    trace("Creating an OpenGL instance");
                    _instance = new GlInstance(ctx);
                }
                catch (Exception ex) {
                    warningf("OpenGL is not available. %s", ex.msg);
                }
                break;
            }
            if (_instance) break;
        }

        if (!_instance) {
            throw new Exception("Could not instantiate a backend");
        }
    }

    override @property Instance instance() {
        return _instance;
    }

    override @property Window[] windows()
    {
        return _windows;
    }

    override Window createWindow()
    {
        return new XcbWindow(this, _instance, false);
    }

    override void pollAndDispatch()
    {
        while (true) {
            auto e = xcb_poll_for_event(_conn);
            if (!e) break;
            handleEvent(e);
        }
    }

    private XcbWindow xcbWindow(xcb_window_t win) {
        foreach(w; _xcbWindows) {
            if (w._win == win) return w;
        }
        return null;
    }

    void registerWindow(XcbWindow window) {
        _windows ~= window;
        _xcbWindows ~= window;
    }

    void unregisterWindow(XcbWindow window) {
        import std.algorithm : remove;
        _windows = _windows.remove!(w => w is window);
        _xcbWindows = _xcbWindows.remove!(w => w is window);
    }

    private @property int mainScreenNum()
    {
        return _mainScreenNum;
    }

    private @property xcb_screen_t* mainScreen()
    {
        return _screens[_mainScreenNum];
    }

    private void handleEvent(xcb_generic_event_t* e)
    {
        immutable xcbType = xcbEventType(e);

        switch (xcbType)
        {
        case XCB_KEY_PRESS:
            auto ev = cast(xcb_key_press_event_t*)e;
            auto xcbWin = xcbWindow(ev.event);
            if (xcbWin && xcbWin._onKeyOnHandler)
                xcbWin._onKeyOnHandler(ev.detail);
            break;
        case XCB_KEY_RELEASE:
            auto ev = cast(xcb_key_press_event_t*)e;
            auto xcbWin = xcbWindow(ev.event);
            if (xcbWin && xcbWin._onKeyOffHandler)
                xcbWin._onKeyOffHandler(ev.detail);
            break;
        case XCB_BUTTON_PRESS:
            auto ev = cast(xcb_button_press_event_t*)e;
            auto xcbWin = xcbWindow(ev.event);
            if (xcbWin && xcbWin._onHandler)
                xcbWin._onHandler(ev.event_x, ev.event_y);
            break;
        case XCB_BUTTON_RELEASE:
            auto ev = cast(xcb_button_press_event_t*)e;
            auto xcbWin = xcbWindow(ev.event);
            if (xcbWin && xcbWin._offHandler)
                xcbWin._offHandler(ev.event_x, ev.event_y);
            break;
        case XCB_MOTION_NOTIFY:
            auto ev = cast(xcb_motion_notify_event_t*)e;
            auto xcbWin = xcbWindow(ev.event);
            if (xcbWin && xcbWin._moveHandler)
                xcbWin._moveHandler(ev.event_x, ev.event_y);
            break;
        case XCB_CONFIGURE_NOTIFY:
            break;
        case XCB_PROPERTY_NOTIFY:
            break;
        case XCB_CLIENT_MESSAGE:
            auto ev = cast(xcb_client_message_event_t*)e;
            if (ev.data.data32[0] == atom(Atom.WM_DELETE_WINDOW)) {
                auto win = xcbWindow(ev.window);
                if (win._onCloseHandler) {
                    win._closeFlag = win._onCloseHandler();
                }
                else {
                    win._closeFlag = true;
                }
            }
            break;
        default:
            break;
        }
    }

    private xcb_atom_t atom(Atom atom) const
    {
        auto at = (atom in _atoms);
        if (at)
            return *at;
        return XCB_ATOM_NONE;
    }
}

class XcbWindow : Window
{
    import gfx.graal.presentation : Surface;

    private XcbDisplay _dpy;
    private Instance _instance;
    private xcb_window_t _win;
    private Surface _surface;
    private MouseHandler _moveHandler;
    private MouseHandler _onHandler;
    private MouseHandler _offHandler;
    private KeyHandler _onKeyOnHandler;
    private KeyHandler _onKeyOffHandler;
    private CloseHandler _onCloseHandler;
    private bool _closeFlag;
    private bool _dummy;

    this(XcbDisplay dpy, Instance instance, bool dummy)
    {
        assert(dpy && (dummy || instance));
        _dpy = dpy;
        _instance = instance;
        _dummy = dummy;
    }

    override @property void onMouseMove(MouseHandler handler) {
        _moveHandler = handler;
    }
    override @property void onMouseOn(MouseHandler handler) {
        _onHandler = handler;
    }
    override @property void onMouseOff(MouseHandler handler) {
        _offHandler = handler;
    }
    override @property void onKeyOn(KeyHandler handler) {
        _onKeyOnHandler = handler;
    }
    override @property void onKeyOff(KeyHandler handler) {
        _onKeyOffHandler = handler;
    }
    override @property void onClose(CloseHandler handler) {
        _onCloseHandler = handler;
    }

    override @property Surface surface() {
        return _surface;
    }

    override @property bool closeFlag() const {
        return _closeFlag;
    }

    override @property void closeFlag(in bool flag) {
        _closeFlag = flag;
    }

    override void show(uint width, uint height)
    {
        const screen = _dpy.mainScreen;

        const cmap = xcb_generate_id(_dpy._conn);
        _win = xcb_generate_id(_dpy._conn);

        auto visual = drawArgbVisual(screen);
        const depth = drawVisualDepth(screen, visual.visual_id);

        xcb_create_colormap(_dpy._conn, XCB_COLORMAP_ALLOC_NONE, cmap, screen.root, visual.visual_id);

        immutable mask = XCB_CW_BACK_PIXMAP | XCB_CW_BORDER_PIXEL | XCB_CW_COLORMAP;
        const uint[] values = [XCB_BACK_PIXMAP_NONE, 0, cmap, 0];

        auto cookie = xcb_create_window_checked(_dpy._conn, depth,
                _win, screen.root, 50, 50, cast(ushort) width, cast(ushort) height, 0,
                XCB_WINDOW_CLASS_INPUT_OUTPUT, visual.visual_id, mask, &values[0]);

        auto err = xcb_request_check(_dpy._conn, cookie);
        if (err) {
            import std.format : format;
            throw new Exception(format("GFX-XCB: could not create window: %s", err.error_code));
        }

        // register regular events
        {
            const uint[] attrs = [
                XCB_EVENT_MASK_KEY_PRESS | XCB_EVENT_MASK_KEY_RELEASE | XCB_EVENT_MASK_BUTTON_PRESS
                | XCB_EVENT_MASK_BUTTON_RELEASE | XCB_EVENT_MASK_ENTER_WINDOW
                | XCB_EVENT_MASK_LEAVE_WINDOW | XCB_EVENT_MASK_POINTER_MOTION
                | XCB_EVENT_MASK_BUTTON_MOTION | XCB_EVENT_MASK_EXPOSURE
                | XCB_EVENT_MASK_STRUCTURE_NOTIFY | XCB_EVENT_MASK_PROPERTY_CHANGE, 0
            ];
            xcb_change_window_attributes(_dpy._conn, _win,
                    XCB_CW_EVENT_MASK, &attrs[0]);
        }
        // register window close event
        {
            const xcb_atom_t[] props = [atom(Atom.WM_DELETE_WINDOW), 0];
            xcb_change_property(_dpy._conn, XCB_PROP_MODE_REPLACE, _win,
                    atom(Atom.WM_PROTOCOLS), XCB_ATOM_ATOM, 32, 1, &props[0]);
        }

        if (_dummy) {
            xcb_flush(_dpy._conn);
            return;
        }

        _dpy.registerWindow(this);

        xcb_map_window(_dpy._conn, _win);
        xcb_flush(_dpy._conn);

        import gfx.graal : Backend;
        final switch (_instance.backend) {
        case Backend.vulkan:
            import gfx.vulkan.wsi : createVulkanXcbSurface;
            _surface = createVulkanXcbSurface(_instance, _dpy._conn, _win);
            break;
        case Backend.gl3:
            import gfx.gl3 : GlInstance;
            import gfx.gl3.swapchain : GlSurface;
            _surface = new GlSurface(_win);
            auto glInst = cast(GlInstance)_instance;
            auto ctx = glInst.ctx;
            ctx.makeCurrent(_win);
            break;
        }
    }

    override void close()
    {
        if (_dummy) {
            if (_win) {
                xcb_destroy_window(_dpy._conn, _win);
                _win = 0;
            }
        }
        else {
            if (_win) {
                xcb_unmap_window(_dpy._conn, _win);
                xcb_destroy_window(_dpy._conn, _win);
                xcb_flush(_dpy._conn);
                _win = 0;
            }
            _dpy.unregisterWindow(this);
        }
    }

    private xcb_atom_t atom(Atom atom) const
    {
        return _dpy.atom(atom);
    }
}

xcb_visualtype_t *drawArgbVisual(const xcb_screen_t *s)
{
    xcb_depth_iterator_t depth_iter = xcb_screen_allowed_depths_iterator(s);

    if(depth_iter.data) {
        for(; depth_iter.rem; xcb_depth_next (&depth_iter)) {
            if(depth_iter.data.depth == 32) {
                for(xcb_visualtype_iterator_t visual_iter = xcb_depth_visuals_iterator(depth_iter.data);
                    visual_iter.rem; xcb_visualtype_next (&visual_iter))
                {
                    if (visual_iter.data && visual_iter.data.class_ == XCB_VISUAL_CLASS_TRUE_COLOR)
                        return visual_iter.data;
                }
            }
        }
    }

    throw new Exception("could not find a draw visual");
}

ubyte drawVisualDepth(const xcb_screen_t *s, xcb_visualid_t vis)
{
    xcb_depth_iterator_t depth_iter = xcb_screen_allowed_depths_iterator(s);

    if(depth_iter.data) {
        for(; depth_iter.rem; xcb_depth_next (&depth_iter)) {
            for(xcb_visualtype_iterator_t visual_iter = xcb_depth_visuals_iterator(depth_iter.data);
                visual_iter.rem; xcb_visualtype_next (&visual_iter))
            {
                if(vis == visual_iter.data.visual_id)
                    return depth_iter.data.depth;
            }
        }
    }
    throw new Exception("could not find a visuals depth");
}