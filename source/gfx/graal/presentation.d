/// Presentation module
module gfx.graal.presentation;

import core.time : Duration;

import gfx.core.rc;
import gfx.graal.format;
import gfx.graal.image;
import gfx.graal.sync;

import std.typecons : Tuple;

struct SurfaceCaps
{
    uint minImages;
    uint maxImages;
    uint[2] minSize;
    uint[2] maxSize;
    uint maxLayers;
    ImageUsage usage;
    CompositeAlpha supportedAlpha;
}

enum CompositeAlpha {
    opaque          = 0x01,
    preMultiplied   = 0x02,
    postMultiplied  = 0x04,
    inherit         = 0x08,
}

enum PresentMode {
    immediate,
    fifo,
    mailbox,
}

interface Surface : IAtomicRefCounted
{}

interface Swapchain : IAtomicRefCounted
{
    import gfx.graal.device : Device;

    /// Get the parent device
    @property Device device();

    /// Get the Surface that this swapchain is bound to.
    @property Surface surface();

    /// The image format of this swapchain
    @property Format format();

    /// Get the list of images owned by this swapchain.
    /// The index of each image is meaningful and is often used to reference
    /// the image (such as the index returned by acquireNextImage)
    @property ImageBase[] images();

    /// use negative timeout to specify no timeout at all
    /// Params:
    ///     timeout = the maximum time to wait until the call returns
    ///     semaphore = the semaphore
    ///     suboptimal = a flag that implementation may set if the swapchain need
    ///                  to be recreated
    /// Returns: the index of an available image or uint.max if timeout expired
    ///          before any image was returned to the application
    uint acquireNextImage(Duration timeout, Semaphore semaphore, out bool suboptimal);
}
