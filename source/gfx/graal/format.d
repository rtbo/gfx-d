/// Format description module
module gfx.graal.format;

import std.meta : AliasSeq;

/// numeric format of texel channels
enum NumFormat
{
    uNorm,
    sNorm,
    uScaled,
    sScaled,
    uInt,
    sInt,
    uFloat,
    sFloat,
    sRgb,
}

mixin(surfaceCode!());
mixin(formatCode!());

/// description of a format
struct FormatDesc
{
    SurfaceType surfaceType;
    NumFormat numFormat;
    bool packed;
}

/// get the description of a format
FormatDesc formatDesc(Format fmt) {
    return fmtDescs[cast(uint)fmt];
}

private:

enum fmtDescriptors = AliasSeq!(
    "R4_G4",            true,       NumFormat.uNorm,
    "R4_G4_B4_A4",      true,       NumFormat.uNorm,
    "B4_G4_R4_A4",      true,       NumFormat.uNorm,
    "R5_G6_B5",         true,       NumFormat.uNorm,
    "B5_G6_R5",         true,       NumFormat.uNorm,
    "R5_G5_B5_A1",      true,       NumFormat.uNorm,
    "B5_G5_R5_A1",      true,       NumFormat.uNorm,
    "A1_R5_G5_B5",      true,       NumFormat.uNorm,
    "R8",               false,      NumFormat.uNorm,    NumFormat.sNorm,
                                    NumFormat.uScaled,  NumFormat.sScaled,
                                    NumFormat.uInt,     NumFormat.sInt,     NumFormat.sRgb,
    "R8_G8",            false,      NumFormat.uNorm,    NumFormat.sNorm,
                                    NumFormat.uScaled,  NumFormat.sScaled,
                                    NumFormat.uInt,     NumFormat.sInt,     NumFormat.sRgb,
    "R8_G8_B8",         false,      NumFormat.uNorm,    NumFormat.sNorm,
                                    NumFormat.uScaled,  NumFormat.sScaled,
                                    NumFormat.uInt,     NumFormat.sInt,     NumFormat.sRgb,
    "B8_G8_R8",         false,      NumFormat.uNorm,    NumFormat.sNorm,
                                    NumFormat.uScaled,  NumFormat.sScaled,
                                    NumFormat.uInt,     NumFormat.sInt,     NumFormat.sRgb,
    "R8_G8_B8_A8",      false,      NumFormat.uNorm,    NumFormat.sNorm,
                                    NumFormat.uScaled,  NumFormat.sScaled,
                                    NumFormat.uInt,     NumFormat.sInt,     NumFormat.sRgb,
    "B8_G8_R8_A8",      false,      NumFormat.uNorm,    NumFormat.sNorm,
                                    NumFormat.uScaled,  NumFormat.sScaled,
                                    NumFormat.uInt,     NumFormat.sInt,     NumFormat.sRgb,
    "A8_B8_G8_R8",      true,       NumFormat.uNorm,    NumFormat.sNorm,
                                    NumFormat.uScaled,  NumFormat.sScaled,
                                    NumFormat.uInt,     NumFormat.sInt,     NumFormat.sRgb,
    "A2_R10_G10_B10",   true,       NumFormat.uNorm,    NumFormat.sNorm,
                                    NumFormat.uScaled,  NumFormat.sScaled,
                                    NumFormat.uInt,     NumFormat.sInt,
    "A2_B10_G10_R10",   true,       NumFormat.uNorm,    NumFormat.sNorm,
                                    NumFormat.uScaled,  NumFormat.sScaled,
                                    NumFormat.uInt,     NumFormat.sInt,
    "R16",              false,      NumFormat.uNorm,    NumFormat.sNorm,
                                    NumFormat.uScaled,  NumFormat.sScaled,
                                    NumFormat.uInt,     NumFormat.sInt,     NumFormat.sFloat,
    "R16_G16",          false,      NumFormat.uNorm,    NumFormat.sNorm,
                                    NumFormat.uScaled,  NumFormat.sScaled,
                                    NumFormat.uInt,     NumFormat.sInt,     NumFormat.sFloat,
    "R16_G16_B16",      false,      NumFormat.uNorm,    NumFormat.sNorm,
                                    NumFormat.uScaled,  NumFormat.sScaled,
                                    NumFormat.uInt,     NumFormat.sInt,     NumFormat.sFloat,
    "R16_G16_B16_A16",  false,      NumFormat.uNorm,    NumFormat.sNorm,
                                    NumFormat.uScaled,  NumFormat.sScaled,
                                    NumFormat.uInt,     NumFormat.sInt,     NumFormat.sFloat,
    "R32",              false,      NumFormat.uInt,     NumFormat.sInt,     NumFormat.sFloat,
    "R32_G32",          false,      NumFormat.uInt,     NumFormat.sInt,     NumFormat.sFloat,
    "R32_G32_B32",      false,      NumFormat.uInt,     NumFormat.sInt,     NumFormat.sFloat,
    "R32_G32_B32_A32",  false,      NumFormat.uInt,     NumFormat.sInt,     NumFormat.sFloat,
    "R64",              false,      NumFormat.uInt,     NumFormat.sInt,     NumFormat.sFloat,
    "R64_G64",          false,      NumFormat.uInt,     NumFormat.sInt,     NumFormat.sFloat,
    "R64_G64_B64",      false,      NumFormat.uInt,     NumFormat.sInt,     NumFormat.sFloat,
    "R64_G64_B64_A64",  false,      NumFormat.uInt,     NumFormat.sInt,     NumFormat.sFloat,
    "B10_G11_R11",      true,       NumFormat.uFloat,
    "E5_B9_G9_R9",      true,       NumFormat.uFloat,
    "D16",              false,      NumFormat.uNorm,
    "X8_D24",           true,       NumFormat.uNorm,
    "D32",              false,      NumFormat.uNorm,
    "S8",               false,      NumFormat.uInt,
    "D16_S8",           false,      NumFormat.uNorm,  // note: stencil is always uint
    "D24_S8",           false,      NumFormat.uNorm,
    "D32_S8",           false,      NumFormat.sFloat,
);

