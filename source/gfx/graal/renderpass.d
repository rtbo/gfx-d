module gfx.graal.renderpass;

import gfx.core.rc;
import gfx.core.typecons;
import gfx.graal.cmd : Access, PipelineStage;
import gfx.graal.format;
import gfx.graal.image;

import std.typecons : Flag;

enum LoadOp {
    load, clear, dontCare
}

enum StoreOp {
    store, dontCare
}

struct AttachmentOps {
    LoadOp load;
    StoreOp store;
}

struct AttachmentDescription
{
    Format format;
    uint samples=1;
    AttachmentOps colorDepthOps = AttachmentOps(LoadOp.dontCare, StoreOp.dontCare);
    AttachmentOps stencilOps = AttachmentOps(LoadOp.dontCare, StoreOp.dontCare);
    Trans!ImageLayout layoutTrans;
    Flag!"mayAlias" mayAlias;
}

struct AttachmentRef {
    uint attachment;
    ImageLayout layout;
}

struct SubpassDescription
{
    AttachmentRef[] inputs;
    AttachmentRef[] colors;
    Option!AttachmentRef depthStencil;
    uint[] preserves;
}

enum subpassExternal = uint.max;

struct SubpassDependency
{
    Trans!uint subpass;
    Trans!PipelineStage stageMask;
    Trans!Access accessMask;
}

interface RenderPass : AtomicRefCounted
{}

interface Framebuffer : AtomicRefCounted
{}
