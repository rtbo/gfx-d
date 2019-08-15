/// Presentation module
module gfx.graal.presentation;

import core.time : Duration;

import gfx.core.rc;
import gfx.graal.format;
import gfx.graal.image;
import gfx.graal.sync;

import std.typecons : Tuple;

/// Surface capabilities
/// See_Also: PhysicalDevice.surfaceCaps
struct SurfaceCaps
{
    // TODO: currentSize
    /// Minimum number of images necessary in a swapchain created for the
    /// surface these caps where queried for.
    uint minImages;
    /// Maximum number of images supported by swapchains created for the surface
    /// these caps where queried for.
    uint maxImages;
    /// Minimum size of the surface
    uint[2] minSize;
    /// Maximum size of the surface
    uint[2] maxSize;
    /// Maximum number of array layers for this surface. At least one.
    uint maxLayers;
    /// Possible usages bits of the images of swapchains created for this image.
    /// At least `ImageUsage.colorAttachment` is included.
    ImageUsage usage;
    /// Supported composition mode for the surface.
    /// At least one bit is always included. Opaque composition is always
    /// feasible by having no alpha channel or with alpha channel equals to 1.0.
    CompositeAlpha supportedAlpha;
}

/// Composition mode for a presentation engine
enum CompositeAlpha {
    /// The alpha channel of presented surface is discarded and no composition
    /// is performed.
    opaque          = 0x01,
    /// Composition is enabled and the color channels of presented surface are
    /// treated as pre-multiplied by the alpha channel.
    preMultiplied   = 0x02,
    /// Composition is enabled and the color channels of presented surface must
    /// multiplied by the alpha channel by the presentation engine.
    postMultiplied  = 0x04,
    /// The Graal implementation has no clue on how the compositor will
    /// treat the alpha channel.
    inherit         = 0x08,
}

/// PresentMode is the algorithm driving a swapchain
enum PresentMode
{
    /// Image is presented immediately, without waiting for V-blank.
    /// This mode may cause tearing.
    immediate,
    /// First-in, first-out. The presentation engine waits for the next V-blank
    /// to present image, such as tearing cannot be observed. Images are
    /// appended at the end of an internal queue and the images are retrieved at
    /// the beginning of the queue at each V-Blank. This mode is always
    /// available, and should be used for steady throughput of presentation.
    fifo,
    /// This is similar to fifo, with the exception that the internal queue
    /// has only one entry, such as if an image is waiting to be presented,
    /// and another comes before V-blank, the new image replaces the previous
    /// one, such as only the latest image is presented. Tearing cannot be
    /// observed. This mode can increase reactivity of application.
    mailbox,
}

/// Handle to a native surface
interface Surface : IAtomicRefCounted
{}

/// Result of Image acquisition from a Swapchain.
/// See_Also: Swapchain.acquireNextImage
struct ImageAcquisition
{
    /// An Image Acquisition can have one of the 4 following states.
    enum State : uint
    {
        /// The image could be acquired in optimal condition
        ok          = 0x00000000,
        /// An image could be acquired but its use is suboptimal.
        /// This is an indication that the swapchain should be re-generated when
        /// practicable. This can happen e.g. if the window is being resized but
        /// the presentation engine is able to scale the image to the surface.
        suboptimal  = 0x01000000,
        /// The swapchain could is out of date and MUST be re-generated.
        /// This can happen for example during resize of the window behind
        /// the swapchain's surface, or if the window properties have changed
        /// in some way.
        outOfDate   = 0x02000000,
        /// Swapchain.acquireNextImage timed-out, or was called with null
        /// timeout and no image was ready.
        notReady    = 0x03000000,

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

    /// Make an ImageAcquisition in notReady state.
    static ImageAcquisition makeNotReady()
    {
        return ImageAcquisition(cast(uint)State.notReady);
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

    /// Whether the acquisition is in not-ready state
    @property bool notReady() const
    {
        return state == State.notReady;
    }

    /// Whether an image could be acquired
    @property bool hasIndex() const
    {
        return ok || suboptimal;
    }

    /// Whether the Swapchain should be reconstructed
    @property bool swapchainNeedsRebuild() const
    {
        return suboptimal || outOfDate;
    }

    private uint rep;

    private this (uint rep) { this.rep = rep; }

    private static bool indexValid(in uint index)
    {
        return (index & cast(uint)State.mask) == 0;
    }
}

/// Handle to a swapchain engine
interface Swapchain : IAtomicRefCounted
{
    import gfx.graal.device : Device;
    import core.time : dur;

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

    /// Acquire the next image in the swapchain. This function may block until
    /// the next image is available.
    /// Params:
    ///     semaphore   = A semaphore that is signaled when the image is
    ///                   ready to be written to. Use it to synchronize with
    ///                   the first submission that will write to the image.
    ///     timeout     = The maximum time to wait until the call returns.
    ///                   Use negative timeout to specify infinite waiting time.
    ///                   Use null timeout to specify no wait at all.
    /// Returns: ImageAcquisition representing the result of the operation.
    /// See_Also: ImageAcquisition
    ImageAcquisition acquireNextImage(Semaphore semaphore,
                                      Duration timeout=dur!"seconds"(-1));
}
