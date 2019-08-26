module gfx.gl3.queue;

package:

import gfx.bindings.opengl.gl;
import gfx.core.rc : Disposable;
import gfx.gl3 : gfxGlLog;
import gfx.graal.cmd;
import gfx.graal.queue;

final class GlQueue : Queue, Disposable {
    import gfx.gl3 : GlInfo, GlShare;
    import gfx.graal.device : Device;
    import gfx.graal.sync : Fence, Semaphore;

    private GlShare share;
    private GlInfo info;
    private Device _device;
    private GLuint readFbo;
    private GLuint vao;
    private GlState state;
    private uint _index;

    this(GlShare share, Device device, uint index) {
        this.share = share;
        this.info = share.info;
        _device = device;
        this._index = index;
        auto gl = share.gl;
        gl.GenFramebuffers(1, &readFbo);
        gl.GenVertexArrays(1, &vao);
        gl.BindVertexArray(vao);
    }

    override void dispose() {
        auto gl = share.gl;
        gl.DeleteFramebuffers(1, &readFbo);
        gl.DeleteVertexArrays(1, &vao);
    }

    override @property Device device() {
        return _device;
    }

    override @property uint index() {
        return _index;
    }

    override void waitIdle() {
    }

    override void submit(Submission[] submissions, Fence fence) {
        auto gl = share.gl;
        foreach (ref s; submissions) {
            foreach (cmdBuf; s.cmdBufs) {
                auto glCmdBuf = cast(GlCommandBuffer) cmdBuf;
                foreach (cmd; glCmdBuf._cmds) {
                    cmd.execute(this, gl);
                }
                if (glCmdBuf._usage & CommandBufferUsage.oneTimeSubmit) {
                    glCmdBuf._cmds.length = 0;
                }
            }
        }
    }

    override void present(Semaphore[] waitSems, PresentRequest[] prs) {
        import gfx.gl3.resource : GlImage, GlImgType;
        import gfx.gl3.swapchain : GlSurface, GlSwapchain;

        auto gl = share.gl;

        foreach (i, pr; prs) {
            auto sc = cast(GlSwapchain) pr.swapChain;
            auto surf = sc.surface;
            auto img = cast(GlImage) sc.images[pr.imageIndex];
            auto size = sc.size;

            share.ctx.makeCurrent(surf.handle);

            if (i == prs.length - 1)
                share.ctx.swapInterval = 1;
            else
                share.ctx.swapInterval = 0;

            import gfx.gl3.error : glCheck;

            gl.BindFramebuffer(GL_READ_FRAMEBUFFER, readFbo);
            final switch (img.glType) {
            case GlImgType.renderBuf:
                gl.FramebufferRenderbuffer(GL_READ_FRAMEBUFFER,
                        GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, img.name);
                break;
            case GlImgType.tex:
                gl.FramebufferTexture2D(GL_READ_FRAMEBUFFER,
                        GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, img.name, 0);
                break;
            }

            gl.BindFramebuffer(GL_DRAW_FRAMEBUFFER, 0);
            gl.BlitFramebuffer(0, 0, size[0], size[1], 0, 0, size[0], size[1],
                    GL_COLOR_BUFFER_BIT, GL_NEAREST);
            glCheck(gl, "blit framebuffer");

            share.ctx.swapBuffers(surf.handle);
        }
    }
}

final class GlCommandPool : CommandPool {
    import gfx.core.rc : atomicRcCode;
    import gfx.gl3 : GlShare;
    import gfx.graal.cmd : PrimaryCommandBuffer;

    mixin(atomicRcCode);

    private GlQueue queue;
    private GlShare share;
    private GLuint fbo;

    this(GlQueue queue) {
        this.queue = queue;
        this.share = queue.share;
        auto gl = share.gl;
        gl.GenFramebuffers(1, &fbo);
    }

    override void dispose() {
        auto gl = share.gl;
        gl.DeleteFramebuffers(1, &fbo);
    }

    override void reset() {
    }

    override PrimaryCommandBuffer[] allocatePrimary(in size_t count) {
        auto bufs = new PrimaryCommandBuffer[count];
        foreach (i; 0 .. count) {
            bufs[i] = new GlCommandBuffer(this, fbo, CommandBufferLevel.primary);
        }
        return bufs;
    }

    override SecondaryCommandBuffer[] allocateSecondary(in size_t count) {
        auto bufs = new SecondaryCommandBuffer[count];
        foreach (i; 0 .. count) {
            bufs[i] = new GlCommandBuffer(this, fbo, CommandBufferLevel.secondary);
        }
        return bufs;
    }

    override void free(CommandBuffer[] buffers) {
    }
}

final class GlCommandBuffer : PrimaryCommandBuffer, SecondaryCommandBuffer {
    import gfx.gl3 : GlShare, GlInfo;
    import gfx.gl3.conv : toGl;
    import gfx.gl3.pipeline : GlPipeline, GlRenderPass;
    import gfx.graal.buffer : Buffer, IndexType;
    import gfx.graal.image : ImageBase, ImageLayout, ImageSubresourceRange;
    import gfx.graal.pipeline : ColorBlendInfo, DepthInfo, DescriptorSet, Pipeline, PipelineLayout,
        Rasterizer, ShaderStage, VertexInputBinding, VertexInputAttrib, ViewportConfig;
    import gfx.graal.renderpass : Framebuffer, RenderPass;
    import gfx.graal.types : Rect, Trans, Viewport;
    import std.typecons : Flag;

