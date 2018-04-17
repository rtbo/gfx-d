module shadow;

import example;

import gfx.core.rc;
import gfx.core.typecons;
import gfx.core.types;
import gfx.graal.buffer;
import gfx.graal.cmd;
import gfx.graal.format;
import gfx.graal.image;
import gfx.graal.pipeline;
import gfx.graal.renderpass;
import gfx.graal.sync;

import gl3n.linalg : mat4, mat3, quat, vec3, vec4;

import std.math : PI;
import std.stdio;
import std.typecons;


final class ShadowExample : Example
{
    // generic resources
    Rc!Buffer vertBuf;
    Rc!Buffer indBuf;

    Rc!Buffer meshDynamicBuf;       // per mesh and per light
    Rc!Buffer meshStaticBuf;        // per mesh
    Rc!Buffer ligUniformBuf;        // per light

    Rc!DescriptorPool descPool;

    // shadow pass
    Rc!Semaphore shadowFinishedSem;
    Rc!RenderPass shadowRenderPass;
    Rc!Pipeline shadowPipeline;
    Rc!Image shadowTex;
    Rc!Sampler shadowSampler;
    Rc!Framebuffer shadowFramebuffer;
    Rc!DescriptorSetLayout shadowDSLayout;
    Rc!PipelineLayout shadowLayout;
    DescriptorSet shadowDS;

    // mesh pass
    Rc!RenderPass meshRenderPass;
    Rc!Pipeline meshPipeline;
    PerImage[] framebuffers;
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

    final class PerImage : Disposable
    {
        ImageBase color;
        Rc!ImageView colorView;
        Rc!Image depth;
        Rc!ImageView depthView;
        Rc!Framebuffer meshFramebuffer;

        override void dispose() {
            meshFramebuffer.unload();
            colorView.unload();
            depth.unload();
            depthView.unload();
        }
    }

    // supporting structs

    static struct Vertex {
        float[3] position;
        float[3] normal;
    }

    // uniform types
    static struct ShadowVsLocals {  // meshDynamicBuf (per mesh and per light)
        float[4][4] proj;
    }

    static struct MeshVsLocals {    // meshDynamicBuf (per mesh)
        float[4][4] mvp;
        float[4][4] model;
    }

    static struct MeshFsMaterial {  // meshStaticBuf (per mesh)
        float[4] color;
    }

    static struct LightBlk {        // within MeshFsLights
        float[4] position;
        float[4] color;
        float[4][4] proj;
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
        vec4 color;
        mat4 model;
    }

    static struct Light {
        vec4 position;
        vec4 color;
        mat4 view;
        mat4 proj;
        CommandBuffer cmdBuf;
        Rc!ImageView shadowPlane;
        Rc!Framebuffer shadowFb;
    }

    this() {
        super("Shadow");
    }

    override void dispose() {
        device.waitIdle();

        vertBuf.unload();
        indBuf.unload();
        meshDynamicBuf.unload();
        meshStaticBuf.unload();
        ligUniformBuf.unload();

        descPool.unload();

        shadowRenderPass.unload();
        shadowPipeline.unload();
        shadowTex.unload();
        shadowSampler.unload();
        shadowFramebuffer.unload();
        shadowDSLayout.unload();
        shadowLayout.unload();

        meshRenderPass.unload();
        meshPipeline.unload();
        disposeArray(framebuffers);
        meshShadowView.unload();
        meshDSLayout.unload();
        meshLayout.unload();

        reinitArray(lights);

        super.dispose();
    }

    override void prepare() {
        super.prepare();
        prepareSceneAndResources();
        prepareShadowRenderPass();
        prepareMeshRenderPass();
        prepareFramebuffers();
        prepareDescriptors();
        preparePipelines();
    }

    static auto columnMajor(in mat4 mat) {
        return mat.transposed().matrix;
    }

