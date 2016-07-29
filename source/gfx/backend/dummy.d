module gfx.backend.dummy;

import gfx.core : Device, Caps;
import gfx.core.factory : Factory;
import gfx.core.rc : rcCode;
import gfx.core.format : Format;
import gfx.core.buffer : BufferRes, RawBuffer;
import gfx.core.texture : TextureRes, RawTexture, ImageSliceInfo, SamplerRes, SamplerInfo;
import gfx.core.surface : SurfaceRes, BuiltinSurfaceRes, RawSurface;
import gfx.core.program : ShaderRes, ProgramRes, ProgramVars, ShaderStage, Program;
import gfx.core.view : ShaderResourceViewRes, RenderTargetViewRes, DepthStencilViewRes;
import gfx.core.pso : PipelineStateRes, PipelineDescriptor;
import gfx.core.draw : CommandBuffer;


class DummyDevice : Device {
    mixin(rcCode);
    void drop() {}

    @property string name() const { return "dummy"; }
    @property Caps caps() const {
        return Caps();
    }

    @property Factory factory() {
        return new DummyFactory();
    }

    @property BuiltinSurfaceRes builtinSurface() {
        return null;
    }

    CommandBuffer makeCommandBuffer() {
        return null;
    }

    void submit(CommandBuffer buffer) {}
}


class DummyFactory : Factory {

    TextureRes makeTexture(TextureCreationDesc, const(ubyte)[][]) {
        return new DummyTexture();
    }
    SamplerRes makeSampler(ShaderResourceViewRes, SamplerInfo) {
        return null;
    }
    SurfaceRes makeSurface(SurfaceCreationDesc) {
        return null;
    }
    BufferRes makeBuffer(BufferCreationDesc, const(ubyte)[]) {
        return new DummyBuffer();
    }
    ShaderRes makeShader(ShaderStage, string) {
        return new DummyShader();
    }
    ProgramRes makeProgram(ShaderRes[]) {
        return new DummyProgram();
    }
    ShaderResourceViewRes makeShaderResourceView(RawTexture, TexSRVCreationDesc) {
        return null;
    }
    ShaderResourceViewRes makeShaderResourceView(RawBuffer, Format) {
        return null;
    }
    RenderTargetViewRes makeRenderTargetView(RawTexture, TexRTVCreationDesc) {
        return null;
    }
    RenderTargetViewRes makeRenderTargetView(RawSurface) {
        return null;
    }
    DepthStencilViewRes makeDepthStencilView(RawTexture, TexDSVCreationDesc) {
        return null;
    }
    DepthStencilViewRes makeDepthStencilView(RawSurface) {
        return null;
    }
    PipelineStateRes makePipeline(Program, PipelineDescriptor) {
        return null;
    }
}


class DummyTexture : TextureRes {
    mixin(rcCode);
    void drop() {}
    void bind() {}
    void update(in ImageSliceInfo slice, const(ubyte)[] data) {}
}

class DummyBuffer : BufferRes {
    mixin(rcCode);
    void drop() {}
    void bind() {}
    void update(size_t buffer, const(ubyte)[] data) {}
}

class DummyShader : ShaderRes {
    mixin(rcCode);
    void drop() {}
    @property ShaderStage stage() const { return ShaderStage.Vertex; }
}

class DummyProgram : ProgramRes {
    mixin(rcCode);
    void drop() {}
    void bind() {}
    ProgramVars fetchVars() const {
        return ProgramVars.init;
    }
}