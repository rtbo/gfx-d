/// D Bindings to Vulkan API for Gfx-d
module gfx.bindings.vulkan;

import gfx.bindings.core;
public import gfx.bindings.vulkan.vk;

import std.exception;

@nogc nothrow pure {
    uint VK_MAKE_VERSION( uint major, uint minor, uint patch ) {
        return ( major << 22 ) | ( minor << 12 ) | ( patch );
    }

    uint VK_API_VERSION_1_0() { return VK_MAKE_VERSION( 1, 0, 0 ); }

    uint VK_VERSION_MAJOR( uint ver ) { return ver >> 22; }
    uint VK_VERSION_MINOR( uint ver ) { return ( ver >> 12 ) & 0x3ff; }
    uint VK_VERSION_PATCH( uint ver ) { return ver & 0xfff; }
}


enum VK_NULL_HANDLE = null;
version(X86_64) {
    enum VK_NULL_ND_HANDLE = null;
}
else {
    enum VK_NULL_ND_HANDLE = 0;
}

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
