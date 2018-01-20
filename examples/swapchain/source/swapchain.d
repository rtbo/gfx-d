module swapchain;

import core.time : Duration;

import erupted;

import gfx.core.rc;
import gfx.graal;
import gfx.graal.cmd;
import gfx.graal.device;
import gfx.graal.queue;
import gfx.graal.sync;
import gfx.vulkan;
import gfx.window;

import std.algorithm;
import std.exception;
import std.stdio;

class SwapchainExample : Disposable
{
    Rc!Instance instance;
    Window window;
    uint graphicsQueueIndex;
    uint presentQueueIndex;
    Rc!PhysicalDevice physicalDevice;
    Rc!Device device;
    Queue graphicsQueue;
    Queue presentQueue;
    uint[2] surfaceSize;
    Rc!Swapchain swapchain;
    Image[] scImages;
    Rc!Semaphore imageAvailableSem;
    Rc!Semaphore renderingFinishSem;
    Rc!CommandPool presentPool;
    CommandBuffer[] presentCmdBufs;
    bool swStarted;


    void prepare() {
        // initialize vulkan library
        vulkanInit();
        // create a vulkan instance
        instance = createVulkanInstance("Triangle", VulkanVersion(0, 0, 1)).rc;
        // create a window for the running platform
        // the window surface is created during this process
        window = createWindow(instance);

        // the rest of the preparation
        prepareDevice();
        prepareSwapchain(null);
        prepareSync();
        prepareCmds();
        recordCmds();
    }

    void prepareDevice()
    {
        bool checkDevice(PhysicalDevice dev) {
            graphicsQueueIndex = uint.max;
            presentQueueIndex = uint.max;
            if (dev.softwareRendering) return false;
            foreach (uint i, qf; dev.queueFamilies) {
                const graphics = qf.cap & QueueCap.graphics;
                const present = dev.supportsSurface(i, window.surface);
                if (graphics && present) {
                    graphicsQueueIndex = i;
                    presentQueueIndex = i;
                    return true;
                }
                if (graphics) graphicsQueueIndex = i;
                if (present) presentQueueIndex = i;
            }
            return graphicsQueueIndex != uint.max && presentQueueIndex != uint.max;
        }
        foreach (pd; instance.devices) {
            if (checkDevice(pd)) {
                auto qrs = [ QueueRequest(graphicsQueueIndex, [ 0.5f ]) ];
                if (graphicsQueueIndex != presentQueueIndex) {
                    qrs ~= QueueRequest(presentQueueIndex, [ 0.5f ]);
                }
                physicalDevice = pd;
                device = pd.open(qrs);
                graphicsQueue = device.getQueue(graphicsQueueIndex, 0);
                presentQueue = device.getQueue(presentQueueIndex, 0);
                break;
            }
        }
    }

    void prepareSwapchain(Swapchain former) {
        const surfCaps = physicalDevice.surfaceCaps(window.surface);
        enforce(surfCaps.usage & ImageUsage.transferDst, "TransferDst not supported by surface");
        const usage = ImageUsage.transferDst | ImageUsage.colorAttachment;
        const numImages = max(2, surfCaps.minImages);
        enforce(surfCaps.maxImages == 0 || surfCaps.maxImages >= numImages);
        const f = chooseFormat(physicalDevice, window.surface);
        surfaceSize = [ 640, 480 ];
        foreach (i; 0..2) {
            surfaceSize[i] = clamp(surfaceSize[i], surfCaps.minSize[i], surfCaps.maxSize[i]);
        }
        const pm = choosePresentMode(physicalDevice, window.surface);

        swapchain = device.createSwapchain(window.surface, pm, numImages, f, surfaceSize, usage, former);
        scImages = swapchain.images;
    }

    void prepareSync() {
        imageAvailableSem = device.createSemaphore();
        renderingFinishSem = device.createSemaphore();
    }

    void prepareCmds() {
        presentPool = device.createCommandPool(presentQueueIndex);
        presentCmdBufs = presentPool.allocate(scImages.length);
    }

    void recordCmds() {

        const clearValues = ClearColorValues(0.8f, 0.7f, 0.2f, 1f);
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
        }
    }

    override void dispose() {
        if (device) {
            device.waitIdle();
        }
        if (presentPool && presentCmdBufs.length) {
            presentPool.free(presentCmdBufs);
            presentPool.unload();
        }
        // the rest is checked with Rc, so it is safe to call unload even
        // if object is invalid
        imageAvailableSem.unload();
        renderingFinishSem.unload();
        swapchain.unload();
        device.unload();
        physicalDevice.unload();
        if (window) {
            window.close();
        }
        instance.unload();
    }
}

/// Return a format suitable for the surface.
///  - if supported by the surface Format.rgba8_uNorm
///  - otherwise the first format with uNorm numeric format
///  - otherwise the first format
Format chooseFormat(PhysicalDevice pd, Surface surface)
{
    const formats = pd.surfaceFormats(surface);
    enforce(formats.length, "Could not get surface formats");
    if (formats.length == 1 && formats[0] == Format.undefined) {
        return Format.rgba8_uNorm;
    }
    foreach(f; formats) {
        if (f == Format.rgba8_uNorm) {
            return f;
        }
    }
    foreach(f; formats) {
        if (f.formatDesc.numFormat == NumFormat.uNorm) {
            return f;
        }
    }
    return formats[0];
}

PresentMode choosePresentMode(PhysicalDevice pd, Surface surface)
{
    // auto modes = pd.surfacePresentModes(surface);
    // if (modes.canFind(PresentMode.mailbox)) {
    //     return PresentMode.mailbox;
    // }
    assert(pd.surfacePresentModes(surface).canFind(PresentMode.fifo));
    return PresentMode.fifo;
}

int main() {

    try {
        auto example = new SwapchainExample();
        example.prepare();
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
            example.window.waitAndDispatch();
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
