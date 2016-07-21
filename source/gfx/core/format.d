module gfx.core.format;

import std.meta : AliasSeq, staticIndexOf;
import std.typecons : Tuple, tuple, Typedef;


mixin ChannelCode!(
    "Int",      int,    "Texture|Render",
    "Uint",     uint,   "Texture|Render",
    "Inorm",    float,  "Texture|Render|Blend",
    "Unorm",    float,  "Texture|Render|Blend",
    "Float",    float,  "Texture|Render|Blend",
    "Srgb",     float,  "Texture|Render|Blend",
);

enum isChannel(T) = isTextureChannel!T || isRenderChannel!T || isBlendChannel!T;

static assert(isChannel!Srgb);
static assert(!isChannel!short);
static assert(is(Float.ShaderType == float));

unittest {
    assert(Int.channelType == ChannelType.Int);
    assert(Unorm.channelType == ChannelType.Unorm);
}


// TODO: cast the following types
alias U8Norm = Typedef!ubyte;
alias I8Norm = Typedef!byte;
alias U16Norm = Typedef!ushort;
alias I16Norm = Typedef!short;
alias Half = Typedef!(short, short.init, "half");

/// template to be specialized to provide
/// alias type definitions of Surface, Channel and View
template Formatted(T) {}

/// tests if a type actually provides the correct
/// Formatted specialization
template isFormatted(T) {
    alias Fmtted = Formatted!T;
    static if (is(Fmtted.Surface) && is(Fmtted.Channel) && is(Fmtted.View)) {
        enum isFormatted =
            isSurface!(Fmtted.Surface) &&
            isChannel!(Fmtted.Channel);
    }
    else {
        enum isFormatted = false;
    }
}


mixin SurfaceCode!(
// empty strings are parsing helpers
//  name                data type   surfaces                    channels
"", "R4_G4",            ubyte,      "Texture|Render",           Unorm,
"", "R4_G4_B4_A4",      ushort,     "Texture|Render",           Unorm,
"", "R5_G5_B5_A1",      ushort,     "Texture|Render",           Unorm,
"", "R5_G6_B5",         ushort,     "Texture|Render",           Unorm,
"", "R8",               ubyte,      "Texture|Render|Buffer",    Int, Uint, Inorm, Unorm,
"", "R8_G8",            ubyte[2],   "Texture|Render|Buffer",    Int, Uint, Inorm, Unorm,
"", "R8_G8_B8_A8",      ubyte[4],   "Texture|Render|Buffer",    Int, Uint, Inorm, Unorm, Srgb,
"", "R10_G10_B10_A2",   uint,       "Texture|Render|Buffer",    Uint, Unorm, Float,
"", "R11_G11_B10",      uint,       "Texture|Render|Buffer",    Unorm, Float,
"", "R16",              ushort,     "Texture|Render|Buffer",    Int, Uint, Inorm, Unorm, Float,
"", "R16_G16",          ushort[2],  "Texture|Render|Buffer",    Int, Uint, Inorm, Unorm, Float,
"", "R16_G16_B16",      ushort[3],  "Texture|Render|Buffer",    Int, Uint, Inorm, Unorm, Float,
"", "R16_G16_B16_A16",  ushort[4],  "Texture|Render|Buffer",    Int, Uint, Inorm, Unorm, Float,
"", "R32",              uint,       "Texture|Render|Buffer",    Int, Uint, Float,
"", "R32_G32",          uint[2],    "Texture|Render|Buffer",    Int, Uint, Float,
"", "R32_G32_B32",      uint[3],    "Texture|Render|Buffer",    Int, Uint, Float,
"", "R32_G32_B32_A32",  uint[4],    "Texture|Render|Buffer",    Int, Uint, Float,
"", "D16",              Half,       "Texture|Depth",            Unorm,
"", "D24",              float,      "Texture|Depth",            Unorm,       // alpha and stencil bits are 0. is it correct?
"", "D24_S8",           uint,       "Texture|Depth|Stencil",    Unorm, Uint, // numComponents is 2. is it correct?
"", "D32",              float,      "Texture|Depth",            Float,
);


