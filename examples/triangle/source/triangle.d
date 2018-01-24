module triangle;

import example;

import gfx.core.rc;
import gfx.core.typecons;
import gfx.core.types;
import gfx.graal.cmd;
import gfx.graal.image;
import gfx.graal.pipeline;
import gfx.graal.presentation;
import gfx.graal.queue;
import gfx.graal.renderpass;

import std.stdio;
import std.typecons;

class TriangleExample : Example
{
    Rc!RenderPass renderPass;
    Framebuffer[] framebuffers;
    Rc!Pipeline pipeline;

    this() {
        super("Triangle");
    }

    override void dispose() {
        if (device) {
            device.waitIdle();
        }
        pipeline.unload();
        renderPass.unload();
        releaseArray(framebuffers);
        super.dispose();
    }

    override void prepare() {
        super.prepare();
        prepareRenderPass();
        preparePipeline();
    }

    void prepareRenderPass() {
        const attachments = [
            AttachmentDescription(swapchain.format, 1,
                AttachmentOps(LoadOp.clear, StoreOp.store),
                AttachmentOps(LoadOp.dontCare, StoreOp.dontCare),
                trans(ImageLayout.presentSrc, ImageLayout.presentSrc),
                No.mayAlias
            )
        ];
        const subpasses = [
            SubpassDescription(
                [], [ AttachmentRef(0, ImageLayout.colorAttachmentOptimal) ],
                none!AttachmentRef, []
            )
        ];

        renderPass = device.createRenderPass(attachments, subpasses, []);

        framebuffers = new Framebuffer[scImages.length];
        foreach (i; 0 .. scImages.length) {
            framebuffers[i] = device.createFramebuffer(renderPass, [
                scImages[i].createView(
                    ImageType.d2,
                    ImageSubresourceRange(ImageAspect.color, 0, 1, 0, 1),
                    Swizzle.init
                )
            ], surfaceSize[0], surfaceSize[1], 1);
        }
    }

    void preparePipeline()
    {
        auto vtxShader = device.createShaderModule(
            ShaderLanguage.spirV, import("shader.vert.spv"), "main"
        ).rc;
        auto fragShader = device.createShaderModule(
            ShaderLanguage.spirV, import("shader.frag.spv"), "main"
        ).rc;

        PipelineInfo info;
        info.shaders.vertex = vtxShader;
        info.shaders.fragment = fragShader;
        info.assembly = InputAssembly(Primitive.triangleList, No.primitiveRestart);
        info.rasterizer = Rasterizer(
            PolygonMode.fill, Cull.back, FrontFace.ccw, No.depthClamp,
            none!DepthBias, 1f
        );
        info.viewports = [
            ViewportConfig(
                Viewport(0, 0, cast(float)surfaceSize[0], cast(float)surfaceSize[1], -1, 1),
                Rect(0, 0, surfaceSize[0], surfaceSize[1])
            )
        ];
        info.blendInfo = ColorBlendInfo(
            none!LogicOp, [
                ColorBlendAttachment(No.enabled,
                    BlendState(trans(BlendFactor.one, BlendFactor.zero), BlendOp.add),
                    BlendState(trans(BlendFactor.one, BlendFactor.zero), BlendOp.add),
                    ColorMask.all
                )
            ],
            [ 0f, 0f, 0f, 0f ]
        );
        info.layout = device.createPipelineLayout();
        info.renderPass = renderPass;
        info.subpassIndex = 0;

        auto pls = device.createPipelines( [info] );
        pipeline = pls[0];
    }


    void recordCmds() {
        import gfx.core.typecons : trans;

        const cv = ClearColorValues(0.6f, 0.6f, 0.6f, hasAlpha ? 0.5f : 1f);
        auto subrange = ImageSubresourceRange(ImageAspect.color, 0, 1, 0, 1);

        foreach (i, buf; presentCmdBufs) {
            buf.begin(true);

            if (graphicsQueueIndex != presentQueueIndex) {
                buf.pipelineBarrier(
                    trans(PipelineStage.colorAttachment, PipelineStage.colorAttachment), [],
                    [ ImageMemoryBarrier(
                        trans(Access.memoryRead, Access.colorAttachmentWrite),
                        trans(ImageLayout.presentSrc, ImageLayout.presentSrc),
                        trans(presentQueueIndex, graphicsQueueIndex),
                        scImages[i], subrange
                    ) ]
                );
            }

            buf.beginRenderPass(
                renderPass, framebuffers[i],
                Rect(0, 0, surfaceSize[0], surfaceSize[1]), [ ClearValues(cv) ]
            );

            buf.bindPipeline(pipeline);
            buf.draw(3, 1, 0, 0);

            buf.endRenderPass();

            if (graphicsQueueIndex != presentQueueIndex) {
                buf.pipelineBarrier(
                    trans(PipelineStage.colorAttachment, PipelineStage.colorAttachment), [],
                    [ ImageMemoryBarrier(
                        trans(Access.colorAttachmentWrite, Access.memoryRead),
                        trans(ImageLayout.presentSrc, ImageLayout.presentSrc),
                        trans(graphicsQueueIndex, presentQueueIndex),
                        scImages[i], subrange
                    ) ]
                );
            }

            buf.end();
        }
    }
    void render()
    {
        import core.time : dur;

        bool needReconstruction;
        const imgInd = swapchain.acquireNextImage(dur!"seconds"(-1), imageAvailableSem, needReconstruction);

        presentQueue.submit([
            Submission (
                [ StageWait(imageAvailableSem, PipelineStage.transfer) ],
                [ renderingFinishSem ], [ presentCmdBufs[imgInd] ]
            )
        ], null);

        presentQueue.present(
            [ renderingFinishSem ],
            [ PresentRequest(swapchain, imgInd) ]
        );

        if (needReconstruction) {
            writeln("need to rebuild swapchain");
            prepareSwapchain(swapchain);
            presentPool.reset();
            recordCmds();
        }
    }

}

int main() {

    try {
        auto example = new TriangleExample();
        example.prepare();
        example.recordCmds();
        scope(exit) example.dispose();

        bool exitFlag;
        example.window.mouseOn = (uint, uint) {
            exitFlag = true;
        };

        import std.datetime.stopwatch : StopWatch;

        size_t frameCount;
        size_t lastUs;
        StopWatch sw;
        sw.start();

        enum reportFreq = 100;

        while (!exitFlag) {
            example.window.pollAndDispatch();
            example.render();
            ++ frameCount;
            if ((frameCount % reportFreq) == 0) {
                const us = sw.peek().total!"usecs";
                writeln("FPS: ", 1000_000.0 * reportFreq / (us - lastUs));
                lastUs = us;
            }
        }

        return 0;
    }
    catch(Exception ex) {
        stderr.writeln("error occured: ", ex.msg);
        return 1;
    }
}
