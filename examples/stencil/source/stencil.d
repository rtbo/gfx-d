module stencil;

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

import std.exception;
import std.stdio;
import std.typecons;

class StencilExample : Example
{
    Rc!RenderPass renderPass;
    Rc!Pipeline stencilWritePipeline;
    Rc!DescriptorSetLayout stencilWriteDSL;
    Rc!PipelineLayout stencilWriteLayout;
    DescriptorSet descriptorSet;
    Rc!DescriptorPool descPool;

    Rc!Pipeline solidPipeline;

    Rc!Buffer vertBuf;
    Rc!Buffer indBuf;
    Rc!Image chessboard;
    Rc!ImageView chessboardView;
    Rc!Sampler sampler;

    struct VertexP2T2 {
        float[2] position;
        float[2] texCoord;
    }
    immutable square = [
        VertexP2T2([-1.0,  1.0], [0.0, 1.0]),
        VertexP2T2([-1.0, -1.0], [0.0, 0.0]),
        VertexP2T2([ 1.0, -1.0], [1.0, 0.0]),
        VertexP2T2([ 1.0,  1.0], [1.0, 1.0]),
    ];
    immutable squareLen = square.length * VertexP2T2.sizeof;
    immutable ushort[] squareIndices = [
        0, 1, 2,    0, 2, 3
    ];


    struct VertexP2C3 {
        float[2] position;
        float[3] color;
    }
    immutable triangle = [
        VertexP2C3([-1.0,  1.0], [1.0, 0.0, 0.0]),
        VertexP2C3([ 1.0,  1.0], [0.0, 1.0, 0.0]),
        VertexP2C3([ 0.0, -1.0], [0.0, 0.0, 1.0]),
    ];
    immutable triangleLen = triangle.length * VertexP2C3.sizeof;


    this(string[] args) {
        super("Stencil", args);
    }

    override void dispose() {
        if (device) {
            device.waitIdle();
        }
        renderPass.unload();
        stencilWritePipeline.unload();
        stencilWriteDSL.unload();
        stencilWriteLayout.unload();
        descPool.unload();

        solidPipeline.unload();

        vertBuf.unload();
        indBuf.unload();
        chessboard.unload();
        chessboardView.unload();
        sampler.unload();

        super.dispose();
    }

    override void prepare()
    {
        super.prepare();
        prepareChessboard();
        prepareBuffer();
        preparePipeline();
        prepareDescriptorSet();
    }

    void prepareChessboard()
    {
        auto data = new ubyte[32*32];
        foreach (r; 0 .. 32) {
            foreach (c; 0 .. 32) {
                immutable oddR = (r/4)%2 != 0;
                immutable oddC = (c/4)%2 != 0;
                data[r*32 + c] = oddR == oddC ? 0xff : 0x00;
            }
        }
        chessboard = createTextureImage(
            cast(const(void)[])data, ImageInfo.d2(32, 32).withFormat(Format.r8_uNorm)
        );
        chessboardView = chessboard.createView(
            ImageType.d2, ImageSubresourceRange(ImageAspect.color), Swizzle.identity
        );
        import gfx.core.typecons : none;
        sampler = device.createSampler(SamplerInfo(
            Filter.nearest, Filter.nearest, Filter.nearest,
            [WrapMode.repeat, WrapMode.repeat, WrapMode.repeat],
            none!float, 0f, [0f, 0f]
        ));
    }

    void prepareBuffer()
    {
        auto data = new ubyte[squareLen + triangleLen];
        data[0 .. squareLen] = cast(immutable(ubyte)[])square;
        data[squareLen .. squareLen+triangleLen] = cast(immutable(ubyte[]))triangle;
        vertBuf = createStaticBuffer(data, BufferUsage.vertex);

        indBuf = createStaticBuffer(squareIndices, BufferUsage.index);
    }

