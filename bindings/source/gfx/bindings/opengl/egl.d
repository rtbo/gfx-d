/// EGL bindings for D. Generated automatically by gldgen.py
module gfx.bindings.opengl.egl;

import core.stdc.stdint;
import gfx.bindings.core;
import gfx.bindings.opengl.eglplatform;
import gfx.bindings.opengl.khrplatform;

// Base Types

// Types for EGL_VERSION_1_0
alias EGLBoolean = uint;
alias EGLDisplay = void *;
alias EGLConfig  = void *;
alias EGLSurface = void *;
alias EGLContext = void *;

// Types for EGL_VERSION_1_2
alias EGLenum         = uint;
alias EGLClientBuffer = void *;

// Types for EGL_VERSION_1_5
alias EGLSync   = void *;
alias EGLAttrib = intptr_t;
alias EGLTime   = khronos_utime_nanoseconds_t;
alias EGLImage  = void *;

// Types for EGL_KHR_cl_event2
alias EGLSyncKHR   = void *;
alias EGLAttribKHR = intptr_t;

// Types for EGL_KHR_debug
alias EGLLabelKHR  = void *;
alias EGLObjectKHR = void *;

// Types for EGL_KHR_fence_sync
alias EGLTimeKHR = khronos_utime_nanoseconds_t;

// Types for EGL_KHR_image
alias EGLImageKHR = void *;

// Types for EGL_KHR_stream
alias EGLStreamKHR = void *;
alias EGLuint64KHR = khronos_uint64_t;

// Types for EGL_KHR_stream_cross_process_fd
alias EGLNativeFileDescriptorKHR = int;

// Types for EGL_ANDROID_blob_cache
alias EGLsizeiANDROID = khronos_ssize_t;

// Types for EGL_ANDROID_get_frame_timestamps
alias EGLnsecsANDROID = khronos_stime_nanoseconds_t;

// Types for EGL_EXT_device_base
alias EGLDeviceEXT = void *;

// Types for EGL_EXT_output_base
alias EGLOutputLayerEXT = void *;
alias EGLOutputPortEXT  = void *;

// Types for EGL_NV_sync
alias EGLSyncNV = void *;
alias EGLTimeNV = khronos_utime_nanoseconds_t;

// Types for EGL_NV_system_time
alias EGLuint64NV = khronos_utime_nanoseconds_t;

// Struct declarations
struct AHardwareBuffer;

// struct definitions
// Structs for EGL_HI_clientpixmap
struct EGLClientPixmapHI {
    void  * pData;
    EGLint iWidth;
    EGLint iHeight;
    EGLint iStride;
}

// Function pointers

extern(C) nothrow @nogc {

    // for EGL_VERSION_1_0
    alias __eglMustCastToProperFunctionPointerType = void function();

    // for EGL_KHR_debug
    alias EGLDEBUGPROCKHR = void function(
        EGLenum      error,
        const(char)* command,
        EGLint       messageType,
        EGLLabelKHR  threadLabel,
        EGLLabelKHR  objectLabel,
        const(char)* message
    );

    // for EGL_ANDROID_blob_cache
    alias EGLSetBlobFuncANDROID = void function(
        const(void)*    key,
        EGLsizeiANDROID keySize,
        const(void)*    value,
        EGLsizeiANDROID valueSize
    );
    alias EGLGetBlobFuncANDROID = EGLsizeiANDROID function(
        const(void)*    key,
        EGLsizeiANDROID keySize,
        void *          value,
        EGLsizeiANDROID valueSize
    );
}


// Constants for EGL_VERSION_1_0
enum EGL_ALPHA_SIZE              = 0x3021;
enum EGL_BAD_ACCESS              = 0x3002;
enum EGL_BAD_ALLOC               = 0x3003;
enum EGL_BAD_ATTRIBUTE           = 0x3004;
enum EGL_BAD_CONFIG              = 0x3005;
enum EGL_BAD_CONTEXT             = 0x3006;
enum EGL_BAD_CURRENT_SURFACE     = 0x3007;
enum EGL_BAD_DISPLAY             = 0x3008;
enum EGL_BAD_MATCH               = 0x3009;
enum EGL_BAD_NATIVE_PIXMAP       = 0x300A;
enum EGL_BAD_NATIVE_WINDOW       = 0x300B;
enum EGL_BAD_PARAMETER           = 0x300C;
enum EGL_BAD_SURFACE             = 0x300D;
enum EGL_BLUE_SIZE               = 0x3022;
enum EGL_BUFFER_SIZE             = 0x3020;
enum EGL_CONFIG_CAVEAT           = 0x3027;
enum EGL_CONFIG_ID               = 0x3028;
enum EGL_CORE_NATIVE_ENGINE      = 0x305B;
enum EGL_DEPTH_SIZE              = 0x3025;
enum EGL_DONT_CARE               = EGL_CAST!(EGLint)(-1);
enum EGL_DRAW                    = 0x3059;
enum EGL_EXTENSIONS              = 0x3055;
enum EGL_FALSE                   = 0;
enum EGL_GREEN_SIZE              = 0x3023;
enum EGL_HEIGHT                  = 0x3056;
enum EGL_LARGEST_PBUFFER         = 0x3058;
enum EGL_LEVEL                   = 0x3029;
enum EGL_MAX_PBUFFER_HEIGHT      = 0x302A;
enum EGL_MAX_PBUFFER_PIXELS      = 0x302B;
enum EGL_MAX_PBUFFER_WIDTH       = 0x302C;
enum EGL_NATIVE_RENDERABLE       = 0x302D;
enum EGL_NATIVE_VISUAL_ID        = 0x302E;
enum EGL_NATIVE_VISUAL_TYPE      = 0x302F;
enum EGL_NONE                    = 0x3038;
enum EGL_NON_CONFORMANT_CONFIG   = 0x3051;
enum EGL_NOT_INITIALIZED         = 0x3001;
enum EGL_NO_CONTEXT              = EGL_CAST!(EGLContext)(0);
enum EGL_NO_DISPLAY              = EGL_CAST!(EGLDisplay)(0);
enum EGL_NO_SURFACE              = EGL_CAST!(EGLSurface)(0);
enum EGL_PBUFFER_BIT             = 0x0001;
enum EGL_PIXMAP_BIT              = 0x0002;
enum EGL_READ                    = 0x305A;
enum EGL_RED_SIZE                = 0x3024;
enum EGL_SAMPLES                 = 0x3031;
enum EGL_SAMPLE_BUFFERS          = 0x3032;
enum EGL_SLOW_CONFIG             = 0x3050;
enum EGL_STENCIL_SIZE            = 0x3026;
enum EGL_SUCCESS                 = 0x3000;
enum EGL_SURFACE_TYPE            = 0x3033;
enum EGL_TRANSPARENT_BLUE_VALUE  = 0x3035;
enum EGL_TRANSPARENT_GREEN_VALUE = 0x3036;
enum EGL_TRANSPARENT_RED_VALUE   = 0x3037;
enum EGL_TRANSPARENT_RGB         = 0x3052;
enum EGL_TRANSPARENT_TYPE        = 0x3034;
enum EGL_TRUE                    = 1;
enum EGL_VENDOR                  = 0x3053;
enum EGL_VERSION                 = 0x3054;
enum EGL_WIDTH                   = 0x3057;
enum EGL_WINDOW_BIT              = 0x0004;

// Constants for EGL_VERSION_1_1
enum EGL_BACK_BUFFER          = 0x3084;
enum EGL_BIND_TO_TEXTURE_RGB  = 0x3039;
enum EGL_BIND_TO_TEXTURE_RGBA = 0x303A;
enum EGL_CONTEXT_LOST         = 0x300E;
enum EGL_MIN_SWAP_INTERVAL    = 0x303B;
enum EGL_MAX_SWAP_INTERVAL    = 0x303C;
enum EGL_MIPMAP_TEXTURE       = 0x3082;
enum EGL_MIPMAP_LEVEL         = 0x3083;
enum EGL_NO_TEXTURE           = 0x305C;
enum EGL_TEXTURE_2D           = 0x305F;
enum EGL_TEXTURE_FORMAT       = 0x3080;
enum EGL_TEXTURE_RGB          = 0x305D;
enum EGL_TEXTURE_RGBA         = 0x305E;
enum EGL_TEXTURE_TARGET       = 0x3081;

// Constants for EGL_VERSION_1_2
enum EGL_ALPHA_FORMAT          = 0x3088;
enum EGL_ALPHA_FORMAT_NONPRE   = 0x308B;
enum EGL_ALPHA_FORMAT_PRE      = 0x308C;
enum EGL_ALPHA_MASK_SIZE       = 0x303E;
enum EGL_BUFFER_PRESERVED      = 0x3094;
enum EGL_BUFFER_DESTROYED      = 0x3095;
enum EGL_CLIENT_APIS           = 0x308D;
enum EGL_COLORSPACE            = 0x3087;
enum EGL_COLORSPACE_sRGB       = 0x3089;
enum EGL_COLORSPACE_LINEAR     = 0x308A;
enum EGL_COLOR_BUFFER_TYPE     = 0x303F;
enum EGL_CONTEXT_CLIENT_TYPE   = 0x3097;
enum EGL_DISPLAY_SCALING       = 10000;
enum EGL_HORIZONTAL_RESOLUTION = 0x3090;
enum EGL_LUMINANCE_BUFFER      = 0x308F;
enum EGL_LUMINANCE_SIZE        = 0x303D;
enum EGL_OPENGL_ES_BIT         = 0x0001;
enum EGL_OPENVG_BIT            = 0x0002;
enum EGL_OPENGL_ES_API         = 0x30A0;
enum EGL_OPENVG_API            = 0x30A1;
enum EGL_OPENVG_IMAGE          = 0x3096;
enum EGL_PIXEL_ASPECT_RATIO    = 0x3092;
enum EGL_RENDERABLE_TYPE       = 0x3040;
enum EGL_RENDER_BUFFER         = 0x3086;
enum EGL_RGB_BUFFER            = 0x308E;
enum EGL_SINGLE_BUFFER         = 0x3085;
enum EGL_SWAP_BEHAVIOR         = 0x3093;
enum EGL_UNKNOWN               = EGL_CAST!(EGLint)(-1);
enum EGL_VERTICAL_RESOLUTION   = 0x3091;

// Constants for EGL_VERSION_1_3
enum EGL_CONFORMANT               = 0x3042;
enum EGL_CONTEXT_CLIENT_VERSION   = 0x3098;
enum EGL_MATCH_NATIVE_PIXMAP      = 0x3041;
enum EGL_OPENGL_ES2_BIT           = 0x0004;
enum EGL_VG_ALPHA_FORMAT          = 0x3088;
enum EGL_VG_ALPHA_FORMAT_NONPRE   = 0x308B;
enum EGL_VG_ALPHA_FORMAT_PRE      = 0x308C;
enum EGL_VG_ALPHA_FORMAT_PRE_BIT  = 0x0040;
enum EGL_VG_COLORSPACE            = 0x3087;
enum EGL_VG_COLORSPACE_sRGB       = 0x3089;
enum EGL_VG_COLORSPACE_LINEAR     = 0x308A;
enum EGL_VG_COLORSPACE_LINEAR_BIT = 0x0020;

// Constants for EGL_VERSION_1_4
enum EGL_DEFAULT_DISPLAY             = EGL_CAST!(EGLNativeDisplayType)(0);
enum EGL_MULTISAMPLE_RESOLVE_BOX_BIT = 0x0200;
enum EGL_MULTISAMPLE_RESOLVE         = 0x3099;
enum EGL_MULTISAMPLE_RESOLVE_DEFAULT = 0x309A;
enum EGL_MULTISAMPLE_RESOLVE_BOX     = 0x309B;
enum EGL_OPENGL_API                  = 0x30A2;
enum EGL_OPENGL_BIT                  = 0x0008;
enum EGL_SWAP_BEHAVIOR_PRESERVED_BIT = 0x0400;

// Constants for EGL_VERSION_1_5
enum EGL_CONTEXT_MAJOR_VERSION                      = 0x3098;
enum EGL_CONTEXT_MINOR_VERSION                      = 0x30FB;
enum EGL_CONTEXT_OPENGL_PROFILE_MASK                = 0x30FD;
enum EGL_CONTEXT_OPENGL_RESET_NOTIFICATION_STRATEGY = 0x31BD;
enum EGL_NO_RESET_NOTIFICATION                      = 0x31BE;
enum EGL_LOSE_CONTEXT_ON_RESET                      = 0x31BF;
enum EGL_CONTEXT_OPENGL_CORE_PROFILE_BIT            = 0x00000001;
enum EGL_CONTEXT_OPENGL_COMPATIBILITY_PROFILE_BIT   = 0x00000002;
enum EGL_CONTEXT_OPENGL_DEBUG                       = 0x31B0;
enum EGL_CONTEXT_OPENGL_FORWARD_COMPATIBLE          = 0x31B1;
enum EGL_CONTEXT_OPENGL_ROBUST_ACCESS               = 0x31B2;
enum EGL_OPENGL_ES3_BIT                             = 0x00000040;
enum EGL_CL_EVENT_HANDLE                            = 0x309C;
enum EGL_SYNC_CL_EVENT                              = 0x30FE;
enum EGL_SYNC_CL_EVENT_COMPLETE                     = 0x30FF;
enum EGL_SYNC_PRIOR_COMMANDS_COMPLETE               = 0x30F0;
enum EGL_SYNC_TYPE                                  = 0x30F7;
enum EGL_SYNC_STATUS                                = 0x30F1;
enum EGL_SYNC_CONDITION                             = 0x30F8;
enum EGL_SIGNALED                                   = 0x30F2;
enum EGL_UNSIGNALED                                 = 0x30F3;
enum EGL_SYNC_FLUSH_COMMANDS_BIT                    = 0x0001;
enum EGL_FOREVER                                    = 0xFFFFFFFFFFFFFFFF;
enum EGL_TIMEOUT_EXPIRED                            = 0x30F5;
enum EGL_CONDITION_SATISFIED                        = 0x30F6;
enum EGL_NO_SYNC                                    = EGL_CAST!(EGLSync)(0);
enum EGL_SYNC_FENCE                                 = 0x30F9;
enum EGL_GL_COLORSPACE                              = 0x309D;
enum EGL_GL_COLORSPACE_SRGB                         = 0x3089;
enum EGL_GL_COLORSPACE_LINEAR                       = 0x308A;
enum EGL_GL_RENDERBUFFER                            = 0x30B9;
enum EGL_GL_TEXTURE_2D                              = 0x30B1;
enum EGL_GL_TEXTURE_LEVEL                           = 0x30BC;
enum EGL_GL_TEXTURE_3D                              = 0x30B2;
enum EGL_GL_TEXTURE_ZOFFSET                         = 0x30BD;
enum EGL_GL_TEXTURE_CUBE_MAP_POSITIVE_X             = 0x30B3;
enum EGL_GL_TEXTURE_CUBE_MAP_NEGATIVE_X             = 0x30B4;
enum EGL_GL_TEXTURE_CUBE_MAP_POSITIVE_Y             = 0x30B5;
enum EGL_GL_TEXTURE_CUBE_MAP_NEGATIVE_Y             = 0x30B6;
enum EGL_GL_TEXTURE_CUBE_MAP_POSITIVE_Z             = 0x30B7;
enum EGL_GL_TEXTURE_CUBE_MAP_NEGATIVE_Z             = 0x30B8;
enum EGL_IMAGE_PRESERVED                            = 0x30D2;
enum EGL_NO_IMAGE                                   = EGL_CAST!(EGLImage)(0);

// Constants for EGL_KHR_cl_event
enum EGL_CL_EVENT_HANDLE_KHR        = 0x309C;
enum EGL_SYNC_CL_EVENT_KHR          = 0x30FE;
enum EGL_SYNC_CL_EVENT_COMPLETE_KHR = 0x30FF;

// Constants for EGL_KHR_config_attribs
enum EGL_CONFORMANT_KHR               = 0x3042;
enum EGL_VG_COLORSPACE_LINEAR_BIT_KHR = 0x0020;
enum EGL_VG_ALPHA_FORMAT_PRE_BIT_KHR  = 0x0040;

// Constants for EGL_KHR_context_flush_control
enum EGL_CONTEXT_RELEASE_BEHAVIOR_NONE_KHR  = 0;
enum EGL_CONTEXT_RELEASE_BEHAVIOR_KHR       = 0x2097;
enum EGL_CONTEXT_RELEASE_BEHAVIOR_FLUSH_KHR = 0x2098;

// Constants for EGL_KHR_create_context
enum EGL_CONTEXT_MAJOR_VERSION_KHR                      = 0x3098;
enum EGL_CONTEXT_MINOR_VERSION_KHR                      = 0x30FB;
enum EGL_CONTEXT_FLAGS_KHR                              = 0x30FC;
enum EGL_CONTEXT_OPENGL_PROFILE_MASK_KHR                = 0x30FD;
enum EGL_CONTEXT_OPENGL_RESET_NOTIFICATION_STRATEGY_KHR = 0x31BD;
enum EGL_NO_RESET_NOTIFICATION_KHR                      = 0x31BE;
enum EGL_LOSE_CONTEXT_ON_RESET_KHR                      = 0x31BF;
enum EGL_CONTEXT_OPENGL_DEBUG_BIT_KHR                   = 0x00000001;
enum EGL_CONTEXT_OPENGL_FORWARD_COMPATIBLE_BIT_KHR      = 0x00000002;
enum EGL_CONTEXT_OPENGL_ROBUST_ACCESS_BIT_KHR           = 0x00000004;
enum EGL_CONTEXT_OPENGL_CORE_PROFILE_BIT_KHR            = 0x00000001;
enum EGL_CONTEXT_OPENGL_COMPATIBILITY_PROFILE_BIT_KHR   = 0x00000002;
enum EGL_OPENGL_ES3_BIT_KHR                             = 0x00000040;

// Constants for EGL_KHR_create_context_no_error
enum EGL_CONTEXT_OPENGL_NO_ERROR_KHR = 0x31B3;

// Constants for EGL_KHR_debug
enum EGL_OBJECT_THREAD_KHR      = 0x33B0;
enum EGL_OBJECT_DISPLAY_KHR     = 0x33B1;
enum EGL_OBJECT_CONTEXT_KHR     = 0x33B2;
enum EGL_OBJECT_SURFACE_KHR     = 0x33B3;
enum EGL_OBJECT_IMAGE_KHR       = 0x33B4;
enum EGL_OBJECT_SYNC_KHR        = 0x33B5;
enum EGL_OBJECT_STREAM_KHR      = 0x33B6;
enum EGL_DEBUG_MSG_CRITICAL_KHR = 0x33B9;
enum EGL_DEBUG_MSG_ERROR_KHR    = 0x33BA;
enum EGL_DEBUG_MSG_WARN_KHR     = 0x33BB;
enum EGL_DEBUG_MSG_INFO_KHR     = 0x33BC;
enum EGL_DEBUG_CALLBACK_KHR     = 0x33B8;

// Constants for EGL_KHR_display_reference
enum EGL_TRACK_REFERENCES_KHR = 0x3352;

// Constants for EGL_KHR_fence_sync
enum EGL_SYNC_PRIOR_COMMANDS_COMPLETE_KHR = 0x30F0;
enum EGL_SYNC_CONDITION_KHR               = 0x30F8;
enum EGL_SYNC_FENCE_KHR                   = 0x30F9;

// Constants for EGL_KHR_gl_colorspace
enum EGL_GL_COLORSPACE_KHR        = 0x309D;
enum EGL_GL_COLORSPACE_SRGB_KHR   = 0x3089;
enum EGL_GL_COLORSPACE_LINEAR_KHR = 0x308A;

// Constants for EGL_KHR_gl_renderbuffer_image
enum EGL_GL_RENDERBUFFER_KHR = 0x30B9;

// Constants for EGL_KHR_gl_texture_2D_image
enum EGL_GL_TEXTURE_2D_KHR    = 0x30B1;
enum EGL_GL_TEXTURE_LEVEL_KHR = 0x30BC;

// Constants for EGL_KHR_gl_texture_3D_image
enum EGL_GL_TEXTURE_3D_KHR      = 0x30B2;
enum EGL_GL_TEXTURE_ZOFFSET_KHR = 0x30BD;

