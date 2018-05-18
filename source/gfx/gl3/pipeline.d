module gfx.gl3.pipeline;

package:

import gfx.bindings.opengl.gl : Gl, GLenum, GLint, GLuint;
import gfx.graal.pipeline;
import gfx.graal.renderpass;

final class GlShaderModule : ShaderModule
{
    import gfx.bindings.opengl.gl : GLuint;
    import gfx.core.rc : atomicRcCode;
    import gfx.gl3 : GlShare;

    mixin(atomicRcCode);

    private Gl gl;
    private GLuint _name;
    private string _code;
    private ShaderStage _stage;

    this (GlShare share, in const(uint)[] code) {
        import spirv_cross : SpvCompilerGlsl;
        gl = share.gl;
        auto cl = new SpvCompilerGlsl(code);
        scope(exit) cl.dispose();
        auto opts = cl.options;
        opts.ver = share.info.glslVer;
        opts.enable_420pack = false;
        opts.vertex_invert_y = true;
        // opts.vertex_transform_clip_space = true;
        cl.options = opts;
        _code = cl.compile();
    }

    override void dispose() {
        if (_name != 0) {
            gl.DeleteShader(_name);
        }
    }

    override @property string entryPoint() {
        return "main";
    }

    GLuint compile(in ShaderStage stage)
    {
        if (_name) {
            import std.exception : enforce;
            enforce(stage == _stage, "unsupported: try to compile the same shader for different stages");
            return _name;
        }

        import gfx.bindings.opengl.gl : GLchar, GLint;
        import gfx.gl3.conv : toGl;

        const target = toGl(stage);
        _name = gl.CreateShader(target);

        const GLint len = cast(GLint)_code.length;
        const GLchar* str = cast(const(GLchar)*)_code.ptr;
        gl.ShaderSource(_name, 1, &str, &len);

        gl.CompileShader(_name);

        const log = getShaderLog(gl, _name);
        if (!getShaderCompileStatus(gl, _name)) {
            import gfx.gl3.error : Gl3ShaderCompileException;
            throw new Gl3ShaderCompileException(stage, _code, log);
        }
        else if (log.length) {
            import std.conv : to;
            import std.experimental.logger : logf;
            logf("%s shader compile message: %s", stage.to!string, log);
        }
        _stage = stage;
        return _name;
    }

}


private SubpassDescription clone(const(SubpassDescription) sd) {
    return SubpassDescription(
        sd.inputs.dup, sd.colors.dup, sd.depthStencil.save, sd.preserves.dup
    );
}

private SubpassDescription[] clone(in SubpassDescription[] descs) {
    import std.array : uninitializedArray;
    auto duplicate = uninitializedArray!(SubpassDescription[])(descs.length);
    foreach (i; 0 .. descs.length) {
        duplicate[i] = descs[i].clone();
    }
    return duplicate;
}


final class GlRenderPass : RenderPass
{
    import gfx.core.rc : atomicRcCode;

    mixin(atomicRcCode);

    package AttachmentDescription[] attachments;
    package SubpassDescription[]    subpasses;
    package SubpassDependency[]     deps;

    this(   in AttachmentDescription[] attachments,
            in SubpassDescription[] subpasses,
            in SubpassDependency[] dependencies)
    {
        this.attachments = attachments.dup;
        this.subpasses = subpasses.clone();
        this.deps = dependencies.dup;
    }

    override void dispose() {}
}

final class GlPipelineLayout : PipelineLayout
{
    import gfx.core.rc : atomicRcCode;

    mixin(atomicRcCode);

    private DescriptorSetLayout[] _layouts;
    private PushConstantRange[] _push;

    this (DescriptorSetLayout[] layouts, PushConstantRange[] push) {
        import gfx.core.rc : retainArray;
        _layouts = layouts;
        retainArray(_layouts);
        _push = push;
    }

    override void dispose() {
        import gfx.core.rc : releaseArray;
        releaseArray(_layouts);
    }
}


final class GlFramebuffer : Framebuffer
{
    import gfx.bindings.opengl.gl : Gl, GLuint;
    import gfx.core.rc : atomicRcCode;
    import gfx.gl3 : GlShare;
    import gfx.gl3.resource : GlImageView;

    mixin (atomicRcCode);

    private GlRenderPass rp;
    private GlImageView[] attachments;
    private uint width;
    private uint height;
    private uint layers;

    private Gl gl;
    private GLuint _name;

