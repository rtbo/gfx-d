/// Vulkan buffer module
module gfx.vulkan.buffer;

package:

import gfx.bindings.vulkan;

import gfx.core.rc;
import gfx.graal.buffer;
import gfx.vulkan.device;
import gfx.vulkan.error;
import gfx.vulkan.memory;

final class VulkanBuffer : VulkanDevObj!(VkBuffer, "DestroyBuffer"), Buffer
{
    mixin(atomicRcCode);

    this (VkBuffer vkObj, VulkanDevice dev, BufferUsage usage, size_t size)
    {
        super(vkObj, dev);
        _usage = usage;
        _size = size;
    }

    override void dispose() {
        vk.DestroyBuffer(vkDev, vkObj, null);
        if (_vdm) _vdm.release();
        dev.release();
    }

    override Device device() {
        return dev;
    }

    @property BufferUsage usage() {
        return _usage;
    }

    @property size_t size() {
        return _size;
    }

    override @property MemoryRequirements memoryRequirements() {
        VkMemoryRequirements vkMr;
        vk.GetBufferMemoryRequirements(vkDev, vkObj, &vkMr);
        return vkMr.toGfx();
    }

    override void bindMemory(DeviceMemory mem, in size_t offset)
    {
        assert(!_vdm, "Bind the same buffer twice");
        _vdm = enforce(cast(VulkanDeviceMemory)mem, "Did not pass a Vulkan memory");
        vulkanEnforce(
            vk.BindBufferMemory(vkDev, vkObj, _vdm.vkObj, offset),
            "Could not bind image memory"
        );
        _vdm.retain();
    }

    override @property DeviceMemory boundMemory() {
        return _vdm;
    }

    override VulkanTexelBufferView createTexelView(Format format, size_t offset, size_t size)
    {
        VkBufferViewCreateInfo bvci;
        bvci.sType = VK_STRUCTURE_TYPE_BUFFER_VIEW_CREATE_INFO;
        bvci.format = format.toVk();
        bvci.offset = offset;
        bvci.range = size;

        VkBufferView vkBv;
        vulkanEnforce(
            vk.CreateBufferView(vkDev, &bvci, null, &vkBv),
            "Could not create Vulkan buffer view"
        );

        return new VulkanTexelBufferView(vkBv, this, format, offset, size);
    }

    private VulkanDeviceMemory _vdm;
    private BufferUsage _usage;
    private size_t _size;
}


class VulkanTexelBufferView : VulkanDevObj!(VkBufferView, "DestroyBufferView"), TexelBufferView
{
    mixin(atomicRcCode);

    this(VkBufferView vkObj, VulkanBuffer buf, Format format, size_t offset, size_t size)
    {
        super(vkObj, buf.dev);
        _buf = buf;
        _buf.retain();
        _format = format;
        _offset = offset;
        _size = size;
    }

    override void dispose()
    {
        super.dispose();
        _buf.release();
        _buf = null;
    }

    override @property VulkanBuffer buffer() {
        return _buf;
    }

    override @property Format format() {
        return _format;
    }

    override @property size_t offset() {
        return _offset;
    }

    override @property size_t size() {
        return _size;
    }


    private VulkanBuffer _buf;
    private Format _format;
    private size_t _offset;
    private size_t _size;
}