// Constants for EGL_KHR_gl_texture_cubemap_image
enum EGL_GL_TEXTURE_CUBE_MAP_POSITIVE_X_KHR = 0x30B3;
enum EGL_GL_TEXTURE_CUBE_MAP_NEGATIVE_X_KHR = 0x30B4;
enum EGL_GL_TEXTURE_CUBE_MAP_POSITIVE_Y_KHR = 0x30B5;
enum EGL_GL_TEXTURE_CUBE_MAP_NEGATIVE_Y_KHR = 0x30B6;
enum EGL_GL_TEXTURE_CUBE_MAP_POSITIVE_Z_KHR = 0x30B7;
enum EGL_GL_TEXTURE_CUBE_MAP_NEGATIVE_Z_KHR = 0x30B8;

// Constants for EGL_KHR_image
enum EGL_NATIVE_PIXMAP_KHR = 0x30B0;
enum EGL_NO_IMAGE_KHR      = EGL_CAST!(EGLImageKHR)(0);

// Constants for EGL_KHR_image_base
enum EGL_IMAGE_PRESERVED_KHR = 0x30D2;

// Constants for EGL_KHR_lock_surface
enum EGL_READ_SURFACE_BIT_KHR              = 0x0001;
enum EGL_WRITE_SURFACE_BIT_KHR             = 0x0002;
enum EGL_LOCK_SURFACE_BIT_KHR              = 0x0080;
enum EGL_OPTIMAL_FORMAT_BIT_KHR            = 0x0100;
enum EGL_MATCH_FORMAT_KHR                  = 0x3043;
enum EGL_FORMAT_RGB_565_EXACT_KHR          = 0x30C0;
enum EGL_FORMAT_RGB_565_KHR                = 0x30C1;
enum EGL_FORMAT_RGBA_8888_EXACT_KHR        = 0x30C2;
enum EGL_FORMAT_RGBA_8888_KHR              = 0x30C3;
enum EGL_MAP_PRESERVE_PIXELS_KHR           = 0x30C4;
enum EGL_LOCK_USAGE_HINT_KHR               = 0x30C5;
enum EGL_BITMAP_POINTER_KHR                = 0x30C6;
enum EGL_BITMAP_PITCH_KHR                  = 0x30C7;
enum EGL_BITMAP_ORIGIN_KHR                 = 0x30C8;
enum EGL_BITMAP_PIXEL_RED_OFFSET_KHR       = 0x30C9;
enum EGL_BITMAP_PIXEL_GREEN_OFFSET_KHR     = 0x30CA;
enum EGL_BITMAP_PIXEL_BLUE_OFFSET_KHR      = 0x30CB;
enum EGL_BITMAP_PIXEL_ALPHA_OFFSET_KHR     = 0x30CC;
enum EGL_BITMAP_PIXEL_LUMINANCE_OFFSET_KHR = 0x30CD;
enum EGL_LOWER_LEFT_KHR                    = 0x30CE;
enum EGL_UPPER_LEFT_KHR                    = 0x30CF;

// Constants for EGL_KHR_lock_surface2
enum EGL_BITMAP_PIXEL_SIZE_KHR = 0x3110;

// Constants for EGL_KHR_mutable_render_buffer
enum EGL_MUTABLE_RENDER_BUFFER_BIT_KHR = 0x1000;

// Constants for EGL_KHR_no_config_context
enum EGL_NO_CONFIG_KHR = EGL_CAST!(EGLConfig)(0);

// Constants for EGL_KHR_partial_update
enum EGL_BUFFER_AGE_KHR = 0x313D;

// Constants for EGL_KHR_platform_android
enum EGL_PLATFORM_ANDROID_KHR = 0x3141;

// Constants for EGL_KHR_platform_gbm
enum EGL_PLATFORM_GBM_KHR = 0x31D7;

// Constants for EGL_KHR_platform_wayland
enum EGL_PLATFORM_WAYLAND_KHR = 0x31D8;

// Constants for EGL_KHR_platform_x11
enum EGL_PLATFORM_X11_KHR        = 0x31D5;
enum EGL_PLATFORM_X11_SCREEN_KHR = 0x31D6;

// Constants for EGL_KHR_reusable_sync
enum EGL_SYNC_STATUS_KHR             = 0x30F1;
enum EGL_SIGNALED_KHR                = 0x30F2;
enum EGL_UNSIGNALED_KHR              = 0x30F3;
enum EGL_TIMEOUT_EXPIRED_KHR         = 0x30F5;
enum EGL_CONDITION_SATISFIED_KHR     = 0x30F6;
enum EGL_SYNC_TYPE_KHR               = 0x30F7;
enum EGL_SYNC_REUSABLE_KHR           = 0x30FA;
enum EGL_SYNC_FLUSH_COMMANDS_BIT_KHR = 0x0001;
enum EGL_FOREVER_KHR                 = 0xFFFFFFFFFFFFFFFF;
enum EGL_NO_SYNC_KHR                 = EGL_CAST!(EGLSyncKHR)(0);

// Constants for EGL_KHR_stream
enum EGL_NO_STREAM_KHR                        = EGL_CAST!(EGLStreamKHR)(0);
enum EGL_CONSUMER_LATENCY_USEC_KHR            = 0x3210;
enum EGL_PRODUCER_FRAME_KHR                   = 0x3212;
enum EGL_CONSUMER_FRAME_KHR                   = 0x3213;
enum EGL_STREAM_STATE_KHR                     = 0x3214;
enum EGL_STREAM_STATE_CREATED_KHR             = 0x3215;
enum EGL_STREAM_STATE_CONNECTING_KHR          = 0x3216;
enum EGL_STREAM_STATE_EMPTY_KHR               = 0x3217;
enum EGL_STREAM_STATE_NEW_FRAME_AVAILABLE_KHR = 0x3218;
enum EGL_STREAM_STATE_OLD_FRAME_AVAILABLE_KHR = 0x3219;
enum EGL_STREAM_STATE_DISCONNECTED_KHR        = 0x321A;
enum EGL_BAD_STREAM_KHR                       = 0x321B;
enum EGL_BAD_STATE_KHR                        = 0x321C;

// Constants for EGL_KHR_stream_consumer_gltexture
enum EGL_CONSUMER_ACQUIRE_TIMEOUT_USEC_KHR = 0x321E;

// Constants for EGL_KHR_stream_cross_process_fd
enum EGL_NO_FILE_DESCRIPTOR_KHR = EGL_CAST!(EGLNativeFileDescriptorKHR)(-1);

// Constants for EGL_KHR_stream_fifo
enum EGL_STREAM_FIFO_LENGTH_KHR   = 0x31FC;
enum EGL_STREAM_TIME_NOW_KHR      = 0x31FD;
enum EGL_STREAM_TIME_CONSUMER_KHR = 0x31FE;
enum EGL_STREAM_TIME_PRODUCER_KHR = 0x31FF;

// Constants for EGL_KHR_stream_producer_eglsurface
enum EGL_STREAM_BIT_KHR = 0x0800;

// Constants for EGL_KHR_vg_parent_image
enum EGL_VG_PARENT_IMAGE_KHR = 0x30BA;

// Constants for EGL_ANDROID_create_native_client_buffer
enum EGL_NATIVE_BUFFER_USAGE_ANDROID                  = 0x3143;
enum EGL_NATIVE_BUFFER_USAGE_PROTECTED_BIT_ANDROID    = 0x00000001;
enum EGL_NATIVE_BUFFER_USAGE_RENDERBUFFER_BIT_ANDROID = 0x00000002;
enum EGL_NATIVE_BUFFER_USAGE_TEXTURE_BIT_ANDROID      = 0x00000004;

// Constants for EGL_ANDROID_framebuffer_target
enum EGL_FRAMEBUFFER_TARGET_ANDROID = 0x3147;

// Constants for EGL_ANDROID_front_buffer_auto_refresh
enum EGL_FRONT_BUFFER_AUTO_REFRESH_ANDROID = 0x314C;

// Constants for EGL_ANDROID_get_frame_timestamps
enum EGL_TIMESTAMP_PENDING_ANDROID                   = EGL_CAST!(EGLnsecsANDROID)(-2);
enum EGL_TIMESTAMP_INVALID_ANDROID                   = EGL_CAST!(EGLnsecsANDROID)(-1);
enum EGL_TIMESTAMPS_ANDROID                          = 0x3430;
enum EGL_COMPOSITE_DEADLINE_ANDROID                  = 0x3431;
enum EGL_COMPOSITE_INTERVAL_ANDROID                  = 0x3432;
enum EGL_COMPOSITE_TO_PRESENT_LATENCY_ANDROID        = 0x3433;
enum EGL_REQUESTED_PRESENT_TIME_ANDROID              = 0x3434;
enum EGL_RENDERING_COMPLETE_TIME_ANDROID             = 0x3435;
enum EGL_COMPOSITION_LATCH_TIME_ANDROID              = 0x3436;
enum EGL_FIRST_COMPOSITION_START_TIME_ANDROID        = 0x3437;
enum EGL_LAST_COMPOSITION_START_TIME_ANDROID         = 0x3438;
enum EGL_FIRST_COMPOSITION_GPU_FINISHED_TIME_ANDROID = 0x3439;
enum EGL_DISPLAY_PRESENT_TIME_ANDROID                = 0x343A;
enum EGL_DEQUEUE_READY_TIME_ANDROID                  = 0x343B;
enum EGL_READS_DONE_TIME_ANDROID                     = 0x343C;

// Constants for EGL_ANDROID_image_native_buffer
enum EGL_NATIVE_BUFFER_ANDROID = 0x3140;

// Constants for EGL_ANDROID_native_fence_sync
enum EGL_SYNC_NATIVE_FENCE_ANDROID          = 0x3144;
enum EGL_SYNC_NATIVE_FENCE_FD_ANDROID       = 0x3145;
enum EGL_SYNC_NATIVE_FENCE_SIGNALED_ANDROID = 0x3146;
enum EGL_NO_NATIVE_FENCE_FD_ANDROID         = -1;

// Constants for EGL_ANDROID_recordable
enum EGL_RECORDABLE_ANDROID = 0x3142;

// Constants for EGL_ANGLE_d3d_share_handle_client_buffer
enum EGL_D3D_TEXTURE_2D_SHARE_HANDLE_ANGLE = 0x3200;

// Constants for EGL_ANGLE_device_d3d
enum EGL_D3D9_DEVICE_ANGLE  = 0x33A0;
enum EGL_D3D11_DEVICE_ANGLE = 0x33A1;

// Constants for EGL_ANGLE_window_fixed_size
enum EGL_FIXED_SIZE_ANGLE = 0x3201;

// Constants for EGL_ARM_implicit_external_sync
enum EGL_SYNC_PRIOR_COMMANDS_IMPLICIT_EXTERNAL_ARM = 0x328A;

// Constants for EGL_ARM_pixmap_multisample_discard
enum EGL_DISCARD_SAMPLES_ARM = 0x3286;

// Constants for EGL_EXT_bind_to_front
enum EGL_FRONT_BUFFER_EXT = 0x3464;

// Constants for EGL_EXT_buffer_age
enum EGL_BUFFER_AGE_EXT = 0x313D;

// Constants for EGL_EXT_compositor
enum EGL_PRIMARY_COMPOSITOR_CONTEXT_EXT   = 0x3460;
enum EGL_EXTERNAL_REF_ID_EXT              = 0x3461;
enum EGL_COMPOSITOR_DROP_NEWEST_FRAME_EXT = 0x3462;
enum EGL_COMPOSITOR_KEEP_NEWEST_FRAME_EXT = 0x3463;

// Constants for EGL_EXT_create_context_robustness
enum EGL_CONTEXT_OPENGL_ROBUST_ACCESS_EXT               = 0x30BF;
enum EGL_CONTEXT_OPENGL_RESET_NOTIFICATION_STRATEGY_EXT = 0x3138;
enum EGL_NO_RESET_NOTIFICATION_EXT                      = 0x31BE;
enum EGL_LOSE_CONTEXT_ON_RESET_EXT                      = 0x31BF;

// Constants for EGL_EXT_device_base
enum EGL_NO_DEVICE_EXT  = EGL_CAST!(EGLDeviceEXT)(0);
enum EGL_BAD_DEVICE_EXT = 0x322B;
enum EGL_DEVICE_EXT     = 0x322C;

// Constants for EGL_EXT_device_drm
enum EGL_DRM_DEVICE_FILE_EXT = 0x3233;

// Constants for EGL_EXT_device_openwf
enum EGL_OPENWF_DEVICE_ID_EXT = 0x3237;

// Constants for EGL_EXT_gl_colorspace_bt2020_linear
enum EGL_GL_COLORSPACE_BT2020_LINEAR_EXT = 0x333F;

// Constants for EGL_EXT_gl_colorspace_bt2020_pq
enum EGL_GL_COLORSPACE_BT2020_PQ_EXT = 0x3340;

// Constants for EGL_EXT_gl_colorspace_display_p3
enum EGL_GL_COLORSPACE_DISPLAY_P3_EXT = 0x3363;

// Constants for EGL_EXT_gl_colorspace_display_p3_linear
enum EGL_GL_COLORSPACE_DISPLAY_P3_LINEAR_EXT = 0x3362;

// Constants for EGL_EXT_gl_colorspace_scrgb
enum EGL_GL_COLORSPACE_SCRGB_EXT = 0x3351;

// Constants for EGL_EXT_gl_colorspace_scrgb_linear
enum EGL_GL_COLORSPACE_SCRGB_LINEAR_EXT = 0x3350;

// Constants for EGL_EXT_image_dma_buf_import
enum EGL_LINUX_DMA_BUF_EXT                     = 0x3270;
enum EGL_LINUX_DRM_FOURCC_EXT                  = 0x3271;
enum EGL_DMA_BUF_PLANE0_FD_EXT                 = 0x3272;
enum EGL_DMA_BUF_PLANE0_OFFSET_EXT             = 0x3273;
enum EGL_DMA_BUF_PLANE0_PITCH_EXT              = 0x3274;
enum EGL_DMA_BUF_PLANE1_FD_EXT                 = 0x3275;
enum EGL_DMA_BUF_PLANE1_OFFSET_EXT             = 0x3276;
enum EGL_DMA_BUF_PLANE1_PITCH_EXT              = 0x3277;
enum EGL_DMA_BUF_PLANE2_FD_EXT                 = 0x3278;
enum EGL_DMA_BUF_PLANE2_OFFSET_EXT             = 0x3279;
enum EGL_DMA_BUF_PLANE2_PITCH_EXT              = 0x327A;
enum EGL_YUV_COLOR_SPACE_HINT_EXT              = 0x327B;
enum EGL_SAMPLE_RANGE_HINT_EXT                 = 0x327C;
enum EGL_YUV_CHROMA_HORIZONTAL_SITING_HINT_EXT = 0x327D;
enum EGL_YUV_CHROMA_VERTICAL_SITING_HINT_EXT   = 0x327E;
enum EGL_ITU_REC601_EXT                        = 0x327F;
enum EGL_ITU_REC709_EXT                        = 0x3280;
enum EGL_ITU_REC2020_EXT                       = 0x3281;
enum EGL_YUV_FULL_RANGE_EXT                    = 0x3282;
enum EGL_YUV_NARROW_RANGE_EXT                  = 0x3283;
enum EGL_YUV_CHROMA_SITING_0_EXT               = 0x3284;
enum EGL_YUV_CHROMA_SITING_0_5_EXT             = 0x3285;

// Constants for EGL_EXT_image_dma_buf_import_modifiers
enum EGL_DMA_BUF_PLANE3_FD_EXT          = 0x3440;
enum EGL_DMA_BUF_PLANE3_OFFSET_EXT      = 0x3441;
enum EGL_DMA_BUF_PLANE3_PITCH_EXT       = 0x3442;
enum EGL_DMA_BUF_PLANE0_MODIFIER_LO_EXT = 0x3443;
enum EGL_DMA_BUF_PLANE0_MODIFIER_HI_EXT = 0x3444;
enum EGL_DMA_BUF_PLANE1_MODIFIER_LO_EXT = 0x3445;
enum EGL_DMA_BUF_PLANE1_MODIFIER_HI_EXT = 0x3446;
enum EGL_DMA_BUF_PLANE2_MODIFIER_LO_EXT = 0x3447;
enum EGL_DMA_BUF_PLANE2_MODIFIER_HI_EXT = 0x3448;
enum EGL_DMA_BUF_PLANE3_MODIFIER_LO_EXT = 0x3449;
enum EGL_DMA_BUF_PLANE3_MODIFIER_HI_EXT = 0x344A;

// Constants for EGL_EXT_image_implicit_sync_control
enum EGL_IMPORT_SYNC_TYPE_EXT     = 0x3470;
enum EGL_IMPORT_IMPLICIT_SYNC_EXT = 0x3471;
enum EGL_IMPORT_EXPLICIT_SYNC_EXT = 0x3472;

// Constants for EGL_EXT_multiview_window
enum EGL_MULTIVIEW_VIEW_COUNT_EXT = 0x3134;

// Constants for EGL_EXT_output_base
enum EGL_NO_OUTPUT_LAYER_EXT  = EGL_CAST!(EGLOutputLayerEXT)(0);
enum EGL_NO_OUTPUT_PORT_EXT   = EGL_CAST!(EGLOutputPortEXT)(0);
enum EGL_BAD_OUTPUT_LAYER_EXT = 0x322D;
enum EGL_BAD_OUTPUT_PORT_EXT  = 0x322E;
enum EGL_SWAP_INTERVAL_EXT    = 0x322F;

// Constants for EGL_EXT_output_drm
enum EGL_DRM_CRTC_EXT      = 0x3234;
enum EGL_DRM_PLANE_EXT     = 0x3235;
enum EGL_DRM_CONNECTOR_EXT = 0x3236;

// Constants for EGL_EXT_output_openwf
enum EGL_OPENWF_PIPELINE_ID_EXT = 0x3238;
enum EGL_OPENWF_PORT_ID_EXT     = 0x3239;

// Constants for EGL_EXT_pixel_format_float
enum EGL_COLOR_COMPONENT_TYPE_EXT       = 0x3339;
enum EGL_COLOR_COMPONENT_TYPE_FIXED_EXT = 0x333A;
enum EGL_COLOR_COMPONENT_TYPE_FLOAT_EXT = 0x333B;

// Constants for EGL_EXT_platform_device
enum EGL_PLATFORM_DEVICE_EXT = 0x313F;

// Constants for EGL_EXT_platform_wayland
enum EGL_PLATFORM_WAYLAND_EXT = 0x31D8;

// Constants for EGL_EXT_platform_x11
enum EGL_PLATFORM_X11_EXT        = 0x31D5;
enum EGL_PLATFORM_X11_SCREEN_EXT = 0x31D6;

// Constants for EGL_EXT_protected_content
enum EGL_PROTECTED_CONTENT_EXT = 0x32C0;

// Constants for EGL_EXT_surface_CTA861_3_metadata
enum EGL_CTA861_3_MAX_CONTENT_LIGHT_LEVEL_EXT = 0x3360;
enum EGL_CTA861_3_MAX_FRAME_AVERAGE_LEVEL_EXT = 0x3361;

// Constants for EGL_EXT_surface_SMPTE2086_metadata
enum EGL_SMPTE2086_DISPLAY_PRIMARY_RX_EXT = 0x3341;
enum EGL_SMPTE2086_DISPLAY_PRIMARY_RY_EXT = 0x3342;
enum EGL_SMPTE2086_DISPLAY_PRIMARY_GX_EXT = 0x3343;
enum EGL_SMPTE2086_DISPLAY_PRIMARY_GY_EXT = 0x3344;
enum EGL_SMPTE2086_DISPLAY_PRIMARY_BX_EXT = 0x3345;
enum EGL_SMPTE2086_DISPLAY_PRIMARY_BY_EXT = 0x3346;
enum EGL_SMPTE2086_WHITE_POINT_X_EXT      = 0x3347;
enum EGL_SMPTE2086_WHITE_POINT_Y_EXT      = 0x3348;
enum EGL_SMPTE2086_MAX_LUMINANCE_EXT      = 0x3349;
enum EGL_SMPTE2086_MIN_LUMINANCE_EXT      = 0x334A;
enum EGL_METADATA_SCALING_EXT             = 50000;

