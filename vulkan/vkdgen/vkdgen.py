#! /usr/bin/env python3
"""
    Vulkan D bindings generator.
    Reads Vulkan XML API definition to produce the D bindings code.
    Also depends on the python scripts of Vulkan-Docs.
"""

from reg import Registry
from generator import OutputGenerator, GeneratorOptions, noneStr
import xml.etree.ElementTree as etree
from itertools import islice
import re
from enum import Enum, auto

# General utility

class Sect(Enum):
    INTRO           = auto()
    BASETYPE        = auto()
    HANDLE          = auto()
    CONST           = auto()
    FUNCPTR         = auto()
    ENUM            = auto()
    STRUCT          = auto()
    CMD             = auto()

class SourceFile(object):
    '''
    buffer to append code in various sections of a file
    in any order
    '''

    _one_indent_level = '    '

    class _Section:
        def __init__(self, sect):
            self.sect = sect
            self.lines = []
            self.indent = 0

    def __init__(self, outFile):
        self._sections = {}
        for sect in Sect:
            self._sections[sect] = SourceFile._Section(sect)

        self._sect = Sect.INTRO
        self._section = self._sections[Sect.INTRO]
        self._outFile = outFile

    @property
    def section(self):
        return self._sect

    @section.setter
    def section(self, section):
        '''
        Set the section of the file where to append code.
        Allows to make different sections in the file to append
        to in any order
        '''
        self._sect = section
        self._section = self._sections[section]


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
        self._section.indent += 1

    def unindent(self):
        '''
        removes one level of indentation to the current section
        '''
        assert self._section.indent > 0, "negative indent"
        self._section.indent -= 1

    def __call__(self, fmt="", *args):
        '''
        Append a line to the file at in its current section and
        indentation of the current section
        '''
        indent = SourceFile._one_indent_level * self._section.indent
        self._section.lines.append(indent + (fmt % args))


    def writeOut(self):
        for sect in Sect:
            for line in self._sections[sect].lines:
                print(line.rstrip(), file=self._outFile)


# D specific utilities

re_single_const = re.compile(r"^const\s+(.+)\*\s*$")
re_double_const = re.compile(r"^const\s+(.+)\*\s+const\*\s*$")
re_funcptr = re.compile(r"^typedef (.+) \(VKAPI_PTR \*$")

dkeywords = [ "module" ]

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

def makeDParamType(param):
    def makePart(part):
        return noneStr(part).replace("struct ", "").strip().replace("const", "const ")

    typeStr = makePart(param.text)
    for elem in param:
        if elem.tag != "name":
            typeStr += makePart(elem.text)
        typeStr += makePart(elem.tail)

    return convertDTypeConst(typeStr.replace("const *", "const*"))