template SurfFmtDesc(string n, bool p, NF...) {
    alias surfName = n;
    alias packed = p;
    alias numFormats = NF;
}

alias surfFmtDescs = parseSurfFmtDescs!(fmtDescriptors);


immutable(FormatDesc)[] fmtDescs;

shared static this()
{
    import std.format : format;

    FormatDesc[] fd;

    foreach (sfd; surfFmtDescs) {
        mixin(format("alias SurfT = %s;", sfd.surfName));
        foreach (nf; sfd.numFormats) {
            mixin(format("fd ~= FormatDesc(SurfaceType.%s, NumFormat.%s, %s);\n",
                        sfd.surfName, nf, sfd.packed));
        }
    }

    import std.exception : assumeUnique;
    fmtDescs = assumeUnique(fd);
}


template parseSurfFmtDescs(Descs...) {
    static if (Descs.length == 0) {
        alias parseSurfFmtDescs = AliasSeq!();
    }
    else {
        static assert( is(typeof(Descs[0]) == string) );

        enum ns = nextString!(Descs[1 .. $]);

        alias parseSurfFmtDescs = AliasSeq!(
            SurfFmtDesc!(Descs[0 .. ns+1]),
            parseSurfFmtDescs!(Descs[ns+1..$])
        );
    }
}

size_t nextString(Args...)() {
    size_t n=0;
    foreach(arg; Args) {
        static if(is(typeof(arg) == string)) {
            break;
        }
        else {
            ++n;
        }
    }
    return n;
}

