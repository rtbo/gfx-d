#! /usr/bin/env python3
"""
    Open GL D bindings generator.
    Reads OpenGL XML API definition to produce the D bindings code.
"""

import re
from reg import GeneratorOptions, OutputGenerator, regSortFeatures

# General utility

# noneStr - returns string argument, or "" if argument is None.
# Used in converting etree Elements into text.
#   str - string to convert
def noneStr(str):
    if (str):
        return str
    else:
        return ""

# SourceFile: gather and format the source code in the different sections
# and issue them into a file
class SourceFile(object):
    '''
    buffer to append code in various sections of a file
    in any order
    '''

    _one_indent_level = '    '

    def __init__(self):
        self._lines = []
        self._indent = 0


    def indent_block(self):
        class Indenter(object):
            def __init__(self, sf):
                self.sf = sf
            def __enter__(self):
                self.sf.indent()
            def __exit__(self, type, value, traceback):
                self.sf.unindent()
        return Indenter(self)

    def indent(self):
        '''
        adds one level of indentation to the current section
        '''
        self._indent += 1

    def unindent(self):
        '''
        removes one level of indentation to the current section
        '''
        self._indent -= 1

    def __call__(self, fmt="", *args):
        '''
        Append a line to the file at in its current section and
        indentation of the current section
        '''
        indent = SourceFile._one_indent_level * self._indent
        self._lines.append(indent + (fmt % args))


    def writeOut(self, outFile):
        for line in self._lines:
            print(line.rstrip(), file=outFile)


# D specific utilities

re_single_const = re.compile(r"^const\s+(.+)\*\s*$")
re_double_const = re.compile(r"^const\s+(.+)\*\s+const\*\s*$")

def convertDTypeConst( typ ):
    """
    Converts C const syntax to D const syntax
    """
    doubleConstMatch = re.match( re_double_const, typ )
    if doubleConstMatch:
        return "const({}*)*".format( doubleConstMatch.group( 1 ))
    else:
        singleConstMatch = re.match( re_single_const, typ )
        if singleConstMatch:
            return "const({})*".format( singleConstMatch.group( 1 ))
    return typ

def mapDName(name):
    if name in [ "ref" ]:
        return name + "_"
    else:
        return name

# generator options

class DGeneratorOptions(GeneratorOptions):
    """Represents options during C header production from an API registry"""
    def __init__(self,
                 filename = None,
                 apiname = None,
                 profile = None,
                 versions = '.*',
                 emitversions = '.*',
                 defaultExtensions = None,
                 addExtensions = None,
                 removeExtensions = None,
                 sortProcedure = regSortFeatures,
                 module = "",
                 stmts = []):
        GeneratorOptions.__init__(self, filename, apiname, profile,
                                  versions, emitversions, defaultExtensions,
                                  addExtensions, removeExtensions, sortProcedure)
        self.module = module
        self.stmts = stmts

# the main generator

