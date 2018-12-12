/// Conversion module between vulkan and graal types
module gfx.vulkan.conv;

package:

import gfx.bindings.vulkan;

import gfx.graal : Severity;
import gfx.graal.buffer;
import gfx.graal.cmd;
import gfx.graal.format;
import gfx.graal.image;
import gfx.graal.memory;
import gfx.graal.pipeline;
import gfx.graal.presentation;
import gfx.graal.queue;
import gfx.graal.renderpass;
import gfx.graal.types;

import std.typecons : Flag;

// structures and enums conversion

VkFormat toVk(in Format format) {
    return cast(VkFormat)format;
}

Format toGfx(in VkFormat vkFormat) {
    return cast(Format)vkFormat;
}

VkFormatFeatureFlags toVk(in FormatFeatures ff) {
    return cast(VkFormatFeatureFlags)ff;
}

FormatFeatures toGfx(in VkFormatFeatureFlags vkFff) {
    return cast(FormatFeatures)vkFff;
}

static assert(Format.rgba8_uNorm.toVk() == VK_FORMAT_R8G8B8A8_UNORM);

VkImageType toVk(in ImageType it) {
    final switch (it) {
    case ImageType.d1:
    case ImageType.d1Array:
        return VK_IMAGE_TYPE_1D;
    case ImageType.d2:
    case ImageType.d2Array:
    case ImageType.cube:
    case ImageType.cubeArray:
        return VK_IMAGE_TYPE_2D;
    case ImageType.d3:
        return VK_IMAGE_TYPE_3D;
    }
}

VkImageViewType toVkView(in ImageType it) {
    final switch (it) {
    case ImageType.d1:
        return VK_IMAGE_VIEW_TYPE_1D;
    case ImageType.d1Array:
        return VK_IMAGE_VIEW_TYPE_1D_ARRAY;
    case ImageType.d2:
        return VK_IMAGE_VIEW_TYPE_2D;
    case ImageType.d2Array:
        return VK_IMAGE_VIEW_TYPE_2D_ARRAY;
    case ImageType.cube:
        return VK_IMAGE_VIEW_TYPE_CUBE;
    case ImageType.cubeArray:
        return VK_IMAGE_VIEW_TYPE_CUBE_ARRAY;
    case ImageType.d3:
        return VK_IMAGE_VIEW_TYPE_3D;
    }
}

VkImageLayout toVk(in ImageLayout layout)
{
    return cast(VkImageLayout)layout;
}

VkImageTiling toVk(in ImageTiling tiling)
{
    return cast(VkImageTiling)tiling;
}

MemoryRequirements toGfx(in VkMemoryRequirements mr) {
    return MemoryRequirements(
        cast(size_t)mr.size, cast(size_t)mr.alignment, memPropsToGfx(mr.memoryTypeBits)
    );
}

VkComponentSwizzle toVk(in CompSwizzle cs) {
    final switch (cs) {
    case CompSwizzle.identity : return VK_COMPONENT_SWIZZLE_IDENTITY;
    case CompSwizzle.zero : return VK_COMPONENT_SWIZZLE_ZERO;
    case CompSwizzle.one : return VK_COMPONENT_SWIZZLE_ONE;
    case CompSwizzle.r : return VK_COMPONENT_SWIZZLE_R;
    case CompSwizzle.g : return VK_COMPONENT_SWIZZLE_G;
    case CompSwizzle.b : return VK_COMPONENT_SWIZZLE_B;
    case CompSwizzle.a : return VK_COMPONENT_SWIZZLE_A;
    }
}

VkComponentMapping toVk(in Swizzle swizzle) {
    return VkComponentMapping(
        swizzle[0].toVk(), swizzle[1].toVk(), swizzle[2].toVk(), swizzle[3].toVk(),
    );
}

VkImageSubresourceRange toVk(in ImageSubresourceRange isr) {
    return VkImageSubresourceRange(
        isr.aspect.aspectToVk(),
        cast(uint)isr.firstLevel, cast(uint)isr.levels,
        cast(uint)isr.firstLayer, cast(uint)isr.layers,
    );
}

SurfaceCaps toGfx(in VkSurfaceCapabilitiesKHR vkCaps) {
    return SurfaceCaps(
        vkCaps.minImageCount, vkCaps.maxImageCount,
        [ vkCaps.minImageExtent.width, vkCaps.minImageExtent.height ],
        [ vkCaps.maxImageExtent.width, vkCaps.maxImageExtent.height ],
        vkCaps.maxImageArrayLayers,
        imageUsageToGfx(vkCaps.supportedUsageFlags),
        compositeAlphaToGfx(vkCaps.supportedCompositeAlpha),
    );
}

PresentMode toGfx(in VkPresentModeKHR pm) {
    switch (pm) {
    case VK_PRESENT_MODE_IMMEDIATE_KHR:
        return PresentMode.immediate;
    case VK_PRESENT_MODE_FIFO_KHR:
        return PresentMode.fifo;
    case VK_PRESENT_MODE_MAILBOX_KHR:
        return PresentMode.mailbox;
    default:
        assert(false);
    }
}

VkPresentModeKHR toVk(in PresentMode pm) {
    final switch (pm) {
    case PresentMode.immediate:
        return VK_PRESENT_MODE_IMMEDIATE_KHR;
    case PresentMode.fifo:
        return VK_PRESENT_MODE_FIFO_KHR;
    case PresentMode.mailbox:
        return VK_PRESENT_MODE_MAILBOX_KHR;
    }
}

