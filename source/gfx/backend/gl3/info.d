module gfx.backend.gl3.info;

import gfx.backend.gl3 : GlCaps;

import derelict.opengl3.gl3;

import std.typecons : Nullable;
import std.string : empty, fromStringz;



struct Version {
    int major;
    int minor;
    Nullable!int revision;
    string vendorInfo;

    static Version parse(string glVersion) {
        import std.algorithm : findSplit;
        import std.conv : to;

        scope(failure) {
            throw new Exception("could not parse GL version string: " ~ glVersion);
        }

        auto glv = glVersion.findSplit(" ");
        string v = glv[0];
        auto v1 = v.findSplit(".");
        auto v2 = v1[2].findSplit(".");

        int major = v1[0].to!int;
        int minor = v2[0].to!int;
        Nullable!int rev;
        if (!v2[2].empty) {
            rev = v2[2].to!int;
        }
        string vendorInfo = glv[2];

        return Version(major, minor, rev, vendorInfo);
    }

    @property int decimal() const {
        return 100*major + minor;
    }
}

struct PlatformName {
    string vendor;
    string renderer;

    static PlatformName fetch() {
        return PlatformName(
            fromStringz(glGetString(GL_VENDOR)).idup,
            fromStringz(glGetString(GL_RENDERER)).idup
        );
    }
}



size_t getGlNum(GLenum name) {
    GLint val;
    glGetIntegerv(name, &val);
    return cast(size_t)val;
}


struct ContextInfo {
    PlatformName platformName;
    Version glVersion;
    Version glslVersion;
    Ext[string] extensions;

    GlCaps caps;

    public bool versionSupported(in int maj, in int min) const {
        return glVersion.major > maj ||
                (glVersion.major == maj && glVersion.minor >= min);
    }

    public bool extensionSupported(string ext) const {
        return (ext in extensions) !is null;
    }

    public bool versionOrExtensionSupported(in int maj, in int min, string ext) const {
        return versionSupported(maj, min) || extensionSupported(ext);
    }

    static ContextInfo fetch() {
        import std.algorithm : splitter, each;

        ContextInfo res;

        res.platformName = PlatformName.fetch();
        res.glVersion = Version.parse(fromStringz(glGetString(GL_VERSION)).idup);
        res.glslVersion = Version.parse(fromStringz(
                glGetString(GL_SHADING_LANGUAGE_VERSION)).idup);

        GLint numExts;
        glGetIntegerv(GL_NUM_EXTENSIONS, &numExts);
        foreach(i; 0..numExts) {
            string ext = fromStringz(glGetStringi(GL_EXTENSIONS, i)).idup;
            res.extensions[ext] = Ext();
        }

        res.caps.interfaceQuery = res.versionOrExtensionSupported(4, 3, "GL_ARB_program_interface_query");
        res.caps.samplerObject = res.versionOrExtensionSupported(3, 3, "GL_ARB_sampler_objects");
        res.caps.textureStorage = res.versionOrExtensionSupported(4, 2, "GL_ARB_texture_storage") &&
                    res.versionOrExtensionSupported(4, 3, "GL_ARB_texture_storage_multisample");
        res.caps.attribBinding = res.versionOrExtensionSupported(4, 3, "GL_ARB_vertex_attrib_binding");
        res.caps.ubo = res.versionOrExtensionSupported(3, 1, "GL_ARB_uniform_buffer_object");
        res.caps.instanceRate = res.versionOrExtensionSupported(3, 3, "GL_ARB_instanced_arrays");

        return res;
    }

    string infoString() const {
        import std.algorithm : filter;
        import std.format : format;
        import std.conv : to;

        string res = "ContextInfo {\n";
        res ~= "    platform: {\n",
        res ~= format("        vendor: \"%s\"\n", platformName.vendor);
        res ~= format("        renderer: \"%s\"\n", platformName.renderer);
        res ~= "    },\n";
        res ~= format("    version: %s.%s%s%s\n",
            glVersion.major, glVersion.minor,
                glVersion.revision.isNull()?"":"."~glVersion.revision.to!string,
                glVersion.vendorInfo.empty?"":" "~ glVersion.vendorInfo);
        res ~= format("    glslVersion: %s.%s\n", glslVersion.major, glslVersion.minor);
        res ~= "    Caps: {\n";
        res ~= format("        interfaceQuery: %s\n", caps.interfaceQuery);
        res ~= format("        samplerObject: %s\n", caps.samplerObject);
        res ~= format("        textureStorage: %s\n", caps.textureStorage);
        res ~= format("        attribBinding: %s\n", caps.attribBinding);
        res ~= "    }\n";
        res ~= "    extensions: [\n";
        foreach(ext; extensions.keys) {
            res ~= format("        %s\n", ext);
        }
        res ~= "    ]\n";
        res ~= "}\n";
        return res;
    }



    private struct Ext {} // empty type to emulate a hashset


}