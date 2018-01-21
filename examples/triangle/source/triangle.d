module triangle;

import example;

import gfx.graal.cmd;
import gfx.graal.image;
import gfx.graal.presentation;
import gfx.graal.queue;

import std.stdio;

class TriangleExample : Example
{
    void recordCmds() {
        import gfx.core.typecons : trans;

        const clearValues = ClearColorValues(0.6f, 0.6f, 0.6f, hasAlpha ? 0.5f : 1f);
        auto subrange = ImageSubresourceRange(ImageAspect.color, 0, 1, 0, 1);

        foreach (i, buf; presentCmdBufs) {
            buf.begin(true);

            buf.pipelineBarrier(
                trans(PipelineStage.transfer, PipelineStage.transfer), [],
                [ ImageMemoryBarrier(
                    trans(Access.memoryRead, Access.transferWrite),
                    trans(ImageLayout.undefined, ImageLayout.transferDstOptimal),
                    trans(graphicsQueueIndex, presentQueueIndex),
                    scImages[i], subrange
                ) ]
            );

            buf.clearColorImage(
                scImages[i], ImageLayout.transferDstOptimal, clearValues, [ subrange ]
            );

            buf.pipelineBarrier(
                trans(PipelineStage.transfer, PipelineStage.transfer), [],
                [ ImageMemoryBarrier(
                    trans(Access.transferWrite, Access.memoryRead),
                    trans(ImageLayout.transferDstOptimal, ImageLayout.presentSrc),
                    trans(graphicsQueueIndex, presentQueueIndex),
                    scImages[i], subrange
                ) ]
            );

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
