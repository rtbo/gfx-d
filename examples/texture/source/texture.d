module texture;

import example;

import gfx.core.rc;
import gfx.core.typecons;
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
import gfx.window;
import gfx.window.keys;

import gl3n.linalg : mat4, mat3, vec3, vec4;

import std.exception;
import std.stdio;
import std.typecons;
import std.math;

class TextureExample : Example
{
    Rc!RenderPass renderPass;
    Rc!Pipeline pipeline;
    Rc!PipelineLayout layout;
    ushort[] indices;
    Rc!Buffer vertBuf;
    Rc!Buffer indBuf;
    Rc!Buffer matBuf;
    Rc!Buffer ligBuf;
    Rc!Image texImg;
    Rc!ImageView texView;
    Rc!Sampler texSampler;
    Rc!DescriptorPool descPool;
    Rc!DescriptorSetLayout setLayout;
    DescriptorSet set;

    struct Vertex {
        float[3] position;
        float[3] normal;
        float[2] tex;
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

    this(string[] args) {
        super("Texture", args);
    }

    override void dispose()
    {
        if (device) {
            device.waitIdle();
        }
        vertBuf.unload();
        indBuf.unload();
        matBuf.unload();
        ligBuf.unload();
        texImg.unload();
        texView.unload();
        texSampler.unload();
        setLayout.unload();
        descPool.unload();
        layout.unload();
        pipeline.unload();
        renderPass.unload();
        super.dispose();
    }

    override void prepare()
    {
        super.prepare();
        prepareBuffers();
        prepareTexture();
        preparePipeline();
        prepareDescriptorSet();
    }

    void prepareBuffers()
    {
        import gfx.genmesh.cube : genCube;
        import gfx.genmesh.algorithm : indexCollectMesh, triangulate, vertices;
        import gfx.genmesh.poly : quad;
        import std.algorithm : map;

        auto crate = genCube()
                .map!(f => quad(
                    Vertex( f[0].p, f[0].n, [ 0f, 0f ] ),
                    Vertex( f[1].p, f[1].n, [ 0f, 1f ] ),
                    Vertex( f[2].p, f[2].n, [ 1f, 1f ] ),
                    Vertex( f[3].p, f[3].n, [ 1f, 0f ] ),
                ))
                .triangulate()
                .vertices()
                .indexCollectMesh();

        auto normalize(in float[4] vec) {
            return vec4(vec).normalized().vector;
        }
        const lights = Lights( [
            Light(normalize([1.0, 1.0, -1.0, 0.0]),    [0.8, 0.5, 0.2, 1.0]),
            Light(normalize([-1.0, 1.0, -1.0, 0.0]),    [0.2, 0.5, 0.8, 1.0]),
            Light.init, Light.init, Light.init
        ], 2);

        indices = crate.indices;
        vertBuf = createStaticBuffer(crate.vertices, BufferUsage.vertex);
        indBuf = createStaticBuffer(crate.indices, BufferUsage.index);

        matBuf = createDynamicBuffer(Matrices.sizeof, BufferUsage.uniform);
        ligBuf = createStaticBuffer(lights, BufferUsage.uniform);
    }

    void prepareTexture()
    {
        import img : ImageFormat, ImgImage = Image;
        auto img = ImgImage.loadFromView!("crate.jpg")(ImageFormat.argb);
        texImg = createTextureImage(
            cast(const(void)[])img.data, ImageInfo.d2(img.width, img.height).withFormat(Format.rgba8_uNorm)
        );
        // argb swizzling
        version(LittleEndian) {
            const swizzle = Swizzle.bgra;
        }
        else {
            const swizzle = Swizzle.argb;
        }
        texView = texImg.createView(ImageType.d2, ImageSubresourceRange(ImageAspect.color), swizzle);

        import gfx.core.typecons : some;

        texSampler = device.createSampler(SamplerInfo(
            Filter.linear, Filter.linear, Filter.nearest,
            [WrapMode.repeat, WrapMode.repeat, WrapMode.repeat],
            some(16f), 0f, [0f, 0f]
        ));
    }

    override void prepareRenderPass()
    {
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
    }

    override void prepareFramebuffer(PerImage imgData, CommandBuffer layoutChangeCmdBuf)
    {
        imgData.framebuffer = device.createFramebuffer(renderPass, [
            imgData.color.createView(
                ImageType.d2,
                ImageSubresourceRange(ImageAspect.color),
                Swizzle.identity
            )
        ], surfaceSize[0], surfaceSize[1], 1);
    }

