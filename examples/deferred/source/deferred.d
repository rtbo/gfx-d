module deferred;

import example;
import pipeline;
import scene;

import gfx.core;
import gfx.graal;
import gfx.math;
import gfx.window;

import std.datetime : Duration;
import std.stdio;


class DeferredExample : Example
{
    /// per frame UBO for the geom pipeline
    struct GeomFrameUbo
    {
        FMat4 viewProj = FMat4.identity;
    }
    /// per draw call UBO for the geom pipeline
    struct GeomModelData
    {
        FMat4 model = FMat4.identity;
        FVec4 color = fvec(0, 0, 0, 1);
        float[4] pad; // 32 bytes alignment for dynamic offset
    }
    /// ditto
    struct GeomModelUbo
    {
        GeomModelData[3] data;
    }
    /// per frame UBO for the light pipeline
    struct LightFrameUbo
    {
        FVec4 viewerPos = fvec(0, 0, 0, 1);
    }
    /// per draw call UBO for the light pipeline
    struct LightModelUbo
    {
        FMat4 modelViewProj = FMat4.identity;
        FVec4 position = fvec(0, 0, 0, 1);
        FVec4 color = fvec(0, 0, 0, 1);
        float radius = 1f;
        float[7] pad; // 32 bytes alignment for dynamic offset
    }
    static assert(LightModelUbo.sizeof == FMat4.sizeof + 4*FVec4.sizeof);

    struct UboBuffer(T)
    {
        T[] data; // copy on host
        Rc!Buffer buffer;
        MemoryMap mmap;

        void initBuffer(DeferredExample ex)
        {
            buffer = ex.createDynamicBuffer(data.length * T.sizeof, BufferUsage.uniform);
            mmap = buffer.boundMemory.map();
        }

        void updateBuffer(ref MappedMemorySet mms)
        {
            auto v = mmap.view!(T[])(0, data.length);
            v[] = data;
            mmap.addToSet(mms);
        }


        void release()
        {
            import std.algorithm : move;

            move(mmap);
            buffer.unload();
        }
    }

    struct MeshBuffer
    {
        Rc!Buffer indexBuf;
        Rc!Buffer vertexBuf;
        Interval!size_t indices;
        Interval!size_t vertices;

        @property uint indicesCount()
        {
            return cast(uint)indices.length / ushort.sizeof;
        }

        void bindIndex(CommandBuffer cmd)
        {
            cmd.bindIndexBuffer(indexBuf, indices.start, IndexType.u16);
        }

        VertexBinding vertexBinding()
        {
            return VertexBinding(
                vertexBuf.obj, vertices.start,
            );
        }

        void release()
        {
            indexBuf.unload();
            vertexBuf.unload();
        }
    }


    Rc!RenderPass renderPass;
    Rc!DescriptorPool descriptorPool;

    Rc!DeferredPipelines pipelines;

    DescriptorSet geomDescriptorSet;

    DescriptorSet lightBufDescriptorSet;
    DescriptorSet lightAttachDescriptorSet;

    MeshBuffer hiResSphere;
    MeshBuffer loResSphere;
    UboBuffer!GeomFrameUbo geomFrameUbo;
    UboBuffer!GeomModelUbo geomModelUbo;
    UboBuffer!LightFrameUbo lightFrameUbo;
    UboBuffer!LightModelUbo lightModelUbo;

    Duration lastTimeElapsed;

    DeferredScene scene;
    FMat4 viewProj;
    FVec3 viewerPos;

    this(string[] args) {
        super("Deferred", args);
    }

    override void dispose()
    {
        if (device)
            device.waitIdle();
        renderPass.unload();
        descriptorPool.reset();
        descriptorPool.unload();
        pipelines.unload();
        hiResSphere.release();
        loResSphere.release();
        geomFrameUbo.release();
        geomModelUbo.release();
        lightFrameUbo.release();
        lightModelUbo.release();

        super.dispose();
    }

    override void prepare()
    {
        super.prepare();
        const rad = scene.prepare();
        prepareBuffers();
        pipelines = new DeferredPipelines(device, renderPass);
        prepareDescriptors();

        viewerPos = fvec(rad, rad, rad);
        const view = lookAt(viewerPos, fvec(0, 0, 0), fvec(0, 0, 1));
        const proj = perspective!float(this.ndc, 45, 4f/3f, 1f, rad * 3f);
        viewProj = proj * view;
    }

    final void prepareBuffers()
    {
        prepareMeshBuffers();
        prepareUboBuffers();
    }

