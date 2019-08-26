module triangle;

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

class TriangleExample : Example
{
    Rc!RenderPass renderPass;
    Rc!Pipeline pipeline;
    FrameData[] perImages;
    Rc!Buffer vertBuf;

    struct Vertex {
        float[4] position;
        float[4] color;
    }

    this(string[] args) {
        super("Triangle", args);
    }

    override void dispose()
    {
        if (device) {
            device.waitIdle();
        }
        vertBuf.unload();
        pipeline.unload();
        renderPass.unload();
        super.dispose();
    }

    override void prepare()
    {
        super.prepare();
        prepareBuffer();
        preparePipeline();
    }

    void prepareBuffer()
    {
        import gfx.math.proj : XYClip, xyClip;

        const high = ndc.xyClip == XYClip.rightHand ? -0.7f : 0.7f;
        const low = ndc.xyClip == XYClip.rightHand ?  0.7f : -0.7f;

        const vertexData = [
            Vertex([-0.7f,  low, 0f, 1f], [ 0f, 1f, 0f, 1f ]),
            Vertex([ 0.7f,  low, 0f, 1f], [ 1f, 0f, 0f, 1f ]),
            Vertex([   0f, high, 0f, 1f], [ 0f, 0f, 1f, 1f ]),
        ];

        vertBuf = createStaticBuffer(vertexData, BufferUsage.vertex);
    }

    override void prepareRenderPass()
    {
        const attachments = [
            AttachmentDescription(swapchain.format, 1,
                AttachmentOps(LoadOp.clear, StoreOp.store),
                AttachmentOps(LoadOp.dontCare, StoreOp.dontCare),
                trans(ImageLayout.undefined, ImageLayout.presentSrc),
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

    class TriangleFrameData : FrameData
    {
        PrimaryCommandBuffer cmdBuf;
        Rc!Framebuffer framebuffer;

        this(ImageBase swcColor, CommandBuffer tempBuf)
        {
            super(swcColor);
            cmdBuf = cmdPool.allocatePrimary(1)[0];

            framebuffer = device.createFramebuffer(this.outer.renderPass.obj, [
                swcColor.createView(
                    ImageType.d2,
                    ImageSubresourceRange(ImageAspect.color),
                    Swizzle.identity
                )
            ], size[0], size[1], 1);
        }

        override void dispose()
        {
            cmdPool.free([ cast(CommandBuffer)cmdBuf ]);
            framebuffer.unload();
            super.dispose();
        }
    }

    override FrameData makeFrameData(ImageBase swcColor, CommandBuffer tempBuf)
    {
        return new TriangleFrameData(swcColor, tempBuf);
    }

    void preparePipeline()
    {
        const spv = [
            import("shader.vert.spv"), import("shader.frag.spv")
        ];
        auto vtxShader = device.createShaderModule(
            cast(immutable(uint)[])spv[0], "main"
        ).rc;
        auto fragShader = device.createShaderModule(
            cast(immutable(uint)[])spv[1], "main"
        ).rc;
        auto pl = device.createPipelineLayout([], []).rc;

        PipelineInfo info;
        info.shaders.vertex = vtxShader;
        info.shaders.fragment = fragShader;
        info.inputBindings = [
            VertexInputBinding(0, Vertex.sizeof, No.instanced)
        ];
        info.inputAttribs = [
            VertexInputAttrib(0, 0, Format.rgba32_sFloat, 0),
            VertexInputAttrib(1, 0, Format.rgba32_sFloat, Vertex.color.offsetof),
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
        info.layout = pl;
        info.renderPass = renderPass;
        info.subpassIndex = 0;

        auto pls = device.createPipelines( [info] );
        pipeline = pls[0];
    }


    override Submission[] recordCmds(FrameData frameData)
    {
        import gfx.graal.types : trans;

        auto tfd = cast(TriangleFrameData)frameData;
        auto buf = tfd.cmdBuf;

        const cv = ClearColorValues(0.6f, 0.6f, 0.6f, hasAlpha ? 0.5f : 1f);

        buf.begin(CommandBufferUsage.oneTimeSubmit);

        buf.beginRenderPass(
            renderPass, tfd.framebuffer,
            Rect(0, 0, surfaceSize[0], surfaceSize[1]), [ ClearValues(cv) ]
        );

        buf.bindPipeline(pipeline);
        buf.bindVertexBuffers(0, [ VertexBinding(vertBuf, 0) ]);
        buf.draw(3, 1, 0, 0);

        buf.endRenderPass();

        buf.end();

        return simpleSubmission([ buf ]);
    }

}

int main(string[] args)
{
    try {

        auto example = new TriangleExample(args);
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
