/// Vulkan Window System Integration module
module gfx.vulkan.wsi;

import core.time : Duration;

import gfx.bindings.vulkan;

import gfx.core.rc;
import gfx.graal;
import gfx.graal.format;
import gfx.graal.image;
import gfx.graal.sync;
import gfx.vulkan;
import gfx.vulkan.image;
import gfx.vulkan.error;
import gfx.vulkan.sync;

import std.exception : enforce;

// instance level extensions

enum surfaceExtension = "VK_KHR_surface";

version(Windows) {
    enum win32SurfaceExtension = "VK_KHR_win32_surface";
}
version(linux) {
    enum waylandSurfaceExtension = "VK_KHR_wayland_surface";
    enum xcbSurfaceExtension = "VK_KHR_xcb_surface";
}

// device level extensions

enum swapChainExtension = "VK_KHR_swapchain";

version(linux) {
    import wayland.client : WlDisplay, WlSurface;
    import xcb.xcb : xcb_connection_t, xcb_window_t;

    // TODO: fall back from wayland to XCB
    enum surfaceInstanceExtensions = [
        surfaceExtension, waylandSurfaceExtension, xcbSurfaceExtension
    ];

    Surface createVulkanWaylandSurface(Instance graalInst, WlDisplay wlDpy, WlSurface wlSurf)
    {
        auto inst = enforce(
            cast(VulkanInstance)graalInst,
            "createVulkanWaylandSurface called with non-vulkan instance"
        );

        VkWaylandSurfaceCreateInfoKHR sci;
        sci.sType = VK_STRUCTURE_TYPE_WAYLAND_SURFACE_CREATE_INFO_KHR;
        sci.display = wlDpy.native;
        sci.surface = wlSurf.proxy;

        VkSurfaceKHR vkSurf;
        vulkanEnforce(
            inst.vk.CreateWaylandSurfaceKHR(inst.vkObj, &sci, null, &vkSurf),
            "Could not create Vulkan Wayland Surface"
        );

        return new VulkanSurface(vkSurf, inst);
    }

    Surface createVulkanXcbSurface(Instance graalInst, xcb_connection_t* conn, xcb_window_t win)
    {
        auto inst = enforce(
            cast(VulkanInstance)graalInst,
            "createVulkanXcbSurface called with non-vulkan instance"
        );

        VkXcbSurfaceCreateInfoKHR sci;
        sci.sType = VK_STRUCTURE_TYPE_XCB_SURFACE_CREATE_INFO_KHR;
        sci.connection = conn;
        sci.window = win;

        VkSurfaceKHR vkSurf;
        vulkanEnforce(
            inst.vk.CreateXcbSurfaceKHR(inst.vkObj, &sci, null, &vkSurf),
            "Could not create Vulkan Xcb Surface"
        );

        return new VulkanSurface(vkSurf, inst);
    }
}

version(Windows) {

    import core.sys.windows.windef : HINSTANCE, HWND;

    enum surfaceInstanceExtensions = [
        surfaceExtension, win32SurfaceExtension
    ];

    Surface createVulkanWin32Surface(Instance graalInst, HINSTANCE hinstance, HWND hwnd) {
        auto inst = enforce(
            cast(VulkanInstance)graalInst,
            "createVulkanXcbSurface called with non-vulkan instance"
        );

        VkWin32SurfaceCreateInfoKHR sci;
        sci.sType = VK_STRUCTURE_TYPE_WIN32_SURFACE_CREATE_INFO_KHR;
        sci.hinstance = hinstance;
        sci.hwnd = hwnd;

        VkSurfaceKHR vkSurf;
        vulkanEnforce(
            inst.vk.CreateWin32SurfaceKHR(inst.vkObj, &sci, null, &vkSurf),
            "Could not create Vulkan Xcb Surface"
        );

        return new VulkanSurface(vkSurf, inst);
    }
}
version(GfxOffscreen) {
    enum surfaceInstanceExtensions = [];
}


package:

class VulkanSurface : VulkanInstObj!(VkSurfaceKHR), Surface
{
    mixin(atomicRcCode);

    this(VkSurfaceKHR vkObj, VulkanInstance inst)
    {
        super(vkObj, inst);
    }

    override void dispose() {
        inst.vk.DestroySurfaceKHR(vkInst, vkObj, null);
        super.dispose();
    }
}

class VulkanSwapchain : VulkanDevObj!(VkSwapchainKHR, "DestroySwapchainKHR"), Swapchain
{
    mixin(atomicRcCode);

    this(VkSwapchainKHR vkObj, VulkanDevice dev, Surface surf, uint[2] size, Format format)
    {
        super(vkObj, dev);
        _surf = surf;
        _size = size;
        _format = format;
    }

    override void dispose() {
        super.dispose();
        _surf.unload();
    }

    override @property Device device() {
        return dev;
    }

    override @property Surface surface() {
        return _surf;
    }

    override @property Format format() {
        return _format;
    }

    // not releasing images on purpose, the lifetime is owned by implementation

    override @property ImageBase[] images() {

        if (!_images.length) {
            uint count;
            vulkanEnforce(
                vk.GetSwapchainImagesKHR(vkDev, vkObj, &count, null),
                "Could not get vulkan swap chain images"
            );
            auto vkImgs = new VkImage[count];
            vulkanEnforce(
                vk.GetSwapchainImagesKHR(vkDev, vkObj, &count, &vkImgs[0]),
                "Could not get vulkan swap chain images"
            );

            import std.algorithm : map;
            import std.array : array;
            _images = vkImgs
                    .map!((VkImage vkImg) {
                        const info = ImageInfo.d2(_size[0], _size[1]).withFormat(_format);
                        auto img = new VulkanImageBase(vkImg, dev, info);
                        return cast(ImageBase)img;
                    })
                    .array;
        }

        return _images;
    }

    override uint acquireNextImage(Duration timeout, Semaphore graalSemaphore, out bool suboptimal)
    {
        auto sem = enforce(
            cast(VulkanSemaphore)graalSemaphore,
            "a non vulkan semaphore was passed"
        );

        ulong vkTimeout = timeout.total!"nsecs";
        import core.time : dur;
        if (timeout < dur!"nsecs"(0)) {
            vkTimeout = ulong.max;
        }

        uint img;
        const res = vk.AcquireNextImageKHR(vkDev, vkObj, vkTimeout, sem.vkObj, VK_NULL_ND_HANDLE, &img);

        if (res == VK_SUBOPTIMAL_KHR) {
            suboptimal = true;
        }
        else {
            enforce(res == VK_SUCCESS, "Could not acquire next vulkan image");
        }

        return img;
    }

    private Rc!Surface _surf;
    private ImageBase[] _images;
    private uint[2] _size;
    private Format _format;
}
