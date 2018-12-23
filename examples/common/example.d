module example;

import gfx.core.rc;
import gfx.graal;
import gfx.graal.cmd;
import gfx.graal.device;
import gfx.graal.image;
import gfx.graal.queue;
import gfx.graal.sync;
import gfx.vulkan;
import gfx.window;

import std.algorithm;
import std.exception;
import std.typecons;
import std.traits : isArray;

struct FPSProbe {
    import std.datetime.stopwatch : StopWatch;

    private StopWatch sw;
    private size_t lastUsecs;
    private size_t lastFc;
    size_t frameCount;

    void start() { sw.start(); }
    void tick() { frameCount += 1; }
    @property float fps() {
        const usecs = sw.peek().total!"usecs"();
        const fps = 1000_000f * (frameCount - lastFc) / (usecs-lastUsecs);
        lastFc = frameCount;
        lastUsecs = usecs;
        return fps;
    }
}

class Example : Disposable
{
    string title;
    string[] args;
    Rc!Display display;
    Window window;
    Rc!Instance instance;
    uint graphicsQueueIndex;
    uint presentQueueIndex;
    PhysicalDevice physicalDevice;
    Rc!Device device;
    Queue graphicsQueue;
    Queue presentQueue;
    uint[2] surfaceSize;
    bool hasAlpha;
    Rc!Swapchain swapchain;
    ImageBase[] scImages;
    Rc!Semaphore imageAvailableSem;
    Rc!Semaphore renderingFinishSem;
    Rc!CommandPool cmdPool;
    CommandBuffer[] cmdBufs;
    Fence[] fences;

    enum numCmdBufs=2;
    size_t cmdBufInd;

    this (string title, string[] args=[])
    {
        this.title = title;
        this.args = args;
    }

    override void dispose() {
        if (device) {
            device.waitIdle();
        }
        releaseArr(fences);
        if (cmdPool && cmdBufs.length) {
            cmdPool.free(cmdBufs);
            cmdPool.unload();
        }
        // the rest is checked with Rc, so it is safe to call unload even
        // if object is invalid
        imageAvailableSem.unload();
        renderingFinishSem.unload();
        swapchain.unload();
        device.unload();
        if (window) {
            //window.close();
        }
        instance.unload();
        display.unload();
    }

