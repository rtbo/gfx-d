module highlevel;

private:

import gfx.core.rc : Disposable;

shared static this()
{
    debug(rc) {
        import gfx.core.log : Severity, severity;
        import gfx.core.rc : rcPrintStack, rcTypeRegex;

        severity = Severity.trace;
        rcPrintStack = true;
        rcTypeRegex = "^VulkanDescriptorSetLayout$";
    }
}

final class HighLevel : Disposable
{
    import gfx.core.rc : Rc;
    import gfx.graal : Instance;
    import gfx.graal.buffer : Buffer;
    import gfx.graal.cmd : CommandBuffer;
    import gfx.graal.image : Image, ImageView;
    import gfx.graal.pipeline : DescriptorPool, DescriptorSet, DescriptorSetLayout, Pipeline, PipelineLayout;
    import gfx.graal.renderpass : Framebuffer, RenderPass;
    import gfx.hl.device : GraphicsDevice, openGraphicsDevice;
    import gfx.hl.surface : chooseSurfaceFormat, GraphicsSurface;
    import gfx.math : FMat4, FVec3, FVec4, NDC;
    import gfx.window : createDisplay, Display, Window;

    string title;
    string[] args;
    Rc!Display display;
    Window window;
    Rc!Instance instance;
    Rc!GraphicsDevice device;
    Rc!GraphicsSurface surface;
    NDC ndc;
    size_t cubeLen;
    enum cubeCount = 3;
    const(ushort)[] indices;
    Rc!Buffer vertBuf;
    Rc!Buffer indBuf;
    Rc!Buffer matBuf;
    Rc!Buffer ligBuf;
    Rc!RenderPass renderPass;
    PerImage[] framebuffers;
    Rc!Pipeline pipeline;
    Rc!PipelineLayout layout;
    Rc!DescriptorPool descPool;
    Rc!DescriptorSetLayout setLayout;
    DescriptorSet set;
    CommandBuffer[] cmdBufs;

    override void dispose()
    {
        import gfx.core.rc : disposeArr;
        device.waitIdle();
        layout.unload();
        setLayout.unload();
        descPool.unload();
        pipeline.unload();
        renderPass.unload();
        ligBuf.unload();
        matBuf.unload();
        indBuf.unload();
        vertBuf.unload();
        disposeArr(framebuffers);
        surface.unload();
        device.unload();
        instance.unload();
        display.unload();
    }

    class PerImage : Disposable
    {
        Rc!Image        depth;
        Rc!ImageView    depthView;
        Rc!Framebuffer  framebuffer;

        override void dispose()
        {
            depth.unload();
            depthView.unload();
            framebuffer.unload();
        }
    }

    struct Vertex
    {
        FVec3 position;
        FVec3 normal;
        FVec4 color;
    }

    struct Matrices
    {
        FMat4 mvp;
        FMat4 normal;
    }

    enum maxLights = 5;

    struct Light
    {
        FVec4 direction;
        FVec4 color;
    }

    struct Lights
    {
        Light[maxLights] lights;
        uint num;
    }

    this (string title, string[] args=[])
    {
        this.title = title;
        this.args = args;
    }

    void prepare()
    {
        import gfx.graal : Backend, Severity;
        import gfx.graal.presentation : PresentMode;
        import gfx.hl.device : findGraphicsDevice;
        import std.exception : enforce;

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

        // Create a display for the running platform.
        // The instance is created by the display. Backend is chosen at runtime
        // depending on detected API support. (i.e. Vulkan is preferred)
        display = createDisplay(backendLoadOrder);
        instance = display.instance;
        ndc = instance.apiProps.ndc;
        // Create a window. The surface is created during the call to show.
        window = display.createWindow();
        window.show(640, 480);

        instance.setDebugCallback((Severity sev, string msg) {
            import std.stdio : writefln;
            if (sev >= Severity.warning) {
                writefln("Gfx backend %s message: %s", sev, msg);
            }
            if (sev == Severity.error) {
                // debug break
                asm { int 0x03; }
            }
        });

        device = openGraphicsDevice(instance.obj, window.surface);
        const format = chooseSurfaceFormat(device.physicalDevice, window.surface);
        surface = new GraphicsSurface(device, window.surface, format, PresentMode.fifo);
        surface.rebuild([640, 480]);

        cmdBufs = device.graphicsCmdPool.allocate(surface.numImages);

        prepareBuffers();
        prepareRenderPass();
        prepareFramebuffers();
        preparePipeline();
        prepareDescriptorSet();
    }

