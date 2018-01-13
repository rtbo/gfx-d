module triangle;

import erupted;

import gfx.core.rc;
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

        auto dev = pd.open([QueueRequest(0, 0.5)]).rc;
        auto mem = dev.allocateMemory(0, 2*1024*1024).rc;
        writefln("mem size: %s", mem.size);

        writefln("window surface support: %s", pd.supportsSurface(0, win.surface));
    }

    return 0;
}