    void prepareSceneAndResources() {

        import std.exception : enforce;

        // setting up lights

        enum numLights = 3;

        shadowTex = device.createImage(
            ImageType.d2Array, ImageDims.d2Array(shadowSize, shadowSize, numLights),
            Format.d32_sFloat, ImageUsage.sampled | ImageUsage.depthStencilAttachment,
            ImageTiling.optimal, 1, 1
        );
        enforce(bindImageMemory(shadowTex));
        meshShadowView = shadowTex.createView(
            ImageType.d2Array,
            ImageSubresourceRange(ImageAspect.depth, 0, 1, 0, numLights),
            Swizzle.identity
        );
        {
            auto b = autoCmdBuf().rc;
            b.cmdBuf.pipelineBarrier(
                trans(PipelineStage.topOfPipe, PipelineStage.earlyFragmentTests), [], [
                    ImageMemoryBarrier(
                        trans(Access.none, Access.depthStencilAttachmentRead | Access.depthStencilAttachmentWrite),
                        trans(ImageLayout.undefined, ImageLayout.depthStencilAttachmentOptimal),
                        trans(queueFamilyIgnored, queueFamilyIgnored),
                        shadowTex, ImageSubresourceRange(ImageAspect.depth, 0, 1, 0, numLights)
                    )
                ]
            );
        }

        shadowSampler = device.createSampler(SamplerInfo(
            Filter.linear, Filter.linear, Filter.nearest,
            [WrapMode.repeat, WrapMode.repeat, WrapMode.repeat],
            some(16f), 0f, [0f, 0f]
        ));

        auto ligCmdBufs = cmdPool.allocate(numLights);

        auto makeLight(uint layer, float[3] pos, float[4] color, float fov)
        {
            enum near = 1f;
            enum far = 20f;

            Light l;
            l.position = vec4(pos, 1);
            l.color = vec4(color);
            l.view = mat4.look_at(vec3(pos), vec3(0, 0, 0), vec3(0, 0, 1));
            l.proj = mat4.perspective(100, 100, fov, near, far);
            l.shadowPlane = shadowTex.createView(
                ImageType.d2,
                ImageSubresourceRange(
                    ImageAspect.depth, 0, 1, layer, 1
                ),
                Swizzle.identity
            );
            l.cmdBuf = ligCmdBufs[layer];

            return l;
        }
        lights = [
            makeLight(0, [7, -5, 10], [0.5, 0.7, 0.5, 1], 60),
            makeLight(1, [-5, 7, 10], [0.7, 0.5, 0.5, 1], 45),
            makeLight(2, [10, 7, -5], [0.5, 0.5, 0.7, 1], 90),
        ];

        {
            MeshFsLights mfl;
            mfl.numLights = numLights;
            foreach (ind, l; lights) {
                mfl.lights[ind] = LightBlk(
                    l.position.vector, l.color.vector, columnMajor(l.proj*l.view)
                );
            }
            auto data = cast(void[])((&mfl)[0 .. 1]);
            ligUniformBuf = createStaticBuffer(data, BufferUsage.uniform);
        }

        // setup meshes

        // buffers layout:
        // vertBuf: cube vertices | plane vertices
        // indBuf:  cube indices  | plane indices

        enum numCubes = 4;

        import gfx.genmesh.cube : genCube;
        import gfx.genmesh.algorithm : indexCollectMesh, triangulate, vertices;
        import gfx.genmesh.poly : quad;
        import std.algorithm : map;

        const cube = genCube()
                .map!(f => quad(
                    Vertex( f[0].p, f[0].n ),
                    Vertex( f[1].p, f[1].n ),
                    Vertex( f[2].p, f[2].n ),
                    Vertex( f[3].p, f[3].n ),
                ))
                .triangulate()
                .vertices()
                .indexCollectMesh();

        const planeVertices = [
            Vertex([-1, -1,  0],    [ 0,  0,  1]),
            Vertex([ 1, -1,  0],    [ 0,  0,  1]),
            Vertex([ 1,  1,  0],    [ 0,  0,  1]),
            Vertex([-1,  1,  0],    [ 0,  0,  1]),
        ];

        const ushort[] planeIndices = [ 0,  1,  2,  2,  3,  0 ];

        const cubeVertBytes = cast(uint)(cube.vertices.length * Vertex.sizeof);
        const cubeIndBytes = cast(uint)(cube.indices.length * ushort.sizeof);

        const cubeVertOffset = 0;
        const cubeIndOffset = 0;
        const cubeNumIndices = cast(uint)cube.indices.length;
        const planeVertOffset = cubeVertBytes;
        const planeIndOffset = cubeIndBytes;
        const planeNumIndices = cast(uint)planeIndices.length;

        auto makeMesh(in uint vertOffset, in uint indOffset, in uint numVertices, in float rpm,
                      in mat4 model, in float[4] color) {
            return Mesh(vertOffset, indOffset, numVertices, rpm*2*PI/3600f, vec4(color), model);
        }

        auto makeCube(in float rpm, in float[3] pos, in float scale, in float angle, in float[4] color) {
            const offset = vec3(pos);
            const r = quat.axis_rotation(angle*PI/180.0, offset.normalized).to_matrix!(4, 4);
            const t = mat4.translation(offset);
            const s = mat4.scaling(scale, scale, scale);
            const model = t * s * r;
            return makeMesh(cubeVertOffset, cubeIndOffset, cubeNumIndices, rpm, model, color);
        }

        auto makePlane(in float rpm, in mat4 model, in float[4] color) {
            return makeMesh(planeVertOffset, planeIndOffset, planeNumIndices, rpm, model, color);
        }

        meshes = [
            makeCube(20, [-2, -2, 2], 0.7, 10, [0.8, 0.2, 0.2, 1]),
            makeCube(60, [2, -2, 2], 1.3, 50, [0.2, 0.8, 0.2, 1]),
            makeCube(10, [-2, 2, 2], 1.1, 140, [0.2, 0.2, 0.8, 1]),
            makeCube(5, [2, 2, 2], 0.9, 210, [0.8, 0.8, 0.2, 1]),
            makePlane(0f, mat4.identity, [1, 1, 1, 1]),
        ];

        {
            auto verts = cube.vertices ~ planeVertices;
            vertBuf = createStaticBuffer(verts, BufferUsage.vertex);
        }
        {
            auto inds = cube.indices ~ planeIndices;
            indBuf = createStaticBuffer(inds, BufferUsage.index);
        }
        {
            import std.array : array;
            auto data = meshes.map!(m => MeshFsMaterial(m.color.vector)).array;
            meshStaticBuf = createStaticBuffer(data, BufferUsage.uniform);
        }
        meshDynamicBuf = createDynamicBuffer(
            ShadowVsLocals.sizeof * meshes.length * lights.length +
            MeshVsLocals.sizeof * meshes.length,
            BufferUsage.uniform
        );
    }