    private enum Dirty {
        none = 0x00,
        vertexBindings = 0x01,
        pipeline = 0x02,

        all = 0xff,
    }

    private CommandPool _pool;
    private CommandBufferLevel _level;
    private GLuint _fbo;
    private CommandBufferUsage _usage;

    private GlCommand[] _cmds;
    private Dirty _dirty;

    // render pass cache
    private GlRenderPass _renderPass;
    private GlColorAttachment[] _attachments; // TODO: static array
    private uint _subpass;

    // pipeline cache
    private GLenum _primitive;
    private VertexInputBinding[] _inputBindings;
    private VertexInputAttrib[] _inputAttribs;

    // index buffer cache
    private size_t _indexOffset;
    private GLenum _indexType;

    // vertex cache
    private VertexBinding[] _vertexBindings;

    this(CommandPool pool, GLuint fbo, CommandBufferLevel level) {
        _pool = pool;
        _fbo = fbo;
        _level = level;
    }

    override @property CommandPool pool() {
        return _pool;
    }

    override @property CommandBufferLevel level() const {
        return _level;
    }

    override void reset() {
        _cmds.length = 0;
        _dirty = Dirty.none;
        _vertexBindings.length = 0;
    }

    override void begin(in CommandBufferUsage usage) {
        _usage = usage;
    }

    override void end() {
    }

    override void pipelineBarrier(Trans!PipelineStage stageTrans,
            BufferMemoryBarrier[] bufMbs, ImageMemoryBarrier[] imgMbs) {
        gfxGlLog.warning("unimplemented GL command");
    }

    override void clearColorImage(ImageBase image, ImageLayout layout,
            in ClearColorValues clearValues, ImageSubresourceRange[] ranges) {
        import gfx.gl3.resource : GlImage;

        _cmds ~= new SetupFramebufferCmd(_fbo, cast(GlImage) image);
        _cmds ~= new ClearColorCmd(clearValues);
    }

    override void clearDepthStencilImage(ImageBase image, ImageLayout layout,
            in ClearDepthStencilValues clearValues, ImageSubresourceRange[] ranges) {
        import gfx.gl3.resource : GlImage;

        _cmds ~= new SetupFramebufferCmd(_fbo, cast(GlImage) image);
        _cmds ~= new ClearDepthStencilCmd(clearValues, true, true);
    }

    override void fillBuffer(Buffer dst, in size_t offset, in size_t size, uint value) {
        gfxGlLog.warning("unimplemented GL command");
    }

    override void updateBuffer(Buffer dst, in size_t offset, in uint[] data) {
        gfxGlLog.warning("unimplemented GL command");
    }

    override void copyBuffer(Trans!Buffer buffers, in CopyRegion[] regions) {
        import gfx.gl3.resource : GlBuffer;

        foreach (r; regions) {
            _cmds ~= new CopyBufToBufCmd(cast(GlBuffer) buffers.from, cast(GlBuffer) buffers.to, r);
        }
    }

    override void copyBufferToImage(Buffer srcBuffer, ImageBase dstImage,
            in ImageLayout dstLayout, in BufferImageCopy[] regions) {
        import gfx.gl3.resource : GlBuffer, GlImage;

        foreach (r; regions) {
            _cmds ~= new CopyBufToImgCmd(cast(GlBuffer) srcBuffer, cast(GlImage) dstImage, r);
        }
    }

    override void setViewport(in uint firstViewport, in Viewport[] viewports) {
        _cmds ~= new SetViewportsCmd(firstViewport, viewports);
    }

    override void setScissor(in uint firstScissor, in Rect[] scissors) {
        _cmds ~= new SetScissorsCmd(firstScissor, scissors);
    }

    override void setDepthBounds(in float minDepth, in float maxDepth) {
        gfxGlLog.warning("unimplemented GL command");
    }

    void setLineWidth(in float lineWidth) {
        _cmds ~= new SetLineWidthCmd(lineWidth);
    }

    override void setDepthBias(in float constFactor, in float clamp, in float slopeFactor) {
        _cmds ~= new SetDepthBiasCmd(constFactor, clamp, slopeFactor);
    }

    override void setStencilCompareMask(in StencilFace faceMask, in uint compareMask) {
        gfxGlLog.warning("unimplemented GL command");
    }

    override void setStencilWriteMask(in StencilFace faceMask, in uint writeMask) {
        gfxGlLog.warning("unimplemented GL command");
    }

    override void setStencilReference(in StencilFace faceMask, in uint reference) {
        gfxGlLog.warning("unimplemented GL command");
    }

    override void setBlendConstants(in float[4] blendConstants) {
        _cmds ~= new SetBlendConstantsCmd(blendConstants);
    }

    override void beginRenderPass(RenderPass rp, Framebuffer fb, in Rect area,
            in ClearValues[] clearValues) {
        import gfx.gl3.pipeline : GlFramebuffer;
        import gfx.graal.pipeline : ColorBlendAttachment;
        import std.algorithm : map;
        import std.array : array;

        _renderPass = cast(GlRenderPass) rp;
        _attachments = _renderPass.attachments.map!(ad => GlColorAttachment(false,
                ad, ColorBlendAttachment.init)).array;
        setActiveSubpass(0);

        const glFb = cast(GlFramebuffer) fb;
        _cmds ~= new BindFramebufferCmd(glFb.name);
        foreach (cv; clearValues) {
            if (cv.type == ClearValues.Type.color) {
                _cmds ~= new ClearColorCmd(cv.values.color);
            }
            if (cv.type == ClearValues.Type.depthStencil) {
                _cmds ~= new ClearDepthStencilCmd(cv.values.depthStencil, true, true);
            }
        }
    }