    final void prepareMeshBuffers()
    {
        import std.algorithm : map;
        import std.array : array;

        const hiRes = buildUvSpheroid(fvec(0, 0, 0), 1f, 1f, 15);
        const loRes = buildUvSpheroid(fvec(0, 0, 0), 1f, 1f, 6);

        Rc!Buffer indexBuf = createStaticBuffer(hiRes.indices ~ loRes.indices, BufferUsage.index);

        const hiResData = cast(const(ubyte)[])hiRes.vertices;
        const loResTemp = loRes.vertices.map!(v => v.pos).array;
        const loResData = cast(const(ubyte)[])loResTemp;
        Rc!Buffer vertexBuf = createStaticBuffer(hiResData ~ loResData, BufferUsage.vertex);

        const hiResI = hiRes.indices.length * ushort.sizeof;
        const hiResV = hiRes.vertices.length * Vertex.sizeof;

        hiResSphere.indexBuf = indexBuf;
        hiResSphere.vertexBuf = vertexBuf;
        hiResSphere.indices = interval(0, hiResI);
        hiResSphere.vertices = interval(0, hiResV);

        loResSphere.indexBuf = indexBuf;
        loResSphere.vertexBuf = vertexBuf;
        loResSphere.indices = interval(hiResI, hiResI + loRes.indices.length * ushort.sizeof);
        loResSphere.vertices = interval(hiResV, hiResV + loRes.vertices.length * FVec3.sizeof);
    }

    final void prepareUboBuffers()
    {
        const count = scene.saucerCount();

        geomFrameUbo.data = new GeomFrameUbo[1];
        geomModelUbo.data = new GeomModelUbo[count];
        lightFrameUbo.data = new LightFrameUbo[1];
        lightModelUbo.data = new LightModelUbo[count];

        geomFrameUbo.initBuffer(this);
        geomModelUbo.initBuffer(this);
        lightFrameUbo.initBuffer(this);
        lightModelUbo.initBuffer(this);
    }

    override void prepareRenderPass()
    {
        enum Attachment {
            worldPos,
            normal,
            color,
            depth,
            swcColor,

            count,
        }
        enum Subpass {
            geom,
            light,
            bulb,

            count,
        }

        auto attachments = new AttachmentDescription[Attachment.count];
        auto subpasses = new SubpassDescription[Subpass.count];

        attachments[Attachment.worldPos] = AttachmentDescription.color(
            Format.rgba32_sFloat, AttachmentOps(LoadOp.clear, StoreOp.store),
            trans(ImageLayout.undefined, ImageLayout.colorAttachmentOptimal)
        );
        attachments[Attachment.normal] = AttachmentDescription.color(
            Format.rgba16_sFloat, AttachmentOps(LoadOp.clear, StoreOp.store),
            trans(ImageLayout.undefined, ImageLayout.colorAttachmentOptimal)
        );
        attachments[Attachment.color] = AttachmentDescription.color(
            Format.rgba8_uNorm, AttachmentOps(LoadOp.clear, StoreOp.store),
            trans(ImageLayout.undefined, ImageLayout.colorAttachmentOptimal)
        );
        attachments[Attachment.depth] = AttachmentDescription.depth(
            Format.d16_uNorm, AttachmentOps(LoadOp.clear, StoreOp.store),
            trans(ImageLayout.undefined, ImageLayout.depthStencilAttachmentOptimal)
        );
        attachments[Attachment.swcColor] = AttachmentDescription.color(
            swapchain.format, AttachmentOps(LoadOp.clear, StoreOp.store),
            trans(ImageLayout.undefined, ImageLayout.presentSrc)
        );

        subpasses[Subpass.geom] = SubpassDescription(
            // inputs
            [],
            // outputs
            [
                AttachmentRef(Attachment.worldPos, ImageLayout.colorAttachmentOptimal),
                AttachmentRef(Attachment.normal, ImageLayout.colorAttachmentOptimal),
                AttachmentRef(Attachment.color, ImageLayout.colorAttachmentOptimal),
            ],
            // depth
            some(AttachmentRef(Attachment.depth, ImageLayout.depthStencilAttachmentOptimal))
        );
        subpasses[Subpass.light] = SubpassDescription(
            // inputs
            [
                AttachmentRef(Attachment.worldPos, ImageLayout.shaderReadOnlyOptimal),
                AttachmentRef(Attachment.normal, ImageLayout.shaderReadOnlyOptimal),
                AttachmentRef(Attachment.color, ImageLayout.shaderReadOnlyOptimal),
            ],
            // outputs
            [
                AttachmentRef(Attachment.swcColor, ImageLayout.colorAttachmentOptimal)
            ],
            // depth
            none!AttachmentRef
        );
        subpasses[Subpass.bulb] = SubpassDescription(
            // inputs
            [],
            // outputs
            [
                AttachmentRef(Attachment.swcColor, ImageLayout.colorAttachmentOptimal)
            ],
            // depth
            some(AttachmentRef(Attachment.depth, ImageLayout.depthStencilAttachmentOptimal))
        );
        const dependencies = [
            SubpassDependency(
                trans(subpassExternal, Subpass.geom),
                trans(PipelineStage.bottomOfPipe, PipelineStage.colorAttachmentOutput),
                trans(Access.memoryRead, Access.colorAttachmentWrite)
            ),
            SubpassDependency(
                trans!uint(Subpass.geom, Subpass.light), // from geometry to lighting pass
                trans(PipelineStage.colorAttachmentOutput, PipelineStage.fragmentShader),
                trans(Access.colorAttachmentWrite, Access.colorAttachmentRead)
            ),
            SubpassDependency(
                trans!uint(Subpass.light, Subpass.bulb), // from lighting to bulb pass
                trans(PipelineStage.colorAttachmentOutput, PipelineStage.fragmentShader),
                trans(Access.colorAttachmentWrite, Access.colorAttachmentRead)
            ),
            SubpassDependency(
                trans(Subpass.bulb, subpassExternal),
                trans(PipelineStage.bottomOfPipe, PipelineStage.topOfPipe),
                trans(Access.colorAttachmentWrite, Access.memoryRead)
            ),
        ];

        renderPass = device.createRenderPass(attachments, subpasses, dependencies);
    }

