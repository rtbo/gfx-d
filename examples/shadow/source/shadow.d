module shadow;

import example;

import gfx.core;
import gfx.graal;
import gfx.window;
import gfx.math;

import std.math : PI;
import std.stdio;
import std.typecons;


final class ShadowExample : Example
{
    // generic resources
    Rc!Buffer vertBuf;
    Rc!Buffer indBuf;

    Rc!Buffer meshUniformBuf;       // per mesh and per light
    Rc!Buffer ligUniformBuf;        // per light

    Rc!DescriptorPool descPool;

    Rc!Fence lastSub;

    // shadow pass
    Rc!Semaphore shadowFinishedSem;
    Rc!RenderPass shadowRenderPass;
    Rc!Pipeline shadowPipeline;
    Rc!Image shadowTex;
    Rc!Sampler shadowSampler;
    Rc!DescriptorSetLayout shadowDSLayout;
    Rc!PipelineLayout shadowLayout;
    DescriptorSet shadowDS;

    // mesh pass
    Rc!RenderPass meshRenderPass;
    Rc!Pipeline meshPipeline;
    Rc!ImageView meshShadowView;
    Rc!DescriptorSetLayout meshDSLayout;
    Rc!PipelineLayout meshLayout;
    DescriptorSet meshDS;

    // scene
    Mesh[] meshes;
    Light[] lights;

    // constants
    enum shadowSize = 2048;
    enum maxLights = 5;
    enum numLights = 3;

    // supporting structs

    static struct Vertex {
        FVec3 position;
        FVec3 normal;
    }

    // uniform types
    static struct ShadowVsLocals {  // meshDynamicBuf (per mesh and per light)
        FMat4 proj;
    }

    static struct MeshVsLocals {    // meshDynamicBuf (per mesh)
        FMat4 mvp;
        FMat4 model;
    }

    static struct MeshFsMaterial {  // meshDynamicBuf (per mesh)
        FVec4 color;
        FVec4 padding;
    }

    static struct LightBlk {        // within MeshFsLights
        FVec4 position;
        FVec4 color;
        FMat4 proj;
    }

    static struct MeshFsLights {     // ligUniformBuf (static, single instance)
        int numLights;
        int[3] padding;
        LightBlk[maxLights] lights;
    }

    // scene types
    static struct Mesh {
        uint vertOffset;
        uint indOffset;
        uint numVertices;
        float pulse;
        FVec4 color;
        FMat4 model;
    }

    static struct Light {
        FVec4 position;
        FVec4 color;
        FMat4 view;
        FMat4 proj;
        Rc!ImageView shadowPlane;
        Rc!Framebuffer shadowFb;
    }

    this(string[] args=[]) {
        super("Shadow", args);
    }

    override void dispose() {
        device.waitIdle();

        vertBuf.unload();
        indBuf.unload();
        meshUniformBuf.unload();
        ligUniformBuf.unload();

        lastSub.unload();
        descPool.unload();

        shadowFinishedSem.unload();
        shadowRenderPass.unload();
        shadowPipeline.unload();
        shadowTex.unload();
        shadowSampler.unload();
        shadowDSLayout.unload();
        shadowLayout.unload();

        meshRenderPass.unload();
        meshPipeline.unload();
        meshShadowView.unload();
        meshDSLayout.unload();
        meshLayout.unload();

        reinitArr(lights);

        super.dispose();
    }

    override void prepare()
    {
        super.prepare();
        prepareSceneAndResources();
        prepareShadowFramebuffers();
        prepareDescriptors();
        preparePipelines();
    }