    override void beginWithinRenderPass(in CommandBufferUsage usage,
            RenderPass rp, Framebuffer fb, uint subpass) {
        import gfx.core.util : unsafeCast;
        import gfx.gl3.pipeline : GlFramebuffer;
        import gfx.graal.pipeline : ColorBlendAttachment;
        import std.algorithm : map;
        import std.array : array;

        assert(_level == CommandBufferLevel.secondary);
        _usage = usage;
        _renderPass = cast(GlRenderPass) rp;
        _attachments = _renderPass.attachments.map!(ad => GlColorAttachment(false,
                ad, ColorBlendAttachment.init)).array;
        setActiveSubpass(0);

        const glFb = cast(GlFramebuffer) fb;
        _cmds ~= new BindFramebufferCmd(glFb.name);
        _subpass = subpass;
    }

    override void nextSubpass() {
        assert(_level == CommandBufferLevel.primary);
        setActiveSubpass(_subpass + 1);
    }

    override void endRenderPass() {
        assert(_level == CommandBufferLevel.primary);
    }

    override void bindPipeline(Pipeline pipeline) {
        auto glPipeline = cast(GlPipeline) pipeline;

        _cmds ~= new BindProgramCmd(glPipeline.prog);
        _cmds ~= new SetViewportConfigsCmd(glPipeline.info.viewports);
        _cmds ~= new SetRasterizerCmd(glPipeline.info.rasterizer);
        _cmds ~= new SetDepthInfoCmd(glPipeline.info.depthInfo);
        _cmds ~= new SetStencilInfoCmd(glPipeline.info.stencilInfo);

        uint curAttach = 0;
        foreach (ref a; _attachments) {
            if (a.enabled) {
                a.attachment = glPipeline.info.blendInfo.attachments[curAttach++];
            }
        }
        assert(curAttach == glPipeline.info.blendInfo.attachments.length);
        _cmds ~= new BindBlendSlotsCmd(_attachments.dup);

        _primitive = toGl(glPipeline.info.assembly.primitive);
        _inputBindings = glPipeline.info.inputBindings;
        _inputAttribs = glPipeline.info.inputAttribs;

        dirty(Dirty.vertexBindings | Dirty.pipeline);
    }

    override void bindVertexBuffers(uint firstBinding, VertexBinding[] bindings) {
        const minLen = firstBinding + bindings.length;
        if (_vertexBindings.length < minLen)
            _vertexBindings.length = minLen;
        _vertexBindings[firstBinding .. firstBinding + bindings.length] = bindings;
        dirty(Dirty.vertexBindings);
    }

    override void bindIndexBuffer(Buffer indexBuf, size_t offset, IndexType type) {
        import gfx.gl3.resource : GlBuffer;

        auto glBuf = cast(GlBuffer) indexBuf;
        _cmds ~= new BindIndexBufCmd(glBuf.name);
        _indexOffset = offset;
        _indexType = toGl(type);
    }

    override void bindDescriptorSets(PipelineBindPoint bindPoint, PipelineLayout layout,
            uint firstSet, DescriptorSet[] sets, in size_t[] dynamicOffsets) {
        import gfx.gl3.pipeline : GlDescriptorSet;
        import gfx.graal.pipeline : DescriptorType;

        size_t dynInd = 0;

        foreach (si, ds; sets) {
            auto glSet = cast(GlDescriptorSet) ds;

            foreach (bi, b; glSet.bindings) {

                foreach (di, d; b.descriptors) {

                    switch (b.layout.descriptorType) {
                    case DescriptorType.uniformBuffer:
                        _cmds ~= new BindUniformBufferCmd(b.layout.binding, d.buffer, 0);
                        break;
                    case DescriptorType.uniformBufferDynamic:
                        _cmds ~= new BindUniformBufferCmd(b.layout.binding,
                                d.buffer, dynamicOffsets[dynInd++]);
                        break;
                    case DescriptorType.combinedImageSampler:
                        _cmds ~= new BindSamplerImageCmd(b.layout.binding, d.imageSampler);
                        break;
                    default:
                        gfxGlLog.warning("unhandled descriptor set");
                        break;
                    }
                }
            }
        }
    }

    override void pushConstants(PipelineLayout layout, ShaderStage stages,
            size_t offset, size_t size, const(void)* data) {
        gfxGlLog.warning("unimplemented GL command");
    }

    override void draw(uint vertexCount, uint instanceCount, uint firstVertex, uint firstInstance) {
        ensureBindings();
        _cmds ~= new DrawCmd(_primitive, cast(GLint) firstVertex, cast(GLsizei) vertexCount,
                cast(GLsizei) instanceCount, cast(GLuint) firstInstance);
    }

