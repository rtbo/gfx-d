module gfx.gl3;

import gfx.graal : Instance;
import gfx.graal.device : PhysicalDevice;

class GlInstance : Instance
{
    import gfx.core.rc : atomicRcCode, Rc;
    import gfx.graal : ApiProps, CoordSystem;

    mixin(atomicRcCode);

    this() {
        //phd = new GlPhysicalDevice;
    }

    override void dispose() {
        phd.unload();
    }

    override @property ApiProps apiProps() {
        return ApiProps(
            "gl3", CoordSystem.leftHanded
        );
    }

    override PhysicalDevice[] devices() {
        return [ ];
    }

    private Rc!PhysicalDevice phd;
}

// class GlPhysicalDevice : PhysicalDevice
// {
//     import gfx.core.rc : atomicRcCode;
//     import gfx.graal.device : Device, DeviceFeatures, DeviceLimits, DeviceType;
//     import gfx.graal.format : Format, FormatProperties;
//     import gfx.graal.memory : MemoryProperties;
//     import gfx.graal.queue : QueueFamily, QueueRequest;
//     import gfx.graal.presentation : PresentMode, Surface, SurfaceCaps;

//     mixin(atomicRcCode);

//     this() {}

//     override void dispose() {}

//     override @property uint apiVersion();

//     override @property uint driverVersion();

//     override @property uint vendorId();

//     override @property uint deviceId();

//     override @property string name();

//     override @property DeviceType type();

//     override @property DeviceFeatures features();

//     override @property DeviceLimits limits();

//     override @property MemoryProperties memoryProperties();

//     override @property QueueFamily[] queueFamilies();

//     override FormatProperties formatProperties(in Format format);

//     override bool supportsSurface(uint queueFamilyIndex, Surface surface);
//     override SurfaceCaps surfaceCaps(Surface surface);
//     override Format[] surfaceFormats(Surface surface);
//     override PresentMode[] surfacePresentModes(Surface surface);

//     /// Open a logical device with the specified queues.
//     /// Returns: null if it can't meet all requested queues, the opened device otherwise.
//     override Device open(in QueueRequest[] queues, in DeviceFeatures features=DeviceFeatures.all)
//     {
//         return null;
//     }
// }