// Constants for EGL_EXT_yuv_surface
enum EGL_YUV_ORDER_EXT               = 0x3301;
enum EGL_YUV_NUMBER_OF_PLANES_EXT    = 0x3311;
enum EGL_YUV_SUBSAMPLE_EXT           = 0x3312;
enum EGL_YUV_DEPTH_RANGE_EXT         = 0x3317;
enum EGL_YUV_CSC_STANDARD_EXT        = 0x330A;
enum EGL_YUV_PLANE_BPP_EXT           = 0x331A;
enum EGL_YUV_BUFFER_EXT              = 0x3300;
enum EGL_YUV_ORDER_YUV_EXT           = 0x3302;
enum EGL_YUV_ORDER_YVU_EXT           = 0x3303;
enum EGL_YUV_ORDER_YUYV_EXT          = 0x3304;
enum EGL_YUV_ORDER_UYVY_EXT          = 0x3305;
enum EGL_YUV_ORDER_YVYU_EXT          = 0x3306;
enum EGL_YUV_ORDER_VYUY_EXT          = 0x3307;
enum EGL_YUV_ORDER_AYUV_EXT          = 0x3308;
enum EGL_YUV_SUBSAMPLE_4_2_0_EXT     = 0x3313;
enum EGL_YUV_SUBSAMPLE_4_2_2_EXT     = 0x3314;
enum EGL_YUV_SUBSAMPLE_4_4_4_EXT     = 0x3315;
enum EGL_YUV_DEPTH_RANGE_LIMITED_EXT = 0x3318;
enum EGL_YUV_DEPTH_RANGE_FULL_EXT    = 0x3319;
enum EGL_YUV_CSC_STANDARD_601_EXT    = 0x330B;
enum EGL_YUV_CSC_STANDARD_709_EXT    = 0x330C;
enum EGL_YUV_CSC_STANDARD_2020_EXT   = 0x330D;
enum EGL_YUV_PLANE_BPP_0_EXT         = 0x331B;
enum EGL_YUV_PLANE_BPP_8_EXT         = 0x331C;
enum EGL_YUV_PLANE_BPP_10_EXT        = 0x331D;

// Constants for EGL_HI_clientpixmap
enum EGL_CLIENT_PIXMAP_POINTER_HI = 0x8F74;

// Constants for EGL_HI_colorformats
enum EGL_COLOR_FORMAT_HI = 0x8F70;
enum EGL_COLOR_RGB_HI    = 0x8F71;
enum EGL_COLOR_RGBA_HI   = 0x8F72;
enum EGL_COLOR_ARGB_HI   = 0x8F73;

// Constants for EGL_IMG_context_priority
enum EGL_CONTEXT_PRIORITY_LEVEL_IMG  = 0x3100;
enum EGL_CONTEXT_PRIORITY_HIGH_IMG   = 0x3101;
enum EGL_CONTEXT_PRIORITY_MEDIUM_IMG = 0x3102;
enum EGL_CONTEXT_PRIORITY_LOW_IMG    = 0x3103;

// Constants for EGL_IMG_image_plane_attribs
enum EGL_NATIVE_BUFFER_MULTIPLANE_SEPARATE_IMG = 0x3105;
enum EGL_NATIVE_BUFFER_PLANE_OFFSET_IMG        = 0x3106;

// Constants for EGL_MESA_drm_image
enum EGL_DRM_BUFFER_FORMAT_MESA        = 0x31D0;
enum EGL_DRM_BUFFER_USE_MESA           = 0x31D1;
enum EGL_DRM_BUFFER_FORMAT_ARGB32_MESA = 0x31D2;
enum EGL_DRM_BUFFER_MESA               = 0x31D3;
enum EGL_DRM_BUFFER_STRIDE_MESA        = 0x31D4;
enum EGL_DRM_BUFFER_USE_SCANOUT_MESA   = 0x00000001;
enum EGL_DRM_BUFFER_USE_SHARE_MESA     = 0x00000002;
enum EGL_DRM_BUFFER_USE_CURSOR_MESA    = 0x00000004;

// Constants for EGL_MESA_platform_gbm
enum EGL_PLATFORM_GBM_MESA = 0x31D7;

// Constants for EGL_MESA_platform_surfaceless
enum EGL_PLATFORM_SURFACELESS_MESA = 0x31DD;

// Constants for EGL_NOK_texture_from_pixmap
enum EGL_Y_INVERTED_NOK = 0x307F;

// Constants for EGL_NV_3dvision_surface
enum EGL_AUTO_STEREO_NV = 0x3136;

// Constants for EGL_NV_context_priority_realtime
enum EGL_CONTEXT_PRIORITY_REALTIME_NV = 0x3357;

// Constants for EGL_NV_coverage_sample
enum EGL_COVERAGE_BUFFERS_NV = 0x30E0;
enum EGL_COVERAGE_SAMPLES_NV = 0x30E1;

// Constants for EGL_NV_coverage_sample_resolve
enum EGL_COVERAGE_SAMPLE_RESOLVE_NV         = 0x3131;
enum EGL_COVERAGE_SAMPLE_RESOLVE_DEFAULT_NV = 0x3132;
enum EGL_COVERAGE_SAMPLE_RESOLVE_NONE_NV    = 0x3133;

// Constants for EGL_NV_cuda_event
enum EGL_CUDA_EVENT_HANDLE_NV        = 0x323B;
enum EGL_SYNC_CUDA_EVENT_NV          = 0x323C;
enum EGL_SYNC_CUDA_EVENT_COMPLETE_NV = 0x323D;

// Constants for EGL_NV_depth_nonlinear
enum EGL_DEPTH_ENCODING_NV           = 0x30E2;
enum EGL_DEPTH_ENCODING_NONE_NV      = 0;
enum EGL_DEPTH_ENCODING_NONLINEAR_NV = 0x30E3;

// Constants for EGL_NV_device_cuda
enum EGL_CUDA_DEVICE_NV = 0x323A;

// Constants for EGL_NV_post_sub_buffer
enum EGL_POST_SUB_BUFFER_SUPPORTED_NV = 0x30BE;

// Constants for EGL_NV_robustness_video_memory_purge
enum EGL_GENERATE_RESET_ON_VIDEO_MEMORY_PURGE_NV = 0x334C;

// Constants for EGL_NV_stream_consumer_gltexture_yuv
enum EGL_YUV_PLANE0_TEXTURE_UNIT_NV = 0x332C;
enum EGL_YUV_PLANE1_TEXTURE_UNIT_NV = 0x332D;
enum EGL_YUV_PLANE2_TEXTURE_UNIT_NV = 0x332E;

// Constants for EGL_NV_stream_cross_display
enum EGL_STREAM_CROSS_DISPLAY_NV = 0x334E;

// Constants for EGL_NV_stream_cross_object
enum EGL_STREAM_CROSS_OBJECT_NV = 0x334D;

// Constants for EGL_NV_stream_cross_partition
enum EGL_STREAM_CROSS_PARTITION_NV = 0x323F;

// Constants for EGL_NV_stream_cross_process
enum EGL_STREAM_CROSS_PROCESS_NV = 0x3245;

// Constants for EGL_NV_stream_cross_system
enum EGL_STREAM_CROSS_SYSTEM_NV = 0x334F;

// Constants for EGL_NV_stream_fifo_next
enum EGL_PENDING_FRAME_NV       = 0x3329;
enum EGL_STREAM_TIME_PENDING_NV = 0x332A;

// Constants for EGL_NV_stream_fifo_synchronous
enum EGL_STREAM_FIFO_SYNCHRONOUS_NV = 0x3336;

// Constants for EGL_NV_stream_frame_limits
enum EGL_PRODUCER_MAX_FRAME_HINT_NV = 0x3337;
enum EGL_CONSUMER_MAX_FRAME_HINT_NV = 0x3338;

// Constants for EGL_NV_stream_metadata
enum EGL_MAX_STREAM_METADATA_BLOCKS_NV     = 0x3250;
enum EGL_MAX_STREAM_METADATA_BLOCK_SIZE_NV = 0x3251;
enum EGL_MAX_STREAM_METADATA_TOTAL_SIZE_NV = 0x3252;
enum EGL_PRODUCER_METADATA_NV              = 0x3253;
enum EGL_CONSUMER_METADATA_NV              = 0x3254;
enum EGL_PENDING_METADATA_NV               = 0x3328;
enum EGL_METADATA0_SIZE_NV                 = 0x3255;
enum EGL_METADATA1_SIZE_NV                 = 0x3256;
enum EGL_METADATA2_SIZE_NV                 = 0x3257;
enum EGL_METADATA3_SIZE_NV                 = 0x3258;
enum EGL_METADATA0_TYPE_NV                 = 0x3259;
enum EGL_METADATA1_TYPE_NV                 = 0x325A;
enum EGL_METADATA2_TYPE_NV                 = 0x325B;
enum EGL_METADATA3_TYPE_NV                 = 0x325C;

// Constants for EGL_NV_stream_remote
enum EGL_STREAM_STATE_INITIALIZING_NV = 0x3240;
enum EGL_STREAM_TYPE_NV               = 0x3241;
enum EGL_STREAM_PROTOCOL_NV           = 0x3242;
enum EGL_STREAM_ENDPOINT_NV           = 0x3243;
enum EGL_STREAM_LOCAL_NV              = 0x3244;
enum EGL_STREAM_PRODUCER_NV           = 0x3247;
enum EGL_STREAM_CONSUMER_NV           = 0x3248;
enum EGL_STREAM_PROTOCOL_FD_NV        = 0x3246;

// Constants for EGL_NV_stream_reset
enum EGL_SUPPORT_RESET_NV = 0x3334;
enum EGL_SUPPORT_REUSE_NV = 0x3335;

// Constants for EGL_NV_stream_socket
enum EGL_STREAM_PROTOCOL_SOCKET_NV = 0x324B;
enum EGL_SOCKET_HANDLE_NV          = 0x324C;
enum EGL_SOCKET_TYPE_NV            = 0x324D;

// Constants for EGL_NV_stream_socket_inet
enum EGL_SOCKET_TYPE_INET_NV = 0x324F;

// Constants for EGL_NV_stream_socket_unix
enum EGL_SOCKET_TYPE_UNIX_NV = 0x324E;

// Constants for EGL_NV_stream_sync
enum EGL_SYNC_NEW_FRAME_NV = 0x321F;

// Constants for EGL_NV_sync
enum EGL_SYNC_PRIOR_COMMANDS_COMPLETE_NV = 0x30E6;
enum EGL_SYNC_STATUS_NV                  = 0x30E7;
enum EGL_SIGNALED_NV                     = 0x30E8;
enum EGL_UNSIGNALED_NV                   = 0x30E9;
enum EGL_SYNC_FLUSH_COMMANDS_BIT_NV      = 0x0001;
enum EGL_FOREVER_NV                      = 0xFFFFFFFFFFFFFFFF;
enum EGL_ALREADY_SIGNALED_NV             = 0x30EA;
enum EGL_TIMEOUT_EXPIRED_NV              = 0x30EB;
enum EGL_CONDITION_SATISFIED_NV          = 0x30EC;
enum EGL_SYNC_TYPE_NV                    = 0x30ED;
enum EGL_SYNC_CONDITION_NV               = 0x30EE;
enum EGL_SYNC_FENCE_NV                   = 0x30EF;
enum EGL_NO_SYNC_NV                      = EGL_CAST!(EGLSyncNV)(0);

// Constants for EGL_TIZEN_image_native_buffer
enum EGL_NATIVE_BUFFER_TIZEN = 0x32A0;

// Constants for EGL_TIZEN_image_native_surface
enum EGL_NATIVE_SURFACE_TIZEN = 0x32A1;

// Command pointer aliases