    void prepareBuffers()
    {
        import gfx.genmesh.cube : genCube;
        import gfx.genmesh.algorithm : indexCollectMesh, triangulate, vertices;
        import gfx.genmesh.poly : quad;
        import gfx.graal.buffer : BufferUsage;
        import gfx.math : normalize, fvec;
        import std.algorithm : map;

        const cube = genCube()
                .map!(f => quad(
                    Vertex( fvec(f[0].p), fvec(f[0].n) ),
                    Vertex( fvec(f[1].p), fvec(f[1].n) ),
                    Vertex( fvec(f[2].p), fvec(f[2].n) ),
                    Vertex( fvec(f[3].p), fvec(f[3].n) ),
                ))
                .triangulate()
                .vertices()
                .indexCollectMesh();

        cubeLen = cube.vertices.length;

        const red   = fvec( 1f, 0f, 0f, 1f );
        const green = fvec( 0f, 1f, 0f, 1f );
        const blue  = fvec( 0f, 0f, 1f, 1f );
        const colors = [ red, green, blue ];

        Vertex[] verts;
        foreach (c; 0 .. cubeCount) {
            verts ~= cube.vertices;
            const color = colors[c % 3];
            foreach (v; 0 .. cubeLen) {
                verts[$ - cubeLen + v].color = color;
            }
        }

        indices = cube.indices;
        vertBuf = device.createStaticBuffer(verts, BufferUsage.vertex);
        indBuf = device.createStaticBuffer(indices, BufferUsage.index);

        const lights = Lights( [
            Light(normalize(fvec(1.0, 1.0, -1.0, 0.0)),  fvec(0.8, 0.5, 0.2, 1.0)),
            Light(normalize(fvec(-1.0, 1.0, -1.0, 0.0)), fvec(0.2, 0.5, 0.8, 1.0)),
            Light.init, Light.init, Light.init
        ], 2);

        matBuf = device.createDynamicBuffer(
                cubeCount * Matrices.sizeof, BufferUsage.uniform);
        ligBuf = device.createStaticBuffer(lights, BufferUsage.uniform);
    }

    void prepareRenderPass()
    {
        import gfx.core.typecons : some;
        import gfx.graal.image : ImageLayout;
        import gfx.graal.renderpass : AttachmentDescription, AttachmentOps,
                                      AttachmentRef, LoadOp, StoreOp,
                                      SubpassDescription;
        import gfx.graal.types : trans;
        import std.typecons : No;

        const attachments = [
            AttachmentDescription(surface.format, 1,
                AttachmentOps(LoadOp.clear, StoreOp.store),
                AttachmentOps(LoadOp.dontCare, StoreOp.dontCare),
                trans(ImageLayout.presentSrc, ImageLayout.presentSrc),
                No.mayAlias
            ),
            AttachmentDescription(device.findDepthFormat(), 1,
                AttachmentOps(LoadOp.clear, StoreOp.dontCare),
                AttachmentOps(LoadOp.dontCare, StoreOp.dontCare),
                trans(ImageLayout.undefined, ImageLayout.depthStencilAttachmentOptimal),
                No.mayAlias
            )
        ];
        const subpasses = [
            SubpassDescription(
                [], [ AttachmentRef(0, ImageLayout.colorAttachmentOptimal) ],
                some(AttachmentRef(1, ImageLayout.depthStencilAttachmentOptimal)),
                []
            )
        ];

        renderPass = device.createRenderPass(attachments, subpasses, []);
    }

    void prepareFramebuffers()
    {
        import gfx.core.rc : rc;
        import gfx.graal.cmd : Access, ImageMemoryBarrier, PipelineStage, queueFamilyIgnored;
        import gfx.graal.format : formatDesc, stencilBits;
        import gfx.graal.image : ImageAspect, ImageLayout, ImageSubresourceRange, ImageType, Swizzle;
        import gfx.graal.types : trans;

        auto b = device.autoCmdBuf().rc;

        const sz = surface.size;

        foreach (i; 0 .. surface.numImages) {
            auto pi = new PerImage;
            pi.depth = device.createDepthImage(sz[0], sz[1]);
            pi.depthView = pi.depth.createView(
                ImageType.d2, ImageSubresourceRange(ImageAspect.depth), Swizzle.identity
            );
            pi.framebuffer = device.createFramebuffer(renderPass, [
                surface.view(i), pi.depthView.obj
            ], sz[0], sz[1], 1);

            b.cmdBuf.pipelineBarrier(
                trans(PipelineStage.colorAttachmentOutput, PipelineStage.colorAttachmentOutput), [],
                [ ImageMemoryBarrier(
                    trans(Access.none, Access.colorAttachmentWrite),
                    trans(ImageLayout.undefined, ImageLayout.presentSrc),
                    trans(queueFamilyIgnored, queueFamilyIgnored),
                    surface.image(i), ImageSubresourceRange(ImageAspect.color)
                ) ]
            );

            const hasStencil = formatDesc(pi.depth.info.format).surfaceType.stencilBits > 0;
            const aspect = hasStencil ? ImageAspect.depthStencil : ImageAspect.depth;
            b.cmdBuf.pipelineBarrier(
                trans(PipelineStage.topOfPipe, PipelineStage.earlyFragmentTests), [], [
                    ImageMemoryBarrier(
                        trans(Access.none, Access.depthStencilAttachmentRead | Access.depthStencilAttachmentWrite),
                        trans(ImageLayout.undefined, ImageLayout.depthStencilAttachmentOptimal),
                        trans(queueFamilyIgnored, queueFamilyIgnored),
                        pi.depth, ImageSubresourceRange(aspect)
                    )
                ]
            );

            framebuffers ~= pi;
        }
    }

