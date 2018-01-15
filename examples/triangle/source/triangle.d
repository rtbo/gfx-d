module triangle;

import erupted;

import gfx.core.rc;
import gfx.graal;
import gfx.graal.device;
import gfx.vulkan;
import gfx.window;

import std.algorithm;
import std.exception;
import std.stdio;

int main() {

    vulkanInit();

    writeln("layers:");
    vulkanInstanceLayers.each!(writeln);
    writeln("extensions:");
    vulkanInstanceExtensions.each!(writeln);

    auto instance = createVulkanInstance("Triangle", VulkanVersion(0, 0, 1)).rc;

    auto win = createWindow(instance);
    scope(exit) win.close();

    auto pd = enforce(
        chooseDevice(instance, win.surface),
        "Could not find a suitable device"
    ).rc;

    writeln("device layers:");
    pd.vulkanDeviceLayers.each!(writeln);
    writeln("device extensions:");
    pd.vulkanDeviceExtensions.each!(writeln);
    writefln("apiVersion = %s", VulkanVersion.fromUint(pd.apiVersion));
    writefln("driverVersion = %s", VulkanVersion.fromUint(pd.driverVersion));
    writefln("vendorId = %s", pd.vendorId);
    writefln("deviceId = %s", pd.deviceId);
    writefln("name = %s", pd.name);
    writefln("type = %s", pd.type);
    writefln("mem props = %s", pd.memoryProperties);
    writefln("queue families = %s", pd.queueFamilies);
    writefln("window surface support: %s", pd.supportsSurface(0, win.surface));
    writefln("window surface caps: %s", pd.surfaceCaps(win.surface));
    writefln("window surface formats: %s", pd.surfaceFormats(win.surface));
    writefln("window surface presentModes: %s", pd.surfacePresentModes(win.surface));

    const qfInd = chooseQueue(pd);
    enforce (qfInd != invalidQueue, "Could not find a suitable graphics queue");

    auto dev = pd.open([QueueRequest(qfInd, [0.5])]).rc;

    const surfCaps = pd.surfaceCaps(win.surface);

    enforce(surfCaps.usage & ImageUsage.transferDst, "TransferDst not supported by surface");
    const usage = ImageUsage.transferDst | ImageUsage.colorAttachment;

    const numImages = max(2, surfCaps.minImages);
    enforce(surfCaps.maxImages == 0 || surfCaps.maxImages >= numImages);

    uint[2] swapChainSize = [ 640, 480 ];
    foreach (i; 0..2) {
        swapChainSize[i] = clamp(swapChainSize[i], surfCaps.minSize[i], surfCaps.maxSize[i]);
    }

    const pm = choosePresentMode(pd, win.surface);

    const f = chooseFormat(pd, win.surface);

    auto sc = dev.createSwapchain(win.surface, pm, numImages, f, swapChainSize, usage).rc;

    auto scImgs = sc.images;

    bool exitFlag;
    win.mouseOn = (uint, uint) {
        exitFlag = true;
    };

    while (!exitFlag) {
        win.waitAndDispatch();
        writeln("draw!");
    }

    return 0;
}


/// Returns the first device from instance that supports surface
PhysicalDevice chooseDevice(Instance instance, Surface surface)
{
    import std.algorithm : filter;
    import std.range : takeOne;
    auto devices = instance.devices()
        .filter!((PhysicalDevice pd) {
            if (pd.softwareRendering) return false;

            foreach (i, qf; pd.queueFamilies) {
                if (pd.supportsSurface(cast(uint)i, surface)) return true;
            }
            return false;
        })
        .takeOne;
    return devices.empty ? null : devices.front;
}

enum invalidQueue = uint.max;

/// Return the first queue index with graphics capability,
/// or invalidQueue if none is found
uint chooseQueue(PhysicalDevice pd) {
     foreach (i, qf; pd.queueFamilies) {
         if (qf.cap & QueueCap.graphics) return cast(uint)i;
     }
     return invalidQueue;
}

/// Return a format suitable for the surface.
///  - if supported by the surface Format.rgba8_uNorm
///  - otherwise the first format with uNorm numeric format
///  - otherwise the first format
Format chooseFormat(PhysicalDevice pd, Surface surface)
{
    auto formats = pd.surfaceFormats(surface);
    enforce(formats.length, "Could not get surface formats");
    if (formats.length == 1 && formats[0] == Format.undefined)
    {
        return Format.rgba8_uNorm;
    }
    foreach(f; formats) {
        if (f == Format.rgba8_uNorm) {
            return f;
        }
    }
    foreach(f; formats) {
        if (f.formatDesc.numFormat == NumFormat.uNorm) {
            return f;
        }
    }
    return formats[0];
}

PresentMode choosePresentMode(PhysicalDevice pd, Surface surface)
{
    auto modes = pd.surfacePresentModes(surface);
    if (modes.canFind(PresentMode.mailbox)) {
        return PresentMode.mailbox;
    }
    assert(modes.canFind(PresentMode.fifo));
    return PresentMode.fifo;
}