    this (GlShare share, GlRenderPass rp, GlImageView[] attachments, uint width, uint height, uint layers)
    {
        import gfx.core.rc : retainArray;
        import std.exception : enforce;

        enforce(
            rp.attachments.length == attachments.length,
            "Render pass do not fit with attachments in Framebuffer creation"
        );

        this.rp = rp;
        this.attachments = attachments;
        this.width = width;
        this.height = height;
        this.layers = layers;

        rp.retain();
        retainArray(this.attachments);

        this.gl = share.gl;

        gl.GenFramebuffers(1, &_name);

        import gfx.bindings.opengl.gl : GLenum, GLsizei, GL_COLOR_ATTACHMENT0,
                                        GL_DRAW_FRAMEBUFFER;

        gl.BindFramebuffer(GL_DRAW_FRAMEBUFFER, _name);

        uint colorNum = 0;

        foreach(attachment; attachments) {
            attachment.attachToFbo(GL_DRAW_FRAMEBUFFER, colorNum);
        }

        auto drawBufs = new GLenum[colorNum];
        foreach(i; 0 .. colorNum) {
            drawBufs[i] = GL_COLOR_ATTACHMENT0 + i;
        }
        gl.DrawBuffers(cast(GLsizei)colorNum, drawBufs.ptr);

        gl.BindFramebuffer(GL_DRAW_FRAMEBUFFER, 0);
    }

    @property GLuint name() const {
        return _name;
    }

    override void dispose()
    {
        import gfx.core.rc : releaseArray;

        gl.DeleteFramebuffers(1, &_name);

        releaseArray(attachments);
        rp.release();
    }
}

final class GlPipeline : Pipeline
{
    import gfx.bindings.opengl.gl : GLuint;
    import gfx.core.rc : atomicRcCode;
    import gfx.gl3 : GlShare;

    mixin(atomicRcCode);

    private Gl gl;
    package GLuint prog;
    package PipelineInfo info;

    this(GlShare share, PipelineInfo info) {
        this.gl = share.gl;
        this.info = info;

        prog = gl.CreateProgram();

        import std.exception : enforce;
        enforce(info.shaders.vertex, "Vertex input shader is mandatory");

        void attachShader(ShaderStage stage, ShaderModule mod) {
            if (!mod) return;
            auto glMod = cast(GlShaderModule)mod;
            const name = glMod.compile(stage);
            gl.AttachShader(prog, name);
        }

        attachShader(ShaderStage.vertex, info.shaders.vertex);
        attachShader(ShaderStage.tessellationControl, info.shaders.tessControl);
        attachShader(ShaderStage.tessellationEvaluation, info.shaders.tessEval);
        attachShader(ShaderStage.geometry, info.shaders.geometry);
        attachShader(ShaderStage.fragment, info.shaders.fragment);

        gl.LinkProgram(prog);

        const log = getProgramLog(gl, prog);
        if (!getProgramLinkStatus(gl, prog)) {
            import gfx.gl3.error : Gl3ProgramLinkException;
            throw new Gl3ProgramLinkException(log);
        }

        if (log.length) {
            import std.experimental.logger : logf;
            logf("Gfx-Gl: Program link message: %s", log);
        }
    }

    override void dispose() {
        gl.DeleteProgram(prog);
        prog = 0;
    }
}

final class GlDescriptorSetLayout : DescriptorSetLayout
{
    import gfx.core.rc : atomicRcCode;
    mixin(atomicRcCode);
    const(PipelineLayoutBinding[]) bindings;
    this(in PipelineLayoutBinding[] bindings) {
        this.bindings = bindings;
    }
    override void dispose() {}
}

final class GlDescriptorPool : DescriptorPool
{
    import gfx.core.rc : atomicRcCode;
    mixin(atomicRcCode);

    private uint maxSets;
    private const(DescriptorPoolSize[]) sizes;

    this(in uint maxSets, in DescriptorPoolSize[] bindings) {
        this.maxSets = maxSets;
        this.sizes = sizes;
    }
    override void dispose() {}

    override DescriptorSet[] allocate(DescriptorSetLayout[] layouts) {
        import std.algorithm : map;
        import std.array : array;
        return layouts.map!(l => cast(DescriptorSet)new GlDescriptorSet(this, l)).array;
    }

    override void reset() {}
}

union GlDescriptor {
    import gfx.graal.image : Sampler;
    import gfx.graal.buffer : BufferView;

    Sampler                 sampler;
    CombinedImageSampler    combinedImageSampler;
    ImageViewLayout         imageViewLayout;
    BufferRange             bufferRange;
    BufferView              bufferView;
}

struct GlDescriptorSetBinding
{
    PipelineLayoutBinding layout;
    GlDescriptor[] descriptors;

