/// Conversion module between vulkan and graal types
module gfx.vulkan.conv;

package:

import erupted;

import gfx.graal.format;
import gfx.graal.image;
import gfx.graal.memory;
import gfx.graal.queue;


// structures and enums conversion

VkFormat toVk(in Format format) {
    return cast(VkFormat)format;
}

Format fromVk(in VkFormat vkFormat) {
    return cast(Format)vkFormat;
}

VkFormatFeatureFlags toVk(in FormatFeatures ff) {
    return cast(VkFormatFeatureFlags)ff;
}

FormatFeatures fromVk(in VkFormatFeatureFlags vkFff) {
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

MemoryRequirements fromVk(in VkMemoryRequirements mr) {
    return MemoryRequirements(
        mr.size, mr.alignment, memPropsFromVk(mr.memoryTypeBits)
    );
}

// flags conversion

MemProps memPropsFromVk(in VkMemoryPropertyFlags vkFlags)
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

QueueCap queueCapFromVk(in VkQueueFlags vkFlags)
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

VkImageUsageFlags imageUsageToVk(in ImageUsage usage)
{
    return cast(VkImageUsageFlags)usage;
}