    override void drawIndexed(uint indexCount, uint instanceCount,
            uint firstVertex, int vertexOffset, uint firstInstance) {
        ensureBindings();

        const factor = _indexType == GL_UNSIGNED_SHORT ? 2 : 4;
        const offset = factor * firstVertex + _indexOffset;

        _cmds ~= new DrawIndexedCmd(_primitive, cast(GLsizei) indexCount, _indexType, offset,
                cast(GLint) vertexOffset, cast(GLsizei) instanceCount, cast(GLuint) firstInstance);
    }

    override void execute(SecondaryCommandBuffer[] buffers) {
        assert(_level == CommandBufferLevel.primary);
        assert(false, "not implemented");
    }

    private void dirty(Dirty flag) {
        _dirty |= flag;
    }

    private void clean(Dirty flag) {
        _dirty &= ~flag;
    }

    private bool allDirty(Dirty flags) {
        return (_dirty & flags) == flags;
    }

    private bool someDirty(Dirty flags) {
        return (_dirty & flags) != Dirty.none;
    }

    private void ensureBindings() {
        if (someDirty(Dirty.vertexBindings)) {
            bindAttribs();
            clean(Dirty.vertexBindings);
        }
    }

    private void bindAttribs() {
        assert(_vertexBindings.length == _inputBindings.length);
        assert(someDirty(Dirty.vertexBindings));

        import gfx.gl3.conv : glVertexFormat, vertexFormatSupported;
        import gfx.gl3.resource : GlBuffer;
        import gfx.graal.format : formatDesc;
        import std.algorithm : filter;

        foreach (bi, vb; _vertexBindings) {
            const bindingInfo = _inputBindings[bi];

            GlVertexAttrib[] attribs;

            foreach (ai; _inputAttribs.filter!(ia => ia.binding == bi)) {
                const f = ai.format;
                assert(vertexFormatSupported(f));

                attribs ~= GlVertexAttrib(ai.location, glVertexFormat(f), vb.offset + ai.offset);
            }

            auto buf = cast(GlBuffer) vb.buffer;
            _cmds ~= new BindVertexBufCmd(buf.name, cast(GLsizei) bindingInfo.stride, attribs);
        }
    }

    void setActiveSubpass(uint subpass) {
        assert(_renderPass);
        assert(_attachments.length == _renderPass.attachments.length);
        const sp = _renderPass.subpasses[subpass];
        foreach (ref a; _attachments) {
            a.enabled = false;
        }
        foreach (ar; sp.colors) {
            _attachments[ar.attachment].enabled = true;
        }
        _subpass = subpass;
    }

}

private:

struct GlState {
    import gfx.graal.pipeline : DepthInfo, Rasterizer, StencilInfo, ViewportConfig;
    import gfx.graal.types : Rect, Viewport;

    GLuint prog;
    const(ViewportConfig)[] vcs;
    const(Viewport)[] viewports;
    const(Rect)[] scissors;
    Rasterizer rasterizer;
    DepthInfo depthInfo;
    StencilInfo stencilInfo;
}

struct GlColorAttachment {
    import gfx.graal.pipeline : ColorBlendAttachment;
    import gfx.graal.renderpass : AttachmentDescription;

    bool enabled;
    AttachmentDescription desc;
    ColorBlendAttachment attachment;
}

abstract class GlCommand {
    abstract void execute(GlQueue queue, Gl gl);
}

string allFieldsCtor(T)() {
    import std.array : join;
    import std.traits : FieldNameTuple, Fields;

    alias names = FieldNameTuple!T;
    alias types = Fields!T;

    string[] fields;
    static foreach (i, n; names) {
        fields ~= types[i].stringof ~ " " ~ n;
    }
    string code = "this(" ~ fields.join(", ") ~ ") {\n";
    static foreach (n; names) {
        code ~= "    this." ~ n ~ " = " ~ n ~ ";\n";
    }
    return code ~ "}";
}

final class CopyBufToBufCmd : GlCommand {
    import gfx.gl3.resource : GlBuffer;

    GlBuffer src;
    GlBuffer dst;
    CopyRegion region;

    mixin(allFieldsCtor!(typeof(this)));

    override void execute(GlQueue queue, Gl gl) {
        gl.BindBuffer(GL_COPY_READ_BUFFER, src.name);
        gl.BindBuffer(GL_COPY_WRITE_BUFFER, dst.name);
        gl.CopyBufferSubData(GL_COPY_READ_BUFFER, GL_COPY_WRITE_BUFFER,
                cast(GLintptr) region.offset.from,
                cast(GLintptr) region.offset.to, cast(GLsizeiptr) region.size);
        gl.BindBuffer(GL_COPY_READ_BUFFER, 0);
        gl.BindBuffer(GL_COPY_WRITE_BUFFER, 0);

        import gfx.gl3.error : glCheck;

        glCheck(gl, "copy buffer to buffer");
    }
}

final class CopyBufToImgCmd : GlCommand {
    import gfx.gl3.resource : GlBuffer, GlImage;

    GlBuffer buf;
    GlImage img;
    BufferImageCopy region;

    mixin(allFieldsCtor!(typeof(this)));

    override void execute(GlQueue queue, Gl gl) {
        gl.ActiveTexture(GL_TEXTURE0);
        gl.BindBuffer(GL_PIXEL_UNPACK_BUFFER, buf.name);
        gl.BindTexture(img.texTarget, img.name);
        img.texSubImage(region);
        gl.BindBuffer(GL_PIXEL_UNPACK_BUFFER, 0);

        import gfx.gl3.error : glCheck;

        glCheck(gl, "copy buffer to image");
    }
}

