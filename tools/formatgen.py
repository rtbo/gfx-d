#! /usr/bin/env python3


def isalpha(s):
    return s.isalpha()

def lower(s):
    return s.lower()


def parseNumAfterLetter(string, letter):
    num = ""
    while len(string):
        if string[0] == letter:
            string = string[1:]
            while len(string) and string[0].isdigit():
                num += string[0]
                string = string[1:]
            break
        string = string[1:]
    if len(num): return int(num)
    else: return 0

def parseNumComponents(string):
    return sum(1 for _ in filter(isalpha, string))

class Surface:
    def __init__(self, name, packed, numFmts):
        self.name = name
        self.packed = packed
        self.numFmts = numFmts
        self.numComponents = parseNumComponents(name)
        self.redBits = parseNumAfterLetter(name, "R")
        self.greenBits = parseNumAfterLetter(name, "G")
        self.blueBits = parseNumAfterLetter(name, "B")
        self.alphaBits = parseNumAfterLetter(name, "A")
        self.sharedExpBits = parseNumAfterLetter(name, "E")
        self.depthBits = parseNumAfterLetter(name, "D")
        self.stencilBits = parseNumAfterLetter(name, "S")
        self.totalBits = parseNumAfterLetter(name, "X")                 \
                        + self.redBits + self.greenBits + self.blueBits \
                        + self.alphaBits + self.sharedExpBits           \
                        + self.depthBits + self.stencilBits
        self.colorBits = self.redBits + self.greenBits + self.blueBits \
                        + self.alphaBits + self.sharedExpBits

        letters = filter((lambda c: isalpha(c)), name)

        self.redShift = 0
        self.greenShift = 0
        self.blueShift = 0
        self.alphaShift = 0
        comps = []
        for l in letters:
            bits = 0
            if l == "R":
                bits = self.redBits
            elif l == "G":
                bits = self.greenBits
            elif l == "B":
                bits = self.blueBits
            elif l == "A":
                bits = self.alphaBits
            if bits == 0: continue
            if "R" in comps:
                self.redShift += bits
            if "G" in comps:
                self.greenShift += bits
            if "B" in comps:
                self.blueShift += bits
            if "A" in comps:
                self.alphaShift += bits
            comps.append(l)


    def numFormatsStr(self):
        return ", ".join( ("NumFormat."+nf for nf in self.numFmts) )

    def formatBaseName(self):
        contract = self.redBits > 0                                         \
                and (self.greenBits == 0 or self.greenBits == self.redBits) \
                and (self.blueBits == 0 or self.blueBits == self.redBits)   \
                and (self.alphaBits == 0 or self.alphaBits == self.redBits)

        res = self.name.replace("_", "").lower()

        if contract:
            resc = ""
            for c in res:
                if c.isdigit(): continue
                resc += c
            res = resc + str(self.redBits)

        return res



def parseSurfaces():
    from formatdata import formatData
    surfaces = []
    for surf in formatData:
        s = Surface(surf[0], surf[1], surf[2])
        surfaces.append(s)
    return surfaces


def issueSurfaceEnum(surfaces, cg):
    cg()
    cg("/// Describes the components of a surface")
    cg("enum SurfaceType {")
    with cg.indentBlock():
        for s in surfaces:
            cg("%s,", s.name)
    cg("}")


def issueFormatEnum(surfaces, cg):
    cg()
    cg("/// The format of an Image.")
    cg("enum Format")
    cg("{")
    with cg.indentBlock():
        cg("undefined = 0,")
        num = 1
        for s in surfaces:
            for nf in s.numFmts:
                cg("%s_%s = %s,", s.formatBaseName(), nf, num)
                num += 1
    cg("}")

