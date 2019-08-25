module pipeline;

import buffer;

import gfx.core;
import gfx.graal;
import gfx.math;

class DeferredPipelines : AtomicRefCounted
{
    struct Pl {
        DescriptorSetLayout[] descriptorLayouts;
        PipelineLayout layout;
        Pipeline pipeline;

        void release()
        {
            releaseObj(pipeline);
            releaseObj(layout);
            releaseArr(descriptorLayouts);
        }
    }

    Pl[] pls;

    this(Device device, RenderPass deferredRp, RenderPass bloomRp, RenderPass blendRp)
    {
        import std.algorithm : map;
        import std.array : array;

        auto infos = [
            geomInfo(device, deferredRp),
            lightInfo(device, deferredRp),
            bloomInfo(device, bloomRp),
            blendInfo(device, blendRp),
        ];

        pls = device.createPipelines(infos)
            .map!(pl => Pl([], null, retainObj(pl)))
            .array;

        foreach(i; 0 .. infos.length)
        {
            pls[i].layout = infos[i].layout;
            pls[i].descriptorLayouts = infos[i].layout.descriptorLayouts;
            releaseObj(infos[i].shaders.vertex);
            releaseObj(infos[i].shaders.fragment);
        }
    }

    override void dispose()
    {
        foreach(ref pl; pls) {
            pl.release();
        }
        pls = [];
    }

    @property Pl geom()
    {
        return pls[0];
    }

    @property Pl light()
    {
        return pls[1];
    }

    @property Pl bloom()
    {
        return pls[2];
    }

    @property Pl blend()
    {
        return pls[3];
    }

    final PipelineInfo geomInfo(Device device, RenderPass renderPass)
    {
        import std.typecons : No, Yes;

        const shaderSpv = [
            import("geom.vert.spv"), import("geom.frag.spv"),
        ];

        const layoutBindings = [
            PipelineLayoutBinding(
                0, DescriptorType.uniformBuffer, 1, ShaderStage.vertex
            ),
            PipelineLayoutBinding(
                1, DescriptorType.uniformBufferDynamic, 1, ShaderStage.vertex
            ),
        ];

        auto descriptorLayouts = [
            retainObj(device.createDescriptorSetLayout(layoutBindings))
        ];
        auto layout = retainObj(device.createPipelineLayout( descriptorLayouts, [] ));

        PipelineInfo info;
        info.shaders.vertex = retainObj(device.createShaderModule(
            cast(immutable(uint)[])shaderSpv[0], "main"
        ));
        info.shaders.fragment = retainObj(device.createShaderModule(
            cast(immutable(uint)[])shaderSpv[1], "main"
        ));
        info.inputBindings = [
            VertexInputBinding(0, P3N3Vertex.sizeof, No.instanced)
        ];
        info.inputAttribs = [
            VertexInputAttrib(0, 0, Format.rgb32_sFloat, 0),
            VertexInputAttrib(1, 0, Format.rgb32_sFloat, P3N3Vertex.normal.offsetof),
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
        info.layout = layout;
        info.renderPass = renderPass;
        info.subpassIndex = 0;

        return info;
    }

    final PipelineInfo lightInfo(Device device, RenderPass renderPass)
    {
        import std.typecons : No, Yes;

        const shaderSpv = [
            import("light.vert.spv"), import("light.frag.spv"),
        ];

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

        auto descriptorLayouts = [
            retainObj(device.createDescriptorSetLayout(bufLayoutBindings)),
            retainObj(device.createDescriptorSetLayout(attachLayoutBindings)),
        ];
        auto layout = retainObj(device.createPipelineLayout( descriptorLayouts, [] ));

        PipelineInfo info;
        info.shaders.vertex = retainObj(device.createShaderModule(
            cast(immutable(uint)[])shaderSpv[0], "main"
        ));
        info.shaders.fragment = retainObj(device.createShaderModule(
            cast(immutable(uint)[])shaderSpv[1], "main"
        ));
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
                ColorBlendAttachment.blend(
                    BlendState(
                        trans(BlendFactor.one, BlendFactor.one),
                        BlendOp.add,
                    ),
                ),
            ],
        );
        info.dynamicStates = [ DynamicState.viewport, DynamicState.scissor ];
        info.layout = layout;
        info.renderPass = renderPass;
        info.subpassIndex = 1;

