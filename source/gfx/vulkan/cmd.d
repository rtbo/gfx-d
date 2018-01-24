/// Vulkan command module
module gfx.vulkan.cmd;

package:

import erupted;

import gfx.core.rc;
import gfx.core.typecons;
import gfx.graal.cmd;
import gfx.graal.renderpass;
import gfx.vulkan.buffer;
import gfx.vulkan.conv;
import gfx.vulkan.device;
import gfx.vulkan.error;
import gfx.vulkan.image;
import gfx.vulkan.renderpass;

class VulkanCommandPool : VulkanDevObj!(VkCommandPool, vkDestroyCommandPool), CommandPool
{
    mixin(atomicRcCode);

    this (VkCommandPool pool, VulkanDevice dev) {
        super(pool, dev);
    }

    override void reset() {
        vulkanEnforce(vkResetCommandPool(vkDev, vk, 0), "Could not reset command buffer");
    }

    override CommandBuffer[] allocate(size_t count) {
        VkCommandBufferAllocateInfo cbai;
        cbai.sType = VK_STRUCTURE_TYPE_COMMAND_BUFFER_ALLOCATE_INFO;
        cbai.commandPool = vk;
        cbai.level = VK_COMMAND_BUFFER_LEVEL_PRIMARY;
        cbai.commandBufferCount = cast(uint)count;

        auto vkBufs = new VkCommandBuffer[count];
        vulkanEnforce(
            vkAllocateCommandBuffers(vkDev, &cbai, &vkBufs[0]),
            "Could not allocate command buffers"
        );

        import std.algorithm : map;
        import std.array : array;

        return vkBufs
                .map!(vkBuf => cast(CommandBuffer)new VulkanCommandBuffer(vkBuf, this))
                .array;
    }

    override void free(CommandBuffer[] bufs) {
        import std.algorithm : map;
        import std.array : array;

        auto vkBufs = bufs.map!(
            b => enforce(cast(VulkanCommandBuffer)b, "Did not pass a Vulkan command buffer").vk
        ).array;
        vkFreeCommandBuffers(vkDev, vk, cast(uint)bufs.length, &vkBufs[0]);
    }
}

final class VulkanCommandBuffer : CommandBuffer
{
    this (VkCommandBuffer vk, VulkanCommandPool pool) {
        _vk = vk;
        _pool = pool;
    }

    @property VkCommandBuffer vk() {
        return _vk;
    }

    override @property CommandPool pool() {
        return _pool;
    }

    override void reset() {
        vulkanEnforce(
            vkResetCommandBuffer(vk, 0), "Could not reset vulkan command buffer"
        );
    }

    override void begin(bool multipleSubmissions) {
        VkCommandBufferBeginInfo cbbi;
        cbbi.sType = VK_STRUCTURE_TYPE_COMMAND_BUFFER_BEGIN_INFO;
        cbbi.flags = multipleSubmissions ?
            VK_COMMAND_BUFFER_USAGE_SIMULTANEOUS_USE_BIT :
            VK_COMMAND_BUFFER_USAGE_ONE_TIME_SUBMIT_BIT;
        vulkanEnforce(
            vkBeginCommandBuffer(vk, &cbbi), "Could not begin vulkan command buffer"
        );
    }

    override void end() {
        vulkanEnforce(
            vkEndCommandBuffer(vk), "Could not end vulkan command buffer"
        );
    }

    override void pipelineBarrier(Trans!PipelineStage stageTrans,
                                  BufferMemoryBarrier[] bufMbs,
                                  ImageMemoryBarrier[] imgMbs)
    {
        import std.algorithm : map;
        import std.array : array;

        auto vkBufMbs = bufMbs.map!((BufferMemoryBarrier bufMb) {
            VkBufferMemoryBarrier vkBufMb;
            vkBufMb.sType = VK_STRUCTURE_TYPE_BUFFER_MEMORY_BARRIER;
            vkBufMb.srcAccessMask = accessToVk(bufMb.accessMaskTrans.from);
            vkBufMb.dstAccessMask = accessToVk(bufMb.accessMaskTrans.to);
            vkBufMb.srcQueueFamilyIndex = bufMb.queueFamIndexTrans.from;
            vkBufMb.dstQueueFamilyIndex = bufMb.queueFamIndexTrans.to;
            vkBufMb.buffer = enforce(cast(VulkanBuffer)bufMb.buffer, "Did not pass a Vulkan buffer").vk;
            vkBufMb.offset = bufMb.offset;
            vkBufMb.size = bufMb.size;
            return vkBufMb;
        }).array;

        auto vkImgMbs = imgMbs.map!((ImageMemoryBarrier imgMb) {
            VkImageMemoryBarrier vkImgMb;
            vkImgMb.sType = VK_STRUCTURE_TYPE_IMAGE_MEMORY_BARRIER;
            vkImgMb.srcAccessMask = accessToVk(imgMb.accessMaskTrans.from);
            vkImgMb.dstAccessMask = accessToVk(imgMb.accessMaskTrans.to);
            vkImgMb.oldLayout = imgMb.layoutTrans.from.toVk();
            vkImgMb.newLayout = imgMb.layoutTrans.to.toVk();
            vkImgMb.srcQueueFamilyIndex = imgMb.queueFamIndexTrans.from;
            vkImgMb.dstQueueFamilyIndex = imgMb.queueFamIndexTrans.to;
            vkImgMb.image = enforce(cast(VulkanImage)imgMb.image, "Did not pass a Vulkan image").vk;
            vkImgMb.subresourceRange = imgMb.range.toVk();
            return vkImgMb;
        }).array;

        vkCmdPipelineBarrier( vk,
            pipelineStageToVk(stageTrans.from), pipelineStageToVk(stageTrans.to),
            0, 0, null,
            cast(uint)vkBufMbs.length, vkBufMbs.ptr,
            cast(uint)vkImgMbs.length, vkImgMbs.ptr
        );
    }

