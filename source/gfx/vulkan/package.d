/// Vulkan implementation of GrAAL
module gfx.vulkan;

import erupted;

import gfx.graal;


// some standard layers

enum lunarGValidationLayers = [
    "VK_LAYER_LUNARG_core_validation",
    "VK_LAYER_LUNARG_standard_validation",
    "VK_LAYER_LUNARG_parameter_validation",
];

// instance level extensions

enum surfaceExtension = "VK_KHR_surface";

version(Windows) {
    enum win32SurfaceExtension = "VK_KHR_win32_surface";
}
version(linux) {
    enum xlibSurfaceExtension = "VK_KHR_xlib_surface";
    enum xcbSurfaceExtension = "VK_KHR_xcb_surface";
}

// device level extensions

enum swapChainExtension = "VK_KHR_swapchain";


version(GfxVulkanXcb) {
    enum surfaceInstanceExtensions = [
        surfaceExtension, xcbSurfaceExtension
    ];
}
version(GfxVulkanWin32) {
    enum surfaceInstanceExtensions = [
        surfaceExtension, win32SurfaceExtension
    ];
}
version(GfxOffscreen) {
    enum surfaceInstanceExtensions = [];
}

/// Load global level vulkan functions, and instance level layers and extensions
/// This function must be called before any other in this module
void vulkanInit()
{
    DerelictErupted.load();
    _instanceLayers = loadInstanceLayers();
    _instanceExtensions = loadInstanceExtensions();
}

struct VulkanVersion
{
    import std.bitmanip : bitfields;
    mixin(bitfields!(
        uint, "patch", 12,
        uint, "minor", 10,
        uint, "major", 10,
    ));

    this (in uint major, in uint minor, in uint patch) {
        this.major = major; this.minor = minor; this.patch = patch;
    }

    this (in uint vkVer) {
        this(VK_VERSION_MAJOR(vkVer), VK_VERSION_MINOR(vkVer), VK_VERSION_PATCH(vkVer));
    }

    static VulkanVersion fromUint(in uint vkVer) {
        return *cast(VulkanVersion*)(cast(void*)&vkVer);
    }

    uint toUint() const {
        return *cast(uint*)(cast(void*)&this);
    }

    string toString() {
        import std.format : format;
        return format("VulkanVersion(%s, %s, %s)", this.major, this.minor, this.patch);
    }
}

unittest {
    const vkVer = VK_MAKE_VERSION(12, 7, 38);
    auto vv = VulkanVersion.fromUint(vkVer);
    assert(vv.major == 12);
    assert(vv.minor == 7);
    assert(vv.patch == 38);
    assert(vv.toUint() == vkVer);
}

struct VulkanLayerProperties
{
    string layerName;
    VulkanVersion specVer;
    VulkanVersion implVer;
    string description;

    @property VulkanExtensionProperties[] instanceExtensions()
    {
        return loadInstanceExtensions(layerName);
    }
}

struct VulkanExtensionProperties
{
    string extensionName;
    VulkanVersion specVer;
}

/// Retrieve available instance level layer properties
@property VulkanLayerProperties[] vulkanInstanceLayers() {
    return _instanceLayers;
}
/// Retrieve available instance level extensions properties
@property VulkanExtensionProperties[] vulkanInstanceExtensions()
{
    return _instanceExtensions;
}

/// Creates a vulkan instance with default layers and extensions
VulkanInstance createVulkanInstance(in string appName=null,
                                    in VulkanVersion appVersion=VulkanVersion(0, 0, 0))
{
    debug {
        const layers = lunarGValidationLayers;
    }
    else {
        const string[] layers = [];
    }

    return createVulkanInstance(layers, surfaceInstanceExtensions, appName, appVersion);
}

