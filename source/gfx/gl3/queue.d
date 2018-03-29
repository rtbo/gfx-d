module gfx.gl3.queue;

package:

import gfx.bindings.opengl.gl;
import gfx.graal.cmd;
import gfx.graal.queue;

final class GlCommandPool : CommandPool
{
    import gfx.core.rc : atomicRcCode;
    import gfx.gl3 : GlShare;
    import gfx.graal.cmd : CommandBuffer;

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

    override void reset() {}

    override CommandBuffer[] allocate(size_t count) {
        auto bufs = new CommandBuffer[count];
        foreach (i; 0 .. count) {
            bufs[i] = new GlCommandBuffer(this, fbo);
        }
        return bufs;
    }

    override void free(CommandBuffer[] buffers) {}
}

final class GlCommandBuffer : CommandBuffer
{
    import gfx.core.typecons : Trans;
    import gfx.core.types : Rect;
    import gfx.gl3 : GlShare, GlInfo;
    import gfx.graal.buffer : Buffer, IndexType;
    import gfx.graal.image : ImageBase, ImageLayout, ImageSubresourceRange;
    import gfx.graal.pipeline : DescriptorSet, Pipeline, PipelineLayout, ShaderStage;
    import gfx.graal.renderpass : Framebuffer, RenderPass;
    import std.typecons : Flag;

    private CommandPool _pool;
    private GlCommand[] _cmds;
    private GLuint _fbo;
    private bool _persistent;

    this (CommandPool pool, GLuint fbo) {
        _pool = pool;
        _fbo = fbo;
    }

    override @property CommandPool pool() {
        return _pool;
    }

    override void reset() {}

    override void begin(Flag!"persistent" persistent) {
        _persistent = persistent;
    }
    override void end() {}

    override void pipelineBarrier(Trans!PipelineStage stageTrans,
                                  BufferMemoryBarrier[] bufMbs,
                                  ImageMemoryBarrier[] imgMbs) {}

    override void clearColorImage(ImageBase image, ImageLayout layout,
                                  in ClearColorValues clearValues,
                                  ImageSubresourceRange[] ranges)
    {
        import gfx.gl3.resource : GlImage;
        _cmds ~= new ClearColorCmd(_fbo, cast(GlImage)image, clearValues, false);
    }

    override void clearDepthStencilImage(ImageBase image, ImageLayout layout,
                                         in ClearDepthStencilValues clearValues,
                                         ImageSubresourceRange[] ranges)
    {}

    override void copyBuffer(Trans!Buffer buffers, CopyRegion[] regions) {}
    override void copyBufferToImage(Buffer srcBuffer, ImageBase dstImage,
                                    in ImageLayout dstLayout,
                                    in BufferImageCopy[] regions)
    {}

    override void beginRenderPass(RenderPass rp, Framebuffer fb,
                                  Rect area, ClearValues[] clearValues)
    {
        import gfx.gl3.pipeline : GlFramebuffer;
        const glFb = cast(GlFramebuffer)fb;
        foreach (cv; clearValues) {
            if (cv.type == ClearValues.Type.color) {
                _cmds ~= new ClearColorCmd(glFb.name, null, cv.values.color, true);
            }
        }
    }

    override void nextSubpass() {}

    override void endRenderPass() {}

    override void bindPipeline(Pipeline pipeline) {}
    override void bindVertexBuffers(uint firstBinding, VertexBinding[] bindings)
    {}
    override void bindIndexBuffer(Buffer indexBuf, size_t offset,
                                  IndexType type)
    {}

    override void bindDescriptorSets(PipelineBindPoint bindPoint,
                                     PipelineLayout layout, uint firstSet,
                                     DescriptorSet[] sets,
                                     in size_t[] dynamicOffsets)
    {}

    override void pushConstants(PipelineLayout layout, ShaderStage stages,
                                size_t offset, size_t size, const(void)* data)
    {}

