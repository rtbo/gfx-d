module gfx.gl3.swapchain;

import gfx.graal.device : Device;
import gfx.graal.presentation : Surface, Swapchain;

final class GlSurface : Surface
{
    import gfx.core.rc : atomicRcCode;

    mixin(atomicRcCode);

    private size_t _handle;

    this(size_t handle) {
        _handle = handle;
    }
    override void dispose() {}

    @property size_t handle() {
        return _handle;
    }
}

package final class GlSwapchain : Swapchain
{
    import core.time                : Duration;
    import gfx.core.rc              : atomicRcCode, Rc;
    import gfx.gl3                  : GlShare;
    import gfx.gl3.device           : GlDevice;
    import gfx.gl3.resource         : GlImage;
    import gfx.graal.format         : Format;
    import gfx.graal.image          : ImageBase, ImageInfo, ImageUsage;
    import gfx.graal.presentation   : CompositeAlpha, ImageAcquisition,
                                      PresentMode;
    import gfx.graal.sync           : Semaphore;

    mixin(atomicRcCode);

    Rc!Device _dev;
    Rc!GlShare _share;
    GlSurface _surface;
    GlImage[] _imgs;
    ImageBase[] _imgsB; // same objects, but already cast to interface (points to different addresses)
    uint[2] _size;
    Format _format;
    uint _nextImg;


    this (GlDevice device, GlShare share, Surface surface, PresentMode pm, uint numImages,
          Format format, uint[2] size, ImageUsage usage, CompositeAlpha alpha,
          Swapchain former=null)
    {
        _dev = device;
        _share = share;
        _surface = cast(GlSurface)surface;
        _format = format;
        _size = size;

        _imgs = new GlImage[numImages];
        _imgsB = new ImageBase[numImages];
        auto mem = device.allocateMemory(0, 1); // dummy memory
        mem.retain();
        foreach (i; 0 .. numImages) {
            auto img = new GlImage(
                _dev.obj, _share, ImageInfo.d2(size[0], size[1]).withFormat(format).withUsage(usage)
            );
            img.bindMemory(mem, 0);

            _imgs[i] = img;
            _imgsB[i] = cast(ImageBase)img;
        }
        mem.release();

        import gfx.core.rc : retainArr;
        retainArr(_imgs);
    }

    override void dispose() {
        import gfx.core.rc : releaseArr;
        releaseArr(_imgs);
        _share.unload();
        _dev.unload();
    }

    override @property Device device() {
        return _dev;
    }

    override @property Format format() {
        return _format;
    }

    override @property ImageBase[] images() {
        return _imgsB;
    }

    override ImageAcquisition acquireNextImage(Semaphore semaphore,
                                               Duration timeout)
    {
        const ni = _nextImg++;
        if (_nextImg >= _imgs.length) _nextImg = 0;
        return ImageAcquisition.makeOk(ni);
    }

    @property GlSurface surface() {
        return _surface;
    }

    @property uint[2] size() {
        return _size;
    }
}
