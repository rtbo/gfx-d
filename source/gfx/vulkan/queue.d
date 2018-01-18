/// Vulkan queue module
module gfx.vulkan.queue;

package:

import erupted;

import gfx.core.rc;
import gfx.graal.queue;
import gfx.vulkan.conv;
import gfx.vulkan.error;
import gfx.vulkan.sync;
import gfx.vulkan.wsi;

class VulkanQueue : Queue
{
    this (VkQueue vk) {
        _vk = vk;
    }

    final @property VkQueue vk() {
        return _vk;
    }

    void waitIdle() {
        vkQueueWaitIdle(_vk);
    }

    void submit(Submission[] submissions, Fence fence)
    {
        import std.algorithm : map;
        import std.array : array;

        auto vkSubmitInfos = submissions.map!((ref Submission s)
        {
            auto vkWaitSems = new VkSemaphore[s.stageWaits.length];
            auto vkWaitDstStage = new VkPipelineStageFlags[s.stageWaits.length];

            foreach (i, sw; s.stageWaits) {
                vkWaitSems[i] = enforce(
                    cast(VulkanSemaphore)sw.sem,
                    "Did not pass a vulkan semaphore"
                ).vk;
                vkWaitDstStage[i] = pipelineStageToVk(sw.stages);
            }

            auto vkSigSems = s.sigSems.map!(
                s => enforce(
                    cast(VulkanSemaphore)s,
                    "Did not pass a vulkan semaphore"
                ).vk
            ).array;
            auto vkCmdBufs = s.cmdBufs.map!(
                b => enforce(
                    cast(VulkanCommandBuffer)b,
                    "Did not pass a vulkan command buffer"
                ).vk
            ).array;


            VkSubmitInfo si;
            si.sType = VK_STRUCTURE_TYPE_SUBMIT_INFO;
            si.waitSemaphoreCount = cast(uint)vkWaitSems.length;
            si.pWaitSemaphores = vkWaitSems.ptr;
            si.pWaitDstStageMask = vkWaitDstStage.ptr;
            si.commandBufferCount = cast(uint)vkCmdBufs.length;
            si.pCommandBuffers = vkCmdBufs.ptr;
            si.signalSemaphoreCount = cast(uint)vkSigSems.length;
            si.pSignalSemaphores = vkSigSems.ptr;

            return si;
        }).array;

        VkFence vkFence;
        if (fence) {
            vkFence = enforce(cast(VulkanFence)fence, "Did not pass a Vulkan fence").vk;
        }

        vulkanEnforce(
            vkQueueSubmit(vk, cast(uint)vkSubmitInfos.length, vkSubmitInfos.ptr, vkFence),
            "Could not submit vulkan queue"
        );
    }

    void present(Semaphore[] waitSems, PresentRequest[] prs) {
        import std.algorithm : map;
        import std.array : array;

        auto vkSems = waitSems.map!(
            s => enforce(
                cast(VulkanSemaphore)s,
                "Did not pass a vulkan semaphore"
            ).vk
        ).array;

        auto vkScs = new VkSwapchainKHR[prs.length];
        auto vkImgs = new uint[prs.length];
        foreach (i, pr; prs) {
            vkScs[i] = enforce(
                cast(VulkanSwapchain)pr.swapChain,
                "Did not pass a vukan swap chain").vk;
            vkImgs[i] = pr.imageIndex;
        }

        VkPresentInfoKHR qpi;
        qpi.sType = VK_STRUCTURE_TYPE_PRESENT_INFO_KHR;
        qpi.waitSemaphoreCount = cast(uint)waitSems.length;
        qpi.pWaitSemaphores = &vkSems[0];
        qpi.swapchainCount = cast(uint)prs.length;
        qpi.pSwapchains = &vkScs[0];
        qpi.pImageIndices = &vkImgs[0];

        vulkanEnforce(
            vkQueuePresentKHR(vk, &qpi), "Could not present vulkan swapchain"
        );
    }

    private VkQueue _vk;
}
