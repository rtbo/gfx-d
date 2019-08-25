/// Vulkan implementation of GrAAL
module gfx.vulkan;

import gfx.bindings.vulkan;
import gfx.core.log : LogTag;
import gfx.graal;

enum gfxVkLogMask = 0x2000_0000;
package(gfx) immutable gfxVkLog = LogTag("GFX-VK", gfxVkLogMask);

// some standard layers

immutable lunarGValidationLayers = [
    "VK_LAYER_LUNARG_core_validation",
    "VK_LAYER_LUNARG_standard_validation",
    "VK_LAYER_LUNARG_parameter_validation",
];

immutable debugReportInstanceExtensions = [
    "VK_KHR_debug_report", "VK_EXT_debug_report"
];

@property ApiProps vulkanApiProps()
{
    import gfx.math.proj : ndc, XYClip, ZClip;

    return ApiProps(
        "vulkan", ndc(XYClip.rightHand, ZClip.zeroToOne)
    );
}

/// Load global level vulkan functions, and instance level layers and extensions
/// This function must be called before any other in this module
void vulkanInit()
{
    _globCmds = loadVulkanGlobalCmds();
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

debug {
    private immutable defaultLayers = lunarGValidationLayers;
    private immutable defaultExts = debugReportInstanceExtensions ~ surfaceInstanceExtensions;
}
else {
    private immutable string[] defaultLayers = [];
    private immutable string[] defaultExts = surfaceInstanceExtensions;
}

/// Options to create a Vulkan instance.
struct VulkanCreateInfo
{
    /// Application name and version.
    string appName;
    /// ditto
    VulkanVersion appVersion = VulkanVersion(0, 0, 0);

    /// Mandatory layers that are needed by the application.
    /// Instance creation will fail if one is not present.
    const(string)[] mandatoryLayers;
    /// Optional layers that will be enabled if present.
    const(string)[] optionalLayers = defaultLayers;

    /// Mandatory extensions that are needed by the application.
    /// Instance creation will fail if one is not present.
    const(string)[] mandatoryExtensions;
    /// Optional extensions that will be enabled if present.
    const(string)[] optionalExtensions = defaultExts;
}

/// Creates an Instance object with Vulkan backend with options
VulkanInstance createVulkanInstance(VulkanCreateInfo createInfo=VulkanCreateInfo.init)
{
    import gfx : gfxVersionMaj, gfxVersionMin, gfxVersionMic;
    import std.algorithm : all, canFind, map;
    import std.array : array;
    import std.exception : enforce;
    import std.range : chain;
    import std.string : toStringz;

    // throw if some requested layers or extensions are not available
    // TODO: specific exception
    foreach (l; createInfo.mandatoryLayers) {
        enforce(
            _instanceLayers.map!(il => il.layerName).canFind(l),
            "Could not find layer " ~ l ~ " when creating Vulkan instance"
        );
    }
    foreach (e; createInfo.mandatoryExtensions) {
        enforce(
            _instanceExtensions.map!(ie => ie.extensionName).canFind(e),
            "Could not find extension " ~ e ~ " when creating Vulkan instance"
        );
    }

    const(string)[] layers = createInfo.mandatoryLayers;
    foreach (l; createInfo.optionalLayers) {
        if (_instanceLayers.map!(il => il.layerName).canFind(l)) {
            layers ~= l;
        }
        else {
            gfxVkLog.warningf("Optional layer %s is not present and won't be enabled", l);
        }
    }

    const(string)[] extensions = createInfo.mandatoryExtensions;
    foreach (e; createInfo.optionalExtensions) {
        if (_instanceExtensions.map!(ie => ie.extensionName).canFind(e)) {
            extensions ~= e;
        }
        else {
            gfxVkLog.warningf("Optional extension %s is not present and won't be enabled", e);
        }
    }

    VkApplicationInfo ai;
    ai.sType = VK_STRUCTURE_TYPE_APPLICATION_INFO;
    if (createInfo.appName.length) {
        ai.pApplicationName = toStringz(createInfo.appName);
    }
    ai.applicationVersion = createInfo.appVersion.toUint();
    ai.pEngineName = "gfx-d\0".ptr;
    ai.engineVersion = VK_MAKE_VERSION(gfxVersionMaj, gfxVersionMin, gfxVersionMic);
    ai.apiVersion = VK_API_VERSION_1_0;

    const vkLayers = layers.map!toStringz.array;
    const vkExts = extensions.map!toStringz.array;

    gfxVkLog.info("Opening Vulkan instance.");
    gfxVkLog.infof("Vulkan layers:%s", layers.length?"":" none");
    foreach (l; layers) {
        gfxVkLog.infof("    %s", l);
    }
    gfxVkLog.infof("Vulkan extensions:%s", extensions.length?"":" none");
    import std.algorithm : canFind, filter, map;
    import std.array : array;
    import std.range : chain;
    foreach (e; extensions) {
        gfxVkLog.infof("    %s", e);
    }

    VkInstanceCreateInfo ici;
    ici.sType = VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO;
    ici.pApplicationInfo = &ai;
    ici.enabledLayerCount = cast(uint)vkLayers.length;
    ici.ppEnabledLayerNames = vkLayers.ptr;
    ici.enabledExtensionCount = cast(uint)vkExts.length;
    ici.ppEnabledExtensionNames = vkExts.ptr;

    auto vk = _globCmds;
    VkInstance vkInst;
    vulkanEnforce(vk.CreateInstance(&ici, null, &vkInst), "Could not create Vulkan instance");

    return new VulkanInstance(vkInst, layers, extensions);
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
import gfx.graal.presentation;
import gfx.graal.queue;
import gfx.vulkan.conv;
import gfx.vulkan.device;
import gfx.vulkan.error;
import gfx.vulkan.wsi : VulkanSurface;

import std.exception : enforce;

__gshared VkGlobalCmds _globCmds;
__gshared VulkanLayerProperties[] _instanceLayers;
__gshared VulkanExtensionProperties[] _instanceExtensions;

VulkanLayerProperties[] loadInstanceLayers()
{
    auto vk = _globCmds;
    uint count;
    vulkanEnforce(
        vk.EnumerateInstanceLayerProperties(&count, null),
        "Could not retrieve Vulkan instance layers"
    );
    if (!count) return[];

    auto vkLayers = new VkLayerProperties[count];
    vulkanEnforce(
        vk.EnumerateInstanceLayerProperties(&count, &vkLayers[0]),
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
    auto vk = _globCmds;
    uint count;
    vulkanEnforce(
        vk.EnumerateInstanceExtensionProperties(layer, &count, null),
        "Could not retrieve Vulkan instance extensions"
    );
    if (!count) return[];

    auto vkExts = new VkExtensionProperties[count];
    vulkanEnforce(
        vk.EnumerateInstanceExtensionProperties(layer, &count, &vkExts[0]),
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
    auto vk = pd.vk;
    uint count;
    vulkanEnforce(
        vk.EnumerateDeviceLayerProperties(pd.vkObj, &count, null),
        "Could not retrieve Vulkan device layers"
    );
    if (!count) return[];

    auto vkLayers = new VkLayerProperties[count];
    vulkanEnforce(
        vk.EnumerateDeviceLayerProperties(pd.vkObj, &count, &vkLayers[0]),
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

    auto vk = pd.vk;
    uint count;
    vulkanEnforce(
        vk.EnumerateDeviceExtensionProperties(pd.vkObj, layer, &count, null),
        "Could not retrieve Vulkan device extensions"
    );
    if (!count) return[];

    auto vkExts = new VkExtensionProperties[count];
    vulkanEnforce(
        vk.EnumerateDeviceExtensionProperties(pd.vkObj, layer, &count, &vkExts[0]),
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

class VulkanObj(VkType)
{
    this (VkType vkObj) {
        _vkObj = vkObj;
    }

    final @property VkType vkObj() {
        return _vkObj;
    }

    private VkType _vkObj;
}

class VulkanInstObj(VkType) : Disposable
{
    this (VkType vkObj, VulkanInstance inst)
    {
        _vkObj = vkObj;
        _inst = inst;
        _inst.retain();
    }

    override void dispose() {
        _inst.release();
        _inst = null;
    }

    final @property VkType vkObj() {
        return _vkObj;
    }

    final @property VulkanInstance inst() {
        return _inst;
    }

    final @property VkInstance vkInst() {
        return _inst.vkObj;
    }

    private VkType _vkObj;
    private VulkanInstance _inst;
}

final class VulkanInstance : VulkanObj!(VkInstance), Instance
{
    mixin(atomicRcCode);

    this(VkInstance vkObj, in string[] layers, in string[] extensions) {
        super(vkObj);
        _vk = new VkInstanceCmds(vkObj, _globCmds);
        this.layers = layers;
        this.extensions = extensions;
    }

    override void dispose() {
        if (_vkCb) {
            vk.DestroyDebugReportCallbackEXT(vkObj, _vkCb, null);
            _vkCb = VK_NULL_ND_HANDLE;
            _callback = null;
        }
        vk.DestroyInstance(vkObj, null);
    }

    override @property Backend backend() {
        return Backend.vulkan;
    }

    override @property ApiProps apiProps() {
        return vulkanApiProps;
    }

    @property VkInstanceCmds vk() {
        return _vk;
    }

    override PhysicalDevice[] devices()
    {
        import std.algorithm : map;
        import std.array : array, uninitializedArray;

        if (!_phDs.length) {
            uint count;
            vulkanEnforce(vk.EnumeratePhysicalDevices(vkObj, &count, null),
                    "Could not enumerate Vulkan devices");
            auto devices = uninitializedArray!(VkPhysicalDevice[])(count);
            vulkanEnforce(vk.EnumeratePhysicalDevices(vkObj, &count, devices.ptr),
                    "Could not enumerate Vulkan devices");

            _phDs = devices
                .map!(vkD => cast(PhysicalDevice)new VulkanPhysicalDevice(vkD, this))
                .array();
        }
        return _phDs;
    }

    override void setDebugCallback(DebugCallback callback) {
        VkDebugReportCallbackCreateInfoEXT ci;
        ci.sType = VK_STRUCTURE_TYPE_DEBUG_REPORT_CALLBACK_CREATE_INFO_EXT;
        ci.flags = 0x1f;
        ci.pfnCallback = &gfxd_vk_DebugReportCallback;
        ci.pUserData = cast(void*)this;

        vk.CreateDebugReportCallbackEXT(vkObj, &ci, null, &_vkCb);
        _callback = callback;
    }

    /// The layers enabled with this instance
    public const(string[]) layers;
    /// The extensions enabled with this instance
    public const(string[]) extensions;

    private VkInstanceCmds _vk;
    private PhysicalDevice[] _phDs;
    private VkDebugReportCallbackEXT _vkCb;
    private DebugCallback _callback;
}

extern(C) nothrow {
    VkBool32 gfxd_vk_DebugReportCallback(VkDebugReportFlagsEXT flags,
                                         VkDebugReportObjectTypeEXT /+objectType+/,
                                         ulong /+object+/,
                                         size_t /+location+/,
                                         int /+messageCode+/,
                                         const(char)* pLayerPrefix,
                                         const(char)* pMessage,
                                         void* pUserData)
    {
        auto vkInst = cast(VulkanInstance)pUserData;
        if (vkInst && vkInst._callback) {
            import gfx.vulkan.conv : debugReportFlagsToGfx;
            import std.string : fromStringz;
            try {
                vkInst._callback(debugReportFlagsToGfx(flags), fromStringz(pMessage).idup);
            }
            catch(Exception ex) {
                import std.exception : collectException;
                import std.stdio : stderr;
                collectException(
                    stderr.writefln("Exception thrown in debug callback: %s", ex.msg)
                );
            }
        }

        return VK_FALSE;
    }
}

final class VulkanPhysicalDevice : PhysicalDevice
{
    this(VkPhysicalDevice vkObj, VulkanInstance inst) {
        _vkObj = vkObj;
        _inst = inst;
        _vk = _inst.vk;

        vk.GetPhysicalDeviceProperties(_vkObj, &_vkProps);

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
            import gfx.vulkan.wsi : swapChainDeviceExtension;
            enforce(_availableExtensions.map!"a.extensionName".canFind(swapChainDeviceExtension));
            _openExtensions ~= swapChainDeviceExtension;
        }
    }

    @property VkPhysicalDevice vkObj() {
        return _vkObj;
    }

    @property VkInstanceCmds vk() {
        return _vk;
    }

    override @property Instance instance()
    {
        auto inst = lockObj(_inst);
        if (!inst) return null;
        return giveAwayObj(inst);
    }

    override @property string name() {
        import std.string : fromStringz;
        return fromStringz(_vkProps.deviceName.ptr).idup;
    }
    override @property DeviceType type() {
        return devTypeToGfx(_vkProps.deviceType);
    }
    override @property DeviceFeatures features() {
        import std.algorithm : canFind, map;
        import gfx.vulkan.wsi : swapChainDeviceExtension;

        VkPhysicalDeviceFeatures vkFeats;
        vk.GetPhysicalDeviceFeatures(vkObj, &vkFeats);

        DeviceFeatures features;
        features.anisotropy = vkFeats.samplerAnisotropy == VK_TRUE;
        features.presentation = vulkanDeviceExtensions(this)
                .map!(e => e.extensionName)
                .canFind(swapChainDeviceExtension);
        return features;
    }
    override @property DeviceLimits limits()
    {
        DeviceLimits limits;
        limits.linearOptimalGranularity =
                cast(size_t)_vkProps.limits.bufferImageGranularity;
        return limits;
    }

    override @property MemoryProperties memoryProperties()
    {
        VkPhysicalDeviceMemoryProperties vkProps=void;
        vk.GetPhysicalDeviceMemoryProperties(_vkObj, &vkProps);

        MemoryProperties props;

        foreach(i; 0 .. vkProps.memoryHeapCount) {
            const vkHeap = vkProps.memoryHeaps[i];
            props.heaps ~= MemoryHeap(
                cast(size_t)vkHeap.size, (vkHeap.flags & VK_MEMORY_HEAP_DEVICE_LOCAL_BIT) != 0
            );
        }
        foreach(i; 0 .. vkProps.memoryTypeCount) {
            const vkMemType = vkProps.memoryTypes[i];
            props.types ~= MemoryType(
                memPropsToGfx(vkMemType.propertyFlags),
                vkMemType.heapIndex,
            );
        }

        return props;
    }

    override @property QueueFamily[] queueFamilies()
    {
        import std.array : array, uninitializedArray;
        uint count;
        vk.GetPhysicalDeviceQueueFamilyProperties(_vkObj, &count, null);

        auto vkQueueFams = uninitializedArray!(VkQueueFamilyProperties[])(count);
        vk.GetPhysicalDeviceQueueFamilyProperties(_vkObj, &count, vkQueueFams.ptr);

        import std.algorithm : map;
        return vkQueueFams.map!(vkObj => QueueFamily(
            queueCapToGfx(vkObj.queueFlags), vkObj.queueCount
        )).array;
    }

    override FormatProperties formatProperties(in Format format)
    {
        VkFormatProperties vkFp;
        vk.GetPhysicalDeviceFormatProperties(_vkObj, format.toVk(), &vkFp);

        return FormatProperties(
            vkFp.linearTilingFeatures.toGfx(),
            vkFp.optimalTilingFeatures.toGfx(),
            vkFp.bufferFeatures.toGfx(),
        );
    }

    override bool supportsSurface(uint queueFamilyIndex, Surface graalSurface) {
        auto surf = enforce(
            cast(VulkanSurface)graalSurface,
            "Did not pass a Vulkan surface"
        );
        VkBool32 supported;
        vulkanEnforce(
            vk.GetPhysicalDeviceSurfaceSupportKHR(vkObj, queueFamilyIndex, surf.vkObj, &supported),
            "Could not query vulkan surface support"
        );
        return supported != VK_FALSE;
    }

    override SurfaceCaps surfaceCaps(Surface graalSurface) {
        auto surf = enforce(
            cast(VulkanSurface)graalSurface,
            "Did not pass a Vulkan surface"
        );
        VkSurfaceCapabilitiesKHR vkSc;
        vulkanEnforce(
            vk.GetPhysicalDeviceSurfaceCapabilitiesKHR(vkObj, surf.vkObj, &vkSc),
            "Could not query vulkan surface capabilities"
        );
        return vkSc.toGfx();
    }

    override Format[] surfaceFormats(Surface graalSurface) {
        auto surf = enforce(
            cast(VulkanSurface)graalSurface,
            "Did not pass a Vulkan surface"
        );

        uint count;
        vulkanEnforce(
            vk.GetPhysicalDeviceSurfaceFormatsKHR(vkObj, surf.vkObj, &count, null),
            "Could not query vulkan surface formats"
        );
        auto vkSf = new VkSurfaceFormatKHR[count];
        vulkanEnforce(
            vk.GetPhysicalDeviceSurfaceFormatsKHR(vkObj, surf.vkObj, &count, &vkSf[0]),
            "Could not query vulkan surface formats"
        );

        import std.algorithm : filter, map;
        import std.array : array;
        return vkSf
                .filter!(sf => sf.colorSpace == VK_COLOR_SPACE_SRGB_NONLINEAR_KHR)
                .map!(sf => sf.format.toGfx())
                .array;
    }

    override PresentMode[] surfacePresentModes(Surface graalSurface) {
        auto surf = enforce(
            cast(VulkanSurface)graalSurface,
            "Did not pass a Vulkan surface"
        );

        uint count;
        vulkanEnforce(
            vk.GetPhysicalDeviceSurfacePresentModesKHR(vkObj, surf.vkObj, &count, null),
            "Could not query vulkan surface present modes"
        );
        auto vkPms = new VkPresentModeKHR[count];
        vulkanEnforce(
            vk.GetPhysicalDeviceSurfacePresentModesKHR(vkObj, surf.vkObj, &count, &vkPms[0]),
            "Could not query vulkan surface present modes"
        );

        import std.algorithm : filter, map;
        import std.array : array;
        return vkPms
                .filter!(pm => pm.hasGfxSupport)
                .map!(pm => pm.toGfx())
                .array;
    }

    override Device open(in QueueRequest[] queues, in DeviceFeatures features=DeviceFeatures.all)
    {
        import std.algorithm : filter, map, sort;
        import std.array : array;
        import std.exception : enforce;
        import std.string : toStringz;
        import gfx.vulkan.wsi : swapChainDeviceExtension;

        if (!queues.length) {
            return null;
        }

        const qcis = queues.map!((const(QueueRequest) r) {
            VkDeviceQueueCreateInfo qci;
            qci.sType = VK_STRUCTURE_TYPE_DEVICE_QUEUE_CREATE_INFO;
            qci.queueFamilyIndex = r.familyIndex;
            qci.queueCount = cast(uint)r.priorities.length;
            qci.pQueuePriorities = r.priorities.ptr;
            return qci;
        }).array;

        const layers = _openLayers.map!toStringz.array;
        const extensions = _openExtensions
                .filter!(e => e != swapChainDeviceExtension || features.presentation)
                .map!toStringz.array;
        VkPhysicalDeviceFeatures vkFeats;
        vkFeats.samplerAnisotropy = features.anisotropy ? VK_TRUE : VK_FALSE;

        VkDeviceCreateInfo ci;
        ci.sType = VK_STRUCTURE_TYPE_DEVICE_CREATE_INFO;
        ci.queueCreateInfoCount = cast(uint)qcis.length;
        ci.pQueueCreateInfos = qcis.ptr;
        ci.enabledLayerCount = cast(uint)layers.length;
        ci.ppEnabledLayerNames = layers.ptr;
        ci.enabledExtensionCount = cast(uint)extensions.length;
        ci.ppEnabledExtensionNames = extensions.ptr;
        ci.pEnabledFeatures = &vkFeats;

        VkDevice vkDev;
        vulkanEnforce(vk.CreateDevice(_vkObj, &ci, null, &vkDev),
                "Vulkan device creation failed");

        return new VulkanDevice(vkDev, this, _inst);
    }

    private VkPhysicalDevice _vkObj;
    private VkPhysicalDeviceProperties _vkProps;
    private VulkanInstance _inst;

    private VkInstanceCmds _vk;

    private VulkanLayerProperties[] _availableLayers;
    private VulkanExtensionProperties[] _availableExtensions;

    private string[] _openLayers;
    private string[] _openExtensions;
}

DeviceType devTypeToGfx(in VkPhysicalDeviceType vkType)
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
