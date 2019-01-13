module swapchain;

import example;

import gfx.graal.cmd;
import gfx.graal.image;
import gfx.graal.types;
import gfx.window;
import gfx.window.keys;

import std.typecons;


class SwapchainExample : Example
{
    this(string[] args) {
        super("Swapchain", args);
    }

    override void recordCmds(PerImage imgData)
    {
        const clearValues = ClearColorValues(0.6f, 0.6f, 0.6f, hasAlpha ? 0.5f : 1f);
        auto subrange = ImageSubresourceRange(ImageAspect.color, 0, 1, 0, 1);

        auto buf = imgData.cmdBufs[0];
        buf.begin(Yes.persistent);

            buf.pipelineBarrier(
                trans(PipelineStage.transfer, PipelineStage.transfer), [],
                [ ImageMemoryBarrier(
                    trans(Access.memoryRead, Access.transferWrite),
                    trans(ImageLayout.presentSrc, ImageLayout.transferDstOptimal),
                    trans(graphicsQueueIndex, presentQueueIndex),
                    imgData.color, subrange
                ) ]
            );

            buf.clearColorImage(
                imgData.color, ImageLayout.transferDstOptimal, clearValues, [ subrange ]
            );

            buf.pipelineBarrier(
                trans(PipelineStage.transfer, PipelineStage.transfer), [],
                [ ImageMemoryBarrier(
                    trans(Access.transferWrite, Access.memoryRead),
                    trans(ImageLayout.transferDstOptimal, ImageLayout.presentSrc),
                    trans(graphicsQueueIndex, presentQueueIndex),
                    imgData.color, subrange
                ) ]
            );

        buf.end();
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
        log.errorf("error occured: %s", ex.msg);
        return 1;
    }
}
