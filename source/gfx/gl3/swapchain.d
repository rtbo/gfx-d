module gfx.gl3.swapchain;

package:

import gfx.graal.presentation;

class GlSwapchain : Swapchain
{
    import core.time : Duration;
    import gfx.core.rc : atomicRcCode, Rc;
    import gfx.gl3 : GlShare;
    import gfx.gl3.resource : GlImage;
    import gfx.graal.format : Format;
    import gfx.graal.image : ImageBase, ImageDims, ImageUsage, ImageTiling, ImageType;
    import gfx.graal.sync : Semaphore;

    mixin(atomicRcCode);

    Rc!GlShare _share;
    GlImage[] _imgs;
    ImageBase[] _imgsB; // same objects, but already cast to interface (points to different addresses)
    Format _format;
    uint _nextImg;


    this (GlShare share, Surface surface, PresentMode pm, uint numImages,
          Format format, uint[2] size, ImageUsage usage, CompositeAlpha alpha,
          Swapchain former=null)
    {
        _share = share;
        _format = format;

        _imgs = new GlImage[numImages];
        _imgsB = new ImageBase[numImages];
        foreach (i; 0 .. numImages) {
            _imgs[i] = new GlImage(
                _share, ImageType.d2, ImageDims.d2(size[0], size[1]), format,
                usage, ImageTiling.optimal, 0, 1
            );
            _imgsB[i] = cast(ImageBase)_imgs[i];
        }

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
}
