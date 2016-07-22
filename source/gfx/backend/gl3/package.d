module gfx.backend.gl3;

import gfx.backend : unsafeCast;
import gfx.backend.gl3.info : ContextInfo;
import gfx.backend.gl3.buffer : makeBufferImpl;
import gfx.backend.gl3.texture : makeTextureImpl, GlSurface;
import gfx.backend.gl3.view :   GlBufferShaderResourceView,
                                GlTextureShaderResourceView,
                                GlTextureTargetView,
                                GlSurfaceTargetView;
import gfx.backend.gl3.program : GlShader, GlProgram;
import gfx.backend.gl3.pso : GlPipelineState;
import gfx.backend.gl3.command : GlCommandBuffer;

import gfx.core : Device;
import gfx.core.context : Context;
import gfx.core.format : Format;
import gfx.core.buffer : BufferRes, RawBuffer;
import gfx.core.texture : TextureRes, RawTexture, TextureUsage;
import gfx.core.surface : SurfaceRes, RawSurface;
import gfx.core.program : ShaderStage, ShaderRes, ProgramRes, ProgramVars, Program;
import gfx.core.view : ShaderResourceViewRes, RenderTargetViewRes, DepthStencilViewRes;
import gfx.core.pso : PipelineStateRes, PipelineDescriptor;
import gfx.core.command : CommandBuffer;

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

        import std.exception : enforce;

        enforce(_info.glVersion.major >= 3, "Open GL 3.0 is requested by gfx-d");
        enforce(_info.glslVersion.decimal >= 130, "GLSL v1.30 is requested by gfx-d");
        enforce(_info.caps.interfaceQuery, "GL_ARB_program_interface_query is requested by gfx-d");

        _deviceContext = new GlDeviceContext(_info.caps);
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
        bool, "instanceRate", 1,
        byte, "", 2,
    ));
}


class GlDeviceContext : Context {

    GlCaps _caps;

    this(GlCaps caps) {
        _caps = caps;
    }

    @property GlCaps caps() const { return _caps; }


    @property bool hasIntrospection() const {
        return _caps.interfaceQuery;
    }
    @property string name() const {
        return "OpenGl 3";
    }

    TextureRes makeTexture(TextureCreationDesc desc, const(ubyte)[][] data) {
        return makeTextureImpl(_caps.textureStorage, desc, data);
    }
    SurfaceRes makeSurface(SurfaceCreationDesc desc) {
        return new GlSurface(desc);
    }
    BufferRes makeBuffer(BufferCreationDesc desc, const(ubyte)[] data) {
        return makeBufferImpl(desc, data);
    }
    ShaderRes makeShader(ShaderStage stage, string code) {
        return new GlShader(stage, code);
    }
    ProgramRes makeProgram(ShaderRes[] shaders) {
        return new GlProgram(_caps.ubo, shaders);
    }
    ShaderResourceViewRes makeShaderResourceView(RawTexture tex, TexSRVCreationDesc desc) {
        return new GlTextureShaderResourceView(tex, desc);
    }
    ShaderResourceViewRes makeShaderResourceView(RawBuffer buf, Format fmt) {
        return new GlBufferShaderResourceView(buf, fmt);
    }
    RenderTargetViewRes makeRenderTargetView(RawTexture tex, TexRTVCreationDesc desc) {
        return new GlTextureTargetView(tex, desc);
    }
    RenderTargetViewRes makeRenderTargetView(RawSurface surf) {
        return new GlSurfaceTargetView(surf);
    }
    DepthStencilViewRes makeDepthStencilView(RawTexture tex, TexDSVCreationDesc desc) {
        return new GlTextureTargetView(tex, desc);
    }
    DepthStencilViewRes makeDepthStencilView(RawSurface surf) {
        return new GlSurfaceTargetView(surf);
    }
    PipelineStateRes makePipeline(Program prog, PipelineDescriptor descriptor) {
        return new GlPipelineState(prog, descriptor);
    }

    CommandBuffer makeCommandBuffer() {
        return new GlCommandBuffer();
    }

    void submit(CommandBuffer buffer) {
        import std.algorithm : each;
        auto cmds = unsafeCast!GlCommandBuffer(buffer).retrieve();
        cmds.each!(cmd => cmd.execute(this));
    }
}