    void prepareShadowRenderPass() {
        const attachments = [
            AttachmentDescription(
                Format.d32_sFloat, 1,
                AttachmentOps(LoadOp.clear, StoreOp.store),
                AttachmentOps(LoadOp.dontCare, StoreOp.dontCare),
                trans(ImageLayout.depthStencilAttachmentOptimal, ImageLayout.depthStencilAttachmentOptimal),
                No.mayAlias
            ),
        ];
        const subpasses = [
            SubpassDescription(
                [], [], some(AttachmentRef(0, ImageLayout.depthStencilAttachmentOptimal)), []
            ),
        ];
        shadowRenderPass = device.createRenderPass(attachments, subpasses, []);
        shadowFinishedSem = device.createSemaphore();
    }

    void prepareMeshRenderPass() {
        const attachments = [
            AttachmentDescription(swapchain.format, 1,
                AttachmentOps(LoadOp.clear, StoreOp.store),
                AttachmentOps(LoadOp.dontCare, StoreOp.dontCare),
                trans(ImageLayout.presentSrc, ImageLayout.presentSrc),
                No.mayAlias
            ),
            AttachmentDescription(findDepthFormat(), 1,
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
        meshRenderPass = device.createRenderPass(attachments, subpasses, []);
    }

    void prepareFramebuffers() {
        foreach (ref l; lights) {
            l.shadowFb = device.createFramebuffer(
                shadowRenderPass, [ l.shadowPlane ], shadowSize, shadowSize, 1
            );
        }

        auto b = autoCmdBuf().rc;

        foreach (img; scImages) {

            auto pi = new PerImage;
            pi.color = img;
            pi.colorView = img.createView(
                ImageType.d2, ImageSubresourceRange(ImageAspect.color), Swizzle.identity
            );
            pi.depth = createDepthImage(surfaceSize[0], surfaceSize[1]);
            pi.depthView = pi.depth.createView(
                ImageType.d2, ImageSubresourceRange(ImageAspect.depth), Swizzle.identity
            );
            pi.meshFramebuffer = device.createFramebuffer(meshRenderPass, [
                pi.colorView.obj, pi.depthView.obj
            ], surfaceSize[0], surfaceSize[1], 1);

            b.cmdBuf.pipelineBarrier(
                trans(PipelineStage.colorAttachment, PipelineStage.colorAttachment), [], [
                    ImageMemoryBarrier(
                        trans(Access.none, Access.colorAttachmentWrite),
                        trans(ImageLayout.undefined, ImageLayout.presentSrc),
                        trans(queueFamilyIgnored, queueFamilyIgnored),
                        img, ImageSubresourceRange(ImageAspect.color)
                    )
                ]
            );

            b.cmdBuf.pipelineBarrier(
                trans(PipelineStage.topOfPipe, PipelineStage.earlyFragmentTests), [], [
                    ImageMemoryBarrier(
                        trans(Access.none, Access.depthStencilAttachmentRead | Access.depthStencilAttachmentWrite),
                        trans(ImageLayout.undefined, ImageLayout.depthStencilAttachmentOptimal),
                        trans(queueFamilyIgnored, queueFamilyIgnored),
                        pi.depth, ImageSubresourceRange(ImageAspect.depth)
                    )
                ]
            );

            framebuffers ~= pi;
        }
    }

    void prepareDescriptors() {

        shadowDSLayout = device.createDescriptorSetLayout(
            [
                PipelineLayoutBinding(0, DescriptorType.uniformBufferDynamic, 1, ShaderStage.vertex),
            ]
        );
        shadowLayout = device.createPipelineLayout(
            [ shadowDSLayout ], []
        );

        const numLights = cast(uint)lights.length;

        meshDSLayout = device.createDescriptorSetLayout(
            [
                PipelineLayoutBinding(0, DescriptorType.uniformBufferDynamic, 1, ShaderStage.vertex),
                PipelineLayoutBinding(1, DescriptorType.uniformBuffer, 1, ShaderStage.fragment),
                PipelineLayoutBinding(2, DescriptorType.uniformBuffer, 1, ShaderStage.fragment),
                PipelineLayoutBinding(3, DescriptorType.combinedImageSampler, 1, ShaderStage.fragment),
            ]
        );
        meshLayout = device.createPipelineLayout(
            [ meshDSLayout ], []
        );

        descPool = device.createDescriptorPool( 2,
            [
                DescriptorPoolSize(DescriptorType.uniformBufferDynamic, 2),
                DescriptorPoolSize(DescriptorType.uniformBuffer, 2),
                DescriptorPoolSize(DescriptorType.combinedImageSampler, 1)
            ]
        );

        auto dss = descPool.allocate( [ shadowDSLayout, meshDSLayout ] );
        shadowDS = dss[0];
        meshDS = dss[1];

        const shadowVsLen = cast(uint)(ShadowVsLocals.sizeof * lights.length * meshes.length);
        const meshVsLen = cast(uint)(MeshVsLocals.sizeof * meshes.length);
        const meshFsMatLen = cast(uint)(MeshFsMaterial.sizeof * meshes.length);
        const ligFsLen = cast(uint)MeshFsLights.sizeof;

        import std.algorithm : map;
        import std.array : array;

        auto writes = [
            WriteDescriptorSet(shadowDS, 0, 0, new UniformBufferDynamicDescWrites(
                [ BufferRange(meshDynamicBuf, 0, ShadowVsLocals.sizeof) ]
            )),
            WriteDescriptorSet(meshDS, 0, 0, new UniformBufferDynamicDescWrites(
                [ BufferRange(meshDynamicBuf, shadowVsLen, MeshVsLocals.sizeof) ]
            )),
            WriteDescriptorSet(meshDS, 1, 0, new UniformBufferDescWrites(
                [ BufferRange(meshStaticBuf, 0, meshFsMatLen) ]
            )),
            WriteDescriptorSet(meshDS, 2, 0, new UniformBufferDescWrites(
                [ BufferRange(ligUniformBuf, 0, ligFsLen) ]
            )),
            WriteDescriptorSet(meshDS, 3, 0, new CombinedImageSamplerDescWrites(
                [ CombinedImageSampler(shadowSampler, meshShadowView, ImageLayout.depthStencilReadOnlyOptimal) ]
            ))
        ];
        device.updateDescriptorSets(writes, []);
    }

    PipelineInfo prepareShadowPipeline()
    {
        PipelineInfo info;
        info.shaders.vertex = device.createShaderModule(
            cast(immutable(uint)[])import("shadow.vert.spv"), "main"
        );
        info.shaders.fragment = device.createShaderModule(
            cast(immutable(uint)[])import("shadow.frag.spv"), "main"
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
                Viewport(0, 0, cast(float)shadowSize, cast(float)shadowSize),
                Rect(0, 0, shadowSize, shadowSize)
            )
        ];
        info.depthInfo = DepthInfo(
            Yes.enabled, Yes.write, CompareOp.less, No.boundsTest, 0f, 1f
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
        PipelineInfo info;
        info.shaders.vertex = device.createShaderModule(
            cast(immutable(uint)[])import("mesh.vert.spv"), "main"
        );
        info.shaders.fragment = device.createShaderModule(
            cast(immutable(uint)[])import("mesh.frag.spv"), "main"
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
            Yes.enabled, Yes.write, CompareOp.less, No.boundsTest, 0f, 1f
        );
        info.blendInfo = ColorBlendInfo(
            none!LogicOp, [ ColorBlendAttachment.solid() ], [ 0f, 0f, 0f, 0f ]
        );
        info.layout = meshLayout;
        info.renderPass = meshRenderPass;
        info.subpassIndex = 0;

        return info;
    }

    void preparePipelines() {
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

    void updateBuffers(in mat4 viewProj) {

        const axis = vec3(0, 0, 1);
        foreach (ref m; meshes) {
            const r = quat.axis_rotation(m.pulse, axis).to_matrix!(4, 4);
            m.model *= r;
        }

        const shadowVsLen = cast(uint)(ShadowVsLocals.sizeof * lights.length * meshes.length);
        const meshVsLen = cast(uint)(MeshVsLocals.sizeof * meshes.length);

        import gfx.graal.device : MappedMemorySet;
        import gfx.graal.memory : mapMemory;

        auto mem = meshDynamicBuf.boundMemory;

        {
            auto mm = mem.mapMemory!ShadowVsLocals(0, lights.length*meshes.length);
            foreach (il, ref l; lights) {
                foreach (im, ref m; meshes) {
                    const mat = ShadowVsLocals(columnMajor(l.proj * l.view * m.model));
                    mm[il*meshes.length + im] = mat;
                }
            }
            MappedMemorySet mms;
            mm.addToSet(mms);
            device.flushMappedMemory(mms);
        }
        {
            auto mm = mem.mapMemory!MeshVsLocals(shadowVsLen, meshes.length);
            foreach (im, ref m; meshes) {
                mm[im] = MeshVsLocals(
                    columnMajor(viewProj * m.model),
                    columnMajor(m.model),
                );
            }
            MappedMemorySet mms;
            mm.addToSet(mms);
            device.flushMappedMemory(mms);
        }
    }

    override void render()
    {
        import core.time : dur;
        import gfx.graal.queue : PresentRequest, StageWait, Submission;
        import std.algorithm : map;
        import std.array : array;

        bool needReconstruction;
        const imgInd = swapchain.acquireNextImage(dur!"seconds"(-1), imageAvailableSem, needReconstruction);
        const cmdBufInd = nextCmdBuf();

        // we have cmdbufs for each light that must be used on every frame
        // therefore, we must sync with the same fence on every frame
        fences[0].wait();
        fences[0].reset();

        recordCmds(cmdBufInd, imgInd);

        auto shadowSubmission = Submission(
            [],
            [ shadowFinishedSem ],
            lights.map!(l => l.cmdBuf).array
        );
        auto meshSubmission = Submission(
            [
                StageWait(shadowFinishedSem, PipelineStage.fragmentShader),
                StageWait(imageAvailableSem, PipelineStage.transfer)
            ],
            [ renderingFinishSem ], [ cmdBufs[cmdBufInd] ]
        );

        graphicsQueue.submit(
            [ shadowSubmission, meshSubmission ], fences[0]
        );

        presentQueue.present(
            [ renderingFinishSem ],
            [ PresentRequest(swapchain, imgInd) ]
        );

        // if (needReconstruction) {
        //     prepareSwapchain(swapchain);
        //     presentPool.reset();
        // }
    }


    override void recordCmds(ulong cmdBufInd, ulong imgInd)
    {
        void recordLight(uint il, Light l) {
            auto buf = l.cmdBuf;
            buf.begin(No.persistent);

            buf.beginRenderPass(
                shadowRenderPass, l.shadowFb, Rect(0, 0, shadowSize, shadowSize),
                [ ClearValues.depthStencil(0f, 0) ]
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
            auto buf = cmdBufs[cmdBufInd];
            auto fb = framebuffers[imgInd];

            buf.begin(No.persistent);
            buf.beginRenderPass(
                meshRenderPass, fb.meshFramebuffer, Rect(0, 0, surfaceSize[0], surfaceSize[1]),
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
                        c * MeshVsLocals.sizeof
                    ]
                );
                buf.drawIndexed(m.numVertices, 1, 0, 0, 0);
            }

            buf.endRenderPass();
            buf.end();
        }

        foreach (uint il, ref l; lights) {
            recordLight(il, l);
        }
        recordMeshes();
    }

}

int main() {

    try {
        auto example = new ShadowExample();
        example.prepare();
        scope(exit) example.dispose();

        example.window.onMouseOn = (uint, uint) {
            example.window.closeFlag = true;
        };

        const winSize = example.surfaceSize;
        const proj = mat4.perspective(winSize[0], winSize[1], 45, 1f, 20f);
        const viewProj = proj * mat4.look_at(vec3(3, 10, 6), vec3(0, 0, 0), vec3(0, 0, 1));

        FPSProbe fpsProbe;
        fpsProbe.start();

        enum reportFreq = 60;

        while (!example.window.closeFlag) {

            example.updateBuffers(viewProj);
            example.render();
            example.display.pollAndDispatch();

            fpsProbe.tick();
            if ((fpsProbe.frameCount % reportFreq) == 0) {
                writeln("FPS: ", fpsProbe.fps);
            }
        }

        return 0;
    }
    catch(Exception ex) {
        stderr.writeln("error occured: ", ex.msg);
        return 1;
    }
}