extern(C) nothrow @nogc {

    // Command pointers for EGL_VERSION_1_0
    alias PFN_eglChooseConfig = EGLBoolean function (
        EGLDisplay     dpy,
        const(EGLint)* attrib_list,
        EGLConfig*     configs,
        EGLint         config_size,
        EGLint*        num_config,
    );
    alias PFN_eglCopyBuffers = EGLBoolean function (
        EGLDisplay          dpy,
        EGLSurface          surface,
        EGLNativePixmapType target,
    );
    alias PFN_eglCreateContext = EGLContext function (
        EGLDisplay     dpy,
        EGLConfig      config,
        EGLContext     share_context,
        const(EGLint)* attrib_list,
    );
    alias PFN_eglCreatePbufferSurface = EGLSurface function (
        EGLDisplay     dpy,
        EGLConfig      config,
        const(EGLint)* attrib_list,
    );
    alias PFN_eglCreatePixmapSurface = EGLSurface function (
        EGLDisplay          dpy,
        EGLConfig           config,
        EGLNativePixmapType pixmap,
        const(EGLint)*      attrib_list,
    );
    alias PFN_eglCreateWindowSurface = EGLSurface function (
        EGLDisplay          dpy,
        EGLConfig           config,
        EGLNativeWindowType win,
        const(EGLint)*      attrib_list,
    );
    alias PFN_eglDestroyContext = EGLBoolean function (
        EGLDisplay dpy,
        EGLContext ctx,
    );
    alias PFN_eglDestroySurface = EGLBoolean function (
        EGLDisplay dpy,
        EGLSurface surface,
    );
    alias PFN_eglGetConfigAttrib = EGLBoolean function (
        EGLDisplay dpy,
        EGLConfig  config,
        EGLint     attribute,
        EGLint*    value,
    );
    alias PFN_eglGetConfigs = EGLBoolean function (
        EGLDisplay dpy,
        EGLConfig* configs,
        EGLint     config_size,
        EGLint*    num_config,
    );
    alias PFN_eglGetCurrentDisplay = EGLDisplay function ();
    alias PFN_eglGetCurrentSurface = EGLSurface function (
        EGLint readdraw,
    );
    alias PFN_eglGetDisplay = EGLDisplay function (
        EGLNativeDisplayType display_id,
    );
    alias PFN_eglGetError = EGLint function ();
    alias PFN_eglGetProcAddress = __eglMustCastToProperFunctionPointerType function (
        const(char)* procname,
    );
    alias PFN_eglInitialize = EGLBoolean function (
        EGLDisplay dpy,
        EGLint*    major,
        EGLint*    minor,
    );
    alias PFN_eglMakeCurrent = EGLBoolean function (
        EGLDisplay dpy,
        EGLSurface draw,
        EGLSurface read,
        EGLContext ctx,
    );
    alias PFN_eglQueryContext = EGLBoolean function (
        EGLDisplay dpy,
        EGLContext ctx,
        EGLint     attribute,
        EGLint*    value,
    );
    alias PFN_eglQueryString = const(char)* function (
        EGLDisplay dpy,
        EGLint     name,
    );
    alias PFN_eglQuerySurface = EGLBoolean function (
        EGLDisplay dpy,
        EGLSurface surface,
        EGLint     attribute,
        EGLint*    value,
    );
    alias PFN_eglSwapBuffers = EGLBoolean function (
        EGLDisplay dpy,
        EGLSurface surface,
    );
    alias PFN_eglTerminate = EGLBoolean function (
        EGLDisplay dpy,
    );
    alias PFN_eglWaitGL = EGLBoolean function ();
    alias PFN_eglWaitNative = EGLBoolean function (
        EGLint engine,
    );

    // Command pointers for EGL_VERSION_1_1
    alias PFN_eglBindTexImage = EGLBoolean function (
        EGLDisplay dpy,
        EGLSurface surface,
        EGLint     buffer,
    );
    alias PFN_eglReleaseTexImage = EGLBoolean function (
        EGLDisplay dpy,
        EGLSurface surface,
        EGLint     buffer,
    );
    alias PFN_eglSurfaceAttrib = EGLBoolean function (
        EGLDisplay dpy,
        EGLSurface surface,
        EGLint     attribute,
        EGLint     value,
    );
    alias PFN_eglSwapInterval = EGLBoolean function (
        EGLDisplay dpy,
        EGLint     interval,
    );

    // Command pointers for EGL_VERSION_1_2
    alias PFN_eglBindAPI = EGLBoolean function (
        EGLenum api,
    );
    alias PFN_eglQueryAPI = EGLenum function ();
    alias PFN_eglCreatePbufferFromClientBuffer = EGLSurface function (
        EGLDisplay      dpy,
        EGLenum         buftype,
        EGLClientBuffer buffer,
        EGLConfig       config,
        const(EGLint)*  attrib_list,
    );
    alias PFN_eglReleaseThread = EGLBoolean function ();
    alias PFN_eglWaitClient = EGLBoolean function ();

    // Command pointers for EGL_VERSION_1_4
    alias PFN_eglGetCurrentContext = EGLContext function ();

    // Command pointers for EGL_VERSION_1_5
    alias PFN_eglCreateSync = EGLSync function (
        EGLDisplay        dpy,
        EGLenum           type,
        const(EGLAttrib)* attrib_list,
    );
    alias PFN_eglDestroySync = EGLBoolean function (
        EGLDisplay dpy,
        EGLSync    sync,
    );
    alias PFN_eglClientWaitSync = EGLint function (
        EGLDisplay dpy,
        EGLSync    sync,
        EGLint     flags,
        EGLTime    timeout,
    );
    alias PFN_eglGetSyncAttrib = EGLBoolean function (
        EGLDisplay dpy,
        EGLSync    sync,
        EGLint     attribute,
        EGLAttrib* value,
    );
    alias PFN_eglCreateImage = EGLImage function (
        EGLDisplay        dpy,
        EGLContext        ctx,
        EGLenum           target,
        EGLClientBuffer   buffer,
        const(EGLAttrib)* attrib_list,
    );
    alias PFN_eglDestroyImage = EGLBoolean function (
        EGLDisplay dpy,
        EGLImage   image,
    );
    alias PFN_eglGetPlatformDisplay = EGLDisplay function (
        EGLenum           platform,
        void*             native_display,
        const(EGLAttrib)* attrib_list,
    );
    alias PFN_eglCreatePlatformWindowSurface = EGLSurface function (
        EGLDisplay        dpy,
        EGLConfig         config,
        void*             native_window,
        const(EGLAttrib)* attrib_list,
    );
    alias PFN_eglCreatePlatformPixmapSurface = EGLSurface function (
        EGLDisplay        dpy,
        EGLConfig         config,
        void*             native_pixmap,
        const(EGLAttrib)* attrib_list,
    );
    alias PFN_eglWaitSync = EGLBoolean function (
        EGLDisplay dpy,
        EGLSync    sync,
        EGLint     flags,
    );

    // Command pointers for EGL_KHR_debug
    alias PFN_eglDebugMessageControlKHR = EGLint function (
        EGLDEBUGPROCKHR   callback,
        const(EGLAttrib)* attrib_list,
    );
    alias PFN_eglQueryDebugKHR = EGLBoolean function (
        EGLint     attribute,
        EGLAttrib* value,
    );
    alias PFN_eglLabelObjectKHR = EGLint function (
        EGLDisplay   display,
        EGLenum      objectType,
        EGLObjectKHR object,
        EGLLabelKHR  label,
    );

    // Command pointers for EGL_KHR_display_reference
    alias PFN_eglQueryDisplayAttribKHR = EGLBoolean function (
        EGLDisplay dpy,
        EGLint     name,
        EGLAttrib* value,
    );

    // Command pointers for EGL_KHR_fence_sync
    alias PFN_eglCreateSyncKHR = EGLSyncKHR function (
        EGLDisplay     dpy,
        EGLenum        type,
        const(EGLint)* attrib_list,
    );
    alias PFN_eglGetSyncAttribKHR = EGLBoolean function (
        EGLDisplay dpy,
        EGLSyncKHR sync,
        EGLint     attribute,
        EGLint*    value,
    );

    // Command pointers for EGL_KHR_image
    alias PFN_eglCreateImageKHR = EGLImageKHR function (
        EGLDisplay      dpy,
        EGLContext      ctx,
        EGLenum         target,
        EGLClientBuffer buffer,
        const(EGLint)*  attrib_list,
    );

    // Command pointers for EGL_KHR_lock_surface
    alias PFN_eglLockSurfaceKHR = EGLBoolean function (
        EGLDisplay     dpy,
        EGLSurface     surface,
        const(EGLint)* attrib_list,
    );
    alias PFN_eglUnlockSurfaceKHR = EGLBoolean function (
        EGLDisplay dpy,
        EGLSurface surface,
    );

    // Command pointers for EGL_KHR_lock_surface3
    alias PFN_eglQuerySurface64KHR = EGLBoolean function (
        EGLDisplay    dpy,
        EGLSurface    surface,
        EGLint        attribute,
        EGLAttribKHR* value,
    );

    // Command pointers for EGL_KHR_partial_update
    alias PFN_eglSetDamageRegionKHR = EGLBoolean function (
        EGLDisplay dpy,
        EGLSurface surface,
        EGLint*    rects,
        EGLint     n_rects,
    );

    // Command pointers for EGL_KHR_reusable_sync
    alias PFN_eglSignalSyncKHR = EGLBoolean function (
        EGLDisplay dpy,
        EGLSyncKHR sync,
        EGLenum    mode,
    );

    // Command pointers for EGL_KHR_stream
    alias PFN_eglCreateStreamKHR = EGLStreamKHR function (
        EGLDisplay     dpy,
        const(EGLint)* attrib_list,
    );
    alias PFN_eglDestroyStreamKHR = EGLBoolean function (
        EGLDisplay   dpy,
        EGLStreamKHR stream,
    );
    alias PFN_eglStreamAttribKHR = EGLBoolean function (
        EGLDisplay   dpy,
        EGLStreamKHR stream,
        EGLenum      attribute,
        EGLint       value,
    );
    alias PFN_eglQueryStreamKHR = EGLBoolean function (
        EGLDisplay   dpy,
        EGLStreamKHR stream,
        EGLenum      attribute,
        EGLint*      value,
    );
    alias PFN_eglQueryStreamu64KHR = EGLBoolean function (
        EGLDisplay    dpy,
        EGLStreamKHR  stream,
        EGLenum       attribute,
        EGLuint64KHR* value,
    );

    // Command pointers for EGL_KHR_stream_attrib
    alias PFN_eglCreateStreamAttribKHR = EGLStreamKHR function (
        EGLDisplay        dpy,
        const(EGLAttrib)* attrib_list,
    );
    alias PFN_eglSetStreamAttribKHR = EGLBoolean function (
        EGLDisplay   dpy,
        EGLStreamKHR stream,
        EGLenum      attribute,
        EGLAttrib    value,
    );
    alias PFN_eglQueryStreamAttribKHR = EGLBoolean function (
        EGLDisplay   dpy,
        EGLStreamKHR stream,
        EGLenum      attribute,
        EGLAttrib*   value,
    );
    alias PFN_eglStreamConsumerAcquireAttribKHR = EGLBoolean function (
        EGLDisplay        dpy,
        EGLStreamKHR      stream,
        const(EGLAttrib)* attrib_list,
    );
    alias PFN_eglStreamConsumerReleaseAttribKHR = EGLBoolean function (
        EGLDisplay        dpy,
        EGLStreamKHR      stream,
        const(EGLAttrib)* attrib_list,
    );

    // Command pointers for EGL_KHR_stream_consumer_gltexture
    alias PFN_eglStreamConsumerGLTextureExternalKHR = EGLBoolean function (
        EGLDisplay   dpy,
        EGLStreamKHR stream,
    );
    alias PFN_eglStreamConsumerAcquireKHR = EGLBoolean function (
        EGLDisplay   dpy,
        EGLStreamKHR stream,
    );
    alias PFN_eglStreamConsumerReleaseKHR = EGLBoolean function (
        EGLDisplay   dpy,
        EGLStreamKHR stream,
    );

    // Command pointers for EGL_KHR_stream_cross_process_fd
    alias PFN_eglGetStreamFileDescriptorKHR = EGLNativeFileDescriptorKHR function (
        EGLDisplay   dpy,
        EGLStreamKHR stream,
    );
    alias PFN_eglCreateStreamFromFileDescriptorKHR = EGLStreamKHR function (
        EGLDisplay                 dpy,
        EGLNativeFileDescriptorKHR file_descriptor,
    );

    // Command pointers for EGL_KHR_stream_fifo
    alias PFN_eglQueryStreamTimeKHR = EGLBoolean function (
        EGLDisplay   dpy,
        EGLStreamKHR stream,
        EGLenum      attribute,
        EGLTimeKHR*  value,
    );

    // Command pointers for EGL_KHR_stream_producer_eglsurface
    alias PFN_eglCreateStreamProducerSurfaceKHR = EGLSurface function (
        EGLDisplay     dpy,
        EGLConfig      config,
        EGLStreamKHR   stream,
        const(EGLint)* attrib_list,
    );

    // Command pointers for EGL_KHR_swap_buffers_with_damage
    alias PFN_eglSwapBuffersWithDamageKHR = EGLBoolean function (
        EGLDisplay dpy,
        EGLSurface surface,
        EGLint*    rects,
        EGLint     n_rects,
    );

    // Command pointers for EGL_KHR_wait_sync
    alias PFN_eglWaitSyncKHR = EGLint function (
        EGLDisplay dpy,
        EGLSyncKHR sync,
        EGLint     flags,
    );

    // Command pointers for EGL_ANDROID_blob_cache
    alias PFN_eglSetBlobCacheFuncsANDROID = void function (
        EGLDisplay            dpy,
        EGLSetBlobFuncANDROID set,
        EGLGetBlobFuncANDROID get,
    );

    // Command pointers for EGL_ANDROID_create_native_client_buffer
    alias PFN_eglCreateNativeClientBufferANDROID = EGLClientBuffer function (
        const(EGLint)* attrib_list,
    );

    // Command pointers for EGL_ANDROID_get_frame_timestamps
    alias PFN_eglGetCompositorTimingSupportedANDROID = EGLBoolean function (
        EGLDisplay dpy,
        EGLSurface surface,
        EGLint     name,
    );
    alias PFN_eglGetCompositorTimingANDROID = EGLBoolean function (
        EGLDisplay       dpy,
        EGLSurface       surface,
        EGLint           numTimestamps,
        const(EGLint)*   names,
        EGLnsecsANDROID* values,
    );
    alias PFN_eglGetNextFrameIdANDROID = EGLBoolean function (
        EGLDisplay    dpy,
        EGLSurface    surface,
        EGLuint64KHR* frameId,
    );
    alias PFN_eglGetFrameTimestampSupportedANDROID = EGLBoolean function (
        EGLDisplay dpy,
        EGLSurface surface,
        EGLint     timestamp,
    );
    alias PFN_eglGetFrameTimestampsANDROID = EGLBoolean function (
        EGLDisplay       dpy,
        EGLSurface       surface,
        EGLuint64KHR     frameId,
        EGLint           numTimestamps,
        const(EGLint)*   timestamps,
        EGLnsecsANDROID* values,
    );

    // Command pointers for EGL_ANDROID_get_native_client_buffer
    alias PFN_eglGetNativeClientBufferANDROID = EGLClientBuffer function (
        const(AHardwareBuffer)* buffer,
    );

    // Command pointers for EGL_ANDROID_native_fence_sync
    alias PFN_eglDupNativeFenceFDANDROID = EGLint function (
        EGLDisplay dpy,
        EGLSyncKHR sync,
    );

    // Command pointers for EGL_ANDROID_presentation_time
    alias PFN_eglPresentationTimeANDROID = EGLBoolean function (
        EGLDisplay      dpy,
        EGLSurface      surface,
        EGLnsecsANDROID time,
    );

    // Command pointers for EGL_ANGLE_query_surface_pointer
    alias PFN_eglQuerySurfacePointerANGLE = EGLBoolean function (
        EGLDisplay dpy,
        EGLSurface surface,
        EGLint     attribute,
        void**     value,
    );

    // Command pointers for EGL_EXT_compositor
    alias PFN_eglCompositorSetContextListEXT = EGLBoolean function (
        const(EGLint)* external_ref_ids,
        EGLint         num_entries,
    );
    alias PFN_eglCompositorSetContextAttributesEXT = EGLBoolean function (
        EGLint         external_ref_id,
        const(EGLint)* context_attributes,
        EGLint         num_entries,
    );
    alias PFN_eglCompositorSetWindowListEXT = EGLBoolean function (
        EGLint         external_ref_id,
        const(EGLint)* external_win_ids,
        EGLint         num_entries,
    );
    alias PFN_eglCompositorSetWindowAttributesEXT = EGLBoolean function (
        EGLint         external_win_id,
        const(EGLint)* window_attributes,
        EGLint         num_entries,
    );
    alias PFN_eglCompositorBindTexWindowEXT = EGLBoolean function (
        EGLint external_win_id,
    );
    alias PFN_eglCompositorSetSizeEXT = EGLBoolean function (
        EGLint external_win_id,
        EGLint width,
        EGLint height,
    );
    alias PFN_eglCompositorSwapPolicyEXT = EGLBoolean function (
        EGLint external_win_id,
        EGLint policy,
    );

    // Command pointers for EGL_EXT_device_base
    alias PFN_eglQueryDeviceAttribEXT = EGLBoolean function (
        EGLDeviceEXT device,
        EGLint       attribute,
        EGLAttrib*   value,
    );
    alias PFN_eglQueryDeviceStringEXT = const(char)* function (
        EGLDeviceEXT device,
        EGLint       name,
    );
    alias PFN_eglQueryDevicesEXT = EGLBoolean function (
        EGLint        max_devices,
        EGLDeviceEXT* devices,
        EGLint*       num_devices,
    );
    alias PFN_eglQueryDisplayAttribEXT = EGLBoolean function (
        EGLDisplay dpy,
        EGLint     attribute,
        EGLAttrib* value,
    );

    // Command pointers for EGL_EXT_image_dma_buf_import_modifiers
    alias PFN_eglQueryDmaBufFormatsEXT = EGLBoolean function (
        EGLDisplay dpy,
        EGLint     max_formats,
        EGLint*    formats,
        EGLint*    num_formats,
    );
    alias PFN_eglQueryDmaBufModifiersEXT = EGLBoolean function (
        EGLDisplay    dpy,
        EGLint        format,
        EGLint        max_modifiers,
        EGLuint64KHR* modifiers,
        EGLBoolean*   external_only,
        EGLint*       num_modifiers,
    );

    // Command pointers for EGL_EXT_output_base
    alias PFN_eglGetOutputLayersEXT = EGLBoolean function (
        EGLDisplay         dpy,
        const(EGLAttrib)*  attrib_list,
        EGLOutputLayerEXT* layers,
        EGLint             max_layers,
        EGLint*            num_layers,
    );
    alias PFN_eglGetOutputPortsEXT = EGLBoolean function (
        EGLDisplay        dpy,
        const(EGLAttrib)* attrib_list,
        EGLOutputPortEXT* ports,
        EGLint            max_ports,
        EGLint*           num_ports,
    );
    alias PFN_eglOutputLayerAttribEXT = EGLBoolean function (
        EGLDisplay        dpy,
        EGLOutputLayerEXT layer,
        EGLint            attribute,
        EGLAttrib         value,
    );
    alias PFN_eglQueryOutputLayerAttribEXT = EGLBoolean function (
        EGLDisplay        dpy,
        EGLOutputLayerEXT layer,
        EGLint            attribute,
        EGLAttrib*        value,
    );
    alias PFN_eglQueryOutputLayerStringEXT = const(char)* function (
        EGLDisplay        dpy,
        EGLOutputLayerEXT layer,
        EGLint            name,
    );
    alias PFN_eglOutputPortAttribEXT = EGLBoolean function (
        EGLDisplay       dpy,
        EGLOutputPortEXT port,
        EGLint           attribute,
        EGLAttrib        value,
    );
    alias PFN_eglQueryOutputPortAttribEXT = EGLBoolean function (
        EGLDisplay       dpy,
        EGLOutputPortEXT port,
        EGLint           attribute,
        EGLAttrib*       value,
    );
    alias PFN_eglQueryOutputPortStringEXT = const(char)* function (
        EGLDisplay       dpy,
        EGLOutputPortEXT port,
        EGLint           name,
    );

    // Command pointers for EGL_EXT_platform_base
    alias PFN_eglGetPlatformDisplayEXT = EGLDisplay function (
        EGLenum        platform,
        void*          native_display,
        const(EGLint)* attrib_list,
    );
    alias PFN_eglCreatePlatformWindowSurfaceEXT = EGLSurface function (
        EGLDisplay     dpy,
        EGLConfig      config,
        void*          native_window,
        const(EGLint)* attrib_list,
    );
    alias PFN_eglCreatePlatformPixmapSurfaceEXT = EGLSurface function (
        EGLDisplay     dpy,
        EGLConfig      config,
        void*          native_pixmap,
        const(EGLint)* attrib_list,
    );

    // Command pointers for EGL_EXT_stream_consumer_egloutput
    alias PFN_eglStreamConsumerOutputEXT = EGLBoolean function (
        EGLDisplay        dpy,
        EGLStreamKHR      stream,
        EGLOutputLayerEXT layer,
    );

    // Command pointers for EGL_EXT_swap_buffers_with_damage
    alias PFN_eglSwapBuffersWithDamageEXT = EGLBoolean function (
        EGLDisplay dpy,
        EGLSurface surface,
        EGLint*    rects,
        EGLint     n_rects,
    );

    // Command pointers for EGL_HI_clientpixmap
    alias PFN_eglCreatePixmapSurfaceHI = EGLSurface function (
        EGLDisplay         dpy,
        EGLConfig          config,
        EGLClientPixmapHI* pixmap,
    );

    // Command pointers for EGL_MESA_drm_image
    alias PFN_eglCreateDRMImageMESA = EGLImageKHR function (
        EGLDisplay     dpy,
        const(EGLint)* attrib_list,
    );
    alias PFN_eglExportDRMImageMESA = EGLBoolean function (
        EGLDisplay  dpy,
        EGLImageKHR image,
        EGLint*     name,
        EGLint*     handle,
        EGLint*     stride,
    );

    // Command pointers for EGL_MESA_image_dma_buf_export
    alias PFN_eglExportDMABUFImageQueryMESA = EGLBoolean function (
        EGLDisplay    dpy,
        EGLImageKHR   image,
        int*          fourcc,
        int*          num_planes,
        EGLuint64KHR* modifiers,
    );
    alias PFN_eglExportDMABUFImageMESA = EGLBoolean function (
        EGLDisplay  dpy,
        EGLImageKHR image,
        int*        fds,
        EGLint*     strides,
        EGLint*     offsets,
    );

    // Command pointers for EGL_NOK_swap_region
    alias PFN_eglSwapBuffersRegionNOK = EGLBoolean function (
        EGLDisplay     dpy,
        EGLSurface     surface,
        EGLint         numRects,
        const(EGLint)* rects,
    );

    // Command pointers for EGL_NOK_swap_region2
    alias PFN_eglSwapBuffersRegion2NOK = EGLBoolean function (
        EGLDisplay     dpy,
        EGLSurface     surface,
        EGLint         numRects,
        const(EGLint)* rects,
    );

    // Command pointers for EGL_NV_native_query
    alias PFN_eglQueryNativeDisplayNV = EGLBoolean function (
        EGLDisplay            dpy,
        EGLNativeDisplayType* display_id,
    );
    alias PFN_eglQueryNativeWindowNV = EGLBoolean function (
        EGLDisplay           dpy,
        EGLSurface           surf,
        EGLNativeWindowType* window,
    );
    alias PFN_eglQueryNativePixmapNV = EGLBoolean function (
        EGLDisplay           dpy,
        EGLSurface           surf,
        EGLNativePixmapType* pixmap,
    );

    // Command pointers for EGL_NV_post_sub_buffer
    alias PFN_eglPostSubBufferNV = EGLBoolean function (
        EGLDisplay dpy,
        EGLSurface surface,
        EGLint     x,
        EGLint     y,
        EGLint     width,
        EGLint     height,
    );

    // Command pointers for EGL_NV_stream_consumer_gltexture_yuv
    alias PFN_eglStreamConsumerGLTextureExternalAttribsNV = EGLBoolean function (
        EGLDisplay        dpy,
        EGLStreamKHR      stream,
        const(EGLAttrib)* attrib_list,
    );

    // Command pointers for EGL_NV_stream_metadata
    alias PFN_eglQueryDisplayAttribNV = EGLBoolean function (
        EGLDisplay dpy,
        EGLint     attribute,
        EGLAttrib* value,
    );
    alias PFN_eglSetStreamMetadataNV = EGLBoolean function (
        EGLDisplay   dpy,
        EGLStreamKHR stream,
        EGLint       n,
        EGLint       offset,
        EGLint       size,
        const(void)* data,
    );
    alias PFN_eglQueryStreamMetadataNV = EGLBoolean function (
        EGLDisplay   dpy,
        EGLStreamKHR stream,
        EGLenum      name,
        EGLint       n,
        EGLint       offset,
        EGLint       size,
        void*        data,
    );

    // Command pointers for EGL_NV_stream_reset
    alias PFN_eglResetStreamNV = EGLBoolean function (
        EGLDisplay   dpy,
        EGLStreamKHR stream,
    );

    // Command pointers for EGL_NV_stream_sync
    alias PFN_eglCreateStreamSyncNV = EGLSyncKHR function (
        EGLDisplay     dpy,
        EGLStreamKHR   stream,
        EGLenum        type,
        const(EGLint)* attrib_list,
    );

    // Command pointers for EGL_NV_sync
    alias PFN_eglCreateFenceSyncNV = EGLSyncNV function (
        EGLDisplay     dpy,
        EGLenum        condition,
        const(EGLint)* attrib_list,
    );
    alias PFN_eglDestroySyncNV = EGLBoolean function (
        EGLSyncNV sync,
    );
    alias PFN_eglFenceNV = EGLBoolean function (
        EGLSyncNV sync,
    );
    alias PFN_eglClientWaitSyncNV = EGLint function (
        EGLSyncNV sync,
        EGLint    flags,
        EGLTimeNV timeout,
    );
    alias PFN_eglSignalSyncNV = EGLBoolean function (
        EGLSyncNV sync,
        EGLenum   mode,
    );
    alias PFN_eglGetSyncAttribNV = EGLBoolean function (
        EGLSyncNV sync,
        EGLint    attribute,
        EGLint*   value,
    );

    // Command pointers for EGL_NV_system_time
    alias PFN_eglGetSystemTimeFrequencyNV = EGLuint64NV function ();
    alias PFN_eglGetSystemTimeNV = EGLuint64NV function ();
}

/// EglVersion describes the version of EGL
enum EglVersion {
    egl10 = 10,
    egl11 = 11,
    egl12 = 12,
    egl14 = 14,
    egl15 = 15,
}

