module gfx.gl3.pipeline;

package:

import gfx.bindings.opengl.gl : Gl, GLenum, GLint, GLuint;
import gfx.graal.device : Device;
import gfx.graal.pipeline;
import gfx.graal.renderpass;

final class GlShaderModule : ShaderModule
{
    import gfx.bindings.opengl.gl : GLuint;
    import gfx.core.rc : atomicRcCode, Rc;
    import gfx.gl3 : GlShare;

    mixin(atomicRcCode);

    private Rc!Device _dev;
    private Gl gl;
    private GLuint _name;
    private string _code;
    private ShaderStage _stage;

    this (Device dev, GlShare share, in const(uint)[] code) {
        import spirv_cross : ScCompilerGlsl;
        _dev = dev;
        gl = share.gl;
        auto cl = new ScCompilerGlsl(code);
        scope(exit) cl.dispose();
        auto opts = cl.options;
        opts.ver = share.info.glslVer;
        opts.enable420PackExtension = false;
        cl.options = opts;
        _code = cl.compile();
    }

    override void dispose() {
        if (_name != 0) {
            gl.DeleteShader(_name);
        }
        _dev.unload();
    }

    override @property Device device() {
        return _dev;
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
            import gfx.gl3 : gfxGlLog;
            gfxGlLog.infof("%s shader compile message: %s", stage.to!string, log);
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
    import gfx.core.rc : atomicRcCode, Rc;

    mixin(atomicRcCode);

    private Rc!Device _dev;
    package AttachmentDescription[] attachments;
    package SubpassDescription[]    subpasses;
    package SubpassDependency[]     deps;

    this(   Device device,
            in AttachmentDescription[] attachments,
            in SubpassDescription[] subpasses,
            in SubpassDependency[] dependencies)
    {
        _dev = device;
        this.attachments = attachments.dup;
        this.subpasses = subpasses.clone();
        this.deps = dependencies.dup;
    }

    override void dispose() {
        _dev.unload();
    }

    override @property Device device() {
        return _dev;
    }
}

final class GlPipelineLayout : PipelineLayout
{
    import gfx.core.rc : atomicRcCode, Rc;

    mixin(atomicRcCode);

    private Rc!Device _dev;
    private DescriptorSetLayout[] _layouts;
    private const(PushConstantRange)[] _push;

    this (Device device, DescriptorSetLayout[] layouts, in PushConstantRange[] push) {
        import gfx.core.rc : retainArr;
        _dev = device;
        _layouts = layouts;
        retainArr(_layouts);
        _push = push;
    }

    override void dispose() {
        import gfx.core.rc : releaseArr;
        releaseArr(_layouts);
        _dev.unload();
    }

    override @property Device device() {
        return _dev;
    }

    override @property DescriptorSetLayout[] descriptorLayouts()
    {
        return _layouts;
    }

    override @property const(PushConstantRange)[] pushConstantRanges()
    {
        return _push;
    }
}


final class GlFramebuffer : Framebuffer
{
    import gfx.bindings.opengl.gl : Gl, GLuint;
    import gfx.core.rc : atomicRcCode, Rc;
    import gfx.gl3 : GlShare;
    import gfx.gl3.resource : GlImageView;

    mixin (atomicRcCode);

    private Rc!Device _dev;
    private GlRenderPass rp;
    private GlImageView[] attachments;
    private uint width;
    private uint height;
    private uint layers;

    private Gl gl;
    private GLuint _name;

    this (GlShare share, GlRenderPass rp, GlImageView[] attachments, uint width, uint height, uint layers)
    {
        import gfx.core.rc : retainArr;
        import std.exception : enforce;

        enforce(
            rp.attachments.length == attachments.length,
            "Render pass do not fit with attachments in Framebuffer creation"
        );

        _dev = rp.device;
        this.rp = rp;
        this.attachments = attachments;
        this.width = width;
        this.height = height;
        this.layers = layers;

        rp.retain();
        retainArr(this.attachments);

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
        import gfx.core.rc : releaseArr;

        gl.DeleteFramebuffers(1, &_name);

        releaseArr(attachments);
        rp.release();
        _dev.unload();
    }