def mapDName(name):
    if name in dkeywords:
        return name + "_"
    return name


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

    class BaseType:
        def __init__(self, name, alias):
            self.name = name
            self.alias = alias

    class Const:
        def __init__(self, name, value):
            self.name = name
            self.value = value

    class Enum:
        def __init__(self, name, members, values):
            assert len(members) == len(values)
            self.name = name
            self.members = members
            self.values = values

    # Param is both struct member and command param
    class Param:
        def __init__(self, name, typeStr):
            self.name = name
            self.typeStr = typeStr

    class Struct:
        def __init__(self, name, category, params):
            self.name = name
            self.category = category
            self.params = params

    class Command:
        def __init__(self, name, ret, params):
            self.name = name
            self.returnType = ret
            self.params = params

    class Feature:
        def __init__(self, name, guard):
            self.name = name
            self.guard = guard
            self.baseTypes = []
            self.handles = []
            self.ndHandles = []
            self.consts = []
            self.funcptrs = []
            self.enums = []
            self.structs = []
            self.cmds = []
            self.instanceCmds = []
            self.deviceCmds = []

        def beginGuard(self, sf):
            if self.guard != None:
                self.guard.begin(sf)

        def endGuard(self, sf):
            if self.guard != None:
                self.guard.end(sf)

    def __init__(self, moduleName, outFile):
        super().__init__()
        self.moduleName = moduleName
        self.outFile = outFile
        self.headerVersion = ""
        self.basicTypes = {
            "uint8_t": "ubyte",
            "uint16_t": "ushort",
            "uint32_t": "uint",
            "uint64_t": "ulong",
            "int8_t": "byte",
            "int16_t": "short",
            "int32_t": "int",
            "int64_t": "long",
        }

        self.globalCmdNames = {
            "vkGetInstanceProcAddr",
            "vkEnumerateInstanceExtensionProperties",
            "vkEnumerateInstanceLayerProperties",
            "vkCreateInstance"
        }
        self.globalCmds = []

        self.features = []
        self.feature = None
        self.featureGuards = {
            "VK_KHR_win32_surface": DGenerator.FeatureGuard(
                "Windows",
                [ "import core.sys.windows.windef : HINSTANCE, HWND;" ]
            ),
            "VK_KHR_xcb_surface": DGenerator.FeatureGuard(
                "linux",
                [ "import xcb.xcb : xcb_connection_t, xcb_visualid_t, xcb_window_t;" ]
            ),
            "VK_KHR_wayland_surface": DGenerator.FeatureGuard(
                "linux",
                [
                    "import wayland.native.client : wl_display, wl_proxy;",
                    "alias wl_surface = wl_proxy;"
                ]
            )
        }
        for k in self.featureGuards:
            self.featureGuards[k].name = k

    def logMsg(self, level, *args):
        # shut down logging during dev to see debug output
        # super().logMsg(level, *args)
        pass

    def beginFile(self, opts):
        # generator base class open and close a file
        # don't want that here as we may output to stdout
        # not calling super on purpose

        # Everything is written in endFile
        pass

    def endFile(self):
        # not calling super on purpose (see beginFile comment)
        self.sf = SourceFile(self.outFile)
        self.sf.section = Sect.INTRO
        self.sf("/// Vulkan D bindings generated by vkdgen.py for Gfx-d")
        self.sf("module %s;", self.moduleName)
        self.sf()
        for k in self.featureGuards:
            fg = self.featureGuards[k]
            fg.begin(self.sf)
            for s in fg.stmts:
                self.sf(s)
            fg.end(self.sf)
            self.sf()

        if self.headerVersion != "":
            self.sf("enum VK_HEADER_VERSION = %s;", self.headerVersion)

        self.issueBaseTypes()
        self.issueHandles()
        self.issueConsts()
        self.issueFuncptrs()
        self.issueEnums()
        self.issueStructs()

        self.issueCmdPtrAliases()
        self.issueGlobalCmds()
        self.issueInstanceCmds()
        self.issueDeviceCmds()

        self.sf.writeOut()

    def beginFeature(self, interface, emit):
        super().beginFeature(interface, emit)

        feature = interface.get("name")
        guard = None
        if feature in self.featureGuards:
            guard = self.featureGuards[feature]

        self.feature = DGenerator.Feature(feature, guard)


    def endFeature(self):
        super().endFeature()
        self.features.append(self.feature)
        self.feature = None


    def genType(self, typeinfo, name):
        super().genType(typeinfo, name)
        if "category" not in typeinfo.elem.attrib:
            return
        category = typeinfo.elem.attrib["category"]

        if category == "basetype" or category == "bitmask":
            self.feature.baseTypes.append(
                DGenerator.BaseType(name, typeinfo.elem.find("type").text)
            )

        elif category == "handle":
            handleType = typeinfo.elem.find("type").text
            if handleType == "VK_DEFINE_HANDLE":
                self.feature.handles.append(name)
            else:
                assert handleType == "VK_DEFINE_NON_DISPATCHABLE_HANDLE"
                self.feature.ndHandles.append(name)

        elif category == "struct" or category == "union":
            self.genStruct(typeinfo, name)

        elif category == 'define' and name == 'VK_HEADER_VERSION':
            for headerVersion in islice( typeinfo.elem.itertext(), 2, 3 ):	# get the version string from the one element list
                self.headerVersion = headerVersion
                break

        elif category == "funcpointer":

            returnType = re.match( re_funcptr, typeinfo.elem.text ).group( 1 )

            paramsTxt = "".join( islice( typeinfo.elem.itertext(), 2, None ))[ 2: ]
            params = []

            if paramsTxt != "void);" and paramsTxt != " void );":
                for line in paramsTxt.splitlines():
                    lineSplit = line.split()
                    if len(lineSplit) == 0:
                        continue
                    if len(lineSplit) == 3 and lineSplit[0] == "const":
                        typeStr = "const(" + lineSplit[1] + ")"
                        typeStr = typeStr.replace("*)", ")*")
                        paramName = lineSplit[2]
                    else:
                        assert len(lineSplit) == 2
                        typeStr = lineSplit[0]
                        paramName = lineSplit[1]
                    paramName = paramName.replace(",", "").replace(")", "").replace(";", "")
                    params.append(
                        DGenerator.Param(paramName, typeStr)
                    )

            self.feature.funcptrs.append(
                DGenerator.Command(name, returnType, params)
            )

    def issueBaseTypes(self):
        self.sf.section = Sect.BASETYPE
        self.sf()
        self.sf("// Basic types definition")
        self.sf()
        maxLen = 0
        for bt in self.basicTypes:
            maxLen = max(maxLen, len(bt))
        for bt in self.basicTypes:
            spacer = " " * (maxLen - len(bt))
            self.sf("alias %s%s = %s;", bt, spacer, self.basicTypes[bt])
        for f in [f for f in self.features if len(f.baseTypes) > 0]:
            self.sf()
            self.sf("// %s", f.name)
            f.beginGuard(self.sf)
            maxLen = 0
            for bt in f.baseTypes:
                maxLen = max(maxLen, len(bt.name))
            for bt in f.baseTypes:
                spacer = " " * (maxLen - len(bt.name))
                self.sf("alias %s%s = %s;", bt.name, spacer, bt.alias)
            f.endGuard(self.sf)

    def issueHandles(self):
        self.sf.section = Sect.HANDLE
        self.sf()
        self.sf("// Handles")
        self.sf()
        feats = [f for f in self.features if len(f.handles) > 0]
        for i, f in enumerate(feats):
            if i != 0:
                self.sf()
            self.sf("// %s", f.name)
            f.beginGuard(self.sf)
            maxLen = 0
            for h in f.handles:
                maxLen = max(maxLen, len(h))
            for h in f.handles:
                spacer = " " * (maxLen - len(h))
                self.sf("struct %s_T; %salias %s %s= %s_T*;", h, spacer, h, spacer, h)
            f.endGuard(self.sf)

        self.sf()
        self.sf("// Non-dispatchable handles")
        self.sf()
        feats = [f for f in self.features if len(f.ndHandles) > 0]
        self.sf("version(X86_64) {")
        with self.sf.indent_block():
            for i, f in enumerate(feats):
                if i != 0:
                    self.sf()
                self.sf("// %s", f.name)
                f.beginGuard(self.sf)
                maxLen = 0
                for h in f.ndHandles:
                    maxLen = max(maxLen, len(h))
                for h in f.ndHandles:
                    spacer = " " * (maxLen - len(h))
                    self.sf("struct %s_T; %salias %s %s= %s_T*;", h, spacer, h, spacer, h)
                f.endGuard(self.sf)
        self.sf("}")
        self.sf("else {")
        with self.sf.indent_block():
            for i, f in enumerate(feats):
                if i != 0:
                    self.sf()
                self.sf("// %s", f.name)
                f.beginGuard(self.sf)
                maxLen = 0
                for h in f.ndHandles:
                    maxLen = max(maxLen, len(h))
                for h in f.ndHandles:
                    spacer = " " * (maxLen - len(h))
                    self.sf('alias %s %s= ulong;', h, spacer)
                f.endGuard(self.sf)
        self.sf("}")

    def issueFuncptrs(self):
        self.sf.section = Sect.FUNCPTR
        self.sf()
        self.sf("// Function pointers")
        self.sf()
        self.sf("extern(C) nothrow {")
        with self.sf.indent_block():
            feats = [f for f in self.features if len(f.funcptrs) > 0]
            for i, f in enumerate(feats):
                if i != 0: self.sf()
                self.sf("// %s", f.name)
                f.beginGuard(self.sf)
                for fp in f.funcptrs:
                    if not len(fp.params):
                        self.sf("alias %s = %s function();", fp.name, fp.returnType)
                    else:
                        maxLen = 0
                        for p in fp.params:
                            maxLen = max(maxLen, len(p.typeStr))
                        self.sf("alias %s = %s function(", fp.name, fp.returnType)
                        with self.sf.indent_block():
                            for i, p in enumerate(fp.params):
                                spacer = " " * (maxLen - len(p.typeStr))
                                endLine = "" if i == len(fp.params)-1 else ","
                                self.sf("%s%s %s%s", p.typeStr, spacer, p.name, endLine)
                        self.sf(");")
                f.endGuard(self.sf)
        self.sf("}")

    # an enum is a single constant
    def genEnum(self, enuminfo, name):
        super().genEnum(enuminfo, name)
        (_, strVal) = self.enumToValue(enuminfo.elem, False)
        self.feature.consts.append(
                DGenerator.Const(
                    name,
                    strVal
                        .replace("0ULL", "0")
                        .replace("0L", "0")
                        .replace("0U", "0")
                        .replace("(", "")
                        .replace(")", "")
            )
        )

    def issueConsts(self):
        self.sf.section = Sect.CONST
        self.sf()
        self.sf("// Constants")
        for f in [f for f in self.features if len(f.consts) > 0]:
            self.sf()
            self.sf("// %s", f.name)
            f.beginGuard(self.sf)
            maxLen = 0
            for c in f.consts:
                maxLen = max(maxLen, len(c.name))
            for c in f.consts:
                spacer = " " * (maxLen - len(c.name))
                self.sf("enum %s%s = %s;", c.name, spacer, c.value)
            f.endGuard(self.sf)


    # a group is an enumeration of several related constants
    def genGroup(self, groupinfo, name):
        super().genGroup(groupinfo, name)

        members = []
        values = []
        for elem in groupinfo.elem.findall("enum"):
            (numVal, strVal) = self.enumToValue(elem, True)
            members.append(elem.get("name"))
            values.append(strVal)

        self.feature.enums.append(
            DGenerator.Enum(name, members, values)
        )

    def issueEnums(self):
        self.sf.section = Sect.ENUM
        self.sf()
        self.sf("// Enumerations")
        for f in [f for f in self.features if len(f.enums) > 0]:
            self.sf()
            self.sf("// %s", f.name)
            f.beginGuard(self.sf)
            for e in f.enums:
                repStr = ""
                if e.name.endswith("FlagBits"):
                    repStr = " : VkFlags"

                maxLen = 0
                for m in e.members:
                    maxLen = max(maxLen, len(m))

                self.sf("enum %s%s {", e.name, repStr)
                with self.sf.indent_block():
                    for i in range(len(e.members)):
                        spacer = " " * (maxLen - len(e.members[i]))
                        self.sf("%s%s = %s,", e.members[i], spacer, e.values[i])
                self.sf("}")
                for m in e.members:
                    spacer = " " * (maxLen - len(m))
                    self.sf("enum %s%s = %s.%s;", m, spacer, e.name, m)
                self.sf()
            f.endGuard(self.sf)


    def genStruct(self, typeinfo, name):
        super().genStruct(typeinfo, name)
        category = typeinfo.elem.attrib["category"]
        params = []
        for member in typeinfo.elem.findall(".//member"):
            typeStr = makeDParamType(member)
            memName = member.find("name").text
            if memName in dkeywords:
                memName += "_"
            params.append(
                DGenerator.Param(memName, typeStr)
            )

        self.feature.structs.append(
            DGenerator.Struct(name, category, params)
        )

    def issueStructs(self):
        self.sf()
        self.sf.section = Sect.STRUCT
        self.sf("// Structures")
        for f in [f for f in self.features if len(f.structs) > 0]:
            self.sf()
            self.sf("// %s", f.name)
            f.beginGuard(self.sf)
            for s in f.structs:
                maxLen = 0
                for p in s.params:
                    maxLen = max(maxLen, len(p.typeStr))
                self.sf.section = Sect.STRUCT
                self.sf("%s %s {", s.category, s.name)
                with self.sf.indent_block():
                    for p in s.params:
                        spacer = " " * (maxLen - len(p.typeStr))
                        self.sf("%s%s %s;", p.typeStr, spacer, p.name)
                self.sf("}")

            f.endGuard(self.sf)


    def genCmd(self, cmdinfo, name):
        super().genCmd(cmdinfo, name)
        typeStr = cmdinfo.elem.findall("./proto/type")[0].text
        params=[]
        for pElem in cmdinfo.elem.findall("./param"):
            p = DGenerator.Param(pElem.find("name").text, makeDParamType(pElem))
            params.append(p)

        cmd = DGenerator.Command(name, typeStr, params)

        self.feature.cmds.append(cmd)

        if name in self.globalCmdNames:
            self.globalCmds.append(cmd)
        elif name != "vkGetDeviceProcAddr" and len(params) and params[0].typeStr in { "VkDevice", "VkQueue", "VkCommandBuffer" }:
            self.feature.deviceCmds.append(cmd)
        else:
            self.feature.instanceCmds.append(cmd)

    def issueCmdPtrAliases(self):
        self.sf.section = Sect.CMD
        self.sf()
        self.sf("// Command pointer aliases")
        self.sf()
        self.sf("extern(C) nothrow @nogc {")
        with self.sf.indent_block():
            feats = [f for f in self.features if len(f.cmds) > 0]
            for i, f in enumerate(feats):
                if i != 0:
                    self.sf()
                self.sf("// %s", f.name)
                f.beginGuard(self.sf)
                for cmd in f.cmds:
                    maxLen = 0
                    for p in cmd.params:
                        maxLen = max(maxLen, len(p.typeStr))
                    fstLine = "alias PFN_{} = {} function (".format(cmd.name, cmd.returnType)
                    if len(cmd.params) == 0:
                        self.sf(fstLine+");")
                        continue

                    self.sf(fstLine)
                    with self.sf.indent_block():
                        for p in cmd.params:
                            spacer = " " * (maxLen-len(p.typeStr))
                            self.sf("%s%s %s,", p.typeStr, spacer, p.name)
                    self.sf(");")

                f.endGuard(self.sf)

        self.sf("}")
        self.sf()

    def issueGlobalCmds(self):
        maxLen = 0
        for cmd in self.globalCmds:
            maxLen = max(maxLen, len(cmd.name))

        self.sf.section = Sect.CMD
        self.sf()
        self.sf("// Global commands")
        self.sf()
        self.sf("final class VkGlobalCmds {")
        with self.sf.indent_block():
            self.sf()
            self.sf("this (PFN_vkGetInstanceProcAddr loader) {")
            with self.sf.indent_block():
                self.sf("_GetInstanceProcAddr = loader;")
                for cmd in [cmd for cmd in self.globalCmds if cmd.name != "vkGetInstanceProcAddr"]:
                    spacer = " " * (maxLen - len(cmd.name))
                    membName = cmd.name[2:]
                    self.sf(
                        "_%s%s = cast(PFN_%s)%sloader(null, \"%s\");",
                        membName, spacer, cmd.name, spacer, cmd.name
                    )
            self.sf("}")
            for cmd in self.globalCmds:
                spacer = " " * (maxLen - len(cmd.name))
                # vkCmdName => CmdName
                membName = cmd.name[2:]
                paramStr = ", ".join(map((lambda p: "{} {}".format(p.typeStr, p.name)), cmd.params))
                argStr = ", ".join(map((lambda p: p.name), cmd.params))
                self.sf()
                self.sf("%s %s (%s) {", cmd.returnType, membName, paramStr)
                with self.sf.indent_block():
                    self.sf("assert(_%s !is null, \"%s was not loaded.\");", membName, cmd.name)
                    self.sf("return _%s(%s);", membName, argStr)
                self.sf("}")

            self.sf()
            for cmd in self.globalCmds:
                spacer = " " * (maxLen - len(cmd.name))
                # vkCmdName => CmdName
                membName = cmd.name[2:]
                self.sf("private PFN_%s%s _%s;", cmd.name, spacer, membName)
        self.sf("}")


    def issueInstanceCmds(self):
        maxLen = 0
        for f in self.features:
            for cmd in f.instanceCmds:
                maxLen = max(maxLen, len(cmd.name))

        self.sf.section = Sect.CMD
        self.sf()
        self.sf("// Instance commands")
        self.sf()
        self.sf("final class VkInstanceCmds {")
        with self.sf.indent_block():
            feats = [f for f in self.features if len(f.instanceCmds) > 0]
            self.sf()
            self.sf("this (VkInstance instance, VkGlobalCmds globalCmds) {")
            with self.sf.indent_block():
                self.sf("auto loader = globalCmds._GetInstanceProcAddr;")
                for i, f in enumerate(feats):
                    if i != 0:
                        self.sf()
                    self.sf("// %s", f.name)
                    f.beginGuard(self.sf)
                    for cmd in f.instanceCmds:
                        spacer = " " * (maxLen - len(cmd.name))
                        membName = cmd.name[2:]
                        self.sf(
                            "_%s%s = cast(PFN_%s)%sloader(instance, \"%s\");",
                            membName, spacer, cmd.name, spacer, cmd.name
                        )
                    f.endGuard(self.sf)
            self.sf("}")

            for f in feats:
                self.sf()
                f.beginGuard(self.sf)
                for i, cmd in enumerate(f.instanceCmds):
                    spacer = " " * (maxLen - len(cmd.name))
                    membName = cmd.name[2:]     # vkCmdName => CmdName
                    paramStr = ", ".join(map((lambda p: "{} {}".format(p.typeStr, p.name)), cmd.params))
                    argStr = ", ".join(map((lambda p: p.name), cmd.params))
                    if i == 0:  self.sf("/// Commands for %s", f.name)
                    else:       self.sf("/// ditto")
                    self.sf("%s %s (%s) {", cmd.returnType, membName, paramStr)
                    with self.sf.indent_block():
                        self.sf("assert(_%s !is null, \"%s was not loaded. Requested by %s\");", membName, cmd.name, f.name)
                        self.sf("return _%s(%s);", membName, argStr)
                    self.sf("}")
                f.endGuard(self.sf)

            for f in feats:
                self.sf()
                self.sf("// fields for %s", f.name)
                f.beginGuard(self.sf)
                for cmd in f.instanceCmds:
                    spacer = " " * (maxLen - len(cmd.name))
                    # vkCmdName => CmdName
                    membName = cmd.name[2:]
                    self.sf("private PFN_%s%s _%s;", cmd.name, spacer, membName)
                f.endGuard(self.sf)
        self.sf("}")


    def issueDeviceCmds(self):
        maxLen = 0
        for f in self.features:
            for cmd in f.deviceCmds:
                maxLen = max(maxLen, len(cmd.name))

        self.sf.section = Sect.CMD
        self.sf()
        self.sf("// Device commands")
        self.sf()
        self.sf("final class VkDeviceCmds {")
        with self.sf.indent_block():
            feats = [f for f in self.features if len(f.deviceCmds) > 0]
            self.sf()
            self.sf("this (VkDevice device, VkInstanceCmds instanceCmds) {")
            with self.sf.indent_block():
                self.sf("auto loader = instanceCmds._GetDeviceProcAddr;")
                for i, f in enumerate(feats):
                    if i != 0:
                        self.sf()
                    self.sf("// %s", f.name)
                    f.beginGuard(self.sf)
                    for cmd in f.deviceCmds:
                        spacer = " " * (maxLen - len(cmd.name))
                        membName = cmd.name[2:]
                        self.sf(
                            "_%s%s = cast(PFN_%s)%sloader(device, \"%s\");",
                            membName, spacer, cmd.name, spacer, cmd.name
                        )
                    f.endGuard(self.sf)
            self.sf("}")

            for f in feats:
                self.sf()
                f.beginGuard(self.sf)
                for i, cmd in enumerate(f.deviceCmds):
                    spacer = " " * (maxLen - len(cmd.name))
                    membName = cmd.name[2:]     # vkCmdName => CmdName
                    paramStr = ", ".join(map((lambda p: "{} {}".format(p.typeStr, p.name)), cmd.params))
                    argStr = ", ".join(map((lambda p: p.name), cmd.params))
                    if i == 0:  self.sf("/// Commands for %s", f.name)
                    else:       self.sf("/// ditto")
                    self.sf("%s %s (%s) {", cmd.returnType, membName, paramStr)
                    with self.sf.indent_block():
                        self.sf("assert(_%s !is null, \"%s was not loaded. Requested by %s\");", membName, cmd.name, f.name)
                        self.sf("return _%s(%s);", membName, argStr)
                    self.sf("}")
                f.endGuard(self.sf)

            for f in feats:
                self.sf()
                self.sf("// fields for %s", f.name)
                f.beginGuard(self.sf)
                for cmd in f.deviceCmds:
                    spacer = " " * (maxLen - len(cmd.name))
                    # vkCmdName => CmdName
                    membName = cmd.name[2:]
                    self.sf("private PFN_%s%s _%s;", cmd.name, spacer, membName)
                f.endGuard(self.sf)
        self.sf("}")



