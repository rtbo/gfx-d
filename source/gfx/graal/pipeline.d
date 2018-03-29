module gfx.graal.pipeline;

import gfx.core.rc;
import gfx.core.typecons;
import gfx.core.types;
import gfx.graal.buffer;
import gfx.graal.format;
import gfx.graal.image;
import gfx.graal.renderpass;

import std.typecons : Flag;

interface ShaderModule : AtomicRefCounted
{
    @property string entryPoint();
}

interface PipelineLayout : AtomicRefCounted
{}

interface Pipeline : AtomicRefCounted
{}

interface DescriptorSetLayout : AtomicRefCounted
{}

interface DescriptorPool : AtomicRefCounted
{
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

struct DepthBias
{
    float constantFactor;
    float clamp;
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

struct StencilOpState
{
    StencilOp failOp;
    StencilOp passOp;
    StencilOp depthFailOp;
    CompareOp compareOp;
    uint compareMask;
    uint writeMask;
    uint reference;
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

    all = r | g | b | a,
}

struct ColorBlendAttachment {
    Flag!"enabled" enabled;
    BlendState colorBlend;
    BlendState alphaBlend;
    ColorMask colorMask;
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
    float[4] blendConstants;
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
    DescriptorWrites writes;
}

struct CopyDescritporSet {
    Trans!DescriptorSet set;
    Trans!uint          binding;
    Trans!uint          arrayElem;
}

abstract class DescriptorWrites
{
    this(DescriptorType type, size_t count) {
        _type = type;
        _count = count;
    }
    final @property DescriptorType type() const {
        return _type;
    }
    final @property size_t count() const {
        return _count;
    }
    private DescriptorType _type;
    private size_t _count;
}

class TDescWritesBase(Desc) : DescriptorWrites
{
    this(Desc[] descs, DescriptorType type) {
        super(type, descs.length);
        _descs = descs;
    }
    final @property Desc[] descs() {
        return _descs;
    }
    private Desc[] _descs;
}

final class TDescWrites(Desc, DescriptorType ctType) : TDescWritesBase!Desc
{
    this(Desc[] descs) {
        super(descs, ctType);
    }
}

struct CombinedImageSampler {
    Sampler sampler;
    ImageView view;
    ImageLayout layout;
}

struct ImageViewLayout {
    ImageView view;
    ImageLayout layout;
}

struct BufferRange {
    Buffer buffer;
    size_t offset;
    size_t range;
}

alias SamplerDescWrites = TDescWrites!(Sampler, DescriptorType.sampler);
alias CombinedImageSamplerDescWrites = TDescWrites!(CombinedImageSampler, DescriptorType.combinedImageSampler);
alias SampledImageDescWrites = TDescWrites!(ImageViewLayout, DescriptorType.sampledImage);
alias StorageImageDescWrites = TDescWrites!(ImageViewLayout, DescriptorType.storageImage);
alias InputAttachmentDescWrites = TDescWrites!(ImageViewLayout, DescriptorType.inputAttachment);
alias UniformBufferDescWrites = TDescWrites!(BufferRange, DescriptorType.uniformBuffer);
alias StorageBufferDescWrites = TDescWrites!(BufferRange, DescriptorType.storageBuffer);
alias UniformBufferDynamicDescWrites = TDescWrites!(BufferRange, DescriptorType.uniformBufferDynamic);
alias StorageBufferDynamicDescWrites = TDescWrites!(BufferRange, DescriptorType.storageBufferDynamic);
alias UniformTexelBufferDescWrites = TDescWrites!(BufferView, DescriptorType.uniformTexelBuffer);
alias StorageTexelBufferDescWrites = TDescWrites!(BufferView, DescriptorType.storageTexelBuffer);