enum isSurface(T) =
        isTextureSurface!T ||
        isRenderSurface!T ||
        isBufferSurface!T ||
        isDepthSurface!T ||
        isStencilSurface!T;

enum isDepthStencilSurface(T) = isDepthSurface!T || isStencilSurface!T;

static assert(isSurface!R8_G8 && isSurface!D24_S8);
static assert(!isSurface!uint);


template SurfaceHasChannel(Surf, Ch) if (isSurface!Surf && isChannel!Ch) {
    static if(staticIndexOf!(Ch, Surf.Channels) != -1) {
        enum SurfaceHasChannel = true;
    }
    else {
        enum SurfaceHasChannel = false;
    }
}

static assert( SurfaceHasChannel!(R8_G8_B8_A8,      Srgb));
static assert(!SurfaceHasChannel!(R8_G8_B8_A8,      Float));
static assert( SurfaceHasChannel!(R16_G16_B16_A16,  Unorm));
static assert(!SurfaceHasChannel!(R16_G16_B16_A16,  Srgb));
static assert( SurfaceHasChannel!(R32_G32,          Uint));
static assert(!SurfaceHasChannel!(R32_G32,          Inorm));

unittest {
    assert( SurfaceType.R8_G8_B8_A8     .hasChannel(ChannelType.Srgb));
    assert(!SurfaceType.R8_G8_B8_A8     .hasChannel(ChannelType.Float));
    assert( SurfaceType.R16_G16_B16_A16 .hasChannel(ChannelType.Unorm));
    assert(!SurfaceType.R16_G16_B16_A16 .hasChannel(ChannelType.Srgb));
    assert( SurfaceType.R32_G32         .hasChannel(ChannelType.Uint));
    assert(!SurfaceType.R32_G32         .hasChannel(ChannelType.Inorm));
}


/// Standard 8bits RGBA format.
alias Rgba8 = Tuple!(R8_G8_B8_A8, Unorm);
/// Standard 8bit gamma transforming RGB format.
alias Srgba8 = Tuple!(R8_G8_B8_A8, Srgb);
/// Standard HDR floating-point format with 10 bits for RGB components
/// and 2 bits for the alpha.
alias Rgb10a2F = Tuple!(R10_G10_B10_A2, Float);
/// Standard 16-bit floating-point RGBA format.
alias Rgba16F = Tuple!(R16_G16_B16_A16, Float);
/// Standard 32-bit floating-point RGBA format.
alias Rgba32F = Tuple!(R32_G32_B32_A32, Float);
/// Standard 24-bit depth format.
alias Depth = Tuple!(D24, Unorm);
/// Standard 24-bit depth format with 8-bit stencil.
alias DepthStencil = Tuple!(D24_S8, Unorm);
/// Standard 32-bit floating-point depth format.
alias Depth32F = Tuple!(D32, Float);

template Formatted(T: Tuple!(S, C), S, C)
        if (isSurface!S && isChannel!C && SurfaceHasChannel!(S, C)) {
    alias Surface = S;
    alias Channel = C;
    alias View = Channel.ShaderType[S.numComponents];
}

static assert(is(Formatted!(Rgba8).Surface));
static assert(isFormatted!Rgba8);


struct Format {
    SurfaceType surface;
    ChannelType channel;

    this(SurfaceType surface, ChannelType channel) {
        this.surface = surface;
        this.channel = channel;
    }
}


@property Format format(T)() if(isFormatted!T) {
    alias F = Formatted!T;
    return Format(F.Surface.surfaceType, F.Channel.channelType);
}


unittest {
    auto f = format!Rgba8;
    assert(f.surface == SurfaceType.R8_G8_B8_A8);
    assert(f.channel == ChannelType.Unorm);
}


/// Source channel in a swizzle configuration. Some may redirect onto
/// different physical channels, some may be hardcoded to 0 or 1.
enum ChannelSource {
    Zero, One,
    X, Y, Z, W,
}

