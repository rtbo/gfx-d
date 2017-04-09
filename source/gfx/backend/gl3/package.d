module gfx.backend.gl3;

import gfx.backend.gl3.info : ContextInfo;
import gfx.backend.gl3.buffer : makeBufferImpl;
import gfx.backend.gl3.texture :    makeTextureImpl, GlSurface, GlBuiltinSurface,
                                    GlSamplerWithObj, GlSamplerWithoutObj;
import gfx.backend.gl3.view :   GlBufferShaderResourceView,
                                GlTextureShaderResourceView,
                                GlTextureTargetView,
                                GlSurfaceTargetView;
import gfx.backend.gl3.program : GlShader, GlProgram;
import gfx.backend.gl3.pso : GlPipelineState;
import gfx.backend.gl3.command : GlCommandBuffer;

import gfx.core : Device, Caps;
import gfx.core.rc : rcCode, Rc;
import gfx.core.factory : Factory;
import gfx.core.format : Format;
import gfx.core.buffer : BufferRes, RawBuffer;
import gfx.core.texture : TextureRes, RawTexture, TextureUsage, SamplerRes, SamplerInfo;
import gfx.core.surface : SurfaceRes, BuiltinSurfaceRes, RawSurface;
import gfx.core.program : ShaderStage, ShaderRes, ProgramRes, ProgramVars, Program;
import gfx.core.view : ShaderResourceViewRes, RenderTargetViewRes, DepthStencilViewRes;
import gfx.core.pso : PipelineStateRes, PipelineDescriptor;
import gfx.core.draw : CommandBuffer;

import derelict.opengl3.gl3;

import std.experimental.logger;


Device createGlDevice() {
    return new GlDevice();
}


struct GlCaps {
    import std.bitmanip : bitfields;

    mixin(bitfields!(
        bool, "samplerObject", 1,
        bool, "textureStorage", 1,
        bool, "attribBinding", 1,
        bool, "ubo", 1,
        byte, "", 4,
    ));
}


class GlDevice : Device {

    mixin(rcCode);

    GlFactory _factory;
    ContextInfo _info;
    Rc!GlBuiltinSurface _builtinSurf;
    GLuint _fbo;
    GLuint _vao;

    this() {
        _info = ContextInfo.fetch();

        import std.exception : enforce;

        enforce(_info.glVersion.major >= 3, "Open GL 3.0 is requested by gfx-d");
        enforce(_info.glslVersion.decimal >= 130, "GLSL v1.30 is requested by gfx-d");
        enforce(_info.caps.introspection, "GL_ARB_program_interface_query is requested by gfx-d");
        enforce(_info.glCaps.ubo, "GL_ARB_uniform_buffer_object is requested by gfx-d");

        _factory = new GlFactory(_info.caps, _info.glCaps);

        glGenFramebuffers(1, &_fbo);
        glGenVertexArrays(1, &_vao);
        glBindVertexArray(_vao);
    }

    final void drop() {
        glDeleteVertexArrays(1, &_vao);
        glDeleteFramebuffers(1, &_fbo);
        _builtinSurf.unload();
    }

    final @property const(ContextInfo) info() const { return _info; }
    final @property Caps caps() const { return _info.caps; }
    final @property GlCaps glCaps() const { return _info.glCaps; }

    final @property string name() const {
        return "OpenGl 3";
    }

    final @property Factory factory() {
        return _factory;
    }

    final @property BuiltinSurfaceRes builtinSurface() {
        if (!_builtinSurf.loaded) _builtinSurf = new GlBuiltinSurface;
        return _builtinSurf.obj;
    }

    final CommandBuffer makeCommandBuffer() {
        return new GlCommandBuffer(_fbo);
    }

    final void submit(CommandBuffer buffer) {
        import gfx.core.util : unsafeCast;
        import std.algorithm : each;
        auto cmds = unsafeCast!GlCommandBuffer(buffer).retrieve();
        cmds.each!(cmd => cmd.execute(this));
        cmds.each!(cmd => cmd.unload());
    }
}


class GlFactory : Factory {

    Caps _caps;
    GlCaps _glCaps;

    this(Caps caps, GlCaps glCaps) {
        _caps = caps;
        _glCaps = glCaps;
    }

    final @property Caps caps() const { return _caps; }
    final @property GlCaps glCaps() const { return _glCaps; }

    final TextureRes makeTexture(TextureCreationDesc desc, const(ubyte)[][] data) {
        return makeTextureImpl(glCaps.textureStorage, desc, data);
    }
    final SamplerRes makeSampler(ShaderResourceViewRes srv, SamplerInfo info) {
        if (glCaps.samplerObject) {
            return new GlSamplerWithObj(srv, info);
        }
        else {
            return new GlSamplerWithoutObj(srv, info);
        }
    }
    final SurfaceRes makeSurface(SurfaceCreationDesc desc) {
        return new GlSurface(desc);
    }
    final BufferRes makeBuffer(BufferCreationDesc desc, const(ubyte)[] data) {
        return makeBufferImpl(desc, data);
    }
    final ShaderRes makeShader(ShaderStage stage, string code) {
        return new GlShader(stage, code);
    }
    final ProgramRes makeProgram(ShaderRes[] shaders) {
        return new GlProgram(glCaps.ubo, shaders);
    }
    final ShaderResourceViewRes makeShaderResourceView(RawTexture tex, TexSRVCreationDesc desc) {
        return new GlTextureShaderResourceView(tex, desc);
    }
    final ShaderResourceViewRes makeShaderResourceView(RawBuffer buf, Format fmt) {
        return new GlBufferShaderResourceView(buf, fmt);
    }
    final RenderTargetViewRes makeRenderTargetView(RawTexture tex, TexRTVCreationDesc desc) {
        return new GlTextureTargetView(tex, desc);
    }
    final RenderTargetViewRes makeRenderTargetView(RawSurface surf) {
        return new GlSurfaceTargetView(surf);
    }
    final DepthStencilViewRes makeDepthStencilView(RawTexture tex, TexDSVCreationDesc desc) {
        return new GlTextureTargetView(tex, desc);
    }
    final DepthStencilViewRes makeDepthStencilView(RawSurface surf) {
        return new GlSurfaceTargetView(surf);
    }
    final PipelineStateRes makePipeline(Program prog, PipelineDescriptor descriptor) {
        return new GlPipelineState(prog, descriptor);
    }
}