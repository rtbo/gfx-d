/// High level routines to handle Swapchain creation
module gfx.hl.surface;

import gfx.core.rc : AtomicRefCounted;
import gfx.graal.device : PhysicalDevice;
import gfx.graal.format : Format;
import gfx.graal.presentation : Surface;
import std.typecons : Flag, Yes;

// FIXME: not sure if this is the best approach to find a format
// FIXME: what the heck with ColorSpace in Vulkan?
/// Return a format suitable for the surface.
///  - if supported by the surface Format.rgba8_{uNorm, sRGB}
///  - otherwise the first format with {uNorm, sRGB} numeric format
///  - otherwise the first format
/// Returns: A format suitable for the surface
/// Throws: An Exception if no suitable format was found.
Format chooseSurfaceFormat(PhysicalDevice pd, Surface surface, Flag!"sRGB" sRGB = Yes.sRGB)
{
    import gfx.graal.format : formatDesc, NumFormat;
    import std.exception : enforce;

    const formats = pd.surfaceFormats(surface);
    enforce(formats.length, "Could not get surface formats");

    const favFormat = sRGB ? Format.rgba8_sRgb : Format.rgba8_uNorm;
    const favNumFormat = sRGB ? NumFormat.sRgb : NumFormat.uNorm;

    // the surface supports all kinds of formats
    if (formats.length == 1 && formats[0] == Format.undefined) {
        return favFormat;
    }

    foreach (f; formats) {
        if (f == favFormat) {
            return f;
        }
    }
    foreach (f; formats) {
        if (f.formatDesc.numFormat == favNumFormat) {
            return f;
        }
    }
    return formats[0];
}

/// GraphicsSurface is a high level entity on top of Graal.
/// It represent a single Surface and manages the associated Swapchain.
/// Most of the initialization is done during rebuild, so one
/// must not assume that the surface is functional before that point.
final class GraphicsSurface : AtomicRefCounted
{
    import core.time                : dur, Duration;
    import gfx.core.rc              : Rc, releaseArr, releaseObj, retainObj;
    import gfx.graal.device         : Device;
    import gfx.graal.format         : Format;
    import gfx.graal.image          : ImageBase, ImageView;
    import gfx.graal.presentation   : CompositeAlpha, ImageAcquisition,
                                      PresentMode, Surface, SurfaceCaps,
                                      Swapchain;
    import gfx.graal.sync           : Fence, Semaphore;

    private Rc!Device _device;
    private Rc!Surface _surface;
    private Rc!Semaphore _imageAvailSem;
    private Rc!Semaphore _renderingDoneSem;
    private Format _format;
    private SurfaceCaps _surfCaps;
    private PresentMode _presentMode;
    private CompositeAlpha _compAlpha;
    private uint _numImages;
    private uint[2] _size;
    //private bool _mustRebuildSwapchain;

    private Rc!Swapchain _swapchain;
    private PerImage[] _perImages;

    this(Device device, Surface surface, in Format format,
            in PresentMode presentMode, uint numImages = 0)
    {
        import gfx : gfxLog;

        _device = device;
        _surface = surface;
        _imageAvailSem = device.createSemaphore();
        _renderingDoneSem = device.createSemaphore();
        _format = format;
        _surfCaps = device.physicalDevice.surfaceCaps(surface);
        _numImages = numImages ? numImages : _surfCaps.minImages;
        if (_numImages < _surfCaps.minImages) {
            gfxLog.warningf("minimum swapchain images count is %s", _surfCaps.minImages);
            _numImages = _surfCaps.minImages;
        }
        else if (_surfCaps.maxImages != 0 && _surfCaps.maxImages < _numImages) {
            gfxLog.warningf("maximum swapchain images count is %s", _surfCaps.maxImages);
            _numImages = _surfCaps.maxImages;
        }
        _presentMode = presentMode;
        _compAlpha = findCompAlpha(_format, _surfCaps.supportedAlpha);
    }

    override void dispose()
    {
        import std.algorithm : each;

        _perImages.each!(pi => pi.release());
        _perImages = null;

        _swapchain.unload();
        _imageAvailSem.unload();
        _renderingDoneSem.unload();
        _surface.unload();
        _device.unload();
    }

