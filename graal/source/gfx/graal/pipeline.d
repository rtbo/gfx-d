module gfx.graal.pipeline;

import gfx.core.rc;
import gfx.core.typecons;
import gfx.graal.buffer;
import gfx.graal.format;
import gfx.graal.image;
import gfx.graal.renderpass;
import gfx.graal.types;

import std.typecons : Flag;

interface ShaderModule : IAtomicRefCounted
{
    import gfx.graal.device : Device;

    /// Get the parent device
    @property Device device();

    @property string entryPoint();
}

interface PipelineLayout : IAtomicRefCounted
{
    import gfx.graal.device : Device;

    /// Get the parent device
    @property Device device();

    /// Get the descriptor set layouts used to create this pipeline layout
    @property DescriptorSetLayout[] descriptorLayouts();

    /// Get the push constant ranges in this layout
    @property const(PushConstantRange)[] pushConstantRanges();
}

interface Pipeline : IAtomicRefCounted
{
    import gfx.graal.device : Device;

    /// Get the parent device
    @property Device device();
}

interface DescriptorSetLayout : IAtomicRefCounted
{
    import gfx.graal.device : Device;

    /// Get the parent device
    @property Device device();
}

interface DescriptorPool : IAtomicRefCounted
{
    import gfx.graal.device : Device;

    /// Get the parent device
    @property Device device();

    /// Allocate a descriptor set per descriptor layout passed as argument
    DescriptorSet[] allocate(DescriptorSetLayout[] layouts);

    /// Reset this pool.
    /// All descriptors allocated with this pool are invalid after this call
    void reset();
}

interface DescriptorSet
{
    @property DescriptorPool pool();
}

struct PipelineInfo {
    GraphicsShaderSet shaders;
    VertexInputBinding[] inputBindings;
    VertexInputAttrib[] inputAttribs;
    InputAssembly assembly;
    Rasterizer rasterizer;
    /// Viewport configuration of the pipeline.
    /// For dynamic viewport, leave this array empty
    ViewportConfig[] viewports;

    // TODO: tesselation, multisample

    DepthInfo depthInfo;
    StencilInfo stencilInfo;
    ColorBlendInfo blendInfo;

    DynamicState[] dynamicStates;

    PipelineLayout layout;

    RenderPass renderPass;
    uint subpassIndex;
}

enum ShaderStage {
    vertex                  = 0x01,
    tessellationControl     = 0x02,
    tessellationEvaluation  = 0x04,
    geometry                = 0x08,
    fragment                = 0x10,
    compute                 = 0x20,

    allGraphics             = 0x1f,
    all                     = allGraphics | compute,
}

struct GraphicsShaderSet {
    ShaderModule vertex;
    ShaderModule tessControl;
    ShaderModule tessEval;
    ShaderModule geometry;
    ShaderModule fragment;
}


/// Describes the binding of a buffer to the pipeline
struct VertexInputBinding {
    uint binding;
    size_t stride;
    Flag!"instanced" instanced;
}

/// Describes a vertex attribute
struct VertexInputAttrib {
    uint location;
    uint binding;
    Format format;
    size_t offset;
}


enum Primitive {
    pointList, lineList, lineStrip,
    triangleList, triangleStrip, triangleFan,
    lineListAdjacency, lineStripAdjacency,
    triangleListAdjacency, triangleStripAdjacency,
    patchList,
}

struct InputAssembly {
    Primitive primitive;
    Flag!"primitiveRestart" primitiveRestart;
}

enum FrontFace {
    ccw, cw,
}

enum Cull {
    none            = 0x00,
    front           = 0x01,
    back            = 0x02,
    frontAndBack    = front | back,
}

enum PolygonMode {
    fill, line, point,
}

/// Defines how a polygon can be offset (mainly to avoid shadow artifacts).
/// Given m as maximum depth slope of the triangle and r as implementation defined
/// minimal resolvable difference, the offset of the triangle is defined as follow:
/// o = m * slopeFactor + r * constantFactor
/// If clamp == 0f, o is used directly as effective offset.
/// If clamp > 0f, the effective offset is min(o, clamp)
/// If clamp < 0f, the effective offset is max(o, clamp)
struct DepthBias
{
    /// Factor multiplied by the minimal resolvable difference of the depth buffer
    float constantFactor;
    /// Clamps the effective offset to a particular value
    float clamp;
    /// Factor multiplied by the maximum depth slope of the polygon.
    float slopeFactor;
}

struct Rasterizer {
    PolygonMode mode;
    Cull cull;
    FrontFace front;
    Flag!"depthClamp" depthClamp;
    Option!DepthBias depthBias;
    float lineWidth=1f;
}