    void prepareSceneAndResources()
    {
        import std.exception : enforce;

        // setting up lights

        shadowTex = device.createImage(
            ImageInfo.d2Array(shadowSize, shadowSize, numLights)
                .withFormat(Format.d32_sFloat)
                .withUsage(ImageUsage.sampled | ImageUsage.depthStencilAttachment)
        );
        enforce(bindImageMemory(shadowTex));
        meshShadowView = shadowTex.createView(
            ImageType.d2Array,
            ImageSubresourceRange(ImageAspect.depth, 0, 1, 0, numLights),
            Swizzle.identity
        );

        shadowSampler = device.createSampler(SamplerInfo(
            Filter.linear, Filter.linear, Filter.nearest,
            [WrapMode.repeat, WrapMode.repeat, WrapMode.repeat],
            none!float, 0f, [0f, 0f], some(CompareOp.lessOrEqual)
        ));

        auto makeLight(uint layer, FVec3 pos, FVec4 color, float fov)
        {
            enum near = 5f;
            enum far = 20f;

            Light l;
            l.position = fvec(pos, 1);
            l.color = color;
            l.view = lookAt(pos, fvec(0, 0, 0), fvec(0, 0, 1));
            l.proj = perspective(ndc, fov, 1f, near, far);
            l.shadowPlane = shadowTex.createView(
                ImageType.d2,
                ImageSubresourceRange(
                    ImageAspect.depth, 0, 1, layer, 1
                ),
                Swizzle.identity
            );
            return l;
        }
        lights = [
            makeLight(0, fvec(7, -5, 10), fvec(0.5, 0.7, 0.5, 1), 60),
            makeLight(1, fvec(-5, 7, 10), fvec(0.7, 0.5, 0.5, 1), 45),
            makeLight(2, fvec(10, 7, 5), fvec(0.5, 0.5, 0.7, 1), 90),
        ];

        {
            MeshFsLights mfl;
            mfl.numLights = numLights;
            foreach (ind, l; lights) {
                mfl.lights[ind] = LightBlk(
                    l.position, l.color, transpose(l.proj*l.view)
                );
            }
            auto data = cast(void[])((&mfl)[0 .. 1]);
            ligUniformBuf = createStaticBuffer(data, BufferUsage.uniform);
        }

        // setup meshes

        // buffers layout:
        // vertBuf: cube vertices | plane vertices
        // indBuf:  cube indices  | plane indices

        import gfx.genmesh.cube : genCube;
        import gfx.genmesh.algorithm : indexCollectMesh, triangulate, vertices;
        import gfx.genmesh.poly : quad;
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

        const planeVertices = [
            Vertex(fvec(-7, -7,  0), fvec(0,  0,  1)),
            Vertex(fvec( 7, -7,  0), fvec(0,  0,  1)),
            Vertex(fvec( 7,  7,  0), fvec(0,  0,  1)),
            Vertex(fvec(-7,  7,  0), fvec(0,  0,  1)),
        ];

        const ushort[] planeIndices = [ 0,  1,  2,  0,  2,  3 ];

        const cubeVertBytes = cast(uint)(cube.vertices.length * Vertex.sizeof);
        const cubeIndBytes = cast(uint)(cube.indices.length * ushort.sizeof);

        const cubeVertOffset = 0;
        const cubeIndOffset = 0;
        const cubeNumIndices = cast(uint)cube.indices.length;
        const planeVertOffset = cubeVertBytes;
        const planeIndOffset = cubeIndBytes;
        const planeNumIndices = cast(uint)planeIndices.length;

        auto makeMesh(in uint vertOffset, in uint indOffset, in uint numVertices, in float rpm,
                      in FMat4 model, in FVec4 color) {
            return Mesh(vertOffset, indOffset, numVertices, rpm*2*PI/3600f, color, model);
        }

        auto makeCube(in float rpm, in FVec3 pos, in float scale, in float angle, in FVec4 color) {
            const r = rotation(angle*PI/180f, normalize(pos));
            const t = translation(pos);
            const s = gfx.math.scale(scale, scale, scale);
            const model = t * s * r;
            return makeMesh(cubeVertOffset, cubeIndOffset, cubeNumIndices, rpm, model, color);
        }

        auto makePlane(in FMat4 model, in FVec4 color) {
            return makeMesh(planeVertOffset, planeIndOffset, planeNumIndices, 0, model, color);
        }

        meshes = [
            makeCube(3, fvec(-2, -2, 2), 0.7, 10, fvec(0.8, 0.2, 0.2, 1)),
            makeCube(7, fvec(2, -2, 2), 1.3, 50, fvec(0.2, 0.8, 0.2, 1)),
            makeCube(10, fvec(-2, 2, 2), 1.1, 140, fvec(0.2, 0.2, 0.8, 1)),
            makeCube(5, fvec(2, 2, 2), 0.9, 210, fvec(0.8, 0.8, 0.2, 1)),
            makePlane(FMat4.identity, fvec(1, 1, 1, 1)),
        ];

        {
            auto verts = cube.vertices ~ planeVertices;
            vertBuf = createStaticBuffer(verts, BufferUsage.vertex);
        }
        {
            auto inds = cube.indices ~ planeIndices;
            indBuf = createStaticBuffer(inds, BufferUsage.index);
        }
        meshUniformBuf = createDynamicBuffer(
            ShadowVsLocals.sizeof * meshes.length * lights.length +
            MeshVsLocals.sizeof * meshes.length +
            MeshFsMaterial.sizeof * meshes.length,
            BufferUsage.uniform
        );
    }

