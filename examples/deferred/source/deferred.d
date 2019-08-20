module deferred;

import example;

import gfx.core;
import gfx.graal;
import gfx.math;
import gfx.window;

import std.datetime : Duration;
import std.stdio;

struct Vertex
{
    FVec3 pos;
    FVec3 normal;
}

struct Mesh
{
    ushort[] indices;
    Vertex[] vertices;
}

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

    struct MovingObj
    {
        /// position of the object relative to its parent
        FVec3 position = fvec(0, 0, 0);
        /// rotation speed of the object around itself
        /// using Euler angles, in rad/s
        FVec3 spin = fvec(0, 0, 0);
        /// current rotation of the object
        FMat3 rotation = FMat3.identity;

        /// rotate the rotation matrix with the spin euler vector
        /// over dt secs
        void rotate(in float dt)
        {
            const euler = spin * dt;
            rotation *= eulerAngles(euler);
        }

        /// Compute the full transform
        FMat4 transform()
        {
            return translate(
                mat(
                    vec(rotation[0], 0),
                    vec(rotation[1], 0),
                    vec(rotation[2], 0),
                    vec(0, 0, 0, 1),
                ),
                position,
            );
        }
    }

    struct SaucerBody
    {
        FMat4 transform = FMat4.identity;
        FVec3 color = fvec(0, 0, 0);
    }

    struct Saucer
    {
        MovingObj mov;
        size_t saucerIdx;
        SaucerBody[] bodies;

        FVec3 lightCol;
        FVec3 lightPos;
        float[2] lightTimeOnOff; // time with light spent on and off each cycle
        float lightRadius;

        float phase;
        bool lightOn;

        void anim(in float dt) {
            mov.rotate(dt);
            const period = lightTimeOnOff[0] + lightTimeOnOff[1];
            phase += dt;
            while (phase >= period) phase -= period;
            lightOn = phase <= lightTimeOnOff[0];
        }
    }

    struct SaucerSubStruct
    {
        MovingObj mov;
        Saucer[] saucers;
    }

    struct SaucerSuperStruct
    {
        MovingObj mov;
        SaucerSubStruct[] subStructs;

        size_t saucerCount()
        {
            import std.algorithm : map, sum;

            return subStructs
                .map!(ss => ss.saucers.length)
                .sum();
        }
    }

    Rc!RenderPass renderPass;
    Rc!DescriptorPool descriptorPool;

    Rc!DescriptorSetLayout geomDescriptorLayout;
    Rc!PipelineLayout geomPipelineLayout;
    Rc!Pipeline geomPipeline;
    DescriptorSet geomDescriptorSet;

    Rc!DescriptorSetLayout lightBufDescriptorLayout;
    Rc!DescriptorSetLayout lightAttachDescriptorLayout;
    Rc!PipelineLayout lightPipelineLayout;
    Rc!Pipeline lightPipeline;
    DescriptorSet lightBufDescriptorSet;
    DescriptorSet lightAttachDescriptorSet;

    MeshBuffer hiResSphere;
    MeshBuffer loResSphere;
    UboBuffer!GeomFrameUbo geomFrameUbo;
    UboBuffer!GeomModelUbo geomModelUbo;
    UboBuffer!LightFrameUbo lightFrameUbo;
    UboBuffer!LightModelUbo lightModelUbo;

    Duration lastTimeElapsed;

    SaucerSuperStruct scene;
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
        geomDescriptorLayout.unload();
        geomPipelineLayout.unload();
        geomPipeline.unload();
        lightBufDescriptorLayout.unload();
        lightAttachDescriptorLayout.unload();
        lightPipelineLayout.unload();
        lightPipeline.unload();
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
        const rad = prepareScene();
        prepareBuffers();
        preparePipeline();
        prepareDescriptors();

        viewerPos = fvec(rad, rad, rad);
        const view = lookAt(viewerPos, fvec(0, 0, 0), fvec(0, 0, 1));
        const proj = perspective!float(this.ndc, 45, 4f/3f, 1f, rad * 3f);
        viewProj = proj * view;
    }

    /// return bounding radius of the sphere
    final float prepareScene()
    {
        /// Build a structure of 9 sub structures, each containing 9 saucers.
        /// Saucers have a fixed position relative to their sub-structure,
        /// which have fixed position relative to the super structure.
        /// Each object (structure, sub-structure and saucer spin around their center)
        /// is setup such as to not have collisions.

        import std.algorithm : map;
        import std.array : array;
        import std.math : PI, sqrt;
        import std.random : Random, uniform;

        enum margin = 1f;
        enum saucerSz = 3f;
        enum saucerBound = saucerSz + 2 * margin;
        enum subStructSz = saucerBound * 3;
        enum subStructBound = subStructSz + 2 * margin;
        enum superStructSz = subStructBound * 3;
        enum numSubStructs = 9;
        enum numSaucers = 9;

        enum subDist = (superStructSz / 2f) - (subStructBound / 2f);
        enum saucerDist = (subStructSz / 2f) - (saucerBound / 2f);

        auto rnd = Random(12);
        size_t saucerIdx = 0;

        FVec3 spin(in float minRpm, in float maxRpm)
        {
            enum RPM = 2*PI / 60;
            return fvec(
                uniform(minRpm * RPM, maxRpm * RPM, rnd),
                uniform(minRpm * RPM, maxRpm * RPM, rnd),
                uniform(minRpm * RPM, maxRpm * RPM, rnd),
            );
        }

        MovingObj[] buildMovingObjs(in uint num, in float dist, in float minRpm, in float maxRpm)
        {
            MovingObj[] objs = new MovingObj[num];

            const coord = dist * sqrt(2f) / 2;

            foreach(i; 0 .. num) {
                FVec3 pos = fvec(0, 0, 0);
                if (i > 0) {
                    const mask = i - 1;
                    pos.x = (mask & 0b001) ? coord : -coord;
                    pos.y = (mask & 0b010) ? coord : -coord;
                    pos.z = (mask & 0b100) ? coord : -coord;
                }
                objs[i] = MovingObj(pos, spin(minRpm, maxRpm), FMat3.identity);
            }
            return objs;
        }

        FVec3 color() {
            return normalize(
                fvec(
                    uniform(0.1, 1.0, rnd),
                    uniform(0.1, 1.0, rnd),
                    uniform(0.1, 1.0, rnd),
                )
            );
        }

        Saucer makeSaucer(MovingObj mov) {
            const float time = uniform(1.0, 10.0, rnd);
            const float onOff = uniform(0.1, 0.6, rnd); // on 10% to 60%
            const float[2] timeOnOff = [time * onOff, time * (1 - onOff)];

            SaucerBody body;
            SaucerBody cockpit;
            SaucerBody antenna;
            const bodyCol = color();
            const antennaCol = color();
            FVec3 antennaPos;
            {
                const xy = uniform(2.5, 3, rnd);
                const z = uniform(0.8, 1, rnd);
                body.transform = scale(fvec(xy, xy, z));
                body.color = bodyCol * 0.8;
            }
            {
                const s = uniform(0.5, 1, rnd);
                const x = uniform(-0.5, 0, rnd);
                const z = uniform(0.8, 1, rnd);
                cockpit.transform = translation(fvec(x, 0, z))
                        * scale(FVec3(s));
                cockpit.color = bodyCol;
            }
            {
                const s = uniform(0.1, 0.3, rnd);
                const x = uniform(1, 2, rnd);
                const z = uniform(1.5, 2.5, rnd);
                antennaPos = fvec(x, 0, z);
                antenna.transform = translation(antennaPos)
                        * scale(FVec3(s));
                antenna.color = antennaCol;
            }

            return Saucer(
                mov, saucerIdx++, [body, cockpit, antenna],
                antennaCol,
                antennaPos,
                timeOnOff,
                uniform(3f, 9f, rnd), // light radius
                uniform(0.0, time, rnd), // initial phase
            );
        }
        SaucerSubStruct makeSubStruct(MovingObj mov) {
            return SaucerSubStruct(
                mov,
                buildMovingObjs(numSaucers, saucerDist, 6f, 7f)
                    .map!(mov => makeSaucer(mov))
                    .array
            );
        }

        scene.mov.spin = spin(2f, 3f);
        scene.subStructs = buildMovingObjs(numSubStructs, subDist, 4f, 5f)
            .map!(mov => makeSubStruct(mov))
            .array;

        writefln("made %s saucers", saucerIdx);

        return superStructSz / 2f;
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
        const attachments = [
            // G-buffer attachment
            //      world pos
            AttachmentDescription.color(
                Format.rgba32_sFloat, AttachmentOps(LoadOp.clear, StoreOp.store),
                trans(ImageLayout.undefined, ImageLayout.colorAttachmentOptimal)
            ),
            //      normal
            AttachmentDescription.color(
                Format.rgba16_sFloat, AttachmentOps(LoadOp.clear, StoreOp.store),
                trans(ImageLayout.undefined, ImageLayout.colorAttachmentOptimal)
            ),
            //      color
            AttachmentDescription.color(
                Format.rgba8_uNorm, AttachmentOps(LoadOp.clear, StoreOp.store),
                trans(ImageLayout.undefined, ImageLayout.colorAttachmentOptimal)
            ),
            // depth image
            AttachmentDescription.depth(
                Format.d16_uNorm, AttachmentOps(LoadOp.clear, StoreOp.store),
                trans(ImageLayout.undefined, ImageLayout.depthStencilAttachmentOptimal)
            ),
            // swapchain image
            AttachmentDescription.color(
                swapchain.format, AttachmentOps(LoadOp.clear, StoreOp.store),
                trans(ImageLayout.undefined, ImageLayout.presentSrc)
            )
        ];
        const subpasses = [
            // geometry pass
            SubpassDescription(
                // inputs
                [],
                // outputs
                [
                    AttachmentRef(0, ImageLayout.colorAttachmentOptimal),
                    AttachmentRef(1, ImageLayout.colorAttachmentOptimal),
                    AttachmentRef(2, ImageLayout.colorAttachmentOptimal),
                ],
                // depth
                some(AttachmentRef(3, ImageLayout.depthStencilAttachmentOptimal))
            ),
            // lighting pass
            SubpassDescription(
                // inputs
                [
                    AttachmentRef(0, ImageLayout.shaderReadOnlyOptimal),
                    AttachmentRef(1, ImageLayout.shaderReadOnlyOptimal),
                    AttachmentRef(2, ImageLayout.shaderReadOnlyOptimal),
                ],
                // outputs
                [
                    AttachmentRef(4, ImageLayout.colorAttachmentOptimal)
                ],
                // depth
                none!AttachmentRef
            ),
        ];
        const dependencies = [
            SubpassDependency(
                trans(subpassExternal, 0),
                trans(PipelineStage.bottomOfPipe, PipelineStage.colorAttachmentOutput),
                trans(Access.memoryRead, Access.colorAttachmentWrite)
            ),
            SubpassDependency(
                trans!uint(0, 1), // from geometry to lighting passes
                trans(PipelineStage.colorAttachmentOutput, PipelineStage.fragmentShader),
                trans(Access.colorAttachmentWrite, Access.colorAttachmentRead)
            ),
            SubpassDependency(
                trans(1, subpassExternal),
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

    final void preparePipeline()
    {
        prepareGeomPipeline();
        prepareLightPipeline();
    }

    final void prepareGeomPipeline()
    {
        import std.typecons : No, Yes;

        const shaderSpv = [
            import("geom.vert.spv"), import("geom.frag.spv"),
        ];
        auto vtxShader = device.createShaderModule(
            cast(immutable(uint)[])shaderSpv[0], "main"
        ).rc;
        auto fragShader = device.createShaderModule(
            cast(immutable(uint)[])shaderSpv[1], "main"
        ).rc;

        const layoutBindings = [
            PipelineLayoutBinding(
                0, DescriptorType.uniformBuffer, 1, ShaderStage.vertex
            ),
            PipelineLayoutBinding(
                1, DescriptorType.uniformBufferDynamic, 1, ShaderStage.vertex
            ),
        ];

        geomDescriptorLayout = device.createDescriptorSetLayout(layoutBindings);
        geomPipelineLayout = device.createPipelineLayout([ geomDescriptorLayout.obj ], []);

        PipelineInfo info;
        info.shaders.vertex = vtxShader;
        info.shaders.fragment = fragShader;
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
        info.depthInfo = DepthInfo(
            Yes.enabled, Yes.write, CompareOp.less, No.boundsTest, 0f, 1f
        );
        info.blendInfo = ColorBlendInfo(
            none!LogicOp, [
                ColorBlendAttachment.solid(),
                ColorBlendAttachment.solid(),
                ColorBlendAttachment.solid(),
            ],
        );
        info.dynamicStates = [ DynamicState.viewport, DynamicState.scissor ];
        info.layout = geomPipelineLayout;
        info.renderPass = renderPass;
        info.subpassIndex = 0;

        geomPipeline = device.createPipelines((&info)[0 .. 1])[0];
    }

    final void prepareLightPipeline()
    {
        import std.typecons : No, Yes;

        const shaderSpv = [
            import("light.vert.spv"), import("light.frag.spv"),
        ];
        auto vtxShader = device.createShaderModule(
            cast(immutable(uint)[])shaderSpv[0], "main"
        ).rc;
        auto fragShader = device.createShaderModule(
            cast(immutable(uint)[])shaderSpv[1], "main"
        ).rc;

        const bufLayoutBindings = [
            PipelineLayoutBinding(
                0, DescriptorType.uniformBuffer, 1, ShaderStage.fragment
            ),
            PipelineLayoutBinding(
                1, DescriptorType.uniformBufferDynamic, 1, ShaderStage.vertex | ShaderStage.fragment
            ),
        ];
        const attachLayoutBindings = [
            PipelineLayoutBinding(
                0, DescriptorType.inputAttachment, 3, ShaderStage.fragment
            ),
        ];

        lightBufDescriptorLayout = device.createDescriptorSetLayout(bufLayoutBindings);
        lightAttachDescriptorLayout = device.createDescriptorSetLayout(attachLayoutBindings);
        lightPipelineLayout = device.createPipelineLayout([
            lightBufDescriptorLayout.obj, lightAttachDescriptorLayout.obj,
        ], []);

        PipelineInfo info;
        info.shaders.vertex = vtxShader;
        info.shaders.fragment = fragShader;
        info.inputBindings = [
            VertexInputBinding(0, FVec3.sizeof, No.instanced)
        ];
        info.inputAttribs = [
            VertexInputAttrib(0, 0, Format.rgb32_sFloat, 0),
        ];
        info.assembly = InputAssembly(Primitive.triangleList, No.primitiveRestart);
        // culling so that we run the shader once per fragment
        // front instead of back culling to also run the shader if the camera is within a sphere
        info.rasterizer = Rasterizer(
            PolygonMode.fill, Cull.front, FrontFace.ccw
        );
        info.blendInfo = ColorBlendInfo(
            none!LogicOp, [
                ColorBlendAttachment.blend(
                    BlendState(
                        trans(BlendFactor.one, BlendFactor.one),
                        BlendOp.add,
                    ),
                ),
            ],
        );
        info.dynamicStates = [ DynamicState.viewport, DynamicState.scissor ];
        info.layout = lightPipelineLayout;
        info.renderPass = renderPass;
        info.subpassIndex = 1;

        lightPipeline = device.createPipelines((&info)[0 .. 1])[0];
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
            geomDescriptorLayout.obj, lightBufDescriptorLayout.obj, lightAttachDescriptorLayout.obj
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

                buf.bindPipeline(geomPipeline);
                hiResSphere.bindIndex(buf);
                buf.bindVertexBuffers(0, [ hiResSphere.vertexBinding() ]);

                foreach (ref ss; scene.subStructs) {
                    foreach (ref s; ss.saucers) {
                        buf.bindDescriptorSets(
                            PipelineBindPoint.graphics,
                            geomPipelineLayout, 0, [ geomDescriptorSet ],
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

                buf.bindPipeline(lightPipeline);
                loResSphere.bindIndex(buf);
                buf.bindVertexBuffers(0, [ loResSphere.vertexBinding() ]);
                buf.bindDescriptorSets(
                    PipelineBindPoint.graphics,
                    lightPipelineLayout, 1, [ lightAttachDescriptorSet ], []
                );

                foreach (ref ss; scene.subStructs) {
                    foreach (ref s; ss.saucers) {

                        if (!s.lightOn) continue;

                        buf.bindDescriptorSets(
                            PipelineBindPoint.graphics,
                            lightPipelineLayout, 0, [ lightBufDescriptorSet ],
                            [ s.saucerIdx * LightModelUbo.sizeof ]
                        );
                        buf.drawIndexed(
                            cast(uint)loResSphere.indicesCount, 1, 0, 0, 0
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

Mesh buildUvSpheroid(in FVec3 center, in float radius, in float height,
        in uint latDivs = 8)
{
    import std.array : uninitializedArray;
    import std.math : PI, cos, sin;

    const longDivs = latDivs * 2;
    const totalVertices = 2 + (latDivs - 1) * longDivs;
    const totalIndices = 3 * longDivs * (2 + 2 * (latDivs - 2));

    auto vertices = uninitializedArray!(Vertex[])(totalVertices);

    size_t ind = 0;
    void unitVertex(in FVec3 pos)
    {
        const v = fvec(radius * pos.xy, height * pos.z);
        vertices[ind++] = Vertex(center + v, normalize(v));
    }

    const latAngle = PI / latDivs;
    const longAngle = 2 * PI / longDivs;

    // north pole
    unitVertex(fvec(0, 0, 1));
    // latitudes
    foreach (lat; 1 .. latDivs)
    {
        const alpha = latAngle * lat;
        const z = cos(alpha);
        const sa = sin(alpha);
        foreach (lng; 0 .. longDivs)
        {
            const beta = longAngle * lng;
            const x = cos(beta) * sa;
            const y = sin(beta) * sa;

            unitVertex(fvec(x, y, z));
        }
    }
    // south pole
    unitVertex(fvec(0, 0, -1));
    assert(ind == totalVertices);

    // build ccw triangle faces
    auto indices = uninitializedArray!(ushort[])(totalIndices);
    ind = 0;
    void face(in size_t v0, in size_t v1, in size_t v2)
    {
        indices[ind++] = cast(ushort) v0;
        indices[ind++] = cast(ushort) v1;
        indices[ind++] = cast(ushort) v2;
    }

    size_t left(size_t lng)
    {
        return lng;
    }

    size_t right(size_t lng)
    {
        return lng == longDivs - 1 ? 0 : lng + 1;
    }

    // northern div triangles
    foreach (lng; 0 .. longDivs)
    {
        const pole = 0;
        const bot = 1;
        face(pole, bot + left(lng), bot + right(lng));
    }
    // middle divs rectangles
    foreach (lat; 0 .. latDivs - 2)
    {
        const top = 1 + lat * longDivs;
        const bot = top + longDivs;
        foreach (lng; 0 .. longDivs)
        {
            const l = left(lng);
            const r = right(lng);

            face(top + l, bot + l, bot + r);
            face(top + l, bot + r, top + r);
        }
    }
    // southern div triangles
    foreach (lng; 0 .. longDivs)
    {
        const pole = totalVertices - 1;
        const top = 1 + (latDivs - 2) * longDivs;
        face(pole, top + right(lng), top + left(lng));
    }
    assert(ind == totalIndices);

    return Mesh(indices, vertices);
}
