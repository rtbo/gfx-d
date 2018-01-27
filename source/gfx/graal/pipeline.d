module gfx.graal.pipeline;

import gfx.core.rc;
import gfx.core.typecons;
import gfx.core.types;
import gfx.graal.format;
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


struct PipelineInfo {
    GraphicsShaderSet shaders;
    VertexInputBinding[] inputBindings;
    VertexInputAttrib[] inputAttribs;
    InputAssembly assembly;
    Rasterizer rasterizer;
    /// Viewport configuration of the pipeline.
    /// For dynamic viewport, leave this array empty
    ViewportConfig[] viewports;

    // TODO: tesselation, multisample, depth-stencil
    ColorBlendInfo blendInfo;

    DynamicState[] dynamicStates;

    PipelineLayout layout;

    RenderPass renderPass;
    uint subpassIndex;
}

enum ShaderLanguage {
    spirV       = 0x01,
    glsl        = 0x02, // TODO: glsl versions
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
