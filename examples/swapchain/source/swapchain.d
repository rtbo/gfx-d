module swapchain;

import example;

import gfx.graal;
import gfx.window;

import std.typecons;


class SwapchainExample : Example
{
    this(string[] args) {
        super("Swapchain", args);
    }

    class SwapchainFrameData : FrameData
    {
        PrimaryCommandBuffer cmdBuf;

        this(ImageBase swcColor, CommandBuffer tempBuf)
        {
            super(swcColor);
            cmdBuf = cmdPool.allocatePrimary(1)[0];

            this.outer.recordImageLayoutBarrier(
                tempBuf, swcColor, trans(ImageLayout.undefined, ImageLayout.presentSrc)
            );
        }

        override void dispose()
        {
            cmdPool.free([ cast(CommandBuffer)cmdBuf ]);
            super.dispose();
        }
    }

    override FrameData makeFrameData(ImageBase swcColor, CommandBuffer tempBuf)
    {
        return new SwapchainFrameData(swcColor, tempBuf);
    }

    override Submission[] recordCmds(FrameData frameData)
    {
        auto sfd = cast(SwapchainFrameData)frameData;
        const clearValues = ClearColorValues(0.6f, 0.6f, 0.6f, hasAlpha ? 0.5f : 1f);
        auto subrange = ImageSubresourceRange(ImageAspect.color, 0, 1, 0, 1);

        auto buf = sfd.cmdBuf;
        buf.begin(CommandBufferUsage.none);

            buf.pipelineBarrier(
                trans(PipelineStage.transfer, PipelineStage.transfer), [],
                [ ImageMemoryBarrier(
                    trans(Access.memoryRead, Access.transferWrite),
                    trans(ImageLayout.presentSrc, ImageLayout.transferDstOptimal),
                    trans(presentQueue.index, graphicsQueue.index),
                    sfd.swcColor, subrange
                ) ]
            );

            buf.clearColorImage(
                sfd.swcColor, ImageLayout.transferDstOptimal, clearValues, [ subrange ]
            );

            buf.pipelineBarrier(
                trans(PipelineStage.transfer, PipelineStage.transfer), [],
                [ ImageMemoryBarrier(
                    trans(Access.transferWrite, Access.memoryRead),
                    trans(ImageLayout.transferDstOptimal, ImageLayout.presentSrc),
                    trans(graphicsQueue.index, presentQueue.index),
                    sfd.swcColor, subrange
                ) ]
            );

        buf.end();

        return simpleSubmission([ buf ]);
    }
}

int main(string[] args)
{
    try {
        auto example = new SwapchainExample(args);
        example.prepare();
        scope(exit) example.dispose();

        example.window.onKeyOn = (KeyEvent ev)
        {
            if (ev.sym == KeySym.escape) {
                example.window.closeFlag = true;
            }
        };

        while (!example.window.closeFlag) {
            example.render();
            example.frameTick();
            example.display.pollAndDispatch();
        }

        return 0;
    }
    catch(Exception ex) {
        gfxExLog.errorf("error occured: %s", ex.msg);
        return 1;
    }
}
