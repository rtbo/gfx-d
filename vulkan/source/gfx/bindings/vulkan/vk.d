/// Vulkan D bindings generated automatically by vkdgen
/// See https://github.com/rtbo/vkdgen
module gfx.bindings.vulkan.vk;

version(Windows) {
    import core.sys.windows.windef : HINSTANCE, HWND;
}

version(linux) {
    import xcb.xcb : xcb_connection_t, xcb_visualid_t, xcb_window_t;
}

version(linux) {
    import wayland.native.client : wl_display, wl_proxy;
    alias wl_surface = wl_proxy;
}

enum VK_HEADER_VERSION =  96;

// Basic types definition

alias uint8_t  = ubyte;
alias uint16_t = ushort;
alias uint32_t = uint;
alias uint64_t = ulong;
alias int8_t   = byte;
alias int16_t  = short;
alias int32_t  = int;
alias int64_t  = long;

// VK_VERSION_1_0
alias VkFlags                                 = uint32_t;
alias VkInstanceCreateFlags                   = VkFlags;
alias VkBool32                                = uint32_t;
alias VkFormatFeatureFlags                    = VkFlags;
alias VkImageUsageFlags                       = VkFlags;
alias VkImageCreateFlags                      = VkFlags;
alias VkSampleCountFlags                      = VkFlags;
alias VkDeviceSize                            = uint64_t;
alias VkQueueFlags                            = VkFlags;
alias VkMemoryPropertyFlags                   = VkFlags;
alias VkMemoryHeapFlags                       = VkFlags;
alias VkDeviceCreateFlags                     = VkFlags;
alias VkDeviceQueueCreateFlags                = VkFlags;
alias VkPipelineStageFlags                    = VkFlags;
alias VkMemoryMapFlags                        = VkFlags;
alias VkImageAspectFlags                      = VkFlags;
alias VkSparseImageFormatFlags                = VkFlags;
alias VkSparseMemoryBindFlags                 = VkFlags;
alias VkFenceCreateFlags                      = VkFlags;
alias VkSemaphoreCreateFlags                  = VkFlags;
alias VkEventCreateFlags                      = VkFlags;
alias VkQueryPoolCreateFlags                  = VkFlags;
alias VkQueryPipelineStatisticFlags           = VkFlags;
alias VkQueryResultFlags                      = VkFlags;
alias VkBufferCreateFlags                     = VkFlags;
alias VkBufferUsageFlags                      = VkFlags;
alias VkBufferViewCreateFlags                 = VkFlags;
alias VkImageViewCreateFlags                  = VkFlags;
alias VkShaderModuleCreateFlags               = VkFlags;
alias VkPipelineCacheCreateFlags              = VkFlags;
alias VkPipelineCreateFlags                   = VkFlags;
alias VkPipelineShaderStageCreateFlags        = VkFlags;
alias VkPipelineVertexInputStateCreateFlags   = VkFlags;
alias VkPipelineInputAssemblyStateCreateFlags = VkFlags;
alias VkPipelineTessellationStateCreateFlags  = VkFlags;
alias VkPipelineViewportStateCreateFlags      = VkFlags;
alias VkPipelineRasterizationStateCreateFlags = VkFlags;
alias VkCullModeFlags                         = VkFlags;
alias VkPipelineMultisampleStateCreateFlags   = VkFlags;
alias VkSampleMask                            = uint32_t;
alias VkPipelineDepthStencilStateCreateFlags  = VkFlags;
alias VkPipelineColorBlendStateCreateFlags    = VkFlags;
alias VkColorComponentFlags                   = VkFlags;
alias VkPipelineDynamicStateCreateFlags       = VkFlags;
alias VkPipelineLayoutCreateFlags             = VkFlags;
alias VkShaderStageFlags                      = VkFlags;
alias VkSamplerCreateFlags                    = VkFlags;
alias VkDescriptorSetLayoutCreateFlags        = VkFlags;
alias VkDescriptorPoolCreateFlags             = VkFlags;
alias VkDescriptorPoolResetFlags              = VkFlags;
alias VkFramebufferCreateFlags                = VkFlags;
alias VkRenderPassCreateFlags                 = VkFlags;
alias VkAttachmentDescriptionFlags            = VkFlags;
alias VkSubpassDescriptionFlags               = VkFlags;
alias VkAccessFlags                           = VkFlags;
alias VkDependencyFlags                       = VkFlags;
alias VkCommandPoolCreateFlags                = VkFlags;
alias VkCommandPoolResetFlags                 = VkFlags;
alias VkCommandBufferUsageFlags               = VkFlags;
alias VkQueryControlFlags                     = VkFlags;
alias VkCommandBufferResetFlags               = VkFlags;
alias VkStencilFaceFlags                      = VkFlags;

// VK_VERSION_1_1
alias VkSubgroupFeatureFlags                = VkFlags;
alias VkPeerMemoryFeatureFlags              = VkFlags;
alias VkMemoryAllocateFlags                 = VkFlags;
alias VkCommandPoolTrimFlags                = VkFlags;
alias VkDescriptorUpdateTemplateCreateFlags = VkFlags;
alias VkExternalMemoryHandleTypeFlags       = VkFlags;
alias VkExternalMemoryFeatureFlags          = VkFlags;
alias VkExternalFenceHandleTypeFlags        = VkFlags;
alias VkExternalFenceFeatureFlags           = VkFlags;
alias VkFenceImportFlags                    = VkFlags;
alias VkSemaphoreImportFlags                = VkFlags;
alias VkExternalSemaphoreHandleTypeFlags    = VkFlags;
alias VkExternalSemaphoreFeatureFlags       = VkFlags;

// VK_KHR_surface
alias VkSurfaceTransformFlagsKHR = VkFlags;
alias VkCompositeAlphaFlagsKHR   = VkFlags;

// VK_KHR_swapchain
alias VkSwapchainCreateFlagsKHR        = VkFlags;
alias VkDeviceGroupPresentModeFlagsKHR = VkFlags;

// VK_KHR_display
alias VkDisplayPlaneAlphaFlagsKHR    = VkFlags;
alias VkDisplayModeCreateFlagsKHR    = VkFlags;
alias VkDisplaySurfaceCreateFlagsKHR = VkFlags;

// VK_KHR_xcb_surface
version(linux) {
    alias VkXcbSurfaceCreateFlagsKHR = VkFlags;
}

// VK_KHR_wayland_surface
version(linux) {
    alias VkWaylandSurfaceCreateFlagsKHR = VkFlags;
}

// VK_KHR_win32_surface
version(Windows) {
    alias VkWin32SurfaceCreateFlagsKHR = VkFlags;
}

// VK_EXT_debug_report
alias VkDebugReportFlagsEXT = VkFlags;

// Handles

// VK_VERSION_1_0
struct VkInstance_T;       alias VkInstance       = VkInstance_T*;
struct VkPhysicalDevice_T; alias VkPhysicalDevice = VkPhysicalDevice_T*;
struct VkDevice_T;         alias VkDevice         = VkDevice_T*;
struct VkQueue_T;          alias VkQueue          = VkQueue_T*;
struct VkCommandBuffer_T;  alias VkCommandBuffer  = VkCommandBuffer_T*;

// Non-dispatchable handles

version(X86_64) {
    // VK_VERSION_1_0
    struct VkSemaphore_T;           alias VkSemaphore           = VkSemaphore_T*;
    struct VkFence_T;               alias VkFence               = VkFence_T*;
    struct VkDeviceMemory_T;        alias VkDeviceMemory        = VkDeviceMemory_T*;
    struct VkBuffer_T;              alias VkBuffer              = VkBuffer_T*;
    struct VkImage_T;               alias VkImage               = VkImage_T*;
    struct VkEvent_T;               alias VkEvent               = VkEvent_T*;
    struct VkQueryPool_T;           alias VkQueryPool           = VkQueryPool_T*;
    struct VkBufferView_T;          alias VkBufferView          = VkBufferView_T*;
    struct VkImageView_T;           alias VkImageView           = VkImageView_T*;
    struct VkShaderModule_T;        alias VkShaderModule        = VkShaderModule_T*;
    struct VkPipelineCache_T;       alias VkPipelineCache       = VkPipelineCache_T*;
    struct VkPipelineLayout_T;      alias VkPipelineLayout      = VkPipelineLayout_T*;
    struct VkRenderPass_T;          alias VkRenderPass          = VkRenderPass_T*;
    struct VkPipeline_T;            alias VkPipeline            = VkPipeline_T*;
    struct VkDescriptorSetLayout_T; alias VkDescriptorSetLayout = VkDescriptorSetLayout_T*;
    struct VkSampler_T;             alias VkSampler             = VkSampler_T*;
    struct VkDescriptorPool_T;      alias VkDescriptorPool      = VkDescriptorPool_T*;
    struct VkDescriptorSet_T;       alias VkDescriptorSet       = VkDescriptorSet_T*;
    struct VkFramebuffer_T;         alias VkFramebuffer         = VkFramebuffer_T*;
    struct VkCommandPool_T;         alias VkCommandPool         = VkCommandPool_T*;

    // VK_VERSION_1_1
    struct VkSamplerYcbcrConversion_T;   alias VkSamplerYcbcrConversion   = VkSamplerYcbcrConversion_T*;
    struct VkDescriptorUpdateTemplate_T; alias VkDescriptorUpdateTemplate = VkDescriptorUpdateTemplate_T*;

    // VK_KHR_surface
    struct VkSurfaceKHR_T; alias VkSurfaceKHR = VkSurfaceKHR_T*;

    // VK_KHR_swapchain
    struct VkSwapchainKHR_T; alias VkSwapchainKHR = VkSwapchainKHR_T*;

    // VK_KHR_display
    struct VkDisplayKHR_T;     alias VkDisplayKHR     = VkDisplayKHR_T*;
    struct VkDisplayModeKHR_T; alias VkDisplayModeKHR = VkDisplayModeKHR_T*;

    // VK_EXT_debug_report
    struct VkDebugReportCallbackEXT_T; alias VkDebugReportCallbackEXT = VkDebugReportCallbackEXT_T*;
}
else {
    // VK_VERSION_1_0
    alias VkSemaphore           = ulong;
    alias VkFence               = ulong;
    alias VkDeviceMemory        = ulong;
    alias VkBuffer              = ulong;
    alias VkImage               = ulong;
    alias VkEvent               = ulong;
    alias VkQueryPool           = ulong;
    alias VkBufferView          = ulong;
    alias VkImageView           = ulong;
    alias VkShaderModule        = ulong;
    alias VkPipelineCache       = ulong;
    alias VkPipelineLayout      = ulong;
    alias VkRenderPass          = ulong;
    alias VkPipeline            = ulong;
    alias VkDescriptorSetLayout = ulong;
    alias VkSampler             = ulong;
    alias VkDescriptorPool      = ulong;
    alias VkDescriptorSet       = ulong;
    alias VkFramebuffer         = ulong;
    alias VkCommandPool         = ulong;

    // VK_VERSION_1_1
    alias VkSamplerYcbcrConversion   = ulong;
    alias VkDescriptorUpdateTemplate = ulong;

    // VK_KHR_surface
    alias VkSurfaceKHR = ulong;

    // VK_KHR_swapchain
    alias VkSwapchainKHR = ulong;

    // VK_KHR_display
    alias VkDisplayKHR     = ulong;
    alias VkDisplayModeKHR = ulong;

    // VK_EXT_debug_report
    alias VkDebugReportCallbackEXT = ulong;
}

// Constants

// VK_VERSION_1_0
enum VK_LOD_CLAMP_NONE                = 1000.0f;
enum VK_REMAINING_MIP_LEVELS          = ~0;
enum VK_REMAINING_ARRAY_LAYERS        = ~0;
enum VK_WHOLE_SIZE                    = ~0;
enum VK_ATTACHMENT_UNUSED             = ~0;
enum VK_TRUE                          = 1;
enum VK_FALSE                         = 0;
enum VK_QUEUE_FAMILY_IGNORED          = ~0;
enum VK_SUBPASS_EXTERNAL              = ~0;
enum VK_MAX_PHYSICAL_DEVICE_NAME_SIZE = 256;
enum VK_UUID_SIZE                     = 16;
enum VK_MAX_MEMORY_TYPES              = 32;
enum VK_MAX_MEMORY_HEAPS              = 16;
enum VK_MAX_EXTENSION_NAME_SIZE       = 256;
enum VK_MAX_DESCRIPTION_SIZE          = 256;

// VK_VERSION_1_1
enum VK_MAX_DEVICE_GROUP_SIZE = 32;
enum VK_LUID_SIZE             = 8;
enum VK_QUEUE_FAMILY_EXTERNAL = ~0-1;

// VK_KHR_surface
enum VK_KHR_SURFACE_SPEC_VERSION   = 25;
enum VK_KHR_SURFACE_EXTENSION_NAME = "VK_KHR_surface";

// VK_KHR_swapchain
enum VK_KHR_SWAPCHAIN_SPEC_VERSION   = 70;
enum VK_KHR_SWAPCHAIN_EXTENSION_NAME = "VK_KHR_swapchain";

// VK_KHR_display
enum VK_KHR_DISPLAY_SPEC_VERSION   = 21;
enum VK_KHR_DISPLAY_EXTENSION_NAME = "VK_KHR_display";

// VK_KHR_xcb_surface
version(linux) {
    enum VK_KHR_XCB_SURFACE_SPEC_VERSION   = 6;
    enum VK_KHR_XCB_SURFACE_EXTENSION_NAME = "VK_KHR_xcb_surface";
}

// VK_KHR_wayland_surface
version(linux) {
    enum VK_KHR_WAYLAND_SURFACE_SPEC_VERSION   = 6;
    enum VK_KHR_WAYLAND_SURFACE_EXTENSION_NAME = "VK_KHR_wayland_surface";
}

// VK_KHR_win32_surface
version(Windows) {
    enum VK_KHR_WIN32_SURFACE_SPEC_VERSION   = 6;
    enum VK_KHR_WIN32_SURFACE_EXTENSION_NAME = "VK_KHR_win32_surface";
}

// VK_EXT_debug_report
enum VK_EXT_DEBUG_REPORT_SPEC_VERSION   = 9;
enum VK_EXT_DEBUG_REPORT_EXTENSION_NAME = "VK_EXT_debug_report";

// Function pointers

extern(C) nothrow {
    // VK_VERSION_1_0
    alias PFN_vkAllocationFunction = void* function(
        void*                   pUserData,
        size_t                  size,
        size_t                  alignment,
        VkSystemAllocationScope allocationScope
    );
    alias PFN_vkReallocationFunction = void* function(
        void*                   pUserData,
        void*                   pOriginal,
        size_t                  size,
        size_t                  alignment,
        VkSystemAllocationScope allocationScope
    );
    alias PFN_vkFreeFunction = void function(
        void* pUserData,
        void* pMemory
    );
    alias PFN_vkInternalAllocationNotification = void function(
        void*                    pUserData,
        size_t                   size,
        VkInternalAllocationType allocationType,
        VkSystemAllocationScope  allocationScope
    );
    alias PFN_vkInternalFreeNotification = void function(
        void*                    pUserData,
        size_t                   size,
        VkInternalAllocationType allocationType,
        VkSystemAllocationScope  allocationScope
    );
    alias PFN_vkVoidFunction = void function();

    // VK_EXT_debug_report
    alias PFN_vkDebugReportCallbackEXT = VkBool32 function(
        VkDebugReportFlagsEXT      flags,
        VkDebugReportObjectTypeEXT objectType,
        uint64_t                   object,
        size_t                     location,
        int32_t                    messageCode,
        const(char)*               pLayerPrefix,
        const(char)*               pMessage,
        void*                      pUserData
    );
}

// Enumerations

// VK_VERSION_1_0
enum VkPipelineCacheHeaderVersion {
    VK_PIPELINE_CACHE_HEADER_VERSION_ONE = 1,
}
enum VK_PIPELINE_CACHE_HEADER_VERSION_ONE = VkPipelineCacheHeaderVersion.VK_PIPELINE_CACHE_HEADER_VERSION_ONE;

enum VkResult {
    VK_SUCCESS                                            = 0,
    VK_NOT_READY                                          = 1,
    VK_TIMEOUT                                            = 2,
    VK_EVENT_SET                                          = 3,
    VK_EVENT_RESET                                        = 4,
    VK_INCOMPLETE                                         = 5,
    VK_ERROR_OUT_OF_HOST_MEMORY                           = -1,
    VK_ERROR_OUT_OF_DEVICE_MEMORY                         = -2,
    VK_ERROR_INITIALIZATION_FAILED                        = -3,
    VK_ERROR_DEVICE_LOST                                  = -4,
    VK_ERROR_MEMORY_MAP_FAILED                            = -5,
    VK_ERROR_LAYER_NOT_PRESENT                            = -6,
    VK_ERROR_EXTENSION_NOT_PRESENT                        = -7,
    VK_ERROR_FEATURE_NOT_PRESENT                          = -8,
    VK_ERROR_INCOMPATIBLE_DRIVER                          = -9,
    VK_ERROR_TOO_MANY_OBJECTS                             = -10,
    VK_ERROR_FORMAT_NOT_SUPPORTED                         = -11,
    VK_ERROR_FRAGMENTED_POOL                              = -12,
    VK_ERROR_OUT_OF_POOL_MEMORY                           = -1000069000,
    VK_ERROR_INVALID_EXTERNAL_HANDLE                      = -1000072003,
    VK_ERROR_SURFACE_LOST_KHR                             = -1000000000,
    VK_ERROR_NATIVE_WINDOW_IN_USE_KHR                     = -1000000001,
    VK_SUBOPTIMAL_KHR                                     = 1000001003,
    VK_ERROR_OUT_OF_DATE_KHR                              = -1000001004,
    VK_ERROR_INCOMPATIBLE_DISPLAY_KHR                     = -1000003001,
    VK_ERROR_VALIDATION_FAILED_EXT                        = -1000011001,
    VK_ERROR_INVALID_SHADER_NV                            = -1000012000,
    VK_ERROR_OUT_OF_POOL_MEMORY_KHR                       = VK_ERROR_OUT_OF_POOL_MEMORY,
    VK_ERROR_INVALID_EXTERNAL_HANDLE_KHR                  = VK_ERROR_INVALID_EXTERNAL_HANDLE,
    VK_ERROR_INVALID_DRM_FORMAT_MODIFIER_PLANE_LAYOUT_EXT = -1000158000,
    VK_ERROR_FRAGMENTATION_EXT                            = -1000161000,
    VK_ERROR_NOT_PERMITTED_EXT                            = -1000174001,
}
enum VK_SUCCESS                                            = VkResult.VK_SUCCESS;
enum VK_NOT_READY                                          = VkResult.VK_NOT_READY;
enum VK_TIMEOUT                                            = VkResult.VK_TIMEOUT;
enum VK_EVENT_SET                                          = VkResult.VK_EVENT_SET;
enum VK_EVENT_RESET                                        = VkResult.VK_EVENT_RESET;
enum VK_INCOMPLETE                                         = VkResult.VK_INCOMPLETE;
enum VK_ERROR_OUT_OF_HOST_MEMORY                           = VkResult.VK_ERROR_OUT_OF_HOST_MEMORY;
enum VK_ERROR_OUT_OF_DEVICE_MEMORY                         = VkResult.VK_ERROR_OUT_OF_DEVICE_MEMORY;
enum VK_ERROR_INITIALIZATION_FAILED                        = VkResult.VK_ERROR_INITIALIZATION_FAILED;
enum VK_ERROR_DEVICE_LOST                                  = VkResult.VK_ERROR_DEVICE_LOST;
enum VK_ERROR_MEMORY_MAP_FAILED                            = VkResult.VK_ERROR_MEMORY_MAP_FAILED;
enum VK_ERROR_LAYER_NOT_PRESENT                            = VkResult.VK_ERROR_LAYER_NOT_PRESENT;
enum VK_ERROR_EXTENSION_NOT_PRESENT                        = VkResult.VK_ERROR_EXTENSION_NOT_PRESENT;
enum VK_ERROR_FEATURE_NOT_PRESENT                          = VkResult.VK_ERROR_FEATURE_NOT_PRESENT;
enum VK_ERROR_INCOMPATIBLE_DRIVER                          = VkResult.VK_ERROR_INCOMPATIBLE_DRIVER;
enum VK_ERROR_TOO_MANY_OBJECTS                             = VkResult.VK_ERROR_TOO_MANY_OBJECTS;
enum VK_ERROR_FORMAT_NOT_SUPPORTED                         = VkResult.VK_ERROR_FORMAT_NOT_SUPPORTED;
enum VK_ERROR_FRAGMENTED_POOL                              = VkResult.VK_ERROR_FRAGMENTED_POOL;
enum VK_ERROR_OUT_OF_POOL_MEMORY                           = VkResult.VK_ERROR_OUT_OF_POOL_MEMORY;
enum VK_ERROR_INVALID_EXTERNAL_HANDLE                      = VkResult.VK_ERROR_INVALID_EXTERNAL_HANDLE;
enum VK_ERROR_SURFACE_LOST_KHR                             = VkResult.VK_ERROR_SURFACE_LOST_KHR;
enum VK_ERROR_NATIVE_WINDOW_IN_USE_KHR                     = VkResult.VK_ERROR_NATIVE_WINDOW_IN_USE_KHR;
enum VK_SUBOPTIMAL_KHR                                     = VkResult.VK_SUBOPTIMAL_KHR;
enum VK_ERROR_OUT_OF_DATE_KHR                              = VkResult.VK_ERROR_OUT_OF_DATE_KHR;
enum VK_ERROR_INCOMPATIBLE_DISPLAY_KHR                     = VkResult.VK_ERROR_INCOMPATIBLE_DISPLAY_KHR;
enum VK_ERROR_VALIDATION_FAILED_EXT                        = VkResult.VK_ERROR_VALIDATION_FAILED_EXT;
enum VK_ERROR_INVALID_SHADER_NV                            = VkResult.VK_ERROR_INVALID_SHADER_NV;
enum VK_ERROR_OUT_OF_POOL_MEMORY_KHR                       = VkResult.VK_ERROR_OUT_OF_POOL_MEMORY_KHR;
enum VK_ERROR_INVALID_EXTERNAL_HANDLE_KHR                  = VkResult.VK_ERROR_INVALID_EXTERNAL_HANDLE_KHR;
enum VK_ERROR_INVALID_DRM_FORMAT_MODIFIER_PLANE_LAYOUT_EXT = VkResult.VK_ERROR_INVALID_DRM_FORMAT_MODIFIER_PLANE_LAYOUT_EXT;
enum VK_ERROR_FRAGMENTATION_EXT                            = VkResult.VK_ERROR_FRAGMENTATION_EXT;
enum VK_ERROR_NOT_PERMITTED_EXT                            = VkResult.VK_ERROR_NOT_PERMITTED_EXT;

enum VkStructureType {
    VK_STRUCTURE_TYPE_APPLICATION_INFO                                             = 0,
    VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO                                         = 1,
    VK_STRUCTURE_TYPE_DEVICE_QUEUE_CREATE_INFO                                     = 2,
    VK_STRUCTURE_TYPE_DEVICE_CREATE_INFO                                           = 3,
    VK_STRUCTURE_TYPE_SUBMIT_INFO                                                  = 4,
    VK_STRUCTURE_TYPE_MEMORY_ALLOCATE_INFO                                         = 5,
    VK_STRUCTURE_TYPE_MAPPED_MEMORY_RANGE                                          = 6,
    VK_STRUCTURE_TYPE_BIND_SPARSE_INFO                                             = 7,
    VK_STRUCTURE_TYPE_FENCE_CREATE_INFO                                            = 8,
    VK_STRUCTURE_TYPE_SEMAPHORE_CREATE_INFO                                        = 9,
    VK_STRUCTURE_TYPE_EVENT_CREATE_INFO                                            = 10,
    VK_STRUCTURE_TYPE_QUERY_POOL_CREATE_INFO                                       = 11,
    VK_STRUCTURE_TYPE_BUFFER_CREATE_INFO                                           = 12,
    VK_STRUCTURE_TYPE_BUFFER_VIEW_CREATE_INFO                                      = 13,
    VK_STRUCTURE_TYPE_IMAGE_CREATE_INFO                                            = 14,
    VK_STRUCTURE_TYPE_IMAGE_VIEW_CREATE_INFO                                       = 15,
    VK_STRUCTURE_TYPE_SHADER_MODULE_CREATE_INFO                                    = 16,
    VK_STRUCTURE_TYPE_PIPELINE_CACHE_CREATE_INFO                                   = 17,
    VK_STRUCTURE_TYPE_PIPELINE_SHADER_STAGE_CREATE_INFO                            = 18,
    VK_STRUCTURE_TYPE_PIPELINE_VERTEX_INPUT_STATE_CREATE_INFO                      = 19,
    VK_STRUCTURE_TYPE_PIPELINE_INPUT_ASSEMBLY_STATE_CREATE_INFO                    = 20,
    VK_STRUCTURE_TYPE_PIPELINE_TESSELLATION_STATE_CREATE_INFO                      = 21,
    VK_STRUCTURE_TYPE_PIPELINE_VIEWPORT_STATE_CREATE_INFO                          = 22,
    VK_STRUCTURE_TYPE_PIPELINE_RASTERIZATION_STATE_CREATE_INFO                     = 23,
    VK_STRUCTURE_TYPE_PIPELINE_MULTISAMPLE_STATE_CREATE_INFO                       = 24,
    VK_STRUCTURE_TYPE_PIPELINE_DEPTH_STENCIL_STATE_CREATE_INFO                     = 25,
    VK_STRUCTURE_TYPE_PIPELINE_COLOR_BLEND_STATE_CREATE_INFO                       = 26,
    VK_STRUCTURE_TYPE_PIPELINE_DYNAMIC_STATE_CREATE_INFO                           = 27,
    VK_STRUCTURE_TYPE_GRAPHICS_PIPELINE_CREATE_INFO                                = 28,
    VK_STRUCTURE_TYPE_COMPUTE_PIPELINE_CREATE_INFO                                 = 29,
    VK_STRUCTURE_TYPE_PIPELINE_LAYOUT_CREATE_INFO                                  = 30,
    VK_STRUCTURE_TYPE_SAMPLER_CREATE_INFO                                          = 31,
    VK_STRUCTURE_TYPE_DESCRIPTOR_SET_LAYOUT_CREATE_INFO                            = 32,
    VK_STRUCTURE_TYPE_DESCRIPTOR_POOL_CREATE_INFO                                  = 33,
    VK_STRUCTURE_TYPE_DESCRIPTOR_SET_ALLOCATE_INFO                                 = 34,
    VK_STRUCTURE_TYPE_WRITE_DESCRIPTOR_SET                                         = 35,
    VK_STRUCTURE_TYPE_COPY_DESCRIPTOR_SET                                          = 36,
    VK_STRUCTURE_TYPE_FRAMEBUFFER_CREATE_INFO                                      = 37,
    VK_STRUCTURE_TYPE_RENDER_PASS_CREATE_INFO                                      = 38,
    VK_STRUCTURE_TYPE_COMMAND_POOL_CREATE_INFO                                     = 39,
    VK_STRUCTURE_TYPE_COMMAND_BUFFER_ALLOCATE_INFO                                 = 40,
    VK_STRUCTURE_TYPE_COMMAND_BUFFER_INHERITANCE_INFO                              = 41,
    VK_STRUCTURE_TYPE_COMMAND_BUFFER_BEGIN_INFO                                    = 42,
    VK_STRUCTURE_TYPE_RENDER_PASS_BEGIN_INFO                                       = 43,
    VK_STRUCTURE_TYPE_BUFFER_MEMORY_BARRIER                                        = 44,
    VK_STRUCTURE_TYPE_IMAGE_MEMORY_BARRIER                                         = 45,
    VK_STRUCTURE_TYPE_MEMORY_BARRIER                                               = 46,
    VK_STRUCTURE_TYPE_LOADER_INSTANCE_CREATE_INFO                                  = 47,
    VK_STRUCTURE_TYPE_LOADER_DEVICE_CREATE_INFO                                    = 48,
    VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SUBGROUP_PROPERTIES                          = 1000094000,
    VK_STRUCTURE_TYPE_BIND_BUFFER_MEMORY_INFO                                      = 1000157000,
    VK_STRUCTURE_TYPE_BIND_IMAGE_MEMORY_INFO                                       = 1000157001,
    VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_16BIT_STORAGE_FEATURES                       = 1000083000,
    VK_STRUCTURE_TYPE_MEMORY_DEDICATED_REQUIREMENTS                                = 1000127000,
    VK_STRUCTURE_TYPE_MEMORY_DEDICATED_ALLOCATE_INFO                               = 1000127001,
    VK_STRUCTURE_TYPE_MEMORY_ALLOCATE_FLAGS_INFO                                   = 1000060000,
    VK_STRUCTURE_TYPE_DEVICE_GROUP_RENDER_PASS_BEGIN_INFO                          = 1000060003,
    VK_STRUCTURE_TYPE_DEVICE_GROUP_COMMAND_BUFFER_BEGIN_INFO                       = 1000060004,
    VK_STRUCTURE_TYPE_DEVICE_GROUP_SUBMIT_INFO                                     = 1000060005,
    VK_STRUCTURE_TYPE_DEVICE_GROUP_BIND_SPARSE_INFO                                = 1000060006,
    VK_STRUCTURE_TYPE_BIND_BUFFER_MEMORY_DEVICE_GROUP_INFO                         = 1000060013,
    VK_STRUCTURE_TYPE_BIND_IMAGE_MEMORY_DEVICE_GROUP_INFO                          = 1000060014,
    VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_GROUP_PROPERTIES                             = 1000070000,
    VK_STRUCTURE_TYPE_DEVICE_GROUP_DEVICE_CREATE_INFO                              = 1000070001,
    VK_STRUCTURE_TYPE_BUFFER_MEMORY_REQUIREMENTS_INFO_2                            = 1000146000,
    VK_STRUCTURE_TYPE_IMAGE_MEMORY_REQUIREMENTS_INFO_2                             = 1000146001,
    VK_STRUCTURE_TYPE_IMAGE_SPARSE_MEMORY_REQUIREMENTS_INFO_2                      = 1000146002,
    VK_STRUCTURE_TYPE_MEMORY_REQUIREMENTS_2                                        = 1000146003,
    VK_STRUCTURE_TYPE_SPARSE_IMAGE_MEMORY_REQUIREMENTS_2                           = 1000146004,
    VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_FEATURES_2                                   = 1000059000,
    VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PROPERTIES_2                                 = 1000059001,
    VK_STRUCTURE_TYPE_FORMAT_PROPERTIES_2                                          = 1000059002,
    VK_STRUCTURE_TYPE_IMAGE_FORMAT_PROPERTIES_2                                    = 1000059003,
    VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_IMAGE_FORMAT_INFO_2                          = 1000059004,
    VK_STRUCTURE_TYPE_QUEUE_FAMILY_PROPERTIES_2                                    = 1000059005,
    VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MEMORY_PROPERTIES_2                          = 1000059006,
    VK_STRUCTURE_TYPE_SPARSE_IMAGE_FORMAT_PROPERTIES_2                             = 1000059007,
    VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SPARSE_IMAGE_FORMAT_INFO_2                   = 1000059008,
    VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_POINT_CLIPPING_PROPERTIES                    = 1000117000,
    VK_STRUCTURE_TYPE_RENDER_PASS_INPUT_ATTACHMENT_ASPECT_CREATE_INFO              = 1000117001,
    VK_STRUCTURE_TYPE_IMAGE_VIEW_USAGE_CREATE_INFO                                 = 1000117002,
    VK_STRUCTURE_TYPE_PIPELINE_TESSELLATION_DOMAIN_ORIGIN_STATE_CREATE_INFO        = 1000117003,
    VK_STRUCTURE_TYPE_RENDER_PASS_MULTIVIEW_CREATE_INFO                            = 1000053000,
    VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MULTIVIEW_FEATURES                           = 1000053001,
    VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MULTIVIEW_PROPERTIES                         = 1000053002,
    VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_VARIABLE_POINTER_FEATURES                    = 1000120000,
    VK_STRUCTURE_TYPE_PROTECTED_SUBMIT_INFO                                        = 1000145000,
    VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PROTECTED_MEMORY_FEATURES                    = 1000145001,
    VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PROTECTED_MEMORY_PROPERTIES                  = 1000145002,
    VK_STRUCTURE_TYPE_DEVICE_QUEUE_INFO_2                                          = 1000145003,
    VK_STRUCTURE_TYPE_SAMPLER_YCBCR_CONVERSION_CREATE_INFO                         = 1000156000,
    VK_STRUCTURE_TYPE_SAMPLER_YCBCR_CONVERSION_INFO                                = 1000156001,
    VK_STRUCTURE_TYPE_BIND_IMAGE_PLANE_MEMORY_INFO                                 = 1000156002,
    VK_STRUCTURE_TYPE_IMAGE_PLANE_MEMORY_REQUIREMENTS_INFO                         = 1000156003,
    VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SAMPLER_YCBCR_CONVERSION_FEATURES            = 1000156004,
    VK_STRUCTURE_TYPE_SAMPLER_YCBCR_CONVERSION_IMAGE_FORMAT_PROPERTIES             = 1000156005,
    VK_STRUCTURE_TYPE_DESCRIPTOR_UPDATE_TEMPLATE_CREATE_INFO                       = 1000085000,
    VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_EXTERNAL_IMAGE_FORMAT_INFO                   = 1000071000,
    VK_STRUCTURE_TYPE_EXTERNAL_IMAGE_FORMAT_PROPERTIES                             = 1000071001,
    VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_EXTERNAL_BUFFER_INFO                         = 1000071002,
    VK_STRUCTURE_TYPE_EXTERNAL_BUFFER_PROPERTIES                                   = 1000071003,
    VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_ID_PROPERTIES                                = 1000071004,
    VK_STRUCTURE_TYPE_EXTERNAL_MEMORY_BUFFER_CREATE_INFO                           = 1000072000,
    VK_STRUCTURE_TYPE_EXTERNAL_MEMORY_IMAGE_CREATE_INFO                            = 1000072001,
    VK_STRUCTURE_TYPE_EXPORT_MEMORY_ALLOCATE_INFO                                  = 1000072002,
    VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_EXTERNAL_FENCE_INFO                          = 1000112000,
    VK_STRUCTURE_TYPE_EXTERNAL_FENCE_PROPERTIES                                    = 1000112001,
    VK_STRUCTURE_TYPE_EXPORT_FENCE_CREATE_INFO                                     = 1000113000,
    VK_STRUCTURE_TYPE_EXPORT_SEMAPHORE_CREATE_INFO                                 = 1000077000,
    VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_EXTERNAL_SEMAPHORE_INFO                      = 1000076000,
    VK_STRUCTURE_TYPE_EXTERNAL_SEMAPHORE_PROPERTIES                                = 1000076001,
    VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MAINTENANCE_3_PROPERTIES                     = 1000168000,
    VK_STRUCTURE_TYPE_DESCRIPTOR_SET_LAYOUT_SUPPORT                                = 1000168001,
    VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADER_DRAW_PARAMETER_FEATURES               = 1000063000,
    VK_STRUCTURE_TYPE_SWAPCHAIN_CREATE_INFO_KHR                                    = 1000001000,
    VK_STRUCTURE_TYPE_PRESENT_INFO_KHR                                             = 1000001001,
    VK_STRUCTURE_TYPE_DEVICE_GROUP_PRESENT_CAPABILITIES_KHR                        = 1000060007,
    VK_STRUCTURE_TYPE_IMAGE_SWAPCHAIN_CREATE_INFO_KHR                              = 1000060008,
    VK_STRUCTURE_TYPE_BIND_IMAGE_MEMORY_SWAPCHAIN_INFO_KHR                         = 1000060009,
    VK_STRUCTURE_TYPE_ACQUIRE_NEXT_IMAGE_INFO_KHR                                  = 1000060010,
    VK_STRUCTURE_TYPE_DEVICE_GROUP_PRESENT_INFO_KHR                                = 1000060011,
    VK_STRUCTURE_TYPE_DEVICE_GROUP_SWAPCHAIN_CREATE_INFO_KHR                       = 1000060012,
    VK_STRUCTURE_TYPE_DISPLAY_MODE_CREATE_INFO_KHR                                 = 1000002000,
    VK_STRUCTURE_TYPE_DISPLAY_SURFACE_CREATE_INFO_KHR                              = 1000002001,
    VK_STRUCTURE_TYPE_DISPLAY_PRESENT_INFO_KHR                                     = 1000003000,
    VK_STRUCTURE_TYPE_XLIB_SURFACE_CREATE_INFO_KHR                                 = 1000004000,
    VK_STRUCTURE_TYPE_XCB_SURFACE_CREATE_INFO_KHR                                  = 1000005000,
    VK_STRUCTURE_TYPE_WAYLAND_SURFACE_CREATE_INFO_KHR                              = 1000006000,
    VK_STRUCTURE_TYPE_ANDROID_SURFACE_CREATE_INFO_KHR                              = 1000008000,
    VK_STRUCTURE_TYPE_WIN32_SURFACE_CREATE_INFO_KHR                                = 1000009000,
    VK_STRUCTURE_TYPE_NATIVE_BUFFER_ANDROID                                        = 1000010000,
    VK_STRUCTURE_TYPE_DEBUG_REPORT_CALLBACK_CREATE_INFO_EXT                        = 1000011000,
    VK_STRUCTURE_TYPE_DEBUG_REPORT_CREATE_INFO_EXT                                 = VK_STRUCTURE_TYPE_DEBUG_REPORT_CALLBACK_CREATE_INFO_EXT,
    VK_STRUCTURE_TYPE_PIPELINE_RASTERIZATION_STATE_RASTERIZATION_ORDER_AMD         = 1000018000,
    VK_STRUCTURE_TYPE_DEBUG_MARKER_OBJECT_NAME_INFO_EXT                            = 1000022000,
    VK_STRUCTURE_TYPE_DEBUG_MARKER_OBJECT_TAG_INFO_EXT                             = 1000022001,
    VK_STRUCTURE_TYPE_DEBUG_MARKER_MARKER_INFO_EXT                                 = 1000022002,
    VK_STRUCTURE_TYPE_DEDICATED_ALLOCATION_IMAGE_CREATE_INFO_NV                    = 1000026000,
    VK_STRUCTURE_TYPE_DEDICATED_ALLOCATION_BUFFER_CREATE_INFO_NV                   = 1000026001,
    VK_STRUCTURE_TYPE_DEDICATED_ALLOCATION_MEMORY_ALLOCATE_INFO_NV                 = 1000026002,
    VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_TRANSFORM_FEEDBACK_FEATURES_EXT              = 1000028000,
    VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_TRANSFORM_FEEDBACK_PROPERTIES_EXT            = 1000028001,
    VK_STRUCTURE_TYPE_PIPELINE_RASTERIZATION_STATE_STREAM_CREATE_INFO_EXT          = 1000028002,
    VK_STRUCTURE_TYPE_TEXTURE_LOD_GATHER_FORMAT_PROPERTIES_AMD                     = 1000041000,
    VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_CORNER_SAMPLED_IMAGE_FEATURES_NV             = 1000050000,
    VK_STRUCTURE_TYPE_RENDER_PASS_MULTIVIEW_CREATE_INFO_KHR                        = VK_STRUCTURE_TYPE_RENDER_PASS_MULTIVIEW_CREATE_INFO,
    VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MULTIVIEW_FEATURES_KHR                       = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MULTIVIEW_FEATURES,
    VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MULTIVIEW_PROPERTIES_KHR                     = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MULTIVIEW_PROPERTIES,
    VK_STRUCTURE_TYPE_EXTERNAL_MEMORY_IMAGE_CREATE_INFO_NV                         = 1000056000,
    VK_STRUCTURE_TYPE_EXPORT_MEMORY_ALLOCATE_INFO_NV                               = 1000056001,
    VK_STRUCTURE_TYPE_IMPORT_MEMORY_WIN32_HANDLE_INFO_NV                           = 1000057000,
    VK_STRUCTURE_TYPE_EXPORT_MEMORY_WIN32_HANDLE_INFO_NV                           = 1000057001,
    VK_STRUCTURE_TYPE_WIN32_KEYED_MUTEX_ACQUIRE_RELEASE_INFO_NV                    = 1000058000,
    VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_FEATURES_2_KHR                               = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_FEATURES_2,
    VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PROPERTIES_2_KHR                             = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PROPERTIES_2,
    VK_STRUCTURE_TYPE_FORMAT_PROPERTIES_2_KHR                                      = VK_STRUCTURE_TYPE_FORMAT_PROPERTIES_2,
    VK_STRUCTURE_TYPE_IMAGE_FORMAT_PROPERTIES_2_KHR                                = VK_STRUCTURE_TYPE_IMAGE_FORMAT_PROPERTIES_2,
    VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_IMAGE_FORMAT_INFO_2_KHR                      = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_IMAGE_FORMAT_INFO_2,
    VK_STRUCTURE_TYPE_QUEUE_FAMILY_PROPERTIES_2_KHR                                = VK_STRUCTURE_TYPE_QUEUE_FAMILY_PROPERTIES_2,
    VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MEMORY_PROPERTIES_2_KHR                      = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MEMORY_PROPERTIES_2,
    VK_STRUCTURE_TYPE_SPARSE_IMAGE_FORMAT_PROPERTIES_2_KHR                         = VK_STRUCTURE_TYPE_SPARSE_IMAGE_FORMAT_PROPERTIES_2,
    VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SPARSE_IMAGE_FORMAT_INFO_2_KHR               = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SPARSE_IMAGE_FORMAT_INFO_2,
    VK_STRUCTURE_TYPE_MEMORY_ALLOCATE_FLAGS_INFO_KHR                               = VK_STRUCTURE_TYPE_MEMORY_ALLOCATE_FLAGS_INFO,
    VK_STRUCTURE_TYPE_DEVICE_GROUP_RENDER_PASS_BEGIN_INFO_KHR                      = VK_STRUCTURE_TYPE_DEVICE_GROUP_RENDER_PASS_BEGIN_INFO,
    VK_STRUCTURE_TYPE_DEVICE_GROUP_COMMAND_BUFFER_BEGIN_INFO_KHR                   = VK_STRUCTURE_TYPE_DEVICE_GROUP_COMMAND_BUFFER_BEGIN_INFO,
    VK_STRUCTURE_TYPE_DEVICE_GROUP_SUBMIT_INFO_KHR                                 = VK_STRUCTURE_TYPE_DEVICE_GROUP_SUBMIT_INFO,
    VK_STRUCTURE_TYPE_DEVICE_GROUP_BIND_SPARSE_INFO_KHR                            = VK_STRUCTURE_TYPE_DEVICE_GROUP_BIND_SPARSE_INFO,
    VK_STRUCTURE_TYPE_BIND_BUFFER_MEMORY_DEVICE_GROUP_INFO_KHR                     = VK_STRUCTURE_TYPE_BIND_BUFFER_MEMORY_DEVICE_GROUP_INFO,
    VK_STRUCTURE_TYPE_BIND_IMAGE_MEMORY_DEVICE_GROUP_INFO_KHR                      = VK_STRUCTURE_TYPE_BIND_IMAGE_MEMORY_DEVICE_GROUP_INFO,
    VK_STRUCTURE_TYPE_VALIDATION_FLAGS_EXT                                         = 1000061000,
    VK_STRUCTURE_TYPE_VI_SURFACE_CREATE_INFO_NN                                    = 1000062000,
    VK_STRUCTURE_TYPE_IMAGE_VIEW_ASTC_DECODE_MODE_EXT                              = 1000067000,
    VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_ASTC_DECODE_FEATURES_EXT                     = 1000067001,
    VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_GROUP_PROPERTIES_KHR                         = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_GROUP_PROPERTIES,
    VK_STRUCTURE_TYPE_DEVICE_GROUP_DEVICE_CREATE_INFO_KHR                          = VK_STRUCTURE_TYPE_DEVICE_GROUP_DEVICE_CREATE_INFO,
    VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_EXTERNAL_IMAGE_FORMAT_INFO_KHR               = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_EXTERNAL_IMAGE_FORMAT_INFO,
    VK_STRUCTURE_TYPE_EXTERNAL_IMAGE_FORMAT_PROPERTIES_KHR                         = VK_STRUCTURE_TYPE_EXTERNAL_IMAGE_FORMAT_PROPERTIES,
    VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_EXTERNAL_BUFFER_INFO_KHR                     = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_EXTERNAL_BUFFER_INFO,
    VK_STRUCTURE_TYPE_EXTERNAL_BUFFER_PROPERTIES_KHR                               = VK_STRUCTURE_TYPE_EXTERNAL_BUFFER_PROPERTIES,
    VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_ID_PROPERTIES_KHR                            = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_ID_PROPERTIES,
    VK_STRUCTURE_TYPE_EXTERNAL_MEMORY_BUFFER_CREATE_INFO_KHR                       = VK_STRUCTURE_TYPE_EXTERNAL_MEMORY_BUFFER_CREATE_INFO,
    VK_STRUCTURE_TYPE_EXTERNAL_MEMORY_IMAGE_CREATE_INFO_KHR                        = VK_STRUCTURE_TYPE_EXTERNAL_MEMORY_IMAGE_CREATE_INFO,
    VK_STRUCTURE_TYPE_EXPORT_MEMORY_ALLOCATE_INFO_KHR                              = VK_STRUCTURE_TYPE_EXPORT_MEMORY_ALLOCATE_INFO,
    VK_STRUCTURE_TYPE_IMPORT_MEMORY_WIN32_HANDLE_INFO_KHR                          = 1000073000,
    VK_STRUCTURE_TYPE_EXPORT_MEMORY_WIN32_HANDLE_INFO_KHR                          = 1000073001,
    VK_STRUCTURE_TYPE_MEMORY_WIN32_HANDLE_PROPERTIES_KHR                           = 1000073002,
    VK_STRUCTURE_TYPE_MEMORY_GET_WIN32_HANDLE_INFO_KHR                             = 1000073003,
    VK_STRUCTURE_TYPE_IMPORT_MEMORY_FD_INFO_KHR                                    = 1000074000,
    VK_STRUCTURE_TYPE_MEMORY_FD_PROPERTIES_KHR                                     = 1000074001,
    VK_STRUCTURE_TYPE_MEMORY_GET_FD_INFO_KHR                                       = 1000074002,
    VK_STRUCTURE_TYPE_WIN32_KEYED_MUTEX_ACQUIRE_RELEASE_INFO_KHR                   = 1000075000,
    VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_EXTERNAL_SEMAPHORE_INFO_KHR                  = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_EXTERNAL_SEMAPHORE_INFO,
    VK_STRUCTURE_TYPE_EXTERNAL_SEMAPHORE_PROPERTIES_KHR                            = VK_STRUCTURE_TYPE_EXTERNAL_SEMAPHORE_PROPERTIES,
    VK_STRUCTURE_TYPE_EXPORT_SEMAPHORE_CREATE_INFO_KHR                             = VK_STRUCTURE_TYPE_EXPORT_SEMAPHORE_CREATE_INFO,
    VK_STRUCTURE_TYPE_IMPORT_SEMAPHORE_WIN32_HANDLE_INFO_KHR                       = 1000078000,
    VK_STRUCTURE_TYPE_EXPORT_SEMAPHORE_WIN32_HANDLE_INFO_KHR                       = 1000078001,
    VK_STRUCTURE_TYPE_D3D12_FENCE_SUBMIT_INFO_KHR                                  = 1000078002,
    VK_STRUCTURE_TYPE_SEMAPHORE_GET_WIN32_HANDLE_INFO_KHR                          = 1000078003,
    VK_STRUCTURE_TYPE_IMPORT_SEMAPHORE_FD_INFO_KHR                                 = 1000079000,
    VK_STRUCTURE_TYPE_SEMAPHORE_GET_FD_INFO_KHR                                    = 1000079001,
    VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PUSH_DESCRIPTOR_PROPERTIES_KHR               = 1000080000,
    VK_STRUCTURE_TYPE_COMMAND_BUFFER_INHERITANCE_CONDITIONAL_RENDERING_INFO_EXT    = 1000081000,
    VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_CONDITIONAL_RENDERING_FEATURES_EXT           = 1000081001,
    VK_STRUCTURE_TYPE_CONDITIONAL_RENDERING_BEGIN_INFO_EXT                         = 1000081002,
    VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_FLOAT16_INT8_FEATURES_KHR                    = 1000082000,
    VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_16BIT_STORAGE_FEATURES_KHR                   = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_16BIT_STORAGE_FEATURES,
    VK_STRUCTURE_TYPE_PRESENT_REGIONS_KHR                                          = 1000084000,
    VK_STRUCTURE_TYPE_DESCRIPTOR_UPDATE_TEMPLATE_CREATE_INFO_KHR                   = VK_STRUCTURE_TYPE_DESCRIPTOR_UPDATE_TEMPLATE_CREATE_INFO,
    VK_STRUCTURE_TYPE_OBJECT_TABLE_CREATE_INFO_NVX                                 = 1000086000,
    VK_STRUCTURE_TYPE_INDIRECT_COMMANDS_LAYOUT_CREATE_INFO_NVX                     = 1000086001,
    VK_STRUCTURE_TYPE_CMD_PROCESS_COMMANDS_INFO_NVX                                = 1000086002,
    VK_STRUCTURE_TYPE_CMD_RESERVE_SPACE_FOR_COMMANDS_INFO_NVX                      = 1000086003,
    VK_STRUCTURE_TYPE_DEVICE_GENERATED_COMMANDS_LIMITS_NVX                         = 1000086004,
    VK_STRUCTURE_TYPE_DEVICE_GENERATED_COMMANDS_FEATURES_NVX                       = 1000086005,
    VK_STRUCTURE_TYPE_PIPELINE_VIEWPORT_W_SCALING_STATE_CREATE_INFO_NV             = 1000087000,
    VK_STRUCTURE_TYPE_SURFACE_CAPABILITIES_2_EXT                                   = 1000090000,
    VK_STRUCTURE_TYPE_SURFACE_CAPABILITIES2_EXT                                    = VK_STRUCTURE_TYPE_SURFACE_CAPABILITIES_2_EXT,
    VK_STRUCTURE_TYPE_DISPLAY_POWER_INFO_EXT                                       = 1000091000,
    VK_STRUCTURE_TYPE_DEVICE_EVENT_INFO_EXT                                        = 1000091001,
    VK_STRUCTURE_TYPE_DISPLAY_EVENT_INFO_EXT                                       = 1000091002,
    VK_STRUCTURE_TYPE_SWAPCHAIN_COUNTER_CREATE_INFO_EXT                            = 1000091003,
    VK_STRUCTURE_TYPE_PRESENT_TIMES_INFO_GOOGLE                                    = 1000092000,
    VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MULTIVIEW_PER_VIEW_ATTRIBUTES_PROPERTIES_NVX = 1000097000,
    VK_STRUCTURE_TYPE_PIPELINE_VIEWPORT_SWIZZLE_STATE_CREATE_INFO_NV               = 1000098000,
    VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_DISCARD_RECTANGLE_PROPERTIES_EXT             = 1000099000,
    VK_STRUCTURE_TYPE_PIPELINE_DISCARD_RECTANGLE_STATE_CREATE_INFO_EXT             = 1000099001,
    VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_CONSERVATIVE_RASTERIZATION_PROPERTIES_EXT    = 1000101000,
    VK_STRUCTURE_TYPE_PIPELINE_RASTERIZATION_CONSERVATIVE_STATE_CREATE_INFO_EXT    = 1000101001,
    VK_STRUCTURE_TYPE_HDR_METADATA_EXT                                             = 1000105000,
    VK_STRUCTURE_TYPE_ATTACHMENT_DESCRIPTION_2_KHR                                 = 1000109000,
    VK_STRUCTURE_TYPE_ATTACHMENT_REFERENCE_2_KHR                                   = 1000109001,
    VK_STRUCTURE_TYPE_SUBPASS_DESCRIPTION_2_KHR                                    = 1000109002,
    VK_STRUCTURE_TYPE_SUBPASS_DEPENDENCY_2_KHR                                     = 1000109003,
    VK_STRUCTURE_TYPE_RENDER_PASS_CREATE_INFO_2_KHR                                = 1000109004,
    VK_STRUCTURE_TYPE_SUBPASS_BEGIN_INFO_KHR                                       = 1000109005,
    VK_STRUCTURE_TYPE_SUBPASS_END_INFO_KHR                                         = 1000109006,
    VK_STRUCTURE_TYPE_SHARED_PRESENT_SURFACE_CAPABILITIES_KHR                      = 1000111000,
    VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_EXTERNAL_FENCE_INFO_KHR                      = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_EXTERNAL_FENCE_INFO,
    VK_STRUCTURE_TYPE_EXTERNAL_FENCE_PROPERTIES_KHR                                = VK_STRUCTURE_TYPE_EXTERNAL_FENCE_PROPERTIES,
    VK_STRUCTURE_TYPE_EXPORT_FENCE_CREATE_INFO_KHR                                 = VK_STRUCTURE_TYPE_EXPORT_FENCE_CREATE_INFO,
    VK_STRUCTURE_TYPE_IMPORT_FENCE_WIN32_HANDLE_INFO_KHR                           = 1000114000,
    VK_STRUCTURE_TYPE_EXPORT_FENCE_WIN32_HANDLE_INFO_KHR                           = 1000114001,
    VK_STRUCTURE_TYPE_FENCE_GET_WIN32_HANDLE_INFO_KHR                              = 1000114002,
    VK_STRUCTURE_TYPE_IMPORT_FENCE_FD_INFO_KHR                                     = 1000115000,
    VK_STRUCTURE_TYPE_FENCE_GET_FD_INFO_KHR                                        = 1000115001,
    VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_POINT_CLIPPING_PROPERTIES_KHR                = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_POINT_CLIPPING_PROPERTIES,
    VK_STRUCTURE_TYPE_RENDER_PASS_INPUT_ATTACHMENT_ASPECT_CREATE_INFO_KHR          = VK_STRUCTURE_TYPE_RENDER_PASS_INPUT_ATTACHMENT_ASPECT_CREATE_INFO,
    VK_STRUCTURE_TYPE_IMAGE_VIEW_USAGE_CREATE_INFO_KHR                             = VK_STRUCTURE_TYPE_IMAGE_VIEW_USAGE_CREATE_INFO,
    VK_STRUCTURE_TYPE_PIPELINE_TESSELLATION_DOMAIN_ORIGIN_STATE_CREATE_INFO_KHR    = VK_STRUCTURE_TYPE_PIPELINE_TESSELLATION_DOMAIN_ORIGIN_STATE_CREATE_INFO,
    VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SURFACE_INFO_2_KHR                           = 1000119000,
    VK_STRUCTURE_TYPE_SURFACE_CAPABILITIES_2_KHR                                   = 1000119001,
    VK_STRUCTURE_TYPE_SURFACE_FORMAT_2_KHR                                         = 1000119002,
    VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_VARIABLE_POINTER_FEATURES_KHR                = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_VARIABLE_POINTER_FEATURES,
    VK_STRUCTURE_TYPE_DISPLAY_PROPERTIES_2_KHR                                     = 1000121000,
    VK_STRUCTURE_TYPE_DISPLAY_PLANE_PROPERTIES_2_KHR                               = 1000121001,
    VK_STRUCTURE_TYPE_DISPLAY_MODE_PROPERTIES_2_KHR                                = 1000121002,
    VK_STRUCTURE_TYPE_DISPLAY_PLANE_INFO_2_KHR                                     = 1000121003,
    VK_STRUCTURE_TYPE_DISPLAY_PLANE_CAPABILITIES_2_KHR                             = 1000121004,
    VK_STRUCTURE_TYPE_IOS_SURFACE_CREATE_INFO_MVK                                  = 1000122000,
    VK_STRUCTURE_TYPE_MACOS_SURFACE_CREATE_INFO_MVK                                = 1000123000,
    VK_STRUCTURE_TYPE_MEMORY_DEDICATED_REQUIREMENTS_KHR                            = VK_STRUCTURE_TYPE_MEMORY_DEDICATED_REQUIREMENTS,
    VK_STRUCTURE_TYPE_MEMORY_DEDICATED_ALLOCATE_INFO_KHR                           = VK_STRUCTURE_TYPE_MEMORY_DEDICATED_ALLOCATE_INFO,
    VK_STRUCTURE_TYPE_DEBUG_UTILS_OBJECT_NAME_INFO_EXT                             = 1000128000,
    VK_STRUCTURE_TYPE_DEBUG_UTILS_OBJECT_TAG_INFO_EXT                              = 1000128001,
    VK_STRUCTURE_TYPE_DEBUG_UTILS_LABEL_EXT                                        = 1000128002,
    VK_STRUCTURE_TYPE_DEBUG_UTILS_MESSENGER_CALLBACK_DATA_EXT                      = 1000128003,
    VK_STRUCTURE_TYPE_DEBUG_UTILS_MESSENGER_CREATE_INFO_EXT                        = 1000128004,
    VK_STRUCTURE_TYPE_ANDROID_HARDWARE_BUFFER_USAGE_ANDROID                        = 1000129000,
    VK_STRUCTURE_TYPE_ANDROID_HARDWARE_BUFFER_PROPERTIES_ANDROID                   = 1000129001,
    VK_STRUCTURE_TYPE_ANDROID_HARDWARE_BUFFER_FORMAT_PROPERTIES_ANDROID            = 1000129002,
    VK_STRUCTURE_TYPE_IMPORT_ANDROID_HARDWARE_BUFFER_INFO_ANDROID                  = 1000129003,
    VK_STRUCTURE_TYPE_MEMORY_GET_ANDROID_HARDWARE_BUFFER_INFO_ANDROID              = 1000129004,
    VK_STRUCTURE_TYPE_EXTERNAL_FORMAT_ANDROID                                      = 1000129005,
    VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SAMPLER_FILTER_MINMAX_PROPERTIES_EXT         = 1000130000,
    VK_STRUCTURE_TYPE_SAMPLER_REDUCTION_MODE_CREATE_INFO_EXT                       = 1000130001,
    VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_INLINE_UNIFORM_BLOCK_FEATURES_EXT            = 1000138000,
    VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_INLINE_UNIFORM_BLOCK_PROPERTIES_EXT          = 1000138001,
    VK_STRUCTURE_TYPE_WRITE_DESCRIPTOR_SET_INLINE_UNIFORM_BLOCK_EXT                = 1000138002,
    VK_STRUCTURE_TYPE_DESCRIPTOR_POOL_INLINE_UNIFORM_BLOCK_CREATE_INFO_EXT         = 1000138003,
    VK_STRUCTURE_TYPE_SAMPLE_LOCATIONS_INFO_EXT                                    = 1000143000,
    VK_STRUCTURE_TYPE_RENDER_PASS_SAMPLE_LOCATIONS_BEGIN_INFO_EXT                  = 1000143001,
    VK_STRUCTURE_TYPE_PIPELINE_SAMPLE_LOCATIONS_STATE_CREATE_INFO_EXT              = 1000143002,
    VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SAMPLE_LOCATIONS_PROPERTIES_EXT              = 1000143003,
    VK_STRUCTURE_TYPE_MULTISAMPLE_PROPERTIES_EXT                                   = 1000143004,
    VK_STRUCTURE_TYPE_BUFFER_MEMORY_REQUIREMENTS_INFO_2_KHR                        = VK_STRUCTURE_TYPE_BUFFER_MEMORY_REQUIREMENTS_INFO_2,
    VK_STRUCTURE_TYPE_IMAGE_MEMORY_REQUIREMENTS_INFO_2_KHR                         = VK_STRUCTURE_TYPE_IMAGE_MEMORY_REQUIREMENTS_INFO_2,
    VK_STRUCTURE_TYPE_IMAGE_SPARSE_MEMORY_REQUIREMENTS_INFO_2_KHR                  = VK_STRUCTURE_TYPE_IMAGE_SPARSE_MEMORY_REQUIREMENTS_INFO_2,
    VK_STRUCTURE_TYPE_MEMORY_REQUIREMENTS_2_KHR                                    = VK_STRUCTURE_TYPE_MEMORY_REQUIREMENTS_2,
    VK_STRUCTURE_TYPE_SPARSE_IMAGE_MEMORY_REQUIREMENTS_2_KHR                       = VK_STRUCTURE_TYPE_SPARSE_IMAGE_MEMORY_REQUIREMENTS_2,
    VK_STRUCTURE_TYPE_IMAGE_FORMAT_LIST_CREATE_INFO_KHR                            = 1000147000,
    VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_BLEND_OPERATION_ADVANCED_FEATURES_EXT        = 1000148000,
    VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_BLEND_OPERATION_ADVANCED_PROPERTIES_EXT      = 1000148001,
    VK_STRUCTURE_TYPE_PIPELINE_COLOR_BLEND_ADVANCED_STATE_CREATE_INFO_EXT          = 1000148002,
    VK_STRUCTURE_TYPE_PIPELINE_COVERAGE_TO_COLOR_STATE_CREATE_INFO_NV              = 1000149000,
    VK_STRUCTURE_TYPE_PIPELINE_COVERAGE_MODULATION_STATE_CREATE_INFO_NV            = 1000152000,
    VK_STRUCTURE_TYPE_SAMPLER_YCBCR_CONVERSION_CREATE_INFO_KHR                     = VK_STRUCTURE_TYPE_SAMPLER_YCBCR_CONVERSION_CREATE_INFO,
    VK_STRUCTURE_TYPE_SAMPLER_YCBCR_CONVERSION_INFO_KHR                            = VK_STRUCTURE_TYPE_SAMPLER_YCBCR_CONVERSION_INFO,
    VK_STRUCTURE_TYPE_BIND_IMAGE_PLANE_MEMORY_INFO_KHR                             = VK_STRUCTURE_TYPE_BIND_IMAGE_PLANE_MEMORY_INFO,
    VK_STRUCTURE_TYPE_IMAGE_PLANE_MEMORY_REQUIREMENTS_INFO_KHR                     = VK_STRUCTURE_TYPE_IMAGE_PLANE_MEMORY_REQUIREMENTS_INFO,
    VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SAMPLER_YCBCR_CONVERSION_FEATURES_KHR        = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SAMPLER_YCBCR_CONVERSION_FEATURES,
    VK_STRUCTURE_TYPE_SAMPLER_YCBCR_CONVERSION_IMAGE_FORMAT_PROPERTIES_KHR         = VK_STRUCTURE_TYPE_SAMPLER_YCBCR_CONVERSION_IMAGE_FORMAT_PROPERTIES,
    VK_STRUCTURE_TYPE_BIND_BUFFER_MEMORY_INFO_KHR                                  = VK_STRUCTURE_TYPE_BIND_BUFFER_MEMORY_INFO,
    VK_STRUCTURE_TYPE_BIND_IMAGE_MEMORY_INFO_KHR                                   = VK_STRUCTURE_TYPE_BIND_IMAGE_MEMORY_INFO,
    VK_STRUCTURE_TYPE_DRM_FORMAT_MODIFIER_PROPERTIES_LIST_EXT                      = 1000158000,
    VK_STRUCTURE_TYPE_DRM_FORMAT_MODIFIER_PROPERTIES_EXT                           = 1000158001,
    VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_IMAGE_DRM_FORMAT_MODIFIER_INFO_EXT           = 1000158002,
    VK_STRUCTURE_TYPE_IMAGE_DRM_FORMAT_MODIFIER_LIST_CREATE_INFO_EXT               = 1000158003,
    VK_STRUCTURE_TYPE_IMAGE_DRM_FORMAT_MODIFIER_EXPLICIT_CREATE_INFO_EXT           = 1000158004,
    VK_STRUCTURE_TYPE_IMAGE_DRM_FORMAT_MODIFIER_PROPERTIES_EXT                     = 1000158005,
    VK_STRUCTURE_TYPE_VALIDATION_CACHE_CREATE_INFO_EXT                             = 1000160000,
    VK_STRUCTURE_TYPE_SHADER_MODULE_VALIDATION_CACHE_CREATE_INFO_EXT               = 1000160001,
    VK_STRUCTURE_TYPE_DESCRIPTOR_SET_LAYOUT_BINDING_FLAGS_CREATE_INFO_EXT          = 1000161000,
    VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_DESCRIPTOR_INDEXING_FEATURES_EXT             = 1000161001,
    VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_DESCRIPTOR_INDEXING_PROPERTIES_EXT           = 1000161002,
    VK_STRUCTURE_TYPE_DESCRIPTOR_SET_VARIABLE_DESCRIPTOR_COUNT_ALLOCATE_INFO_EXT   = 1000161003,
    VK_STRUCTURE_TYPE_DESCRIPTOR_SET_VARIABLE_DESCRIPTOR_COUNT_LAYOUT_SUPPORT_EXT  = 1000161004,
    VK_STRUCTURE_TYPE_PIPELINE_VIEWPORT_SHADING_RATE_IMAGE_STATE_CREATE_INFO_NV    = 1000164000,
    VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADING_RATE_IMAGE_FEATURES_NV               = 1000164001,
    VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADING_RATE_IMAGE_PROPERTIES_NV             = 1000164002,
    VK_STRUCTURE_TYPE_PIPELINE_VIEWPORT_COARSE_SAMPLE_ORDER_STATE_CREATE_INFO_NV   = 1000164005,
    VK_STRUCTURE_TYPE_RAY_TRACING_PIPELINE_CREATE_INFO_NV                          = 1000165000,
    VK_STRUCTURE_TYPE_ACCELERATION_STRUCTURE_CREATE_INFO_NV                        = 1000165001,
    VK_STRUCTURE_TYPE_GEOMETRY_NV                                                  = 1000165003,
    VK_STRUCTURE_TYPE_GEOMETRY_TRIANGLES_NV                                        = 1000165004,
    VK_STRUCTURE_TYPE_GEOMETRY_AABB_NV                                             = 1000165005,
    VK_STRUCTURE_TYPE_BIND_ACCELERATION_STRUCTURE_MEMORY_INFO_NV                   = 1000165006,
    VK_STRUCTURE_TYPE_WRITE_DESCRIPTOR_SET_ACCELERATION_STRUCTURE_NV               = 1000165007,
    VK_STRUCTURE_TYPE_ACCELERATION_STRUCTURE_MEMORY_REQUIREMENTS_INFO_NV           = 1000165008,
    VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_RAY_TRACING_PROPERTIES_NV                    = 1000165009,
    VK_STRUCTURE_TYPE_RAY_TRACING_SHADER_GROUP_CREATE_INFO_NV                      = 1000165011,
    VK_STRUCTURE_TYPE_ACCELERATION_STRUCTURE_INFO_NV                               = 1000165012,
    VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_REPRESENTATIVE_FRAGMENT_TEST_FEATURES_NV     = 1000166000,
    VK_STRUCTURE_TYPE_PIPELINE_REPRESENTATIVE_FRAGMENT_TEST_STATE_CREATE_INFO_NV   = 1000166001,
    VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MAINTENANCE_3_PROPERTIES_KHR                 = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MAINTENANCE_3_PROPERTIES,
    VK_STRUCTURE_TYPE_DESCRIPTOR_SET_LAYOUT_SUPPORT_KHR                            = VK_STRUCTURE_TYPE_DESCRIPTOR_SET_LAYOUT_SUPPORT,
    VK_STRUCTURE_TYPE_DEVICE_QUEUE_GLOBAL_PRIORITY_CREATE_INFO_EXT                 = 1000174000,
    VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_8BIT_STORAGE_FEATURES_KHR                    = 1000177000,
    VK_STRUCTURE_TYPE_IMPORT_MEMORY_HOST_POINTER_INFO_EXT                          = 1000178000,
    VK_STRUCTURE_TYPE_MEMORY_HOST_POINTER_PROPERTIES_EXT                           = 1000178001,
    VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_EXTERNAL_MEMORY_HOST_PROPERTIES_EXT          = 1000178002,
    VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADER_ATOMIC_INT64_FEATURES_KHR             = 1000180000,
    VK_STRUCTURE_TYPE_CALIBRATED_TIMESTAMP_INFO_EXT                                = 1000184000,
    VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADER_CORE_PROPERTIES_AMD                   = 1000185000,
    VK_STRUCTURE_TYPE_DEVICE_MEMORY_OVERALLOCATION_CREATE_INFO_AMD                 = 1000189000,
    VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_VERTEX_ATTRIBUTE_DIVISOR_PROPERTIES_EXT      = 1000190000,
    VK_STRUCTURE_TYPE_PIPELINE_VERTEX_INPUT_DIVISOR_STATE_CREATE_INFO_EXT          = 1000190001,
    VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_VERTEX_ATTRIBUTE_DIVISOR_FEATURES_EXT        = 1000190002,
    VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_DRIVER_PROPERTIES_KHR                        = 1000196000,
    VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_FLOAT_CONTROLS_PROPERTIES_KHR                = 1000197000,
    VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_COMPUTE_SHADER_DERIVATIVES_FEATURES_NV       = 1000201000,
    VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MESH_SHADER_FEATURES_NV                      = 1000202000,
    VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MESH_SHADER_PROPERTIES_NV                    = 1000202001,
    VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_FRAGMENT_SHADER_BARYCENTRIC_FEATURES_NV      = 1000203000,
    VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADER_IMAGE_FOOTPRINT_FEATURES_NV           = 1000204000,
    VK_STRUCTURE_TYPE_PIPELINE_VIEWPORT_EXCLUSIVE_SCISSOR_STATE_CREATE_INFO_NV     = 1000205000,
    VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_EXCLUSIVE_SCISSOR_FEATURES_NV                = 1000205002,
    VK_STRUCTURE_TYPE_CHECKPOINT_DATA_NV                                           = 1000206000,
    VK_STRUCTURE_TYPE_QUEUE_FAMILY_CHECKPOINT_PROPERTIES_NV                        = 1000206001,
    VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_VULKAN_MEMORY_MODEL_FEATURES_KHR             = 1000211000,
    VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PCI_BUS_INFO_PROPERTIES_EXT                  = 1000212000,
    VK_STRUCTURE_TYPE_IMAGEPIPE_SURFACE_CREATE_INFO_FUCHSIA                        = 1000214000,
    VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_FRAGMENT_DENSITY_MAP_FEATURES_EXT            = 1000218000,
    VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_FRAGMENT_DENSITY_MAP_PROPERTIES_EXT          = 1000218001,
    VK_STRUCTURE_TYPE_RENDER_PASS_FRAGMENT_DENSITY_MAP_CREATE_INFO_EXT             = 1000218002,
    VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SCALAR_BLOCK_LAYOUT_FEATURES_EXT             = 1000221000,
    VK_STRUCTURE_TYPE_IMAGE_STENCIL_USAGE_CREATE_INFO_EXT                          = 1000246000,
}
enum VK_STRUCTURE_TYPE_APPLICATION_INFO                                             = VkStructureType.VK_STRUCTURE_TYPE_APPLICATION_INFO;
enum VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO                                         = VkStructureType.VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO;
enum VK_STRUCTURE_TYPE_DEVICE_QUEUE_CREATE_INFO                                     = VkStructureType.VK_STRUCTURE_TYPE_DEVICE_QUEUE_CREATE_INFO;
enum VK_STRUCTURE_TYPE_DEVICE_CREATE_INFO                                           = VkStructureType.VK_STRUCTURE_TYPE_DEVICE_CREATE_INFO;
enum VK_STRUCTURE_TYPE_SUBMIT_INFO                                                  = VkStructureType.VK_STRUCTURE_TYPE_SUBMIT_INFO;
enum VK_STRUCTURE_TYPE_MEMORY_ALLOCATE_INFO                                         = VkStructureType.VK_STRUCTURE_TYPE_MEMORY_ALLOCATE_INFO;
enum VK_STRUCTURE_TYPE_MAPPED_MEMORY_RANGE                                          = VkStructureType.VK_STRUCTURE_TYPE_MAPPED_MEMORY_RANGE;
enum VK_STRUCTURE_TYPE_BIND_SPARSE_INFO                                             = VkStructureType.VK_STRUCTURE_TYPE_BIND_SPARSE_INFO;
enum VK_STRUCTURE_TYPE_FENCE_CREATE_INFO                                            = VkStructureType.VK_STRUCTURE_TYPE_FENCE_CREATE_INFO;
enum VK_STRUCTURE_TYPE_SEMAPHORE_CREATE_INFO                                        = VkStructureType.VK_STRUCTURE_TYPE_SEMAPHORE_CREATE_INFO;
enum VK_STRUCTURE_TYPE_EVENT_CREATE_INFO                                            = VkStructureType.VK_STRUCTURE_TYPE_EVENT_CREATE_INFO;
enum VK_STRUCTURE_TYPE_QUERY_POOL_CREATE_INFO                                       = VkStructureType.VK_STRUCTURE_TYPE_QUERY_POOL_CREATE_INFO;
enum VK_STRUCTURE_TYPE_BUFFER_CREATE_INFO                                           = VkStructureType.VK_STRUCTURE_TYPE_BUFFER_CREATE_INFO;
enum VK_STRUCTURE_TYPE_BUFFER_VIEW_CREATE_INFO                                      = VkStructureType.VK_STRUCTURE_TYPE_BUFFER_VIEW_CREATE_INFO;
enum VK_STRUCTURE_TYPE_IMAGE_CREATE_INFO                                            = VkStructureType.VK_STRUCTURE_TYPE_IMAGE_CREATE_INFO;
enum VK_STRUCTURE_TYPE_IMAGE_VIEW_CREATE_INFO                                       = VkStructureType.VK_STRUCTURE_TYPE_IMAGE_VIEW_CREATE_INFO;
enum VK_STRUCTURE_TYPE_SHADER_MODULE_CREATE_INFO                                    = VkStructureType.VK_STRUCTURE_TYPE_SHADER_MODULE_CREATE_INFO;
enum VK_STRUCTURE_TYPE_PIPELINE_CACHE_CREATE_INFO                                   = VkStructureType.VK_STRUCTURE_TYPE_PIPELINE_CACHE_CREATE_INFO;
enum VK_STRUCTURE_TYPE_PIPELINE_SHADER_STAGE_CREATE_INFO                            = VkStructureType.VK_STRUCTURE_TYPE_PIPELINE_SHADER_STAGE_CREATE_INFO;
enum VK_STRUCTURE_TYPE_PIPELINE_VERTEX_INPUT_STATE_CREATE_INFO                      = VkStructureType.VK_STRUCTURE_TYPE_PIPELINE_VERTEX_INPUT_STATE_CREATE_INFO;
enum VK_STRUCTURE_TYPE_PIPELINE_INPUT_ASSEMBLY_STATE_CREATE_INFO                    = VkStructureType.VK_STRUCTURE_TYPE_PIPELINE_INPUT_ASSEMBLY_STATE_CREATE_INFO;
enum VK_STRUCTURE_TYPE_PIPELINE_TESSELLATION_STATE_CREATE_INFO                      = VkStructureType.VK_STRUCTURE_TYPE_PIPELINE_TESSELLATION_STATE_CREATE_INFO;
enum VK_STRUCTURE_TYPE_PIPELINE_VIEWPORT_STATE_CREATE_INFO                          = VkStructureType.VK_STRUCTURE_TYPE_PIPELINE_VIEWPORT_STATE_CREATE_INFO;
enum VK_STRUCTURE_TYPE_PIPELINE_RASTERIZATION_STATE_CREATE_INFO                     = VkStructureType.VK_STRUCTURE_TYPE_PIPELINE_RASTERIZATION_STATE_CREATE_INFO;
enum VK_STRUCTURE_TYPE_PIPELINE_MULTISAMPLE_STATE_CREATE_INFO                       = VkStructureType.VK_STRUCTURE_TYPE_PIPELINE_MULTISAMPLE_STATE_CREATE_INFO;
enum VK_STRUCTURE_TYPE_PIPELINE_DEPTH_STENCIL_STATE_CREATE_INFO                     = VkStructureType.VK_STRUCTURE_TYPE_PIPELINE_DEPTH_STENCIL_STATE_CREATE_INFO;
enum VK_STRUCTURE_TYPE_PIPELINE_COLOR_BLEND_STATE_CREATE_INFO                       = VkStructureType.VK_STRUCTURE_TYPE_PIPELINE_COLOR_BLEND_STATE_CREATE_INFO;
enum VK_STRUCTURE_TYPE_PIPELINE_DYNAMIC_STATE_CREATE_INFO                           = VkStructureType.VK_STRUCTURE_TYPE_PIPELINE_DYNAMIC_STATE_CREATE_INFO;
enum VK_STRUCTURE_TYPE_GRAPHICS_PIPELINE_CREATE_INFO                                = VkStructureType.VK_STRUCTURE_TYPE_GRAPHICS_PIPELINE_CREATE_INFO;
enum VK_STRUCTURE_TYPE_COMPUTE_PIPELINE_CREATE_INFO                                 = VkStructureType.VK_STRUCTURE_TYPE_COMPUTE_PIPELINE_CREATE_INFO;
enum VK_STRUCTURE_TYPE_PIPELINE_LAYOUT_CREATE_INFO                                  = VkStructureType.VK_STRUCTURE_TYPE_PIPELINE_LAYOUT_CREATE_INFO;
enum VK_STRUCTURE_TYPE_SAMPLER_CREATE_INFO                                          = VkStructureType.VK_STRUCTURE_TYPE_SAMPLER_CREATE_INFO;
enum VK_STRUCTURE_TYPE_DESCRIPTOR_SET_LAYOUT_CREATE_INFO                            = VkStructureType.VK_STRUCTURE_TYPE_DESCRIPTOR_SET_LAYOUT_CREATE_INFO;
enum VK_STRUCTURE_TYPE_DESCRIPTOR_POOL_CREATE_INFO                                  = VkStructureType.VK_STRUCTURE_TYPE_DESCRIPTOR_POOL_CREATE_INFO;
enum VK_STRUCTURE_TYPE_DESCRIPTOR_SET_ALLOCATE_INFO                                 = VkStructureType.VK_STRUCTURE_TYPE_DESCRIPTOR_SET_ALLOCATE_INFO;
enum VK_STRUCTURE_TYPE_WRITE_DESCRIPTOR_SET                                         = VkStructureType.VK_STRUCTURE_TYPE_WRITE_DESCRIPTOR_SET;
enum VK_STRUCTURE_TYPE_COPY_DESCRIPTOR_SET                                          = VkStructureType.VK_STRUCTURE_TYPE_COPY_DESCRIPTOR_SET;
enum VK_STRUCTURE_TYPE_FRAMEBUFFER_CREATE_INFO                                      = VkStructureType.VK_STRUCTURE_TYPE_FRAMEBUFFER_CREATE_INFO;
enum VK_STRUCTURE_TYPE_RENDER_PASS_CREATE_INFO                                      = VkStructureType.VK_STRUCTURE_TYPE_RENDER_PASS_CREATE_INFO;
enum VK_STRUCTURE_TYPE_COMMAND_POOL_CREATE_INFO                                     = VkStructureType.VK_STRUCTURE_TYPE_COMMAND_POOL_CREATE_INFO;
enum VK_STRUCTURE_TYPE_COMMAND_BUFFER_ALLOCATE_INFO                                 = VkStructureType.VK_STRUCTURE_TYPE_COMMAND_BUFFER_ALLOCATE_INFO;
enum VK_STRUCTURE_TYPE_COMMAND_BUFFER_INHERITANCE_INFO                              = VkStructureType.VK_STRUCTURE_TYPE_COMMAND_BUFFER_INHERITANCE_INFO;
enum VK_STRUCTURE_TYPE_COMMAND_BUFFER_BEGIN_INFO                                    = VkStructureType.VK_STRUCTURE_TYPE_COMMAND_BUFFER_BEGIN_INFO;
enum VK_STRUCTURE_TYPE_RENDER_PASS_BEGIN_INFO                                       = VkStructureType.VK_STRUCTURE_TYPE_RENDER_PASS_BEGIN_INFO;
enum VK_STRUCTURE_TYPE_BUFFER_MEMORY_BARRIER                                        = VkStructureType.VK_STRUCTURE_TYPE_BUFFER_MEMORY_BARRIER;
enum VK_STRUCTURE_TYPE_IMAGE_MEMORY_BARRIER                                         = VkStructureType.VK_STRUCTURE_TYPE_IMAGE_MEMORY_BARRIER;
enum VK_STRUCTURE_TYPE_MEMORY_BARRIER                                               = VkStructureType.VK_STRUCTURE_TYPE_MEMORY_BARRIER;
enum VK_STRUCTURE_TYPE_LOADER_INSTANCE_CREATE_INFO                                  = VkStructureType.VK_STRUCTURE_TYPE_LOADER_INSTANCE_CREATE_INFO;
enum VK_STRUCTURE_TYPE_LOADER_DEVICE_CREATE_INFO                                    = VkStructureType.VK_STRUCTURE_TYPE_LOADER_DEVICE_CREATE_INFO;
enum VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SUBGROUP_PROPERTIES                          = VkStructureType.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SUBGROUP_PROPERTIES;
enum VK_STRUCTURE_TYPE_BIND_BUFFER_MEMORY_INFO                                      = VkStructureType.VK_STRUCTURE_TYPE_BIND_BUFFER_MEMORY_INFO;
enum VK_STRUCTURE_TYPE_BIND_IMAGE_MEMORY_INFO                                       = VkStructureType.VK_STRUCTURE_TYPE_BIND_IMAGE_MEMORY_INFO;
enum VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_16BIT_STORAGE_FEATURES                       = VkStructureType.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_16BIT_STORAGE_FEATURES;
enum VK_STRUCTURE_TYPE_MEMORY_DEDICATED_REQUIREMENTS                                = VkStructureType.VK_STRUCTURE_TYPE_MEMORY_DEDICATED_REQUIREMENTS;
enum VK_STRUCTURE_TYPE_MEMORY_DEDICATED_ALLOCATE_INFO                               = VkStructureType.VK_STRUCTURE_TYPE_MEMORY_DEDICATED_ALLOCATE_INFO;
enum VK_STRUCTURE_TYPE_MEMORY_ALLOCATE_FLAGS_INFO                                   = VkStructureType.VK_STRUCTURE_TYPE_MEMORY_ALLOCATE_FLAGS_INFO;
enum VK_STRUCTURE_TYPE_DEVICE_GROUP_RENDER_PASS_BEGIN_INFO                          = VkStructureType.VK_STRUCTURE_TYPE_DEVICE_GROUP_RENDER_PASS_BEGIN_INFO;
enum VK_STRUCTURE_TYPE_DEVICE_GROUP_COMMAND_BUFFER_BEGIN_INFO                       = VkStructureType.VK_STRUCTURE_TYPE_DEVICE_GROUP_COMMAND_BUFFER_BEGIN_INFO;
enum VK_STRUCTURE_TYPE_DEVICE_GROUP_SUBMIT_INFO                                     = VkStructureType.VK_STRUCTURE_TYPE_DEVICE_GROUP_SUBMIT_INFO;
enum VK_STRUCTURE_TYPE_DEVICE_GROUP_BIND_SPARSE_INFO                                = VkStructureType.VK_STRUCTURE_TYPE_DEVICE_GROUP_BIND_SPARSE_INFO;
enum VK_STRUCTURE_TYPE_BIND_BUFFER_MEMORY_DEVICE_GROUP_INFO                         = VkStructureType.VK_STRUCTURE_TYPE_BIND_BUFFER_MEMORY_DEVICE_GROUP_INFO;
enum VK_STRUCTURE_TYPE_BIND_IMAGE_MEMORY_DEVICE_GROUP_INFO                          = VkStructureType.VK_STRUCTURE_TYPE_BIND_IMAGE_MEMORY_DEVICE_GROUP_INFO;
enum VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_GROUP_PROPERTIES                             = VkStructureType.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_GROUP_PROPERTIES;
enum VK_STRUCTURE_TYPE_DEVICE_GROUP_DEVICE_CREATE_INFO                              = VkStructureType.VK_STRUCTURE_TYPE_DEVICE_GROUP_DEVICE_CREATE_INFO;
enum VK_STRUCTURE_TYPE_BUFFER_MEMORY_REQUIREMENTS_INFO_2                            = VkStructureType.VK_STRUCTURE_TYPE_BUFFER_MEMORY_REQUIREMENTS_INFO_2;
enum VK_STRUCTURE_TYPE_IMAGE_MEMORY_REQUIREMENTS_INFO_2                             = VkStructureType.VK_STRUCTURE_TYPE_IMAGE_MEMORY_REQUIREMENTS_INFO_2;
enum VK_STRUCTURE_TYPE_IMAGE_SPARSE_MEMORY_REQUIREMENTS_INFO_2                      = VkStructureType.VK_STRUCTURE_TYPE_IMAGE_SPARSE_MEMORY_REQUIREMENTS_INFO_2;
enum VK_STRUCTURE_TYPE_MEMORY_REQUIREMENTS_2                                        = VkStructureType.VK_STRUCTURE_TYPE_MEMORY_REQUIREMENTS_2;
enum VK_STRUCTURE_TYPE_SPARSE_IMAGE_MEMORY_REQUIREMENTS_2                           = VkStructureType.VK_STRUCTURE_TYPE_SPARSE_IMAGE_MEMORY_REQUIREMENTS_2;
enum VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_FEATURES_2                                   = VkStructureType.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_FEATURES_2;
enum VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PROPERTIES_2                                 = VkStructureType.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PROPERTIES_2;
enum VK_STRUCTURE_TYPE_FORMAT_PROPERTIES_2                                          = VkStructureType.VK_STRUCTURE_TYPE_FORMAT_PROPERTIES_2;
enum VK_STRUCTURE_TYPE_IMAGE_FORMAT_PROPERTIES_2                                    = VkStructureType.VK_STRUCTURE_TYPE_IMAGE_FORMAT_PROPERTIES_2;
enum VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_IMAGE_FORMAT_INFO_2                          = VkStructureType.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_IMAGE_FORMAT_INFO_2;
enum VK_STRUCTURE_TYPE_QUEUE_FAMILY_PROPERTIES_2                                    = VkStructureType.VK_STRUCTURE_TYPE_QUEUE_FAMILY_PROPERTIES_2;
enum VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MEMORY_PROPERTIES_2                          = VkStructureType.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MEMORY_PROPERTIES_2;
enum VK_STRUCTURE_TYPE_SPARSE_IMAGE_FORMAT_PROPERTIES_2                             = VkStructureType.VK_STRUCTURE_TYPE_SPARSE_IMAGE_FORMAT_PROPERTIES_2;
enum VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SPARSE_IMAGE_FORMAT_INFO_2                   = VkStructureType.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SPARSE_IMAGE_FORMAT_INFO_2;
enum VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_POINT_CLIPPING_PROPERTIES                    = VkStructureType.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_POINT_CLIPPING_PROPERTIES;
enum VK_STRUCTURE_TYPE_RENDER_PASS_INPUT_ATTACHMENT_ASPECT_CREATE_INFO              = VkStructureType.VK_STRUCTURE_TYPE_RENDER_PASS_INPUT_ATTACHMENT_ASPECT_CREATE_INFO;
enum VK_STRUCTURE_TYPE_IMAGE_VIEW_USAGE_CREATE_INFO                                 = VkStructureType.VK_STRUCTURE_TYPE_IMAGE_VIEW_USAGE_CREATE_INFO;
enum VK_STRUCTURE_TYPE_PIPELINE_TESSELLATION_DOMAIN_ORIGIN_STATE_CREATE_INFO        = VkStructureType.VK_STRUCTURE_TYPE_PIPELINE_TESSELLATION_DOMAIN_ORIGIN_STATE_CREATE_INFO;
enum VK_STRUCTURE_TYPE_RENDER_PASS_MULTIVIEW_CREATE_INFO                            = VkStructureType.VK_STRUCTURE_TYPE_RENDER_PASS_MULTIVIEW_CREATE_INFO;
enum VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MULTIVIEW_FEATURES                           = VkStructureType.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MULTIVIEW_FEATURES;
enum VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MULTIVIEW_PROPERTIES                         = VkStructureType.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MULTIVIEW_PROPERTIES;
enum VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_VARIABLE_POINTER_FEATURES                    = VkStructureType.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_VARIABLE_POINTER_FEATURES;
enum VK_STRUCTURE_TYPE_PROTECTED_SUBMIT_INFO                                        = VkStructureType.VK_STRUCTURE_TYPE_PROTECTED_SUBMIT_INFO;
enum VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PROTECTED_MEMORY_FEATURES                    = VkStructureType.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PROTECTED_MEMORY_FEATURES;
enum VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PROTECTED_MEMORY_PROPERTIES                  = VkStructureType.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PROTECTED_MEMORY_PROPERTIES;
enum VK_STRUCTURE_TYPE_DEVICE_QUEUE_INFO_2                                          = VkStructureType.VK_STRUCTURE_TYPE_DEVICE_QUEUE_INFO_2;
enum VK_STRUCTURE_TYPE_SAMPLER_YCBCR_CONVERSION_CREATE_INFO                         = VkStructureType.VK_STRUCTURE_TYPE_SAMPLER_YCBCR_CONVERSION_CREATE_INFO;
enum VK_STRUCTURE_TYPE_SAMPLER_YCBCR_CONVERSION_INFO                                = VkStructureType.VK_STRUCTURE_TYPE_SAMPLER_YCBCR_CONVERSION_INFO;
enum VK_STRUCTURE_TYPE_BIND_IMAGE_PLANE_MEMORY_INFO                                 = VkStructureType.VK_STRUCTURE_TYPE_BIND_IMAGE_PLANE_MEMORY_INFO;
enum VK_STRUCTURE_TYPE_IMAGE_PLANE_MEMORY_REQUIREMENTS_INFO                         = VkStructureType.VK_STRUCTURE_TYPE_IMAGE_PLANE_MEMORY_REQUIREMENTS_INFO;
enum VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SAMPLER_YCBCR_CONVERSION_FEATURES            = VkStructureType.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SAMPLER_YCBCR_CONVERSION_FEATURES;
enum VK_STRUCTURE_TYPE_SAMPLER_YCBCR_CONVERSION_IMAGE_FORMAT_PROPERTIES             = VkStructureType.VK_STRUCTURE_TYPE_SAMPLER_YCBCR_CONVERSION_IMAGE_FORMAT_PROPERTIES;
enum VK_STRUCTURE_TYPE_DESCRIPTOR_UPDATE_TEMPLATE_CREATE_INFO                       = VkStructureType.VK_STRUCTURE_TYPE_DESCRIPTOR_UPDATE_TEMPLATE_CREATE_INFO;
enum VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_EXTERNAL_IMAGE_FORMAT_INFO                   = VkStructureType.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_EXTERNAL_IMAGE_FORMAT_INFO;
enum VK_STRUCTURE_TYPE_EXTERNAL_IMAGE_FORMAT_PROPERTIES                             = VkStructureType.VK_STRUCTURE_TYPE_EXTERNAL_IMAGE_FORMAT_PROPERTIES;
enum VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_EXTERNAL_BUFFER_INFO                         = VkStructureType.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_EXTERNAL_BUFFER_INFO;
enum VK_STRUCTURE_TYPE_EXTERNAL_BUFFER_PROPERTIES                                   = VkStructureType.VK_STRUCTURE_TYPE_EXTERNAL_BUFFER_PROPERTIES;
enum VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_ID_PROPERTIES                                = VkStructureType.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_ID_PROPERTIES;
enum VK_STRUCTURE_TYPE_EXTERNAL_MEMORY_BUFFER_CREATE_INFO                           = VkStructureType.VK_STRUCTURE_TYPE_EXTERNAL_MEMORY_BUFFER_CREATE_INFO;
enum VK_STRUCTURE_TYPE_EXTERNAL_MEMORY_IMAGE_CREATE_INFO                            = VkStructureType.VK_STRUCTURE_TYPE_EXTERNAL_MEMORY_IMAGE_CREATE_INFO;
enum VK_STRUCTURE_TYPE_EXPORT_MEMORY_ALLOCATE_INFO                                  = VkStructureType.VK_STRUCTURE_TYPE_EXPORT_MEMORY_ALLOCATE_INFO;
enum VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_EXTERNAL_FENCE_INFO                          = VkStructureType.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_EXTERNAL_FENCE_INFO;
enum VK_STRUCTURE_TYPE_EXTERNAL_FENCE_PROPERTIES                                    = VkStructureType.VK_STRUCTURE_TYPE_EXTERNAL_FENCE_PROPERTIES;
enum VK_STRUCTURE_TYPE_EXPORT_FENCE_CREATE_INFO                                     = VkStructureType.VK_STRUCTURE_TYPE_EXPORT_FENCE_CREATE_INFO;
enum VK_STRUCTURE_TYPE_EXPORT_SEMAPHORE_CREATE_INFO                                 = VkStructureType.VK_STRUCTURE_TYPE_EXPORT_SEMAPHORE_CREATE_INFO;
enum VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_EXTERNAL_SEMAPHORE_INFO                      = VkStructureType.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_EXTERNAL_SEMAPHORE_INFO;
enum VK_STRUCTURE_TYPE_EXTERNAL_SEMAPHORE_PROPERTIES                                = VkStructureType.VK_STRUCTURE_TYPE_EXTERNAL_SEMAPHORE_PROPERTIES;
enum VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MAINTENANCE_3_PROPERTIES                     = VkStructureType.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MAINTENANCE_3_PROPERTIES;
enum VK_STRUCTURE_TYPE_DESCRIPTOR_SET_LAYOUT_SUPPORT                                = VkStructureType.VK_STRUCTURE_TYPE_DESCRIPTOR_SET_LAYOUT_SUPPORT;
enum VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADER_DRAW_PARAMETER_FEATURES               = VkStructureType.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADER_DRAW_PARAMETER_FEATURES;
enum VK_STRUCTURE_TYPE_SWAPCHAIN_CREATE_INFO_KHR                                    = VkStructureType.VK_STRUCTURE_TYPE_SWAPCHAIN_CREATE_INFO_KHR;
enum VK_STRUCTURE_TYPE_PRESENT_INFO_KHR                                             = VkStructureType.VK_STRUCTURE_TYPE_PRESENT_INFO_KHR;
enum VK_STRUCTURE_TYPE_DEVICE_GROUP_PRESENT_CAPABILITIES_KHR                        = VkStructureType.VK_STRUCTURE_TYPE_DEVICE_GROUP_PRESENT_CAPABILITIES_KHR;
enum VK_STRUCTURE_TYPE_IMAGE_SWAPCHAIN_CREATE_INFO_KHR                              = VkStructureType.VK_STRUCTURE_TYPE_IMAGE_SWAPCHAIN_CREATE_INFO_KHR;
enum VK_STRUCTURE_TYPE_BIND_IMAGE_MEMORY_SWAPCHAIN_INFO_KHR                         = VkStructureType.VK_STRUCTURE_TYPE_BIND_IMAGE_MEMORY_SWAPCHAIN_INFO_KHR;
enum VK_STRUCTURE_TYPE_ACQUIRE_NEXT_IMAGE_INFO_KHR                                  = VkStructureType.VK_STRUCTURE_TYPE_ACQUIRE_NEXT_IMAGE_INFO_KHR;
enum VK_STRUCTURE_TYPE_DEVICE_GROUP_PRESENT_INFO_KHR                                = VkStructureType.VK_STRUCTURE_TYPE_DEVICE_GROUP_PRESENT_INFO_KHR;
enum VK_STRUCTURE_TYPE_DEVICE_GROUP_SWAPCHAIN_CREATE_INFO_KHR                       = VkStructureType.VK_STRUCTURE_TYPE_DEVICE_GROUP_SWAPCHAIN_CREATE_INFO_KHR;
enum VK_STRUCTURE_TYPE_DISPLAY_MODE_CREATE_INFO_KHR                                 = VkStructureType.VK_STRUCTURE_TYPE_DISPLAY_MODE_CREATE_INFO_KHR;
enum VK_STRUCTURE_TYPE_DISPLAY_SURFACE_CREATE_INFO_KHR                              = VkStructureType.VK_STRUCTURE_TYPE_DISPLAY_SURFACE_CREATE_INFO_KHR;
enum VK_STRUCTURE_TYPE_DISPLAY_PRESENT_INFO_KHR                                     = VkStructureType.VK_STRUCTURE_TYPE_DISPLAY_PRESENT_INFO_KHR;
enum VK_STRUCTURE_TYPE_XLIB_SURFACE_CREATE_INFO_KHR                                 = VkStructureType.VK_STRUCTURE_TYPE_XLIB_SURFACE_CREATE_INFO_KHR;
enum VK_STRUCTURE_TYPE_XCB_SURFACE_CREATE_INFO_KHR                                  = VkStructureType.VK_STRUCTURE_TYPE_XCB_SURFACE_CREATE_INFO_KHR;
enum VK_STRUCTURE_TYPE_WAYLAND_SURFACE_CREATE_INFO_KHR                              = VkStructureType.VK_STRUCTURE_TYPE_WAYLAND_SURFACE_CREATE_INFO_KHR;
enum VK_STRUCTURE_TYPE_ANDROID_SURFACE_CREATE_INFO_KHR                              = VkStructureType.VK_STRUCTURE_TYPE_ANDROID_SURFACE_CREATE_INFO_KHR;
enum VK_STRUCTURE_TYPE_WIN32_SURFACE_CREATE_INFO_KHR                                = VkStructureType.VK_STRUCTURE_TYPE_WIN32_SURFACE_CREATE_INFO_KHR;
enum VK_STRUCTURE_TYPE_NATIVE_BUFFER_ANDROID                                        = VkStructureType.VK_STRUCTURE_TYPE_NATIVE_BUFFER_ANDROID;
enum VK_STRUCTURE_TYPE_DEBUG_REPORT_CALLBACK_CREATE_INFO_EXT                        = VkStructureType.VK_STRUCTURE_TYPE_DEBUG_REPORT_CALLBACK_CREATE_INFO_EXT;
enum VK_STRUCTURE_TYPE_DEBUG_REPORT_CREATE_INFO_EXT                                 = VkStructureType.VK_STRUCTURE_TYPE_DEBUG_REPORT_CREATE_INFO_EXT;
enum VK_STRUCTURE_TYPE_PIPELINE_RASTERIZATION_STATE_RASTERIZATION_ORDER_AMD         = VkStructureType.VK_STRUCTURE_TYPE_PIPELINE_RASTERIZATION_STATE_RASTERIZATION_ORDER_AMD;
enum VK_STRUCTURE_TYPE_DEBUG_MARKER_OBJECT_NAME_INFO_EXT                            = VkStructureType.VK_STRUCTURE_TYPE_DEBUG_MARKER_OBJECT_NAME_INFO_EXT;
enum VK_STRUCTURE_TYPE_DEBUG_MARKER_OBJECT_TAG_INFO_EXT                             = VkStructureType.VK_STRUCTURE_TYPE_DEBUG_MARKER_OBJECT_TAG_INFO_EXT;
enum VK_STRUCTURE_TYPE_DEBUG_MARKER_MARKER_INFO_EXT                                 = VkStructureType.VK_STRUCTURE_TYPE_DEBUG_MARKER_MARKER_INFO_EXT;
enum VK_STRUCTURE_TYPE_DEDICATED_ALLOCATION_IMAGE_CREATE_INFO_NV                    = VkStructureType.VK_STRUCTURE_TYPE_DEDICATED_ALLOCATION_IMAGE_CREATE_INFO_NV;
enum VK_STRUCTURE_TYPE_DEDICATED_ALLOCATION_BUFFER_CREATE_INFO_NV                   = VkStructureType.VK_STRUCTURE_TYPE_DEDICATED_ALLOCATION_BUFFER_CREATE_INFO_NV;
enum VK_STRUCTURE_TYPE_DEDICATED_ALLOCATION_MEMORY_ALLOCATE_INFO_NV                 = VkStructureType.VK_STRUCTURE_TYPE_DEDICATED_ALLOCATION_MEMORY_ALLOCATE_INFO_NV;
enum VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_TRANSFORM_FEEDBACK_FEATURES_EXT              = VkStructureType.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_TRANSFORM_FEEDBACK_FEATURES_EXT;
enum VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_TRANSFORM_FEEDBACK_PROPERTIES_EXT            = VkStructureType.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_TRANSFORM_FEEDBACK_PROPERTIES_EXT;
enum VK_STRUCTURE_TYPE_PIPELINE_RASTERIZATION_STATE_STREAM_CREATE_INFO_EXT          = VkStructureType.VK_STRUCTURE_TYPE_PIPELINE_RASTERIZATION_STATE_STREAM_CREATE_INFO_EXT;
enum VK_STRUCTURE_TYPE_TEXTURE_LOD_GATHER_FORMAT_PROPERTIES_AMD                     = VkStructureType.VK_STRUCTURE_TYPE_TEXTURE_LOD_GATHER_FORMAT_PROPERTIES_AMD;
enum VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_CORNER_SAMPLED_IMAGE_FEATURES_NV             = VkStructureType.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_CORNER_SAMPLED_IMAGE_FEATURES_NV;
enum VK_STRUCTURE_TYPE_RENDER_PASS_MULTIVIEW_CREATE_INFO_KHR                        = VkStructureType.VK_STRUCTURE_TYPE_RENDER_PASS_MULTIVIEW_CREATE_INFO_KHR;
enum VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MULTIVIEW_FEATURES_KHR                       = VkStructureType.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MULTIVIEW_FEATURES_KHR;
enum VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MULTIVIEW_PROPERTIES_KHR                     = VkStructureType.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MULTIVIEW_PROPERTIES_KHR;
enum VK_STRUCTURE_TYPE_EXTERNAL_MEMORY_IMAGE_CREATE_INFO_NV                         = VkStructureType.VK_STRUCTURE_TYPE_EXTERNAL_MEMORY_IMAGE_CREATE_INFO_NV;
enum VK_STRUCTURE_TYPE_EXPORT_MEMORY_ALLOCATE_INFO_NV                               = VkStructureType.VK_STRUCTURE_TYPE_EXPORT_MEMORY_ALLOCATE_INFO_NV;
enum VK_STRUCTURE_TYPE_IMPORT_MEMORY_WIN32_HANDLE_INFO_NV                           = VkStructureType.VK_STRUCTURE_TYPE_IMPORT_MEMORY_WIN32_HANDLE_INFO_NV;
enum VK_STRUCTURE_TYPE_EXPORT_MEMORY_WIN32_HANDLE_INFO_NV                           = VkStructureType.VK_STRUCTURE_TYPE_EXPORT_MEMORY_WIN32_HANDLE_INFO_NV;
enum VK_STRUCTURE_TYPE_WIN32_KEYED_MUTEX_ACQUIRE_RELEASE_INFO_NV                    = VkStructureType.VK_STRUCTURE_TYPE_WIN32_KEYED_MUTEX_ACQUIRE_RELEASE_INFO_NV;
enum VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_FEATURES_2_KHR                               = VkStructureType.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_FEATURES_2_KHR;
enum VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PROPERTIES_2_KHR                             = VkStructureType.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PROPERTIES_2_KHR;
enum VK_STRUCTURE_TYPE_FORMAT_PROPERTIES_2_KHR                                      = VkStructureType.VK_STRUCTURE_TYPE_FORMAT_PROPERTIES_2_KHR;
enum VK_STRUCTURE_TYPE_IMAGE_FORMAT_PROPERTIES_2_KHR                                = VkStructureType.VK_STRUCTURE_TYPE_IMAGE_FORMAT_PROPERTIES_2_KHR;
enum VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_IMAGE_FORMAT_INFO_2_KHR                      = VkStructureType.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_IMAGE_FORMAT_INFO_2_KHR;
enum VK_STRUCTURE_TYPE_QUEUE_FAMILY_PROPERTIES_2_KHR                                = VkStructureType.VK_STRUCTURE_TYPE_QUEUE_FAMILY_PROPERTIES_2_KHR;
enum VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MEMORY_PROPERTIES_2_KHR                      = VkStructureType.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MEMORY_PROPERTIES_2_KHR;
enum VK_STRUCTURE_TYPE_SPARSE_IMAGE_FORMAT_PROPERTIES_2_KHR                         = VkStructureType.VK_STRUCTURE_TYPE_SPARSE_IMAGE_FORMAT_PROPERTIES_2_KHR;
enum VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SPARSE_IMAGE_FORMAT_INFO_2_KHR               = VkStructureType.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SPARSE_IMAGE_FORMAT_INFO_2_KHR;
enum VK_STRUCTURE_TYPE_MEMORY_ALLOCATE_FLAGS_INFO_KHR                               = VkStructureType.VK_STRUCTURE_TYPE_MEMORY_ALLOCATE_FLAGS_INFO_KHR;
enum VK_STRUCTURE_TYPE_DEVICE_GROUP_RENDER_PASS_BEGIN_INFO_KHR                      = VkStructureType.VK_STRUCTURE_TYPE_DEVICE_GROUP_RENDER_PASS_BEGIN_INFO_KHR;
enum VK_STRUCTURE_TYPE_DEVICE_GROUP_COMMAND_BUFFER_BEGIN_INFO_KHR                   = VkStructureType.VK_STRUCTURE_TYPE_DEVICE_GROUP_COMMAND_BUFFER_BEGIN_INFO_KHR;
enum VK_STRUCTURE_TYPE_DEVICE_GROUP_SUBMIT_INFO_KHR                                 = VkStructureType.VK_STRUCTURE_TYPE_DEVICE_GROUP_SUBMIT_INFO_KHR;
enum VK_STRUCTURE_TYPE_DEVICE_GROUP_BIND_SPARSE_INFO_KHR                            = VkStructureType.VK_STRUCTURE_TYPE_DEVICE_GROUP_BIND_SPARSE_INFO_KHR;
enum VK_STRUCTURE_TYPE_BIND_BUFFER_MEMORY_DEVICE_GROUP_INFO_KHR                     = VkStructureType.VK_STRUCTURE_TYPE_BIND_BUFFER_MEMORY_DEVICE_GROUP_INFO_KHR;
enum VK_STRUCTURE_TYPE_BIND_IMAGE_MEMORY_DEVICE_GROUP_INFO_KHR                      = VkStructureType.VK_STRUCTURE_TYPE_BIND_IMAGE_MEMORY_DEVICE_GROUP_INFO_KHR;
enum VK_STRUCTURE_TYPE_VALIDATION_FLAGS_EXT                                         = VkStructureType.VK_STRUCTURE_TYPE_VALIDATION_FLAGS_EXT;
enum VK_STRUCTURE_TYPE_VI_SURFACE_CREATE_INFO_NN                                    = VkStructureType.VK_STRUCTURE_TYPE_VI_SURFACE_CREATE_INFO_NN;
enum VK_STRUCTURE_TYPE_IMAGE_VIEW_ASTC_DECODE_MODE_EXT                              = VkStructureType.VK_STRUCTURE_TYPE_IMAGE_VIEW_ASTC_DECODE_MODE_EXT;
enum VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_ASTC_DECODE_FEATURES_EXT                     = VkStructureType.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_ASTC_DECODE_FEATURES_EXT;
enum VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_GROUP_PROPERTIES_KHR                         = VkStructureType.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_GROUP_PROPERTIES_KHR;
enum VK_STRUCTURE_TYPE_DEVICE_GROUP_DEVICE_CREATE_INFO_KHR                          = VkStructureType.VK_STRUCTURE_TYPE_DEVICE_GROUP_DEVICE_CREATE_INFO_KHR;
enum VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_EXTERNAL_IMAGE_FORMAT_INFO_KHR               = VkStructureType.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_EXTERNAL_IMAGE_FORMAT_INFO_KHR;
enum VK_STRUCTURE_TYPE_EXTERNAL_IMAGE_FORMAT_PROPERTIES_KHR                         = VkStructureType.VK_STRUCTURE_TYPE_EXTERNAL_IMAGE_FORMAT_PROPERTIES_KHR;
enum VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_EXTERNAL_BUFFER_INFO_KHR                     = VkStructureType.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_EXTERNAL_BUFFER_INFO_KHR;
enum VK_STRUCTURE_TYPE_EXTERNAL_BUFFER_PROPERTIES_KHR                               = VkStructureType.VK_STRUCTURE_TYPE_EXTERNAL_BUFFER_PROPERTIES_KHR;
enum VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_ID_PROPERTIES_KHR                            = VkStructureType.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_ID_PROPERTIES_KHR;
enum VK_STRUCTURE_TYPE_EXTERNAL_MEMORY_BUFFER_CREATE_INFO_KHR                       = VkStructureType.VK_STRUCTURE_TYPE_EXTERNAL_MEMORY_BUFFER_CREATE_INFO_KHR;
enum VK_STRUCTURE_TYPE_EXTERNAL_MEMORY_IMAGE_CREATE_INFO_KHR                        = VkStructureType.VK_STRUCTURE_TYPE_EXTERNAL_MEMORY_IMAGE_CREATE_INFO_KHR;
enum VK_STRUCTURE_TYPE_EXPORT_MEMORY_ALLOCATE_INFO_KHR                              = VkStructureType.VK_STRUCTURE_TYPE_EXPORT_MEMORY_ALLOCATE_INFO_KHR;
enum VK_STRUCTURE_TYPE_IMPORT_MEMORY_WIN32_HANDLE_INFO_KHR                          = VkStructureType.VK_STRUCTURE_TYPE_IMPORT_MEMORY_WIN32_HANDLE_INFO_KHR;
enum VK_STRUCTURE_TYPE_EXPORT_MEMORY_WIN32_HANDLE_INFO_KHR                          = VkStructureType.VK_STRUCTURE_TYPE_EXPORT_MEMORY_WIN32_HANDLE_INFO_KHR;
enum VK_STRUCTURE_TYPE_MEMORY_WIN32_HANDLE_PROPERTIES_KHR                           = VkStructureType.VK_STRUCTURE_TYPE_MEMORY_WIN32_HANDLE_PROPERTIES_KHR;
enum VK_STRUCTURE_TYPE_MEMORY_GET_WIN32_HANDLE_INFO_KHR                             = VkStructureType.VK_STRUCTURE_TYPE_MEMORY_GET_WIN32_HANDLE_INFO_KHR;
enum VK_STRUCTURE_TYPE_IMPORT_MEMORY_FD_INFO_KHR                                    = VkStructureType.VK_STRUCTURE_TYPE_IMPORT_MEMORY_FD_INFO_KHR;
enum VK_STRUCTURE_TYPE_MEMORY_FD_PROPERTIES_KHR                                     = VkStructureType.VK_STRUCTURE_TYPE_MEMORY_FD_PROPERTIES_KHR;
enum VK_STRUCTURE_TYPE_MEMORY_GET_FD_INFO_KHR                                       = VkStructureType.VK_STRUCTURE_TYPE_MEMORY_GET_FD_INFO_KHR;
enum VK_STRUCTURE_TYPE_WIN32_KEYED_MUTEX_ACQUIRE_RELEASE_INFO_KHR                   = VkStructureType.VK_STRUCTURE_TYPE_WIN32_KEYED_MUTEX_ACQUIRE_RELEASE_INFO_KHR;
enum VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_EXTERNAL_SEMAPHORE_INFO_KHR                  = VkStructureType.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_EXTERNAL_SEMAPHORE_INFO_KHR;
enum VK_STRUCTURE_TYPE_EXTERNAL_SEMAPHORE_PROPERTIES_KHR                            = VkStructureType.VK_STRUCTURE_TYPE_EXTERNAL_SEMAPHORE_PROPERTIES_KHR;
enum VK_STRUCTURE_TYPE_EXPORT_SEMAPHORE_CREATE_INFO_KHR                             = VkStructureType.VK_STRUCTURE_TYPE_EXPORT_SEMAPHORE_CREATE_INFO_KHR;
enum VK_STRUCTURE_TYPE_IMPORT_SEMAPHORE_WIN32_HANDLE_INFO_KHR                       = VkStructureType.VK_STRUCTURE_TYPE_IMPORT_SEMAPHORE_WIN32_HANDLE_INFO_KHR;
enum VK_STRUCTURE_TYPE_EXPORT_SEMAPHORE_WIN32_HANDLE_INFO_KHR                       = VkStructureType.VK_STRUCTURE_TYPE_EXPORT_SEMAPHORE_WIN32_HANDLE_INFO_KHR;
enum VK_STRUCTURE_TYPE_D3D12_FENCE_SUBMIT_INFO_KHR                                  = VkStructureType.VK_STRUCTURE_TYPE_D3D12_FENCE_SUBMIT_INFO_KHR;
enum VK_STRUCTURE_TYPE_SEMAPHORE_GET_WIN32_HANDLE_INFO_KHR                          = VkStructureType.VK_STRUCTURE_TYPE_SEMAPHORE_GET_WIN32_HANDLE_INFO_KHR;
enum VK_STRUCTURE_TYPE_IMPORT_SEMAPHORE_FD_INFO_KHR                                 = VkStructureType.VK_STRUCTURE_TYPE_IMPORT_SEMAPHORE_FD_INFO_KHR;
enum VK_STRUCTURE_TYPE_SEMAPHORE_GET_FD_INFO_KHR                                    = VkStructureType.VK_STRUCTURE_TYPE_SEMAPHORE_GET_FD_INFO_KHR;
enum VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PUSH_DESCRIPTOR_PROPERTIES_KHR               = VkStructureType.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PUSH_DESCRIPTOR_PROPERTIES_KHR;
enum VK_STRUCTURE_TYPE_COMMAND_BUFFER_INHERITANCE_CONDITIONAL_RENDERING_INFO_EXT    = VkStructureType.VK_STRUCTURE_TYPE_COMMAND_BUFFER_INHERITANCE_CONDITIONAL_RENDERING_INFO_EXT;
enum VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_CONDITIONAL_RENDERING_FEATURES_EXT           = VkStructureType.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_CONDITIONAL_RENDERING_FEATURES_EXT;
enum VK_STRUCTURE_TYPE_CONDITIONAL_RENDERING_BEGIN_INFO_EXT                         = VkStructureType.VK_STRUCTURE_TYPE_CONDITIONAL_RENDERING_BEGIN_INFO_EXT;
enum VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_FLOAT16_INT8_FEATURES_KHR                    = VkStructureType.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_FLOAT16_INT8_FEATURES_KHR;
enum VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_16BIT_STORAGE_FEATURES_KHR                   = VkStructureType.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_16BIT_STORAGE_FEATURES_KHR;
enum VK_STRUCTURE_TYPE_PRESENT_REGIONS_KHR                                          = VkStructureType.VK_STRUCTURE_TYPE_PRESENT_REGIONS_KHR;
enum VK_STRUCTURE_TYPE_DESCRIPTOR_UPDATE_TEMPLATE_CREATE_INFO_KHR                   = VkStructureType.VK_STRUCTURE_TYPE_DESCRIPTOR_UPDATE_TEMPLATE_CREATE_INFO_KHR;
enum VK_STRUCTURE_TYPE_OBJECT_TABLE_CREATE_INFO_NVX                                 = VkStructureType.VK_STRUCTURE_TYPE_OBJECT_TABLE_CREATE_INFO_NVX;
enum VK_STRUCTURE_TYPE_INDIRECT_COMMANDS_LAYOUT_CREATE_INFO_NVX                     = VkStructureType.VK_STRUCTURE_TYPE_INDIRECT_COMMANDS_LAYOUT_CREATE_INFO_NVX;
enum VK_STRUCTURE_TYPE_CMD_PROCESS_COMMANDS_INFO_NVX                                = VkStructureType.VK_STRUCTURE_TYPE_CMD_PROCESS_COMMANDS_INFO_NVX;
enum VK_STRUCTURE_TYPE_CMD_RESERVE_SPACE_FOR_COMMANDS_INFO_NVX                      = VkStructureType.VK_STRUCTURE_TYPE_CMD_RESERVE_SPACE_FOR_COMMANDS_INFO_NVX;
enum VK_STRUCTURE_TYPE_DEVICE_GENERATED_COMMANDS_LIMITS_NVX                         = VkStructureType.VK_STRUCTURE_TYPE_DEVICE_GENERATED_COMMANDS_LIMITS_NVX;
enum VK_STRUCTURE_TYPE_DEVICE_GENERATED_COMMANDS_FEATURES_NVX                       = VkStructureType.VK_STRUCTURE_TYPE_DEVICE_GENERATED_COMMANDS_FEATURES_NVX;
enum VK_STRUCTURE_TYPE_PIPELINE_VIEWPORT_W_SCALING_STATE_CREATE_INFO_NV             = VkStructureType.VK_STRUCTURE_TYPE_PIPELINE_VIEWPORT_W_SCALING_STATE_CREATE_INFO_NV;
enum VK_STRUCTURE_TYPE_SURFACE_CAPABILITIES_2_EXT                                   = VkStructureType.VK_STRUCTURE_TYPE_SURFACE_CAPABILITIES_2_EXT;
enum VK_STRUCTURE_TYPE_SURFACE_CAPABILITIES2_EXT                                    = VkStructureType.VK_STRUCTURE_TYPE_SURFACE_CAPABILITIES2_EXT;
enum VK_STRUCTURE_TYPE_DISPLAY_POWER_INFO_EXT                                       = VkStructureType.VK_STRUCTURE_TYPE_DISPLAY_POWER_INFO_EXT;
enum VK_STRUCTURE_TYPE_DEVICE_EVENT_INFO_EXT                                        = VkStructureType.VK_STRUCTURE_TYPE_DEVICE_EVENT_INFO_EXT;
enum VK_STRUCTURE_TYPE_DISPLAY_EVENT_INFO_EXT                                       = VkStructureType.VK_STRUCTURE_TYPE_DISPLAY_EVENT_INFO_EXT;
enum VK_STRUCTURE_TYPE_SWAPCHAIN_COUNTER_CREATE_INFO_EXT                            = VkStructureType.VK_STRUCTURE_TYPE_SWAPCHAIN_COUNTER_CREATE_INFO_EXT;
enum VK_STRUCTURE_TYPE_PRESENT_TIMES_INFO_GOOGLE                                    = VkStructureType.VK_STRUCTURE_TYPE_PRESENT_TIMES_INFO_GOOGLE;
enum VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MULTIVIEW_PER_VIEW_ATTRIBUTES_PROPERTIES_NVX = VkStructureType.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MULTIVIEW_PER_VIEW_ATTRIBUTES_PROPERTIES_NVX;
enum VK_STRUCTURE_TYPE_PIPELINE_VIEWPORT_SWIZZLE_STATE_CREATE_INFO_NV               = VkStructureType.VK_STRUCTURE_TYPE_PIPELINE_VIEWPORT_SWIZZLE_STATE_CREATE_INFO_NV;
enum VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_DISCARD_RECTANGLE_PROPERTIES_EXT             = VkStructureType.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_DISCARD_RECTANGLE_PROPERTIES_EXT;
enum VK_STRUCTURE_TYPE_PIPELINE_DISCARD_RECTANGLE_STATE_CREATE_INFO_EXT             = VkStructureType.VK_STRUCTURE_TYPE_PIPELINE_DISCARD_RECTANGLE_STATE_CREATE_INFO_EXT;
enum VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_CONSERVATIVE_RASTERIZATION_PROPERTIES_EXT    = VkStructureType.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_CONSERVATIVE_RASTERIZATION_PROPERTIES_EXT;
enum VK_STRUCTURE_TYPE_PIPELINE_RASTERIZATION_CONSERVATIVE_STATE_CREATE_INFO_EXT    = VkStructureType.VK_STRUCTURE_TYPE_PIPELINE_RASTERIZATION_CONSERVATIVE_STATE_CREATE_INFO_EXT;
enum VK_STRUCTURE_TYPE_HDR_METADATA_EXT                                             = VkStructureType.VK_STRUCTURE_TYPE_HDR_METADATA_EXT;
enum VK_STRUCTURE_TYPE_ATTACHMENT_DESCRIPTION_2_KHR                                 = VkStructureType.VK_STRUCTURE_TYPE_ATTACHMENT_DESCRIPTION_2_KHR;
enum VK_STRUCTURE_TYPE_ATTACHMENT_REFERENCE_2_KHR                                   = VkStructureType.VK_STRUCTURE_TYPE_ATTACHMENT_REFERENCE_2_KHR;
enum VK_STRUCTURE_TYPE_SUBPASS_DESCRIPTION_2_KHR                                    = VkStructureType.VK_STRUCTURE_TYPE_SUBPASS_DESCRIPTION_2_KHR;
enum VK_STRUCTURE_TYPE_SUBPASS_DEPENDENCY_2_KHR                                     = VkStructureType.VK_STRUCTURE_TYPE_SUBPASS_DEPENDENCY_2_KHR;
enum VK_STRUCTURE_TYPE_RENDER_PASS_CREATE_INFO_2_KHR                                = VkStructureType.VK_STRUCTURE_TYPE_RENDER_PASS_CREATE_INFO_2_KHR;
enum VK_STRUCTURE_TYPE_SUBPASS_BEGIN_INFO_KHR                                       = VkStructureType.VK_STRUCTURE_TYPE_SUBPASS_BEGIN_INFO_KHR;
enum VK_STRUCTURE_TYPE_SUBPASS_END_INFO_KHR                                         = VkStructureType.VK_STRUCTURE_TYPE_SUBPASS_END_INFO_KHR;
enum VK_STRUCTURE_TYPE_SHARED_PRESENT_SURFACE_CAPABILITIES_KHR                      = VkStructureType.VK_STRUCTURE_TYPE_SHARED_PRESENT_SURFACE_CAPABILITIES_KHR;
enum VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_EXTERNAL_FENCE_INFO_KHR                      = VkStructureType.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_EXTERNAL_FENCE_INFO_KHR;
enum VK_STRUCTURE_TYPE_EXTERNAL_FENCE_PROPERTIES_KHR                                = VkStructureType.VK_STRUCTURE_TYPE_EXTERNAL_FENCE_PROPERTIES_KHR;
enum VK_STRUCTURE_TYPE_EXPORT_FENCE_CREATE_INFO_KHR                                 = VkStructureType.VK_STRUCTURE_TYPE_EXPORT_FENCE_CREATE_INFO_KHR;
enum VK_STRUCTURE_TYPE_IMPORT_FENCE_WIN32_HANDLE_INFO_KHR                           = VkStructureType.VK_STRUCTURE_TYPE_IMPORT_FENCE_WIN32_HANDLE_INFO_KHR;
enum VK_STRUCTURE_TYPE_EXPORT_FENCE_WIN32_HANDLE_INFO_KHR                           = VkStructureType.VK_STRUCTURE_TYPE_EXPORT_FENCE_WIN32_HANDLE_INFO_KHR;
enum VK_STRUCTURE_TYPE_FENCE_GET_WIN32_HANDLE_INFO_KHR                              = VkStructureType.VK_STRUCTURE_TYPE_FENCE_GET_WIN32_HANDLE_INFO_KHR;
enum VK_STRUCTURE_TYPE_IMPORT_FENCE_FD_INFO_KHR                                     = VkStructureType.VK_STRUCTURE_TYPE_IMPORT_FENCE_FD_INFO_KHR;
enum VK_STRUCTURE_TYPE_FENCE_GET_FD_INFO_KHR                                        = VkStructureType.VK_STRUCTURE_TYPE_FENCE_GET_FD_INFO_KHR;
enum VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_POINT_CLIPPING_PROPERTIES_KHR                = VkStructureType.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_POINT_CLIPPING_PROPERTIES_KHR;
enum VK_STRUCTURE_TYPE_RENDER_PASS_INPUT_ATTACHMENT_ASPECT_CREATE_INFO_KHR          = VkStructureType.VK_STRUCTURE_TYPE_RENDER_PASS_INPUT_ATTACHMENT_ASPECT_CREATE_INFO_KHR;
enum VK_STRUCTURE_TYPE_IMAGE_VIEW_USAGE_CREATE_INFO_KHR                             = VkStructureType.VK_STRUCTURE_TYPE_IMAGE_VIEW_USAGE_CREATE_INFO_KHR;
enum VK_STRUCTURE_TYPE_PIPELINE_TESSELLATION_DOMAIN_ORIGIN_STATE_CREATE_INFO_KHR    = VkStructureType.VK_STRUCTURE_TYPE_PIPELINE_TESSELLATION_DOMAIN_ORIGIN_STATE_CREATE_INFO_KHR;
enum VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SURFACE_INFO_2_KHR                           = VkStructureType.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SURFACE_INFO_2_KHR;
enum VK_STRUCTURE_TYPE_SURFACE_CAPABILITIES_2_KHR                                   = VkStructureType.VK_STRUCTURE_TYPE_SURFACE_CAPABILITIES_2_KHR;
enum VK_STRUCTURE_TYPE_SURFACE_FORMAT_2_KHR                                         = VkStructureType.VK_STRUCTURE_TYPE_SURFACE_FORMAT_2_KHR;
enum VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_VARIABLE_POINTER_FEATURES_KHR                = VkStructureType.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_VARIABLE_POINTER_FEATURES_KHR;
enum VK_STRUCTURE_TYPE_DISPLAY_PROPERTIES_2_KHR                                     = VkStructureType.VK_STRUCTURE_TYPE_DISPLAY_PROPERTIES_2_KHR;
enum VK_STRUCTURE_TYPE_DISPLAY_PLANE_PROPERTIES_2_KHR                               = VkStructureType.VK_STRUCTURE_TYPE_DISPLAY_PLANE_PROPERTIES_2_KHR;
enum VK_STRUCTURE_TYPE_DISPLAY_MODE_PROPERTIES_2_KHR                                = VkStructureType.VK_STRUCTURE_TYPE_DISPLAY_MODE_PROPERTIES_2_KHR;
enum VK_STRUCTURE_TYPE_DISPLAY_PLANE_INFO_2_KHR                                     = VkStructureType.VK_STRUCTURE_TYPE_DISPLAY_PLANE_INFO_2_KHR;
enum VK_STRUCTURE_TYPE_DISPLAY_PLANE_CAPABILITIES_2_KHR                             = VkStructureType.VK_STRUCTURE_TYPE_DISPLAY_PLANE_CAPABILITIES_2_KHR;
enum VK_STRUCTURE_TYPE_IOS_SURFACE_CREATE_INFO_MVK                                  = VkStructureType.VK_STRUCTURE_TYPE_IOS_SURFACE_CREATE_INFO_MVK;
enum VK_STRUCTURE_TYPE_MACOS_SURFACE_CREATE_INFO_MVK                                = VkStructureType.VK_STRUCTURE_TYPE_MACOS_SURFACE_CREATE_INFO_MVK;
enum VK_STRUCTURE_TYPE_MEMORY_DEDICATED_REQUIREMENTS_KHR                            = VkStructureType.VK_STRUCTURE_TYPE_MEMORY_DEDICATED_REQUIREMENTS_KHR;
enum VK_STRUCTURE_TYPE_MEMORY_DEDICATED_ALLOCATE_INFO_KHR                           = VkStructureType.VK_STRUCTURE_TYPE_MEMORY_DEDICATED_ALLOCATE_INFO_KHR;
enum VK_STRUCTURE_TYPE_DEBUG_UTILS_OBJECT_NAME_INFO_EXT                             = VkStructureType.VK_STRUCTURE_TYPE_DEBUG_UTILS_OBJECT_NAME_INFO_EXT;
enum VK_STRUCTURE_TYPE_DEBUG_UTILS_OBJECT_TAG_INFO_EXT                              = VkStructureType.VK_STRUCTURE_TYPE_DEBUG_UTILS_OBJECT_TAG_INFO_EXT;
enum VK_STRUCTURE_TYPE_DEBUG_UTILS_LABEL_EXT                                        = VkStructureType.VK_STRUCTURE_TYPE_DEBUG_UTILS_LABEL_EXT;
enum VK_STRUCTURE_TYPE_DEBUG_UTILS_MESSENGER_CALLBACK_DATA_EXT                      = VkStructureType.VK_STRUCTURE_TYPE_DEBUG_UTILS_MESSENGER_CALLBACK_DATA_EXT;
enum VK_STRUCTURE_TYPE_DEBUG_UTILS_MESSENGER_CREATE_INFO_EXT                        = VkStructureType.VK_STRUCTURE_TYPE_DEBUG_UTILS_MESSENGER_CREATE_INFO_EXT;
enum VK_STRUCTURE_TYPE_ANDROID_HARDWARE_BUFFER_USAGE_ANDROID                        = VkStructureType.VK_STRUCTURE_TYPE_ANDROID_HARDWARE_BUFFER_USAGE_ANDROID;
enum VK_STRUCTURE_TYPE_ANDROID_HARDWARE_BUFFER_PROPERTIES_ANDROID                   = VkStructureType.VK_STRUCTURE_TYPE_ANDROID_HARDWARE_BUFFER_PROPERTIES_ANDROID;
enum VK_STRUCTURE_TYPE_ANDROID_HARDWARE_BUFFER_FORMAT_PROPERTIES_ANDROID            = VkStructureType.VK_STRUCTURE_TYPE_ANDROID_HARDWARE_BUFFER_FORMAT_PROPERTIES_ANDROID;
enum VK_STRUCTURE_TYPE_IMPORT_ANDROID_HARDWARE_BUFFER_INFO_ANDROID                  = VkStructureType.VK_STRUCTURE_TYPE_IMPORT_ANDROID_HARDWARE_BUFFER_INFO_ANDROID;
enum VK_STRUCTURE_TYPE_MEMORY_GET_ANDROID_HARDWARE_BUFFER_INFO_ANDROID              = VkStructureType.VK_STRUCTURE_TYPE_MEMORY_GET_ANDROID_HARDWARE_BUFFER_INFO_ANDROID;
enum VK_STRUCTURE_TYPE_EXTERNAL_FORMAT_ANDROID                                      = VkStructureType.VK_STRUCTURE_TYPE_EXTERNAL_FORMAT_ANDROID;
enum VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SAMPLER_FILTER_MINMAX_PROPERTIES_EXT         = VkStructureType.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SAMPLER_FILTER_MINMAX_PROPERTIES_EXT;
enum VK_STRUCTURE_TYPE_SAMPLER_REDUCTION_MODE_CREATE_INFO_EXT                       = VkStructureType.VK_STRUCTURE_TYPE_SAMPLER_REDUCTION_MODE_CREATE_INFO_EXT;
enum VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_INLINE_UNIFORM_BLOCK_FEATURES_EXT            = VkStructureType.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_INLINE_UNIFORM_BLOCK_FEATURES_EXT;
enum VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_INLINE_UNIFORM_BLOCK_PROPERTIES_EXT          = VkStructureType.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_INLINE_UNIFORM_BLOCK_PROPERTIES_EXT;
enum VK_STRUCTURE_TYPE_WRITE_DESCRIPTOR_SET_INLINE_UNIFORM_BLOCK_EXT                = VkStructureType.VK_STRUCTURE_TYPE_WRITE_DESCRIPTOR_SET_INLINE_UNIFORM_BLOCK_EXT;
enum VK_STRUCTURE_TYPE_DESCRIPTOR_POOL_INLINE_UNIFORM_BLOCK_CREATE_INFO_EXT         = VkStructureType.VK_STRUCTURE_TYPE_DESCRIPTOR_POOL_INLINE_UNIFORM_BLOCK_CREATE_INFO_EXT;
enum VK_STRUCTURE_TYPE_SAMPLE_LOCATIONS_INFO_EXT                                    = VkStructureType.VK_STRUCTURE_TYPE_SAMPLE_LOCATIONS_INFO_EXT;
enum VK_STRUCTURE_TYPE_RENDER_PASS_SAMPLE_LOCATIONS_BEGIN_INFO_EXT                  = VkStructureType.VK_STRUCTURE_TYPE_RENDER_PASS_SAMPLE_LOCATIONS_BEGIN_INFO_EXT;
enum VK_STRUCTURE_TYPE_PIPELINE_SAMPLE_LOCATIONS_STATE_CREATE_INFO_EXT              = VkStructureType.VK_STRUCTURE_TYPE_PIPELINE_SAMPLE_LOCATIONS_STATE_CREATE_INFO_EXT;
enum VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SAMPLE_LOCATIONS_PROPERTIES_EXT              = VkStructureType.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SAMPLE_LOCATIONS_PROPERTIES_EXT;
enum VK_STRUCTURE_TYPE_MULTISAMPLE_PROPERTIES_EXT                                   = VkStructureType.VK_STRUCTURE_TYPE_MULTISAMPLE_PROPERTIES_EXT;
enum VK_STRUCTURE_TYPE_BUFFER_MEMORY_REQUIREMENTS_INFO_2_KHR                        = VkStructureType.VK_STRUCTURE_TYPE_BUFFER_MEMORY_REQUIREMENTS_INFO_2_KHR;
enum VK_STRUCTURE_TYPE_IMAGE_MEMORY_REQUIREMENTS_INFO_2_KHR                         = VkStructureType.VK_STRUCTURE_TYPE_IMAGE_MEMORY_REQUIREMENTS_INFO_2_KHR;
enum VK_STRUCTURE_TYPE_IMAGE_SPARSE_MEMORY_REQUIREMENTS_INFO_2_KHR                  = VkStructureType.VK_STRUCTURE_TYPE_IMAGE_SPARSE_MEMORY_REQUIREMENTS_INFO_2_KHR;
enum VK_STRUCTURE_TYPE_MEMORY_REQUIREMENTS_2_KHR                                    = VkStructureType.VK_STRUCTURE_TYPE_MEMORY_REQUIREMENTS_2_KHR;
enum VK_STRUCTURE_TYPE_SPARSE_IMAGE_MEMORY_REQUIREMENTS_2_KHR                       = VkStructureType.VK_STRUCTURE_TYPE_SPARSE_IMAGE_MEMORY_REQUIREMENTS_2_KHR;
enum VK_STRUCTURE_TYPE_IMAGE_FORMAT_LIST_CREATE_INFO_KHR                            = VkStructureType.VK_STRUCTURE_TYPE_IMAGE_FORMAT_LIST_CREATE_INFO_KHR;
enum VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_BLEND_OPERATION_ADVANCED_FEATURES_EXT        = VkStructureType.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_BLEND_OPERATION_ADVANCED_FEATURES_EXT;
enum VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_BLEND_OPERATION_ADVANCED_PROPERTIES_EXT      = VkStructureType.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_BLEND_OPERATION_ADVANCED_PROPERTIES_EXT;
enum VK_STRUCTURE_TYPE_PIPELINE_COLOR_BLEND_ADVANCED_STATE_CREATE_INFO_EXT          = VkStructureType.VK_STRUCTURE_TYPE_PIPELINE_COLOR_BLEND_ADVANCED_STATE_CREATE_INFO_EXT;
enum VK_STRUCTURE_TYPE_PIPELINE_COVERAGE_TO_COLOR_STATE_CREATE_INFO_NV              = VkStructureType.VK_STRUCTURE_TYPE_PIPELINE_COVERAGE_TO_COLOR_STATE_CREATE_INFO_NV;
enum VK_STRUCTURE_TYPE_PIPELINE_COVERAGE_MODULATION_STATE_CREATE_INFO_NV            = VkStructureType.VK_STRUCTURE_TYPE_PIPELINE_COVERAGE_MODULATION_STATE_CREATE_INFO_NV;
enum VK_STRUCTURE_TYPE_SAMPLER_YCBCR_CONVERSION_CREATE_INFO_KHR                     = VkStructureType.VK_STRUCTURE_TYPE_SAMPLER_YCBCR_CONVERSION_CREATE_INFO_KHR;
enum VK_STRUCTURE_TYPE_SAMPLER_YCBCR_CONVERSION_INFO_KHR                            = VkStructureType.VK_STRUCTURE_TYPE_SAMPLER_YCBCR_CONVERSION_INFO_KHR;
enum VK_STRUCTURE_TYPE_BIND_IMAGE_PLANE_MEMORY_INFO_KHR                             = VkStructureType.VK_STRUCTURE_TYPE_BIND_IMAGE_PLANE_MEMORY_INFO_KHR;
enum VK_STRUCTURE_TYPE_IMAGE_PLANE_MEMORY_REQUIREMENTS_INFO_KHR                     = VkStructureType.VK_STRUCTURE_TYPE_IMAGE_PLANE_MEMORY_REQUIREMENTS_INFO_KHR;
enum VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SAMPLER_YCBCR_CONVERSION_FEATURES_KHR        = VkStructureType.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SAMPLER_YCBCR_CONVERSION_FEATURES_KHR;
enum VK_STRUCTURE_TYPE_SAMPLER_YCBCR_CONVERSION_IMAGE_FORMAT_PROPERTIES_KHR         = VkStructureType.VK_STRUCTURE_TYPE_SAMPLER_YCBCR_CONVERSION_IMAGE_FORMAT_PROPERTIES_KHR;
enum VK_STRUCTURE_TYPE_BIND_BUFFER_MEMORY_INFO_KHR                                  = VkStructureType.VK_STRUCTURE_TYPE_BIND_BUFFER_MEMORY_INFO_KHR;
enum VK_STRUCTURE_TYPE_BIND_IMAGE_MEMORY_INFO_KHR                                   = VkStructureType.VK_STRUCTURE_TYPE_BIND_IMAGE_MEMORY_INFO_KHR;
enum VK_STRUCTURE_TYPE_DRM_FORMAT_MODIFIER_PROPERTIES_LIST_EXT                      = VkStructureType.VK_STRUCTURE_TYPE_DRM_FORMAT_MODIFIER_PROPERTIES_LIST_EXT;
enum VK_STRUCTURE_TYPE_DRM_FORMAT_MODIFIER_PROPERTIES_EXT                           = VkStructureType.VK_STRUCTURE_TYPE_DRM_FORMAT_MODIFIER_PROPERTIES_EXT;
enum VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_IMAGE_DRM_FORMAT_MODIFIER_INFO_EXT           = VkStructureType.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_IMAGE_DRM_FORMAT_MODIFIER_INFO_EXT;
enum VK_STRUCTURE_TYPE_IMAGE_DRM_FORMAT_MODIFIER_LIST_CREATE_INFO_EXT               = VkStructureType.VK_STRUCTURE_TYPE_IMAGE_DRM_FORMAT_MODIFIER_LIST_CREATE_INFO_EXT;
enum VK_STRUCTURE_TYPE_IMAGE_DRM_FORMAT_MODIFIER_EXPLICIT_CREATE_INFO_EXT           = VkStructureType.VK_STRUCTURE_TYPE_IMAGE_DRM_FORMAT_MODIFIER_EXPLICIT_CREATE_INFO_EXT;
enum VK_STRUCTURE_TYPE_IMAGE_DRM_FORMAT_MODIFIER_PROPERTIES_EXT                     = VkStructureType.VK_STRUCTURE_TYPE_IMAGE_DRM_FORMAT_MODIFIER_PROPERTIES_EXT;
enum VK_STRUCTURE_TYPE_VALIDATION_CACHE_CREATE_INFO_EXT                             = VkStructureType.VK_STRUCTURE_TYPE_VALIDATION_CACHE_CREATE_INFO_EXT;
enum VK_STRUCTURE_TYPE_SHADER_MODULE_VALIDATION_CACHE_CREATE_INFO_EXT               = VkStructureType.VK_STRUCTURE_TYPE_SHADER_MODULE_VALIDATION_CACHE_CREATE_INFO_EXT;
enum VK_STRUCTURE_TYPE_DESCRIPTOR_SET_LAYOUT_BINDING_FLAGS_CREATE_INFO_EXT          = VkStructureType.VK_STRUCTURE_TYPE_DESCRIPTOR_SET_LAYOUT_BINDING_FLAGS_CREATE_INFO_EXT;
enum VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_DESCRIPTOR_INDEXING_FEATURES_EXT             = VkStructureType.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_DESCRIPTOR_INDEXING_FEATURES_EXT;
enum VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_DESCRIPTOR_INDEXING_PROPERTIES_EXT           = VkStructureType.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_DESCRIPTOR_INDEXING_PROPERTIES_EXT;
enum VK_STRUCTURE_TYPE_DESCRIPTOR_SET_VARIABLE_DESCRIPTOR_COUNT_ALLOCATE_INFO_EXT   = VkStructureType.VK_STRUCTURE_TYPE_DESCRIPTOR_SET_VARIABLE_DESCRIPTOR_COUNT_ALLOCATE_INFO_EXT;
enum VK_STRUCTURE_TYPE_DESCRIPTOR_SET_VARIABLE_DESCRIPTOR_COUNT_LAYOUT_SUPPORT_EXT  = VkStructureType.VK_STRUCTURE_TYPE_DESCRIPTOR_SET_VARIABLE_DESCRIPTOR_COUNT_LAYOUT_SUPPORT_EXT;
enum VK_STRUCTURE_TYPE_PIPELINE_VIEWPORT_SHADING_RATE_IMAGE_STATE_CREATE_INFO_NV    = VkStructureType.VK_STRUCTURE_TYPE_PIPELINE_VIEWPORT_SHADING_RATE_IMAGE_STATE_CREATE_INFO_NV;
enum VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADING_RATE_IMAGE_FEATURES_NV               = VkStructureType.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADING_RATE_IMAGE_FEATURES_NV;
enum VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADING_RATE_IMAGE_PROPERTIES_NV             = VkStructureType.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADING_RATE_IMAGE_PROPERTIES_NV;
enum VK_STRUCTURE_TYPE_PIPELINE_VIEWPORT_COARSE_SAMPLE_ORDER_STATE_CREATE_INFO_NV   = VkStructureType.VK_STRUCTURE_TYPE_PIPELINE_VIEWPORT_COARSE_SAMPLE_ORDER_STATE_CREATE_INFO_NV;
enum VK_STRUCTURE_TYPE_RAY_TRACING_PIPELINE_CREATE_INFO_NV                          = VkStructureType.VK_STRUCTURE_TYPE_RAY_TRACING_PIPELINE_CREATE_INFO_NV;
enum VK_STRUCTURE_TYPE_ACCELERATION_STRUCTURE_CREATE_INFO_NV                        = VkStructureType.VK_STRUCTURE_TYPE_ACCELERATION_STRUCTURE_CREATE_INFO_NV;
enum VK_STRUCTURE_TYPE_GEOMETRY_NV                                                  = VkStructureType.VK_STRUCTURE_TYPE_GEOMETRY_NV;
enum VK_STRUCTURE_TYPE_GEOMETRY_TRIANGLES_NV                                        = VkStructureType.VK_STRUCTURE_TYPE_GEOMETRY_TRIANGLES_NV;
enum VK_STRUCTURE_TYPE_GEOMETRY_AABB_NV                                             = VkStructureType.VK_STRUCTURE_TYPE_GEOMETRY_AABB_NV;
enum VK_STRUCTURE_TYPE_BIND_ACCELERATION_STRUCTURE_MEMORY_INFO_NV                   = VkStructureType.VK_STRUCTURE_TYPE_BIND_ACCELERATION_STRUCTURE_MEMORY_INFO_NV;
enum VK_STRUCTURE_TYPE_WRITE_DESCRIPTOR_SET_ACCELERATION_STRUCTURE_NV               = VkStructureType.VK_STRUCTURE_TYPE_WRITE_DESCRIPTOR_SET_ACCELERATION_STRUCTURE_NV;
enum VK_STRUCTURE_TYPE_ACCELERATION_STRUCTURE_MEMORY_REQUIREMENTS_INFO_NV           = VkStructureType.VK_STRUCTURE_TYPE_ACCELERATION_STRUCTURE_MEMORY_REQUIREMENTS_INFO_NV;
enum VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_RAY_TRACING_PROPERTIES_NV                    = VkStructureType.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_RAY_TRACING_PROPERTIES_NV;
enum VK_STRUCTURE_TYPE_RAY_TRACING_SHADER_GROUP_CREATE_INFO_NV                      = VkStructureType.VK_STRUCTURE_TYPE_RAY_TRACING_SHADER_GROUP_CREATE_INFO_NV;
enum VK_STRUCTURE_TYPE_ACCELERATION_STRUCTURE_INFO_NV                               = VkStructureType.VK_STRUCTURE_TYPE_ACCELERATION_STRUCTURE_INFO_NV;
enum VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_REPRESENTATIVE_FRAGMENT_TEST_FEATURES_NV     = VkStructureType.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_REPRESENTATIVE_FRAGMENT_TEST_FEATURES_NV;
enum VK_STRUCTURE_TYPE_PIPELINE_REPRESENTATIVE_FRAGMENT_TEST_STATE_CREATE_INFO_NV   = VkStructureType.VK_STRUCTURE_TYPE_PIPELINE_REPRESENTATIVE_FRAGMENT_TEST_STATE_CREATE_INFO_NV;
enum VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MAINTENANCE_3_PROPERTIES_KHR                 = VkStructureType.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MAINTENANCE_3_PROPERTIES_KHR;
enum VK_STRUCTURE_TYPE_DESCRIPTOR_SET_LAYOUT_SUPPORT_KHR                            = VkStructureType.VK_STRUCTURE_TYPE_DESCRIPTOR_SET_LAYOUT_SUPPORT_KHR;
enum VK_STRUCTURE_TYPE_DEVICE_QUEUE_GLOBAL_PRIORITY_CREATE_INFO_EXT                 = VkStructureType.VK_STRUCTURE_TYPE_DEVICE_QUEUE_GLOBAL_PRIORITY_CREATE_INFO_EXT;
enum VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_8BIT_STORAGE_FEATURES_KHR                    = VkStructureType.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_8BIT_STORAGE_FEATURES_KHR;
enum VK_STRUCTURE_TYPE_IMPORT_MEMORY_HOST_POINTER_INFO_EXT                          = VkStructureType.VK_STRUCTURE_TYPE_IMPORT_MEMORY_HOST_POINTER_INFO_EXT;
enum VK_STRUCTURE_TYPE_MEMORY_HOST_POINTER_PROPERTIES_EXT                           = VkStructureType.VK_STRUCTURE_TYPE_MEMORY_HOST_POINTER_PROPERTIES_EXT;
enum VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_EXTERNAL_MEMORY_HOST_PROPERTIES_EXT          = VkStructureType.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_EXTERNAL_MEMORY_HOST_PROPERTIES_EXT;
enum VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADER_ATOMIC_INT64_FEATURES_KHR             = VkStructureType.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADER_ATOMIC_INT64_FEATURES_KHR;
enum VK_STRUCTURE_TYPE_CALIBRATED_TIMESTAMP_INFO_EXT                                = VkStructureType.VK_STRUCTURE_TYPE_CALIBRATED_TIMESTAMP_INFO_EXT;
enum VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADER_CORE_PROPERTIES_AMD                   = VkStructureType.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADER_CORE_PROPERTIES_AMD;
enum VK_STRUCTURE_TYPE_DEVICE_MEMORY_OVERALLOCATION_CREATE_INFO_AMD                 = VkStructureType.VK_STRUCTURE_TYPE_DEVICE_MEMORY_OVERALLOCATION_CREATE_INFO_AMD;
enum VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_VERTEX_ATTRIBUTE_DIVISOR_PROPERTIES_EXT      = VkStructureType.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_VERTEX_ATTRIBUTE_DIVISOR_PROPERTIES_EXT;
enum VK_STRUCTURE_TYPE_PIPELINE_VERTEX_INPUT_DIVISOR_STATE_CREATE_INFO_EXT          = VkStructureType.VK_STRUCTURE_TYPE_PIPELINE_VERTEX_INPUT_DIVISOR_STATE_CREATE_INFO_EXT;
enum VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_VERTEX_ATTRIBUTE_DIVISOR_FEATURES_EXT        = VkStructureType.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_VERTEX_ATTRIBUTE_DIVISOR_FEATURES_EXT;
enum VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_DRIVER_PROPERTIES_KHR                        = VkStructureType.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_DRIVER_PROPERTIES_KHR;
enum VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_FLOAT_CONTROLS_PROPERTIES_KHR                = VkStructureType.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_FLOAT_CONTROLS_PROPERTIES_KHR;
enum VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_COMPUTE_SHADER_DERIVATIVES_FEATURES_NV       = VkStructureType.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_COMPUTE_SHADER_DERIVATIVES_FEATURES_NV;
enum VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MESH_SHADER_FEATURES_NV                      = VkStructureType.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MESH_SHADER_FEATURES_NV;
enum VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MESH_SHADER_PROPERTIES_NV                    = VkStructureType.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MESH_SHADER_PROPERTIES_NV;
enum VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_FRAGMENT_SHADER_BARYCENTRIC_FEATURES_NV      = VkStructureType.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_FRAGMENT_SHADER_BARYCENTRIC_FEATURES_NV;
enum VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADER_IMAGE_FOOTPRINT_FEATURES_NV           = VkStructureType.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADER_IMAGE_FOOTPRINT_FEATURES_NV;
enum VK_STRUCTURE_TYPE_PIPELINE_VIEWPORT_EXCLUSIVE_SCISSOR_STATE_CREATE_INFO_NV     = VkStructureType.VK_STRUCTURE_TYPE_PIPELINE_VIEWPORT_EXCLUSIVE_SCISSOR_STATE_CREATE_INFO_NV;
enum VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_EXCLUSIVE_SCISSOR_FEATURES_NV                = VkStructureType.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_EXCLUSIVE_SCISSOR_FEATURES_NV;
enum VK_STRUCTURE_TYPE_CHECKPOINT_DATA_NV                                           = VkStructureType.VK_STRUCTURE_TYPE_CHECKPOINT_DATA_NV;
enum VK_STRUCTURE_TYPE_QUEUE_FAMILY_CHECKPOINT_PROPERTIES_NV                        = VkStructureType.VK_STRUCTURE_TYPE_QUEUE_FAMILY_CHECKPOINT_PROPERTIES_NV;
enum VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_VULKAN_MEMORY_MODEL_FEATURES_KHR             = VkStructureType.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_VULKAN_MEMORY_MODEL_FEATURES_KHR;
enum VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PCI_BUS_INFO_PROPERTIES_EXT                  = VkStructureType.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PCI_BUS_INFO_PROPERTIES_EXT;
enum VK_STRUCTURE_TYPE_IMAGEPIPE_SURFACE_CREATE_INFO_FUCHSIA                        = VkStructureType.VK_STRUCTURE_TYPE_IMAGEPIPE_SURFACE_CREATE_INFO_FUCHSIA;
enum VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_FRAGMENT_DENSITY_MAP_FEATURES_EXT            = VkStructureType.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_FRAGMENT_DENSITY_MAP_FEATURES_EXT;
enum VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_FRAGMENT_DENSITY_MAP_PROPERTIES_EXT          = VkStructureType.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_FRAGMENT_DENSITY_MAP_PROPERTIES_EXT;
enum VK_STRUCTURE_TYPE_RENDER_PASS_FRAGMENT_DENSITY_MAP_CREATE_INFO_EXT             = VkStructureType.VK_STRUCTURE_TYPE_RENDER_PASS_FRAGMENT_DENSITY_MAP_CREATE_INFO_EXT;
enum VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SCALAR_BLOCK_LAYOUT_FEATURES_EXT             = VkStructureType.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SCALAR_BLOCK_LAYOUT_FEATURES_EXT;
enum VK_STRUCTURE_TYPE_IMAGE_STENCIL_USAGE_CREATE_INFO_EXT                          = VkStructureType.VK_STRUCTURE_TYPE_IMAGE_STENCIL_USAGE_CREATE_INFO_EXT;

enum VkSystemAllocationScope {
    VK_SYSTEM_ALLOCATION_SCOPE_COMMAND  = 0,
    VK_SYSTEM_ALLOCATION_SCOPE_OBJECT   = 1,
    VK_SYSTEM_ALLOCATION_SCOPE_CACHE    = 2,
    VK_SYSTEM_ALLOCATION_SCOPE_DEVICE   = 3,
    VK_SYSTEM_ALLOCATION_SCOPE_INSTANCE = 4,
}
enum VK_SYSTEM_ALLOCATION_SCOPE_COMMAND  = VkSystemAllocationScope.VK_SYSTEM_ALLOCATION_SCOPE_COMMAND;
enum VK_SYSTEM_ALLOCATION_SCOPE_OBJECT   = VkSystemAllocationScope.VK_SYSTEM_ALLOCATION_SCOPE_OBJECT;
enum VK_SYSTEM_ALLOCATION_SCOPE_CACHE    = VkSystemAllocationScope.VK_SYSTEM_ALLOCATION_SCOPE_CACHE;
enum VK_SYSTEM_ALLOCATION_SCOPE_DEVICE   = VkSystemAllocationScope.VK_SYSTEM_ALLOCATION_SCOPE_DEVICE;
enum VK_SYSTEM_ALLOCATION_SCOPE_INSTANCE = VkSystemAllocationScope.VK_SYSTEM_ALLOCATION_SCOPE_INSTANCE;

enum VkInternalAllocationType {
    VK_INTERNAL_ALLOCATION_TYPE_EXECUTABLE = 0,
}
enum VK_INTERNAL_ALLOCATION_TYPE_EXECUTABLE = VkInternalAllocationType.VK_INTERNAL_ALLOCATION_TYPE_EXECUTABLE;

enum VkFormat {
    VK_FORMAT_UNDEFINED                                      = 0,
    VK_FORMAT_R4G4_UNORM_PACK8                               = 1,
    VK_FORMAT_R4G4B4A4_UNORM_PACK16                          = 2,
    VK_FORMAT_B4G4R4A4_UNORM_PACK16                          = 3,
    VK_FORMAT_R5G6B5_UNORM_PACK16                            = 4,
    VK_FORMAT_B5G6R5_UNORM_PACK16                            = 5,
    VK_FORMAT_R5G5B5A1_UNORM_PACK16                          = 6,
    VK_FORMAT_B5G5R5A1_UNORM_PACK16                          = 7,
    VK_FORMAT_A1R5G5B5_UNORM_PACK16                          = 8,
    VK_FORMAT_R8_UNORM                                       = 9,
    VK_FORMAT_R8_SNORM                                       = 10,
    VK_FORMAT_R8_USCALED                                     = 11,
    VK_FORMAT_R8_SSCALED                                     = 12,
    VK_FORMAT_R8_UINT                                        = 13,
    VK_FORMAT_R8_SINT                                        = 14,
    VK_FORMAT_R8_SRGB                                        = 15,
    VK_FORMAT_R8G8_UNORM                                     = 16,
    VK_FORMAT_R8G8_SNORM                                     = 17,
    VK_FORMAT_R8G8_USCALED                                   = 18,
    VK_FORMAT_R8G8_SSCALED                                   = 19,
    VK_FORMAT_R8G8_UINT                                      = 20,
    VK_FORMAT_R8G8_SINT                                      = 21,
    VK_FORMAT_R8G8_SRGB                                      = 22,
    VK_FORMAT_R8G8B8_UNORM                                   = 23,
    VK_FORMAT_R8G8B8_SNORM                                   = 24,
    VK_FORMAT_R8G8B8_USCALED                                 = 25,
    VK_FORMAT_R8G8B8_SSCALED                                 = 26,
    VK_FORMAT_R8G8B8_UINT                                    = 27,
    VK_FORMAT_R8G8B8_SINT                                    = 28,
    VK_FORMAT_R8G8B8_SRGB                                    = 29,
    VK_FORMAT_B8G8R8_UNORM                                   = 30,
    VK_FORMAT_B8G8R8_SNORM                                   = 31,
    VK_FORMAT_B8G8R8_USCALED                                 = 32,
    VK_FORMAT_B8G8R8_SSCALED                                 = 33,
    VK_FORMAT_B8G8R8_UINT                                    = 34,
    VK_FORMAT_B8G8R8_SINT                                    = 35,
    VK_FORMAT_B8G8R8_SRGB                                    = 36,
    VK_FORMAT_R8G8B8A8_UNORM                                 = 37,
    VK_FORMAT_R8G8B8A8_SNORM                                 = 38,
    VK_FORMAT_R8G8B8A8_USCALED                               = 39,
    VK_FORMAT_R8G8B8A8_SSCALED                               = 40,
    VK_FORMAT_R8G8B8A8_UINT                                  = 41,
    VK_FORMAT_R8G8B8A8_SINT                                  = 42,
    VK_FORMAT_R8G8B8A8_SRGB                                  = 43,
    VK_FORMAT_B8G8R8A8_UNORM                                 = 44,
    VK_FORMAT_B8G8R8A8_SNORM                                 = 45,
    VK_FORMAT_B8G8R8A8_USCALED                               = 46,
    VK_FORMAT_B8G8R8A8_SSCALED                               = 47,
    VK_FORMAT_B8G8R8A8_UINT                                  = 48,
    VK_FORMAT_B8G8R8A8_SINT                                  = 49,
    VK_FORMAT_B8G8R8A8_SRGB                                  = 50,
    VK_FORMAT_A8B8G8R8_UNORM_PACK32                          = 51,
    VK_FORMAT_A8B8G8R8_SNORM_PACK32                          = 52,
    VK_FORMAT_A8B8G8R8_USCALED_PACK32                        = 53,
    VK_FORMAT_A8B8G8R8_SSCALED_PACK32                        = 54,
    VK_FORMAT_A8B8G8R8_UINT_PACK32                           = 55,
    VK_FORMAT_A8B8G8R8_SINT_PACK32                           = 56,
    VK_FORMAT_A8B8G8R8_SRGB_PACK32                           = 57,
    VK_FORMAT_A2R10G10B10_UNORM_PACK32                       = 58,
    VK_FORMAT_A2R10G10B10_SNORM_PACK32                       = 59,
    VK_FORMAT_A2R10G10B10_USCALED_PACK32                     = 60,
    VK_FORMAT_A2R10G10B10_SSCALED_PACK32                     = 61,
    VK_FORMAT_A2R10G10B10_UINT_PACK32                        = 62,
    VK_FORMAT_A2R10G10B10_SINT_PACK32                        = 63,
    VK_FORMAT_A2B10G10R10_UNORM_PACK32                       = 64,
    VK_FORMAT_A2B10G10R10_SNORM_PACK32                       = 65,
    VK_FORMAT_A2B10G10R10_USCALED_PACK32                     = 66,
    VK_FORMAT_A2B10G10R10_SSCALED_PACK32                     = 67,
    VK_FORMAT_A2B10G10R10_UINT_PACK32                        = 68,
    VK_FORMAT_A2B10G10R10_SINT_PACK32                        = 69,
    VK_FORMAT_R16_UNORM                                      = 70,
    VK_FORMAT_R16_SNORM                                      = 71,
    VK_FORMAT_R16_USCALED                                    = 72,
    VK_FORMAT_R16_SSCALED                                    = 73,
    VK_FORMAT_R16_UINT                                       = 74,
    VK_FORMAT_R16_SINT                                       = 75,
    VK_FORMAT_R16_SFLOAT                                     = 76,
    VK_FORMAT_R16G16_UNORM                                   = 77,
    VK_FORMAT_R16G16_SNORM                                   = 78,
    VK_FORMAT_R16G16_USCALED                                 = 79,
    VK_FORMAT_R16G16_SSCALED                                 = 80,
    VK_FORMAT_R16G16_UINT                                    = 81,
    VK_FORMAT_R16G16_SINT                                    = 82,
    VK_FORMAT_R16G16_SFLOAT                                  = 83,
    VK_FORMAT_R16G16B16_UNORM                                = 84,
    VK_FORMAT_R16G16B16_SNORM                                = 85,
    VK_FORMAT_R16G16B16_USCALED                              = 86,
    VK_FORMAT_R16G16B16_SSCALED                              = 87,
    VK_FORMAT_R16G16B16_UINT                                 = 88,
    VK_FORMAT_R16G16B16_SINT                                 = 89,
    VK_FORMAT_R16G16B16_SFLOAT                               = 90,
    VK_FORMAT_R16G16B16A16_UNORM                             = 91,
    VK_FORMAT_R16G16B16A16_SNORM                             = 92,
    VK_FORMAT_R16G16B16A16_USCALED                           = 93,
    VK_FORMAT_R16G16B16A16_SSCALED                           = 94,
    VK_FORMAT_R16G16B16A16_UINT                              = 95,
    VK_FORMAT_R16G16B16A16_SINT                              = 96,
    VK_FORMAT_R16G16B16A16_SFLOAT                            = 97,
    VK_FORMAT_R32_UINT                                       = 98,
    VK_FORMAT_R32_SINT                                       = 99,
    VK_FORMAT_R32_SFLOAT                                     = 100,
    VK_FORMAT_R32G32_UINT                                    = 101,
    VK_FORMAT_R32G32_SINT                                    = 102,
    VK_FORMAT_R32G32_SFLOAT                                  = 103,
    VK_FORMAT_R32G32B32_UINT                                 = 104,
    VK_FORMAT_R32G32B32_SINT                                 = 105,
    VK_FORMAT_R32G32B32_SFLOAT                               = 106,
    VK_FORMAT_R32G32B32A32_UINT                              = 107,
    VK_FORMAT_R32G32B32A32_SINT                              = 108,
    VK_FORMAT_R32G32B32A32_SFLOAT                            = 109,
    VK_FORMAT_R64_UINT                                       = 110,
    VK_FORMAT_R64_SINT                                       = 111,
    VK_FORMAT_R64_SFLOAT                                     = 112,
    VK_FORMAT_R64G64_UINT                                    = 113,
    VK_FORMAT_R64G64_SINT                                    = 114,
    VK_FORMAT_R64G64_SFLOAT                                  = 115,
    VK_FORMAT_R64G64B64_UINT                                 = 116,
    VK_FORMAT_R64G64B64_SINT                                 = 117,
    VK_FORMAT_R64G64B64_SFLOAT                               = 118,
    VK_FORMAT_R64G64B64A64_UINT                              = 119,
    VK_FORMAT_R64G64B64A64_SINT                              = 120,
    VK_FORMAT_R64G64B64A64_SFLOAT                            = 121,
    VK_FORMAT_B10G11R11_UFLOAT_PACK32                        = 122,
    VK_FORMAT_E5B9G9R9_UFLOAT_PACK32                         = 123,
    VK_FORMAT_D16_UNORM                                      = 124,
    VK_FORMAT_X8_D24_UNORM_PACK32                            = 125,
    VK_FORMAT_D32_SFLOAT                                     = 126,
    VK_FORMAT_S8_UINT                                        = 127,
    VK_FORMAT_D16_UNORM_S8_UINT                              = 128,
    VK_FORMAT_D24_UNORM_S8_UINT                              = 129,
    VK_FORMAT_D32_SFLOAT_S8_UINT                             = 130,
    VK_FORMAT_BC1_RGB_UNORM_BLOCK                            = 131,
    VK_FORMAT_BC1_RGB_SRGB_BLOCK                             = 132,
    VK_FORMAT_BC1_RGBA_UNORM_BLOCK                           = 133,
    VK_FORMAT_BC1_RGBA_SRGB_BLOCK                            = 134,
    VK_FORMAT_BC2_UNORM_BLOCK                                = 135,
    VK_FORMAT_BC2_SRGB_BLOCK                                 = 136,
    VK_FORMAT_BC3_UNORM_BLOCK                                = 137,
    VK_FORMAT_BC3_SRGB_BLOCK                                 = 138,
    VK_FORMAT_BC4_UNORM_BLOCK                                = 139,
    VK_FORMAT_BC4_SNORM_BLOCK                                = 140,
    VK_FORMAT_BC5_UNORM_BLOCK                                = 141,
    VK_FORMAT_BC5_SNORM_BLOCK                                = 142,
    VK_FORMAT_BC6H_UFLOAT_BLOCK                              = 143,
    VK_FORMAT_BC6H_SFLOAT_BLOCK                              = 144,
    VK_FORMAT_BC7_UNORM_BLOCK                                = 145,
    VK_FORMAT_BC7_SRGB_BLOCK                                 = 146,
    VK_FORMAT_ETC2_R8G8B8_UNORM_BLOCK                        = 147,
    VK_FORMAT_ETC2_R8G8B8_SRGB_BLOCK                         = 148,
    VK_FORMAT_ETC2_R8G8B8A1_UNORM_BLOCK                      = 149,
    VK_FORMAT_ETC2_R8G8B8A1_SRGB_BLOCK                       = 150,
    VK_FORMAT_ETC2_R8G8B8A8_UNORM_BLOCK                      = 151,
    VK_FORMAT_ETC2_R8G8B8A8_SRGB_BLOCK                       = 152,
    VK_FORMAT_EAC_R11_UNORM_BLOCK                            = 153,
    VK_FORMAT_EAC_R11_SNORM_BLOCK                            = 154,
    VK_FORMAT_EAC_R11G11_UNORM_BLOCK                         = 155,
    VK_FORMAT_EAC_R11G11_SNORM_BLOCK                         = 156,
    VK_FORMAT_ASTC_4x4_UNORM_BLOCK                           = 157,
    VK_FORMAT_ASTC_4x4_SRGB_BLOCK                            = 158,
    VK_FORMAT_ASTC_5x4_UNORM_BLOCK                           = 159,
    VK_FORMAT_ASTC_5x4_SRGB_BLOCK                            = 160,
    VK_FORMAT_ASTC_5x5_UNORM_BLOCK                           = 161,
    VK_FORMAT_ASTC_5x5_SRGB_BLOCK                            = 162,
    VK_FORMAT_ASTC_6x5_UNORM_BLOCK                           = 163,
    VK_FORMAT_ASTC_6x5_SRGB_BLOCK                            = 164,
    VK_FORMAT_ASTC_6x6_UNORM_BLOCK                           = 165,
    VK_FORMAT_ASTC_6x6_SRGB_BLOCK                            = 166,
    VK_FORMAT_ASTC_8x5_UNORM_BLOCK                           = 167,
    VK_FORMAT_ASTC_8x5_SRGB_BLOCK                            = 168,
    VK_FORMAT_ASTC_8x6_UNORM_BLOCK                           = 169,
    VK_FORMAT_ASTC_8x6_SRGB_BLOCK                            = 170,
    VK_FORMAT_ASTC_8x8_UNORM_BLOCK                           = 171,
    VK_FORMAT_ASTC_8x8_SRGB_BLOCK                            = 172,
    VK_FORMAT_ASTC_10x5_UNORM_BLOCK                          = 173,
    VK_FORMAT_ASTC_10x5_SRGB_BLOCK                           = 174,
    VK_FORMAT_ASTC_10x6_UNORM_BLOCK                          = 175,
    VK_FORMAT_ASTC_10x6_SRGB_BLOCK                           = 176,
    VK_FORMAT_ASTC_10x8_UNORM_BLOCK                          = 177,
    VK_FORMAT_ASTC_10x8_SRGB_BLOCK                           = 178,
    VK_FORMAT_ASTC_10x10_UNORM_BLOCK                         = 179,
    VK_FORMAT_ASTC_10x10_SRGB_BLOCK                          = 180,
    VK_FORMAT_ASTC_12x10_UNORM_BLOCK                         = 181,
    VK_FORMAT_ASTC_12x10_SRGB_BLOCK                          = 182,
    VK_FORMAT_ASTC_12x12_UNORM_BLOCK                         = 183,
    VK_FORMAT_ASTC_12x12_SRGB_BLOCK                          = 184,
    VK_FORMAT_G8B8G8R8_422_UNORM                             = 1000156000,
    VK_FORMAT_B8G8R8G8_422_UNORM                             = 1000156001,
    VK_FORMAT_G8_B8_R8_3PLANE_420_UNORM                      = 1000156002,
    VK_FORMAT_G8_B8R8_2PLANE_420_UNORM                       = 1000156003,
    VK_FORMAT_G8_B8_R8_3PLANE_422_UNORM                      = 1000156004,
    VK_FORMAT_G8_B8R8_2PLANE_422_UNORM                       = 1000156005,
    VK_FORMAT_G8_B8_R8_3PLANE_444_UNORM                      = 1000156006,
    VK_FORMAT_R10X6_UNORM_PACK16                             = 1000156007,
    VK_FORMAT_R10X6G10X6_UNORM_2PACK16                       = 1000156008,
    VK_FORMAT_R10X6G10X6B10X6A10X6_UNORM_4PACK16             = 1000156009,
    VK_FORMAT_G10X6B10X6G10X6R10X6_422_UNORM_4PACK16         = 1000156010,
    VK_FORMAT_B10X6G10X6R10X6G10X6_422_UNORM_4PACK16         = 1000156011,
    VK_FORMAT_G10X6_B10X6_R10X6_3PLANE_420_UNORM_3PACK16     = 1000156012,
    VK_FORMAT_G10X6_B10X6R10X6_2PLANE_420_UNORM_3PACK16      = 1000156013,
    VK_FORMAT_G10X6_B10X6_R10X6_3PLANE_422_UNORM_3PACK16     = 1000156014,
    VK_FORMAT_G10X6_B10X6R10X6_2PLANE_422_UNORM_3PACK16      = 1000156015,
    VK_FORMAT_G10X6_B10X6_R10X6_3PLANE_444_UNORM_3PACK16     = 1000156016,
    VK_FORMAT_R12X4_UNORM_PACK16                             = 1000156017,
    VK_FORMAT_R12X4G12X4_UNORM_2PACK16                       = 1000156018,
    VK_FORMAT_R12X4G12X4B12X4A12X4_UNORM_4PACK16             = 1000156019,
    VK_FORMAT_G12X4B12X4G12X4R12X4_422_UNORM_4PACK16         = 1000156020,
    VK_FORMAT_B12X4G12X4R12X4G12X4_422_UNORM_4PACK16         = 1000156021,
    VK_FORMAT_G12X4_B12X4_R12X4_3PLANE_420_UNORM_3PACK16     = 1000156022,
    VK_FORMAT_G12X4_B12X4R12X4_2PLANE_420_UNORM_3PACK16      = 1000156023,
    VK_FORMAT_G12X4_B12X4_R12X4_3PLANE_422_UNORM_3PACK16     = 1000156024,
    VK_FORMAT_G12X4_B12X4R12X4_2PLANE_422_UNORM_3PACK16      = 1000156025,
    VK_FORMAT_G12X4_B12X4_R12X4_3PLANE_444_UNORM_3PACK16     = 1000156026,
    VK_FORMAT_G16B16G16R16_422_UNORM                         = 1000156027,
    VK_FORMAT_B16G16R16G16_422_UNORM                         = 1000156028,
    VK_FORMAT_G16_B16_R16_3PLANE_420_UNORM                   = 1000156029,
    VK_FORMAT_G16_B16R16_2PLANE_420_UNORM                    = 1000156030,
    VK_FORMAT_G16_B16_R16_3PLANE_422_UNORM                   = 1000156031,
    VK_FORMAT_G16_B16R16_2PLANE_422_UNORM                    = 1000156032,
    VK_FORMAT_G16_B16_R16_3PLANE_444_UNORM                   = 1000156033,
    VK_FORMAT_PVRTC1_2BPP_UNORM_BLOCK_IMG                    = 1000054000,
    VK_FORMAT_PVRTC1_4BPP_UNORM_BLOCK_IMG                    = 1000054001,
    VK_FORMAT_PVRTC2_2BPP_UNORM_BLOCK_IMG                    = 1000054002,
    VK_FORMAT_PVRTC2_4BPP_UNORM_BLOCK_IMG                    = 1000054003,
    VK_FORMAT_PVRTC1_2BPP_SRGB_BLOCK_IMG                     = 1000054004,
    VK_FORMAT_PVRTC1_4BPP_SRGB_BLOCK_IMG                     = 1000054005,
    VK_FORMAT_PVRTC2_2BPP_SRGB_BLOCK_IMG                     = 1000054006,
    VK_FORMAT_PVRTC2_4BPP_SRGB_BLOCK_IMG                     = 1000054007,
    VK_FORMAT_G8B8G8R8_422_UNORM_KHR                         = VK_FORMAT_G8B8G8R8_422_UNORM,
    VK_FORMAT_B8G8R8G8_422_UNORM_KHR                         = VK_FORMAT_B8G8R8G8_422_UNORM,
    VK_FORMAT_G8_B8_R8_3PLANE_420_UNORM_KHR                  = VK_FORMAT_G8_B8_R8_3PLANE_420_UNORM,
    VK_FORMAT_G8_B8R8_2PLANE_420_UNORM_KHR                   = VK_FORMAT_G8_B8R8_2PLANE_420_UNORM,
    VK_FORMAT_G8_B8_R8_3PLANE_422_UNORM_KHR                  = VK_FORMAT_G8_B8_R8_3PLANE_422_UNORM,
    VK_FORMAT_G8_B8R8_2PLANE_422_UNORM_KHR                   = VK_FORMAT_G8_B8R8_2PLANE_422_UNORM,
    VK_FORMAT_G8_B8_R8_3PLANE_444_UNORM_KHR                  = VK_FORMAT_G8_B8_R8_3PLANE_444_UNORM,
    VK_FORMAT_R10X6_UNORM_PACK16_KHR                         = VK_FORMAT_R10X6_UNORM_PACK16,
    VK_FORMAT_R10X6G10X6_UNORM_2PACK16_KHR                   = VK_FORMAT_R10X6G10X6_UNORM_2PACK16,
    VK_FORMAT_R10X6G10X6B10X6A10X6_UNORM_4PACK16_KHR         = VK_FORMAT_R10X6G10X6B10X6A10X6_UNORM_4PACK16,
    VK_FORMAT_G10X6B10X6G10X6R10X6_422_UNORM_4PACK16_KHR     = VK_FORMAT_G10X6B10X6G10X6R10X6_422_UNORM_4PACK16,
    VK_FORMAT_B10X6G10X6R10X6G10X6_422_UNORM_4PACK16_KHR     = VK_FORMAT_B10X6G10X6R10X6G10X6_422_UNORM_4PACK16,
    VK_FORMAT_G10X6_B10X6_R10X6_3PLANE_420_UNORM_3PACK16_KHR = VK_FORMAT_G10X6_B10X6_R10X6_3PLANE_420_UNORM_3PACK16,
    VK_FORMAT_G10X6_B10X6R10X6_2PLANE_420_UNORM_3PACK16_KHR  = VK_FORMAT_G10X6_B10X6R10X6_2PLANE_420_UNORM_3PACK16,
    VK_FORMAT_G10X6_B10X6_R10X6_3PLANE_422_UNORM_3PACK16_KHR = VK_FORMAT_G10X6_B10X6_R10X6_3PLANE_422_UNORM_3PACK16,
    VK_FORMAT_G10X6_B10X6R10X6_2PLANE_422_UNORM_3PACK16_KHR  = VK_FORMAT_G10X6_B10X6R10X6_2PLANE_422_UNORM_3PACK16,
    VK_FORMAT_G10X6_B10X6_R10X6_3PLANE_444_UNORM_3PACK16_KHR = VK_FORMAT_G10X6_B10X6_R10X6_3PLANE_444_UNORM_3PACK16,
    VK_FORMAT_R12X4_UNORM_PACK16_KHR                         = VK_FORMAT_R12X4_UNORM_PACK16,
    VK_FORMAT_R12X4G12X4_UNORM_2PACK16_KHR                   = VK_FORMAT_R12X4G12X4_UNORM_2PACK16,
    VK_FORMAT_R12X4G12X4B12X4A12X4_UNORM_4PACK16_KHR         = VK_FORMAT_R12X4G12X4B12X4A12X4_UNORM_4PACK16,
    VK_FORMAT_G12X4B12X4G12X4R12X4_422_UNORM_4PACK16_KHR     = VK_FORMAT_G12X4B12X4G12X4R12X4_422_UNORM_4PACK16,
    VK_FORMAT_B12X4G12X4R12X4G12X4_422_UNORM_4PACK16_KHR     = VK_FORMAT_B12X4G12X4R12X4G12X4_422_UNORM_4PACK16,
    VK_FORMAT_G12X4_B12X4_R12X4_3PLANE_420_UNORM_3PACK16_KHR = VK_FORMAT_G12X4_B12X4_R12X4_3PLANE_420_UNORM_3PACK16,
    VK_FORMAT_G12X4_B12X4R12X4_2PLANE_420_UNORM_3PACK16_KHR  = VK_FORMAT_G12X4_B12X4R12X4_2PLANE_420_UNORM_3PACK16,
    VK_FORMAT_G12X4_B12X4_R12X4_3PLANE_422_UNORM_3PACK16_KHR = VK_FORMAT_G12X4_B12X4_R12X4_3PLANE_422_UNORM_3PACK16,
    VK_FORMAT_G12X4_B12X4R12X4_2PLANE_422_UNORM_3PACK16_KHR  = VK_FORMAT_G12X4_B12X4R12X4_2PLANE_422_UNORM_3PACK16,
    VK_FORMAT_G12X4_B12X4_R12X4_3PLANE_444_UNORM_3PACK16_KHR = VK_FORMAT_G12X4_B12X4_R12X4_3PLANE_444_UNORM_3PACK16,
    VK_FORMAT_G16B16G16R16_422_UNORM_KHR                     = VK_FORMAT_G16B16G16R16_422_UNORM,
    VK_FORMAT_B16G16R16G16_422_UNORM_KHR                     = VK_FORMAT_B16G16R16G16_422_UNORM,
    VK_FORMAT_G16_B16_R16_3PLANE_420_UNORM_KHR               = VK_FORMAT_G16_B16_R16_3PLANE_420_UNORM,
    VK_FORMAT_G16_B16R16_2PLANE_420_UNORM_KHR                = VK_FORMAT_G16_B16R16_2PLANE_420_UNORM,
    VK_FORMAT_G16_B16_R16_3PLANE_422_UNORM_KHR               = VK_FORMAT_G16_B16_R16_3PLANE_422_UNORM,
    VK_FORMAT_G16_B16R16_2PLANE_422_UNORM_KHR                = VK_FORMAT_G16_B16R16_2PLANE_422_UNORM,
    VK_FORMAT_G16_B16_R16_3PLANE_444_UNORM_KHR               = VK_FORMAT_G16_B16_R16_3PLANE_444_UNORM,
}
enum VK_FORMAT_UNDEFINED                                      = VkFormat.VK_FORMAT_UNDEFINED;
enum VK_FORMAT_R4G4_UNORM_PACK8                               = VkFormat.VK_FORMAT_R4G4_UNORM_PACK8;
enum VK_FORMAT_R4G4B4A4_UNORM_PACK16                          = VkFormat.VK_FORMAT_R4G4B4A4_UNORM_PACK16;
enum VK_FORMAT_B4G4R4A4_UNORM_PACK16                          = VkFormat.VK_FORMAT_B4G4R4A4_UNORM_PACK16;
enum VK_FORMAT_R5G6B5_UNORM_PACK16                            = VkFormat.VK_FORMAT_R5G6B5_UNORM_PACK16;
enum VK_FORMAT_B5G6R5_UNORM_PACK16                            = VkFormat.VK_FORMAT_B5G6R5_UNORM_PACK16;
enum VK_FORMAT_R5G5B5A1_UNORM_PACK16                          = VkFormat.VK_FORMAT_R5G5B5A1_UNORM_PACK16;
enum VK_FORMAT_B5G5R5A1_UNORM_PACK16                          = VkFormat.VK_FORMAT_B5G5R5A1_UNORM_PACK16;
enum VK_FORMAT_A1R5G5B5_UNORM_PACK16                          = VkFormat.VK_FORMAT_A1R5G5B5_UNORM_PACK16;
enum VK_FORMAT_R8_UNORM                                       = VkFormat.VK_FORMAT_R8_UNORM;
enum VK_FORMAT_R8_SNORM                                       = VkFormat.VK_FORMAT_R8_SNORM;
enum VK_FORMAT_R8_USCALED                                     = VkFormat.VK_FORMAT_R8_USCALED;
enum VK_FORMAT_R8_SSCALED                                     = VkFormat.VK_FORMAT_R8_SSCALED;
enum VK_FORMAT_R8_UINT                                        = VkFormat.VK_FORMAT_R8_UINT;
enum VK_FORMAT_R8_SINT                                        = VkFormat.VK_FORMAT_R8_SINT;
enum VK_FORMAT_R8_SRGB                                        = VkFormat.VK_FORMAT_R8_SRGB;
enum VK_FORMAT_R8G8_UNORM                                     = VkFormat.VK_FORMAT_R8G8_UNORM;
enum VK_FORMAT_R8G8_SNORM                                     = VkFormat.VK_FORMAT_R8G8_SNORM;
enum VK_FORMAT_R8G8_USCALED                                   = VkFormat.VK_FORMAT_R8G8_USCALED;
enum VK_FORMAT_R8G8_SSCALED                                   = VkFormat.VK_FORMAT_R8G8_SSCALED;
enum VK_FORMAT_R8G8_UINT                                      = VkFormat.VK_FORMAT_R8G8_UINT;
enum VK_FORMAT_R8G8_SINT                                      = VkFormat.VK_FORMAT_R8G8_SINT;
enum VK_FORMAT_R8G8_SRGB                                      = VkFormat.VK_FORMAT_R8G8_SRGB;
enum VK_FORMAT_R8G8B8_UNORM                                   = VkFormat.VK_FORMAT_R8G8B8_UNORM;
enum VK_FORMAT_R8G8B8_SNORM                                   = VkFormat.VK_FORMAT_R8G8B8_SNORM;
enum VK_FORMAT_R8G8B8_USCALED                                 = VkFormat.VK_FORMAT_R8G8B8_USCALED;
enum VK_FORMAT_R8G8B8_SSCALED                                 = VkFormat.VK_FORMAT_R8G8B8_SSCALED;
enum VK_FORMAT_R8G8B8_UINT                                    = VkFormat.VK_FORMAT_R8G8B8_UINT;
enum VK_FORMAT_R8G8B8_SINT                                    = VkFormat.VK_FORMAT_R8G8B8_SINT;
enum VK_FORMAT_R8G8B8_SRGB                                    = VkFormat.VK_FORMAT_R8G8B8_SRGB;
enum VK_FORMAT_B8G8R8_UNORM                                   = VkFormat.VK_FORMAT_B8G8R8_UNORM;
enum VK_FORMAT_B8G8R8_SNORM                                   = VkFormat.VK_FORMAT_B8G8R8_SNORM;
enum VK_FORMAT_B8G8R8_USCALED                                 = VkFormat.VK_FORMAT_B8G8R8_USCALED;
enum VK_FORMAT_B8G8R8_SSCALED                                 = VkFormat.VK_FORMAT_B8G8R8_SSCALED;
enum VK_FORMAT_B8G8R8_UINT                                    = VkFormat.VK_FORMAT_B8G8R8_UINT;
enum VK_FORMAT_B8G8R8_SINT                                    = VkFormat.VK_FORMAT_B8G8R8_SINT;
enum VK_FORMAT_B8G8R8_SRGB                                    = VkFormat.VK_FORMAT_B8G8R8_SRGB;
enum VK_FORMAT_R8G8B8A8_UNORM                                 = VkFormat.VK_FORMAT_R8G8B8A8_UNORM;
enum VK_FORMAT_R8G8B8A8_SNORM                                 = VkFormat.VK_FORMAT_R8G8B8A8_SNORM;
enum VK_FORMAT_R8G8B8A8_USCALED                               = VkFormat.VK_FORMAT_R8G8B8A8_USCALED;
enum VK_FORMAT_R8G8B8A8_SSCALED                               = VkFormat.VK_FORMAT_R8G8B8A8_SSCALED;
enum VK_FORMAT_R8G8B8A8_UINT                                  = VkFormat.VK_FORMAT_R8G8B8A8_UINT;
enum VK_FORMAT_R8G8B8A8_SINT                                  = VkFormat.VK_FORMAT_R8G8B8A8_SINT;
enum VK_FORMAT_R8G8B8A8_SRGB                                  = VkFormat.VK_FORMAT_R8G8B8A8_SRGB;
enum VK_FORMAT_B8G8R8A8_UNORM                                 = VkFormat.VK_FORMAT_B8G8R8A8_UNORM;
enum VK_FORMAT_B8G8R8A8_SNORM                                 = VkFormat.VK_FORMAT_B8G8R8A8_SNORM;
enum VK_FORMAT_B8G8R8A8_USCALED                               = VkFormat.VK_FORMAT_B8G8R8A8_USCALED;
enum VK_FORMAT_B8G8R8A8_SSCALED                               = VkFormat.VK_FORMAT_B8G8R8A8_SSCALED;
enum VK_FORMAT_B8G8R8A8_UINT                                  = VkFormat.VK_FORMAT_B8G8R8A8_UINT;
enum VK_FORMAT_B8G8R8A8_SINT                                  = VkFormat.VK_FORMAT_B8G8R8A8_SINT;
enum VK_FORMAT_B8G8R8A8_SRGB                                  = VkFormat.VK_FORMAT_B8G8R8A8_SRGB;
enum VK_FORMAT_A8B8G8R8_UNORM_PACK32                          = VkFormat.VK_FORMAT_A8B8G8R8_UNORM_PACK32;
enum VK_FORMAT_A8B8G8R8_SNORM_PACK32                          = VkFormat.VK_FORMAT_A8B8G8R8_SNORM_PACK32;
enum VK_FORMAT_A8B8G8R8_USCALED_PACK32                        = VkFormat.VK_FORMAT_A8B8G8R8_USCALED_PACK32;
enum VK_FORMAT_A8B8G8R8_SSCALED_PACK32                        = VkFormat.VK_FORMAT_A8B8G8R8_SSCALED_PACK32;
enum VK_FORMAT_A8B8G8R8_UINT_PACK32                           = VkFormat.VK_FORMAT_A8B8G8R8_UINT_PACK32;
enum VK_FORMAT_A8B8G8R8_SINT_PACK32                           = VkFormat.VK_FORMAT_A8B8G8R8_SINT_PACK32;
enum VK_FORMAT_A8B8G8R8_SRGB_PACK32                           = VkFormat.VK_FORMAT_A8B8G8R8_SRGB_PACK32;
enum VK_FORMAT_A2R10G10B10_UNORM_PACK32                       = VkFormat.VK_FORMAT_A2R10G10B10_UNORM_PACK32;
enum VK_FORMAT_A2R10G10B10_SNORM_PACK32                       = VkFormat.VK_FORMAT_A2R10G10B10_SNORM_PACK32;
enum VK_FORMAT_A2R10G10B10_USCALED_PACK32                     = VkFormat.VK_FORMAT_A2R10G10B10_USCALED_PACK32;
enum VK_FORMAT_A2R10G10B10_SSCALED_PACK32                     = VkFormat.VK_FORMAT_A2R10G10B10_SSCALED_PACK32;
enum VK_FORMAT_A2R10G10B10_UINT_PACK32                        = VkFormat.VK_FORMAT_A2R10G10B10_UINT_PACK32;
enum VK_FORMAT_A2R10G10B10_SINT_PACK32                        = VkFormat.VK_FORMAT_A2R10G10B10_SINT_PACK32;
enum VK_FORMAT_A2B10G10R10_UNORM_PACK32                       = VkFormat.VK_FORMAT_A2B10G10R10_UNORM_PACK32;
enum VK_FORMAT_A2B10G10R10_SNORM_PACK32                       = VkFormat.VK_FORMAT_A2B10G10R10_SNORM_PACK32;
enum VK_FORMAT_A2B10G10R10_USCALED_PACK32                     = VkFormat.VK_FORMAT_A2B10G10R10_USCALED_PACK32;
enum VK_FORMAT_A2B10G10R10_SSCALED_PACK32                     = VkFormat.VK_FORMAT_A2B10G10R10_SSCALED_PACK32;
enum VK_FORMAT_A2B10G10R10_UINT_PACK32                        = VkFormat.VK_FORMAT_A2B10G10R10_UINT_PACK32;
enum VK_FORMAT_A2B10G10R10_SINT_PACK32                        = VkFormat.VK_FORMAT_A2B10G10R10_SINT_PACK32;
enum VK_FORMAT_R16_UNORM                                      = VkFormat.VK_FORMAT_R16_UNORM;
enum VK_FORMAT_R16_SNORM                                      = VkFormat.VK_FORMAT_R16_SNORM;
enum VK_FORMAT_R16_USCALED                                    = VkFormat.VK_FORMAT_R16_USCALED;
enum VK_FORMAT_R16_SSCALED                                    = VkFormat.VK_FORMAT_R16_SSCALED;
enum VK_FORMAT_R16_UINT                                       = VkFormat.VK_FORMAT_R16_UINT;
enum VK_FORMAT_R16_SINT                                       = VkFormat.VK_FORMAT_R16_SINT;
enum VK_FORMAT_R16_SFLOAT                                     = VkFormat.VK_FORMAT_R16_SFLOAT;
enum VK_FORMAT_R16G16_UNORM                                   = VkFormat.VK_FORMAT_R16G16_UNORM;
enum VK_FORMAT_R16G16_SNORM                                   = VkFormat.VK_FORMAT_R16G16_SNORM;
enum VK_FORMAT_R16G16_USCALED                                 = VkFormat.VK_FORMAT_R16G16_USCALED;
enum VK_FORMAT_R16G16_SSCALED                                 = VkFormat.VK_FORMAT_R16G16_SSCALED;
enum VK_FORMAT_R16G16_UINT                                    = VkFormat.VK_FORMAT_R16G16_UINT;
enum VK_FORMAT_R16G16_SINT                                    = VkFormat.VK_FORMAT_R16G16_SINT;
enum VK_FORMAT_R16G16_SFLOAT                                  = VkFormat.VK_FORMAT_R16G16_SFLOAT;
enum VK_FORMAT_R16G16B16_UNORM                                = VkFormat.VK_FORMAT_R16G16B16_UNORM;
enum VK_FORMAT_R16G16B16_SNORM                                = VkFormat.VK_FORMAT_R16G16B16_SNORM;
enum VK_FORMAT_R16G16B16_USCALED                              = VkFormat.VK_FORMAT_R16G16B16_USCALED;
enum VK_FORMAT_R16G16B16_SSCALED                              = VkFormat.VK_FORMAT_R16G16B16_SSCALED;
enum VK_FORMAT_R16G16B16_UINT                                 = VkFormat.VK_FORMAT_R16G16B16_UINT;
enum VK_FORMAT_R16G16B16_SINT                                 = VkFormat.VK_FORMAT_R16G16B16_SINT;
enum VK_FORMAT_R16G16B16_SFLOAT                               = VkFormat.VK_FORMAT_R16G16B16_SFLOAT;
enum VK_FORMAT_R16G16B16A16_UNORM                             = VkFormat.VK_FORMAT_R16G16B16A16_UNORM;
enum VK_FORMAT_R16G16B16A16_SNORM                             = VkFormat.VK_FORMAT_R16G16B16A16_SNORM;
enum VK_FORMAT_R16G16B16A16_USCALED                           = VkFormat.VK_FORMAT_R16G16B16A16_USCALED;
enum VK_FORMAT_R16G16B16A16_SSCALED                           = VkFormat.VK_FORMAT_R16G16B16A16_SSCALED;
enum VK_FORMAT_R16G16B16A16_UINT                              = VkFormat.VK_FORMAT_R16G16B16A16_UINT;
enum VK_FORMAT_R16G16B16A16_SINT                              = VkFormat.VK_FORMAT_R16G16B16A16_SINT;
enum VK_FORMAT_R16G16B16A16_SFLOAT                            = VkFormat.VK_FORMAT_R16G16B16A16_SFLOAT;
enum VK_FORMAT_R32_UINT                                       = VkFormat.VK_FORMAT_R32_UINT;
enum VK_FORMAT_R32_SINT                                       = VkFormat.VK_FORMAT_R32_SINT;
enum VK_FORMAT_R32_SFLOAT                                     = VkFormat.VK_FORMAT_R32_SFLOAT;
enum VK_FORMAT_R32G32_UINT                                    = VkFormat.VK_FORMAT_R32G32_UINT;
enum VK_FORMAT_R32G32_SINT                                    = VkFormat.VK_FORMAT_R32G32_SINT;
enum VK_FORMAT_R32G32_SFLOAT                                  = VkFormat.VK_FORMAT_R32G32_SFLOAT;
enum VK_FORMAT_R32G32B32_UINT                                 = VkFormat.VK_FORMAT_R32G32B32_UINT;
enum VK_FORMAT_R32G32B32_SINT                                 = VkFormat.VK_FORMAT_R32G32B32_SINT;
enum VK_FORMAT_R32G32B32_SFLOAT                               = VkFormat.VK_FORMAT_R32G32B32_SFLOAT;
enum VK_FORMAT_R32G32B32A32_UINT                              = VkFormat.VK_FORMAT_R32G32B32A32_UINT;
enum VK_FORMAT_R32G32B32A32_SINT                              = VkFormat.VK_FORMAT_R32G32B32A32_SINT;
enum VK_FORMAT_R32G32B32A32_SFLOAT                            = VkFormat.VK_FORMAT_R32G32B32A32_SFLOAT;
enum VK_FORMAT_R64_UINT                                       = VkFormat.VK_FORMAT_R64_UINT;
enum VK_FORMAT_R64_SINT                                       = VkFormat.VK_FORMAT_R64_SINT;
enum VK_FORMAT_R64_SFLOAT                                     = VkFormat.VK_FORMAT_R64_SFLOAT;
enum VK_FORMAT_R64G64_UINT                                    = VkFormat.VK_FORMAT_R64G64_UINT;
enum VK_FORMAT_R64G64_SINT                                    = VkFormat.VK_FORMAT_R64G64_SINT;
enum VK_FORMAT_R64G64_SFLOAT                                  = VkFormat.VK_FORMAT_R64G64_SFLOAT;
enum VK_FORMAT_R64G64B64_UINT                                 = VkFormat.VK_FORMAT_R64G64B64_UINT;
enum VK_FORMAT_R64G64B64_SINT                                 = VkFormat.VK_FORMAT_R64G64B64_SINT;
enum VK_FORMAT_R64G64B64_SFLOAT                               = VkFormat.VK_FORMAT_R64G64B64_SFLOAT;
enum VK_FORMAT_R64G64B64A64_UINT                              = VkFormat.VK_FORMAT_R64G64B64A64_UINT;
enum VK_FORMAT_R64G64B64A64_SINT                              = VkFormat.VK_FORMAT_R64G64B64A64_SINT;
enum VK_FORMAT_R64G64B64A64_SFLOAT                            = VkFormat.VK_FORMAT_R64G64B64A64_SFLOAT;
enum VK_FORMAT_B10G11R11_UFLOAT_PACK32                        = VkFormat.VK_FORMAT_B10G11R11_UFLOAT_PACK32;
enum VK_FORMAT_E5B9G9R9_UFLOAT_PACK32                         = VkFormat.VK_FORMAT_E5B9G9R9_UFLOAT_PACK32;
enum VK_FORMAT_D16_UNORM                                      = VkFormat.VK_FORMAT_D16_UNORM;
enum VK_FORMAT_X8_D24_UNORM_PACK32                            = VkFormat.VK_FORMAT_X8_D24_UNORM_PACK32;
enum VK_FORMAT_D32_SFLOAT                                     = VkFormat.VK_FORMAT_D32_SFLOAT;
enum VK_FORMAT_S8_UINT                                        = VkFormat.VK_FORMAT_S8_UINT;
enum VK_FORMAT_D16_UNORM_S8_UINT                              = VkFormat.VK_FORMAT_D16_UNORM_S8_UINT;
enum VK_FORMAT_D24_UNORM_S8_UINT                              = VkFormat.VK_FORMAT_D24_UNORM_S8_UINT;
enum VK_FORMAT_D32_SFLOAT_S8_UINT                             = VkFormat.VK_FORMAT_D32_SFLOAT_S8_UINT;
enum VK_FORMAT_BC1_RGB_UNORM_BLOCK                            = VkFormat.VK_FORMAT_BC1_RGB_UNORM_BLOCK;
enum VK_FORMAT_BC1_RGB_SRGB_BLOCK                             = VkFormat.VK_FORMAT_BC1_RGB_SRGB_BLOCK;
enum VK_FORMAT_BC1_RGBA_UNORM_BLOCK                           = VkFormat.VK_FORMAT_BC1_RGBA_UNORM_BLOCK;
enum VK_FORMAT_BC1_RGBA_SRGB_BLOCK                            = VkFormat.VK_FORMAT_BC1_RGBA_SRGB_BLOCK;
enum VK_FORMAT_BC2_UNORM_BLOCK                                = VkFormat.VK_FORMAT_BC2_UNORM_BLOCK;
enum VK_FORMAT_BC2_SRGB_BLOCK                                 = VkFormat.VK_FORMAT_BC2_SRGB_BLOCK;
enum VK_FORMAT_BC3_UNORM_BLOCK                                = VkFormat.VK_FORMAT_BC3_UNORM_BLOCK;
enum VK_FORMAT_BC3_SRGB_BLOCK                                 = VkFormat.VK_FORMAT_BC3_SRGB_BLOCK;
enum VK_FORMAT_BC4_UNORM_BLOCK                                = VkFormat.VK_FORMAT_BC4_UNORM_BLOCK;
enum VK_FORMAT_BC4_SNORM_BLOCK                                = VkFormat.VK_FORMAT_BC4_SNORM_BLOCK;
enum VK_FORMAT_BC5_UNORM_BLOCK                                = VkFormat.VK_FORMAT_BC5_UNORM_BLOCK;
enum VK_FORMAT_BC5_SNORM_BLOCK                                = VkFormat.VK_FORMAT_BC5_SNORM_BLOCK;
enum VK_FORMAT_BC6H_UFLOAT_BLOCK                              = VkFormat.VK_FORMAT_BC6H_UFLOAT_BLOCK;
enum VK_FORMAT_BC6H_SFLOAT_BLOCK                              = VkFormat.VK_FORMAT_BC6H_SFLOAT_BLOCK;
enum VK_FORMAT_BC7_UNORM_BLOCK                                = VkFormat.VK_FORMAT_BC7_UNORM_BLOCK;
enum VK_FORMAT_BC7_SRGB_BLOCK                                 = VkFormat.VK_FORMAT_BC7_SRGB_BLOCK;
enum VK_FORMAT_ETC2_R8G8B8_UNORM_BLOCK                        = VkFormat.VK_FORMAT_ETC2_R8G8B8_UNORM_BLOCK;
enum VK_FORMAT_ETC2_R8G8B8_SRGB_BLOCK                         = VkFormat.VK_FORMAT_ETC2_R8G8B8_SRGB_BLOCK;
enum VK_FORMAT_ETC2_R8G8B8A1_UNORM_BLOCK                      = VkFormat.VK_FORMAT_ETC2_R8G8B8A1_UNORM_BLOCK;
enum VK_FORMAT_ETC2_R8G8B8A1_SRGB_BLOCK                       = VkFormat.VK_FORMAT_ETC2_R8G8B8A1_SRGB_BLOCK;
enum VK_FORMAT_ETC2_R8G8B8A8_UNORM_BLOCK                      = VkFormat.VK_FORMAT_ETC2_R8G8B8A8_UNORM_BLOCK;
enum VK_FORMAT_ETC2_R8G8B8A8_SRGB_BLOCK                       = VkFormat.VK_FORMAT_ETC2_R8G8B8A8_SRGB_BLOCK;
enum VK_FORMAT_EAC_R11_UNORM_BLOCK                            = VkFormat.VK_FORMAT_EAC_R11_UNORM_BLOCK;
enum VK_FORMAT_EAC_R11_SNORM_BLOCK                            = VkFormat.VK_FORMAT_EAC_R11_SNORM_BLOCK;
enum VK_FORMAT_EAC_R11G11_UNORM_BLOCK                         = VkFormat.VK_FORMAT_EAC_R11G11_UNORM_BLOCK;
enum VK_FORMAT_EAC_R11G11_SNORM_BLOCK                         = VkFormat.VK_FORMAT_EAC_R11G11_SNORM_BLOCK;
enum VK_FORMAT_ASTC_4x4_UNORM_BLOCK                           = VkFormat.VK_FORMAT_ASTC_4x4_UNORM_BLOCK;
enum VK_FORMAT_ASTC_4x4_SRGB_BLOCK                            = VkFormat.VK_FORMAT_ASTC_4x4_SRGB_BLOCK;
enum VK_FORMAT_ASTC_5x4_UNORM_BLOCK                           = VkFormat.VK_FORMAT_ASTC_5x4_UNORM_BLOCK;
enum VK_FORMAT_ASTC_5x4_SRGB_BLOCK                            = VkFormat.VK_FORMAT_ASTC_5x4_SRGB_BLOCK;
enum VK_FORMAT_ASTC_5x5_UNORM_BLOCK                           = VkFormat.VK_FORMAT_ASTC_5x5_UNORM_BLOCK;
enum VK_FORMAT_ASTC_5x5_SRGB_BLOCK                            = VkFormat.VK_FORMAT_ASTC_5x5_SRGB_BLOCK;
enum VK_FORMAT_ASTC_6x5_UNORM_BLOCK                           = VkFormat.VK_FORMAT_ASTC_6x5_UNORM_BLOCK;
enum VK_FORMAT_ASTC_6x5_SRGB_BLOCK                            = VkFormat.VK_FORMAT_ASTC_6x5_SRGB_BLOCK;
enum VK_FORMAT_ASTC_6x6_UNORM_BLOCK                           = VkFormat.VK_FORMAT_ASTC_6x6_UNORM_BLOCK;
enum VK_FORMAT_ASTC_6x6_SRGB_BLOCK                            = VkFormat.VK_FORMAT_ASTC_6x6_SRGB_BLOCK;
enum VK_FORMAT_ASTC_8x5_UNORM_BLOCK                           = VkFormat.VK_FORMAT_ASTC_8x5_UNORM_BLOCK;
enum VK_FORMAT_ASTC_8x5_SRGB_BLOCK                            = VkFormat.VK_FORMAT_ASTC_8x5_SRGB_BLOCK;
enum VK_FORMAT_ASTC_8x6_UNORM_BLOCK                           = VkFormat.VK_FORMAT_ASTC_8x6_UNORM_BLOCK;
enum VK_FORMAT_ASTC_8x6_SRGB_BLOCK                            = VkFormat.VK_FORMAT_ASTC_8x6_SRGB_BLOCK;
enum VK_FORMAT_ASTC_8x8_UNORM_BLOCK                           = VkFormat.VK_FORMAT_ASTC_8x8_UNORM_BLOCK;
enum VK_FORMAT_ASTC_8x8_SRGB_BLOCK                            = VkFormat.VK_FORMAT_ASTC_8x8_SRGB_BLOCK;
enum VK_FORMAT_ASTC_10x5_UNORM_BLOCK                          = VkFormat.VK_FORMAT_ASTC_10x5_UNORM_BLOCK;
enum VK_FORMAT_ASTC_10x5_SRGB_BLOCK                           = VkFormat.VK_FORMAT_ASTC_10x5_SRGB_BLOCK;
enum VK_FORMAT_ASTC_10x6_UNORM_BLOCK                          = VkFormat.VK_FORMAT_ASTC_10x6_UNORM_BLOCK;
enum VK_FORMAT_ASTC_10x6_SRGB_BLOCK                           = VkFormat.VK_FORMAT_ASTC_10x6_SRGB_BLOCK;
enum VK_FORMAT_ASTC_10x8_UNORM_BLOCK                          = VkFormat.VK_FORMAT_ASTC_10x8_UNORM_BLOCK;
enum VK_FORMAT_ASTC_10x8_SRGB_BLOCK                           = VkFormat.VK_FORMAT_ASTC_10x8_SRGB_BLOCK;
enum VK_FORMAT_ASTC_10x10_UNORM_BLOCK                         = VkFormat.VK_FORMAT_ASTC_10x10_UNORM_BLOCK;
enum VK_FORMAT_ASTC_10x10_SRGB_BLOCK                          = VkFormat.VK_FORMAT_ASTC_10x10_SRGB_BLOCK;
enum VK_FORMAT_ASTC_12x10_UNORM_BLOCK                         = VkFormat.VK_FORMAT_ASTC_12x10_UNORM_BLOCK;
enum VK_FORMAT_ASTC_12x10_SRGB_BLOCK                          = VkFormat.VK_FORMAT_ASTC_12x10_SRGB_BLOCK;
enum VK_FORMAT_ASTC_12x12_UNORM_BLOCK                         = VkFormat.VK_FORMAT_ASTC_12x12_UNORM_BLOCK;
enum VK_FORMAT_ASTC_12x12_SRGB_BLOCK                          = VkFormat.VK_FORMAT_ASTC_12x12_SRGB_BLOCK;
enum VK_FORMAT_G8B8G8R8_422_UNORM                             = VkFormat.VK_FORMAT_G8B8G8R8_422_UNORM;
enum VK_FORMAT_B8G8R8G8_422_UNORM                             = VkFormat.VK_FORMAT_B8G8R8G8_422_UNORM;
enum VK_FORMAT_G8_B8_R8_3PLANE_420_UNORM                      = VkFormat.VK_FORMAT_G8_B8_R8_3PLANE_420_UNORM;
enum VK_FORMAT_G8_B8R8_2PLANE_420_UNORM                       = VkFormat.VK_FORMAT_G8_B8R8_2PLANE_420_UNORM;
enum VK_FORMAT_G8_B8_R8_3PLANE_422_UNORM                      = VkFormat.VK_FORMAT_G8_B8_R8_3PLANE_422_UNORM;
enum VK_FORMAT_G8_B8R8_2PLANE_422_UNORM                       = VkFormat.VK_FORMAT_G8_B8R8_2PLANE_422_UNORM;
enum VK_FORMAT_G8_B8_R8_3PLANE_444_UNORM                      = VkFormat.VK_FORMAT_G8_B8_R8_3PLANE_444_UNORM;
enum VK_FORMAT_R10X6_UNORM_PACK16                             = VkFormat.VK_FORMAT_R10X6_UNORM_PACK16;
enum VK_FORMAT_R10X6G10X6_UNORM_2PACK16                       = VkFormat.VK_FORMAT_R10X6G10X6_UNORM_2PACK16;
enum VK_FORMAT_R10X6G10X6B10X6A10X6_UNORM_4PACK16             = VkFormat.VK_FORMAT_R10X6G10X6B10X6A10X6_UNORM_4PACK16;
enum VK_FORMAT_G10X6B10X6G10X6R10X6_422_UNORM_4PACK16         = VkFormat.VK_FORMAT_G10X6B10X6G10X6R10X6_422_UNORM_4PACK16;
enum VK_FORMAT_B10X6G10X6R10X6G10X6_422_UNORM_4PACK16         = VkFormat.VK_FORMAT_B10X6G10X6R10X6G10X6_422_UNORM_4PACK16;
enum VK_FORMAT_G10X6_B10X6_R10X6_3PLANE_420_UNORM_3PACK16     = VkFormat.VK_FORMAT_G10X6_B10X6_R10X6_3PLANE_420_UNORM_3PACK16;
enum VK_FORMAT_G10X6_B10X6R10X6_2PLANE_420_UNORM_3PACK16      = VkFormat.VK_FORMAT_G10X6_B10X6R10X6_2PLANE_420_UNORM_3PACK16;
enum VK_FORMAT_G10X6_B10X6_R10X6_3PLANE_422_UNORM_3PACK16     = VkFormat.VK_FORMAT_G10X6_B10X6_R10X6_3PLANE_422_UNORM_3PACK16;
enum VK_FORMAT_G10X6_B10X6R10X6_2PLANE_422_UNORM_3PACK16      = VkFormat.VK_FORMAT_G10X6_B10X6R10X6_2PLANE_422_UNORM_3PACK16;
enum VK_FORMAT_G10X6_B10X6_R10X6_3PLANE_444_UNORM_3PACK16     = VkFormat.VK_FORMAT_G10X6_B10X6_R10X6_3PLANE_444_UNORM_3PACK16;
enum VK_FORMAT_R12X4_UNORM_PACK16                             = VkFormat.VK_FORMAT_R12X4_UNORM_PACK16;
enum VK_FORMAT_R12X4G12X4_UNORM_2PACK16                       = VkFormat.VK_FORMAT_R12X4G12X4_UNORM_2PACK16;
enum VK_FORMAT_R12X4G12X4B12X4A12X4_UNORM_4PACK16             = VkFormat.VK_FORMAT_R12X4G12X4B12X4A12X4_UNORM_4PACK16;
enum VK_FORMAT_G12X4B12X4G12X4R12X4_422_UNORM_4PACK16         = VkFormat.VK_FORMAT_G12X4B12X4G12X4R12X4_422_UNORM_4PACK16;
enum VK_FORMAT_B12X4G12X4R12X4G12X4_422_UNORM_4PACK16         = VkFormat.VK_FORMAT_B12X4G12X4R12X4G12X4_422_UNORM_4PACK16;
enum VK_FORMAT_G12X4_B12X4_R12X4_3PLANE_420_UNORM_3PACK16     = VkFormat.VK_FORMAT_G12X4_B12X4_R12X4_3PLANE_420_UNORM_3PACK16;
enum VK_FORMAT_G12X4_B12X4R12X4_2PLANE_420_UNORM_3PACK16      = VkFormat.VK_FORMAT_G12X4_B12X4R12X4_2PLANE_420_UNORM_3PACK16;
enum VK_FORMAT_G12X4_B12X4_R12X4_3PLANE_422_UNORM_3PACK16     = VkFormat.VK_FORMAT_G12X4_B12X4_R12X4_3PLANE_422_UNORM_3PACK16;
enum VK_FORMAT_G12X4_B12X4R12X4_2PLANE_422_UNORM_3PACK16      = VkFormat.VK_FORMAT_G12X4_B12X4R12X4_2PLANE_422_UNORM_3PACK16;
enum VK_FORMAT_G12X4_B12X4_R12X4_3PLANE_444_UNORM_3PACK16     = VkFormat.VK_FORMAT_G12X4_B12X4_R12X4_3PLANE_444_UNORM_3PACK16;
enum VK_FORMAT_G16B16G16R16_422_UNORM                         = VkFormat.VK_FORMAT_G16B16G16R16_422_UNORM;
enum VK_FORMAT_B16G16R16G16_422_UNORM                         = VkFormat.VK_FORMAT_B16G16R16G16_422_UNORM;
enum VK_FORMAT_G16_B16_R16_3PLANE_420_UNORM                   = VkFormat.VK_FORMAT_G16_B16_R16_3PLANE_420_UNORM;
enum VK_FORMAT_G16_B16R16_2PLANE_420_UNORM                    = VkFormat.VK_FORMAT_G16_B16R16_2PLANE_420_UNORM;
enum VK_FORMAT_G16_B16_R16_3PLANE_422_UNORM                   = VkFormat.VK_FORMAT_G16_B16_R16_3PLANE_422_UNORM;
enum VK_FORMAT_G16_B16R16_2PLANE_422_UNORM                    = VkFormat.VK_FORMAT_G16_B16R16_2PLANE_422_UNORM;
enum VK_FORMAT_G16_B16_R16_3PLANE_444_UNORM                   = VkFormat.VK_FORMAT_G16_B16_R16_3PLANE_444_UNORM;
enum VK_FORMAT_PVRTC1_2BPP_UNORM_BLOCK_IMG                    = VkFormat.VK_FORMAT_PVRTC1_2BPP_UNORM_BLOCK_IMG;
enum VK_FORMAT_PVRTC1_4BPP_UNORM_BLOCK_IMG                    = VkFormat.VK_FORMAT_PVRTC1_4BPP_UNORM_BLOCK_IMG;
enum VK_FORMAT_PVRTC2_2BPP_UNORM_BLOCK_IMG                    = VkFormat.VK_FORMAT_PVRTC2_2BPP_UNORM_BLOCK_IMG;
enum VK_FORMAT_PVRTC2_4BPP_UNORM_BLOCK_IMG                    = VkFormat.VK_FORMAT_PVRTC2_4BPP_UNORM_BLOCK_IMG;
enum VK_FORMAT_PVRTC1_2BPP_SRGB_BLOCK_IMG                     = VkFormat.VK_FORMAT_PVRTC1_2BPP_SRGB_BLOCK_IMG;
enum VK_FORMAT_PVRTC1_4BPP_SRGB_BLOCK_IMG                     = VkFormat.VK_FORMAT_PVRTC1_4BPP_SRGB_BLOCK_IMG;
enum VK_FORMAT_PVRTC2_2BPP_SRGB_BLOCK_IMG                     = VkFormat.VK_FORMAT_PVRTC2_2BPP_SRGB_BLOCK_IMG;
enum VK_FORMAT_PVRTC2_4BPP_SRGB_BLOCK_IMG                     = VkFormat.VK_FORMAT_PVRTC2_4BPP_SRGB_BLOCK_IMG;
enum VK_FORMAT_G8B8G8R8_422_UNORM_KHR                         = VkFormat.VK_FORMAT_G8B8G8R8_422_UNORM_KHR;
enum VK_FORMAT_B8G8R8G8_422_UNORM_KHR                         = VkFormat.VK_FORMAT_B8G8R8G8_422_UNORM_KHR;
enum VK_FORMAT_G8_B8_R8_3PLANE_420_UNORM_KHR                  = VkFormat.VK_FORMAT_G8_B8_R8_3PLANE_420_UNORM_KHR;
enum VK_FORMAT_G8_B8R8_2PLANE_420_UNORM_KHR                   = VkFormat.VK_FORMAT_G8_B8R8_2PLANE_420_UNORM_KHR;
enum VK_FORMAT_G8_B8_R8_3PLANE_422_UNORM_KHR                  = VkFormat.VK_FORMAT_G8_B8_R8_3PLANE_422_UNORM_KHR;
enum VK_FORMAT_G8_B8R8_2PLANE_422_UNORM_KHR                   = VkFormat.VK_FORMAT_G8_B8R8_2PLANE_422_UNORM_KHR;
enum VK_FORMAT_G8_B8_R8_3PLANE_444_UNORM_KHR                  = VkFormat.VK_FORMAT_G8_B8_R8_3PLANE_444_UNORM_KHR;
enum VK_FORMAT_R10X6_UNORM_PACK16_KHR                         = VkFormat.VK_FORMAT_R10X6_UNORM_PACK16_KHR;
enum VK_FORMAT_R10X6G10X6_UNORM_2PACK16_KHR                   = VkFormat.VK_FORMAT_R10X6G10X6_UNORM_2PACK16_KHR;
enum VK_FORMAT_R10X6G10X6B10X6A10X6_UNORM_4PACK16_KHR         = VkFormat.VK_FORMAT_R10X6G10X6B10X6A10X6_UNORM_4PACK16_KHR;
enum VK_FORMAT_G10X6B10X6G10X6R10X6_422_UNORM_4PACK16_KHR     = VkFormat.VK_FORMAT_G10X6B10X6G10X6R10X6_422_UNORM_4PACK16_KHR;
enum VK_FORMAT_B10X6G10X6R10X6G10X6_422_UNORM_4PACK16_KHR     = VkFormat.VK_FORMAT_B10X6G10X6R10X6G10X6_422_UNORM_4PACK16_KHR;
enum VK_FORMAT_G10X6_B10X6_R10X6_3PLANE_420_UNORM_3PACK16_KHR = VkFormat.VK_FORMAT_G10X6_B10X6_R10X6_3PLANE_420_UNORM_3PACK16_KHR;
enum VK_FORMAT_G10X6_B10X6R10X6_2PLANE_420_UNORM_3PACK16_KHR  = VkFormat.VK_FORMAT_G10X6_B10X6R10X6_2PLANE_420_UNORM_3PACK16_KHR;
enum VK_FORMAT_G10X6_B10X6_R10X6_3PLANE_422_UNORM_3PACK16_KHR = VkFormat.VK_FORMAT_G10X6_B10X6_R10X6_3PLANE_422_UNORM_3PACK16_KHR;
enum VK_FORMAT_G10X6_B10X6R10X6_2PLANE_422_UNORM_3PACK16_KHR  = VkFormat.VK_FORMAT_G10X6_B10X6R10X6_2PLANE_422_UNORM_3PACK16_KHR;
enum VK_FORMAT_G10X6_B10X6_R10X6_3PLANE_444_UNORM_3PACK16_KHR = VkFormat.VK_FORMAT_G10X6_B10X6_R10X6_3PLANE_444_UNORM_3PACK16_KHR;
enum VK_FORMAT_R12X4_UNORM_PACK16_KHR                         = VkFormat.VK_FORMAT_R12X4_UNORM_PACK16_KHR;
enum VK_FORMAT_R12X4G12X4_UNORM_2PACK16_KHR                   = VkFormat.VK_FORMAT_R12X4G12X4_UNORM_2PACK16_KHR;
enum VK_FORMAT_R12X4G12X4B12X4A12X4_UNORM_4PACK16_KHR         = VkFormat.VK_FORMAT_R12X4G12X4B12X4A12X4_UNORM_4PACK16_KHR;
enum VK_FORMAT_G12X4B12X4G12X4R12X4_422_UNORM_4PACK16_KHR     = VkFormat.VK_FORMAT_G12X4B12X4G12X4R12X4_422_UNORM_4PACK16_KHR;
enum VK_FORMAT_B12X4G12X4R12X4G12X4_422_UNORM_4PACK16_KHR     = VkFormat.VK_FORMAT_B12X4G12X4R12X4G12X4_422_UNORM_4PACK16_KHR;
enum VK_FORMAT_G12X4_B12X4_R12X4_3PLANE_420_UNORM_3PACK16_KHR = VkFormat.VK_FORMAT_G12X4_B12X4_R12X4_3PLANE_420_UNORM_3PACK16_KHR;
enum VK_FORMAT_G12X4_B12X4R12X4_2PLANE_420_UNORM_3PACK16_KHR  = VkFormat.VK_FORMAT_G12X4_B12X4R12X4_2PLANE_420_UNORM_3PACK16_KHR;
enum VK_FORMAT_G12X4_B12X4_R12X4_3PLANE_422_UNORM_3PACK16_KHR = VkFormat.VK_FORMAT_G12X4_B12X4_R12X4_3PLANE_422_UNORM_3PACK16_KHR;
enum VK_FORMAT_G12X4_B12X4R12X4_2PLANE_422_UNORM_3PACK16_KHR  = VkFormat.VK_FORMAT_G12X4_B12X4R12X4_2PLANE_422_UNORM_3PACK16_KHR;
enum VK_FORMAT_G12X4_B12X4_R12X4_3PLANE_444_UNORM_3PACK16_KHR = VkFormat.VK_FORMAT_G12X4_B12X4_R12X4_3PLANE_444_UNORM_3PACK16_KHR;
enum VK_FORMAT_G16B16G16R16_422_UNORM_KHR                     = VkFormat.VK_FORMAT_G16B16G16R16_422_UNORM_KHR;
enum VK_FORMAT_B16G16R16G16_422_UNORM_KHR                     = VkFormat.VK_FORMAT_B16G16R16G16_422_UNORM_KHR;
enum VK_FORMAT_G16_B16_R16_3PLANE_420_UNORM_KHR               = VkFormat.VK_FORMAT_G16_B16_R16_3PLANE_420_UNORM_KHR;
enum VK_FORMAT_G16_B16R16_2PLANE_420_UNORM_KHR                = VkFormat.VK_FORMAT_G16_B16R16_2PLANE_420_UNORM_KHR;
enum VK_FORMAT_G16_B16_R16_3PLANE_422_UNORM_KHR               = VkFormat.VK_FORMAT_G16_B16_R16_3PLANE_422_UNORM_KHR;
enum VK_FORMAT_G16_B16R16_2PLANE_422_UNORM_KHR                = VkFormat.VK_FORMAT_G16_B16R16_2PLANE_422_UNORM_KHR;
enum VK_FORMAT_G16_B16_R16_3PLANE_444_UNORM_KHR               = VkFormat.VK_FORMAT_G16_B16_R16_3PLANE_444_UNORM_KHR;

enum VkFormatFeatureFlagBits : VkFlags {
    VK_FORMAT_FEATURE_SAMPLED_IMAGE_BIT                                                               = 0x00000001,
    VK_FORMAT_FEATURE_STORAGE_IMAGE_BIT                                                               = 0x00000002,
    VK_FORMAT_FEATURE_STORAGE_IMAGE_ATOMIC_BIT                                                        = 0x00000004,
    VK_FORMAT_FEATURE_UNIFORM_TEXEL_BUFFER_BIT                                                        = 0x00000008,
    VK_FORMAT_FEATURE_STORAGE_TEXEL_BUFFER_BIT                                                        = 0x00000010,
    VK_FORMAT_FEATURE_STORAGE_TEXEL_BUFFER_ATOMIC_BIT                                                 = 0x00000020,
    VK_FORMAT_FEATURE_VERTEX_BUFFER_BIT                                                               = 0x00000040,
    VK_FORMAT_FEATURE_COLOR_ATTACHMENT_BIT                                                            = 0x00000080,
    VK_FORMAT_FEATURE_COLOR_ATTACHMENT_BLEND_BIT                                                      = 0x00000100,
    VK_FORMAT_FEATURE_DEPTH_STENCIL_ATTACHMENT_BIT                                                    = 0x00000200,
    VK_FORMAT_FEATURE_BLIT_SRC_BIT                                                                    = 0x00000400,
    VK_FORMAT_FEATURE_BLIT_DST_BIT                                                                    = 0x00000800,
    VK_FORMAT_FEATURE_SAMPLED_IMAGE_FILTER_LINEAR_BIT                                                 = 0x00001000,
    VK_FORMAT_FEATURE_TRANSFER_SRC_BIT                                                                = 0x00004000,
    VK_FORMAT_FEATURE_TRANSFER_DST_BIT                                                                = 0x00008000,
    VK_FORMAT_FEATURE_MIDPOINT_CHROMA_SAMPLES_BIT                                                     = 0x00020000,
    VK_FORMAT_FEATURE_SAMPLED_IMAGE_YCBCR_CONVERSION_LINEAR_FILTER_BIT                                = 0x00040000,
    VK_FORMAT_FEATURE_SAMPLED_IMAGE_YCBCR_CONVERSION_SEPARATE_RECONSTRUCTION_FILTER_BIT               = 0x00080000,
    VK_FORMAT_FEATURE_SAMPLED_IMAGE_YCBCR_CONVERSION_CHROMA_RECONSTRUCTION_EXPLICIT_BIT               = 0x00100000,
    VK_FORMAT_FEATURE_SAMPLED_IMAGE_YCBCR_CONVERSION_CHROMA_RECONSTRUCTION_EXPLICIT_FORCEABLE_BIT     = 0x00200000,
    VK_FORMAT_FEATURE_DISJOINT_BIT                                                                    = 0x00400000,
    VK_FORMAT_FEATURE_COSITED_CHROMA_SAMPLES_BIT                                                      = 0x00800000,
    VK_FORMAT_FEATURE_SAMPLED_IMAGE_FILTER_CUBIC_BIT_IMG                                              = 0x00002000,
    VK_FORMAT_FEATURE_RESERVED_27_BIT_KHR                                                             = 0x08000000,
    VK_FORMAT_FEATURE_RESERVED_28_BIT_KHR                                                             = 0x10000000,
    VK_FORMAT_FEATURE_RESERVED_25_BIT_KHR                                                             = 0x02000000,
    VK_FORMAT_FEATURE_RESERVED_26_BIT_KHR                                                             = 0x04000000,
    VK_FORMAT_FEATURE_TRANSFER_SRC_BIT_KHR                                                            = VK_FORMAT_FEATURE_TRANSFER_SRC_BIT,
    VK_FORMAT_FEATURE_TRANSFER_DST_BIT_KHR                                                            = VK_FORMAT_FEATURE_TRANSFER_DST_BIT,
    VK_FORMAT_FEATURE_SAMPLED_IMAGE_FILTER_MINMAX_BIT_EXT                                             = 0x00010000,
    VK_FORMAT_FEATURE_MIDPOINT_CHROMA_SAMPLES_BIT_KHR                                                 = VK_FORMAT_FEATURE_MIDPOINT_CHROMA_SAMPLES_BIT,
    VK_FORMAT_FEATURE_SAMPLED_IMAGE_YCBCR_CONVERSION_LINEAR_FILTER_BIT_KHR                            = VK_FORMAT_FEATURE_SAMPLED_IMAGE_YCBCR_CONVERSION_LINEAR_FILTER_BIT,
    VK_FORMAT_FEATURE_SAMPLED_IMAGE_YCBCR_CONVERSION_SEPARATE_RECONSTRUCTION_FILTER_BIT_KHR           = VK_FORMAT_FEATURE_SAMPLED_IMAGE_YCBCR_CONVERSION_SEPARATE_RECONSTRUCTION_FILTER_BIT,
    VK_FORMAT_FEATURE_SAMPLED_IMAGE_YCBCR_CONVERSION_CHROMA_RECONSTRUCTION_EXPLICIT_BIT_KHR           = VK_FORMAT_FEATURE_SAMPLED_IMAGE_YCBCR_CONVERSION_CHROMA_RECONSTRUCTION_EXPLICIT_BIT,
    VK_FORMAT_FEATURE_SAMPLED_IMAGE_YCBCR_CONVERSION_CHROMA_RECONSTRUCTION_EXPLICIT_FORCEABLE_BIT_KHR = VK_FORMAT_FEATURE_SAMPLED_IMAGE_YCBCR_CONVERSION_CHROMA_RECONSTRUCTION_EXPLICIT_FORCEABLE_BIT,
    VK_FORMAT_FEATURE_DISJOINT_BIT_KHR                                                                = VK_FORMAT_FEATURE_DISJOINT_BIT,
    VK_FORMAT_FEATURE_COSITED_CHROMA_SAMPLES_BIT_KHR                                                  = VK_FORMAT_FEATURE_COSITED_CHROMA_SAMPLES_BIT,
    VK_FORMAT_FEATURE_FRAGMENT_DENSITY_MAP_BIT_EXT                                                    = 0x01000000,
}
enum VK_FORMAT_FEATURE_SAMPLED_IMAGE_BIT                                                               = VkFormatFeatureFlagBits.VK_FORMAT_FEATURE_SAMPLED_IMAGE_BIT;
enum VK_FORMAT_FEATURE_STORAGE_IMAGE_BIT                                                               = VkFormatFeatureFlagBits.VK_FORMAT_FEATURE_STORAGE_IMAGE_BIT;
enum VK_FORMAT_FEATURE_STORAGE_IMAGE_ATOMIC_BIT                                                        = VkFormatFeatureFlagBits.VK_FORMAT_FEATURE_STORAGE_IMAGE_ATOMIC_BIT;
enum VK_FORMAT_FEATURE_UNIFORM_TEXEL_BUFFER_BIT                                                        = VkFormatFeatureFlagBits.VK_FORMAT_FEATURE_UNIFORM_TEXEL_BUFFER_BIT;
enum VK_FORMAT_FEATURE_STORAGE_TEXEL_BUFFER_BIT                                                        = VkFormatFeatureFlagBits.VK_FORMAT_FEATURE_STORAGE_TEXEL_BUFFER_BIT;
enum VK_FORMAT_FEATURE_STORAGE_TEXEL_BUFFER_ATOMIC_BIT                                                 = VkFormatFeatureFlagBits.VK_FORMAT_FEATURE_STORAGE_TEXEL_BUFFER_ATOMIC_BIT;
enum VK_FORMAT_FEATURE_VERTEX_BUFFER_BIT                                                               = VkFormatFeatureFlagBits.VK_FORMAT_FEATURE_VERTEX_BUFFER_BIT;
enum VK_FORMAT_FEATURE_COLOR_ATTACHMENT_BIT                                                            = VkFormatFeatureFlagBits.VK_FORMAT_FEATURE_COLOR_ATTACHMENT_BIT;
enum VK_FORMAT_FEATURE_COLOR_ATTACHMENT_BLEND_BIT                                                      = VkFormatFeatureFlagBits.VK_FORMAT_FEATURE_COLOR_ATTACHMENT_BLEND_BIT;
enum VK_FORMAT_FEATURE_DEPTH_STENCIL_ATTACHMENT_BIT                                                    = VkFormatFeatureFlagBits.VK_FORMAT_FEATURE_DEPTH_STENCIL_ATTACHMENT_BIT;
enum VK_FORMAT_FEATURE_BLIT_SRC_BIT                                                                    = VkFormatFeatureFlagBits.VK_FORMAT_FEATURE_BLIT_SRC_BIT;
enum VK_FORMAT_FEATURE_BLIT_DST_BIT                                                                    = VkFormatFeatureFlagBits.VK_FORMAT_FEATURE_BLIT_DST_BIT;
enum VK_FORMAT_FEATURE_SAMPLED_IMAGE_FILTER_LINEAR_BIT                                                 = VkFormatFeatureFlagBits.VK_FORMAT_FEATURE_SAMPLED_IMAGE_FILTER_LINEAR_BIT;
enum VK_FORMAT_FEATURE_TRANSFER_SRC_BIT                                                                = VkFormatFeatureFlagBits.VK_FORMAT_FEATURE_TRANSFER_SRC_BIT;
enum VK_FORMAT_FEATURE_TRANSFER_DST_BIT                                                                = VkFormatFeatureFlagBits.VK_FORMAT_FEATURE_TRANSFER_DST_BIT;
enum VK_FORMAT_FEATURE_MIDPOINT_CHROMA_SAMPLES_BIT                                                     = VkFormatFeatureFlagBits.VK_FORMAT_FEATURE_MIDPOINT_CHROMA_SAMPLES_BIT;
enum VK_FORMAT_FEATURE_SAMPLED_IMAGE_YCBCR_CONVERSION_LINEAR_FILTER_BIT                                = VkFormatFeatureFlagBits.VK_FORMAT_FEATURE_SAMPLED_IMAGE_YCBCR_CONVERSION_LINEAR_FILTER_BIT;
enum VK_FORMAT_FEATURE_SAMPLED_IMAGE_YCBCR_CONVERSION_SEPARATE_RECONSTRUCTION_FILTER_BIT               = VkFormatFeatureFlagBits.VK_FORMAT_FEATURE_SAMPLED_IMAGE_YCBCR_CONVERSION_SEPARATE_RECONSTRUCTION_FILTER_BIT;
enum VK_FORMAT_FEATURE_SAMPLED_IMAGE_YCBCR_CONVERSION_CHROMA_RECONSTRUCTION_EXPLICIT_BIT               = VkFormatFeatureFlagBits.VK_FORMAT_FEATURE_SAMPLED_IMAGE_YCBCR_CONVERSION_CHROMA_RECONSTRUCTION_EXPLICIT_BIT;
enum VK_FORMAT_FEATURE_SAMPLED_IMAGE_YCBCR_CONVERSION_CHROMA_RECONSTRUCTION_EXPLICIT_FORCEABLE_BIT     = VkFormatFeatureFlagBits.VK_FORMAT_FEATURE_SAMPLED_IMAGE_YCBCR_CONVERSION_CHROMA_RECONSTRUCTION_EXPLICIT_FORCEABLE_BIT;
enum VK_FORMAT_FEATURE_DISJOINT_BIT                                                                    = VkFormatFeatureFlagBits.VK_FORMAT_FEATURE_DISJOINT_BIT;
enum VK_FORMAT_FEATURE_COSITED_CHROMA_SAMPLES_BIT                                                      = VkFormatFeatureFlagBits.VK_FORMAT_FEATURE_COSITED_CHROMA_SAMPLES_BIT;
enum VK_FORMAT_FEATURE_SAMPLED_IMAGE_FILTER_CUBIC_BIT_IMG                                              = VkFormatFeatureFlagBits.VK_FORMAT_FEATURE_SAMPLED_IMAGE_FILTER_CUBIC_BIT_IMG;
enum VK_FORMAT_FEATURE_RESERVED_27_BIT_KHR                                                             = VkFormatFeatureFlagBits.VK_FORMAT_FEATURE_RESERVED_27_BIT_KHR;
enum VK_FORMAT_FEATURE_RESERVED_28_BIT_KHR                                                             = VkFormatFeatureFlagBits.VK_FORMAT_FEATURE_RESERVED_28_BIT_KHR;
enum VK_FORMAT_FEATURE_RESERVED_25_BIT_KHR                                                             = VkFormatFeatureFlagBits.VK_FORMAT_FEATURE_RESERVED_25_BIT_KHR;
enum VK_FORMAT_FEATURE_RESERVED_26_BIT_KHR                                                             = VkFormatFeatureFlagBits.VK_FORMAT_FEATURE_RESERVED_26_BIT_KHR;
enum VK_FORMAT_FEATURE_TRANSFER_SRC_BIT_KHR                                                            = VkFormatFeatureFlagBits.VK_FORMAT_FEATURE_TRANSFER_SRC_BIT_KHR;
enum VK_FORMAT_FEATURE_TRANSFER_DST_BIT_KHR                                                            = VkFormatFeatureFlagBits.VK_FORMAT_FEATURE_TRANSFER_DST_BIT_KHR;
enum VK_FORMAT_FEATURE_SAMPLED_IMAGE_FILTER_MINMAX_BIT_EXT                                             = VkFormatFeatureFlagBits.VK_FORMAT_FEATURE_SAMPLED_IMAGE_FILTER_MINMAX_BIT_EXT;
enum VK_FORMAT_FEATURE_MIDPOINT_CHROMA_SAMPLES_BIT_KHR                                                 = VkFormatFeatureFlagBits.VK_FORMAT_FEATURE_MIDPOINT_CHROMA_SAMPLES_BIT_KHR;
enum VK_FORMAT_FEATURE_SAMPLED_IMAGE_YCBCR_CONVERSION_LINEAR_FILTER_BIT_KHR                            = VkFormatFeatureFlagBits.VK_FORMAT_FEATURE_SAMPLED_IMAGE_YCBCR_CONVERSION_LINEAR_FILTER_BIT_KHR;
enum VK_FORMAT_FEATURE_SAMPLED_IMAGE_YCBCR_CONVERSION_SEPARATE_RECONSTRUCTION_FILTER_BIT_KHR           = VkFormatFeatureFlagBits.VK_FORMAT_FEATURE_SAMPLED_IMAGE_YCBCR_CONVERSION_SEPARATE_RECONSTRUCTION_FILTER_BIT_KHR;
enum VK_FORMAT_FEATURE_SAMPLED_IMAGE_YCBCR_CONVERSION_CHROMA_RECONSTRUCTION_EXPLICIT_BIT_KHR           = VkFormatFeatureFlagBits.VK_FORMAT_FEATURE_SAMPLED_IMAGE_YCBCR_CONVERSION_CHROMA_RECONSTRUCTION_EXPLICIT_BIT_KHR;
enum VK_FORMAT_FEATURE_SAMPLED_IMAGE_YCBCR_CONVERSION_CHROMA_RECONSTRUCTION_EXPLICIT_FORCEABLE_BIT_KHR = VkFormatFeatureFlagBits.VK_FORMAT_FEATURE_SAMPLED_IMAGE_YCBCR_CONVERSION_CHROMA_RECONSTRUCTION_EXPLICIT_FORCEABLE_BIT_KHR;
enum VK_FORMAT_FEATURE_DISJOINT_BIT_KHR                                                                = VkFormatFeatureFlagBits.VK_FORMAT_FEATURE_DISJOINT_BIT_KHR;
enum VK_FORMAT_FEATURE_COSITED_CHROMA_SAMPLES_BIT_KHR                                                  = VkFormatFeatureFlagBits.VK_FORMAT_FEATURE_COSITED_CHROMA_SAMPLES_BIT_KHR;
enum VK_FORMAT_FEATURE_FRAGMENT_DENSITY_MAP_BIT_EXT                                                    = VkFormatFeatureFlagBits.VK_FORMAT_FEATURE_FRAGMENT_DENSITY_MAP_BIT_EXT;

enum VkImageType {
    VK_IMAGE_TYPE_1D = 0,
    VK_IMAGE_TYPE_2D = 1,
    VK_IMAGE_TYPE_3D = 2,
}
enum VK_IMAGE_TYPE_1D = VkImageType.VK_IMAGE_TYPE_1D;
enum VK_IMAGE_TYPE_2D = VkImageType.VK_IMAGE_TYPE_2D;
enum VK_IMAGE_TYPE_3D = VkImageType.VK_IMAGE_TYPE_3D;

enum VkImageTiling {
    VK_IMAGE_TILING_OPTIMAL                 = 0,
    VK_IMAGE_TILING_LINEAR                  = 1,
    VK_IMAGE_TILING_DRM_FORMAT_MODIFIER_EXT = 1000158000,
}
enum VK_IMAGE_TILING_OPTIMAL                 = VkImageTiling.VK_IMAGE_TILING_OPTIMAL;
enum VK_IMAGE_TILING_LINEAR                  = VkImageTiling.VK_IMAGE_TILING_LINEAR;
enum VK_IMAGE_TILING_DRM_FORMAT_MODIFIER_EXT = VkImageTiling.VK_IMAGE_TILING_DRM_FORMAT_MODIFIER_EXT;

enum VkImageUsageFlagBits : VkFlags {
    VK_IMAGE_USAGE_TRANSFER_SRC_BIT             = 0x00000001,
    VK_IMAGE_USAGE_TRANSFER_DST_BIT             = 0x00000002,
    VK_IMAGE_USAGE_SAMPLED_BIT                  = 0x00000004,
    VK_IMAGE_USAGE_STORAGE_BIT                  = 0x00000008,
    VK_IMAGE_USAGE_COLOR_ATTACHMENT_BIT         = 0x00000010,
    VK_IMAGE_USAGE_DEPTH_STENCIL_ATTACHMENT_BIT = 0x00000020,
    VK_IMAGE_USAGE_TRANSIENT_ATTACHMENT_BIT     = 0x00000040,
    VK_IMAGE_USAGE_INPUT_ATTACHMENT_BIT         = 0x00000080,
    VK_IMAGE_USAGE_RESERVED_13_BIT_KHR          = 0x00002000,
    VK_IMAGE_USAGE_RESERVED_14_BIT_KHR          = 0x00004000,
    VK_IMAGE_USAGE_RESERVED_15_BIT_KHR          = 0x00008000,
    VK_IMAGE_USAGE_RESERVED_10_BIT_KHR          = 0x00000400,
    VK_IMAGE_USAGE_RESERVED_11_BIT_KHR          = 0x00000800,
    VK_IMAGE_USAGE_RESERVED_12_BIT_KHR          = 0x00001000,
    VK_IMAGE_USAGE_SHADING_RATE_IMAGE_BIT_NV    = 0x00000100,
    VK_IMAGE_USAGE_FRAGMENT_DENSITY_MAP_BIT_EXT = 0x00000200,
}
enum VK_IMAGE_USAGE_TRANSFER_SRC_BIT             = VkImageUsageFlagBits.VK_IMAGE_USAGE_TRANSFER_SRC_BIT;
enum VK_IMAGE_USAGE_TRANSFER_DST_BIT             = VkImageUsageFlagBits.VK_IMAGE_USAGE_TRANSFER_DST_BIT;
enum VK_IMAGE_USAGE_SAMPLED_BIT                  = VkImageUsageFlagBits.VK_IMAGE_USAGE_SAMPLED_BIT;
enum VK_IMAGE_USAGE_STORAGE_BIT                  = VkImageUsageFlagBits.VK_IMAGE_USAGE_STORAGE_BIT;
enum VK_IMAGE_USAGE_COLOR_ATTACHMENT_BIT         = VkImageUsageFlagBits.VK_IMAGE_USAGE_COLOR_ATTACHMENT_BIT;
enum VK_IMAGE_USAGE_DEPTH_STENCIL_ATTACHMENT_BIT = VkImageUsageFlagBits.VK_IMAGE_USAGE_DEPTH_STENCIL_ATTACHMENT_BIT;
enum VK_IMAGE_USAGE_TRANSIENT_ATTACHMENT_BIT     = VkImageUsageFlagBits.VK_IMAGE_USAGE_TRANSIENT_ATTACHMENT_BIT;
enum VK_IMAGE_USAGE_INPUT_ATTACHMENT_BIT         = VkImageUsageFlagBits.VK_IMAGE_USAGE_INPUT_ATTACHMENT_BIT;
enum VK_IMAGE_USAGE_RESERVED_13_BIT_KHR          = VkImageUsageFlagBits.VK_IMAGE_USAGE_RESERVED_13_BIT_KHR;
enum VK_IMAGE_USAGE_RESERVED_14_BIT_KHR          = VkImageUsageFlagBits.VK_IMAGE_USAGE_RESERVED_14_BIT_KHR;
enum VK_IMAGE_USAGE_RESERVED_15_BIT_KHR          = VkImageUsageFlagBits.VK_IMAGE_USAGE_RESERVED_15_BIT_KHR;
enum VK_IMAGE_USAGE_RESERVED_10_BIT_KHR          = VkImageUsageFlagBits.VK_IMAGE_USAGE_RESERVED_10_BIT_KHR;
enum VK_IMAGE_USAGE_RESERVED_11_BIT_KHR          = VkImageUsageFlagBits.VK_IMAGE_USAGE_RESERVED_11_BIT_KHR;
enum VK_IMAGE_USAGE_RESERVED_12_BIT_KHR          = VkImageUsageFlagBits.VK_IMAGE_USAGE_RESERVED_12_BIT_KHR;
enum VK_IMAGE_USAGE_SHADING_RATE_IMAGE_BIT_NV    = VkImageUsageFlagBits.VK_IMAGE_USAGE_SHADING_RATE_IMAGE_BIT_NV;
enum VK_IMAGE_USAGE_FRAGMENT_DENSITY_MAP_BIT_EXT = VkImageUsageFlagBits.VK_IMAGE_USAGE_FRAGMENT_DENSITY_MAP_BIT_EXT;

enum VkImageCreateFlagBits : VkFlags {
    VK_IMAGE_CREATE_SPARSE_BINDING_BIT                        = 0x00000001,
    VK_IMAGE_CREATE_SPARSE_RESIDENCY_BIT                      = 0x00000002,
    VK_IMAGE_CREATE_SPARSE_ALIASED_BIT                        = 0x00000004,
    VK_IMAGE_CREATE_MUTABLE_FORMAT_BIT                        = 0x00000008,
    VK_IMAGE_CREATE_CUBE_COMPATIBLE_BIT                       = 0x00000010,
    VK_IMAGE_CREATE_ALIAS_BIT                                 = 0x00000400,
    VK_IMAGE_CREATE_SPLIT_INSTANCE_BIND_REGIONS_BIT           = 0x00000040,
    VK_IMAGE_CREATE_2D_ARRAY_COMPATIBLE_BIT                   = 0x00000020,
    VK_IMAGE_CREATE_BLOCK_TEXEL_VIEW_COMPATIBLE_BIT           = 0x00000080,
    VK_IMAGE_CREATE_EXTENDED_USAGE_BIT                        = 0x00000100,
    VK_IMAGE_CREATE_PROTECTED_BIT                             = 0x00000800,
    VK_IMAGE_CREATE_DISJOINT_BIT                              = 0x00000200,
    VK_IMAGE_CREATE_CORNER_SAMPLED_BIT_NV                     = 0x00002000,
    VK_IMAGE_CREATE_SPLIT_INSTANCE_BIND_REGIONS_BIT_KHR       = VK_IMAGE_CREATE_SPLIT_INSTANCE_BIND_REGIONS_BIT,
    VK_IMAGE_CREATE_2D_ARRAY_COMPATIBLE_BIT_KHR               = VK_IMAGE_CREATE_2D_ARRAY_COMPATIBLE_BIT,
    VK_IMAGE_CREATE_BLOCK_TEXEL_VIEW_COMPATIBLE_BIT_KHR       = VK_IMAGE_CREATE_BLOCK_TEXEL_VIEW_COMPATIBLE_BIT,
    VK_IMAGE_CREATE_EXTENDED_USAGE_BIT_KHR                    = VK_IMAGE_CREATE_EXTENDED_USAGE_BIT,
    VK_IMAGE_CREATE_SAMPLE_LOCATIONS_COMPATIBLE_DEPTH_BIT_EXT = 0x00001000,
    VK_IMAGE_CREATE_DISJOINT_BIT_KHR                          = VK_IMAGE_CREATE_DISJOINT_BIT,
    VK_IMAGE_CREATE_ALIAS_BIT_KHR                             = VK_IMAGE_CREATE_ALIAS_BIT,
    VK_IMAGE_CREATE_SUBSAMPLED_BIT_EXT                        = 0x00004000,
}
enum VK_IMAGE_CREATE_SPARSE_BINDING_BIT                        = VkImageCreateFlagBits.VK_IMAGE_CREATE_SPARSE_BINDING_BIT;
enum VK_IMAGE_CREATE_SPARSE_RESIDENCY_BIT                      = VkImageCreateFlagBits.VK_IMAGE_CREATE_SPARSE_RESIDENCY_BIT;
enum VK_IMAGE_CREATE_SPARSE_ALIASED_BIT                        = VkImageCreateFlagBits.VK_IMAGE_CREATE_SPARSE_ALIASED_BIT;
enum VK_IMAGE_CREATE_MUTABLE_FORMAT_BIT                        = VkImageCreateFlagBits.VK_IMAGE_CREATE_MUTABLE_FORMAT_BIT;
enum VK_IMAGE_CREATE_CUBE_COMPATIBLE_BIT                       = VkImageCreateFlagBits.VK_IMAGE_CREATE_CUBE_COMPATIBLE_BIT;
enum VK_IMAGE_CREATE_ALIAS_BIT                                 = VkImageCreateFlagBits.VK_IMAGE_CREATE_ALIAS_BIT;
enum VK_IMAGE_CREATE_SPLIT_INSTANCE_BIND_REGIONS_BIT           = VkImageCreateFlagBits.VK_IMAGE_CREATE_SPLIT_INSTANCE_BIND_REGIONS_BIT;
enum VK_IMAGE_CREATE_2D_ARRAY_COMPATIBLE_BIT                   = VkImageCreateFlagBits.VK_IMAGE_CREATE_2D_ARRAY_COMPATIBLE_BIT;
enum VK_IMAGE_CREATE_BLOCK_TEXEL_VIEW_COMPATIBLE_BIT           = VkImageCreateFlagBits.VK_IMAGE_CREATE_BLOCK_TEXEL_VIEW_COMPATIBLE_BIT;
enum VK_IMAGE_CREATE_EXTENDED_USAGE_BIT                        = VkImageCreateFlagBits.VK_IMAGE_CREATE_EXTENDED_USAGE_BIT;
enum VK_IMAGE_CREATE_PROTECTED_BIT                             = VkImageCreateFlagBits.VK_IMAGE_CREATE_PROTECTED_BIT;
enum VK_IMAGE_CREATE_DISJOINT_BIT                              = VkImageCreateFlagBits.VK_IMAGE_CREATE_DISJOINT_BIT;
enum VK_IMAGE_CREATE_CORNER_SAMPLED_BIT_NV                     = VkImageCreateFlagBits.VK_IMAGE_CREATE_CORNER_SAMPLED_BIT_NV;
enum VK_IMAGE_CREATE_SPLIT_INSTANCE_BIND_REGIONS_BIT_KHR       = VkImageCreateFlagBits.VK_IMAGE_CREATE_SPLIT_INSTANCE_BIND_REGIONS_BIT_KHR;
enum VK_IMAGE_CREATE_2D_ARRAY_COMPATIBLE_BIT_KHR               = VkImageCreateFlagBits.VK_IMAGE_CREATE_2D_ARRAY_COMPATIBLE_BIT_KHR;
enum VK_IMAGE_CREATE_BLOCK_TEXEL_VIEW_COMPATIBLE_BIT_KHR       = VkImageCreateFlagBits.VK_IMAGE_CREATE_BLOCK_TEXEL_VIEW_COMPATIBLE_BIT_KHR;
enum VK_IMAGE_CREATE_EXTENDED_USAGE_BIT_KHR                    = VkImageCreateFlagBits.VK_IMAGE_CREATE_EXTENDED_USAGE_BIT_KHR;
enum VK_IMAGE_CREATE_SAMPLE_LOCATIONS_COMPATIBLE_DEPTH_BIT_EXT = VkImageCreateFlagBits.VK_IMAGE_CREATE_SAMPLE_LOCATIONS_COMPATIBLE_DEPTH_BIT_EXT;
enum VK_IMAGE_CREATE_DISJOINT_BIT_KHR                          = VkImageCreateFlagBits.VK_IMAGE_CREATE_DISJOINT_BIT_KHR;
enum VK_IMAGE_CREATE_ALIAS_BIT_KHR                             = VkImageCreateFlagBits.VK_IMAGE_CREATE_ALIAS_BIT_KHR;
enum VK_IMAGE_CREATE_SUBSAMPLED_BIT_EXT                        = VkImageCreateFlagBits.VK_IMAGE_CREATE_SUBSAMPLED_BIT_EXT;

enum VkSampleCountFlagBits : VkFlags {
    VK_SAMPLE_COUNT_1_BIT  = 0x00000001,
    VK_SAMPLE_COUNT_2_BIT  = 0x00000002,
    VK_SAMPLE_COUNT_4_BIT  = 0x00000004,
    VK_SAMPLE_COUNT_8_BIT  = 0x00000008,
    VK_SAMPLE_COUNT_16_BIT = 0x00000010,
    VK_SAMPLE_COUNT_32_BIT = 0x00000020,
    VK_SAMPLE_COUNT_64_BIT = 0x00000040,
}
enum VK_SAMPLE_COUNT_1_BIT  = VkSampleCountFlagBits.VK_SAMPLE_COUNT_1_BIT;
enum VK_SAMPLE_COUNT_2_BIT  = VkSampleCountFlagBits.VK_SAMPLE_COUNT_2_BIT;
enum VK_SAMPLE_COUNT_4_BIT  = VkSampleCountFlagBits.VK_SAMPLE_COUNT_4_BIT;
enum VK_SAMPLE_COUNT_8_BIT  = VkSampleCountFlagBits.VK_SAMPLE_COUNT_8_BIT;
enum VK_SAMPLE_COUNT_16_BIT = VkSampleCountFlagBits.VK_SAMPLE_COUNT_16_BIT;
enum VK_SAMPLE_COUNT_32_BIT = VkSampleCountFlagBits.VK_SAMPLE_COUNT_32_BIT;
enum VK_SAMPLE_COUNT_64_BIT = VkSampleCountFlagBits.VK_SAMPLE_COUNT_64_BIT;

enum VkPhysicalDeviceType {
    VK_PHYSICAL_DEVICE_TYPE_OTHER          = 0,
    VK_PHYSICAL_DEVICE_TYPE_INTEGRATED_GPU = 1,
    VK_PHYSICAL_DEVICE_TYPE_DISCRETE_GPU   = 2,
    VK_PHYSICAL_DEVICE_TYPE_VIRTUAL_GPU    = 3,
    VK_PHYSICAL_DEVICE_TYPE_CPU            = 4,
}
enum VK_PHYSICAL_DEVICE_TYPE_OTHER          = VkPhysicalDeviceType.VK_PHYSICAL_DEVICE_TYPE_OTHER;
enum VK_PHYSICAL_DEVICE_TYPE_INTEGRATED_GPU = VkPhysicalDeviceType.VK_PHYSICAL_DEVICE_TYPE_INTEGRATED_GPU;
enum VK_PHYSICAL_DEVICE_TYPE_DISCRETE_GPU   = VkPhysicalDeviceType.VK_PHYSICAL_DEVICE_TYPE_DISCRETE_GPU;
enum VK_PHYSICAL_DEVICE_TYPE_VIRTUAL_GPU    = VkPhysicalDeviceType.VK_PHYSICAL_DEVICE_TYPE_VIRTUAL_GPU;
enum VK_PHYSICAL_DEVICE_TYPE_CPU            = VkPhysicalDeviceType.VK_PHYSICAL_DEVICE_TYPE_CPU;

enum VkQueueFlagBits : VkFlags {
    VK_QUEUE_GRAPHICS_BIT       = 0x00000001,
    VK_QUEUE_COMPUTE_BIT        = 0x00000002,
    VK_QUEUE_TRANSFER_BIT       = 0x00000004,
    VK_QUEUE_SPARSE_BINDING_BIT = 0x00000008,
    VK_QUEUE_PROTECTED_BIT      = 0x00000010,
    VK_QUEUE_RESERVED_6_BIT_KHR = 0x00000040,
    VK_QUEUE_RESERVED_5_BIT_KHR = 0x00000020,
}
enum VK_QUEUE_GRAPHICS_BIT       = VkQueueFlagBits.VK_QUEUE_GRAPHICS_BIT;
enum VK_QUEUE_COMPUTE_BIT        = VkQueueFlagBits.VK_QUEUE_COMPUTE_BIT;
enum VK_QUEUE_TRANSFER_BIT       = VkQueueFlagBits.VK_QUEUE_TRANSFER_BIT;
enum VK_QUEUE_SPARSE_BINDING_BIT = VkQueueFlagBits.VK_QUEUE_SPARSE_BINDING_BIT;
enum VK_QUEUE_PROTECTED_BIT      = VkQueueFlagBits.VK_QUEUE_PROTECTED_BIT;
enum VK_QUEUE_RESERVED_6_BIT_KHR = VkQueueFlagBits.VK_QUEUE_RESERVED_6_BIT_KHR;
enum VK_QUEUE_RESERVED_5_BIT_KHR = VkQueueFlagBits.VK_QUEUE_RESERVED_5_BIT_KHR;

enum VkMemoryPropertyFlagBits : VkFlags {
    VK_MEMORY_PROPERTY_DEVICE_LOCAL_BIT     = 0x00000001,
    VK_MEMORY_PROPERTY_HOST_VISIBLE_BIT     = 0x00000002,
    VK_MEMORY_PROPERTY_HOST_COHERENT_BIT    = 0x00000004,
    VK_MEMORY_PROPERTY_HOST_CACHED_BIT      = 0x00000008,
    VK_MEMORY_PROPERTY_LAZILY_ALLOCATED_BIT = 0x00000010,
    VK_MEMORY_PROPERTY_PROTECTED_BIT        = 0x00000020,
}
enum VK_MEMORY_PROPERTY_DEVICE_LOCAL_BIT     = VkMemoryPropertyFlagBits.VK_MEMORY_PROPERTY_DEVICE_LOCAL_BIT;
enum VK_MEMORY_PROPERTY_HOST_VISIBLE_BIT     = VkMemoryPropertyFlagBits.VK_MEMORY_PROPERTY_HOST_VISIBLE_BIT;
enum VK_MEMORY_PROPERTY_HOST_COHERENT_BIT    = VkMemoryPropertyFlagBits.VK_MEMORY_PROPERTY_HOST_COHERENT_BIT;
enum VK_MEMORY_PROPERTY_HOST_CACHED_BIT      = VkMemoryPropertyFlagBits.VK_MEMORY_PROPERTY_HOST_CACHED_BIT;
enum VK_MEMORY_PROPERTY_LAZILY_ALLOCATED_BIT = VkMemoryPropertyFlagBits.VK_MEMORY_PROPERTY_LAZILY_ALLOCATED_BIT;
enum VK_MEMORY_PROPERTY_PROTECTED_BIT        = VkMemoryPropertyFlagBits.VK_MEMORY_PROPERTY_PROTECTED_BIT;

enum VkMemoryHeapFlagBits : VkFlags {
    VK_MEMORY_HEAP_DEVICE_LOCAL_BIT       = 0x00000001,
    VK_MEMORY_HEAP_MULTI_INSTANCE_BIT     = 0x00000002,
    VK_MEMORY_HEAP_MULTI_INSTANCE_BIT_KHR = VK_MEMORY_HEAP_MULTI_INSTANCE_BIT,
}
enum VK_MEMORY_HEAP_DEVICE_LOCAL_BIT       = VkMemoryHeapFlagBits.VK_MEMORY_HEAP_DEVICE_LOCAL_BIT;
enum VK_MEMORY_HEAP_MULTI_INSTANCE_BIT     = VkMemoryHeapFlagBits.VK_MEMORY_HEAP_MULTI_INSTANCE_BIT;
enum VK_MEMORY_HEAP_MULTI_INSTANCE_BIT_KHR = VkMemoryHeapFlagBits.VK_MEMORY_HEAP_MULTI_INSTANCE_BIT_KHR;

enum VkDeviceQueueCreateFlagBits : VkFlags {
    VK_DEVICE_QUEUE_CREATE_PROTECTED_BIT = 0x00000001,
}
enum VK_DEVICE_QUEUE_CREATE_PROTECTED_BIT = VkDeviceQueueCreateFlagBits.VK_DEVICE_QUEUE_CREATE_PROTECTED_BIT;

enum VkPipelineStageFlagBits : VkFlags {
    VK_PIPELINE_STAGE_TOP_OF_PIPE_BIT                     = 0x00000001,
    VK_PIPELINE_STAGE_DRAW_INDIRECT_BIT                   = 0x00000002,
    VK_PIPELINE_STAGE_VERTEX_INPUT_BIT                    = 0x00000004,
    VK_PIPELINE_STAGE_VERTEX_SHADER_BIT                   = 0x00000008,
    VK_PIPELINE_STAGE_TESSELLATION_CONTROL_SHADER_BIT     = 0x00000010,
    VK_PIPELINE_STAGE_TESSELLATION_EVALUATION_SHADER_BIT  = 0x00000020,
    VK_PIPELINE_STAGE_GEOMETRY_SHADER_BIT                 = 0x00000040,
    VK_PIPELINE_STAGE_FRAGMENT_SHADER_BIT                 = 0x00000080,
    VK_PIPELINE_STAGE_EARLY_FRAGMENT_TESTS_BIT            = 0x00000100,
    VK_PIPELINE_STAGE_LATE_FRAGMENT_TESTS_BIT             = 0x00000200,
    VK_PIPELINE_STAGE_COLOR_ATTACHMENT_OUTPUT_BIT         = 0x00000400,
    VK_PIPELINE_STAGE_COMPUTE_SHADER_BIT                  = 0x00000800,
    VK_PIPELINE_STAGE_TRANSFER_BIT                        = 0x00001000,
    VK_PIPELINE_STAGE_BOTTOM_OF_PIPE_BIT                  = 0x00002000,
    VK_PIPELINE_STAGE_HOST_BIT                            = 0x00004000,
    VK_PIPELINE_STAGE_ALL_GRAPHICS_BIT                    = 0x00008000,
    VK_PIPELINE_STAGE_ALL_COMMANDS_BIT                    = 0x00010000,
    VK_PIPELINE_STAGE_RESERVED_27_BIT_KHR                 = 0x08000000,
    VK_PIPELINE_STAGE_RESERVED_26_BIT_KHR                 = 0x04000000,
    VK_PIPELINE_STAGE_TRANSFORM_FEEDBACK_BIT_EXT          = 0x01000000,
    VK_PIPELINE_STAGE_CONDITIONAL_RENDERING_BIT_EXT       = 0x00040000,
    VK_PIPELINE_STAGE_COMMAND_PROCESS_BIT_NVX             = 0x00020000,
    VK_PIPELINE_STAGE_SHADING_RATE_IMAGE_BIT_NV           = 0x00400000,
    VK_PIPELINE_STAGE_RAY_TRACING_SHADER_BIT_NV           = 0x00200000,
    VK_PIPELINE_STAGE_ACCELERATION_STRUCTURE_BUILD_BIT_NV = 0x02000000,
    VK_PIPELINE_STAGE_TASK_SHADER_BIT_NV                  = 0x00080000,
    VK_PIPELINE_STAGE_MESH_SHADER_BIT_NV                  = 0x00100000,
    VK_PIPELINE_STAGE_FRAGMENT_DENSITY_PROCESS_BIT_EXT    = 0x00800000,
}
enum VK_PIPELINE_STAGE_TOP_OF_PIPE_BIT                     = VkPipelineStageFlagBits.VK_PIPELINE_STAGE_TOP_OF_PIPE_BIT;
enum VK_PIPELINE_STAGE_DRAW_INDIRECT_BIT                   = VkPipelineStageFlagBits.VK_PIPELINE_STAGE_DRAW_INDIRECT_BIT;
enum VK_PIPELINE_STAGE_VERTEX_INPUT_BIT                    = VkPipelineStageFlagBits.VK_PIPELINE_STAGE_VERTEX_INPUT_BIT;
enum VK_PIPELINE_STAGE_VERTEX_SHADER_BIT                   = VkPipelineStageFlagBits.VK_PIPELINE_STAGE_VERTEX_SHADER_BIT;
enum VK_PIPELINE_STAGE_TESSELLATION_CONTROL_SHADER_BIT     = VkPipelineStageFlagBits.VK_PIPELINE_STAGE_TESSELLATION_CONTROL_SHADER_BIT;
enum VK_PIPELINE_STAGE_TESSELLATION_EVALUATION_SHADER_BIT  = VkPipelineStageFlagBits.VK_PIPELINE_STAGE_TESSELLATION_EVALUATION_SHADER_BIT;
enum VK_PIPELINE_STAGE_GEOMETRY_SHADER_BIT                 = VkPipelineStageFlagBits.VK_PIPELINE_STAGE_GEOMETRY_SHADER_BIT;
enum VK_PIPELINE_STAGE_FRAGMENT_SHADER_BIT                 = VkPipelineStageFlagBits.VK_PIPELINE_STAGE_FRAGMENT_SHADER_BIT;
enum VK_PIPELINE_STAGE_EARLY_FRAGMENT_TESTS_BIT            = VkPipelineStageFlagBits.VK_PIPELINE_STAGE_EARLY_FRAGMENT_TESTS_BIT;
enum VK_PIPELINE_STAGE_LATE_FRAGMENT_TESTS_BIT             = VkPipelineStageFlagBits.VK_PIPELINE_STAGE_LATE_FRAGMENT_TESTS_BIT;
enum VK_PIPELINE_STAGE_COLOR_ATTACHMENT_OUTPUT_BIT         = VkPipelineStageFlagBits.VK_PIPELINE_STAGE_COLOR_ATTACHMENT_OUTPUT_BIT;
enum VK_PIPELINE_STAGE_COMPUTE_SHADER_BIT                  = VkPipelineStageFlagBits.VK_PIPELINE_STAGE_COMPUTE_SHADER_BIT;
enum VK_PIPELINE_STAGE_TRANSFER_BIT                        = VkPipelineStageFlagBits.VK_PIPELINE_STAGE_TRANSFER_BIT;
enum VK_PIPELINE_STAGE_BOTTOM_OF_PIPE_BIT                  = VkPipelineStageFlagBits.VK_PIPELINE_STAGE_BOTTOM_OF_PIPE_BIT;
enum VK_PIPELINE_STAGE_HOST_BIT                            = VkPipelineStageFlagBits.VK_PIPELINE_STAGE_HOST_BIT;
enum VK_PIPELINE_STAGE_ALL_GRAPHICS_BIT                    = VkPipelineStageFlagBits.VK_PIPELINE_STAGE_ALL_GRAPHICS_BIT;
enum VK_PIPELINE_STAGE_ALL_COMMANDS_BIT                    = VkPipelineStageFlagBits.VK_PIPELINE_STAGE_ALL_COMMANDS_BIT;
enum VK_PIPELINE_STAGE_RESERVED_27_BIT_KHR                 = VkPipelineStageFlagBits.VK_PIPELINE_STAGE_RESERVED_27_BIT_KHR;
enum VK_PIPELINE_STAGE_RESERVED_26_BIT_KHR                 = VkPipelineStageFlagBits.VK_PIPELINE_STAGE_RESERVED_26_BIT_KHR;
enum VK_PIPELINE_STAGE_TRANSFORM_FEEDBACK_BIT_EXT          = VkPipelineStageFlagBits.VK_PIPELINE_STAGE_TRANSFORM_FEEDBACK_BIT_EXT;
enum VK_PIPELINE_STAGE_CONDITIONAL_RENDERING_BIT_EXT       = VkPipelineStageFlagBits.VK_PIPELINE_STAGE_CONDITIONAL_RENDERING_BIT_EXT;
enum VK_PIPELINE_STAGE_COMMAND_PROCESS_BIT_NVX             = VkPipelineStageFlagBits.VK_PIPELINE_STAGE_COMMAND_PROCESS_BIT_NVX;
enum VK_PIPELINE_STAGE_SHADING_RATE_IMAGE_BIT_NV           = VkPipelineStageFlagBits.VK_PIPELINE_STAGE_SHADING_RATE_IMAGE_BIT_NV;
enum VK_PIPELINE_STAGE_RAY_TRACING_SHADER_BIT_NV           = VkPipelineStageFlagBits.VK_PIPELINE_STAGE_RAY_TRACING_SHADER_BIT_NV;
enum VK_PIPELINE_STAGE_ACCELERATION_STRUCTURE_BUILD_BIT_NV = VkPipelineStageFlagBits.VK_PIPELINE_STAGE_ACCELERATION_STRUCTURE_BUILD_BIT_NV;
enum VK_PIPELINE_STAGE_TASK_SHADER_BIT_NV                  = VkPipelineStageFlagBits.VK_PIPELINE_STAGE_TASK_SHADER_BIT_NV;
enum VK_PIPELINE_STAGE_MESH_SHADER_BIT_NV                  = VkPipelineStageFlagBits.VK_PIPELINE_STAGE_MESH_SHADER_BIT_NV;
enum VK_PIPELINE_STAGE_FRAGMENT_DENSITY_PROCESS_BIT_EXT    = VkPipelineStageFlagBits.VK_PIPELINE_STAGE_FRAGMENT_DENSITY_PROCESS_BIT_EXT;

enum VkImageAspectFlagBits : VkFlags {
    VK_IMAGE_ASPECT_COLOR_BIT              = 0x00000001,
    VK_IMAGE_ASPECT_DEPTH_BIT              = 0x00000002,
    VK_IMAGE_ASPECT_STENCIL_BIT            = 0x00000004,
    VK_IMAGE_ASPECT_METADATA_BIT           = 0x00000008,
    VK_IMAGE_ASPECT_PLANE_0_BIT            = 0x00000010,
    VK_IMAGE_ASPECT_PLANE_1_BIT            = 0x00000020,
    VK_IMAGE_ASPECT_PLANE_2_BIT            = 0x00000040,
    VK_IMAGE_ASPECT_PLANE_0_BIT_KHR        = VK_IMAGE_ASPECT_PLANE_0_BIT,
    VK_IMAGE_ASPECT_PLANE_1_BIT_KHR        = VK_IMAGE_ASPECT_PLANE_1_BIT,
    VK_IMAGE_ASPECT_PLANE_2_BIT_KHR        = VK_IMAGE_ASPECT_PLANE_2_BIT,
    VK_IMAGE_ASPECT_MEMORY_PLANE_0_BIT_EXT = 0x00000080,
    VK_IMAGE_ASPECT_MEMORY_PLANE_1_BIT_EXT = 0x00000100,
    VK_IMAGE_ASPECT_MEMORY_PLANE_2_BIT_EXT = 0x00000200,
    VK_IMAGE_ASPECT_MEMORY_PLANE_3_BIT_EXT = 0x00000400,
}
enum VK_IMAGE_ASPECT_COLOR_BIT              = VkImageAspectFlagBits.VK_IMAGE_ASPECT_COLOR_BIT;
enum VK_IMAGE_ASPECT_DEPTH_BIT              = VkImageAspectFlagBits.VK_IMAGE_ASPECT_DEPTH_BIT;
enum VK_IMAGE_ASPECT_STENCIL_BIT            = VkImageAspectFlagBits.VK_IMAGE_ASPECT_STENCIL_BIT;
enum VK_IMAGE_ASPECT_METADATA_BIT           = VkImageAspectFlagBits.VK_IMAGE_ASPECT_METADATA_BIT;
enum VK_IMAGE_ASPECT_PLANE_0_BIT            = VkImageAspectFlagBits.VK_IMAGE_ASPECT_PLANE_0_BIT;
enum VK_IMAGE_ASPECT_PLANE_1_BIT            = VkImageAspectFlagBits.VK_IMAGE_ASPECT_PLANE_1_BIT;
enum VK_IMAGE_ASPECT_PLANE_2_BIT            = VkImageAspectFlagBits.VK_IMAGE_ASPECT_PLANE_2_BIT;
enum VK_IMAGE_ASPECT_PLANE_0_BIT_KHR        = VkImageAspectFlagBits.VK_IMAGE_ASPECT_PLANE_0_BIT_KHR;
enum VK_IMAGE_ASPECT_PLANE_1_BIT_KHR        = VkImageAspectFlagBits.VK_IMAGE_ASPECT_PLANE_1_BIT_KHR;
enum VK_IMAGE_ASPECT_PLANE_2_BIT_KHR        = VkImageAspectFlagBits.VK_IMAGE_ASPECT_PLANE_2_BIT_KHR;
enum VK_IMAGE_ASPECT_MEMORY_PLANE_0_BIT_EXT = VkImageAspectFlagBits.VK_IMAGE_ASPECT_MEMORY_PLANE_0_BIT_EXT;
enum VK_IMAGE_ASPECT_MEMORY_PLANE_1_BIT_EXT = VkImageAspectFlagBits.VK_IMAGE_ASPECT_MEMORY_PLANE_1_BIT_EXT;
enum VK_IMAGE_ASPECT_MEMORY_PLANE_2_BIT_EXT = VkImageAspectFlagBits.VK_IMAGE_ASPECT_MEMORY_PLANE_2_BIT_EXT;
enum VK_IMAGE_ASPECT_MEMORY_PLANE_3_BIT_EXT = VkImageAspectFlagBits.VK_IMAGE_ASPECT_MEMORY_PLANE_3_BIT_EXT;

enum VkSparseImageFormatFlagBits : VkFlags {
    VK_SPARSE_IMAGE_FORMAT_SINGLE_MIPTAIL_BIT         = 0x00000001,
    VK_SPARSE_IMAGE_FORMAT_ALIGNED_MIP_SIZE_BIT       = 0x00000002,
    VK_SPARSE_IMAGE_FORMAT_NONSTANDARD_BLOCK_SIZE_BIT = 0x00000004,
}
enum VK_SPARSE_IMAGE_FORMAT_SINGLE_MIPTAIL_BIT         = VkSparseImageFormatFlagBits.VK_SPARSE_IMAGE_FORMAT_SINGLE_MIPTAIL_BIT;
enum VK_SPARSE_IMAGE_FORMAT_ALIGNED_MIP_SIZE_BIT       = VkSparseImageFormatFlagBits.VK_SPARSE_IMAGE_FORMAT_ALIGNED_MIP_SIZE_BIT;
enum VK_SPARSE_IMAGE_FORMAT_NONSTANDARD_BLOCK_SIZE_BIT = VkSparseImageFormatFlagBits.VK_SPARSE_IMAGE_FORMAT_NONSTANDARD_BLOCK_SIZE_BIT;

enum VkSparseMemoryBindFlagBits : VkFlags {
    VK_SPARSE_MEMORY_BIND_METADATA_BIT = 0x00000001,
}
enum VK_SPARSE_MEMORY_BIND_METADATA_BIT = VkSparseMemoryBindFlagBits.VK_SPARSE_MEMORY_BIND_METADATA_BIT;

enum VkFenceCreateFlagBits : VkFlags {
    VK_FENCE_CREATE_SIGNALED_BIT = 0x00000001,
}
enum VK_FENCE_CREATE_SIGNALED_BIT = VkFenceCreateFlagBits.VK_FENCE_CREATE_SIGNALED_BIT;

enum VkQueryType {
    VK_QUERY_TYPE_OCCLUSION                                = 0,
    VK_QUERY_TYPE_PIPELINE_STATISTICS                      = 1,
    VK_QUERY_TYPE_TIMESTAMP                                = 2,
    VK_QUERY_TYPE_RESERVED_8                               = 1000023008,
    VK_QUERY_TYPE_RESERVED_4                               = 1000024004,
    VK_QUERY_TYPE_TRANSFORM_FEEDBACK_STREAM_EXT            = 1000028004,
    VK_QUERY_TYPE_ACCELERATION_STRUCTURE_COMPACTED_SIZE_NV = 1000165000,
}
enum VK_QUERY_TYPE_OCCLUSION                                = VkQueryType.VK_QUERY_TYPE_OCCLUSION;
enum VK_QUERY_TYPE_PIPELINE_STATISTICS                      = VkQueryType.VK_QUERY_TYPE_PIPELINE_STATISTICS;
enum VK_QUERY_TYPE_TIMESTAMP                                = VkQueryType.VK_QUERY_TYPE_TIMESTAMP;
enum VK_QUERY_TYPE_RESERVED_8                               = VkQueryType.VK_QUERY_TYPE_RESERVED_8;
enum VK_QUERY_TYPE_RESERVED_4                               = VkQueryType.VK_QUERY_TYPE_RESERVED_4;
enum VK_QUERY_TYPE_TRANSFORM_FEEDBACK_STREAM_EXT            = VkQueryType.VK_QUERY_TYPE_TRANSFORM_FEEDBACK_STREAM_EXT;
enum VK_QUERY_TYPE_ACCELERATION_STRUCTURE_COMPACTED_SIZE_NV = VkQueryType.VK_QUERY_TYPE_ACCELERATION_STRUCTURE_COMPACTED_SIZE_NV;

enum VkQueryPipelineStatisticFlagBits : VkFlags {
    VK_QUERY_PIPELINE_STATISTIC_INPUT_ASSEMBLY_VERTICES_BIT                    = 0x00000001,
    VK_QUERY_PIPELINE_STATISTIC_INPUT_ASSEMBLY_PRIMITIVES_BIT                  = 0x00000002,
    VK_QUERY_PIPELINE_STATISTIC_VERTEX_SHADER_INVOCATIONS_BIT                  = 0x00000004,
    VK_QUERY_PIPELINE_STATISTIC_GEOMETRY_SHADER_INVOCATIONS_BIT                = 0x00000008,
    VK_QUERY_PIPELINE_STATISTIC_GEOMETRY_SHADER_PRIMITIVES_BIT                 = 0x00000010,
    VK_QUERY_PIPELINE_STATISTIC_CLIPPING_INVOCATIONS_BIT                       = 0x00000020,
    VK_QUERY_PIPELINE_STATISTIC_CLIPPING_PRIMITIVES_BIT                        = 0x00000040,
    VK_QUERY_PIPELINE_STATISTIC_FRAGMENT_SHADER_INVOCATIONS_BIT                = 0x00000080,
    VK_QUERY_PIPELINE_STATISTIC_TESSELLATION_CONTROL_SHADER_PATCHES_BIT        = 0x00000100,
    VK_QUERY_PIPELINE_STATISTIC_TESSELLATION_EVALUATION_SHADER_INVOCATIONS_BIT = 0x00000200,
    VK_QUERY_PIPELINE_STATISTIC_COMPUTE_SHADER_INVOCATIONS_BIT                 = 0x00000400,
}
enum VK_QUERY_PIPELINE_STATISTIC_INPUT_ASSEMBLY_VERTICES_BIT                    = VkQueryPipelineStatisticFlagBits.VK_QUERY_PIPELINE_STATISTIC_INPUT_ASSEMBLY_VERTICES_BIT;
enum VK_QUERY_PIPELINE_STATISTIC_INPUT_ASSEMBLY_PRIMITIVES_BIT                  = VkQueryPipelineStatisticFlagBits.VK_QUERY_PIPELINE_STATISTIC_INPUT_ASSEMBLY_PRIMITIVES_BIT;
enum VK_QUERY_PIPELINE_STATISTIC_VERTEX_SHADER_INVOCATIONS_BIT                  = VkQueryPipelineStatisticFlagBits.VK_QUERY_PIPELINE_STATISTIC_VERTEX_SHADER_INVOCATIONS_BIT;
enum VK_QUERY_PIPELINE_STATISTIC_GEOMETRY_SHADER_INVOCATIONS_BIT                = VkQueryPipelineStatisticFlagBits.VK_QUERY_PIPELINE_STATISTIC_GEOMETRY_SHADER_INVOCATIONS_BIT;
enum VK_QUERY_PIPELINE_STATISTIC_GEOMETRY_SHADER_PRIMITIVES_BIT                 = VkQueryPipelineStatisticFlagBits.VK_QUERY_PIPELINE_STATISTIC_GEOMETRY_SHADER_PRIMITIVES_BIT;
enum VK_QUERY_PIPELINE_STATISTIC_CLIPPING_INVOCATIONS_BIT                       = VkQueryPipelineStatisticFlagBits.VK_QUERY_PIPELINE_STATISTIC_CLIPPING_INVOCATIONS_BIT;
enum VK_QUERY_PIPELINE_STATISTIC_CLIPPING_PRIMITIVES_BIT                        = VkQueryPipelineStatisticFlagBits.VK_QUERY_PIPELINE_STATISTIC_CLIPPING_PRIMITIVES_BIT;
enum VK_QUERY_PIPELINE_STATISTIC_FRAGMENT_SHADER_INVOCATIONS_BIT                = VkQueryPipelineStatisticFlagBits.VK_QUERY_PIPELINE_STATISTIC_FRAGMENT_SHADER_INVOCATIONS_BIT;
enum VK_QUERY_PIPELINE_STATISTIC_TESSELLATION_CONTROL_SHADER_PATCHES_BIT        = VkQueryPipelineStatisticFlagBits.VK_QUERY_PIPELINE_STATISTIC_TESSELLATION_CONTROL_SHADER_PATCHES_BIT;
enum VK_QUERY_PIPELINE_STATISTIC_TESSELLATION_EVALUATION_SHADER_INVOCATIONS_BIT = VkQueryPipelineStatisticFlagBits.VK_QUERY_PIPELINE_STATISTIC_TESSELLATION_EVALUATION_SHADER_INVOCATIONS_BIT;
enum VK_QUERY_PIPELINE_STATISTIC_COMPUTE_SHADER_INVOCATIONS_BIT                 = VkQueryPipelineStatisticFlagBits.VK_QUERY_PIPELINE_STATISTIC_COMPUTE_SHADER_INVOCATIONS_BIT;

enum VkQueryResultFlagBits : VkFlags {
    VK_QUERY_RESULT_64_BIT                = 0x00000001,
    VK_QUERY_RESULT_WAIT_BIT              = 0x00000002,
    VK_QUERY_RESULT_WITH_AVAILABILITY_BIT = 0x00000004,
    VK_QUERY_RESULT_PARTIAL_BIT           = 0x00000008,
}
enum VK_QUERY_RESULT_64_BIT                = VkQueryResultFlagBits.VK_QUERY_RESULT_64_BIT;
enum VK_QUERY_RESULT_WAIT_BIT              = VkQueryResultFlagBits.VK_QUERY_RESULT_WAIT_BIT;
enum VK_QUERY_RESULT_WITH_AVAILABILITY_BIT = VkQueryResultFlagBits.VK_QUERY_RESULT_WITH_AVAILABILITY_BIT;
enum VK_QUERY_RESULT_PARTIAL_BIT           = VkQueryResultFlagBits.VK_QUERY_RESULT_PARTIAL_BIT;

enum VkBufferCreateFlagBits : VkFlags {
    VK_BUFFER_CREATE_SPARSE_BINDING_BIT   = 0x00000001,
    VK_BUFFER_CREATE_SPARSE_RESIDENCY_BIT = 0x00000002,
    VK_BUFFER_CREATE_SPARSE_ALIASED_BIT   = 0x00000004,
    VK_BUFFER_CREATE_PROTECTED_BIT        = 0x00000008,
}
enum VK_BUFFER_CREATE_SPARSE_BINDING_BIT   = VkBufferCreateFlagBits.VK_BUFFER_CREATE_SPARSE_BINDING_BIT;
enum VK_BUFFER_CREATE_SPARSE_RESIDENCY_BIT = VkBufferCreateFlagBits.VK_BUFFER_CREATE_SPARSE_RESIDENCY_BIT;
enum VK_BUFFER_CREATE_SPARSE_ALIASED_BIT   = VkBufferCreateFlagBits.VK_BUFFER_CREATE_SPARSE_ALIASED_BIT;
enum VK_BUFFER_CREATE_PROTECTED_BIT        = VkBufferCreateFlagBits.VK_BUFFER_CREATE_PROTECTED_BIT;

enum VkBufferUsageFlagBits : VkFlags {
    VK_BUFFER_USAGE_TRANSFER_SRC_BIT                          = 0x00000001,
    VK_BUFFER_USAGE_TRANSFER_DST_BIT                          = 0x00000002,
    VK_BUFFER_USAGE_UNIFORM_TEXEL_BUFFER_BIT                  = 0x00000004,
    VK_BUFFER_USAGE_STORAGE_TEXEL_BUFFER_BIT                  = 0x00000008,
    VK_BUFFER_USAGE_UNIFORM_BUFFER_BIT                        = 0x00000010,
    VK_BUFFER_USAGE_STORAGE_BUFFER_BIT                        = 0x00000020,
    VK_BUFFER_USAGE_INDEX_BUFFER_BIT                          = 0x00000040,
    VK_BUFFER_USAGE_VERTEX_BUFFER_BIT                         = 0x00000080,
    VK_BUFFER_USAGE_INDIRECT_BUFFER_BIT                       = 0x00000100,
    VK_BUFFER_USAGE_RESERVED_14_BIT_KHR                       = 0x00004000,
    VK_BUFFER_USAGE_RESERVED_13_BIT_KHR                       = 0x00002000,
    VK_BUFFER_USAGE_TRANSFORM_FEEDBACK_BUFFER_BIT_EXT         = 0x00000800,
    VK_BUFFER_USAGE_TRANSFORM_FEEDBACK_COUNTER_BUFFER_BIT_EXT = 0x00001000,
    VK_BUFFER_USAGE_CONDITIONAL_RENDERING_BIT_EXT             = 0x00000200,
    VK_BUFFER_USAGE_RAY_TRACING_BIT_NV                        = 0x00000400,
}
enum VK_BUFFER_USAGE_TRANSFER_SRC_BIT                          = VkBufferUsageFlagBits.VK_BUFFER_USAGE_TRANSFER_SRC_BIT;
enum VK_BUFFER_USAGE_TRANSFER_DST_BIT                          = VkBufferUsageFlagBits.VK_BUFFER_USAGE_TRANSFER_DST_BIT;
enum VK_BUFFER_USAGE_UNIFORM_TEXEL_BUFFER_BIT                  = VkBufferUsageFlagBits.VK_BUFFER_USAGE_UNIFORM_TEXEL_BUFFER_BIT;
enum VK_BUFFER_USAGE_STORAGE_TEXEL_BUFFER_BIT                  = VkBufferUsageFlagBits.VK_BUFFER_USAGE_STORAGE_TEXEL_BUFFER_BIT;
enum VK_BUFFER_USAGE_UNIFORM_BUFFER_BIT                        = VkBufferUsageFlagBits.VK_BUFFER_USAGE_UNIFORM_BUFFER_BIT;
enum VK_BUFFER_USAGE_STORAGE_BUFFER_BIT                        = VkBufferUsageFlagBits.VK_BUFFER_USAGE_STORAGE_BUFFER_BIT;
enum VK_BUFFER_USAGE_INDEX_BUFFER_BIT                          = VkBufferUsageFlagBits.VK_BUFFER_USAGE_INDEX_BUFFER_BIT;
enum VK_BUFFER_USAGE_VERTEX_BUFFER_BIT                         = VkBufferUsageFlagBits.VK_BUFFER_USAGE_VERTEX_BUFFER_BIT;
enum VK_BUFFER_USAGE_INDIRECT_BUFFER_BIT                       = VkBufferUsageFlagBits.VK_BUFFER_USAGE_INDIRECT_BUFFER_BIT;
enum VK_BUFFER_USAGE_RESERVED_14_BIT_KHR                       = VkBufferUsageFlagBits.VK_BUFFER_USAGE_RESERVED_14_BIT_KHR;
enum VK_BUFFER_USAGE_RESERVED_13_BIT_KHR                       = VkBufferUsageFlagBits.VK_BUFFER_USAGE_RESERVED_13_BIT_KHR;
enum VK_BUFFER_USAGE_TRANSFORM_FEEDBACK_BUFFER_BIT_EXT         = VkBufferUsageFlagBits.VK_BUFFER_USAGE_TRANSFORM_FEEDBACK_BUFFER_BIT_EXT;
enum VK_BUFFER_USAGE_TRANSFORM_FEEDBACK_COUNTER_BUFFER_BIT_EXT = VkBufferUsageFlagBits.VK_BUFFER_USAGE_TRANSFORM_FEEDBACK_COUNTER_BUFFER_BIT_EXT;
enum VK_BUFFER_USAGE_CONDITIONAL_RENDERING_BIT_EXT             = VkBufferUsageFlagBits.VK_BUFFER_USAGE_CONDITIONAL_RENDERING_BIT_EXT;
enum VK_BUFFER_USAGE_RAY_TRACING_BIT_NV                        = VkBufferUsageFlagBits.VK_BUFFER_USAGE_RAY_TRACING_BIT_NV;

enum VkSharingMode {
    VK_SHARING_MODE_EXCLUSIVE  = 0,
    VK_SHARING_MODE_CONCURRENT = 1,
}
enum VK_SHARING_MODE_EXCLUSIVE  = VkSharingMode.VK_SHARING_MODE_EXCLUSIVE;
enum VK_SHARING_MODE_CONCURRENT = VkSharingMode.VK_SHARING_MODE_CONCURRENT;

enum VkImageLayout {
    VK_IMAGE_LAYOUT_UNDEFINED                                      = 0,
    VK_IMAGE_LAYOUT_GENERAL                                        = 1,
    VK_IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL                       = 2,
    VK_IMAGE_LAYOUT_DEPTH_STENCIL_ATTACHMENT_OPTIMAL               = 3,
    VK_IMAGE_LAYOUT_DEPTH_STENCIL_READ_ONLY_OPTIMAL                = 4,
    VK_IMAGE_LAYOUT_SHADER_READ_ONLY_OPTIMAL                       = 5,
    VK_IMAGE_LAYOUT_TRANSFER_SRC_OPTIMAL                           = 6,
    VK_IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL                           = 7,
    VK_IMAGE_LAYOUT_PREINITIALIZED                                 = 8,
    VK_IMAGE_LAYOUT_DEPTH_READ_ONLY_STENCIL_ATTACHMENT_OPTIMAL     = 1000117000,
    VK_IMAGE_LAYOUT_DEPTH_ATTACHMENT_STENCIL_READ_ONLY_OPTIMAL     = 1000117001,
    VK_IMAGE_LAYOUT_PRESENT_SRC_KHR                                = 1000001002,
    VK_IMAGE_LAYOUT_SHARED_PRESENT_KHR                             = 1000111000,
    VK_IMAGE_LAYOUT_DEPTH_READ_ONLY_STENCIL_ATTACHMENT_OPTIMAL_KHR = VK_IMAGE_LAYOUT_DEPTH_READ_ONLY_STENCIL_ATTACHMENT_OPTIMAL,
    VK_IMAGE_LAYOUT_DEPTH_ATTACHMENT_STENCIL_READ_ONLY_OPTIMAL_KHR = VK_IMAGE_LAYOUT_DEPTH_ATTACHMENT_STENCIL_READ_ONLY_OPTIMAL,
    VK_IMAGE_LAYOUT_SHADING_RATE_OPTIMAL_NV                        = 1000164003,
    VK_IMAGE_LAYOUT_FRAGMENT_DENSITY_MAP_OPTIMAL_EXT               = 1000218000,
}
enum VK_IMAGE_LAYOUT_UNDEFINED                                      = VkImageLayout.VK_IMAGE_LAYOUT_UNDEFINED;
enum VK_IMAGE_LAYOUT_GENERAL                                        = VkImageLayout.VK_IMAGE_LAYOUT_GENERAL;
enum VK_IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL                       = VkImageLayout.VK_IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL;
enum VK_IMAGE_LAYOUT_DEPTH_STENCIL_ATTACHMENT_OPTIMAL               = VkImageLayout.VK_IMAGE_LAYOUT_DEPTH_STENCIL_ATTACHMENT_OPTIMAL;
enum VK_IMAGE_LAYOUT_DEPTH_STENCIL_READ_ONLY_OPTIMAL                = VkImageLayout.VK_IMAGE_LAYOUT_DEPTH_STENCIL_READ_ONLY_OPTIMAL;
enum VK_IMAGE_LAYOUT_SHADER_READ_ONLY_OPTIMAL                       = VkImageLayout.VK_IMAGE_LAYOUT_SHADER_READ_ONLY_OPTIMAL;
enum VK_IMAGE_LAYOUT_TRANSFER_SRC_OPTIMAL                           = VkImageLayout.VK_IMAGE_LAYOUT_TRANSFER_SRC_OPTIMAL;
enum VK_IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL                           = VkImageLayout.VK_IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL;
enum VK_IMAGE_LAYOUT_PREINITIALIZED                                 = VkImageLayout.VK_IMAGE_LAYOUT_PREINITIALIZED;
enum VK_IMAGE_LAYOUT_DEPTH_READ_ONLY_STENCIL_ATTACHMENT_OPTIMAL     = VkImageLayout.VK_IMAGE_LAYOUT_DEPTH_READ_ONLY_STENCIL_ATTACHMENT_OPTIMAL;
enum VK_IMAGE_LAYOUT_DEPTH_ATTACHMENT_STENCIL_READ_ONLY_OPTIMAL     = VkImageLayout.VK_IMAGE_LAYOUT_DEPTH_ATTACHMENT_STENCIL_READ_ONLY_OPTIMAL;
enum VK_IMAGE_LAYOUT_PRESENT_SRC_KHR                                = VkImageLayout.VK_IMAGE_LAYOUT_PRESENT_SRC_KHR;
enum VK_IMAGE_LAYOUT_SHARED_PRESENT_KHR                             = VkImageLayout.VK_IMAGE_LAYOUT_SHARED_PRESENT_KHR;
enum VK_IMAGE_LAYOUT_DEPTH_READ_ONLY_STENCIL_ATTACHMENT_OPTIMAL_KHR = VkImageLayout.VK_IMAGE_LAYOUT_DEPTH_READ_ONLY_STENCIL_ATTACHMENT_OPTIMAL_KHR;
enum VK_IMAGE_LAYOUT_DEPTH_ATTACHMENT_STENCIL_READ_ONLY_OPTIMAL_KHR = VkImageLayout.VK_IMAGE_LAYOUT_DEPTH_ATTACHMENT_STENCIL_READ_ONLY_OPTIMAL_KHR;
enum VK_IMAGE_LAYOUT_SHADING_RATE_OPTIMAL_NV                        = VkImageLayout.VK_IMAGE_LAYOUT_SHADING_RATE_OPTIMAL_NV;
enum VK_IMAGE_LAYOUT_FRAGMENT_DENSITY_MAP_OPTIMAL_EXT               = VkImageLayout.VK_IMAGE_LAYOUT_FRAGMENT_DENSITY_MAP_OPTIMAL_EXT;

enum VkImageViewCreateFlagBits : VkFlags {
    VK_IMAGE_VIEW_CREATE_FRAGMENT_DENSITY_MAP_DYNAMIC_BIT_EXT = 0x00000001,
}
enum VK_IMAGE_VIEW_CREATE_FRAGMENT_DENSITY_MAP_DYNAMIC_BIT_EXT = VkImageViewCreateFlagBits.VK_IMAGE_VIEW_CREATE_FRAGMENT_DENSITY_MAP_DYNAMIC_BIT_EXT;

enum VkImageViewType {
    VK_IMAGE_VIEW_TYPE_1D         = 0,
    VK_IMAGE_VIEW_TYPE_2D         = 1,
    VK_IMAGE_VIEW_TYPE_3D         = 2,
    VK_IMAGE_VIEW_TYPE_CUBE       = 3,
    VK_IMAGE_VIEW_TYPE_1D_ARRAY   = 4,
    VK_IMAGE_VIEW_TYPE_2D_ARRAY   = 5,
    VK_IMAGE_VIEW_TYPE_CUBE_ARRAY = 6,
}
enum VK_IMAGE_VIEW_TYPE_1D         = VkImageViewType.VK_IMAGE_VIEW_TYPE_1D;
enum VK_IMAGE_VIEW_TYPE_2D         = VkImageViewType.VK_IMAGE_VIEW_TYPE_2D;
enum VK_IMAGE_VIEW_TYPE_3D         = VkImageViewType.VK_IMAGE_VIEW_TYPE_3D;
enum VK_IMAGE_VIEW_TYPE_CUBE       = VkImageViewType.VK_IMAGE_VIEW_TYPE_CUBE;
enum VK_IMAGE_VIEW_TYPE_1D_ARRAY   = VkImageViewType.VK_IMAGE_VIEW_TYPE_1D_ARRAY;
enum VK_IMAGE_VIEW_TYPE_2D_ARRAY   = VkImageViewType.VK_IMAGE_VIEW_TYPE_2D_ARRAY;
enum VK_IMAGE_VIEW_TYPE_CUBE_ARRAY = VkImageViewType.VK_IMAGE_VIEW_TYPE_CUBE_ARRAY;

enum VkComponentSwizzle {
    VK_COMPONENT_SWIZZLE_IDENTITY = 0,
    VK_COMPONENT_SWIZZLE_ZERO     = 1,
    VK_COMPONENT_SWIZZLE_ONE      = 2,
    VK_COMPONENT_SWIZZLE_R        = 3,
    VK_COMPONENT_SWIZZLE_G        = 4,
    VK_COMPONENT_SWIZZLE_B        = 5,
    VK_COMPONENT_SWIZZLE_A        = 6,
}
enum VK_COMPONENT_SWIZZLE_IDENTITY = VkComponentSwizzle.VK_COMPONENT_SWIZZLE_IDENTITY;
enum VK_COMPONENT_SWIZZLE_ZERO     = VkComponentSwizzle.VK_COMPONENT_SWIZZLE_ZERO;
enum VK_COMPONENT_SWIZZLE_ONE      = VkComponentSwizzle.VK_COMPONENT_SWIZZLE_ONE;
enum VK_COMPONENT_SWIZZLE_R        = VkComponentSwizzle.VK_COMPONENT_SWIZZLE_R;
enum VK_COMPONENT_SWIZZLE_G        = VkComponentSwizzle.VK_COMPONENT_SWIZZLE_G;
enum VK_COMPONENT_SWIZZLE_B        = VkComponentSwizzle.VK_COMPONENT_SWIZZLE_B;
enum VK_COMPONENT_SWIZZLE_A        = VkComponentSwizzle.VK_COMPONENT_SWIZZLE_A;

enum VkPipelineCreateFlagBits : VkFlags {
    VK_PIPELINE_CREATE_DISABLE_OPTIMIZATION_BIT             = 0x00000001,
    VK_PIPELINE_CREATE_ALLOW_DERIVATIVES_BIT                = 0x00000002,
    VK_PIPELINE_CREATE_DERIVATIVE_BIT                       = 0x00000004,
    VK_PIPELINE_CREATE_VIEW_INDEX_FROM_DEVICE_INDEX_BIT     = 0x00000008,
    VK_PIPELINE_CREATE_DISPATCH_BASE                        = 0x00000010,
    VK_PIPELINE_CREATE_VIEW_INDEX_FROM_DEVICE_INDEX_BIT_KHR = VK_PIPELINE_CREATE_VIEW_INDEX_FROM_DEVICE_INDEX_BIT,
    VK_PIPELINE_CREATE_DISPATCH_BASE_KHR                    = VK_PIPELINE_CREATE_DISPATCH_BASE,
    VK_PIPELINE_CREATE_DEFER_COMPILE_BIT_NV                 = 0x00000020,
}
enum VK_PIPELINE_CREATE_DISABLE_OPTIMIZATION_BIT             = VkPipelineCreateFlagBits.VK_PIPELINE_CREATE_DISABLE_OPTIMIZATION_BIT;
enum VK_PIPELINE_CREATE_ALLOW_DERIVATIVES_BIT                = VkPipelineCreateFlagBits.VK_PIPELINE_CREATE_ALLOW_DERIVATIVES_BIT;
enum VK_PIPELINE_CREATE_DERIVATIVE_BIT                       = VkPipelineCreateFlagBits.VK_PIPELINE_CREATE_DERIVATIVE_BIT;
enum VK_PIPELINE_CREATE_VIEW_INDEX_FROM_DEVICE_INDEX_BIT     = VkPipelineCreateFlagBits.VK_PIPELINE_CREATE_VIEW_INDEX_FROM_DEVICE_INDEX_BIT;
enum VK_PIPELINE_CREATE_DISPATCH_BASE                        = VkPipelineCreateFlagBits.VK_PIPELINE_CREATE_DISPATCH_BASE;
enum VK_PIPELINE_CREATE_VIEW_INDEX_FROM_DEVICE_INDEX_BIT_KHR = VkPipelineCreateFlagBits.VK_PIPELINE_CREATE_VIEW_INDEX_FROM_DEVICE_INDEX_BIT_KHR;
enum VK_PIPELINE_CREATE_DISPATCH_BASE_KHR                    = VkPipelineCreateFlagBits.VK_PIPELINE_CREATE_DISPATCH_BASE_KHR;
enum VK_PIPELINE_CREATE_DEFER_COMPILE_BIT_NV                 = VkPipelineCreateFlagBits.VK_PIPELINE_CREATE_DEFER_COMPILE_BIT_NV;

enum VkShaderStageFlagBits : VkFlags {
    VK_SHADER_STAGE_VERTEX_BIT                  = 0x00000001,
    VK_SHADER_STAGE_TESSELLATION_CONTROL_BIT    = 0x00000002,
    VK_SHADER_STAGE_TESSELLATION_EVALUATION_BIT = 0x00000004,
    VK_SHADER_STAGE_GEOMETRY_BIT                = 0x00000008,
    VK_SHADER_STAGE_FRAGMENT_BIT                = 0x00000010,
    VK_SHADER_STAGE_COMPUTE_BIT                 = 0x00000020,
    VK_SHADER_STAGE_ALL_GRAPHICS                = 0x0000001F,
    VK_SHADER_STAGE_ALL                         = 0x7FFFFFFF,
    VK_SHADER_STAGE_RAYGEN_BIT_NV               = 0x00000100,
    VK_SHADER_STAGE_ANY_HIT_BIT_NV              = 0x00000200,
    VK_SHADER_STAGE_CLOSEST_HIT_BIT_NV          = 0x00000400,
    VK_SHADER_STAGE_MISS_BIT_NV                 = 0x00000800,
    VK_SHADER_STAGE_INTERSECTION_BIT_NV         = 0x00001000,
    VK_SHADER_STAGE_CALLABLE_BIT_NV             = 0x00002000,
    VK_SHADER_STAGE_TASK_BIT_NV                 = 0x00000040,
    VK_SHADER_STAGE_MESH_BIT_NV                 = 0x00000080,
}
enum VK_SHADER_STAGE_VERTEX_BIT                  = VkShaderStageFlagBits.VK_SHADER_STAGE_VERTEX_BIT;
enum VK_SHADER_STAGE_TESSELLATION_CONTROL_BIT    = VkShaderStageFlagBits.VK_SHADER_STAGE_TESSELLATION_CONTROL_BIT;
enum VK_SHADER_STAGE_TESSELLATION_EVALUATION_BIT = VkShaderStageFlagBits.VK_SHADER_STAGE_TESSELLATION_EVALUATION_BIT;
enum VK_SHADER_STAGE_GEOMETRY_BIT                = VkShaderStageFlagBits.VK_SHADER_STAGE_GEOMETRY_BIT;
enum VK_SHADER_STAGE_FRAGMENT_BIT                = VkShaderStageFlagBits.VK_SHADER_STAGE_FRAGMENT_BIT;
enum VK_SHADER_STAGE_COMPUTE_BIT                 = VkShaderStageFlagBits.VK_SHADER_STAGE_COMPUTE_BIT;
enum VK_SHADER_STAGE_ALL_GRAPHICS                = VkShaderStageFlagBits.VK_SHADER_STAGE_ALL_GRAPHICS;
enum VK_SHADER_STAGE_ALL                         = VkShaderStageFlagBits.VK_SHADER_STAGE_ALL;
enum VK_SHADER_STAGE_RAYGEN_BIT_NV               = VkShaderStageFlagBits.VK_SHADER_STAGE_RAYGEN_BIT_NV;
enum VK_SHADER_STAGE_ANY_HIT_BIT_NV              = VkShaderStageFlagBits.VK_SHADER_STAGE_ANY_HIT_BIT_NV;
enum VK_SHADER_STAGE_CLOSEST_HIT_BIT_NV          = VkShaderStageFlagBits.VK_SHADER_STAGE_CLOSEST_HIT_BIT_NV;
enum VK_SHADER_STAGE_MISS_BIT_NV                 = VkShaderStageFlagBits.VK_SHADER_STAGE_MISS_BIT_NV;
enum VK_SHADER_STAGE_INTERSECTION_BIT_NV         = VkShaderStageFlagBits.VK_SHADER_STAGE_INTERSECTION_BIT_NV;
enum VK_SHADER_STAGE_CALLABLE_BIT_NV             = VkShaderStageFlagBits.VK_SHADER_STAGE_CALLABLE_BIT_NV;
enum VK_SHADER_STAGE_TASK_BIT_NV                 = VkShaderStageFlagBits.VK_SHADER_STAGE_TASK_BIT_NV;
enum VK_SHADER_STAGE_MESH_BIT_NV                 = VkShaderStageFlagBits.VK_SHADER_STAGE_MESH_BIT_NV;

enum VkVertexInputRate {
    VK_VERTEX_INPUT_RATE_VERTEX   = 0,
    VK_VERTEX_INPUT_RATE_INSTANCE = 1,
}
enum VK_VERTEX_INPUT_RATE_VERTEX   = VkVertexInputRate.VK_VERTEX_INPUT_RATE_VERTEX;
enum VK_VERTEX_INPUT_RATE_INSTANCE = VkVertexInputRate.VK_VERTEX_INPUT_RATE_INSTANCE;

enum VkPrimitiveTopology {
    VK_PRIMITIVE_TOPOLOGY_POINT_LIST                    = 0,
    VK_PRIMITIVE_TOPOLOGY_LINE_LIST                     = 1,
    VK_PRIMITIVE_TOPOLOGY_LINE_STRIP                    = 2,
    VK_PRIMITIVE_TOPOLOGY_TRIANGLE_LIST                 = 3,
    VK_PRIMITIVE_TOPOLOGY_TRIANGLE_STRIP                = 4,
    VK_PRIMITIVE_TOPOLOGY_TRIANGLE_FAN                  = 5,
    VK_PRIMITIVE_TOPOLOGY_LINE_LIST_WITH_ADJACENCY      = 6,
    VK_PRIMITIVE_TOPOLOGY_LINE_STRIP_WITH_ADJACENCY     = 7,
    VK_PRIMITIVE_TOPOLOGY_TRIANGLE_LIST_WITH_ADJACENCY  = 8,
    VK_PRIMITIVE_TOPOLOGY_TRIANGLE_STRIP_WITH_ADJACENCY = 9,
    VK_PRIMITIVE_TOPOLOGY_PATCH_LIST                    = 10,
}
enum VK_PRIMITIVE_TOPOLOGY_POINT_LIST                    = VkPrimitiveTopology.VK_PRIMITIVE_TOPOLOGY_POINT_LIST;
enum VK_PRIMITIVE_TOPOLOGY_LINE_LIST                     = VkPrimitiveTopology.VK_PRIMITIVE_TOPOLOGY_LINE_LIST;
enum VK_PRIMITIVE_TOPOLOGY_LINE_STRIP                    = VkPrimitiveTopology.VK_PRIMITIVE_TOPOLOGY_LINE_STRIP;
enum VK_PRIMITIVE_TOPOLOGY_TRIANGLE_LIST                 = VkPrimitiveTopology.VK_PRIMITIVE_TOPOLOGY_TRIANGLE_LIST;
enum VK_PRIMITIVE_TOPOLOGY_TRIANGLE_STRIP                = VkPrimitiveTopology.VK_PRIMITIVE_TOPOLOGY_TRIANGLE_STRIP;
enum VK_PRIMITIVE_TOPOLOGY_TRIANGLE_FAN                  = VkPrimitiveTopology.VK_PRIMITIVE_TOPOLOGY_TRIANGLE_FAN;
enum VK_PRIMITIVE_TOPOLOGY_LINE_LIST_WITH_ADJACENCY      = VkPrimitiveTopology.VK_PRIMITIVE_TOPOLOGY_LINE_LIST_WITH_ADJACENCY;
enum VK_PRIMITIVE_TOPOLOGY_LINE_STRIP_WITH_ADJACENCY     = VkPrimitiveTopology.VK_PRIMITIVE_TOPOLOGY_LINE_STRIP_WITH_ADJACENCY;
enum VK_PRIMITIVE_TOPOLOGY_TRIANGLE_LIST_WITH_ADJACENCY  = VkPrimitiveTopology.VK_PRIMITIVE_TOPOLOGY_TRIANGLE_LIST_WITH_ADJACENCY;
enum VK_PRIMITIVE_TOPOLOGY_TRIANGLE_STRIP_WITH_ADJACENCY = VkPrimitiveTopology.VK_PRIMITIVE_TOPOLOGY_TRIANGLE_STRIP_WITH_ADJACENCY;
enum VK_PRIMITIVE_TOPOLOGY_PATCH_LIST                    = VkPrimitiveTopology.VK_PRIMITIVE_TOPOLOGY_PATCH_LIST;

enum VkPolygonMode {
    VK_POLYGON_MODE_FILL              = 0,
    VK_POLYGON_MODE_LINE              = 1,
    VK_POLYGON_MODE_POINT             = 2,
    VK_POLYGON_MODE_FILL_RECTANGLE_NV = 1000153000,
}
enum VK_POLYGON_MODE_FILL              = VkPolygonMode.VK_POLYGON_MODE_FILL;
enum VK_POLYGON_MODE_LINE              = VkPolygonMode.VK_POLYGON_MODE_LINE;
enum VK_POLYGON_MODE_POINT             = VkPolygonMode.VK_POLYGON_MODE_POINT;
enum VK_POLYGON_MODE_FILL_RECTANGLE_NV = VkPolygonMode.VK_POLYGON_MODE_FILL_RECTANGLE_NV;

enum VkCullModeFlagBits : VkFlags {
    VK_CULL_MODE_NONE           = 0,
    VK_CULL_MODE_FRONT_BIT      = 0x00000001,
    VK_CULL_MODE_BACK_BIT       = 0x00000002,
    VK_CULL_MODE_FRONT_AND_BACK = 0x00000003,
}
enum VK_CULL_MODE_NONE           = VkCullModeFlagBits.VK_CULL_MODE_NONE;
enum VK_CULL_MODE_FRONT_BIT      = VkCullModeFlagBits.VK_CULL_MODE_FRONT_BIT;
enum VK_CULL_MODE_BACK_BIT       = VkCullModeFlagBits.VK_CULL_MODE_BACK_BIT;
enum VK_CULL_MODE_FRONT_AND_BACK = VkCullModeFlagBits.VK_CULL_MODE_FRONT_AND_BACK;

enum VkFrontFace {
    VK_FRONT_FACE_COUNTER_CLOCKWISE = 0,
    VK_FRONT_FACE_CLOCKWISE         = 1,
}
enum VK_FRONT_FACE_COUNTER_CLOCKWISE = VkFrontFace.VK_FRONT_FACE_COUNTER_CLOCKWISE;
enum VK_FRONT_FACE_CLOCKWISE         = VkFrontFace.VK_FRONT_FACE_CLOCKWISE;

enum VkCompareOp {
    VK_COMPARE_OP_NEVER            = 0,
    VK_COMPARE_OP_LESS             = 1,
    VK_COMPARE_OP_EQUAL            = 2,
    VK_COMPARE_OP_LESS_OR_EQUAL    = 3,
    VK_COMPARE_OP_GREATER          = 4,
    VK_COMPARE_OP_NOT_EQUAL        = 5,
    VK_COMPARE_OP_GREATER_OR_EQUAL = 6,
    VK_COMPARE_OP_ALWAYS           = 7,
}
enum VK_COMPARE_OP_NEVER            = VkCompareOp.VK_COMPARE_OP_NEVER;
enum VK_COMPARE_OP_LESS             = VkCompareOp.VK_COMPARE_OP_LESS;
enum VK_COMPARE_OP_EQUAL            = VkCompareOp.VK_COMPARE_OP_EQUAL;
enum VK_COMPARE_OP_LESS_OR_EQUAL    = VkCompareOp.VK_COMPARE_OP_LESS_OR_EQUAL;
enum VK_COMPARE_OP_GREATER          = VkCompareOp.VK_COMPARE_OP_GREATER;
enum VK_COMPARE_OP_NOT_EQUAL        = VkCompareOp.VK_COMPARE_OP_NOT_EQUAL;
enum VK_COMPARE_OP_GREATER_OR_EQUAL = VkCompareOp.VK_COMPARE_OP_GREATER_OR_EQUAL;
enum VK_COMPARE_OP_ALWAYS           = VkCompareOp.VK_COMPARE_OP_ALWAYS;

enum VkStencilOp {
    VK_STENCIL_OP_KEEP                = 0,
    VK_STENCIL_OP_ZERO                = 1,
    VK_STENCIL_OP_REPLACE             = 2,
    VK_STENCIL_OP_INCREMENT_AND_CLAMP = 3,
    VK_STENCIL_OP_DECREMENT_AND_CLAMP = 4,
    VK_STENCIL_OP_INVERT              = 5,
    VK_STENCIL_OP_INCREMENT_AND_WRAP  = 6,
    VK_STENCIL_OP_DECREMENT_AND_WRAP  = 7,
}
enum VK_STENCIL_OP_KEEP                = VkStencilOp.VK_STENCIL_OP_KEEP;
enum VK_STENCIL_OP_ZERO                = VkStencilOp.VK_STENCIL_OP_ZERO;
enum VK_STENCIL_OP_REPLACE             = VkStencilOp.VK_STENCIL_OP_REPLACE;
enum VK_STENCIL_OP_INCREMENT_AND_CLAMP = VkStencilOp.VK_STENCIL_OP_INCREMENT_AND_CLAMP;
enum VK_STENCIL_OP_DECREMENT_AND_CLAMP = VkStencilOp.VK_STENCIL_OP_DECREMENT_AND_CLAMP;
enum VK_STENCIL_OP_INVERT              = VkStencilOp.VK_STENCIL_OP_INVERT;
enum VK_STENCIL_OP_INCREMENT_AND_WRAP  = VkStencilOp.VK_STENCIL_OP_INCREMENT_AND_WRAP;
enum VK_STENCIL_OP_DECREMENT_AND_WRAP  = VkStencilOp.VK_STENCIL_OP_DECREMENT_AND_WRAP;

enum VkLogicOp {
    VK_LOGIC_OP_CLEAR         = 0,
    VK_LOGIC_OP_AND           = 1,
    VK_LOGIC_OP_AND_REVERSE   = 2,
    VK_LOGIC_OP_COPY          = 3,
    VK_LOGIC_OP_AND_INVERTED  = 4,
    VK_LOGIC_OP_NO_OP         = 5,
    VK_LOGIC_OP_XOR           = 6,
    VK_LOGIC_OP_OR            = 7,
    VK_LOGIC_OP_NOR           = 8,
    VK_LOGIC_OP_EQUIVALENT    = 9,
    VK_LOGIC_OP_INVERT        = 10,
    VK_LOGIC_OP_OR_REVERSE    = 11,
    VK_LOGIC_OP_COPY_INVERTED = 12,
    VK_LOGIC_OP_OR_INVERTED   = 13,
    VK_LOGIC_OP_NAND          = 14,
    VK_LOGIC_OP_SET           = 15,
}
enum VK_LOGIC_OP_CLEAR         = VkLogicOp.VK_LOGIC_OP_CLEAR;
enum VK_LOGIC_OP_AND           = VkLogicOp.VK_LOGIC_OP_AND;
enum VK_LOGIC_OP_AND_REVERSE   = VkLogicOp.VK_LOGIC_OP_AND_REVERSE;
enum VK_LOGIC_OP_COPY          = VkLogicOp.VK_LOGIC_OP_COPY;
enum VK_LOGIC_OP_AND_INVERTED  = VkLogicOp.VK_LOGIC_OP_AND_INVERTED;
enum VK_LOGIC_OP_NO_OP         = VkLogicOp.VK_LOGIC_OP_NO_OP;
enum VK_LOGIC_OP_XOR           = VkLogicOp.VK_LOGIC_OP_XOR;
enum VK_LOGIC_OP_OR            = VkLogicOp.VK_LOGIC_OP_OR;
enum VK_LOGIC_OP_NOR           = VkLogicOp.VK_LOGIC_OP_NOR;
enum VK_LOGIC_OP_EQUIVALENT    = VkLogicOp.VK_LOGIC_OP_EQUIVALENT;
enum VK_LOGIC_OP_INVERT        = VkLogicOp.VK_LOGIC_OP_INVERT;
enum VK_LOGIC_OP_OR_REVERSE    = VkLogicOp.VK_LOGIC_OP_OR_REVERSE;
enum VK_LOGIC_OP_COPY_INVERTED = VkLogicOp.VK_LOGIC_OP_COPY_INVERTED;
enum VK_LOGIC_OP_OR_INVERTED   = VkLogicOp.VK_LOGIC_OP_OR_INVERTED;
enum VK_LOGIC_OP_NAND          = VkLogicOp.VK_LOGIC_OP_NAND;
enum VK_LOGIC_OP_SET           = VkLogicOp.VK_LOGIC_OP_SET;

enum VkBlendFactor {
    VK_BLEND_FACTOR_ZERO                     = 0,
    VK_BLEND_FACTOR_ONE                      = 1,
    VK_BLEND_FACTOR_SRC_COLOR                = 2,
    VK_BLEND_FACTOR_ONE_MINUS_SRC_COLOR      = 3,
    VK_BLEND_FACTOR_DST_COLOR                = 4,
    VK_BLEND_FACTOR_ONE_MINUS_DST_COLOR      = 5,
    VK_BLEND_FACTOR_SRC_ALPHA                = 6,
    VK_BLEND_FACTOR_ONE_MINUS_SRC_ALPHA      = 7,
    VK_BLEND_FACTOR_DST_ALPHA                = 8,
    VK_BLEND_FACTOR_ONE_MINUS_DST_ALPHA      = 9,
    VK_BLEND_FACTOR_CONSTANT_COLOR           = 10,
    VK_BLEND_FACTOR_ONE_MINUS_CONSTANT_COLOR = 11,
    VK_BLEND_FACTOR_CONSTANT_ALPHA           = 12,
    VK_BLEND_FACTOR_ONE_MINUS_CONSTANT_ALPHA = 13,
    VK_BLEND_FACTOR_SRC_ALPHA_SATURATE       = 14,
    VK_BLEND_FACTOR_SRC1_COLOR               = 15,
    VK_BLEND_FACTOR_ONE_MINUS_SRC1_COLOR     = 16,
    VK_BLEND_FACTOR_SRC1_ALPHA               = 17,
    VK_BLEND_FACTOR_ONE_MINUS_SRC1_ALPHA     = 18,
}
enum VK_BLEND_FACTOR_ZERO                     = VkBlendFactor.VK_BLEND_FACTOR_ZERO;
enum VK_BLEND_FACTOR_ONE                      = VkBlendFactor.VK_BLEND_FACTOR_ONE;
enum VK_BLEND_FACTOR_SRC_COLOR                = VkBlendFactor.VK_BLEND_FACTOR_SRC_COLOR;
enum VK_BLEND_FACTOR_ONE_MINUS_SRC_COLOR      = VkBlendFactor.VK_BLEND_FACTOR_ONE_MINUS_SRC_COLOR;
enum VK_BLEND_FACTOR_DST_COLOR                = VkBlendFactor.VK_BLEND_FACTOR_DST_COLOR;
enum VK_BLEND_FACTOR_ONE_MINUS_DST_COLOR      = VkBlendFactor.VK_BLEND_FACTOR_ONE_MINUS_DST_COLOR;
enum VK_BLEND_FACTOR_SRC_ALPHA                = VkBlendFactor.VK_BLEND_FACTOR_SRC_ALPHA;
enum VK_BLEND_FACTOR_ONE_MINUS_SRC_ALPHA      = VkBlendFactor.VK_BLEND_FACTOR_ONE_MINUS_SRC_ALPHA;
enum VK_BLEND_FACTOR_DST_ALPHA                = VkBlendFactor.VK_BLEND_FACTOR_DST_ALPHA;
enum VK_BLEND_FACTOR_ONE_MINUS_DST_ALPHA      = VkBlendFactor.VK_BLEND_FACTOR_ONE_MINUS_DST_ALPHA;
enum VK_BLEND_FACTOR_CONSTANT_COLOR           = VkBlendFactor.VK_BLEND_FACTOR_CONSTANT_COLOR;
enum VK_BLEND_FACTOR_ONE_MINUS_CONSTANT_COLOR = VkBlendFactor.VK_BLEND_FACTOR_ONE_MINUS_CONSTANT_COLOR;
enum VK_BLEND_FACTOR_CONSTANT_ALPHA           = VkBlendFactor.VK_BLEND_FACTOR_CONSTANT_ALPHA;
enum VK_BLEND_FACTOR_ONE_MINUS_CONSTANT_ALPHA = VkBlendFactor.VK_BLEND_FACTOR_ONE_MINUS_CONSTANT_ALPHA;
enum VK_BLEND_FACTOR_SRC_ALPHA_SATURATE       = VkBlendFactor.VK_BLEND_FACTOR_SRC_ALPHA_SATURATE;
enum VK_BLEND_FACTOR_SRC1_COLOR               = VkBlendFactor.VK_BLEND_FACTOR_SRC1_COLOR;
enum VK_BLEND_FACTOR_ONE_MINUS_SRC1_COLOR     = VkBlendFactor.VK_BLEND_FACTOR_ONE_MINUS_SRC1_COLOR;
enum VK_BLEND_FACTOR_SRC1_ALPHA               = VkBlendFactor.VK_BLEND_FACTOR_SRC1_ALPHA;
enum VK_BLEND_FACTOR_ONE_MINUS_SRC1_ALPHA     = VkBlendFactor.VK_BLEND_FACTOR_ONE_MINUS_SRC1_ALPHA;

enum VkBlendOp {
    VK_BLEND_OP_ADD                    = 0,
    VK_BLEND_OP_SUBTRACT               = 1,
    VK_BLEND_OP_REVERSE_SUBTRACT       = 2,
    VK_BLEND_OP_MIN                    = 3,
    VK_BLEND_OP_MAX                    = 4,
    VK_BLEND_OP_ZERO_EXT               = 1000148000,
    VK_BLEND_OP_SRC_EXT                = 1000148001,
    VK_BLEND_OP_DST_EXT                = 1000148002,
    VK_BLEND_OP_SRC_OVER_EXT           = 1000148003,
    VK_BLEND_OP_DST_OVER_EXT           = 1000148004,
    VK_BLEND_OP_SRC_IN_EXT             = 1000148005,
    VK_BLEND_OP_DST_IN_EXT             = 1000148006,
    VK_BLEND_OP_SRC_OUT_EXT            = 1000148007,
    VK_BLEND_OP_DST_OUT_EXT            = 1000148008,
    VK_BLEND_OP_SRC_ATOP_EXT           = 1000148009,
    VK_BLEND_OP_DST_ATOP_EXT           = 1000148010,
    VK_BLEND_OP_XOR_EXT                = 1000148011,
    VK_BLEND_OP_MULTIPLY_EXT           = 1000148012,
    VK_BLEND_OP_SCREEN_EXT             = 1000148013,
    VK_BLEND_OP_OVERLAY_EXT            = 1000148014,
    VK_BLEND_OP_DARKEN_EXT             = 1000148015,
    VK_BLEND_OP_LIGHTEN_EXT            = 1000148016,
    VK_BLEND_OP_COLORDODGE_EXT         = 1000148017,
    VK_BLEND_OP_COLORBURN_EXT          = 1000148018,
    VK_BLEND_OP_HARDLIGHT_EXT          = 1000148019,
    VK_BLEND_OP_SOFTLIGHT_EXT          = 1000148020,
    VK_BLEND_OP_DIFFERENCE_EXT         = 1000148021,
    VK_BLEND_OP_EXCLUSION_EXT          = 1000148022,
    VK_BLEND_OP_INVERT_EXT             = 1000148023,
    VK_BLEND_OP_INVERT_RGB_EXT         = 1000148024,
    VK_BLEND_OP_LINEARDODGE_EXT        = 1000148025,
    VK_BLEND_OP_LINEARBURN_EXT         = 1000148026,
    VK_BLEND_OP_VIVIDLIGHT_EXT         = 1000148027,
    VK_BLEND_OP_LINEARLIGHT_EXT        = 1000148028,
    VK_BLEND_OP_PINLIGHT_EXT           = 1000148029,
    VK_BLEND_OP_HARDMIX_EXT            = 1000148030,
    VK_BLEND_OP_HSL_HUE_EXT            = 1000148031,
    VK_BLEND_OP_HSL_SATURATION_EXT     = 1000148032,
    VK_BLEND_OP_HSL_COLOR_EXT          = 1000148033,
    VK_BLEND_OP_HSL_LUMINOSITY_EXT     = 1000148034,
    VK_BLEND_OP_PLUS_EXT               = 1000148035,
    VK_BLEND_OP_PLUS_CLAMPED_EXT       = 1000148036,
    VK_BLEND_OP_PLUS_CLAMPED_ALPHA_EXT = 1000148037,
    VK_BLEND_OP_PLUS_DARKER_EXT        = 1000148038,
    VK_BLEND_OP_MINUS_EXT              = 1000148039,
    VK_BLEND_OP_MINUS_CLAMPED_EXT      = 1000148040,
    VK_BLEND_OP_CONTRAST_EXT           = 1000148041,
    VK_BLEND_OP_INVERT_OVG_EXT         = 1000148042,
    VK_BLEND_OP_RED_EXT                = 1000148043,
    VK_BLEND_OP_GREEN_EXT              = 1000148044,
    VK_BLEND_OP_BLUE_EXT               = 1000148045,
}
enum VK_BLEND_OP_ADD                    = VkBlendOp.VK_BLEND_OP_ADD;
enum VK_BLEND_OP_SUBTRACT               = VkBlendOp.VK_BLEND_OP_SUBTRACT;
enum VK_BLEND_OP_REVERSE_SUBTRACT       = VkBlendOp.VK_BLEND_OP_REVERSE_SUBTRACT;
enum VK_BLEND_OP_MIN                    = VkBlendOp.VK_BLEND_OP_MIN;
enum VK_BLEND_OP_MAX                    = VkBlendOp.VK_BLEND_OP_MAX;
enum VK_BLEND_OP_ZERO_EXT               = VkBlendOp.VK_BLEND_OP_ZERO_EXT;
enum VK_BLEND_OP_SRC_EXT                = VkBlendOp.VK_BLEND_OP_SRC_EXT;
enum VK_BLEND_OP_DST_EXT                = VkBlendOp.VK_BLEND_OP_DST_EXT;
enum VK_BLEND_OP_SRC_OVER_EXT           = VkBlendOp.VK_BLEND_OP_SRC_OVER_EXT;
enum VK_BLEND_OP_DST_OVER_EXT           = VkBlendOp.VK_BLEND_OP_DST_OVER_EXT;
enum VK_BLEND_OP_SRC_IN_EXT             = VkBlendOp.VK_BLEND_OP_SRC_IN_EXT;
enum VK_BLEND_OP_DST_IN_EXT             = VkBlendOp.VK_BLEND_OP_DST_IN_EXT;
enum VK_BLEND_OP_SRC_OUT_EXT            = VkBlendOp.VK_BLEND_OP_SRC_OUT_EXT;
enum VK_BLEND_OP_DST_OUT_EXT            = VkBlendOp.VK_BLEND_OP_DST_OUT_EXT;
enum VK_BLEND_OP_SRC_ATOP_EXT           = VkBlendOp.VK_BLEND_OP_SRC_ATOP_EXT;
enum VK_BLEND_OP_DST_ATOP_EXT           = VkBlendOp.VK_BLEND_OP_DST_ATOP_EXT;
enum VK_BLEND_OP_XOR_EXT                = VkBlendOp.VK_BLEND_OP_XOR_EXT;
enum VK_BLEND_OP_MULTIPLY_EXT           = VkBlendOp.VK_BLEND_OP_MULTIPLY_EXT;
enum VK_BLEND_OP_SCREEN_EXT             = VkBlendOp.VK_BLEND_OP_SCREEN_EXT;
enum VK_BLEND_OP_OVERLAY_EXT            = VkBlendOp.VK_BLEND_OP_OVERLAY_EXT;
enum VK_BLEND_OP_DARKEN_EXT             = VkBlendOp.VK_BLEND_OP_DARKEN_EXT;
enum VK_BLEND_OP_LIGHTEN_EXT            = VkBlendOp.VK_BLEND_OP_LIGHTEN_EXT;
enum VK_BLEND_OP_COLORDODGE_EXT         = VkBlendOp.VK_BLEND_OP_COLORDODGE_EXT;
enum VK_BLEND_OP_COLORBURN_EXT          = VkBlendOp.VK_BLEND_OP_COLORBURN_EXT;
enum VK_BLEND_OP_HARDLIGHT_EXT          = VkBlendOp.VK_BLEND_OP_HARDLIGHT_EXT;
enum VK_BLEND_OP_SOFTLIGHT_EXT          = VkBlendOp.VK_BLEND_OP_SOFTLIGHT_EXT;
enum VK_BLEND_OP_DIFFERENCE_EXT         = VkBlendOp.VK_BLEND_OP_DIFFERENCE_EXT;
enum VK_BLEND_OP_EXCLUSION_EXT          = VkBlendOp.VK_BLEND_OP_EXCLUSION_EXT;
enum VK_BLEND_OP_INVERT_EXT             = VkBlendOp.VK_BLEND_OP_INVERT_EXT;
enum VK_BLEND_OP_INVERT_RGB_EXT         = VkBlendOp.VK_BLEND_OP_INVERT_RGB_EXT;
enum VK_BLEND_OP_LINEARDODGE_EXT        = VkBlendOp.VK_BLEND_OP_LINEARDODGE_EXT;
enum VK_BLEND_OP_LINEARBURN_EXT         = VkBlendOp.VK_BLEND_OP_LINEARBURN_EXT;
enum VK_BLEND_OP_VIVIDLIGHT_EXT         = VkBlendOp.VK_BLEND_OP_VIVIDLIGHT_EXT;
enum VK_BLEND_OP_LINEARLIGHT_EXT        = VkBlendOp.VK_BLEND_OP_LINEARLIGHT_EXT;
enum VK_BLEND_OP_PINLIGHT_EXT           = VkBlendOp.VK_BLEND_OP_PINLIGHT_EXT;
enum VK_BLEND_OP_HARDMIX_EXT            = VkBlendOp.VK_BLEND_OP_HARDMIX_EXT;
enum VK_BLEND_OP_HSL_HUE_EXT            = VkBlendOp.VK_BLEND_OP_HSL_HUE_EXT;
enum VK_BLEND_OP_HSL_SATURATION_EXT     = VkBlendOp.VK_BLEND_OP_HSL_SATURATION_EXT;
enum VK_BLEND_OP_HSL_COLOR_EXT          = VkBlendOp.VK_BLEND_OP_HSL_COLOR_EXT;
enum VK_BLEND_OP_HSL_LUMINOSITY_EXT     = VkBlendOp.VK_BLEND_OP_HSL_LUMINOSITY_EXT;
enum VK_BLEND_OP_PLUS_EXT               = VkBlendOp.VK_BLEND_OP_PLUS_EXT;
enum VK_BLEND_OP_PLUS_CLAMPED_EXT       = VkBlendOp.VK_BLEND_OP_PLUS_CLAMPED_EXT;
enum VK_BLEND_OP_PLUS_CLAMPED_ALPHA_EXT = VkBlendOp.VK_BLEND_OP_PLUS_CLAMPED_ALPHA_EXT;
enum VK_BLEND_OP_PLUS_DARKER_EXT        = VkBlendOp.VK_BLEND_OP_PLUS_DARKER_EXT;
enum VK_BLEND_OP_MINUS_EXT              = VkBlendOp.VK_BLEND_OP_MINUS_EXT;
enum VK_BLEND_OP_MINUS_CLAMPED_EXT      = VkBlendOp.VK_BLEND_OP_MINUS_CLAMPED_EXT;
enum VK_BLEND_OP_CONTRAST_EXT           = VkBlendOp.VK_BLEND_OP_CONTRAST_EXT;
enum VK_BLEND_OP_INVERT_OVG_EXT         = VkBlendOp.VK_BLEND_OP_INVERT_OVG_EXT;
enum VK_BLEND_OP_RED_EXT                = VkBlendOp.VK_BLEND_OP_RED_EXT;
enum VK_BLEND_OP_GREEN_EXT              = VkBlendOp.VK_BLEND_OP_GREEN_EXT;
enum VK_BLEND_OP_BLUE_EXT               = VkBlendOp.VK_BLEND_OP_BLUE_EXT;

enum VkColorComponentFlagBits : VkFlags {
    VK_COLOR_COMPONENT_R_BIT = 0x00000001,
    VK_COLOR_COMPONENT_G_BIT = 0x00000002,
    VK_COLOR_COMPONENT_B_BIT = 0x00000004,
    VK_COLOR_COMPONENT_A_BIT = 0x00000008,
}
enum VK_COLOR_COMPONENT_R_BIT = VkColorComponentFlagBits.VK_COLOR_COMPONENT_R_BIT;
enum VK_COLOR_COMPONENT_G_BIT = VkColorComponentFlagBits.VK_COLOR_COMPONENT_G_BIT;
enum VK_COLOR_COMPONENT_B_BIT = VkColorComponentFlagBits.VK_COLOR_COMPONENT_B_BIT;
enum VK_COLOR_COMPONENT_A_BIT = VkColorComponentFlagBits.VK_COLOR_COMPONENT_A_BIT;

enum VkDynamicState {
    VK_DYNAMIC_STATE_VIEWPORT                         = 0,
    VK_DYNAMIC_STATE_SCISSOR                          = 1,
    VK_DYNAMIC_STATE_LINE_WIDTH                       = 2,
    VK_DYNAMIC_STATE_DEPTH_BIAS                       = 3,
    VK_DYNAMIC_STATE_BLEND_CONSTANTS                  = 4,
    VK_DYNAMIC_STATE_DEPTH_BOUNDS                     = 5,
    VK_DYNAMIC_STATE_STENCIL_COMPARE_MASK             = 6,
    VK_DYNAMIC_STATE_STENCIL_WRITE_MASK               = 7,
    VK_DYNAMIC_STATE_STENCIL_REFERENCE                = 8,
    VK_DYNAMIC_STATE_VIEWPORT_W_SCALING_NV            = 1000087000,
    VK_DYNAMIC_STATE_DISCARD_RECTANGLE_EXT            = 1000099000,
    VK_DYNAMIC_STATE_SAMPLE_LOCATIONS_EXT             = 1000143000,
    VK_DYNAMIC_STATE_VIEWPORT_SHADING_RATE_PALETTE_NV = 1000164004,
    VK_DYNAMIC_STATE_VIEWPORT_COARSE_SAMPLE_ORDER_NV  = 1000164006,
    VK_DYNAMIC_STATE_EXCLUSIVE_SCISSOR_NV             = 1000205001,
}
enum VK_DYNAMIC_STATE_VIEWPORT                         = VkDynamicState.VK_DYNAMIC_STATE_VIEWPORT;
enum VK_DYNAMIC_STATE_SCISSOR                          = VkDynamicState.VK_DYNAMIC_STATE_SCISSOR;
enum VK_DYNAMIC_STATE_LINE_WIDTH                       = VkDynamicState.VK_DYNAMIC_STATE_LINE_WIDTH;
enum VK_DYNAMIC_STATE_DEPTH_BIAS                       = VkDynamicState.VK_DYNAMIC_STATE_DEPTH_BIAS;
enum VK_DYNAMIC_STATE_BLEND_CONSTANTS                  = VkDynamicState.VK_DYNAMIC_STATE_BLEND_CONSTANTS;
enum VK_DYNAMIC_STATE_DEPTH_BOUNDS                     = VkDynamicState.VK_DYNAMIC_STATE_DEPTH_BOUNDS;
enum VK_DYNAMIC_STATE_STENCIL_COMPARE_MASK             = VkDynamicState.VK_DYNAMIC_STATE_STENCIL_COMPARE_MASK;
enum VK_DYNAMIC_STATE_STENCIL_WRITE_MASK               = VkDynamicState.VK_DYNAMIC_STATE_STENCIL_WRITE_MASK;
enum VK_DYNAMIC_STATE_STENCIL_REFERENCE                = VkDynamicState.VK_DYNAMIC_STATE_STENCIL_REFERENCE;
enum VK_DYNAMIC_STATE_VIEWPORT_W_SCALING_NV            = VkDynamicState.VK_DYNAMIC_STATE_VIEWPORT_W_SCALING_NV;
enum VK_DYNAMIC_STATE_DISCARD_RECTANGLE_EXT            = VkDynamicState.VK_DYNAMIC_STATE_DISCARD_RECTANGLE_EXT;
enum VK_DYNAMIC_STATE_SAMPLE_LOCATIONS_EXT             = VkDynamicState.VK_DYNAMIC_STATE_SAMPLE_LOCATIONS_EXT;
enum VK_DYNAMIC_STATE_VIEWPORT_SHADING_RATE_PALETTE_NV = VkDynamicState.VK_DYNAMIC_STATE_VIEWPORT_SHADING_RATE_PALETTE_NV;
enum VK_DYNAMIC_STATE_VIEWPORT_COARSE_SAMPLE_ORDER_NV  = VkDynamicState.VK_DYNAMIC_STATE_VIEWPORT_COARSE_SAMPLE_ORDER_NV;
enum VK_DYNAMIC_STATE_EXCLUSIVE_SCISSOR_NV             = VkDynamicState.VK_DYNAMIC_STATE_EXCLUSIVE_SCISSOR_NV;

enum VkSamplerCreateFlagBits : VkFlags {
    VK_SAMPLER_CREATE_SUBSAMPLED_BIT_EXT                       = 0x00000001,
    VK_SAMPLER_CREATE_SUBSAMPLED_COARSE_RECONSTRUCTION_BIT_EXT = 0x00000002,
}
enum VK_SAMPLER_CREATE_SUBSAMPLED_BIT_EXT                       = VkSamplerCreateFlagBits.VK_SAMPLER_CREATE_SUBSAMPLED_BIT_EXT;
enum VK_SAMPLER_CREATE_SUBSAMPLED_COARSE_RECONSTRUCTION_BIT_EXT = VkSamplerCreateFlagBits.VK_SAMPLER_CREATE_SUBSAMPLED_COARSE_RECONSTRUCTION_BIT_EXT;

enum VkFilter {
    VK_FILTER_NEAREST   = 0,
    VK_FILTER_LINEAR    = 1,
    VK_FILTER_CUBIC_IMG = 1000015000,
}
enum VK_FILTER_NEAREST   = VkFilter.VK_FILTER_NEAREST;
enum VK_FILTER_LINEAR    = VkFilter.VK_FILTER_LINEAR;
enum VK_FILTER_CUBIC_IMG = VkFilter.VK_FILTER_CUBIC_IMG;

enum VkSamplerMipmapMode {
    VK_SAMPLER_MIPMAP_MODE_NEAREST = 0,
    VK_SAMPLER_MIPMAP_MODE_LINEAR  = 1,
}
enum VK_SAMPLER_MIPMAP_MODE_NEAREST = VkSamplerMipmapMode.VK_SAMPLER_MIPMAP_MODE_NEAREST;
enum VK_SAMPLER_MIPMAP_MODE_LINEAR  = VkSamplerMipmapMode.VK_SAMPLER_MIPMAP_MODE_LINEAR;

enum VkSamplerAddressMode {
    VK_SAMPLER_ADDRESS_MODE_REPEAT               = 0,
    VK_SAMPLER_ADDRESS_MODE_MIRRORED_REPEAT      = 1,
    VK_SAMPLER_ADDRESS_MODE_CLAMP_TO_EDGE        = 2,
    VK_SAMPLER_ADDRESS_MODE_CLAMP_TO_BORDER      = 3,
    VK_SAMPLER_ADDRESS_MODE_MIRROR_CLAMP_TO_EDGE = 4,
}
enum VK_SAMPLER_ADDRESS_MODE_REPEAT               = VkSamplerAddressMode.VK_SAMPLER_ADDRESS_MODE_REPEAT;
enum VK_SAMPLER_ADDRESS_MODE_MIRRORED_REPEAT      = VkSamplerAddressMode.VK_SAMPLER_ADDRESS_MODE_MIRRORED_REPEAT;
enum VK_SAMPLER_ADDRESS_MODE_CLAMP_TO_EDGE        = VkSamplerAddressMode.VK_SAMPLER_ADDRESS_MODE_CLAMP_TO_EDGE;
enum VK_SAMPLER_ADDRESS_MODE_CLAMP_TO_BORDER      = VkSamplerAddressMode.VK_SAMPLER_ADDRESS_MODE_CLAMP_TO_BORDER;
enum VK_SAMPLER_ADDRESS_MODE_MIRROR_CLAMP_TO_EDGE = VkSamplerAddressMode.VK_SAMPLER_ADDRESS_MODE_MIRROR_CLAMP_TO_EDGE;

enum VkBorderColor {
    VK_BORDER_COLOR_FLOAT_TRANSPARENT_BLACK = 0,
    VK_BORDER_COLOR_INT_TRANSPARENT_BLACK   = 1,
    VK_BORDER_COLOR_FLOAT_OPAQUE_BLACK      = 2,
    VK_BORDER_COLOR_INT_OPAQUE_BLACK        = 3,
    VK_BORDER_COLOR_FLOAT_OPAQUE_WHITE      = 4,
    VK_BORDER_COLOR_INT_OPAQUE_WHITE        = 5,
}
enum VK_BORDER_COLOR_FLOAT_TRANSPARENT_BLACK = VkBorderColor.VK_BORDER_COLOR_FLOAT_TRANSPARENT_BLACK;
enum VK_BORDER_COLOR_INT_TRANSPARENT_BLACK   = VkBorderColor.VK_BORDER_COLOR_INT_TRANSPARENT_BLACK;
enum VK_BORDER_COLOR_FLOAT_OPAQUE_BLACK      = VkBorderColor.VK_BORDER_COLOR_FLOAT_OPAQUE_BLACK;
enum VK_BORDER_COLOR_INT_OPAQUE_BLACK        = VkBorderColor.VK_BORDER_COLOR_INT_OPAQUE_BLACK;
enum VK_BORDER_COLOR_FLOAT_OPAQUE_WHITE      = VkBorderColor.VK_BORDER_COLOR_FLOAT_OPAQUE_WHITE;
enum VK_BORDER_COLOR_INT_OPAQUE_WHITE        = VkBorderColor.VK_BORDER_COLOR_INT_OPAQUE_WHITE;

enum VkDescriptorSetLayoutCreateFlagBits : VkFlags {
    VK_DESCRIPTOR_SET_LAYOUT_CREATE_PUSH_DESCRIPTOR_BIT_KHR        = 0x00000001,
    VK_DESCRIPTOR_SET_LAYOUT_CREATE_UPDATE_AFTER_BIND_POOL_BIT_EXT = 0x00000002,
}
enum VK_DESCRIPTOR_SET_LAYOUT_CREATE_PUSH_DESCRIPTOR_BIT_KHR        = VkDescriptorSetLayoutCreateFlagBits.VK_DESCRIPTOR_SET_LAYOUT_CREATE_PUSH_DESCRIPTOR_BIT_KHR;
enum VK_DESCRIPTOR_SET_LAYOUT_CREATE_UPDATE_AFTER_BIND_POOL_BIT_EXT = VkDescriptorSetLayoutCreateFlagBits.VK_DESCRIPTOR_SET_LAYOUT_CREATE_UPDATE_AFTER_BIND_POOL_BIT_EXT;

enum VkDescriptorType {
    VK_DESCRIPTOR_TYPE_SAMPLER                   = 0,
    VK_DESCRIPTOR_TYPE_COMBINED_IMAGE_SAMPLER    = 1,
    VK_DESCRIPTOR_TYPE_SAMPLED_IMAGE             = 2,
    VK_DESCRIPTOR_TYPE_STORAGE_IMAGE             = 3,
    VK_DESCRIPTOR_TYPE_UNIFORM_TEXEL_BUFFER      = 4,
    VK_DESCRIPTOR_TYPE_STORAGE_TEXEL_BUFFER      = 5,
    VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER            = 6,
    VK_DESCRIPTOR_TYPE_STORAGE_BUFFER            = 7,
    VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER_DYNAMIC    = 8,
    VK_DESCRIPTOR_TYPE_STORAGE_BUFFER_DYNAMIC    = 9,
    VK_DESCRIPTOR_TYPE_INPUT_ATTACHMENT          = 10,
    VK_DESCRIPTOR_TYPE_INLINE_UNIFORM_BLOCK_EXT  = 1000138000,
    VK_DESCRIPTOR_TYPE_ACCELERATION_STRUCTURE_NV = 1000165000,
}
enum VK_DESCRIPTOR_TYPE_SAMPLER                   = VkDescriptorType.VK_DESCRIPTOR_TYPE_SAMPLER;
enum VK_DESCRIPTOR_TYPE_COMBINED_IMAGE_SAMPLER    = VkDescriptorType.VK_DESCRIPTOR_TYPE_COMBINED_IMAGE_SAMPLER;
enum VK_DESCRIPTOR_TYPE_SAMPLED_IMAGE             = VkDescriptorType.VK_DESCRIPTOR_TYPE_SAMPLED_IMAGE;
enum VK_DESCRIPTOR_TYPE_STORAGE_IMAGE             = VkDescriptorType.VK_DESCRIPTOR_TYPE_STORAGE_IMAGE;
enum VK_DESCRIPTOR_TYPE_UNIFORM_TEXEL_BUFFER      = VkDescriptorType.VK_DESCRIPTOR_TYPE_UNIFORM_TEXEL_BUFFER;
enum VK_DESCRIPTOR_TYPE_STORAGE_TEXEL_BUFFER      = VkDescriptorType.VK_DESCRIPTOR_TYPE_STORAGE_TEXEL_BUFFER;
enum VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER            = VkDescriptorType.VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER;
enum VK_DESCRIPTOR_TYPE_STORAGE_BUFFER            = VkDescriptorType.VK_DESCRIPTOR_TYPE_STORAGE_BUFFER;
enum VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER_DYNAMIC    = VkDescriptorType.VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER_DYNAMIC;
enum VK_DESCRIPTOR_TYPE_STORAGE_BUFFER_DYNAMIC    = VkDescriptorType.VK_DESCRIPTOR_TYPE_STORAGE_BUFFER_DYNAMIC;
enum VK_DESCRIPTOR_TYPE_INPUT_ATTACHMENT          = VkDescriptorType.VK_DESCRIPTOR_TYPE_INPUT_ATTACHMENT;
enum VK_DESCRIPTOR_TYPE_INLINE_UNIFORM_BLOCK_EXT  = VkDescriptorType.VK_DESCRIPTOR_TYPE_INLINE_UNIFORM_BLOCK_EXT;
enum VK_DESCRIPTOR_TYPE_ACCELERATION_STRUCTURE_NV = VkDescriptorType.VK_DESCRIPTOR_TYPE_ACCELERATION_STRUCTURE_NV;

enum VkDescriptorPoolCreateFlagBits : VkFlags {
    VK_DESCRIPTOR_POOL_CREATE_FREE_DESCRIPTOR_SET_BIT   = 0x00000001,
    VK_DESCRIPTOR_POOL_CREATE_UPDATE_AFTER_BIND_BIT_EXT = 0x00000002,
}
enum VK_DESCRIPTOR_POOL_CREATE_FREE_DESCRIPTOR_SET_BIT   = VkDescriptorPoolCreateFlagBits.VK_DESCRIPTOR_POOL_CREATE_FREE_DESCRIPTOR_SET_BIT;
enum VK_DESCRIPTOR_POOL_CREATE_UPDATE_AFTER_BIND_BIT_EXT = VkDescriptorPoolCreateFlagBits.VK_DESCRIPTOR_POOL_CREATE_UPDATE_AFTER_BIND_BIT_EXT;

enum VkAttachmentDescriptionFlagBits : VkFlags {
    VK_ATTACHMENT_DESCRIPTION_MAY_ALIAS_BIT = 0x00000001,
}
enum VK_ATTACHMENT_DESCRIPTION_MAY_ALIAS_BIT = VkAttachmentDescriptionFlagBits.VK_ATTACHMENT_DESCRIPTION_MAY_ALIAS_BIT;

enum VkAttachmentLoadOp {
    VK_ATTACHMENT_LOAD_OP_LOAD      = 0,
    VK_ATTACHMENT_LOAD_OP_CLEAR     = 1,
    VK_ATTACHMENT_LOAD_OP_DONT_CARE = 2,
}
enum VK_ATTACHMENT_LOAD_OP_LOAD      = VkAttachmentLoadOp.VK_ATTACHMENT_LOAD_OP_LOAD;
enum VK_ATTACHMENT_LOAD_OP_CLEAR     = VkAttachmentLoadOp.VK_ATTACHMENT_LOAD_OP_CLEAR;
enum VK_ATTACHMENT_LOAD_OP_DONT_CARE = VkAttachmentLoadOp.VK_ATTACHMENT_LOAD_OP_DONT_CARE;

enum VkAttachmentStoreOp {
    VK_ATTACHMENT_STORE_OP_STORE     = 0,
    VK_ATTACHMENT_STORE_OP_DONT_CARE = 1,
}
enum VK_ATTACHMENT_STORE_OP_STORE     = VkAttachmentStoreOp.VK_ATTACHMENT_STORE_OP_STORE;
enum VK_ATTACHMENT_STORE_OP_DONT_CARE = VkAttachmentStoreOp.VK_ATTACHMENT_STORE_OP_DONT_CARE;

enum VkSubpassDescriptionFlagBits : VkFlags {
    VK_SUBPASS_DESCRIPTION_PER_VIEW_ATTRIBUTES_BIT_NVX      = 0x00000001,
    VK_SUBPASS_DESCRIPTION_PER_VIEW_POSITION_X_ONLY_BIT_NVX = 0x00000002,
}
enum VK_SUBPASS_DESCRIPTION_PER_VIEW_ATTRIBUTES_BIT_NVX      = VkSubpassDescriptionFlagBits.VK_SUBPASS_DESCRIPTION_PER_VIEW_ATTRIBUTES_BIT_NVX;
enum VK_SUBPASS_DESCRIPTION_PER_VIEW_POSITION_X_ONLY_BIT_NVX = VkSubpassDescriptionFlagBits.VK_SUBPASS_DESCRIPTION_PER_VIEW_POSITION_X_ONLY_BIT_NVX;

enum VkPipelineBindPoint {
    VK_PIPELINE_BIND_POINT_GRAPHICS       = 0,
    VK_PIPELINE_BIND_POINT_COMPUTE        = 1,
    VK_PIPELINE_BIND_POINT_RAY_TRACING_NV = 1000165000,
}
enum VK_PIPELINE_BIND_POINT_GRAPHICS       = VkPipelineBindPoint.VK_PIPELINE_BIND_POINT_GRAPHICS;
enum VK_PIPELINE_BIND_POINT_COMPUTE        = VkPipelineBindPoint.VK_PIPELINE_BIND_POINT_COMPUTE;
enum VK_PIPELINE_BIND_POINT_RAY_TRACING_NV = VkPipelineBindPoint.VK_PIPELINE_BIND_POINT_RAY_TRACING_NV;

enum VkAccessFlagBits : VkFlags {
    VK_ACCESS_INDIRECT_COMMAND_READ_BIT                 = 0x00000001,
    VK_ACCESS_INDEX_READ_BIT                            = 0x00000002,
    VK_ACCESS_VERTEX_ATTRIBUTE_READ_BIT                 = 0x00000004,
    VK_ACCESS_UNIFORM_READ_BIT                          = 0x00000008,
    VK_ACCESS_INPUT_ATTACHMENT_READ_BIT                 = 0x00000010,
    VK_ACCESS_SHADER_READ_BIT                           = 0x00000020,
    VK_ACCESS_SHADER_WRITE_BIT                          = 0x00000040,
    VK_ACCESS_COLOR_ATTACHMENT_READ_BIT                 = 0x00000080,
    VK_ACCESS_COLOR_ATTACHMENT_WRITE_BIT                = 0x00000100,
    VK_ACCESS_DEPTH_STENCIL_ATTACHMENT_READ_BIT         = 0x00000200,
    VK_ACCESS_DEPTH_STENCIL_ATTACHMENT_WRITE_BIT        = 0x00000400,
    VK_ACCESS_TRANSFER_READ_BIT                         = 0x00000800,
    VK_ACCESS_TRANSFER_WRITE_BIT                        = 0x00001000,
    VK_ACCESS_HOST_READ_BIT                             = 0x00002000,
    VK_ACCESS_HOST_WRITE_BIT                            = 0x00004000,
    VK_ACCESS_MEMORY_READ_BIT                           = 0x00008000,
    VK_ACCESS_MEMORY_WRITE_BIT                          = 0x00010000,
    VK_ACCESS_RESERVED_30_BIT_KHR                       = 0x40000000,
    VK_ACCESS_RESERVED_31_BIT_KHR                       = 0x80000000,
    VK_ACCESS_RESERVED_28_BIT_KHR                       = 0x10000000,
    VK_ACCESS_RESERVED_29_BIT_KHR                       = 0x20000000,
    VK_ACCESS_TRANSFORM_FEEDBACK_WRITE_BIT_EXT          = 0x02000000,
    VK_ACCESS_TRANSFORM_FEEDBACK_COUNTER_READ_BIT_EXT   = 0x04000000,
    VK_ACCESS_TRANSFORM_FEEDBACK_COUNTER_WRITE_BIT_EXT  = 0x08000000,
    VK_ACCESS_CONDITIONAL_RENDERING_READ_BIT_EXT        = 0x00100000,
    VK_ACCESS_COMMAND_PROCESS_READ_BIT_NVX              = 0x00020000,
    VK_ACCESS_COMMAND_PROCESS_WRITE_BIT_NVX             = 0x00040000,
    VK_ACCESS_COLOR_ATTACHMENT_READ_NONCOHERENT_BIT_EXT = 0x00080000,
    VK_ACCESS_SHADING_RATE_IMAGE_READ_BIT_NV            = 0x00800000,
    VK_ACCESS_ACCELERATION_STRUCTURE_READ_BIT_NV        = 0x00200000,
    VK_ACCESS_ACCELERATION_STRUCTURE_WRITE_BIT_NV       = 0x00400000,
    VK_ACCESS_FRAGMENT_DENSITY_MAP_READ_BIT_EXT         = 0x01000000,
}
enum VK_ACCESS_INDIRECT_COMMAND_READ_BIT                 = VkAccessFlagBits.VK_ACCESS_INDIRECT_COMMAND_READ_BIT;
enum VK_ACCESS_INDEX_READ_BIT                            = VkAccessFlagBits.VK_ACCESS_INDEX_READ_BIT;
enum VK_ACCESS_VERTEX_ATTRIBUTE_READ_BIT                 = VkAccessFlagBits.VK_ACCESS_VERTEX_ATTRIBUTE_READ_BIT;
enum VK_ACCESS_UNIFORM_READ_BIT                          = VkAccessFlagBits.VK_ACCESS_UNIFORM_READ_BIT;
enum VK_ACCESS_INPUT_ATTACHMENT_READ_BIT                 = VkAccessFlagBits.VK_ACCESS_INPUT_ATTACHMENT_READ_BIT;
enum VK_ACCESS_SHADER_READ_BIT                           = VkAccessFlagBits.VK_ACCESS_SHADER_READ_BIT;
enum VK_ACCESS_SHADER_WRITE_BIT                          = VkAccessFlagBits.VK_ACCESS_SHADER_WRITE_BIT;
enum VK_ACCESS_COLOR_ATTACHMENT_READ_BIT                 = VkAccessFlagBits.VK_ACCESS_COLOR_ATTACHMENT_READ_BIT;
enum VK_ACCESS_COLOR_ATTACHMENT_WRITE_BIT                = VkAccessFlagBits.VK_ACCESS_COLOR_ATTACHMENT_WRITE_BIT;
enum VK_ACCESS_DEPTH_STENCIL_ATTACHMENT_READ_BIT         = VkAccessFlagBits.VK_ACCESS_DEPTH_STENCIL_ATTACHMENT_READ_BIT;
enum VK_ACCESS_DEPTH_STENCIL_ATTACHMENT_WRITE_BIT        = VkAccessFlagBits.VK_ACCESS_DEPTH_STENCIL_ATTACHMENT_WRITE_BIT;
enum VK_ACCESS_TRANSFER_READ_BIT                         = VkAccessFlagBits.VK_ACCESS_TRANSFER_READ_BIT;
enum VK_ACCESS_TRANSFER_WRITE_BIT                        = VkAccessFlagBits.VK_ACCESS_TRANSFER_WRITE_BIT;
enum VK_ACCESS_HOST_READ_BIT                             = VkAccessFlagBits.VK_ACCESS_HOST_READ_BIT;
enum VK_ACCESS_HOST_WRITE_BIT                            = VkAccessFlagBits.VK_ACCESS_HOST_WRITE_BIT;
enum VK_ACCESS_MEMORY_READ_BIT                           = VkAccessFlagBits.VK_ACCESS_MEMORY_READ_BIT;
enum VK_ACCESS_MEMORY_WRITE_BIT                          = VkAccessFlagBits.VK_ACCESS_MEMORY_WRITE_BIT;
enum VK_ACCESS_RESERVED_30_BIT_KHR                       = VkAccessFlagBits.VK_ACCESS_RESERVED_30_BIT_KHR;
enum VK_ACCESS_RESERVED_31_BIT_KHR                       = VkAccessFlagBits.VK_ACCESS_RESERVED_31_BIT_KHR;
enum VK_ACCESS_RESERVED_28_BIT_KHR                       = VkAccessFlagBits.VK_ACCESS_RESERVED_28_BIT_KHR;
enum VK_ACCESS_RESERVED_29_BIT_KHR                       = VkAccessFlagBits.VK_ACCESS_RESERVED_29_BIT_KHR;
enum VK_ACCESS_TRANSFORM_FEEDBACK_WRITE_BIT_EXT          = VkAccessFlagBits.VK_ACCESS_TRANSFORM_FEEDBACK_WRITE_BIT_EXT;
enum VK_ACCESS_TRANSFORM_FEEDBACK_COUNTER_READ_BIT_EXT   = VkAccessFlagBits.VK_ACCESS_TRANSFORM_FEEDBACK_COUNTER_READ_BIT_EXT;
enum VK_ACCESS_TRANSFORM_FEEDBACK_COUNTER_WRITE_BIT_EXT  = VkAccessFlagBits.VK_ACCESS_TRANSFORM_FEEDBACK_COUNTER_WRITE_BIT_EXT;
enum VK_ACCESS_CONDITIONAL_RENDERING_READ_BIT_EXT        = VkAccessFlagBits.VK_ACCESS_CONDITIONAL_RENDERING_READ_BIT_EXT;
enum VK_ACCESS_COMMAND_PROCESS_READ_BIT_NVX              = VkAccessFlagBits.VK_ACCESS_COMMAND_PROCESS_READ_BIT_NVX;
enum VK_ACCESS_COMMAND_PROCESS_WRITE_BIT_NVX             = VkAccessFlagBits.VK_ACCESS_COMMAND_PROCESS_WRITE_BIT_NVX;
enum VK_ACCESS_COLOR_ATTACHMENT_READ_NONCOHERENT_BIT_EXT = VkAccessFlagBits.VK_ACCESS_COLOR_ATTACHMENT_READ_NONCOHERENT_BIT_EXT;
enum VK_ACCESS_SHADING_RATE_IMAGE_READ_BIT_NV            = VkAccessFlagBits.VK_ACCESS_SHADING_RATE_IMAGE_READ_BIT_NV;
enum VK_ACCESS_ACCELERATION_STRUCTURE_READ_BIT_NV        = VkAccessFlagBits.VK_ACCESS_ACCELERATION_STRUCTURE_READ_BIT_NV;
enum VK_ACCESS_ACCELERATION_STRUCTURE_WRITE_BIT_NV       = VkAccessFlagBits.VK_ACCESS_ACCELERATION_STRUCTURE_WRITE_BIT_NV;
enum VK_ACCESS_FRAGMENT_DENSITY_MAP_READ_BIT_EXT         = VkAccessFlagBits.VK_ACCESS_FRAGMENT_DENSITY_MAP_READ_BIT_EXT;

enum VkDependencyFlagBits : VkFlags {
    VK_DEPENDENCY_BY_REGION_BIT        = 0x00000001,
    VK_DEPENDENCY_DEVICE_GROUP_BIT     = 0x00000004,
    VK_DEPENDENCY_VIEW_LOCAL_BIT       = 0x00000002,
    VK_DEPENDENCY_VIEW_LOCAL_BIT_KHR   = VK_DEPENDENCY_VIEW_LOCAL_BIT,
    VK_DEPENDENCY_DEVICE_GROUP_BIT_KHR = VK_DEPENDENCY_DEVICE_GROUP_BIT,
}
enum VK_DEPENDENCY_BY_REGION_BIT        = VkDependencyFlagBits.VK_DEPENDENCY_BY_REGION_BIT;
enum VK_DEPENDENCY_DEVICE_GROUP_BIT     = VkDependencyFlagBits.VK_DEPENDENCY_DEVICE_GROUP_BIT;
enum VK_DEPENDENCY_VIEW_LOCAL_BIT       = VkDependencyFlagBits.VK_DEPENDENCY_VIEW_LOCAL_BIT;
enum VK_DEPENDENCY_VIEW_LOCAL_BIT_KHR   = VkDependencyFlagBits.VK_DEPENDENCY_VIEW_LOCAL_BIT_KHR;
enum VK_DEPENDENCY_DEVICE_GROUP_BIT_KHR = VkDependencyFlagBits.VK_DEPENDENCY_DEVICE_GROUP_BIT_KHR;

enum VkCommandPoolCreateFlagBits : VkFlags {
    VK_COMMAND_POOL_CREATE_TRANSIENT_BIT            = 0x00000001,
    VK_COMMAND_POOL_CREATE_RESET_COMMAND_BUFFER_BIT = 0x00000002,
    VK_COMMAND_POOL_CREATE_PROTECTED_BIT            = 0x00000004,
}
enum VK_COMMAND_POOL_CREATE_TRANSIENT_BIT            = VkCommandPoolCreateFlagBits.VK_COMMAND_POOL_CREATE_TRANSIENT_BIT;
enum VK_COMMAND_POOL_CREATE_RESET_COMMAND_BUFFER_BIT = VkCommandPoolCreateFlagBits.VK_COMMAND_POOL_CREATE_RESET_COMMAND_BUFFER_BIT;
enum VK_COMMAND_POOL_CREATE_PROTECTED_BIT            = VkCommandPoolCreateFlagBits.VK_COMMAND_POOL_CREATE_PROTECTED_BIT;

enum VkCommandPoolResetFlagBits : VkFlags {
    VK_COMMAND_POOL_RESET_RELEASE_RESOURCES_BIT = 0x00000001,
}
enum VK_COMMAND_POOL_RESET_RELEASE_RESOURCES_BIT = VkCommandPoolResetFlagBits.VK_COMMAND_POOL_RESET_RELEASE_RESOURCES_BIT;

enum VkCommandBufferLevel {
    VK_COMMAND_BUFFER_LEVEL_PRIMARY   = 0,
    VK_COMMAND_BUFFER_LEVEL_SECONDARY = 1,
}
enum VK_COMMAND_BUFFER_LEVEL_PRIMARY   = VkCommandBufferLevel.VK_COMMAND_BUFFER_LEVEL_PRIMARY;
enum VK_COMMAND_BUFFER_LEVEL_SECONDARY = VkCommandBufferLevel.VK_COMMAND_BUFFER_LEVEL_SECONDARY;

enum VkCommandBufferUsageFlagBits : VkFlags {
    VK_COMMAND_BUFFER_USAGE_ONE_TIME_SUBMIT_BIT      = 0x00000001,
    VK_COMMAND_BUFFER_USAGE_RENDER_PASS_CONTINUE_BIT = 0x00000002,
    VK_COMMAND_BUFFER_USAGE_SIMULTANEOUS_USE_BIT     = 0x00000004,
}
enum VK_COMMAND_BUFFER_USAGE_ONE_TIME_SUBMIT_BIT      = VkCommandBufferUsageFlagBits.VK_COMMAND_BUFFER_USAGE_ONE_TIME_SUBMIT_BIT;
enum VK_COMMAND_BUFFER_USAGE_RENDER_PASS_CONTINUE_BIT = VkCommandBufferUsageFlagBits.VK_COMMAND_BUFFER_USAGE_RENDER_PASS_CONTINUE_BIT;
enum VK_COMMAND_BUFFER_USAGE_SIMULTANEOUS_USE_BIT     = VkCommandBufferUsageFlagBits.VK_COMMAND_BUFFER_USAGE_SIMULTANEOUS_USE_BIT;

enum VkQueryControlFlagBits : VkFlags {
    VK_QUERY_CONTROL_PRECISE_BIT = 0x00000001,
}
enum VK_QUERY_CONTROL_PRECISE_BIT = VkQueryControlFlagBits.VK_QUERY_CONTROL_PRECISE_BIT;

enum VkCommandBufferResetFlagBits : VkFlags {
    VK_COMMAND_BUFFER_RESET_RELEASE_RESOURCES_BIT = 0x00000001,
}
enum VK_COMMAND_BUFFER_RESET_RELEASE_RESOURCES_BIT = VkCommandBufferResetFlagBits.VK_COMMAND_BUFFER_RESET_RELEASE_RESOURCES_BIT;

enum VkStencilFaceFlagBits : VkFlags {
    VK_STENCIL_FACE_FRONT_BIT = 0x00000001,
    VK_STENCIL_FACE_BACK_BIT  = 0x00000002,
    VK_STENCIL_FRONT_AND_BACK = 0x00000003,
}
enum VK_STENCIL_FACE_FRONT_BIT = VkStencilFaceFlagBits.VK_STENCIL_FACE_FRONT_BIT;
enum VK_STENCIL_FACE_BACK_BIT  = VkStencilFaceFlagBits.VK_STENCIL_FACE_BACK_BIT;
enum VK_STENCIL_FRONT_AND_BACK = VkStencilFaceFlagBits.VK_STENCIL_FRONT_AND_BACK;

enum VkIndexType {
    VK_INDEX_TYPE_UINT16  = 0,
    VK_INDEX_TYPE_UINT32  = 1,
    VK_INDEX_TYPE_NONE_NV = 1000165000,
}
enum VK_INDEX_TYPE_UINT16  = VkIndexType.VK_INDEX_TYPE_UINT16;
enum VK_INDEX_TYPE_UINT32  = VkIndexType.VK_INDEX_TYPE_UINT32;
enum VK_INDEX_TYPE_NONE_NV = VkIndexType.VK_INDEX_TYPE_NONE_NV;

enum VkSubpassContents {
    VK_SUBPASS_CONTENTS_INLINE                    = 0,
    VK_SUBPASS_CONTENTS_SECONDARY_COMMAND_BUFFERS = 1,
}
enum VK_SUBPASS_CONTENTS_INLINE                    = VkSubpassContents.VK_SUBPASS_CONTENTS_INLINE;
enum VK_SUBPASS_CONTENTS_SECONDARY_COMMAND_BUFFERS = VkSubpassContents.VK_SUBPASS_CONTENTS_SECONDARY_COMMAND_BUFFERS;

enum VkObjectType {
    VK_OBJECT_TYPE_UNKNOWN                        = 0,
    VK_OBJECT_TYPE_INSTANCE                       = 1,
    VK_OBJECT_TYPE_PHYSICAL_DEVICE                = 2,
    VK_OBJECT_TYPE_DEVICE                         = 3,
    VK_OBJECT_TYPE_QUEUE                          = 4,
    VK_OBJECT_TYPE_SEMAPHORE                      = 5,
    VK_OBJECT_TYPE_COMMAND_BUFFER                 = 6,
    VK_OBJECT_TYPE_FENCE                          = 7,
    VK_OBJECT_TYPE_DEVICE_MEMORY                  = 8,
    VK_OBJECT_TYPE_BUFFER                         = 9,
    VK_OBJECT_TYPE_IMAGE                          = 10,
    VK_OBJECT_TYPE_EVENT                          = 11,
    VK_OBJECT_TYPE_QUERY_POOL                     = 12,
    VK_OBJECT_TYPE_BUFFER_VIEW                    = 13,
    VK_OBJECT_TYPE_IMAGE_VIEW                     = 14,
    VK_OBJECT_TYPE_SHADER_MODULE                  = 15,
    VK_OBJECT_TYPE_PIPELINE_CACHE                 = 16,
    VK_OBJECT_TYPE_PIPELINE_LAYOUT                = 17,
    VK_OBJECT_TYPE_RENDER_PASS                    = 18,
    VK_OBJECT_TYPE_PIPELINE                       = 19,
    VK_OBJECT_TYPE_DESCRIPTOR_SET_LAYOUT          = 20,
    VK_OBJECT_TYPE_SAMPLER                        = 21,
    VK_OBJECT_TYPE_DESCRIPTOR_POOL                = 22,
    VK_OBJECT_TYPE_DESCRIPTOR_SET                 = 23,
    VK_OBJECT_TYPE_FRAMEBUFFER                    = 24,
    VK_OBJECT_TYPE_COMMAND_POOL                   = 25,
    VK_OBJECT_TYPE_SAMPLER_YCBCR_CONVERSION       = 1000156000,
    VK_OBJECT_TYPE_DESCRIPTOR_UPDATE_TEMPLATE     = 1000085000,
    VK_OBJECT_TYPE_SURFACE_KHR                    = 1000000000,
    VK_OBJECT_TYPE_SWAPCHAIN_KHR                  = 1000001000,
    VK_OBJECT_TYPE_DISPLAY_KHR                    = 1000002000,
    VK_OBJECT_TYPE_DISPLAY_MODE_KHR               = 1000002001,
    VK_OBJECT_TYPE_DEBUG_REPORT_CALLBACK_EXT      = 1000011000,
    VK_OBJECT_TYPE_DESCRIPTOR_UPDATE_TEMPLATE_KHR = VK_OBJECT_TYPE_DESCRIPTOR_UPDATE_TEMPLATE,
    VK_OBJECT_TYPE_OBJECT_TABLE_NVX               = 1000086000,
    VK_OBJECT_TYPE_INDIRECT_COMMANDS_LAYOUT_NVX   = 1000086001,
    VK_OBJECT_TYPE_DEBUG_UTILS_MESSENGER_EXT      = 1000128000,
    VK_OBJECT_TYPE_SAMPLER_YCBCR_CONVERSION_KHR   = VK_OBJECT_TYPE_SAMPLER_YCBCR_CONVERSION,
    VK_OBJECT_TYPE_VALIDATION_CACHE_EXT           = 1000160000,
    VK_OBJECT_TYPE_ACCELERATION_STRUCTURE_NV      = 1000165000,
}
enum VK_OBJECT_TYPE_UNKNOWN                        = VkObjectType.VK_OBJECT_TYPE_UNKNOWN;
enum VK_OBJECT_TYPE_INSTANCE                       = VkObjectType.VK_OBJECT_TYPE_INSTANCE;
enum VK_OBJECT_TYPE_PHYSICAL_DEVICE                = VkObjectType.VK_OBJECT_TYPE_PHYSICAL_DEVICE;
enum VK_OBJECT_TYPE_DEVICE                         = VkObjectType.VK_OBJECT_TYPE_DEVICE;
enum VK_OBJECT_TYPE_QUEUE                          = VkObjectType.VK_OBJECT_TYPE_QUEUE;
enum VK_OBJECT_TYPE_SEMAPHORE                      = VkObjectType.VK_OBJECT_TYPE_SEMAPHORE;
enum VK_OBJECT_TYPE_COMMAND_BUFFER                 = VkObjectType.VK_OBJECT_TYPE_COMMAND_BUFFER;
enum VK_OBJECT_TYPE_FENCE                          = VkObjectType.VK_OBJECT_TYPE_FENCE;
enum VK_OBJECT_TYPE_DEVICE_MEMORY                  = VkObjectType.VK_OBJECT_TYPE_DEVICE_MEMORY;
enum VK_OBJECT_TYPE_BUFFER                         = VkObjectType.VK_OBJECT_TYPE_BUFFER;
enum VK_OBJECT_TYPE_IMAGE                          = VkObjectType.VK_OBJECT_TYPE_IMAGE;
enum VK_OBJECT_TYPE_EVENT                          = VkObjectType.VK_OBJECT_TYPE_EVENT;
enum VK_OBJECT_TYPE_QUERY_POOL                     = VkObjectType.VK_OBJECT_TYPE_QUERY_POOL;
enum VK_OBJECT_TYPE_BUFFER_VIEW                    = VkObjectType.VK_OBJECT_TYPE_BUFFER_VIEW;
enum VK_OBJECT_TYPE_IMAGE_VIEW                     = VkObjectType.VK_OBJECT_TYPE_IMAGE_VIEW;
enum VK_OBJECT_TYPE_SHADER_MODULE                  = VkObjectType.VK_OBJECT_TYPE_SHADER_MODULE;
enum VK_OBJECT_TYPE_PIPELINE_CACHE                 = VkObjectType.VK_OBJECT_TYPE_PIPELINE_CACHE;
enum VK_OBJECT_TYPE_PIPELINE_LAYOUT                = VkObjectType.VK_OBJECT_TYPE_PIPELINE_LAYOUT;
enum VK_OBJECT_TYPE_RENDER_PASS                    = VkObjectType.VK_OBJECT_TYPE_RENDER_PASS;
enum VK_OBJECT_TYPE_PIPELINE                       = VkObjectType.VK_OBJECT_TYPE_PIPELINE;
enum VK_OBJECT_TYPE_DESCRIPTOR_SET_LAYOUT          = VkObjectType.VK_OBJECT_TYPE_DESCRIPTOR_SET_LAYOUT;
enum VK_OBJECT_TYPE_SAMPLER                        = VkObjectType.VK_OBJECT_TYPE_SAMPLER;
enum VK_OBJECT_TYPE_DESCRIPTOR_POOL                = VkObjectType.VK_OBJECT_TYPE_DESCRIPTOR_POOL;
enum VK_OBJECT_TYPE_DESCRIPTOR_SET                 = VkObjectType.VK_OBJECT_TYPE_DESCRIPTOR_SET;
enum VK_OBJECT_TYPE_FRAMEBUFFER                    = VkObjectType.VK_OBJECT_TYPE_FRAMEBUFFER;
enum VK_OBJECT_TYPE_COMMAND_POOL                   = VkObjectType.VK_OBJECT_TYPE_COMMAND_POOL;
enum VK_OBJECT_TYPE_SAMPLER_YCBCR_CONVERSION       = VkObjectType.VK_OBJECT_TYPE_SAMPLER_YCBCR_CONVERSION;
enum VK_OBJECT_TYPE_DESCRIPTOR_UPDATE_TEMPLATE     = VkObjectType.VK_OBJECT_TYPE_DESCRIPTOR_UPDATE_TEMPLATE;
enum VK_OBJECT_TYPE_SURFACE_KHR                    = VkObjectType.VK_OBJECT_TYPE_SURFACE_KHR;
enum VK_OBJECT_TYPE_SWAPCHAIN_KHR                  = VkObjectType.VK_OBJECT_TYPE_SWAPCHAIN_KHR;
enum VK_OBJECT_TYPE_DISPLAY_KHR                    = VkObjectType.VK_OBJECT_TYPE_DISPLAY_KHR;
enum VK_OBJECT_TYPE_DISPLAY_MODE_KHR               = VkObjectType.VK_OBJECT_TYPE_DISPLAY_MODE_KHR;
enum VK_OBJECT_TYPE_DEBUG_REPORT_CALLBACK_EXT      = VkObjectType.VK_OBJECT_TYPE_DEBUG_REPORT_CALLBACK_EXT;
enum VK_OBJECT_TYPE_DESCRIPTOR_UPDATE_TEMPLATE_KHR = VkObjectType.VK_OBJECT_TYPE_DESCRIPTOR_UPDATE_TEMPLATE_KHR;
enum VK_OBJECT_TYPE_OBJECT_TABLE_NVX               = VkObjectType.VK_OBJECT_TYPE_OBJECT_TABLE_NVX;
enum VK_OBJECT_TYPE_INDIRECT_COMMANDS_LAYOUT_NVX   = VkObjectType.VK_OBJECT_TYPE_INDIRECT_COMMANDS_LAYOUT_NVX;
enum VK_OBJECT_TYPE_DEBUG_UTILS_MESSENGER_EXT      = VkObjectType.VK_OBJECT_TYPE_DEBUG_UTILS_MESSENGER_EXT;
enum VK_OBJECT_TYPE_SAMPLER_YCBCR_CONVERSION_KHR   = VkObjectType.VK_OBJECT_TYPE_SAMPLER_YCBCR_CONVERSION_KHR;
enum VK_OBJECT_TYPE_VALIDATION_CACHE_EXT           = VkObjectType.VK_OBJECT_TYPE_VALIDATION_CACHE_EXT;
enum VK_OBJECT_TYPE_ACCELERATION_STRUCTURE_NV      = VkObjectType.VK_OBJECT_TYPE_ACCELERATION_STRUCTURE_NV;

enum VkVendorId {
    VK_VENDOR_ID_VIV   = 0x10001,
    VK_VENDOR_ID_VSI   = 0x10002,
    VK_VENDOR_ID_KAZAN = 0x10003,
}
enum VK_VENDOR_ID_VIV   = VkVendorId.VK_VENDOR_ID_VIV;
enum VK_VENDOR_ID_VSI   = VkVendorId.VK_VENDOR_ID_VSI;
enum VK_VENDOR_ID_KAZAN = VkVendorId.VK_VENDOR_ID_KAZAN;


// VK_VERSION_1_1
enum VkSubgroupFeatureFlagBits : VkFlags {
    VK_SUBGROUP_FEATURE_BASIC_BIT            = 0x00000001,
    VK_SUBGROUP_FEATURE_VOTE_BIT             = 0x00000002,
    VK_SUBGROUP_FEATURE_ARITHMETIC_BIT       = 0x00000004,
    VK_SUBGROUP_FEATURE_BALLOT_BIT           = 0x00000008,
    VK_SUBGROUP_FEATURE_SHUFFLE_BIT          = 0x00000010,
    VK_SUBGROUP_FEATURE_SHUFFLE_RELATIVE_BIT = 0x00000020,
    VK_SUBGROUP_FEATURE_CLUSTERED_BIT        = 0x00000040,
    VK_SUBGROUP_FEATURE_QUAD_BIT             = 0x00000080,
    VK_SUBGROUP_FEATURE_PARTITIONED_BIT_NV   = 0x00000100,
}
enum VK_SUBGROUP_FEATURE_BASIC_BIT            = VkSubgroupFeatureFlagBits.VK_SUBGROUP_FEATURE_BASIC_BIT;
enum VK_SUBGROUP_FEATURE_VOTE_BIT             = VkSubgroupFeatureFlagBits.VK_SUBGROUP_FEATURE_VOTE_BIT;
enum VK_SUBGROUP_FEATURE_ARITHMETIC_BIT       = VkSubgroupFeatureFlagBits.VK_SUBGROUP_FEATURE_ARITHMETIC_BIT;
enum VK_SUBGROUP_FEATURE_BALLOT_BIT           = VkSubgroupFeatureFlagBits.VK_SUBGROUP_FEATURE_BALLOT_BIT;
enum VK_SUBGROUP_FEATURE_SHUFFLE_BIT          = VkSubgroupFeatureFlagBits.VK_SUBGROUP_FEATURE_SHUFFLE_BIT;
enum VK_SUBGROUP_FEATURE_SHUFFLE_RELATIVE_BIT = VkSubgroupFeatureFlagBits.VK_SUBGROUP_FEATURE_SHUFFLE_RELATIVE_BIT;
enum VK_SUBGROUP_FEATURE_CLUSTERED_BIT        = VkSubgroupFeatureFlagBits.VK_SUBGROUP_FEATURE_CLUSTERED_BIT;
enum VK_SUBGROUP_FEATURE_QUAD_BIT             = VkSubgroupFeatureFlagBits.VK_SUBGROUP_FEATURE_QUAD_BIT;
enum VK_SUBGROUP_FEATURE_PARTITIONED_BIT_NV   = VkSubgroupFeatureFlagBits.VK_SUBGROUP_FEATURE_PARTITIONED_BIT_NV;

enum VkPeerMemoryFeatureFlagBits : VkFlags {
    VK_PEER_MEMORY_FEATURE_COPY_SRC_BIT        = 0x00000001,
    VK_PEER_MEMORY_FEATURE_COPY_DST_BIT        = 0x00000002,
    VK_PEER_MEMORY_FEATURE_GENERIC_SRC_BIT     = 0x00000004,
    VK_PEER_MEMORY_FEATURE_GENERIC_DST_BIT     = 0x00000008,
    VK_PEER_MEMORY_FEATURE_COPY_SRC_BIT_KHR    = VK_PEER_MEMORY_FEATURE_COPY_SRC_BIT,
    VK_PEER_MEMORY_FEATURE_COPY_DST_BIT_KHR    = VK_PEER_MEMORY_FEATURE_COPY_DST_BIT,
    VK_PEER_MEMORY_FEATURE_GENERIC_SRC_BIT_KHR = VK_PEER_MEMORY_FEATURE_GENERIC_SRC_BIT,
    VK_PEER_MEMORY_FEATURE_GENERIC_DST_BIT_KHR = VK_PEER_MEMORY_FEATURE_GENERIC_DST_BIT,
}
enum VK_PEER_MEMORY_FEATURE_COPY_SRC_BIT        = VkPeerMemoryFeatureFlagBits.VK_PEER_MEMORY_FEATURE_COPY_SRC_BIT;
enum VK_PEER_MEMORY_FEATURE_COPY_DST_BIT        = VkPeerMemoryFeatureFlagBits.VK_PEER_MEMORY_FEATURE_COPY_DST_BIT;
enum VK_PEER_MEMORY_FEATURE_GENERIC_SRC_BIT     = VkPeerMemoryFeatureFlagBits.VK_PEER_MEMORY_FEATURE_GENERIC_SRC_BIT;
enum VK_PEER_MEMORY_FEATURE_GENERIC_DST_BIT     = VkPeerMemoryFeatureFlagBits.VK_PEER_MEMORY_FEATURE_GENERIC_DST_BIT;
enum VK_PEER_MEMORY_FEATURE_COPY_SRC_BIT_KHR    = VkPeerMemoryFeatureFlagBits.VK_PEER_MEMORY_FEATURE_COPY_SRC_BIT_KHR;
enum VK_PEER_MEMORY_FEATURE_COPY_DST_BIT_KHR    = VkPeerMemoryFeatureFlagBits.VK_PEER_MEMORY_FEATURE_COPY_DST_BIT_KHR;
enum VK_PEER_MEMORY_FEATURE_GENERIC_SRC_BIT_KHR = VkPeerMemoryFeatureFlagBits.VK_PEER_MEMORY_FEATURE_GENERIC_SRC_BIT_KHR;
enum VK_PEER_MEMORY_FEATURE_GENERIC_DST_BIT_KHR = VkPeerMemoryFeatureFlagBits.VK_PEER_MEMORY_FEATURE_GENERIC_DST_BIT_KHR;

enum VkMemoryAllocateFlagBits : VkFlags {
    VK_MEMORY_ALLOCATE_DEVICE_MASK_BIT     = 0x00000001,
    VK_MEMORY_ALLOCATE_DEVICE_MASK_BIT_KHR = VK_MEMORY_ALLOCATE_DEVICE_MASK_BIT,
}
enum VK_MEMORY_ALLOCATE_DEVICE_MASK_BIT     = VkMemoryAllocateFlagBits.VK_MEMORY_ALLOCATE_DEVICE_MASK_BIT;
enum VK_MEMORY_ALLOCATE_DEVICE_MASK_BIT_KHR = VkMemoryAllocateFlagBits.VK_MEMORY_ALLOCATE_DEVICE_MASK_BIT_KHR;

enum VkPointClippingBehavior {
    VK_POINT_CLIPPING_BEHAVIOR_ALL_CLIP_PLANES           = 0,
    VK_POINT_CLIPPING_BEHAVIOR_USER_CLIP_PLANES_ONLY     = 1,
    VK_POINT_CLIPPING_BEHAVIOR_ALL_CLIP_PLANES_KHR       = VK_POINT_CLIPPING_BEHAVIOR_ALL_CLIP_PLANES,
    VK_POINT_CLIPPING_BEHAVIOR_USER_CLIP_PLANES_ONLY_KHR = VK_POINT_CLIPPING_BEHAVIOR_USER_CLIP_PLANES_ONLY,
}
enum VK_POINT_CLIPPING_BEHAVIOR_ALL_CLIP_PLANES           = VkPointClippingBehavior.VK_POINT_CLIPPING_BEHAVIOR_ALL_CLIP_PLANES;
enum VK_POINT_CLIPPING_BEHAVIOR_USER_CLIP_PLANES_ONLY     = VkPointClippingBehavior.VK_POINT_CLIPPING_BEHAVIOR_USER_CLIP_PLANES_ONLY;
enum VK_POINT_CLIPPING_BEHAVIOR_ALL_CLIP_PLANES_KHR       = VkPointClippingBehavior.VK_POINT_CLIPPING_BEHAVIOR_ALL_CLIP_PLANES_KHR;
enum VK_POINT_CLIPPING_BEHAVIOR_USER_CLIP_PLANES_ONLY_KHR = VkPointClippingBehavior.VK_POINT_CLIPPING_BEHAVIOR_USER_CLIP_PLANES_ONLY_KHR;

enum VkTessellationDomainOrigin {
    VK_TESSELLATION_DOMAIN_ORIGIN_UPPER_LEFT     = 0,
    VK_TESSELLATION_DOMAIN_ORIGIN_LOWER_LEFT     = 1,
    VK_TESSELLATION_DOMAIN_ORIGIN_UPPER_LEFT_KHR = VK_TESSELLATION_DOMAIN_ORIGIN_UPPER_LEFT,
    VK_TESSELLATION_DOMAIN_ORIGIN_LOWER_LEFT_KHR = VK_TESSELLATION_DOMAIN_ORIGIN_LOWER_LEFT,
}
enum VK_TESSELLATION_DOMAIN_ORIGIN_UPPER_LEFT     = VkTessellationDomainOrigin.VK_TESSELLATION_DOMAIN_ORIGIN_UPPER_LEFT;
enum VK_TESSELLATION_DOMAIN_ORIGIN_LOWER_LEFT     = VkTessellationDomainOrigin.VK_TESSELLATION_DOMAIN_ORIGIN_LOWER_LEFT;
enum VK_TESSELLATION_DOMAIN_ORIGIN_UPPER_LEFT_KHR = VkTessellationDomainOrigin.VK_TESSELLATION_DOMAIN_ORIGIN_UPPER_LEFT_KHR;
enum VK_TESSELLATION_DOMAIN_ORIGIN_LOWER_LEFT_KHR = VkTessellationDomainOrigin.VK_TESSELLATION_DOMAIN_ORIGIN_LOWER_LEFT_KHR;

enum VkSamplerYcbcrModelConversion {
    VK_SAMPLER_YCBCR_MODEL_CONVERSION_RGB_IDENTITY       = 0,
    VK_SAMPLER_YCBCR_MODEL_CONVERSION_YCBCR_IDENTITY     = 1,
    VK_SAMPLER_YCBCR_MODEL_CONVERSION_YCBCR_709          = 2,
    VK_SAMPLER_YCBCR_MODEL_CONVERSION_YCBCR_601          = 3,
    VK_SAMPLER_YCBCR_MODEL_CONVERSION_YCBCR_2020         = 4,
    VK_SAMPLER_YCBCR_MODEL_CONVERSION_RGB_IDENTITY_KHR   = VK_SAMPLER_YCBCR_MODEL_CONVERSION_RGB_IDENTITY,
    VK_SAMPLER_YCBCR_MODEL_CONVERSION_YCBCR_IDENTITY_KHR = VK_SAMPLER_YCBCR_MODEL_CONVERSION_YCBCR_IDENTITY,
    VK_SAMPLER_YCBCR_MODEL_CONVERSION_YCBCR_709_KHR      = VK_SAMPLER_YCBCR_MODEL_CONVERSION_YCBCR_709,
    VK_SAMPLER_YCBCR_MODEL_CONVERSION_YCBCR_601_KHR      = VK_SAMPLER_YCBCR_MODEL_CONVERSION_YCBCR_601,
    VK_SAMPLER_YCBCR_MODEL_CONVERSION_YCBCR_2020_KHR     = VK_SAMPLER_YCBCR_MODEL_CONVERSION_YCBCR_2020,
}
enum VK_SAMPLER_YCBCR_MODEL_CONVERSION_RGB_IDENTITY       = VkSamplerYcbcrModelConversion.VK_SAMPLER_YCBCR_MODEL_CONVERSION_RGB_IDENTITY;
enum VK_SAMPLER_YCBCR_MODEL_CONVERSION_YCBCR_IDENTITY     = VkSamplerYcbcrModelConversion.VK_SAMPLER_YCBCR_MODEL_CONVERSION_YCBCR_IDENTITY;
enum VK_SAMPLER_YCBCR_MODEL_CONVERSION_YCBCR_709          = VkSamplerYcbcrModelConversion.VK_SAMPLER_YCBCR_MODEL_CONVERSION_YCBCR_709;
enum VK_SAMPLER_YCBCR_MODEL_CONVERSION_YCBCR_601          = VkSamplerYcbcrModelConversion.VK_SAMPLER_YCBCR_MODEL_CONVERSION_YCBCR_601;
enum VK_SAMPLER_YCBCR_MODEL_CONVERSION_YCBCR_2020         = VkSamplerYcbcrModelConversion.VK_SAMPLER_YCBCR_MODEL_CONVERSION_YCBCR_2020;
enum VK_SAMPLER_YCBCR_MODEL_CONVERSION_RGB_IDENTITY_KHR   = VkSamplerYcbcrModelConversion.VK_SAMPLER_YCBCR_MODEL_CONVERSION_RGB_IDENTITY_KHR;
enum VK_SAMPLER_YCBCR_MODEL_CONVERSION_YCBCR_IDENTITY_KHR = VkSamplerYcbcrModelConversion.VK_SAMPLER_YCBCR_MODEL_CONVERSION_YCBCR_IDENTITY_KHR;
enum VK_SAMPLER_YCBCR_MODEL_CONVERSION_YCBCR_709_KHR      = VkSamplerYcbcrModelConversion.VK_SAMPLER_YCBCR_MODEL_CONVERSION_YCBCR_709_KHR;
enum VK_SAMPLER_YCBCR_MODEL_CONVERSION_YCBCR_601_KHR      = VkSamplerYcbcrModelConversion.VK_SAMPLER_YCBCR_MODEL_CONVERSION_YCBCR_601_KHR;
enum VK_SAMPLER_YCBCR_MODEL_CONVERSION_YCBCR_2020_KHR     = VkSamplerYcbcrModelConversion.VK_SAMPLER_YCBCR_MODEL_CONVERSION_YCBCR_2020_KHR;

enum VkSamplerYcbcrRange {
    VK_SAMPLER_YCBCR_RANGE_ITU_FULL       = 0,
    VK_SAMPLER_YCBCR_RANGE_ITU_NARROW     = 1,
    VK_SAMPLER_YCBCR_RANGE_ITU_FULL_KHR   = VK_SAMPLER_YCBCR_RANGE_ITU_FULL,
    VK_SAMPLER_YCBCR_RANGE_ITU_NARROW_KHR = VK_SAMPLER_YCBCR_RANGE_ITU_NARROW,
}
enum VK_SAMPLER_YCBCR_RANGE_ITU_FULL       = VkSamplerYcbcrRange.VK_SAMPLER_YCBCR_RANGE_ITU_FULL;
enum VK_SAMPLER_YCBCR_RANGE_ITU_NARROW     = VkSamplerYcbcrRange.VK_SAMPLER_YCBCR_RANGE_ITU_NARROW;
enum VK_SAMPLER_YCBCR_RANGE_ITU_FULL_KHR   = VkSamplerYcbcrRange.VK_SAMPLER_YCBCR_RANGE_ITU_FULL_KHR;
enum VK_SAMPLER_YCBCR_RANGE_ITU_NARROW_KHR = VkSamplerYcbcrRange.VK_SAMPLER_YCBCR_RANGE_ITU_NARROW_KHR;

enum VkChromaLocation {
    VK_CHROMA_LOCATION_COSITED_EVEN     = 0,
    VK_CHROMA_LOCATION_MIDPOINT         = 1,
    VK_CHROMA_LOCATION_COSITED_EVEN_KHR = VK_CHROMA_LOCATION_COSITED_EVEN,
    VK_CHROMA_LOCATION_MIDPOINT_KHR     = VK_CHROMA_LOCATION_MIDPOINT,
}
enum VK_CHROMA_LOCATION_COSITED_EVEN     = VkChromaLocation.VK_CHROMA_LOCATION_COSITED_EVEN;
enum VK_CHROMA_LOCATION_MIDPOINT         = VkChromaLocation.VK_CHROMA_LOCATION_MIDPOINT;
enum VK_CHROMA_LOCATION_COSITED_EVEN_KHR = VkChromaLocation.VK_CHROMA_LOCATION_COSITED_EVEN_KHR;
enum VK_CHROMA_LOCATION_MIDPOINT_KHR     = VkChromaLocation.VK_CHROMA_LOCATION_MIDPOINT_KHR;

enum VkDescriptorUpdateTemplateType {
    VK_DESCRIPTOR_UPDATE_TEMPLATE_TYPE_DESCRIPTOR_SET       = 0,
    VK_DESCRIPTOR_UPDATE_TEMPLATE_TYPE_PUSH_DESCRIPTORS_KHR = 1,
    VK_DESCRIPTOR_UPDATE_TEMPLATE_TYPE_DESCRIPTOR_SET_KHR   = VK_DESCRIPTOR_UPDATE_TEMPLATE_TYPE_DESCRIPTOR_SET,
}
enum VK_DESCRIPTOR_UPDATE_TEMPLATE_TYPE_DESCRIPTOR_SET       = VkDescriptorUpdateTemplateType.VK_DESCRIPTOR_UPDATE_TEMPLATE_TYPE_DESCRIPTOR_SET;
enum VK_DESCRIPTOR_UPDATE_TEMPLATE_TYPE_PUSH_DESCRIPTORS_KHR = VkDescriptorUpdateTemplateType.VK_DESCRIPTOR_UPDATE_TEMPLATE_TYPE_PUSH_DESCRIPTORS_KHR;
enum VK_DESCRIPTOR_UPDATE_TEMPLATE_TYPE_DESCRIPTOR_SET_KHR   = VkDescriptorUpdateTemplateType.VK_DESCRIPTOR_UPDATE_TEMPLATE_TYPE_DESCRIPTOR_SET_KHR;

enum VkExternalMemoryHandleTypeFlagBits : VkFlags {
    VK_EXTERNAL_MEMORY_HANDLE_TYPE_OPAQUE_FD_BIT                       = 0x00000001,
    VK_EXTERNAL_MEMORY_HANDLE_TYPE_OPAQUE_WIN32_BIT                    = 0x00000002,
    VK_EXTERNAL_MEMORY_HANDLE_TYPE_OPAQUE_WIN32_KMT_BIT                = 0x00000004,
    VK_EXTERNAL_MEMORY_HANDLE_TYPE_D3D11_TEXTURE_BIT                   = 0x00000008,
    VK_EXTERNAL_MEMORY_HANDLE_TYPE_D3D11_TEXTURE_KMT_BIT               = 0x00000010,
    VK_EXTERNAL_MEMORY_HANDLE_TYPE_D3D12_HEAP_BIT                      = 0x00000020,
    VK_EXTERNAL_MEMORY_HANDLE_TYPE_D3D12_RESOURCE_BIT                  = 0x00000040,
    VK_EXTERNAL_MEMORY_HANDLE_TYPE_OPAQUE_FD_BIT_KHR                   = VK_EXTERNAL_MEMORY_HANDLE_TYPE_OPAQUE_FD_BIT,
    VK_EXTERNAL_MEMORY_HANDLE_TYPE_OPAQUE_WIN32_BIT_KHR                = VK_EXTERNAL_MEMORY_HANDLE_TYPE_OPAQUE_WIN32_BIT,
    VK_EXTERNAL_MEMORY_HANDLE_TYPE_OPAQUE_WIN32_KMT_BIT_KHR            = VK_EXTERNAL_MEMORY_HANDLE_TYPE_OPAQUE_WIN32_KMT_BIT,
    VK_EXTERNAL_MEMORY_HANDLE_TYPE_D3D11_TEXTURE_BIT_KHR               = VK_EXTERNAL_MEMORY_HANDLE_TYPE_D3D11_TEXTURE_BIT,
    VK_EXTERNAL_MEMORY_HANDLE_TYPE_D3D11_TEXTURE_KMT_BIT_KHR           = VK_EXTERNAL_MEMORY_HANDLE_TYPE_D3D11_TEXTURE_KMT_BIT,
    VK_EXTERNAL_MEMORY_HANDLE_TYPE_D3D12_HEAP_BIT_KHR                  = VK_EXTERNAL_MEMORY_HANDLE_TYPE_D3D12_HEAP_BIT,
    VK_EXTERNAL_MEMORY_HANDLE_TYPE_D3D12_RESOURCE_BIT_KHR              = VK_EXTERNAL_MEMORY_HANDLE_TYPE_D3D12_RESOURCE_BIT,
    VK_EXTERNAL_MEMORY_HANDLE_TYPE_DMA_BUF_BIT_EXT                     = 0x00000200,
    VK_EXTERNAL_MEMORY_HANDLE_TYPE_ANDROID_HARDWARE_BUFFER_BIT_ANDROID = 0x00000400,
    VK_EXTERNAL_MEMORY_HANDLE_TYPE_HOST_ALLOCATION_BIT_EXT             = 0x00000080,
    VK_EXTERNAL_MEMORY_HANDLE_TYPE_HOST_MAPPED_FOREIGN_MEMORY_BIT_EXT  = 0x00000100,
}
enum VK_EXTERNAL_MEMORY_HANDLE_TYPE_OPAQUE_FD_BIT                       = VkExternalMemoryHandleTypeFlagBits.VK_EXTERNAL_MEMORY_HANDLE_TYPE_OPAQUE_FD_BIT;
enum VK_EXTERNAL_MEMORY_HANDLE_TYPE_OPAQUE_WIN32_BIT                    = VkExternalMemoryHandleTypeFlagBits.VK_EXTERNAL_MEMORY_HANDLE_TYPE_OPAQUE_WIN32_BIT;
enum VK_EXTERNAL_MEMORY_HANDLE_TYPE_OPAQUE_WIN32_KMT_BIT                = VkExternalMemoryHandleTypeFlagBits.VK_EXTERNAL_MEMORY_HANDLE_TYPE_OPAQUE_WIN32_KMT_BIT;
enum VK_EXTERNAL_MEMORY_HANDLE_TYPE_D3D11_TEXTURE_BIT                   = VkExternalMemoryHandleTypeFlagBits.VK_EXTERNAL_MEMORY_HANDLE_TYPE_D3D11_TEXTURE_BIT;
enum VK_EXTERNAL_MEMORY_HANDLE_TYPE_D3D11_TEXTURE_KMT_BIT               = VkExternalMemoryHandleTypeFlagBits.VK_EXTERNAL_MEMORY_HANDLE_TYPE_D3D11_TEXTURE_KMT_BIT;
enum VK_EXTERNAL_MEMORY_HANDLE_TYPE_D3D12_HEAP_BIT                      = VkExternalMemoryHandleTypeFlagBits.VK_EXTERNAL_MEMORY_HANDLE_TYPE_D3D12_HEAP_BIT;
enum VK_EXTERNAL_MEMORY_HANDLE_TYPE_D3D12_RESOURCE_BIT                  = VkExternalMemoryHandleTypeFlagBits.VK_EXTERNAL_MEMORY_HANDLE_TYPE_D3D12_RESOURCE_BIT;
enum VK_EXTERNAL_MEMORY_HANDLE_TYPE_OPAQUE_FD_BIT_KHR                   = VkExternalMemoryHandleTypeFlagBits.VK_EXTERNAL_MEMORY_HANDLE_TYPE_OPAQUE_FD_BIT_KHR;
enum VK_EXTERNAL_MEMORY_HANDLE_TYPE_OPAQUE_WIN32_BIT_KHR                = VkExternalMemoryHandleTypeFlagBits.VK_EXTERNAL_MEMORY_HANDLE_TYPE_OPAQUE_WIN32_BIT_KHR;
enum VK_EXTERNAL_MEMORY_HANDLE_TYPE_OPAQUE_WIN32_KMT_BIT_KHR            = VkExternalMemoryHandleTypeFlagBits.VK_EXTERNAL_MEMORY_HANDLE_TYPE_OPAQUE_WIN32_KMT_BIT_KHR;
enum VK_EXTERNAL_MEMORY_HANDLE_TYPE_D3D11_TEXTURE_BIT_KHR               = VkExternalMemoryHandleTypeFlagBits.VK_EXTERNAL_MEMORY_HANDLE_TYPE_D3D11_TEXTURE_BIT_KHR;
enum VK_EXTERNAL_MEMORY_HANDLE_TYPE_D3D11_TEXTURE_KMT_BIT_KHR           = VkExternalMemoryHandleTypeFlagBits.VK_EXTERNAL_MEMORY_HANDLE_TYPE_D3D11_TEXTURE_KMT_BIT_KHR;
enum VK_EXTERNAL_MEMORY_HANDLE_TYPE_D3D12_HEAP_BIT_KHR                  = VkExternalMemoryHandleTypeFlagBits.VK_EXTERNAL_MEMORY_HANDLE_TYPE_D3D12_HEAP_BIT_KHR;
enum VK_EXTERNAL_MEMORY_HANDLE_TYPE_D3D12_RESOURCE_BIT_KHR              = VkExternalMemoryHandleTypeFlagBits.VK_EXTERNAL_MEMORY_HANDLE_TYPE_D3D12_RESOURCE_BIT_KHR;
enum VK_EXTERNAL_MEMORY_HANDLE_TYPE_DMA_BUF_BIT_EXT                     = VkExternalMemoryHandleTypeFlagBits.VK_EXTERNAL_MEMORY_HANDLE_TYPE_DMA_BUF_BIT_EXT;
enum VK_EXTERNAL_MEMORY_HANDLE_TYPE_ANDROID_HARDWARE_BUFFER_BIT_ANDROID = VkExternalMemoryHandleTypeFlagBits.VK_EXTERNAL_MEMORY_HANDLE_TYPE_ANDROID_HARDWARE_BUFFER_BIT_ANDROID;
enum VK_EXTERNAL_MEMORY_HANDLE_TYPE_HOST_ALLOCATION_BIT_EXT             = VkExternalMemoryHandleTypeFlagBits.VK_EXTERNAL_MEMORY_HANDLE_TYPE_HOST_ALLOCATION_BIT_EXT;
enum VK_EXTERNAL_MEMORY_HANDLE_TYPE_HOST_MAPPED_FOREIGN_MEMORY_BIT_EXT  = VkExternalMemoryHandleTypeFlagBits.VK_EXTERNAL_MEMORY_HANDLE_TYPE_HOST_MAPPED_FOREIGN_MEMORY_BIT_EXT;

enum VkExternalMemoryFeatureFlagBits : VkFlags {
    VK_EXTERNAL_MEMORY_FEATURE_DEDICATED_ONLY_BIT     = 0x00000001,
    VK_EXTERNAL_MEMORY_FEATURE_EXPORTABLE_BIT         = 0x00000002,
    VK_EXTERNAL_MEMORY_FEATURE_IMPORTABLE_BIT         = 0x00000004,
    VK_EXTERNAL_MEMORY_FEATURE_DEDICATED_ONLY_BIT_KHR = VK_EXTERNAL_MEMORY_FEATURE_DEDICATED_ONLY_BIT,
    VK_EXTERNAL_MEMORY_FEATURE_EXPORTABLE_BIT_KHR     = VK_EXTERNAL_MEMORY_FEATURE_EXPORTABLE_BIT,
    VK_EXTERNAL_MEMORY_FEATURE_IMPORTABLE_BIT_KHR     = VK_EXTERNAL_MEMORY_FEATURE_IMPORTABLE_BIT,
}
enum VK_EXTERNAL_MEMORY_FEATURE_DEDICATED_ONLY_BIT     = VkExternalMemoryFeatureFlagBits.VK_EXTERNAL_MEMORY_FEATURE_DEDICATED_ONLY_BIT;
enum VK_EXTERNAL_MEMORY_FEATURE_EXPORTABLE_BIT         = VkExternalMemoryFeatureFlagBits.VK_EXTERNAL_MEMORY_FEATURE_EXPORTABLE_BIT;
enum VK_EXTERNAL_MEMORY_FEATURE_IMPORTABLE_BIT         = VkExternalMemoryFeatureFlagBits.VK_EXTERNAL_MEMORY_FEATURE_IMPORTABLE_BIT;
enum VK_EXTERNAL_MEMORY_FEATURE_DEDICATED_ONLY_BIT_KHR = VkExternalMemoryFeatureFlagBits.VK_EXTERNAL_MEMORY_FEATURE_DEDICATED_ONLY_BIT_KHR;
enum VK_EXTERNAL_MEMORY_FEATURE_EXPORTABLE_BIT_KHR     = VkExternalMemoryFeatureFlagBits.VK_EXTERNAL_MEMORY_FEATURE_EXPORTABLE_BIT_KHR;
enum VK_EXTERNAL_MEMORY_FEATURE_IMPORTABLE_BIT_KHR     = VkExternalMemoryFeatureFlagBits.VK_EXTERNAL_MEMORY_FEATURE_IMPORTABLE_BIT_KHR;

enum VkExternalFenceHandleTypeFlagBits : VkFlags {
    VK_EXTERNAL_FENCE_HANDLE_TYPE_OPAQUE_FD_BIT            = 0x00000001,
    VK_EXTERNAL_FENCE_HANDLE_TYPE_OPAQUE_WIN32_BIT         = 0x00000002,
    VK_EXTERNAL_FENCE_HANDLE_TYPE_OPAQUE_WIN32_KMT_BIT     = 0x00000004,
    VK_EXTERNAL_FENCE_HANDLE_TYPE_SYNC_FD_BIT              = 0x00000008,
    VK_EXTERNAL_FENCE_HANDLE_TYPE_OPAQUE_FD_BIT_KHR        = VK_EXTERNAL_FENCE_HANDLE_TYPE_OPAQUE_FD_BIT,
    VK_EXTERNAL_FENCE_HANDLE_TYPE_OPAQUE_WIN32_BIT_KHR     = VK_EXTERNAL_FENCE_HANDLE_TYPE_OPAQUE_WIN32_BIT,
    VK_EXTERNAL_FENCE_HANDLE_TYPE_OPAQUE_WIN32_KMT_BIT_KHR = VK_EXTERNAL_FENCE_HANDLE_TYPE_OPAQUE_WIN32_KMT_BIT,
    VK_EXTERNAL_FENCE_HANDLE_TYPE_SYNC_FD_BIT_KHR          = VK_EXTERNAL_FENCE_HANDLE_TYPE_SYNC_FD_BIT,
}
enum VK_EXTERNAL_FENCE_HANDLE_TYPE_OPAQUE_FD_BIT            = VkExternalFenceHandleTypeFlagBits.VK_EXTERNAL_FENCE_HANDLE_TYPE_OPAQUE_FD_BIT;
enum VK_EXTERNAL_FENCE_HANDLE_TYPE_OPAQUE_WIN32_BIT         = VkExternalFenceHandleTypeFlagBits.VK_EXTERNAL_FENCE_HANDLE_TYPE_OPAQUE_WIN32_BIT;
enum VK_EXTERNAL_FENCE_HANDLE_TYPE_OPAQUE_WIN32_KMT_BIT     = VkExternalFenceHandleTypeFlagBits.VK_EXTERNAL_FENCE_HANDLE_TYPE_OPAQUE_WIN32_KMT_BIT;
enum VK_EXTERNAL_FENCE_HANDLE_TYPE_SYNC_FD_BIT              = VkExternalFenceHandleTypeFlagBits.VK_EXTERNAL_FENCE_HANDLE_TYPE_SYNC_FD_BIT;
enum VK_EXTERNAL_FENCE_HANDLE_TYPE_OPAQUE_FD_BIT_KHR        = VkExternalFenceHandleTypeFlagBits.VK_EXTERNAL_FENCE_HANDLE_TYPE_OPAQUE_FD_BIT_KHR;
enum VK_EXTERNAL_FENCE_HANDLE_TYPE_OPAQUE_WIN32_BIT_KHR     = VkExternalFenceHandleTypeFlagBits.VK_EXTERNAL_FENCE_HANDLE_TYPE_OPAQUE_WIN32_BIT_KHR;
enum VK_EXTERNAL_FENCE_HANDLE_TYPE_OPAQUE_WIN32_KMT_BIT_KHR = VkExternalFenceHandleTypeFlagBits.VK_EXTERNAL_FENCE_HANDLE_TYPE_OPAQUE_WIN32_KMT_BIT_KHR;
enum VK_EXTERNAL_FENCE_HANDLE_TYPE_SYNC_FD_BIT_KHR          = VkExternalFenceHandleTypeFlagBits.VK_EXTERNAL_FENCE_HANDLE_TYPE_SYNC_FD_BIT_KHR;

enum VkExternalFenceFeatureFlagBits : VkFlags {
    VK_EXTERNAL_FENCE_FEATURE_EXPORTABLE_BIT     = 0x00000001,
    VK_EXTERNAL_FENCE_FEATURE_IMPORTABLE_BIT     = 0x00000002,
    VK_EXTERNAL_FENCE_FEATURE_EXPORTABLE_BIT_KHR = VK_EXTERNAL_FENCE_FEATURE_EXPORTABLE_BIT,
    VK_EXTERNAL_FENCE_FEATURE_IMPORTABLE_BIT_KHR = VK_EXTERNAL_FENCE_FEATURE_IMPORTABLE_BIT,
}
enum VK_EXTERNAL_FENCE_FEATURE_EXPORTABLE_BIT     = VkExternalFenceFeatureFlagBits.VK_EXTERNAL_FENCE_FEATURE_EXPORTABLE_BIT;
enum VK_EXTERNAL_FENCE_FEATURE_IMPORTABLE_BIT     = VkExternalFenceFeatureFlagBits.VK_EXTERNAL_FENCE_FEATURE_IMPORTABLE_BIT;
enum VK_EXTERNAL_FENCE_FEATURE_EXPORTABLE_BIT_KHR = VkExternalFenceFeatureFlagBits.VK_EXTERNAL_FENCE_FEATURE_EXPORTABLE_BIT_KHR;
enum VK_EXTERNAL_FENCE_FEATURE_IMPORTABLE_BIT_KHR = VkExternalFenceFeatureFlagBits.VK_EXTERNAL_FENCE_FEATURE_IMPORTABLE_BIT_KHR;

enum VkFenceImportFlagBits : VkFlags {
    VK_FENCE_IMPORT_TEMPORARY_BIT     = 0x00000001,
    VK_FENCE_IMPORT_TEMPORARY_BIT_KHR = VK_FENCE_IMPORT_TEMPORARY_BIT,
}
enum VK_FENCE_IMPORT_TEMPORARY_BIT     = VkFenceImportFlagBits.VK_FENCE_IMPORT_TEMPORARY_BIT;
enum VK_FENCE_IMPORT_TEMPORARY_BIT_KHR = VkFenceImportFlagBits.VK_FENCE_IMPORT_TEMPORARY_BIT_KHR;

enum VkSemaphoreImportFlagBits : VkFlags {
    VK_SEMAPHORE_IMPORT_TEMPORARY_BIT     = 0x00000001,
    VK_SEMAPHORE_IMPORT_TEMPORARY_BIT_KHR = VK_SEMAPHORE_IMPORT_TEMPORARY_BIT,
}
enum VK_SEMAPHORE_IMPORT_TEMPORARY_BIT     = VkSemaphoreImportFlagBits.VK_SEMAPHORE_IMPORT_TEMPORARY_BIT;
enum VK_SEMAPHORE_IMPORT_TEMPORARY_BIT_KHR = VkSemaphoreImportFlagBits.VK_SEMAPHORE_IMPORT_TEMPORARY_BIT_KHR;

enum VkExternalSemaphoreHandleTypeFlagBits : VkFlags {
    VK_EXTERNAL_SEMAPHORE_HANDLE_TYPE_OPAQUE_FD_BIT            = 0x00000001,
    VK_EXTERNAL_SEMAPHORE_HANDLE_TYPE_OPAQUE_WIN32_BIT         = 0x00000002,
    VK_EXTERNAL_SEMAPHORE_HANDLE_TYPE_OPAQUE_WIN32_KMT_BIT     = 0x00000004,
    VK_EXTERNAL_SEMAPHORE_HANDLE_TYPE_D3D12_FENCE_BIT          = 0x00000008,
    VK_EXTERNAL_SEMAPHORE_HANDLE_TYPE_SYNC_FD_BIT              = 0x00000010,
    VK_EXTERNAL_SEMAPHORE_HANDLE_TYPE_OPAQUE_FD_BIT_KHR        = VK_EXTERNAL_SEMAPHORE_HANDLE_TYPE_OPAQUE_FD_BIT,
    VK_EXTERNAL_SEMAPHORE_HANDLE_TYPE_OPAQUE_WIN32_BIT_KHR     = VK_EXTERNAL_SEMAPHORE_HANDLE_TYPE_OPAQUE_WIN32_BIT,
    VK_EXTERNAL_SEMAPHORE_HANDLE_TYPE_OPAQUE_WIN32_KMT_BIT_KHR = VK_EXTERNAL_SEMAPHORE_HANDLE_TYPE_OPAQUE_WIN32_KMT_BIT,
    VK_EXTERNAL_SEMAPHORE_HANDLE_TYPE_D3D12_FENCE_BIT_KHR      = VK_EXTERNAL_SEMAPHORE_HANDLE_TYPE_D3D12_FENCE_BIT,
    VK_EXTERNAL_SEMAPHORE_HANDLE_TYPE_SYNC_FD_BIT_KHR          = VK_EXTERNAL_SEMAPHORE_HANDLE_TYPE_SYNC_FD_BIT,
}
enum VK_EXTERNAL_SEMAPHORE_HANDLE_TYPE_OPAQUE_FD_BIT            = VkExternalSemaphoreHandleTypeFlagBits.VK_EXTERNAL_SEMAPHORE_HANDLE_TYPE_OPAQUE_FD_BIT;
enum VK_EXTERNAL_SEMAPHORE_HANDLE_TYPE_OPAQUE_WIN32_BIT         = VkExternalSemaphoreHandleTypeFlagBits.VK_EXTERNAL_SEMAPHORE_HANDLE_TYPE_OPAQUE_WIN32_BIT;
enum VK_EXTERNAL_SEMAPHORE_HANDLE_TYPE_OPAQUE_WIN32_KMT_BIT     = VkExternalSemaphoreHandleTypeFlagBits.VK_EXTERNAL_SEMAPHORE_HANDLE_TYPE_OPAQUE_WIN32_KMT_BIT;
enum VK_EXTERNAL_SEMAPHORE_HANDLE_TYPE_D3D12_FENCE_BIT          = VkExternalSemaphoreHandleTypeFlagBits.VK_EXTERNAL_SEMAPHORE_HANDLE_TYPE_D3D12_FENCE_BIT;
enum VK_EXTERNAL_SEMAPHORE_HANDLE_TYPE_SYNC_FD_BIT              = VkExternalSemaphoreHandleTypeFlagBits.VK_EXTERNAL_SEMAPHORE_HANDLE_TYPE_SYNC_FD_BIT;
enum VK_EXTERNAL_SEMAPHORE_HANDLE_TYPE_OPAQUE_FD_BIT_KHR        = VkExternalSemaphoreHandleTypeFlagBits.VK_EXTERNAL_SEMAPHORE_HANDLE_TYPE_OPAQUE_FD_BIT_KHR;
enum VK_EXTERNAL_SEMAPHORE_HANDLE_TYPE_OPAQUE_WIN32_BIT_KHR     = VkExternalSemaphoreHandleTypeFlagBits.VK_EXTERNAL_SEMAPHORE_HANDLE_TYPE_OPAQUE_WIN32_BIT_KHR;
enum VK_EXTERNAL_SEMAPHORE_HANDLE_TYPE_OPAQUE_WIN32_KMT_BIT_KHR = VkExternalSemaphoreHandleTypeFlagBits.VK_EXTERNAL_SEMAPHORE_HANDLE_TYPE_OPAQUE_WIN32_KMT_BIT_KHR;
enum VK_EXTERNAL_SEMAPHORE_HANDLE_TYPE_D3D12_FENCE_BIT_KHR      = VkExternalSemaphoreHandleTypeFlagBits.VK_EXTERNAL_SEMAPHORE_HANDLE_TYPE_D3D12_FENCE_BIT_KHR;
enum VK_EXTERNAL_SEMAPHORE_HANDLE_TYPE_SYNC_FD_BIT_KHR          = VkExternalSemaphoreHandleTypeFlagBits.VK_EXTERNAL_SEMAPHORE_HANDLE_TYPE_SYNC_FD_BIT_KHR;

enum VkExternalSemaphoreFeatureFlagBits : VkFlags {
    VK_EXTERNAL_SEMAPHORE_FEATURE_EXPORTABLE_BIT     = 0x00000001,
    VK_EXTERNAL_SEMAPHORE_FEATURE_IMPORTABLE_BIT     = 0x00000002,
    VK_EXTERNAL_SEMAPHORE_FEATURE_EXPORTABLE_BIT_KHR = VK_EXTERNAL_SEMAPHORE_FEATURE_EXPORTABLE_BIT,
    VK_EXTERNAL_SEMAPHORE_FEATURE_IMPORTABLE_BIT_KHR = VK_EXTERNAL_SEMAPHORE_FEATURE_IMPORTABLE_BIT,
}
enum VK_EXTERNAL_SEMAPHORE_FEATURE_EXPORTABLE_BIT     = VkExternalSemaphoreFeatureFlagBits.VK_EXTERNAL_SEMAPHORE_FEATURE_EXPORTABLE_BIT;
enum VK_EXTERNAL_SEMAPHORE_FEATURE_IMPORTABLE_BIT     = VkExternalSemaphoreFeatureFlagBits.VK_EXTERNAL_SEMAPHORE_FEATURE_IMPORTABLE_BIT;
enum VK_EXTERNAL_SEMAPHORE_FEATURE_EXPORTABLE_BIT_KHR = VkExternalSemaphoreFeatureFlagBits.VK_EXTERNAL_SEMAPHORE_FEATURE_EXPORTABLE_BIT_KHR;
enum VK_EXTERNAL_SEMAPHORE_FEATURE_IMPORTABLE_BIT_KHR = VkExternalSemaphoreFeatureFlagBits.VK_EXTERNAL_SEMAPHORE_FEATURE_IMPORTABLE_BIT_KHR;


// VK_KHR_surface
enum VkSurfaceTransformFlagBitsKHR {
    VK_SURFACE_TRANSFORM_IDENTITY_BIT_KHR                     = 0x00000001,
    VK_SURFACE_TRANSFORM_ROTATE_90_BIT_KHR                    = 0x00000002,
    VK_SURFACE_TRANSFORM_ROTATE_180_BIT_KHR                   = 0x00000004,
    VK_SURFACE_TRANSFORM_ROTATE_270_BIT_KHR                   = 0x00000008,
    VK_SURFACE_TRANSFORM_HORIZONTAL_MIRROR_BIT_KHR            = 0x00000010,
    VK_SURFACE_TRANSFORM_HORIZONTAL_MIRROR_ROTATE_90_BIT_KHR  = 0x00000020,
    VK_SURFACE_TRANSFORM_HORIZONTAL_MIRROR_ROTATE_180_BIT_KHR = 0x00000040,
    VK_SURFACE_TRANSFORM_HORIZONTAL_MIRROR_ROTATE_270_BIT_KHR = 0x00000080,
    VK_SURFACE_TRANSFORM_INHERIT_BIT_KHR                      = 0x00000100,
}
enum VK_SURFACE_TRANSFORM_IDENTITY_BIT_KHR                     = VkSurfaceTransformFlagBitsKHR.VK_SURFACE_TRANSFORM_IDENTITY_BIT_KHR;
enum VK_SURFACE_TRANSFORM_ROTATE_90_BIT_KHR                    = VkSurfaceTransformFlagBitsKHR.VK_SURFACE_TRANSFORM_ROTATE_90_BIT_KHR;
enum VK_SURFACE_TRANSFORM_ROTATE_180_BIT_KHR                   = VkSurfaceTransformFlagBitsKHR.VK_SURFACE_TRANSFORM_ROTATE_180_BIT_KHR;
enum VK_SURFACE_TRANSFORM_ROTATE_270_BIT_KHR                   = VkSurfaceTransformFlagBitsKHR.VK_SURFACE_TRANSFORM_ROTATE_270_BIT_KHR;
enum VK_SURFACE_TRANSFORM_HORIZONTAL_MIRROR_BIT_KHR            = VkSurfaceTransformFlagBitsKHR.VK_SURFACE_TRANSFORM_HORIZONTAL_MIRROR_BIT_KHR;
enum VK_SURFACE_TRANSFORM_HORIZONTAL_MIRROR_ROTATE_90_BIT_KHR  = VkSurfaceTransformFlagBitsKHR.VK_SURFACE_TRANSFORM_HORIZONTAL_MIRROR_ROTATE_90_BIT_KHR;
enum VK_SURFACE_TRANSFORM_HORIZONTAL_MIRROR_ROTATE_180_BIT_KHR = VkSurfaceTransformFlagBitsKHR.VK_SURFACE_TRANSFORM_HORIZONTAL_MIRROR_ROTATE_180_BIT_KHR;
enum VK_SURFACE_TRANSFORM_HORIZONTAL_MIRROR_ROTATE_270_BIT_KHR = VkSurfaceTransformFlagBitsKHR.VK_SURFACE_TRANSFORM_HORIZONTAL_MIRROR_ROTATE_270_BIT_KHR;
enum VK_SURFACE_TRANSFORM_INHERIT_BIT_KHR                      = VkSurfaceTransformFlagBitsKHR.VK_SURFACE_TRANSFORM_INHERIT_BIT_KHR;

enum VkCompositeAlphaFlagBitsKHR {
    VK_COMPOSITE_ALPHA_OPAQUE_BIT_KHR          = 0x00000001,
    VK_COMPOSITE_ALPHA_PRE_MULTIPLIED_BIT_KHR  = 0x00000002,
    VK_COMPOSITE_ALPHA_POST_MULTIPLIED_BIT_KHR = 0x00000004,
    VK_COMPOSITE_ALPHA_INHERIT_BIT_KHR         = 0x00000008,
}
enum VK_COMPOSITE_ALPHA_OPAQUE_BIT_KHR          = VkCompositeAlphaFlagBitsKHR.VK_COMPOSITE_ALPHA_OPAQUE_BIT_KHR;
enum VK_COMPOSITE_ALPHA_PRE_MULTIPLIED_BIT_KHR  = VkCompositeAlphaFlagBitsKHR.VK_COMPOSITE_ALPHA_PRE_MULTIPLIED_BIT_KHR;
enum VK_COMPOSITE_ALPHA_POST_MULTIPLIED_BIT_KHR = VkCompositeAlphaFlagBitsKHR.VK_COMPOSITE_ALPHA_POST_MULTIPLIED_BIT_KHR;
enum VK_COMPOSITE_ALPHA_INHERIT_BIT_KHR         = VkCompositeAlphaFlagBitsKHR.VK_COMPOSITE_ALPHA_INHERIT_BIT_KHR;

enum VkColorSpaceKHR {
    VK_COLOR_SPACE_SRGB_NONLINEAR_KHR          = 0,
    VK_COLORSPACE_SRGB_NONLINEAR_KHR           = VK_COLOR_SPACE_SRGB_NONLINEAR_KHR,
    VK_COLOR_SPACE_DISPLAY_P3_NONLINEAR_EXT    = 1000104001,
    VK_COLOR_SPACE_EXTENDED_SRGB_LINEAR_EXT    = 1000104002,
    VK_COLOR_SPACE_DCI_P3_LINEAR_EXT           = 1000104003,
    VK_COLOR_SPACE_DCI_P3_NONLINEAR_EXT        = 1000104004,
    VK_COLOR_SPACE_BT709_LINEAR_EXT            = 1000104005,
    VK_COLOR_SPACE_BT709_NONLINEAR_EXT         = 1000104006,
    VK_COLOR_SPACE_BT2020_LINEAR_EXT           = 1000104007,
    VK_COLOR_SPACE_HDR10_ST2084_EXT            = 1000104008,
    VK_COLOR_SPACE_DOLBYVISION_EXT             = 1000104009,
    VK_COLOR_SPACE_HDR10_HLG_EXT               = 1000104010,
    VK_COLOR_SPACE_ADOBERGB_LINEAR_EXT         = 1000104011,
    VK_COLOR_SPACE_ADOBERGB_NONLINEAR_EXT      = 1000104012,
    VK_COLOR_SPACE_PASS_THROUGH_EXT            = 1000104013,
    VK_COLOR_SPACE_EXTENDED_SRGB_NONLINEAR_EXT = 1000104014,
}
enum VK_COLOR_SPACE_SRGB_NONLINEAR_KHR          = VkColorSpaceKHR.VK_COLOR_SPACE_SRGB_NONLINEAR_KHR;
enum VK_COLORSPACE_SRGB_NONLINEAR_KHR           = VkColorSpaceKHR.VK_COLORSPACE_SRGB_NONLINEAR_KHR;
enum VK_COLOR_SPACE_DISPLAY_P3_NONLINEAR_EXT    = VkColorSpaceKHR.VK_COLOR_SPACE_DISPLAY_P3_NONLINEAR_EXT;
enum VK_COLOR_SPACE_EXTENDED_SRGB_LINEAR_EXT    = VkColorSpaceKHR.VK_COLOR_SPACE_EXTENDED_SRGB_LINEAR_EXT;
enum VK_COLOR_SPACE_DCI_P3_LINEAR_EXT           = VkColorSpaceKHR.VK_COLOR_SPACE_DCI_P3_LINEAR_EXT;
enum VK_COLOR_SPACE_DCI_P3_NONLINEAR_EXT        = VkColorSpaceKHR.VK_COLOR_SPACE_DCI_P3_NONLINEAR_EXT;
enum VK_COLOR_SPACE_BT709_LINEAR_EXT            = VkColorSpaceKHR.VK_COLOR_SPACE_BT709_LINEAR_EXT;
enum VK_COLOR_SPACE_BT709_NONLINEAR_EXT         = VkColorSpaceKHR.VK_COLOR_SPACE_BT709_NONLINEAR_EXT;
enum VK_COLOR_SPACE_BT2020_LINEAR_EXT           = VkColorSpaceKHR.VK_COLOR_SPACE_BT2020_LINEAR_EXT;
enum VK_COLOR_SPACE_HDR10_ST2084_EXT            = VkColorSpaceKHR.VK_COLOR_SPACE_HDR10_ST2084_EXT;
enum VK_COLOR_SPACE_DOLBYVISION_EXT             = VkColorSpaceKHR.VK_COLOR_SPACE_DOLBYVISION_EXT;
enum VK_COLOR_SPACE_HDR10_HLG_EXT               = VkColorSpaceKHR.VK_COLOR_SPACE_HDR10_HLG_EXT;
enum VK_COLOR_SPACE_ADOBERGB_LINEAR_EXT         = VkColorSpaceKHR.VK_COLOR_SPACE_ADOBERGB_LINEAR_EXT;
enum VK_COLOR_SPACE_ADOBERGB_NONLINEAR_EXT      = VkColorSpaceKHR.VK_COLOR_SPACE_ADOBERGB_NONLINEAR_EXT;
enum VK_COLOR_SPACE_PASS_THROUGH_EXT            = VkColorSpaceKHR.VK_COLOR_SPACE_PASS_THROUGH_EXT;
enum VK_COLOR_SPACE_EXTENDED_SRGB_NONLINEAR_EXT = VkColorSpaceKHR.VK_COLOR_SPACE_EXTENDED_SRGB_NONLINEAR_EXT;

enum VkPresentModeKHR {
    VK_PRESENT_MODE_IMMEDIATE_KHR                 = 0,
    VK_PRESENT_MODE_MAILBOX_KHR                   = 1,
    VK_PRESENT_MODE_FIFO_KHR                      = 2,
    VK_PRESENT_MODE_FIFO_RELAXED_KHR              = 3,
    VK_PRESENT_MODE_SHARED_DEMAND_REFRESH_KHR     = 1000111000,
    VK_PRESENT_MODE_SHARED_CONTINUOUS_REFRESH_KHR = 1000111001,
}
enum VK_PRESENT_MODE_IMMEDIATE_KHR                 = VkPresentModeKHR.VK_PRESENT_MODE_IMMEDIATE_KHR;
enum VK_PRESENT_MODE_MAILBOX_KHR                   = VkPresentModeKHR.VK_PRESENT_MODE_MAILBOX_KHR;
enum VK_PRESENT_MODE_FIFO_KHR                      = VkPresentModeKHR.VK_PRESENT_MODE_FIFO_KHR;
enum VK_PRESENT_MODE_FIFO_RELAXED_KHR              = VkPresentModeKHR.VK_PRESENT_MODE_FIFO_RELAXED_KHR;
enum VK_PRESENT_MODE_SHARED_DEMAND_REFRESH_KHR     = VkPresentModeKHR.VK_PRESENT_MODE_SHARED_DEMAND_REFRESH_KHR;
enum VK_PRESENT_MODE_SHARED_CONTINUOUS_REFRESH_KHR = VkPresentModeKHR.VK_PRESENT_MODE_SHARED_CONTINUOUS_REFRESH_KHR;


// VK_KHR_swapchain
enum VkSwapchainCreateFlagBitsKHR {
    VK_SWAPCHAIN_CREATE_SPLIT_INSTANCE_BIND_REGIONS_BIT_KHR = 0x00000001,
    VK_SWAPCHAIN_CREATE_PROTECTED_BIT_KHR                   = 0x00000002,
    VK_SWAPCHAIN_CREATE_MUTABLE_FORMAT_BIT_KHR              = 0x00000004,
}
enum VK_SWAPCHAIN_CREATE_SPLIT_INSTANCE_BIND_REGIONS_BIT_KHR = VkSwapchainCreateFlagBitsKHR.VK_SWAPCHAIN_CREATE_SPLIT_INSTANCE_BIND_REGIONS_BIT_KHR;
enum VK_SWAPCHAIN_CREATE_PROTECTED_BIT_KHR                   = VkSwapchainCreateFlagBitsKHR.VK_SWAPCHAIN_CREATE_PROTECTED_BIT_KHR;
enum VK_SWAPCHAIN_CREATE_MUTABLE_FORMAT_BIT_KHR              = VkSwapchainCreateFlagBitsKHR.VK_SWAPCHAIN_CREATE_MUTABLE_FORMAT_BIT_KHR;

enum VkDeviceGroupPresentModeFlagBitsKHR {
    VK_DEVICE_GROUP_PRESENT_MODE_LOCAL_BIT_KHR              = 0x00000001,
    VK_DEVICE_GROUP_PRESENT_MODE_REMOTE_BIT_KHR             = 0x00000002,
    VK_DEVICE_GROUP_PRESENT_MODE_SUM_BIT_KHR                = 0x00000004,
    VK_DEVICE_GROUP_PRESENT_MODE_LOCAL_MULTI_DEVICE_BIT_KHR = 0x00000008,
}
enum VK_DEVICE_GROUP_PRESENT_MODE_LOCAL_BIT_KHR              = VkDeviceGroupPresentModeFlagBitsKHR.VK_DEVICE_GROUP_PRESENT_MODE_LOCAL_BIT_KHR;
enum VK_DEVICE_GROUP_PRESENT_MODE_REMOTE_BIT_KHR             = VkDeviceGroupPresentModeFlagBitsKHR.VK_DEVICE_GROUP_PRESENT_MODE_REMOTE_BIT_KHR;
enum VK_DEVICE_GROUP_PRESENT_MODE_SUM_BIT_KHR                = VkDeviceGroupPresentModeFlagBitsKHR.VK_DEVICE_GROUP_PRESENT_MODE_SUM_BIT_KHR;
enum VK_DEVICE_GROUP_PRESENT_MODE_LOCAL_MULTI_DEVICE_BIT_KHR = VkDeviceGroupPresentModeFlagBitsKHR.VK_DEVICE_GROUP_PRESENT_MODE_LOCAL_MULTI_DEVICE_BIT_KHR;


// VK_KHR_display
enum VkDisplayPlaneAlphaFlagBitsKHR {
    VK_DISPLAY_PLANE_ALPHA_OPAQUE_BIT_KHR                  = 0x00000001,
    VK_DISPLAY_PLANE_ALPHA_GLOBAL_BIT_KHR                  = 0x00000002,
    VK_DISPLAY_PLANE_ALPHA_PER_PIXEL_BIT_KHR               = 0x00000004,
    VK_DISPLAY_PLANE_ALPHA_PER_PIXEL_PREMULTIPLIED_BIT_KHR = 0x00000008,
}
enum VK_DISPLAY_PLANE_ALPHA_OPAQUE_BIT_KHR                  = VkDisplayPlaneAlphaFlagBitsKHR.VK_DISPLAY_PLANE_ALPHA_OPAQUE_BIT_KHR;
enum VK_DISPLAY_PLANE_ALPHA_GLOBAL_BIT_KHR                  = VkDisplayPlaneAlphaFlagBitsKHR.VK_DISPLAY_PLANE_ALPHA_GLOBAL_BIT_KHR;
enum VK_DISPLAY_PLANE_ALPHA_PER_PIXEL_BIT_KHR               = VkDisplayPlaneAlphaFlagBitsKHR.VK_DISPLAY_PLANE_ALPHA_PER_PIXEL_BIT_KHR;
enum VK_DISPLAY_PLANE_ALPHA_PER_PIXEL_PREMULTIPLIED_BIT_KHR = VkDisplayPlaneAlphaFlagBitsKHR.VK_DISPLAY_PLANE_ALPHA_PER_PIXEL_PREMULTIPLIED_BIT_KHR;


// VK_EXT_debug_report
enum VkDebugReportObjectTypeEXT {
    VK_DEBUG_REPORT_OBJECT_TYPE_UNKNOWN_EXT                        = 0,
    VK_DEBUG_REPORT_OBJECT_TYPE_INSTANCE_EXT                       = 1,
    VK_DEBUG_REPORT_OBJECT_TYPE_PHYSICAL_DEVICE_EXT                = 2,
    VK_DEBUG_REPORT_OBJECT_TYPE_DEVICE_EXT                         = 3,
    VK_DEBUG_REPORT_OBJECT_TYPE_QUEUE_EXT                          = 4,
    VK_DEBUG_REPORT_OBJECT_TYPE_SEMAPHORE_EXT                      = 5,
    VK_DEBUG_REPORT_OBJECT_TYPE_COMMAND_BUFFER_EXT                 = 6,
    VK_DEBUG_REPORT_OBJECT_TYPE_FENCE_EXT                          = 7,
    VK_DEBUG_REPORT_OBJECT_TYPE_DEVICE_MEMORY_EXT                  = 8,
    VK_DEBUG_REPORT_OBJECT_TYPE_BUFFER_EXT                         = 9,
    VK_DEBUG_REPORT_OBJECT_TYPE_IMAGE_EXT                          = 10,
    VK_DEBUG_REPORT_OBJECT_TYPE_EVENT_EXT                          = 11,
    VK_DEBUG_REPORT_OBJECT_TYPE_QUERY_POOL_EXT                     = 12,
    VK_DEBUG_REPORT_OBJECT_TYPE_BUFFER_VIEW_EXT                    = 13,
    VK_DEBUG_REPORT_OBJECT_TYPE_IMAGE_VIEW_EXT                     = 14,
    VK_DEBUG_REPORT_OBJECT_TYPE_SHADER_MODULE_EXT                  = 15,
    VK_DEBUG_REPORT_OBJECT_TYPE_PIPELINE_CACHE_EXT                 = 16,
    VK_DEBUG_REPORT_OBJECT_TYPE_PIPELINE_LAYOUT_EXT                = 17,
    VK_DEBUG_REPORT_OBJECT_TYPE_RENDER_PASS_EXT                    = 18,
    VK_DEBUG_REPORT_OBJECT_TYPE_PIPELINE_EXT                       = 19,
    VK_DEBUG_REPORT_OBJECT_TYPE_DESCRIPTOR_SET_LAYOUT_EXT          = 20,
    VK_DEBUG_REPORT_OBJECT_TYPE_SAMPLER_EXT                        = 21,
    VK_DEBUG_REPORT_OBJECT_TYPE_DESCRIPTOR_POOL_EXT                = 22,
    VK_DEBUG_REPORT_OBJECT_TYPE_DESCRIPTOR_SET_EXT                 = 23,
    VK_DEBUG_REPORT_OBJECT_TYPE_FRAMEBUFFER_EXT                    = 24,
    VK_DEBUG_REPORT_OBJECT_TYPE_COMMAND_POOL_EXT                   = 25,
    VK_DEBUG_REPORT_OBJECT_TYPE_SURFACE_KHR_EXT                    = 26,
    VK_DEBUG_REPORT_OBJECT_TYPE_SWAPCHAIN_KHR_EXT                  = 27,
    VK_DEBUG_REPORT_OBJECT_TYPE_DEBUG_REPORT_CALLBACK_EXT_EXT      = 28,
    VK_DEBUG_REPORT_OBJECT_TYPE_DEBUG_REPORT_EXT                   = VK_DEBUG_REPORT_OBJECT_TYPE_DEBUG_REPORT_CALLBACK_EXT_EXT,
    VK_DEBUG_REPORT_OBJECT_TYPE_DISPLAY_KHR_EXT                    = 29,
    VK_DEBUG_REPORT_OBJECT_TYPE_DISPLAY_MODE_KHR_EXT               = 30,
    VK_DEBUG_REPORT_OBJECT_TYPE_OBJECT_TABLE_NVX_EXT               = 31,
    VK_DEBUG_REPORT_OBJECT_TYPE_INDIRECT_COMMANDS_LAYOUT_NVX_EXT   = 32,
    VK_DEBUG_REPORT_OBJECT_TYPE_VALIDATION_CACHE_EXT_EXT           = 33,
    VK_DEBUG_REPORT_OBJECT_TYPE_VALIDATION_CACHE_EXT               = VK_DEBUG_REPORT_OBJECT_TYPE_VALIDATION_CACHE_EXT_EXT,
    VK_DEBUG_REPORT_OBJECT_TYPE_SAMPLER_YCBCR_CONVERSION_EXT       = 1000156000,
    VK_DEBUG_REPORT_OBJECT_TYPE_DESCRIPTOR_UPDATE_TEMPLATE_EXT     = 1000085000,
    VK_DEBUG_REPORT_OBJECT_TYPE_DESCRIPTOR_UPDATE_TEMPLATE_KHR_EXT = VK_DEBUG_REPORT_OBJECT_TYPE_DESCRIPTOR_UPDATE_TEMPLATE_EXT,
    VK_DEBUG_REPORT_OBJECT_TYPE_SAMPLER_YCBCR_CONVERSION_KHR_EXT   = VK_DEBUG_REPORT_OBJECT_TYPE_SAMPLER_YCBCR_CONVERSION_EXT,
    VK_DEBUG_REPORT_OBJECT_TYPE_ACCELERATION_STRUCTURE_NV_EXT      = 1000165000,
}
enum VK_DEBUG_REPORT_OBJECT_TYPE_UNKNOWN_EXT                        = VkDebugReportObjectTypeEXT.VK_DEBUG_REPORT_OBJECT_TYPE_UNKNOWN_EXT;
enum VK_DEBUG_REPORT_OBJECT_TYPE_INSTANCE_EXT                       = VkDebugReportObjectTypeEXT.VK_DEBUG_REPORT_OBJECT_TYPE_INSTANCE_EXT;
enum VK_DEBUG_REPORT_OBJECT_TYPE_PHYSICAL_DEVICE_EXT                = VkDebugReportObjectTypeEXT.VK_DEBUG_REPORT_OBJECT_TYPE_PHYSICAL_DEVICE_EXT;
enum VK_DEBUG_REPORT_OBJECT_TYPE_DEVICE_EXT                         = VkDebugReportObjectTypeEXT.VK_DEBUG_REPORT_OBJECT_TYPE_DEVICE_EXT;
enum VK_DEBUG_REPORT_OBJECT_TYPE_QUEUE_EXT                          = VkDebugReportObjectTypeEXT.VK_DEBUG_REPORT_OBJECT_TYPE_QUEUE_EXT;
enum VK_DEBUG_REPORT_OBJECT_TYPE_SEMAPHORE_EXT                      = VkDebugReportObjectTypeEXT.VK_DEBUG_REPORT_OBJECT_TYPE_SEMAPHORE_EXT;
enum VK_DEBUG_REPORT_OBJECT_TYPE_COMMAND_BUFFER_EXT                 = VkDebugReportObjectTypeEXT.VK_DEBUG_REPORT_OBJECT_TYPE_COMMAND_BUFFER_EXT;
enum VK_DEBUG_REPORT_OBJECT_TYPE_FENCE_EXT                          = VkDebugReportObjectTypeEXT.VK_DEBUG_REPORT_OBJECT_TYPE_FENCE_EXT;
enum VK_DEBUG_REPORT_OBJECT_TYPE_DEVICE_MEMORY_EXT                  = VkDebugReportObjectTypeEXT.VK_DEBUG_REPORT_OBJECT_TYPE_DEVICE_MEMORY_EXT;
enum VK_DEBUG_REPORT_OBJECT_TYPE_BUFFER_EXT                         = VkDebugReportObjectTypeEXT.VK_DEBUG_REPORT_OBJECT_TYPE_BUFFER_EXT;
enum VK_DEBUG_REPORT_OBJECT_TYPE_IMAGE_EXT                          = VkDebugReportObjectTypeEXT.VK_DEBUG_REPORT_OBJECT_TYPE_IMAGE_EXT;
enum VK_DEBUG_REPORT_OBJECT_TYPE_EVENT_EXT                          = VkDebugReportObjectTypeEXT.VK_DEBUG_REPORT_OBJECT_TYPE_EVENT_EXT;
enum VK_DEBUG_REPORT_OBJECT_TYPE_QUERY_POOL_EXT                     = VkDebugReportObjectTypeEXT.VK_DEBUG_REPORT_OBJECT_TYPE_QUERY_POOL_EXT;
enum VK_DEBUG_REPORT_OBJECT_TYPE_BUFFER_VIEW_EXT                    = VkDebugReportObjectTypeEXT.VK_DEBUG_REPORT_OBJECT_TYPE_BUFFER_VIEW_EXT;
enum VK_DEBUG_REPORT_OBJECT_TYPE_IMAGE_VIEW_EXT                     = VkDebugReportObjectTypeEXT.VK_DEBUG_REPORT_OBJECT_TYPE_IMAGE_VIEW_EXT;
enum VK_DEBUG_REPORT_OBJECT_TYPE_SHADER_MODULE_EXT                  = VkDebugReportObjectTypeEXT.VK_DEBUG_REPORT_OBJECT_TYPE_SHADER_MODULE_EXT;
enum VK_DEBUG_REPORT_OBJECT_TYPE_PIPELINE_CACHE_EXT                 = VkDebugReportObjectTypeEXT.VK_DEBUG_REPORT_OBJECT_TYPE_PIPELINE_CACHE_EXT;
enum VK_DEBUG_REPORT_OBJECT_TYPE_PIPELINE_LAYOUT_EXT                = VkDebugReportObjectTypeEXT.VK_DEBUG_REPORT_OBJECT_TYPE_PIPELINE_LAYOUT_EXT;
enum VK_DEBUG_REPORT_OBJECT_TYPE_RENDER_PASS_EXT                    = VkDebugReportObjectTypeEXT.VK_DEBUG_REPORT_OBJECT_TYPE_RENDER_PASS_EXT;
enum VK_DEBUG_REPORT_OBJECT_TYPE_PIPELINE_EXT                       = VkDebugReportObjectTypeEXT.VK_DEBUG_REPORT_OBJECT_TYPE_PIPELINE_EXT;
enum VK_DEBUG_REPORT_OBJECT_TYPE_DESCRIPTOR_SET_LAYOUT_EXT          = VkDebugReportObjectTypeEXT.VK_DEBUG_REPORT_OBJECT_TYPE_DESCRIPTOR_SET_LAYOUT_EXT;
enum VK_DEBUG_REPORT_OBJECT_TYPE_SAMPLER_EXT                        = VkDebugReportObjectTypeEXT.VK_DEBUG_REPORT_OBJECT_TYPE_SAMPLER_EXT;
enum VK_DEBUG_REPORT_OBJECT_TYPE_DESCRIPTOR_POOL_EXT                = VkDebugReportObjectTypeEXT.VK_DEBUG_REPORT_OBJECT_TYPE_DESCRIPTOR_POOL_EXT;
enum VK_DEBUG_REPORT_OBJECT_TYPE_DESCRIPTOR_SET_EXT                 = VkDebugReportObjectTypeEXT.VK_DEBUG_REPORT_OBJECT_TYPE_DESCRIPTOR_SET_EXT;
enum VK_DEBUG_REPORT_OBJECT_TYPE_FRAMEBUFFER_EXT                    = VkDebugReportObjectTypeEXT.VK_DEBUG_REPORT_OBJECT_TYPE_FRAMEBUFFER_EXT;
enum VK_DEBUG_REPORT_OBJECT_TYPE_COMMAND_POOL_EXT                   = VkDebugReportObjectTypeEXT.VK_DEBUG_REPORT_OBJECT_TYPE_COMMAND_POOL_EXT;
enum VK_DEBUG_REPORT_OBJECT_TYPE_SURFACE_KHR_EXT                    = VkDebugReportObjectTypeEXT.VK_DEBUG_REPORT_OBJECT_TYPE_SURFACE_KHR_EXT;
enum VK_DEBUG_REPORT_OBJECT_TYPE_SWAPCHAIN_KHR_EXT                  = VkDebugReportObjectTypeEXT.VK_DEBUG_REPORT_OBJECT_TYPE_SWAPCHAIN_KHR_EXT;
enum VK_DEBUG_REPORT_OBJECT_TYPE_DEBUG_REPORT_CALLBACK_EXT_EXT      = VkDebugReportObjectTypeEXT.VK_DEBUG_REPORT_OBJECT_TYPE_DEBUG_REPORT_CALLBACK_EXT_EXT;
enum VK_DEBUG_REPORT_OBJECT_TYPE_DEBUG_REPORT_EXT                   = VkDebugReportObjectTypeEXT.VK_DEBUG_REPORT_OBJECT_TYPE_DEBUG_REPORT_EXT;
enum VK_DEBUG_REPORT_OBJECT_TYPE_DISPLAY_KHR_EXT                    = VkDebugReportObjectTypeEXT.VK_DEBUG_REPORT_OBJECT_TYPE_DISPLAY_KHR_EXT;
enum VK_DEBUG_REPORT_OBJECT_TYPE_DISPLAY_MODE_KHR_EXT               = VkDebugReportObjectTypeEXT.VK_DEBUG_REPORT_OBJECT_TYPE_DISPLAY_MODE_KHR_EXT;
enum VK_DEBUG_REPORT_OBJECT_TYPE_OBJECT_TABLE_NVX_EXT               = VkDebugReportObjectTypeEXT.VK_DEBUG_REPORT_OBJECT_TYPE_OBJECT_TABLE_NVX_EXT;
enum VK_DEBUG_REPORT_OBJECT_TYPE_INDIRECT_COMMANDS_LAYOUT_NVX_EXT   = VkDebugReportObjectTypeEXT.VK_DEBUG_REPORT_OBJECT_TYPE_INDIRECT_COMMANDS_LAYOUT_NVX_EXT;
enum VK_DEBUG_REPORT_OBJECT_TYPE_VALIDATION_CACHE_EXT_EXT           = VkDebugReportObjectTypeEXT.VK_DEBUG_REPORT_OBJECT_TYPE_VALIDATION_CACHE_EXT_EXT;
enum VK_DEBUG_REPORT_OBJECT_TYPE_VALIDATION_CACHE_EXT               = VkDebugReportObjectTypeEXT.VK_DEBUG_REPORT_OBJECT_TYPE_VALIDATION_CACHE_EXT;
enum VK_DEBUG_REPORT_OBJECT_TYPE_SAMPLER_YCBCR_CONVERSION_EXT       = VkDebugReportObjectTypeEXT.VK_DEBUG_REPORT_OBJECT_TYPE_SAMPLER_YCBCR_CONVERSION_EXT;
enum VK_DEBUG_REPORT_OBJECT_TYPE_DESCRIPTOR_UPDATE_TEMPLATE_EXT     = VkDebugReportObjectTypeEXT.VK_DEBUG_REPORT_OBJECT_TYPE_DESCRIPTOR_UPDATE_TEMPLATE_EXT;
enum VK_DEBUG_REPORT_OBJECT_TYPE_DESCRIPTOR_UPDATE_TEMPLATE_KHR_EXT = VkDebugReportObjectTypeEXT.VK_DEBUG_REPORT_OBJECT_TYPE_DESCRIPTOR_UPDATE_TEMPLATE_KHR_EXT;
enum VK_DEBUG_REPORT_OBJECT_TYPE_SAMPLER_YCBCR_CONVERSION_KHR_EXT   = VkDebugReportObjectTypeEXT.VK_DEBUG_REPORT_OBJECT_TYPE_SAMPLER_YCBCR_CONVERSION_KHR_EXT;
enum VK_DEBUG_REPORT_OBJECT_TYPE_ACCELERATION_STRUCTURE_NV_EXT      = VkDebugReportObjectTypeEXT.VK_DEBUG_REPORT_OBJECT_TYPE_ACCELERATION_STRUCTURE_NV_EXT;

enum VkDebugReportFlagBitsEXT {
    VK_DEBUG_REPORT_INFORMATION_BIT_EXT         = 0x00000001,
    VK_DEBUG_REPORT_WARNING_BIT_EXT             = 0x00000002,
    VK_DEBUG_REPORT_PERFORMANCE_WARNING_BIT_EXT = 0x00000004,
    VK_DEBUG_REPORT_ERROR_BIT_EXT               = 0x00000008,
    VK_DEBUG_REPORT_DEBUG_BIT_EXT               = 0x00000010,
}
enum VK_DEBUG_REPORT_INFORMATION_BIT_EXT         = VkDebugReportFlagBitsEXT.VK_DEBUG_REPORT_INFORMATION_BIT_EXT;
enum VK_DEBUG_REPORT_WARNING_BIT_EXT             = VkDebugReportFlagBitsEXT.VK_DEBUG_REPORT_WARNING_BIT_EXT;
enum VK_DEBUG_REPORT_PERFORMANCE_WARNING_BIT_EXT = VkDebugReportFlagBitsEXT.VK_DEBUG_REPORT_PERFORMANCE_WARNING_BIT_EXT;
enum VK_DEBUG_REPORT_ERROR_BIT_EXT               = VkDebugReportFlagBitsEXT.VK_DEBUG_REPORT_ERROR_BIT_EXT;
enum VK_DEBUG_REPORT_DEBUG_BIT_EXT               = VkDebugReportFlagBitsEXT.VK_DEBUG_REPORT_DEBUG_BIT_EXT;


// Structures

// VK_VERSION_1_0
struct VkApplicationInfo {
    VkStructureType sType;
    const(void)*    pNext;
    const(char)*    pApplicationName;
    uint32_t        applicationVersion;
    const(char)*    pEngineName;
    uint32_t        engineVersion;
    uint32_t        apiVersion;
}
struct VkInstanceCreateInfo {
    VkStructureType           sType;
    const(void)*              pNext;
    VkInstanceCreateFlags     flags;
    const(VkApplicationInfo)* pApplicationInfo;
    uint32_t                  enabledLayerCount;
    const(char*)*             ppEnabledLayerNames;
    uint32_t                  enabledExtensionCount;
    const(char*)*             ppEnabledExtensionNames;
}
struct VkAllocationCallbacks {
    void*                                pUserData;
    PFN_vkAllocationFunction             pfnAllocation;
    PFN_vkReallocationFunction           pfnReallocation;
    PFN_vkFreeFunction                   pfnFree;
    PFN_vkInternalAllocationNotification pfnInternalAllocation;
    PFN_vkInternalFreeNotification       pfnInternalFree;
}
struct VkPhysicalDeviceFeatures {
    VkBool32 robustBufferAccess;
    VkBool32 fullDrawIndexUint32;
    VkBool32 imageCubeArray;
    VkBool32 independentBlend;
    VkBool32 geometryShader;
    VkBool32 tessellationShader;
    VkBool32 sampleRateShading;
    VkBool32 dualSrcBlend;
    VkBool32 logicOp;
    VkBool32 multiDrawIndirect;
    VkBool32 drawIndirectFirstInstance;
    VkBool32 depthClamp;
    VkBool32 depthBiasClamp;
    VkBool32 fillModeNonSolid;
    VkBool32 depthBounds;
    VkBool32 wideLines;
    VkBool32 largePoints;
    VkBool32 alphaToOne;
    VkBool32 multiViewport;
    VkBool32 samplerAnisotropy;
    VkBool32 textureCompressionETC2;
    VkBool32 textureCompressionASTC_LDR;
    VkBool32 textureCompressionBC;
    VkBool32 occlusionQueryPrecise;
    VkBool32 pipelineStatisticsQuery;
    VkBool32 vertexPipelineStoresAndAtomics;
    VkBool32 fragmentStoresAndAtomics;
    VkBool32 shaderTessellationAndGeometryPointSize;
    VkBool32 shaderImageGatherExtended;
    VkBool32 shaderStorageImageExtendedFormats;
    VkBool32 shaderStorageImageMultisample;
    VkBool32 shaderStorageImageReadWithoutFormat;
    VkBool32 shaderStorageImageWriteWithoutFormat;
    VkBool32 shaderUniformBufferArrayDynamicIndexing;
    VkBool32 shaderSampledImageArrayDynamicIndexing;
    VkBool32 shaderStorageBufferArrayDynamicIndexing;
    VkBool32 shaderStorageImageArrayDynamicIndexing;
    VkBool32 shaderClipDistance;
    VkBool32 shaderCullDistance;
    VkBool32 shaderFloat64;
    VkBool32 shaderInt64;
    VkBool32 shaderInt16;
    VkBool32 shaderResourceResidency;
    VkBool32 shaderResourceMinLod;
    VkBool32 sparseBinding;
    VkBool32 sparseResidencyBuffer;
    VkBool32 sparseResidencyImage2D;
    VkBool32 sparseResidencyImage3D;
    VkBool32 sparseResidency2Samples;
    VkBool32 sparseResidency4Samples;
    VkBool32 sparseResidency8Samples;
    VkBool32 sparseResidency16Samples;
    VkBool32 sparseResidencyAliased;
    VkBool32 variableMultisampleRate;
    VkBool32 inheritedQueries;
}
struct VkFormatProperties {
    VkFormatFeatureFlags linearTilingFeatures;
    VkFormatFeatureFlags optimalTilingFeatures;
    VkFormatFeatureFlags bufferFeatures;
}
struct VkExtent3D {
    uint32_t width;
    uint32_t height;
    uint32_t depth;
}
struct VkImageFormatProperties {
    VkExtent3D         maxExtent;
    uint32_t           maxMipLevels;
    uint32_t           maxArrayLayers;
    VkSampleCountFlags sampleCounts;
    VkDeviceSize       maxResourceSize;
}
struct VkPhysicalDeviceLimits {
    uint32_t           maxImageDimension1D;
    uint32_t           maxImageDimension2D;
    uint32_t           maxImageDimension3D;
    uint32_t           maxImageDimensionCube;
    uint32_t           maxImageArrayLayers;
    uint32_t           maxTexelBufferElements;
    uint32_t           maxUniformBufferRange;
    uint32_t           maxStorageBufferRange;
    uint32_t           maxPushConstantsSize;
    uint32_t           maxMemoryAllocationCount;
    uint32_t           maxSamplerAllocationCount;
    VkDeviceSize       bufferImageGranularity;
    VkDeviceSize       sparseAddressSpaceSize;
    uint32_t           maxBoundDescriptorSets;
    uint32_t           maxPerStageDescriptorSamplers;
    uint32_t           maxPerStageDescriptorUniformBuffers;
    uint32_t           maxPerStageDescriptorStorageBuffers;
    uint32_t           maxPerStageDescriptorSampledImages;
    uint32_t           maxPerStageDescriptorStorageImages;
    uint32_t           maxPerStageDescriptorInputAttachments;
    uint32_t           maxPerStageResources;
    uint32_t           maxDescriptorSetSamplers;
    uint32_t           maxDescriptorSetUniformBuffers;
    uint32_t           maxDescriptorSetUniformBuffersDynamic;
    uint32_t           maxDescriptorSetStorageBuffers;
    uint32_t           maxDescriptorSetStorageBuffersDynamic;
    uint32_t           maxDescriptorSetSampledImages;
    uint32_t           maxDescriptorSetStorageImages;
    uint32_t           maxDescriptorSetInputAttachments;
    uint32_t           maxVertexInputAttributes;
    uint32_t           maxVertexInputBindings;
    uint32_t           maxVertexInputAttributeOffset;
    uint32_t           maxVertexInputBindingStride;
    uint32_t           maxVertexOutputComponents;
    uint32_t           maxTessellationGenerationLevel;
    uint32_t           maxTessellationPatchSize;
    uint32_t           maxTessellationControlPerVertexInputComponents;
    uint32_t           maxTessellationControlPerVertexOutputComponents;
    uint32_t           maxTessellationControlPerPatchOutputComponents;
    uint32_t           maxTessellationControlTotalOutputComponents;
    uint32_t           maxTessellationEvaluationInputComponents;
    uint32_t           maxTessellationEvaluationOutputComponents;
    uint32_t           maxGeometryShaderInvocations;
    uint32_t           maxGeometryInputComponents;
    uint32_t           maxGeometryOutputComponents;
    uint32_t           maxGeometryOutputVertices;
    uint32_t           maxGeometryTotalOutputComponents;
    uint32_t           maxFragmentInputComponents;
    uint32_t           maxFragmentOutputAttachments;
    uint32_t           maxFragmentDualSrcAttachments;
    uint32_t           maxFragmentCombinedOutputResources;
    uint32_t           maxComputeSharedMemorySize;
    uint32_t[3]        maxComputeWorkGroupCount;
    uint32_t           maxComputeWorkGroupInvocations;
    uint32_t[3]        maxComputeWorkGroupSize;
    uint32_t           subPixelPrecisionBits;
    uint32_t           subTexelPrecisionBits;
    uint32_t           mipmapPrecisionBits;
    uint32_t           maxDrawIndexedIndexValue;
    uint32_t           maxDrawIndirectCount;
    float              maxSamplerLodBias;
    float              maxSamplerAnisotropy;
    uint32_t           maxViewports;
    uint32_t[2]        maxViewportDimensions;
    float[2]           viewportBoundsRange;
    uint32_t           viewportSubPixelBits;
    size_t             minMemoryMapAlignment;
    VkDeviceSize       minTexelBufferOffsetAlignment;
    VkDeviceSize       minUniformBufferOffsetAlignment;
    VkDeviceSize       minStorageBufferOffsetAlignment;
    int32_t            minTexelOffset;
    uint32_t           maxTexelOffset;
    int32_t            minTexelGatherOffset;
    uint32_t           maxTexelGatherOffset;
    float              minInterpolationOffset;
    float              maxInterpolationOffset;
    uint32_t           subPixelInterpolationOffsetBits;
    uint32_t           maxFramebufferWidth;
    uint32_t           maxFramebufferHeight;
    uint32_t           maxFramebufferLayers;
    VkSampleCountFlags framebufferColorSampleCounts;
    VkSampleCountFlags framebufferDepthSampleCounts;
    VkSampleCountFlags framebufferStencilSampleCounts;
    VkSampleCountFlags framebufferNoAttachmentsSampleCounts;
    uint32_t           maxColorAttachments;
    VkSampleCountFlags sampledImageColorSampleCounts;
    VkSampleCountFlags sampledImageIntegerSampleCounts;
    VkSampleCountFlags sampledImageDepthSampleCounts;
    VkSampleCountFlags sampledImageStencilSampleCounts;
    VkSampleCountFlags storageImageSampleCounts;
    uint32_t           maxSampleMaskWords;
    VkBool32           timestampComputeAndGraphics;
    float              timestampPeriod;
    uint32_t           maxClipDistances;
    uint32_t           maxCullDistances;
    uint32_t           maxCombinedClipAndCullDistances;
    uint32_t           discreteQueuePriorities;
    float[2]           pointSizeRange;
    float[2]           lineWidthRange;
    float              pointSizeGranularity;
    float              lineWidthGranularity;
    VkBool32           strictLines;
    VkBool32           standardSampleLocations;
    VkDeviceSize       optimalBufferCopyOffsetAlignment;
    VkDeviceSize       optimalBufferCopyRowPitchAlignment;
    VkDeviceSize       nonCoherentAtomSize;
}
struct VkPhysicalDeviceSparseProperties {
    VkBool32 residencyStandard2DBlockShape;
    VkBool32 residencyStandard2DMultisampleBlockShape;
    VkBool32 residencyStandard3DBlockShape;
    VkBool32 residencyAlignedMipSize;
    VkBool32 residencyNonResidentStrict;
}
struct VkPhysicalDeviceProperties {
    uint32_t                               apiVersion;
    uint32_t                               driverVersion;
    uint32_t                               vendorID;
    uint32_t                               deviceID;
    VkPhysicalDeviceType                   deviceType;
    char[VK_MAX_PHYSICAL_DEVICE_NAME_SIZE] deviceName;
    uint8_t[VK_UUID_SIZE]                  pipelineCacheUUID;
    VkPhysicalDeviceLimits                 limits;
    VkPhysicalDeviceSparseProperties       sparseProperties;
}
struct VkQueueFamilyProperties {
    VkQueueFlags queueFlags;
    uint32_t     queueCount;
    uint32_t     timestampValidBits;
    VkExtent3D   minImageTransferGranularity;
}
struct VkMemoryType {
    VkMemoryPropertyFlags propertyFlags;
    uint32_t              heapIndex;
}
struct VkMemoryHeap {
    VkDeviceSize      size;
    VkMemoryHeapFlags flags;
}
struct VkPhysicalDeviceMemoryProperties {
    uint32_t                          memoryTypeCount;
    VkMemoryType[VK_MAX_MEMORY_TYPES] memoryTypes;
    uint32_t                          memoryHeapCount;
    VkMemoryHeap[VK_MAX_MEMORY_HEAPS] memoryHeaps;
}
struct VkDeviceQueueCreateInfo {
    VkStructureType          sType;
    const(void)*             pNext;
    VkDeviceQueueCreateFlags flags;
    uint32_t                 queueFamilyIndex;
    uint32_t                 queueCount;
    const(float)*            pQueuePriorities;
}
struct VkDeviceCreateInfo {
    VkStructureType                  sType;
    const(void)*                     pNext;
    VkDeviceCreateFlags              flags;
    uint32_t                         queueCreateInfoCount;
    const(VkDeviceQueueCreateInfo)*  pQueueCreateInfos;
    uint32_t                         enabledLayerCount;
    const(char*)*                    ppEnabledLayerNames;
    uint32_t                         enabledExtensionCount;
    const(char*)*                    ppEnabledExtensionNames;
    const(VkPhysicalDeviceFeatures)* pEnabledFeatures;
}
struct VkExtensionProperties {
    char[VK_MAX_EXTENSION_NAME_SIZE] extensionName;
    uint32_t                         specVersion;
}
struct VkLayerProperties {
    char[VK_MAX_EXTENSION_NAME_SIZE] layerName;
    uint32_t                         specVersion;
    uint32_t                         implementationVersion;
    char[VK_MAX_DESCRIPTION_SIZE]    description;
}
struct VkSubmitInfo {
    VkStructureType              sType;
    const(void)*                 pNext;
    uint32_t                     waitSemaphoreCount;
    const(VkSemaphore)*          pWaitSemaphores;
    const(VkPipelineStageFlags)* pWaitDstStageMask;
    uint32_t                     commandBufferCount;
    const(VkCommandBuffer)*      pCommandBuffers;
    uint32_t                     signalSemaphoreCount;
    const(VkSemaphore)*          pSignalSemaphores;
}
struct VkMemoryAllocateInfo {
    VkStructureType sType;
    const(void)*    pNext;
    VkDeviceSize    allocationSize;
    uint32_t        memoryTypeIndex;
}
struct VkMappedMemoryRange {
    VkStructureType sType;
    const(void)*    pNext;
    VkDeviceMemory  memory;
    VkDeviceSize    offset;
    VkDeviceSize    size;
}
struct VkMemoryRequirements {
    VkDeviceSize size;
    VkDeviceSize alignment;
    uint32_t     memoryTypeBits;
}
struct VkSparseImageFormatProperties {
    VkImageAspectFlags       aspectMask;
    VkExtent3D               imageGranularity;
    VkSparseImageFormatFlags flags;
}
struct VkSparseImageMemoryRequirements {
    VkSparseImageFormatProperties formatProperties;
    uint32_t                      imageMipTailFirstLod;
    VkDeviceSize                  imageMipTailSize;
    VkDeviceSize                  imageMipTailOffset;
    VkDeviceSize                  imageMipTailStride;
}
struct VkSparseMemoryBind {
    VkDeviceSize            resourceOffset;
    VkDeviceSize            size;
    VkDeviceMemory          memory;
    VkDeviceSize            memoryOffset;
    VkSparseMemoryBindFlags flags;
}
struct VkSparseBufferMemoryBindInfo {
    VkBuffer                   buffer;
    uint32_t                   bindCount;
    const(VkSparseMemoryBind)* pBinds;
}
struct VkSparseImageOpaqueMemoryBindInfo {
    VkImage                    image;
    uint32_t                   bindCount;
    const(VkSparseMemoryBind)* pBinds;
}
struct VkImageSubresource {
    VkImageAspectFlags aspectMask;
    uint32_t           mipLevel;
    uint32_t           arrayLayer;
}
struct VkOffset3D {
    int32_t x;
    int32_t y;
    int32_t z;
}
struct VkSparseImageMemoryBind {
    VkImageSubresource      subresource;
    VkOffset3D              offset;
    VkExtent3D              extent;
    VkDeviceMemory          memory;
    VkDeviceSize            memoryOffset;
    VkSparseMemoryBindFlags flags;
}
struct VkSparseImageMemoryBindInfo {
    VkImage                         image;
    uint32_t                        bindCount;
    const(VkSparseImageMemoryBind)* pBinds;
}
struct VkBindSparseInfo {
    VkStructureType                           sType;
    const(void)*                              pNext;
    uint32_t                                  waitSemaphoreCount;
    const(VkSemaphore)*                       pWaitSemaphores;
    uint32_t                                  bufferBindCount;
    const(VkSparseBufferMemoryBindInfo)*      pBufferBinds;
    uint32_t                                  imageOpaqueBindCount;
    const(VkSparseImageOpaqueMemoryBindInfo)* pImageOpaqueBinds;
    uint32_t                                  imageBindCount;
    const(VkSparseImageMemoryBindInfo)*       pImageBinds;
    uint32_t                                  signalSemaphoreCount;
    const(VkSemaphore)*                       pSignalSemaphores;
}
struct VkFenceCreateInfo {
    VkStructureType    sType;
    const(void)*       pNext;
    VkFenceCreateFlags flags;
}
struct VkSemaphoreCreateInfo {
    VkStructureType        sType;
    const(void)*           pNext;
    VkSemaphoreCreateFlags flags;
}
struct VkEventCreateInfo {
    VkStructureType    sType;
    const(void)*       pNext;
    VkEventCreateFlags flags;
}
struct VkQueryPoolCreateInfo {
    VkStructureType               sType;
    const(void)*                  pNext;
    VkQueryPoolCreateFlags        flags;
    VkQueryType                   queryType;
    uint32_t                      queryCount;
    VkQueryPipelineStatisticFlags pipelineStatistics;
}
struct VkBufferCreateInfo {
    VkStructureType     sType;
    const(void)*        pNext;
    VkBufferCreateFlags flags;
    VkDeviceSize        size;
    VkBufferUsageFlags  usage;
    VkSharingMode       sharingMode;
    uint32_t            queueFamilyIndexCount;
    const(uint32_t)*    pQueueFamilyIndices;
}
struct VkBufferViewCreateInfo {
    VkStructureType         sType;
    const(void)*            pNext;
    VkBufferViewCreateFlags flags;
    VkBuffer                buffer;
    VkFormat                format;
    VkDeviceSize            offset;
    VkDeviceSize            range;
}
struct VkImageCreateInfo {
    VkStructureType       sType;
    const(void)*          pNext;
    VkImageCreateFlags    flags;
    VkImageType           imageType;
    VkFormat              format;
    VkExtent3D            extent;
    uint32_t              mipLevels;
    uint32_t              arrayLayers;
    VkSampleCountFlagBits samples;
    VkImageTiling         tiling;
    VkImageUsageFlags     usage;
    VkSharingMode         sharingMode;
    uint32_t              queueFamilyIndexCount;
    const(uint32_t)*      pQueueFamilyIndices;
    VkImageLayout         initialLayout;
}
struct VkSubresourceLayout {
    VkDeviceSize offset;
    VkDeviceSize size;
    VkDeviceSize rowPitch;
    VkDeviceSize arrayPitch;
    VkDeviceSize depthPitch;
}
struct VkComponentMapping {
    VkComponentSwizzle r;
    VkComponentSwizzle g;
    VkComponentSwizzle b;
    VkComponentSwizzle a;
}
struct VkImageSubresourceRange {
    VkImageAspectFlags aspectMask;
    uint32_t           baseMipLevel;
    uint32_t           levelCount;
    uint32_t           baseArrayLayer;
    uint32_t           layerCount;
}
struct VkImageViewCreateInfo {
    VkStructureType         sType;
    const(void)*            pNext;
    VkImageViewCreateFlags  flags;
    VkImage                 image;
    VkImageViewType         viewType;
    VkFormat                format;
    VkComponentMapping      components;
    VkImageSubresourceRange subresourceRange;
}
struct VkShaderModuleCreateInfo {
    VkStructureType           sType;
    const(void)*              pNext;
    VkShaderModuleCreateFlags flags;
    size_t                    codeSize;
    const(uint32_t)*          pCode;
}
struct VkPipelineCacheCreateInfo {
    VkStructureType            sType;
    const(void)*               pNext;
    VkPipelineCacheCreateFlags flags;
    size_t                     initialDataSize;
    const(void)*               pInitialData;
}
struct VkSpecializationMapEntry {
    uint32_t constantID;
    uint32_t offset;
    size_t   size;
}
struct VkSpecializationInfo {
    uint32_t                         mapEntryCount;
    const(VkSpecializationMapEntry)* pMapEntries;
    size_t                           dataSize;
    const(void)*                     pData;
}
struct VkPipelineShaderStageCreateInfo {
    VkStructureType                  sType;
    const(void)*                     pNext;
    VkPipelineShaderStageCreateFlags flags;
    VkShaderStageFlagBits            stage;
    VkShaderModule                   module_;
    const(char)*                     pName;
    const(VkSpecializationInfo)*     pSpecializationInfo;
}
struct VkVertexInputBindingDescription {
    uint32_t          binding;
    uint32_t          stride;
    VkVertexInputRate inputRate;
}
struct VkVertexInputAttributeDescription {
    uint32_t location;
    uint32_t binding;
    VkFormat format;
    uint32_t offset;
}
struct VkPipelineVertexInputStateCreateInfo {
    VkStructureType                           sType;
    const(void)*                              pNext;
    VkPipelineVertexInputStateCreateFlags     flags;
    uint32_t                                  vertexBindingDescriptionCount;
    const(VkVertexInputBindingDescription)*   pVertexBindingDescriptions;
    uint32_t                                  vertexAttributeDescriptionCount;
    const(VkVertexInputAttributeDescription)* pVertexAttributeDescriptions;
}
struct VkPipelineInputAssemblyStateCreateInfo {
    VkStructureType                         sType;
    const(void)*                            pNext;
    VkPipelineInputAssemblyStateCreateFlags flags;
    VkPrimitiveTopology                     topology;
    VkBool32                                primitiveRestartEnable;
}
struct VkPipelineTessellationStateCreateInfo {
    VkStructureType                        sType;
    const(void)*                           pNext;
    VkPipelineTessellationStateCreateFlags flags;
    uint32_t                               patchControlPoints;
}
struct VkViewport {
    float x;
    float y;
    float width;
    float height;
    float minDepth;
    float maxDepth;
}
struct VkOffset2D {
    int32_t x;
    int32_t y;
}
struct VkExtent2D {
    uint32_t width;
    uint32_t height;
}
struct VkRect2D {
    VkOffset2D offset;
    VkExtent2D extent;
}
struct VkPipelineViewportStateCreateInfo {
    VkStructureType                    sType;
    const(void)*                       pNext;
    VkPipelineViewportStateCreateFlags flags;
    uint32_t                           viewportCount;
    const(VkViewport)*                 pViewports;
    uint32_t                           scissorCount;
    const(VkRect2D)*                   pScissors;
}
struct VkPipelineRasterizationStateCreateInfo {
    VkStructureType                         sType;
    const(void)*                            pNext;
    VkPipelineRasterizationStateCreateFlags flags;
    VkBool32                                depthClampEnable;
    VkBool32                                rasterizerDiscardEnable;
    VkPolygonMode                           polygonMode;
    VkCullModeFlags                         cullMode;
    VkFrontFace                             frontFace;
    VkBool32                                depthBiasEnable;
    float                                   depthBiasConstantFactor;
    float                                   depthBiasClamp;
    float                                   depthBiasSlopeFactor;
    float                                   lineWidth;
}
struct VkPipelineMultisampleStateCreateInfo {
    VkStructureType                       sType;
    const(void)*                          pNext;
    VkPipelineMultisampleStateCreateFlags flags;
    VkSampleCountFlagBits                 rasterizationSamples;
    VkBool32                              sampleShadingEnable;
    float                                 minSampleShading;
    const(VkSampleMask)*                  pSampleMask;
    VkBool32                              alphaToCoverageEnable;
    VkBool32                              alphaToOneEnable;
}
struct VkStencilOpState {
    VkStencilOp failOp;
    VkStencilOp passOp;
    VkStencilOp depthFailOp;
    VkCompareOp compareOp;
    uint32_t    compareMask;
    uint32_t    writeMask;
    uint32_t    reference;
}
struct VkPipelineDepthStencilStateCreateInfo {
    VkStructureType                        sType;
    const(void)*                           pNext;
    VkPipelineDepthStencilStateCreateFlags flags;
    VkBool32                               depthTestEnable;
    VkBool32                               depthWriteEnable;
    VkCompareOp                            depthCompareOp;
    VkBool32                               depthBoundsTestEnable;
    VkBool32                               stencilTestEnable;
    VkStencilOpState                       front;
    VkStencilOpState                       back;
    float                                  minDepthBounds;
    float                                  maxDepthBounds;
}
struct VkPipelineColorBlendAttachmentState {
    VkBool32              blendEnable;
    VkBlendFactor         srcColorBlendFactor;
    VkBlendFactor         dstColorBlendFactor;
    VkBlendOp             colorBlendOp;
    VkBlendFactor         srcAlphaBlendFactor;
    VkBlendFactor         dstAlphaBlendFactor;
    VkBlendOp             alphaBlendOp;
    VkColorComponentFlags colorWriteMask;
}
struct VkPipelineColorBlendStateCreateInfo {
    VkStructureType                             sType;
    const(void)*                                pNext;
    VkPipelineColorBlendStateCreateFlags        flags;
    VkBool32                                    logicOpEnable;
    VkLogicOp                                   logicOp;
    uint32_t                                    attachmentCount;
    const(VkPipelineColorBlendAttachmentState)* pAttachments;
    float[4]                                    blendConstants;
}
struct VkPipelineDynamicStateCreateInfo {
    VkStructureType                   sType;
    const(void)*                      pNext;
    VkPipelineDynamicStateCreateFlags flags;
    uint32_t                          dynamicStateCount;
    const(VkDynamicState)*            pDynamicStates;
}
struct VkGraphicsPipelineCreateInfo {
    VkStructureType                                sType;
    const(void)*                                   pNext;
    VkPipelineCreateFlags                          flags;
    uint32_t                                       stageCount;
    const(VkPipelineShaderStageCreateInfo)*        pStages;
    const(VkPipelineVertexInputStateCreateInfo)*   pVertexInputState;
    const(VkPipelineInputAssemblyStateCreateInfo)* pInputAssemblyState;
    const(VkPipelineTessellationStateCreateInfo)*  pTessellationState;
    const(VkPipelineViewportStateCreateInfo)*      pViewportState;
    const(VkPipelineRasterizationStateCreateInfo)* pRasterizationState;
    const(VkPipelineMultisampleStateCreateInfo)*   pMultisampleState;
    const(VkPipelineDepthStencilStateCreateInfo)*  pDepthStencilState;
    const(VkPipelineColorBlendStateCreateInfo)*    pColorBlendState;
    const(VkPipelineDynamicStateCreateInfo)*       pDynamicState;
    VkPipelineLayout                               layout;
    VkRenderPass                                   renderPass;
    uint32_t                                       subpass;
    VkPipeline                                     basePipelineHandle;
    int32_t                                        basePipelineIndex;
}
struct VkComputePipelineCreateInfo {
    VkStructureType                 sType;
    const(void)*                    pNext;
    VkPipelineCreateFlags           flags;
    VkPipelineShaderStageCreateInfo stage;
    VkPipelineLayout                layout;
    VkPipeline                      basePipelineHandle;
    int32_t                         basePipelineIndex;
}
struct VkPushConstantRange {
    VkShaderStageFlags stageFlags;
    uint32_t           offset;
    uint32_t           size;
}
struct VkPipelineLayoutCreateInfo {
    VkStructureType               sType;
    const(void)*                  pNext;
    VkPipelineLayoutCreateFlags   flags;
    uint32_t                      setLayoutCount;
    const(VkDescriptorSetLayout)* pSetLayouts;
    uint32_t                      pushConstantRangeCount;
    const(VkPushConstantRange)*   pPushConstantRanges;
}
struct VkSamplerCreateInfo {
    VkStructureType      sType;
    const(void)*         pNext;
    VkSamplerCreateFlags flags;
    VkFilter             magFilter;
    VkFilter             minFilter;
    VkSamplerMipmapMode  mipmapMode;
    VkSamplerAddressMode addressModeU;
    VkSamplerAddressMode addressModeV;
    VkSamplerAddressMode addressModeW;
    float                mipLodBias;
    VkBool32             anisotropyEnable;
    float                maxAnisotropy;
    VkBool32             compareEnable;
    VkCompareOp          compareOp;
    float                minLod;
    float                maxLod;
    VkBorderColor        borderColor;
    VkBool32             unnormalizedCoordinates;
}
struct VkDescriptorSetLayoutBinding {
    uint32_t           binding;
    VkDescriptorType   descriptorType;
    uint32_t           descriptorCount;
    VkShaderStageFlags stageFlags;
    const(VkSampler)*  pImmutableSamplers;
}
struct VkDescriptorSetLayoutCreateInfo {
    VkStructureType                      sType;
    const(void)*                         pNext;
    VkDescriptorSetLayoutCreateFlags     flags;
    uint32_t                             bindingCount;
    const(VkDescriptorSetLayoutBinding)* pBindings;
}
struct VkDescriptorPoolSize {
    VkDescriptorType type;
    uint32_t         descriptorCount;
}
struct VkDescriptorPoolCreateInfo {
    VkStructureType              sType;
    const(void)*                 pNext;
    VkDescriptorPoolCreateFlags  flags;
    uint32_t                     maxSets;
    uint32_t                     poolSizeCount;
    const(VkDescriptorPoolSize)* pPoolSizes;
}
struct VkDescriptorSetAllocateInfo {
    VkStructureType               sType;
    const(void)*                  pNext;
    VkDescriptorPool              descriptorPool;
    uint32_t                      descriptorSetCount;
    const(VkDescriptorSetLayout)* pSetLayouts;
}
struct VkDescriptorImageInfo {
    VkSampler     sampler;
    VkImageView   imageView;
    VkImageLayout imageLayout;
}
struct VkDescriptorBufferInfo {
    VkBuffer     buffer;
    VkDeviceSize offset;
    VkDeviceSize range;
}
struct VkWriteDescriptorSet {
    VkStructureType                sType;
    const(void)*                   pNext;
    VkDescriptorSet                dstSet;
    uint32_t                       dstBinding;
    uint32_t                       dstArrayElement;
    uint32_t                       descriptorCount;
    VkDescriptorType               descriptorType;
    const(VkDescriptorImageInfo)*  pImageInfo;
    const(VkDescriptorBufferInfo)* pBufferInfo;
    const(VkBufferView)*           pTexelBufferView;
}
struct VkCopyDescriptorSet {
    VkStructureType sType;
    const(void)*    pNext;
    VkDescriptorSet srcSet;
    uint32_t        srcBinding;
    uint32_t        srcArrayElement;
    VkDescriptorSet dstSet;
    uint32_t        dstBinding;
    uint32_t        dstArrayElement;
    uint32_t        descriptorCount;
}
struct VkFramebufferCreateInfo {
    VkStructureType          sType;
    const(void)*             pNext;
    VkFramebufferCreateFlags flags;
    VkRenderPass             renderPass;
    uint32_t                 attachmentCount;
    const(VkImageView)*      pAttachments;
    uint32_t                 width;
    uint32_t                 height;
    uint32_t                 layers;
}
struct VkAttachmentDescription {
    VkAttachmentDescriptionFlags flags;
    VkFormat                     format;
    VkSampleCountFlagBits        samples;
    VkAttachmentLoadOp           loadOp;
    VkAttachmentStoreOp          storeOp;
    VkAttachmentLoadOp           stencilLoadOp;
    VkAttachmentStoreOp          stencilStoreOp;
    VkImageLayout                initialLayout;
    VkImageLayout                finalLayout;
}
struct VkAttachmentReference {
    uint32_t      attachment;
    VkImageLayout layout;
}
struct VkSubpassDescription {
    VkSubpassDescriptionFlags     flags;
    VkPipelineBindPoint           pipelineBindPoint;
    uint32_t                      inputAttachmentCount;
    const(VkAttachmentReference)* pInputAttachments;
    uint32_t                      colorAttachmentCount;
    const(VkAttachmentReference)* pColorAttachments;
    const(VkAttachmentReference)* pResolveAttachments;
    const(VkAttachmentReference)* pDepthStencilAttachment;
    uint32_t                      preserveAttachmentCount;
    const(uint32_t)*              pPreserveAttachments;
}
struct VkSubpassDependency {
    uint32_t             srcSubpass;
    uint32_t             dstSubpass;
    VkPipelineStageFlags srcStageMask;
    VkPipelineStageFlags dstStageMask;
    VkAccessFlags        srcAccessMask;
    VkAccessFlags        dstAccessMask;
    VkDependencyFlags    dependencyFlags;
}
struct VkRenderPassCreateInfo {
    VkStructureType                 sType;
    const(void)*                    pNext;
    VkRenderPassCreateFlags         flags;
    uint32_t                        attachmentCount;
    const(VkAttachmentDescription)* pAttachments;
    uint32_t                        subpassCount;
    const(VkSubpassDescription)*    pSubpasses;
    uint32_t                        dependencyCount;
    const(VkSubpassDependency)*     pDependencies;
}
struct VkCommandPoolCreateInfo {
    VkStructureType          sType;
    const(void)*             pNext;
    VkCommandPoolCreateFlags flags;
    uint32_t                 queueFamilyIndex;
}
struct VkCommandBufferAllocateInfo {
    VkStructureType      sType;
    const(void)*         pNext;
    VkCommandPool        commandPool;
    VkCommandBufferLevel level;
    uint32_t             commandBufferCount;
}
struct VkCommandBufferInheritanceInfo {
    VkStructureType               sType;
    const(void)*                  pNext;
    VkRenderPass                  renderPass;
    uint32_t                      subpass;
    VkFramebuffer                 framebuffer;
    VkBool32                      occlusionQueryEnable;
    VkQueryControlFlags           queryFlags;
    VkQueryPipelineStatisticFlags pipelineStatistics;
}
struct VkCommandBufferBeginInfo {
    VkStructureType                        sType;
    const(void)*                           pNext;
    VkCommandBufferUsageFlags              flags;
    const(VkCommandBufferInheritanceInfo)* pInheritanceInfo;
}
struct VkBufferCopy {
    VkDeviceSize srcOffset;
    VkDeviceSize dstOffset;
    VkDeviceSize size;
}
struct VkImageSubresourceLayers {
    VkImageAspectFlags aspectMask;
    uint32_t           mipLevel;
    uint32_t           baseArrayLayer;
    uint32_t           layerCount;
}
struct VkImageCopy {
    VkImageSubresourceLayers srcSubresource;
    VkOffset3D               srcOffset;
    VkImageSubresourceLayers dstSubresource;
    VkOffset3D               dstOffset;
    VkExtent3D               extent;
}
struct VkImageBlit {
    VkImageSubresourceLayers srcSubresource;
    VkOffset3D[2]            srcOffsets;
    VkImageSubresourceLayers dstSubresource;
    VkOffset3D[2]            dstOffsets;
}
struct VkBufferImageCopy {
    VkDeviceSize             bufferOffset;
    uint32_t                 bufferRowLength;
    uint32_t                 bufferImageHeight;
    VkImageSubresourceLayers imageSubresource;
    VkOffset3D               imageOffset;
    VkExtent3D               imageExtent;
}
union VkClearColorValue {
    float[4]    float32;
    int32_t[4]  int32;
    uint32_t[4] uint32;
}
struct VkClearDepthStencilValue {
    float    depth;
    uint32_t stencil;
}
union VkClearValue {
    VkClearColorValue        color;
    VkClearDepthStencilValue depthStencil;
}
struct VkClearAttachment {
    VkImageAspectFlags aspectMask;
    uint32_t           colorAttachment;
    VkClearValue       clearValue;
}
struct VkClearRect {
    VkRect2D rect;
    uint32_t baseArrayLayer;
    uint32_t layerCount;
}
struct VkImageResolve {
    VkImageSubresourceLayers srcSubresource;
    VkOffset3D               srcOffset;
    VkImageSubresourceLayers dstSubresource;
    VkOffset3D               dstOffset;
    VkExtent3D               extent;
}
struct VkMemoryBarrier {
    VkStructureType sType;
    const(void)*    pNext;
    VkAccessFlags   srcAccessMask;
    VkAccessFlags   dstAccessMask;
}
struct VkBufferMemoryBarrier {
    VkStructureType sType;
    const(void)*    pNext;
    VkAccessFlags   srcAccessMask;
    VkAccessFlags   dstAccessMask;
    uint32_t        srcQueueFamilyIndex;
    uint32_t        dstQueueFamilyIndex;
    VkBuffer        buffer;
    VkDeviceSize    offset;
    VkDeviceSize    size;
}
struct VkImageMemoryBarrier {
    VkStructureType         sType;
    const(void)*            pNext;
    VkAccessFlags           srcAccessMask;
    VkAccessFlags           dstAccessMask;
    VkImageLayout           oldLayout;
    VkImageLayout           newLayout;
    uint32_t                srcQueueFamilyIndex;
    uint32_t                dstQueueFamilyIndex;
    VkImage                 image;
    VkImageSubresourceRange subresourceRange;
}
struct VkRenderPassBeginInfo {
    VkStructureType      sType;
    const(void)*         pNext;
    VkRenderPass         renderPass;
    VkFramebuffer        framebuffer;
    VkRect2D             renderArea;
    uint32_t             clearValueCount;
    const(VkClearValue)* pClearValues;
}
struct VkDispatchIndirectCommand {
    uint32_t x;
    uint32_t y;
    uint32_t z;
}
struct VkDrawIndexedIndirectCommand {
    uint32_t indexCount;
    uint32_t instanceCount;
    uint32_t firstIndex;
    int32_t  vertexOffset;
    uint32_t firstInstance;
}
struct VkDrawIndirectCommand {
    uint32_t vertexCount;
    uint32_t instanceCount;
    uint32_t firstVertex;
    uint32_t firstInstance;
}
struct VkBaseOutStructure {
    VkStructureType     sType;
    VkBaseOutStructure* pNext;
}
struct VkBaseInStructure {
    VkStructureType           sType;
    const(VkBaseInStructure)* pNext;
}

// VK_VERSION_1_1
struct VkPhysicalDeviceSubgroupProperties {
    VkStructureType        sType;
    void*                  pNext;
    uint32_t               subgroupSize;
    VkShaderStageFlags     supportedStages;
    VkSubgroupFeatureFlags supportedOperations;
    VkBool32               quadOperationsInAllStages;
}
struct VkBindBufferMemoryInfo {
    VkStructureType sType;
    const(void)*    pNext;
    VkBuffer        buffer;
    VkDeviceMemory  memory;
    VkDeviceSize    memoryOffset;
}
struct VkBindImageMemoryInfo {
    VkStructureType sType;
    const(void)*    pNext;
    VkImage         image;
    VkDeviceMemory  memory;
    VkDeviceSize    memoryOffset;
}
struct VkPhysicalDevice16BitStorageFeatures {
    VkStructureType sType;
    void*           pNext;
    VkBool32        storageBuffer16BitAccess;
    VkBool32        uniformAndStorageBuffer16BitAccess;
    VkBool32        storagePushConstant16;
    VkBool32        storageInputOutput16;
}
struct VkMemoryDedicatedRequirements {
    VkStructureType sType;
    void*           pNext;
    VkBool32        prefersDedicatedAllocation;
    VkBool32        requiresDedicatedAllocation;
}
struct VkMemoryDedicatedAllocateInfo {
    VkStructureType sType;
    const(void)*    pNext;
    VkImage         image;
    VkBuffer        buffer;
}
struct VkMemoryAllocateFlagsInfo {
    VkStructureType       sType;
    const(void)*          pNext;
    VkMemoryAllocateFlags flags;
    uint32_t              deviceMask;
}
struct VkDeviceGroupRenderPassBeginInfo {
    VkStructureType  sType;
    const(void)*     pNext;
    uint32_t         deviceMask;
    uint32_t         deviceRenderAreaCount;
    const(VkRect2D)* pDeviceRenderAreas;
}
struct VkDeviceGroupCommandBufferBeginInfo {
    VkStructureType sType;
    const(void)*    pNext;
    uint32_t        deviceMask;
}
struct VkDeviceGroupSubmitInfo {
    VkStructureType  sType;
    const(void)*     pNext;
    uint32_t         waitSemaphoreCount;
    const(uint32_t)* pWaitSemaphoreDeviceIndices;
    uint32_t         commandBufferCount;
    const(uint32_t)* pCommandBufferDeviceMasks;
    uint32_t         signalSemaphoreCount;
    const(uint32_t)* pSignalSemaphoreDeviceIndices;
}
struct VkDeviceGroupBindSparseInfo {
    VkStructureType sType;
    const(void)*    pNext;
    uint32_t        resourceDeviceIndex;
    uint32_t        memoryDeviceIndex;
}
struct VkBindBufferMemoryDeviceGroupInfo {
    VkStructureType  sType;
    const(void)*     pNext;
    uint32_t         deviceIndexCount;
    const(uint32_t)* pDeviceIndices;
}
struct VkBindImageMemoryDeviceGroupInfo {
    VkStructureType  sType;
    const(void)*     pNext;
    uint32_t         deviceIndexCount;
    const(uint32_t)* pDeviceIndices;
    uint32_t         splitInstanceBindRegionCount;
    const(VkRect2D)* pSplitInstanceBindRegions;
}
struct VkPhysicalDeviceGroupProperties {
    VkStructureType                            sType;
    void*                                      pNext;
    uint32_t                                   physicalDeviceCount;
    VkPhysicalDevice[VK_MAX_DEVICE_GROUP_SIZE] physicalDevices;
    VkBool32                                   subsetAllocation;
}
struct VkDeviceGroupDeviceCreateInfo {
    VkStructureType          sType;
    const(void)*             pNext;
    uint32_t                 physicalDeviceCount;
    const(VkPhysicalDevice)* pPhysicalDevices;
}
struct VkBufferMemoryRequirementsInfo2 {
    VkStructureType sType;
    const(void)*    pNext;
    VkBuffer        buffer;
}
struct VkImageMemoryRequirementsInfo2 {
    VkStructureType sType;
    const(void)*    pNext;
    VkImage         image;
}
struct VkImageSparseMemoryRequirementsInfo2 {
    VkStructureType sType;
    const(void)*    pNext;
    VkImage         image;
}
struct VkMemoryRequirements2 {
    VkStructureType      sType;
    void*                pNext;
    VkMemoryRequirements memoryRequirements;
}
struct VkSparseImageMemoryRequirements2 {
    VkStructureType                 sType;
    void*                           pNext;
    VkSparseImageMemoryRequirements memoryRequirements;
}
struct VkPhysicalDeviceFeatures2 {
    VkStructureType          sType;
    void*                    pNext;
    VkPhysicalDeviceFeatures features;
}
struct VkPhysicalDeviceProperties2 {
    VkStructureType            sType;
    void*                      pNext;
    VkPhysicalDeviceProperties properties;
}
struct VkFormatProperties2 {
    VkStructureType    sType;
    void*              pNext;
    VkFormatProperties formatProperties;
}
struct VkImageFormatProperties2 {
    VkStructureType         sType;
    void*                   pNext;
    VkImageFormatProperties imageFormatProperties;
}
struct VkPhysicalDeviceImageFormatInfo2 {
    VkStructureType    sType;
    const(void)*       pNext;
    VkFormat           format;
    VkImageType        type;
    VkImageTiling      tiling;
    VkImageUsageFlags  usage;
    VkImageCreateFlags flags;
}
struct VkQueueFamilyProperties2 {
    VkStructureType         sType;
    void*                   pNext;
    VkQueueFamilyProperties queueFamilyProperties;
}
struct VkPhysicalDeviceMemoryProperties2 {
    VkStructureType                  sType;
    void*                            pNext;
    VkPhysicalDeviceMemoryProperties memoryProperties;
}
struct VkSparseImageFormatProperties2 {
    VkStructureType               sType;
    void*                         pNext;
    VkSparseImageFormatProperties properties;
}
struct VkPhysicalDeviceSparseImageFormatInfo2 {
    VkStructureType       sType;
    const(void)*          pNext;
    VkFormat              format;
    VkImageType           type;
    VkSampleCountFlagBits samples;
    VkImageUsageFlags     usage;
    VkImageTiling         tiling;
}
struct VkPhysicalDevicePointClippingProperties {
    VkStructureType         sType;
    void*                   pNext;
    VkPointClippingBehavior pointClippingBehavior;
}
struct VkInputAttachmentAspectReference {
    uint32_t           subpass;
    uint32_t           inputAttachmentIndex;
    VkImageAspectFlags aspectMask;
}
struct VkRenderPassInputAttachmentAspectCreateInfo {
    VkStructureType                          sType;
    const(void)*                             pNext;
    uint32_t                                 aspectReferenceCount;
    const(VkInputAttachmentAspectReference)* pAspectReferences;
}
struct VkImageViewUsageCreateInfo {
    VkStructureType   sType;
    const(void)*      pNext;
    VkImageUsageFlags usage;
}
struct VkPipelineTessellationDomainOriginStateCreateInfo {
    VkStructureType            sType;
    const(void)*               pNext;
    VkTessellationDomainOrigin domainOrigin;
}
struct VkRenderPassMultiviewCreateInfo {
    VkStructureType  sType;
    const(void)*     pNext;
    uint32_t         subpassCount;
    const(uint32_t)* pViewMasks;
    uint32_t         dependencyCount;
    const(int32_t)*  pViewOffsets;
    uint32_t         correlationMaskCount;
    const(uint32_t)* pCorrelationMasks;
}
struct VkPhysicalDeviceMultiviewFeatures {
    VkStructureType sType;
    void*           pNext;
    VkBool32        multiview;
    VkBool32        multiviewGeometryShader;
    VkBool32        multiviewTessellationShader;
}
struct VkPhysicalDeviceMultiviewProperties {
    VkStructureType sType;
    void*           pNext;
    uint32_t        maxMultiviewViewCount;
    uint32_t        maxMultiviewInstanceIndex;
}
struct VkPhysicalDeviceVariablePointerFeatures {
    VkStructureType sType;
    void*           pNext;
    VkBool32        variablePointersStorageBuffer;
    VkBool32        variablePointers;
}
struct VkPhysicalDeviceProtectedMemoryFeatures {
    VkStructureType sType;
    void*           pNext;
    VkBool32        protectedMemory;
}
struct VkPhysicalDeviceProtectedMemoryProperties {
    VkStructureType sType;
    void*           pNext;
    VkBool32        protectedNoFault;
}
struct VkDeviceQueueInfo2 {
    VkStructureType          sType;
    const(void)*             pNext;
    VkDeviceQueueCreateFlags flags;
    uint32_t                 queueFamilyIndex;
    uint32_t                 queueIndex;
}
struct VkProtectedSubmitInfo {
    VkStructureType sType;
    const(void)*    pNext;
    VkBool32        protectedSubmit;
}
struct VkSamplerYcbcrConversionCreateInfo {
    VkStructureType               sType;
    const(void)*                  pNext;
    VkFormat                      format;
    VkSamplerYcbcrModelConversion ycbcrModel;
    VkSamplerYcbcrRange           ycbcrRange;
    VkComponentMapping            components;
    VkChromaLocation              xChromaOffset;
    VkChromaLocation              yChromaOffset;
    VkFilter                      chromaFilter;
    VkBool32                      forceExplicitReconstruction;
}
struct VkSamplerYcbcrConversionInfo {
    VkStructureType          sType;
    const(void)*             pNext;
    VkSamplerYcbcrConversion conversion;
}
struct VkBindImagePlaneMemoryInfo {
    VkStructureType       sType;
    const(void)*          pNext;
    VkImageAspectFlagBits planeAspect;
}
struct VkImagePlaneMemoryRequirementsInfo {
    VkStructureType       sType;
    const(void)*          pNext;
    VkImageAspectFlagBits planeAspect;
}
struct VkPhysicalDeviceSamplerYcbcrConversionFeatures {
    VkStructureType sType;
    void*           pNext;
    VkBool32        samplerYcbcrConversion;
}
struct VkSamplerYcbcrConversionImageFormatProperties {
    VkStructureType sType;
    void*           pNext;
    uint32_t        combinedImageSamplerDescriptorCount;
}
struct VkDescriptorUpdateTemplateEntry {
    uint32_t         dstBinding;
    uint32_t         dstArrayElement;
    uint32_t         descriptorCount;
    VkDescriptorType descriptorType;
    size_t           offset;
    size_t           stride;
}
struct VkDescriptorUpdateTemplateCreateInfo {
    VkStructureType                         sType;
    const(void)*                            pNext;
    VkDescriptorUpdateTemplateCreateFlags   flags;
    uint32_t                                descriptorUpdateEntryCount;
    const(VkDescriptorUpdateTemplateEntry)* pDescriptorUpdateEntries;
    VkDescriptorUpdateTemplateType          templateType;
    VkDescriptorSetLayout                   descriptorSetLayout;
    VkPipelineBindPoint                     pipelineBindPoint;
    VkPipelineLayout                        pipelineLayout;
    uint32_t                                set;
}
struct VkExternalMemoryProperties {
    VkExternalMemoryFeatureFlags    externalMemoryFeatures;
    VkExternalMemoryHandleTypeFlags exportFromImportedHandleTypes;
    VkExternalMemoryHandleTypeFlags compatibleHandleTypes;
}
struct VkPhysicalDeviceExternalImageFormatInfo {
    VkStructureType                    sType;
    const(void)*                       pNext;
    VkExternalMemoryHandleTypeFlagBits handleType;
}
struct VkExternalImageFormatProperties {
    VkStructureType            sType;
    void*                      pNext;
    VkExternalMemoryProperties externalMemoryProperties;
}
struct VkPhysicalDeviceExternalBufferInfo {
    VkStructureType                    sType;
    const(void)*                       pNext;
    VkBufferCreateFlags                flags;
    VkBufferUsageFlags                 usage;
    VkExternalMemoryHandleTypeFlagBits handleType;
}
struct VkExternalBufferProperties {
    VkStructureType            sType;
    void*                      pNext;
    VkExternalMemoryProperties externalMemoryProperties;
}
struct VkPhysicalDeviceIDProperties {
    VkStructureType       sType;
    void*                 pNext;
    uint8_t[VK_UUID_SIZE] deviceUUID;
    uint8_t[VK_UUID_SIZE] driverUUID;
    uint8_t[VK_LUID_SIZE] deviceLUID;
    uint32_t              deviceNodeMask;
    VkBool32              deviceLUIDValid;
}
struct VkExternalMemoryImageCreateInfo {
    VkStructureType                 sType;
    const(void)*                    pNext;
    VkExternalMemoryHandleTypeFlags handleTypes;
}
struct VkExternalMemoryBufferCreateInfo {
    VkStructureType                 sType;
    const(void)*                    pNext;
    VkExternalMemoryHandleTypeFlags handleTypes;
}
struct VkExportMemoryAllocateInfo {
    VkStructureType                 sType;
    const(void)*                    pNext;
    VkExternalMemoryHandleTypeFlags handleTypes;
}
struct VkPhysicalDeviceExternalFenceInfo {
    VkStructureType                   sType;
    const(void)*                      pNext;
    VkExternalFenceHandleTypeFlagBits handleType;
}
struct VkExternalFenceProperties {
    VkStructureType                sType;
    void*                          pNext;
    VkExternalFenceHandleTypeFlags exportFromImportedHandleTypes;
    VkExternalFenceHandleTypeFlags compatibleHandleTypes;
    VkExternalFenceFeatureFlags    externalFenceFeatures;
}
struct VkExportFenceCreateInfo {
    VkStructureType                sType;
    const(void)*                   pNext;
    VkExternalFenceHandleTypeFlags handleTypes;
}
struct VkExportSemaphoreCreateInfo {
    VkStructureType                    sType;
    const(void)*                       pNext;
    VkExternalSemaphoreHandleTypeFlags handleTypes;
}
struct VkPhysicalDeviceExternalSemaphoreInfo {
    VkStructureType                       sType;
    const(void)*                          pNext;
    VkExternalSemaphoreHandleTypeFlagBits handleType;
}
struct VkExternalSemaphoreProperties {
    VkStructureType                    sType;
    void*                              pNext;
    VkExternalSemaphoreHandleTypeFlags exportFromImportedHandleTypes;
    VkExternalSemaphoreHandleTypeFlags compatibleHandleTypes;
    VkExternalSemaphoreFeatureFlags    externalSemaphoreFeatures;
}
struct VkPhysicalDeviceMaintenance3Properties {
    VkStructureType sType;
    void*           pNext;
    uint32_t        maxPerSetDescriptors;
    VkDeviceSize    maxMemoryAllocationSize;
}
struct VkDescriptorSetLayoutSupport {
    VkStructureType sType;
    void*           pNext;
    VkBool32        supported;
}
struct VkPhysicalDeviceShaderDrawParameterFeatures {
    VkStructureType sType;
    void*           pNext;
    VkBool32        shaderDrawParameters;
}

// VK_KHR_surface
struct VkSurfaceCapabilitiesKHR {
    uint32_t                      minImageCount;
    uint32_t                      maxImageCount;
    VkExtent2D                    currentExtent;
    VkExtent2D                    minImageExtent;
    VkExtent2D                    maxImageExtent;
    uint32_t                      maxImageArrayLayers;
    VkSurfaceTransformFlagsKHR    supportedTransforms;
    VkSurfaceTransformFlagBitsKHR currentTransform;
    VkCompositeAlphaFlagsKHR      supportedCompositeAlpha;
    VkImageUsageFlags             supportedUsageFlags;
}
struct VkSurfaceFormatKHR {
    VkFormat        format;
    VkColorSpaceKHR colorSpace;
}

// VK_KHR_swapchain
struct VkSwapchainCreateInfoKHR {
    VkStructureType               sType;
    const(void)*                  pNext;
    VkSwapchainCreateFlagsKHR     flags;
    VkSurfaceKHR                  surface;
    uint32_t                      minImageCount;
    VkFormat                      imageFormat;
    VkColorSpaceKHR               imageColorSpace;
    VkExtent2D                    imageExtent;
    uint32_t                      imageArrayLayers;
    VkImageUsageFlags             imageUsage;
    VkSharingMode                 imageSharingMode;
    uint32_t                      queueFamilyIndexCount;
    const(uint32_t)*              pQueueFamilyIndices;
    VkSurfaceTransformFlagBitsKHR preTransform;
    VkCompositeAlphaFlagBitsKHR   compositeAlpha;
    VkPresentModeKHR              presentMode;
    VkBool32                      clipped;
    VkSwapchainKHR                oldSwapchain;
}
struct VkPresentInfoKHR {
    VkStructureType        sType;
    const(void)*           pNext;
    uint32_t               waitSemaphoreCount;
    const(VkSemaphore)*    pWaitSemaphores;
    uint32_t               swapchainCount;
    const(VkSwapchainKHR)* pSwapchains;
    const(uint32_t)*       pImageIndices;
    VkResult*              pResults;
}
struct VkImageSwapchainCreateInfoKHR {
    VkStructureType sType;
    const(void)*    pNext;
    VkSwapchainKHR  swapchain;
}
struct VkBindImageMemorySwapchainInfoKHR {
    VkStructureType sType;
    const(void)*    pNext;
    VkSwapchainKHR  swapchain;
    uint32_t        imageIndex;
}
struct VkAcquireNextImageInfoKHR {
    VkStructureType sType;
    const(void)*    pNext;
    VkSwapchainKHR  swapchain;
    uint64_t        timeout;
    VkSemaphore     semaphore;
    VkFence         fence;
    uint32_t        deviceMask;
}
struct VkDeviceGroupPresentCapabilitiesKHR {
    VkStructureType                    sType;
    const(void)*                       pNext;
    uint32_t[VK_MAX_DEVICE_GROUP_SIZE] presentMask;
    VkDeviceGroupPresentModeFlagsKHR   modes;
}
struct VkDeviceGroupPresentInfoKHR {
    VkStructureType                     sType;
    const(void)*                        pNext;
    uint32_t                            swapchainCount;
    const(uint32_t)*                    pDeviceMasks;
    VkDeviceGroupPresentModeFlagBitsKHR mode;
}
struct VkDeviceGroupSwapchainCreateInfoKHR {
    VkStructureType                  sType;
    const(void)*                     pNext;
    VkDeviceGroupPresentModeFlagsKHR modes;
}

// VK_KHR_display
struct VkDisplayPropertiesKHR {
    VkDisplayKHR               display;
    const(char)*               displayName;
    VkExtent2D                 physicalDimensions;
    VkExtent2D                 physicalResolution;
    VkSurfaceTransformFlagsKHR supportedTransforms;
    VkBool32                   planeReorderPossible;
    VkBool32                   persistentContent;
}
struct VkDisplayModeParametersKHR {
    VkExtent2D visibleRegion;
    uint32_t   refreshRate;
}
struct VkDisplayModePropertiesKHR {
    VkDisplayModeKHR           displayMode;
    VkDisplayModeParametersKHR parameters;
}
struct VkDisplayModeCreateInfoKHR {
    VkStructureType             sType;
    const(void)*                pNext;
    VkDisplayModeCreateFlagsKHR flags;
    VkDisplayModeParametersKHR  parameters;
}
struct VkDisplayPlaneCapabilitiesKHR {
    VkDisplayPlaneAlphaFlagsKHR supportedAlpha;
    VkOffset2D                  minSrcPosition;
    VkOffset2D                  maxSrcPosition;
    VkExtent2D                  minSrcExtent;
    VkExtent2D                  maxSrcExtent;
    VkOffset2D                  minDstPosition;
    VkOffset2D                  maxDstPosition;
    VkExtent2D                  minDstExtent;
    VkExtent2D                  maxDstExtent;
}
struct VkDisplayPlanePropertiesKHR {
    VkDisplayKHR currentDisplay;
    uint32_t     currentStackIndex;
}
struct VkDisplaySurfaceCreateInfoKHR {
    VkStructureType                sType;
    const(void)*                   pNext;
    VkDisplaySurfaceCreateFlagsKHR flags;
    VkDisplayModeKHR               displayMode;
    uint32_t                       planeIndex;
    uint32_t                       planeStackIndex;
    VkSurfaceTransformFlagBitsKHR  transform;
    float                          globalAlpha;
    VkDisplayPlaneAlphaFlagBitsKHR alphaMode;
    VkExtent2D                     imageExtent;
}

// VK_KHR_xcb_surface
version(linux) {
    struct VkXcbSurfaceCreateInfoKHR {
        VkStructureType            sType;
        const(void)*               pNext;
        VkXcbSurfaceCreateFlagsKHR flags;
        xcb_connection_t*          connection;
        xcb_window_t               window;
    }
}

// VK_KHR_wayland_surface
version(linux) {
    struct VkWaylandSurfaceCreateInfoKHR {
        VkStructureType                sType;
        const(void)*                   pNext;
        VkWaylandSurfaceCreateFlagsKHR flags;
        wl_display*                    display;
        wl_surface*                    surface;
    }
}

// VK_KHR_win32_surface
version(Windows) {
    struct VkWin32SurfaceCreateInfoKHR {
        VkStructureType              sType;
        const(void)*                 pNext;
        VkWin32SurfaceCreateFlagsKHR flags;
        HINSTANCE                    hinstance;
        HWND                         hwnd;
    }
}

// VK_EXT_debug_report
struct VkDebugReportCallbackCreateInfoEXT {
    VkStructureType              sType;
    const(void)*                 pNext;
    VkDebugReportFlagsEXT        flags;
    PFN_vkDebugReportCallbackEXT pfnCallback;
    void*                        pUserData;
}

// Command pointer aliases

extern(C) nothrow @nogc {
    // VK_VERSION_1_0
    alias PFN_vkCreateInstance = VkResult function (
        const(VkInstanceCreateInfo)*  pCreateInfo,
        const(VkAllocationCallbacks)* pAllocator,
        VkInstance*                   pInstance,
    );
    alias PFN_vkDestroyInstance = void function (
        VkInstance                    instance,
        const(VkAllocationCallbacks)* pAllocator,
    );
    alias PFN_vkEnumeratePhysicalDevices = VkResult function (
        VkInstance        instance,
        uint32_t*         pPhysicalDeviceCount,
        VkPhysicalDevice* pPhysicalDevices,
    );
    alias PFN_vkGetPhysicalDeviceFeatures = void function (
        VkPhysicalDevice          physicalDevice,
        VkPhysicalDeviceFeatures* pFeatures,
    );
    alias PFN_vkGetPhysicalDeviceFormatProperties = void function (
        VkPhysicalDevice    physicalDevice,
        VkFormat            format,
        VkFormatProperties* pFormatProperties,
    );
    alias PFN_vkGetPhysicalDeviceImageFormatProperties = VkResult function (
        VkPhysicalDevice         physicalDevice,
        VkFormat                 format,
        VkImageType              type,
        VkImageTiling            tiling,
        VkImageUsageFlags        usage,
        VkImageCreateFlags       flags,
        VkImageFormatProperties* pImageFormatProperties,
    );
    alias PFN_vkGetPhysicalDeviceProperties = void function (
        VkPhysicalDevice            physicalDevice,
        VkPhysicalDeviceProperties* pProperties,
    );
    alias PFN_vkGetPhysicalDeviceQueueFamilyProperties = void function (
        VkPhysicalDevice         physicalDevice,
        uint32_t*                pQueueFamilyPropertyCount,
        VkQueueFamilyProperties* pQueueFamilyProperties,
    );
    alias PFN_vkGetPhysicalDeviceMemoryProperties = void function (
        VkPhysicalDevice                  physicalDevice,
        VkPhysicalDeviceMemoryProperties* pMemoryProperties,
    );
    alias PFN_vkGetInstanceProcAddr = PFN_vkVoidFunction function (
        VkInstance   instance,
        const(char)* pName,
    );
    alias PFN_vkGetDeviceProcAddr = PFN_vkVoidFunction function (
        VkDevice     device,
        const(char)* pName,
    );
    alias PFN_vkCreateDevice = VkResult function (
        VkPhysicalDevice              physicalDevice,
        const(VkDeviceCreateInfo)*    pCreateInfo,
        const(VkAllocationCallbacks)* pAllocator,
        VkDevice*                     pDevice,
    );
    alias PFN_vkDestroyDevice = void function (
        VkDevice                      device,
        const(VkAllocationCallbacks)* pAllocator,
    );
    alias PFN_vkEnumerateInstanceExtensionProperties = VkResult function (
        const(char)*           pLayerName,
        uint32_t*              pPropertyCount,
        VkExtensionProperties* pProperties,
    );
    alias PFN_vkEnumerateDeviceExtensionProperties = VkResult function (
        VkPhysicalDevice       physicalDevice,
        const(char)*           pLayerName,
        uint32_t*              pPropertyCount,
        VkExtensionProperties* pProperties,
    );
    alias PFN_vkEnumerateInstanceLayerProperties = VkResult function (
        uint32_t*          pPropertyCount,
        VkLayerProperties* pProperties,
    );
    alias PFN_vkEnumerateDeviceLayerProperties = VkResult function (
        VkPhysicalDevice   physicalDevice,
        uint32_t*          pPropertyCount,
        VkLayerProperties* pProperties,
    );
    alias PFN_vkGetDeviceQueue = void function (
        VkDevice device,
        uint32_t queueFamilyIndex,
        uint32_t queueIndex,
        VkQueue* pQueue,
    );
    alias PFN_vkQueueSubmit = VkResult function (
        VkQueue              queue,
        uint32_t             submitCount,
        const(VkSubmitInfo)* pSubmits,
        VkFence              fence,
    );
    alias PFN_vkQueueWaitIdle = VkResult function (
        VkQueue queue,
    );
    alias PFN_vkDeviceWaitIdle = VkResult function (
        VkDevice device,
    );
    alias PFN_vkAllocateMemory = VkResult function (
        VkDevice                      device,
        const(VkMemoryAllocateInfo)*  pAllocateInfo,
        const(VkAllocationCallbacks)* pAllocator,
        VkDeviceMemory*               pMemory,
    );
    alias PFN_vkFreeMemory = void function (
        VkDevice                      device,
        VkDeviceMemory                memory,
        const(VkAllocationCallbacks)* pAllocator,
    );
    alias PFN_vkMapMemory = VkResult function (
        VkDevice         device,
        VkDeviceMemory   memory,
        VkDeviceSize     offset,
        VkDeviceSize     size,
        VkMemoryMapFlags flags,
        void**           ppData,
    );
    alias PFN_vkUnmapMemory = void function (
        VkDevice       device,
        VkDeviceMemory memory,
    );
    alias PFN_vkFlushMappedMemoryRanges = VkResult function (
        VkDevice                    device,
        uint32_t                    memoryRangeCount,
        const(VkMappedMemoryRange)* pMemoryRanges,
    );
    alias PFN_vkInvalidateMappedMemoryRanges = VkResult function (
        VkDevice                    device,
        uint32_t                    memoryRangeCount,
        const(VkMappedMemoryRange)* pMemoryRanges,
    );
    alias PFN_vkGetDeviceMemoryCommitment = void function (
        VkDevice       device,
        VkDeviceMemory memory,
        VkDeviceSize*  pCommittedMemoryInBytes,
    );
    alias PFN_vkBindBufferMemory = VkResult function (
        VkDevice       device,
        VkBuffer       buffer,
        VkDeviceMemory memory,
        VkDeviceSize   memoryOffset,
    );
    alias PFN_vkBindImageMemory = VkResult function (
        VkDevice       device,
        VkImage        image,
        VkDeviceMemory memory,
        VkDeviceSize   memoryOffset,
    );
    alias PFN_vkGetBufferMemoryRequirements = void function (
        VkDevice              device,
        VkBuffer              buffer,
        VkMemoryRequirements* pMemoryRequirements,
    );
    alias PFN_vkGetImageMemoryRequirements = void function (
        VkDevice              device,
        VkImage               image,
        VkMemoryRequirements* pMemoryRequirements,
    );
    alias PFN_vkGetImageSparseMemoryRequirements = void function (
        VkDevice                         device,
        VkImage                          image,
        uint32_t*                        pSparseMemoryRequirementCount,
        VkSparseImageMemoryRequirements* pSparseMemoryRequirements,
    );
    alias PFN_vkGetPhysicalDeviceSparseImageFormatProperties = void function (
        VkPhysicalDevice               physicalDevice,
        VkFormat                       format,
        VkImageType                    type,
        VkSampleCountFlagBits          samples,
        VkImageUsageFlags              usage,
        VkImageTiling                  tiling,
        uint32_t*                      pPropertyCount,
        VkSparseImageFormatProperties* pProperties,
    );
    alias PFN_vkQueueBindSparse = VkResult function (
        VkQueue                  queue,
        uint32_t                 bindInfoCount,
        const(VkBindSparseInfo)* pBindInfo,
        VkFence                  fence,
    );
    alias PFN_vkCreateFence = VkResult function (
        VkDevice                      device,
        const(VkFenceCreateInfo)*     pCreateInfo,
        const(VkAllocationCallbacks)* pAllocator,
        VkFence*                      pFence,
    );
    alias PFN_vkDestroyFence = void function (
        VkDevice                      device,
        VkFence                       fence,
        const(VkAllocationCallbacks)* pAllocator,
    );
    alias PFN_vkResetFences = VkResult function (
        VkDevice        device,
        uint32_t        fenceCount,
        const(VkFence)* pFences,
    );
    alias PFN_vkGetFenceStatus = VkResult function (
        VkDevice device,
        VkFence  fence,
    );
    alias PFN_vkWaitForFences = VkResult function (
        VkDevice        device,
        uint32_t        fenceCount,
        const(VkFence)* pFences,
        VkBool32        waitAll,
        uint64_t        timeout,
    );
    alias PFN_vkCreateSemaphore = VkResult function (
        VkDevice                      device,
        const(VkSemaphoreCreateInfo)* pCreateInfo,
        const(VkAllocationCallbacks)* pAllocator,
        VkSemaphore*                  pSemaphore,
    );
    alias PFN_vkDestroySemaphore = void function (
        VkDevice                      device,
        VkSemaphore                   semaphore,
        const(VkAllocationCallbacks)* pAllocator,
    );
    alias PFN_vkCreateEvent = VkResult function (
        VkDevice                      device,
        const(VkEventCreateInfo)*     pCreateInfo,
        const(VkAllocationCallbacks)* pAllocator,
        VkEvent*                      pEvent,
    );
    alias PFN_vkDestroyEvent = void function (
        VkDevice                      device,
        VkEvent                       event,
        const(VkAllocationCallbacks)* pAllocator,
    );
    alias PFN_vkGetEventStatus = VkResult function (
        VkDevice device,
        VkEvent  event,
    );
    alias PFN_vkSetEvent = VkResult function (
        VkDevice device,
        VkEvent  event,
    );
    alias PFN_vkResetEvent = VkResult function (
        VkDevice device,
        VkEvent  event,
    );
    alias PFN_vkCreateQueryPool = VkResult function (
        VkDevice                      device,
        const(VkQueryPoolCreateInfo)* pCreateInfo,
        const(VkAllocationCallbacks)* pAllocator,
        VkQueryPool*                  pQueryPool,
    );
    alias PFN_vkDestroyQueryPool = void function (
        VkDevice                      device,
        VkQueryPool                   queryPool,
        const(VkAllocationCallbacks)* pAllocator,
    );
    alias PFN_vkGetQueryPoolResults = VkResult function (
        VkDevice           device,
        VkQueryPool        queryPool,
        uint32_t           firstQuery,
        uint32_t           queryCount,
        size_t             dataSize,
        void*              pData,
        VkDeviceSize       stride,
        VkQueryResultFlags flags,
    );
    alias PFN_vkCreateBuffer = VkResult function (
        VkDevice                      device,
        const(VkBufferCreateInfo)*    pCreateInfo,
        const(VkAllocationCallbacks)* pAllocator,
        VkBuffer*                     pBuffer,
    );
    alias PFN_vkDestroyBuffer = void function (
        VkDevice                      device,
        VkBuffer                      buffer,
        const(VkAllocationCallbacks)* pAllocator,
    );
    alias PFN_vkCreateBufferView = VkResult function (
        VkDevice                       device,
        const(VkBufferViewCreateInfo)* pCreateInfo,
        const(VkAllocationCallbacks)*  pAllocator,
        VkBufferView*                  pView,
    );
    alias PFN_vkDestroyBufferView = void function (
        VkDevice                      device,
        VkBufferView                  bufferView,
        const(VkAllocationCallbacks)* pAllocator,
    );
    alias PFN_vkCreateImage = VkResult function (
        VkDevice                      device,
        const(VkImageCreateInfo)*     pCreateInfo,
        const(VkAllocationCallbacks)* pAllocator,
        VkImage*                      pImage,
    );
    alias PFN_vkDestroyImage = void function (
        VkDevice                      device,
        VkImage                       image,
        const(VkAllocationCallbacks)* pAllocator,
    );
    alias PFN_vkGetImageSubresourceLayout = void function (
        VkDevice                   device,
        VkImage                    image,
        const(VkImageSubresource)* pSubresource,
        VkSubresourceLayout*       pLayout,
    );
    alias PFN_vkCreateImageView = VkResult function (
        VkDevice                      device,
        const(VkImageViewCreateInfo)* pCreateInfo,
        const(VkAllocationCallbacks)* pAllocator,
        VkImageView*                  pView,
    );
    alias PFN_vkDestroyImageView = void function (
        VkDevice                      device,
        VkImageView                   imageView,
        const(VkAllocationCallbacks)* pAllocator,
    );
    alias PFN_vkCreateShaderModule = VkResult function (
        VkDevice                         device,
        const(VkShaderModuleCreateInfo)* pCreateInfo,
        const(VkAllocationCallbacks)*    pAllocator,
        VkShaderModule*                  pShaderModule,
    );
    alias PFN_vkDestroyShaderModule = void function (
        VkDevice                      device,
        VkShaderModule                shaderModule,
        const(VkAllocationCallbacks)* pAllocator,
    );
    alias PFN_vkCreatePipelineCache = VkResult function (
        VkDevice                          device,
        const(VkPipelineCacheCreateInfo)* pCreateInfo,
        const(VkAllocationCallbacks)*     pAllocator,
        VkPipelineCache*                  pPipelineCache,
    );
    alias PFN_vkDestroyPipelineCache = void function (
        VkDevice                      device,
        VkPipelineCache               pipelineCache,
        const(VkAllocationCallbacks)* pAllocator,
    );
    alias PFN_vkGetPipelineCacheData = VkResult function (
        VkDevice        device,
        VkPipelineCache pipelineCache,
        size_t*         pDataSize,
        void*           pData,
    );
    alias PFN_vkMergePipelineCaches = VkResult function (
        VkDevice                device,
        VkPipelineCache         dstCache,
        uint32_t                srcCacheCount,
        const(VkPipelineCache)* pSrcCaches,
    );
    alias PFN_vkCreateGraphicsPipelines = VkResult function (
        VkDevice                             device,
        VkPipelineCache                      pipelineCache,
        uint32_t                             createInfoCount,
        const(VkGraphicsPipelineCreateInfo)* pCreateInfos,
        const(VkAllocationCallbacks)*        pAllocator,
        VkPipeline*                          pPipelines,
    );
    alias PFN_vkCreateComputePipelines = VkResult function (
        VkDevice                            device,
        VkPipelineCache                     pipelineCache,
        uint32_t                            createInfoCount,
        const(VkComputePipelineCreateInfo)* pCreateInfos,
        const(VkAllocationCallbacks)*       pAllocator,
        VkPipeline*                         pPipelines,
    );
    alias PFN_vkDestroyPipeline = void function (
        VkDevice                      device,
        VkPipeline                    pipeline,
        const(VkAllocationCallbacks)* pAllocator,
    );
    alias PFN_vkCreatePipelineLayout = VkResult function (
        VkDevice                           device,
        const(VkPipelineLayoutCreateInfo)* pCreateInfo,
        const(VkAllocationCallbacks)*      pAllocator,
        VkPipelineLayout*                  pPipelineLayout,
    );
    alias PFN_vkDestroyPipelineLayout = void function (
        VkDevice                      device,
        VkPipelineLayout              pipelineLayout,
        const(VkAllocationCallbacks)* pAllocator,
    );
    alias PFN_vkCreateSampler = VkResult function (
        VkDevice                      device,
        const(VkSamplerCreateInfo)*   pCreateInfo,
        const(VkAllocationCallbacks)* pAllocator,
        VkSampler*                    pSampler,
    );
    alias PFN_vkDestroySampler = void function (
        VkDevice                      device,
        VkSampler                     sampler,
        const(VkAllocationCallbacks)* pAllocator,
    );
    alias PFN_vkCreateDescriptorSetLayout = VkResult function (
        VkDevice                                device,
        const(VkDescriptorSetLayoutCreateInfo)* pCreateInfo,
        const(VkAllocationCallbacks)*           pAllocator,
        VkDescriptorSetLayout*                  pSetLayout,
    );
    alias PFN_vkDestroyDescriptorSetLayout = void function (
        VkDevice                      device,
        VkDescriptorSetLayout         descriptorSetLayout,
        const(VkAllocationCallbacks)* pAllocator,
    );
    alias PFN_vkCreateDescriptorPool = VkResult function (
        VkDevice                           device,
        const(VkDescriptorPoolCreateInfo)* pCreateInfo,
        const(VkAllocationCallbacks)*      pAllocator,
        VkDescriptorPool*                  pDescriptorPool,
    );
    alias PFN_vkDestroyDescriptorPool = void function (
        VkDevice                      device,
        VkDescriptorPool              descriptorPool,
        const(VkAllocationCallbacks)* pAllocator,
    );
    alias PFN_vkResetDescriptorPool = VkResult function (
        VkDevice                   device,
        VkDescriptorPool           descriptorPool,
        VkDescriptorPoolResetFlags flags,
    );
    alias PFN_vkAllocateDescriptorSets = VkResult function (
        VkDevice                            device,
        const(VkDescriptorSetAllocateInfo)* pAllocateInfo,
        VkDescriptorSet*                    pDescriptorSets,
    );
    alias PFN_vkFreeDescriptorSets = VkResult function (
        VkDevice                device,
        VkDescriptorPool        descriptorPool,
        uint32_t                descriptorSetCount,
        const(VkDescriptorSet)* pDescriptorSets,
    );
    alias PFN_vkUpdateDescriptorSets = void function (
        VkDevice                     device,
        uint32_t                     descriptorWriteCount,
        const(VkWriteDescriptorSet)* pDescriptorWrite,
        uint32_t                     descriptorCopyCount,
        const(VkCopyDescriptorSet)*  pDescriptorCopies,
    );
    alias PFN_vkCreateFramebuffer = VkResult function (
        VkDevice                        device,
        const(VkFramebufferCreateInfo)* pCreateInfo,
        const(VkAllocationCallbacks)*   pAllocator,
        VkFramebuffer*                  pFramebuffer,
    );
    alias PFN_vkDestroyFramebuffer = void function (
        VkDevice                      device,
        VkFramebuffer                 framebuffer,
        const(VkAllocationCallbacks)* pAllocator,
    );
    alias PFN_vkCreateRenderPass = VkResult function (
        VkDevice                       device,
        const(VkRenderPassCreateInfo)* pCreateInfo,
        const(VkAllocationCallbacks)*  pAllocator,
        VkRenderPass*                  pRenderPass,
    );
    alias PFN_vkDestroyRenderPass = void function (
        VkDevice                      device,
        VkRenderPass                  renderPass,
        const(VkAllocationCallbacks)* pAllocator,
    );
    alias PFN_vkGetRenderAreaGranularity = void function (
        VkDevice     device,
        VkRenderPass renderPass,
        VkExtent2D*  pGranularity,
    );
    alias PFN_vkCreateCommandPool = VkResult function (
        VkDevice                        device,
        const(VkCommandPoolCreateInfo)* pCreateInfo,
        const(VkAllocationCallbacks)*   pAllocator,
        VkCommandPool*                  pCommandPool,
    );
    alias PFN_vkDestroyCommandPool = void function (
        VkDevice                      device,
        VkCommandPool                 commandPool,
        const(VkAllocationCallbacks)* pAllocator,
    );
    alias PFN_vkResetCommandPool = VkResult function (
        VkDevice                device,
        VkCommandPool           commandPool,
        VkCommandPoolResetFlags flags,
    );
    alias PFN_vkAllocateCommandBuffers = VkResult function (
        VkDevice                            device,
        const(VkCommandBufferAllocateInfo)* pAllocateInfo,
        VkCommandBuffer*                    pCommandBuffers,
    );
    alias PFN_vkFreeCommandBuffers = void function (
        VkDevice                device,
        VkCommandPool           commandPool,
        uint32_t                commandBufferCount,
        const(VkCommandBuffer)* pCommandBuffers,
    );
    alias PFN_vkBeginCommandBuffer = VkResult function (
        VkCommandBuffer                  commandBuffer,
        const(VkCommandBufferBeginInfo)* pBeginInfo,
    );
    alias PFN_vkEndCommandBuffer = VkResult function (
        VkCommandBuffer commandBuffer,
    );
    alias PFN_vkResetCommandBuffer = VkResult function (
        VkCommandBuffer           commandBuffer,
        VkCommandBufferResetFlags flags,
    );
    alias PFN_vkCmdBindPipeline = void function (
        VkCommandBuffer     commandBuffer,
        VkPipelineBindPoint pipelineBindPoint,
        VkPipeline          pipeline,
    );
    alias PFN_vkCmdSetViewport = void function (
        VkCommandBuffer    commandBuffer,
        uint32_t           firstViewport,
        uint32_t           viewportCount,
        const(VkViewport)* pViewports,
    );
    alias PFN_vkCmdSetScissor = void function (
        VkCommandBuffer  commandBuffer,
        uint32_t         firstScissor,
        uint32_t         scissorCount,
        const(VkRect2D)* pScissors,
    );
    alias PFN_vkCmdSetLineWidth = void function (
        VkCommandBuffer commandBuffer,
        float           lineWidth,
    );
    alias PFN_vkCmdSetDepthBias = void function (
        VkCommandBuffer commandBuffer,
        float           depthBiasConstantFactor,
        float           depthBiasClamp,
        float           depthBiasSlopeFactor,
    );
    alias PFN_vkCmdSetBlendConstants = void function (
        VkCommandBuffer commandBuffer,
        const float[4]  blendConstants,
    );
    alias PFN_vkCmdSetDepthBounds = void function (
        VkCommandBuffer commandBuffer,
        float           minDepthBounds,
        float           maxDepthBounds,
    );
    alias PFN_vkCmdSetStencilCompareMask = void function (
        VkCommandBuffer    commandBuffer,
        VkStencilFaceFlags faceMask,
        uint32_t           compareMask,
    );
    alias PFN_vkCmdSetStencilWriteMask = void function (
        VkCommandBuffer    commandBuffer,
        VkStencilFaceFlags faceMask,
        uint32_t           writeMask,
    );
    alias PFN_vkCmdSetStencilReference = void function (
        VkCommandBuffer    commandBuffer,
        VkStencilFaceFlags faceMask,
        uint32_t           reference,
    );
    alias PFN_vkCmdBindDescriptorSets = void function (
        VkCommandBuffer         commandBuffer,
        VkPipelineBindPoint     pipelineBindPoint,
        VkPipelineLayout        layout,
        uint32_t                firstSet,
        uint32_t                descriptorSetCount,
        const(VkDescriptorSet)* pDescriptorSets,
        uint32_t                dynamicOffsetCount,
        const(uint32_t)*        pDynamicOffsets,
    );
    alias PFN_vkCmdBindIndexBuffer = void function (
        VkCommandBuffer commandBuffer,
        VkBuffer        buffer,
        VkDeviceSize    offset,
        VkIndexType     indexType,
    );
    alias PFN_vkCmdBindVertexBuffers = void function (
        VkCommandBuffer      commandBuffer,
        uint32_t             firstBinding,
        uint32_t             bindingCount,
        const(VkBuffer)*     pBuffers,
        const(VkDeviceSize)* pOffsets,
    );
    alias PFN_vkCmdDraw = void function (
        VkCommandBuffer commandBuffer,
        uint32_t        vertexCount,
        uint32_t        instanceCount,
        uint32_t        firstVertex,
        uint32_t        firstInstance,
    );
    alias PFN_vkCmdDrawIndexed = void function (
        VkCommandBuffer commandBuffer,
        uint32_t        indexCount,
        uint32_t        instanceCount,
        uint32_t        firstIndex,
        int32_t         vertexOffset,
        uint32_t        firstInstance,
    );
    alias PFN_vkCmdDrawIndirect = void function (
        VkCommandBuffer commandBuffer,
        VkBuffer        buffer,
        VkDeviceSize    offset,
        uint32_t        drawCount,
        uint32_t        stride,
    );
    alias PFN_vkCmdDrawIndexedIndirect = void function (
        VkCommandBuffer commandBuffer,
        VkBuffer        buffer,
        VkDeviceSize    offset,
        uint32_t        drawCount,
        uint32_t        stride,
    );
    alias PFN_vkCmdDispatch = void function (
        VkCommandBuffer commandBuffer,
        uint32_t        groupCountX,
        uint32_t        groupCountY,
        uint32_t        groupCountZ,
    );
    alias PFN_vkCmdDispatchIndirect = void function (
        VkCommandBuffer commandBuffer,
        VkBuffer        buffer,
        VkDeviceSize    offset,
    );
    alias PFN_vkCmdCopyBuffer = void function (
        VkCommandBuffer      commandBuffer,
        VkBuffer             srcBuffer,
        VkBuffer             dstBuffer,
        uint32_t             regionCount,
        const(VkBufferCopy)* pRegions,
    );
    alias PFN_vkCmdCopyImage = void function (
        VkCommandBuffer     commandBuffer,
        VkImage             srcImage,
        VkImageLayout       srcImageLayout,
        VkImage             dstImage,
        VkImageLayout       dstImageLayout,
        uint32_t            regionCount,
        const(VkImageCopy)* pRegions,
    );
    alias PFN_vkCmdBlitImage = void function (
        VkCommandBuffer     commandBuffer,
        VkImage             srcImage,
        VkImageLayout       srcImageLayout,
        VkImage             dstImage,
        VkImageLayout       dstImageLayout,
        uint32_t            regionCount,
        const(VkImageBlit)* pRegions,
        VkFilter            filter,
    );
    alias PFN_vkCmdCopyBufferToImage = void function (
        VkCommandBuffer           commandBuffer,
        VkBuffer                  srcBuffer,
        VkImage                   dstImage,
        VkImageLayout             dstImageLayout,
        uint32_t                  regionCount,
        const(VkBufferImageCopy)* pRegions,
    );
    alias PFN_vkCmdCopyImageToBuffer = void function (
        VkCommandBuffer           commandBuffer,
        VkImage                   srcImage,
        VkImageLayout             srcImageLayout,
        VkBuffer                  dstBuffer,
        uint32_t                  regionCount,
        const(VkBufferImageCopy)* pRegions,
    );
    alias PFN_vkCmdUpdateBuffer = void function (
        VkCommandBuffer commandBuffer,
        VkBuffer        dstBuffer,
        VkDeviceSize    dstOffset,
        VkDeviceSize    dataSize,
        const(void)*    pData,
    );
    alias PFN_vkCmdFillBuffer = void function (
        VkCommandBuffer commandBuffer,
        VkBuffer        dstBuffer,
        VkDeviceSize    dstOffset,
        VkDeviceSize    size,
        uint32_t        data,
    );
    alias PFN_vkCmdClearColorImage = void function (
        VkCommandBuffer                 commandBuffer,
        VkImage                         image,
        VkImageLayout                   imageLayout,
        const(VkClearColorValue)*       pColor,
        uint32_t                        rangeCount,
        const(VkImageSubresourceRange)* pRanges,
    );
    alias PFN_vkCmdClearDepthStencilImage = void function (
        VkCommandBuffer                  commandBuffer,
        VkImage                          image,
        VkImageLayout                    imageLayout,
        const(VkClearDepthStencilValue)* pDepthStencil,
        uint32_t                         rangeCount,
        const(VkImageSubresourceRange)*  pRanges,
    );
    alias PFN_vkCmdClearAttachments = void function (
        VkCommandBuffer           commandBuffer,
        uint32_t                  attachmentCount,
        const(VkClearAttachment)* pAttachments,
        uint32_t                  rectCount,
        const(VkClearRect)*       pRects,
    );
    alias PFN_vkCmdResolveImage = void function (
        VkCommandBuffer        commandBuffer,
        VkImage                srcImage,
        VkImageLayout          srcImageLayout,
        VkImage                dstImage,
        VkImageLayout          dstImageLayout,
        uint32_t               regionCount,
        const(VkImageResolve)* pRegions,
    );
    alias PFN_vkCmdSetEvent = void function (
        VkCommandBuffer      commandBuffer,
        VkEvent              event,
        VkPipelineStageFlags stageMask,
    );
    alias PFN_vkCmdResetEvent = void function (
        VkCommandBuffer      commandBuffer,
        VkEvent              event,
        VkPipelineStageFlags stageMask,
    );
    alias PFN_vkCmdWaitEvents = void function (
        VkCommandBuffer               commandBuffer,
        uint32_t                      eventCount,
        const(VkEvent)*               pEvents,
        VkPipelineStageFlags          srcStageMask,
        VkPipelineStageFlags          dstStageMask,
        uint32_t                      memoryBarrierCount,
        const(VkMemoryBarrier)*       pMemoryBarriers,
        uint32_t                      bufferMemoryBarrierCount,
        const(VkBufferMemoryBarrier)* pBufferMemoryBarriers,
        uint32_t                      imageMemoryBarrierCount,
        const(VkImageMemoryBarrier)*  pImageMemoryBarriers,
    );
    alias PFN_vkCmdPipelineBarrier = void function (
        VkCommandBuffer               commandBuffer,
        VkPipelineStageFlags          srcStageMask,
        VkPipelineStageFlags          dstStageMask,
        VkDependencyFlags             dependencyFlags,
        uint32_t                      memoryBarrierCount,
        const(VkMemoryBarrier)*       pMemoryBarriers,
        uint32_t                      bufferMemoryBarrierCount,
        const(VkBufferMemoryBarrier)* pBufferMemoryBarriers,
        uint32_t                      imageMemoryBarrierCount,
        const(VkImageMemoryBarrier)*  pImageMemoryBarriers,
    );
    alias PFN_vkCmdBeginQuery = void function (
        VkCommandBuffer     commandBuffer,
        VkQueryPool         queryPool,
        uint32_t            query,
        VkQueryControlFlags flags,
    );
    alias PFN_vkCmdEndQuery = void function (
        VkCommandBuffer commandBuffer,
        VkQueryPool     queryPool,
        uint32_t        query,
    );
    alias PFN_vkCmdResetQueryPool = void function (
        VkCommandBuffer commandBuffer,
        VkQueryPool     queryPool,
        uint32_t        firstQuery,
        uint32_t        queryCount,
    );
    alias PFN_vkCmdWriteTimestamp = void function (
        VkCommandBuffer         commandBuffer,
        VkPipelineStageFlagBits pipelineStage,
        VkQueryPool             queryPool,
        uint32_t                query,
    );
    alias PFN_vkCmdCopyQueryPoolResults = void function (
        VkCommandBuffer    commandBuffer,
        VkQueryPool        queryPool,
        uint32_t           firstQuery,
        uint32_t           queryCount,
        VkBuffer           dstBuffer,
        VkDeviceSize       dstOffset,
        VkDeviceSize       stride,
        VkQueryResultFlags flags,
    );
    alias PFN_vkCmdPushConstants = void function (
        VkCommandBuffer    commandBuffer,
        VkPipelineLayout   layout,
        VkShaderStageFlags stageFlags,
        uint32_t           offset,
        uint32_t           size,
        const(void)*       pValues,
    );
    alias PFN_vkCmdBeginRenderPass = void function (
        VkCommandBuffer               commandBuffer,
        const(VkRenderPassBeginInfo)* pRenderPassBegin,
        VkSubpassContents             contents,
    );
    alias PFN_vkCmdNextSubpass = void function (
        VkCommandBuffer   commandBuffer,
        VkSubpassContents contents,
    );
    alias PFN_vkCmdEndRenderPass = void function (
        VkCommandBuffer commandBuffer,
    );
    alias PFN_vkCmdExecuteCommands = void function (
        VkCommandBuffer         commandBuffer,
        uint32_t                commandBufferCount,
        const(VkCommandBuffer)* pCommandBuffers,
    );

    // VK_VERSION_1_1
    alias PFN_vkEnumerateInstanceVersion = VkResult function (
        uint32_t* pApiVersion,
    );
    alias PFN_vkBindBufferMemory2 = VkResult function (
        VkDevice                       device,
        uint32_t                       bindInfoCount,
        const(VkBindBufferMemoryInfo)* pBindInfos,
    );
    alias PFN_vkBindImageMemory2 = VkResult function (
        VkDevice                      device,
        uint32_t                      bindInfoCount,
        const(VkBindImageMemoryInfo)* pBindInfos,
    );
    alias PFN_vkGetDeviceGroupPeerMemoryFeatures = void function (
        VkDevice                  device,
        uint32_t                  heapIndex,
        uint32_t                  localDeviceIndex,
        uint32_t                  remoteDeviceIndex,
        VkPeerMemoryFeatureFlags* pPeerMemoryFeatures,
    );
    alias PFN_vkCmdSetDeviceMask = void function (
        VkCommandBuffer commandBuffer,
        uint32_t        deviceMask,
    );
    alias PFN_vkCmdDispatchBase = void function (
        VkCommandBuffer commandBuffer,
        uint32_t        baseGroupX,
        uint32_t        baseGroupY,
        uint32_t        baseGroupZ,
        uint32_t        groupCountX,
        uint32_t        groupCountY,
        uint32_t        groupCountZ,
    );
    alias PFN_vkEnumeratePhysicalDeviceGroups = VkResult function (
        VkInstance                       instance,
        uint32_t*                        pPhysicalDeviceGroupCount,
        VkPhysicalDeviceGroupProperties* pPhysicalDeviceGroupProperties,
    );
    alias PFN_vkGetImageMemoryRequirements2 = void function (
        VkDevice                               device,
        const(VkImageMemoryRequirementsInfo2)* pInfo,
        VkMemoryRequirements2*                 pMemoryRequirements,
    );
    alias PFN_vkGetBufferMemoryRequirements2 = void function (
        VkDevice                                device,
        const(VkBufferMemoryRequirementsInfo2)* pInfo,
        VkMemoryRequirements2*                  pMemoryRequirements,
    );
    alias PFN_vkGetImageSparseMemoryRequirements2 = void function (
        VkDevice                                     device,
        const(VkImageSparseMemoryRequirementsInfo2)* pInfo,
        uint32_t*                                    pSparseMemoryRequirementCount,
        VkSparseImageMemoryRequirements2*            pSparseMemoryRequirements,
    );
    alias PFN_vkGetPhysicalDeviceFeatures2 = void function (
        VkPhysicalDevice           physicalDevice,
        VkPhysicalDeviceFeatures2* pFeatures,
    );
    alias PFN_vkGetPhysicalDeviceProperties2 = void function (
        VkPhysicalDevice             physicalDevice,
        VkPhysicalDeviceProperties2* pProperties,
    );
    alias PFN_vkGetPhysicalDeviceFormatProperties2 = void function (
        VkPhysicalDevice     physicalDevice,
        VkFormat             format,
        VkFormatProperties2* pFormatProperties,
    );
    alias PFN_vkGetPhysicalDeviceImageFormatProperties2 = VkResult function (
        VkPhysicalDevice                         physicalDevice,
        const(VkPhysicalDeviceImageFormatInfo2)* pImageFormatInfo,
        VkImageFormatProperties2*                pImageFormatProperties,
    );
    alias PFN_vkGetPhysicalDeviceQueueFamilyProperties2 = void function (
        VkPhysicalDevice          physicalDevice,
        uint32_t*                 pQueueFamilyPropertyCount,
        VkQueueFamilyProperties2* pQueueFamilyProperties,
    );
    alias PFN_vkGetPhysicalDeviceMemoryProperties2 = void function (
        VkPhysicalDevice                   physicalDevice,
        VkPhysicalDeviceMemoryProperties2* pMemoryProperties,
    );
    alias PFN_vkGetPhysicalDeviceSparseImageFormatProperties2 = void function (
        VkPhysicalDevice                               physicalDevice,
        const(VkPhysicalDeviceSparseImageFormatInfo2)* pFormatInfo,
        uint32_t*                                      pPropertyCount,
        VkSparseImageFormatProperties2*                pProperties,
    );
    alias PFN_vkTrimCommandPool = void function (
        VkDevice               device,
        VkCommandPool          commandPool,
        VkCommandPoolTrimFlags flags,
    );
    alias PFN_vkGetDeviceQueue2 = void function (
        VkDevice                   device,
        const(VkDeviceQueueInfo2)* pQueueInfo,
        VkQueue*                   pQueue,
    );
    alias PFN_vkCreateSamplerYcbcrConversion = VkResult function (
        VkDevice                                   device,
        const(VkSamplerYcbcrConversionCreateInfo)* pCreateInfo,
        const(VkAllocationCallbacks)*              pAllocator,
        VkSamplerYcbcrConversion*                  pYcbcrConversion,
    );
    alias PFN_vkDestroySamplerYcbcrConversion = void function (
        VkDevice                      device,
        VkSamplerYcbcrConversion      ycbcrConversion,
        const(VkAllocationCallbacks)* pAllocator,
    );
    alias PFN_vkCreateDescriptorUpdateTemplate = VkResult function (
        VkDevice                                     device,
        const(VkDescriptorUpdateTemplateCreateInfo)* pCreateInfo,
        const(VkAllocationCallbacks)*                pAllocator,
        VkDescriptorUpdateTemplate*                  pDescriptorUpdateTemplate,
    );
    alias PFN_vkDestroyDescriptorUpdateTemplate = void function (
        VkDevice                      device,
        VkDescriptorUpdateTemplate    descriptorUpdateTemplate,
        const(VkAllocationCallbacks)* pAllocator,
    );
    alias PFN_vkUpdateDescriptorSetWithTemplate = void function (
        VkDevice                   device,
        VkDescriptorSet            descriptorSet,
        VkDescriptorUpdateTemplate descriptorUpdateTemplate,
        const(void)*               pData,
    );
    alias PFN_vkGetPhysicalDeviceExternalBufferProperties = void function (
        VkPhysicalDevice                           physicalDevice,
        const(VkPhysicalDeviceExternalBufferInfo)* pExternalBufferInfo,
        VkExternalBufferProperties*                pExternalBufferProperties,
    );
    alias PFN_vkGetPhysicalDeviceExternalFenceProperties = void function (
        VkPhysicalDevice                          physicalDevice,
        const(VkPhysicalDeviceExternalFenceInfo)* pExternalFenceInfo,
        VkExternalFenceProperties*                pExternalFenceProperties,
    );
    alias PFN_vkGetPhysicalDeviceExternalSemaphoreProperties = void function (
        VkPhysicalDevice                              physicalDevice,
        const(VkPhysicalDeviceExternalSemaphoreInfo)* pExternalSemaphoreInfo,
        VkExternalSemaphoreProperties*                pExternalSemaphoreProperties,
    );
    alias PFN_vkGetDescriptorSetLayoutSupport = void function (
        VkDevice                                device,
        const(VkDescriptorSetLayoutCreateInfo)* pCreateInfo,
        VkDescriptorSetLayoutSupport*           pSupport,
    );

    // VK_KHR_surface
    alias PFN_vkDestroySurfaceKHR = void function (
        VkInstance                    instance,
        VkSurfaceKHR                  surface,
        const(VkAllocationCallbacks)* pAllocator,
    );
    alias PFN_vkGetPhysicalDeviceSurfaceSupportKHR = VkResult function (
        VkPhysicalDevice physicalDevice,
        uint32_t         queueFamilyIndex,
        VkSurfaceKHR     surface,
        VkBool32*        pSupported,
    );
    alias PFN_vkGetPhysicalDeviceSurfaceCapabilitiesKHR = VkResult function (
        VkPhysicalDevice          physicalDevice,
        VkSurfaceKHR              surface,
        VkSurfaceCapabilitiesKHR* pSurfaceCapabilities,
    );
    alias PFN_vkGetPhysicalDeviceSurfaceFormatsKHR = VkResult function (
        VkPhysicalDevice    physicalDevice,
        VkSurfaceKHR        surface,
        uint32_t*           pSurfaceFormatCount,
        VkSurfaceFormatKHR* pSurfaceFormats,
    );
    alias PFN_vkGetPhysicalDeviceSurfacePresentModesKHR = VkResult function (
        VkPhysicalDevice  physicalDevice,
        VkSurfaceKHR      surface,
        uint32_t*         pPresentModeCount,
        VkPresentModeKHR* pPresentModes,
    );

    // VK_KHR_swapchain
    alias PFN_vkCreateSwapchainKHR = VkResult function (
        VkDevice                         device,
        const(VkSwapchainCreateInfoKHR)* pCreateInfo,
        const(VkAllocationCallbacks)*    pAllocator,
        VkSwapchainKHR*                  pSwapchain,
    );
    alias PFN_vkDestroySwapchainKHR = void function (
        VkDevice                      device,
        VkSwapchainKHR                swapchain,
        const(VkAllocationCallbacks)* pAllocator,
    );
    alias PFN_vkGetSwapchainImagesKHR = VkResult function (
        VkDevice       device,
        VkSwapchainKHR swapchain,
        uint32_t*      pSwapchainImageCount,
        VkImage*       pSwapchainImages,
    );
    alias PFN_vkAcquireNextImageKHR = VkResult function (
        VkDevice       device,
        VkSwapchainKHR swapchain,
        uint64_t       timeout,
        VkSemaphore    semaphore,
        VkFence        fence,
        uint32_t*      pImageIndex,
    );
    alias PFN_vkQueuePresentKHR = VkResult function (
        VkQueue                  queue,
        const(VkPresentInfoKHR)* pPresentInfo,
    );
    alias PFN_vkGetDeviceGroupPresentCapabilitiesKHR = VkResult function (
        VkDevice                             device,
        VkDeviceGroupPresentCapabilitiesKHR* pDeviceGroupPresentCapabilities,
    );
    alias PFN_vkGetDeviceGroupSurfacePresentModesKHR = VkResult function (
        VkDevice                          device,
        VkSurfaceKHR                      surface,
        VkDeviceGroupPresentModeFlagsKHR* pModes,
    );
    alias PFN_vkGetPhysicalDevicePresentRectanglesKHR = VkResult function (
        VkPhysicalDevice physicalDevice,
        VkSurfaceKHR     surface,
        uint32_t*        pRectCount,
        VkRect2D*        pRects,
    );
    alias PFN_vkAcquireNextImage2KHR = VkResult function (
        VkDevice                          device,
        const(VkAcquireNextImageInfoKHR)* pAcquireInfo,
        uint32_t*                         pImageIndex,
    );

    // VK_KHR_display
    alias PFN_vkGetPhysicalDeviceDisplayPropertiesKHR = VkResult function (
        VkPhysicalDevice        physicalDevice,
        uint32_t*               pPropertyCount,
        VkDisplayPropertiesKHR* pProperties,
    );
    alias PFN_vkGetPhysicalDeviceDisplayPlanePropertiesKHR = VkResult function (
        VkPhysicalDevice             physicalDevice,
        uint32_t*                    pPropertyCount,
        VkDisplayPlanePropertiesKHR* pProperties,
    );
    alias PFN_vkGetDisplayPlaneSupportedDisplaysKHR = VkResult function (
        VkPhysicalDevice physicalDevice,
        uint32_t         planeIndex,
        uint32_t*        pDisplayCount,
        VkDisplayKHR*    pDisplays,
    );
    alias PFN_vkGetDisplayModePropertiesKHR = VkResult function (
        VkPhysicalDevice            physicalDevice,
        VkDisplayKHR                display,
        uint32_t*                   pPropertyCount,
        VkDisplayModePropertiesKHR* pProperties,
    );
    alias PFN_vkCreateDisplayModeKHR = VkResult function (
        VkPhysicalDevice                   physicalDevice,
        VkDisplayKHR                       display,
        const(VkDisplayModeCreateInfoKHR)* pCreateInfo,
        const(VkAllocationCallbacks)*      pAllocator,
        VkDisplayModeKHR*                  pMode,
    );
    alias PFN_vkGetDisplayPlaneCapabilitiesKHR = VkResult function (
        VkPhysicalDevice               physicalDevice,
        VkDisplayModeKHR               mode,
        uint32_t                       planeIndex,
        VkDisplayPlaneCapabilitiesKHR* pCapabilities,
    );
    alias PFN_vkCreateDisplayPlaneSurfaceKHR = VkResult function (
        VkInstance                            instance,
        const(VkDisplaySurfaceCreateInfoKHR)* pCreateInfo,
        const(VkAllocationCallbacks)*         pAllocator,
        VkSurfaceKHR*                         pSurface,
    );

    // VK_KHR_xcb_surface
    version(linux) {
        alias PFN_vkCreateXcbSurfaceKHR = VkResult function (
            VkInstance                        instance,
            const(VkXcbSurfaceCreateInfoKHR)* pCreateInfo,
            const(VkAllocationCallbacks)*     pAllocator,
            VkSurfaceKHR*                     pSurface,
        );
        alias PFN_vkGetPhysicalDeviceXcbPresentationSupportKHR = VkBool32 function (
            VkPhysicalDevice  physicalDevice,
            uint32_t          queueFamilyIndex,
            xcb_connection_t* connection,
            xcb_visualid_t    visual_id,
        );
    }

    // VK_KHR_wayland_surface
    version(linux) {
        alias PFN_vkCreateWaylandSurfaceKHR = VkResult function (
            VkInstance                            instance,
            const(VkWaylandSurfaceCreateInfoKHR)* pCreateInfo,
            const(VkAllocationCallbacks)*         pAllocator,
            VkSurfaceKHR*                         pSurface,
        );
        alias PFN_vkGetPhysicalDeviceWaylandPresentationSupportKHR = VkBool32 function (
            VkPhysicalDevice physicalDevice,
            uint32_t         queueFamilyIndex,
            wl_display*      display,
        );
    }

    // VK_KHR_win32_surface
    version(Windows) {
        alias PFN_vkCreateWin32SurfaceKHR = VkResult function (
            VkInstance                          instance,
            const(VkWin32SurfaceCreateInfoKHR)* pCreateInfo,
            const(VkAllocationCallbacks)*       pAllocator,
            VkSurfaceKHR*                       pSurface,
        );
        alias PFN_vkGetPhysicalDeviceWin32PresentationSupportKHR = VkBool32 function (
            VkPhysicalDevice physicalDevice,
            uint32_t         queueFamilyIndex,
        );
    }

    // VK_EXT_debug_report
    alias PFN_vkCreateDebugReportCallbackEXT = VkResult function (
        VkInstance                                 instance,
        const(VkDebugReportCallbackCreateInfoEXT)* pCreateInfo,
        const(VkAllocationCallbacks)*              pAllocator,
        VkDebugReportCallbackEXT*                  pCallback,
    );
    alias PFN_vkDestroyDebugReportCallbackEXT = void function (
        VkInstance                    instance,
        VkDebugReportCallbackEXT      callback,
        const(VkAllocationCallbacks)* pAllocator,
    );
    alias PFN_vkDebugReportMessageEXT = void function (
        VkInstance                 instance,
        VkDebugReportFlagsEXT      flags,
        VkDebugReportObjectTypeEXT objectType,
        uint64_t                   object,
        size_t                     location,
        int32_t                    messageCode,
        const(char)*               pLayerPrefix,
        const(char)*               pMessage,
    );
}


// Global commands

final class VkGlobalCmds {

    this (PFN_vkGetInstanceProcAddr loader) {
        _GetInstanceProcAddr = loader;
        _CreateInstance                       = cast(PFN_vkCreateInstance)                      loader(null, "vkCreateInstance");
        _EnumerateInstanceExtensionProperties = cast(PFN_vkEnumerateInstanceExtensionProperties)loader(null, "vkEnumerateInstanceExtensionProperties");
        _EnumerateInstanceLayerProperties     = cast(PFN_vkEnumerateInstanceLayerProperties)    loader(null, "vkEnumerateInstanceLayerProperties");
    }

    VkResult CreateInstance (const(VkInstanceCreateInfo)* pCreateInfo, const(VkAllocationCallbacks)* pAllocator, VkInstance* pInstance) {
        assert(_CreateInstance !is null, "vkCreateInstance was not loaded.");
        return _CreateInstance(pCreateInfo, pAllocator, pInstance);
    }

    PFN_vkVoidFunction GetInstanceProcAddr (VkInstance instance, const(char)* pName) {
        assert(_GetInstanceProcAddr !is null, "vkGetInstanceProcAddr was not loaded.");
        return _GetInstanceProcAddr(instance, pName);
    }

    VkResult EnumerateInstanceExtensionProperties (const(char)* pLayerName, uint32_t* pPropertyCount, VkExtensionProperties* pProperties) {
        assert(_EnumerateInstanceExtensionProperties !is null, "vkEnumerateInstanceExtensionProperties was not loaded.");
        return _EnumerateInstanceExtensionProperties(pLayerName, pPropertyCount, pProperties);
    }

    VkResult EnumerateInstanceLayerProperties (uint32_t* pPropertyCount, VkLayerProperties* pProperties) {
        assert(_EnumerateInstanceLayerProperties !is null, "vkEnumerateInstanceLayerProperties was not loaded.");
        return _EnumerateInstanceLayerProperties(pPropertyCount, pProperties);
    }

    private PFN_vkCreateInstance                       _CreateInstance;
    private PFN_vkGetInstanceProcAddr                  _GetInstanceProcAddr;
    private PFN_vkEnumerateInstanceExtensionProperties _EnumerateInstanceExtensionProperties;
    private PFN_vkEnumerateInstanceLayerProperties     _EnumerateInstanceLayerProperties;
}

// Instance commands

final class VkInstanceCmds {

    this (VkInstance instance, VkGlobalCmds globalCmds) {
        auto loader = globalCmds._GetInstanceProcAddr;
        // VK_VERSION_1_0
        _DestroyInstance                                = cast(PFN_vkDestroyInstance)                               loader(instance, "vkDestroyInstance");
        _EnumeratePhysicalDevices                       = cast(PFN_vkEnumeratePhysicalDevices)                      loader(instance, "vkEnumeratePhysicalDevices");
        _GetPhysicalDeviceFeatures                      = cast(PFN_vkGetPhysicalDeviceFeatures)                     loader(instance, "vkGetPhysicalDeviceFeatures");
        _GetPhysicalDeviceFormatProperties              = cast(PFN_vkGetPhysicalDeviceFormatProperties)             loader(instance, "vkGetPhysicalDeviceFormatProperties");
        _GetPhysicalDeviceImageFormatProperties         = cast(PFN_vkGetPhysicalDeviceImageFormatProperties)        loader(instance, "vkGetPhysicalDeviceImageFormatProperties");
        _GetPhysicalDeviceProperties                    = cast(PFN_vkGetPhysicalDeviceProperties)                   loader(instance, "vkGetPhysicalDeviceProperties");
        _GetPhysicalDeviceQueueFamilyProperties         = cast(PFN_vkGetPhysicalDeviceQueueFamilyProperties)        loader(instance, "vkGetPhysicalDeviceQueueFamilyProperties");
        _GetPhysicalDeviceMemoryProperties              = cast(PFN_vkGetPhysicalDeviceMemoryProperties)             loader(instance, "vkGetPhysicalDeviceMemoryProperties");
        _GetDeviceProcAddr                              = cast(PFN_vkGetDeviceProcAddr)                             loader(instance, "vkGetDeviceProcAddr");
        _CreateDevice                                   = cast(PFN_vkCreateDevice)                                  loader(instance, "vkCreateDevice");
        _EnumerateDeviceExtensionProperties             = cast(PFN_vkEnumerateDeviceExtensionProperties)            loader(instance, "vkEnumerateDeviceExtensionProperties");
        _EnumerateDeviceLayerProperties                 = cast(PFN_vkEnumerateDeviceLayerProperties)                loader(instance, "vkEnumerateDeviceLayerProperties");
        _GetPhysicalDeviceSparseImageFormatProperties   = cast(PFN_vkGetPhysicalDeviceSparseImageFormatProperties)  loader(instance, "vkGetPhysicalDeviceSparseImageFormatProperties");

        // VK_VERSION_1_1
        _EnumerateInstanceVersion                       = cast(PFN_vkEnumerateInstanceVersion)                      loader(instance, "vkEnumerateInstanceVersion");
        _EnumeratePhysicalDeviceGroups                  = cast(PFN_vkEnumeratePhysicalDeviceGroups)                 loader(instance, "vkEnumeratePhysicalDeviceGroups");
        _GetPhysicalDeviceFeatures2                     = cast(PFN_vkGetPhysicalDeviceFeatures2)                    loader(instance, "vkGetPhysicalDeviceFeatures2");
        _GetPhysicalDeviceProperties2                   = cast(PFN_vkGetPhysicalDeviceProperties2)                  loader(instance, "vkGetPhysicalDeviceProperties2");
        _GetPhysicalDeviceFormatProperties2             = cast(PFN_vkGetPhysicalDeviceFormatProperties2)            loader(instance, "vkGetPhysicalDeviceFormatProperties2");
        _GetPhysicalDeviceImageFormatProperties2        = cast(PFN_vkGetPhysicalDeviceImageFormatProperties2)       loader(instance, "vkGetPhysicalDeviceImageFormatProperties2");
        _GetPhysicalDeviceQueueFamilyProperties2        = cast(PFN_vkGetPhysicalDeviceQueueFamilyProperties2)       loader(instance, "vkGetPhysicalDeviceQueueFamilyProperties2");
        _GetPhysicalDeviceMemoryProperties2             = cast(PFN_vkGetPhysicalDeviceMemoryProperties2)            loader(instance, "vkGetPhysicalDeviceMemoryProperties2");
        _GetPhysicalDeviceSparseImageFormatProperties2  = cast(PFN_vkGetPhysicalDeviceSparseImageFormatProperties2) loader(instance, "vkGetPhysicalDeviceSparseImageFormatProperties2");
        _GetPhysicalDeviceExternalBufferProperties      = cast(PFN_vkGetPhysicalDeviceExternalBufferProperties)     loader(instance, "vkGetPhysicalDeviceExternalBufferProperties");
        _GetPhysicalDeviceExternalFenceProperties       = cast(PFN_vkGetPhysicalDeviceExternalFenceProperties)      loader(instance, "vkGetPhysicalDeviceExternalFenceProperties");
        _GetPhysicalDeviceExternalSemaphoreProperties   = cast(PFN_vkGetPhysicalDeviceExternalSemaphoreProperties)  loader(instance, "vkGetPhysicalDeviceExternalSemaphoreProperties");

        // VK_KHR_surface
        _DestroySurfaceKHR                              = cast(PFN_vkDestroySurfaceKHR)                             loader(instance, "vkDestroySurfaceKHR");
        _GetPhysicalDeviceSurfaceSupportKHR             = cast(PFN_vkGetPhysicalDeviceSurfaceSupportKHR)            loader(instance, "vkGetPhysicalDeviceSurfaceSupportKHR");
        _GetPhysicalDeviceSurfaceCapabilitiesKHR        = cast(PFN_vkGetPhysicalDeviceSurfaceCapabilitiesKHR)       loader(instance, "vkGetPhysicalDeviceSurfaceCapabilitiesKHR");
        _GetPhysicalDeviceSurfaceFormatsKHR             = cast(PFN_vkGetPhysicalDeviceSurfaceFormatsKHR)            loader(instance, "vkGetPhysicalDeviceSurfaceFormatsKHR");
        _GetPhysicalDeviceSurfacePresentModesKHR        = cast(PFN_vkGetPhysicalDeviceSurfacePresentModesKHR)       loader(instance, "vkGetPhysicalDeviceSurfacePresentModesKHR");

        // VK_KHR_swapchain
        _GetPhysicalDevicePresentRectanglesKHR          = cast(PFN_vkGetPhysicalDevicePresentRectanglesKHR)         loader(instance, "vkGetPhysicalDevicePresentRectanglesKHR");

        // VK_KHR_display
        _GetPhysicalDeviceDisplayPropertiesKHR          = cast(PFN_vkGetPhysicalDeviceDisplayPropertiesKHR)         loader(instance, "vkGetPhysicalDeviceDisplayPropertiesKHR");
        _GetPhysicalDeviceDisplayPlanePropertiesKHR     = cast(PFN_vkGetPhysicalDeviceDisplayPlanePropertiesKHR)    loader(instance, "vkGetPhysicalDeviceDisplayPlanePropertiesKHR");
        _GetDisplayPlaneSupportedDisplaysKHR            = cast(PFN_vkGetDisplayPlaneSupportedDisplaysKHR)           loader(instance, "vkGetDisplayPlaneSupportedDisplaysKHR");
        _GetDisplayModePropertiesKHR                    = cast(PFN_vkGetDisplayModePropertiesKHR)                   loader(instance, "vkGetDisplayModePropertiesKHR");
        _CreateDisplayModeKHR                           = cast(PFN_vkCreateDisplayModeKHR)                          loader(instance, "vkCreateDisplayModeKHR");
        _GetDisplayPlaneCapabilitiesKHR                 = cast(PFN_vkGetDisplayPlaneCapabilitiesKHR)                loader(instance, "vkGetDisplayPlaneCapabilitiesKHR");
        _CreateDisplayPlaneSurfaceKHR                   = cast(PFN_vkCreateDisplayPlaneSurfaceKHR)                  loader(instance, "vkCreateDisplayPlaneSurfaceKHR");

        // VK_KHR_xcb_surface
        version(linux) {
            _CreateXcbSurfaceKHR                            = cast(PFN_vkCreateXcbSurfaceKHR)                           loader(instance, "vkCreateXcbSurfaceKHR");
            _GetPhysicalDeviceXcbPresentationSupportKHR     = cast(PFN_vkGetPhysicalDeviceXcbPresentationSupportKHR)    loader(instance, "vkGetPhysicalDeviceXcbPresentationSupportKHR");
        }

        // VK_KHR_wayland_surface
        version(linux) {
            _CreateWaylandSurfaceKHR                        = cast(PFN_vkCreateWaylandSurfaceKHR)                       loader(instance, "vkCreateWaylandSurfaceKHR");
            _GetPhysicalDeviceWaylandPresentationSupportKHR = cast(PFN_vkGetPhysicalDeviceWaylandPresentationSupportKHR)loader(instance, "vkGetPhysicalDeviceWaylandPresentationSupportKHR");
        }

        // VK_KHR_win32_surface
        version(Windows) {
            _CreateWin32SurfaceKHR                          = cast(PFN_vkCreateWin32SurfaceKHR)                         loader(instance, "vkCreateWin32SurfaceKHR");
            _GetPhysicalDeviceWin32PresentationSupportKHR   = cast(PFN_vkGetPhysicalDeviceWin32PresentationSupportKHR)  loader(instance, "vkGetPhysicalDeviceWin32PresentationSupportKHR");
        }

        // VK_EXT_debug_report
        _CreateDebugReportCallbackEXT                   = cast(PFN_vkCreateDebugReportCallbackEXT)                  loader(instance, "vkCreateDebugReportCallbackEXT");
        _DestroyDebugReportCallbackEXT                  = cast(PFN_vkDestroyDebugReportCallbackEXT)                 loader(instance, "vkDestroyDebugReportCallbackEXT");
        _DebugReportMessageEXT                          = cast(PFN_vkDebugReportMessageEXT)                         loader(instance, "vkDebugReportMessageEXT");
    }

    /// Commands for VK_VERSION_1_0
    void DestroyInstance (VkInstance instance, const(VkAllocationCallbacks)* pAllocator) {
        assert(_DestroyInstance !is null, "vkDestroyInstance was not loaded. Required by VK_VERSION_1_0");
        return _DestroyInstance(instance, pAllocator);
    }
    /// ditto
    VkResult EnumeratePhysicalDevices (VkInstance instance, uint32_t* pPhysicalDeviceCount, VkPhysicalDevice* pPhysicalDevices) {
        assert(_EnumeratePhysicalDevices !is null, "vkEnumeratePhysicalDevices was not loaded. Required by VK_VERSION_1_0");
        return _EnumeratePhysicalDevices(instance, pPhysicalDeviceCount, pPhysicalDevices);
    }
    /// ditto
    void GetPhysicalDeviceFeatures (VkPhysicalDevice physicalDevice, VkPhysicalDeviceFeatures* pFeatures) {
        assert(_GetPhysicalDeviceFeatures !is null, "vkGetPhysicalDeviceFeatures was not loaded. Required by VK_VERSION_1_0");
        return _GetPhysicalDeviceFeatures(physicalDevice, pFeatures);
    }
    /// ditto
    void GetPhysicalDeviceFormatProperties (VkPhysicalDevice physicalDevice, VkFormat format, VkFormatProperties* pFormatProperties) {
        assert(_GetPhysicalDeviceFormatProperties !is null, "vkGetPhysicalDeviceFormatProperties was not loaded. Required by VK_VERSION_1_0");
        return _GetPhysicalDeviceFormatProperties(physicalDevice, format, pFormatProperties);
    }
    /// ditto
    VkResult GetPhysicalDeviceImageFormatProperties (VkPhysicalDevice physicalDevice, VkFormat format, VkImageType type, VkImageTiling tiling, VkImageUsageFlags usage, VkImageCreateFlags flags, VkImageFormatProperties* pImageFormatProperties) {
        assert(_GetPhysicalDeviceImageFormatProperties !is null, "vkGetPhysicalDeviceImageFormatProperties was not loaded. Required by VK_VERSION_1_0");
        return _GetPhysicalDeviceImageFormatProperties(physicalDevice, format, type, tiling, usage, flags, pImageFormatProperties);
    }
    /// ditto
    void GetPhysicalDeviceProperties (VkPhysicalDevice physicalDevice, VkPhysicalDeviceProperties* pProperties) {
        assert(_GetPhysicalDeviceProperties !is null, "vkGetPhysicalDeviceProperties was not loaded. Required by VK_VERSION_1_0");
        return _GetPhysicalDeviceProperties(physicalDevice, pProperties);
    }
    /// ditto
    void GetPhysicalDeviceQueueFamilyProperties (VkPhysicalDevice physicalDevice, uint32_t* pQueueFamilyPropertyCount, VkQueueFamilyProperties* pQueueFamilyProperties) {
        assert(_GetPhysicalDeviceQueueFamilyProperties !is null, "vkGetPhysicalDeviceQueueFamilyProperties was not loaded. Required by VK_VERSION_1_0");
        return _GetPhysicalDeviceQueueFamilyProperties(physicalDevice, pQueueFamilyPropertyCount, pQueueFamilyProperties);
    }
    /// ditto
    void GetPhysicalDeviceMemoryProperties (VkPhysicalDevice physicalDevice, VkPhysicalDeviceMemoryProperties* pMemoryProperties) {
        assert(_GetPhysicalDeviceMemoryProperties !is null, "vkGetPhysicalDeviceMemoryProperties was not loaded. Required by VK_VERSION_1_0");
        return _GetPhysicalDeviceMemoryProperties(physicalDevice, pMemoryProperties);
    }
    /// ditto
    PFN_vkVoidFunction GetDeviceProcAddr (VkDevice device, const(char)* pName) {
        assert(_GetDeviceProcAddr !is null, "vkGetDeviceProcAddr was not loaded. Required by VK_VERSION_1_0");
        return _GetDeviceProcAddr(device, pName);
    }
    /// ditto
    VkResult CreateDevice (VkPhysicalDevice physicalDevice, const(VkDeviceCreateInfo)* pCreateInfo, const(VkAllocationCallbacks)* pAllocator, VkDevice* pDevice) {
        assert(_CreateDevice !is null, "vkCreateDevice was not loaded. Required by VK_VERSION_1_0");
        return _CreateDevice(physicalDevice, pCreateInfo, pAllocator, pDevice);
    }
    /// ditto
    VkResult EnumerateDeviceExtensionProperties (VkPhysicalDevice physicalDevice, const(char)* pLayerName, uint32_t* pPropertyCount, VkExtensionProperties* pProperties) {
        assert(_EnumerateDeviceExtensionProperties !is null, "vkEnumerateDeviceExtensionProperties was not loaded. Required by VK_VERSION_1_0");
        return _EnumerateDeviceExtensionProperties(physicalDevice, pLayerName, pPropertyCount, pProperties);
    }
    /// ditto
    VkResult EnumerateDeviceLayerProperties (VkPhysicalDevice physicalDevice, uint32_t* pPropertyCount, VkLayerProperties* pProperties) {
        assert(_EnumerateDeviceLayerProperties !is null, "vkEnumerateDeviceLayerProperties was not loaded. Required by VK_VERSION_1_0");
        return _EnumerateDeviceLayerProperties(physicalDevice, pPropertyCount, pProperties);
    }
    /// ditto
    void GetPhysicalDeviceSparseImageFormatProperties (VkPhysicalDevice physicalDevice, VkFormat format, VkImageType type, VkSampleCountFlagBits samples, VkImageUsageFlags usage, VkImageTiling tiling, uint32_t* pPropertyCount, VkSparseImageFormatProperties* pProperties) {
        assert(_GetPhysicalDeviceSparseImageFormatProperties !is null, "vkGetPhysicalDeviceSparseImageFormatProperties was not loaded. Required by VK_VERSION_1_0");
        return _GetPhysicalDeviceSparseImageFormatProperties(physicalDevice, format, type, samples, usage, tiling, pPropertyCount, pProperties);
    }

    /// Commands for VK_VERSION_1_1
    VkResult EnumerateInstanceVersion (uint32_t* pApiVersion) {
        assert(_EnumerateInstanceVersion !is null, "vkEnumerateInstanceVersion was not loaded. Required by VK_VERSION_1_1");
        return _EnumerateInstanceVersion(pApiVersion);
    }
    /// ditto
    VkResult EnumeratePhysicalDeviceGroups (VkInstance instance, uint32_t* pPhysicalDeviceGroupCount, VkPhysicalDeviceGroupProperties* pPhysicalDeviceGroupProperties) {
        assert(_EnumeratePhysicalDeviceGroups !is null, "vkEnumeratePhysicalDeviceGroups was not loaded. Required by VK_VERSION_1_1");
        return _EnumeratePhysicalDeviceGroups(instance, pPhysicalDeviceGroupCount, pPhysicalDeviceGroupProperties);
    }
    /// ditto
    void GetPhysicalDeviceFeatures2 (VkPhysicalDevice physicalDevice, VkPhysicalDeviceFeatures2* pFeatures) {
        assert(_GetPhysicalDeviceFeatures2 !is null, "vkGetPhysicalDeviceFeatures2 was not loaded. Required by VK_VERSION_1_1");
        return _GetPhysicalDeviceFeatures2(physicalDevice, pFeatures);
    }
    /// ditto
    void GetPhysicalDeviceProperties2 (VkPhysicalDevice physicalDevice, VkPhysicalDeviceProperties2* pProperties) {
        assert(_GetPhysicalDeviceProperties2 !is null, "vkGetPhysicalDeviceProperties2 was not loaded. Required by VK_VERSION_1_1");
        return _GetPhysicalDeviceProperties2(physicalDevice, pProperties);
    }
    /// ditto
    void GetPhysicalDeviceFormatProperties2 (VkPhysicalDevice physicalDevice, VkFormat format, VkFormatProperties2* pFormatProperties) {
        assert(_GetPhysicalDeviceFormatProperties2 !is null, "vkGetPhysicalDeviceFormatProperties2 was not loaded. Required by VK_VERSION_1_1");
        return _GetPhysicalDeviceFormatProperties2(physicalDevice, format, pFormatProperties);
    }
    /// ditto
    VkResult GetPhysicalDeviceImageFormatProperties2 (VkPhysicalDevice physicalDevice, const(VkPhysicalDeviceImageFormatInfo2)* pImageFormatInfo, VkImageFormatProperties2* pImageFormatProperties) {
        assert(_GetPhysicalDeviceImageFormatProperties2 !is null, "vkGetPhysicalDeviceImageFormatProperties2 was not loaded. Required by VK_VERSION_1_1");
        return _GetPhysicalDeviceImageFormatProperties2(physicalDevice, pImageFormatInfo, pImageFormatProperties);
    }
    /// ditto
    void GetPhysicalDeviceQueueFamilyProperties2 (VkPhysicalDevice physicalDevice, uint32_t* pQueueFamilyPropertyCount, VkQueueFamilyProperties2* pQueueFamilyProperties) {
        assert(_GetPhysicalDeviceQueueFamilyProperties2 !is null, "vkGetPhysicalDeviceQueueFamilyProperties2 was not loaded. Required by VK_VERSION_1_1");
        return _GetPhysicalDeviceQueueFamilyProperties2(physicalDevice, pQueueFamilyPropertyCount, pQueueFamilyProperties);
    }
    /// ditto
    void GetPhysicalDeviceMemoryProperties2 (VkPhysicalDevice physicalDevice, VkPhysicalDeviceMemoryProperties2* pMemoryProperties) {
        assert(_GetPhysicalDeviceMemoryProperties2 !is null, "vkGetPhysicalDeviceMemoryProperties2 was not loaded. Required by VK_VERSION_1_1");
        return _GetPhysicalDeviceMemoryProperties2(physicalDevice, pMemoryProperties);
    }
    /// ditto
    void GetPhysicalDeviceSparseImageFormatProperties2 (VkPhysicalDevice physicalDevice, const(VkPhysicalDeviceSparseImageFormatInfo2)* pFormatInfo, uint32_t* pPropertyCount, VkSparseImageFormatProperties2* pProperties) {
        assert(_GetPhysicalDeviceSparseImageFormatProperties2 !is null, "vkGetPhysicalDeviceSparseImageFormatProperties2 was not loaded. Required by VK_VERSION_1_1");
        return _GetPhysicalDeviceSparseImageFormatProperties2(physicalDevice, pFormatInfo, pPropertyCount, pProperties);
    }
    /// ditto
    void GetPhysicalDeviceExternalBufferProperties (VkPhysicalDevice physicalDevice, const(VkPhysicalDeviceExternalBufferInfo)* pExternalBufferInfo, VkExternalBufferProperties* pExternalBufferProperties) {
        assert(_GetPhysicalDeviceExternalBufferProperties !is null, "vkGetPhysicalDeviceExternalBufferProperties was not loaded. Required by VK_VERSION_1_1");
        return _GetPhysicalDeviceExternalBufferProperties(physicalDevice, pExternalBufferInfo, pExternalBufferProperties);
    }
    /// ditto
    void GetPhysicalDeviceExternalFenceProperties (VkPhysicalDevice physicalDevice, const(VkPhysicalDeviceExternalFenceInfo)* pExternalFenceInfo, VkExternalFenceProperties* pExternalFenceProperties) {
        assert(_GetPhysicalDeviceExternalFenceProperties !is null, "vkGetPhysicalDeviceExternalFenceProperties was not loaded. Required by VK_VERSION_1_1");
        return _GetPhysicalDeviceExternalFenceProperties(physicalDevice, pExternalFenceInfo, pExternalFenceProperties);
    }
    /// ditto
    void GetPhysicalDeviceExternalSemaphoreProperties (VkPhysicalDevice physicalDevice, const(VkPhysicalDeviceExternalSemaphoreInfo)* pExternalSemaphoreInfo, VkExternalSemaphoreProperties* pExternalSemaphoreProperties) {
        assert(_GetPhysicalDeviceExternalSemaphoreProperties !is null, "vkGetPhysicalDeviceExternalSemaphoreProperties was not loaded. Required by VK_VERSION_1_1");
        return _GetPhysicalDeviceExternalSemaphoreProperties(physicalDevice, pExternalSemaphoreInfo, pExternalSemaphoreProperties);
    }

    /// Commands for VK_KHR_surface
    void DestroySurfaceKHR (VkInstance instance, VkSurfaceKHR surface, const(VkAllocationCallbacks)* pAllocator) {
        assert(_DestroySurfaceKHR !is null, "vkDestroySurfaceKHR was not loaded. Required by VK_KHR_surface");
        return _DestroySurfaceKHR(instance, surface, pAllocator);
    }
    /// ditto
    VkResult GetPhysicalDeviceSurfaceSupportKHR (VkPhysicalDevice physicalDevice, uint32_t queueFamilyIndex, VkSurfaceKHR surface, VkBool32* pSupported) {
        assert(_GetPhysicalDeviceSurfaceSupportKHR !is null, "vkGetPhysicalDeviceSurfaceSupportKHR was not loaded. Required by VK_KHR_surface");
        return _GetPhysicalDeviceSurfaceSupportKHR(physicalDevice, queueFamilyIndex, surface, pSupported);
    }
    /// ditto
    VkResult GetPhysicalDeviceSurfaceCapabilitiesKHR (VkPhysicalDevice physicalDevice, VkSurfaceKHR surface, VkSurfaceCapabilitiesKHR* pSurfaceCapabilities) {
        assert(_GetPhysicalDeviceSurfaceCapabilitiesKHR !is null, "vkGetPhysicalDeviceSurfaceCapabilitiesKHR was not loaded. Required by VK_KHR_surface");
        return _GetPhysicalDeviceSurfaceCapabilitiesKHR(physicalDevice, surface, pSurfaceCapabilities);
    }
    /// ditto
    VkResult GetPhysicalDeviceSurfaceFormatsKHR (VkPhysicalDevice physicalDevice, VkSurfaceKHR surface, uint32_t* pSurfaceFormatCount, VkSurfaceFormatKHR* pSurfaceFormats) {
        assert(_GetPhysicalDeviceSurfaceFormatsKHR !is null, "vkGetPhysicalDeviceSurfaceFormatsKHR was not loaded. Required by VK_KHR_surface");
        return _GetPhysicalDeviceSurfaceFormatsKHR(physicalDevice, surface, pSurfaceFormatCount, pSurfaceFormats);
    }
    /// ditto
    VkResult GetPhysicalDeviceSurfacePresentModesKHR (VkPhysicalDevice physicalDevice, VkSurfaceKHR surface, uint32_t* pPresentModeCount, VkPresentModeKHR* pPresentModes) {
        assert(_GetPhysicalDeviceSurfacePresentModesKHR !is null, "vkGetPhysicalDeviceSurfacePresentModesKHR was not loaded. Required by VK_KHR_surface");
        return _GetPhysicalDeviceSurfacePresentModesKHR(physicalDevice, surface, pPresentModeCount, pPresentModes);
    }

    /// Commands for VK_KHR_swapchain
    VkResult GetPhysicalDevicePresentRectanglesKHR (VkPhysicalDevice physicalDevice, VkSurfaceKHR surface, uint32_t* pRectCount, VkRect2D* pRects) {
        assert(_GetPhysicalDevicePresentRectanglesKHR !is null, "vkGetPhysicalDevicePresentRectanglesKHR was not loaded. Required by VK_KHR_swapchain");
        return _GetPhysicalDevicePresentRectanglesKHR(physicalDevice, surface, pRectCount, pRects);
    }

    /// Commands for VK_KHR_display
    VkResult GetPhysicalDeviceDisplayPropertiesKHR (VkPhysicalDevice physicalDevice, uint32_t* pPropertyCount, VkDisplayPropertiesKHR* pProperties) {
        assert(_GetPhysicalDeviceDisplayPropertiesKHR !is null, "vkGetPhysicalDeviceDisplayPropertiesKHR was not loaded. Required by VK_KHR_display");
        return _GetPhysicalDeviceDisplayPropertiesKHR(physicalDevice, pPropertyCount, pProperties);
    }
    /// ditto
    VkResult GetPhysicalDeviceDisplayPlanePropertiesKHR (VkPhysicalDevice physicalDevice, uint32_t* pPropertyCount, VkDisplayPlanePropertiesKHR* pProperties) {
        assert(_GetPhysicalDeviceDisplayPlanePropertiesKHR !is null, "vkGetPhysicalDeviceDisplayPlanePropertiesKHR was not loaded. Required by VK_KHR_display");
        return _GetPhysicalDeviceDisplayPlanePropertiesKHR(physicalDevice, pPropertyCount, pProperties);
    }
    /// ditto
    VkResult GetDisplayPlaneSupportedDisplaysKHR (VkPhysicalDevice physicalDevice, uint32_t planeIndex, uint32_t* pDisplayCount, VkDisplayKHR* pDisplays) {
        assert(_GetDisplayPlaneSupportedDisplaysKHR !is null, "vkGetDisplayPlaneSupportedDisplaysKHR was not loaded. Required by VK_KHR_display");
        return _GetDisplayPlaneSupportedDisplaysKHR(physicalDevice, planeIndex, pDisplayCount, pDisplays);
    }
    /// ditto
    VkResult GetDisplayModePropertiesKHR (VkPhysicalDevice physicalDevice, VkDisplayKHR display, uint32_t* pPropertyCount, VkDisplayModePropertiesKHR* pProperties) {
        assert(_GetDisplayModePropertiesKHR !is null, "vkGetDisplayModePropertiesKHR was not loaded. Required by VK_KHR_display");
        return _GetDisplayModePropertiesKHR(physicalDevice, display, pPropertyCount, pProperties);
    }
    /// ditto
    VkResult CreateDisplayModeKHR (VkPhysicalDevice physicalDevice, VkDisplayKHR display, const(VkDisplayModeCreateInfoKHR)* pCreateInfo, const(VkAllocationCallbacks)* pAllocator, VkDisplayModeKHR* pMode) {
        assert(_CreateDisplayModeKHR !is null, "vkCreateDisplayModeKHR was not loaded. Required by VK_KHR_display");
        return _CreateDisplayModeKHR(physicalDevice, display, pCreateInfo, pAllocator, pMode);
    }
    /// ditto
    VkResult GetDisplayPlaneCapabilitiesKHR (VkPhysicalDevice physicalDevice, VkDisplayModeKHR mode, uint32_t planeIndex, VkDisplayPlaneCapabilitiesKHR* pCapabilities) {
        assert(_GetDisplayPlaneCapabilitiesKHR !is null, "vkGetDisplayPlaneCapabilitiesKHR was not loaded. Required by VK_KHR_display");
        return _GetDisplayPlaneCapabilitiesKHR(physicalDevice, mode, planeIndex, pCapabilities);
    }
    /// ditto
    VkResult CreateDisplayPlaneSurfaceKHR (VkInstance instance, const(VkDisplaySurfaceCreateInfoKHR)* pCreateInfo, const(VkAllocationCallbacks)* pAllocator, VkSurfaceKHR* pSurface) {
        assert(_CreateDisplayPlaneSurfaceKHR !is null, "vkCreateDisplayPlaneSurfaceKHR was not loaded. Required by VK_KHR_display");
        return _CreateDisplayPlaneSurfaceKHR(instance, pCreateInfo, pAllocator, pSurface);
    }

    version(linux) {
        /// Commands for VK_KHR_xcb_surface
        VkResult CreateXcbSurfaceKHR (VkInstance instance, const(VkXcbSurfaceCreateInfoKHR)* pCreateInfo, const(VkAllocationCallbacks)* pAllocator, VkSurfaceKHR* pSurface) {
            assert(_CreateXcbSurfaceKHR !is null, "vkCreateXcbSurfaceKHR was not loaded. Required by VK_KHR_xcb_surface");
            return _CreateXcbSurfaceKHR(instance, pCreateInfo, pAllocator, pSurface);
        }
        /// ditto
        VkBool32 GetPhysicalDeviceXcbPresentationSupportKHR (VkPhysicalDevice physicalDevice, uint32_t queueFamilyIndex, xcb_connection_t* connection, xcb_visualid_t visual_id) {
            assert(_GetPhysicalDeviceXcbPresentationSupportKHR !is null, "vkGetPhysicalDeviceXcbPresentationSupportKHR was not loaded. Required by VK_KHR_xcb_surface");
            return _GetPhysicalDeviceXcbPresentationSupportKHR(physicalDevice, queueFamilyIndex, connection, visual_id);
        }
    }

    version(linux) {
        /// Commands for VK_KHR_wayland_surface
        VkResult CreateWaylandSurfaceKHR (VkInstance instance, const(VkWaylandSurfaceCreateInfoKHR)* pCreateInfo, const(VkAllocationCallbacks)* pAllocator, VkSurfaceKHR* pSurface) {
            assert(_CreateWaylandSurfaceKHR !is null, "vkCreateWaylandSurfaceKHR was not loaded. Required by VK_KHR_wayland_surface");
            return _CreateWaylandSurfaceKHR(instance, pCreateInfo, pAllocator, pSurface);
        }
        /// ditto
        VkBool32 GetPhysicalDeviceWaylandPresentationSupportKHR (VkPhysicalDevice physicalDevice, uint32_t queueFamilyIndex, wl_display* display) {
            assert(_GetPhysicalDeviceWaylandPresentationSupportKHR !is null, "vkGetPhysicalDeviceWaylandPresentationSupportKHR was not loaded. Required by VK_KHR_wayland_surface");
            return _GetPhysicalDeviceWaylandPresentationSupportKHR(physicalDevice, queueFamilyIndex, display);
        }
    }

    version(Windows) {
        /// Commands for VK_KHR_win32_surface
        VkResult CreateWin32SurfaceKHR (VkInstance instance, const(VkWin32SurfaceCreateInfoKHR)* pCreateInfo, const(VkAllocationCallbacks)* pAllocator, VkSurfaceKHR* pSurface) {
            assert(_CreateWin32SurfaceKHR !is null, "vkCreateWin32SurfaceKHR was not loaded. Required by VK_KHR_win32_surface");
            return _CreateWin32SurfaceKHR(instance, pCreateInfo, pAllocator, pSurface);
        }
        /// ditto
        VkBool32 GetPhysicalDeviceWin32PresentationSupportKHR (VkPhysicalDevice physicalDevice, uint32_t queueFamilyIndex) {
            assert(_GetPhysicalDeviceWin32PresentationSupportKHR !is null, "vkGetPhysicalDeviceWin32PresentationSupportKHR was not loaded. Required by VK_KHR_win32_surface");
            return _GetPhysicalDeviceWin32PresentationSupportKHR(physicalDevice, queueFamilyIndex);
        }
    }

    /// Commands for VK_EXT_debug_report
    VkResult CreateDebugReportCallbackEXT (VkInstance instance, const(VkDebugReportCallbackCreateInfoEXT)* pCreateInfo, const(VkAllocationCallbacks)* pAllocator, VkDebugReportCallbackEXT* pCallback) {
        assert(_CreateDebugReportCallbackEXT !is null, "vkCreateDebugReportCallbackEXT was not loaded. Required by VK_EXT_debug_report");
        return _CreateDebugReportCallbackEXT(instance, pCreateInfo, pAllocator, pCallback);
    }
    /// ditto
    void DestroyDebugReportCallbackEXT (VkInstance instance, VkDebugReportCallbackEXT callback, const(VkAllocationCallbacks)* pAllocator) {
        assert(_DestroyDebugReportCallbackEXT !is null, "vkDestroyDebugReportCallbackEXT was not loaded. Required by VK_EXT_debug_report");
        return _DestroyDebugReportCallbackEXT(instance, callback, pAllocator);
    }
    /// ditto
    void DebugReportMessageEXT (VkInstance instance, VkDebugReportFlagsEXT flags, VkDebugReportObjectTypeEXT objectType, uint64_t object, size_t location, int32_t messageCode, const(char)* pLayerPrefix, const(char)* pMessage) {
        assert(_DebugReportMessageEXT !is null, "vkDebugReportMessageEXT was not loaded. Required by VK_EXT_debug_report");
        return _DebugReportMessageEXT(instance, flags, objectType, object, location, messageCode, pLayerPrefix, pMessage);
    }

    // fields for VK_VERSION_1_0
    private PFN_vkDestroyInstance                                _DestroyInstance;
    private PFN_vkEnumeratePhysicalDevices                       _EnumeratePhysicalDevices;
    private PFN_vkGetPhysicalDeviceFeatures                      _GetPhysicalDeviceFeatures;
    private PFN_vkGetPhysicalDeviceFormatProperties              _GetPhysicalDeviceFormatProperties;
    private PFN_vkGetPhysicalDeviceImageFormatProperties         _GetPhysicalDeviceImageFormatProperties;
    private PFN_vkGetPhysicalDeviceProperties                    _GetPhysicalDeviceProperties;
    private PFN_vkGetPhysicalDeviceQueueFamilyProperties         _GetPhysicalDeviceQueueFamilyProperties;
    private PFN_vkGetPhysicalDeviceMemoryProperties              _GetPhysicalDeviceMemoryProperties;
    private PFN_vkGetDeviceProcAddr                              _GetDeviceProcAddr;
    private PFN_vkCreateDevice                                   _CreateDevice;
    private PFN_vkEnumerateDeviceExtensionProperties             _EnumerateDeviceExtensionProperties;
    private PFN_vkEnumerateDeviceLayerProperties                 _EnumerateDeviceLayerProperties;
    private PFN_vkGetPhysicalDeviceSparseImageFormatProperties   _GetPhysicalDeviceSparseImageFormatProperties;

    // fields for VK_VERSION_1_1
    private PFN_vkEnumerateInstanceVersion                       _EnumerateInstanceVersion;
    private PFN_vkEnumeratePhysicalDeviceGroups                  _EnumeratePhysicalDeviceGroups;
    private PFN_vkGetPhysicalDeviceFeatures2                     _GetPhysicalDeviceFeatures2;
    private PFN_vkGetPhysicalDeviceProperties2                   _GetPhysicalDeviceProperties2;
    private PFN_vkGetPhysicalDeviceFormatProperties2             _GetPhysicalDeviceFormatProperties2;
    private PFN_vkGetPhysicalDeviceImageFormatProperties2        _GetPhysicalDeviceImageFormatProperties2;
    private PFN_vkGetPhysicalDeviceQueueFamilyProperties2        _GetPhysicalDeviceQueueFamilyProperties2;
    private PFN_vkGetPhysicalDeviceMemoryProperties2             _GetPhysicalDeviceMemoryProperties2;
    private PFN_vkGetPhysicalDeviceSparseImageFormatProperties2  _GetPhysicalDeviceSparseImageFormatProperties2;
    private PFN_vkGetPhysicalDeviceExternalBufferProperties      _GetPhysicalDeviceExternalBufferProperties;
    private PFN_vkGetPhysicalDeviceExternalFenceProperties       _GetPhysicalDeviceExternalFenceProperties;
    private PFN_vkGetPhysicalDeviceExternalSemaphoreProperties   _GetPhysicalDeviceExternalSemaphoreProperties;

    // fields for VK_KHR_surface
    private PFN_vkDestroySurfaceKHR                              _DestroySurfaceKHR;
    private PFN_vkGetPhysicalDeviceSurfaceSupportKHR             _GetPhysicalDeviceSurfaceSupportKHR;
    private PFN_vkGetPhysicalDeviceSurfaceCapabilitiesKHR        _GetPhysicalDeviceSurfaceCapabilitiesKHR;
    private PFN_vkGetPhysicalDeviceSurfaceFormatsKHR             _GetPhysicalDeviceSurfaceFormatsKHR;
    private PFN_vkGetPhysicalDeviceSurfacePresentModesKHR        _GetPhysicalDeviceSurfacePresentModesKHR;

    // fields for VK_KHR_swapchain
    private PFN_vkGetPhysicalDevicePresentRectanglesKHR          _GetPhysicalDevicePresentRectanglesKHR;

    // fields for VK_KHR_display
    private PFN_vkGetPhysicalDeviceDisplayPropertiesKHR          _GetPhysicalDeviceDisplayPropertiesKHR;
    private PFN_vkGetPhysicalDeviceDisplayPlanePropertiesKHR     _GetPhysicalDeviceDisplayPlanePropertiesKHR;
    private PFN_vkGetDisplayPlaneSupportedDisplaysKHR            _GetDisplayPlaneSupportedDisplaysKHR;
    private PFN_vkGetDisplayModePropertiesKHR                    _GetDisplayModePropertiesKHR;
    private PFN_vkCreateDisplayModeKHR                           _CreateDisplayModeKHR;
    private PFN_vkGetDisplayPlaneCapabilitiesKHR                 _GetDisplayPlaneCapabilitiesKHR;
    private PFN_vkCreateDisplayPlaneSurfaceKHR                   _CreateDisplayPlaneSurfaceKHR;

    // fields for VK_KHR_xcb_surface
    version(linux) {
        private PFN_vkCreateXcbSurfaceKHR                            _CreateXcbSurfaceKHR;
        private PFN_vkGetPhysicalDeviceXcbPresentationSupportKHR     _GetPhysicalDeviceXcbPresentationSupportKHR;
    }

    // fields for VK_KHR_wayland_surface
    version(linux) {
        private PFN_vkCreateWaylandSurfaceKHR                        _CreateWaylandSurfaceKHR;
        private PFN_vkGetPhysicalDeviceWaylandPresentationSupportKHR _GetPhysicalDeviceWaylandPresentationSupportKHR;
    }

    // fields for VK_KHR_win32_surface
    version(Windows) {
        private PFN_vkCreateWin32SurfaceKHR                          _CreateWin32SurfaceKHR;
        private PFN_vkGetPhysicalDeviceWin32PresentationSupportKHR   _GetPhysicalDeviceWin32PresentationSupportKHR;
    }

    // fields for VK_EXT_debug_report
    private PFN_vkCreateDebugReportCallbackEXT                   _CreateDebugReportCallbackEXT;
    private PFN_vkDestroyDebugReportCallbackEXT                  _DestroyDebugReportCallbackEXT;
    private PFN_vkDebugReportMessageEXT                          _DebugReportMessageEXT;
}

// Device commands

final class VkDeviceCmds {

    this (VkDevice device, VkInstanceCmds instanceCmds) {
        auto loader = instanceCmds._GetDeviceProcAddr;
        // VK_VERSION_1_0
        _DestroyDevice                        = cast(PFN_vkDestroyDevice)                       loader(device, "vkDestroyDevice");
        _GetDeviceQueue                       = cast(PFN_vkGetDeviceQueue)                      loader(device, "vkGetDeviceQueue");
        _QueueSubmit                          = cast(PFN_vkQueueSubmit)                         loader(device, "vkQueueSubmit");
        _QueueWaitIdle                        = cast(PFN_vkQueueWaitIdle)                       loader(device, "vkQueueWaitIdle");
        _DeviceWaitIdle                       = cast(PFN_vkDeviceWaitIdle)                      loader(device, "vkDeviceWaitIdle");
        _AllocateMemory                       = cast(PFN_vkAllocateMemory)                      loader(device, "vkAllocateMemory");
        _FreeMemory                           = cast(PFN_vkFreeMemory)                          loader(device, "vkFreeMemory");
        _MapMemory                            = cast(PFN_vkMapMemory)                           loader(device, "vkMapMemory");
        _UnmapMemory                          = cast(PFN_vkUnmapMemory)                         loader(device, "vkUnmapMemory");
        _FlushMappedMemoryRanges              = cast(PFN_vkFlushMappedMemoryRanges)             loader(device, "vkFlushMappedMemoryRanges");
        _InvalidateMappedMemoryRanges         = cast(PFN_vkInvalidateMappedMemoryRanges)        loader(device, "vkInvalidateMappedMemoryRanges");
        _GetDeviceMemoryCommitment            = cast(PFN_vkGetDeviceMemoryCommitment)           loader(device, "vkGetDeviceMemoryCommitment");
        _BindBufferMemory                     = cast(PFN_vkBindBufferMemory)                    loader(device, "vkBindBufferMemory");
        _BindImageMemory                      = cast(PFN_vkBindImageMemory)                     loader(device, "vkBindImageMemory");
        _GetBufferMemoryRequirements          = cast(PFN_vkGetBufferMemoryRequirements)         loader(device, "vkGetBufferMemoryRequirements");
        _GetImageMemoryRequirements           = cast(PFN_vkGetImageMemoryRequirements)          loader(device, "vkGetImageMemoryRequirements");
        _GetImageSparseMemoryRequirements     = cast(PFN_vkGetImageSparseMemoryRequirements)    loader(device, "vkGetImageSparseMemoryRequirements");
        _QueueBindSparse                      = cast(PFN_vkQueueBindSparse)                     loader(device, "vkQueueBindSparse");
        _CreateFence                          = cast(PFN_vkCreateFence)                         loader(device, "vkCreateFence");
        _DestroyFence                         = cast(PFN_vkDestroyFence)                        loader(device, "vkDestroyFence");
        _ResetFences                          = cast(PFN_vkResetFences)                         loader(device, "vkResetFences");
        _GetFenceStatus                       = cast(PFN_vkGetFenceStatus)                      loader(device, "vkGetFenceStatus");
        _WaitForFences                        = cast(PFN_vkWaitForFences)                       loader(device, "vkWaitForFences");
        _CreateSemaphore                      = cast(PFN_vkCreateSemaphore)                     loader(device, "vkCreateSemaphore");
        _DestroySemaphore                     = cast(PFN_vkDestroySemaphore)                    loader(device, "vkDestroySemaphore");
        _CreateEvent                          = cast(PFN_vkCreateEvent)                         loader(device, "vkCreateEvent");
        _DestroyEvent                         = cast(PFN_vkDestroyEvent)                        loader(device, "vkDestroyEvent");
        _GetEventStatus                       = cast(PFN_vkGetEventStatus)                      loader(device, "vkGetEventStatus");
        _SetEvent                             = cast(PFN_vkSetEvent)                            loader(device, "vkSetEvent");
        _ResetEvent                           = cast(PFN_vkResetEvent)                          loader(device, "vkResetEvent");
        _CreateQueryPool                      = cast(PFN_vkCreateQueryPool)                     loader(device, "vkCreateQueryPool");
        _DestroyQueryPool                     = cast(PFN_vkDestroyQueryPool)                    loader(device, "vkDestroyQueryPool");
        _GetQueryPoolResults                  = cast(PFN_vkGetQueryPoolResults)                 loader(device, "vkGetQueryPoolResults");
        _CreateBuffer                         = cast(PFN_vkCreateBuffer)                        loader(device, "vkCreateBuffer");
        _DestroyBuffer                        = cast(PFN_vkDestroyBuffer)                       loader(device, "vkDestroyBuffer");
        _CreateBufferView                     = cast(PFN_vkCreateBufferView)                    loader(device, "vkCreateBufferView");
        _DestroyBufferView                    = cast(PFN_vkDestroyBufferView)                   loader(device, "vkDestroyBufferView");
        _CreateImage                          = cast(PFN_vkCreateImage)                         loader(device, "vkCreateImage");
        _DestroyImage                         = cast(PFN_vkDestroyImage)                        loader(device, "vkDestroyImage");
        _GetImageSubresourceLayout            = cast(PFN_vkGetImageSubresourceLayout)           loader(device, "vkGetImageSubresourceLayout");
        _CreateImageView                      = cast(PFN_vkCreateImageView)                     loader(device, "vkCreateImageView");
        _DestroyImageView                     = cast(PFN_vkDestroyImageView)                    loader(device, "vkDestroyImageView");
        _CreateShaderModule                   = cast(PFN_vkCreateShaderModule)                  loader(device, "vkCreateShaderModule");
        _DestroyShaderModule                  = cast(PFN_vkDestroyShaderModule)                 loader(device, "vkDestroyShaderModule");
        _CreatePipelineCache                  = cast(PFN_vkCreatePipelineCache)                 loader(device, "vkCreatePipelineCache");
        _DestroyPipelineCache                 = cast(PFN_vkDestroyPipelineCache)                loader(device, "vkDestroyPipelineCache");
        _GetPipelineCacheData                 = cast(PFN_vkGetPipelineCacheData)                loader(device, "vkGetPipelineCacheData");
        _MergePipelineCaches                  = cast(PFN_vkMergePipelineCaches)                 loader(device, "vkMergePipelineCaches");
        _CreateGraphicsPipelines              = cast(PFN_vkCreateGraphicsPipelines)             loader(device, "vkCreateGraphicsPipelines");
        _CreateComputePipelines               = cast(PFN_vkCreateComputePipelines)              loader(device, "vkCreateComputePipelines");
        _DestroyPipeline                      = cast(PFN_vkDestroyPipeline)                     loader(device, "vkDestroyPipeline");
        _CreatePipelineLayout                 = cast(PFN_vkCreatePipelineLayout)                loader(device, "vkCreatePipelineLayout");
        _DestroyPipelineLayout                = cast(PFN_vkDestroyPipelineLayout)               loader(device, "vkDestroyPipelineLayout");
        _CreateSampler                        = cast(PFN_vkCreateSampler)                       loader(device, "vkCreateSampler");
        _DestroySampler                       = cast(PFN_vkDestroySampler)                      loader(device, "vkDestroySampler");
        _CreateDescriptorSetLayout            = cast(PFN_vkCreateDescriptorSetLayout)           loader(device, "vkCreateDescriptorSetLayout");
        _DestroyDescriptorSetLayout           = cast(PFN_vkDestroyDescriptorSetLayout)          loader(device, "vkDestroyDescriptorSetLayout");
        _CreateDescriptorPool                 = cast(PFN_vkCreateDescriptorPool)                loader(device, "vkCreateDescriptorPool");
        _DestroyDescriptorPool                = cast(PFN_vkDestroyDescriptorPool)               loader(device, "vkDestroyDescriptorPool");
        _ResetDescriptorPool                  = cast(PFN_vkResetDescriptorPool)                 loader(device, "vkResetDescriptorPool");
        _AllocateDescriptorSets               = cast(PFN_vkAllocateDescriptorSets)              loader(device, "vkAllocateDescriptorSets");
        _FreeDescriptorSets                   = cast(PFN_vkFreeDescriptorSets)                  loader(device, "vkFreeDescriptorSets");
        _UpdateDescriptorSets                 = cast(PFN_vkUpdateDescriptorSets)                loader(device, "vkUpdateDescriptorSets");
        _CreateFramebuffer                    = cast(PFN_vkCreateFramebuffer)                   loader(device, "vkCreateFramebuffer");
        _DestroyFramebuffer                   = cast(PFN_vkDestroyFramebuffer)                  loader(device, "vkDestroyFramebuffer");
        _CreateRenderPass                     = cast(PFN_vkCreateRenderPass)                    loader(device, "vkCreateRenderPass");
        _DestroyRenderPass                    = cast(PFN_vkDestroyRenderPass)                   loader(device, "vkDestroyRenderPass");
        _GetRenderAreaGranularity             = cast(PFN_vkGetRenderAreaGranularity)            loader(device, "vkGetRenderAreaGranularity");
        _CreateCommandPool                    = cast(PFN_vkCreateCommandPool)                   loader(device, "vkCreateCommandPool");
        _DestroyCommandPool                   = cast(PFN_vkDestroyCommandPool)                  loader(device, "vkDestroyCommandPool");
        _ResetCommandPool                     = cast(PFN_vkResetCommandPool)                    loader(device, "vkResetCommandPool");
        _AllocateCommandBuffers               = cast(PFN_vkAllocateCommandBuffers)              loader(device, "vkAllocateCommandBuffers");
        _FreeCommandBuffers                   = cast(PFN_vkFreeCommandBuffers)                  loader(device, "vkFreeCommandBuffers");
        _BeginCommandBuffer                   = cast(PFN_vkBeginCommandBuffer)                  loader(device, "vkBeginCommandBuffer");
        _EndCommandBuffer                     = cast(PFN_vkEndCommandBuffer)                    loader(device, "vkEndCommandBuffer");
        _ResetCommandBuffer                   = cast(PFN_vkResetCommandBuffer)                  loader(device, "vkResetCommandBuffer");
        _CmdBindPipeline                      = cast(PFN_vkCmdBindPipeline)                     loader(device, "vkCmdBindPipeline");
        _CmdSetViewport                       = cast(PFN_vkCmdSetViewport)                      loader(device, "vkCmdSetViewport");
        _CmdSetScissor                        = cast(PFN_vkCmdSetScissor)                       loader(device, "vkCmdSetScissor");
        _CmdSetLineWidth                      = cast(PFN_vkCmdSetLineWidth)                     loader(device, "vkCmdSetLineWidth");
        _CmdSetDepthBias                      = cast(PFN_vkCmdSetDepthBias)                     loader(device, "vkCmdSetDepthBias");
        _CmdSetBlendConstants                 = cast(PFN_vkCmdSetBlendConstants)                loader(device, "vkCmdSetBlendConstants");
        _CmdSetDepthBounds                    = cast(PFN_vkCmdSetDepthBounds)                   loader(device, "vkCmdSetDepthBounds");
        _CmdSetStencilCompareMask             = cast(PFN_vkCmdSetStencilCompareMask)            loader(device, "vkCmdSetStencilCompareMask");
        _CmdSetStencilWriteMask               = cast(PFN_vkCmdSetStencilWriteMask)              loader(device, "vkCmdSetStencilWriteMask");
        _CmdSetStencilReference               = cast(PFN_vkCmdSetStencilReference)              loader(device, "vkCmdSetStencilReference");
        _CmdBindDescriptorSets                = cast(PFN_vkCmdBindDescriptorSets)               loader(device, "vkCmdBindDescriptorSets");
        _CmdBindIndexBuffer                   = cast(PFN_vkCmdBindIndexBuffer)                  loader(device, "vkCmdBindIndexBuffer");
        _CmdBindVertexBuffers                 = cast(PFN_vkCmdBindVertexBuffers)                loader(device, "vkCmdBindVertexBuffers");
        _CmdDraw                              = cast(PFN_vkCmdDraw)                             loader(device, "vkCmdDraw");
        _CmdDrawIndexed                       = cast(PFN_vkCmdDrawIndexed)                      loader(device, "vkCmdDrawIndexed");
        _CmdDrawIndirect                      = cast(PFN_vkCmdDrawIndirect)                     loader(device, "vkCmdDrawIndirect");
        _CmdDrawIndexedIndirect               = cast(PFN_vkCmdDrawIndexedIndirect)              loader(device, "vkCmdDrawIndexedIndirect");
        _CmdDispatch                          = cast(PFN_vkCmdDispatch)                         loader(device, "vkCmdDispatch");
        _CmdDispatchIndirect                  = cast(PFN_vkCmdDispatchIndirect)                 loader(device, "vkCmdDispatchIndirect");
        _CmdCopyBuffer                        = cast(PFN_vkCmdCopyBuffer)                       loader(device, "vkCmdCopyBuffer");
        _CmdCopyImage                         = cast(PFN_vkCmdCopyImage)                        loader(device, "vkCmdCopyImage");
        _CmdBlitImage                         = cast(PFN_vkCmdBlitImage)                        loader(device, "vkCmdBlitImage");
        _CmdCopyBufferToImage                 = cast(PFN_vkCmdCopyBufferToImage)                loader(device, "vkCmdCopyBufferToImage");
        _CmdCopyImageToBuffer                 = cast(PFN_vkCmdCopyImageToBuffer)                loader(device, "vkCmdCopyImageToBuffer");
        _CmdUpdateBuffer                      = cast(PFN_vkCmdUpdateBuffer)                     loader(device, "vkCmdUpdateBuffer");
        _CmdFillBuffer                        = cast(PFN_vkCmdFillBuffer)                       loader(device, "vkCmdFillBuffer");
        _CmdClearColorImage                   = cast(PFN_vkCmdClearColorImage)                  loader(device, "vkCmdClearColorImage");
        _CmdClearDepthStencilImage            = cast(PFN_vkCmdClearDepthStencilImage)           loader(device, "vkCmdClearDepthStencilImage");
        _CmdClearAttachments                  = cast(PFN_vkCmdClearAttachments)                 loader(device, "vkCmdClearAttachments");
        _CmdResolveImage                      = cast(PFN_vkCmdResolveImage)                     loader(device, "vkCmdResolveImage");
        _CmdSetEvent                          = cast(PFN_vkCmdSetEvent)                         loader(device, "vkCmdSetEvent");
        _CmdResetEvent                        = cast(PFN_vkCmdResetEvent)                       loader(device, "vkCmdResetEvent");
        _CmdWaitEvents                        = cast(PFN_vkCmdWaitEvents)                       loader(device, "vkCmdWaitEvents");
        _CmdPipelineBarrier                   = cast(PFN_vkCmdPipelineBarrier)                  loader(device, "vkCmdPipelineBarrier");
        _CmdBeginQuery                        = cast(PFN_vkCmdBeginQuery)                       loader(device, "vkCmdBeginQuery");
        _CmdEndQuery                          = cast(PFN_vkCmdEndQuery)                         loader(device, "vkCmdEndQuery");
        _CmdResetQueryPool                    = cast(PFN_vkCmdResetQueryPool)                   loader(device, "vkCmdResetQueryPool");
        _CmdWriteTimestamp                    = cast(PFN_vkCmdWriteTimestamp)                   loader(device, "vkCmdWriteTimestamp");
        _CmdCopyQueryPoolResults              = cast(PFN_vkCmdCopyQueryPoolResults)             loader(device, "vkCmdCopyQueryPoolResults");
        _CmdPushConstants                     = cast(PFN_vkCmdPushConstants)                    loader(device, "vkCmdPushConstants");
        _CmdBeginRenderPass                   = cast(PFN_vkCmdBeginRenderPass)                  loader(device, "vkCmdBeginRenderPass");
        _CmdNextSubpass                       = cast(PFN_vkCmdNextSubpass)                      loader(device, "vkCmdNextSubpass");
        _CmdEndRenderPass                     = cast(PFN_vkCmdEndRenderPass)                    loader(device, "vkCmdEndRenderPass");
        _CmdExecuteCommands                   = cast(PFN_vkCmdExecuteCommands)                  loader(device, "vkCmdExecuteCommands");

        // VK_VERSION_1_1
        _BindBufferMemory2                    = cast(PFN_vkBindBufferMemory2)                   loader(device, "vkBindBufferMemory2");
        _BindImageMemory2                     = cast(PFN_vkBindImageMemory2)                    loader(device, "vkBindImageMemory2");
        _GetDeviceGroupPeerMemoryFeatures     = cast(PFN_vkGetDeviceGroupPeerMemoryFeatures)    loader(device, "vkGetDeviceGroupPeerMemoryFeatures");
        _CmdSetDeviceMask                     = cast(PFN_vkCmdSetDeviceMask)                    loader(device, "vkCmdSetDeviceMask");
        _CmdDispatchBase                      = cast(PFN_vkCmdDispatchBase)                     loader(device, "vkCmdDispatchBase");
        _GetImageMemoryRequirements2          = cast(PFN_vkGetImageMemoryRequirements2)         loader(device, "vkGetImageMemoryRequirements2");
        _GetBufferMemoryRequirements2         = cast(PFN_vkGetBufferMemoryRequirements2)        loader(device, "vkGetBufferMemoryRequirements2");
        _GetImageSparseMemoryRequirements2    = cast(PFN_vkGetImageSparseMemoryRequirements2)   loader(device, "vkGetImageSparseMemoryRequirements2");
        _TrimCommandPool                      = cast(PFN_vkTrimCommandPool)                     loader(device, "vkTrimCommandPool");
        _GetDeviceQueue2                      = cast(PFN_vkGetDeviceQueue2)                     loader(device, "vkGetDeviceQueue2");
        _CreateSamplerYcbcrConversion         = cast(PFN_vkCreateSamplerYcbcrConversion)        loader(device, "vkCreateSamplerYcbcrConversion");
        _DestroySamplerYcbcrConversion        = cast(PFN_vkDestroySamplerYcbcrConversion)       loader(device, "vkDestroySamplerYcbcrConversion");
        _CreateDescriptorUpdateTemplate       = cast(PFN_vkCreateDescriptorUpdateTemplate)      loader(device, "vkCreateDescriptorUpdateTemplate");
        _DestroyDescriptorUpdateTemplate      = cast(PFN_vkDestroyDescriptorUpdateTemplate)     loader(device, "vkDestroyDescriptorUpdateTemplate");
        _UpdateDescriptorSetWithTemplate      = cast(PFN_vkUpdateDescriptorSetWithTemplate)     loader(device, "vkUpdateDescriptorSetWithTemplate");
        _GetDescriptorSetLayoutSupport        = cast(PFN_vkGetDescriptorSetLayoutSupport)       loader(device, "vkGetDescriptorSetLayoutSupport");

        // VK_KHR_swapchain
        _CreateSwapchainKHR                   = cast(PFN_vkCreateSwapchainKHR)                  loader(device, "vkCreateSwapchainKHR");
        _DestroySwapchainKHR                  = cast(PFN_vkDestroySwapchainKHR)                 loader(device, "vkDestroySwapchainKHR");
        _GetSwapchainImagesKHR                = cast(PFN_vkGetSwapchainImagesKHR)               loader(device, "vkGetSwapchainImagesKHR");
        _AcquireNextImageKHR                  = cast(PFN_vkAcquireNextImageKHR)                 loader(device, "vkAcquireNextImageKHR");
        _QueuePresentKHR                      = cast(PFN_vkQueuePresentKHR)                     loader(device, "vkQueuePresentKHR");
        _GetDeviceGroupPresentCapabilitiesKHR = cast(PFN_vkGetDeviceGroupPresentCapabilitiesKHR)loader(device, "vkGetDeviceGroupPresentCapabilitiesKHR");
        _GetDeviceGroupSurfacePresentModesKHR = cast(PFN_vkGetDeviceGroupSurfacePresentModesKHR)loader(device, "vkGetDeviceGroupSurfacePresentModesKHR");
        _AcquireNextImage2KHR                 = cast(PFN_vkAcquireNextImage2KHR)                loader(device, "vkAcquireNextImage2KHR");
    }

    /// Commands for VK_VERSION_1_0
    void DestroyDevice (VkDevice device, const(VkAllocationCallbacks)* pAllocator) {
        assert(_DestroyDevice !is null, "vkDestroyDevice was not loaded. Requested by VK_VERSION_1_0");
        return _DestroyDevice(device, pAllocator);
    }
    /// ditto
    void GetDeviceQueue (VkDevice device, uint32_t queueFamilyIndex, uint32_t queueIndex, VkQueue* pQueue) {
        assert(_GetDeviceQueue !is null, "vkGetDeviceQueue was not loaded. Requested by VK_VERSION_1_0");
        return _GetDeviceQueue(device, queueFamilyIndex, queueIndex, pQueue);
    }
    /// ditto
    VkResult QueueSubmit (VkQueue queue, uint32_t submitCount, const(VkSubmitInfo)* pSubmits, VkFence fence) {
        assert(_QueueSubmit !is null, "vkQueueSubmit was not loaded. Requested by VK_VERSION_1_0");
        return _QueueSubmit(queue, submitCount, pSubmits, fence);
    }
    /// ditto
    VkResult QueueWaitIdle (VkQueue queue) {
        assert(_QueueWaitIdle !is null, "vkQueueWaitIdle was not loaded. Requested by VK_VERSION_1_0");
        return _QueueWaitIdle(queue);
    }
    /// ditto
    VkResult DeviceWaitIdle (VkDevice device) {
        assert(_DeviceWaitIdle !is null, "vkDeviceWaitIdle was not loaded. Requested by VK_VERSION_1_0");
        return _DeviceWaitIdle(device);
    }
    /// ditto
    VkResult AllocateMemory (VkDevice device, const(VkMemoryAllocateInfo)* pAllocateInfo, const(VkAllocationCallbacks)* pAllocator, VkDeviceMemory* pMemory) {
        assert(_AllocateMemory !is null, "vkAllocateMemory was not loaded. Requested by VK_VERSION_1_0");
        return _AllocateMemory(device, pAllocateInfo, pAllocator, pMemory);
    }
    /// ditto
    void FreeMemory (VkDevice device, VkDeviceMemory memory, const(VkAllocationCallbacks)* pAllocator) {
        assert(_FreeMemory !is null, "vkFreeMemory was not loaded. Requested by VK_VERSION_1_0");
        return _FreeMemory(device, memory, pAllocator);
    }
    /// ditto
    VkResult MapMemory (VkDevice device, VkDeviceMemory memory, VkDeviceSize offset, VkDeviceSize size, VkMemoryMapFlags flags, void** ppData) {
        assert(_MapMemory !is null, "vkMapMemory was not loaded. Requested by VK_VERSION_1_0");
        return _MapMemory(device, memory, offset, size, flags, ppData);
    }
    /// ditto
    void UnmapMemory (VkDevice device, VkDeviceMemory memory) {
        assert(_UnmapMemory !is null, "vkUnmapMemory was not loaded. Requested by VK_VERSION_1_0");
        return _UnmapMemory(device, memory);
    }
    /// ditto
    VkResult FlushMappedMemoryRanges (VkDevice device, uint32_t memoryRangeCount, const(VkMappedMemoryRange)* pMemoryRanges) {
        assert(_FlushMappedMemoryRanges !is null, "vkFlushMappedMemoryRanges was not loaded. Requested by VK_VERSION_1_0");
        return _FlushMappedMemoryRanges(device, memoryRangeCount, pMemoryRanges);
    }
    /// ditto
    VkResult InvalidateMappedMemoryRanges (VkDevice device, uint32_t memoryRangeCount, const(VkMappedMemoryRange)* pMemoryRanges) {
        assert(_InvalidateMappedMemoryRanges !is null, "vkInvalidateMappedMemoryRanges was not loaded. Requested by VK_VERSION_1_0");
        return _InvalidateMappedMemoryRanges(device, memoryRangeCount, pMemoryRanges);
    }
    /// ditto
    void GetDeviceMemoryCommitment (VkDevice device, VkDeviceMemory memory, VkDeviceSize* pCommittedMemoryInBytes) {
        assert(_GetDeviceMemoryCommitment !is null, "vkGetDeviceMemoryCommitment was not loaded. Requested by VK_VERSION_1_0");
        return _GetDeviceMemoryCommitment(device, memory, pCommittedMemoryInBytes);
    }
    /// ditto
    VkResult BindBufferMemory (VkDevice device, VkBuffer buffer, VkDeviceMemory memory, VkDeviceSize memoryOffset) {
        assert(_BindBufferMemory !is null, "vkBindBufferMemory was not loaded. Requested by VK_VERSION_1_0");
        return _BindBufferMemory(device, buffer, memory, memoryOffset);
    }
    /// ditto
    VkResult BindImageMemory (VkDevice device, VkImage image, VkDeviceMemory memory, VkDeviceSize memoryOffset) {
        assert(_BindImageMemory !is null, "vkBindImageMemory was not loaded. Requested by VK_VERSION_1_0");
        return _BindImageMemory(device, image, memory, memoryOffset);
    }
    /// ditto
    void GetBufferMemoryRequirements (VkDevice device, VkBuffer buffer, VkMemoryRequirements* pMemoryRequirements) {
        assert(_GetBufferMemoryRequirements !is null, "vkGetBufferMemoryRequirements was not loaded. Requested by VK_VERSION_1_0");
        return _GetBufferMemoryRequirements(device, buffer, pMemoryRequirements);
    }
    /// ditto
    void GetImageMemoryRequirements (VkDevice device, VkImage image, VkMemoryRequirements* pMemoryRequirements) {
        assert(_GetImageMemoryRequirements !is null, "vkGetImageMemoryRequirements was not loaded. Requested by VK_VERSION_1_0");
        return _GetImageMemoryRequirements(device, image, pMemoryRequirements);
    }
    /// ditto
    void GetImageSparseMemoryRequirements (VkDevice device, VkImage image, uint32_t* pSparseMemoryRequirementCount, VkSparseImageMemoryRequirements* pSparseMemoryRequirements) {
        assert(_GetImageSparseMemoryRequirements !is null, "vkGetImageSparseMemoryRequirements was not loaded. Requested by VK_VERSION_1_0");
        return _GetImageSparseMemoryRequirements(device, image, pSparseMemoryRequirementCount, pSparseMemoryRequirements);
    }
    /// ditto
    VkResult QueueBindSparse (VkQueue queue, uint32_t bindInfoCount, const(VkBindSparseInfo)* pBindInfo, VkFence fence) {
        assert(_QueueBindSparse !is null, "vkQueueBindSparse was not loaded. Requested by VK_VERSION_1_0");
        return _QueueBindSparse(queue, bindInfoCount, pBindInfo, fence);
    }
    /// ditto
    VkResult CreateFence (VkDevice device, const(VkFenceCreateInfo)* pCreateInfo, const(VkAllocationCallbacks)* pAllocator, VkFence* pFence) {
        assert(_CreateFence !is null, "vkCreateFence was not loaded. Requested by VK_VERSION_1_0");
        return _CreateFence(device, pCreateInfo, pAllocator, pFence);
    }
    /// ditto
    void DestroyFence (VkDevice device, VkFence fence, const(VkAllocationCallbacks)* pAllocator) {
        assert(_DestroyFence !is null, "vkDestroyFence was not loaded. Requested by VK_VERSION_1_0");
        return _DestroyFence(device, fence, pAllocator);
    }
    /// ditto
    VkResult ResetFences (VkDevice device, uint32_t fenceCount, const(VkFence)* pFences) {
        assert(_ResetFences !is null, "vkResetFences was not loaded. Requested by VK_VERSION_1_0");
        return _ResetFences(device, fenceCount, pFences);
    }
    /// ditto
    VkResult GetFenceStatus (VkDevice device, VkFence fence) {
        assert(_GetFenceStatus !is null, "vkGetFenceStatus was not loaded. Requested by VK_VERSION_1_0");
        return _GetFenceStatus(device, fence);
    }
    /// ditto
    VkResult WaitForFences (VkDevice device, uint32_t fenceCount, const(VkFence)* pFences, VkBool32 waitAll, uint64_t timeout) {
        assert(_WaitForFences !is null, "vkWaitForFences was not loaded. Requested by VK_VERSION_1_0");
        return _WaitForFences(device, fenceCount, pFences, waitAll, timeout);
    }
    /// ditto
    VkResult CreateSemaphore (VkDevice device, const(VkSemaphoreCreateInfo)* pCreateInfo, const(VkAllocationCallbacks)* pAllocator, VkSemaphore* pSemaphore) {
        assert(_CreateSemaphore !is null, "vkCreateSemaphore was not loaded. Requested by VK_VERSION_1_0");
        return _CreateSemaphore(device, pCreateInfo, pAllocator, pSemaphore);
    }
    /// ditto
    void DestroySemaphore (VkDevice device, VkSemaphore semaphore, const(VkAllocationCallbacks)* pAllocator) {
        assert(_DestroySemaphore !is null, "vkDestroySemaphore was not loaded. Requested by VK_VERSION_1_0");
        return _DestroySemaphore(device, semaphore, pAllocator);
    }
    /// ditto
    VkResult CreateEvent (VkDevice device, const(VkEventCreateInfo)* pCreateInfo, const(VkAllocationCallbacks)* pAllocator, VkEvent* pEvent) {
        assert(_CreateEvent !is null, "vkCreateEvent was not loaded. Requested by VK_VERSION_1_0");
        return _CreateEvent(device, pCreateInfo, pAllocator, pEvent);
    }
    /// ditto
    void DestroyEvent (VkDevice device, VkEvent event, const(VkAllocationCallbacks)* pAllocator) {
        assert(_DestroyEvent !is null, "vkDestroyEvent was not loaded. Requested by VK_VERSION_1_0");
        return _DestroyEvent(device, event, pAllocator);
    }
    /// ditto
    VkResult GetEventStatus (VkDevice device, VkEvent event) {
        assert(_GetEventStatus !is null, "vkGetEventStatus was not loaded. Requested by VK_VERSION_1_0");
        return _GetEventStatus(device, event);
    }
    /// ditto
    VkResult SetEvent (VkDevice device, VkEvent event) {
        assert(_SetEvent !is null, "vkSetEvent was not loaded. Requested by VK_VERSION_1_0");
        return _SetEvent(device, event);
    }
    /// ditto
    VkResult ResetEvent (VkDevice device, VkEvent event) {
        assert(_ResetEvent !is null, "vkResetEvent was not loaded. Requested by VK_VERSION_1_0");
        return _ResetEvent(device, event);
    }
    /// ditto
    VkResult CreateQueryPool (VkDevice device, const(VkQueryPoolCreateInfo)* pCreateInfo, const(VkAllocationCallbacks)* pAllocator, VkQueryPool* pQueryPool) {
        assert(_CreateQueryPool !is null, "vkCreateQueryPool was not loaded. Requested by VK_VERSION_1_0");
        return _CreateQueryPool(device, pCreateInfo, pAllocator, pQueryPool);
    }
    /// ditto
    void DestroyQueryPool (VkDevice device, VkQueryPool queryPool, const(VkAllocationCallbacks)* pAllocator) {
        assert(_DestroyQueryPool !is null, "vkDestroyQueryPool was not loaded. Requested by VK_VERSION_1_0");
        return _DestroyQueryPool(device, queryPool, pAllocator);
    }
    /// ditto
    VkResult GetQueryPoolResults (VkDevice device, VkQueryPool queryPool, uint32_t firstQuery, uint32_t queryCount, size_t dataSize, void* pData, VkDeviceSize stride, VkQueryResultFlags flags) {
        assert(_GetQueryPoolResults !is null, "vkGetQueryPoolResults was not loaded. Requested by VK_VERSION_1_0");
        return _GetQueryPoolResults(device, queryPool, firstQuery, queryCount, dataSize, pData, stride, flags);
    }
    /// ditto
    VkResult CreateBuffer (VkDevice device, const(VkBufferCreateInfo)* pCreateInfo, const(VkAllocationCallbacks)* pAllocator, VkBuffer* pBuffer) {
        assert(_CreateBuffer !is null, "vkCreateBuffer was not loaded. Requested by VK_VERSION_1_0");
        return _CreateBuffer(device, pCreateInfo, pAllocator, pBuffer);
    }
    /// ditto
    void DestroyBuffer (VkDevice device, VkBuffer buffer, const(VkAllocationCallbacks)* pAllocator) {
        assert(_DestroyBuffer !is null, "vkDestroyBuffer was not loaded. Requested by VK_VERSION_1_0");
        return _DestroyBuffer(device, buffer, pAllocator);
    }
    /// ditto
    VkResult CreateBufferView (VkDevice device, const(VkBufferViewCreateInfo)* pCreateInfo, const(VkAllocationCallbacks)* pAllocator, VkBufferView* pView) {
        assert(_CreateBufferView !is null, "vkCreateBufferView was not loaded. Requested by VK_VERSION_1_0");
        return _CreateBufferView(device, pCreateInfo, pAllocator, pView);
    }
    /// ditto
    void DestroyBufferView (VkDevice device, VkBufferView bufferView, const(VkAllocationCallbacks)* pAllocator) {
        assert(_DestroyBufferView !is null, "vkDestroyBufferView was not loaded. Requested by VK_VERSION_1_0");
        return _DestroyBufferView(device, bufferView, pAllocator);
    }
    /// ditto
    VkResult CreateImage (VkDevice device, const(VkImageCreateInfo)* pCreateInfo, const(VkAllocationCallbacks)* pAllocator, VkImage* pImage) {
        assert(_CreateImage !is null, "vkCreateImage was not loaded. Requested by VK_VERSION_1_0");
        return _CreateImage(device, pCreateInfo, pAllocator, pImage);
    }
    /// ditto
    void DestroyImage (VkDevice device, VkImage image, const(VkAllocationCallbacks)* pAllocator) {
        assert(_DestroyImage !is null, "vkDestroyImage was not loaded. Requested by VK_VERSION_1_0");
        return _DestroyImage(device, image, pAllocator);
    }
    /// ditto
    void GetImageSubresourceLayout (VkDevice device, VkImage image, const(VkImageSubresource)* pSubresource, VkSubresourceLayout* pLayout) {
        assert(_GetImageSubresourceLayout !is null, "vkGetImageSubresourceLayout was not loaded. Requested by VK_VERSION_1_0");
        return _GetImageSubresourceLayout(device, image, pSubresource, pLayout);
    }
    /// ditto
    VkResult CreateImageView (VkDevice device, const(VkImageViewCreateInfo)* pCreateInfo, const(VkAllocationCallbacks)* pAllocator, VkImageView* pView) {
        assert(_CreateImageView !is null, "vkCreateImageView was not loaded. Requested by VK_VERSION_1_0");
        return _CreateImageView(device, pCreateInfo, pAllocator, pView);
    }
    /// ditto
    void DestroyImageView (VkDevice device, VkImageView imageView, const(VkAllocationCallbacks)* pAllocator) {
        assert(_DestroyImageView !is null, "vkDestroyImageView was not loaded. Requested by VK_VERSION_1_0");
        return _DestroyImageView(device, imageView, pAllocator);
    }
    /// ditto
    VkResult CreateShaderModule (VkDevice device, const(VkShaderModuleCreateInfo)* pCreateInfo, const(VkAllocationCallbacks)* pAllocator, VkShaderModule* pShaderModule) {
        assert(_CreateShaderModule !is null, "vkCreateShaderModule was not loaded. Requested by VK_VERSION_1_0");
        return _CreateShaderModule(device, pCreateInfo, pAllocator, pShaderModule);
    }
    /// ditto
    void DestroyShaderModule (VkDevice device, VkShaderModule shaderModule, const(VkAllocationCallbacks)* pAllocator) {
        assert(_DestroyShaderModule !is null, "vkDestroyShaderModule was not loaded. Requested by VK_VERSION_1_0");
        return _DestroyShaderModule(device, shaderModule, pAllocator);
    }
    /// ditto
    VkResult CreatePipelineCache (VkDevice device, const(VkPipelineCacheCreateInfo)* pCreateInfo, const(VkAllocationCallbacks)* pAllocator, VkPipelineCache* pPipelineCache) {
        assert(_CreatePipelineCache !is null, "vkCreatePipelineCache was not loaded. Requested by VK_VERSION_1_0");
        return _CreatePipelineCache(device, pCreateInfo, pAllocator, pPipelineCache);
    }
    /// ditto
    void DestroyPipelineCache (VkDevice device, VkPipelineCache pipelineCache, const(VkAllocationCallbacks)* pAllocator) {
        assert(_DestroyPipelineCache !is null, "vkDestroyPipelineCache was not loaded. Requested by VK_VERSION_1_0");
        return _DestroyPipelineCache(device, pipelineCache, pAllocator);
    }
    /// ditto
    VkResult GetPipelineCacheData (VkDevice device, VkPipelineCache pipelineCache, size_t* pDataSize, void* pData) {
        assert(_GetPipelineCacheData !is null, "vkGetPipelineCacheData was not loaded. Requested by VK_VERSION_1_0");
        return _GetPipelineCacheData(device, pipelineCache, pDataSize, pData);
    }
    /// ditto
    VkResult MergePipelineCaches (VkDevice device, VkPipelineCache dstCache, uint32_t srcCacheCount, const(VkPipelineCache)* pSrcCaches) {
        assert(_MergePipelineCaches !is null, "vkMergePipelineCaches was not loaded. Requested by VK_VERSION_1_0");
        return _MergePipelineCaches(device, dstCache, srcCacheCount, pSrcCaches);
    }
    /// ditto
    VkResult CreateGraphicsPipelines (VkDevice device, VkPipelineCache pipelineCache, uint32_t createInfoCount, const(VkGraphicsPipelineCreateInfo)* pCreateInfos, const(VkAllocationCallbacks)* pAllocator, VkPipeline* pPipelines) {
        assert(_CreateGraphicsPipelines !is null, "vkCreateGraphicsPipelines was not loaded. Requested by VK_VERSION_1_0");
        return _CreateGraphicsPipelines(device, pipelineCache, createInfoCount, pCreateInfos, pAllocator, pPipelines);
    }
    /// ditto
    VkResult CreateComputePipelines (VkDevice device, VkPipelineCache pipelineCache, uint32_t createInfoCount, const(VkComputePipelineCreateInfo)* pCreateInfos, const(VkAllocationCallbacks)* pAllocator, VkPipeline* pPipelines) {
        assert(_CreateComputePipelines !is null, "vkCreateComputePipelines was not loaded. Requested by VK_VERSION_1_0");
        return _CreateComputePipelines(device, pipelineCache, createInfoCount, pCreateInfos, pAllocator, pPipelines);
    }
    /// ditto
    void DestroyPipeline (VkDevice device, VkPipeline pipeline, const(VkAllocationCallbacks)* pAllocator) {
        assert(_DestroyPipeline !is null, "vkDestroyPipeline was not loaded. Requested by VK_VERSION_1_0");
        return _DestroyPipeline(device, pipeline, pAllocator);
    }
    /// ditto
    VkResult CreatePipelineLayout (VkDevice device, const(VkPipelineLayoutCreateInfo)* pCreateInfo, const(VkAllocationCallbacks)* pAllocator, VkPipelineLayout* pPipelineLayout) {
        assert(_CreatePipelineLayout !is null, "vkCreatePipelineLayout was not loaded. Requested by VK_VERSION_1_0");
        return _CreatePipelineLayout(device, pCreateInfo, pAllocator, pPipelineLayout);
    }
    /// ditto
    void DestroyPipelineLayout (VkDevice device, VkPipelineLayout pipelineLayout, const(VkAllocationCallbacks)* pAllocator) {
        assert(_DestroyPipelineLayout !is null, "vkDestroyPipelineLayout was not loaded. Requested by VK_VERSION_1_0");
        return _DestroyPipelineLayout(device, pipelineLayout, pAllocator);
    }
    /// ditto
    VkResult CreateSampler (VkDevice device, const(VkSamplerCreateInfo)* pCreateInfo, const(VkAllocationCallbacks)* pAllocator, VkSampler* pSampler) {
        assert(_CreateSampler !is null, "vkCreateSampler was not loaded. Requested by VK_VERSION_1_0");
        return _CreateSampler(device, pCreateInfo, pAllocator, pSampler);
    }
    /// ditto
    void DestroySampler (VkDevice device, VkSampler sampler, const(VkAllocationCallbacks)* pAllocator) {
        assert(_DestroySampler !is null, "vkDestroySampler was not loaded. Requested by VK_VERSION_1_0");
        return _DestroySampler(device, sampler, pAllocator);
    }
    /// ditto
    VkResult CreateDescriptorSetLayout (VkDevice device, const(VkDescriptorSetLayoutCreateInfo)* pCreateInfo, const(VkAllocationCallbacks)* pAllocator, VkDescriptorSetLayout* pSetLayout) {
        assert(_CreateDescriptorSetLayout !is null, "vkCreateDescriptorSetLayout was not loaded. Requested by VK_VERSION_1_0");
        return _CreateDescriptorSetLayout(device, pCreateInfo, pAllocator, pSetLayout);
    }
    /// ditto
    void DestroyDescriptorSetLayout (VkDevice device, VkDescriptorSetLayout descriptorSetLayout, const(VkAllocationCallbacks)* pAllocator) {
        assert(_DestroyDescriptorSetLayout !is null, "vkDestroyDescriptorSetLayout was not loaded. Requested by VK_VERSION_1_0");
        return _DestroyDescriptorSetLayout(device, descriptorSetLayout, pAllocator);
    }
    /// ditto
    VkResult CreateDescriptorPool (VkDevice device, const(VkDescriptorPoolCreateInfo)* pCreateInfo, const(VkAllocationCallbacks)* pAllocator, VkDescriptorPool* pDescriptorPool) {
        assert(_CreateDescriptorPool !is null, "vkCreateDescriptorPool was not loaded. Requested by VK_VERSION_1_0");
        return _CreateDescriptorPool(device, pCreateInfo, pAllocator, pDescriptorPool);
    }
    /// ditto
    void DestroyDescriptorPool (VkDevice device, VkDescriptorPool descriptorPool, const(VkAllocationCallbacks)* pAllocator) {
        assert(_DestroyDescriptorPool !is null, "vkDestroyDescriptorPool was not loaded. Requested by VK_VERSION_1_0");
        return _DestroyDescriptorPool(device, descriptorPool, pAllocator);
    }
    /// ditto
    VkResult ResetDescriptorPool (VkDevice device, VkDescriptorPool descriptorPool, VkDescriptorPoolResetFlags flags) {
        assert(_ResetDescriptorPool !is null, "vkResetDescriptorPool was not loaded. Requested by VK_VERSION_1_0");
        return _ResetDescriptorPool(device, descriptorPool, flags);
    }
    /// ditto
    VkResult AllocateDescriptorSets (VkDevice device, const(VkDescriptorSetAllocateInfo)* pAllocateInfo, VkDescriptorSet* pDescriptorSets) {
        assert(_AllocateDescriptorSets !is null, "vkAllocateDescriptorSets was not loaded. Requested by VK_VERSION_1_0");
        return _AllocateDescriptorSets(device, pAllocateInfo, pDescriptorSets);
    }
    /// ditto
    VkResult FreeDescriptorSets (VkDevice device, VkDescriptorPool descriptorPool, uint32_t descriptorSetCount, const(VkDescriptorSet)* pDescriptorSets) {
        assert(_FreeDescriptorSets !is null, "vkFreeDescriptorSets was not loaded. Requested by VK_VERSION_1_0");
        return _FreeDescriptorSets(device, descriptorPool, descriptorSetCount, pDescriptorSets);
    }
    /// ditto
    void UpdateDescriptorSets (VkDevice device, uint32_t descriptorWriteCount, const(VkWriteDescriptorSet)* pDescriptorWrite, uint32_t descriptorCopyCount, const(VkCopyDescriptorSet)* pDescriptorCopies) {
        assert(_UpdateDescriptorSets !is null, "vkUpdateDescriptorSets was not loaded. Requested by VK_VERSION_1_0");
        return _UpdateDescriptorSets(device, descriptorWriteCount, pDescriptorWrite, descriptorCopyCount, pDescriptorCopies);
    }
    /// ditto
    VkResult CreateFramebuffer (VkDevice device, const(VkFramebufferCreateInfo)* pCreateInfo, const(VkAllocationCallbacks)* pAllocator, VkFramebuffer* pFramebuffer) {
        assert(_CreateFramebuffer !is null, "vkCreateFramebuffer was not loaded. Requested by VK_VERSION_1_0");
        return _CreateFramebuffer(device, pCreateInfo, pAllocator, pFramebuffer);
    }
    /// ditto
    void DestroyFramebuffer (VkDevice device, VkFramebuffer framebuffer, const(VkAllocationCallbacks)* pAllocator) {
        assert(_DestroyFramebuffer !is null, "vkDestroyFramebuffer was not loaded. Requested by VK_VERSION_1_0");
        return _DestroyFramebuffer(device, framebuffer, pAllocator);
    }
    /// ditto
    VkResult CreateRenderPass (VkDevice device, const(VkRenderPassCreateInfo)* pCreateInfo, const(VkAllocationCallbacks)* pAllocator, VkRenderPass* pRenderPass) {
        assert(_CreateRenderPass !is null, "vkCreateRenderPass was not loaded. Requested by VK_VERSION_1_0");
        return _CreateRenderPass(device, pCreateInfo, pAllocator, pRenderPass);
    }
    /// ditto
    void DestroyRenderPass (VkDevice device, VkRenderPass renderPass, const(VkAllocationCallbacks)* pAllocator) {
        assert(_DestroyRenderPass !is null, "vkDestroyRenderPass was not loaded. Requested by VK_VERSION_1_0");
        return _DestroyRenderPass(device, renderPass, pAllocator);
    }
    /// ditto
    void GetRenderAreaGranularity (VkDevice device, VkRenderPass renderPass, VkExtent2D* pGranularity) {
        assert(_GetRenderAreaGranularity !is null, "vkGetRenderAreaGranularity was not loaded. Requested by VK_VERSION_1_0");
        return _GetRenderAreaGranularity(device, renderPass, pGranularity);
    }
    /// ditto
    VkResult CreateCommandPool (VkDevice device, const(VkCommandPoolCreateInfo)* pCreateInfo, const(VkAllocationCallbacks)* pAllocator, VkCommandPool* pCommandPool) {
        assert(_CreateCommandPool !is null, "vkCreateCommandPool was not loaded. Requested by VK_VERSION_1_0");
        return _CreateCommandPool(device, pCreateInfo, pAllocator, pCommandPool);
    }
    /// ditto
    void DestroyCommandPool (VkDevice device, VkCommandPool commandPool, const(VkAllocationCallbacks)* pAllocator) {
        assert(_DestroyCommandPool !is null, "vkDestroyCommandPool was not loaded. Requested by VK_VERSION_1_0");
        return _DestroyCommandPool(device, commandPool, pAllocator);
    }
    /// ditto
    VkResult ResetCommandPool (VkDevice device, VkCommandPool commandPool, VkCommandPoolResetFlags flags) {
        assert(_ResetCommandPool !is null, "vkResetCommandPool was not loaded. Requested by VK_VERSION_1_0");
        return _ResetCommandPool(device, commandPool, flags);
    }
    /// ditto
    VkResult AllocateCommandBuffers (VkDevice device, const(VkCommandBufferAllocateInfo)* pAllocateInfo, VkCommandBuffer* pCommandBuffers) {
        assert(_AllocateCommandBuffers !is null, "vkAllocateCommandBuffers was not loaded. Requested by VK_VERSION_1_0");
        return _AllocateCommandBuffers(device, pAllocateInfo, pCommandBuffers);
    }
    /// ditto
    void FreeCommandBuffers (VkDevice device, VkCommandPool commandPool, uint32_t commandBufferCount, const(VkCommandBuffer)* pCommandBuffers) {
        assert(_FreeCommandBuffers !is null, "vkFreeCommandBuffers was not loaded. Requested by VK_VERSION_1_0");
        return _FreeCommandBuffers(device, commandPool, commandBufferCount, pCommandBuffers);
    }
    /// ditto
    VkResult BeginCommandBuffer (VkCommandBuffer commandBuffer, const(VkCommandBufferBeginInfo)* pBeginInfo) {
        assert(_BeginCommandBuffer !is null, "vkBeginCommandBuffer was not loaded. Requested by VK_VERSION_1_0");
        return _BeginCommandBuffer(commandBuffer, pBeginInfo);
    }
    /// ditto
    VkResult EndCommandBuffer (VkCommandBuffer commandBuffer) {
        assert(_EndCommandBuffer !is null, "vkEndCommandBuffer was not loaded. Requested by VK_VERSION_1_0");
        return _EndCommandBuffer(commandBuffer);
    }
    /// ditto
    VkResult ResetCommandBuffer (VkCommandBuffer commandBuffer, VkCommandBufferResetFlags flags) {
        assert(_ResetCommandBuffer !is null, "vkResetCommandBuffer was not loaded. Requested by VK_VERSION_1_0");
        return _ResetCommandBuffer(commandBuffer, flags);
    }
    /// ditto
    void CmdBindPipeline (VkCommandBuffer commandBuffer, VkPipelineBindPoint pipelineBindPoint, VkPipeline pipeline) {
        assert(_CmdBindPipeline !is null, "vkCmdBindPipeline was not loaded. Requested by VK_VERSION_1_0");
        return _CmdBindPipeline(commandBuffer, pipelineBindPoint, pipeline);
    }
    /// ditto
    void CmdSetViewport (VkCommandBuffer commandBuffer, uint32_t firstViewport, uint32_t viewportCount, const(VkViewport)* pViewports) {
        assert(_CmdSetViewport !is null, "vkCmdSetViewport was not loaded. Requested by VK_VERSION_1_0");
        return _CmdSetViewport(commandBuffer, firstViewport, viewportCount, pViewports);
    }
    /// ditto
    void CmdSetScissor (VkCommandBuffer commandBuffer, uint32_t firstScissor, uint32_t scissorCount, const(VkRect2D)* pScissors) {
        assert(_CmdSetScissor !is null, "vkCmdSetScissor was not loaded. Requested by VK_VERSION_1_0");
        return _CmdSetScissor(commandBuffer, firstScissor, scissorCount, pScissors);
    }
    /// ditto
    void CmdSetLineWidth (VkCommandBuffer commandBuffer, float lineWidth) {
        assert(_CmdSetLineWidth !is null, "vkCmdSetLineWidth was not loaded. Requested by VK_VERSION_1_0");
        return _CmdSetLineWidth(commandBuffer, lineWidth);
    }
    /// ditto
    void CmdSetDepthBias (VkCommandBuffer commandBuffer, float depthBiasConstantFactor, float depthBiasClamp, float depthBiasSlopeFactor) {
        assert(_CmdSetDepthBias !is null, "vkCmdSetDepthBias was not loaded. Requested by VK_VERSION_1_0");
        return _CmdSetDepthBias(commandBuffer, depthBiasConstantFactor, depthBiasClamp, depthBiasSlopeFactor);
    }
    /// ditto
    void CmdSetBlendConstants (VkCommandBuffer commandBuffer, const float[4] blendConstants) {
        assert(_CmdSetBlendConstants !is null, "vkCmdSetBlendConstants was not loaded. Requested by VK_VERSION_1_0");
        return _CmdSetBlendConstants(commandBuffer, blendConstants);
    }
    /// ditto
    void CmdSetDepthBounds (VkCommandBuffer commandBuffer, float minDepthBounds, float maxDepthBounds) {
        assert(_CmdSetDepthBounds !is null, "vkCmdSetDepthBounds was not loaded. Requested by VK_VERSION_1_0");
        return _CmdSetDepthBounds(commandBuffer, minDepthBounds, maxDepthBounds);
    }
    /// ditto
    void CmdSetStencilCompareMask (VkCommandBuffer commandBuffer, VkStencilFaceFlags faceMask, uint32_t compareMask) {
        assert(_CmdSetStencilCompareMask !is null, "vkCmdSetStencilCompareMask was not loaded. Requested by VK_VERSION_1_0");
        return _CmdSetStencilCompareMask(commandBuffer, faceMask, compareMask);
    }
    /// ditto
    void CmdSetStencilWriteMask (VkCommandBuffer commandBuffer, VkStencilFaceFlags faceMask, uint32_t writeMask) {
        assert(_CmdSetStencilWriteMask !is null, "vkCmdSetStencilWriteMask was not loaded. Requested by VK_VERSION_1_0");
        return _CmdSetStencilWriteMask(commandBuffer, faceMask, writeMask);
    }
    /// ditto
    void CmdSetStencilReference (VkCommandBuffer commandBuffer, VkStencilFaceFlags faceMask, uint32_t reference) {
        assert(_CmdSetStencilReference !is null, "vkCmdSetStencilReference was not loaded. Requested by VK_VERSION_1_0");
        return _CmdSetStencilReference(commandBuffer, faceMask, reference);
    }
    /// ditto
    void CmdBindDescriptorSets (VkCommandBuffer commandBuffer, VkPipelineBindPoint pipelineBindPoint, VkPipelineLayout layout, uint32_t firstSet, uint32_t descriptorSetCount, const(VkDescriptorSet)* pDescriptorSets, uint32_t dynamicOffsetCount, const(uint32_t)* pDynamicOffsets) {
        assert(_CmdBindDescriptorSets !is null, "vkCmdBindDescriptorSets was not loaded. Requested by VK_VERSION_1_0");
        return _CmdBindDescriptorSets(commandBuffer, pipelineBindPoint, layout, firstSet, descriptorSetCount, pDescriptorSets, dynamicOffsetCount, pDynamicOffsets);
    }
    /// ditto
    void CmdBindIndexBuffer (VkCommandBuffer commandBuffer, VkBuffer buffer, VkDeviceSize offset, VkIndexType indexType) {
        assert(_CmdBindIndexBuffer !is null, "vkCmdBindIndexBuffer was not loaded. Requested by VK_VERSION_1_0");
        return _CmdBindIndexBuffer(commandBuffer, buffer, offset, indexType);
    }
    /// ditto
    void CmdBindVertexBuffers (VkCommandBuffer commandBuffer, uint32_t firstBinding, uint32_t bindingCount, const(VkBuffer)* pBuffers, const(VkDeviceSize)* pOffsets) {
        assert(_CmdBindVertexBuffers !is null, "vkCmdBindVertexBuffers was not loaded. Requested by VK_VERSION_1_0");
        return _CmdBindVertexBuffers(commandBuffer, firstBinding, bindingCount, pBuffers, pOffsets);
    }
    /// ditto
    void CmdDraw (VkCommandBuffer commandBuffer, uint32_t vertexCount, uint32_t instanceCount, uint32_t firstVertex, uint32_t firstInstance) {
        assert(_CmdDraw !is null, "vkCmdDraw was not loaded. Requested by VK_VERSION_1_0");
        return _CmdDraw(commandBuffer, vertexCount, instanceCount, firstVertex, firstInstance);
    }
    /// ditto
    void CmdDrawIndexed (VkCommandBuffer commandBuffer, uint32_t indexCount, uint32_t instanceCount, uint32_t firstIndex, int32_t vertexOffset, uint32_t firstInstance) {
        assert(_CmdDrawIndexed !is null, "vkCmdDrawIndexed was not loaded. Requested by VK_VERSION_1_0");
        return _CmdDrawIndexed(commandBuffer, indexCount, instanceCount, firstIndex, vertexOffset, firstInstance);
    }
    /// ditto
    void CmdDrawIndirect (VkCommandBuffer commandBuffer, VkBuffer buffer, VkDeviceSize offset, uint32_t drawCount, uint32_t stride) {
        assert(_CmdDrawIndirect !is null, "vkCmdDrawIndirect was not loaded. Requested by VK_VERSION_1_0");
        return _CmdDrawIndirect(commandBuffer, buffer, offset, drawCount, stride);
    }
    /// ditto
    void CmdDrawIndexedIndirect (VkCommandBuffer commandBuffer, VkBuffer buffer, VkDeviceSize offset, uint32_t drawCount, uint32_t stride) {
        assert(_CmdDrawIndexedIndirect !is null, "vkCmdDrawIndexedIndirect was not loaded. Requested by VK_VERSION_1_0");
        return _CmdDrawIndexedIndirect(commandBuffer, buffer, offset, drawCount, stride);
    }
    /// ditto
    void CmdDispatch (VkCommandBuffer commandBuffer, uint32_t groupCountX, uint32_t groupCountY, uint32_t groupCountZ) {
        assert(_CmdDispatch !is null, "vkCmdDispatch was not loaded. Requested by VK_VERSION_1_0");
        return _CmdDispatch(commandBuffer, groupCountX, groupCountY, groupCountZ);
    }
    /// ditto
    void CmdDispatchIndirect (VkCommandBuffer commandBuffer, VkBuffer buffer, VkDeviceSize offset) {
        assert(_CmdDispatchIndirect !is null, "vkCmdDispatchIndirect was not loaded. Requested by VK_VERSION_1_0");
        return _CmdDispatchIndirect(commandBuffer, buffer, offset);
    }
    /// ditto
    void CmdCopyBuffer (VkCommandBuffer commandBuffer, VkBuffer srcBuffer, VkBuffer dstBuffer, uint32_t regionCount, const(VkBufferCopy)* pRegions) {
        assert(_CmdCopyBuffer !is null, "vkCmdCopyBuffer was not loaded. Requested by VK_VERSION_1_0");
        return _CmdCopyBuffer(commandBuffer, srcBuffer, dstBuffer, regionCount, pRegions);
    }
    /// ditto
    void CmdCopyImage (VkCommandBuffer commandBuffer, VkImage srcImage, VkImageLayout srcImageLayout, VkImage dstImage, VkImageLayout dstImageLayout, uint32_t regionCount, const(VkImageCopy)* pRegions) {
        assert(_CmdCopyImage !is null, "vkCmdCopyImage was not loaded. Requested by VK_VERSION_1_0");
        return _CmdCopyImage(commandBuffer, srcImage, srcImageLayout, dstImage, dstImageLayout, regionCount, pRegions);
    }
    /// ditto
    void CmdBlitImage (VkCommandBuffer commandBuffer, VkImage srcImage, VkImageLayout srcImageLayout, VkImage dstImage, VkImageLayout dstImageLayout, uint32_t regionCount, const(VkImageBlit)* pRegions, VkFilter filter) {
        assert(_CmdBlitImage !is null, "vkCmdBlitImage was not loaded. Requested by VK_VERSION_1_0");
        return _CmdBlitImage(commandBuffer, srcImage, srcImageLayout, dstImage, dstImageLayout, regionCount, pRegions, filter);
    }
    /// ditto
    void CmdCopyBufferToImage (VkCommandBuffer commandBuffer, VkBuffer srcBuffer, VkImage dstImage, VkImageLayout dstImageLayout, uint32_t regionCount, const(VkBufferImageCopy)* pRegions) {
        assert(_CmdCopyBufferToImage !is null, "vkCmdCopyBufferToImage was not loaded. Requested by VK_VERSION_1_0");
        return _CmdCopyBufferToImage(commandBuffer, srcBuffer, dstImage, dstImageLayout, regionCount, pRegions);
    }
    /// ditto
    void CmdCopyImageToBuffer (VkCommandBuffer commandBuffer, VkImage srcImage, VkImageLayout srcImageLayout, VkBuffer dstBuffer, uint32_t regionCount, const(VkBufferImageCopy)* pRegions) {
        assert(_CmdCopyImageToBuffer !is null, "vkCmdCopyImageToBuffer was not loaded. Requested by VK_VERSION_1_0");
        return _CmdCopyImageToBuffer(commandBuffer, srcImage, srcImageLayout, dstBuffer, regionCount, pRegions);
    }
    /// ditto
    void CmdUpdateBuffer (VkCommandBuffer commandBuffer, VkBuffer dstBuffer, VkDeviceSize dstOffset, VkDeviceSize dataSize, const(void)* pData) {
        assert(_CmdUpdateBuffer !is null, "vkCmdUpdateBuffer was not loaded. Requested by VK_VERSION_1_0");
        return _CmdUpdateBuffer(commandBuffer, dstBuffer, dstOffset, dataSize, pData);
    }
    /// ditto
    void CmdFillBuffer (VkCommandBuffer commandBuffer, VkBuffer dstBuffer, VkDeviceSize dstOffset, VkDeviceSize size, uint32_t data) {
        assert(_CmdFillBuffer !is null, "vkCmdFillBuffer was not loaded. Requested by VK_VERSION_1_0");
        return _CmdFillBuffer(commandBuffer, dstBuffer, dstOffset, size, data);
    }
    /// ditto
    void CmdClearColorImage (VkCommandBuffer commandBuffer, VkImage image, VkImageLayout imageLayout, const(VkClearColorValue)* pColor, uint32_t rangeCount, const(VkImageSubresourceRange)* pRanges) {
        assert(_CmdClearColorImage !is null, "vkCmdClearColorImage was not loaded. Requested by VK_VERSION_1_0");
        return _CmdClearColorImage(commandBuffer, image, imageLayout, pColor, rangeCount, pRanges);
    }
    /// ditto
    void CmdClearDepthStencilImage (VkCommandBuffer commandBuffer, VkImage image, VkImageLayout imageLayout, const(VkClearDepthStencilValue)* pDepthStencil, uint32_t rangeCount, const(VkImageSubresourceRange)* pRanges) {
        assert(_CmdClearDepthStencilImage !is null, "vkCmdClearDepthStencilImage was not loaded. Requested by VK_VERSION_1_0");
        return _CmdClearDepthStencilImage(commandBuffer, image, imageLayout, pDepthStencil, rangeCount, pRanges);
    }
    /// ditto
    void CmdClearAttachments (VkCommandBuffer commandBuffer, uint32_t attachmentCount, const(VkClearAttachment)* pAttachments, uint32_t rectCount, const(VkClearRect)* pRects) {
        assert(_CmdClearAttachments !is null, "vkCmdClearAttachments was not loaded. Requested by VK_VERSION_1_0");
        return _CmdClearAttachments(commandBuffer, attachmentCount, pAttachments, rectCount, pRects);
    }
    /// ditto
    void CmdResolveImage (VkCommandBuffer commandBuffer, VkImage srcImage, VkImageLayout srcImageLayout, VkImage dstImage, VkImageLayout dstImageLayout, uint32_t regionCount, const(VkImageResolve)* pRegions) {
        assert(_CmdResolveImage !is null, "vkCmdResolveImage was not loaded. Requested by VK_VERSION_1_0");
        return _CmdResolveImage(commandBuffer, srcImage, srcImageLayout, dstImage, dstImageLayout, regionCount, pRegions);
    }
    /// ditto
    void CmdSetEvent (VkCommandBuffer commandBuffer, VkEvent event, VkPipelineStageFlags stageMask) {
        assert(_CmdSetEvent !is null, "vkCmdSetEvent was not loaded. Requested by VK_VERSION_1_0");
        return _CmdSetEvent(commandBuffer, event, stageMask);
    }
    /// ditto
    void CmdResetEvent (VkCommandBuffer commandBuffer, VkEvent event, VkPipelineStageFlags stageMask) {
        assert(_CmdResetEvent !is null, "vkCmdResetEvent was not loaded. Requested by VK_VERSION_1_0");
        return _CmdResetEvent(commandBuffer, event, stageMask);
    }
    /// ditto
    void CmdWaitEvents (VkCommandBuffer commandBuffer, uint32_t eventCount, const(VkEvent)* pEvents, VkPipelineStageFlags srcStageMask, VkPipelineStageFlags dstStageMask, uint32_t memoryBarrierCount, const(VkMemoryBarrier)* pMemoryBarriers, uint32_t bufferMemoryBarrierCount, const(VkBufferMemoryBarrier)* pBufferMemoryBarriers, uint32_t imageMemoryBarrierCount, const(VkImageMemoryBarrier)* pImageMemoryBarriers) {
        assert(_CmdWaitEvents !is null, "vkCmdWaitEvents was not loaded. Requested by VK_VERSION_1_0");
        return _CmdWaitEvents(commandBuffer, eventCount, pEvents, srcStageMask, dstStageMask, memoryBarrierCount, pMemoryBarriers, bufferMemoryBarrierCount, pBufferMemoryBarriers, imageMemoryBarrierCount, pImageMemoryBarriers);
    }
    /// ditto
    void CmdPipelineBarrier (VkCommandBuffer commandBuffer, VkPipelineStageFlags srcStageMask, VkPipelineStageFlags dstStageMask, VkDependencyFlags dependencyFlags, uint32_t memoryBarrierCount, const(VkMemoryBarrier)* pMemoryBarriers, uint32_t bufferMemoryBarrierCount, const(VkBufferMemoryBarrier)* pBufferMemoryBarriers, uint32_t imageMemoryBarrierCount, const(VkImageMemoryBarrier)* pImageMemoryBarriers) {
        assert(_CmdPipelineBarrier !is null, "vkCmdPipelineBarrier was not loaded. Requested by VK_VERSION_1_0");
        return _CmdPipelineBarrier(commandBuffer, srcStageMask, dstStageMask, dependencyFlags, memoryBarrierCount, pMemoryBarriers, bufferMemoryBarrierCount, pBufferMemoryBarriers, imageMemoryBarrierCount, pImageMemoryBarriers);
    }
    /// ditto
    void CmdBeginQuery (VkCommandBuffer commandBuffer, VkQueryPool queryPool, uint32_t query, VkQueryControlFlags flags) {
        assert(_CmdBeginQuery !is null, "vkCmdBeginQuery was not loaded. Requested by VK_VERSION_1_0");
        return _CmdBeginQuery(commandBuffer, queryPool, query, flags);
    }
    /// ditto
    void CmdEndQuery (VkCommandBuffer commandBuffer, VkQueryPool queryPool, uint32_t query) {
        assert(_CmdEndQuery !is null, "vkCmdEndQuery was not loaded. Requested by VK_VERSION_1_0");
        return _CmdEndQuery(commandBuffer, queryPool, query);
    }
    /// ditto
    void CmdResetQueryPool (VkCommandBuffer commandBuffer, VkQueryPool queryPool, uint32_t firstQuery, uint32_t queryCount) {
        assert(_CmdResetQueryPool !is null, "vkCmdResetQueryPool was not loaded. Requested by VK_VERSION_1_0");
        return _CmdResetQueryPool(commandBuffer, queryPool, firstQuery, queryCount);
    }
    /// ditto
    void CmdWriteTimestamp (VkCommandBuffer commandBuffer, VkPipelineStageFlagBits pipelineStage, VkQueryPool queryPool, uint32_t query) {
        assert(_CmdWriteTimestamp !is null, "vkCmdWriteTimestamp was not loaded. Requested by VK_VERSION_1_0");
        return _CmdWriteTimestamp(commandBuffer, pipelineStage, queryPool, query);
    }
    /// ditto
    void CmdCopyQueryPoolResults (VkCommandBuffer commandBuffer, VkQueryPool queryPool, uint32_t firstQuery, uint32_t queryCount, VkBuffer dstBuffer, VkDeviceSize dstOffset, VkDeviceSize stride, VkQueryResultFlags flags) {
        assert(_CmdCopyQueryPoolResults !is null, "vkCmdCopyQueryPoolResults was not loaded. Requested by VK_VERSION_1_0");
        return _CmdCopyQueryPoolResults(commandBuffer, queryPool, firstQuery, queryCount, dstBuffer, dstOffset, stride, flags);
    }
    /// ditto
    void CmdPushConstants (VkCommandBuffer commandBuffer, VkPipelineLayout layout, VkShaderStageFlags stageFlags, uint32_t offset, uint32_t size, const(void)* pValues) {
        assert(_CmdPushConstants !is null, "vkCmdPushConstants was not loaded. Requested by VK_VERSION_1_0");
        return _CmdPushConstants(commandBuffer, layout, stageFlags, offset, size, pValues);
    }
    /// ditto
    void CmdBeginRenderPass (VkCommandBuffer commandBuffer, const(VkRenderPassBeginInfo)* pRenderPassBegin, VkSubpassContents contents) {
        assert(_CmdBeginRenderPass !is null, "vkCmdBeginRenderPass was not loaded. Requested by VK_VERSION_1_0");
        return _CmdBeginRenderPass(commandBuffer, pRenderPassBegin, contents);
    }
    /// ditto
    void CmdNextSubpass (VkCommandBuffer commandBuffer, VkSubpassContents contents) {
        assert(_CmdNextSubpass !is null, "vkCmdNextSubpass was not loaded. Requested by VK_VERSION_1_0");
        return _CmdNextSubpass(commandBuffer, contents);
    }
    /// ditto
    void CmdEndRenderPass (VkCommandBuffer commandBuffer) {
        assert(_CmdEndRenderPass !is null, "vkCmdEndRenderPass was not loaded. Requested by VK_VERSION_1_0");
        return _CmdEndRenderPass(commandBuffer);
    }
    /// ditto
    void CmdExecuteCommands (VkCommandBuffer commandBuffer, uint32_t commandBufferCount, const(VkCommandBuffer)* pCommandBuffers) {
        assert(_CmdExecuteCommands !is null, "vkCmdExecuteCommands was not loaded. Requested by VK_VERSION_1_0");
        return _CmdExecuteCommands(commandBuffer, commandBufferCount, pCommandBuffers);
    }

    /// Commands for VK_VERSION_1_1
    VkResult BindBufferMemory2 (VkDevice device, uint32_t bindInfoCount, const(VkBindBufferMemoryInfo)* pBindInfos) {
        assert(_BindBufferMemory2 !is null, "vkBindBufferMemory2 was not loaded. Requested by VK_VERSION_1_1");
        return _BindBufferMemory2(device, bindInfoCount, pBindInfos);
    }
    /// ditto
    VkResult BindImageMemory2 (VkDevice device, uint32_t bindInfoCount, const(VkBindImageMemoryInfo)* pBindInfos) {
        assert(_BindImageMemory2 !is null, "vkBindImageMemory2 was not loaded. Requested by VK_VERSION_1_1");
        return _BindImageMemory2(device, bindInfoCount, pBindInfos);
    }
    /// ditto
    void GetDeviceGroupPeerMemoryFeatures (VkDevice device, uint32_t heapIndex, uint32_t localDeviceIndex, uint32_t remoteDeviceIndex, VkPeerMemoryFeatureFlags* pPeerMemoryFeatures) {
        assert(_GetDeviceGroupPeerMemoryFeatures !is null, "vkGetDeviceGroupPeerMemoryFeatures was not loaded. Requested by VK_VERSION_1_1");
        return _GetDeviceGroupPeerMemoryFeatures(device, heapIndex, localDeviceIndex, remoteDeviceIndex, pPeerMemoryFeatures);
    }
    /// ditto
    void CmdSetDeviceMask (VkCommandBuffer commandBuffer, uint32_t deviceMask) {
        assert(_CmdSetDeviceMask !is null, "vkCmdSetDeviceMask was not loaded. Requested by VK_VERSION_1_1");
        return _CmdSetDeviceMask(commandBuffer, deviceMask);
    }
    /// ditto
    void CmdDispatchBase (VkCommandBuffer commandBuffer, uint32_t baseGroupX, uint32_t baseGroupY, uint32_t baseGroupZ, uint32_t groupCountX, uint32_t groupCountY, uint32_t groupCountZ) {
        assert(_CmdDispatchBase !is null, "vkCmdDispatchBase was not loaded. Requested by VK_VERSION_1_1");
        return _CmdDispatchBase(commandBuffer, baseGroupX, baseGroupY, baseGroupZ, groupCountX, groupCountY, groupCountZ);
    }
    /// ditto
    void GetImageMemoryRequirements2 (VkDevice device, const(VkImageMemoryRequirementsInfo2)* pInfo, VkMemoryRequirements2* pMemoryRequirements) {
        assert(_GetImageMemoryRequirements2 !is null, "vkGetImageMemoryRequirements2 was not loaded. Requested by VK_VERSION_1_1");
        return _GetImageMemoryRequirements2(device, pInfo, pMemoryRequirements);
    }
    /// ditto
    void GetBufferMemoryRequirements2 (VkDevice device, const(VkBufferMemoryRequirementsInfo2)* pInfo, VkMemoryRequirements2* pMemoryRequirements) {
        assert(_GetBufferMemoryRequirements2 !is null, "vkGetBufferMemoryRequirements2 was not loaded. Requested by VK_VERSION_1_1");
        return _GetBufferMemoryRequirements2(device, pInfo, pMemoryRequirements);
    }
    /// ditto
    void GetImageSparseMemoryRequirements2 (VkDevice device, const(VkImageSparseMemoryRequirementsInfo2)* pInfo, uint32_t* pSparseMemoryRequirementCount, VkSparseImageMemoryRequirements2* pSparseMemoryRequirements) {
        assert(_GetImageSparseMemoryRequirements2 !is null, "vkGetImageSparseMemoryRequirements2 was not loaded. Requested by VK_VERSION_1_1");
        return _GetImageSparseMemoryRequirements2(device, pInfo, pSparseMemoryRequirementCount, pSparseMemoryRequirements);
    }
    /// ditto
    void TrimCommandPool (VkDevice device, VkCommandPool commandPool, VkCommandPoolTrimFlags flags) {
        assert(_TrimCommandPool !is null, "vkTrimCommandPool was not loaded. Requested by VK_VERSION_1_1");
        return _TrimCommandPool(device, commandPool, flags);
    }
    /// ditto
    void GetDeviceQueue2 (VkDevice device, const(VkDeviceQueueInfo2)* pQueueInfo, VkQueue* pQueue) {
        assert(_GetDeviceQueue2 !is null, "vkGetDeviceQueue2 was not loaded. Requested by VK_VERSION_1_1");
        return _GetDeviceQueue2(device, pQueueInfo, pQueue);
    }
    /// ditto
    VkResult CreateSamplerYcbcrConversion (VkDevice device, const(VkSamplerYcbcrConversionCreateInfo)* pCreateInfo, const(VkAllocationCallbacks)* pAllocator, VkSamplerYcbcrConversion* pYcbcrConversion) {
        assert(_CreateSamplerYcbcrConversion !is null, "vkCreateSamplerYcbcrConversion was not loaded. Requested by VK_VERSION_1_1");
        return _CreateSamplerYcbcrConversion(device, pCreateInfo, pAllocator, pYcbcrConversion);
    }
    /// ditto
    void DestroySamplerYcbcrConversion (VkDevice device, VkSamplerYcbcrConversion ycbcrConversion, const(VkAllocationCallbacks)* pAllocator) {
        assert(_DestroySamplerYcbcrConversion !is null, "vkDestroySamplerYcbcrConversion was not loaded. Requested by VK_VERSION_1_1");
        return _DestroySamplerYcbcrConversion(device, ycbcrConversion, pAllocator);
    }
    /// ditto
    VkResult CreateDescriptorUpdateTemplate (VkDevice device, const(VkDescriptorUpdateTemplateCreateInfo)* pCreateInfo, const(VkAllocationCallbacks)* pAllocator, VkDescriptorUpdateTemplate* pDescriptorUpdateTemplate) {
        assert(_CreateDescriptorUpdateTemplate !is null, "vkCreateDescriptorUpdateTemplate was not loaded. Requested by VK_VERSION_1_1");
        return _CreateDescriptorUpdateTemplate(device, pCreateInfo, pAllocator, pDescriptorUpdateTemplate);
    }
    /// ditto
    void DestroyDescriptorUpdateTemplate (VkDevice device, VkDescriptorUpdateTemplate descriptorUpdateTemplate, const(VkAllocationCallbacks)* pAllocator) {
        assert(_DestroyDescriptorUpdateTemplate !is null, "vkDestroyDescriptorUpdateTemplate was not loaded. Requested by VK_VERSION_1_1");
        return _DestroyDescriptorUpdateTemplate(device, descriptorUpdateTemplate, pAllocator);
    }
    /// ditto
    void UpdateDescriptorSetWithTemplate (VkDevice device, VkDescriptorSet descriptorSet, VkDescriptorUpdateTemplate descriptorUpdateTemplate, const(void)* pData) {
        assert(_UpdateDescriptorSetWithTemplate !is null, "vkUpdateDescriptorSetWithTemplate was not loaded. Requested by VK_VERSION_1_1");
        return _UpdateDescriptorSetWithTemplate(device, descriptorSet, descriptorUpdateTemplate, pData);
    }
    /// ditto
    void GetDescriptorSetLayoutSupport (VkDevice device, const(VkDescriptorSetLayoutCreateInfo)* pCreateInfo, VkDescriptorSetLayoutSupport* pSupport) {
        assert(_GetDescriptorSetLayoutSupport !is null, "vkGetDescriptorSetLayoutSupport was not loaded. Requested by VK_VERSION_1_1");
        return _GetDescriptorSetLayoutSupport(device, pCreateInfo, pSupport);
    }

    /// Commands for VK_KHR_swapchain
    VkResult CreateSwapchainKHR (VkDevice device, const(VkSwapchainCreateInfoKHR)* pCreateInfo, const(VkAllocationCallbacks)* pAllocator, VkSwapchainKHR* pSwapchain) {
        assert(_CreateSwapchainKHR !is null, "vkCreateSwapchainKHR was not loaded. Requested by VK_KHR_swapchain");
        return _CreateSwapchainKHR(device, pCreateInfo, pAllocator, pSwapchain);
    }
    /// ditto
    void DestroySwapchainKHR (VkDevice device, VkSwapchainKHR swapchain, const(VkAllocationCallbacks)* pAllocator) {
        assert(_DestroySwapchainKHR !is null, "vkDestroySwapchainKHR was not loaded. Requested by VK_KHR_swapchain");
        return _DestroySwapchainKHR(device, swapchain, pAllocator);
    }
    /// ditto
    VkResult GetSwapchainImagesKHR (VkDevice device, VkSwapchainKHR swapchain, uint32_t* pSwapchainImageCount, VkImage* pSwapchainImages) {
        assert(_GetSwapchainImagesKHR !is null, "vkGetSwapchainImagesKHR was not loaded. Requested by VK_KHR_swapchain");
        return _GetSwapchainImagesKHR(device, swapchain, pSwapchainImageCount, pSwapchainImages);
    }
    /// ditto
    VkResult AcquireNextImageKHR (VkDevice device, VkSwapchainKHR swapchain, uint64_t timeout, VkSemaphore semaphore, VkFence fence, uint32_t* pImageIndex) {
        assert(_AcquireNextImageKHR !is null, "vkAcquireNextImageKHR was not loaded. Requested by VK_KHR_swapchain");
        return _AcquireNextImageKHR(device, swapchain, timeout, semaphore, fence, pImageIndex);
    }
    /// ditto
    VkResult QueuePresentKHR (VkQueue queue, const(VkPresentInfoKHR)* pPresentInfo) {
        assert(_QueuePresentKHR !is null, "vkQueuePresentKHR was not loaded. Requested by VK_KHR_swapchain");
        return _QueuePresentKHR(queue, pPresentInfo);
    }
    /// ditto
    VkResult GetDeviceGroupPresentCapabilitiesKHR (VkDevice device, VkDeviceGroupPresentCapabilitiesKHR* pDeviceGroupPresentCapabilities) {
        assert(_GetDeviceGroupPresentCapabilitiesKHR !is null, "vkGetDeviceGroupPresentCapabilitiesKHR was not loaded. Requested by VK_KHR_swapchain");
        return _GetDeviceGroupPresentCapabilitiesKHR(device, pDeviceGroupPresentCapabilities);
    }
    /// ditto
    VkResult GetDeviceGroupSurfacePresentModesKHR (VkDevice device, VkSurfaceKHR surface, VkDeviceGroupPresentModeFlagsKHR* pModes) {
        assert(_GetDeviceGroupSurfacePresentModesKHR !is null, "vkGetDeviceGroupSurfacePresentModesKHR was not loaded. Requested by VK_KHR_swapchain");
        return _GetDeviceGroupSurfacePresentModesKHR(device, surface, pModes);
    }
    /// ditto
    VkResult AcquireNextImage2KHR (VkDevice device, const(VkAcquireNextImageInfoKHR)* pAcquireInfo, uint32_t* pImageIndex) {
        assert(_AcquireNextImage2KHR !is null, "vkAcquireNextImage2KHR was not loaded. Requested by VK_KHR_swapchain");
        return _AcquireNextImage2KHR(device, pAcquireInfo, pImageIndex);
    }

    // fields for VK_VERSION_1_0
    private PFN_vkDestroyDevice                        _DestroyDevice;
    private PFN_vkGetDeviceQueue                       _GetDeviceQueue;
    private PFN_vkQueueSubmit                          _QueueSubmit;
    private PFN_vkQueueWaitIdle                        _QueueWaitIdle;
    private PFN_vkDeviceWaitIdle                       _DeviceWaitIdle;
    private PFN_vkAllocateMemory                       _AllocateMemory;
    private PFN_vkFreeMemory                           _FreeMemory;
    private PFN_vkMapMemory                            _MapMemory;
    private PFN_vkUnmapMemory                          _UnmapMemory;
    private PFN_vkFlushMappedMemoryRanges              _FlushMappedMemoryRanges;
    private PFN_vkInvalidateMappedMemoryRanges         _InvalidateMappedMemoryRanges;
    private PFN_vkGetDeviceMemoryCommitment            _GetDeviceMemoryCommitment;
    private PFN_vkBindBufferMemory                     _BindBufferMemory;
    private PFN_vkBindImageMemory                      _BindImageMemory;
    private PFN_vkGetBufferMemoryRequirements          _GetBufferMemoryRequirements;
    private PFN_vkGetImageMemoryRequirements           _GetImageMemoryRequirements;
    private PFN_vkGetImageSparseMemoryRequirements     _GetImageSparseMemoryRequirements;
    private PFN_vkQueueBindSparse                      _QueueBindSparse;
    private PFN_vkCreateFence                          _CreateFence;
    private PFN_vkDestroyFence                         _DestroyFence;
    private PFN_vkResetFences                          _ResetFences;
    private PFN_vkGetFenceStatus                       _GetFenceStatus;
    private PFN_vkWaitForFences                        _WaitForFences;
    private PFN_vkCreateSemaphore                      _CreateSemaphore;
    private PFN_vkDestroySemaphore                     _DestroySemaphore;
    private PFN_vkCreateEvent                          _CreateEvent;
    private PFN_vkDestroyEvent                         _DestroyEvent;
    private PFN_vkGetEventStatus                       _GetEventStatus;
    private PFN_vkSetEvent                             _SetEvent;
    private PFN_vkResetEvent                           _ResetEvent;
    private PFN_vkCreateQueryPool                      _CreateQueryPool;
    private PFN_vkDestroyQueryPool                     _DestroyQueryPool;
    private PFN_vkGetQueryPoolResults                  _GetQueryPoolResults;
    private PFN_vkCreateBuffer                         _CreateBuffer;
    private PFN_vkDestroyBuffer                        _DestroyBuffer;
    private PFN_vkCreateBufferView                     _CreateBufferView;
    private PFN_vkDestroyBufferView                    _DestroyBufferView;
    private PFN_vkCreateImage                          _CreateImage;
    private PFN_vkDestroyImage                         _DestroyImage;
    private PFN_vkGetImageSubresourceLayout            _GetImageSubresourceLayout;
    private PFN_vkCreateImageView                      _CreateImageView;
    private PFN_vkDestroyImageView                     _DestroyImageView;
    private PFN_vkCreateShaderModule                   _CreateShaderModule;
    private PFN_vkDestroyShaderModule                  _DestroyShaderModule;
    private PFN_vkCreatePipelineCache                  _CreatePipelineCache;
    private PFN_vkDestroyPipelineCache                 _DestroyPipelineCache;
    private PFN_vkGetPipelineCacheData                 _GetPipelineCacheData;
    private PFN_vkMergePipelineCaches                  _MergePipelineCaches;
    private PFN_vkCreateGraphicsPipelines              _CreateGraphicsPipelines;
    private PFN_vkCreateComputePipelines               _CreateComputePipelines;
    private PFN_vkDestroyPipeline                      _DestroyPipeline;
    private PFN_vkCreatePipelineLayout                 _CreatePipelineLayout;
    private PFN_vkDestroyPipelineLayout                _DestroyPipelineLayout;
    private PFN_vkCreateSampler                        _CreateSampler;
    private PFN_vkDestroySampler                       _DestroySampler;
    private PFN_vkCreateDescriptorSetLayout            _CreateDescriptorSetLayout;
    private PFN_vkDestroyDescriptorSetLayout           _DestroyDescriptorSetLayout;
    private PFN_vkCreateDescriptorPool                 _CreateDescriptorPool;
    private PFN_vkDestroyDescriptorPool                _DestroyDescriptorPool;
    private PFN_vkResetDescriptorPool                  _ResetDescriptorPool;
    private PFN_vkAllocateDescriptorSets               _AllocateDescriptorSets;
    private PFN_vkFreeDescriptorSets                   _FreeDescriptorSets;
    private PFN_vkUpdateDescriptorSets                 _UpdateDescriptorSets;
    private PFN_vkCreateFramebuffer                    _CreateFramebuffer;
    private PFN_vkDestroyFramebuffer                   _DestroyFramebuffer;
    private PFN_vkCreateRenderPass                     _CreateRenderPass;
    private PFN_vkDestroyRenderPass                    _DestroyRenderPass;
    private PFN_vkGetRenderAreaGranularity             _GetRenderAreaGranularity;
    private PFN_vkCreateCommandPool                    _CreateCommandPool;
    private PFN_vkDestroyCommandPool                   _DestroyCommandPool;
    private PFN_vkResetCommandPool                     _ResetCommandPool;
    private PFN_vkAllocateCommandBuffers               _AllocateCommandBuffers;
    private PFN_vkFreeCommandBuffers                   _FreeCommandBuffers;
    private PFN_vkBeginCommandBuffer                   _BeginCommandBuffer;
    private PFN_vkEndCommandBuffer                     _EndCommandBuffer;
    private PFN_vkResetCommandBuffer                   _ResetCommandBuffer;
    private PFN_vkCmdBindPipeline                      _CmdBindPipeline;
    private PFN_vkCmdSetViewport                       _CmdSetViewport;
    private PFN_vkCmdSetScissor                        _CmdSetScissor;
    private PFN_vkCmdSetLineWidth                      _CmdSetLineWidth;
    private PFN_vkCmdSetDepthBias                      _CmdSetDepthBias;
    private PFN_vkCmdSetBlendConstants                 _CmdSetBlendConstants;
    private PFN_vkCmdSetDepthBounds                    _CmdSetDepthBounds;
    private PFN_vkCmdSetStencilCompareMask             _CmdSetStencilCompareMask;
    private PFN_vkCmdSetStencilWriteMask               _CmdSetStencilWriteMask;
    private PFN_vkCmdSetStencilReference               _CmdSetStencilReference;
    private PFN_vkCmdBindDescriptorSets                _CmdBindDescriptorSets;
    private PFN_vkCmdBindIndexBuffer                   _CmdBindIndexBuffer;
    private PFN_vkCmdBindVertexBuffers                 _CmdBindVertexBuffers;
    private PFN_vkCmdDraw                              _CmdDraw;
    private PFN_vkCmdDrawIndexed                       _CmdDrawIndexed;
    private PFN_vkCmdDrawIndirect                      _CmdDrawIndirect;
    private PFN_vkCmdDrawIndexedIndirect               _CmdDrawIndexedIndirect;
    private PFN_vkCmdDispatch                          _CmdDispatch;
    private PFN_vkCmdDispatchIndirect                  _CmdDispatchIndirect;
    private PFN_vkCmdCopyBuffer                        _CmdCopyBuffer;
    private PFN_vkCmdCopyImage                         _CmdCopyImage;
    private PFN_vkCmdBlitImage                         _CmdBlitImage;
    private PFN_vkCmdCopyBufferToImage                 _CmdCopyBufferToImage;
    private PFN_vkCmdCopyImageToBuffer                 _CmdCopyImageToBuffer;
    private PFN_vkCmdUpdateBuffer                      _CmdUpdateBuffer;
    private PFN_vkCmdFillBuffer                        _CmdFillBuffer;
    private PFN_vkCmdClearColorImage                   _CmdClearColorImage;
    private PFN_vkCmdClearDepthStencilImage            _CmdClearDepthStencilImage;
    private PFN_vkCmdClearAttachments                  _CmdClearAttachments;
    private PFN_vkCmdResolveImage                      _CmdResolveImage;
    private PFN_vkCmdSetEvent                          _CmdSetEvent;
    private PFN_vkCmdResetEvent                        _CmdResetEvent;
    private PFN_vkCmdWaitEvents                        _CmdWaitEvents;
    private PFN_vkCmdPipelineBarrier                   _CmdPipelineBarrier;
    private PFN_vkCmdBeginQuery                        _CmdBeginQuery;
    private PFN_vkCmdEndQuery                          _CmdEndQuery;
    private PFN_vkCmdResetQueryPool                    _CmdResetQueryPool;
    private PFN_vkCmdWriteTimestamp                    _CmdWriteTimestamp;
    private PFN_vkCmdCopyQueryPoolResults              _CmdCopyQueryPoolResults;
    private PFN_vkCmdPushConstants                     _CmdPushConstants;
    private PFN_vkCmdBeginRenderPass                   _CmdBeginRenderPass;
    private PFN_vkCmdNextSubpass                       _CmdNextSubpass;
    private PFN_vkCmdEndRenderPass                     _CmdEndRenderPass;
    private PFN_vkCmdExecuteCommands                   _CmdExecuteCommands;

    // fields for VK_VERSION_1_1
    private PFN_vkBindBufferMemory2                    _BindBufferMemory2;
    private PFN_vkBindImageMemory2                     _BindImageMemory2;
    private PFN_vkGetDeviceGroupPeerMemoryFeatures     _GetDeviceGroupPeerMemoryFeatures;
    private PFN_vkCmdSetDeviceMask                     _CmdSetDeviceMask;
    private PFN_vkCmdDispatchBase                      _CmdDispatchBase;
    private PFN_vkGetImageMemoryRequirements2          _GetImageMemoryRequirements2;
    private PFN_vkGetBufferMemoryRequirements2         _GetBufferMemoryRequirements2;
    private PFN_vkGetImageSparseMemoryRequirements2    _GetImageSparseMemoryRequirements2;
    private PFN_vkTrimCommandPool                      _TrimCommandPool;
    private PFN_vkGetDeviceQueue2                      _GetDeviceQueue2;
    private PFN_vkCreateSamplerYcbcrConversion         _CreateSamplerYcbcrConversion;
    private PFN_vkDestroySamplerYcbcrConversion        _DestroySamplerYcbcrConversion;
    private PFN_vkCreateDescriptorUpdateTemplate       _CreateDescriptorUpdateTemplate;
    private PFN_vkDestroyDescriptorUpdateTemplate      _DestroyDescriptorUpdateTemplate;
    private PFN_vkUpdateDescriptorSetWithTemplate      _UpdateDescriptorSetWithTemplate;
    private PFN_vkGetDescriptorSetLayoutSupport        _GetDescriptorSetLayoutSupport;

    // fields for VK_KHR_swapchain
    private PFN_vkCreateSwapchainKHR                   _CreateSwapchainKHR;
    private PFN_vkDestroySwapchainKHR                  _DestroySwapchainKHR;
    private PFN_vkGetSwapchainImagesKHR                _GetSwapchainImagesKHR;
    private PFN_vkAcquireNextImageKHR                  _AcquireNextImageKHR;
    private PFN_vkQueuePresentKHR                      _QueuePresentKHR;
    private PFN_vkGetDeviceGroupPresentCapabilitiesKHR _GetDeviceGroupPresentCapabilitiesKHR;
    private PFN_vkGetDeviceGroupSurfacePresentModesKHR _GetDeviceGroupSurfacePresentModesKHR;
    private PFN_vkAcquireNextImage2KHR                 _AcquireNextImage2KHR;
}