struct ViewportConfig {
    Viewport viewport;
    Rect scissors;
}

enum CompareOp
{
    never, less, equal, lessOrEqual, greater, notEqual, greaterOrEqual, always,
}

enum StencilOp
{
    keep,
    zero,
    replace,
    incrementAndClamp,
    decrementAndClamp,
    invert,
    incrementAndWrap,
    decrementAndWrap,
}

struct DepthInfo
{
    Flag!"enabled" enabled;
    Flag!"write" write;
    CompareOp compareOp;
    Flag!"boundsTest" boundsTest;
    float minBounds;
    float maxBounds;

    @property static DepthInfo none() {
        return DepthInfo.init;
    }
}

struct StencilOpState
{
    StencilOp failOp;
    StencilOp passOp;
    StencilOp depthFailOp;
    CompareOp compareOp;
    uint compareMask;
    uint writeMask;
    uint refMask;
}

struct StencilInfo
{
    Flag!"enabled" enabled;
    StencilOpState front;
    StencilOpState back;

    @property static StencilInfo none() {
        return StencilInfo.init;
    }
}


enum BlendFactor
{
    zero = 0,
    one = 1,
    srcColor = 2,
    oneMinusSrcColor = 3,
    dstColor = 4,
    oneMinusDstColor = 5,
    srcAlpha = 6,
    oneMinusSrcAlpha = 7,
    dstAlpha = 8,
    oneMinusDstAlpha = 9,
    constantColor = 10,
    oneMinusConstantColor = 11,
    constantAlpha = 12,
    oneMinusConstantAlpha = 13,
    srcAlphaSaturate = 14,
    src1Color = 15,
    oneMinusSrc1Color = 16,
    src1Alpha = 17,
    oneMinusSrc1Alpha = 18,
}

enum BlendOp {
    add,
    subtract,
    reverseSubtract,
    min,
    max,
}

struct BlendState {
    Trans!BlendFactor factor;
    BlendOp op;
}

enum ColorMask {
    r = 0x01,
    g = 0x02,
    b = 0x04,
    a = 0x08,

    none    = 0x00,
    all     = r | g | b | a,
    rg      = r | g,
    rb      = r | b,
    ra      = r | a,
    gb      = g | b,
    ga      = g | a,
    ba      = b | a,
    rgb     = r | g | b,
    rga     = r | g | a,
    rba     = r | b | a,
    gba     = g | b | a,
    rgba    = r | g | b | a,
}

struct ColorBlendAttachment {
    Flag!"enabled" enabled;
    BlendState colorBlend;
    BlendState alphaBlend;
    ColorMask colorMask;

    static ColorBlendAttachment solid(in ColorMask mask=ColorMask.all) {
        import std.typecons : No;
        return ColorBlendAttachment(
            No.enabled, BlendState.init, BlendState.init, mask
        );
    }

    static ColorBlendAttachment blend(in BlendState blendState,
                                      in ColorMask mask=ColorMask.all) {
        import std.typecons : Yes;
        return ColorBlendAttachment(
            Yes.enabled, blendState, blendState, mask
        );
    }

    static ColorBlendAttachment blend(in BlendState color, in BlendState alpha,
                                      in ColorMask mask=ColorMask.all) {
        import std.typecons : Yes;
        return ColorBlendAttachment(
            Yes.enabled, color, alpha, mask
        );
    }
}

enum LogicOp {
    clear,
    and,
    andReverse,
    copy,
    andInverted,
    noop,
    xor,
    or,
    nor,
    equivalent,
    invert,
    orReverse,
    copyInverted,
    orInverted,
    nand,
    set,
}

struct ColorBlendInfo
{
    Option!LogicOp logicOp;
    ColorBlendAttachment[] attachments;
    float[4] blendConstants = [ 0f, 0f, 0f, 0f ];
}

enum DynamicState {
    viewport,
    scissor,
    lineWidth,
    depthBias,
    blendConstants,
    depthBounds,
    stencilCmpMask,
    stencilWriteMask,
    stencilRef,
}

enum DescriptorType {
    sampler,
    combinedImageSampler,
    sampledImage,
    storageImage,
    uniformTexelBuffer,
    storageTexelBuffer,
    uniformBuffer,
    storageBuffer,
    uniformBufferDynamic,
    storageBufferDynamic,
    inputAttachment,
}

struct PipelineLayoutBinding {
    uint binding;
    DescriptorType descriptorType;
    uint descriptorCount;
    ShaderStage stages;
}

