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

/// Result of Image Acquisition from a Swapchain.
struct ImageAcquisition
{
    /// An Image Acquisition can have one of the 3 following states.
    enum State : uint
    {
        /// The image could be acquired in optimal condition
        ok          = 0x00000000,
        /// An image could be acquired but its use is suboptimal.
        /// This is an indication that the swapchain should be re-generated.
        suboptimal  = 0x01000000,
        /// The swapchain could is out of date and must be re-generated.
        /// This can happen for example during resize of the window behind
        /// the swapchain's surface.
        outOfDate   = 0x02000000,

        /// Value used to mask out the index from the state.
        mask        = 0xff000000,
    }

    /// Make an ImageAcquisition in OK state with the given image index.
    static ImageAcquisition makeOk(uint index)
    {
        assert(indexValid(index));
        return ImageAcquisition(index);
    }

    /// Make an ImageAcquisition in Suboptimal state with the given image index.
    static ImageAcquisition makeSuboptimal(uint index)
    {
        assert(indexValid(index));
        return ImageAcquisition(cast(uint)State.suboptimal | index);
    }

    /// Make an ImageAcquisition in out-of-date state.
    static ImageAcquisition makeOutOfDate()
    {
        return ImageAcquisition(cast(uint)State.outOfDate);
    }

    /// Get the state of the acquisition
    @property State state() const
    {
        return cast(State)(rep & State.mask);
    }

    /// Get the index of the acquired image
    @property uint index() const
    in (!outOfDate)
    {
        return rep & ~State.mask;
    }

    /// Whether the acquisition is in OK state
    @property bool ok() const
    {
        return state == State.ok;
    }

    /// Whether the acquisition is in OK state
    @property bool ok() const
    {
        return state == State.ok;
    }

    /// Whether the acquisition is in suboptimal state
    @property bool suboptimal() const
    {
        return state == State.suboptimal;
    }

    /// Whether the acquisition is in out-of-date state
    @property bool outOfDate() const
    {
        return state == State.outOfDate;
    }

    private uint rep;

    private this (uint rep) { this.rep = rep; }

    private static bool indexValid(in uint index)
    {
        return (index & cast(uint)State.mask) == 0;
    }
}

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