final class BindFramebufferCmd : GlCommand {
    GLuint fbo;
    this(GLuint fbo) {
        this.fbo = fbo;
    }

    override void execute(GlQueue queue, Gl gl) {
        gl.BindFramebuffer(GL_DRAW_FRAMEBUFFER, fbo);
    }
}

final class SetupFramebufferCmd : GlCommand {
    import gfx.gl3.resource : GlImage, GlImgType;

    GLuint fbo;
    GlImage img;

    this(GLuint fbo, GlImage img) {
        this.fbo = fbo;
        this.img = img;
    }

    override void execute(GlQueue queue, Gl gl) {
        gl.BindFramebuffer(GL_DRAW_FRAMEBUFFER, fbo);
        final switch (img.glType) {
        case GlImgType.renderBuf:
            gl.FramebufferRenderbuffer(GL_DRAW_FRAMEBUFFER,
                    GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, img.name);
            break;
        case GlImgType.tex:
            gl.FramebufferTexture2D(GL_DRAW_FRAMEBUFFER,
                    GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, img.name, 0);
            break;
        }
        const GLenum drawBuf = GL_COLOR_ATTACHMENT0;
        gl.DrawBuffers(1, &drawBuf);
    }
}

final class SetViewportConfigsCmd : GlCommand {
    import gfx.graal.pipeline : ViewportConfig;

    ViewportConfig[] viewports;
    this(ViewportConfig[] viewports) {
        this.viewports = viewports;
    }

    override void execute(GlQueue queue, Gl gl) {

        if (queue.state.vcs == viewports)
            return;

        if (viewports.length > 1 && !queue.info.viewportArray) {
            gfxGlLog.error("ARB_viewport_array not supported");
            viewports = viewports[0 .. 1];
        }

        if (viewports.length > 1) {
            foreach (i, vc; viewports) {
                const vp = vc.viewport;
                gl.ViewportIndexedf(cast(GLuint) i, vp.x, vp.y, vp.width, vp.height);
                gl.DepthRangeIndexed(cast(GLuint) i, vp.minDepth, vp.maxDepth);

                const sc = vc.scissors;
                gl.ScissorIndexed(cast(GLuint) i, cast(GLint) sc.x,
                        cast(GLint) sc.y, cast(GLsizei) sc.width, cast(GLsizei) sc.height);
            }
        } else if (viewports.length == 1) {
            const vp = viewports[0].viewport;
            gl.Viewport(cast(GLint) vp.x, cast(GLint) vp.y,
                    cast(GLsizei) vp.width, cast(GLsizei) vp.height);
            gl.DepthRangef(vp.minDepth, vp.maxDepth);

            const sc = viewports[0].scissors;
            gl.Scissor(cast(GLint) sc.x, cast(GLint) sc.y, cast(GLsizei) sc.width,
                    cast(GLsizei) sc.height);
        }

        queue.state.vcs = viewports;
    }
}

final class SetViewportsCmd : GlCommand {
    import gfx.graal.types : Viewport;

    uint firstViewport;
    const(Viewport)[] viewports;

    this(in uint firstViewport, const(Viewport)[] viewports) {
        this.firstViewport = firstViewport;
        this.viewports = viewports;
    }

    override void execute(GlQueue queue, Gl gl) {

        if (queue.state.viewports == viewports)
            return;

        bool useArray = viewports.length > 1 || firstViewport > 0;

        if (useArray && !queue.info.viewportArray) {
            gfxGlLog.error("ARB_viewport_array not supported");
            viewports = viewports[0 .. 1];
            firstViewport = 0;
            useArray = false;
        }

        if (useArray) {
            foreach (i, vp; viewports) {
                gl.ViewportIndexedf(cast(GLuint)(i + firstViewport), vp.x, vp.y,
                        vp.width, vp.height);
                gl.DepthRangeIndexed(cast(GLuint)(i + firstViewport), vp.minDepth, vp.maxDepth);
            }
        } else if (viewports.length == 1) {
            const vp = viewports[0];
            gl.Viewport(cast(GLint) vp.x, cast(GLint) vp.y,
                    cast(GLsizei) vp.width, cast(GLsizei) vp.height);
            gl.DepthRangef(vp.minDepth, vp.maxDepth);
        }

        queue.state.viewports = viewports;
    }
}

final class SetScissorsCmd : GlCommand {
    import gfx.graal.types : Rect;

    uint firstScissor;
    const(Rect)[] scissors;

    this(in uint firstScissor, const(Rect)[] scissors) {
        this.firstScissor = firstScissor;
        this.scissors = scissors;
    }

    override void execute(GlQueue queue, Gl gl) {
        import std.algorithm : equal, map;

        if (queue.state.scissors == scissors)
            return;

        bool useArray = scissors.length > 1 || firstScissor > 0;
        if (useArray && !queue.info.viewportArray) {
            gfxGlLog.error("ARB_viewport_array not supported");
            scissors = scissors[0 .. 1];
            firstScissor = 0;
            useArray = false;
        }

        if (useArray) {
            foreach (i, sc; scissors) {
                gl.ScissorIndexed(cast(GLuint)(i + firstScissor),
                        cast(GLint) sc.x, cast(GLint) sc.y,
                        cast(GLsizei) sc.width, cast(GLsizei) sc.height);
            }
        } else if (scissors.length == 1) {
            const sc = scissors[0];
            gl.Scissor(cast(GLint) sc.x, cast(GLint) sc.y, cast(GLsizei) sc.width,
                    cast(GLsizei) sc.height);
        }

        queue.state.scissors = scissors;
    }
}

