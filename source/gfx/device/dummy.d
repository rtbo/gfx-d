module gfx.device.dummy;

import gfx.device : Device, Caps;
import gfx.device.factory : Factory;
import gfx.foundation.rc : rcCode;
import gfx.pipeline.format : Format;
import gfx.pipeline.buffer : BufferRes, RawBuffer;
import gfx.pipeline.texture : TextureRes, RawTexture, ImageSliceInfo, SamplerRes, SamplerInfo;
import gfx.pipeline.surface : SurfaceRes, BuiltinSurfaceRes, RawSurface;
import gfx.pipeline.program : ShaderRes, ProgramRes, ProgramVars, ShaderStage, Program;
import gfx.pipeline.view : ShaderResourceViewRes, RenderTargetViewRes, DepthStencilViewRes;
import gfx.pipeline.pso : PipelineStateRes, PipelineDescriptor;
import gfx.pipeline.draw : CommandBuffer;


class DummyDevice : Device {
    mixin(rcCode);
    void dispose() {}

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
    void dispose() {}
    void bind() {}
    void update(in ImageSliceInfo slice, const(ubyte)[] data) {}
}

class DummyBuffer : BufferRes {
    mixin(rcCode);
    void dispose() {}
    void bind() {}
    void update(size_t buffer, const(ubyte)[] data) {}
}

class DummyShader : ShaderRes {
    mixin(rcCode);
    void dispose() {}
    @property ShaderStage stage() const { return ShaderStage.Vertex; }
}

class DummyProgram : ProgramRes {
    mixin(rcCode);
    void dispose() {}
    void bind() {}
    ProgramVars fetchVars() const {
        return ProgramVars.init;
    }
}