    override void prepareRenderPass()
    {
        const attachments = [
            AttachmentDescription(
                swapchain.format, 1,
                AttachmentOps(LoadOp.clear, StoreOp.store),
                AttachmentOps(LoadOp.dontCare, StoreOp.dontCare),
                trans(ImageLayout.presentSrc, ImageLayout.presentSrc),
                No.mayAlias
            ),
            AttachmentDescription(
                Format.s8_uInt, 1,
                AttachmentOps(LoadOp.dontCare, StoreOp.dontCare),
                AttachmentOps(LoadOp.dontCare, StoreOp.dontCare),
                trans(ImageLayout.depthStencilAttachmentOptimal, ImageLayout.depthStencilAttachmentOptimal),
                No.mayAlias
            ),
        ];
        const subpasses = [
            // subpass 1: write stencil buffer from texture
            // subpass 2: render with stencil masking
            SubpassDescription(
                [], [], some(AttachmentRef(1, ImageLayout.depthStencilAttachmentOptimal)), []
            ),
            SubpassDescription(
                [], [ AttachmentRef(0, ImageLayout.colorAttachmentOptimal) ],
                some(AttachmentRef(1, ImageLayout.depthStencilAttachmentOptimal)), []
            )
        ];
        const dependencies = [
            SubpassDependency(
                trans!uint(0, 1),
                trans(PipelineStage.lateFragmentTests, PipelineStage.earlyFragmentTests),
                trans(Access.depthStencilAttachmentWrite, Access.depthStencilAttachmentRead)
            )
        ];

        renderPass = device.createRenderPass(attachments, subpasses, dependencies);
    }

    override void prepareFramebuffer(PerImage imgData, PrimaryCommandBuffer layoutChangeCmdBuf)
    {
        imgData.stencil = createStencilImage(surfaceSize[0], surfaceSize[1]);

        auto colorView = imgData.color.createView(
            ImageType.d2, ImageSubresourceRange(ImageAspect.color), Swizzle.identity
        ).rc;
        auto stencilView = imgData.stencil.createView(
            ImageType.d2, ImageSubresourceRange(ImageAspect.stencil), Swizzle.identity
        ).rc;
        imgData.framebuffer = device.createFramebuffer(renderPass, [
            colorView.obj, stencilView.obj
        ], surfaceSize[0], surfaceSize[1], 1);
    }

    void preparePipeline()
    {
        auto swVs = device.createShaderModule(
            cast(immutable(uint)[])import("stencil.vert.spv"), "main"
        ).rc;
        auto swFs = device.createShaderModule(
            cast(immutable(uint)[])import("stencil.frag.spv"), "main"
        ).rc;
        stencilWriteDSL = device.createDescriptorSetLayout([
            PipelineLayoutBinding(0, DescriptorType.combinedImageSampler, 1, ShaderStage.fragment),
        ]);
        stencilWriteLayout = device.createPipelineLayout([ stencilWriteDSL.obj ], []);

        PipelineInfo swInfo;
        swInfo.shaders.vertex = swVs;
        swInfo.shaders.fragment = swFs;
        swInfo.inputBindings = [
            VertexInputBinding(0, VertexP2T2.sizeof, No.instanced)
        ];
        swInfo.inputAttribs = [
            VertexInputAttrib(0, 0, Format.rg32_sFloat, VertexP2T2.position.offsetof),
            VertexInputAttrib(1, 0, Format.rg32_sFloat, VertexP2T2.texCoord.offsetof),
        ];
        swInfo.assembly = InputAssembly(Primitive.triangleList, No.primitiveRestart);
        swInfo.rasterizer = Rasterizer(
            PolygonMode.fill, Cull.none, FrontFace.ccw, No.depthClamp,
            none!DepthBias, 1f
        );
        swInfo.viewports = [
            ViewportConfig(
                Viewport(0, 0, cast(float)surfaceSize[0], cast(float)surfaceSize[1]),
                Rect(0, 0, surfaceSize[0], surfaceSize[1])
            )
        ];
        const sos1 = StencilOpState(
            StencilOp.replace, StencilOp.replace, StencilOp.replace, CompareOp.always,
            0x01, 0x01, 0x01
        );
        swInfo.stencilInfo = StencilInfo(
            Yes.enabled, sos1, sos1
        );
        swInfo.layout = stencilWriteLayout;
        swInfo.renderPass = renderPass;
        swInfo.subpassIndex = 0;


        auto solVs = device.createShaderModule(
            cast(immutable(uint)[])import("solid.vert.spv"), "main"
        ).rc;
        auto solFs = device.createShaderModule(
            cast(immutable(uint)[])import("solid.frag.spv"), "main"
        ).rc;
        auto solPL = device.createPipelineLayout([], []).rc;

        PipelineInfo solInfo;
        solInfo.shaders.vertex = solVs;
        solInfo.shaders.fragment = solFs;
        solInfo.inputBindings = [
            VertexInputBinding(0, VertexP2C3.sizeof, No.instanced)
        ];
        solInfo.inputAttribs = [
            VertexInputAttrib(0, 0, Format.rg32_sFloat, VertexP2C3.position.offsetof),
            VertexInputAttrib(1, 0, Format.rgb32_sFloat, VertexP2C3.color.offsetof),
        ];
        solInfo.assembly = InputAssembly(Primitive.triangleList, No.primitiveRestart);
        solInfo.rasterizer = Rasterizer(
            PolygonMode.fill, Cull.none, FrontFace.ccw, No.depthClamp,
            none!DepthBias, 1f
        );
        solInfo.viewports = [
            ViewportConfig(
                Viewport(0, 0, cast(float)surfaceSize[0], cast(float)surfaceSize[1]),
                Rect(0, 0, surfaceSize[0], surfaceSize[1])
            )
        ];
        solInfo.blendInfo = ColorBlendInfo(
            none!LogicOp, [ ColorBlendAttachment.solid() ], [ 0f, 0f, 0f, 0f ]
        );
        const sos2 = StencilOpState(
            StencilOp.keep, StencilOp.keep, StencilOp.keep, CompareOp.equal,
            0x01, 0x01, 0x01
        );
        solInfo.stencilInfo = StencilInfo(
            Yes.enabled, sos2, sos2
        );
        solInfo.layout = solPL;
        solInfo.renderPass = renderPass;
        solInfo.subpassIndex = 1;

        auto pls = device.createPipelines( [ swInfo, solInfo ] );
        stencilWritePipeline = pls[0];
        solidPipeline = pls[1];
    }

