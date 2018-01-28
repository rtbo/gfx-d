module triangle;

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

import std.exception;
import std.stdio;
import std.typecons;

class TriangleExample : Example
{
    Rc!RenderPass renderPass;
    Framebuffer[] framebuffers;
    Rc!Pipeline pipeline;
    PerImage[] perImages;
    Rc!Buffer vertBuf;

    struct PerImage {
        bool undefinedLayout=true;
    }

    struct Vertex {
        float[4] position;
        float[4] color;
    }

    this() {
        super("Triangle");
    }

    override void dispose() {
        if (device) {
            device.waitIdle();
        }
        vertBuf.unload();
        pipeline.unload();
        renderPass.unload();
        releaseArray(framebuffers);
        super.dispose();
    }

    override void prepare() {
        super.prepare();
        prepareBuffer();
        prepareRenderPass();
        preparePipeline();
    }

    void prepareBuffer() {
        const vertexData = [
            Vertex([ 0.7f, -0.7f, 0f, 1f], [ 1f, 0f, 0f, 1f ]),
            Vertex([-0.7f, -0.7f, 0f, 1f], [ 0f, 1f, 0f, 1f ]),
            Vertex([   0f,  0.7f, 0f, 1f], [ 0f, 0f, 1f, 1f ]),
        ];
        const dataSize = vertexData.length * Vertex.sizeof;

        vertBuf = device.createBuffer( BufferUsage.vertex, dataSize );

        const mr = vertBuf.memoryRequirements;
        const props = mr.props | MemProps.hostVisible;
        const devMemProps = physicalDevice.memoryProperties;
        uint memTypeInd = uint.max;
        foreach (uint i, mt; devMemProps.types) {
            if ((mt.props & props) == props) {
                memTypeInd = i;
                break;
            }
        }
        enforce(memTypeInd != uint.max, "Could not find a memory type");

        auto mem = device.allocateMemory(memTypeInd, mr.size).rc;
        {
            auto mm = mapMemory!Vertex(mem, 0, vertexData.length);
            mm[] = vertexData;
            MappedMemorySet mms;
            mm.addToSet(mms);
            device.flushMappedMemory(mms);
        }

        vertBuf.bindMemory(mem, 0);
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
    }

    void preparePipeline()
    {
        auto vtxShader = device.createShaderModule(
            ShaderLanguage.spirV, import("shader.vert.spv"), "main"
        ).rc;
        auto fragShader = device.createShaderModule(
            ShaderLanguage.spirV, import("shader.frag.spv"), "main"
        ).rc;

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
        info.layout = device.createPipelineLayout();
        info.renderPass = renderPass;
        info.subpassIndex = 0;

        auto pls = device.createPipelines( [info] );
        pipeline = pls[0];
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
        buf.bindVertexBuffers(0, [ VertexBinding(vertBuf, 0) ]);
        buf.draw(3, 1, 0, 0);

        buf.endRenderPass();

        buf.end();
    }

}

int main() {

    try {
        auto example = new TriangleExample();
        example.prepare();
        scope(exit) example.dispose();

        bool exitFlag;
        example.window.mouseOn = (uint, uint) {
            exitFlag = true;
        };

        import std.datetime.stopwatch : StopWatch;

        size_t frameCount;
        size_t lastUs;
        StopWatch sw;
        sw.start();

        enum reportFreq = 100;

        while (!exitFlag) {
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