/// Creates an Instance object with Vulkan backend with user specified layers and extensions
VulkanInstance createVulkanInstance(in string[] layers, in string[] extensions,
                                    in string appName=null,
                                    in VulkanVersion appVersion=VulkanVersion(0, 0, 0))
{
    import gfx : gfxVersionMaj, gfxVersionMin, gfxVersionMic;
    import std.algorithm : all, canFind, map;
    import std.array : array;
    import std.exception : enforce;
    import std.string : toStringz;

    // throw if some requested layers or extensions are not available
    // TODO: specific exception
    foreach (l; layers) {
        enforce(
            _instanceLayers.map!(il => il.layerName).canFind(l),
            "Could not find layer " ~ l ~ " when creating Vulkan instance"
        );
    }
    foreach (e; extensions) {
        enforce(
            _instanceExtensions.map!(ie => ie.extensionName).canFind(e),
            "Could not find extension " ~ e ~ " when creating Vulkan instance"
        );
    }

    VkApplicationInfo ai;
    ai.sType = VK_STRUCTURE_TYPE_APPLICATION_INFO;
    if (appName.length) {
        ai.pApplicationName = toStringz(appName);
    }
    ai.applicationVersion = appVersion.toUint();
    ai.pEngineName = "gfx-d\n".ptr;
    ai.engineVersion = VK_MAKE_VERSION(gfxVersionMaj, gfxVersionMin, gfxVersionMic);

    auto vkLayers = layers.map!toStringz.array;
    auto vkExts = extensions.map!toStringz.array;

    VkInstanceCreateInfo ici;
    ici.sType = VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO;
    ici.pApplicationInfo = &ai;
    ici.enabledLayerCount = cast(uint)vkLayers.length;
    ici.ppEnabledLayerNames = &vkLayers[0];
    ici.enabledExtensionCount = cast(uint)vkExts.length;
    ici.ppEnabledExtensionNames = &vkExts[0];

    VkInstance vkInst;
    vulkanEnforce(vkCreateInstance(&ici, null, &vkInst), "Could not create Vulkan instance");

    loadInstanceLevelFunctions(vkInst);
    loadDeviceLevelFunctions(vkInst);

    return new VulkanInstance(vkInst);
}

/// Retrieve available device level layers
@property VulkanLayerProperties[] vulkanDeviceLayers(PhysicalDevice device) {
    auto pd = cast(VulkanPhysicalDevice)device;
    if (!pd) return [];

    return pd._availableLayers;
}
/// Retrieve available instance level extensions properties
VulkanExtensionProperties[] vulkanDeviceExtensions(PhysicalDevice device, in string layerName=null)
{
    auto pd = cast(VulkanPhysicalDevice)device;
    if (!pd) return [];

    if (!layerName) {
        return pd._availableExtensions;
    }
    else {
        return pd.loadDeviceExtensions(layerName);
    }
}

void overrideDeviceOpenVulkanLayers(PhysicalDevice device, string[] layers)
{
    auto pd = cast(VulkanPhysicalDevice)device;
    if (!pd) return;

    pd._openLayers = layers;
}