template surfaceCode() {
    import std.meta : staticMap;

    enum surfaceCode = buildCode();

    alias surfDescs = staticMap!(SurfDesc, surfFmtDescs);

    template SurfDesc(alias fmt) {
        alias name = fmt.surfName;
        alias numFormats = fmt.numFormats;
        enum redBits = name.parseNumAftLetter('R');
        enum greenBits = name.parseNumAftLetter('G');
        enum blueBits = name.parseNumAftLetter('B');
        enum alphaBits = name.parseNumAftLetter('A');
        enum stencilBits = name.parseNumAftLetter('S');
        enum depthBits = name.parseNumAftLetter('D');
        enum sharedExponentBits = name.parseNumAftLetter('E');
        enum numComponents = name.parseNumComponents();

        enum totalBits = redBits + greenBits + blueBits + alphaBits +
                         depthBits + stencilBits + sharedExponentBits +
                         name.parseNumAftLetter('X');
    }

    string buildCode()
    {
        string codeStr;

        void code(Args...)(string fmt, Args args) {
            import std.format : format;
            codeStr ~= format(fmt, args);
        }

        // enum SurfaceType

        code("/// the type of texture surface\n");
        code("public enum SurfaceType {\n");
        foreach(sd; surfDescs) {
            code("    %s,\n", sd.name);
        }
        code("}\n\n");

        // properties
        void switchProperty (string name)() {
            code("/// get the %s of an image surface\n", name);
            code("public @property uint %s(in SurfaceType st) {\n", name);
            code("    switch(st) {\n");
            foreach(sd; surfDescs) {
                mixin("enum num = sd."~name~";");
                static if (num > 0) {
                    code("    case SurfaceType.%s: return %s;\n", sd.name, num);
                }
            }
            code("    default: return 0;\n");
            code("    }\n");
            code("}\n\n");
        }

        switchProperty!("totalBits")();
        switchProperty!("numComponents")();
        switchProperty!("redBits")();
        switchProperty!("greenBits")();
        switchProperty!("blueBits")();
        switchProperty!("alphaBits")();
        switchProperty!("depthBits")();
        switchProperty!("stencilBits")();
        switchProperty!("sharedExponentBits")();

        // trait structs
        foreach(sd; surfDescs) {
            code("/// static descriptor of surface type %s\n", sd.name);
            code("public struct %s {\n", sd.name);
            code("    enum surfaceType = SurfaceType.%s;\n", sd.name);
            code("    enum totalBits = %s;\n", sd.totalBits);
            code("    enum redBits = %s;\n", sd.redBits);
            code("    enum greenBits = %s;\n", sd.greenBits);
            code("    enum blueBits = %s;\n", sd.blueBits);
            code("    enum alphaBits = %s;\n", sd.alphaBits);
            code("    enum depthBits = %s;\n", sd.depthBits);
            code("    enum stencilBits = %s;\n", sd.stencilBits);
            code("    enum numComponents = %s;\n", sd.numComponents);
            code("    alias numFormats = AliasSeq!(");
                foreach(nf; sd.numFormats) code("NumFormat.%s, ", nf);
            code(");\n");
            // evaluate fmtBaseName for each surface instead of each format to lower ctfe work
            code(
                "    private enum fmtBaseName = \"%s\";\n",
                formatBaseName(sd.name, sd.redBits, sd.greenBits, sd.blueBits, sd.alphaBits)
            );
            code("}\n");
        }
        return codeStr;
    }

}

template formatCode()
{
    enum formatCode = buildCode();

    string buildCode() {
        string codeStr;

        void code(Args...)(string fmt, Args args) {
            import std.format : format;
            codeStr ~= format(fmt, args);
        }

        code("/// the format of an image\n");
        code("public enum Format {\n");
        code("    undefined = 0,\n");
        int i = 1;
        foreach (sfd; surfFmtDescs) {
            mixin("alias SurfT = "~sfd.surfName~";");
            foreach (nf; sfd.numFormats) {
                const name = formatEnumName(SurfT.fmtBaseName, nf);
                code("    %s = %s,\n", name, i++);
            }
        }
        code("}\n");

        foreach (sfd; surfFmtDescs) {
            mixin("alias SurfT = "~sfd.surfName~";");
            foreach (nf; sfd.numFormats) {
                const name = formatTypeName(SurfT.fmtBaseName, nf);
                code("/// static descriptor of image format %s\n", name);
                code("public struct %s {\n", name);
                code("    enum surfaceType = SurfaceType.%s;\n", sfd.surfName);
                code("    enum numFormat = NumFormat.%s;\n", nf);
                code("    enum packed = %s;\n", sfd.packed);
                code("}\n");
            }
        }

        return codeStr;
    }
}

string formatBaseName(in string name, in uint redBits, in uint greenBits,
                      in uint blueBits, in uint alphaBits) {
    import std.algorithm : all, filter;
    import std.array : array;
    import std.conv : to;
    import std.range : chain, only;
    import std.uni : isNumber, toLower;

    const contractNumComps = redBits > 0 &&
        only(greenBits, blueBits, alphaBits)
            .filter!(n => n != 0)
            .all!(n => n == redBits);

    string res = name.toLower
                .filter!(c => c != '_').to!string;
    if (contractNumComps) {
        res = res.filter!(c => !c.isNumber).to!string ~ redBits.to!string;
    }
    return res;
}

string formatEnumName(string baseName, NumFormat nf) {
    import std.format : format;
    return format("%s_%s", baseName, nf);
}
string formatTypeName(string baseName, NumFormat nf) {
    import std.format : format;
    import std.string : capitalize;
    return format("%s_%s", capitalize(baseName), capitalize(format("%s", nf)));
}

ubyte parseNumComponents(string name) {
    import std.uni : isAlpha;
    import std.algorithm : count;

    return cast(ubyte)name.count!((c) {
        return c.isAlpha && c != '_' && c != 'E'; // shared exponent does not count as a component
    });
}

ubyte parseNumAftLetter(string name, char letter) {
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