struct PushConstantRange {
    ShaderStage stages;
    uint offset;
    uint size;
}

struct DescriptorPoolSize {
    DescriptorType type;
    uint count;
}

struct WriteDescriptorSet {
    DescriptorSet dstSet;
    uint dstBinding;
    uint dstArrayElem;
    DescriptorWrite write;
}

struct CopyDescritporSet {
    Trans!DescriptorSet set;
    Trans!uint          binding;
    Trans!uint          arrayElem;
}

/// Descriptor for a buffer
/// to be used to update the following descriptor types:
///   - DescriptorType.uniformBuffer
///   - DescriptorType.uniformBufferDynamic
///   - DescriptorType.storageBuffer
///   - DescriptorType.storageBufferDynamic
struct BufferDescriptor
{
    /// descriptor resource
    Buffer buffer;
    /// bytes offset from the beginning of the resource
    size_t offset;
    /// amount of bytes to use from the resource
    size_t size;
}

/// Descriptor for a texel buffer
/// to be used to update the following descriptor types:
///   - DescriptorType.uniformTexelBuffer
///   - DescriptorType.storageTexelBuffer
struct TexelBufferDescriptor
{
    /// descriptor resource
    TexelBufferView bufferView;
}

/// Descriptor for images
/// to be used to update the following descriptor types:
///   - DescriptorType.sampledImage
///   - DescriptorType.storageImage
///   - DescriptorType.inputAttachment
struct ImageDescriptor {
    /// view to descriptor resource
    ImageView view;
    /// layout of the image resource
    ImageLayout layout;
}

/// Descriptor that combines sampler and image view
/// to be used to update the following descriptor types:
///   - DescriptorType.combinedImageSampler
struct ImageSamplerDescriptor
{
    /// view to image resource
    ImageView view;
    /// layout of the image resource
    ImageLayout layout;
    /// sampler resource combined with this image
    Sampler sampler;
}

/// Descriptor for a sampler
/// to be used to update the following descriptor types:
///   - DescriptorType.sampler
struct SamplerDescriptor
{
    /// descriptor resource
    Sampler sampler;
}

/// Gathering of descriptor or descriptors array to be written to a device
struct DescriptorWrite
{
    private this(DescriptorType type, size_t count, Write write) {
        _type = type;
        _count = count;
        _write = write;
    }
    private this(DescriptorType type, size_t count, Writes writes) {
        _type = type;
        _count = count;
        _writes = writes;
    }

    /// the type of the descriptor to be written
    @property DescriptorType type() const {
        return _type;
    }

    /// how many descriptors are to be written
    @property size_t count() const {
        return _count;
    }

    /// make a Descriptor write for a single BufferDescriptor
    static DescriptorWrite make(in DescriptorType type, BufferDescriptor buffer)
    in(type == DescriptorType.uniformBuffer
        || type == DescriptorType.storageBuffer
        || type == DescriptorType.uniformBufferDynamic
        || type == DescriptorType.storageBufferDynamic)
    {
        Write write;
        write.buffer = buffer;
        return DescriptorWrite(type, 1, write);
    }

    /// make a Descriptor write for a BufferDescriptor array
    static DescriptorWrite make(in DescriptorType type, BufferDescriptor[] buffers)
    in(type == DescriptorType.uniformBuffer
        || type == DescriptorType.storageBuffer
        || type == DescriptorType.uniformBufferDynamic
        || type == DescriptorType.storageBufferDynamic)
    in(buffers.length > 1)
    {
        Writes writes;
        writes.buffers = buffers;
        return DescriptorWrite(type, buffers.length, writes);
    }

    /// make a Descriptor write for a single TexelBufferDescriptor
    static DescriptorWrite make(in DescriptorType type, TexelBufferDescriptor texelBuffer)
    in(type == DescriptorType.uniformTexelBuffer
        || type == DescriptorType.storageTexelBuffer)
    {
        Write write;
        write.texelBuffer = texelBuffer;
        return DescriptorWrite(type, 1, write);
    }

    /// make a Descriptor write for a TexelBufferDescriptor array
    static DescriptorWrite make(in DescriptorType type, TexelBufferDescriptor[] texelBuffers)
    in(type == DescriptorType.uniformTexelBuffer
        || type == DescriptorType.storageTexelBuffer)
    in(texelBuffers.length > 1)
    {
        Writes writes;
        writes.texelBuffers = texelBuffers;
        return DescriptorWrite(type, texelBuffers.length, writes);
    }