/// EGL loader base class
final class Egl {
    this(SymbolLoader loader) {

        // EGL_VERSION_1_0
        _ChooseConfig = cast(PFN_eglChooseConfig)loadSymbol(loader, "eglChooseConfig", []);
        _CopyBuffers = cast(PFN_eglCopyBuffers)loadSymbol(loader, "eglCopyBuffers", []);
        _CreateContext = cast(PFN_eglCreateContext)loadSymbol(loader, "eglCreateContext", []);
        _CreatePbufferSurface = cast(PFN_eglCreatePbufferSurface)loadSymbol(loader, "eglCreatePbufferSurface", []);
        _CreatePixmapSurface = cast(PFN_eglCreatePixmapSurface)loadSymbol(loader, "eglCreatePixmapSurface", []);
        _CreateWindowSurface = cast(PFN_eglCreateWindowSurface)loadSymbol(loader, "eglCreateWindowSurface", []);
        _DestroyContext = cast(PFN_eglDestroyContext)loadSymbol(loader, "eglDestroyContext", []);
        _DestroySurface = cast(PFN_eglDestroySurface)loadSymbol(loader, "eglDestroySurface", []);
        _GetConfigAttrib = cast(PFN_eglGetConfigAttrib)loadSymbol(loader, "eglGetConfigAttrib", []);
        _GetConfigs = cast(PFN_eglGetConfigs)loadSymbol(loader, "eglGetConfigs", []);
        _GetCurrentDisplay = cast(PFN_eglGetCurrentDisplay)loadSymbol(loader, "eglGetCurrentDisplay", []);
        _GetCurrentSurface = cast(PFN_eglGetCurrentSurface)loadSymbol(loader, "eglGetCurrentSurface", []);
        _GetDisplay = cast(PFN_eglGetDisplay)loadSymbol(loader, "eglGetDisplay", []);
        _GetError = cast(PFN_eglGetError)loadSymbol(loader, "eglGetError", []);
        _GetProcAddress = cast(PFN_eglGetProcAddress)loadSymbol(loader, "eglGetProcAddress", []);
        _Initialize = cast(PFN_eglInitialize)loadSymbol(loader, "eglInitialize", []);
        _MakeCurrent = cast(PFN_eglMakeCurrent)loadSymbol(loader, "eglMakeCurrent", []);
        _QueryContext = cast(PFN_eglQueryContext)loadSymbol(loader, "eglQueryContext", []);
        _QueryString = cast(PFN_eglQueryString)loadSymbol(loader, "eglQueryString", []);
        _QuerySurface = cast(PFN_eglQuerySurface)loadSymbol(loader, "eglQuerySurface", []);
        _SwapBuffers = cast(PFN_eglSwapBuffers)loadSymbol(loader, "eglSwapBuffers", []);
        _Terminate = cast(PFN_eglTerminate)loadSymbol(loader, "eglTerminate", []);
        _WaitGL = cast(PFN_eglWaitGL)loadSymbol(loader, "eglWaitGL", []);
        _WaitNative = cast(PFN_eglWaitNative)loadSymbol(loader, "eglWaitNative", []);

        // EGL_VERSION_1_1
        _BindTexImage = cast(PFN_eglBindTexImage)loadSymbol(loader, "eglBindTexImage", []);
        _ReleaseTexImage = cast(PFN_eglReleaseTexImage)loadSymbol(loader, "eglReleaseTexImage", []);
        _SurfaceAttrib = cast(PFN_eglSurfaceAttrib)loadSymbol(loader, "eglSurfaceAttrib", []);
        _SwapInterval = cast(PFN_eglSwapInterval)loadSymbol(loader, "eglSwapInterval", []);

        // EGL_VERSION_1_2
        _BindAPI = cast(PFN_eglBindAPI)loadSymbol(loader, "eglBindAPI", []);
        _QueryAPI = cast(PFN_eglQueryAPI)loadSymbol(loader, "eglQueryAPI", []);
        _CreatePbufferFromClientBuffer = cast(PFN_eglCreatePbufferFromClientBuffer)loadSymbol(loader, "eglCreatePbufferFromClientBuffer", []);
        _ReleaseThread = cast(PFN_eglReleaseThread)loadSymbol(loader, "eglReleaseThread", []);
        _WaitClient = cast(PFN_eglWaitClient)loadSymbol(loader, "eglWaitClient", []);

        // EGL_VERSION_1_4
        _GetCurrentContext = cast(PFN_eglGetCurrentContext)loadSymbol(loader, "eglGetCurrentContext", []);

        // EGL_VERSION_1_5
        _CreateSync = cast(PFN_eglCreateSync)loadSymbol(loader, "eglCreateSync", ["eglCreateSync64KHR"]);
        _DestroySync = cast(PFN_eglDestroySync)loadSymbol(loader, "eglDestroySync", ["eglDestroySyncKHR"]);
        _ClientWaitSync = cast(PFN_eglClientWaitSync)loadSymbol(loader, "eglClientWaitSync", ["eglClientWaitSyncKHR"]);
        _GetSyncAttrib = cast(PFN_eglGetSyncAttrib)loadSymbol(loader, "eglGetSyncAttrib", []);
        _CreateImage = cast(PFN_eglCreateImage)loadSymbol(loader, "eglCreateImage", []);
        _DestroyImage = cast(PFN_eglDestroyImage)loadSymbol(loader, "eglDestroyImage", ["eglDestroyImageKHR"]);
        _GetPlatformDisplay = cast(PFN_eglGetPlatformDisplay)loadSymbol(loader, "eglGetPlatformDisplay", []);
        _CreatePlatformWindowSurface = cast(PFN_eglCreatePlatformWindowSurface)loadSymbol(loader, "eglCreatePlatformWindowSurface", []);
        _CreatePlatformPixmapSurface = cast(PFN_eglCreatePlatformPixmapSurface)loadSymbol(loader, "eglCreatePlatformPixmapSurface", []);
        _WaitSync = cast(PFN_eglWaitSync)loadSymbol(loader, "eglWaitSync", []);

        // EGL_KHR_debug,
        _DebugMessageControlKHR = cast(PFN_eglDebugMessageControlKHR)loadSymbol(loader, "eglDebugMessageControlKHR", []);
        _QueryDebugKHR = cast(PFN_eglQueryDebugKHR)loadSymbol(loader, "eglQueryDebugKHR", []);
        _LabelObjectKHR = cast(PFN_eglLabelObjectKHR)loadSymbol(loader, "eglLabelObjectKHR", []);

        // EGL_KHR_display_reference,
        _QueryDisplayAttribKHR = cast(PFN_eglQueryDisplayAttribKHR)loadSymbol(loader, "eglQueryDisplayAttribKHR", []);

        // EGL_KHR_fence_sync,
        _CreateSyncKHR = cast(PFN_eglCreateSyncKHR)loadSymbol(loader, "eglCreateSyncKHR", []);
        _GetSyncAttribKHR = cast(PFN_eglGetSyncAttribKHR)loadSymbol(loader, "eglGetSyncAttribKHR", []);

        // EGL_KHR_image,
        _CreateImageKHR = cast(PFN_eglCreateImageKHR)loadSymbol(loader, "eglCreateImageKHR", []);

        // EGL_KHR_lock_surface,
        _LockSurfaceKHR = cast(PFN_eglLockSurfaceKHR)loadSymbol(loader, "eglLockSurfaceKHR", []);
        _UnlockSurfaceKHR = cast(PFN_eglUnlockSurfaceKHR)loadSymbol(loader, "eglUnlockSurfaceKHR", []);

        // EGL_KHR_lock_surface3,
        _QuerySurface64KHR = cast(PFN_eglQuerySurface64KHR)loadSymbol(loader, "eglQuerySurface64KHR", []);

        // EGL_KHR_partial_update,
        _SetDamageRegionKHR = cast(PFN_eglSetDamageRegionKHR)loadSymbol(loader, "eglSetDamageRegionKHR", []);

        // EGL_KHR_reusable_sync,
        _SignalSyncKHR = cast(PFN_eglSignalSyncKHR)loadSymbol(loader, "eglSignalSyncKHR", []);

        // EGL_KHR_stream,
        _CreateStreamKHR = cast(PFN_eglCreateStreamKHR)loadSymbol(loader, "eglCreateStreamKHR", []);
        _DestroyStreamKHR = cast(PFN_eglDestroyStreamKHR)loadSymbol(loader, "eglDestroyStreamKHR", []);
        _StreamAttribKHR = cast(PFN_eglStreamAttribKHR)loadSymbol(loader, "eglStreamAttribKHR", []);
        _QueryStreamKHR = cast(PFN_eglQueryStreamKHR)loadSymbol(loader, "eglQueryStreamKHR", []);
        _QueryStreamu64KHR = cast(PFN_eglQueryStreamu64KHR)loadSymbol(loader, "eglQueryStreamu64KHR", []);

        // EGL_KHR_stream_attrib,
        _CreateStreamAttribKHR = cast(PFN_eglCreateStreamAttribKHR)loadSymbol(loader, "eglCreateStreamAttribKHR", []);
        _SetStreamAttribKHR = cast(PFN_eglSetStreamAttribKHR)loadSymbol(loader, "eglSetStreamAttribKHR", []);
        _QueryStreamAttribKHR = cast(PFN_eglQueryStreamAttribKHR)loadSymbol(loader, "eglQueryStreamAttribKHR", []);
        _StreamConsumerAcquireAttribKHR = cast(PFN_eglStreamConsumerAcquireAttribKHR)loadSymbol(loader, "eglStreamConsumerAcquireAttribKHR", []);
        _StreamConsumerReleaseAttribKHR = cast(PFN_eglStreamConsumerReleaseAttribKHR)loadSymbol(loader, "eglStreamConsumerReleaseAttribKHR", []);

        // EGL_KHR_stream_consumer_gltexture,
        _StreamConsumerGLTextureExternalKHR = cast(PFN_eglStreamConsumerGLTextureExternalKHR)loadSymbol(loader, "eglStreamConsumerGLTextureExternalKHR", []);
        _StreamConsumerAcquireKHR = cast(PFN_eglStreamConsumerAcquireKHR)loadSymbol(loader, "eglStreamConsumerAcquireKHR", []);
        _StreamConsumerReleaseKHR = cast(PFN_eglStreamConsumerReleaseKHR)loadSymbol(loader, "eglStreamConsumerReleaseKHR", []);

        // EGL_KHR_stream_cross_process_fd,
        _GetStreamFileDescriptorKHR = cast(PFN_eglGetStreamFileDescriptorKHR)loadSymbol(loader, "eglGetStreamFileDescriptorKHR", []);
        _CreateStreamFromFileDescriptorKHR = cast(PFN_eglCreateStreamFromFileDescriptorKHR)loadSymbol(loader, "eglCreateStreamFromFileDescriptorKHR", []);

        // EGL_KHR_stream_fifo,
        _QueryStreamTimeKHR = cast(PFN_eglQueryStreamTimeKHR)loadSymbol(loader, "eglQueryStreamTimeKHR", []);

        // EGL_KHR_stream_producer_eglsurface,
        _CreateStreamProducerSurfaceKHR = cast(PFN_eglCreateStreamProducerSurfaceKHR)loadSymbol(loader, "eglCreateStreamProducerSurfaceKHR", []);

        // EGL_KHR_swap_buffers_with_damage,
        _SwapBuffersWithDamageKHR = cast(PFN_eglSwapBuffersWithDamageKHR)loadSymbol(loader, "eglSwapBuffersWithDamageKHR", []);

        // EGL_KHR_wait_sync,
        _WaitSyncKHR = cast(PFN_eglWaitSyncKHR)loadSymbol(loader, "eglWaitSyncKHR", []);

        // EGL_ANDROID_blob_cache,
        _SetBlobCacheFuncsANDROID = cast(PFN_eglSetBlobCacheFuncsANDROID)loadSymbol(loader, "eglSetBlobCacheFuncsANDROID", []);

        // EGL_ANDROID_create_native_client_buffer,
        _CreateNativeClientBufferANDROID = cast(PFN_eglCreateNativeClientBufferANDROID)loadSymbol(loader, "eglCreateNativeClientBufferANDROID", []);

        // EGL_ANDROID_get_frame_timestamps,
        _GetCompositorTimingSupportedANDROID = cast(PFN_eglGetCompositorTimingSupportedANDROID)loadSymbol(loader, "eglGetCompositorTimingSupportedANDROID", []);
        _GetCompositorTimingANDROID = cast(PFN_eglGetCompositorTimingANDROID)loadSymbol(loader, "eglGetCompositorTimingANDROID", []);
        _GetNextFrameIdANDROID = cast(PFN_eglGetNextFrameIdANDROID)loadSymbol(loader, "eglGetNextFrameIdANDROID", []);
        _GetFrameTimestampSupportedANDROID = cast(PFN_eglGetFrameTimestampSupportedANDROID)loadSymbol(loader, "eglGetFrameTimestampSupportedANDROID", []);
        _GetFrameTimestampsANDROID = cast(PFN_eglGetFrameTimestampsANDROID)loadSymbol(loader, "eglGetFrameTimestampsANDROID", []);

        // EGL_ANDROID_get_native_client_buffer,
        _GetNativeClientBufferANDROID = cast(PFN_eglGetNativeClientBufferANDROID)loadSymbol(loader, "eglGetNativeClientBufferANDROID", []);

        // EGL_ANDROID_native_fence_sync,
        _DupNativeFenceFDANDROID = cast(PFN_eglDupNativeFenceFDANDROID)loadSymbol(loader, "eglDupNativeFenceFDANDROID", []);

        // EGL_ANDROID_presentation_time,
        _PresentationTimeANDROID = cast(PFN_eglPresentationTimeANDROID)loadSymbol(loader, "eglPresentationTimeANDROID", []);

        // EGL_ANGLE_query_surface_pointer,
        _QuerySurfacePointerANGLE = cast(PFN_eglQuerySurfacePointerANGLE)loadSymbol(loader, "eglQuerySurfacePointerANGLE", []);

        // EGL_EXT_compositor,
        _CompositorSetContextListEXT = cast(PFN_eglCompositorSetContextListEXT)loadSymbol(loader, "eglCompositorSetContextListEXT", []);
        _CompositorSetContextAttributesEXT = cast(PFN_eglCompositorSetContextAttributesEXT)loadSymbol(loader, "eglCompositorSetContextAttributesEXT", []);
        _CompositorSetWindowListEXT = cast(PFN_eglCompositorSetWindowListEXT)loadSymbol(loader, "eglCompositorSetWindowListEXT", []);
        _CompositorSetWindowAttributesEXT = cast(PFN_eglCompositorSetWindowAttributesEXT)loadSymbol(loader, "eglCompositorSetWindowAttributesEXT", []);
        _CompositorBindTexWindowEXT = cast(PFN_eglCompositorBindTexWindowEXT)loadSymbol(loader, "eglCompositorBindTexWindowEXT", []);
        _CompositorSetSizeEXT = cast(PFN_eglCompositorSetSizeEXT)loadSymbol(loader, "eglCompositorSetSizeEXT", []);
        _CompositorSwapPolicyEXT = cast(PFN_eglCompositorSwapPolicyEXT)loadSymbol(loader, "eglCompositorSwapPolicyEXT", []);

        // EGL_EXT_device_base,
        _QueryDeviceAttribEXT = cast(PFN_eglQueryDeviceAttribEXT)loadSymbol(loader, "eglQueryDeviceAttribEXT", []);
        _QueryDeviceStringEXT = cast(PFN_eglQueryDeviceStringEXT)loadSymbol(loader, "eglQueryDeviceStringEXT", []);
        _QueryDevicesEXT = cast(PFN_eglQueryDevicesEXT)loadSymbol(loader, "eglQueryDevicesEXT", []);
        _QueryDisplayAttribEXT = cast(PFN_eglQueryDisplayAttribEXT)loadSymbol(loader, "eglQueryDisplayAttribEXT", []);

        // EGL_EXT_image_dma_buf_import_modifiers,
        _QueryDmaBufFormatsEXT = cast(PFN_eglQueryDmaBufFormatsEXT)loadSymbol(loader, "eglQueryDmaBufFormatsEXT", []);
        _QueryDmaBufModifiersEXT = cast(PFN_eglQueryDmaBufModifiersEXT)loadSymbol(loader, "eglQueryDmaBufModifiersEXT", []);

        // EGL_EXT_output_base,
        _GetOutputLayersEXT = cast(PFN_eglGetOutputLayersEXT)loadSymbol(loader, "eglGetOutputLayersEXT", []);
        _GetOutputPortsEXT = cast(PFN_eglGetOutputPortsEXT)loadSymbol(loader, "eglGetOutputPortsEXT", []);
        _OutputLayerAttribEXT = cast(PFN_eglOutputLayerAttribEXT)loadSymbol(loader, "eglOutputLayerAttribEXT", []);
        _QueryOutputLayerAttribEXT = cast(PFN_eglQueryOutputLayerAttribEXT)loadSymbol(loader, "eglQueryOutputLayerAttribEXT", []);
        _QueryOutputLayerStringEXT = cast(PFN_eglQueryOutputLayerStringEXT)loadSymbol(loader, "eglQueryOutputLayerStringEXT", []);
        _OutputPortAttribEXT = cast(PFN_eglOutputPortAttribEXT)loadSymbol(loader, "eglOutputPortAttribEXT", []);
        _QueryOutputPortAttribEXT = cast(PFN_eglQueryOutputPortAttribEXT)loadSymbol(loader, "eglQueryOutputPortAttribEXT", []);
        _QueryOutputPortStringEXT = cast(PFN_eglQueryOutputPortStringEXT)loadSymbol(loader, "eglQueryOutputPortStringEXT", []);

        // EGL_EXT_platform_base,
        _GetPlatformDisplayEXT = cast(PFN_eglGetPlatformDisplayEXT)loadSymbol(loader, "eglGetPlatformDisplayEXT", []);
        _CreatePlatformWindowSurfaceEXT = cast(PFN_eglCreatePlatformWindowSurfaceEXT)loadSymbol(loader, "eglCreatePlatformWindowSurfaceEXT", []);
        _CreatePlatformPixmapSurfaceEXT = cast(PFN_eglCreatePlatformPixmapSurfaceEXT)loadSymbol(loader, "eglCreatePlatformPixmapSurfaceEXT", []);

        // EGL_EXT_stream_consumer_egloutput,
        _StreamConsumerOutputEXT = cast(PFN_eglStreamConsumerOutputEXT)loadSymbol(loader, "eglStreamConsumerOutputEXT", []);

        // EGL_EXT_swap_buffers_with_damage,
        _SwapBuffersWithDamageEXT = cast(PFN_eglSwapBuffersWithDamageEXT)loadSymbol(loader, "eglSwapBuffersWithDamageEXT", []);

        // EGL_HI_clientpixmap,
        _CreatePixmapSurfaceHI = cast(PFN_eglCreatePixmapSurfaceHI)loadSymbol(loader, "eglCreatePixmapSurfaceHI", []);

        // EGL_MESA_drm_image,
        _CreateDRMImageMESA = cast(PFN_eglCreateDRMImageMESA)loadSymbol(loader, "eglCreateDRMImageMESA", []);
        _ExportDRMImageMESA = cast(PFN_eglExportDRMImageMESA)loadSymbol(loader, "eglExportDRMImageMESA", []);

        // EGL_MESA_image_dma_buf_export,
        _ExportDMABUFImageQueryMESA = cast(PFN_eglExportDMABUFImageQueryMESA)loadSymbol(loader, "eglExportDMABUFImageQueryMESA", []);
        _ExportDMABUFImageMESA = cast(PFN_eglExportDMABUFImageMESA)loadSymbol(loader, "eglExportDMABUFImageMESA", []);

        // EGL_NOK_swap_region,
        _SwapBuffersRegionNOK = cast(PFN_eglSwapBuffersRegionNOK)loadSymbol(loader, "eglSwapBuffersRegionNOK", []);

        // EGL_NOK_swap_region2,
        _SwapBuffersRegion2NOK = cast(PFN_eglSwapBuffersRegion2NOK)loadSymbol(loader, "eglSwapBuffersRegion2NOK", []);

        // EGL_NV_native_query,
        _QueryNativeDisplayNV = cast(PFN_eglQueryNativeDisplayNV)loadSymbol(loader, "eglQueryNativeDisplayNV", []);
        _QueryNativeWindowNV = cast(PFN_eglQueryNativeWindowNV)loadSymbol(loader, "eglQueryNativeWindowNV", []);
        _QueryNativePixmapNV = cast(PFN_eglQueryNativePixmapNV)loadSymbol(loader, "eglQueryNativePixmapNV", []);

        // EGL_NV_post_sub_buffer,
        _PostSubBufferNV = cast(PFN_eglPostSubBufferNV)loadSymbol(loader, "eglPostSubBufferNV", []);

        // EGL_NV_stream_consumer_gltexture_yuv,
        _StreamConsumerGLTextureExternalAttribsNV = cast(PFN_eglStreamConsumerGLTextureExternalAttribsNV)loadSymbol(loader, "eglStreamConsumerGLTextureExternalAttribsNV", []);

        // EGL_NV_stream_metadata,
        _QueryDisplayAttribNV = cast(PFN_eglQueryDisplayAttribNV)loadSymbol(loader, "eglQueryDisplayAttribNV", []);
        _SetStreamMetadataNV = cast(PFN_eglSetStreamMetadataNV)loadSymbol(loader, "eglSetStreamMetadataNV", []);
        _QueryStreamMetadataNV = cast(PFN_eglQueryStreamMetadataNV)loadSymbol(loader, "eglQueryStreamMetadataNV", []);

        // EGL_NV_stream_reset,
        _ResetStreamNV = cast(PFN_eglResetStreamNV)loadSymbol(loader, "eglResetStreamNV", []);

        // EGL_NV_stream_sync,
        _CreateStreamSyncNV = cast(PFN_eglCreateStreamSyncNV)loadSymbol(loader, "eglCreateStreamSyncNV", []);

        // EGL_NV_sync,
        _CreateFenceSyncNV = cast(PFN_eglCreateFenceSyncNV)loadSymbol(loader, "eglCreateFenceSyncNV", []);
        _DestroySyncNV = cast(PFN_eglDestroySyncNV)loadSymbol(loader, "eglDestroySyncNV", []);
        _FenceNV = cast(PFN_eglFenceNV)loadSymbol(loader, "eglFenceNV", []);
        _ClientWaitSyncNV = cast(PFN_eglClientWaitSyncNV)loadSymbol(loader, "eglClientWaitSyncNV", []);
        _SignalSyncNV = cast(PFN_eglSignalSyncNV)loadSymbol(loader, "eglSignalSyncNV", []);
        _GetSyncAttribNV = cast(PFN_eglGetSyncAttribNV)loadSymbol(loader, "eglGetSyncAttribNV", []);

        // EGL_NV_system_time,
        _GetSystemTimeFrequencyNV = cast(PFN_eglGetSystemTimeFrequencyNV)loadSymbol(loader, "eglGetSystemTimeFrequencyNV", []);
        _GetSystemTimeNV = cast(PFN_eglGetSystemTimeNV)loadSymbol(loader, "eglGetSystemTimeNV", []);
    }

