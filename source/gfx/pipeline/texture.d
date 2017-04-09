module gfx.pipeline.texture;

import gfx.device : Device, Resource, ResourceHolder;
import gfx.foundation.typecons : Option, none;
import gfx.foundation.rc : RefCounted, rcCode, Rc;
import gfx.device.factory : Factory;
import gfx.pipeline.format : isFormatted, Formatted, Format, Swizzle;
import gfx.pipeline.view : RawShaderResourceView, ShaderResourceView, RenderTargetView, DepthStencilView, DSVReadOnlyFlags;
import gfx.pipeline.state : Comparison;

import std.typecons : BitFlags;
import std.experimental.logger;

enum TextureType {
    D1, D1Array,
    D2, D2Array,
    D2Multisample, D2ArrayMultisample,
    D3, Cube, CubeArray
}

bool isCube(in TextureType tt) {
    return tt == TextureType.Cube || tt == TextureType.CubeArray;
}


enum TextureUsage {
    None = 0,
    RenderTarget = 1,
    DepthStencil = 2,
    ShaderResource = 4,
    UnorderedAccess = 8,
}
alias TexUsageFlags = BitFlags!TextureUsage;

enum CubeFace {
    None,
    PosX, NegX,
    PosY, NegY,
    PosZ, NegZ,
}

/// an array of faces in the order that is expected during cube initialization
immutable cubeFaces = [
    CubeFace.PosX, CubeFace.NegX,
    CubeFace.PosY, CubeFace.NegY,
    CubeFace.PosZ, CubeFace.NegZ,
];

struct ImageSliceInfo {
    ushort xoffset;
    ushort yoffset;
    ushort zoffset;
    ushort width;
    ushort height;
    ushort depth;
    ubyte level;
    CubeFace face;
}

struct ImageInfo {
    ushort width;
    ushort height;
    ushort depth;
    ushort numSlices;
    ubyte levels;

    ImageSliceInfo levelSliceInfo(in ubyte level) const {
        import std.algorithm : max;

        ushort mapdim(in ushort dim) {
            return cast(ushort)max(1, dim >> level);
        }

        immutable w = mapdim(width);
        immutable h = mapdim(height);
        immutable d = mapdim(depth);
        return ImageSliceInfo(
            0, 0, 0,
            w, h, d,
            level, CubeFace.None,
        );
    }
}

/// Specifies how texture coordinates outside the range `[0, 1]` are handled.
enum WrapMode {
    /// Tile the texture. That is, sample the coordinate modulo `1.0`. This is
    /// the default.
    Tile,
    /// Mirror the texture. Like tile, but uses abs(coord) before the modulo.
    Mirror,
    /// Clamp the texture to the value at `0.0` or `1.0` respectively.
    Clamp,
    /// Use border color.
    Border,
}

/// Wrapper for the level of detail of a texture
struct Lod {
    short lod;

    this (in short lod) {
        this.lod = lod;
    }
    this (in float v) {
        lod = cast(short)(v * 8f);
    }

    float opCast(T : float)() const {
        return float(lod) / 8f;
    }
}

/// A wrapper for a 8bpp color packed into a 32bit int
struct PackedColor {
    uint color;

    this (in uint color) {
        this.color = color;
    }
    this (in float[4] col) {
        color = 0;
        foreach (i; 0 .. 4) {
            immutable ubyte comp = 0xff & cast(uint)(col[i] * 255f + 0.5f);
            color |= comp << (8*(3-i));
        }
    }

    float[4] opCast(T : float[4])() const {
        float[4] col;
        foreach (i; 0 .. 4) {
            immutable ubyte comp = 0xff & (color >> (8 *(3-i)));
            col[i] = (float(comp) + 0.5f) / 255f;
        }
        return col;
    }
}

/// How to [filter](https://en.wikipedia.org/wiki/Texture_filtering) the
/// texture when sampling. They correspond to increasing levels of quality,
/// but also cost. They "layer" on top of each other: it is not possible to
/// have bilinear filtering without mipmapping, for example.
///
/// These names are somewhat poor, in that "bilinear" is really just doing
/// linear filtering on each axis, and it is only bilinear in the case of 2D
/// textures. Similarly for trilinear, it is really Quadralinear(?) for 3D
/// textures. Alas, these names are simple, and match certain intuitions
/// ingrained by many years of public use of inaccurate terminology.
enum FilterMethod {
    /// The dumbest filtering possible, nearest-neighbor interpolation.
    Scale,
    /// Add simple mipmapping.
    Mipmap,
    /// Sample multiple texels within a single mipmap level to increase
    /// quality.
    Bilinear,
    /// Sample multiple texels across two mipmap levels to increase quality.
    Trilinear,
    /// Anisotropic filtering with a given "max", must be between 1 and 16,
    /// inclusive.
    Anisotropic
}