    /// make a Descriptor write for a single ImageDescriptor
    static DescriptorWrite make(in DescriptorType type, ImageDescriptor image)
    in(type == DescriptorType.sampledImage
        || type == DescriptorType.storageImage
        || type == DescriptorType.inputAttachment)
    {
        Write write;
        write.image = image;
        return DescriptorWrite(type, 1, write);
    }

    /// make a Descriptor write for a ImageDescriptor array
    static DescriptorWrite make(in DescriptorType type, ImageDescriptor[] images)
    in(type == DescriptorType.sampledImage
        || type == DescriptorType.storageImage
        || type == DescriptorType.inputAttachment)
    in(images.length > 1)
    {
        Writes writes;
        writes.images = images;
        return DescriptorWrite(type, images.length, writes);
    }

    /// make a Descriptor write for a single ImageSamplerDescriptor
    static DescriptorWrite make(in DescriptorType type, ImageSamplerDescriptor imageSampler)
    in(type == DescriptorType.combinedImageSampler)
    {
        Write write;
        write.imageSampler = imageSampler;
        return DescriptorWrite(type, 1, write);
    }

    /// make a Descriptor write for a ImageSamplerDescriptor array
    static DescriptorWrite make(in DescriptorType type, ImageSamplerDescriptor[] imageSamplers)
    in(type == DescriptorType.combinedImageSampler)
    in(imageSamplers.length > 1)
    {
        Writes writes;
        writes.imageSamplers = imageSamplers;
        return DescriptorWrite(type, imageSamplers.length, writes);
    }

    /// make a Descriptor write for a single SamplerDescriptor
    static DescriptorWrite make(in DescriptorType type, SamplerDescriptor sampler)
    in(type == DescriptorType.sampler)
    {
        Write write;
        write.sampler = sampler;
        return DescriptorWrite(type, 1, write);
    }

    /// make a Descriptor write for a SamplerDescriptor array
    static DescriptorWrite make(in DescriptorType type, SamplerDescriptor[] samplers)
    in(type == DescriptorType.sampler)
    in(samplers.length > 1)
    {
        Writes writes;
        writes.samplers = samplers;
        return DescriptorWrite(type, samplers.length, writes);
    }

    /// access BufferDescriptor array
    @property BufferDescriptor[] buffers() return
    in(type == DescriptorType.uniformBuffer
        || type == DescriptorType.storageBuffer
        || type == DescriptorType.uniformBufferDynamic
        || type == DescriptorType.storageBufferDynamic)
    {
        if (_count == 1) {
            return (&_write.buffer)[0 .. 1];
        }
        else {
            return _writes.buffers;
        }
    }

    /// access TexelBufferDescriptor array
    @property TexelBufferDescriptor[] texelBuffers() return
    in(type == DescriptorType.uniformTexelBuffer
        || type == DescriptorType.storageTexelBuffer)
    {
        if (_count == 1) {
            return (&_write.texelBuffer)[0 .. 1];
        }
        else {
            return _writes.texelBuffers;
        }
    }

    /// access ImageDescriptor array
    @property ImageDescriptor[] images() return
    in(type == DescriptorType.sampledImage
        || type == DescriptorType.storageImage
        || type == DescriptorType.inputAttachment)
    {
        if (_count == 1) {
            return (&_write.image)[0 .. 1];
        }
        else {
            return _writes.images;
        }
    }

    /// access ImageSamplerDescriptor array
    @property ImageSamplerDescriptor[] imageSamplers() return
    in(type == DescriptorType.combinedImageSampler)
    {
        if (_count == 1) {
            return (&_write.imageSampler)[0 .. 1];
        }
        else {
            return _writes.imageSamplers;
        }
    }

    /// access SamplerDescriptor array
    @property SamplerDescriptor[] samplers() return
    in(type == DescriptorType.sampler)
    {
        if (_count == 1) {
            return (&_write.sampler)[0 .. 1];
        }
        else {
            return _writes.samplers;
        }
    }

    // union used if count > 1 (heap allocation)
    private union Writes
    {
        BufferDescriptor[] buffers;
        TexelBufferDescriptor[] texelBuffers;
        ImageDescriptor[] images;
        ImageSamplerDescriptor[] imageSamplers;
        SamplerDescriptor[] samplers;
    }

    // avoid heap allocation when a single descriptor is specified
    // (probably over 90% of use cases)
    private union Write
    {
        BufferDescriptor buffer;
        TexelBufferDescriptor texelBuffer;
        ImageDescriptor image;
        ImageSamplerDescriptor imageSampler;
        SamplerDescriptor sampler;
    }

    private DescriptorType _type;
    private size_t _count;
    private Writes _writes;
    private Write _write;
}
