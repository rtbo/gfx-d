/// command buffer module
module gfx.graal.cmd;

import gfx.core.rc;
import gfx.core.typecons;
import gfx.graal.buffer;
import gfx.graal.image;
import gfx.graal.renderpass;
import gfx.graal.pipeline;
import gfx.graal.types;

import std.typecons : Flag, No;

interface CommandPool : IAtomicRefCounted {
    void reset();

    PrimaryCommandBuffer[] allocatePrimary(in size_t count);
    SecondaryCommandBuffer[] allocateSecondary(in size_t count);

    void free(CommandBuffer[] buffers)
    in {
        import std.algorithm : all;

        assert(buffers.all!(b => b.pool is this));
    }
}

enum Access {
    none = 0x00000000,
    indirectCommandRead = 0x00000001,
    indexRead = 0x00000002,
    vertexAttributeRead = 0x00000004,
    uniformRead = 0x00000008,
    inputAttachmentRead = 0x00000010,
    shaderRead = 0x00000020,
    shaderWrite = 0x00000040,
    colorAttachmentRead = 0x00000080,
    colorAttachmentWrite = 0x00000100,
    depthStencilAttachmentRead = 0x00000200,
    depthStencilAttachmentWrite = 0x00000400,
    transferRead = 0x00000800,
    transferWrite = 0x00001000,
    hostRead = 0x00002000,
    hostWrite = 0x00004000,
    memoryRead = 0x00008000,
    memoryWrite = 0x00010000,
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
    topOfPipe = 0x00000001,
    drawIndirect = 0x00000002,
    vertexInput = 0x00000004,
    vertexShader = 0x00000008,
    tessellationControlShader = 0x00000010,
    tessellationEvalShader = 0x00000020,
    geometryShader = 0x00000040,
    fragmentShader = 0x00000080,
    earlyFragmentTests = 0x00000100,
    lateFragmentTests = 0x00000200,
    colorAttachmentOutput = 0x00000400,
    computeShader = 0x00000800,
    transfer = 0x00001000,
    bottomOfPipe = 0x00002000,
    host = 0x00004000,
    allGraphics = 0x00008000,
    allCommands = 0x00010000,
}

enum PipelineBindPoint {
    graphics,
    compute
}

/// Values to be given to a clear image color command
/// The type should be f32, unless the image format has numeric format of sInt or uInt.
struct ClearColorValues {
    enum Type {
        f32,
        i32,
        u32
    }

    union Values {
        float[4] f32;
        int[4] i32;
        uint[4] u32;
    }

    Type type;
    Values values;

    this(float r, float g, float b, float a) {
        type = Type.f32;
        values.f32 = [r, g, b, a];
    }

    this(int r, int g, int b, int a) {
        type = Type.i32;
        values.i32 = [r, g, b, a];
    }

    this(uint r, uint g, uint b, uint a) {
        type = Type.u32;
        values.u32 = [r, g, b, a];
    }
}

struct ClearDepthStencilValues {
    float depth;
    uint stencil;
}

struct ClearValues {
    enum Type {
        undefined,
        color,
        depthStencil
    }

    union Values {
        ClearColorValues color;
        ClearDepthStencilValues depthStencil;
    }

    Type type;
    Values values;

    this(ClearColorValues color) {
        type = Type.color;
        values.color = color;
    }

