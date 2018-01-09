/// Vulkan implementation of GrAAL
module gfx.vulkan;

import erupted;

import gfx.graal;

/// Creates an Instance object with Vulkan backend
VulkanInstance createVulkanInstance(in string appName="", in uint appVersion=0)
{
    import gfx : gfxVersionMaj, gfxVersionMin, gfxVersionMic;
    import std.string : toStringz;

    DerelictErupted.load();

    VkApplicationInfo ai;
    ai.sType = VK_STRUCTURE_TYPE_APPLICATION_INFO;
    if (appName.length) {
        ai.pApplicationName = toStringz(appName);
    }
    ai.applicationVersion = appVersion;
    ai.pEngineName = "gfx-d\n".ptr;
    ai.engineVersion = VK_MAKE_VERSION(gfxVersionMaj, gfxVersionMin, gfxVersionMic);

    VkInstanceCreateInfo ici;
    ici.sType = VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO;
    ici.pApplicationInfo = &ai;

    VkInstance vkInst;
    vulkanEnforce(vkCreateInstance(&ici, null, &vkInst), "Could not create Vulkan instance");

    loadInstanceLevelFunctions(vkInst);
    loadDeviceLevelFunctions(vkInst);

    return new VulkanInstance(vkInst);
}

package:

import gfx.core.rc;
import gfx.graal.device;
import gfx.graal.format;
import gfx.graal.memory;
import gfx.graal.queue;
import gfx.vulkan.conv;
import gfx.vulkan.device;
import gfx.vulkan.error;


class VulkanObj(VkType, alias destroyFn) : Disposable
{
    this (VkType vk) {
        _vk = vk;
    }

    override void dispose() {
        destroyFn(_vk, null);
    }

    final @property VkType vk() {
        return _vk;
    }

    private VkType _vk;
}


immutable deviceExtensions = [
    VK_KHR_SWAPCHAIN_EXTENSION_NAME
];


class VulkanInstance : VulkanObj!(VkInstance, vkDestroyInstance), Instance
{
    mixin(atomicRcCode);

    this(VkInstance vk) {
        super(vk);
    }

    override PhysicalDevice[] devices()
    {
        import std.array : array, uninitializedArray;
        uint count;
        vulkanEnforce(vkEnumeratePhysicalDevices(vk, &count, null),
                "Could not enumerate Vulkan devices");
        auto devices = uninitializedArray!(VkPhysicalDevice[])(count);
        vulkanEnforce(vkEnumeratePhysicalDevices(vk, &count, devices.ptr),
                "Could not enumerate Vulkan devices");

        import std.algorithm : map;
        return devices
            .map!(d => cast(PhysicalDevice)(new VulkanPhysicalDevice(d, this)))
            .array;
    }
}

class VulkanPhysicalDevice : PhysicalDevice
{
    mixin(atomicRcCode);

    this(VkPhysicalDevice vk, VulkanInstance inst) {
        _vk = vk;
        _inst = inst;
        _inst.retain();

        vkGetPhysicalDeviceProperties(_vk, &_vkProps);
    }

    override void dispose() {
        _inst.release();
        _inst = null;
    }

    override @property uint apiVersion() {
        return _vkProps.apiVersion;
    }
    override @property uint driverVersion() {
        return _vkProps.driverVersion;
    }
    override @property uint vendorId() {
        return _vkProps.vendorID;
    }
    override @property uint deviceId() {
        return _vkProps.deviceID;
    }
    override @property string name() {
        import std.string : fromStringz;
        return fromStringz(_vkProps.deviceName.ptr).idup;
    }
    override @property DeviceType type() {
        return devTypeFromVk(_vkProps.deviceType);
    }
    override @property DeviceFeatures features() {
        return DeviceFeatures.init;
    }
    override @property DeviceLimits limits() {
        return DeviceLimits.init;
    }