    void preparePipeline()
    {
        import gfx.core.rc : rc;
        import gfx.core.typecons : none;
        import gfx.graal.format : Format;
        import gfx.graal.pipeline : BlendFactor, BlendOp, BlendState, ColorBlendAttachment, ColorBlendInfo, ColorMask, CompareOp, Cull, DepthBias, DepthInfo, FrontFace, DescriptorType, DynamicState, InputAssembly, LogicOp, PipelineInfo, PipelineLayoutBinding, PolygonMode, Primitive, Rasterizer, ShaderModule, ShaderStage, VertexInputAttrib, VertexInputBinding;
        import gfx.graal.types : trans;
        import std.typecons : No, Yes;

        Rc!ShaderModule vtxShader;
        Rc!ShaderModule fragShader;

        vtxShader = device.createShaderModule(
            cast(immutable(uint)[])import("shader.vert.spv"), "main"
        );
        fragShader = device.createShaderModule(
            cast(immutable(uint)[])import("shader.frag.spv"), "main"
        );

        const layoutBindings = [
            PipelineLayoutBinding(0, DescriptorType.uniformBufferDynamic, 1, ShaderStage.vertex),
            PipelineLayoutBinding(1, DescriptorType.uniformBuffer, 1, ShaderStage.fragment),
        ];

        setLayout = device.createDescriptorSetLayout(layoutBindings);
        layout = device.createPipelineLayout( [ setLayout.obj ], []);

        PipelineInfo info;
        info.shaders.vertex = vtxShader;
        info.shaders.fragment = fragShader;
        info.inputBindings = [
            VertexInputBinding(0, Vertex.sizeof, No.instanced)
        ];
        info.inputAttribs = [
            VertexInputAttrib(0, 0, Format.rgb32_sFloat, 0),
            VertexInputAttrib(1, 0, Format.rgb32_sFloat, Vertex.normal.offsetof),
            VertexInputAttrib(2, 0, Format.rgba32_sFloat, Vertex.color.offsetof),
        ];
        info.assembly = InputAssembly(Primitive.triangleList, No.primitiveRestart);
        info.rasterizer = Rasterizer(
            PolygonMode.fill, Cull.back, FrontFace.ccw, No.depthClamp,
            none!DepthBias, 1f
        );
        // info.viewports = [
        //     ViewportConfig(
        //         Viewport(0, 0, cast(float)surfaceSize[0], cast(float)surfaceSize[1]),
        //         Rect(0, 0, surfaceSize[0], surfaceSize[1])
        //     )
        // ];
        info.depthInfo = DepthInfo(
            Yes.enabled, Yes.write, CompareOp.less, No.boundsTest, 0f, 1f
        );
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
        info.dynamicStates = [ DynamicState.viewport, DynamicState.scissor ];
        info.layout = layout.obj;
        info.renderPass = renderPass.obj;
        info.subpassIndex = 0;

        auto pls = device.createPipelines( [info] );
        pipeline = pls[0];
    }

    void prepareDescriptorSet()
    {
        import gfx.graal.pipeline : BufferRange, DescriptorPoolSize, DescriptorType, UniformBufferDescWrites, UniformBufferDynamicDescWrites, WriteDescriptorSet;

        const poolSizes = [
            DescriptorPoolSize(DescriptorType.uniformBufferDynamic, 1),
            DescriptorPoolSize(DescriptorType.uniformBuffer, 1),
        ];
        descPool = device.createDescriptorPool(1, poolSizes);
        set = descPool.allocate([ setLayout.obj ])[0];

        auto writes = [
            WriteDescriptorSet(set, 0, 0, new UniformBufferDynamicDescWrites([
                BufferRange(matBuf, 0, Matrices.sizeof),
            ])),
            WriteDescriptorSet(set, 1, 0, new UniformBufferDescWrites([
                BufferRange(ligBuf, 0, Lights.sizeof)
            ])),
        ];
        device.updateDescriptorSets(writes, []);
    }

