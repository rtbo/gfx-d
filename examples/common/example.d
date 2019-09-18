module example;

import gfx.core.log;
import gfx.core.rc;
import gfx.graal;
import gfx.graal.buffer;
import gfx.graal.cmd;
import gfx.graal.device;
import gfx.graal.format;
import gfx.graal.image;
import gfx.graal.memory;
import gfx.graal.presentation;
import gfx.graal.queue;
import gfx.graal.renderpass;
import gfx.graal.sync;
import gfx.graal.types;
import gfx.window;

import std.algorithm;
import std.exception;
import std.stdio;
import std.typecons;
import std.traits : isArray;
import std.datetime : Duration;

immutable gfxExLog = LogTag("GFX-EX");

struct FpsProbe
{
    import std.datetime.stopwatch : StopWatch;

    private StopWatch sw;
    private size_t lastUsecs;
    private size_t lastFc;
    private size_t fc;

    void start() { sw.start(); }

    bool running() { return sw.running(); }

    void stop()
    {
        sw.stop();
        lastUsecs = 0;
        lastFc = 0;
        fc = 0;
    }

    void tick() { fc += 1; }

    size_t framecount() { return fc; }

    float computeFps() {
        const usecs = sw.peek().total!"usecs"();
        const fps = 1000_000f * (fc - lastFc) / (usecs-lastUsecs);
        lastFc = fc;
        lastUsecs = usecs;
        return fps;
    }
}

struct Timer
{
    import std.datetime.stopwatch : StopWatch;

    private StopWatch sw;
    private size_t fc;

    void start() { sw.start(); }
    void stop() { sw.stop(); }

    auto frame() {
        static struct FrameTimer
        {
            StopWatch* sw;
            this(StopWatch* sw)
            {
                this.sw = sw;
                sw.start();
            }
            ~this()
            {
                if (this.sw) {
                    sw.stop();
                }
            }
        }
        ++fc;
        return FrameTimer(&sw);
    }

    @property Duration totalDur()
    {
        return sw.peek;
    }

    @property Duration avgDur()
    {
        return sw.peek / fc;
    }

    @property size_t framecount()
    {
        return fc;
    }
}

shared static this()
{
    import gfx.core.log : Severity, severity;
    severity = Severity.trace;

    debug(rc) {
        import gfx.core.rc : rcPrintStack, rcTypeRegex;
        rcPrintStack = true;
        rcTypeRegex = "^GlDevice$";
    }
}

class Example : Disposable
{
    import gfx.math.proj : NDC;

    string title;
    string[] args;
    Rc!Display display;
    Window window;
    Rc!Instance instance;
    NDC ndc;
    PhysicalDevice physicalDevice;
    Rc!Device device;
    Queue graphicsQueue;
    Queue presentQueue;
    uint[2] surfaceSize;
    bool hasAlpha;
    Rc!Swapchain swapchain;
    Rc!Semaphore imageAvailableSem;
    Rc!Semaphore renderingFinishSem;
    uint frameNumber;
    FrameData[] frameDatas;
    FpsProbe probe;

    // garbage collection
    // it is sometimes desirable to delete objects still in use in a command
    // buffer (this happens when rebuilding the swapchain for example)
    // each entry is given an optional fence to check for the command buffer
    // completion, and if the fence is null, it checks that the garbage
    // was not emitted more than maxFcAge frames ago.
    GarbageEntry garbageEntries;
    GarbageEntry lastGarbageEntry;
    enum maxFcAge = 4;

    class GarbageEntry
    {
        GarbageEntry next;
        uint fc;
        Fence fence;
        IAtomicRefCounted resource;
    }

    this (string title, string[] args=[])
    {
        this.title = title;
        this.args = args;
    }

    override void dispose()
    {
        probe.stop();
        if (device) {
            device.waitIdle();
        }
        while (garbageEntries) {
            if (garbageEntries.fence) {
                garbageEntries.fence.wait();
                releaseObj(garbageEntries.fence);
            }
            releaseObj(garbageEntries.resource);
            garbageEntries = garbageEntries.next;
        }
        releaseArr(frameDatas);
        // the rest is checked with Rc, so it is safe to call unload even
        // if object is invalid
        imageAvailableSem.unload();
        renderingFinishSem.unload();
        swapchain.unload();
        device.unload();
        // if (window) window.close();
        instance.unload();
        display.unload();
    }