interface SamplerRes : Resource {
}

interface TextureRes : Resource {
    void bind();
    void update(in ImageSliceInfo slice, const(ubyte)[] data);
}

struct SamplerInfo {
    FilterMethod filter;
    ubyte anisotropyMax = 16;
    WrapMode[3] wrapMode;
    Lod lodBias;
    Lod[2] lodRange;
    Option!Comparison comparison;
    PackedColor border;

    this(FilterMethod filter, WrapMode mode) {
        this.filter = filter;
        this.wrapMode = [mode, mode, mode];
        this.lodBias = Lod(0);
        this.lodRange = [Lod(-8000), Lod(8000)];
    }

    SamplerInfo withComparison(Comparison comparison) const {
        import gfx.foundation.typecons : some;
        SamplerInfo res = this;
        res.comparison = some(comparison);
        return res;
    }

    SamplerInfo withBorder(in float[4] color) const {
        SamplerInfo res = this;
        res.border = PackedColor(color);
        return res;
    }

    SamplerInfo withBorder(in uint color) const {
        SamplerInfo res = this;
        res.border = PackedColor(color);
        return res;
    }
}

class Sampler : ResourceHolder {
    mixin(rcCode);

    private Rc!SamplerRes _res;
    private Rc!RawShaderResourceView _srv;
    private SamplerInfo _info;

    this (RawShaderResourceView srv, SamplerInfo info) {
        _srv = srv;
        _info = info;
    }

    final void dispose() {
        _res.unload();
        _srv.unload();
    }

    final @property inout(SamplerRes) res() inout { return _res.obj; }

    final void pinResources(Device device) {
        if (!_srv.pinned) _srv.pinResources(device);
        _res = device.factory.makeSampler(_srv.res, _info);
    }
}

/// Untyped abstract texture class.
/// Applications must nstanciate directly typed ones such as Texture2D!Rgba8
abstract class RawTexture : ResourceHolder {
    mixin(rcCode);

    private Rc!TextureRes _res;
    private TextureType _type;
    private TexUsageFlags _usage;
    private ImageInfo _imgInfo;
    private ubyte _samples;
    private Format _format;
    private ubyte _texelSize;
    private const(ubyte)[][] _initData; // deleted after pinResources is called

    private this(TextureType type, TexUsageFlags usage, ImageInfo imgInfo, ubyte samples, Format format,
                ubyte texelSize, const(ubyte)[][] initData) {
        _type = type;
        _usage = usage;
        _imgInfo = imgInfo;
        _format = format;
        _texelSize = texelSize;
        _initData = initData;
        if (!(_usage & (TextureUsage.ShaderResource | TextureUsage.UnorderedAccess))) {
            warningf("Building texture without need for sampling. A surface may be more efficient.");
        }
    }

    final void dispose() {
        _res.unload();
    }

    final @property inout(TextureRes) res() inout { return _res; }
    final @property TextureType type() const { return _type; }
    final @property TexUsageFlags usage() const { return _usage; }
    final @property ImageInfo imgInfo() const { return _imgInfo; }
    final @property ushort width() const { return _imgInfo.width; }
    final @property ushort height() const { return _imgInfo.width; }
    final @property ushort depth() const { return _imgInfo.depth; }
    final @property ushort numSlices() const { return _imgInfo.numSlices; }
    final @property ubyte levels() const { return _imgInfo.levels; }
    final @property ubyte samples() const { return _samples; }
    final @property Format format() const { return _format; }
    final @property ubyte texelSize() const { return _texelSize; }

    final void pinResources(Device device) {
        Factory.TextureCreationDesc desc;
        desc.type = type;
        desc.usage = usage;
        desc.format = format;
        desc.imgInfo = imgInfo;
        desc.samples = _samples;
        _res = device.factory.makeTexture(desc, _initData);
        _initData = [];
    }
}


abstract class Texture(TexelF) : RawTexture if (isFormatted!TexelF) {
    alias TexelFormat = Formatted!(TexelF);
    alias Texel = TexelFormat.Surface.DataType;