    override void clearColorImage(Image image, ImageLayout layout,
                         in ClearColorValues clearValues, ImageSubresourceRange[] ranges)
    {
        import std.algorithm : map;
        import std.array : array;

        auto vkImg = enforce(cast(VulkanImage)image, "Did not pass a vulkan image").vk;
        auto vkLayout = layout.toVk();
        auto vkClear = cast(const(VkClearColorValue)*) cast(const(void)*) &clearValues.values;
        auto vkRanges = ranges.map!(r => r.toVk()).array;

        vkCmdClearColorImage(vk, vkImg, vkLayout, vkClear, cast(uint)vkRanges.length, &vkRanges[0]);
    }

    override void clearDepthStencilImage(Image image, ImageLayout layout,
                                         in ClearDepthStencilValues clearValues,
                                         ImageSubresourceRange[] ranges)
    {
        import std.algorithm : map;
        import std.array : array;

        auto vkImg = enforce(cast(VulkanImage)image, "Did not pass a vulkan image").vk;
        auto vkLayout = layout.toVk();
        auto vkClear = VkClearDepthStencilValue(clearValues.depth, clearValues.stencil);
        auto vkRanges = ranges.map!(r => r.toVk()).array;

        vkCmdClearDepthStencilImage(vk, vkImg, vkLayout, &vkClear, cast(uint)vkRanges.length, &vkRanges[0]);
    }

    override void beginRenderPass(RenderPass rp, Framebuffer fb,
                                  Rect area, ClearValues[] clearValues)
    {
        import std.algorithm : map;
        import std.array : array;
        auto vkCvs = clearValues.map!(
            (ClearValues cv) {
                VkClearValue vkCv;
                if (cv.type == ClearValues.Type.color) {
                    const ccv = cv.values.color;
                    VkClearColorValue vkCcv;
                    switch (ccv.type) {
                    case ClearColorValues.Type.f32:
                        vkCcv.float32 = ccv.values.f32;
                        break;
                    case ClearColorValues.Type.i32:
                        vkCcv.int32 = ccv.values.i32;
                        break;
                    case ClearColorValues.Type.u32:
                        vkCcv.uint32 = ccv.values.u32;
                        break;
                    default:
                        break;
                    }
                    vkCv.color = vkCcv;
                }
                else if (cv.type == ClearValues.Type.depthStencil) {
                    const dscv = cv.values.depthStencil;
                    vkCv.depthStencil = VkClearDepthStencilValue(
                        dscv.depth, dscv.stencil
                    );
                }
                return vkCv;
            }
        ).array;

        VkRenderPassBeginInfo bi;
        bi.sType = VK_STRUCTURE_TYPE_RENDER_PASS_BEGIN_INFO;
        bi.renderPass = enforce(cast(VulkanRenderPass)rp, "did not supply a valid Vulkan render pass").vk;
        bi.framebuffer = enforce(cast(VulkanFramebuffer)fb, "did not supply a valid Vulkan frame buffer").vk;
        bi.renderArea = area.toVk();
        bi.clearValueCount = cast(uint)vkCvs.length;
        bi.pClearValues = vkCvs.ptr;

        vkCmdBeginRenderPass(vk, &bi, VK_SUBPASS_CONTENTS_INLINE);
    }

    override void nextSubpass() {
        vkCmdNextSubpass(vk, VK_SUBPASS_CONTENTS_INLINE);
    }

    override void endRenderPass() {
        vkCmdEndRenderPass(vk);
    }

    override void bindPipeline(Pipeline pipeline)
    {
        vkCmdBindPipeline(vk, VK_PIPELINE_BIND_POINT_GRAPHICS, enforce(
            cast(VulkanPipeline)pipeline, "did not pass a valid Vulkan pipeline"
        ).vk);
    }

    override void draw(uint vertexCount, uint instanceCount, uint firstVertex, uint firstInstance)
    {
        vkCmdDraw(vk, vertexCount, instanceCount, firstVertex, firstInstance);
    }

    private VkCommandBuffer _vk;
    private VulkanCommandPool _pool;
}