    this(ClearDepthStencilValues depthStencil) {
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

struct CopyRegion {
    Trans!size_t offset;
    size_t size;
}

struct ImageCopyRegion {
    Trans!ImageSubresourceRange isr;
    Trans!(float[3]) offset;
}

struct BufferImageCopy {
    ulong bufferOffset;
    uint bufferWidth;
    uint bufferHeight;
    ImageSubresourceLayer imageLayers;
    int[3] offset;
    uint[3] extent;
}

enum StencilFace {
    front = 1,
    back = 2,
    frontAndBack = 3,
}

enum wholeSize = uint.max;

enum CommandBufferUsage {
    none = 0,
    oneTimeSubmit = 0x0001,
    simultaneousUse = 0x0004,
}

enum CommandBufferLevel {
    primary,
    secondary,
}

/// Base interface for a command buffer
///
/// CommandBuffer are allocated and owned by a command pool.
/// A command buffer can be in three defined states:
/// 1. invalid - that is the state after it as been created or reset
/// 2. recoding - that is the state between begin() and end() calls()
/// 3. pending - that is the state when recording is done and commands
///     are ready for execution.
///
/// A command buffer in pending state can only go back to the initial
/// state by a call to reset(). This call must not occur before all
/// submitted executions are finished in the device queues.
interface CommandBuffer {
    @property CommandPool pool();

    @property CommandBufferLevel level() const;

    void reset();

    /// Begin recording and switches the buffer state from "invalid" to "recording"
    /// SecondaryCommandBuffer can alternatively call beginWithinRenderPass
    void begin(in CommandBufferUsage usage);
    void end();

    void pipelineBarrier(Trans!PipelineStage stageTrans,
            BufferMemoryBarrier[] bufMbs, ImageMemoryBarrier[] imgMbs);

    void clearColorImage(ImageBase image, ImageLayout layout,
            in ClearColorValues clearValues, ImageSubresourceRange[] ranges);

    void clearDepthStencilImage(ImageBase image, ImageLayout layout,
            in ClearDepthStencilValues clearValues, ImageSubresourceRange[] ranges);

    /// Fills buffer from offset to offset+size with value
    /// Params:
    ///     dst     = the buffer to fill.
    ///     offset  = Byte offset from where to fill the buffer.
    ///               Must be a multiple of 4.
    ///     size    = Number of bytes to fill. Must be a multiple of 4 or
    ///               wholeSize to fill until the end of the buffer.
    ///     value   = Value to copy into the buffer, in host endianess.
    /// Can only be used outside of a render pass.
    void fillBuffer(Buffer dst, in size_t offset, in size_t size, uint value)
    in {
        assert(offset % 4 == 0);
        assert(size == wholeSize || size % 4 == 0);
    }
    /// Update buffer with the data passed as argument
    /// Params:
    ///     dst     = the buffer to update.
    ///     offset  = Byte offset from where to update the buffer.
    ///               Must be a multiple of 4.
    ///     data    = The data to copy into the buffer.
    /// The data is duplicated into the command buffer, so it is legal to pass a slice
    /// to local on-stack data, or to let GC collect the data right after the call.
    /// Can only be used outside of a render pass.
    void updateBuffer(Buffer dst, in size_t offset, in uint[] data);
    void copyBuffer(Trans!Buffer buffers, in CopyRegion[] regions);
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

    void bindPipeline(Pipeline pipeline);
    void bindVertexBuffers(uint firstBinding, VertexBinding[] bindings);
    void bindIndexBuffer(Buffer indexBuf, size_t offset, IndexType type);

    void bindDescriptorSets(PipelineBindPoint bindPoint, PipelineLayout layout,
            uint firstSet, DescriptorSet[] sets, in size_t[] dynamicOffsets);

    void pushConstants(PipelineLayout layout, ShaderStage stages, size_t offset,
            size_t size, const(void)* data);

    void draw(uint vertexCount, uint instanceCount, uint firstVertex, uint firstInstance);
    void drawIndexed(uint indexCount, uint instanceCount, uint firstVertex,
            int vertexOffset, uint firstInstance);
}

/// Interface to a primary command buffer
///
/// A primary command buffer can be submitted directly to a queue
/// and also execute commands that are recorded in a secondary command buffer.
///
/// Primary command buffers are doing most of their work when tied to a render pass.
/// As they are not thread safe, it means that recording commands to the same framebuffer
/// cannot be parallelized with PrimaryCommandBuffer.
/// If this is needed, SecondaryCommandBuffer (from other CommandPool) can be filled in parallel,
/// and later executed on a PrimaryCommandBuffer
interface PrimaryCommandBuffer : CommandBuffer {

    /// Place the command buffer into a render pass context
    void beginRenderPass(RenderPass rp, Framebuffer fb, in Rect area, in ClearValues[] clearValues);
    void nextSubpass();
    void endRenderPass();

    /// Execute secondary buffers into this primary buffer
    void execute(SecondaryCommandBuffer[] buffers);
}

/// Interface to a secondary command buffer
///
/// Main interest of secondary command buffer is that they are not tied to
/// a render pass and as such can be filled in parallel on different threads.
interface SecondaryCommandBuffer : CommandBuffer {

    /// Switches the buffer to the "recording" state, acknowledging that the buffer
    /// will be executed within a render pass compatible with rp
    void beginWithinRenderPass(in CommandBufferUsage usage, RenderPass rp,
            Framebuffer fb, uint subpass = 0);

}
