/// D Bindings to Vulkan API for Gfx-d
module gfx.bindings.vulkan;

import gfx.bindings.core;
public import gfx.bindings.vulkan.vk;

import std.exception;

VkGlobalCmds loadVulkanGlobalCmds() {
    version( Windows )
        enum libName = "vulkan-1.dll";
    else version( Posix )
        enum libName = "libvulkan.so.1";
    else
        static assert (false, "Vulkan bindings not supported on this OS");

    auto lib = enforce(openSharedLib(libName), "Cannot open "~libName);

    auto getInstanceProcAddr = enforce(
        cast(PFN_vkGetInstanceProcAddr)loadSharedSym(lib, "vkGetInstanceProcAddr"),
        "Could not load vkGetInstanceProcAddr from "~libName
    );

    return new VkGlobalCmds(getInstanceProcAddr);
}
