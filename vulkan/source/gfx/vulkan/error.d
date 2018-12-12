/// Module that is meant to give meaningful information about the Vulkan errors
module gfx.vulkan.error;

package:

import gfx.bindings.vulkan;

import gfx.graal.error;

void vulkanEnforce(in VkResult res, in string msg) {
    if (res == VK_SUCCESS) return;

    import gfx.graal.error;

    switch (res) {
    case VK_ERROR_OUT_OF_HOST_MEMORY:
        throw new OutOfHostMemoryException(msg);
    case VK_ERROR_OUT_OF_DEVICE_MEMORY:
        throw new OutOfDeviceMemoryException(msg);
    case VK_ERROR_INITIALIZATION_FAILED:
        throw new InitializationFailedException(msg);
    case VK_ERROR_MEMORY_MAP_FAILED:
        throw new MemoryMapFailedException(msg);
    case VK_ERROR_DEVICE_LOST:
        throw new DeviceLostException(msg);
    case VK_ERROR_EXTENSION_NOT_PRESENT:
        throw new ExtensionNotPresentException(msg);
    case VK_ERROR_FEATURE_NOT_PRESENT:
        throw new FeatureNotPresentException(msg);
    case VK_ERROR_LAYER_NOT_PRESENT:
        throw new LayerNotPresentException(msg);
    case VK_ERROR_INCOMPATIBLE_DRIVER:
        throw new IncompatibleDriverException(msg);
    case VK_ERROR_TOO_MANY_OBJECTS:
        throw new TooManyObjectsException(msg);
    case VK_ERROR_FORMAT_NOT_SUPPORTED:
        throw new FormatNotSupportedException(msg);
    case VK_ERROR_SURFACE_LOST_KHR:
        throw new SurfaceLostException(msg);
    case VK_ERROR_OUT_OF_DATE_KHR:
        throw new OutOfDateException(msg);
    case VK_ERROR_INCOMPATIBLE_DISPLAY_KHR:
        throw new IncompatibleDisplayException(msg);
    case VK_ERROR_NATIVE_WINDOW_IN_USE_KHR:
        throw new NativeWindowInUseException(msg);
    case VK_ERROR_VALIDATION_FAILED_EXT:
        throw new ValidationFailedException(msg);
    default:
        throw new GfxException(msg, "Unknown reason");
    }
}