final class SetLineWidthCmd : GlCommand {
    float lineWidth;
    this(in float lineWidth) {
        this.lineWidth = lineWidth;
    }

    override void execute(GlQueue queue, Gl gl) {
        gl.LineWidth(this.lineWidth);
    }
}

final class SetDepthBiasCmd : GlCommand {
    float constFactor;
    float clamp;
    float slopeFactor;

    mixin(allFieldsCtor!(typeof(this)));

    override void execute(GlQueue queue, Gl gl) {
        if (queue.info.polygonOffsetClamp) {
            gl.PolygonOffsetClamp(slopeFactor, constFactor, clamp);
        } else {
            gl.PolygonOffset(slopeFactor, constFactor);
        }
    }
}

final class SetBlendConstantsCmd : GlCommand {
    float[4] constants;

    mixin(allFieldsCtor!(typeof(this)));

    override void execute(GlQueue queue, Gl gl) {
        gl.BlendColor(constants[0], constants[1], constants[2], constants[3]);
    }
}

final class ClearColorCmd : GlCommand {

    ClearColorValues values;

    this(ClearColorValues values) {
        this.values = values;
    }

    override void execute(GlQueue queue, Gl gl) {
        gl.ColorMaski(0, GL_TRUE, GL_TRUE, GL_TRUE, GL_TRUE);
        final switch (values.type) {
        case ClearColorValues.Type.f32:
            gl.ClearBufferfv(GL_COLOR, 0, &values.values.f32[0]);
            break;
        case ClearColorValues.Type.i32:
            gl.ClearBufferiv(GL_COLOR, 0, &values.values.i32[0]);
            break;
        case ClearColorValues.Type.u32:
            gl.ClearBufferuiv(GL_COLOR, 0, &values.values.u32[0]);
            break;
        }
    }
}

final class ClearDepthStencilCmd : GlCommand {

    ClearDepthStencilValues values;
    bool depth;
    bool stencil;

    this(ClearDepthStencilValues values, bool depth, bool stencil) {
        this.values = values;
        this.depth = depth;
        this.stencil = stencil;
    }

    override void execute(GlQueue queue, Gl gl) {
        if (depth) {
            gl.DepthMask(GL_TRUE);
            gl.ClearBufferfv(GL_DEPTH, 0, &values.depth);
        }
        if (stencil) {
            const val = cast(GLint) values.stencil;
            gl.StencilMask(GLuint.max);
            gl.ClearBufferiv(GL_STENCIL, 0, &val);
        }
    }
}

final class BindProgramCmd : GlCommand {
    GLuint prog;
    this(GLuint prog) {
        this.prog = prog;
    }

    override void execute(GlQueue queue, Gl gl) {
        if (queue.state.prog == prog)
            return;
        gl.UseProgram(prog);
        queue.state.prog = prog;
    }
}

final class SetRasterizerCmd : GlCommand {
    import gfx.graal.pipeline : Rasterizer;

    Rasterizer rasterizer;
    this(Rasterizer rasterizer) {
        this.rasterizer = rasterizer;
    }

    override void execute(GlQueue queue, Gl gl) {
        import gfx.gl3.conv : toGl;
        import gfx.graal.pipeline : Cull, PolygonMode;

        if (queue.state.rasterizer == rasterizer)
            return;

        void polygonBias(GLenum polygonMode, GLenum depthBias) {
            gl.PolygonMode(GL_FRONT_AND_BACK, polygonMode);
            if (rasterizer.depthBias.isSome) {
                const db = rasterizer.depthBias.get;
                gl.Enable(depthBias);
                if (queue.info.polygonOffsetClamp) {
                    gl.PolygonOffsetClamp(db.slopeFactor, db.constantFactor, db.clamp);
                } else {
                    gl.PolygonOffset(db.slopeFactor, db.constantFactor);
                }
            } else {
                gl.Disable(depthBias);
            }
        }

        final switch (rasterizer.mode) {
        case PolygonMode.point:
            polygonBias(GL_POINT, GL_POLYGON_OFFSET_POINT);
            break;
        case PolygonMode.line:
            polygonBias(GL_LINE, GL_POLYGON_OFFSET_LINE);
            gl.LineWidth(rasterizer.lineWidth);
            break;
        case PolygonMode.fill:
            polygonBias(GL_FILL, GL_POLYGON_OFFSET_FILL);
            break;
        }

        if (rasterizer.cull == Cull.none) {
            gl.Disable(GL_CULL_FACE);
        } else {
            gl.Enable(GL_CULL_FACE);
            switch (rasterizer.cull) {
            case Cull.back:
                gl.CullFace(GL_BACK);
                break;
            case Cull.front:
                gl.CullFace(GL_FRONT);
                break;
            case Cull.frontAndBack:
                gl.CullFace(GL_FRONT_AND_BACK);
                break;
            default:
                break;
            }
            gl.FrontFace(toGl(rasterizer.front));
        }

        if (rasterizer.depthClamp) {
            gl.Enable(GL_DEPTH_CLAMP);
        } else {
            gl.Disable(GL_DEPTH_CLAMP);
        }

        queue.state.rasterizer = rasterizer;
    }
}