    void updateMatrices(in Matrices[] mat)
    {
        import gfx.graal.device : MappedMemorySet;

        auto mm = matBuf.boundMemory.map();
        auto v = mm.view!(Matrices[])(0, mat.length);
        v[] = mat;
        MappedMemorySet mms;
        mm.addToSet(mms);
        device.flushMappedMemory(mms);
    }

    void render()
    {
        import gfx.graal.buffer : IndexType;
        import gfx.graal.cmd : ClearColorValues, ClearDepthStencilValues,
                               ClearValues, PipelineBindPoint, PipelineStage,
                               VertexBinding;
        import gfx.graal.queue : PresentRequest, StageWait, Submission;
        import gfx.graal.types : Rect, trans, Viewport;
        import std.typecons : No;

        const acq = surface.acquireNextImage();

        if (acq.hasIndex) {

            const imgInd = acq.index;

            auto fence = surface.fence(imgInd);
            fence.wait();
            fence.reset();

            const ccv = ClearColorValues(0.6f, 0.6f, 0.6f, 0.5f);
            const dcv = ClearDepthStencilValues(1f, 0);
            const sz = surface.size;

            auto buf = cmdBufs[imgInd];
            auto fb = framebuffers[imgInd];

            buf.begin(No.persistent);

            buf.setViewport(0, [ Viewport(0f, 0f, cast(float)sz[0], cast(float)sz[1]) ]);
            buf.setScissor(0, [ Rect(0, 0, sz[0], sz[1]) ]);

            buf.beginRenderPass(
                renderPass, fb.framebuffer,
                Rect(0, 0, sz[0], sz[1]), [ ClearValues(ccv), ClearValues(dcv) ]
            );

            buf.bindPipeline(pipeline);
            buf.bindIndexBuffer(indBuf, 0, IndexType.u16);
            foreach(c; 0 .. cubeCount) {
                buf.bindVertexBuffers(0, [ VertexBinding(vertBuf, Vertex.sizeof*c*cubeLen) ]);
                buf.bindDescriptorSets(PipelineBindPoint.graphics, layout, 0, [ set ], [c * Matrices.sizeof]);
                buf.drawIndexed(cast(uint)indices.length, 1, 0, 0, 0);
            }

            buf.endRenderPass();

            buf.end();

            device.graphicsQueue().submit([
                Submission (
                    [ StageWait(surface.imageAvailSem, PipelineStage.transfer) ],
                    [ surface.renderingDoneSem ], [ buf ]
                )
            ], fence );

            device.presentQueue.present(
                [ surface.renderingDoneSem ],
                [ PresentRequest(surface.swapchain, imgInd) ]
            );
        }

    }

}

void main(string[] args)
{
    import gfx.hl.util : FpsProbe;
    import gfx.math : affineInverse, fvec, lookAt, perspective, rotation,
                      translation, transpose;
    import std.math : PI;
    import std.stdio : writeln;

    auto example = new HighLevel("High-Level example", args);
    scope(exit) example.dispose();

    example.prepare();

    example.window.onMouseOn = (uint, uint) {
        example.window.closeFlag = true;
    };

    enum reportFreq = 100;

    // 6 RPM at 60 FPS
    const puls = 6 * 2*PI / 3600f;
    auto angle = 0f;
    const view = lookAt(fvec(0, -7, 2), fvec(0, 0, 0), fvec(0, 0, 1));
    const proj = perspective(example.ndc, 45f, 4f/3f, 1f, 10f);
    const viewProj = proj*view;

    HighLevel.Matrices[3] matrices;

    FpsProbe fps;
    fps.start();

    while (!example.window.closeFlag) {

        import gfx.math.inverse : affineInverse;

        foreach (m; 0 .. 3) {
            const posAngle = cast(float)(m * 2f * PI / 3f);
            const model = rotation(posAngle + angle, fvec(0, 0, 1))
                    * translation(2f, 0f, 0f)
                    * rotation(-angle, fvec(0, 0, 1));
            const mvp = viewProj*model;
            matrices[m] = HighLevel.Matrices(
                mvp.transpose(),
                model.affineInverse(), // need the transpose of model inverse
            );
        }

        example.updateMatrices(matrices);

        angle += puls;

        example.render();
        fps.tick();
        if ((fps.framecount % reportFreq) == 0) {
            writeln("FPS: ", fps.computeFps());
        }
        example.display.pollAndDispatch();
    }
}