    class DeferredFrameData : FrameData
    {
        /// G-buffer images and views
        Rc!Image worldPos;
        Rc!Image normal;
        Rc!Image color;
        Rc!ImageView worldPosView;
        Rc!ImageView normalView;
        Rc!ImageView colorView;

        /// depth buffer
        Rc!Image depth;

        /// Framebuffer
        Rc!Framebuffer framebuffer;

        /// Command buffer
        PrimaryCommandBuffer cmdBuf;

        this(ImageBase swcColor, CommandBuffer tempBuf)
        {
            import std.exception : enforce;

            super(swcColor);

            cmdBuf = cmdPool.allocatePrimary(1)[0];

            worldPos = device.createImage(ImageInfo.d2(size[0], size[1])
                    .withFormat(Format.rgba32_sFloat).withUsage(
                        ImageUsage.colorAttachment | ImageUsage.inputAttachment
                    ));
            normal = device.createImage(ImageInfo.d2(size[0], size[1])
                    .withFormat(Format.rgba16_sFloat).withUsage(
                        ImageUsage.colorAttachment | ImageUsage.inputAttachment
                    ));
            color = device.createImage(ImageInfo.d2(size[0], size[1])
                    .withFormat(Format.rgba8_uNorm).withUsage(
                        ImageUsage.colorAttachment | ImageUsage.inputAttachment
                    ));
            depth = device.createImage(ImageInfo.d2(size[0], size[1])
                    .withFormat(Format.d16_uNorm).withUsage(ImageUsage.depthStencilAttachment));

            enforce(bindImageMemory(worldPos.obj));
            enforce(bindImageMemory(normal.obj));
            enforce(bindImageMemory(color.obj));
            enforce(bindImageMemory(depth.obj));

            worldPosView = worldPos.createView(
                ImageType.d2, ImageSubresourceRange(ImageAspect.color), Swizzle.identity
            );
            normalView = normal.createView(
                ImageType.d2, ImageSubresourceRange(ImageAspect.color), Swizzle.identity
            );
            colorView = color.createView(
                ImageType.d2, ImageSubresourceRange(ImageAspect.color), Swizzle.identity
            );
            auto depthView = depth.createView(
                ImageType.d2, ImageSubresourceRange(ImageAspect.depth), Swizzle.identity
            ).rc;
            auto swcColorView = swcColor.createView(
                ImageType.d2, ImageSubresourceRange(ImageAspect.color), Swizzle.identity
            ).rc;

            this.framebuffer = this.outer.device.createFramebuffer(this.outer.renderPass, [
                worldPosView.obj, normalView.obj, colorView.obj, depthView.obj, swcColorView.obj
            ], size[0], size[1], 1);
        }