    override void prepareRenderPass()
    {
        prepareShadowRenderPass();
        prepareMeshRenderPass();
    }

    void prepareShadowRenderPass()
    {
        const attachments = [
            AttachmentDescription.depth(
                Format.d32_sFloat, AttachmentOps(LoadOp.clear, StoreOp.dontCare),
                trans(ImageLayout.undefined, ImageLayout.depthStencilReadOnlyOptimal)
            )
        ];
        const subpasses = [
            SubpassDescription(
                [], [], some(AttachmentRef(0, ImageLayout.depthStencilAttachmentOptimal)), []
            ),
        ];
        shadowRenderPass = device.createRenderPass(attachments, subpasses, []);
        shadowFinishedSem = device.createSemaphore();
    }

    void prepareMeshRenderPass()
    {
        const attachments = [
            AttachmentDescription.color(
                swapchain.format, AttachmentOps(LoadOp.clear, StoreOp.store),
                trans(ImageLayout.undefined, ImageLayout.presentSrc),
            ),
            AttachmentDescription.depth(
                findDepthFormat(), AttachmentOps(LoadOp.clear, StoreOp.dontCare),
                trans(ImageLayout.undefined, ImageLayout.depthStencilReadOnlyOptimal)
            ),
       ];
        const subpasses = [
            SubpassDescription(
                [], [ AttachmentRef(0, ImageLayout.colorAttachmentOptimal) ],
                some(AttachmentRef(1, ImageLayout.depthStencilAttachmentOptimal)),
                []
            )
        ];
        meshRenderPass = device.createRenderPass(attachments, subpasses, []);
    }

    void prepareShadowFramebuffers()
    {
        foreach (ref l; lights) {
            if (l.shadowFb) continue; // not needed during rebuild of swapchain
            l.shadowFb = device.createFramebuffer(
                shadowRenderPass, [ l.shadowPlane.obj ], shadowSize, shadowSize, 1
            );
        }
    }

    class ShadowFrameData : FrameData
    {
        PrimaryCommandBuffer[] cmdBufs;
        Rc!Image depth;
        Rc!Framebuffer framebuffer;

        this(ImageBase swcColor, CommandBuffer tempBuf)
        {
            super(swcColor);
            cmdBufs = cmdPool.allocatePrimary(numLights + 1);

            depth = createDepthImage(size[0], size[1]);

            auto colorView = swcColor.createView(
                ImageType.d2, ImageSubresourceRange(ImageAspect.color), Swizzle.identity
            ).rc;
            auto depthView = depth.createView(
                ImageType.d2, ImageSubresourceRange(ImageAspect.depth), Swizzle.identity
            ).rc;

            this.framebuffer = this.outer.device.createFramebuffer(this.outer.meshRenderPass, [
                colorView.obj, depthView.obj
            ], size[0], size[1], 1);
        }

        override void dispose()
        {
            import std.algorithm : map;
            import std.array : array;

            framebuffer.unload();
            depth.unload();
            cmdPool.free(cmdBufs.map!(b => cast(CommandBuffer)b).array);
            super.dispose();
        }
    }

    override FrameData makeFrameData(ImageBase swcColor, CommandBuffer tempBuf)
    {
        return new ShadowFrameData(swcColor, tempBuf);
    }

