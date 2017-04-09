module gfx.device.factory;

import gfx.device : Size;
import gfx.foundation.typecons : Option;
import gfx.pipeline.buffer : BufferRes, RawBuffer, BufferRole, BufferUsage;
import gfx.pipeline.format : Format, ChannelType, Swizzle;
import gfx.pipeline.texture :   TextureRes, RawTexture, TextureType, TexUsageFlags, ImageInfo,
                            SamplerRes, SamplerInfo;
import gfx.pipeline.surface : SurfaceRes, SurfUsageFlags, RawSurface;
import gfx.pipeline.program : ShaderStage, ShaderRes, ProgramRes, Program;
import gfx.pipeline.view :  ShaderResourceViewRes, RenderTargetViewRes, DepthStencilViewRes, DSVReadOnlyFlags;
import gfx.pipeline.pso : PipelineStateRes, PipelineDescriptor;

interface Factory {

    struct BufferCreationDesc {
        BufferRole role;
        BufferUsage usage;
        size_t size;
    }
    BufferRes makeBuffer(BufferCreationDesc desc, const(ubyte)[] data);


    struct TextureCreationDesc {
        TextureType type = TextureType.D1;
        TexUsageFlags usage;
        Format format;
        ImageInfo imgInfo;
        ubyte samples;
    }
    TextureRes makeTexture(TextureCreationDesc desc, const(ubyte)[][] data);

    SamplerRes makeSampler(ShaderResourceViewRes srv, SamplerInfo info);

    struct SurfaceCreationDesc {
        SurfUsageFlags usage;
        Format format;
        Size size;
        ubyte samples;
    }
    SurfaceRes makeSurface(SurfaceCreationDesc desc);

    ShaderRes makeShader(ShaderStage stage, string code);

    ProgramRes makeProgram(ShaderRes[] shaders);

    struct TexSRVCreationDesc {
        ChannelType channel;
        ubyte minLevel;
        ubyte maxLevel;
        Swizzle swizzle;
    }
    ShaderResourceViewRes makeShaderResourceView(RawTexture tex, TexSRVCreationDesc desc);

    ShaderResourceViewRes makeShaderResourceView(RawBuffer buf, Format fmt);

    struct TexRTVCreationDesc {
        ChannelType channel;
        ubyte level;
        Option!ubyte layer;
    }
    RenderTargetViewRes makeRenderTargetView(RawTexture tex, TexRTVCreationDesc desc);

    RenderTargetViewRes makeRenderTargetView(RawSurface surf);

    struct TexDSVCreationDesc {
        ubyte level;
        Option!ubyte layer;
        DSVReadOnlyFlags flags;
    }
    DepthStencilViewRes makeDepthStencilView(RawTexture tex, TexDSVCreationDesc desc);

    DepthStencilViewRes makeDepthStencilView(RawSurface surf);




    PipelineStateRes makePipeline(Program prog, PipelineDescriptor descriptor);

}
