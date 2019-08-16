module gfx.graal.renderpass;

import gfx.core.rc;
import gfx.core.typecons : Option;
import gfx.graal.cmd : Access, PipelineStage;
import gfx.graal.format;
import gfx.graal.image;
import gfx.graal.types;

import std.math : isPowerOf2;
import std.typecons : Flag, Yes;

/// Attachment load operation at the beginning of a render pass
enum LoadOp
{
    /// the previous content of the image is preserved
    load,
    /// the content of the image is cleared
    clear,
    /// the content of the image is undefined
    dontCare
}

/// Attachment store operation at the end of a render pass
enum StoreOp
{
    /// the content of the image is stored for later processing
    store,
    /// the content of the image is discarded
    dontCare
}

/// The operations performed on an attachment when it enters and leaves a render pass
struct AttachmentOps
{
    LoadOp load;
    StoreOp store;
}

/// Describes an image attachment in a render pass or framebuffer
struct AttachmentDescription
{
    /// the format of the attachment
    Format format;
    /// Sample count of the attachment
    /// Must be a power of two between 1 and 64
    uint samples = 1;
    /// the operations to be performed on the attachment
    /// color and depth attachments may only need to define the ops member
    /// depth-stencil attachments must define both ops (for depth) and stencilOps members.
    AttachmentOps ops = AttachmentOps(LoadOp.dontCare, StoreOp.dontCare);
    /// ditto
    AttachmentOps stencilOps = AttachmentOps(LoadOp.dontCare, StoreOp.dontCare);
    /// The ImageLayout transition of the attachment.
    /// layoutTrans.from is the initial layout of the attachment when it enters the render pass.
    /// it is up to the programmer to ensure that the attachment will be in this state.
    /// layoutTrans.to is the layout of the attachment when it exits the render pass.
    Trans!ImageLayout layoutTrans;
    /// Set mayAlias to Yes if a part of the attachment memory is shared with parts of other attachments
    /// in the same render pass.
    Flag!"mayAlias" mayAlias;

    /// Build a color attachment description
    static AttachmentDescription color(Format format, AttachmentOps ops,
            Trans!ImageLayout layoutTrans)
    in(colorBits(format.formatDesc.surfaceType) > 0)
    {
        AttachmentDescription ad;
        ad.format = format;
        ad.ops = ops;
        ad.layoutTrans = layoutTrans;
        return ad;
    }

    /// Build a depth attachment description
    static AttachmentDescription depth(Format format, AttachmentOps ops,
            Trans!ImageLayout layoutTrans)
    in(depthBits(format.formatDesc.surfaceType) > 0)
    {
        AttachmentDescription ad;
        ad.format = format;
        ad.ops = ops;
        ad.layoutTrans = layoutTrans;
        return ad;
    }

    /// Build a depth-stencil attachment description
    static AttachmentDescription depthStencil(Format format, AttachmentOps depthOps,
            AttachmentOps stencilOps, Trans!ImageLayout layoutTrans)
    in(depthBits(format.formatDesc.surfaceType) > 0)
    in(stencilBits(format.formatDesc.surfaceType) > 0)
    {
        AttachmentDescription ad;
        ad.format = format;
        ad.ops = depthOps;
        ad.stencilOps = stencilOps;
        ad.layoutTrans = layoutTrans;
        return ad;
    }

    /// Set samples to the description
    AttachmentDescription withSamples(uint samples)
    in(isPowerOf2(samples) && samples >= 1 && samples <= 64)
    {
        this.samples = samples;
        return this;
    }

    /// Set mayAlias to Yes
    AttachmentDescription withMayAlias()
    {
        this.mayAlias = Yes.mayAlias;
        return this;
    }
}

/// A reference to an attachment
struct AttachmentRef
{
    /// The index of the attachment in the framebuffer
    uint attachment;
    /// The layout the attachment will be in the subpass this reference is used
    ImageLayout layout;
}

/// Decription of a subpass in a renderpass
struct SubpassDescription
{
    /// Input attachments (read from in fragment shader)
    AttachmentRef[] inputs;
    /// Color-output attachments (written to in fragment shader)
    AttachmentRef[] colors;
    /// depth-stencil attachment (if any)
    Option!AttachmentRef depthStencil;
    /// Indices of attachments that are not used but whose content must be preserved
    /// throughout the subpass
    uint[] preserves;
}

/// virtual subpass index for subpass dependencies that relates to what is before or after
/// the render pass
enum subpassExternal = uint.max;

/// The SubpassDependency structure describes synchronization dependencies
/// between two subpasses in a render pass
struct SubpassDependency
{
    /// subpass indices of the source and destination subpasses
    Trans!uint subpass;
    /// Pipeline stage masks of source and destination subpasses
    Trans!PipelineStage stageMask;
    /// Memory access masks of source and destination subpasses
    Trans!Access accessMask;
}

/// A render pass is a succession of one or more subpasses,
/// each of which describes what image attachments are used
/// and how they are laid out in memory.
interface RenderPass : IAtomicRefCounted
{
    import gfx.graal.device : Device;

    /// Get the device that issued the render pass
    @property Device device();
}

/// Framebuffer is a collection of images attachments used
/// in a render pass.
/// When a render pass is started in a command buffer, a framebuffer
/// is tied to it so that its input and output attachments are used
/// during the rendering operations.
interface Framebuffer : IAtomicRefCounted
{
    import gfx.graal.device : Device;

    /// Get the device that issued the framebuffer
    @property Device device();
}