    void prepareDescriptors() {

        shadowDSLayout = device.createDescriptorSetLayout(
            [
                PipelineLayoutBinding(0, DescriptorType.uniformBufferDynamic, 1, ShaderStage.vertex),
            ]
        );
        shadowLayout = device.createPipelineLayout(
            [ shadowDSLayout.obj ], []
        );

        meshDSLayout = device.createDescriptorSetLayout(
            [
                PipelineLayoutBinding(0, DescriptorType.uniformBufferDynamic, 1, ShaderStage.vertex),
                PipelineLayoutBinding(1, DescriptorType.uniformBufferDynamic, 1, ShaderStage.fragment),
                PipelineLayoutBinding(2, DescriptorType.uniformBuffer, 1, ShaderStage.fragment),
                PipelineLayoutBinding(3, DescriptorType.combinedImageSampler, 1, ShaderStage.fragment),
            ]
        );
        meshLayout = device.createPipelineLayout(
            [ meshDSLayout.obj ], []
        );

        descPool = device.createDescriptorPool( 2,
            [
                DescriptorPoolSize(DescriptorType.uniformBufferDynamic, 3),
                DescriptorPoolSize(DescriptorType.uniformBuffer, 1),
                DescriptorPoolSize(DescriptorType.combinedImageSampler, 1)
            ]
        );

        auto dss = descPool.allocate( [ shadowDSLayout.obj, meshDSLayout.obj ] );
        shadowDS = dss[0];
        meshDS = dss[1];

        const shadowVsLen = ShadowVsLocals.sizeof * lights.length * meshes.length;
        const meshVsLen = MeshVsLocals.sizeof * meshes.length;
        const ligFsLen = MeshFsLights.sizeof;

        import std.algorithm : map;
        import std.array : array;

        auto writes = [
            WriteDescriptorSet(shadowDS, 0, 0, DescriptorWrite.make(
                DescriptorType.uniformBufferDynamic,
                meshUniformBuf.descriptor(0, ShadowVsLocals.sizeof),
            )),

            WriteDescriptorSet(meshDS, 0, 0, DescriptorWrite.make(
                DescriptorType.uniformBufferDynamic,
                meshUniformBuf.descriptor(shadowVsLen, MeshVsLocals.sizeof),
            )),

            WriteDescriptorSet(meshDS, 1, 0, DescriptorWrite.make(
                DescriptorType.uniformBufferDynamic,
                meshUniformBuf.descriptor(shadowVsLen+meshVsLen, MeshFsMaterial.sizeof),
            )),

            WriteDescriptorSet(meshDS, 2, 0, DescriptorWrite.make(
                DescriptorType.uniformBuffer,
                ligUniformBuf.descriptor(0, ligFsLen),
            )),

            WriteDescriptorSet(meshDS, 3, 0, DescriptorWrite.make(
                DescriptorType.combinedImageSampler,
                meshShadowView.descriptorWithSampler(ImageLayout.depthStencilReadOnlyOptimal, shadowSampler),
            )),
        ];
        device.updateDescriptorSets(writes, []);
    }

    PipelineInfo prepareShadowPipeline()
    {
        const spv = [
            import("shadow.vert.spv"), import("shadow.frag.spv")
        ];
        PipelineInfo info;
        info.shaders.vertex = device.createShaderModule(
            cast(immutable(uint)[])spv[0], "main"
        );
        info.shaders.fragment = device.createShaderModule(
            cast(immutable(uint)[])spv[1], "main"
        );
        info.shaders.vertex.retain();
        info.shaders.fragment.retain();

        info.inputBindings = [
            VertexInputBinding(0, Vertex.sizeof, No.instanced)
        ];
        info.inputAttribs = [
            VertexInputAttrib(0, 0, Format.rgb32_sFloat, 0),
            VertexInputAttrib(1, 0, Format.rgb32_sFloat, Vertex.normal.offsetof),
        ];
        info.assembly = InputAssembly(Primitive.triangleList, No.primitiveRestart);
        info.rasterizer = Rasterizer(
            PolygonMode.fill, Cull.back, FrontFace.ccw, No.depthClamp,
            some(DepthBias(1f, 0f, 2f)), 1f
        );
        info.viewports = [
            ViewportConfig(
                Viewport(0, 0, cast(float)shadowSize, cast(float)shadowSize),
                Rect(0, 0, shadowSize, shadowSize)
            )
        ];
        info.depthInfo = DepthInfo(
            Yes.enabled, Yes.write, CompareOp.lessOrEqual, No.boundsTest, 0f, 1f
        );
        info.blendInfo = ColorBlendInfo(
            none!LogicOp, [], [ 0f, 0f, 0f, 0f ]
        );
        info.layout = shadowLayout;
        info.renderPass = shadowRenderPass;
        info.subpassIndex = 0;

        return info;
    }