@property bool hasGfxSupport(in VkPresentModeKHR pm) {
    switch (pm) {
    case VK_PRESENT_MODE_IMMEDIATE_KHR:
    case VK_PRESENT_MODE_FIFO_KHR:
    case VK_PRESENT_MODE_MAILBOX_KHR:
        return true;
    default:
        return false;
    }
}

VkAttachmentLoadOp toVk(in LoadOp op) {
    final switch (op) {
    case LoadOp.load: return VK_ATTACHMENT_LOAD_OP_LOAD;
    case LoadOp.clear: return VK_ATTACHMENT_LOAD_OP_CLEAR;
    case LoadOp.dontCare: return VK_ATTACHMENT_LOAD_OP_DONT_CARE;
    }
}

VkAttachmentStoreOp toVk(in StoreOp op) {
    final switch (op) {
    case StoreOp.store: return VK_ATTACHMENT_STORE_OP_STORE;
    case StoreOp.dontCare: return VK_ATTACHMENT_STORE_OP_DONT_CARE;
    }
}

VkPrimitiveTopology toVk(in Primitive p) {
    return cast(VkPrimitiveTopology)p;
}

VkFrontFace toVk(in FrontFace ff) {
    return cast(VkFrontFace)ff;
}

VkPolygonMode toVk(in PolygonMode pm) {
    return cast(VkPolygonMode)pm;
}

VkBlendFactor toVk(in BlendFactor bf) {
    return cast(VkBlendFactor)bf;
}

VkBlendOp toVk(in BlendOp op) {
    return cast(VkBlendOp)op;
}

VkLogicOp toVk(in LogicOp op) {
    return cast(VkLogicOp)op;
}

VkDynamicState toVk(in DynamicState ds) {
    return cast(VkDynamicState)ds;
}

VkRect2D toVk(in Rect r) {
    return VkRect2D(VkOffset2D(r.x, r.y), VkExtent2D(r.width, r.height));
}

VkFilter toVk(in Filter f) {
    return cast(VkFilter)f;
}

VkSamplerMipmapMode toVkMipmapMode(in Filter f) {
    return cast(VkSamplerMipmapMode)f;
}

VkSamplerAddressMode toVk(in WrapMode wm) {
    return cast(VkSamplerAddressMode)wm;
}

VkBorderColor toVk(in BorderColor bc) {
    return cast(VkBorderColor)bc;
}

VkCompareOp toVk(in CompareOp op) {
    return cast(VkCompareOp)op;
}

VkDescriptorType toVk(in DescriptorType dt) {
    return cast(VkDescriptorType)dt;
}

VkIndexType toVk(in IndexType type) {
    return cast(VkIndexType)type;
}

VkPipelineBindPoint toVk(in PipelineBindPoint bp) {
    return cast(VkPipelineBindPoint)bp;
}


// template conversion

VkBool32 flagToVk(F)(F val)
{
    return val ? VK_TRUE : VK_FALSE;
}

// flags conversion

Severity debugReportFlagsToGfx(in VkDebugReportFlagsEXT flags) nothrow pure {
    return cast(Severity) flags;
}

MemProps memPropsToGfx(in VkMemoryPropertyFlags vkFlags)
{
    MemProps props = cast(MemProps)0;
    if (vkFlags & VK_MEMORY_PROPERTY_DEVICE_LOCAL_BIT) {
        props |= MemProps.deviceLocal;
    }
    if (vkFlags & VK_MEMORY_PROPERTY_HOST_VISIBLE_BIT) {
        props |= MemProps.hostVisible;
    }
    if (vkFlags & VK_MEMORY_PROPERTY_HOST_COHERENT_BIT) {
        props |= MemProps.hostCoherent;
    }
    if (vkFlags & VK_MEMORY_PROPERTY_HOST_CACHED_BIT) {
        props |= MemProps.hostCached;
    }
    if (vkFlags & VK_MEMORY_PROPERTY_LAZILY_ALLOCATED_BIT) {
        props |= MemProps.lazilyAllocated;
    }
    return props;
}

QueueCap queueCapToGfx(in VkQueueFlags vkFlags)
{
    QueueCap caps = cast(QueueCap)0;
    if (vkFlags & VK_QUEUE_GRAPHICS_BIT) {
        caps |= QueueCap.graphics;
    }
    if (vkFlags & VK_QUEUE_COMPUTE_BIT) {
        caps |= QueueCap.compute;
    }
    return caps;
}

ImageUsage imageUsageToGfx(in VkImageUsageFlags usage)
{
    return cast(ImageUsage)usage;
}

CompositeAlpha compositeAlphaToGfx(in VkCompositeAlphaFlagsKHR ca)
{
    return cast(CompositeAlpha)ca;
}

VkBufferUsageFlags bufferUsageToVk(in BufferUsage usage) {
    return cast(VkBufferUsageFlags)usage;
}

VkImageUsageFlags imageUsageToVk(in ImageUsage usage)
{
    return cast(VkImageUsageFlags)usage;
}

VkImageAspectFlags aspectToVk(in ImageAspect aspect)
{
    return cast(VkImageAspectFlags)aspect;
}

VkAccessFlags accessToVk(in Access access)
{
    return cast(VkAccessFlags)access;
}

VkPipelineStageFlags pipelineStageToVk(in PipelineStage stage)
{
    return cast(VkPipelineStageFlags)stage;
}

VkCompositeAlphaFlagBitsKHR compositeAlphaToVk(in CompositeAlpha ca)
{
    return cast(VkCompositeAlphaFlagBitsKHR)ca;
}

VkShaderStageFlagBits shaderStageToVk(in ShaderStage ss)
{
    return cast(VkShaderStageFlagBits)ss;
}

VkCullModeFlagBits cullModeToVk(in Cull c) {
    return cast(VkCullModeFlagBits)c;
}
