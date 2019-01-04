module declapi;

import example;

import gfx.core.rc;
import gfx.core.typecons;
import gfx.decl.engine;
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
import gfx.graal.types;

import gfx.math;

import std.exception;
import std.stdio;
import std.typecons;
import std.math;

class DeclAPIExample : Example
{
    Rc!RenderPass renderPass;
    Rc!Pipeline pipeline;
    Rc!PipelineLayout layout;
    size_t cubeLen;
    enum cubeCount = 3;
    const(ushort)[] indices;
    Rc!Buffer vertBuf;
    Rc!Buffer indBuf;
    Rc!Buffer matBuf;
    Rc!Buffer ligBuf;
    Rc!DescriptorPool descPool;
    Rc!DescriptorSetLayout setLayout;
    DescriptorSet set;

    DeclarativeEngine declEng;

    struct Vertex
    {
        @(Format.rgb32_sFloat)
        FVec3 position;

        @(Format.rgb32_sFloat)
        FVec3 normal;

        @(Format.rgba32_sFloat)
        FVec4 color;
    }

    struct Matrices {
        FMat4 mvp;
        FMat4 normal;
    }

    enum maxLights = 5;

    struct Light {
        FVec4 direction;
        FVec4 color;
    }

    struct Lights {
        Light[maxLights] lights;
        uint num;
    }

    this(string[] args) {
        super("Declarative API", args);
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
        declEng.dispose();
        super.dispose();
    }

    override void prepare() {

        super.prepare();

        prepareBuffers();
        preparePipeline();
        prepareDescriptorSet();
    }

    void prepareBuffers() {

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
        vertBuf = createStaticBuffer(verts, BufferUsage.vertex);
        indBuf = createStaticBuffer(indices, BufferUsage.index);

        const lights = Lights( [
            Light(normalize(fvec(1.0, 1.0, -1.0, 0.0)),  fvec(0.8, 0.5, 0.2, 1.0)),
            Light(normalize(fvec(-1.0, 1.0, -1.0, 0.0)), fvec(0.2, 0.5, 0.8, 1.0)),
            Light.init, Light.init, Light.init
        ], 2);

        matBuf = createDynamicBuffer(cubeCount * Matrices.sizeof, BufferUsage.uniform);
        ligBuf = createStaticBuffer(lights, BufferUsage.uniform);
    }

    override void prepareRenderPass()
    {
        // need a valid device and swapchain, so we prepare it here
        declEng = new DeclarativeEngine(device);
        declEng.declareStruct!Vertex();
        declEng.addView!"shader.vert.spv"();
        declEng.addView!"shader.frag.spv"();
        declEng.store.store("sc_format", swapchain.format);
        declEng.store.store("depth_format", findDepthFormat());
        declEng.parseSDLView!"pipeline.sdl"();

        renderPass = declEng.store.expect!RenderPass("rp");
    }

    override void prepareFramebuffer(PerImage imgData, CommandBuffer layoutChangeCmdBuf)
    {
        imgData.depth = createDepthImage(surfaceSize[0], surfaceSize[1]);

        auto colorView = imgData.color.createView(
            ImageType.d2, ImageSubresourceRange(ImageAspect.color), Swizzle.identity
        ).rc;
        auto depthView = imgData.depth.createView(
            ImageType.d2, ImageSubresourceRange(ImageAspect.depth), Swizzle.identity
        ).rc;

        imgData.framebuffer = device.createFramebuffer(renderPass, [
            colorView.obj, depthView.obj
        ], surfaceSize[0], surfaceSize[1], 1);
    }

    void preparePipeline()
    {
        setLayout = declEng.store.expect!DescriptorSetLayout("dsl");
        layout = declEng.store.expect!PipelineLayout("layout");
        pipeline = declEng.store.expect!Pipeline("pl");
    }

    void prepareDescriptorSet()
    {
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
        auto mm = matBuf.boundMemory.map();
        auto v = mm.view!(Matrices[])(0, mat.length);
        v[] = mat;
        MappedMemorySet mms;
        mm.addToSet(mms);
        device.flushMappedMemory(mms);
    }

    override void recordCmds(PerImage imgData)
    {
        import gfx.graal.types : trans;

        const ccv = ClearColorValues(0.6f, 0.6f, 0.6f, hasAlpha ? 0.5f : 1f);
        const dcv = ClearDepthStencilValues(1f, 0);

        CommandBuffer buf = imgData.cmdBufs[0];

        buf.begin(No.persistent);

        buf.setViewport(0, [ Viewport(0f, 0f, cast(float)surfaceSize[0], cast(float)surfaceSize[1]) ]);
        buf.setScissor(0, [ Rect(0, 0, surfaceSize[0], surfaceSize[1]) ]);

        buf.beginRenderPass(
            renderPass, imgData.framebuffer,
            Rect(0, 0, surfaceSize[0], surfaceSize[1]),
            [ ClearValues(ccv), ClearValues(dcv) ]
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

int main(string[] args)
{
    try {
        auto example = new DeclAPIExample(args);
        example.prepare();
        scope(exit) example.dispose();

        example.window.onMouseOn = (uint, uint) {
            example.window.closeFlag = true;
        };

        // 6 RPM at 60 FPS
        const puls = 6 * 2*PI / 3600f;
        auto angle = 0f;
        const view = lookAt(fvec(0, -7, 2), fvec(0, 0, 0), fvec(0, 0, 1));
        const proj = perspective!float(example.ndc, 45, 4f/3f, 1f, 10f);
        const viewProj = proj*view;

        DeclAPIExample.Matrices[3] matrices;

        while (!example.window.closeFlag) {

            import gfx.math.inverse : affineInverse;

            foreach (m; 0 .. 3) {
                const posAngle = cast(float)(m * 2f * PI / 3f);
                const model = rotation(posAngle + angle, fvec(0, 0, 1))
                        * translation(2f, 0f, 0f)
                        * rotation(-angle, fvec(0, 0, 1));
                const mvp = viewProj*model;
                matrices[m] = DeclAPIExample.Matrices(
                    mvp.transpose(),
                    model.affineInverse(), // need the transpose of model inverse
                );
            }
            angle += puls;
            example.updateMatrices(matrices);

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
