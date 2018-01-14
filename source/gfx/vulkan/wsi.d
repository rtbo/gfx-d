/// Vulkan Window System Integration module
module gfx.vulkan.wsi;

import gfx.core.rc;
import gfx.graal;
import gfx.graal.image;
import gfx.vulkan;
import gfx.vulkan.error;

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

version(GfxVulkanWayland) {
    import wayland.client;

    enum surfaceInstanceExtensions = [
        surfaceExtension, waylandSurfaceExtension
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
            vkCreateWaylandSurfaceKHR(inst.vk, &sci, null, &vkSurf),
            "Could not create Vulkan Wayland Surface"
        );

        return new VulkanSurface(vkSurf, inst);
    }
}
version(GfxVulkanXcb) {
    enum surfaceInstanceExtensions = [
        surfaceExtension, xcbSurfaceExtension
    ];
}
version(GfxVulkanWin32) {
    enum surfaceInstanceExtensions = [
        surfaceExtension, win32SurfaceExtension
    ];
}
version(GfxOffscreen) {
    enum surfaceInstanceExtensions = [];
}



version(GfxVulkanWayland) {
}
version(GfxVulkanXcb) {
}
version(GfxVulkanWin32) {
}

package:

class VulkanSurface : VulkanInstObj!(VkSurfaceKHR, vkDestroySurfaceKHR), Surface
{
    mixin(atomicRcCode);

    this(VkSurfaceKHR vk, VulkanInstance inst)
    {
        super(vk, inst);
    }
}