    void prepareDescriptorSet() {
        const poolSizes = [
            DescriptorPoolSize(DescriptorType.combinedImageSampler, 1),
        ];
        descPool = device.createDescriptorPool(1, poolSizes);
        descriptorSet = descPool.allocate([ stencilWriteDSL.obj ])[0];

        auto writes = [
            WriteDescriptorSet(descriptorSet, 0, 0, new CombinedImageSamplerDescWrites([
                CombinedImageSampler(sampler, chessboardView, ImageLayout.shaderReadOnlyOptimal)
            ]))
        ];
        device.updateDescriptorSets(writes, []);
    }


    override void recordCmds(PerImage imgData)
    {
        import gfx.graal.types : trans;

        const cv = ClearColorValues(0.6f, 0.6f, 0.6f, hasAlpha ? 0.5f : 1f);
        const dsv = ClearDepthStencilValues(0f, 0);

        auto buf = imgData.cmdBufs[0];

        buf.begin(No.persistent);

        buf.beginRenderPass(
            renderPass, imgData.framebuffer,
            Rect(0, 0, surfaceSize[0], surfaceSize[1]),
            [ ClearValues(cv), ClearValues(dsv) ]
        );

            buf.bindPipeline(stencilWritePipeline);
            buf.bindIndexBuffer(indBuf, 0, IndexType.u16);
            buf.bindVertexBuffers(0, [ VertexBinding(vertBuf, 0) ]);
            buf.bindDescriptorSets(
                PipelineBindPoint.graphics, stencilWriteLayout, 0,
                [ descriptorSet ], []
            );
            buf.drawIndexed(cast(uint)squareIndices.length, 1, 0, 0, 0);

        buf.nextSubpass();

            buf.bindPipeline(solidPipeline);
            buf.bindVertexBuffers(0, [ VertexBinding(vertBuf, squareLen) ]);
            buf.draw(3, 1, 0, 0);

        buf.endRenderPass();

        buf.end();
    }

}

int main(string[] args)
{
    try {
        auto example = new StencilExample(args);
        example.prepare();
        scope(exit) example.dispose();

        example.window.onKeyOn = (KeyEvent ev)
        {
            if (ev.sym == KeySym.escape) {
                example.window.closeFlag = true;
            }
        };

        while (!example.window.closeFlag) {
            example.display.pollAndDispatch();
            example.render();
            example.frameTick();
        }

        return 0;
    }
    catch(Exception ex) {
        stderr.writeln("error occured: ", ex.msg);
        return 1;
    }
}
