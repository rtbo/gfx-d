/// ImageBase module
module gfx.graal.image;

import gfx.core.rc;
import gfx.core.typecons;
import gfx.graal.format;
import gfx.graal.memory;
import gfx.graal.pipeline : CompareOp, ImageDescriptor,
        SamplerDescriptor, ImageSamplerDescriptor;

import std.typecons : Flag;

struct ImageInfo
{
    ImageType type;
    ImageDims dims;
    Format format;
    ImageUsage usage;
    ImageTiling tiling;
    uint layers=1;
    uint samples=1;
    uint levels=1;

    static ImageInfo d1 (in uint width) {
        return ImageInfo(
            ImageType.d1,
            ImageDims(width, 1, 1)
        );
    }
    static ImageInfo d2 (in uint width, in uint height) {
        return ImageInfo(
            ImageType.d2,
            ImageDims(width, height, 1)
        );
    }
    static ImageInfo d3 (in uint width, in uint height, in uint depth) {
        return ImageInfo(
            ImageType.d3,
            ImageDims(width, height, depth)
        );
    }
    static ImageInfo cube (in uint width, in uint height) {
        return ImageInfo(
            ImageType.cube,
            ImageDims(width, height, 6)
        );
    }
    static ImageInfo d1Array (in uint width, in uint layers) {
        auto ii = ImageInfo(
            ImageType.d1Array,
            ImageDims(width, 1, 1)
        );
        ii.layers = layers;
        return ii;
    }
    static ImageInfo d2Array (in uint width, uint height, in uint layers) {
        auto ii = ImageInfo(
            ImageType.d2Array,
            ImageDims(width, height, 1)
        );
        ii.layers = layers;
        return ii;
    }
    static ImageInfo cubeArray (in uint width, in uint height, in uint layers) {
        auto ii = ImageInfo(
            ImageType.cubeArray,
            ImageDims(width, height, 1)
        );
        ii.layers = layers;
        return ii;
    }

    ImageInfo withFormat(in Format format) const {
        ImageInfo ii = this;
        ii.format = format;
        return ii;
    }
    ImageInfo withUsage(in ImageUsage usage) const {
        ImageInfo ii = this;
        ii.usage = usage;
        return ii;
    }
    ImageInfo withTiling(in ImageTiling tiling) const {
        ImageInfo ii = this;
        ii.tiling = tiling;
        return ii;
    }
    ImageInfo withSamples(in uint samples) const {
        ImageInfo ii = this;
        ii.samples = samples;
        return ii;
    }
    ImageInfo withLevels(in uint levels) const {
        ImageInfo ii = this;
        ii.levels = levels;
        return ii;
    }
}

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
    uint height=1;
    uint depth=1;
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

    transfer                = transferSrc | transferDst,
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
    presentSrc                      = 1_000_001_002, // TODO impl actual mapping to vulkan
}

enum ImageTiling {
    optimal,
    linear,
}

enum ImageAspect {
    color           = 0x01,
    depth           = 0x02,
    stencil         = 0x04,
    depthStencil    = depth | stencil,
    none            = 0x00,
}


struct ImageSubresourceLayer
{
    ImageAspect aspect  = ImageAspect.color;
    uint mipLevel       = 0;
    uint firstLayer     = 0;
    uint layers         = 1;
}

struct ImageSubresourceRange
{
    ImageAspect aspect  = ImageAspect.color;
    size_t firstLevel   = 0;
    size_t levels       = 1;
    size_t firstLayer   = 0;
    size_t layers       = 1;
}

enum CompSwizzle : ubyte
{
    identity,
    zero, one,
    r, g, b, a,
}

struct Swizzle
{
    private CompSwizzle[4] rep;

    this(in CompSwizzle r, in CompSwizzle g, in CompSwizzle b, in CompSwizzle a)
    {
        rep = [r, g, b, a];
    }

    static @property Swizzle identity() {
        return Swizzle(
            CompSwizzle.identity, CompSwizzle.identity,
            CompSwizzle.identity, CompSwizzle.identity
        );
    }

    static @property Swizzle one() {
        return Swizzle(
            CompSwizzle.one, CompSwizzle.one,
            CompSwizzle.one, CompSwizzle.one
        );
    }

    static @property Swizzle zero() {
        return Swizzle(
            CompSwizzle.zero, CompSwizzle.zero,
            CompSwizzle.zero, CompSwizzle.zero
        );
    }

    static @property Swizzle opDispatch(string name)() {
        bool isSwizzleIdent() {
            foreach (char c; name) {
                switch (c) {
                case 'r': break;
                case 'g': break;
                case 'b': break;
                case 'a': break;
                case 'i': break;
                case 'o': break;
                case 'z': break;
                default: return false;
                }
            }
            return true;
        }
        CompSwizzle getComp(char c) {
            switch (c) {
            case 'r': return CompSwizzle.r;
            case 'g': return CompSwizzle.g;
            case 'b': return CompSwizzle.b;
            case 'a': return CompSwizzle.a;
            case 'i': return CompSwizzle.identity;
            case 'o': return CompSwizzle.one;
            case 'z': return CompSwizzle.zero;
            default: assert(false);
            }
        }

        static assert(name.length == 4, "Error: Swizzle."~name~". Swizzle identifier must have four components.");
        static assert(isSwizzleIdent(), "Wrong swizzle identifier: Swizzle."~name);
        return Swizzle(
            getComp(name[0]), getComp(name[1]), getComp(name[2]), getComp(name[3])
        );
    }

