module gfx.gl3.swapchain;

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
    import core.time : Duration;
    import gfx.core.rc : atomicRcCode, Rc;
    import gfx.gl3 : GlShare;
    import gfx.gl3.device : GlDevice;
    import gfx.gl3.resource : GlImage;
    import gfx.graal.format : Format;
    import gfx.graal.image : ImageBase, ImageInfo, ImageUsage;
    import gfx.graal.presentation : CompositeAlpha, PresentMode;
    import gfx.graal.sync : Semaphore;

    mixin(atomicRcCode);

    Rc!GlShare _share;
    GlSurface _surface;
    GlImage[] _imgs;
    ImageBase[] _imgsB; // same objects, but already cast to interface (points to different addresses)
    uint[2] _size;
    Format _format;
    uint _nextImg;


    this (GlShare share, GlDevice device, Surface surface, PresentMode pm, uint numImages,
          Format format, uint[2] size, ImageUsage usage, CompositeAlpha alpha,
          Swapchain former=null)
    {
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
                _share, ImageInfo.d2(size[0], size[1]).withFormat(format).withUsage(usage)
            );
            img.bindMemory(mem, 0);

            _imgs[i] = img;
            _imgsB[i] = cast(ImageBase)img;
        }
        mem.release();

        import gfx.core.rc : retainArray;
        retainArray(_imgs);
    }

    override void dispose() {
        import gfx.core.rc : releaseArray;
        releaseArray(_imgs);
        _share.unload();
    }

    override @property Format format() {
        return _format;
    }

    override @property ImageBase[] images() {
        return _imgsB;
    }

    override uint acquireNextImage(Duration timeout, Semaphore semaphore,
                                   out bool suboptimal) {
        const ni = _nextImg++;
        if (_nextImg >= _imgs.length) _nextImg = 0;
        return ni;
    }

    @property GlSurface surface() {
        return _surface;
    }

    @property uint[2] size() {
        return _size;
    }
}