class DGenerator(OutputGenerator):

    class FeatureGuard:
        def __init__(self, versionGuard, stmts):
            self.name = ""
            self.versionGuard = versionGuard
            self.stmts = stmts

        def begin(self, sf):
            if len(self.versionGuard):
                sf("version(%s) {", self.versionGuard)
                sf.indent()
        def end(self, sf):
            if len(self.versionGuard):
                sf.unindent()
                sf("}")

    class Feature:
        def __init__(self, name, guard):
            self.name = name
            self.guard = guard
            self.baseTypes = []
            self.structDecls = []
            self.funcptrs = []      # Command[]
            self.consts = []
            self.cmds = []          # Command[]

        def beginGuard(self, sf):
            if self.guard != None:
                self.guard.begin(sf)

        def endGuard(self, sf):
            if self.guard != None:
                self.guard.end(sf)

    class BaseType:
        def __init__(self, name, type):
            self.name = name
            self.type = type

    class Const:
        def __init__(self, name, value):
            self.name = name
            self.value = value

    class Param:
        def __init__(self, name, type):
            self.name = name
            self.type = type

    class Command:
        def __init__(self, name, type, params, alias):
            self.name = name
            self.type = type
            self.params = params
            self.alias = alias
            self.field = name[2].lower() + name[3:]

    class Extension:
        def __init__(self, name, cmds):
            self.name = name
            self.cmds = cmds

    class GlCore:
        def __init__(self, name, clsName, parentClsName, cmds):
            self.name = name
            self.clsName = clsName
            self.parentClsName = parentClsName
            self.cmds = cmds

    def __init__(self):
        super().__init__()
        self.features = []
        self.feature = None
        self.featureGuards = {}
        for k in self.featureGuards:
            self.featureGuards[k].name = k
        self.extensions = []
        self.cores = []
        self.lastLoaderClsName = ""

    def logMsg(self, level, *args):
        # shut down logging
        pass

    def beginFile(self, opts):
        # generator base class open and close a file
        # don't want that here as we may output to stdout
        # not calling super on purpose

        # Everything is written in endFile

        self.opts = opts
        self.apiname = opts.apiname
        self.versionTag = self.apiname.upper() + "_VERSION_"
        self.base = self.apiname[0].upper() + self.apiname[1:].lower()
        self.baseCls = self.base + "Cmds"
        self.versionEnum = self.base + "Version"
        self.versionField = self.base.lower() + "Version"
        humanNames = {
            "gl":   "OpenGL",
            "gles": "OpenGLES",
            "wgl":  "WinGL",
            "glx":  "GLX"
        }
        self.humanName = humanNames[self.apiname]
        pass

    def endFile(self):
        sf = SourceFile()
        sf("/// GL bindings for D. Generated automatically by gldgen.py")
        sf("module %s;", self.opts.module)
        sf()
        for stmt in self.opts.stmts:
            sf(stmt)

        self.issueTypes(sf)
        self.issueFuncptrs(sf)
        self.issueConsts(sf)
        self.issueCmdPtrAliases(sf)
        self.issueVersionEnum(sf)
        self.issueSymbolLoader(sf)
        self.issueExtensionsLoader(sf)
        self.issueCoreLoaders(sf)

        with open(self.opts.filename, "w") as outFile:
            sf.writeOut(outFile)


    def beginFeature(self, interface, emit):
        super().beginFeature(interface, emit)

        feature = interface.get("name")
        guard = None
        if feature in self.featureGuards:
            guard = self.featureGuards[feature]

        self.feature = DGenerator.Feature(feature, guard)


    def endFeature(self):
        super().endFeature()
        # adding feature with commands to cores or extensions
        if self.feature.name.startswith(self.versionTag):
            clsName = self.feature.name                \
                    .replace(self.versionTag, self.baseCls)    \
                    .replace("_", "")
            parentClsName = self.lastLoaderClsName
            self.lastLoaderClsName = clsName
            if len(parentClsName) == 0:
                parentClsName = self.baseCls   # first core extends GlCmds, which is the extension loader
            if len(self.feature.cmds):
                self.cores.append(
                    DGenerator.GlCore(self.feature.name, clsName, parentClsName, self.feature.cmds)
                )
        else:
            if len(self.feature.cmds):
                self.extensions.append(
                    DGenerator.Extension(self.feature.name, self.feature.cmds)
                )
        self.features.append(self.feature)
        self.feature = None

    def genType(self, typeinfo, name):
        super().genType(typeinfo, name)

        nameEl = typeinfo.elem.find("name")
        if nameEl == None or len(nameEl.text) == 0:
            # filter preprocessing declarations
            return

        self.parseBaseType(typeinfo, name)


    def parseBaseType(self, typeinfo, name):
        typeElem = typeinfo.elem
        s = noneStr(typeElem.text)

        for elem in typeElem:
            if elem.tag != "name":
                s += noneStr(elem.text)
            elif elem.text.startswith("struct "):
                self.feature.structDecls.append(elem.text[len("struct "):])
                return
            s += noneStr(elem.tail)

        s = s.strip()   .replace(" ( *)", " (*) ")  \
                        .replace(",", " , ")        \
                        .replace(" *", " * ")        \
                        .replace(");", " );")
        if len(s) == 0:
            return

        words = s.split(" ")
        if words[0] == "typedef": words = words[1:]
        if words[0] == "struct":
            self.feature.structDecls.append(words[1])
            words = words[1:]
        if len(words) < 2 or words[1] != "(*)":
            t = "".join(words)
            if t.endswith(";"): t = t[:-1]
            t = t   .replace("unsignedint", "uint")         \
                    .replace("unsignedchar", "ubyte")       \
                    .replace("unsignedshort", "ushort")     \
                    .replace("signedchar", "byte")
            self.feature.baseTypes.append(
                DGenerator.BaseType(name, t)
            )
        else:
            # ex: words == ['void', '(*)', '(GLenum', 'source', ',', 'GLenum',
            #               'type', ',', 'GLuint', 'id', ',', 'GLenum', 'severity',
            #               ',', 'GLsizei', 'length', ',', 'const', 'GLchar', '*',
            #               'message', ',', 'const', 'void', '*', 'userParam', ');']
            returnType = words[0]
            params = []
            w = words[2:]
            while len(w):
                # handle opening parenthesis
                if len(params) == 0 and w[0].startswith("("):
                    w[0] = w[0][1:]
                p = []
                nextParent = False
                while w[0] != "," and w[0] != ");":
                    if nextParent:
                        w[0] = "("+w[0]+")"
                        nextParent = False
                    elif w[0] == "const":
                        nextParent = True
                    p.append(w[0])
                    w = w[1:]
                #eat , or );
                w = w[1:]
                if len(p) < 2:
                    continue
                t = "".join(p[:-1])
                n = p[-1]
                params.append(DGenerator.Param(n, t))
            self.feature.funcptrs.append(
                DGenerator.Command(name, returnType, params, "PFN_"+name)
            )

    def genEnum(self, enuminfo, name):
        super().genEnum(enuminfo, name)
        value = enuminfo.elem.get("value")
        self.feature.consts.append(
                DGenerator.Const(
                    name,
                    value
                        .replace("0ULL", "0")
                        .replace("0L", "0")
                        .replace("0U", "0")
                        .replace("(", "")
                        .replace(")", "")
            )
        )


    def genCmd(self, cmdinfo, name):
        super().genCmd(cmdinfo, name)
        proto = cmdinfo.elem.find("proto")
        if proto == None: return

        returnType = noneStr(proto.text)
        for el in proto:
            if el.tag != "name":
                returnType += noneStr(el.text)
            returnType += noneStr(el.tail)
        returnType = returnType.strip()
        if not len(returnType): return

        params = []
        for pel in cmdinfo.elem.findall(".//param"):
            n = mapDName(pel.find("name").text)
            assert len(n)
            t = noneStr(pel.text)
            for el in pel:
                if el.tag != "name": t += noneStr(el.text)
                t += noneStr(el.tail)
            t = t.replace(" *", "*")
            if t.count("const") > 1: t = t.replace("*const*", "**")
            t = convertDTypeConst(t)
            if t.startswith("struct "): t = t[len("struct "):]
            params.append(DGenerator.Param(n, t.strip()))
        self.feature.cmds.append(DGenerator.Command(name, returnType, params, "PFN_"+name))



    def issueTypes(self, sf):
        feats = [f for f in self.features if len(f.baseTypes)+len(f.structDecls) > 0]
        if not len(feats): return

        sf()
        sf("// Base Types")
        for f in feats:
            sf()
            sf("// Types for %s", f.name)
            f.beginGuard(sf)
            maxLen = 0
            for sd in f.structDecls:
                sf("struct %s;", sd)
            for bt in f.baseTypes:
                maxLen = max(maxLen, len(bt.name))
            for bt in f.baseTypes:
                spacer = " " * (maxLen - len(bt.name))
                sf("alias %s%s = %s;", bt.name, spacer, bt.type)
            f.endGuard(sf)


    def issueFuncptrs(self, sf):
        feats = [f for f in self.features if len(f.funcptrs) > 0]
        if not len(feats): return

        sf()
        sf("// Function pointers")
        sf()
        sf("extern(C) nothrow @nogc {")
        sf()
        with sf.indent_block():
            for i, f in enumerate(feats):
                if i != 0: sf()
                sf("// for %s", f.name)
                f.beginGuard(sf)
                for fp in f.funcptrs:
                    if not len(fp.params):
                        sf("alias %s = %s function();", fp.name, fp.type)
                    else:
                        maxLen = 0
                        for p in fp.params:
                            maxLen = max(maxLen, len(p.type))
                        sf("alias %s = %s function(", fp.name, fp.type)
                        with sf.indent_block():
                            for i, p in enumerate(fp.params):
                                spacer = " " * (maxLen - len(p.type))
                                endLine = "" if i == len(fp.params)-1 else ","
                                sf("%s%s %s%s", p.type, spacer, p.name, endLine)
                        sf(");")
                f.endGuard(sf)
        sf("}")


    def issueConsts(self, sf):
        feats = [f for f in self.features if len(f.consts) > 0]
        if not len(feats): return

        sf()
        for f in feats:
            sf()
            sf("// Constants for %s", f.name)
            f.beginGuard(sf)
            maxLen = 0
            for c in f.consts:
                maxLen = max(maxLen, len(c.name))
            for c in f.consts:
                spacer = " " * (maxLen - len(c.name))
                sf("enum %s%s = %s;", c.name, spacer, c.value)
            f.endGuard(sf)

    def issueCmdPtrAliases(self, sf):
        feats = [f for f in self.features if len(f.cmds) > 0]
        if not len(feats): return

        sf()
        sf("// Command pointer aliases")
        sf()
        sf("extern(C) nothrow @nogc {")
        sf()
        with sf.indent_block():
            for i, f in enumerate(feats):
                if i != 0:
                    sf()
                sf("// Command pointers for %s", f.name)
                f.beginGuard(sf)
                for cmd in f.cmds:
                    maxLen = 0
                    for p in cmd.params:
                        maxLen = max(maxLen, len(p.type))
                    fstLine = "alias {} = {} function (".format(cmd.alias, cmd.type)
                    if len(cmd.params) == 0:
                        sf(fstLine+");")
                        continue

                    sf(fstLine)
                    with sf.indent_block():
                        for p in cmd.params:
                            spacer = " " * (maxLen-len(p.type))
                            sf("%s%s %s,", p.type, spacer, p.name)
                    sf(");")

                f.endGuard(sf)

        sf("}")


    def issueVersionEnum(self, sf):
        if not len(self.cores): return

        sf()
        sf("/// %s describes the version of %s", self.versionEnum, self.humanName)
        sf("enum %s {", self.versionEnum)
        with sf.indent_block():
            for core in self.cores:
                num = core.clsName[-2:]
                sf("%s,", self.base.lower()+num)
        sf("}")


    def issueSymbolLoader(self, sf):
        sf()
        sf("/// Generic Dynamic lib symbol loader.")
        sf("/// Symbols loaded with such loader must be cast to the appropriate function type.")
        sf("alias SymbolLoader = void* delegate (string name);")


    def issueExtensionsLoader(self, sf):
        hasExtensions = len(self.extensions) > 0
        sf()
        sf("/// %s loader base class", self.humanName)
        if hasExtensions:
            sf("/// %s attempts to load all extensions given as parameters", self.baseCls)
            sf("/// Throws an exception if one of the requested extension could not be loaded")
        sf("abstract class %s {", self.baseCls)
        with sf.indent_block():
            sf()
            if hasExtensions:
                sf("/// Build %s instance and attempt to load the extensions passed", self.baseCls)
                sf("/// as arguments.")
                sf("this (SymbolLoader loader, string[] extensions) {")
                with sf.indent_block():
                    sf("import std.algorithm : canFind;")
                    sf("import std.exception : enforce;")
                    for ext in self.extensions:
                        maxLen = 0
                        for cmd in ext.cmds:
                            maxLen = max(maxLen, len(cmd.name))
                        sf()
                        sf("if (extensions.canFind(\"%s\")) {", ext.name)
                        with sf.indent_block():
                            for cmd in ext.cmds:
                                spacer = " " * (maxLen-len(cmd.name))
                                sf("_%s %s= cast(%s)%senforce(loader(\"%s\"), %s\"Could not load %s. Requested by %s\");",
                                        cmd.field, spacer, cmd.alias, spacer, cmd.name, spacer, cmd.name, ext.name)
                            sf("_%s = true;", ext.name)
                        sf("}")
                    sf()
                    sf("_extensions = extensions;")
                sf("}")
                sf()
                sf("public final @property const(string[]) extensions() const {")
                with sf.indent_block():
                    sf("return _extensions;")
                sf("}")
            else:
                sf("this() {")
                sf("}")

            sf()
            sf("public final @property %s %s() const {", self.versionEnum, self.versionField)
            with sf.indent_block():
                sf("return _%s;", self.versionField)
            sf("}")

            for ext in self.extensions:
                sf()
                sf("/// Accessors for %s", ext.name)
                sf("public final @property bool %s() const {", ext.name)
                with sf.indent_block():
                    sf("return _%s;", ext.name)
                sf("}")
                for cmd in ext.cmds:
                    sf("/// ditto")
                    sf("public final @property %s %s() {", cmd.alias, cmd.field)
                    with sf.indent_block():
                        sf("return _%s;", cmd.field)
                    sf("}")

            if hasExtensions:
                sf("private string[] _extensions;")
            sf("private %s _%s;", self.versionEnum, self.versionField)
            for ext in self.extensions:
                sf()
                sf("// Fields for %s", ext.name)
                maxLen = 0
                for cmd in ext.cmds:
                    maxLen = max(maxLen, len(cmd.alias))
                spacer = " " * (maxLen - len("bool"))
                sf("private bool %s_%s;", spacer, ext.name)
                for cmd in ext.cmds:
                    spacer = " " * (maxLen - len(cmd.alias))
                    sf("private %s %s_%s;", cmd.alias, spacer, cmd.field)
        sf("}")

    def issueCoreLoaders(self, sf):
        hasExtensions = len(self.extensions) > 0
        for core in self.cores:
            maxLen = 0
            for cmd in core.cmds:
                maxLen = max(maxLen, len(cmd.name))
            sf()
            sf("/// Loader for %s.", core.name)
            sf("class %s : %s {", core.clsName, core.parentClsName)
            with sf.indent_block():
                extText = ""
                extParam = ""
                superArgs = ""
                if hasExtensions:
                    extText = " and all passed extensions"
                    extParam = ", string[] extensions"
                    superArgs = "loader, extensions"
                elif core.parentClsName != self.baseCls:
                    superArgs = "loader"
                sf()
                sf("/// Build instance by loading all symbols needed by %s%s.", core.name, extText)
                sf("/// throws if a requested symbol could not be loaded")
                sf("public this(SymbolLoader loader%s) {", extParam)
                with sf.indent_block():
                    sf("import std.exception : enforce;")
                    sf()
                    num = core.clsName[-2:]
                    sf("super(%s);", superArgs)
                    sf()
                    for cmd in core.cmds:
                        spacer = " " * (maxLen-len(cmd.name))
                        sf("_%s %s= cast(%s)%senforce(loader(\"%s\"), %s\"Could not load %s. Requested by %s\");",
                                cmd.field, spacer, cmd.alias, spacer, cmd.name, spacer, cmd.name, core.name)
                    sf()
                    sf("_%s = %s.%s;", self.versionField, self.versionEnum, self.base.lower()+num)
                sf("}")

                sf()
                for cmd in core.cmds:
                    spacer = " " * (maxLen - len(cmd.name))
                    sf("public final @property %s %s() {", cmd.alias, cmd.field)
                    with sf.indent_block():
                        sf("return _%s;", cmd.field)
                    sf("}")

                sf()
                for cmd in core.cmds:
                    spacer = " " * (maxLen - len(cmd.name))
                    sf("private %s %s_%s;", cmd.alias, spacer, cmd.field)
            sf("}")





