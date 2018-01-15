/// Vulkan queue module
module gfx.vulkan.queue;

package:

import erupted;

import gfx.core.rc;
import gfx.graal.queue;
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