final class SetDepthInfoCmd : GlCommand {
    import gfx.graal.pipeline : DepthInfo;

    DepthInfo info;
    this(DepthInfo info) {
        this.info = info;
    }

    override void execute(GlQueue queue, Gl gl) {
        import gfx.gl3.conv : toGl;

        if (queue.state.depthInfo == info)
            return;

        if (info.enabled) {
            gl.Enable(GL_DEPTH_TEST);
            gl.DepthFunc(toGl(info.compareOp));
            gl.DepthMask(cast(GLboolean) info.write);
            if (info.boundsTest) {
                gfxGlLog.warning("no support for depth bounds test");
            }
        } else {
            gl.Disable(GL_DEPTH_TEST);
        }

        queue.state.depthInfo = info;
    }
}

final class SetStencilInfoCmd : GlCommand {
    import gfx.graal.pipeline : StencilInfo;

    StencilInfo info;
    this(StencilInfo info) {
        this.info = info;
    }

    override void execute(GlQueue queue, Gl gl) {
        import gfx.gl3.conv : toGl;
        import gfx.graal.pipeline : StencilOpState;

        if (queue.state.stencilInfo == info)
            return;

        if (info.enabled) {
            gl.Enable(GL_STENCIL_TEST);
            void bindFace(GLenum face, StencilOpState state) {
                gl.StencilOpSeparate(face, toGl(state.failOp),
                        toGl(state.depthFailOp), toGl(state.passOp));
                gl.StencilFuncSeparate(face, toGl(state.compareOp),
                        state.refMask, state.compareMask);
                gl.StencilMaskSeparate(face, state.writeMask);
            }

            bindFace(GL_FRONT, info.front);
            bindFace(GL_BACK, info.back);
        } else {
            gl.Disable(GL_STENCIL_TEST);
        }
    }
}

struct GlVertexAttrib {
    import gfx.gl3.conv : GlVertexFormat;

    GLuint index;
    GlVertexFormat format;
    size_t offset;
}

final class BindVertexBufCmd : GlCommand {
    GLuint buffer;
    GLsizei stride;
    GlVertexAttrib[] attribs;

    this(GLuint buffer, GLsizei stride, GlVertexAttrib[] attribs) {
        this.buffer = buffer;
        this.stride = stride;
        this.attribs = attribs;
    }

    override void execute(GlQueue queue, Gl gl) {
        import gfx.gl3.conv : VAOAttribFun;

        gl.BindBuffer(GL_ARRAY_BUFFER, buffer);
        foreach (at; attribs) {
            final switch (at.format.fun) {
            case VAOAttribFun.f:
                gl.VertexAttribPointer(at.index, at.format.size,
                        at.format.type, at.format.normalized, stride,
                        cast(const(void*)) at.offset);
                break;
            case VAOAttribFun.i:
                gl.VertexAttribIPointer(at.index,
                        at.format.size, at.format.type, stride, cast(const(void*)) at.offset);
                break;
            case VAOAttribFun.d:
                gl.VertexAttribLPointer(at.index,
                        at.format.size, at.format.type, stride, cast(const(void*)) at.offset);
                break;
            }
            gl.EnableVertexAttribArray(at.index);
        }
        gl.BindBuffer(GL_ARRAY_BUFFER, 0);
    }
}

final class BindIndexBufCmd : GlCommand {
    GLuint buf;

    this(GLuint buf) {
        this.buf = buf;
    }

    override void execute(GlQueue queue, Gl gl) {
        gl.BindBuffer(GL_ELEMENT_ARRAY_BUFFER, buf);
    }
}

final class BindUniformBufferCmd : GlCommand {
    import gfx.gl3.resource : GlBuffer;
    import gfx.graal.pipeline : BufferDescriptor;

    GLuint binding;
    BufferDescriptor bufferDesc;
    size_t dynamicOffset;

    this(GLuint binding, BufferDescriptor bd, in size_t dynOffset) {
        this.binding = binding;
        this.bufferDesc = bd;
        this.dynamicOffset = dynOffset;
    }

    override void execute(GlQueue queue, Gl gl) {
        auto glBuf = cast(GlBuffer) bufferDesc.buffer;

        gl.BindBufferRange(GL_UNIFORM_BUFFER, binding, glBuf.name,
                cast(GLintptr)(bufferDesc.offset + dynamicOffset),
                cast(GLintptr)bufferDesc.size);
    }
}

final class BindSamplerImageCmd : GlCommand {
    import gfx.graal.pipeline : ImageSamplerDescriptor;

    GLuint binding;
    ImageSamplerDescriptor sid;

    mixin(allFieldsCtor!(typeof(this)));

    override void execute(GlQueue queue, Gl gl) {
        import gfx.gl3.conv : toGl;
        import gfx.gl3.error : glCheck;
        import gfx.gl3.resource : GlImageView, GlSampler;

        auto view = cast(GlImageView) sid.view;
        auto sampler = cast(GlSampler) sid.sampler;

        gl.ActiveTexture(GL_TEXTURE0 + binding);
        gl.BindTexture(view.target, view.name);
        glCheck(gl, "bind texture");

        sampler.bind(view.target, binding);
        glCheck(gl, "bind sampler");

        const swizzle = toGl(view.swizzle);
        gl.TexParameteriv(view.target, GL_TEXTURE_SWIZZLE_RGBA, &swizzle[0]);
    }
}

