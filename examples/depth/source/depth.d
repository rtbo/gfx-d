module depth;

import example;

import gfx.core.rc;
import gfx.core.typecons;
import gfx.core.types;
import gfx.graal.buffer;
import gfx.graal.cmd;
import gfx.graal.device;
import gfx.graal.format;
import gfx.graal.image;
import gfx.graal.memory;
import gfx.graal.pipeline;
import gfx.graal.presentation;
import gfx.graal.queue;
import gfx.graal.renderpass;

import gl3n.linalg : mat4, mat3, vec3, vec4;

import std.exception;
import std.stdio;
import std.typecons;
import std.math;

class CrateExample : Example
{
    Rc!RenderPass renderPass;
    Framebuffer[] framebuffers;
    Rc!Pipeline pipeline;
    Rc!PipelineLayout layout;
    PerImage[] perImages;
    size_t cubeLen;
    enum cubeCount = 3;
    const(ushort)[] indices;
    Rc!Buffer vertBuf;
    Rc!Buffer indBuf;
    Rc!Buffer matBuf;
    Rc!Buffer ligBuf;
    Rc!Image texImg;
    Rc!DescriptorPool descPool;
    Rc!DescriptorSetLayout setLayout;
    DescriptorSet set;

    struct PerImage {
        bool undefinedLayout=true;
    }

    struct Vertex {
        float[3] position;
        float[3] normal;
        float[4] color;
    }

    struct Matrices {
        float[4][4] mvp;
        float[4][4] normal;
    }

    enum maxLights = 5;

    struct Light {
        float[4] direction;
        float[4] color;
    }

    struct Lights {
        Light[maxLights] lights;
        uint num;
    }

    this() {
        super("Depth");
    }

    override void dispose() {
        if (device) {
            device.waitIdle();
        }
        vertBuf.unload();
        indBuf.unload();
        matBuf.unload();
        ligBuf.unload();
        setLayout.unload();
        descPool.unload();
        layout.unload();
        pipeline.unload();
        renderPass.unload();
        releaseArray(framebuffers);
        super.dispose();
    }

    override void prepare() {
        super.prepare();
        prepareBuffers();
        prepareRenderPass();
        preparePipeline();
        prepareDescriptorSet();
    }

    void prepareBuffers() {

        import gfx.genmesh.cube : genCube;
        import gfx.genmesh.algorithm : indexCollectMesh, quad, triangulate,
                vertices, WindingOrder;
        import std.algorithm : map;

        const cube = genCube()
                .map!(f => quad(
                    Vertex( f[0].p, f[0].n ),
                    Vertex( f[1].p, f[1].n ),
                    Vertex( f[2].p, f[2].n ),
                    Vertex( f[3].p, f[3].n ),
                ))
                .triangulate(WindingOrder.rightHandCCW)
                .vertices()
                .indexCollectMesh();

        cubeLen = cube.vertices.length;

        const red   = [ 1f, 0f, 0f, 1f ];
        const green = [ 0f, 1f, 0f, 1f ];
        const blue  = [ 0f, 0f, 1f, 1f ];
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
        vertBuf = createStaticBuffer(verts, BufferUsage.vertex);
        indBuf = createStaticBuffer(indices, BufferUsage.index);

        auto normalize(in float[4] vec) {
            return vec4(vec).normalized().vector;
        }
        const lights = Lights( [
            Light(normalize([1.0, 1.0, 1.0, 0.0]),    [0.8, 0.5, 0.2, 1.0]),
            Light(normalize([-1.0, 1.0, 1.0, 0.0]),    [0.2, 0.5, 0.8, 1.0]),
            Light.init, Light.init, Light.init
        ], 2);

        matBuf = createDynamicBuffer(cubeCount * Matrices.sizeof, BufferUsage.uniform);
        ligBuf = createStaticBuffer(lights, BufferUsage.uniform);
    }

    void prepareRenderPass() {
        const attachments = [
            AttachmentDescription(swapchain.format, 1,
                AttachmentOps(LoadOp.clear, StoreOp.store),
                AttachmentOps(LoadOp.dontCare, StoreOp.dontCare),
                trans(ImageLayout.presentSrc, ImageLayout.presentSrc),
                No.mayAlias
            )
        ];
        const subpasses = [
            SubpassDescription(
                [], [ AttachmentRef(0, ImageLayout.colorAttachmentOptimal) ],
                none!AttachmentRef, []
            )
        ];

        renderPass = device.createRenderPass(attachments, subpasses, []);

        framebuffers = new Framebuffer[scImages.length];
        foreach (i; 0 .. scImages.length) {
            framebuffers[i] = device.createFramebuffer(renderPass, [
                scImages[i].createView(
                    ImageType.d2,
                    ImageSubresourceRange(ImageAspect.color, 0, 1, 0, 1),
                    Swizzle.init
                )
            ], surfaceSize[0], surfaceSize[1], 1);
        }
        retainArray(framebuffers);
    }