    /// the texture will be initialized with the provided texels.
    /// if no initialization is required, provide empty slice
    /// otherwise, texels must consists of one slice per provided image.
    /// 2 choices for mipmaps:
    ///  1. provide only level 0 and let the driver generate mipmaps
    ///     beware: gfx-d will not generate the mipmaps if the driver can't (TODO: quality/availability in driver)
    ///  2. provide one slice per mipmap level
    /// in both case, slices will be indexed in the following manner:
    /// [ (imgIndex*numFaces + faceIndex) * numMips * mipIndex ]
    /// where imgIndex will be 0 for non-array textures and
    /// numFaces and faceIndex will be 0 for non-cube textures
    this(TextureType type, TexUsageFlags usage, ImageInfo imgInfo, ubyte samples, const(Texel)[][] texels) {
        alias format = gfx.pipeline.format.format;
        import gfx.foundation.util : untypeSlices;
        super(type, usage, imgInfo, samples, format!TexelF, cast(ubyte)Texel.sizeof, untypeSlices(texels));
    }

    final ShaderResourceView!TexelF viewAsShaderResource(ubyte minLevel, ubyte maxLevel, Swizzle swizzle) {
        import gfx.pipeline.view : TextureShaderResourceView;
        return new TextureShaderResourceView!TexelF(this, minLevel, maxLevel, swizzle);
    }

    final RenderTargetView!TexelF viewAsRenderTarget(ubyte level, Option!ubyte layer) {
        import gfx.pipeline.view : TextureRenderTargetView;
        return new TextureRenderTargetView!TexelF(this, level, layer);
    }

    final DepthStencilView!TexelF viewAsDepthStencil(ubyte level, Option!ubyte layer, DSVReadOnlyFlags flags) {
        import gfx.pipeline.view : TextureDepthStencilView;
        return new TextureDepthStencilView!TexelF(this, level, layer, flags);
    }
}

class Texture1D(TexelF) : Texture!TexelF {
    this(TexUsageFlags usage, ubyte levels, ushort width, const(Texel)[][] texels=[]) {
        super(TextureType.D1, usage, ImageInfo(width, 1, 1, 1, levels), 1, texels);
    }
}

class Texture1DArray(TexelF) : Texture!TexelF {
    this(TexUsageFlags usage, ubyte levels, ushort width, ushort numSlices, const(Texel)[][] texels=[]) {
        super(TextureType.D1Array, usage, ImageInfo(width, 1, 1, numSlices, levels), 1, texels);
    }
}

class Texture2D(TexelF) : Texture!TexelF {
    this(TexUsageFlags usage, ubyte levels, ushort width, ushort height, const(Texel)[][] texels=[]) {
        super(TextureType.D2, usage, ImageInfo(width, height, 1, 1, levels), 1, texels);
    }
}

class Texture2DArray(TexelF) : Texture!TexelF {
    this(TexUsageFlags usage, ubyte levels, ushort width, ushort height, ushort numSlices, const(Texel)[][] texels=[]) {
        super(TextureType.D2Array, usage, ImageInfo(width, height, 1, numSlices, levels), 1, texels);
    }
}

class Texture2DMultisample(TexelF) : Texture!TexelF {
    this(TexUsageFlags usage, ubyte levels, ushort width, ushort height, ubyte samples, const(Texel)[][] texels=[]) {
        super(TextureType.D2Multisample, usage, ImageInfo(width, height, 1, 1, levels), samples, texels);
    }
}

class Texture2DArrayMultisample(TexelF) : Texture!TexelF {
    this(TexUsageFlags usage, ubyte levels, ushort width, ushort height, ushort numSlices, ubyte samples, const(Texel)[][] texels=[]) {
        super(TextureType.D2ArrayMultisample, usage, ImageInfo(width, height, 1, numSlices, levels), samples, texels);
    }
}

class Texture3D(TexelF) : Texture!TexelF {
    this(TexUsageFlags usage, ubyte levels, ushort width, ushort height, ushort depth, const(Texel)[][] texels=[]) {
        super(TextureType.D3, usage, ImageInfo(width, height, depth, 1, levels), 1, texels);
    }
}

class TextureCube(TexelF) : Texture!TexelF {
    this(TexUsageFlags usage, ubyte levels, ushort width, const(Texel)[][] texels=[]) {
        super(TextureType.Cube, usage, ImageInfo(width, width, 6, 1, levels), 1, texels);
    }
}

class TextureCubeArray(TexelF) : Texture!TexelF {
    this(TexUsageFlags usage, ubyte levels, ushort width, ushort numSlices, const(Texel)[][] texels=[]) {
        super(TextureType.CubeArray, usage, ImageInfo(width, width, 6, numSlices, levels), 1, texels);
    }
}
unittest {
    import gfx.device.dummy;
    import gfx.pipeline.format : Rgba8;
    auto ctx = new DummyFactory;
    TexUsageFlags usage = TextureUsage.ShaderResource;
    auto tex = new TextureCube!Rgba8(usage, 3, 1);
}

