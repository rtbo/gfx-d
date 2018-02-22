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

reSingleConst = re.compile(
    r"^const\s+(.+)\*\s*$"
)
reDoubleConst = re.compile(
    r"^const\s+(.+)\*\s+const\*\s*$"
)
reTypeAlias = re.compile(   # reStructAlias must be tested before reTypeAlias
    r"^typedef\s+(.*[\s\*])(\w+)\s*;\s*$"
)
reStructAlias = re.compile(
    r"^typedef\s+struct\s+([^{]+)\s*\*\s*(\w+);\s*$"
)
reFuncPtrAlias = re.compile(
    r"^typedef\s+(.*)\s+\(\s*\*\s*(\w+)\)\s*\((.*)\)\s*;\s*$",
    re.MULTILINE | re.DOTALL
)
reFuncParam = re.compile(
    r"^(.*[\s\*])(\w+)$"
)
reStructDecl = re.compile(
    r"^struct\s+(\w+);$"
)
# struct definition regex
# match all fields in a single blob that can be passed to reStructFields
# form:
# typedef struct { fields } name;
reStructTypedefDef  = re.compile(
    r"^typedef\s+struct\s+\{(.*)\}\s*(\w+)\s*;\s*$",
    re.MULTILINE | re.DOTALL
)
# form:
# struct name { fields }
reStructDef = re.compile(
    r"^struct\s+(\w+)\s+\{(.*)\}\s*;\s*$",
    re.MULTILINE | re.DOTALL
)
# match examples for struct fields:
#   int type;
#   unsigned long serial;
#   char pipeName[80]; /* Should be [GLX_HYPERPIPE_PIPE_NAME_LENGTH_SGIX] */
#   int XOrigin, YOrigin, maxHeight, maxWidth;
reStructFields = re.compile(
    r"(^\s*(.*?[\s\*])(((\w+),\s)*(\w+))(\[.+\])?;.*$)+",
    re.MULTILINE
)

def convertDTypeConst( typ ):
    """
    Converts C const syntax to D const syntax
    """
    match = re.match( reDoubleConst, typ )
    if match:
        return "const({}*)*".format(match.group(1).strip())
    else:
        match = re.match( reSingleConst, typ )
        if match:
            return "const({})*".format(match.group(1).strip())
    return typ

def mapDType(t):
    return convertDTypeConst(
        t   .replace("unsigned char", "ubyte")
            .replace("unsigned short", "ushort")
            .replace("unsigned int", "uint")
            .replace("unsigned long", "c_ulong")
            .replace("signed char", "byte")
            .strip()
    )

