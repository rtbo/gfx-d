module triangle;

import erupted;

import gfx.core.rc;
import gfx.graal.device;
import gfx.vulkan : createVulkanInstance;

import std.stdio;

int main() {
    auto instance = createVulkanInstance("Triangle").rc;

    auto physicalDevices = instance.devices();
    retainArray(physicalDevices);
    scope(exit) releaseArray(physicalDevices);

    foreach (pd; physicalDevices) {
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
    }

    return 0;
}
