module gfx.core.context;

import gfx.core.typecons : Option;
import gfx.core.buffer : BufferRes, RawBuffer, BufferRole, BufferUsage;
import gfx.core.format : Format, ChannelType, Swizzle;
import gfx.core.texture : TextureRes, RawTexture, TextureType, TexUsageFlags, ImageInfo;
import gfx.core.program : ShaderStage, ShaderRes, ProgramRes, Program;
import gfx.core.view : ShaderResourceViewRes, RenderTargetViewRes, DepthStencilViewRes, DSVReadOnlyFlags;
import gfx.core.pso : PipelineStateRes, PipelineDescriptor;
import gfx.core.command : CommandBuffer;

interface Context {

    @property bool hasIntrospection() const;
    @property string name() const;

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

    ShaderRes makeShader(ShaderStage stage, string code);

    ProgramRes makeProgram(ShaderRes[] shaders);

    ShaderResourceViewRes viewAsShaderResource(RawBuffer buf, Format fmt);

    struct TexSRVCreationDesc {
        ChannelType channel;
        ubyte minLevel;
        ubyte maxLevel;
        Swizzle swizzle;
    }
    ShaderResourceViewRes viewAsShaderResource(RawTexture tex, TexSRVCreationDesc desc);

    struct TexRTVCreationDesc {
        ChannelType channel;
        ubyte level;
        Option!ubyte layer;
    }
    RenderTargetViewRes viewAsRenderTarget(RawTexture tex, TexRTVCreationDesc desc);

    struct TexDSVCreationDesc {
        ubyte level;
        Option!ubyte layer;
        DSVReadOnlyFlags flags;
    }
    DepthStencilViewRes viewAsDepthStencil(RawTexture tex, TexDSVCreationDesc desc);

    PipelineStateRes makePipeline(Program prog, PipelineDescriptor descriptor);


    CommandBuffer makeCommandBuffer();

    void submit(CommandBuffer buffer);
}