    size_t opDollar() const { return 4; }
    CompSwizzle opIndex(size_t ind) const { return rep[ind]; }
    const(CompSwizzle)[] opIndex() const return { return rep[]; }
    size_t[2] opSlice(size_t dim)(size_t start, size_t end) const {
        return [start, end];
    }
    const(CompSwizzle)[] opIndex(size_t[2] slice) const return {
        return rep[slice[0] .. slice[1]];
    }
}

///
unittest {
    assert(!__traits(compiles, Swizzle.rrr));
    assert(!__traits(compiles, Swizzle.qwer));

    assert(Swizzle.rgba == Swizzle(CompSwizzle.r, CompSwizzle.g, CompSwizzle.b, CompSwizzle.a));
    assert(Swizzle.rrbb == Swizzle(CompSwizzle.r, CompSwizzle.r, CompSwizzle.b, CompSwizzle.b));
    assert(Swizzle.aaag == Swizzle(CompSwizzle.a, CompSwizzle.a, CompSwizzle.a, CompSwizzle.g));
    assert(Swizzle.iiii == Swizzle.identity);
    assert(Swizzle.oooo == Swizzle.one);
    assert(Swizzle.zzzz == Swizzle.zero);
}

interface ImageBase
{
    @property ImageInfo info();

    // TODO: deduce view type from subrange and image type
    ImageView createView(ImageType viewtype, ImageSubresourceRange isr, Swizzle swizzle);
}

interface Image : ImageBase, IAtomicRefCounted
{
    import gfx.graal.device : Device;

    /// Get the parent device
    @property Device device();

    @property MemoryRequirements memoryRequirements();
    /// The image keeps a reference of the device memory
    void bindMemory(DeviceMemory mem, in size_t offset);
    /// The memory bound to this image
    @property DeviceMemory boundMemory();
}

interface ImageView : IAtomicRefCounted
{
    @property ImageBase image();
    @property ImageSubresourceRange subresourceRange();
    @property Swizzle swizzle();

    /// Build a descriptor to this image resource
    final ImageDescriptor descriptor(ImageLayout layout)
    {
        return ImageDescriptor(this, layout);
    }

    /// Build a descriptor to this image resource combined with a sampler
    final ImageSamplerDescriptor descriptorWithSampler(ImageLayout layout, Sampler sampler)
    {
        return ImageSamplerDescriptor(this, layout, sampler);
    }
}

/// Type of filter for texture sampling
enum Filter {
    /// nearest sample is used
    nearest,
    /// sample is interpolated with neighboors
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
    floatTransparent    = 0,
    intTransparent      = 1,
    floatBlack          = 2,
    intBlack            = 3,
    floatWhite          = 4,
    intWhite            = 5,
}

@property bool isFloat(in BorderColor color) pure {
    return (cast(int)color & 0x01) == 0;
}
@property bool isInt(in BorderColor color) pure {
    return (cast(int)color & 0x01) == 1;
}
@property bool isTransparent(in BorderColor color) pure {
    return (cast(int)color & 0x06) == 0;
}
@property bool isBlack(in BorderColor color) pure {
    return (cast(int)color & 0x06) == 2;
}
@property bool isWhite(in BorderColor color) pure {
    return (cast(int)color & 0x06) == 4;
}

/// Structure holding texture sampler information.
/// It is used to create samplers.
struct SamplerInfo {
    /// The minification filter
    Filter minFilter;
    /// The magnification filter
    Filter magFilter;
    /// The filter used between mipmap levels
    Filter mipmapFilter;
    /// The wrap mode for look-ups outside of [ 0 , 1 ] in the three axis
    WrapMode[3] wrapMode;
    /// Enables anisotropy filtering. The value set serves as maximum covering fragments.
    Option!float anisotropy;
    float lodBias = 0f;
    float[2] lodRange = [ 0f, 0f ];
    /// Enables a comparison operation during lookup of depth/stencil based textures.
    /// Mostly useful for shadow maps.
    Option!CompareOp compare;
    BorderColor borderColor;
    /// If set, lookup is done in texel space rather than normalized coordinates.
    Flag!"unnormalizeCoords" unnormalizeCoords;

    /// Initializes a non-filtering SamplerInfo
    static @property SamplerInfo nearest() {
        return SamplerInfo.init;
    }

    /// Initializes a bilinear filtering SamplerInfo
    static @property SamplerInfo bilinear() {
        SamplerInfo si;
        si.minFilter = Filter.linear;
        si.magFilter = Filter.linear;
        return si;
    }

    /// Initializes a trilinear filtering SamplerInfo (that is also linear between mipmap levels)
    static @property SamplerInfo trilinear() {
        SamplerInfo si;
        si.minFilter = Filter.linear;
        si.magFilter = Filter.linear;
        si.mipmapFilter = Filter.linear;
        return si;
    }

    /// Enables comparison operation for depth/stencil texture look-ups.
    /// Use this with shadow samplers.
    SamplerInfo withCompareOp(in CompareOp op) const {
        SamplerInfo si = this;
        si.compare = some(op);
        return si;
    }

    /// Set the wrap mode for the 3 axis
    SamplerInfo withWrapMode(in WrapMode mode) const {
        SamplerInfo si = this;
        si.wrapMode = [ mode, mode, mode ];
        return si;
    }
}

interface Sampler : IAtomicRefCounted
{
    import gfx.graal.device : Device;

    /// Get the parent device
    @property Device device();

    /// Get a descriptor to this resource
    final SamplerDescriptor descriptor()
    {
        return SamplerDescriptor(this);
    }
}