    override @property MemoryProperties memoryProperties()
    {
        VkPhysicalDeviceMemoryProperties vkProps=void;
        vkGetPhysicalDeviceMemoryProperties(_vk, &vkProps);

        MemoryProperties props;

        foreach(i; 0 .. vkProps.memoryHeapCount) {
            const vkHeap = vkProps.memoryHeaps[i];
            props.heaps ~= MemoryHeap(
                vkHeap.size, cast(MemProps)0, (vkHeap.flags & VK_MEMORY_HEAP_DEVICE_LOCAL_BIT) != 0
            );
        }
        foreach(i; 0 .. vkProps.memoryTypeCount) {
            const vkMemType = vkProps.memoryTypes[i];
            const type = MemoryType(
                i, vkMemType.heapIndex, props.heaps[vkMemType.heapIndex].size,
                memPropsFromVk(vkMemType.propertyFlags)
            );
            props.types ~= type;
            props.heaps[i].props |= type.props;
        }

        return props;
    }

    override @property QueueFamily[] queueFamilies()
    {
        import std.array : array, uninitializedArray;
        uint count;
        vkGetPhysicalDeviceQueueFamilyProperties(_vk, &count, null);

        auto vkQueueFams = uninitializedArray!(VkQueueFamilyProperties[])(count);
        vkGetPhysicalDeviceQueueFamilyProperties(_vk, &count, vkQueueFams.ptr);

        import std.algorithm : map;
        return vkQueueFams.map!(vk => QueueFamily(
            queueCapFromVk(vk.queueFlags), vk.queueCount
        )).array;
    }

    override FormatProperties formatProperties(in Format format)
    {
        VkFormatProperties vkFp;
        vkGetPhysicalDeviceFormatProperties(_vk, format.toVk(), &vkFp);

        return FormatProperties(
            vkFp.linearTilingFeatures.fromVk(),
            vkFp.optimalTilingFeatures.fromVk(),
            vkFp.bufferFeatures.fromVk(),
        );
    }

    override Device open(in QueueRequest[] queues)
    {
        import std.algorithm : map, sort;
        import std.array : array;
        import std.exception : enforce;
        import std.string : toStringz;

        if (!queues.length) {
            return null;
        }

        auto ordered = queues.dup;
        ordered.sort!"a.familyIndex < b.familyIndex"();

        struct Req {
            uint fam;
            float[] prios;
        }

        Req[] reqs = [ Req( ordered[0].familyIndex, [ ordered[0].priority ] ) ];
        foreach (const qr; ordered[1 .. $]) {
            if (qr.familyIndex == reqs[$-1].fam) {
                reqs[$-1].prios ~= qr.priority;
            }
            else {
                reqs ~= Req( qr.familyIndex, [ qr.priority ]);
            }
        }

        const qcis = reqs.map!((Req r) {
            VkDeviceQueueCreateInfo qci;
            qci.sType = VK_STRUCTURE_TYPE_DEVICE_QUEUE_CREATE_INFO;
            qci.queueFamilyIndex = r.fam;
            qci.queueCount = cast(uint)r.prios.length;
            qci.pQueuePriorities = r.prios.ptr;
            return qci;
        }).array;

        const extensions = deviceExtensions.map!toStringz.array;

        VkDeviceCreateInfo ci;
        ci.sType = VK_STRUCTURE_TYPE_DEVICE_CREATE_INFO;
        ci.queueCreateInfoCount = cast(uint)qcis.length;
        ci.pQueueCreateInfos = qcis.ptr;
        ci.enabledExtensionCount = cast(uint)extensions.length;
        ci.ppEnabledExtensionNames = extensions.ptr;

        VkDevice vkDev;
        vulkanEnforce(vkCreateDevice(_vk, &ci, null, &vkDev),
                "Vulkan device creation failed");

        return new VulkanDevice(vkDev, this);
    }

    private VkPhysicalDevice _vk;
    private VkPhysicalDeviceProperties _vkProps;
    private VulkanInstance _inst;
}

DeviceType devTypeFromVk(in VkPhysicalDeviceType vkType)
{
    switch (vkType) {
    case VK_PHYSICAL_DEVICE_TYPE_OTHER:
        return DeviceType.other;
    case VK_PHYSICAL_DEVICE_TYPE_INTEGRATED_GPU:
        return DeviceType.integratedGpu;
    case VK_PHYSICAL_DEVICE_TYPE_DISCRETE_GPU:
        return DeviceType.discreteGpu;
    case VK_PHYSICAL_DEVICE_TYPE_VIRTUAL_GPU:
        return DeviceType.virtualGpu;
    case VK_PHYSICAL_DEVICE_TYPE_CPU:
        return DeviceType.cpu;
    default:
        assert(false, "unexpected vulkan device type constant");
    }
}