final class BindBlendSlotsCmd : GlCommand {
    import gfx.graal.pipeline : ColorMask;

    GlColorAttachment[] attachments;

    this(GlColorAttachment[] attachments) {
        this.attachments = attachments;
    }

    override void execute(GlQueue queue, Gl gl) {
        import gfx.gl3.conv : toGl;

        foreach (const ind, a; attachments) {
            const slot = cast(GLuint) ind;
            if (a.enabled) {
                // TODO logicOp
                if (a.attachment.enabled) {
                    // TODO
                    gl.Enablei(GL_BLEND, slot);
                    gl.BlendEquationSeparatei(slot, toGl(a.attachment.colorBlend.op),
                            toGl(a.attachment.alphaBlend.op),);
                    gl.BlendFuncSeparatei(slot, toGl(a.attachment.colorBlend.factor.from),
                            toGl(a.attachment.colorBlend.factor.to), toGl(a.attachment.alphaBlend.factor.from),
                            toGl(a.attachment.alphaBlend.factor.to),);
                } else {
                    gl.Disablei(GL_BLEND, slot);
                }
                import std.typecons : BitFlags, Yes;

                BitFlags!(ColorMask, Yes.unsafe) cm = a.attachment.colorMask;
                gl.ColorMaski(slot, (cm & ColorMask.r) ? GL_TRUE : GL_FALSE,
                        (cm & ColorMask.g) ? GL_TRUE : GL_FALSE, (cm & ColorMask.b)
                        ? GL_TRUE : GL_FALSE, (cm & ColorMask.a) ? GL_TRUE : GL_FALSE);
            } else {
                gl.ColorMaski(slot, GL_FALSE, GL_FALSE, GL_FALSE, GL_FALSE);
            }
        }
    }
}

final class DrawCmd : GlCommand {
    GLenum primitive;
    GLint first;
    GLsizei count;
    GLsizei instanceCount;
    GLuint baseInstance;

    this(GLenum primitive, GLint first, GLsizei count, GLsizei instanceCount, GLuint baseInstance) {
        this.primitive = primitive;
        this.first = first;
        this.count = count;
        this.instanceCount = instanceCount;
        this.baseInstance = baseInstance;
    }

    override void execute(GlQueue queue, Gl gl) {
        if (baseInstance != 0 && !queue.info.baseInstance) {
            gfxGlLog.error("No support for ARB_base_instance");
            return;
        }
        if (instanceCount <= 1) {
            gl.DrawArrays(primitive, first, count);
        } else if (instanceCount > 1 && baseInstance == 0) {
            gl.DrawArraysInstanced(primitive, first, count, instanceCount);
        } else if (instanceCount > 1 && baseInstance != 0) {
            gl.DrawArraysInstancedBaseInstance(primitive, first, count,
                    instanceCount, baseInstance);
        }
        import gfx.gl3.error : glCheck;

        glCheck(gl, "draw");
    }
}

final class DrawIndexedCmd : GlCommand {
    GLenum primitive;
    GLsizei count;
    GLenum type;
    size_t indexBufOffset;
    GLint baseVertex;
    GLsizei instanceCount;
    GLuint baseInstance;

    this(GLenum primitive, GLsizei count, GLenum type, size_t indexBufOffset,
            GLint baseVertex, GLsizei instanceCount, GLuint baseInstance) {
        this.primitive = primitive;
        this.count = count;
        this.type = type;
        this.indexBufOffset = indexBufOffset;
        this.baseVertex = baseVertex;
        this.instanceCount = instanceCount;
        this.baseInstance = baseInstance;
    }

    override void execute(GlQueue queue, Gl gl) {
        const offset = cast(const(void*)) indexBufOffset;

        if (baseVertex != 0 && !queue.info.drawElementsBaseVertex) {
            gfxGlLog.error("No support for ARB_draw_elements_base_vertex");
            return;
        }
        if (baseInstance != 0 && !queue.info.baseInstance) {
            gfxGlLog.error("No support for ARB_base_instance");
            return;
        }

        if (instanceCount <= 1 && baseVertex == 0) {
            gl.DrawElements(primitive, count, type, offset);
        } else if (instanceCount <= 1 && baseVertex != 0) {
            gl.DrawElementsBaseVertex(primitive, count, type, offset, baseVertex);
        } else if (instanceCount > 1 && baseInstance == 0 && baseVertex == 0) {
            gl.DrawElementsInstanced(primitive, count, type, offset, instanceCount);
        } else if (instanceCount > 1 && baseInstance == 0 && baseVertex != 0) {
            gl.DrawElementsInstancedBaseVertex(primitive, count, type, offset,
                    instanceCount, baseVertex);
        } else if (instanceCount > 1 && baseInstance != 0 && baseVertex == 0) {
            gl.DrawElementsInstancedBaseInstance(primitive, count, type,
                    offset, instanceCount, baseInstance);
        } else {
            gl.DrawElementsInstancedBaseVertexBaseInstance(primitive, count,
                    type, offset, instanceCount, baseVertex, baseInstance);
        }
        import gfx.gl3.error : glCheck;

        glCheck(gl, "draw indexed");
    }
}