def issueSurfProps(surfaces, cg):
    def switchProp(propName):
        cg()
        cg("/// Get the %s of an image surface", propName)
        cg("@property uint %s (in SurfaceType st) pure", propName)
        cg("{")
        with cg.indentBlock():
            cg("switch(st) {")
            for s in surfaces:
                bits = getattr(s, propName)
                if bits > 0:
                    cg("case SurfaceType.%s: return %s;", s.name, bits)
            cg("default: return 0;")
            cg("}")
        cg("}")
        cg()
        cg("/// Get the %s of a format", propName)
        cg("@property uint %s (in Format format) pure", propName)
        cg("{")
        with cg.indentBlock():
            cg("return formatDesc(format).surfaceType.%s;", propName)
        cg("}")

    switchProp("totalBits")
    switchProp("numComponents")
    switchProp("colorBits")
    switchProp("redBits")
    switchProp("greenBits")
    switchProp("blueBits")
    switchProp("alphaBits")
    switchProp("redShift")
    switchProp("greenShift")
    switchProp("blueShift")
    switchProp("alphaShift")
    switchProp("sharedExpBits")
    switchProp("depthBits")
    switchProp("stencilBits")


def issueSurfStructs(surfaces, cg):
    for s in surfaces:
        cg()
        cg("/// Static descriptor of SurfaceType.%s.", s.name)
        cg("struct %s", s.name)
        cg("{")
        with cg.indentBlock():
            cg("enum totalBits = %s;", s.totalBits)
            cg("enum numComponents = %s;", s.numComponents)
            cg("enum redBits = %s;", s.redBits)
            cg("enum greenBits = %s;", s.greenBits)
            cg("enum blueBits = %s;", s.blueBits)
            cg("enum alphaBits = %s;", s.alphaBits)
            cg("enum sharedExpBits = %s;", s.sharedExpBits)
            cg("enum depthBits = %s;", s.depthBits)
            cg("enum stencilBits = %s;", s.stencilBits)
            cg()
            cg("import std.meta : AliasSeq;")
            cg("alias numFormats = AliasSeq!(")
            with cg.indentBlock():
                cg(s.numFormatsStr())
            cg(");")
        cg("}")


def issueFormatStructs(surfaces, cg):
    for fd in ((s.name, s.formatBaseName(), nf, s.packed) for s in surfaces for nf in s.numFmts):
        surfName = fd[0]
        fbn = fd[1]
        nf = fd[2]
        packed = fd[3]
        fmtName = "{}_{}".format(fbn, nf)
        structName = "{}_{}".format(fbn[0].upper() + fbn[1:], nf)
        cg()
        cg("/// Static descriptor of Format.%s", fmtName)
        cg("struct %s", structName)
        cg("{")
        with cg.indentBlock():
            cg("alias SurfType = %s;", surfName)
            cg("enum surfType = SurfaceType.%s;", surfName)
            cg("enum numFormat = NumFormat.%s;", nf)
            cg("enum packed = %s;", "true" if packed else "false")
        cg("}")


def issueFmtDescs(surfaces, cg):
    cg()
    cg("private immutable(FormatDesc[]) fmtDescs;")
    cg()
    cg("shared static this()")
    cg("{")
    with cg.indentBlock():
        cg("import std.exception : assumeUnique;")
        cg("fmtDescs = assumeUnique( [")
        with cg.indentBlock():
            cg("FormatDesc.init,")
            for fd in ((s.name, nf, s.packed) for s in surfaces for nf in s.numFmts):
                cg(
                    "FormatDesc(SurfaceType.%s, NumFormat.%s, %s),",
                    fd[0], fd[1], "true" if fd[2] else "false"
                )
        cg("] );")
    cg("}")



if __name__ == "__main__":

    from codegen import CodeGen

    codeGen = CodeGen()

    surfaces = parseSurfaces()
    issueSurfaceEnum(surfaces, codeGen)
    issueFormatEnum(surfaces, codeGen)
    issueSurfProps(surfaces, codeGen)
    issueSurfStructs(surfaces, codeGen)
    issueFormatStructs(surfaces, codeGen)
    issueFmtDescs(surfaces, codeGen)

    from os import path

    toolsDir = path.dirname(path.realpath(__file__))
    gfxDir = path.dirname(toolsDir)

    inPath = path.join(toolsDir, "format.in.d")
    outPath = path.join(gfxDir, "graal", "source", "gfx", "graal", "format.d")

    with open(inPath, "r") as inF, open(outPath, "w") as outF:
        for line in (l.rstrip() for l in inF):
            if line.startswith("//## code_gen ##//"):
                codeGen.writeOut(outF)
            else:
                print(line, file=outF)
