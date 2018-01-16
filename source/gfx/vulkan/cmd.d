/// Vulkan command module
module gfx.vulkan.cmd;

package:

import erupted;

import gfx.core.rc;
import gfx.graal.cmd;
import gfx.vulkan.device;
import gfx.vulkan.error;

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
        return cast(CommandBuffer[])(
            vkBufs.map!(vkBuf => new VulkanCommandBuffer(vkBuf, this)).array
        );
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

    private VkCommandBuffer _vk;
    private VulkanCommandPool _pool;
}
