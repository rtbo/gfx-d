/// command buffer module
module gfx.graal.cmd;

import gfx.core.rc;
import gfx.graal.buffer;
import gfx.graal.image;

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

/// A transition from one state to another
struct Trans(T) {
    /// state before
    T from;
    /// state after
    T to;
}

/// Transition build helper
auto trans(T)(T from, T to) {
    return Trans!T(from, to);
}

enum Access {
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

enum queueFamilyIgnored = ~0;

struct ImageMemoryBarrier {
    Trans!Access accessMaskTrans;
    Trans!ImageLayout layoutTrans;
    Trans!uint queueFamIndexTrans;
    Image image;
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

interface CommandBuffer
{
    @property CommandPool pool();

    void reset();

    void begin(bool multipleSubmissions);
    void end();

    void pipelineBarrier(Trans!PipelineStage stageTrans,
                         BufferMemoryBarrier[] bufMbs,
                         ImageMemoryBarrier[] imgMbs);

    void clearColorImage(Image image, ImageLayout layout,
                         in ClearColorValues clearValues,
                         ImageSubresourceRange[] ranges);

    void clearDepthStencilImage(Image image, ImageLayout layout,
                                in ClearDepthStencilValues clearValues,
                                ImageSubresourceRange[] ranges);

}
