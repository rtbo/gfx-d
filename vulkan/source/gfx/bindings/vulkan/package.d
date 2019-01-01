/// vkdgen Vulkan bindings.
/// See https://github.com/rtbo/vkdgen
module gfx.bindings.vulkan;

public import gfx.bindings.vulkan.loader;
public import gfx.bindings.vulkan.vk;

@nogc nothrow pure
{
    /// Make a Vulkan version identifier
    uint VK_MAKE_VERSION( uint major, uint minor, uint patch ) {
        return ( major << 22 ) | ( minor << 12 ) | ( patch );
    }

    /// Make Vulkan-1.0 identifier
    uint VK_API_VERSION_1_0() { return VK_MAKE_VERSION( 1, 0, 0 ); }
    /// Make Vulkan-1.1 identifier
    uint VK_API_VERSION_1_1() { return VK_MAKE_VERSION( 1, 1, 0 ); }

    /// Extract major version from a Vulkan version identifier
    uint VK_VERSION_MAJOR( uint ver ) { return ver >> 22; }
    /// Extract minor version from a Vulkan version identifier
    uint VK_VERSION_MINOR( uint ver ) { return ( ver >> 12 ) & 0x3ff; }
    /// Extract patch version from a Vulkan version identifier
    uint VK_VERSION_PATCH( uint ver ) { return ver & 0xfff; }
}

/// Vulkan null handle
enum VK_NULL_HANDLE = null;
version(X86_64) {
    /// Vulkan non-dispatchable null handle
    enum VK_NULL_ND_HANDLE = null;
}
else {
    /// Vulkan non-dispatchable null handle
    enum VK_NULL_ND_HANDLE = 0;
}