void overrideDeviceOpenVulkanExtensions(PhysicalDevice device, string[] extensions)
{
    auto pd = cast(VulkanPhysicalDevice)device;
    if (!pd) return;

    pd._openExtensions = extensions;
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

__gshared VulkanLayerProperties[] _instanceLayers;
__gshared VulkanExtensionProperties[] _instanceExtensions;

VulkanLayerProperties[] loadInstanceLayers()
{
    uint count;
    vulkanEnforce(
        vkEnumerateInstanceLayerProperties(&count, null),
        "Could not retrieve Vulkan instance layers"
    );
    if (!count) return[];

    auto vkLayers = new VkLayerProperties[count];
    vulkanEnforce(
        vkEnumerateInstanceLayerProperties(&count, &vkLayers[0]),
        "Could not retrieve Vulkan instance layers"
    );

    import std.algorithm : map;
    import std.array : array;
    import std.string : fromStringz;

    return vkLayers
            .map!((ref VkLayerProperties vkLp) {
                return VulkanLayerProperties(
                    fromStringz(&vkLp.layerName[0]).idup,
                    VulkanVersion.fromUint(vkLp.specVersion),
                    VulkanVersion.fromUint(vkLp.implementationVersion),
                    fromStringz(&vkLp.description[0]).idup,
                );
            })
            .array;
}

VulkanExtensionProperties[] loadInstanceExtensions(in string layerName=null)
{
    import std.string : toStringz;

    const(char)* layer;
    if (layerName.length) {
        layer = toStringz(layerName);
    }
    uint count;
    vulkanEnforce(
        vkEnumerateInstanceExtensionProperties(layer, &count, null),
        "Could not retrieve Vulkan instance extensions"
    );
    if (!count) return[];

    auto vkExts = new VkExtensionProperties[count];
    vulkanEnforce(
        vkEnumerateInstanceExtensionProperties(layer, &count, &vkExts[0]),
        "Could not retrieve Vulkan instance extensions"
    );

    import std.algorithm : map;
    import std.array : array;
    import std.string : fromStringz;

    return vkExts
            .map!((ref VkExtensionProperties vkExt) {
                return VulkanExtensionProperties(
                    fromStringz(&vkExt.extensionName[0]).idup,
                    VulkanVersion.fromUint(vkExt.specVersion)
                );
            })
            .array;
}

VulkanLayerProperties[] loadDeviceLayers(VulkanPhysicalDevice pd)
{
    uint count;
    vulkanEnforce(
        vkEnumerateDeviceLayerProperties(pd.vk, &count, null),
        "Could not retrieve Vulkan device layers"
    );
    if (!count) return[];

    auto vkLayers = new VkLayerProperties[count];
    vulkanEnforce(
        vkEnumerateDeviceLayerProperties(pd.vk, &count, &vkLayers[0]),
        "Could not retrieve Vulkan device layers"
    );

    import std.algorithm : map;
    import std.array : array;
    import std.string : fromStringz;

    return vkLayers
            .map!((ref VkLayerProperties vkLp) {
                return VulkanLayerProperties(
                    fromStringz(&vkLp.layerName[0]).idup,
                    VulkanVersion.fromUint(vkLp.specVersion),
                    VulkanVersion.fromUint(vkLp.implementationVersion),
                    fromStringz(&vkLp.description[0]).idup,
                );
            })
            .array;
}

VulkanExtensionProperties[] loadDeviceExtensions(VulkanPhysicalDevice pd, in string layerName=null)
{
    import std.string : toStringz;

    const(char)* layer;
    if (layerName.length) {
        layer = toStringz(layerName);
    }

    uint count;
    vulkanEnforce(
        vkEnumerateDeviceExtensionProperties(pd.vk, layer, &count, null),
        "Could not retrieve Vulkan device extensions"
    );
    if (!count) return[];

    auto vkExts = new VkExtensionProperties[count];
    vulkanEnforce(
        vkEnumerateDeviceExtensionProperties(pd.vk, layer, &count, &vkExts[0]),
        "Could not retrieve Vulkan device extensions"
    );

    import std.algorithm : map;
    import std.array : array;
    import std.string : fromStringz;

    return vkExts
            .map!((ref VkExtensionProperties vkExt) {
                return VulkanExtensionProperties(
                    fromStringz(&vkExt.extensionName[0]).idup,
                    VulkanVersion.fromUint(vkExt.specVersion)
                );
            })
            .array;
}

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

        _availableLayers = loadDeviceLayers(this);
        _availableExtensions = loadDeviceExtensions(this);

        import std.algorithm : canFind, map;
        import std.exception : enforce;
        debug {
            foreach (l; lunarGValidationLayers) {
                if (_availableLayers.map!"a.layerName".canFind(l)) {
                    _openLayers ~= l;
                }
            }
        }
        version(GfxOffscreen) {}
        else {
            enforce(_availableExtensions.map!"a.extensionName".canFind(swapChainExtension));
            _openExtensions ~= swapChainExtension;
        }
    }

    override void dispose() {
        _inst.release();
        _inst = null;
    }

    @property VkPhysicalDevice vk() {
        return _vk;
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
        import std.algorithm : canFind, map;

        auto exts = vulkanDeviceExtensions(this);

        DeviceFeatures features;
        features.presentation = exts
                .map!(e => e.extensionName)
                .canFind(swapChainExtension);
        return features;
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

        const layers = _openLayers.map!toStringz.array;
        const extensions = _openExtensions.map!toStringz.array;

        VkDeviceCreateInfo ci;
        ci.sType = VK_STRUCTURE_TYPE_DEVICE_CREATE_INFO;
        ci.queueCreateInfoCount = cast(uint)qcis.length;
        ci.pQueueCreateInfos = qcis.ptr;
        ci.enabledLayerCount = cast(uint)layers.length;
        ci.ppEnabledLayerNames = &layers[0];
        ci.enabledExtensionCount = cast(uint)extensions.length;
        ci.ppEnabledExtensionNames = &extensions[0];

        VkDevice vkDev;
        vulkanEnforce(vkCreateDevice(_vk, &ci, null, &vkDev),
                "Vulkan device creation failed");

        return new VulkanDevice(vkDev, this);
    }

    private VkPhysicalDevice _vk;
    private VkPhysicalDeviceProperties _vkProps;
    private VulkanInstance _inst;

    private VulkanLayerProperties[] _availableLayers;
    private VulkanExtensionProperties[] _availableExtensions;

    private string[] _openLayers;
    private string[] _openExtensions;
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