        return info;
    }

    final PipelineInfo bloomInfo(Device device, RenderPass renderPass)
    {
        import std.typecons : No, Yes;

        const shaderSpv = [
            import("bloom.vert.spv"), import("bloom.frag.spv"),
        ];

        const layoutBindings = [
            PipelineLayoutBinding(
                0, DescriptorType.combinedImageSampler, 1, ShaderStage.fragment
            ),
        ];

        auto descriptorLayouts = [
            retainObj(device.createDescriptorSetLayout(layoutBindings)),
        ];
        // pc holds horizontal-vertical boolean
        const pushConstants = [
            PushConstantRange(ShaderStage.fragment, 0, uint.sizeof),
        ];
        auto layout = retainObj(device.createPipelineLayout( descriptorLayouts, pushConstants ));

        PipelineInfo info;
        info.shaders.vertex = retainObj(device.createShaderModule(
            cast(immutable(uint)[])shaderSpv[0], "main"
        ));
        info.shaders.fragment = retainObj(device.createShaderModule(
            cast(immutable(uint)[])shaderSpv[1], "main"
        ));
        info.inputBindings = [
            VertexInputBinding(0, P2T2Vertex.sizeof, No.instanced)
        ];
        info.inputAttribs = [
            VertexInputAttrib(0, 0, Format.rg32_sFloat, 0),
            VertexInputAttrib(1, 0, Format.rg32_sFloat, P2T2Vertex.texCoord.offsetof),
        ];
        info.assembly = InputAssembly(Primitive.triangleList, No.primitiveRestart);
        info.rasterizer = Rasterizer(
            PolygonMode.fill, Cull.none, FrontFace.ccw
        );
        info.blendInfo = ColorBlendInfo(
            none!LogicOp, [
                ColorBlendAttachment.solid(),
            ],
        );
        info.dynamicStates = [ DynamicState.viewport, DynamicState.scissor ];
        info.layout = layout;
        info.renderPass = renderPass;
        info.subpassIndex = 0;

        return info;
    }

    final PipelineInfo blendInfo(Device device, RenderPass renderPass)
    {
        import std.typecons : No, Yes;

        const shaderSpv = [
            import("blend.vert.spv"), import("blend.frag.spv"),
        ];

        const layoutBindings = [
            PipelineLayoutBinding(
                0, DescriptorType.inputAttachment, 2, ShaderStage.fragment
            ),
        ];

        auto descriptorLayouts = [
            retainObj(device.createDescriptorSetLayout(layoutBindings)),
        ];
        auto layout = retainObj(device.createPipelineLayout( descriptorLayouts, [] ));

        PipelineInfo info;
        info.shaders.vertex = retainObj(device.createShaderModule(
            cast(immutable(uint)[])shaderSpv[0], "main"
        ));
        info.shaders.fragment = retainObj(device.createShaderModule(
            cast(immutable(uint)[])shaderSpv[1], "main"
        ));
        info.inputBindings = [
            VertexInputBinding(0, P2T2Vertex.sizeof, No.instanced)
        ];
        info.inputAttribs = [
            VertexInputAttrib(0, 0, Format.rg32_sFloat, 0),
        ];
        info.assembly = InputAssembly(Primitive.triangleList, No.primitiveRestart);
        info.rasterizer = Rasterizer(
            PolygonMode.fill, Cull.none, FrontFace.ccw
        );
        info.blendInfo = ColorBlendInfo(
            none!LogicOp, [
                ColorBlendAttachment.solid(),
            ],
        );
        info.dynamicStates = [ DynamicState.viewport, DynamicState.scissor ];
        info.layout = layout;
        info.renderPass = renderPass;
        info.subpassIndex = 0;

        return info;
    }
}