    PipelineInfo prepareMeshPipeline()
    {
        const spv = [
            import("mesh.vert.spv"), import("mesh.frag.spv")
        ];
        PipelineInfo info;
        info.shaders.vertex = device.createShaderModule(
            cast(immutable(uint)[])spv[0], "main"
        );
        info.shaders.fragment = device.createShaderModule(
            cast(immutable(uint)[])spv[1], "main"
        );
        info.shaders.vertex.retain();
        info.shaders.fragment.retain();

        info.inputBindings = [
            VertexInputBinding(0, Vertex.sizeof, No.instanced)
        ];
        info.inputAttribs = [
            VertexInputAttrib(0, 0, Format.rgb32_sFloat, 0),
            VertexInputAttrib(1, 0, Format.rgb32_sFloat, Vertex.normal.offsetof),
        ];
        info.assembly = InputAssembly(Primitive.triangleList, No.primitiveRestart);
        info.rasterizer = Rasterizer(
            PolygonMode.fill, Cull.back, FrontFace.ccw, No.depthClamp,
            none!DepthBias, 1f
        );
        info.viewports = [
            ViewportConfig(
                Viewport(0, 0, cast(float)surfaceSize[0], cast(float)surfaceSize[1]),
                Rect(0, 0, surfaceSize[0], surfaceSize[1])
            )
        ];
        info.depthInfo = DepthInfo(
            Yes.enabled, Yes.write, CompareOp.lessOrEqual, No.boundsTest, 0f, 1f
        );
        info.blendInfo = ColorBlendInfo(
            none!LogicOp, [ ColorBlendAttachment.solid() ], [ 0f, 0f, 0f, 0f ]
        );
        info.layout = meshLayout;
        info.renderPass = meshRenderPass;
        info.subpassIndex = 0;

        return info;
    }

    void preparePipelines()
    {
        auto infos = [
            prepareShadowPipeline(), prepareMeshPipeline()
        ];
        auto pls = device.createPipelines(infos);
        shadowPipeline = pls[0];
        meshPipeline = pls[1];

        foreach (ref i; infos) {
            i.shaders.vertex.release();
            i.shaders.fragment.release();
        }
    }

    void updateBuffers(in FMat4 viewProj)
    {
        const axis = fvec(0, 0, 1);
        foreach (ref m; meshes) {
            const r = rotation(m.pulse, axis);
            m.model *= r;
        }

        const shadowVsLen = cast(uint)(ShadowVsLocals.sizeof * lights.length * meshes.length);
        const meshVsLen = cast(uint)(MeshVsLocals.sizeof * meshes.length);

        import gfx.graal.device : MappedMemorySet;

        auto mm = meshUniformBuf.boundMemory.map();

        {
            auto v = mm.view!(ShadowVsLocals[])(0, lights.length*meshes.length);
            foreach (il, ref l; lights) {
                foreach (im, ref m; meshes) {
                    const mat = ShadowVsLocals(transpose(l.proj * l.view * m.model));
                    v[il*meshes.length + im] = mat;
                }
            }
        }
        {
            auto v = mm.view!(MeshVsLocals[])(shadowVsLen, meshes.length);
            foreach (im, ref m; meshes) {
                v[im] = MeshVsLocals(
                    transpose(viewProj * m.model),
                    transpose(m.model),
                );
            }
        }
        {
            auto v = mm.view!(MeshFsMaterial[])(shadowVsLen+meshVsLen, meshes.length);
            foreach (im, ref m; meshes) {
                v[im] = MeshFsMaterial( m.color );
            }
        }
        MappedMemorySet mms;
        mm.addToSet(mms);
        device.flushMappedMemory(mms);
    }