        override void dispose()
        {
            framebuffer.unload();
            colorView.unload();
            normalView.unload();
            worldPosView.unload();
            depth.unload();
            color.unload();
            normal.unload();
            worldPos.unload();
            cmdPool.free([ cast(CommandBuffer)cmdBuf ]);
            super.dispose();
        }
    }

    override FrameData makeFrameData(ImageBase swcColor, CommandBuffer tempBuf)
    {
        return new DeferredFrameData(swcColor, tempBuf);
    }

    final void prepareDescriptors()
    {
        const poolSizes = [
            DescriptorPoolSize(DescriptorType.uniformBuffer, 2),
            DescriptorPoolSize(DescriptorType.uniformBufferDynamic, 2),
            DescriptorPoolSize(DescriptorType.inputAttachment, 3),
        ];

        descriptorPool = device.createDescriptorPool(3, poolSizes);
        auto sets = descriptorPool.allocate([
            pipelines.geom.descriptorLayouts[0],
            pipelines.light.descriptorLayouts[0],
            pipelines.light.descriptorLayouts[1],
        ]);
        geomDescriptorSet = sets[0];
        lightBufDescriptorSet = sets[1];
        lightAttachDescriptorSet = sets[2];

        auto writes = [
            WriteDescriptorSet(geomDescriptorSet, 0, 0, new UniformBufferDescWrites([
                BufferRange(geomFrameUbo.buffer.obj, 0, GeomFrameUbo.sizeof),
            ])),
            WriteDescriptorSet(geomDescriptorSet, 1, 0, new UniformBufferDynamicDescWrites([
                BufferRange(geomModelUbo.buffer.obj, 0, GeomModelUbo.sizeof),
            ])),

            WriteDescriptorSet(lightBufDescriptorSet, 0, 0, new UniformBufferDescWrites([
                BufferRange(lightFrameUbo.buffer.obj, 0, LightFrameUbo.sizeof),
            ])),
            WriteDescriptorSet(lightBufDescriptorSet, 1, 0, new UniformBufferDynamicDescWrites([
                BufferRange(lightModelUbo.buffer.obj, 0, LightModelUbo.sizeof),
            ])),
        ];
        device.updateDescriptorSets(writes, []);
    }

    void updateAttachments(DeferredFrameData dfd)
    {
        auto writes = [
            WriteDescriptorSet(lightAttachDescriptorSet, 0, 0, new InputAttachmentDescWrites([
                ImageViewLayout(dfd.worldPosView.obj, ImageLayout.shaderReadOnlyOptimal),
                ImageViewLayout(dfd.normalView.obj, ImageLayout.shaderReadOnlyOptimal),
                ImageViewLayout(dfd.colorView.obj, ImageLayout.shaderReadOnlyOptimal),
            ]))
        ];
        device.updateDescriptorSets(writes, []);
    }

    void updateScene(in float dt)
    {
        scene.mov.rotate(dt);
        const M1 = scene.mov.transform();

        foreach (ref ss; scene.subStructs) {
            ss.mov.rotate(dt);
            const M2 = M1 * ss.mov.transform();

            foreach (ref s; ss.saucers) {
                s.anim(dt);
                const M3 = M2 * s.mov.transform();

                foreach (bi; 0 .. 3) {
                    geomModelUbo.data[s.saucerIdx].data[bi] = GeomModelData(
                        (M3 * s.bodies[bi].transform).transpose(),
                        fvec(s.bodies[bi].color, 1),
                    );
                }

                lightModelUbo.data[s.saucerIdx].modelViewProj = (
                    viewProj
                    * M3
                    * translation(s.lightPos)
                    * scale(FVec3(s.lightRadius * 1.5f)) // sphere slightly bigger than light radius
                ).transpose();
                lightModelUbo.data[s.saucerIdx].position =
                        M3 * translation(s.lightPos) * fvec(0, 0, 0, 1);
                lightModelUbo.data[s.saucerIdx].color = fvec(s.lightCol, 1);
                lightModelUbo.data[s.saucerIdx].radius = s.lightRadius;
            }
        }

        geomFrameUbo.data[0].viewProj = viewProj.transpose();
        lightFrameUbo.data[0].viewerPos = fvec(viewerPos, 1.0);

        MappedMemorySet mms;
        geomModelUbo.updateBuffer(mms);
        geomFrameUbo.updateBuffer(mms);
        lightModelUbo.updateBuffer(mms);
        lightFrameUbo.updateBuffer(mms);
        device.flushMappedMemory(mms);
    }