    private static void* loadSymbol(SymbolLoader loader, in string name, in string[] aliases) {
        void* sym = loader(name);
        if (sym) return sym;
        foreach (n; aliases) {
            sym = loader(n);
            if (sym) return sym;
        }
        return null;
    }

    /// Commands for EGL_VERSION_1_0
    public EGLBoolean ChooseConfig (EGLDisplay dpy, const(EGLint)* attrib_list, EGLConfig* configs, EGLint config_size, EGLint* num_config) const {
        assert(_ChooseConfig !is null, "EGL command eglChooseConfig was not loaded");
        return _ChooseConfig (dpy, attrib_list, configs, config_size, num_config);
    }
    /// ditto
    public EGLBoolean CopyBuffers (EGLDisplay dpy, EGLSurface surface, EGLNativePixmapType target) const {
        assert(_CopyBuffers !is null, "EGL command eglCopyBuffers was not loaded");
        return _CopyBuffers (dpy, surface, target);
    }
    /// ditto
    public EGLContext CreateContext (EGLDisplay dpy, EGLConfig config, EGLContext share_context, const(EGLint)* attrib_list) const {
        assert(_CreateContext !is null, "EGL command eglCreateContext was not loaded");
        return _CreateContext (dpy, config, share_context, attrib_list);
    }
    /// ditto
    public EGLSurface CreatePbufferSurface (EGLDisplay dpy, EGLConfig config, const(EGLint)* attrib_list) const {
        assert(_CreatePbufferSurface !is null, "EGL command eglCreatePbufferSurface was not loaded");
        return _CreatePbufferSurface (dpy, config, attrib_list);
    }
    /// ditto
    public EGLSurface CreatePixmapSurface (EGLDisplay dpy, EGLConfig config, EGLNativePixmapType pixmap, const(EGLint)* attrib_list) const {
        assert(_CreatePixmapSurface !is null, "EGL command eglCreatePixmapSurface was not loaded");
        return _CreatePixmapSurface (dpy, config, pixmap, attrib_list);
    }
    /// ditto
    public EGLSurface CreateWindowSurface (EGLDisplay dpy, EGLConfig config, EGLNativeWindowType win, const(EGLint)* attrib_list) const {
        assert(_CreateWindowSurface !is null, "EGL command eglCreateWindowSurface was not loaded");
        return _CreateWindowSurface (dpy, config, win, attrib_list);
    }
    /// ditto
    public EGLBoolean DestroyContext (EGLDisplay dpy, EGLContext ctx) const {
        assert(_DestroyContext !is null, "EGL command eglDestroyContext was not loaded");
        return _DestroyContext (dpy, ctx);
    }
    /// ditto
    public EGLBoolean DestroySurface (EGLDisplay dpy, EGLSurface surface) const {
        assert(_DestroySurface !is null, "EGL command eglDestroySurface was not loaded");
        return _DestroySurface (dpy, surface);
    }
    /// ditto
    public EGLBoolean GetConfigAttrib (EGLDisplay dpy, EGLConfig config, EGLint attribute, EGLint* value) const {
        assert(_GetConfigAttrib !is null, "EGL command eglGetConfigAttrib was not loaded");
        return _GetConfigAttrib (dpy, config, attribute, value);
    }
    /// ditto
    public EGLBoolean GetConfigs (EGLDisplay dpy, EGLConfig* configs, EGLint config_size, EGLint* num_config) const {
        assert(_GetConfigs !is null, "EGL command eglGetConfigs was not loaded");
        return _GetConfigs (dpy, configs, config_size, num_config);
    }
    /// ditto
    public EGLDisplay GetCurrentDisplay () const {
        assert(_GetCurrentDisplay !is null, "EGL command eglGetCurrentDisplay was not loaded");
        return _GetCurrentDisplay ();
    }
    /// ditto
    public EGLSurface GetCurrentSurface (EGLint readdraw) const {
        assert(_GetCurrentSurface !is null, "EGL command eglGetCurrentSurface was not loaded");
        return _GetCurrentSurface (readdraw);
    }
    /// ditto
    public EGLDisplay GetDisplay (EGLNativeDisplayType display_id) const {
        assert(_GetDisplay !is null, "EGL command eglGetDisplay was not loaded");
        return _GetDisplay (display_id);
    }
    /// ditto
    public EGLint GetError () const {
        assert(_GetError !is null, "EGL command eglGetError was not loaded");
        return _GetError ();
    }
    /// ditto
    public __eglMustCastToProperFunctionPointerType GetProcAddress (const(char)* procname) const {
        assert(_GetProcAddress !is null, "EGL command eglGetProcAddress was not loaded");
        return _GetProcAddress (procname);
    }
    /// ditto
    public EGLBoolean Initialize (EGLDisplay dpy, EGLint* major, EGLint* minor) const {
        assert(_Initialize !is null, "EGL command eglInitialize was not loaded");
        return _Initialize (dpy, major, minor);
    }
    /// ditto
    public EGLBoolean MakeCurrent (EGLDisplay dpy, EGLSurface draw, EGLSurface read, EGLContext ctx) const {
        assert(_MakeCurrent !is null, "EGL command eglMakeCurrent was not loaded");
        return _MakeCurrent (dpy, draw, read, ctx);
    }
    /// ditto
    public EGLBoolean QueryContext (EGLDisplay dpy, EGLContext ctx, EGLint attribute, EGLint* value) const {
        assert(_QueryContext !is null, "EGL command eglQueryContext was not loaded");
        return _QueryContext (dpy, ctx, attribute, value);
    }
    /// ditto
    public const(char)* QueryString (EGLDisplay dpy, EGLint name) const {
        assert(_QueryString !is null, "EGL command eglQueryString was not loaded");
        return _QueryString (dpy, name);
    }
    /// ditto
    public EGLBoolean QuerySurface (EGLDisplay dpy, EGLSurface surface, EGLint attribute, EGLint* value) const {
        assert(_QuerySurface !is null, "EGL command eglQuerySurface was not loaded");
        return _QuerySurface (dpy, surface, attribute, value);
    }
    /// ditto
    public EGLBoolean SwapBuffers (EGLDisplay dpy, EGLSurface surface) const {
        assert(_SwapBuffers !is null, "EGL command eglSwapBuffers was not loaded");
        return _SwapBuffers (dpy, surface);
    }
    /// ditto
    public EGLBoolean Terminate (EGLDisplay dpy) const {
        assert(_Terminate !is null, "EGL command eglTerminate was not loaded");
        return _Terminate (dpy);
    }
    /// ditto
    public EGLBoolean WaitGL () const {
        assert(_WaitGL !is null, "EGL command eglWaitGL was not loaded");
        return _WaitGL ();
    }
    /// ditto
    public EGLBoolean WaitNative (EGLint engine) const {
        assert(_WaitNative !is null, "EGL command eglWaitNative was not loaded");
        return _WaitNative (engine);
    }

    /// Commands for EGL_VERSION_1_1
    public EGLBoolean BindTexImage (EGLDisplay dpy, EGLSurface surface, EGLint buffer) const {
        assert(_BindTexImage !is null, "EGL command eglBindTexImage was not loaded");
        return _BindTexImage (dpy, surface, buffer);
    }
    /// ditto
    public EGLBoolean ReleaseTexImage (EGLDisplay dpy, EGLSurface surface, EGLint buffer) const {
        assert(_ReleaseTexImage !is null, "EGL command eglReleaseTexImage was not loaded");
        return _ReleaseTexImage (dpy, surface, buffer);
    }
    /// ditto
    public EGLBoolean SurfaceAttrib (EGLDisplay dpy, EGLSurface surface, EGLint attribute, EGLint value) const {
        assert(_SurfaceAttrib !is null, "EGL command eglSurfaceAttrib was not loaded");
        return _SurfaceAttrib (dpy, surface, attribute, value);
    }
    /// ditto
    public EGLBoolean SwapInterval (EGLDisplay dpy, EGLint interval) const {
        assert(_SwapInterval !is null, "EGL command eglSwapInterval was not loaded");
        return _SwapInterval (dpy, interval);
    }

    /// Commands for EGL_VERSION_1_2
    public EGLBoolean BindAPI (EGLenum api) const {
        assert(_BindAPI !is null, "EGL command eglBindAPI was not loaded");
        return _BindAPI (api);
    }
    /// ditto
    public EGLenum QueryAPI () const {
        assert(_QueryAPI !is null, "EGL command eglQueryAPI was not loaded");
        return _QueryAPI ();
    }
    /// ditto
    public EGLSurface CreatePbufferFromClientBuffer (EGLDisplay dpy, EGLenum buftype, EGLClientBuffer buffer, EGLConfig config, const(EGLint)* attrib_list) const {
        assert(_CreatePbufferFromClientBuffer !is null, "EGL command eglCreatePbufferFromClientBuffer was not loaded");
        return _CreatePbufferFromClientBuffer (dpy, buftype, buffer, config, attrib_list);
    }
    /// ditto
    public EGLBoolean ReleaseThread () const {
        assert(_ReleaseThread !is null, "EGL command eglReleaseThread was not loaded");
        return _ReleaseThread ();
    }
    /// ditto
    public EGLBoolean WaitClient () const {
        assert(_WaitClient !is null, "EGL command eglWaitClient was not loaded");
        return _WaitClient ();
    }

    /// Commands for EGL_VERSION_1_4
    public EGLContext GetCurrentContext () const {
        assert(_GetCurrentContext !is null, "EGL command eglGetCurrentContext was not loaded");
        return _GetCurrentContext ();
    }

    /// Commands for EGL_VERSION_1_5
    public EGLSync CreateSync (EGLDisplay dpy, EGLenum type, const(EGLAttrib)* attrib_list) const {
        assert(_CreateSync !is null, "EGL command eglCreateSync was not loaded");
        return _CreateSync (dpy, type, attrib_list);
    }
    /// ditto
    public EGLBoolean DestroySync (EGLDisplay dpy, EGLSync sync) const {
        assert(_DestroySync !is null, "EGL command eglDestroySync was not loaded");
        return _DestroySync (dpy, sync);
    }
    /// ditto
    public EGLint ClientWaitSync (EGLDisplay dpy, EGLSync sync, EGLint flags, EGLTime timeout) const {
        assert(_ClientWaitSync !is null, "EGL command eglClientWaitSync was not loaded");
        return _ClientWaitSync (dpy, sync, flags, timeout);
    }
    /// ditto
    public EGLBoolean GetSyncAttrib (EGLDisplay dpy, EGLSync sync, EGLint attribute, EGLAttrib* value) const {
        assert(_GetSyncAttrib !is null, "EGL command eglGetSyncAttrib was not loaded");
        return _GetSyncAttrib (dpy, sync, attribute, value);
    }
    /// ditto
    public EGLImage CreateImage (EGLDisplay dpy, EGLContext ctx, EGLenum target, EGLClientBuffer buffer, const(EGLAttrib)* attrib_list) const {
        assert(_CreateImage !is null, "EGL command eglCreateImage was not loaded");
        return _CreateImage (dpy, ctx, target, buffer, attrib_list);
    }
    /// ditto
    public EGLBoolean DestroyImage (EGLDisplay dpy, EGLImage image) const {
        assert(_DestroyImage !is null, "EGL command eglDestroyImage was not loaded");
        return _DestroyImage (dpy, image);
    }
    /// ditto
    public EGLDisplay GetPlatformDisplay (EGLenum platform, void* native_display, const(EGLAttrib)* attrib_list) const {
        assert(_GetPlatformDisplay !is null, "EGL command eglGetPlatformDisplay was not loaded");
        return _GetPlatformDisplay (platform, native_display, attrib_list);
    }
    /// ditto
    public EGLSurface CreatePlatformWindowSurface (EGLDisplay dpy, EGLConfig config, void* native_window, const(EGLAttrib)* attrib_list) const {
        assert(_CreatePlatformWindowSurface !is null, "EGL command eglCreatePlatformWindowSurface was not loaded");
        return _CreatePlatformWindowSurface (dpy, config, native_window, attrib_list);
    }
    /// ditto
    public EGLSurface CreatePlatformPixmapSurface (EGLDisplay dpy, EGLConfig config, void* native_pixmap, const(EGLAttrib)* attrib_list) const {
        assert(_CreatePlatformPixmapSurface !is null, "EGL command eglCreatePlatformPixmapSurface was not loaded");
        return _CreatePlatformPixmapSurface (dpy, config, native_pixmap, attrib_list);
    }
    /// ditto
    public EGLBoolean WaitSync (EGLDisplay dpy, EGLSync sync, EGLint flags) const {
        assert(_WaitSync !is null, "EGL command eglWaitSync was not loaded");
        return _WaitSync (dpy, sync, flags);
    }

    /// Commands for EGL_KHR_debug
    public EGLint DebugMessageControlKHR (EGLDEBUGPROCKHR callback, const(EGLAttrib)* attrib_list) const {
        assert(_DebugMessageControlKHR !is null, "EGL command eglDebugMessageControlKHR was not loaded");
        return _DebugMessageControlKHR (callback, attrib_list);
    }
    /// ditto
    public EGLBoolean QueryDebugKHR (EGLint attribute, EGLAttrib* value) const {
        assert(_QueryDebugKHR !is null, "EGL command eglQueryDebugKHR was not loaded");
        return _QueryDebugKHR (attribute, value);
    }
    /// ditto
    public EGLint LabelObjectKHR (EGLDisplay display, EGLenum objectType, EGLObjectKHR object, EGLLabelKHR label) const {
        assert(_LabelObjectKHR !is null, "EGL command eglLabelObjectKHR was not loaded");
        return _LabelObjectKHR (display, objectType, object, label);
    }

    /// Commands for EGL_KHR_display_reference
    public EGLBoolean QueryDisplayAttribKHR (EGLDisplay dpy, EGLint name, EGLAttrib* value) const {
        assert(_QueryDisplayAttribKHR !is null, "EGL command eglQueryDisplayAttribKHR was not loaded");
        return _QueryDisplayAttribKHR (dpy, name, value);
    }

    /// Commands for EGL_KHR_fence_sync
    public EGLSyncKHR CreateSyncKHR (EGLDisplay dpy, EGLenum type, const(EGLint)* attrib_list) const {
        assert(_CreateSyncKHR !is null, "EGL command eglCreateSyncKHR was not loaded");
        return _CreateSyncKHR (dpy, type, attrib_list);
    }
    /// ditto
    public EGLBoolean GetSyncAttribKHR (EGLDisplay dpy, EGLSyncKHR sync, EGLint attribute, EGLint* value) const {
        assert(_GetSyncAttribKHR !is null, "EGL command eglGetSyncAttribKHR was not loaded");
        return _GetSyncAttribKHR (dpy, sync, attribute, value);
    }

    /// Commands for EGL_KHR_image
    public EGLImageKHR CreateImageKHR (EGLDisplay dpy, EGLContext ctx, EGLenum target, EGLClientBuffer buffer, const(EGLint)* attrib_list) const {
        assert(_CreateImageKHR !is null, "EGL command eglCreateImageKHR was not loaded");
        return _CreateImageKHR (dpy, ctx, target, buffer, attrib_list);
    }

    /// Commands for EGL_KHR_lock_surface
    public EGLBoolean LockSurfaceKHR (EGLDisplay dpy, EGLSurface surface, const(EGLint)* attrib_list) const {
        assert(_LockSurfaceKHR !is null, "EGL command eglLockSurfaceKHR was not loaded");
        return _LockSurfaceKHR (dpy, surface, attrib_list);
    }
    /// ditto
    public EGLBoolean UnlockSurfaceKHR (EGLDisplay dpy, EGLSurface surface) const {
        assert(_UnlockSurfaceKHR !is null, "EGL command eglUnlockSurfaceKHR was not loaded");
        return _UnlockSurfaceKHR (dpy, surface);
    }

    /// Commands for EGL_KHR_lock_surface3
    public EGLBoolean QuerySurface64KHR (EGLDisplay dpy, EGLSurface surface, EGLint attribute, EGLAttribKHR* value) const {
        assert(_QuerySurface64KHR !is null, "EGL command eglQuerySurface64KHR was not loaded");
        return _QuerySurface64KHR (dpy, surface, attribute, value);
    }

    /// Commands for EGL_KHR_partial_update
    public EGLBoolean SetDamageRegionKHR (EGLDisplay dpy, EGLSurface surface, EGLint* rects, EGLint n_rects) const {
        assert(_SetDamageRegionKHR !is null, "EGL command eglSetDamageRegionKHR was not loaded");
        return _SetDamageRegionKHR (dpy, surface, rects, n_rects);
    }

    /// Commands for EGL_KHR_reusable_sync
    public EGLBoolean SignalSyncKHR (EGLDisplay dpy, EGLSyncKHR sync, EGLenum mode) const {
        assert(_SignalSyncKHR !is null, "EGL command eglSignalSyncKHR was not loaded");
        return _SignalSyncKHR (dpy, sync, mode);
    }

    /// Commands for EGL_KHR_stream
    public EGLStreamKHR CreateStreamKHR (EGLDisplay dpy, const(EGLint)* attrib_list) const {
        assert(_CreateStreamKHR !is null, "EGL command eglCreateStreamKHR was not loaded");
        return _CreateStreamKHR (dpy, attrib_list);
    }
    /// ditto
    public EGLBoolean DestroyStreamKHR (EGLDisplay dpy, EGLStreamKHR stream) const {
        assert(_DestroyStreamKHR !is null, "EGL command eglDestroyStreamKHR was not loaded");
        return _DestroyStreamKHR (dpy, stream);
    }
    /// ditto
    public EGLBoolean StreamAttribKHR (EGLDisplay dpy, EGLStreamKHR stream, EGLenum attribute, EGLint value) const {
        assert(_StreamAttribKHR !is null, "EGL command eglStreamAttribKHR was not loaded");
        return _StreamAttribKHR (dpy, stream, attribute, value);
    }
    /// ditto
    public EGLBoolean QueryStreamKHR (EGLDisplay dpy, EGLStreamKHR stream, EGLenum attribute, EGLint* value) const {
        assert(_QueryStreamKHR !is null, "EGL command eglQueryStreamKHR was not loaded");
        return _QueryStreamKHR (dpy, stream, attribute, value);
    }
    /// ditto
    public EGLBoolean QueryStreamu64KHR (EGLDisplay dpy, EGLStreamKHR stream, EGLenum attribute, EGLuint64KHR* value) const {
        assert(_QueryStreamu64KHR !is null, "EGL command eglQueryStreamu64KHR was not loaded");
        return _QueryStreamu64KHR (dpy, stream, attribute, value);
    }

    /// Commands for EGL_KHR_stream_attrib
    public EGLStreamKHR CreateStreamAttribKHR (EGLDisplay dpy, const(EGLAttrib)* attrib_list) const {
        assert(_CreateStreamAttribKHR !is null, "EGL command eglCreateStreamAttribKHR was not loaded");
        return _CreateStreamAttribKHR (dpy, attrib_list);
    }
    /// ditto
    public EGLBoolean SetStreamAttribKHR (EGLDisplay dpy, EGLStreamKHR stream, EGLenum attribute, EGLAttrib value) const {
        assert(_SetStreamAttribKHR !is null, "EGL command eglSetStreamAttribKHR was not loaded");
        return _SetStreamAttribKHR (dpy, stream, attribute, value);
    }
    /// ditto
    public EGLBoolean QueryStreamAttribKHR (EGLDisplay dpy, EGLStreamKHR stream, EGLenum attribute, EGLAttrib* value) const {
        assert(_QueryStreamAttribKHR !is null, "EGL command eglQueryStreamAttribKHR was not loaded");
        return _QueryStreamAttribKHR (dpy, stream, attribute, value);
    }
    /// ditto
    public EGLBoolean StreamConsumerAcquireAttribKHR (EGLDisplay dpy, EGLStreamKHR stream, const(EGLAttrib)* attrib_list) const {
        assert(_StreamConsumerAcquireAttribKHR !is null, "EGL command eglStreamConsumerAcquireAttribKHR was not loaded");
        return _StreamConsumerAcquireAttribKHR (dpy, stream, attrib_list);
    }
    /// ditto
    public EGLBoolean StreamConsumerReleaseAttribKHR (EGLDisplay dpy, EGLStreamKHR stream, const(EGLAttrib)* attrib_list) const {
        assert(_StreamConsumerReleaseAttribKHR !is null, "EGL command eglStreamConsumerReleaseAttribKHR was not loaded");
        return _StreamConsumerReleaseAttribKHR (dpy, stream, attrib_list);
    }

