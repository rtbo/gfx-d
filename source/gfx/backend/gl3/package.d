module gfx.backend.gl3;

import gfx.backend.gl3.info : ContextInfo;
import gfx.backend.gl3.buffer : GlBuffer;
import gfx.backend.gl3.texture;
import gfx.backend.gl3.program;

import gfx.core : Device;
import gfx.core.context : Context;
import gfx.core.buffer : BufferRes;
import gfx.core.texture : TextureRes;
import gfx.core.program : ShaderStage, ShaderRes, ProgramRes, ProgramVars;

import derelict.opengl3.gl3;

import std.experimental.logger;


interface GlContext {
    void makeCurrent();
    void doneCurrent();
    void swapBuffers();
}


Device createGlDevice(GlContext context) {
    return new GlDevice(context);
}


class GlDevice : Device {
    GlContext _context;
    GlDeviceContext _deviceContext;
    ContextInfo _info;

    this(GlContext context) {
        DerelictGL3.load();
        _context = context;
        _context.makeCurrent();
        DerelictGL3.reload();
        _info = ContextInfo.fetch();
        _deviceContext = new GlDeviceContext(_info.caps);

        log(_info.infoString);
    }

    @property Context context() {
        return _deviceContext;
    }
}

struct GlCaps {
    import std.bitmanip : bitfields;

    mixin(bitfields!(
        bool, "interfaceQuery", 1,
        bool, "samplerObject", 1,
        bool, "textureStorage", 1,
        bool, "attribBinding", 1,
        bool, "ubo", 1,
        byte, "", 3,
    ));
}


class GlDeviceContext : Context {

    GlCaps _caps;

    this(GlCaps caps) {
        _caps = caps;
    }

    TextureRes makeTexture(TextureCreationDesc desc, const(ubyte)[][] data) {
        return makeTextureImpl(_caps.textureStorage, desc, data);
    }
    BufferRes makeBuffer(BufferCreationDesc desc, const(ubyte)[] data) {
        return new GlBuffer(desc, data);
    }
    ShaderRes makeShader(ShaderStage stage, string code) {
        return new GlShader(stage, code);
    }
    ProgramRes makeProgram(ShaderRes[] shaders, out ProgramVars vars) {
        return new GlProgram(_caps.ubo, shaders, vars);
    }
}