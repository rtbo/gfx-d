module gfx.graal.error;

import std.format;


class GfxException : Exception
{
    this (in string msg, in string reason) {
        super(msg.length ?
            format("Gfx error: %s. Reason: %s", msg, reason) :
            format("Gfx error: %s", reason)
        );
    }
}
class OutOfDeviceMemoryException : GfxException
{
    this (in string msg) {
        super(msg, "Out of device memory");
    }
}
class OutOfHostMemoryException : GfxException
{
    this (in string msg) {
        super(msg, "Out of host memory");
    }
}
class InitializationFailedException : GfxException
{
    this (in string msg) {
        super(msg, "Initialization failed");
    }
}
class MemoryMapFailedException : GfxException
{
    this (in string msg) {
        super(msg, "Memory map failed");
    }
}
class DeviceLostException : GfxException
{
    this (in string msg) {
        super(msg, "Device lost");
    }
}
class ExtensionNotPresentException : GfxException
{
    this (in string msg) {
        super(msg, "Extension not present");
    }
}
class FeatureNotPresentException : GfxException
{
    this (in string msg) {
        super(msg, "Feature not present");
    }
}
class LayerNotPresentException : GfxException
{
    this (in string msg) {
        super(msg, "Layer not present");
    }
}
class IncompatibleDriverException : GfxException
{
    this (in string msg) {
        super(msg, "Incompatible driver");
    }
}
class TooManyObjectsException : GfxException
{
    this (in string msg) {
        super(msg, "Too many objects");
    }
}
class FormatNotSupportedException : GfxException
{
    this (in string msg) {
        super(msg, "Format not supported");
    }
}
class SurfaceLostException : GfxException
{
    this (in string msg) {
        super(msg, "Surface lost");
    }
}
class OutOfDateException : GfxException
{
    this (in string msg) {
        super(msg, "Out of date");
    }
}
class IncompatibleDisplayException : GfxException
{
    this (in string msg) {
        super(msg, "Incompatible display");
    }
}
class NativeWindowInUseException : GfxException
{
    this (in string msg) {
        super(msg, "Native window in use");
    }
}
class ValidationFailedException : GfxException
{
    this (in string msg) {
        super(msg, "Validation failed");
    }
}