    /// Commands for EGL_KHR_stream_consumer_gltexture
    public EGLBoolean StreamConsumerGLTextureExternalKHR (EGLDisplay dpy, EGLStreamKHR stream) const {
        assert(_StreamConsumerGLTextureExternalKHR !is null, "EGL command eglStreamConsumerGLTextureExternalKHR was not loaded");
        return _StreamConsumerGLTextureExternalKHR (dpy, stream);
    }
    /// ditto
    public EGLBoolean StreamConsumerAcquireKHR (EGLDisplay dpy, EGLStreamKHR stream) const {
        assert(_StreamConsumerAcquireKHR !is null, "EGL command eglStreamConsumerAcquireKHR was not loaded");
        return _StreamConsumerAcquireKHR (dpy, stream);
    }
    /// ditto
    public EGLBoolean StreamConsumerReleaseKHR (EGLDisplay dpy, EGLStreamKHR stream) const {
        assert(_StreamConsumerReleaseKHR !is null, "EGL command eglStreamConsumerReleaseKHR was not loaded");
        return _StreamConsumerReleaseKHR (dpy, stream);
    }

    /// Commands for EGL_KHR_stream_cross_process_fd
    public EGLNativeFileDescriptorKHR GetStreamFileDescriptorKHR (EGLDisplay dpy, EGLStreamKHR stream) const {
        assert(_GetStreamFileDescriptorKHR !is null, "EGL command eglGetStreamFileDescriptorKHR was not loaded");
        return _GetStreamFileDescriptorKHR (dpy, stream);
    }
    /// ditto
    public EGLStreamKHR CreateStreamFromFileDescriptorKHR (EGLDisplay dpy, EGLNativeFileDescriptorKHR file_descriptor) const {
        assert(_CreateStreamFromFileDescriptorKHR !is null, "EGL command eglCreateStreamFromFileDescriptorKHR was not loaded");
        return _CreateStreamFromFileDescriptorKHR (dpy, file_descriptor);
    }

    /// Commands for EGL_KHR_stream_fifo
    public EGLBoolean QueryStreamTimeKHR (EGLDisplay dpy, EGLStreamKHR stream, EGLenum attribute, EGLTimeKHR* value) const {
        assert(_QueryStreamTimeKHR !is null, "EGL command eglQueryStreamTimeKHR was not loaded");
        return _QueryStreamTimeKHR (dpy, stream, attribute, value);
    }

    /// Commands for EGL_KHR_stream_producer_eglsurface
    public EGLSurface CreateStreamProducerSurfaceKHR (EGLDisplay dpy, EGLConfig config, EGLStreamKHR stream, const(EGLint)* attrib_list) const {
        assert(_CreateStreamProducerSurfaceKHR !is null, "EGL command eglCreateStreamProducerSurfaceKHR was not loaded");
        return _CreateStreamProducerSurfaceKHR (dpy, config, stream, attrib_list);
    }

    /// Commands for EGL_KHR_swap_buffers_with_damage
    public EGLBoolean SwapBuffersWithDamageKHR (EGLDisplay dpy, EGLSurface surface, EGLint* rects, EGLint n_rects) const {
        assert(_SwapBuffersWithDamageKHR !is null, "EGL command eglSwapBuffersWithDamageKHR was not loaded");
        return _SwapBuffersWithDamageKHR (dpy, surface, rects, n_rects);
    }

    /// Commands for EGL_KHR_wait_sync
    public EGLint WaitSyncKHR (EGLDisplay dpy, EGLSyncKHR sync, EGLint flags) const {
        assert(_WaitSyncKHR !is null, "EGL command eglWaitSyncKHR was not loaded");
        return _WaitSyncKHR (dpy, sync, flags);
    }

    /// Commands for EGL_ANDROID_blob_cache
    public void SetBlobCacheFuncsANDROID (EGLDisplay dpy, EGLSetBlobFuncANDROID set, EGLGetBlobFuncANDROID get) const {
        assert(_SetBlobCacheFuncsANDROID !is null, "EGL command eglSetBlobCacheFuncsANDROID was not loaded");
        return _SetBlobCacheFuncsANDROID (dpy, set, get);
    }

    /// Commands for EGL_ANDROID_create_native_client_buffer
    public EGLClientBuffer CreateNativeClientBufferANDROID (const(EGLint)* attrib_list) const {
        assert(_CreateNativeClientBufferANDROID !is null, "EGL command eglCreateNativeClientBufferANDROID was not loaded");
        return _CreateNativeClientBufferANDROID (attrib_list);
    }

    /// Commands for EGL_ANDROID_get_frame_timestamps
    public EGLBoolean GetCompositorTimingSupportedANDROID (EGLDisplay dpy, EGLSurface surface, EGLint name) const {
        assert(_GetCompositorTimingSupportedANDROID !is null, "EGL command eglGetCompositorTimingSupportedANDROID was not loaded");
        return _GetCompositorTimingSupportedANDROID (dpy, surface, name);
    }
    /// ditto
    public EGLBoolean GetCompositorTimingANDROID (EGLDisplay dpy, EGLSurface surface, EGLint numTimestamps, const(EGLint)* names, EGLnsecsANDROID* values) const {
        assert(_GetCompositorTimingANDROID !is null, "EGL command eglGetCompositorTimingANDROID was not loaded");
        return _GetCompositorTimingANDROID (dpy, surface, numTimestamps, names, values);
    }
    /// ditto
    public EGLBoolean GetNextFrameIdANDROID (EGLDisplay dpy, EGLSurface surface, EGLuint64KHR* frameId) const {
        assert(_GetNextFrameIdANDROID !is null, "EGL command eglGetNextFrameIdANDROID was not loaded");
        return _GetNextFrameIdANDROID (dpy, surface, frameId);
    }
    /// ditto
    public EGLBoolean GetFrameTimestampSupportedANDROID (EGLDisplay dpy, EGLSurface surface, EGLint timestamp) const {
        assert(_GetFrameTimestampSupportedANDROID !is null, "EGL command eglGetFrameTimestampSupportedANDROID was not loaded");
        return _GetFrameTimestampSupportedANDROID (dpy, surface, timestamp);
    }
    /// ditto
    public EGLBoolean GetFrameTimestampsANDROID (EGLDisplay dpy, EGLSurface surface, EGLuint64KHR frameId, EGLint numTimestamps, const(EGLint)* timestamps, EGLnsecsANDROID* values) const {
        assert(_GetFrameTimestampsANDROID !is null, "EGL command eglGetFrameTimestampsANDROID was not loaded");
        return _GetFrameTimestampsANDROID (dpy, surface, frameId, numTimestamps, timestamps, values);
    }

    /// Commands for EGL_ANDROID_get_native_client_buffer
    public EGLClientBuffer GetNativeClientBufferANDROID (const(AHardwareBuffer)* buffer) const {
        assert(_GetNativeClientBufferANDROID !is null, "EGL command eglGetNativeClientBufferANDROID was not loaded");
        return _GetNativeClientBufferANDROID (buffer);
    }

    /// Commands for EGL_ANDROID_native_fence_sync
    public EGLint DupNativeFenceFDANDROID (EGLDisplay dpy, EGLSyncKHR sync) const {
        assert(_DupNativeFenceFDANDROID !is null, "EGL command eglDupNativeFenceFDANDROID was not loaded");
        return _DupNativeFenceFDANDROID (dpy, sync);
    }

    /// Commands for EGL_ANDROID_presentation_time
    public EGLBoolean PresentationTimeANDROID (EGLDisplay dpy, EGLSurface surface, EGLnsecsANDROID time) const {
        assert(_PresentationTimeANDROID !is null, "EGL command eglPresentationTimeANDROID was not loaded");
        return _PresentationTimeANDROID (dpy, surface, time);
    }

    /// Commands for EGL_ANGLE_query_surface_pointer
    public EGLBoolean QuerySurfacePointerANGLE (EGLDisplay dpy, EGLSurface surface, EGLint attribute, void** value) const {
        assert(_QuerySurfacePointerANGLE !is null, "EGL command eglQuerySurfacePointerANGLE was not loaded");
        return _QuerySurfacePointerANGLE (dpy, surface, attribute, value);
    }

    /// Commands for EGL_EXT_compositor
    public EGLBoolean CompositorSetContextListEXT (const(EGLint)* external_ref_ids, EGLint num_entries) const {
        assert(_CompositorSetContextListEXT !is null, "EGL command eglCompositorSetContextListEXT was not loaded");
        return _CompositorSetContextListEXT (external_ref_ids, num_entries);
    }
    /// ditto
    public EGLBoolean CompositorSetContextAttributesEXT (EGLint external_ref_id, const(EGLint)* context_attributes, EGLint num_entries) const {
        assert(_CompositorSetContextAttributesEXT !is null, "EGL command eglCompositorSetContextAttributesEXT was not loaded");
        return _CompositorSetContextAttributesEXT (external_ref_id, context_attributes, num_entries);
    }
    /// ditto
    public EGLBoolean CompositorSetWindowListEXT (EGLint external_ref_id, const(EGLint)* external_win_ids, EGLint num_entries) const {
        assert(_CompositorSetWindowListEXT !is null, "EGL command eglCompositorSetWindowListEXT was not loaded");
        return _CompositorSetWindowListEXT (external_ref_id, external_win_ids, num_entries);
    }
    /// ditto
    public EGLBoolean CompositorSetWindowAttributesEXT (EGLint external_win_id, const(EGLint)* window_attributes, EGLint num_entries) const {
        assert(_CompositorSetWindowAttributesEXT !is null, "EGL command eglCompositorSetWindowAttributesEXT was not loaded");
        return _CompositorSetWindowAttributesEXT (external_win_id, window_attributes, num_entries);
    }
    /// ditto
    public EGLBoolean CompositorBindTexWindowEXT (EGLint external_win_id) const {
        assert(_CompositorBindTexWindowEXT !is null, "EGL command eglCompositorBindTexWindowEXT was not loaded");
        return _CompositorBindTexWindowEXT (external_win_id);
    }
    /// ditto
    public EGLBoolean CompositorSetSizeEXT (EGLint external_win_id, EGLint width, EGLint height) const {
        assert(_CompositorSetSizeEXT !is null, "EGL command eglCompositorSetSizeEXT was not loaded");
        return _CompositorSetSizeEXT (external_win_id, width, height);
    }
    /// ditto
    public EGLBoolean CompositorSwapPolicyEXT (EGLint external_win_id, EGLint policy) const {
        assert(_CompositorSwapPolicyEXT !is null, "EGL command eglCompositorSwapPolicyEXT was not loaded");
        return _CompositorSwapPolicyEXT (external_win_id, policy);
    }

    /// Commands for EGL_EXT_device_base
    public EGLBoolean QueryDeviceAttribEXT (EGLDeviceEXT device, EGLint attribute, EGLAttrib* value) const {
        assert(_QueryDeviceAttribEXT !is null, "EGL command eglQueryDeviceAttribEXT was not loaded");
        return _QueryDeviceAttribEXT (device, attribute, value);
    }
    /// ditto
    public const(char)* QueryDeviceStringEXT (EGLDeviceEXT device, EGLint name) const {
        assert(_QueryDeviceStringEXT !is null, "EGL command eglQueryDeviceStringEXT was not loaded");
        return _QueryDeviceStringEXT (device, name);
    }
    /// ditto
    public EGLBoolean QueryDevicesEXT (EGLint max_devices, EGLDeviceEXT* devices, EGLint* num_devices) const {
        assert(_QueryDevicesEXT !is null, "EGL command eglQueryDevicesEXT was not loaded");
        return _QueryDevicesEXT (max_devices, devices, num_devices);
    }
    /// ditto
    public EGLBoolean QueryDisplayAttribEXT (EGLDisplay dpy, EGLint attribute, EGLAttrib* value) const {
        assert(_QueryDisplayAttribEXT !is null, "EGL command eglQueryDisplayAttribEXT was not loaded");
        return _QueryDisplayAttribEXT (dpy, attribute, value);
    }

    /// Commands for EGL_EXT_image_dma_buf_import_modifiers
    public EGLBoolean QueryDmaBufFormatsEXT (EGLDisplay dpy, EGLint max_formats, EGLint* formats, EGLint* num_formats) const {
        assert(_QueryDmaBufFormatsEXT !is null, "EGL command eglQueryDmaBufFormatsEXT was not loaded");
        return _QueryDmaBufFormatsEXT (dpy, max_formats, formats, num_formats);
    }
    /// ditto
    public EGLBoolean QueryDmaBufModifiersEXT (EGLDisplay dpy, EGLint format, EGLint max_modifiers, EGLuint64KHR* modifiers, EGLBoolean* external_only, EGLint* num_modifiers) const {
        assert(_QueryDmaBufModifiersEXT !is null, "EGL command eglQueryDmaBufModifiersEXT was not loaded");
        return _QueryDmaBufModifiersEXT (dpy, format, max_modifiers, modifiers, external_only, num_modifiers);
    }

    /// Commands for EGL_EXT_output_base
    public EGLBoolean GetOutputLayersEXT (EGLDisplay dpy, const(EGLAttrib)* attrib_list, EGLOutputLayerEXT* layers, EGLint max_layers, EGLint* num_layers) const {
        assert(_GetOutputLayersEXT !is null, "EGL command eglGetOutputLayersEXT was not loaded");
        return _GetOutputLayersEXT (dpy, attrib_list, layers, max_layers, num_layers);
    }
    /// ditto
    public EGLBoolean GetOutputPortsEXT (EGLDisplay dpy, const(EGLAttrib)* attrib_list, EGLOutputPortEXT* ports, EGLint max_ports, EGLint* num_ports) const {
        assert(_GetOutputPortsEXT !is null, "EGL command eglGetOutputPortsEXT was not loaded");
        return _GetOutputPortsEXT (dpy, attrib_list, ports, max_ports, num_ports);
    }
    /// ditto
    public EGLBoolean OutputLayerAttribEXT (EGLDisplay dpy, EGLOutputLayerEXT layer, EGLint attribute, EGLAttrib value) const {
        assert(_OutputLayerAttribEXT !is null, "EGL command eglOutputLayerAttribEXT was not loaded");
        return _OutputLayerAttribEXT (dpy, layer, attribute, value);
    }
    /// ditto
    public EGLBoolean QueryOutputLayerAttribEXT (EGLDisplay dpy, EGLOutputLayerEXT layer, EGLint attribute, EGLAttrib* value) const {
        assert(_QueryOutputLayerAttribEXT !is null, "EGL command eglQueryOutputLayerAttribEXT was not loaded");
        return _QueryOutputLayerAttribEXT (dpy, layer, attribute, value);
    }
    /// ditto
    public const(char)* QueryOutputLayerStringEXT (EGLDisplay dpy, EGLOutputLayerEXT layer, EGLint name) const {
        assert(_QueryOutputLayerStringEXT !is null, "EGL command eglQueryOutputLayerStringEXT was not loaded");
        return _QueryOutputLayerStringEXT (dpy, layer, name);
    }
    /// ditto
    public EGLBoolean OutputPortAttribEXT (EGLDisplay dpy, EGLOutputPortEXT port, EGLint attribute, EGLAttrib value) const {
        assert(_OutputPortAttribEXT !is null, "EGL command eglOutputPortAttribEXT was not loaded");
        return _OutputPortAttribEXT (dpy, port, attribute, value);
    }
    /// ditto
    public EGLBoolean QueryOutputPortAttribEXT (EGLDisplay dpy, EGLOutputPortEXT port, EGLint attribute, EGLAttrib* value) const {
        assert(_QueryOutputPortAttribEXT !is null, "EGL command eglQueryOutputPortAttribEXT was not loaded");
        return _QueryOutputPortAttribEXT (dpy, port, attribute, value);
    }
    /// ditto
    public const(char)* QueryOutputPortStringEXT (EGLDisplay dpy, EGLOutputPortEXT port, EGLint name) const {
        assert(_QueryOutputPortStringEXT !is null, "EGL command eglQueryOutputPortStringEXT was not loaded");
        return _QueryOutputPortStringEXT (dpy, port, name);
    }

    /// Commands for EGL_EXT_platform_base
    public EGLDisplay GetPlatformDisplayEXT (EGLenum platform, void* native_display, const(EGLint)* attrib_list) const {
        assert(_GetPlatformDisplayEXT !is null, "EGL command eglGetPlatformDisplayEXT was not loaded");
        return _GetPlatformDisplayEXT (platform, native_display, attrib_list);
    }
    /// ditto
    public EGLSurface CreatePlatformWindowSurfaceEXT (EGLDisplay dpy, EGLConfig config, void* native_window, const(EGLint)* attrib_list) const {
        assert(_CreatePlatformWindowSurfaceEXT !is null, "EGL command eglCreatePlatformWindowSurfaceEXT was not loaded");
        return _CreatePlatformWindowSurfaceEXT (dpy, config, native_window, attrib_list);
    }
    /// ditto
    public EGLSurface CreatePlatformPixmapSurfaceEXT (EGLDisplay dpy, EGLConfig config, void* native_pixmap, const(EGLint)* attrib_list) const {
        assert(_CreatePlatformPixmapSurfaceEXT !is null, "EGL command eglCreatePlatformPixmapSurfaceEXT was not loaded");
        return _CreatePlatformPixmapSurfaceEXT (dpy, config, native_pixmap, attrib_list);
    }

    /// Commands for EGL_EXT_stream_consumer_egloutput
    public EGLBoolean StreamConsumerOutputEXT (EGLDisplay dpy, EGLStreamKHR stream, EGLOutputLayerEXT layer) const {
        assert(_StreamConsumerOutputEXT !is null, "EGL command eglStreamConsumerOutputEXT was not loaded");
        return _StreamConsumerOutputEXT (dpy, stream, layer);
    }

    /// Commands for EGL_EXT_swap_buffers_with_damage
    public EGLBoolean SwapBuffersWithDamageEXT (EGLDisplay dpy, EGLSurface surface, EGLint* rects, EGLint n_rects) const {
        assert(_SwapBuffersWithDamageEXT !is null, "EGL command eglSwapBuffersWithDamageEXT was not loaded");
        return _SwapBuffersWithDamageEXT (dpy, surface, rects, n_rects);
    }

    /// Commands for EGL_HI_clientpixmap
    public EGLSurface CreatePixmapSurfaceHI (EGLDisplay dpy, EGLConfig config, EGLClientPixmapHI* pixmap) const {
        assert(_CreatePixmapSurfaceHI !is null, "EGL command eglCreatePixmapSurfaceHI was not loaded");
        return _CreatePixmapSurfaceHI (dpy, config, pixmap);
    }

    /// Commands for EGL_MESA_drm_image
    public EGLImageKHR CreateDRMImageMESA (EGLDisplay dpy, const(EGLint)* attrib_list) const {
        assert(_CreateDRMImageMESA !is null, "EGL command eglCreateDRMImageMESA was not loaded");
        return _CreateDRMImageMESA (dpy, attrib_list);
    }
    /// ditto
    public EGLBoolean ExportDRMImageMESA (EGLDisplay dpy, EGLImageKHR image, EGLint* name, EGLint* handle, EGLint* stride) const {
        assert(_ExportDRMImageMESA !is null, "EGL command eglExportDRMImageMESA was not loaded");
        return _ExportDRMImageMESA (dpy, image, name, handle, stride);
    }

    /// Commands for EGL_MESA_image_dma_buf_export
    public EGLBoolean ExportDMABUFImageQueryMESA (EGLDisplay dpy, EGLImageKHR image, int* fourcc, int* num_planes, EGLuint64KHR* modifiers) const {
        assert(_ExportDMABUFImageQueryMESA !is null, "EGL command eglExportDMABUFImageQueryMESA was not loaded");
        return _ExportDMABUFImageQueryMESA (dpy, image, fourcc, num_planes, modifiers);
    }
    /// ditto
    public EGLBoolean ExportDMABUFImageMESA (EGLDisplay dpy, EGLImageKHR image, int* fds, EGLint* strides, EGLint* offsets) const {
        assert(_ExportDMABUFImageMESA !is null, "EGL command eglExportDMABUFImageMESA was not loaded");
        return _ExportDMABUFImageMESA (dpy, image, fds, strides, offsets);
    }