    void prepare()
    {
        bool noVulkan = false;
        bool noGl3 = false;
        bool noWayland = false;
        foreach (a; args) {
            if (a == "--no-vulkan" || a == "nv") {
                noVulkan = true;
            }
            else if (a == "--no-gl3" || a == "ng") {
                noGl3 = true;
            }
            else if (a == "--no-wayland" || a == "nw") {
                noWayland = true;
            }
        }

        import std.algorithm : remove;

        DisplayCreateInfo createInfo;
        if (noVulkan) {
            createInfo.backendCreateOrder =
                    createInfo.backendCreateOrder.remove(Backend.vulkan);
        }
        if (noGl3) {
            createInfo.backendCreateOrder =
                    createInfo.backendCreateOrder.remove(Backend.gl3);
        }
        if (noWayland) {
            createInfo.linuxDisplayCreateOrder =
                    createInfo.linuxDisplayCreateOrder.remove(LinuxDisplay.wayland);
        }

        // Create a display for the running platform
        // The instance is created by the display. Backend is chosen at runtime
        // depending on detected API support. (i.e. Vulkan is preferred)
        display = createDisplay(createInfo);
        instance = display.instance;
        ndc = instance.apiProps.ndc;

        // Create a window. The surface is created during the call to show.
        window = display.createWindow(title);
        window.show(640, 480);
        surfaceSize = [640, 480];

        window.onResize = (uint w, uint h)
        {
            if (w != surfaceSize[0] || h != surfaceSize[1]) {
                surfaceSize = [ w, h ];
                rebuildSwapchain();
            }
        };

        debug {
            alias Sev = gfx.graal.Severity;
            instance.setDebugCallback((Sev sev, string msg) {
                import std.stdio : writefln;
                if (sev >= Sev.warning) {
                    writefln("Gfx backend %s message: %s", sev, msg);
                }
                if (sev == Sev.error) {
                    // debug break;
                    asm { int 0x03; }
                }
            });
        }

        // The rest of the preparation.
        prepareDevice();
        prepareSync();
        prepareSwapchain(null);
        prepareRenderPass();
        prepareFramebuffers();

        probe.start();
    }

    Duration timeElapsed()
    {
        assert(probe.sw.running(), "stopwatch isn't running!!");
        return probe.sw.peek();
    }