    override void draw(uint vertexCount, uint instanceCount, uint firstVertex,
                       uint firstInstance)
    {}
    override void drawIndexed(uint indexCount, uint instanceCount,
                              uint firstVertex, int vertexOffset,
                              uint firstInstance)
    {}
}

final class GlQueue : Queue
{
    import gfx.gl3 : GlShare;
    import gfx.graal.device : Device;
    import gfx.graal.sync : Fence, Semaphore;

    private GlShare share;
    private Device _device;
    private GLuint readFbo;

    this(GlShare share, Device device) {
        this.share = share;
        _device = device;
        share.gl.GenFramebuffers(1, &readFbo);
    }

    void clean() {
        share.gl.DeleteFramebuffers(1, &readFbo);
    }

    override @property Device device() {
        return _device;
    }
    override void waitIdle() {}
    override void submit(Submission[] submissions, Fence fence) {
        auto gl = share.gl;
        foreach (ref s; submissions) {
            foreach (cmdBuf; s.cmdBufs) {
                auto glCmdBuf = cast(GlCommandBuffer)cmdBuf;
                foreach (cmd; glCmdBuf._cmds) {
                    cmd.execute(this, gl);
                }
                if (!glCmdBuf._persistent) {
                    glCmdBuf._cmds = null;
                }
            }
        }
    }
    override void present(Semaphore[] waitSems, PresentRequest[] prs) {
        import gfx.gl3.resource : GlImage;
        import gfx.gl3.swapchain : GlSurface, GlSwapchain;
        auto gl = share.gl;

        foreach (i, pr; prs) {
            auto sc = cast(GlSwapchain)pr.swapChain;
            auto surf = sc.surface;
            auto img = cast(GlImage)sc.images[pr.imageIndex];
            auto size = sc.size;

            share.ctx.makeCurrent(surf.handle);

            if (i == prs.length-1) share.ctx.swapInterval = 1;
            else share.ctx.swapInterval = 0;

            import gfx.gl3.error : glCheck;

            gl.BindFramebuffer(GL_READ_FRAMEBUFFER, readFbo);
            gl.FramebufferRenderbuffer(GL_READ_FRAMEBUFFER,
                                       GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER,
                                       img.name);

            gl.BindFramebuffer(GL_DRAW_FRAMEBUFFER, 0);
            gl.BlitFramebuffer(0, 0, size[0], size[1], 0, 0, size[0], size[1],
                               GL_COLOR_BUFFER_BIT, GL_NEAREST);
            glCheck(gl, "blit framebuffer");

            share.ctx.swapBuffers(surf.handle);
        }
        //if (prs.length > 1)
            //share.ctx.makeCurrent(share.dummyWin);
    }
}

private:


abstract class GlCommand {
    abstract void execute(GlQueue queue, Gl gl);
}

final class ClearColorCmd : GlCommand {
    import gfx.gl3.resource : GlImage, GlImgType;

    GLuint fbo;
    GlImage img;
    ClearColorValues values;
    bool fboReady;

    this (GLuint fbo, GlImage img, ClearColorValues values, bool fboReady=false) {
        // img may be null if fboReady is true
        this.fbo = fbo;
        this.img = img;
        this.values = values;
        this.fboReady = fboReady;
    }
    override void execute(GlQueue queue, Gl gl) {
        gl.BindFramebuffer(GL_DRAW_FRAMEBUFFER, fbo);
        if (!fboReady) {
            final switch (img.glType) {
            case GlImgType.renderBuf:
                gl.FramebufferRenderbuffer(GL_DRAW_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, img.name);
                break;
            case GlImgType.tex:
                gl.FramebufferTexture2D(GL_DRAW_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, img.name, 0);
                break;
            }
        }
        const GLenum drawBuf = GL_COLOR_ATTACHMENT0;
        gl.DrawBuffers(1, &drawBuf);

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