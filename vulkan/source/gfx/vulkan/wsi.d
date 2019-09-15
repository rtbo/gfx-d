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

enum surfaceInstanceExtension = "VK_KHR_surface";

version(Windows) {
    enum win32SurfaceInstanceExtension = "VK_KHR_win32_surface";
}
version(linux) {
    enum waylandSurfaceInstanceExtension = "VK_KHR_wayland_surface";
    enum xcbSurfaceInstanceExtension = "VK_KHR_xcb_surface";
}

// device level extensions

enum swapChainDeviceExtension = "VK_KHR_swapchain";

version(GfxOffscreen) {
    /// Extensions to open Vulkan surfaces on the platform window system
    immutable string[] surfaceInstanceExtensions = [];
}
else {
    version(linux) {
        import wayland.client : WlDisplay, WlSurface;
        import xcb.xcb : xcb_connection_t, xcb_window_t;

        /// Extensions to open Vulkan surfaces on the platform window system
        immutable string[] surfaceInstanceExtensions = [
            surfaceInstanceExtension, waylandSurfaceInstanceExtension, xcbSurfaceInstanceExtension
        ];
        /// Extensions necessary to open a Wayland Vulkan surface
        immutable string[] waylandSurfaceInstanceExtensions = [
            surfaceInstanceExtension, waylandSurfaceInstanceExtension
        ];
        /// Extensions necessary to open an XCB Vulkan surface
        immutable string[] xcbSurfaceInstanceExtensions = [
            surfaceInstanceExtension, xcbSurfaceInstanceExtension
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

        /// Extensions to open Vulkan surfaces on the platform window system
        immutable string[] surfaceInstanceExtensions = [
            surfaceInstanceExtension, win32SurfaceInstanceExtension
        ];
        /// Extensions necessary to open an Win32 Vulkan surface
        immutable string[] win32SurfaceInstanceExtensions = [
            surfaceInstanceExtension, win32SurfaceInstanceExtension
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

    this(VkSwapchainKHR vkObj, VulkanDevice dev, Surface surf, uint[2] size,
            Format format, ImageUsage usage)
    {
        super(vkObj, dev);
        _surf = surf;
        _size = size;
        _format = format;
        _usage = usage;
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
                        const info = ImageInfo.d2(_size[0], _size[1])
                            .withFormat(_format)
                            .withUsage(_usage);
                        auto img = new VulkanImageBase(vkImg, dev, info);
                        return cast(ImageBase)img;
                    })
                    .array;
        }

        return _images;
    }

    override ImageAcquisition acquireNextImage(Semaphore graalSem,
                                               Duration timeout)
    {
        auto sem = enforce(
            cast(VulkanSemaphore)graalSem,
            "a non vulkan semaphore was passed acquireNextImage"
        );

        ulong vkTimeout = timeout.total!"nsecs";
        import core.time : dur;
        if (timeout < dur!"nsecs"(0)) {
            vkTimeout = ulong.max;
        }

        uint img;
        const res = vk.AcquireNextImageKHR(vkDev, vkObj, vkTimeout, sem.vkObj, VK_NULL_ND_HANDLE, &img);

        switch (res)
        {
        case VK_SUCCESS:
            return ImageAcquisition.makeOk(img);
        case VK_SUBOPTIMAL_KHR:
            return ImageAcquisition.makeSuboptimal(img);
        case VK_NOT_READY:
        case VK_TIMEOUT:
            return ImageAcquisition.makeNotReady();
        case VK_ERROR_OUT_OF_DATE_KHR:
            return ImageAcquisition.makeOutOfDate();
        default:
            vulkanEnforce(res, "Could not acquire next vulkan image");
            assert(false);
        }
    }

    private Rc!Surface _surf;
    private ImageBase[] _images;
    private uint[2] _size;
    private Format _format;
    private ImageUsage _usage;
}