    /// Rebuild the underlying swapchain with newSize.
    /// This must be called:
    /// - for initialization of the swapchain
    /// - if acquireNextImage result indicates that a rebuild is necessary
    void rebuild(in uint[2] newSize)
    {
        import gfx.core.rc : rc;
        import gfx.graal.image : ImageUsage;
        import std.algorithm : clamp;
        import std.exception : enforce;

        //if (swapchain && newSize == _size && !_mustRebuildSwapchain) return;

        uint[2] sz = void;
        static foreach (i; 0 .. 2) {
            sz[i] = clamp(newSize[i], _surfCaps.minSize[i], _surfCaps.maxSize[i]);
        }
        const usage = ImageUsage.colorAttachment;
        auto oldSc = _swapchain.obj;
        _swapchain = enforce(_device.createSwapchain(_surface.obj, _presentMode, _numImages,
                _format, sz, usage, _compAlpha, oldSc), "Could not create a swap chain").rc;

        _size = sz;

        // ensure we don't miss anything to release
        assert(_perImages.length == 0 || _perImages.length == _numImages);
        if (_perImages.length != _numImages)
            _perImages.length = _numImages;

        auto scImgs = _swapchain.images;
        assert(scImgs.length == _numImages);

        foreach (i; 0 .. _numImages) {
            _perImages[i].reset(device, scImgs[i]);
        }
    }

    /// Get the device linked to this surface
    @property Device device()
    {
        return _device;
    }

    /// Get the underlying surface
    @property Surface surface()
    {
        return _surface;
    }

    /// Semaphore that is signaled when the acquired image is available for
    /// writing.
    @property Semaphore imageAvailSem()
    {
        return _imageAvailSem;
    }

    /// Semaphore that is signaled when the rendering on the image is finished
    /// and the image is ready for presentation.
    @property Semaphore renderingDoneSem()
    {
        return _renderingDoneSem;
    }

    /// The image format of the surface
    @property Format format()
    {
        return _format;
    }

    /// Whether the surface can be alpha-blended by the system compositor.
    @property bool supportsAlphaBlend()
    {
        import gfx.graal.format : formatDesc, alphaBits;

        return _compAlpha != CompositeAlpha.opaque &&
                alphaBits(formatDesc(_format).surfaceType) > 0;
    }

    /// Get the swapchain managed by this GraphicsSurface
    @property Swapchain swapchain()
    {
        return _swapchain.obj;
    }

    /// Get the size of the surface
    @property uint[2] size()
    {
        return _size;
    }

    /// The number of images in the swapchain
    @property uint numImages()
    {
        return _numImages;
    }

    /// Get an image from the swapchain
    ImageBase image(in uint index)
    in(index < _numImages)
    {
        return _perImages[index].img;
    }

    /// Get an image view from the swapchain
    ImageView view(in uint index)
    in(index < _numImages)
    {
        return _perImages[index].view;
    }

    /// Get the fence related to the image at the specified index
    Fence fence(in uint index)
    in(index < _numImages)
    {
        return _perImages[index].fence;
    }

    /// infinite timeout
    enum infinity = dur!"seconds"(-1);

    /// Acquire the following swapchain image
    /// Params:
    ///     timeout = Duration before timeout, or infinity if no timeout is
    ///               desired.
    /// Returns: the ImageAcquisition
    ImageAcquisition acquireNextImage(Duration timeout = infinity)
    {
        return _swapchain.acquireNextImage(_imageAvailSem, timeout);
    }

    private CompositeAlpha findCompAlpha(Format format, CompositeAlpha caps)
    {
        import gfx.graal.format : alphaBits, formatDesc;
        import std.range : only;

        const desc = formatDesc(format);

        auto testOrder = alphaBits(desc.surfaceType) > 0 ?
            only(CompositeAlpha.postMultiplied, CompositeAlpha.preMultiplied,
                CompositeAlpha.inherit, CompositeAlpha.opaque) :
            only(CompositeAlpha.inherit, CompositeAlpha.opaque,
                CompositeAlpha.preMultiplied, CompositeAlpha.postMultiplied);
        foreach (ca; testOrder) {
            if (cast(uint)(ca & caps)) {
                return ca;
            }
        }
        throw new Exception("Did not find composite alpha!");
    }

    private static struct PerImage
    {
        ImageBase img;
        ImageView view;
        Fence fence;

        void release()
        {
            fence.wait();
            releaseObj(fence);
            releaseObj(view);
        }

        void reset(Device device, ImageBase img)
        {
            import gfx.graal.image : ImageSubresourceRange, ImageAspect, ImageType, Swizzle;
            import std.typecons : Yes;

            releaseObj(view);
            this.img = img;
            view = retainObj(img.createView(ImageType.d2,
                    ImageSubresourceRange(ImageAspect.color), Swizzle.identity));

            if (!fence)
                fence = retainObj(device.createFence(Yes.signaled));
            else
                fence.wait();
        }
    }
}
