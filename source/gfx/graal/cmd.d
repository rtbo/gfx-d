/// command buffer module
module gfx.graal.cmd;

import gfx.core.rc;
import gfx.core.typecons;
import gfx.core.types;
import gfx.graal.buffer;
import gfx.graal.image;
import gfx.graal.renderpass;
import gfx.graal.pipeline;

import std.typecons : Flag, No;

interface CommandPool : AtomicRefCounted
{
    void reset();

    CommandBuffer[] allocate(size_t count);

    void free(CommandBuffer[] buffers)
    in {
        import std.algorithm : all;
        assert(buffers.all!(b => b.pool is this));
    }
}

enum Access {
    none                        = 0x00000000,
    indirectCommandRead         = 0x00000001,
    indexRead                   = 0x00000002,
    vertexAttributeRead         = 0x00000004,
    uniformRead                 = 0x00000008,
    inputAttachmentRead         = 0x00000010,
    shaderRead                  = 0x00000020,
    shaderWrite                 = 0x00000040,
    colorAttachmentRead         = 0x00000080,
    colorAttachmentWrite        = 0x00000100,
    depthStencilAttachmentRead  = 0x00000200,
    depthStencilAttachmentWrite = 0x00000400,
    transferRead                = 0x00000800,
    transferWrite               = 0x00001000,
    hostRead                    = 0x00002000,
    hostWrite                   = 0x00004000,
    memoryRead                  = 0x00008000,
    memoryWrite                 = 0x00010000,
}

enum queueFamilyIgnored = 0xffffffff;

struct ImageMemoryBarrier {
    Trans!Access accessMaskTrans;
    Trans!ImageLayout layoutTrans;
    Trans!uint queueFamIndexTrans;
    ImageBase image;
    ImageSubresourceRange range;
}

struct BufferMemoryBarrier {
    Trans!Access accessMaskTrans;
    Trans!uint queueFamIndexTrans;
    Buffer buffer;
    size_t offset;
    size_t size;
}

enum PipelineStage {
    topOfPipe                   = 0x00000001,
    drawIndirect                = 0x00000002,
    vertexInput                 = 0x00000004,
    vertexShader                = 0x00000008,
    tessellationControlShader   = 0x00000010,
    tessellationEvalShader      = 0x00000020,
    geometryShader              = 0x00000040,
    fragmentShader              = 0x00000080,
    earlyFragmentTests          = 0x00000100,
    lateFragmentTests           = 0x00000200,
    colorAttachment             = 0x00000400,
    computeShader               = 0x00000800,
    transfer                    = 0x00001000,
    bottomOfPipe                = 0x00002000,
    host                        = 0x00004000,
    allGraphics                 = 0x00008000,
    allCommands                 = 0x00010000,
}

enum PipelineBindPoint {
    graphics, compute
}

/// Values to be given to a clear image color command
/// The type should be f32, unless the image format has numeric format of sInt or uInt.
struct ClearColorValues
{
    enum Type {
        f32, i32, u32
    }
    union Values {
        float[4] f32;
        int[4] i32;
        uint[4] u32;
    }
    Type type;
    Values values;

    this (float r, float g, float b, float a) {
        type = Type.f32;
        values.f32 = [ r, g, b, a ];
    }

    this (int r, int g, int b, int a) {
        type = Type.i32;
        values.i32 = [ r, g, b, a ];
    }

    this (uint r, uint g, uint b, uint a) {
        type = Type.u32;
        values.u32 = [ r, g, b, a ];
    }
}

struct ClearDepthStencilValues
{
    float depth;
    uint stencil;
}

struct ClearValues
{
    enum Type { undefined, color, depthStencil }
    union Values {
        ClearColorValues        color;
        ClearDepthStencilValues depthStencil;
    }
    Type type;
    Values values;

    this (ClearColorValues color) {
        type = Type.color;
        values.color = color;
    }
    this (ClearDepthStencilValues depthStencil) {
        type = Type.depthStencil;
        values.depthStencil = depthStencil;
    }

    static ClearValues color(in float r, in float g, in float b, in float a) {
        return ClearValues(ClearColorValues(r, g, b, a));
    }

    static ClearValues color(in int r, in int g, in int b, in int a) {
        return ClearValues(ClearColorValues(r, g, b, a));
    }

    static ClearValues color(in uint r, in uint g, in uint b, in uint a) {
        return ClearValues(ClearColorValues(r, g, b, a));
    }

    static ClearValues depthStencil(in float depth, in uint stencil) {
        return ClearValues(ClearDepthStencilValues(depth, stencil));
    }
}

struct VertexBinding {
    Buffer buffer;
    size_t offset;
}

struct CopyRegion
{
    Trans!size_t offset;
    size_t size;
}

struct ImageCopyRegion
{
    Trans!ImageSubresourceRange isr;
    Trans!(float[3]) offset;
}

struct BufferImageCopy
{
    ulong bufferOffset;
    uint bufferWidth;
    uint bufferHeight;
    ImageSubresourceLayer imageLayers;
    int[3] offset;
    uint[3] extent;
}

enum StencilFace
{
    front = 1,
    back = 2,
    frontAndBack = 3,
}

interface CommandBuffer
{
    @property CommandPool pool();

    void reset();

    void begin(Flag!"persistent" persistent=No.persistent);
    void end();

    void pipelineBarrier(Trans!PipelineStage stageTrans,
                         BufferMemoryBarrier[] bufMbs,
                         ImageMemoryBarrier[] imgMbs);

    void clearColorImage(ImageBase image, ImageLayout layout,
                         in ClearColorValues clearValues,
                         ImageSubresourceRange[] ranges);

    void clearDepthStencilImage(ImageBase image, ImageLayout layout,
                                in ClearDepthStencilValues clearValues,
                                ImageSubresourceRange[] ranges);

    void copyBuffer(Trans!Buffer buffers, CopyRegion[] regions);
    void copyBufferToImage(Buffer srcBuffer, ImageBase dstImage,
                           in ImageLayout dstLayout, in BufferImageCopy[] regions);

    void setViewport(in uint firstViewport, in Viewport[] viewports);
    void setScissor(in uint firstScissor, in Rect[] scissors);
    void setDepthBounds(in float minDepth, in float maxDepth);
    void setLineWidth(in float lineWidth);
    void setDepthBias(in float constFactor, in float clamp, in float slopeFactor);
    void setStencilCompareMask(in StencilFace faceMask, in uint compareMask);
    void setStencilWriteMask(in StencilFace faceMask, in uint writeMask);
    void setStencilReference(in StencilFace faceMask, in uint reference);
    void setBlendConstants(in float[4] blendConstants);

    void beginRenderPass(RenderPass rp, Framebuffer fb,
                         Rect area, ClearValues[] clearValues);

    void nextSubpass();

    void endRenderPass();

    void bindPipeline(Pipeline pipeline);
    void bindVertexBuffers(uint firstBinding, VertexBinding[] bindings);
    void bindIndexBuffer(Buffer indexBuf, size_t offset, IndexType type);

    void bindDescriptorSets(PipelineBindPoint bindPoint, PipelineLayout layout,
                            uint firstSet, DescriptorSet[] sets, in size_t[] dynamicOffsets);

    void pushConstants(PipelineLayout layout, ShaderStage stages,
                       size_t offset, size_t size, const(void)* data);

    void draw(uint vertexCount, uint instanceCount, uint firstVertex, uint firstInstance);
    void drawIndexed(uint indexCount, uint instanceCount, uint firstVertex, int vertexOffset, uint firstInstance);
}