    override Submission[] recordCmds(FrameData frameData)
    {
        import std.datetime : dur;

        // temporary hack to avoid update of in-flight descriptors
        graphicsQueue.waitIdle();

        auto dfd = cast(DeferredFrameData)frameData;

        // bind frame attachments
        updateAttachments(dfd);

        // update scene
        const time = timeElapsed();
        if (time > lastTimeElapsed) {
            const dt = (time - lastTimeElapsed).total!"hnsecs" / 10_000_000.0;
            updateScene(dt);
            lastTimeElapsed = time;
        }

        PrimaryCommandBuffer buf = dfd.cmdBuf;

        buf.begin(CommandBufferUsage.oneTimeSubmit);

            buf.setViewport(0, [ Viewport(0f, 0f, cast(float)surfaceSize[0], cast(float)surfaceSize[1]) ]);
            buf.setScissor(0, [ Rect(0, 0, surfaceSize[0], surfaceSize[1]) ]);

            buf.beginRenderPass(
                renderPass, dfd.framebuffer, Rect(0, 0, surfaceSize[0], surfaceSize[1]), [
                    // clearing all 5 attachments in the framebuffer
                    ClearValues(ClearColorValues( 0f, 0f, 0f, 0f )), // world-pos
                    ClearValues(ClearColorValues( 0f, 0f, 0f, 0f )), // normal
                    ClearValues(ClearColorValues( 0f, 0f, 0f, 0f )), // color
                    ClearValues(ClearDepthStencilValues( 1f, 0 )), // depth
                    ClearValues(ClearColorValues( 0f, 0f, 0f, 1f )), // swapchain image
                ]
            );

                // geometry pass

                buf.bindPipeline(pipelines.geom.pipeline);
                hiResSphere.bindIndex(buf);
                buf.bindVertexBuffers(0, [ hiResSphere.vertexBinding() ]);

                foreach (ref ss; scene.subStructs) {
                    foreach (ref s; ss.saucers) {
                        buf.bindDescriptorSets(
                            PipelineBindPoint.graphics,
                            pipelines.geom.layout, 0, [ geomDescriptorSet ],
                            [ s.saucerIdx * GeomModelUbo.sizeof ]
                        );
                        // do not draw the bulb yet if it is on
                        const numInstances = s.lightOn ? 2 : 3;
                        buf.drawIndexed(
                            cast(uint)hiResSphere.indicesCount, numInstances, 0, 0, 0
                        );
                    }
                }

            buf.nextSubpass();

                // light pass

                buf.bindPipeline(pipelines.light.pipeline);
                loResSphere.bindIndex(buf);
                buf.bindVertexBuffers(0, [ loResSphere.vertexBinding() ]);
                buf.bindDescriptorSets(
                    PipelineBindPoint.graphics,
                    pipelines.light.layout, 1, [ lightAttachDescriptorSet ], []
                );

                foreach (ref ss; scene.subStructs) {
                    foreach (ref s; ss.saucers) {

                        if (!s.lightOn) continue;

                        buf.bindDescriptorSets(
                            PipelineBindPoint.graphics,
                            pipelines.light.layout, 0, [ lightBufDescriptorSet ],
                            [ s.saucerIdx * LightModelUbo.sizeof ]
                        );
                        buf.drawIndexed(
                            cast(uint)loResSphere.indicesCount, 1, 0, 0, 0
                        );
                    }
                }

            buf.nextSubpass();

                // bulb pass

                buf.bindPipeline(pipelines.bulb.pipeline);
                hiResSphere.bindIndex(buf);
                buf.bindVertexBuffers(0, [ hiResSphere.vertexBinding() ]);

                foreach (ref ss; scene.subStructs) {
                    foreach (ref s; ss.saucers) {

                        if (!s.lightOn) continue;

                        buf.bindDescriptorSets(
                            PipelineBindPoint.graphics,
                            pipelines.bulb.layout, 0, [ geomDescriptorSet ],
                            [ s.saucerIdx * GeomModelUbo.sizeof ]
                        );
                        // draw only the bulb (instance 2)
                        buf.drawIndexed(
                            cast(uint)hiResSphere.indicesCount, 1, 0, 0, 2
                        );
                    }
                }

            buf.endRenderPass();

        buf.end();

        return simpleSubmission([ buf ]);
    }
}

int main(string[] args)
{
    try {
        auto example = new DeferredExample(args);
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
    catch(Exception ex)
    {
        import std.stdio : stderr;

        stderr.writeln("error occured: ", ex.msg);
        return 1;
    }
}