def mapDName(name):
    if name in [ "ref" ]:
        return name + "_"
    else:
        return name

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
            self.aliases = []
            self.structs = []
            self.funcptrs = []
            self.consts = []
            self.cmds = []

        def beginGuard(self, sf):
            if self.guard != None:
                self.guard.begin(sf)

        def endGuard(self, sf):
            if self.guard != None:
                self.guard.end(sf)

    class Alias:
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

    class Struct:
        def __init__(self, name, params):
            self.name = name
            self.params = params

    class FuncPtr:
        def __init__(self, name, type, params):
            self.name = name
            self.type = type
            self.params = params

    class Command:
        def __init__(self, name, type, params, alias, field):
            self.name = name
            self.type = type
            self.params = params
            self.alias = alias
            self.field = field

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
        self.structDecls = []
        self.extensions = []
        self.cores = []
        self.lastLoaderClsName = ""

    def addStructDecl(self, decl):
        if self.opts and decl in self.opts.importedStructDecls: return
        if decl in self.structDecls: return
        self.structDecls.append(decl)

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
        pass

    def endFile(self):
        sf = SourceFile()
        sf("/// %s bindings for D. Generated automatically by gldgen.py", self.opts.humanName)
        sf("module %s;", self.opts.module)
        sf()
        for stmt in self.opts.stmts:
            sf(stmt)

        self.issueTypes(sf)
        self.issueStructDecls(sf)
        self.issueStructDefs(sf)
        self.issueFuncptrs(sf)
        self.issueConsts(sf)
        self.issueCmdPtrAliases(sf)
        self.issueVersionEnum(sf)
        self.issueExtensionsLoader(sf)
        self.issueCoreLoaders(sf)
        self.issueLoaderFunc(sf)

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

        if len(self.feature.cmds):
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

        self.parseType(typeinfo, name)


    def parseType(self, typeinfo, name):
        typeElem = typeinfo.elem
        s = noneStr(typeElem.text)
        for elem in typeElem:
            s += noneStr(elem.text)
            s += noneStr(elem.tail)

        match = re.match(reStructDecl, s)
        if match:
            struct = match.group(1).strip()
            self.addStructDecl(struct)
            return

        match = re.match(reStructAlias, s)
        if match:
            assert name == match.group(2)
            struct = match.group(1).strip()
            self.addStructDecl(struct)
            self.feature.aliases.append(
                DGenerator.Alias(name, struct+"*")
            )
            return

        match = re.match(reTypeAlias, s)
        if match:
            assert name == match.group(2)
            type = mapDType(match.group(1).strip())

            self.feature.aliases.append(
                DGenerator.Alias(name, type)
            )
            return

        match = re.match(reFuncPtrAlias, s)
        if match:
            assert name == match.group(2)
            t = mapDType(match.group(1))
            p = match.group(3).strip()
            if p == "void": p = ""
            params = []
            for pstr in p.split(","):
                if not len(pstr.strip()): continue
                match = re.match(reFuncParam, pstr)
                params.append(
                    DGenerator.Param(match.group(2), mapDType(match.group(1).strip()))
                )
            self.feature.funcptrs.append(
                DGenerator.FuncPtr(name, t, params)
            )
            return

        match1 = re.match(reStructDef, s)
        match2 = re.match(reStructTypedefDef, s)
        if match1 or match2:
            match = match1 if match1 else match2
            nameGr = 1 if match1 else 2
            fieldsGr = 2 if match1 else 1
            assert name == match.group(nameGr)
            fields = match.group(fieldsGr)
            fieldsMatches = re.findall(reStructFields, fields)
            params = []
            for m in fieldsMatches:
                typ = m[1].strip()
                index = m[6]
                names = m[2]
                for n in names.split(","):
                    params.append(
                        DGenerator.Param(n.strip(), mapDType(typ+index))
                    )
            self.feature.structs.append(
                DGenerator.Struct(name, params)
            )
            return

        print("no match for", s)


    def genEnum(self, enuminfo, name):
        super().genEnum(enuminfo, name)
        value = enuminfo.elem.get("value")
        if "EGL_CAST" in value:
            value = value                               \
                    .replace("EGL_CAST", "EGL_CAST!")   \
                    .replace(",", ")(")
        else:
            value = value                               \
                    .replace("0ULL", "0")               \
                    .replace("0L", "0")                 \
                    .replace("0U", "0")                 \
                    .replace("(", "")                   \
                    .replace(")", "")

        self.feature.consts.append(
                DGenerator.Const(
                    name,
                    value
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
        returnType = mapDType(returnType.strip())
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
            if t.startswith("struct "): t = t[len("struct "):]
            t = t.replace(" struct ", " ")
            t = mapDType(t)
            params.append(DGenerator.Param(n, t.strip()))
        cpl = len(self.opts.cmdPrefix)
        field = name[cpl].lower() + name[cpl+1:]
        self.feature.cmds.append(DGenerator.Command(name, returnType, params, "PFN_"+name, field))



    def issueStructDecls(self, sf):
        if not len(self.structDecls): return
        sf()
        sf("// Struct declarations")
        for sd in self.structDecls:
            sf("struct %s;", sd)

    def issueStructDefs(self, sf):
        feats = [f for f in self.features if len(f.structs) > 0]
        if not len(feats): return

        sf()
        sf("// struct definitions")
        for f in feats:
            sf("// Structs for %s", f.name)
            f.beginGuard(sf)
            for s in f.structs:
                maxLen = 0
                for p in s.params:
                    maxLen = max(maxLen, len(p.type))
                sf("struct %s {", s.name)
                with sf.indent_block():
                    for p in s.params:
                        spacer = " " * (maxLen - len(p.type))
                        sf("%s %s;", p.type, p.name)
                sf("}")
            f.endGuard(sf)

    def issueTypes(self, sf):
        feats = [f for f in self.features if len(f.aliases) > 0]
        if not len(feats): return

        sf()
        sf("// Base Types")
        for f in feats:
            sf()
            sf("// Types for %s", f.name)
            f.beginGuard(sf)
            maxLen = 0
            for a in f.aliases:
                maxLen = max(maxLen, len(a.name))
            for a in f.aliases:
                spacer = " " * (maxLen - len(a.name))
                sf("alias %s%s = %s;", a.name, spacer, a.type)
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
        sf("/// %s describes the version of %s", self.versionEnum, self.opts.humanName)
        sf("enum %s {", self.versionEnum)
        with sf.indent_block():
            for core in self.cores:
                num = core.clsName[-2:]
                sf("%s,", self.base.lower()+num)
        sf("}")


    def issueExtensionsLoader(self, sf):
        hasExtensions = len(self.extensions) > 0
        sf()
        sf("/// %s loader base class", self.opts.humanName)
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

    def issueLoaderFunc(self, sf):
        sf()
        sf("/// Load %s symbols of the given version and with the given extensions", self.opts.humanName)
        sf("%s load%s(SymbolLoader loader, %s ver, string[] extensions) {",
                self.baseCls, self.opts.humanName, self.versionEnum)
        with sf.indent_block():
            sf("final switch(ver) {")
            clsName = ""
            for core in self.cores:
                num = core.clsName[-2:]
                sf("case %s.%s:", self.versionEnum, self.base.lower()+num)
                if len(core.cmds):
                    clsName = core.clsName
                assert clsName != ""
                with sf.indent_block():
                    sf("return new %s(loader, extensions);", clsName)
            sf("}")
        sf("}")


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
                 regFile = "",
                 module = "",
                 humanName = "",
                 cmdPrefix = "",
                 importedStructDecls = [],
                 stmts = []):
        GeneratorOptions.__init__(self, filename, apiname, profile,
                                  versions, emitversions, defaultExtensions,
                                  addExtensions, removeExtensions, sortProcedure)
        self.regFile = regFile
        self.module = module
        self.humanName = humanName
        self.cmdPrefix = cmdPrefix
        self.importedStructDecls = importedStructDecls
        self.stmts = stmts



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
        DGeneratorOptions(      # equivalent of glcorearb.h
            filename            = path.join(srcDir, "gl.d"),
            apiname             = "gl",
            profile             = "core",
            versions            = allVersions,
            emitversions        = allVersions,
            defaultExtensions   = "glcore",
            addExtensions       = glCoreARBPat,
            removeExtensions    = None,
            regFile             = path.join(gldgenDir, "gl.xml"),
            module              = "gfx.bindings.opengl.gl",
            humanName           = "OpenGL",
            cmdPrefix           = "gl",
            importedStructDecls = [],
            stmts               = [
                "import core.stdc.stdint;",
                "import gfx.bindings.core;"
            ]
        ),
        DGeneratorOptions(
            filename            = path.join(srcDir, "glx.d"),
            apiname             = "glx",
            profile             = None,
            versions            = allVersions,
            emitversions        = allVersions,
            defaultExtensions   = "glx",
            addExtensions       = None,
            removeExtensions    = makeREstring([
                "GLX_SGIX_dmbuffer", "GLX_SGIX_video_source"
            ]),
            regFile             = path.join(gldgenDir, "glx.xml"),
            humanName           = "GLX",
            cmdPrefix           = "glX",
            module              = "gfx.bindings.opengl.glx",
            importedStructDecls = [],
            stmts               = [
                "version(linux):",
                "",
                "import core.stdc.config;",
                "import core.stdc.stdint;",
                "import gfx.bindings.core;",
                "import gfx.bindings.opengl.gl;",
                "import X11.Xlib;",
            ]
        ),
        DGeneratorOptions(      # equivalent of wglext.h
            filename            = path.join(srcDir, "wgl.d"),
            apiname             = "wgl",
            profile             = None,
            versions            = allVersions,
            emitversions        = None,
            defaultExtensions   = "wgl",
            addExtensions       = None,
            removeExtensions    = None,
            regFile             = path.join(gldgenDir, "wgl.xml"),
            humanName           = "WinGL",
            cmdPrefix           = "wgl",
            module              = "gfx.bindings.opengl.wgl",
            importedStructDecls = [],
            stmts               = [
                "version(Windows):",
                "import gfx.bindings.core;"
            ]
        ),
        DGeneratorOptions(
            filename            = path.join(srcDir, "egl.d"),
            apiname             = "egl",
            profile             = None,
            versions            = allVersions,
            emitversions        = allVersions,
            defaultExtensions   = "egl",
            addExtensions       = None,
            removeExtensions    = None,
            regFile             = path.join(gldgenDir, "egl.xml"),
            humanName           = "EGL",
            cmdPrefix           = "egl",
            module              = "gfx.bindings.opengl.egl",
            importedStructDecls = [],
            stmts               = [
                "import core.stdc.stdint;",
                "import gfx.bindings.core;",
                "import gfx.bindings.opengl.eglplatform;",
                "import gfx.bindings.opengl.khrplatform;",
            ]
        ),
    ]

    for opts in buildList:
        if opts.apiname == "wgl": continue
        gen = DGenerator()
        reg = Registry()
        reg.loadElementTree( etree.parse( opts.regFile ))
        reg.setGenerator( gen )
        reg.apiGen(opts)

