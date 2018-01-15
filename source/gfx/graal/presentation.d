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
}

enum PresentMode {
    immediate,
    fifo,
    mailbox,
}

interface Surface : AtomicRefCounted
{}

interface Swapchain : AtomicRefCounted
{
    @property Image[] images();

    /// use negative timeout to specify no timeout at all
    /// Params:
    ///     timeout = the maximum time to wait until the call returns
    ///     semaphore = the semaphore
    /// Returns: the index of an available image or uint.max if timeout expired
    ///          before any image was returned to the application
    uint acquireNextImage(Duration timeout, Semaphore semaphore);
}
