module triangle;

import erupted;

import gfx.core.rc;
import gfx.graal.device;
import gfx.vulkan;

import std.algorithm;
import std.exception;
import std.stdio;

int main() {
    vulkanInit();

    writeln("layers:");
    vulkanInstanceLayers.each!(writeln);
    writeln("extensions:");
    vulkanInstanceExtensions.each!(writeln);

    version(Windows) {
        const extensions = surfaceInstanceExtensions(VulkanPlatform.win32);
    }
    else version(linux) {
        const extensions = surfaceInstanceExtensions(VulkanPlatform.xcb);
    }
    else {
        static assert(false, "unsupported platform");
    }

    debug {
        enum layers = lunarGValidationLayers;
    }
    else {
        enum string[] layers = [];
    }

    auto instance = createVulkanInstance(
        layers, extensions, "Triangle", VulkanVersion(0, 0, 1)
    ).rc;

    auto physicalDevices = instance.devices();
    retainArray(physicalDevices);
    scope(exit) releaseArray(physicalDevices);

    foreach (pd; physicalDevices) {
        writeln("device layers:");
        pd.vulkanDeviceLayers.each!(writeln);
        writeln("device extensions:");
        pd.vulkanDeviceExtensions.each!(writeln);

        writefln("apiVersion = %s", pd.apiVersion);
        writefln("driverVersion = %s", pd.driverVersion);
        writefln("vendorId = %s", pd.vendorId);
        writefln("deviceId = %s", pd.deviceId);
        writefln("name = %s", pd.name);
        writefln("type = %s", pd.type);
        writefln("mem props = %s", pd.memoryProperties);
        writefln("queue families = %s", pd.queueFamilies);

        pd.setDeviceOpenVulkanLayers(layers);
        pd.setDeviceOpenVulkanExtensions([ swapChainExtension ]);

        auto dev = pd.open([QueueRequest(0, 0.5)]).rc;
        auto mem = dev.allocateMemory(0, 2*1024*1024).rc;
        writefln("mem size: %s", mem.size);
    }

    return 0;
}