    override Submission[] recordCmds(FrameData frameData)
    {
        auto sfd = cast(ShadowFrameData)frameData;

        void recordLight(size_t il, ref Light l) {
            auto buf = sfd.cmdBufs[il];
            buf.begin(CommandBufferUsage.oneTimeSubmit);

            buf.beginRenderPass(
                shadowRenderPass, l.shadowFb, Rect(0, 0, shadowSize, shadowSize),
                [ ClearValues.depthStencil(1f, 0) ]
            );

            buf.bindPipeline(shadowPipeline);
            foreach (c, m; meshes) {
                buf.bindIndexBuffer(indBuf, m.indOffset, IndexType.u16);
                buf.bindVertexBuffers(0, [ VertexBinding(vertBuf, m.vertOffset) ]);
                buf.bindDescriptorSets(
                    PipelineBindPoint.graphics, shadowLayout, 0, [ shadowDS ],
                    [
                        (il*meshes.length + c) * ShadowVsLocals.sizeof
                    ]
                );
                buf.drawIndexed(m.numVertices, 1, 0, 0, 0);
            }

            buf.endRenderPass();

            buf.end();
        }

        void recordMeshes() {
            auto buf = sfd.cmdBufs[$-1];

            buf.begin(CommandBufferUsage.oneTimeSubmit);
            buf.beginRenderPass(
                meshRenderPass, sfd.framebuffer, Rect(0, 0, surfaceSize[0], surfaceSize[1]),
                [
                    ClearValues.color(0.6f, 0.6f, 0.6f, hasAlpha ? 0.5f : 1f),
                    ClearValues.depthStencil(1f, 0)
                ]
            );

            buf.bindPipeline(meshPipeline);
            foreach (c, m; meshes) {
                buf.bindIndexBuffer(indBuf, m.indOffset, IndexType.u16);
                buf.bindVertexBuffers(0, [ VertexBinding(vertBuf, m.vertOffset) ]);
                buf.bindDescriptorSets(
                    PipelineBindPoint.graphics, meshLayout, 0, [ meshDS ],
                    [
                        c * MeshVsLocals.sizeof, c * MeshFsMaterial.sizeof
                    ]
                );
                buf.drawIndexed(m.numVertices, 1, 0, 0, 0);
            }

            buf.endRenderPass();
            buf.end();
        }

        foreach (size_t il, ref l; lights) {
            recordLight(il, l);
        }
        recordMeshes();

        auto shadowSubmission = Submission(
            [],
            [ shadowFinishedSem.obj ],
            sfd.cmdBufs[0 .. lights.length],
        );
        auto meshSubmission = Submission(
            [
                StageWait(shadowFinishedSem, PipelineStage.fragmentShader),
                StageWait(imageAvailableSem, PipelineStage.transfer)
            ],
            [ renderingFinishSem.obj ], sfd.cmdBufs[lights.length .. $]
        );

        return [ shadowSubmission, meshSubmission ];
    }

    override void rebuildSwapchain()
    {
        device.waitIdle();
        super.rebuildSwapchain();
    }
}

int main(string[] args)
{
    try {
        auto example = new ShadowExample(args);
        example.prepare();
        scope(exit) example.dispose();

        example.window.onKeyOn = (KeyEvent ev)
        {
            if (ev.sym == KeySym.escape) {
                example.window.closeFlag = true;
            }
        };

        const winSize = example.surfaceSize;
        const proj = perspective(example.ndc, 45f, winSize[0]/(cast(float)winSize[1]), 1f, 20f);
        const viewProj = proj * lookAt(fvec(3, -10, 6), fvec(0, 0, 0), fvec(0, 0, 1));

        while (!example.window.closeFlag) {

            example.updateBuffers(viewProj);
            example.render();
            example.frameTick();
            example.display.pollAndDispatch();
        }

        return 0;
    }
    catch(Exception ex) {
        stderr.writeln("error occured: ", ex.msg);
        return 1;
    }
}
