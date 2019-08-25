module deferred;

import buffer;
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
    Rc!RenderPass deferredRenderPass;
    Rc!RenderPass bloomRenderPass;
    Rc!RenderPass blendRenderPass;

    Rc!DescriptorPool descriptorPool;

    Rc!DeferredBuffers buffers;
    Rc!DeferredPipelines pipelines;

    DescriptorSet geomDescriptorSet;

    DescriptorSet lightBufDescriptorSet;
    DescriptorSet lightAttachDescriptorSet;

    Rc!Sampler bloomSampler;
    DescriptorSet[3] bloomDescriptorSets;

    DescriptorSet blendDescriptorSet;

    Duration lastTimeElapsed;

    DeferredScene scene;
    FMat4 viewProj;
    FVec3 viewerPos;

    this(string[] args) {
        super("Deferred", args ~ "--no-gl3");
    }

    override void dispose()
    {
        if (device)
            device.waitIdle();
        bloomSampler.unload();
        deferredRenderPass.unload();
        bloomRenderPass.unload();
        blendRenderPass.unload();
        descriptorPool.reset();
        descriptorPool.unload();
        pipelines.unload();
        buffers.unload();

        super.dispose();
    }

    override void prepare()
    {
        super.prepare();
        const rad = scene.prepare();
        buffers = new DeferredBuffers(this, scene.saucerCount);
        pipelines = new DeferredPipelines(device, deferredRenderPass,
                bloomRenderPass, blendRenderPass);

        bloomSampler = device.createSampler(
            SamplerInfo.bilinear().withWrapMode(WrapMode.clamp)
        );

        prepareDescriptors();

        viewerPos = 1.2 * fvec(rad, rad, rad);
        const view = lookAt(viewerPos, fvec(0, 0, 0), fvec(0, 0, 1));
        const proj = perspective!float(this.ndc, 45, 4f/3f, 1f, rad * 3f);
        viewProj = proj * view;
    }

    override void prepareRenderPass()
    {
        // Deferred render pass
        //  - subpass 1: geom
        //      renders geometry into 4 images (position, normal, color, shininess)
        //  - subpass 2: light
        //      render lighted scene into HDR image
        //      the brightest areas are extracted into the bloomBase image at the same time
        prepareDeferredRenderPass();

        // Bloom render pass
        //  - done successively with flipping attachments
        //    in order to perform horizontal and vertical
        //    blur ping pong passes
        //     - the first pass blurs the bloomBase image horizontally into
        //       the blurH image
        //     - the second pass blurs the blurH image vertically into
        //       the blurV image
        //     - the third pass blurs the blurV image horizontally into
        //       the blurH image
        //     - and so on...
        //    a descriptor set is prepared for each case
        prepareBloomRenderPass();

        // Blend render pass
        //  - blend the lighted
        prepareBlendRenderPass();
    }

    final void prepareDeferredRenderPass()
    {
        enum Attachment {
            worldPos,
            normal,
            color,
            depth,

            hdrScene,
            bloomBase,

            count,
        }
        enum Subpass {
            geom,
            light,

            count,
        }

        auto attachments = new AttachmentDescription[Attachment.count];
        auto subpasses = new SubpassDescription[Subpass.count];

        attachments[Attachment.worldPos] = AttachmentDescription.color(
            Format.rgba32_sFloat, AttachmentOps(LoadOp.clear, StoreOp.dontCare),
            trans(ImageLayout.undefined, ImageLayout.colorAttachmentOptimal)
        );
        attachments[Attachment.normal] = AttachmentDescription.color(
            Format.rgba16_sFloat, AttachmentOps(LoadOp.clear, StoreOp.dontCare),
            trans(ImageLayout.undefined, ImageLayout.colorAttachmentOptimal)
        );
        attachments[Attachment.color] = AttachmentDescription.color(
            Format.rgba8_uNorm, AttachmentOps(LoadOp.clear, StoreOp.dontCare),
            trans(ImageLayout.undefined, ImageLayout.colorAttachmentOptimal)
        );
        attachments[Attachment.depth] = AttachmentDescription.depth(
            Format.d16_uNorm, AttachmentOps(LoadOp.clear, StoreOp.dontCare),
            trans(ImageLayout.undefined, ImageLayout.depthStencilAttachmentOptimal)
        );
        attachments[Attachment.hdrScene] = AttachmentDescription.color(
            Format.rgba16_sFloat, AttachmentOps(LoadOp.clear, StoreOp.store),
            trans(ImageLayout.undefined, ImageLayout.shaderReadOnlyOptimal)
        );
        attachments[Attachment.bloomBase] = AttachmentDescription.color(
            Format.rgba16_sFloat, AttachmentOps(LoadOp.clear, StoreOp.store),
            trans(ImageLayout.undefined, ImageLayout.shaderReadOnlyOptimal)
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
                AttachmentRef(Attachment.hdrScene, ImageLayout.colorAttachmentOptimal),
                AttachmentRef(Attachment.bloomBase, ImageLayout.colorAttachmentOptimal),
            ],
            // depth
            none!AttachmentRef
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
                trans(Subpass.light, subpassExternal),
                trans(PipelineStage.bottomOfPipe, PipelineStage.topOfPipe),
                trans(Access.colorAttachmentWrite, Access.memoryRead)
            ),
        ];

        deferredRenderPass = device.createRenderPass(attachments, subpasses, dependencies);
    }

    final void prepareBloomRenderPass()
    {
        enum Attachment {
            blurOutput,

            count,
        }
        enum Subpass {
            blur,

            count,
        }

        auto attachments = new AttachmentDescription[Attachment.count];
        auto subpasses = new SubpassDescription[Subpass.count];

        attachments[Attachment.blurOutput] = AttachmentDescription.color(
            Format.rgba16_sFloat, AttachmentOps(LoadOp.clear, StoreOp.store),
            trans(ImageLayout.undefined, ImageLayout.shaderReadOnlyOptimal)
        );

        subpasses[Subpass.blur] = SubpassDescription(
            // inputs
            [],
            // outputs
            [
                AttachmentRef(Attachment.blurOutput, ImageLayout.colorAttachmentOptimal),
            ],
            // depth
            none!AttachmentRef
        );
        const dependencies = [
            SubpassDependency(
                trans(subpassExternal, Subpass.blur),
                trans(PipelineStage.bottomOfPipe, PipelineStage.colorAttachmentOutput),
                trans(Access.memoryRead, Access.colorAttachmentWrite)
            ),
            SubpassDependency(
                trans(Subpass.blur, subpassExternal),
                trans(PipelineStage.bottomOfPipe, PipelineStage.topOfPipe),
                trans(Access.colorAttachmentWrite, Access.memoryRead)
            ),
        ];

        bloomRenderPass = device.createRenderPass(attachments, subpasses, dependencies);
    }

    final void prepareBlendRenderPass()
    {
        enum Attachment {
            hdrScene,
            bloom,

            swcColor,

            count,
        }
        enum Subpass {
            blend,

            count,
        }

        auto attachments = new AttachmentDescription[Attachment.count];
        auto subpasses = new SubpassDescription[Subpass.count];

        attachments[Attachment.hdrScene] = AttachmentDescription.color(
            Format.rgba16_sFloat, AttachmentOps(LoadOp.load, StoreOp.dontCare),
            trans(ImageLayout.shaderReadOnlyOptimal, ImageLayout.colorAttachmentOptimal)
        );
        attachments[Attachment.bloom] = AttachmentDescription.color(
            Format.rgba16_sFloat, AttachmentOps(LoadOp.load, StoreOp.dontCare),
            trans(ImageLayout.shaderReadOnlyOptimal, ImageLayout.colorAttachmentOptimal)
        );
        attachments[Attachment.swcColor] = AttachmentDescription.color(
            swapchain.format, AttachmentOps(LoadOp.clear, StoreOp.store),
            trans(ImageLayout.undefined, ImageLayout.presentSrc)
        );

        subpasses[Subpass.blend] = SubpassDescription(
            // inputs
            [
                AttachmentRef(Attachment.hdrScene, ImageLayout.shaderReadOnlyOptimal),
                AttachmentRef(Attachment.bloom, ImageLayout.shaderReadOnlyOptimal),
            ],
            // outputs
            [
                AttachmentRef(Attachment.swcColor, ImageLayout.colorAttachmentOptimal),
            ],
            // depth
            none!AttachmentRef
        );
        const dependencies = [
            SubpassDependency(
                trans(subpassExternal, Subpass.blend),
                trans(PipelineStage.bottomOfPipe, PipelineStage.colorAttachmentOutput),
                trans(Access.memoryRead, Access.colorAttachmentWrite)
            ),
            SubpassDependency(
                trans(Subpass.blend, subpassExternal),
                trans(PipelineStage.bottomOfPipe, PipelineStage.topOfPipe),
                trans(Access.colorAttachmentWrite, Access.memoryRead)
            ),
        ];

        blendRenderPass = device.createRenderPass(attachments, subpasses, dependencies);
    }

    class DeferredFrameData : FrameData
    {
        struct FbImage
        {
            Image img;
            ImageView view;

            this(Device device, DeferredExample ex, ImageInfo info) {
                img = retainObj(device.createImage(info));
                ex.bindImageMemory(img);
                const aspect = info.usage & ImageUsage.depthStencilAttachment ?
                    ImageAspect.depth :
                    ImageAspect.color;
                view = retainObj(img.createView(
                    ImageType.d2, ImageSubresourceRange(aspect), Swizzle.identity
                ));
            }

            this(this) {
                if (img) {
                    retainObj(img);
                    retainObj(view);
                }
            }

            ~this() {
                if (img) {
                    releaseObj(view);
                    releaseObj(img);
                }
            }
        }
        // G-buffer
        FbImage worldPos;
        FbImage normal;
        FbImage color;

        /// depth buffer
        FbImage depth;

        // HDR image the scene is rendered to
        FbImage hdrScene;
        FbImage bloomBase;

        // Framebuffer for deferred pass
        Rc!Framebuffer deferredFramebuffer;

        // ping pong blur framebuffers for blooming
        FbImage blurH;
        FbImage blurV;
        Rc!Framebuffer blurHFramebuffer;
        Rc!Framebuffer blurVFramebuffer;

        // final blend framebuffer
        Rc!Framebuffer blendFramebuffer;

        /// Command buffer
        PrimaryCommandBuffer cmdBuf;

        this(ImageBase swcColor, CommandBuffer tempBuf)
        {
            import std.exception : enforce;

            super(swcColor);

            cmdBuf = cmdPool.allocatePrimary(1)[0];

            worldPos = FbImage(device, this.outer, ImageInfo.d2(size[0], size[1])
                    .withFormat(Format.rgba32_sFloat)
                    .withUsage(ImageUsage.colorAttachment | ImageUsage.inputAttachment)
                );
            normal = FbImage(device, this.outer, ImageInfo.d2(size[0], size[1])
                    .withFormat(Format.rgba16_sFloat)
                    .withUsage(ImageUsage.colorAttachment | ImageUsage.inputAttachment)
                );
            color = FbImage(device, this.outer, ImageInfo.d2(size[0], size[1])
                    .withFormat(Format.rgba8_uNorm)
                    .withUsage(ImageUsage.colorAttachment | ImageUsage.inputAttachment)
                );
            depth = FbImage(device, this.outer, ImageInfo.d2(size[0], size[1])
                    .withFormat(Format.d16_uNorm)
                    .withUsage(ImageUsage.depthStencilAttachment)
                );
            hdrScene = FbImage(device, this.outer, ImageInfo.d2(size[0], size[1])
                    .withFormat(Format.rgba16_sFloat)
                    .withUsage(ImageUsage.colorAttachment | ImageUsage.inputAttachment)
                );
            bloomBase = FbImage(device, this.outer, ImageInfo.d2(size[0], size[1])
                    .withFormat(Format.rgba16_sFloat)
                    .withUsage(ImageUsage.colorAttachment | ImageUsage.sampled )
                );
            blurH = FbImage(device, this.outer, ImageInfo.d2(size[0], size[1])
                    .withFormat(Format.rgba16_sFloat)
                    .withUsage(ImageUsage.colorAttachment | ImageUsage.sampled)
                );
            blurV = FbImage(device, this.outer, ImageInfo.d2(size[0], size[1])
                    .withFormat(Format.rgba16_sFloat)
                    .withUsage(ImageUsage.colorAttachment | ImageUsage.inputAttachment | ImageUsage.sampled)
                );

            auto swcColorView = swcColor.createView(
                ImageType.d2, ImageSubresourceRange(ImageAspect.color), Swizzle.identity
            ).rc;

            deferredFramebuffer = this.outer.device.createFramebuffer(
                this.outer.deferredRenderPass, [
                    worldPos.view, normal.view, color.view,
                    depth.view, hdrScene.view, bloomBase.view
                ], size[0], size[1], 1
            );

            blurHFramebuffer = this.outer.device.createFramebuffer(
                this.outer.bloomRenderPass, [
                    blurH.view,
                ], size[0], size[1], 1
            );
            blurVFramebuffer = this.outer.device.createFramebuffer(
                this.outer.bloomRenderPass, [
                    blurV.view,
                ], size[0], size[1], 1
            );

            blendFramebuffer = this.outer.device.createFramebuffer(
                this.outer.blendRenderPass, [
                    hdrScene.view, blurV.view, swcColorView.obj,
                ], size[0], size[1], 1
            );
        }

        override void dispose()
        {
            blendFramebuffer.unload();
            blurVFramebuffer.unload();
            blurHFramebuffer.unload();
            deferredFramebuffer.unload();
            blurH = FbImage.init;
            blurV = FbImage.init;
            depth = FbImage.init;
            bloomBase = FbImage.init;
            hdrScene = FbImage.init;
            color = FbImage.init;
            normal = FbImage.init;
            worldPos = FbImage.init;
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
            DescriptorPoolSize(DescriptorType.inputAttachment, 5),
            DescriptorPoolSize(DescriptorType.combinedImageSampler, 3),
        ];

        descriptorPool = device.createDescriptorPool(7, poolSizes);
        auto sets = descriptorPool.allocate([
            pipelines.geom.descriptorLayouts[0],
            pipelines.light.descriptorLayouts[0],
            pipelines.light.descriptorLayouts[1],
            pipelines.bloom.descriptorLayouts[0],
            pipelines.bloom.descriptorLayouts[0],
            pipelines.bloom.descriptorLayouts[0],
            pipelines.blend.descriptorLayouts[0],
        ]);
        geomDescriptorSet = sets[0];
        lightBufDescriptorSet = sets[1];
        lightAttachDescriptorSet = sets[2];
        bloomDescriptorSets = sets[3 .. 6];
        blendDescriptorSet = sets[6];

        auto writes = [
            WriteDescriptorSet(geomDescriptorSet, 0, 0, new UniformBufferDescWrites([
                BufferRange(buffers.geomFrameUbo.buffer.obj, 0, GeomFrameUbo.sizeof),
            ])),
            WriteDescriptorSet(geomDescriptorSet, 1, 0, new UniformBufferDynamicDescWrites([
                BufferRange(buffers.geomModelUbo.buffer.obj, 0, GeomModelUbo.sizeof),
            ])),

            WriteDescriptorSet(lightBufDescriptorSet, 0, 0, new UniformBufferDescWrites([
                BufferRange(buffers.lightFrameUbo.buffer.obj, 0, LightFrameUbo.sizeof),
            ])),
            WriteDescriptorSet(lightBufDescriptorSet, 1, 0, new UniformBufferDynamicDescWrites([
                BufferRange(buffers.lightModelUbo.buffer.obj, 0, LightModelUbo.sizeof),
            ])),
        ];
        device.updateDescriptorSets(writes, []);
    }

    void updateAttachments(DeferredFrameData dfd)
    {
        auto writes = [
            WriteDescriptorSet(lightAttachDescriptorSet, 0, 0, new InputAttachmentDescWrites([
                ImageViewLayout(dfd.worldPos.view, ImageLayout.shaderReadOnlyOptimal),
                ImageViewLayout(dfd.normal.view, ImageLayout.shaderReadOnlyOptimal),
                ImageViewLayout(dfd.color.view, ImageLayout.shaderReadOnlyOptimal),
            ])),
            WriteDescriptorSet(bloomDescriptorSets[0], 0, 0, new CombinedImageSamplerDescWrites([
                CombinedImageSampler(bloomSampler.obj, dfd.blurH.view, ImageLayout.shaderReadOnlyOptimal),
            ])),
            WriteDescriptorSet(bloomDescriptorSets[1], 0, 0, new CombinedImageSamplerDescWrites([
                CombinedImageSampler(bloomSampler.obj, dfd.blurV.view, ImageLayout.shaderReadOnlyOptimal),
            ])),
            WriteDescriptorSet(bloomDescriptorSets[2], 0, 0, new CombinedImageSamplerDescWrites([
                CombinedImageSampler(bloomSampler.obj, dfd.bloomBase.view, ImageLayout.shaderReadOnlyOptimal),
            ])),
            WriteDescriptorSet(blendDescriptorSet, 0, 0, new InputAttachmentDescWrites([
                ImageViewLayout(dfd.hdrScene.view, ImageLayout.shaderReadOnlyOptimal),
                ImageViewLayout(dfd.blurV.view, ImageLayout.shaderReadOnlyOptimal),
            ])),
        ];
        device.updateDescriptorSets(writes, []);
    }

    void updateScene(in float dt)
    {
        import std.math : sqrt;

        scene.mov.rotate(dt);
        const M1 = scene.mov.transform();

        foreach (ref ss; scene.subStructs) {
            ss.mov.rotate(dt);
            const M2 = M1 * ss.mov.transform();

            foreach (ref s; ss.saucers) {
                s.anim(dt);
                const M3 = M2 * s.mov.transform();

                foreach (bi; 0 .. 3) {
                    buffers.geomModelUbo.data[s.saucerIdx].data[bi] = GeomModelData(
                        (M3 * s.bodies[bi].transform).transpose(),
                        fvec(
                            s.bodies[bi].color,
                            s.bodies[bi].shininess,
                        ),
                    );
                }

                const lightPosMat = M3 * translation(s.lightPos);
                // set the light sphere volume as a function of brightness on the edge
                // brightness = luminosity / (distance ^ 2 + 1)
                enum edgeBrightness = 0.02;
                const lightRadius = sqrt(s.lightLuminosity / edgeBrightness - 1.0);
                buffers.lightModelUbo.data[s.saucerIdx] = LightModelUbo(
                    transpose(viewProj * lightPosMat * scale(FVec3(lightRadius))),
                    lightPosMat * fvec(0, 0, 0, 1),
                    fvec(s.lightAnim.color, 1),
                    s.lightLuminosity,
                );
            }
        }

        buffers.geomFrameUbo.data[0].viewProj = viewProj.transpose();
        buffers.lightFrameUbo.data[0].viewerPos = fvec(viewerPos, 1.0);

        buffers.updateAll(device.obj);
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

            deferredPass(buf, dfd);

            bloomPasses(buf, dfd);

            blendPass(buf, dfd);

        buf.end();

        return simpleSubmission([ buf ]);
    }

    void deferredPass(PrimaryCommandBuffer buf, DeferredFrameData dfd)
    {
        const(ClearValues[6]) cvs = [
            // clearing all attachments in the framebuffer
            ClearValues(ClearColorValues( 0f, 0f, 0f, 0f )), // world-pos
            ClearValues(ClearColorValues( 0f, 0f, 0f, 0f )), // normal
            ClearValues(ClearColorValues( 0f, 0f, 0f, 0f )), // color
            ClearValues(ClearDepthStencilValues( 1f, 0 )), // depth
            ClearValues(ClearColorValues( 0f, 0f, 0f, 0f )), // hdrScene
            ClearValues(ClearColorValues( 0f, 0f, 0f, 1f )), // bloom base
        ];

        buf.beginRenderPass(
            deferredRenderPass,
            dfd.deferredFramebuffer,
            Rect(0, 0, surfaceSize[0], surfaceSize[1]),
            cvs[],
        );

            // geometry pass

            buf.bindPipeline(pipelines.geom.pipeline);
            buffers.hiResSphere.bindIndex(buf);
            buf.bindVertexBuffers(0, [ buffers.hiResSphere.vertexBinding() ]);

            foreach (ref ss; scene.subStructs) {
                foreach (ref s; ss.saucers) {
                    buf.bindDescriptorSets(
                        PipelineBindPoint.graphics,
                        pipelines.geom.layout, 0, [ geomDescriptorSet ],
                        [ s.saucerIdx * GeomModelUbo.sizeof ]
                    );
                    // only draw the bulbs that are off
                    const numInstances = s.lightAnim.on ? 2 : 3;
                    buf.drawIndexed(
                        cast(uint)buffers.hiResSphere.indicesCount, numInstances, 0, 0, 0
                    );
                }
            }

            // now draw the "on" bulbs with inverted normals as the light is from within
            buffers.invertedSphere.bindIndex(buf);
            buf.bindVertexBuffers(0, [ buffers.invertedSphere.vertexBinding() ]);

            foreach (ref ss; scene.subStructs) {
                foreach (ref s; ss.saucers) {
                    if (!s.lightAnim.on) continue;

                    buf.bindDescriptorSets(
                        PipelineBindPoint.graphics,
                        pipelines.geom.layout, 0, [ geomDescriptorSet ],
                        [ s.saucerIdx * GeomModelUbo.sizeof ]
                    );
                    buf.drawIndexed(
                        cast(uint)buffers.hiResSphere.indicesCount, 1, 0, 0, 2
                    );
                }
            }

        buf.nextSubpass();

            // light pass

            buf.bindPipeline(pipelines.light.pipeline);
            buffers.loResSphere.bindIndex(buf);
            buf.bindVertexBuffers(0, [ buffers.loResSphere.vertexBinding() ]);
            buf.bindDescriptorSets(
                PipelineBindPoint.graphics,
                pipelines.light.layout, 1, [ lightAttachDescriptorSet ], []
            );

            foreach (ref ss; scene.subStructs) {
                foreach (ref s; ss.saucers) {

                    if (!s.lightAnim.on) continue;

                    buf.bindDescriptorSets(
                        PipelineBindPoint.graphics,
                        pipelines.light.layout, 0, [ lightBufDescriptorSet ],
                        [ s.saucerIdx * LightModelUbo.sizeof ]
                    );
                    buf.drawIndexed(
                        cast(uint)buffers.loResSphere.indicesCount, 1, 0, 0, 0
                    );
                }
            }

        buf.endRenderPass();

    }

    void bloomPasses(PrimaryCommandBuffer buf, DeferredFrameData dfd)
    {
        buf.bindPipeline(pipelines.bloom.pipeline);
        buffers.square.bindIndex(buf);
        buf.bindVertexBuffers(0, [ buffers.square.vertexBinding() ]);

        const cv = ClearValues(ClearColorValues( 0f, 0f, 0f, 1f ));

        enum numBlurPasses = 4;

        foreach(i; 0 .. numBlurPasses) {
            foreach(v; 0 .. 2) {
                const h = 1 - v;
                // input descriptor sets:
                //  0: blurH, 1: blurV, 2: bloomBase (result of previous pass)
                auto dsInd = (i+v == 0) ? 2 : h;
                // output
                auto fb = v == 0 ? dfd.blurHFramebuffer.obj : dfd.blurVFramebuffer.obj;

                buf.bindDescriptorSets(
                    PipelineBindPoint.graphics,
                    pipelines.bloom.layout, 0, bloomDescriptorSets[dsInd .. dsInd+1],
                    []
                );

                buf.beginRenderPass(bloomRenderPass, fb,
                        Rect(0, 0, surfaceSize[0], surfaceSize[1]),
                        (&cv)[0 .. 1]);

                    buf.pushConstants(pipelines.bloom.layout, ShaderStage.fragment,
                        0, int.sizeof, &h
                    );

                    buf.drawIndexed(buffers.square.indicesCount, 1, 0, 0, 0);

                buf.endRenderPass();
            }
        }
    }


    void blendPass(PrimaryCommandBuffer buf, DeferredFrameData dfd)
    {
        buf.bindPipeline(pipelines.blend.pipeline);
        // square mesh already bound in bloom pass
        buf.bindDescriptorSets(
            PipelineBindPoint.graphics,
            pipelines.blend.layout, 0, [ blendDescriptorSet ],
            []
        );

        const cvs = [
            ClearValues(ClearColorValues( 0f, 0f, 0f, 1f )),
            ClearValues(ClearColorValues( 0f, 0f, 0f, 1f )),
            ClearValues(ClearColorValues( 0f, 0f, 0f, 1f )),
        ];

        buf.beginRenderPass(blendRenderPass, dfd.blendFramebuffer.obj,
                Rect(0, 0, surfaceSize[0], surfaceSize[1]), cvs);

            buf.drawIndexed(buffers.square.indicesCount, 1, 0, 0, 0);

        buf.endRenderPass();
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
