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
    Rc!RenderPass renderPass;
    Rc!DescriptorPool descriptorPool;

    Rc!DeferredBuffers buffers;
    Rc!DeferredPipelines pipelines;

    DescriptorSet geomDescriptorSet;

    DescriptorSet lightBufDescriptorSet;
    DescriptorSet lightAttachDescriptorSet;

    DescriptorSet toneMapDescriptorSet;

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
        buffers.unload();

        super.dispose();
    }

    override void prepare()
    {
        super.prepare();
        const rad = scene.prepare();
        buffers = new DeferredBuffers(this, scene.saucerCount);
        pipelines = new DeferredPipelines(device, renderPass);
        prepareDescriptors();

        viewerPos = fvec(rad, rad, rad);
        const view = lookAt(viewerPos, fvec(0, 0, 0), fvec(0, 0, 1));
        const proj = perspective!float(this.ndc, 45, 4f/3f, 1f, rad * 3f);
        viewProj = proj * view;
    }


    // Deferred render pass
    //  - subpass 1: geom
    //      renders geometry into 4 images (position, normal, color, shininess)
    //  - subpass 2: light
    //      render lighted scene into HDR image
    //  - subpass 3: tone mapping
    //      tone map lighted scene into final target
    override void prepareRenderPass()
    {
        enum Attachment {
            worldPos,
            normal,
            color,
            shininess,
            depth,

            hdrScene,

            swcColor,

            count,
        }
        enum Subpass {
            geom,
            light,
            toneMap,

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
        attachments[Attachment.shininess] = AttachmentDescription.color(
            Format.r16_sFloat, AttachmentOps(LoadOp.clear, StoreOp.store),
            trans(ImageLayout.undefined, ImageLayout.colorAttachmentOptimal)
        );
        attachments[Attachment.depth] = AttachmentDescription.depth(
            Format.d16_uNorm, AttachmentOps(LoadOp.clear, StoreOp.store),
            trans(ImageLayout.undefined, ImageLayout.depthStencilAttachmentOptimal)
        );
        attachments[Attachment.hdrScene] = AttachmentDescription.color(
            Format.rgba16_sFloat, AttachmentOps(LoadOp.clear, StoreOp.store),
            trans(ImageLayout.undefined, ImageLayout.colorAttachmentOptimal)
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
                AttachmentRef(Attachment.shininess, ImageLayout.colorAttachmentOptimal),
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
                AttachmentRef(Attachment.shininess, ImageLayout.shaderReadOnlyOptimal),
            ],
            // outputs
            [
                AttachmentRef(Attachment.hdrScene, ImageLayout.colorAttachmentOptimal),
            ],
            // depth
            none!AttachmentRef
        );
        subpasses[Subpass.toneMap] = SubpassDescription(
            // inputs
            [
                AttachmentRef(Attachment.hdrScene, ImageLayout.shaderReadOnlyOptimal),
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
                trans!uint(Subpass.light, Subpass.toneMap), // from geometry to lighting pass
                trans(PipelineStage.colorAttachmentOutput, PipelineStage.fragmentShader),
                trans(Access.colorAttachmentWrite, Access.colorAttachmentRead)
            ),
            SubpassDependency(
                trans(Subpass.toneMap, subpassExternal),
                trans(PipelineStage.bottomOfPipe, PipelineStage.topOfPipe),
                trans(Access.colorAttachmentWrite, Access.memoryRead)
            ),
        ];

        renderPass = device.createRenderPass(attachments, subpasses, dependencies);
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
        // G-buffer images and views
        FbImage worldPos;
        FbImage normal;
        FbImage color;
        FbImage shininess;

        /// depth buffer
        FbImage depth;

        // HDR image the scene is rendered to
        FbImage hdrScene;

        /// Main Framebuffer
        Rc!Framebuffer framebuffer;

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
            shininess = FbImage(device, this.outer, ImageInfo.d2(size[0], size[1])
                    .withFormat(Format.r16_sFloat)
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

            auto swcColorView = swcColor.createView(
                ImageType.d2, ImageSubresourceRange(ImageAspect.color), Swizzle.identity
            ).rc;

            this.framebuffer = this.outer.device.createFramebuffer(this.outer.renderPass, [
                worldPos.view, normal.view, color.view, shininess.view,
                depth.view, hdrScene.view, swcColorView.obj
            ], size[0], size[1], 1);
        }

        override void dispose()
        {
            framebuffer.unload();
            depth = FbImage.init;
            hdrScene = FbImage.init;
            shininess = FbImage.init;
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
        ];

        descriptorPool = device.createDescriptorPool(4, poolSizes);
        auto sets = descriptorPool.allocate([
            pipelines.geom.descriptorLayouts[0],
            pipelines.light.descriptorLayouts[0],
            pipelines.light.descriptorLayouts[1],
            pipelines.toneMap.descriptorLayouts[0],
        ]);
        geomDescriptorSet = sets[0];
        lightBufDescriptorSet = sets[1];
        lightAttachDescriptorSet = sets[2];
        toneMapDescriptorSet = sets[3];

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
                ImageViewLayout(dfd.shininess.view, ImageLayout.shaderReadOnlyOptimal),
            ])),
            WriteDescriptorSet(toneMapDescriptorSet, 0, 0, new InputAttachmentDescWrites([
                ImageViewLayout(dfd.hdrScene.view, ImageLayout.shaderReadOnlyOptimal),
            ])),
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
                    buffers.geomModelUbo.data[s.saucerIdx].data[bi] = GeomModelData(
                        (M3 * s.bodies[bi].transform).transpose(),
                        fvec(s.bodies[bi].color, 1),
                        s.bodies[bi].shininess,
                    );
                }

                buffers.lightModelUbo.data[s.saucerIdx].modelViewProj = (
                    viewProj
                    * M3
                    * translation(s.lightPos)
                    * scale(FVec3(s.lightRadius * 1.5f)) // sphere slightly bigger than light radius
                ).transpose();
                buffers.lightModelUbo.data[s.saucerIdx].position =
                        M3 * translation(s.lightPos) * fvec(0, 0, 0, 1);
                buffers.lightModelUbo.data[s.saucerIdx].color = fvec(s.lightCol, 1);
                buffers.lightModelUbo.data[s.saucerIdx].radius = s.lightRadius;
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

            const(ClearValues[7]) cvs = [
                // clearing all attachments in the framebuffer
                ClearValues(ClearColorValues( 0f, 0f, 0f, 0f )), // world-pos
                ClearValues(ClearColorValues( 0f, 0f, 0f, 0f )), // normal
                ClearValues(ClearColorValues( 0f, 0f, 0f, 0f )), // color
                ClearValues(ClearColorValues( 0f, 0f, 0f, 0f )), // shininess
                ClearValues(ClearDepthStencilValues( 1f, 0 )), // depth
                ClearValues(ClearColorValues( 0f, 0f, 0f, 0f )), // hdrScene
                ClearValues(ClearColorValues( 0f, 0f, 0f, 1f )), // swapchain image
            ];

            buf.beginRenderPass(
                renderPass,
                dfd.framebuffer,
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
                        const numInstances = s.lightOn ? 2 : 3;
                        buf.drawIndexed(
                            cast(uint)buffers.hiResSphere.indicesCount, numInstances, 0, 0, 0
                        );
                    }
                }

                // now draw the "on" bulbs with inverted normals
                buffers.invertedSphere.bindIndex(buf);
                buf.bindVertexBuffers(0, [ buffers.invertedSphere.vertexBinding() ]);

                foreach (ref ss; scene.subStructs) {
                    foreach (ref s; ss.saucers) {
                        if (!s.lightOn) continue;

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

                        if (!s.lightOn) continue;

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

            buf.nextSubpass();

                // tone map pass

                buf.bindPipeline(pipelines.toneMap.pipeline);
                buffers.square.bindIndex(buf);
                buf.bindVertexBuffers(0, [ buffers.square.vertexBinding() ]);
                buf.bindDescriptorSets(
                    PipelineBindPoint.graphics,
                    pipelines.toneMap.layout, 0, [ toneMapDescriptorSet ], []
                );

                buf.drawIndexed(cast(uint)buffers.square.indicesCount, 1, 0, 0, 0);

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