    void prepare()
    {
        bool noVulkan = false;
        foreach (a; args) {
            if (a == "--no-vulkan" || a == "nv") {
                noVulkan = true;
                break;
            }
        }
        Backend[] backendLoadOrder;
        if (!noVulkan) {
            backendLoadOrder ~= Backend.vulkan;
        }
        backendLoadOrder ~= Backend.gl3;
        // Create a display for the running platform
        // The instance is created by the display. Backend is chosen at runtime
        // depending on detected API support. (i.e. Vulkan is preferred)
        display = createDisplay(backendLoadOrder);
        instance = display.instance;
        // Create a window. The surface is created during the call to show.
        window = display.createWindow();
        window.show(640, 480);

        instance.setDebugCallback((Severity sev, string msg) {
            import std.stdio : writefln;
            if (sev == Severity.warning) {
                writefln("Gfx backend %s message: %s", sev, msg);
            }
            if (sev == Severity.error) {
                // debug break;
                asm { int 0x03; }
            }
        });

        // The rest of the preparation.
        prepareDevice();
        prepareSwapchain(null);
        prepareSync();
        prepareCmds();
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

    void prepareSwapchain(Swapchain former=null) {
        const surfCaps = physicalDevice.surfaceCaps(window.surface);
        enforce(surfCaps.usage & ImageUsage.transferDst, "TransferDst not supported by surface");
        const usage = ImageUsage.colorAttachment;
        const numImages = max(2, surfCaps.minImages);
        enforce(surfCaps.maxImages == 0 || surfCaps.maxImages >= numImages);
        const f = chooseFormat(physicalDevice, window.surface);

        CompositeAlpha ca;
        if (surfCaps.supportedAlpha & CompositeAlpha.preMultiplied) {
            ca = CompositeAlpha.preMultiplied;
        }
        else if (surfCaps.supportedAlpha & CompositeAlpha.inherit) {
            ca = CompositeAlpha.inherit;
        }
        else if (surfCaps.supportedAlpha & CompositeAlpha.postMultiplied) {
            ca = CompositeAlpha.postMultiplied;
        }
        else {
            ca = CompositeAlpha.opaque;
        }
        hasAlpha = ca != CompositeAlpha.opaque;

        surfaceSize = [ 640, 480 ];
        foreach (i; 0..2) {
            surfaceSize[i] = clamp(surfaceSize[i], surfCaps.minSize[i], surfCaps.maxSize[i]);
        }
        const pm = choosePresentMode(physicalDevice, window.surface);

        swapchain = device.createSwapchain(window.surface, pm, numImages, f, surfaceSize, usage, ca, former);
        scImages = swapchain.images;
    }

    void prepareSync() {
        imageAvailableSem = device.createSemaphore();
        renderingFinishSem = device.createSemaphore();
        fences = new Fence[numCmdBufs];
        foreach (i; 0 .. numCmdBufs) {
            fences[i] = device.createFence(Yes.signaled);
        }
        retainArr(fences);
    }

    void prepareCmds() {
        cmdPool = device.createCommandPool(graphicsQueueIndex);
        cmdBufs = cmdPool.allocate(numCmdBufs);
    }

    abstract void recordCmds(size_t cmdBufInd, size_t imgInd);

    size_t nextCmdBuf() {
        const ind = cmdBufInd++;
        if (cmdBufInd == numCmdBufs) {
            cmdBufInd = 0;
        }
        return ind;
    }

    void render()
    {
        import core.time : dur;

        bool needReconstruction;
        const imgInd = swapchain.acquireNextImage(dur!"seconds"(-1), imageAvailableSem, needReconstruction);
        const cmdBufInd = nextCmdBuf();

        fences[cmdBufInd].wait();
        fences[cmdBufInd].reset();

        recordCmds(cmdBufInd, imgInd);

        submit(cmdBufInd);

        presentQueue.present(
            [ renderingFinishSem ],
            [ PresentRequest(swapchain, imgInd) ]
        );

        // if (needReconstruction) {
        //     prepareSwapchain(swapchain);
        //     presentPool.reset();
        // }
    }

    void submit(ulong cmdBufInd) {
        graphicsQueue.submit([
            Submission (
                [ StageWait(imageAvailableSem, PipelineStage.transfer) ],
                [ renderingFinishSem.obj ], [ cmdBufs[cmdBufInd] ]
            )
        ], fences[cmdBufInd] );
    }


    // Following functions are general utility that can be used by subclassing
    // examples.

    /// Find a format supported by the device for the given tiling and features
    Format findSupportedFormat(in Format[] candidates, in ImageTiling tiling, in FormatFeatures features)
    {
        foreach (f; candidates) {
            const props = physicalDevice.formatProperties(f);
            if (tiling == ImageTiling.optimal &&
                    (props.optimalTiling & features) == features) {
                return f;
            }
            if (tiling == ImageTiling.linear &&
                    (props.linearTiling & features) == features) {
                return f;
            }
        }
        throw new Exception("could not find supported format");
    }

    /// Find a supported depth format
    Format findDepthFormat() {
        return findSupportedFormat(
            [ Format.d32_sFloat, Format.d32s8_sFloat, Format.d24s8_uNorm, Format.d16_uNorm, Format.d16s8_uNorm ],
            ImageTiling.optimal, FormatFeatures.depthStencilAttachment
        );
    }

    /// Return the index of a memory type supporting all of props,
    /// or uint.max if none was found.
    uint findMemType(MemoryRequirements mr, MemProps props)
    {
        const devMemProps = physicalDevice.memoryProperties;
        foreach (i, mt; devMemProps.types) {
            if ((mr.memTypeMask & (1 << i)) != 0 && (mt.props & props) == props) {
                return cast(uint)i;
            }
        }
        return uint.max;
    }


    /// Create a buffer for usage, bind memory of dataSize with memProps
    /// Return null if no memory type can be found
    final Buffer createBuffer(size_t dataSize, BufferUsage usage, MemProps props)
    {
        auto buf = device.createBuffer( usage, dataSize ).rc;

        const mr = buf.memoryRequirements;
        const memTypeInd = findMemType(mr, props);
        if (memTypeInd == uint.max) return null;

        auto mem = device.allocateMemory(memTypeInd, mr.size).rc;
        buf.bindMemory(mem, 0);

        return buf.giveAway();
    }

    /// Create a buffer, binds memory to it, and leave content undefined
    /// The buffer will be host visible and host coherent such as content
    /// can be updated without staging buffer
    final Buffer createDynamicBuffer(size_t dataSize, BufferUsage usage)
    {
        return createBuffer(dataSize, usage, MemProps.hostVisible | MemProps.hostCoherent);
    }

    /// Create a buffer, and bind it with memory filled with data.
    /// The bound memory will be deviceLocal, without guarantee to be host visible.
    final Buffer createStaticBuffer(const(void)[] data, BufferUsage usage)
    {
        const dataSize = data.length;

        // On embedded gpus, device local memory is often also host visible.
        // Attempting to create one that way.
        if (physicalDevice.type != DeviceType.discreteGpu) {
            auto buf = createBuffer(
                dataSize, usage,
                MemProps.hostVisible | MemProps.hostCoherent | MemProps.deviceLocal
            ).rc;
            if (buf) {
                auto mm = buf.boundMemory.map(0, dataSize);
                mm[] = data;
                return buf.giveAway();
            }
        }

        // did not happen :-(
        // will go the usual way: staging buffer then device local buffer

        // create staging buffer
        auto stagingBuf = enforce(createBuffer(
            dataSize, BufferUsage.transferSrc, MemProps.hostVisible | MemProps.hostCoherent
        )).rc;

        // populate data
        {
            auto mm = stagingBuf.boundMemory.map(0, dataSize);
            mm[] = data;
        }

        // create actual buffer
        auto buf = enforce(createBuffer(
            dataSize, usage | BufferUsage.transferDst, MemProps.deviceLocal
        )).rc;

        auto b = autoCmdBuf().rc;

        // copy from staging buffer
        copyBuffer(stagingBuf, buf, dataSize, b.cmdBuf);

        // return data
        return buf.giveAway();
    }

    /// ditto
    final Buffer createStaticBuffer(T)(const(T)[] data, BufferUsage usage)
    if (!is(T == void))
    {
        return createStaticBuffer(untypeSlice(data), usage);
    }

    /// ditto
    final Buffer createStaticBuffer(T)(in T data, BufferUsage usage)
    if (!isArray!T)
    {
        const start = cast(const(void)*)&data;
        return createStaticBuffer(start[0 .. data.sizeof], usage);
    }

    bool bindImageMemory(Image img, MemProps props=MemProps.deviceLocal) {
        const mr = img.memoryRequirements;
        const memTypeInd = findMemType(mr, MemProps.deviceLocal);
        if (memTypeInd == uint.max) return false;

        auto mem = device.allocateMemory(memTypeInd, mr.size).rc;
        img.bindMemory(mem, 0);
        return true;
    }

    /// create an image to be used as texture
    Image createTextureImage(const(void)[] data, in ImageInfo info)
    {
        const FormatFeatures requirement = FormatFeatures.sampledImage;
        const formatProps = physicalDevice.formatProperties(info.format);
        enforce( (formatProps.optimalTiling & requirement) == requirement );

        // create staging buffer
        auto stagingBuf = enforce(createBuffer(
            data.length, BufferUsage.transferSrc, MemProps.hostVisible | MemProps.hostCoherent
        )).rc;

        // populate data to buffer
        {
            auto mm = stagingBuf.boundMemory.map(0, data.length);
            mm[] = data;
        }

        // create an image
        auto img = enforce(device.createImage(
            info.withUsage(info.usage | ImageUsage.sampled | ImageUsage.transferDst)
        )).rc;

        // allocate memory image
        if (!bindImageMemory(img)) return null;

        {
            auto b = autoCmdBuf().rc;

            b.cmdBuf.pipelineBarrier(
                trans(PipelineStage.topOfPipe, PipelineStage.transfer), [], [
                    ImageMemoryBarrier(
                        trans(Access.none, Access.transferWrite),
                        trans(ImageLayout.undefined, ImageLayout.transferDstOptimal),
                        trans(queueFamilyIgnored, queueFamilyIgnored),
                        img, ImageSubresourceRange(ImageAspect.color)
                    )
                ]
            );
            copyBufferToImage(stagingBuf, img, b.cmdBuf);
        }

        return img.giveAway();
    }

    /// Create an image for depth attachment usage
    Image createDepthImage(uint width, uint height)
    {
        // find the format of the image
        const f = findDepthFormat();

        // create an image
        auto img = enforce(device.createImage(
            ImageInfo.d2(width, height).withFormat(f).withUsage(ImageUsage.depthStencilAttachment)
        )).rc;

        // allocate memory image
        if (!bindImageMemory(img)) return null;

        return img.giveAway();
    }

    /// Create an image for stencil attachment usage
    Image createStencilImage(uint width, uint height)
    {
        // assume s8_uInt is supported
        const f = Format.s8_uInt;

        // create an image
        auto img = enforce(device.createImage(
            ImageInfo.d2(width, height).withFormat(f).withUsage(ImageUsage.depthStencilAttachment)
        )).rc;

        // allocate memory image
        if (!bindImageMemory(img)) return null;

        return img.giveAway();
    }

    /// copy the content of one buffer to another
    /// srcBuf and dstBuf must support transferSrc and transferDst respectively.
    final void copyBuffer(Buffer srcBuf, Buffer dstBuf, size_t size, CommandBuffer cmdBuf)
    {
        cmdBuf.copyBuffer(trans(srcBuf, dstBuf), [CopyRegion(trans!size_t(0, 0), size)]);
    }

    /// copy the content of one buffer to an image.
    /// the image layout must be transferDstOptimal buffer the call
    final void copyBufferToImage(Buffer srcBuf, Image dstImg, CommandBuffer cmdBuf)
    {
        const dims = dstImg.info.dims;

        BufferImageCopy region;
        region.extent = [dims.width, dims.height, dims.depth];
        const regions = (&region)[0 .. 1];
        cmdBuf.copyBufferToImage(srcBuf, dstImg, ImageLayout.transferDstOptimal, regions);
    }

    /// Get a RAII command buffer that is meant to be trashed after usage.
    /// Returned buffer is ready to record data, and execute commands on the graphics queue
    /// at end of scope.
    AutoCmdBuf autoCmdBuf(CommandPool pool=null)
    {
        Rc!CommandPool cmdPool = pool;
        if (!cmdPool) {
            cmdPool = enforce(this.cmdPool);
        }
        return new AutoCmdBuf(cmdPool, graphicsQueue);
    }
}

/// Utility command buffer for a one time submission that automatically submit
/// when disposed.
/// Generally used for transfer operations.
class AutoCmdBuf : IAtomicRefCounted
{
    mixin(atomicRcCode);

    Rc!CommandPool pool;
    Queue queue;
    Rc!Device device; // device holds queue,
    CommandBuffer cmdBuf;

    this(CommandPool pool, Queue queue) {
        this.pool = pool;
        this.queue = queue;
        this.device = queue.device;
        this.cmdBuf = this.pool.allocate(1)[0];
        this.cmdBuf.begin(No.persistent);
    }

    override void dispose() {
        this.cmdBuf.end();
        this.queue.submit([
            Submission([], [], [ this.cmdBuf ])
        ], null);
        this.queue.waitIdle();
        this.pool.free([ this.cmdBuf ]);
        this.pool.unload();
        this.device.unload();
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