    void prepareDevice()
    {
        auto graphicsQueueIndex = uint.max;
        auto presentQueueIndex = uint.max;

        bool checkDevice(PhysicalDevice dev) {
            if (dev.softwareRendering) return false;
            foreach (size_t i, qf; dev.queueFamilies) {
                const qi = cast(uint)i;
                const graphics = qf.cap & QueueCap.graphics;
                const present = dev.supportsSurface(qi, window.surface);
                if (graphics && present) {
                    graphicsQueueIndex = qi;
                    presentQueueIndex = qi;
                    return true;
                }
                if (graphics) graphicsQueueIndex = qi;
                if (present) presentQueueIndex = qi;
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

    void prepareSync()
    {
        imageAvailableSem = device.createSemaphore();
        renderingFinishSem = device.createSemaphore();
    }

    void prepareSwapchain(Swapchain former=null)
    {
        gfxExLog.infof("building swapchain %sx%s", surfaceSize[0], surfaceSize[1]);

        const surfCaps = physicalDevice.surfaceCaps(window.surface);
        enforce(surfCaps.usage & ImageUsage.transferDst, "TransferDst not supported by surface");
        enforce(surfCaps.usage & ImageUsage.colorAttachment, "ColorAttachment not supported by surface");
        const usage = ImageUsage.colorAttachment | ImageUsage.transferDst;
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

        foreach (i; 0..2) {
            surfaceSize[i] = clamp(surfaceSize[i], surfCaps.minSize[i], surfCaps.maxSize[i]);
        }
        const pm = choosePresentMode(physicalDevice, window.surface);

        swapchain = device.createSwapchain(window.surface, pm, numImages, f, surfaceSize, usage, ca, former);
    }

    void prepareRenderPass()
    {}

    /// Data that is duplicated for every frame in the swapchain
    /// This typically include framebuffer and command pool.
    abstract class FrameData : AtomicRefCounted
    {
        Rc!Fence fence; // to keep track of when command processing is done
        Rc!CommandPool cmdPool;

        ImageBase swcColor;
        uint[2] size;

        this(ImageBase swcColor)
        {
            this.fence = device.createFence(Yes.signaled);
            this.cmdPool = device.createCommandPool(graphicsQueue.index);

            this.swcColor = swcColor;
            const dims = swcColor.info.dims;
            size = [dims.width, dims.height];
        }

        override void dispose()
        {
            fence.unload();
            cmdPool.unload();
        }
    }

    /// Instantiate FrameData implementation for the given swapchain color image.
    /// tempBuf is a helper that can be used to transfer data, change images layout...
    /// it is submitted and waited for shortly after FrameData is built.
    abstract FrameData makeFrameData(ImageBase swcColor, CommandBuffer tempBuf);

    void prepareFramebuffers()
    {
        auto swcImages = swapchain.images;
        frameDatas = new FrameData[swcImages.length];

        auto tempBuf = rc(new RaiiCmdBuf);

        foreach(i, img; swcImages) {
            frameDatas[i] = retainObj(makeFrameData(img, tempBuf.get));
        }
    }

    /// Record buffer implementation for the current frame.
    /// Returns the submissions for the graphics queue
    /// the first submission that renders to the swapchain image must
    /// wait for imageAvailableSem
    /// the last submission must signal renderingFinishSem
    abstract Submission[] recordCmds(FrameData frameData);

    /// build a submission for the simplest cases with one submission
    final Submission[] simpleSubmission(PrimaryCommandBuffer[] cmdBufs)
    {
        return [
            Submission (
                [ StageWait(imageAvailableSem, PipelineStage.transfer) ],
                [ renderingFinishSem.obj ], cmdBufs
            )
        ];
    }

    void render()
    {
        import gfx.graal.error : OutOfDateException;

        const acq = swapchain.acquireNextImage(imageAvailableSem.obj);

        if (acq.hasIndex) {
            auto frameData = frameDatas[acq.index];
            frameData.fence.wait();
            frameData.fence.reset();

            auto submissions = recordCmds(frameData);

            graphicsQueue.submit(submissions, frameData.fence);

            try {
                presentQueue.present(
                    [ renderingFinishSem.obj ],
                    [ PresentRequest(swapchain, acq.index) ]
                );
            }
            catch (OutOfDateException ex) {
                // The swapchain became out of date between acquire and present.
                // Rare, but can happen
                gfxExLog.errorf("error during presentation: %s", ex.msg);
                gfxExLog.errorf("acquisition was %s", acq.state);
                rebuildSwapchain();
                return;
            }
        }

        if (acq.swapchainNeedsRebuild) {
            rebuildSwapchain();
        }
    }

    void rebuildSwapchain()
    {
        foreach (imgData; frameDatas) {
            gc(imgData, imgData.fence);
        }
        releaseArr(frameDatas);
        prepareSwapchain(swapchain.obj);
        prepareFramebuffers();
    }

    void frameTick()
    {
        frameNumber += 1;
        collectGarbage();

        enum reportPeriod = 300;
        probe.tick();
        if (probe.framecount % reportPeriod == 0) {
            gfxExLog.infof("FPS = %s", probe.computeFps());
        }
    }

    void gc(IAtomicRefCounted resource, Fence fence=null)
    {
        auto entry = new GarbageEntry;
        entry.resource = retainObj(resource);
        if (fence) entry.fence = retainObj(fence);
        entry.fc = frameNumber;

        if (lastGarbageEntry) {
            lastGarbageEntry.next = entry;
            lastGarbageEntry = entry;
        }
        else {
            assert(!garbageEntries);
            garbageEntries = entry;
            lastGarbageEntry = entry;
        }
    }

    void collectGarbage()
    {
        while (garbageEntries) {
            if ((garbageEntries.fence && garbageEntries.fence.signaled) ||
                (garbageEntries.fc+maxFcAge < frameNumber))
            {
                if (garbageEntries.fence) releaseObj(garbageEntries.fence);
                releaseObj(garbageEntries.resource);
                garbageEntries = garbageEntries.next;
            }
            else {
                break;
            }
        }
        if (!garbageEntries) lastGarbageEntry = null;
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

    /// Find a supported stencil format
    Format findStencilFormat() {
        return findSupportedFormat(
            [ Format.s8_uInt, Format.d16s8_uNorm, Format.d24s8_uNorm, Format.d32s8_sFloat ],
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

        auto b = rc(new RaiiCmdBuf);

        // copy from staging buffer
        copyBuffer(stagingBuf, buf, dataSize, b.cmdBuf);

        // return data
        return buf.giveAway();
    }

    /// ditto
    Buffer createStaticBuffer(T)(const(T)[] data, BufferUsage usage)
    if (!is(T == void))
    {
        return createStaticBuffer(untypeSlice(data), usage);
    }

    /// ditto
    Buffer createStaticBuffer(T)(in T data, BufferUsage usage)
    if (!isArray!T)
    {
        const start = cast(const(void)*)&data;
        return createStaticBuffer(start[0 .. data.sizeof], usage);
    }

    bool bindImageMemory(Image img, MemProps props=MemProps.deviceLocal) {
        const mr = img.memoryRequirements;
        const memTypeInd = findMemType(mr, props);
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
            auto b = rc(new RaiiCmdBuf);

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
        const f = findStencilFormat();
        // create an image
        auto img = enforce(device.createImage(
            ImageInfo.d2(width, height).withFormat(f).withUsage(ImageUsage.depthStencilAttachment)
        )).rc;

        // allocate memory image
        if (!bindImageMemory(img)) return null;

        return img.giveAway();
    }

    final void recordImageLayoutBarrier(CommandBuffer cmdBuf, ImageBase img, Trans!ImageLayout layout)
    {
        const info = img.info;

        if (info.usage & ImageUsage.colorAttachment)
        {
            cmdBuf.pipelineBarrier(
                trans(PipelineStage.colorAttachmentOutput, PipelineStage.colorAttachmentOutput), [],
                [ ImageMemoryBarrier(
                    trans(Access.none, Access.colorAttachmentWrite),
                    layout,
                    trans(queueFamilyIgnored, queueFamilyIgnored),
                    img, ImageSubresourceRange(ImageAspect.color)
                ) ]
            );
        }
        else if (info.usage & ImageUsage.depthStencilAttachment)
        {
            const hasDepth = formatDesc(info.format).surfaceType.depthBits > 0;
            const hasStencil = formatDesc(info.format).surfaceType.stencilBits > 0;
            auto aspect = ImageAspect.none;
            if (hasDepth) aspect |= ImageAspect.depth;
            if (hasStencil) aspect |= ImageAspect.stencil;
            cmdBuf.pipelineBarrier(
                trans(PipelineStage.topOfPipe, PipelineStage.earlyFragmentTests), [], [
                    ImageMemoryBarrier(
                        trans(
                            Access.none,
                            Access.depthStencilAttachmentRead | Access.depthStencilAttachmentWrite
                        ),
                        layout,
                        trans(queueFamilyIgnored, queueFamilyIgnored),
                        img, ImageSubresourceRange(aspect)
                    )
                ]
            );
        }
        else {
            import std.format : format;
            throw new Exception(
                format("don't know how to record memory barrier for image usage %s", info.usage)
            );
        }
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

    /// Utility command buffer for a one time submission that automatically submit
    /// when disposed.
    /// Generally used for transfer operations, or image layout change.
    final class RaiiCmdBuf : AtomicRefCounted
    {
        Rc!CommandPool pool;
        PrimaryCommandBuffer cmdBuf;

        this() {
            this.pool = device.createCommandPool(graphicsQueue.index);
            this.cmdBuf = this.pool.allocatePrimary(1)[0];
            this.cmdBuf.begin(CommandBufferUsage.oneTimeSubmit);
        }

        override void dispose() {
            this.cmdBuf.end();
            graphicsQueue.submit([
                Submission([], [], (&this.cmdBuf)[0 .. 1])
            ], null);
            graphicsQueue.waitIdle();
            auto cb = cast(CommandBuffer)this.cmdBuf;
            this.pool.free((&cb)[0 .. 1]);
            this.pool.unload();
        }

        @property CommandBuffer get()
        {
            return cmdBuf;
        }
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
