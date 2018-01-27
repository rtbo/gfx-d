/// Image module
module gfx.graal.image;

import gfx.core.rc;
import gfx.core.typecons;
import gfx.graal.format;
import gfx.graal.memory;
import gfx.graal.pipeline : CompareOp;

import std.typecons : Flag;

enum ImageType {
    d1, d1Array,
    d2, d2Array,
    d3, cube, cubeArray
}

bool isCube(in ImageType it) {
    return it == ImageType.cube || it == ImageType.cubeArray;
}

bool isArray(in ImageType it) {
    return it == ImageType.d1Array || it == ImageType.d2Array || it == ImageType.cubeArray;
}

enum CubeFace {
    none,
    posX, negX,
    posY, negY,
    posZ, negZ,
}

/// an array of faces in the order that is expected during cube initialization
immutable cubeFaces = [
    CubeFace.posX, CubeFace.negX,
    CubeFace.posY, CubeFace.negY,
    CubeFace.posZ, CubeFace.negZ,
];

struct ImageDims
{
    uint width;
    uint height;
    uint depth;
    uint layers;

    static ImageDims d1 (in uint width) {
        return ImageDims(width, 1, 1, 1);
    }
    static ImageDims d2 (in uint width, in uint height) {
        return ImageDims(width, height, 1, 1);
    }
    static ImageDims d3 (in uint width, in uint height, in uint depth) {
        return ImageDims(width, height, depth, 1);
    }
    static ImageDims cube (in uint width, in uint height) {
        return ImageDims(width, height, 6, 1);
    }
    static ImageDims d1Array (in uint width, in uint layers) {
        return ImageDims(width, 1, 1, layers);
    }
    static ImageDims d2Array (in uint width, uint height, in uint layers) {
        return ImageDims(width, height, 1, layers);
    }
    static ImageDims cubeArray (in uint width, in uint height, in uint layers) {
        return ImageDims(width, height, 6, layers);
    }
}

enum ImageUsage {
    none = 0,
    transferSrc             = 0x01,
    transferDst             = 0x02,
    sampled                 = 0x04,
    storage                 = 0x08,
    colorAttachment         = 0x10,
    depthStencilAttachment  = 0x20,
    transientAttachment     = 0x40,
    inputAttachment         = 0x80,
}

enum ImageLayout {
	undefined                       = 0,
	general                         = 1,
	colorAttachmentOptimal          = 2,
	depthStencilAttachmentOptimal   = 3,
	depthStencilReadOnlyOptimal     = 4,
	shaderReadOnlyOptimal           = 5,
	transferSrcOptimal              = 6,
	transferDstOptimal              = 7,
	preinitialized                  = 8,
    presentSrc                      = 1000001002, // TODO impl actual mapping to vulkan
}

enum ImageAspect {
    color           = 0x01,
    depth           = 0x02,
    stencil         = 0x04,
    depthStencil    = depth | stencil,
}


struct ImageSubresourceRange
{
    ImageAspect aspect;
    size_t firstLevel;
    size_t levels;
    size_t firstLayer;
    size_t layers;
}

enum CompSwizzle : ubyte
{
    identity,
    zero, one,
    r, g, b, a,
}

alias Swizzle = CompSwizzle[4];

interface Image
{
    @property ImageType type();
    @property Format format();
    @property ImageDims dims();
    @property uint levels();

    // TODO: deduce view type from subrange and image type
    ImageView createView(ImageType viewtype, ImageSubresourceRange isr, Swizzle swizzle);
}

interface ImageRc : Image, AtomicRefCounted
{
    @property MemoryRequirements memoryRequirements();
    void bindMemory(DeviceMemory mem, in size_t offset);
}

interface ImageView : AtomicRefCounted
{
    @property Image image();
    @property ImageSubresourceRange subresourceRange();
    @property Swizzle swizzle();
}


enum Filter {
    nearest,
    linear,
}


/// Specifies how texture coordinates outside the range `[0, 1]` are handled.
enum WrapMode {
    /// Repeat the texture. That is, sample the coordinate modulo `1.0`.
    repeat,
    /// Mirror the texture. Like tile, but uses abs(coord) before the modulo.
    mirrorRepeat,
    /// Clamp the texture to the value at `0.0` or `1.0` respectively.
    clamp,
    /// Use border color.
    border,
}

enum BorderColor
{
    floatTransparent,
    intTransparent,
    floatBlack,
    intBlack,
    floatWhite,
    intWhite,
}

///
struct SamplerInfo {
    Filter minFilter;
    Filter magFilter;
    Filter mipmapFilter;
    WrapMode[3] wrapMode;
    Option!float anisotropy;
    float lodBias;
    float[2] lodRange;
    Option!CompareOp compare;
    BorderColor borderColor;
    Flag!"unnormalizeCoords" unnormalizeCoords;

    static @property SamplerInfo bilinear() {
        SamplerInfo si;
        si.minFilter = Filter.linear;
        si.magFilter = Filter.linear;
        return si;
    }

    static @property SamplerInfo trilinear() {
        SamplerInfo si;
        si.minFilter = Filter.linear;
        si.magFilter = Filter.linear;
        si.mipmapFilter = Filter.linear;
        return si;
    }
}

interface Sampler : AtomicRefCounted
{}