    void preparePipeline()
    {
        auto vtxShader = device.createShaderModule(
            cast(immutable(uint)[])import("shader.vert.spv"), "main"
        ).rc;
        auto fragShader = device.createShaderModule(
            cast(immutable(uint)[])import("shader.frag.spv"), "main"
        ).rc;

        const layoutBindings = [
            PipelineLayoutBinding(0, DescriptorType.uniformBuffer, 1, ShaderStage.vertex),
            PipelineLayoutBinding(1, DescriptorType.uniformBuffer, 1, ShaderStage.fragment),
            PipelineLayoutBinding(2, DescriptorType.combinedImageSampler, 1, ShaderStage.fragment),
        ];

        setLayout = device.createDescriptorSetLayout(layoutBindings);
        layout = device.createPipelineLayout([ setLayout.obj ], []);

        PipelineInfo info;
        info.shaders.vertex = vtxShader;
        info.shaders.fragment = fragShader;
        info.inputBindings = [
            VertexInputBinding(0, Vertex.sizeof, No.instanced)
        ];
        info.inputAttribs = [
            VertexInputAttrib(0, 0, Format.rgb32_sFloat, 0),
            VertexInputAttrib(1, 0, Format.rgb32_sFloat, Vertex.normal.offsetof),
            VertexInputAttrib(2, 0, Format.rg32_sFloat, Vertex.tex.offsetof),
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

    void prepareDescriptorSet()
    {
        const poolSizes = [
            DescriptorPoolSize(DescriptorType.uniformBuffer, 2),
            DescriptorPoolSize(DescriptorType.combinedImageSampler, 1)
        ];
        descPool = device.createDescriptorPool(1, poolSizes);
        set = descPool.allocate([ setLayout.obj ])[0];

        auto writes = [
            WriteDescriptorSet(set, 0, 0, new UniformBufferDescWrites([
                BufferRange(matBuf, 0, Matrices.sizeof)
            ])),
            WriteDescriptorSet(set, 1, 0, new UniformBufferDescWrites([
                BufferRange(ligBuf, 0, Lights.sizeof)
            ])),
            WriteDescriptorSet(set, 2, 0, new CombinedImageSamplerDescWrites([
                CombinedImageSampler(texSampler, texView, ImageLayout.shaderReadOnlyOptimal)
            ]))
        ];
        device.updateDescriptorSets(writes, []);
    }

    void updateMatrices(in Matrices mat)
    {
        auto mm = matBuf.boundMemory.map();
        auto v = mm.view!(Matrices[])(0, 1);
        v[0] = mat;
        MappedMemorySet mms;
        mm.addToSet(mms);
        device.flushMappedMemory(mms);
    }

    override void recordCmds(PerImage imgData)
    {
        import gfx.graal.types : trans;

        const cv = ClearColorValues(0.6f, 0.6f, 0.6f, hasAlpha ? 0.5f : 1f);
        auto subrange = ImageSubresourceRange(ImageAspect.color, 0, 1, 0, 1);

        auto buf = imgData.cmdBufs[0];

        //buf.reset();
        buf.begin(No.persistent);

        buf.beginRenderPass(
            renderPass, imgData.framebuffer,
            Rect(0, 0, surfaceSize[0], surfaceSize[1]), [ ClearValues(cv) ]
        );

        buf.bindPipeline(pipeline);
        buf.bindVertexBuffers(0, [ VertexBinding(vertBuf, 0) ]);
        buf.bindIndexBuffer(indBuf, 0, IndexType.u16);
        buf.bindDescriptorSets(PipelineBindPoint.graphics, layout, 0, [set], []);
        buf.drawIndexed(cast(uint)indices.length, 1, 0, 0, 0);

        buf.endRenderPass();

        buf.end();
    }

}

/// correction matrix for the vulkan coordinate system
// (gl3n is made with opengl in mind)
mat4 correctionMatrix() pure
{
    return mat4(
        1f, 0f, 0f, 0f,
        0f, -1f, 0f, 0f,
        0f, 0f, 0.5f, 0.5f,
        0f, 0f, 0f, 1f,
    );
}

int main(string[] args)
{
    try {
        auto example = new TextureExample(args);
        example.prepare();
        scope(exit) example.dispose();

        example.window.onKeyOn = (KeyEvent ev)
        {
            if (ev.sym == KeySym.escape) {
                example.window.closeFlag = true;
            }
        };

        // 6 RPM at 60 FPS
        const puls = 6 * 2*PI / 3600f;
        auto angle = 0f;
        const view = mat4.look_at(vec3(0, -5, 3), vec3(0, 0, 0), vec3(0, 0, 1));
        const proj = mat4.perspective(640, 480, 45, 1, 10);
        const viewProj = correctionMatrix() * proj*view;

        while (!example.window.closeFlag) {
            const model = mat4.rotation(angle, vec3(0, 0, 1));
            const mvp = viewProj*model;
            const normals = model.inverse().transposed();
            angle += puls;

            example.updateMatrices( TextureExample.Matrices(
                mvp.transposed().matrix,
                normals.transposed().matrix
            ) );

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