    @property uint index() const { return layout.binding; }
}

final class GlDescriptorSet : DescriptorSet
{
    private GlDescriptorPool _pool;

    GlDescriptorSetBinding[] bindings;

    this(GlDescriptorPool pool, DescriptorSetLayout layout) {
        _pool = pool;
        const layoutBindings = (cast(GlDescriptorSetLayout)layout).bindings;
        bindings = new GlDescriptorSetBinding[layoutBindings.length];
        foreach (i, ref b; bindings) {
            b.layout = layoutBindings[i];
            b.descriptors = new GlDescriptor[b.layout.descriptorCount];
        }
    }
    override @property DescriptorPool pool() {
        return _pool;
    }

    void write(uint dstBinding, uint dstArrayElem, DescriptorWrites writes)
    {
        assert(writes.type == bindings[dstBinding].layout.descriptorType);
        assign(
            bindings[dstBinding].descriptors[
                dstArrayElem .. dstArrayElem+writes.count
            ],
            writes
        );
    }

    private void assign(GlDescriptor[] descs, DescriptorWrites writes) {
        import gfx.core.util : unsafeCast;
        import gfx.graal.image : Sampler;
        import gfx.graal.buffer : BufferView;

        final switch (writes.type) {
        case DescriptorType.sampler:
            auto w = unsafeCast!(SamplerDescWrites)(writes);
            foreach (i, ref d; descs) {
                d.sampler = w.descs[i];
            }
            break;
        case DescriptorType.combinedImageSampler:
            auto w = unsafeCast!(CombinedImageSamplerDescWrites)(writes);
            foreach (i, ref d; descs) {
                d.combinedImageSampler = w.descs[i];
            }
            break;
        case DescriptorType.sampledImage:
        case DescriptorType.storageImage:
        case DescriptorType.inputAttachment:
            auto w = unsafeCast!(TDescWritesBase!ImageViewLayout)(writes);
            foreach (i, ref d; descs) {
                d.imageViewLayout = w.descs[i];
            }
            break;
        case DescriptorType.uniformBuffer:
        case DescriptorType.storageBuffer:
        case DescriptorType.uniformBufferDynamic:
        case DescriptorType.storageBufferDynamic:
            auto w = unsafeCast!(TDescWritesBase!(BufferRange))(writes);
            foreach (i, ref d; descs) {
                d.bufferRange = w.descs[i];
            }
            break;
        case DescriptorType.uniformTexelBuffer:
        case DescriptorType.storageTexelBuffer:
            auto w = unsafeCast!(TDescWritesBase!(BufferView))(writes);
            foreach (i, ref d; descs) {
                d.bufferView = w.descs[i];
            }
            break;
        }
    }

}

private GLint getShaderInt(Gl gl, in GLuint name, in GLenum pname) {
    GLint res;
    gl.GetShaderiv(name, pname, &res);
    return res;
}

private bool getShaderCompileStatus(Gl gl, in GLuint name) {
    import gfx.bindings.opengl.gl : GL_COMPILE_STATUS, GL_FALSE;
    return getShaderInt(gl, name, GL_COMPILE_STATUS) != GL_FALSE;
}

private string getShaderLog(Gl gl, in GLuint name) {
    import gfx.bindings.opengl.gl : GL_INFO_LOG_LENGTH;
    auto len = getShaderInt(gl, name, GL_INFO_LOG_LENGTH);
    if (len > 1) { // some return 1 for empty string (null char)
        auto msg = new char[len];
        gl.GetShaderInfoLog(name, len, &len, msg.ptr);
        return msg[0 .. len-1].idup;
    }
    else {
        return null;
    }
}



private GLint getProgramInt(Gl gl, in GLuint name, in GLenum pname) {
    GLint res;
    gl.GetProgramiv(name, pname, &res);
    return res;
}

private bool getProgramLinkStatus(Gl gl, in GLuint name) {
    import gfx.bindings.opengl.gl : GL_FALSE, GL_LINK_STATUS;
    return getProgramInt(gl, name, GL_LINK_STATUS) != GL_FALSE;
}


private string getProgramLog(Gl gl, in GLuint name) {
    import gfx.bindings.opengl.gl : GL_INFO_LOG_LENGTH;
    auto len = getProgramInt(gl, name, GL_INFO_LOG_LENGTH);
    if (len > 1) {
        auto msg = new char[len];
        gl.GetProgramInfoLog(name, len, &len, msg.ptr);
        return msg[0 .. len-1].idup;
    }
    else {
        return null;
    }
}