    override @property Device device() {
        return _dev;
    }
}

final class GlPipeline : Pipeline
{
    import gfx.bindings.opengl.gl : GLuint;
    import gfx.core.rc : atomicRcCode, Rc;
    import gfx.gl3 : GlShare;

    mixin(atomicRcCode);

    private Rc!Device _dev;
    private Gl gl;
    package GLuint prog;
    package PipelineInfo info;

    this(Device dev, GlShare share, PipelineInfo info) {
        _dev = dev;
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
            import gfx.gl3 : gfxGlLog;
            gfxGlLog.infof("Program link message: %s", log);
        }
    }

    override void dispose() {
        gl.DeleteProgram(prog);
        prog = 0;
        _dev.unload();
    }

    override @property Device device() {
        return _dev;
    }
}

final class GlDescriptorSetLayout : DescriptorSetLayout
{
    import gfx.core.rc : atomicRcCode, Rc;
    mixin(atomicRcCode);

    private Rc!Device _dev;
    const(PipelineLayoutBinding[]) bindings;

    this(Device dev, in PipelineLayoutBinding[] bindings) {
        _dev = dev;
        this.bindings = bindings;
    }
    override void dispose() {
        _dev.unload();
    }

    override @property Device device() {
        return _dev;
    }
}

final class GlDescriptorPool : DescriptorPool
{
    import gfx.core.rc : atomicRcCode, Rc;
    mixin(atomicRcCode);

    private Rc!Device _dev;
    private uint maxSets;
    private const(DescriptorPoolSize[]) sizes;

    this(Device dev, in uint maxSets, in DescriptorPoolSize[] bindings) {
        this._dev = dev;
        this.maxSets = maxSets;
        this.sizes = sizes;
    }
    override void dispose() {
        _dev.unload();
    }

    override @property Device device() {
        return _dev;
    }

    override DescriptorSet[] allocate(DescriptorSetLayout[] layouts) {
        import std.algorithm : map;
        import std.array : array;
        return layouts.map!(l => cast(DescriptorSet)new GlDescriptorSet(this, l)).array;
    }

    override void reset() {}
}

union GlDescriptor {
    SamplerDescriptor sampler;
    ImageSamplerDescriptor imageSampler;
    ImageDescriptor image;
    BufferDescriptor buffer;
    TexelBufferDescriptor texelBuffer;
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

    void write(uint dstBinding, uint dstArrayElem, DescriptorWrite write)
    {
        assert(write.type == bindings[dstBinding].layout.descriptorType);
        assign(
            bindings[dstBinding].descriptors[
                dstArrayElem .. dstArrayElem+write.count
            ],
            write
        );
    }

    private void assign(GlDescriptor[] descs, DescriptorWrite write)
    {
        final switch (write.type) {
        case DescriptorType.sampler:
            auto samplers = write.samplers;
            foreach (i, ref d; descs) {
                d.sampler = samplers[i];
            }
            break;
        case DescriptorType.combinedImageSampler:
            auto si = write.imageSamplers;
            foreach (i, ref d; descs) {
                d.imageSampler = si[i];
            }
            break;
        case DescriptorType.sampledImage:
        case DescriptorType.storageImage:
        case DescriptorType.inputAttachment:
            auto imgs = write.images;
            foreach (i, ref d; descs) {
                d.image = imgs[i];
            }
            break;
        case DescriptorType.uniformBuffer:
        case DescriptorType.storageBuffer:
        case DescriptorType.uniformBufferDynamic:
        case DescriptorType.storageBufferDynamic:
            auto buffers = write.buffers;
            foreach (i, ref d; descs) {
                d.buffer = buffers[i];
            }
            break;
        case DescriptorType.uniformTexelBuffer:
        case DescriptorType.storageTexelBuffer:
            auto tb = write.texelBuffers;
            foreach (i, ref d; descs) {
                d.texelBuffer = tb[i];
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