    /// Commands for EGL_NOK_swap_region
    public EGLBoolean SwapBuffersRegionNOK (EGLDisplay dpy, EGLSurface surface, EGLint numRects, const(EGLint)* rects) const {
        assert(_SwapBuffersRegionNOK !is null, "EGL command eglSwapBuffersRegionNOK was not loaded");
        return _SwapBuffersRegionNOK (dpy, surface, numRects, rects);
    }

    /// Commands for EGL_NOK_swap_region2
    public EGLBoolean SwapBuffersRegion2NOK (EGLDisplay dpy, EGLSurface surface, EGLint numRects, const(EGLint)* rects) const {
        assert(_SwapBuffersRegion2NOK !is null, "EGL command eglSwapBuffersRegion2NOK was not loaded");
        return _SwapBuffersRegion2NOK (dpy, surface, numRects, rects);
    }

    /// Commands for EGL_NV_native_query
    public EGLBoolean QueryNativeDisplayNV (EGLDisplay dpy, EGLNativeDisplayType* display_id) const {
        assert(_QueryNativeDisplayNV !is null, "EGL command eglQueryNativeDisplayNV was not loaded");
        return _QueryNativeDisplayNV (dpy, display_id);
    }
    /// ditto
    public EGLBoolean QueryNativeWindowNV (EGLDisplay dpy, EGLSurface surf, EGLNativeWindowType* window) const {
        assert(_QueryNativeWindowNV !is null, "EGL command eglQueryNativeWindowNV was not loaded");
        return _QueryNativeWindowNV (dpy, surf, window);
    }
    /// ditto
    public EGLBoolean QueryNativePixmapNV (EGLDisplay dpy, EGLSurface surf, EGLNativePixmapType* pixmap) const {
        assert(_QueryNativePixmapNV !is null, "EGL command eglQueryNativePixmapNV was not loaded");
        return _QueryNativePixmapNV (dpy, surf, pixmap);
    }

    /// Commands for EGL_NV_post_sub_buffer
    public EGLBoolean PostSubBufferNV (EGLDisplay dpy, EGLSurface surface, EGLint x, EGLint y, EGLint width, EGLint height) const {
        assert(_PostSubBufferNV !is null, "EGL command eglPostSubBufferNV was not loaded");
        return _PostSubBufferNV (dpy, surface, x, y, width, height);
    }

    /// Commands for EGL_NV_stream_consumer_gltexture_yuv
    public EGLBoolean StreamConsumerGLTextureExternalAttribsNV (EGLDisplay dpy, EGLStreamKHR stream, const(EGLAttrib)* attrib_list) const {
        assert(_StreamConsumerGLTextureExternalAttribsNV !is null, "EGL command eglStreamConsumerGLTextureExternalAttribsNV was not loaded");
        return _StreamConsumerGLTextureExternalAttribsNV (dpy, stream, attrib_list);
    }

    /// Commands for EGL_NV_stream_metadata
    public EGLBoolean QueryDisplayAttribNV (EGLDisplay dpy, EGLint attribute, EGLAttrib* value) const {
        assert(_QueryDisplayAttribNV !is null, "EGL command eglQueryDisplayAttribNV was not loaded");
        return _QueryDisplayAttribNV (dpy, attribute, value);
    }
    /// ditto
    public EGLBoolean SetStreamMetadataNV (EGLDisplay dpy, EGLStreamKHR stream, EGLint n, EGLint offset, EGLint size, const(void)* data) const {
        assert(_SetStreamMetadataNV !is null, "EGL command eglSetStreamMetadataNV was not loaded");
        return _SetStreamMetadataNV (dpy, stream, n, offset, size, data);
    }
    /// ditto
    public EGLBoolean QueryStreamMetadataNV (EGLDisplay dpy, EGLStreamKHR stream, EGLenum name, EGLint n, EGLint offset, EGLint size, void* data) const {
        assert(_QueryStreamMetadataNV !is null, "EGL command eglQueryStreamMetadataNV was not loaded");
        return _QueryStreamMetadataNV (dpy, stream, name, n, offset, size, data);
    }

    /// Commands for EGL_NV_stream_reset
    public EGLBoolean ResetStreamNV (EGLDisplay dpy, EGLStreamKHR stream) const {
        assert(_ResetStreamNV !is null, "EGL command eglResetStreamNV was not loaded");
        return _ResetStreamNV (dpy, stream);
    }

    /// Commands for EGL_NV_stream_sync
    public EGLSyncKHR CreateStreamSyncNV (EGLDisplay dpy, EGLStreamKHR stream, EGLenum type, const(EGLint)* attrib_list) const {
        assert(_CreateStreamSyncNV !is null, "EGL command eglCreateStreamSyncNV was not loaded");
        return _CreateStreamSyncNV (dpy, stream, type, attrib_list);
    }

    /// Commands for EGL_NV_sync
    public EGLSyncNV CreateFenceSyncNV (EGLDisplay dpy, EGLenum condition, const(EGLint)* attrib_list) const {
        assert(_CreateFenceSyncNV !is null, "EGL command eglCreateFenceSyncNV was not loaded");
        return _CreateFenceSyncNV (dpy, condition, attrib_list);
    }
    /// ditto
    public EGLBoolean DestroySyncNV (EGLSyncNV sync) const {
        assert(_DestroySyncNV !is null, "EGL command eglDestroySyncNV was not loaded");
        return _DestroySyncNV (sync);
    }
    /// ditto
    public EGLBoolean FenceNV (EGLSyncNV sync) const {
        assert(_FenceNV !is null, "EGL command eglFenceNV was not loaded");
        return _FenceNV (sync);
    }
    /// ditto
    public EGLint ClientWaitSyncNV (EGLSyncNV sync, EGLint flags, EGLTimeNV timeout) const {
        assert(_ClientWaitSyncNV !is null, "EGL command eglClientWaitSyncNV was not loaded");
        return _ClientWaitSyncNV (sync, flags, timeout);
    }
    /// ditto
    public EGLBoolean SignalSyncNV (EGLSyncNV sync, EGLenum mode) const {
        assert(_SignalSyncNV !is null, "EGL command eglSignalSyncNV was not loaded");
        return _SignalSyncNV (sync, mode);
    }
    /// ditto
    public EGLBoolean GetSyncAttribNV (EGLSyncNV sync, EGLint attribute, EGLint* value) const {
        assert(_GetSyncAttribNV !is null, "EGL command eglGetSyncAttribNV was not loaded");
        return _GetSyncAttribNV (sync, attribute, value);
    }

    /// Commands for EGL_NV_system_time
    public EGLuint64NV GetSystemTimeFrequencyNV () const {
        assert(_GetSystemTimeFrequencyNV !is null, "EGL command eglGetSystemTimeFrequencyNV was not loaded");
        return _GetSystemTimeFrequencyNV ();
    }
    /// ditto
    public EGLuint64NV GetSystemTimeNV () const {
        assert(_GetSystemTimeNV !is null, "EGL command eglGetSystemTimeNV was not loaded");
        return _GetSystemTimeNV ();
    }

    // EGL_VERSION_1_0
    private PFN_eglChooseConfig _ChooseConfig;
    private PFN_eglCopyBuffers _CopyBuffers;
    private PFN_eglCreateContext _CreateContext;
    private PFN_eglCreatePbufferSurface _CreatePbufferSurface;
    private PFN_eglCreatePixmapSurface _CreatePixmapSurface;
    private PFN_eglCreateWindowSurface _CreateWindowSurface;
    private PFN_eglDestroyContext _DestroyContext;
    private PFN_eglDestroySurface _DestroySurface;
    private PFN_eglGetConfigAttrib _GetConfigAttrib;
    private PFN_eglGetConfigs _GetConfigs;
    private PFN_eglGetCurrentDisplay _GetCurrentDisplay;
    private PFN_eglGetCurrentSurface _GetCurrentSurface;
    private PFN_eglGetDisplay _GetDisplay;
    private PFN_eglGetError _GetError;
    private PFN_eglGetProcAddress _GetProcAddress;
    private PFN_eglInitialize _Initialize;
    private PFN_eglMakeCurrent _MakeCurrent;
    private PFN_eglQueryContext _QueryContext;
    private PFN_eglQueryString _QueryString;
    private PFN_eglQuerySurface _QuerySurface;
    private PFN_eglSwapBuffers _SwapBuffers;
    private PFN_eglTerminate _Terminate;
    private PFN_eglWaitGL _WaitGL;
    private PFN_eglWaitNative _WaitNative;

    // EGL_VERSION_1_1
    private PFN_eglBindTexImage _BindTexImage;
    private PFN_eglReleaseTexImage _ReleaseTexImage;
    private PFN_eglSurfaceAttrib _SurfaceAttrib;
    private PFN_eglSwapInterval _SwapInterval;

    // EGL_VERSION_1_2
    private PFN_eglBindAPI _BindAPI;
    private PFN_eglQueryAPI _QueryAPI;
    private PFN_eglCreatePbufferFromClientBuffer _CreatePbufferFromClientBuffer;
    private PFN_eglReleaseThread _ReleaseThread;
    private PFN_eglWaitClient _WaitClient;

    // EGL_VERSION_1_4
    private PFN_eglGetCurrentContext _GetCurrentContext;

    // EGL_VERSION_1_5
    private PFN_eglCreateSync _CreateSync;
    private PFN_eglDestroySync _DestroySync;
    private PFN_eglClientWaitSync _ClientWaitSync;
    private PFN_eglGetSyncAttrib _GetSyncAttrib;
    private PFN_eglCreateImage _CreateImage;
    private PFN_eglDestroyImage _DestroyImage;
    private PFN_eglGetPlatformDisplay _GetPlatformDisplay;
    private PFN_eglCreatePlatformWindowSurface _CreatePlatformWindowSurface;
    private PFN_eglCreatePlatformPixmapSurface _CreatePlatformPixmapSurface;
    private PFN_eglWaitSync _WaitSync;

    // EGL_KHR_debug,
    private PFN_eglDebugMessageControlKHR _DebugMessageControlKHR;
    private PFN_eglQueryDebugKHR _QueryDebugKHR;
    private PFN_eglLabelObjectKHR _LabelObjectKHR;

    // EGL_KHR_display_reference,
    private PFN_eglQueryDisplayAttribKHR _QueryDisplayAttribKHR;

    // EGL_KHR_fence_sync,
    private PFN_eglCreateSyncKHR _CreateSyncKHR;
    private PFN_eglGetSyncAttribKHR _GetSyncAttribKHR;

    // EGL_KHR_image,
    private PFN_eglCreateImageKHR _CreateImageKHR;

    // EGL_KHR_lock_surface,
    private PFN_eglLockSurfaceKHR _LockSurfaceKHR;
    private PFN_eglUnlockSurfaceKHR _UnlockSurfaceKHR;

    // EGL_KHR_lock_surface3,
    private PFN_eglQuerySurface64KHR _QuerySurface64KHR;

    // EGL_KHR_partial_update,
    private PFN_eglSetDamageRegionKHR _SetDamageRegionKHR;

    // EGL_KHR_reusable_sync,
    private PFN_eglSignalSyncKHR _SignalSyncKHR;

    // EGL_KHR_stream,
    private PFN_eglCreateStreamKHR _CreateStreamKHR;
    private PFN_eglDestroyStreamKHR _DestroyStreamKHR;
    private PFN_eglStreamAttribKHR _StreamAttribKHR;
    private PFN_eglQueryStreamKHR _QueryStreamKHR;
    private PFN_eglQueryStreamu64KHR _QueryStreamu64KHR;

    // EGL_KHR_stream_attrib,
    private PFN_eglCreateStreamAttribKHR _CreateStreamAttribKHR;
    private PFN_eglSetStreamAttribKHR _SetStreamAttribKHR;
    private PFN_eglQueryStreamAttribKHR _QueryStreamAttribKHR;
    private PFN_eglStreamConsumerAcquireAttribKHR _StreamConsumerAcquireAttribKHR;
    private PFN_eglStreamConsumerReleaseAttribKHR _StreamConsumerReleaseAttribKHR;

    // EGL_KHR_stream_consumer_gltexture,
    private PFN_eglStreamConsumerGLTextureExternalKHR _StreamConsumerGLTextureExternalKHR;
    private PFN_eglStreamConsumerAcquireKHR _StreamConsumerAcquireKHR;
    private PFN_eglStreamConsumerReleaseKHR _StreamConsumerReleaseKHR;

    // EGL_KHR_stream_cross_process_fd,
    private PFN_eglGetStreamFileDescriptorKHR _GetStreamFileDescriptorKHR;
    private PFN_eglCreateStreamFromFileDescriptorKHR _CreateStreamFromFileDescriptorKHR;

    // EGL_KHR_stream_fifo,
    private PFN_eglQueryStreamTimeKHR _QueryStreamTimeKHR;

    // EGL_KHR_stream_producer_eglsurface,
    private PFN_eglCreateStreamProducerSurfaceKHR _CreateStreamProducerSurfaceKHR;

    // EGL_KHR_swap_buffers_with_damage,
    private PFN_eglSwapBuffersWithDamageKHR _SwapBuffersWithDamageKHR;

    // EGL_KHR_wait_sync,
    private PFN_eglWaitSyncKHR _WaitSyncKHR;

    // EGL_ANDROID_blob_cache,
    private PFN_eglSetBlobCacheFuncsANDROID _SetBlobCacheFuncsANDROID;

    // EGL_ANDROID_create_native_client_buffer,
    private PFN_eglCreateNativeClientBufferANDROID _CreateNativeClientBufferANDROID;

    // EGL_ANDROID_get_frame_timestamps,
    private PFN_eglGetCompositorTimingSupportedANDROID _GetCompositorTimingSupportedANDROID;
    private PFN_eglGetCompositorTimingANDROID _GetCompositorTimingANDROID;
    private PFN_eglGetNextFrameIdANDROID _GetNextFrameIdANDROID;
    private PFN_eglGetFrameTimestampSupportedANDROID _GetFrameTimestampSupportedANDROID;
    private PFN_eglGetFrameTimestampsANDROID _GetFrameTimestampsANDROID;

    // EGL_ANDROID_get_native_client_buffer,
    private PFN_eglGetNativeClientBufferANDROID _GetNativeClientBufferANDROID;

    // EGL_ANDROID_native_fence_sync,
    private PFN_eglDupNativeFenceFDANDROID _DupNativeFenceFDANDROID;

    // EGL_ANDROID_presentation_time,
    private PFN_eglPresentationTimeANDROID _PresentationTimeANDROID;

    // EGL_ANGLE_query_surface_pointer,
    private PFN_eglQuerySurfacePointerANGLE _QuerySurfacePointerANGLE;

    // EGL_EXT_compositor,
    private PFN_eglCompositorSetContextListEXT _CompositorSetContextListEXT;
    private PFN_eglCompositorSetContextAttributesEXT _CompositorSetContextAttributesEXT;
    private PFN_eglCompositorSetWindowListEXT _CompositorSetWindowListEXT;
    private PFN_eglCompositorSetWindowAttributesEXT _CompositorSetWindowAttributesEXT;
    private PFN_eglCompositorBindTexWindowEXT _CompositorBindTexWindowEXT;
    private PFN_eglCompositorSetSizeEXT _CompositorSetSizeEXT;
    private PFN_eglCompositorSwapPolicyEXT _CompositorSwapPolicyEXT;

    // EGL_EXT_device_base,
    private PFN_eglQueryDeviceAttribEXT _QueryDeviceAttribEXT;
    private PFN_eglQueryDeviceStringEXT _QueryDeviceStringEXT;
    private PFN_eglQueryDevicesEXT _QueryDevicesEXT;
    private PFN_eglQueryDisplayAttribEXT _QueryDisplayAttribEXT;

    // EGL_EXT_image_dma_buf_import_modifiers,
    private PFN_eglQueryDmaBufFormatsEXT _QueryDmaBufFormatsEXT;
    private PFN_eglQueryDmaBufModifiersEXT _QueryDmaBufModifiersEXT;

    // EGL_EXT_output_base,
    private PFN_eglGetOutputLayersEXT _GetOutputLayersEXT;
    private PFN_eglGetOutputPortsEXT _GetOutputPortsEXT;
    private PFN_eglOutputLayerAttribEXT _OutputLayerAttribEXT;
    private PFN_eglQueryOutputLayerAttribEXT _QueryOutputLayerAttribEXT;
    private PFN_eglQueryOutputLayerStringEXT _QueryOutputLayerStringEXT;
    private PFN_eglOutputPortAttribEXT _OutputPortAttribEXT;
    private PFN_eglQueryOutputPortAttribEXT _QueryOutputPortAttribEXT;
    private PFN_eglQueryOutputPortStringEXT _QueryOutputPortStringEXT;

    // EGL_EXT_platform_base,
    private PFN_eglGetPlatformDisplayEXT _GetPlatformDisplayEXT;
    private PFN_eglCreatePlatformWindowSurfaceEXT _CreatePlatformWindowSurfaceEXT;
    private PFN_eglCreatePlatformPixmapSurfaceEXT _CreatePlatformPixmapSurfaceEXT;

    // EGL_EXT_stream_consumer_egloutput,
    private PFN_eglStreamConsumerOutputEXT _StreamConsumerOutputEXT;

    // EGL_EXT_swap_buffers_with_damage,
    private PFN_eglSwapBuffersWithDamageEXT _SwapBuffersWithDamageEXT;

    // EGL_HI_clientpixmap,
    private PFN_eglCreatePixmapSurfaceHI _CreatePixmapSurfaceHI;

    // EGL_MESA_drm_image,
    private PFN_eglCreateDRMImageMESA _CreateDRMImageMESA;
    private PFN_eglExportDRMImageMESA _ExportDRMImageMESA;

    // EGL_MESA_image_dma_buf_export,
    private PFN_eglExportDMABUFImageQueryMESA _ExportDMABUFImageQueryMESA;
    private PFN_eglExportDMABUFImageMESA _ExportDMABUFImageMESA;

    // EGL_NOK_swap_region,
    private PFN_eglSwapBuffersRegionNOK _SwapBuffersRegionNOK;

    // EGL_NOK_swap_region2,
    private PFN_eglSwapBuffersRegion2NOK _SwapBuffersRegion2NOK;

    // EGL_NV_native_query,
    private PFN_eglQueryNativeDisplayNV _QueryNativeDisplayNV;
    private PFN_eglQueryNativeWindowNV _QueryNativeWindowNV;
    private PFN_eglQueryNativePixmapNV _QueryNativePixmapNV;

    // EGL_NV_post_sub_buffer,
    private PFN_eglPostSubBufferNV _PostSubBufferNV;

    // EGL_NV_stream_consumer_gltexture_yuv,
    private PFN_eglStreamConsumerGLTextureExternalAttribsNV _StreamConsumerGLTextureExternalAttribsNV;

    // EGL_NV_stream_metadata,
    private PFN_eglQueryDisplayAttribNV _QueryDisplayAttribNV;
    private PFN_eglSetStreamMetadataNV _SetStreamMetadataNV;
    private PFN_eglQueryStreamMetadataNV _QueryStreamMetadataNV;

    // EGL_NV_stream_reset,
    private PFN_eglResetStreamNV _ResetStreamNV;

    // EGL_NV_stream_sync,
    private PFN_eglCreateStreamSyncNV _CreateStreamSyncNV;

    // EGL_NV_sync,
    private PFN_eglCreateFenceSyncNV _CreateFenceSyncNV;
    private PFN_eglDestroySyncNV _DestroySyncNV;
    private PFN_eglFenceNV _FenceNV;
    private PFN_eglClientWaitSyncNV _ClientWaitSyncNV;
    private PFN_eglSignalSyncNV _SignalSyncNV;
    private PFN_eglGetSyncAttribNV _GetSyncAttribNV;

    // EGL_NV_system_time,
    private PFN_eglGetSystemTimeFrequencyNV _GetSystemTimeFrequencyNV;
    private PFN_eglGetSystemTimeNV _GetSystemTimeNV;
}
