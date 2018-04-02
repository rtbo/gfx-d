/// Vulkan queue module
module gfx.vulkan.queue;

package:

import gfx.bindings.vulkan;

import gfx.core.rc;
import gfx.graal.queue;
import gfx.vulkan.conv;
import gfx.vulkan.device;
import gfx.vulkan.error;
import gfx.vulkan.sync;
import gfx.vulkan.wsi;

final class VulkanQueue : Queue
{
    this (VkQueue vkObj, VulkanDevice dev) {
        _vkObj = vkObj;
        _dev = dev; // weak reference, no retain
        _vk = dev.vk;
    }

    @property VkQueue vkObj() {
        return _vkObj;
    }

    @property VkDeviceCmds vk() {
        return _vk;
    }

    @property Device device() {
        return cast(Device)_dev.rcLock();
    }

    void waitIdle() {
        vk.queueWaitIdle(_vkObj);
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
                ).vkObj;
                vkWaitDstStage[i] = pipelineStageToVk(sw.stages);
            }

            auto vkSigSems = s.sigSems.map!(
                s => enforce(
                    cast(VulkanSemaphore)s,
                    "Did not pass a vulkan semaphore"
                ).vkObj
            ).array;
            auto vkCmdBufs = s.cmdBufs.map!(
                b => enforce(
                    cast(VulkanCommandBuffer)b,
                    "Did not pass a vulkan command buffer"
                ).vkObj
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
            vkFence = enforce(cast(VulkanFence)fence, "Did not pass a Vulkan fence").vkObj;
        }

        vulkanEnforce(
            vk.queueSubmit(vkObj, cast(uint)vkSubmitInfos.length, vkSubmitInfos.ptr, vkFence),
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
            ).vkObj
        ).array;

        auto vkScs = new VkSwapchainKHR[prs.length];
        auto vkImgs = new uint[prs.length];
        foreach (i, pr; prs) {
            vkScs[i] = enforce(
                cast(VulkanSwapchain)pr.swapChain,
                "Did not pass a vukan swap chain").vkObj;
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
            vk.queuePresentKHR(vkObj, &qpi), "Could not present vulkan swapchain"
        );
    }

    private VkQueue _vkObj;
    private VulkanDevice _dev; // device is kept as weak reference
    private VkDeviceCmds _vk;
}
