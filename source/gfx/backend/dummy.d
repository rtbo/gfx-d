module gfx.backend.dummy;

import gfx.core : Device;
import gfx.core.context : Context;
import gfx.core.rc : rcCode;
import gfx.core.format : Format;
import gfx.core.buffer : BufferRes, RawBuffer, BufferSliceInfo;
import gfx.core.texture : TextureRes, RawTexture, ImageSliceInfo;
import gfx.core.program : ShaderRes, ProgramRes, ProgramVars, ShaderStage, Program;
import gfx.core.view : ShaderResourceViewRes, RenderTargetViewRes, DepthStencilViewRes;
import gfx.core.pso : PipelineStateRes, PipelineDescriptor;


class DummyDevice : Device {
    @property Context context() {
        return new DummyContext();
    }
}


class DummyContext : Context {

    @property bool hasIntrospection() const { return false; }
    @property string name() const { return "dummy"; }

    TextureRes makeTexture(TextureCreationDesc, const(ubyte)[][]) {
        return new DummyTexture();
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
    ShaderResourceViewRes viewAsShaderResource(RawBuffer, Format fmt) {
        return null;
    }
    ShaderResourceViewRes viewAsShaderResource(RawTexture, TexSRVCreationDesc desc) {
        return null;
    }
    RenderTargetViewRes viewAsRenderTarget(RawTexture tex, TexRTVCreationDesc desc) {
        return null;
    }
    DepthStencilViewRes viewAsDepthStencil(RawTexture tex, TexDSVCreationDesc desc) {
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