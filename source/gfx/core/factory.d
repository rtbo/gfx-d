module gfx.core.factory;

import gfx.core.typecons : Option;
import gfx.core.buffer : BufferRes, RawBuffer, BufferRole, BufferUsage;
import gfx.core.format : Format, ChannelType, Swizzle;
import gfx.core.texture : TextureRes, RawTexture, TextureType, TexUsageFlags, ImageInfo;
import gfx.core.surface : SurfaceRes, SurfUsageFlags, RawSurface;
import gfx.core.program : ShaderStage, ShaderRes, ProgramRes, Program;
import gfx.core.view : ShaderResourceViewRes, RenderTargetViewRes, DepthStencilViewRes, DSVReadOnlyFlags;
import gfx.core.pso : PipelineStateRes, PipelineDescriptor;
import gfx.core.command : CommandBuffer;

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

    struct SurfaceCreationDesc {
        SurfUsageFlags usage;
        Format format;
        ushort width;
        ushort height;
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


    CommandBuffer makeCommandBuffer();
}