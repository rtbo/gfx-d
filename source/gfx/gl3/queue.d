module gfx.gl3.queue;

package:

import gfx.graal.cmd;
import gfx.graal.queue;

final class GlCommandBuffer : CommandBuffer
{
    import gfx.core.typecons : Trans;
    import gfx.core.types : Rect;
    import gfx.gl3 : GlShare;
    import gfx.graal.buffer : Buffer, IndexType;
    import gfx.graal.image : ImageBase, ImageLayout, ImageSubresourceRange;
    import gfx.graal.pipeline : DescriptorSet, Pipeline, PipelineLayout, ShaderStage;
    import gfx.graal.renderpass : Framebuffer, RenderPass;
    import std.typecons : Flag;

    private CommandPool _pool;
    private GlCommand[] _cmds;

    this (CommandPool pool) {
        _pool = pool;
    }

    override @property CommandPool pool() {
        return _pool;
    }

    override void reset() {}

    override void begin(Flag!"persistent" persistent) {}
    override void end() {}

    override void pipelineBarrier(Trans!PipelineStage stageTrans,
                                  BufferMemoryBarrier[] bufMbs,
                                  ImageMemoryBarrier[] imgMbs) {}

    override void clearColorImage(ImageBase image, ImageLayout layout,
                                  in ClearColorValues clearValues,
                                  ImageSubresourceRange[] ranges) {}

    override void clearDepthStencilImage(ImageBase image, ImageLayout layout,
                                         in ClearDepthStencilValues clearValues,
                                         ImageSubresourceRange[] ranges) {}

    override void copyBuffer(Trans!Buffer buffers, CopyRegion[] regions) {}
    override void copyBufferToImage(Buffer srcBuffer, ImageBase dstImage,
                                    in ImageLayout dstLayout, in BufferImageCopy[] regions) {}

    override void beginRenderPass(RenderPass rp, Framebuffer fb,
                                  Rect area, ClearValues[] clearValues) {}

    override void nextSubpass() {}

    override void endRenderPass() {}

    override void bindPipeline(Pipeline pipeline) {}
    override void bindVertexBuffers(uint firstBinding, VertexBinding[] bindings) {}
    override void bindIndexBuffer(Buffer indexBuf, size_t offset, IndexType type) {}

    override void bindDescriptorSets(PipelineBindPoint bindPoint, PipelineLayout layout,
                                     uint firstSet, DescriptorSet[] sets, in size_t[] dynamicOffsets) {}

    override void pushConstants(PipelineLayout layout, ShaderStage stages,
                                size_t offset, size_t size, const(void)* data) {}

    override void draw(uint vertexCount, uint instanceCount, uint firstVertex, uint firstInstance) {}
    override void drawIndexed(uint indexCount, uint instanceCount, uint firstVertex, int vertexOffset, uint firstInstance) {}
}

final class GlQueue : Queue
{
    import gfx.gl3 : GlShare;
    import gfx.graal.device : Device;
    import gfx.graal.sync : Fence, Semaphore;

    private GlShare _share;
    private Device _device;

    this(GlShare share, Device device) {
        _share = share;
        _device = device;
    }

    override @property Device device() {
        return _device;
    }
    override void waitIdle() {}
    override void submit(Submission[] submissions, Fence fence) {
        auto gl = _share.gl;
        foreach (ref s; submissions) {
            foreach (cmdBuf; s.cmdBufs) {
                auto glCmdBuf = cast(GlCommandBuffer)cmdBuf;
                foreach (cmd; glCmdBuf._cmds) {
                    cmd.execute(this, gl);
                }
            }
        }
    }
    override void present(Semaphore[] waitSems, PresentRequest[] prs) {}
}

private:

import gfx.bindings.opengl.gl : Gl;

abstract class GlCommand {
    abstract void execute(GlQueue queue, Gl gl);
}
