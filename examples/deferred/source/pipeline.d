module pipeline;

import scene;

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

    Pl geom;
    Pl light;
    Pl bulb;

    this(Device device, RenderPass renderPass)
    {
        auto infos = [
            geomInfo(device, renderPass),
            lightInfo(device, renderPass),
            bulbInfo(device, renderPass),
        ];

        auto pls = device.createPipelines(infos);
        geom.pipeline = retainObj(pls[0]);
        light.pipeline = retainObj(pls[1]);
        bulb.pipeline = retainObj(pls[2]);

        releaseObj(infos[0].shaders.vertex);
        releaseObj(infos[0].shaders.fragment);
        releaseObj(infos[1].shaders.vertex);
        releaseObj(infos[1].shaders.fragment);
        releaseObj(infos[2].shaders.vertex);
        releaseObj(infos[2].shaders.fragment);
    }

    override void dispose()
    {
        geom.release();
        light.release();
        bulb.release();
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

        geom.descriptorLayouts = [
            retainObj(device.createDescriptorSetLayout(layoutBindings))
        ];
        geom.layout = retainObj(device.createPipelineLayout( geom.descriptorLayouts, [] ));

        PipelineInfo info;
        info.shaders.vertex = retainObj(device.createShaderModule(
            cast(immutable(uint)[])shaderSpv[0], "main"
        ));
        info.shaders.fragment = retainObj(device.createShaderModule(
            cast(immutable(uint)[])shaderSpv[1], "main"
        ));
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
        info.layout = geom.layout;
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

        light.descriptorLayouts = [
            retainObj(device.createDescriptorSetLayout(bufLayoutBindings)),
            retainObj(device.createDescriptorSetLayout(attachLayoutBindings)),
        ];
        light.layout = retainObj(device.createPipelineLayout( light.descriptorLayouts, [] ));

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
            ],
        );
        info.dynamicStates = [ DynamicState.viewport, DynamicState.scissor ];
        info.layout = light.layout;
        info.renderPass = renderPass;
        info.subpassIndex = 1;

        return info;
    }

    final PipelineInfo bulbInfo(Device device, RenderPass renderPass)
    {
        import std.typecons : No, Yes;

        const shaderSpv = [
            import("bulb.vert.spv"), import("bulb.frag.spv"),
        ];


        bulb.descriptorLayouts = geom.descriptorLayouts;
        retainArr(bulb.descriptorLayouts);
        bulb.layout = retainObj(geom.layout);

        PipelineInfo info;
        info.shaders.vertex = retainObj(device.createShaderModule(
            cast(immutable(uint)[])shaderSpv[0], "main"
        ));
        info.shaders.fragment = retainObj(device.createShaderModule(
            cast(immutable(uint)[])shaderSpv[1], "main"
        ));
        info.inputBindings = [
            VertexInputBinding(0, Vertex.sizeof, No.instanced)
        ];
        info.inputAttribs = [
            VertexInputAttrib(0, 0, Format.rgb32_sFloat, 0),
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
                ColorBlendAttachment.blend(
                    BlendState(
                        trans(BlendFactor.one, BlendFactor.one),
                        BlendOp.add,
                    ),
                ),
            ],
        );
        info.dynamicStates = [ DynamicState.viewport, DynamicState.scissor ];
        info.layout = bulb.layout;
        info.renderPass = renderPass;
        info.subpassIndex = 2;

        return info;
    }
}
