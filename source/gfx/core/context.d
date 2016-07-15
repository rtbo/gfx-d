module gfx.core.context;

import gfx.core.buffer;
import gfx.core.format;
import gfx.core.texture;
import gfx.core.program;
import gfx.core.shader_resource;
import gfx.core.render_target;

import std.typecons : Nullable;

interface Context {

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

    ProgramRes makeProgram(ShaderRes[] shaders, out ProgramVars info);

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
        Nullable!ubyte layer;
    }
    RenderTargetViewRes viewAsRenderTarget(RawTexture tex, TexRTVCreationDesc desc);

    struct TexDSVCreationDesc {
        ubyte level;
        Nullable!ubyte layer;
        DSVReadOnlyFlags flags;
    }
    DepthStencilViewRes viewAsDepthStencil(RawTexture tex, TexDSVCreationDesc desc);
}