# main driver starts here

if __name__ == "__main__":

    import sys
    import os
    from os import path
    import argparse

    vkdgenDir = os.path.dirname(os.path.realpath(__file__))
    vkXml = path.join(vkdgenDir, "vk.xml")

    parser = argparse.ArgumentParser(description="Generate Vulkan D bindings")

    parser.add_argument("-m, --module", dest="module", metavar="MODULE",
                help="D module name")
    parser.add_argument("-r, --registry", dest="registry", metavar="REGISTRY",
                help="Path to the XML registry [{}]".format(vkXml), default=vkXml)
    parser.add_argument("-o, --output", dest="output", metavar="OUTPUT",
                help="D output file to generate [stdout].", default="[stdout]")

    args = parser.parse_args(sys.argv[1:])

    def makeREstring(list):
        return '^(' + '|'.join(list) + ')$'

    outFile = sys.stdout if args.output == "[stdout]" else open(args.output, "w")

    gen = DGenerator(args.module, outFile)
    reg = Registry()
    reg.loadElementTree( etree.parse( args.registry ))
    reg.setGenerator( gen )
    reg.apiGen( GeneratorOptions(
        apiname = "vulkan",
        addExtensions = makeREstring([
            "VK_KHR_display",
            "VK_KHR_swapchain",
            "VK_KHR_win32_surface",
            "VK_KHR_xcb_surface",
            "VK_KHR_wayland_surface",
            "VK_KHR_surface",
            "VK_EXT_debug_report",
        ]),
    ))

    if args.output != "[stdout]":
        outFile.close()