/// Channel swizzle configuration for the resource views.
/// Note: It's not currently mirrored at compile-time,
/// thus providing less safety and convenience.
alias Swizzle = Tuple!(ChannelSource, ChannelSource, ChannelSource, ChannelSource);
/// Create a new swizzle where each channel is unmapped.
Swizzle newSwizzle() {
    return tuple(ChannelSource.X, ChannelSource.Y, ChannelSource.Z, ChannelSource.W);
}



private string formatCode(size_t numComps, T, Ch, Surf)()
        if(isChannel!Ch && isSurface!Surf) {
    import std.format : format;
    string sizeSpec = numComps > 1 ? format("[%s]", numComps) : "";
    string res;
    res ~= format("template Formatted(T : %s%s) {\n", T.stringof, sizeSpec);
    res ~= format("    alias Surface = %s;\n", Surf.stringof);
    res ~= format("    alias Channel = %s;\n", Ch.stringof);
    res ~= format("    alias View = Channel.ShaderType%s;\n", sizeSpec);
    res ~= format("}\n");
    return res;
}

private string formatCode_8bit(T, Ch)() {
    string res;
    res ~= formatCode!(1, T, Ch, R8);
    res ~= formatCode!(2, T, Ch, R8_G8);
    res ~= formatCode!(4, T, Ch, R8_G8_B8_A8);
    return res;
}

private string formatCode_16bit(T, Ch)() {
    string res;
    res ~= formatCode!(1, T, Ch, R16);
    res ~= formatCode!(2, T, Ch, R16_G16);
    res ~= formatCode!(3, T, Ch, R16_G16_B16);
    res ~= formatCode!(4, T, Ch, R16_G16_B16_A16);
    return res;
}

private string formatCode_32bit(T, Ch)() {
    string res;
    res ~= formatCode!(1, T, Ch, R32);
    res ~= formatCode!(2, T, Ch, R32_G32);
    res ~= formatCode!(3, T, Ch, R32_G32_B32);
    res ~= formatCode!(4, T, Ch, R32_G32_B32_A32);
    return res;
}

mixin(formatCode_8bit!(ubyte, Uint)());
mixin(formatCode_8bit!(byte, Int)());
mixin(formatCode_8bit!(U8Norm, Unorm)());
mixin(formatCode_8bit!(I8Norm, Inorm)());
mixin(formatCode_16bit!(ushort, Uint)());
mixin(formatCode_16bit!(short, Int)());
mixin(formatCode_16bit!(U16Norm, Unorm)());
mixin(formatCode_16bit!(I16Norm, Inorm)());
mixin(formatCode_16bit!(Half, Float)());
mixin(formatCode_32bit!(uint, Uint)());
mixin(formatCode_32bit!(int, Int)());
mixin(formatCode_32bit!(float, Float)());

version(unittest) {
    alias Fmt = Formatted!(float[4]);
    static assert(is(Fmt.Surface == R32_G32_B32_A32));
    static assert(is(Fmt.Channel == Float));
    static assert(is(Fmt.View == float[4]));
}



private:

mixin template ChannelCode(Specs...) {

    mixin(channelCodeInject());

    private string channelCodeInject(bool genProto=false)() {

        string codeStr;

        void code(Args...)(string fmt, Args args) {
            import std.format : format;
            static if(!genProto) {
                codeStr ~= format(fmt, args);
            }
        }
        void proto(Args...)(string fmt, Args args) {
            import std.format : format;
            static if(genProto) {
                codeStr ~= format(fmt, args);
            }
        }


        proto("enum ChannelType;\n\n");
        code("enum ChannelType {\n");
        foreach(cs; ChanSpecs) {
            code("    %s,\n", cs.name);
        }
        code("}\n\n");

        foreach(cs; ChanSpecs) {
            code("struct %s {\n", cs.name);
            code("    alias ShaderType = %s;\n", cs.Type.stringof);
            code("    enum channelType = ChannelType.%s;\n", cs.name);
            code("}\n\n");
        }

        void switchTemplate (string name)() {
            proto("template is%sChannel(T);\n\n", name);
            code("template is%sChannel(T) {\n", name);
            code("    static if (\n");
            bool fst = true;
            foreach(cs; ChanSpecs) {
                import std.algorithm : canFind;
                if (cs.impl.canFind(name)) {
                    string or = fst ? "  " : "||";
                    code("        %s is(T == %s)\n", or, cs.name);
                    fst = false;
                }
            }
            code("    ) {\n");
            code("        enum is%sChannel = true;\n", name);
            code("    } else {\n");
            code("        enum is%sChannel = false;\n", name);
            code("    }\n}\n\n");
        }

        switchTemplate!("Texture")();
        switchTemplate!("Render")();
        switchTemplate!("Blend")();

        return codeStr;
    }


    private template ChanSpec(string n, T, string i) {
        alias name = n;
        alias Type = T;
        alias impl = i;
    }

    private alias ChanSpecs = parseChanSpecs!Specs;

    private template parseChanSpecs(Specs...) {
        static if (Specs.length == 0) {
            alias parseChanSpecs = AliasSeq!();
        }
        else {
            alias parseChanSpecs = AliasSeq!(
                ChanSpec!(Specs[0..3]),
                parseChanSpecs!(Specs[3..$]));
        }
    }
}

