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

    this (GlShare share, in ShaderLanguage sl, in string code) {
        gl = share.gl;
        _code = code;

        import std.exception : enforce;
        enforce(sl == ShaderLanguage.glsl);
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

    private AttachmentDescription[] _attachments;
    private SubpassDescription[]    _subpasses;
    private SubpassDependency[]     _deps;

    this(   in AttachmentDescription[] attachments,
            in SubpassDescription[] subpasses,
            in SubpassDependency[] dependencies) {
        _attachments = attachments.dup;
        _subpasses = subpasses.clone();
        _deps = dependencies.dup;
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
            rp._attachments.length == attachments.length,
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

        import gfx.bindings.opengl.gl : GL_DRAW_FRAMEBUFFER;

        gl.BindFramebuffer(GL_DRAW_FRAMEBUFFER, _name);

        foreach(i; 0 .. attachments.length) {
            const desc = rp._attachments[i];
            auto attachment = attachments[i];
            uint colorNum = 0;
            attachment.attachToFbo(GL_DRAW_FRAMEBUFFER, colorNum);
        }

        gl.BindFramebuffer(GL_DRAW_FRAMEBUFFER, 0);
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
    private GLuint prog;
    private PipelineInfo info;

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
    if (len > 0) {
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
    if (len > 0) {
        auto msg = new char[len];
        gl.GetProgramInfoLog(name, len, &len, msg.ptr);
        return msg[0 .. len-1].idup;
    }
    else {
        return null;
    }
}
