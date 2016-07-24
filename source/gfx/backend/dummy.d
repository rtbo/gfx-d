module gfx.backend.dummy;

import gfx.core : Device;
import gfx.core.factory : Factory;
import gfx.core.rc : rcCode;
import gfx.core.format : Format;
import gfx.core.buffer : BufferRes, RawBuffer, BufferSliceInfo;
import gfx.core.texture : TextureRes, RawTexture, ImageSliceInfo;
import gfx.core.surface : SurfaceRes, BuiltinSurfaceRes, RawSurface;
import gfx.core.program : ShaderRes, ProgramRes, ProgramVars, ShaderStage, Program;
import gfx.core.view : ShaderResourceViewRes, RenderTargetViewRes, DepthStencilViewRes;
import gfx.core.pso : PipelineStateRes, PipelineDescriptor;
import gfx.core.command : CommandBuffer;


class DummyDevice : Device {
    mixin(rcCode);
    void drop() {}

    @property bool hasIntrospection() const { return false; }
    @property string name() const { return "dummy"; }

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
    SurfaceRes makeSurface(SurfaceCreationDesc desc) {
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
    void update(BufferSliceInfo slice, const(ubyte)[] data) {}
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