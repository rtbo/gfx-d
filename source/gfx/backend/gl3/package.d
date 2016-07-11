module gfx.backend.gl3;

import gfx.backend.gl3.buffer : GlBuffer;
import gfx.backend.gl3.texture;
import gfx.backend.gl3.program;

import gfx.core : Device;
import gfx.core.context : Context;
import gfx.core.buffer : BufferRes;
import gfx.core.texture : TextureRes;
import gfx.core.program : ShaderStage, ShaderRes, ProgramRes, ProgramVars;

import derelict.opengl3.gl3;


interface GlContext {
    void makeCurrent();
    void doneCurrent();
    void swapBuffers();
}


Device createGlDevice(GlContext context) {
    return new GlDevice(context);
}


class GlDevice : Device {
    GlContext context_;
    GlDeviceContext deviceContext_;

    this(GlContext context) {
        DerelictGL3.load();
        context_ = context;
        deviceContext_ = new GlDeviceContext();
        context_.makeCurrent();
        DerelictGL3.reload();
    }

    @property Context context() {
        return deviceContext_;
    }
}



class GlDeviceContext : Context {

    TextureRes makeTexture(TextureCreationDesc desc, const(ubyte)[][] data) {
        return makeTextureImpl(desc, false, data);
    }
    BufferRes makeBuffer(BufferCreationDesc desc, const(ubyte)[] data) {
        return new GlBuffer(desc, data);
    }
    ShaderRes makeShader(ShaderStage stage, string code) {
        return new GlShader(stage, code);
    }
    ProgramRes makeProgram(ShaderRes[] shaders, out ProgramVars vars) {
        return new GlProgram(false, shaders, vars);
    }
}