# main driver starts here

if __name__ == "__main__":

    import sys
    import os
    from os import path

    import xml.etree.ElementTree as etree

    from reg import Registry

    # Turn a list of strings into a regexp string matching exactly those strings
    def makeREstring(list):
        return "^(" + "|".join(list) + ")$"

    # Descriptive names for various regexp patterns used to select
    # versions and extensions

    allVersions       = allExtensions = ".*"
    noVersions        = noExtensions = None
    gl12andLaterPat   = "1\.[2-9]|[234]\.[0-9]"
    # Extensions in old glcorearb.h but not yet tagged accordingly in gl.xml
    glCoreARBPat      = None
    glx13andLaterPat  = "1\.[3-9]"

    gldgenDir = path.dirname(path.realpath(__file__))
    bindingsDir = path.dirname(gldgenDir)
    srcDir = path.join(bindingsDir, "source", "gfx", "bindings", "opengl")

    buildList = [
        DGeneratorOptions(
            filename            = path.join(srcDir, "gl.d"),
            apiname             = "gl",
            profile             = "core",
            versions            = allVersions,
            emitversions        = allVersions,
            defaultExtensions   = "glcore",
            addExtensions       = glCoreARBPat,
            removeExtensions    = None,
            module              = "gfx.bindings.opengl.gl",
            stmts               = [
                "alias uint64_t = ulong;",
                "alias int64_t  = long;",
            ]
        ),
        #DGeneratorOptions(      # equivalent of glxext.h
        #    filename            = path.join(srcDir, "glx.d"),
        #    apiname             = "glx",
        #    profile             = None,
        #    versions            = allVersions,
        #    emitversions        = glx13andLaterPat,
        #    defaultExtensions   = "glx",
        #    addExtensions       = None,
        #    removeExtensions    = None,
        #    module              = "gfx.bindings.opengl.glx",
        #    stmts               = [
        #    ]
        #)
    ]

    for opts in buildList:
        gen = DGenerator()
        reg = Registry()
        reg.loadElementTree( etree.parse( path.join(gldgenDir, opts.apiname+".xml") ))
        reg.setGenerator( gen )
        reg.apiGen(opts)