mixin template SurfaceCode(Specs...) {

    mixin(surfaceCodeInject());

    // with proto enabled, only generates prototypes
    private string surfaceCodeInject(bool genProto=false)() {

        string codeStr;

        void code(Args...)(string fmt, Args args) {
            import std.format : format;
            static if(!genProto) {
                codeStr ~= format(fmt, args);
            }
        }
        void proto(Args...)(string fmt, Args args) {
            import std.format : format;
            static if(genProto) {
                codeStr ~= format(fmt, args);
            }
        }


        // enum SurfaceType
        proto("enum SurfaceType;\n\n");
        code("enum SurfaceType {\n");
        foreach(ss; SurfSpecs) {
            code("    %s,\n", ss.name);
        }
        code("}\n\n");

        // properties
        void switchProperty (string name)() {
            proto("@property ubyte %s(SurfaceType st);\n\n", name);
            code("@property ubyte %s(SurfaceType st) {\n", name);
            code("    final switch(st) {\n");
            foreach(ss; SurfSpecs) {
                mixin("enum num = ss."~name~";");
                code("        case SurfaceType.%s: return %s;\n", ss.name, num);
            }
            code("    }\n");
            code("}\n\n");
        }

        switchProperty!("totalBits")();
        switchProperty!("redBits")();
        switchProperty!("greenBits")();
        switchProperty!("blueBits")();
        switchProperty!("alphaBits")();
        switchProperty!("depthBits")();
        switchProperty!("stencilBits")();


        // trait structs

        foreach(ss; SurfSpecs) {
            proto("struct %a;\n\n", ss.name);
            code("struct %s {\n", ss.name);
            code("    alias DataType = %s;\n", (ss.DataType).stringof);
            code("    enum surfaceType = SurfaceType.%s;\n", ss.name);
            code("    enum totalBits = %s;\n", ss.totalBits);
            code("    enum redBits = %s;\n", ss.redBits);
            code("    enum greenBits = %s;\n", ss.greenBits);
            code("    enum blueBits = %s;\n", ss.blueBits);
            code("    enum alphaBits = %s;\n", ss.alphaBits);
            code("    enum depthBits = %s;\n", ss.depthBits);
            code("    enum stencilBits = %s;\n", ss.stencilBits);
            code("    enum numComponents = %s;\n", ss.numComponents);
            code("    alias Channels = AliasSeq!(");
            foreach(ch; ss.Chans) code("%s, ", ch.stringof);
            code(");\n");
            code("}\n");
        }
        code("\n");


        // templates
        void switchTemplate (string name)() {
            proto("template is%sSurface(T);\n\n", name);
            code("template is%sSurface(T) {\n", name);
            code("    static if (\n");
            bool fst = true;
            foreach(ss; SurfSpecs) {
                import std.algorithm : canFind;
                if (ss.surf.canFind(name)) {
                    string or = fst ? "  " : "||";
                    code("        %s is(T == %s)\n", or, ss.name);
                    fst = false;
                }
            }
            code("    ) {\n");
            code("        enum is%sSurface = true;\n", name);
            code("    } else {\n");
            code("        enum is%sSurface = false;\n", name);
            code("    }\n}\n\n");
        }

        switchTemplate!("Buffer")();
        switchTemplate!("Texture")();
        switchTemplate!("Render")();
        switchTemplate!("Depth")();
        switchTemplate!("Stencil")();
        //switchTemplate!("Blend")();

        proto("bool hasChannel(SurfaceType surf, ChannelType ch);\n\n");
        code("bool hasChannel(SurfaceType surf, ChannelType ch) {\n");
        code("    final switch(surf) {\n");
        foreach(ss; SurfSpecs) {
            code("    case SurfaceType.%s:\n", ss.name);
            code("        switch(ch) {\n");
            foreach(ch; ss.Chans) {
                code("        case ChannelType.%s:\n", ch.stringof);
            }
            code("            return true;\n");
            code("        default: return false;\n");
            code("        }\n");
        }
        code("    }\n");
        code("}\n\n");


        return codeStr;
    }

    private alias SurfSpecs = parseSurfSpecs!Specs;

    private template SurfSpec(string n, DT, string s, CH...) {
        alias   name = n;
        alias   DataType = DT;
        alias   surf = s;
        alias   Chans = CH;
        enum    totalBits = DT.sizeof * 8;
        enum    redBits = parseRedBits(n);
        enum    greenBits = parseGreenBits(n);
        enum    blueBits = parseBlueBits(n);
        enum    alphaBits = parseAlphaBits(n);
        enum    depthBits = parseDepthBits(n);
        enum    stencilBits = parseStencilBits(n);
        enum    numComponents = parseNumComponents(n);
    }

    private template parseSurfSpecs(Specs...) {
        static if (Specs.length == 0) {
            alias parseSurfSpecs = AliasSeq!();
        }
        else {
            static assert(Specs[0] == "");
            enum nes = nextEmptyStr!(Specs[1..$])();
            alias parseSurfSpecs = AliasSeq!(
                SurfSpec!(Specs[1..nes+1]),
                parseSurfSpecs!(Specs[nes+1..$]));
        }
    }

    private ubyte parseRedBits(string name) {
        return parseNumAftLetter(name, 'R');
    }

    private ubyte parseGreenBits(string name) {
        return parseNumAftLetter(name, 'G');
    }

    private ubyte parseBlueBits(string name) {
        return parseNumAftLetter(name, 'B');
    }

    private ubyte parseAlphaBits(string name) {
        return parseNumAftLetter(name, 'A');
    }

    private ubyte parseDepthBits(string name) {
        return parseNumAftLetter(name, 'D');
    }

    private ubyte parseStencilBits(string name) {
        return parseNumAftLetter(name, 'S');
    }

    private ubyte parseNumComponents(string name) {
        import std.uni : isAlpha;
        import std.algorithm : count;

        return cast(ubyte)name.count!((c) {
            return c.isAlpha && c != '_';
        });
    }

    private ubyte parseNumAftLetter(string name, char letter) {
        import std.algorithm : find, countUntil;
        import std.uni : isNumber;
        import std.conv : to;

        string n = name.find(letter);
        if (n.length == 0) return 0;
        n = n[1 .. $];
        auto end = n.countUntil!((c) {
            return !c.isNumber;
        });
        if (end != -1) n = n[0 .. end];
        return n.to!ubyte;
    }

    private size_t nextEmptyStr(Args...)() {
        size_t n=0;
        foreach(arg; Args) {
            static if(is(typeof(arg) == string) && arg == "") {
                break;
            }
            else {
                ++n;
            }
        }
        return n;
    }

}