    void preparePipeline()
    {
        auto vtxShader = device.createShaderModule(
            ShaderLanguage.spirV, import("shader.vert.spv"), "main"
        ).rc;
        auto fragShader = device.createShaderModule(
            ShaderLanguage.spirV, import("shader.frag.spv"), "main"
        ).rc;

        const layoutBindings = [
            PipelineLayoutBinding(0, DescriptorType.uniformBufferDynamic, 1, ShaderStage.vertex),
            PipelineLayoutBinding(1, DescriptorType.uniformBuffer, 1, ShaderStage.fragment),
        ];

        setLayout = device.createDescriptorSetLayout(layoutBindings);
        layout = device.createPipelineLayout([setLayout], []);

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
        info.viewports = [
            ViewportConfig(
                Viewport(0, 0, cast(float)surfaceSize[0], cast(float)surfaceSize[1], -1, 1),
                Rect(0, 0, surfaceSize[0], surfaceSize[1])
            )
        ];
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
        info.layout = layout;
        info.renderPass = renderPass;
        info.subpassIndex = 0;

        auto pls = device.createPipelines( [info] );
        pipeline = pls[0];
    }

    void prepareDescriptorSet() {
        const poolSizes = [
            DescriptorPoolSize(DescriptorType.uniformBufferDynamic, 1),
            DescriptorPoolSize(DescriptorType.uniformBuffer, 1),
        ];
        descPool = device.createDescriptorPool(1, poolSizes);
        set = descPool.allocate([ setLayout ])[0];

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

    void updateMatrices(in Matrices[] mat) {
        auto mm = mapMemory!Matrices(matBuf.boundMemory, 0, mat.length);
        mm[] = mat;
        MappedMemorySet mms;
        mm.addToSet(mms);
        device.flushMappedMemory(mms);
    }

    override void recordCmds(size_t cmdBufInd, size_t imgInd) {
        import gfx.core.typecons : trans;

        if (!perImages.length) {
            perImages = new PerImage[scImages.length];
        }

        const cv = ClearColorValues(0.6f, 0.6f, 0.6f, hasAlpha ? 0.5f : 1f);
        auto subrange = ImageSubresourceRange(ImageAspect.color, 0, 1, 0, 1);

        auto buf = cmdBufs[cmdBufInd];

        //buf.reset();
        buf.begin(No.persistent);

        if (perImages[imgInd].undefinedLayout) {
            buf.pipelineBarrier(
                trans(PipelineStage.colorAttachment, PipelineStage.colorAttachment), [],
                [ ImageMemoryBarrier(
                    trans(Access.none, Access.colorAttachmentWrite),
                    trans(ImageLayout.undefined, ImageLayout.presentSrc),
                    trans(graphicsQueueIndex, graphicsQueueIndex),
                    scImages[imgInd], subrange
                ) ]
            );
            perImages[imgInd].undefinedLayout = false;
        }

        buf.beginRenderPass(
            renderPass, framebuffers[imgInd],
            Rect(0, 0, surfaceSize[0], surfaceSize[1]), [ ClearValues(cv) ]
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
    }

}

int main() {

    try {
        auto example = new CrateExample();
        example.prepare();
        scope(exit) example.dispose();

        bool exitFlag;
        example.window.mouseOn = (uint, uint) {
            exitFlag = true;
        };

        import std.datetime.stopwatch : StopWatch;

        ulong frameCount;
        ulong lastUs;
        StopWatch sw;
        sw.start();

        enum reportFreq = 100;

        // 6 RPM at 60 FPS
        const puls = 6 * 2*PI / 3600f;
        auto angle = 0f;
        const view = mat4.look_at(vec3(0, -7, -2), vec3(0, 0, 0), vec3(0, -1, 0));
        const proj = mat4.perspective(640, 480, 45, 1, 10);
        const viewProj = proj*view;

        CrateExample.Matrices[3] matrices;

        while (!exitFlag) {

            foreach (m; 0 .. 3) {
                const posAngle = cast(float)(m * 2f * PI / 3f);
                const model = mat4.rotation(posAngle + angle, vec3(0, 0, 1))
                        * mat4.translation(2, 0, 0)
                        * mat4.rotation(-angle, vec3(0, 0, 1));
                const mvp = viewProj*model;
                const normals = model.inverse().transposed();
                matrices[m] = CrateExample.Matrices(
                    mvp.transposed().matrix,
                    normals.transposed().matrix
                );
            }

            example.updateMatrices(matrices);

            angle += puls;

            example.window.pollAndDispatch();
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