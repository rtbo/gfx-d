/// GLX bindings for D. Generated automatically by gldgen.
/// See https://github.com/rtbo/gldgen
module gfx.bindings.opengl.glx;

version(linux):

import core.stdc.config;
import core.stdc.stdint;
import gfx.bindings.opengl.loader : SymbolLoader;
import gfx.bindings.opengl.gl;
import X11.Xlib;

// Base Types

// Types for GLX_VERSION_1_0
alias GLXContext  = __GLXcontextRec*;
alias GLXDrawable = XID;
alias GLXPixmap   = XID;

// Types for GLX_VERSION_1_3
alias GLXContextID = XID;
alias GLXFBConfig  = __GLXFBConfigRec*;
alias GLXWindow    = XID;
alias GLXPbuffer   = XID;

// Types for GLX_NV_video_capture
alias GLXVideoCaptureDeviceNV = XID;

// Types for GLX_NV_video_out
alias GLXVideoDeviceNV = uint;

// Types for GLX_SGIX_fbconfig
alias GLXFBConfigSGIX = __GLXFBConfigRec*;

// Types for GLX_SGIX_pbuffer
alias GLXPbufferSGIX = XID;

// Struct declarations
struct __GLXcontextRec;
struct __GLXFBConfigRec;

// Struct definitions
// Structs for GLX_EXT_stereo_tree
struct GLXStereoNotifyEventEXT {
    int type;
    c_ulong serial;
    Bool send_event;
    Display * display;
    int extension;
    int evtype;
    GLXDrawable window;
    Bool stereo_tree;
}
// Structs for GLX_SGIX_hyperpipe
struct GLXHyperpipeNetworkSGIX {
    char[80] pipeName;
    int networkId;
}
struct GLXHyperpipeConfigSGIX {
    char[80] pipeName;
    int channel;
    uint participationType;
    int timeSlice;
}
struct GLXPipeRect {
    char[80] pipeName;
    int srcXOrigin;
    int srcYOrigin;
    int srcWidth;
    int srcHeight;
    int destXOrigin;
    int destYOrigin;
    int destWidth;
    int destHeight;
}
struct GLXPipeRectLimits {
    char[80] pipeName;
    int XOrigin;
    int YOrigin;
    int maxHeight;
    int maxWidth;
}

// Function pointers

extern(C) nothrow @nogc {

    // for GLX_VERSION_1_4
    alias __GLXextFuncPtr = void function();
}


// Constants for GLX_VERSION_1_0
enum GLX_EXTENSION_NAME     = "GLX";
enum GLX_PbufferClobber     = 0;
enum GLX_BufferSwapComplete = 1;
enum __GLX_NUMBER_EVENTS    = 17;
enum GLX_BAD_SCREEN         = 1;
enum GLX_BAD_ATTRIBUTE      = 2;
enum GLX_NO_EXTENSION       = 3;
enum GLX_BAD_VISUAL         = 4;
enum GLX_BAD_CONTEXT        = 5;
enum GLX_BAD_VALUE          = 6;
enum GLX_BAD_ENUM           = 7;
enum GLX_USE_GL             = 1;
enum GLX_BUFFER_SIZE        = 2;
enum GLX_LEVEL              = 3;
enum GLX_RGBA               = 4;
enum GLX_DOUBLEBUFFER       = 5;
enum GLX_STEREO             = 6;
enum GLX_AUX_BUFFERS        = 7;
enum GLX_RED_SIZE           = 8;
enum GLX_GREEN_SIZE         = 9;
enum GLX_BLUE_SIZE          = 10;
enum GLX_ALPHA_SIZE         = 11;
enum GLX_DEPTH_SIZE         = 12;
enum GLX_STENCIL_SIZE       = 13;
enum GLX_ACCUM_RED_SIZE     = 14;
enum GLX_ACCUM_GREEN_SIZE   = 15;
enum GLX_ACCUM_BLUE_SIZE    = 16;
enum GLX_ACCUM_ALPHA_SIZE   = 17;

// Constants for GLX_VERSION_1_1
enum GLX_VENDOR     = 0x1;
enum GLX_VERSION    = 0x2;
enum GLX_EXTENSIONS = 0x3;

// Constants for GLX_VERSION_1_3
enum GLX_WINDOW_BIT              = 0x00000001;
enum GLX_PIXMAP_BIT              = 0x00000002;
enum GLX_PBUFFER_BIT             = 0x00000004;
enum GLX_RGBA_BIT                = 0x00000001;
enum GLX_COLOR_INDEX_BIT         = 0x00000002;
enum GLX_PBUFFER_CLOBBER_MASK    = 0x08000000;
enum GLX_FRONT_LEFT_BUFFER_BIT   = 0x00000001;
enum GLX_FRONT_RIGHT_BUFFER_BIT  = 0x00000002;
enum GLX_BACK_LEFT_BUFFER_BIT    = 0x00000004;
enum GLX_BACK_RIGHT_BUFFER_BIT   = 0x00000008;
enum GLX_AUX_BUFFERS_BIT         = 0x00000010;
enum GLX_DEPTH_BUFFER_BIT        = 0x00000020;
enum GLX_STENCIL_BUFFER_BIT      = 0x00000040;
enum GLX_ACCUM_BUFFER_BIT        = 0x00000080;
enum GLX_CONFIG_CAVEAT           = 0x20;
enum GLX_X_VISUAL_TYPE           = 0x22;
enum GLX_TRANSPARENT_TYPE        = 0x23;
enum GLX_TRANSPARENT_INDEX_VALUE = 0x24;
enum GLX_TRANSPARENT_RED_VALUE   = 0x25;
enum GLX_TRANSPARENT_GREEN_VALUE = 0x26;
enum GLX_TRANSPARENT_BLUE_VALUE  = 0x27;
enum GLX_TRANSPARENT_ALPHA_VALUE = 0x28;
enum GLX_DONT_CARE               = 0xFFFFFFFF;
enum GLX_NONE                    = 0x8000;
enum GLX_SLOW_CONFIG             = 0x8001;
enum GLX_TRUE_COLOR              = 0x8002;
enum GLX_DIRECT_COLOR            = 0x8003;
enum GLX_PSEUDO_COLOR            = 0x8004;
enum GLX_STATIC_COLOR            = 0x8005;
enum GLX_GRAY_SCALE              = 0x8006;
enum GLX_STATIC_GRAY             = 0x8007;
enum GLX_TRANSPARENT_RGB         = 0x8008;
enum GLX_TRANSPARENT_INDEX       = 0x8009;
enum GLX_VISUAL_ID               = 0x800B;
enum GLX_SCREEN                  = 0x800C;
enum GLX_NON_CONFORMANT_CONFIG   = 0x800D;
enum GLX_DRAWABLE_TYPE           = 0x8010;
enum GLX_RENDER_TYPE             = 0x8011;
enum GLX_X_RENDERABLE            = 0x8012;
enum GLX_FBCONFIG_ID             = 0x8013;
enum GLX_RGBA_TYPE               = 0x8014;
enum GLX_COLOR_INDEX_TYPE        = 0x8015;
enum GLX_MAX_PBUFFER_WIDTH       = 0x8016;
enum GLX_MAX_PBUFFER_HEIGHT      = 0x8017;
enum GLX_MAX_PBUFFER_PIXELS      = 0x8018;
enum GLX_PRESERVED_CONTENTS      = 0x801B;
enum GLX_LARGEST_PBUFFER         = 0x801C;
enum GLX_WIDTH                   = 0x801D;
enum GLX_HEIGHT                  = 0x801E;
enum GLX_EVENT_MASK              = 0x801F;
enum GLX_DAMAGED                 = 0x8020;
enum GLX_SAVED                   = 0x8021;
enum GLX_WINDOW                  = 0x8022;
enum GLX_PBUFFER                 = 0x8023;
enum GLX_PBUFFER_HEIGHT          = 0x8040;
enum GLX_PBUFFER_WIDTH           = 0x8041;

// Constants for GLX_VERSION_1_4
enum GLX_SAMPLE_BUFFERS = 100000;
enum GLX_SAMPLES        = 100001;

// Constants for GLX_ARB_context_flush_control
enum GLX_CONTEXT_RELEASE_BEHAVIOR_ARB       = 0x2097;
enum GLX_CONTEXT_RELEASE_BEHAVIOR_NONE_ARB  = 0;
enum GLX_CONTEXT_RELEASE_BEHAVIOR_FLUSH_ARB = 0x2098;

// Constants for GLX_ARB_create_context
enum GLX_CONTEXT_DEBUG_BIT_ARB              = 0x00000001;
enum GLX_CONTEXT_FORWARD_COMPATIBLE_BIT_ARB = 0x00000002;
enum GLX_CONTEXT_MAJOR_VERSION_ARB          = 0x2091;
enum GLX_CONTEXT_MINOR_VERSION_ARB          = 0x2092;
enum GLX_CONTEXT_FLAGS_ARB                  = 0x2094;

// Constants for GLX_ARB_create_context_no_error
enum GLX_CONTEXT_OPENGL_NO_ERROR_ARB = 0x31B3;

// Constants for GLX_ARB_create_context_profile
enum GLX_CONTEXT_CORE_PROFILE_BIT_ARB          = 0x00000001;
enum GLX_CONTEXT_COMPATIBILITY_PROFILE_BIT_ARB = 0x00000002;
enum GLX_CONTEXT_PROFILE_MASK_ARB              = 0x9126;

// Constants for GLX_ARB_create_context_robustness
enum GLX_CONTEXT_ROBUST_ACCESS_BIT_ARB           = 0x00000004;
enum GLX_LOSE_CONTEXT_ON_RESET_ARB               = 0x8252;
enum GLX_CONTEXT_RESET_NOTIFICATION_STRATEGY_ARB = 0x8256;
enum GLX_NO_RESET_NOTIFICATION_ARB               = 0x8261;

// Constants for GLX_ARB_fbconfig_float
enum GLX_RGBA_FLOAT_TYPE_ARB = 0x20B9;
enum GLX_RGBA_FLOAT_BIT_ARB  = 0x00000004;

// Constants for GLX_ARB_framebuffer_sRGB
enum GLX_FRAMEBUFFER_SRGB_CAPABLE_ARB = 0x20B2;

// Constants for GLX_ARB_multisample
enum GLX_SAMPLE_BUFFERS_ARB = 100000;
enum GLX_SAMPLES_ARB        = 100001;

// Constants for GLX_ARB_robustness_application_isolation
enum GLX_CONTEXT_RESET_ISOLATION_BIT_ARB = 0x00000008;

// Constants for GLX_ARB_vertex_buffer_object
enum GLX_CONTEXT_ALLOW_BUFFER_BYTE_ORDER_MISMATCH_ARB = 0x2095;

// Constants for GLX_3DFX_multisample
enum GLX_SAMPLE_BUFFERS_3DFX = 0x8050;
enum GLX_SAMPLES_3DFX        = 0x8051;

// Constants for GLX_AMD_gpu_association
enum GLX_GPU_VENDOR_AMD                = 0x1F00;
enum GLX_GPU_RENDERER_STRING_AMD       = 0x1F01;
enum GLX_GPU_OPENGL_VERSION_STRING_AMD = 0x1F02;
enum GLX_GPU_FASTEST_TARGET_GPUS_AMD   = 0x21A2;
enum GLX_GPU_RAM_AMD                   = 0x21A3;
enum GLX_GPU_CLOCK_AMD                 = 0x21A4;
enum GLX_GPU_NUM_PIPES_AMD             = 0x21A5;
enum GLX_GPU_NUM_SIMD_AMD              = 0x21A6;
enum GLX_GPU_NUM_RB_AMD                = 0x21A7;
enum GLX_GPU_NUM_SPI_AMD               = 0x21A8;

// Constants for GLX_EXT_buffer_age
enum GLX_BACK_BUFFER_AGE_EXT = 0x20F4;

// Constants for GLX_EXT_create_context_es2_profile
enum GLX_CONTEXT_ES2_PROFILE_BIT_EXT = 0x00000004;

// Constants for GLX_EXT_create_context_es_profile
enum GLX_CONTEXT_ES_PROFILE_BIT_EXT = 0x00000004;

// Constants for GLX_EXT_fbconfig_packed_float
enum GLX_RGBA_UNSIGNED_FLOAT_TYPE_EXT = 0x20B1;
enum GLX_RGBA_UNSIGNED_FLOAT_BIT_EXT  = 0x00000008;

// Constants for GLX_EXT_framebuffer_sRGB
enum GLX_FRAMEBUFFER_SRGB_CAPABLE_EXT = 0x20B2;

// Constants for GLX_EXT_import_context
enum GLX_SHARE_CONTEXT_EXT = 0x800A;
enum GLX_VISUAL_ID_EXT     = 0x800B;
enum GLX_SCREEN_EXT        = 0x800C;

// Constants for GLX_EXT_libglvnd
enum GLX_VENDOR_NAMES_EXT = 0x20F6;

// Constants for GLX_EXT_stereo_tree
enum GLX_STEREO_TREE_EXT        = 0x20F5;
enum GLX_STEREO_NOTIFY_MASK_EXT = 0x00000001;
enum GLX_STEREO_NOTIFY_EXT      = 0x00000000;

// Constants for GLX_EXT_swap_control
enum GLX_SWAP_INTERVAL_EXT     = 0x20F1;
enum GLX_MAX_SWAP_INTERVAL_EXT = 0x20F2;

// Constants for GLX_EXT_swap_control_tear
enum GLX_LATE_SWAPS_TEAR_EXT = 0x20F3;

// Constants for GLX_EXT_texture_from_pixmap
enum GLX_TEXTURE_1D_BIT_EXT          = 0x00000001;
enum GLX_TEXTURE_2D_BIT_EXT          = 0x00000002;
enum GLX_TEXTURE_RECTANGLE_BIT_EXT   = 0x00000004;
enum GLX_BIND_TO_TEXTURE_RGB_EXT     = 0x20D0;
enum GLX_BIND_TO_TEXTURE_RGBA_EXT    = 0x20D1;
enum GLX_BIND_TO_MIPMAP_TEXTURE_EXT  = 0x20D2;
enum GLX_BIND_TO_TEXTURE_TARGETS_EXT = 0x20D3;
enum GLX_Y_INVERTED_EXT              = 0x20D4;
enum GLX_TEXTURE_FORMAT_EXT          = 0x20D5;
enum GLX_TEXTURE_TARGET_EXT          = 0x20D6;
enum GLX_MIPMAP_TEXTURE_EXT          = 0x20D7;
enum GLX_TEXTURE_FORMAT_NONE_EXT     = 0x20D8;
enum GLX_TEXTURE_FORMAT_RGB_EXT      = 0x20D9;
enum GLX_TEXTURE_FORMAT_RGBA_EXT     = 0x20DA;
enum GLX_TEXTURE_1D_EXT              = 0x20DB;
enum GLX_TEXTURE_2D_EXT              = 0x20DC;
enum GLX_TEXTURE_RECTANGLE_EXT       = 0x20DD;
enum GLX_FRONT_LEFT_EXT              = 0x20DE;
enum GLX_FRONT_RIGHT_EXT             = 0x20DF;
enum GLX_BACK_LEFT_EXT               = 0x20E0;
enum GLX_BACK_RIGHT_EXT              = 0x20E1;
enum GLX_FRONT_EXT                   = 0x20DE;
enum GLX_BACK_EXT                    = 0x20E0;
enum GLX_AUX0_EXT                    = 0x20E2;
enum GLX_AUX1_EXT                    = 0x20E3;
enum GLX_AUX2_EXT                    = 0x20E4;
enum GLX_AUX3_EXT                    = 0x20E5;
enum GLX_AUX4_EXT                    = 0x20E6;
enum GLX_AUX5_EXT                    = 0x20E7;
enum GLX_AUX6_EXT                    = 0x20E8;
enum GLX_AUX7_EXT                    = 0x20E9;
enum GLX_AUX8_EXT                    = 0x20EA;
enum GLX_AUX9_EXT                    = 0x20EB;

// Constants for GLX_EXT_visual_info
enum GLX_X_VISUAL_TYPE_EXT           = 0x22;
enum GLX_TRANSPARENT_TYPE_EXT        = 0x23;
enum GLX_TRANSPARENT_INDEX_VALUE_EXT = 0x24;
enum GLX_TRANSPARENT_RED_VALUE_EXT   = 0x25;
enum GLX_TRANSPARENT_GREEN_VALUE_EXT = 0x26;
enum GLX_TRANSPARENT_BLUE_VALUE_EXT  = 0x27;
enum GLX_TRANSPARENT_ALPHA_VALUE_EXT = 0x28;
enum GLX_NONE_EXT                    = 0x8000;
enum GLX_TRUE_COLOR_EXT              = 0x8002;
enum GLX_DIRECT_COLOR_EXT            = 0x8003;
enum GLX_PSEUDO_COLOR_EXT            = 0x8004;
enum GLX_STATIC_COLOR_EXT            = 0x8005;
enum GLX_GRAY_SCALE_EXT              = 0x8006;
enum GLX_STATIC_GRAY_EXT             = 0x8007;
enum GLX_TRANSPARENT_RGB_EXT         = 0x8008;
enum GLX_TRANSPARENT_INDEX_EXT       = 0x8009;

// Constants for GLX_EXT_visual_rating
enum GLX_VISUAL_CAVEAT_EXT         = 0x20;
enum GLX_SLOW_VISUAL_EXT           = 0x8001;
enum GLX_NON_CONFORMANT_VISUAL_EXT = 0x800D;

// Constants for GLX_INTEL_swap_event
enum GLX_BUFFER_SWAP_COMPLETE_INTEL_MASK = 0x04000000;
enum GLX_EXCHANGE_COMPLETE_INTEL         = 0x8180;
enum GLX_COPY_COMPLETE_INTEL             = 0x8181;
enum GLX_FLIP_COMPLETE_INTEL             = 0x8182;

// Constants for GLX_MESA_query_renderer
enum GLX_RENDERER_VENDOR_ID_MESA                            = 0x8183;
enum GLX_RENDERER_DEVICE_ID_MESA                            = 0x8184;
enum GLX_RENDERER_VERSION_MESA                              = 0x8185;
enum GLX_RENDERER_ACCELERATED_MESA                          = 0x8186;
enum GLX_RENDERER_VIDEO_MEMORY_MESA                         = 0x8187;
enum GLX_RENDERER_UNIFIED_MEMORY_ARCHITECTURE_MESA          = 0x8188;
enum GLX_RENDERER_PREFERRED_PROFILE_MESA                    = 0x8189;
enum GLX_RENDERER_OPENGL_CORE_PROFILE_VERSION_MESA          = 0x818A;
enum GLX_RENDERER_OPENGL_COMPATIBILITY_PROFILE_VERSION_MESA = 0x818B;
enum GLX_RENDERER_OPENGL_ES_PROFILE_VERSION_MESA            = 0x818C;
enum GLX_RENDERER_OPENGL_ES2_PROFILE_VERSION_MESA           = 0x818D;

// Constants for GLX_MESA_set_3dfx_mode
enum GLX_3DFX_WINDOW_MODE_MESA     = 0x1;
enum GLX_3DFX_FULLSCREEN_MODE_MESA = 0x2;

// Constants for GLX_NV_float_buffer
enum GLX_FLOAT_COMPONENTS_NV = 0x20B0;

// Constants for GLX_NV_multisample_coverage
enum GLX_COVERAGE_SAMPLES_NV = 100001;
enum GLX_COLOR_SAMPLES_NV    = 0x20B3;

// Constants for GLX_NV_present_video
enum GLX_NUM_VIDEO_SLOTS_NV = 0x20F0;

// Constants for GLX_NV_robustness_video_memory_purge
enum GLX_GENERATE_RESET_ON_VIDEO_MEMORY_PURGE_NV = 0x20F7;

// Constants for GLX_NV_video_capture
enum GLX_DEVICE_ID_NV               = 0x20CD;
enum GLX_UNIQUE_ID_NV               = 0x20CE;
enum GLX_NUM_VIDEO_CAPTURE_SLOTS_NV = 0x20CF;

// Constants for GLX_NV_video_out
enum GLX_VIDEO_OUT_COLOR_NV              = 0x20C3;
enum GLX_VIDEO_OUT_ALPHA_NV              = 0x20C4;
enum GLX_VIDEO_OUT_DEPTH_NV              = 0x20C5;
enum GLX_VIDEO_OUT_COLOR_AND_ALPHA_NV    = 0x20C6;
enum GLX_VIDEO_OUT_COLOR_AND_DEPTH_NV    = 0x20C7;
enum GLX_VIDEO_OUT_FRAME_NV              = 0x20C8;
enum GLX_VIDEO_OUT_FIELD_1_NV            = 0x20C9;
enum GLX_VIDEO_OUT_FIELD_2_NV            = 0x20CA;
enum GLX_VIDEO_OUT_STACKED_FIELDS_1_2_NV = 0x20CB;
enum GLX_VIDEO_OUT_STACKED_FIELDS_2_1_NV = 0x20CC;

// Constants for GLX_OML_swap_method
enum GLX_SWAP_METHOD_OML    = 0x8060;
enum GLX_SWAP_EXCHANGE_OML  = 0x8061;
enum GLX_SWAP_COPY_OML      = 0x8062;
enum GLX_SWAP_UNDEFINED_OML = 0x8063;

// Constants for GLX_SGIS_blended_overlay
enum GLX_BLENDED_RGBA_SGIS = 0x8025;

// Constants for GLX_SGIS_multisample
enum GLX_SAMPLE_BUFFERS_SGIS = 100000;
enum GLX_SAMPLES_SGIS        = 100001;

// Constants for GLX_SGIS_shared_multisample
enum GLX_MULTISAMPLE_SUB_RECT_WIDTH_SGIS  = 0x8026;
enum GLX_MULTISAMPLE_SUB_RECT_HEIGHT_SGIS = 0x8027;

// Constants for GLX_SGIX_fbconfig
enum GLX_WINDOW_BIT_SGIX       = 0x00000001;
enum GLX_PIXMAP_BIT_SGIX       = 0x00000002;
enum GLX_RGBA_BIT_SGIX         = 0x00000001;
enum GLX_COLOR_INDEX_BIT_SGIX  = 0x00000002;
enum GLX_DRAWABLE_TYPE_SGIX    = 0x8010;
enum GLX_RENDER_TYPE_SGIX      = 0x8011;
enum GLX_X_RENDERABLE_SGIX     = 0x8012;
enum GLX_FBCONFIG_ID_SGIX      = 0x8013;
enum GLX_RGBA_TYPE_SGIX        = 0x8014;
enum GLX_COLOR_INDEX_TYPE_SGIX = 0x8015;

// Constants for GLX_SGIX_hyperpipe
enum GLX_HYPERPIPE_PIPE_NAME_LENGTH_SGIX = 80;
enum GLX_BAD_HYPERPIPE_CONFIG_SGIX       = 91;
enum GLX_BAD_HYPERPIPE_SGIX              = 92;
enum GLX_HYPERPIPE_DISPLAY_PIPE_SGIX     = 0x00000001;
enum GLX_HYPERPIPE_RENDER_PIPE_SGIX      = 0x00000002;
enum GLX_PIPE_RECT_SGIX                  = 0x00000001;
enum GLX_PIPE_RECT_LIMITS_SGIX           = 0x00000002;
enum GLX_HYPERPIPE_STEREO_SGIX           = 0x00000003;
enum GLX_HYPERPIPE_PIXEL_AVERAGE_SGIX    = 0x00000004;
enum GLX_HYPERPIPE_ID_SGIX               = 0x8030;

// Constants for GLX_SGIX_pbuffer
enum GLX_PBUFFER_BIT_SGIX            = 0x00000004;
enum GLX_BUFFER_CLOBBER_MASK_SGIX    = 0x08000000;
enum GLX_FRONT_LEFT_BUFFER_BIT_SGIX  = 0x00000001;
enum GLX_FRONT_RIGHT_BUFFER_BIT_SGIX = 0x00000002;
enum GLX_BACK_LEFT_BUFFER_BIT_SGIX   = 0x00000004;
enum GLX_BACK_RIGHT_BUFFER_BIT_SGIX  = 0x00000008;
enum GLX_AUX_BUFFERS_BIT_SGIX        = 0x00000010;
enum GLX_DEPTH_BUFFER_BIT_SGIX       = 0x00000020;
enum GLX_STENCIL_BUFFER_BIT_SGIX     = 0x00000040;
enum GLX_ACCUM_BUFFER_BIT_SGIX       = 0x00000080;
enum GLX_SAMPLE_BUFFERS_BIT_SGIX     = 0x00000100;
enum GLX_MAX_PBUFFER_WIDTH_SGIX      = 0x8016;
enum GLX_MAX_PBUFFER_HEIGHT_SGIX     = 0x8017;
enum GLX_MAX_PBUFFER_PIXELS_SGIX     = 0x8018;
enum GLX_OPTIMAL_PBUFFER_WIDTH_SGIX  = 0x8019;
enum GLX_OPTIMAL_PBUFFER_HEIGHT_SGIX = 0x801A;
enum GLX_PRESERVED_CONTENTS_SGIX     = 0x801B;
enum GLX_LARGEST_PBUFFER_SGIX        = 0x801C;
enum GLX_WIDTH_SGIX                  = 0x801D;
enum GLX_HEIGHT_SGIX                 = 0x801E;
enum GLX_EVENT_MASK_SGIX             = 0x801F;
enum GLX_DAMAGED_SGIX                = 0x8020;
enum GLX_SAVED_SGIX                  = 0x8021;
enum GLX_WINDOW_SGIX                 = 0x8022;
enum GLX_PBUFFER_SGIX                = 0x8023;

// Constants for GLX_SGIX_video_resize
enum GLX_SYNC_FRAME_SGIX = 0x00000000;
enum GLX_SYNC_SWAP_SGIX  = 0x00000001;

// Constants for GLX_SGIX_visual_select_group
enum GLX_VISUAL_SELECT_GROUP_SGIX = 0x8028;

// Command pointer aliases

extern(C) nothrow @nogc {

    // Command pointers for GLX_VERSION_1_0
    alias PFN_glXChooseVisual = XVisualInfo * function (
        Display* dpy,
        int      screen,
        int*     attribList,
    );
    alias PFN_glXCreateContext = GLXContext function (
        Display*     dpy,
        XVisualInfo* vis,
        GLXContext   shareList,
        Bool         direct,
    );
    alias PFN_glXDestroyContext = void function (
        Display*   dpy,
        GLXContext ctx,
    );
    alias PFN_glXMakeCurrent = Bool function (
        Display*    dpy,
        GLXDrawable drawable,
        GLXContext  ctx,
    );
    alias PFN_glXCopyContext = void function (
        Display*   dpy,
        GLXContext src,
        GLXContext dst,
        c_ulong    mask,
    );
    alias PFN_glXSwapBuffers = void function (
        Display*    dpy,
        GLXDrawable drawable,
    );
    alias PFN_glXCreateGLXPixmap = GLXPixmap function (
        Display*     dpy,
        XVisualInfo* visual,
        Pixmap       pixmap,
    );
    alias PFN_glXDestroyGLXPixmap = void function (
        Display*  dpy,
        GLXPixmap pixmap,
    );
    alias PFN_glXQueryExtension = Bool function (
        Display* dpy,
        int*     errorb,
        int*     event,
    );
    alias PFN_glXQueryVersion = Bool function (
        Display* dpy,
        int*     maj,
        int*     min,
    );
    alias PFN_glXIsDirect = Bool function (
        Display*   dpy,
        GLXContext ctx,
    );
    alias PFN_glXGetConfig = int function (
        Display*     dpy,
        XVisualInfo* visual,
        int          attrib,
        int*         value,
    );
    alias PFN_glXGetCurrentContext = GLXContext function ();
    alias PFN_glXGetCurrentDrawable = GLXDrawable function ();
    alias PFN_glXWaitGL = void function ();
    alias PFN_glXWaitX = void function ();
    alias PFN_glXUseXFont = void function (
        Font font,
        int  first,
        int  count,
        int  list,
    );

    // Command pointers for GLX_VERSION_1_1
    alias PFN_glXQueryExtensionsString = const(char)* function (
        Display* dpy,
        int      screen,
    );
    alias PFN_glXQueryServerString = const(char)* function (
        Display* dpy,
        int      screen,
        int      name,
    );
    alias PFN_glXGetClientString = const(char)* function (
        Display* dpy,
        int      name,
    );

    // Command pointers for GLX_VERSION_1_2
    alias PFN_glXGetCurrentDisplay = Display * function ();

    // Command pointers for GLX_VERSION_1_3
    alias PFN_glXGetFBConfigs = GLXFBConfig * function (
        Display* dpy,
        int      screen,
        int*     nelements,
    );
    alias PFN_glXChooseFBConfig = GLXFBConfig * function (
        Display*    dpy,
        int         screen,
        const(int)* attrib_list,
        int*        nelements,
    );
    alias PFN_glXGetFBConfigAttrib = int function (
        Display*    dpy,
        GLXFBConfig config,
        int         attribute,
        int*        value,
    );
    alias PFN_glXGetVisualFromFBConfig = XVisualInfo * function (
        Display*    dpy,
        GLXFBConfig config,
    );
    alias PFN_glXCreateWindow = GLXWindow function (
        Display*    dpy,
        GLXFBConfig config,
        Window      win,
        const(int)* attrib_list,
    );
    alias PFN_glXDestroyWindow = void function (
        Display*  dpy,
        GLXWindow win,
    );
    alias PFN_glXCreatePixmap = GLXPixmap function (
        Display*    dpy,
        GLXFBConfig config,
        Pixmap      pixmap,
        const(int)* attrib_list,
    );
    alias PFN_glXDestroyPixmap = void function (
        Display*  dpy,
        GLXPixmap pixmap,
    );
    alias PFN_glXCreatePbuffer = GLXPbuffer function (
        Display*    dpy,
        GLXFBConfig config,
        const(int)* attrib_list,
    );
    alias PFN_glXDestroyPbuffer = void function (
        Display*   dpy,
        GLXPbuffer pbuf,
    );
    alias PFN_glXQueryDrawable = void function (
        Display*    dpy,
        GLXDrawable draw,
        int         attribute,
        uint*       value,
    );
    alias PFN_glXCreateNewContext = GLXContext function (
        Display*    dpy,
        GLXFBConfig config,
        int         render_type,
        GLXContext  share_list,
        Bool        direct,
    );
    alias PFN_glXMakeContextCurrent = Bool function (
        Display*    dpy,
        GLXDrawable draw,
        GLXDrawable read,
        GLXContext  ctx,
    );
    alias PFN_glXGetCurrentReadDrawable = GLXDrawable function ();
    alias PFN_glXQueryContext = int function (
        Display*   dpy,
        GLXContext ctx,
        int        attribute,
        int*       value,
    );
    alias PFN_glXSelectEvent = void function (
        Display*    dpy,
        GLXDrawable draw,
        c_ulong     event_mask,
    );
    alias PFN_glXGetSelectedEvent = void function (
        Display*    dpy,
        GLXDrawable draw,
        c_ulong*    event_mask,
    );

    // Command pointers for GLX_VERSION_1_4
    alias PFN_glXGetProcAddress = __GLXextFuncPtr function (
        const(GLubyte)* procName,
    );

    // Command pointers for GLX_ARB_create_context
    alias PFN_glXCreateContextAttribsARB = GLXContext function (
        Display*    dpy,
        GLXFBConfig config,
        GLXContext  share_context,
        Bool        direct,
        const(int)* attrib_list,
    );

    // Command pointers for GLX_ARB_get_proc_address
    alias PFN_glXGetProcAddressARB = __GLXextFuncPtr function (
        const(GLubyte)* procName,
    );

    // Command pointers for GLX_AMD_gpu_association
    alias PFN_glXGetGPUIDsAMD = uint function (
        uint  maxCount,
        uint* ids,
    );
    alias PFN_glXGetGPUInfoAMD = int function (
        uint   id,
        int    property,
        GLenum dataType,
        uint   size,
        void*  data,
    );
    alias PFN_glXGetContextGPUIDAMD = uint function (
        GLXContext ctx,
    );
    alias PFN_glXCreateAssociatedContextAMD = GLXContext function (
        uint       id,
        GLXContext share_list,
    );
    alias PFN_glXCreateAssociatedContextAttribsAMD = GLXContext function (
        uint        id,
        GLXContext  share_context,
        const(int)* attribList,
    );
    alias PFN_glXDeleteAssociatedContextAMD = Bool function (
        GLXContext ctx,
    );
    alias PFN_glXMakeAssociatedContextCurrentAMD = Bool function (
        GLXContext ctx,
    );
    alias PFN_glXGetCurrentAssociatedContextAMD = GLXContext function ();
    alias PFN_glXBlitContextFramebufferAMD = void function (
        GLXContext dstCtx,
        GLint      srcX0,
        GLint      srcY0,
        GLint      srcX1,
        GLint      srcY1,
        GLint      dstX0,
        GLint      dstY0,
        GLint      dstX1,
        GLint      dstY1,
        GLbitfield mask,
        GLenum     filter,
    );

    // Command pointers for GLX_EXT_import_context
    alias PFN_glXGetCurrentDisplayEXT = Display * function ();
    alias PFN_glXQueryContextInfoEXT = int function (
        Display*   dpy,
        GLXContext context,
        int        attribute,
        int*       value,
    );
    alias PFN_glXGetContextIDEXT = GLXContextID function (
        const GLXContext context,
    );
    alias PFN_glXImportContextEXT = GLXContext function (
        Display*     dpy,
        GLXContextID contextID,
    );
    alias PFN_glXFreeContextEXT = void function (
        Display*   dpy,
        GLXContext context,
    );

    // Command pointers for GLX_EXT_swap_control
    alias PFN_glXSwapIntervalEXT = void function (
        Display*    dpy,
        GLXDrawable drawable,
        int         interval,
    );

    // Command pointers for GLX_EXT_texture_from_pixmap
    alias PFN_glXBindTexImageEXT = void function (
        Display*    dpy,
        GLXDrawable drawable,
        int         buffer,
        const(int)* attrib_list,
    );
    alias PFN_glXReleaseTexImageEXT = void function (
        Display*    dpy,
        GLXDrawable drawable,
        int         buffer,
    );

    // Command pointers for GLX_MESA_agp_offset
    alias PFN_glXGetAGPOffsetMESA = uint function (
        const(void)* pointer,
    );

    // Command pointers for GLX_MESA_copy_sub_buffer
    alias PFN_glXCopySubBufferMESA = void function (
        Display*    dpy,
        GLXDrawable drawable,
        int         x,
        int         y,
        int         width,
        int         height,
    );

    // Command pointers for GLX_MESA_pixmap_colormap
    alias PFN_glXCreateGLXPixmapMESA = GLXPixmap function (
        Display*     dpy,
        XVisualInfo* visual,
        Pixmap       pixmap,
        Colormap     cmap,
    );

    // Command pointers for GLX_MESA_query_renderer
    alias PFN_glXQueryCurrentRendererIntegerMESA = Bool function (
        int   attribute,
        uint* value,
    );
    alias PFN_glXQueryCurrentRendererStringMESA = const(char)* function (
        int attribute,
    );
    alias PFN_glXQueryRendererIntegerMESA = Bool function (
        Display* dpy,
        int      screen,
        int      renderer,
        int      attribute,
        uint*    value,
    );
    alias PFN_glXQueryRendererStringMESA = const(char)* function (
        Display* dpy,
        int      screen,
        int      renderer,
        int      attribute,
    );

    // Command pointers for GLX_MESA_release_buffers
    alias PFN_glXReleaseBuffersMESA = Bool function (
        Display*    dpy,
        GLXDrawable drawable,
    );

    // Command pointers for GLX_MESA_set_3dfx_mode
    alias PFN_glXSet3DfxModeMESA = Bool function (
        int mode,
    );

    // Command pointers for GLX_MESA_swap_control
    alias PFN_glXGetSwapIntervalMESA = int function ();
    alias PFN_glXSwapIntervalMESA = int function (
        uint interval,
    );

    // Command pointers for GLX_NV_copy_buffer
    alias PFN_glXCopyBufferSubDataNV = void function (
        Display*   dpy,
        GLXContext readCtx,
        GLXContext writeCtx,
        GLenum     readTarget,
        GLenum     writeTarget,
        GLintptr   readOffset,
        GLintptr   writeOffset,
        GLsizeiptr size,
    );
    alias PFN_glXNamedCopyBufferSubDataNV = void function (
        Display*   dpy,
        GLXContext readCtx,
        GLXContext writeCtx,
        GLuint     readBuffer,
        GLuint     writeBuffer,
        GLintptr   readOffset,
        GLintptr   writeOffset,
        GLsizeiptr size,
    );

    // Command pointers for GLX_NV_copy_image
    alias PFN_glXCopyImageSubDataNV = void function (
        Display*   dpy,
        GLXContext srcCtx,
        GLuint     srcName,
        GLenum     srcTarget,
        GLint      srcLevel,
        GLint      srcX,
        GLint      srcY,
        GLint      srcZ,
        GLXContext dstCtx,
        GLuint     dstName,
        GLenum     dstTarget,
        GLint      dstLevel,
        GLint      dstX,
        GLint      dstY,
        GLint      dstZ,
        GLsizei    width,
        GLsizei    height,
        GLsizei    depth,
    );

    // Command pointers for GLX_NV_delay_before_swap
    alias PFN_glXDelayBeforeSwapNV = Bool function (
        Display*    dpy,
        GLXDrawable drawable,
        GLfloat     seconds,
    );

    // Command pointers for GLX_NV_present_video
    alias PFN_glXEnumerateVideoDevicesNV = uint * function (
        Display* dpy,
        int      screen,
        int*     nelements,
    );
    alias PFN_glXBindVideoDeviceNV = int function (
        Display*    dpy,
        uint        video_slot,
        uint        video_device,
        const(int)* attrib_list,
    );

    // Command pointers for GLX_NV_swap_group
    alias PFN_glXJoinSwapGroupNV = Bool function (
        Display*    dpy,
        GLXDrawable drawable,
        GLuint      group,
    );
    alias PFN_glXBindSwapBarrierNV = Bool function (
        Display* dpy,
        GLuint   group,
        GLuint   barrier,
    );
    alias PFN_glXQuerySwapGroupNV = Bool function (
        Display*    dpy,
        GLXDrawable drawable,
        GLuint*     group,
        GLuint*     barrier,
    );
    alias PFN_glXQueryMaxSwapGroupsNV = Bool function (
        Display* dpy,
        int      screen,
        GLuint*  maxGroups,
        GLuint*  maxBarriers,
    );
    alias PFN_glXQueryFrameCountNV = Bool function (
        Display* dpy,
        int      screen,
        GLuint*  count,
    );
    alias PFN_glXResetFrameCountNV = Bool function (
        Display* dpy,
        int      screen,
    );

    // Command pointers for GLX_NV_video_capture
    alias PFN_glXBindVideoCaptureDeviceNV = int function (
        Display*                dpy,
        uint                    video_capture_slot,
        GLXVideoCaptureDeviceNV device,
    );
    alias PFN_glXEnumerateVideoCaptureDevicesNV = GLXVideoCaptureDeviceNV * function (
        Display* dpy,
        int      screen,
        int*     nelements,
    );
    alias PFN_glXLockVideoCaptureDeviceNV = void function (
        Display*                dpy,
        GLXVideoCaptureDeviceNV device,
    );
    alias PFN_glXQueryVideoCaptureDeviceNV = int function (
        Display*                dpy,
        GLXVideoCaptureDeviceNV device,
        int                     attribute,
        int*                    value,
    );
    alias PFN_glXReleaseVideoCaptureDeviceNV = void function (
        Display*                dpy,
        GLXVideoCaptureDeviceNV device,
    );

    // Command pointers for GLX_NV_video_out
    alias PFN_glXGetVideoDeviceNV = int function (
        Display*          dpy,
        int               screen,
        int               numVideoDevices,
        GLXVideoDeviceNV* pVideoDevice,
    );
    alias PFN_glXReleaseVideoDeviceNV = int function (
        Display*         dpy,
        int              screen,
        GLXVideoDeviceNV VideoDevice,
    );
    alias PFN_glXBindVideoImageNV = int function (
        Display*         dpy,
        GLXVideoDeviceNV VideoDevice,
        GLXPbuffer       pbuf,
        int              iVideoBuffer,
    );
    alias PFN_glXReleaseVideoImageNV = int function (
        Display*   dpy,
        GLXPbuffer pbuf,
    );
    alias PFN_glXSendPbufferToVideoNV = int function (
        Display*   dpy,
        GLXPbuffer pbuf,
        int        iBufferType,
        c_ulong*   pulCounterPbuffer,
        GLboolean  bBlock,
    );
    alias PFN_glXGetVideoInfoNV = int function (
        Display*         dpy,
        int              screen,
        GLXVideoDeviceNV VideoDevice,
        c_ulong*         pulCounterOutputPbuffer,
        c_ulong*         pulCounterOutputVideo,
    );

    // Command pointers for GLX_OML_sync_control
    alias PFN_glXGetSyncValuesOML = Bool function (
        Display*    dpy,
        GLXDrawable drawable,
        int64_t*    ust,
        int64_t*    msc,
        int64_t*    sbc,
    );
    alias PFN_glXGetMscRateOML = Bool function (
        Display*    dpy,
        GLXDrawable drawable,
        int32_t*    numerator,
        int32_t*    denominator,
    );
    alias PFN_glXSwapBuffersMscOML = int64_t function (
        Display*    dpy,
        GLXDrawable drawable,
        int64_t     target_msc,
        int64_t     divisor,
        int64_t     remainder,
    );
    alias PFN_glXWaitForMscOML = Bool function (
        Display*    dpy,
        GLXDrawable drawable,
        int64_t     target_msc,
        int64_t     divisor,
        int64_t     remainder,
        int64_t*    ust,
        int64_t*    msc,
        int64_t*    sbc,
    );
    alias PFN_glXWaitForSbcOML = Bool function (
        Display*    dpy,
        GLXDrawable drawable,
        int64_t     target_sbc,
        int64_t*    ust,
        int64_t*    msc,
        int64_t*    sbc,
    );

    // Command pointers for GLX_SGIX_fbconfig
    alias PFN_glXGetFBConfigAttribSGIX = int function (
        Display*        dpy,
        GLXFBConfigSGIX config,
        int             attribute,
        int*            value,
    );
    alias PFN_glXChooseFBConfigSGIX = GLXFBConfigSGIX * function (
        Display* dpy,
        int      screen,
        int*     attrib_list,
        int*     nelements,
    );
    alias PFN_glXCreateGLXPixmapWithConfigSGIX = GLXPixmap function (
        Display*        dpy,
        GLXFBConfigSGIX config,
        Pixmap          pixmap,
    );
    alias PFN_glXCreateContextWithConfigSGIX = GLXContext function (
        Display*        dpy,
        GLXFBConfigSGIX config,
        int             render_type,
        GLXContext      share_list,
        Bool            direct,
    );
    alias PFN_glXGetVisualFromFBConfigSGIX = XVisualInfo * function (
        Display*        dpy,
        GLXFBConfigSGIX config,
    );
    alias PFN_glXGetFBConfigFromVisualSGIX = GLXFBConfigSGIX function (
        Display*     dpy,
        XVisualInfo* vis,
    );

    // Command pointers for GLX_SGIX_hyperpipe
    alias PFN_glXQueryHyperpipeNetworkSGIX = GLXHyperpipeNetworkSGIX * function (
        Display* dpy,
        int*     npipes,
    );
    alias PFN_glXHyperpipeConfigSGIX = int function (
        Display*                dpy,
        int                     networkId,
        int                     npipes,
        GLXHyperpipeConfigSGIX* cfg,
        int*                    hpId,
    );
    alias PFN_glXQueryHyperpipeConfigSGIX = GLXHyperpipeConfigSGIX * function (
        Display* dpy,
        int      hpId,
        int*     npipes,
    );
    alias PFN_glXDestroyHyperpipeConfigSGIX = int function (
        Display* dpy,
        int      hpId,
    );
    alias PFN_glXBindHyperpipeSGIX = int function (
        Display* dpy,
        int      hpId,
    );
    alias PFN_glXQueryHyperpipeBestAttribSGIX = int function (
        Display* dpy,
        int      timeSlice,
        int      attrib,
        int      size,
        void*    attribList,
        void*    returnAttribList,
    );
    alias PFN_glXHyperpipeAttribSGIX = int function (
        Display* dpy,
        int      timeSlice,
        int      attrib,
        int      size,
        void*    attribList,
    );
    alias PFN_glXQueryHyperpipeAttribSGIX = int function (
        Display* dpy,
        int      timeSlice,
        int      attrib,
        int      size,
        void*    returnAttribList,
    );

    // Command pointers for GLX_SGIX_pbuffer
    alias PFN_glXCreateGLXPbufferSGIX = GLXPbufferSGIX function (
        Display*        dpy,
        GLXFBConfigSGIX config,
        uint            width,
        uint            height,
        int*            attrib_list,
    );
    alias PFN_glXDestroyGLXPbufferSGIX = void function (
        Display*       dpy,
        GLXPbufferSGIX pbuf,
    );
    alias PFN_glXQueryGLXPbufferSGIX = int function (
        Display*       dpy,
        GLXPbufferSGIX pbuf,
        int            attribute,
        uint*          value,
    );
    alias PFN_glXSelectEventSGIX = void function (
        Display*    dpy,
        GLXDrawable drawable,
        c_ulong     mask,
    );
    alias PFN_glXGetSelectedEventSGIX = void function (
        Display*    dpy,
        GLXDrawable drawable,
        c_ulong*    mask,
    );

    // Command pointers for GLX_SGIX_swap_barrier
    alias PFN_glXBindSwapBarrierSGIX = void function (
        Display*    dpy,
        GLXDrawable drawable,
        int         barrier,
    );
    alias PFN_glXQueryMaxSwapBarriersSGIX = Bool function (
        Display* dpy,
        int      screen,
        int*     max,
    );

    // Command pointers for GLX_SGIX_swap_group
    alias PFN_glXJoinSwapGroupSGIX = void function (
        Display*    dpy,
        GLXDrawable drawable,
        GLXDrawable member,
    );

    // Command pointers for GLX_SGIX_video_resize
    alias PFN_glXBindChannelToWindowSGIX = int function (
        Display* display,
        int      screen,
        int      channel,
        Window   window,
    );
    alias PFN_glXChannelRectSGIX = int function (
        Display* display,
        int      screen,
        int      channel,
        int      x,
        int      y,
        int      w,
        int      h,
    );
    alias PFN_glXQueryChannelRectSGIX = int function (
        Display* display,
        int      screen,
        int      channel,
        int*     dx,
        int*     dy,
        int*     dw,
        int*     dh,
    );
    alias PFN_glXQueryChannelDeltasSGIX = int function (
        Display* display,
        int      screen,
        int      channel,
        int*     x,
        int*     y,
        int*     w,
        int*     h,
    );
    alias PFN_glXChannelRectSyncSGIX = int function (
        Display* display,
        int      screen,
        int      channel,
        GLenum   synctype,
    );

    // Command pointers for GLX_SGI_cushion
    alias PFN_glXCushionSGI = void function (
        Display* dpy,
        Window   window,
        float    cushion,
    );

    // Command pointers for GLX_SGI_make_current_read
    alias PFN_glXMakeCurrentReadSGI = Bool function (
        Display*    dpy,
        GLXDrawable draw,
        GLXDrawable read,
        GLXContext  ctx,
    );
    alias PFN_glXGetCurrentReadDrawableSGI = GLXDrawable function ();

    // Command pointers for GLX_SGI_swap_control
    alias PFN_glXSwapIntervalSGI = int function (
        int interval,
    );

    // Command pointers for GLX_SGI_video_sync
    alias PFN_glXGetVideoSyncSGI = int function (
        uint* count,
    );
    alias PFN_glXWaitVideoSyncSGI = int function (
        int   divisor,
        int   remainder,
        uint* count,
    );

    // Command pointers for GLX_SUN_get_transparent_index
    alias PFN_glXGetTransparentIndexSUN = Status function (
        Display* dpy,
        Window   overlay,
        Window   underlay,
        long*    pTransparentIndex,
    );
}

/// GlxVersion describes the version of GLX
enum GlxVersion {
    glx10 = 10,
    glx11 = 11,
    glx12 = 12,
    glx13 = 13,
    glx14 = 14,
}

/// GLX loader base class
final class Glx {
    this(SymbolLoader loader) {

        // GLX_VERSION_1_0
        _ChooseVisual = cast(PFN_glXChooseVisual)loadSymbol(loader, "glXChooseVisual", []);
        _CreateContext = cast(PFN_glXCreateContext)loadSymbol(loader, "glXCreateContext", []);
        _DestroyContext = cast(PFN_glXDestroyContext)loadSymbol(loader, "glXDestroyContext", []);
        _MakeCurrent = cast(PFN_glXMakeCurrent)loadSymbol(loader, "glXMakeCurrent", []);
        _CopyContext = cast(PFN_glXCopyContext)loadSymbol(loader, "glXCopyContext", []);
        _SwapBuffers = cast(PFN_glXSwapBuffers)loadSymbol(loader, "glXSwapBuffers", []);
        _CreateGLXPixmap = cast(PFN_glXCreateGLXPixmap)loadSymbol(loader, "glXCreateGLXPixmap", []);
        _DestroyGLXPixmap = cast(PFN_glXDestroyGLXPixmap)loadSymbol(loader, "glXDestroyGLXPixmap", []);
        _QueryExtension = cast(PFN_glXQueryExtension)loadSymbol(loader, "glXQueryExtension", []);
        _QueryVersion = cast(PFN_glXQueryVersion)loadSymbol(loader, "glXQueryVersion", []);
        _IsDirect = cast(PFN_glXIsDirect)loadSymbol(loader, "glXIsDirect", []);
        _GetConfig = cast(PFN_glXGetConfig)loadSymbol(loader, "glXGetConfig", []);
        _GetCurrentContext = cast(PFN_glXGetCurrentContext)loadSymbol(loader, "glXGetCurrentContext", []);
        _GetCurrentDrawable = cast(PFN_glXGetCurrentDrawable)loadSymbol(loader, "glXGetCurrentDrawable", []);
        _WaitGL = cast(PFN_glXWaitGL)loadSymbol(loader, "glXWaitGL", []);
        _WaitX = cast(PFN_glXWaitX)loadSymbol(loader, "glXWaitX", []);
        _UseXFont = cast(PFN_glXUseXFont)loadSymbol(loader, "glXUseXFont", []);

        // GLX_VERSION_1_1
        _QueryExtensionsString = cast(PFN_glXQueryExtensionsString)loadSymbol(loader, "glXQueryExtensionsString", []);
        _QueryServerString = cast(PFN_glXQueryServerString)loadSymbol(loader, "glXQueryServerString", []);
        _GetClientString = cast(PFN_glXGetClientString)loadSymbol(loader, "glXGetClientString", []);

        // GLX_VERSION_1_2
        _GetCurrentDisplay = cast(PFN_glXGetCurrentDisplay)loadSymbol(loader, "glXGetCurrentDisplay", []);

        // GLX_VERSION_1_3
        _GetFBConfigs = cast(PFN_glXGetFBConfigs)loadSymbol(loader, "glXGetFBConfigs", []);
        _ChooseFBConfig = cast(PFN_glXChooseFBConfig)loadSymbol(loader, "glXChooseFBConfig", []);
        _GetFBConfigAttrib = cast(PFN_glXGetFBConfigAttrib)loadSymbol(loader, "glXGetFBConfigAttrib", []);
        _GetVisualFromFBConfig = cast(PFN_glXGetVisualFromFBConfig)loadSymbol(loader, "glXGetVisualFromFBConfig", []);
        _CreateWindow = cast(PFN_glXCreateWindow)loadSymbol(loader, "glXCreateWindow", []);
        _DestroyWindow = cast(PFN_glXDestroyWindow)loadSymbol(loader, "glXDestroyWindow", []);
        _CreatePixmap = cast(PFN_glXCreatePixmap)loadSymbol(loader, "glXCreatePixmap", []);
        _DestroyPixmap = cast(PFN_glXDestroyPixmap)loadSymbol(loader, "glXDestroyPixmap", []);
        _CreatePbuffer = cast(PFN_glXCreatePbuffer)loadSymbol(loader, "glXCreatePbuffer", []);
        _DestroyPbuffer = cast(PFN_glXDestroyPbuffer)loadSymbol(loader, "glXDestroyPbuffer", []);
        _QueryDrawable = cast(PFN_glXQueryDrawable)loadSymbol(loader, "glXQueryDrawable", []);
        _CreateNewContext = cast(PFN_glXCreateNewContext)loadSymbol(loader, "glXCreateNewContext", []);
        _MakeContextCurrent = cast(PFN_glXMakeContextCurrent)loadSymbol(loader, "glXMakeContextCurrent", []);
        _GetCurrentReadDrawable = cast(PFN_glXGetCurrentReadDrawable)loadSymbol(loader, "glXGetCurrentReadDrawable", []);
        _QueryContext = cast(PFN_glXQueryContext)loadSymbol(loader, "glXQueryContext", []);
        _SelectEvent = cast(PFN_glXSelectEvent)loadSymbol(loader, "glXSelectEvent", []);
        _GetSelectedEvent = cast(PFN_glXGetSelectedEvent)loadSymbol(loader, "glXGetSelectedEvent", []);

        // GLX_VERSION_1_4
        _GetProcAddress = cast(PFN_glXGetProcAddress)loadSymbol(loader, "glXGetProcAddress", []);

        // GLX_ARB_create_context,
        _CreateContextAttribsARB = cast(PFN_glXCreateContextAttribsARB)loadSymbol(loader, "glXCreateContextAttribsARB", []);

        // GLX_ARB_get_proc_address,
        _GetProcAddressARB = cast(PFN_glXGetProcAddressARB)loadSymbol(loader, "glXGetProcAddressARB", []);

        // GLX_AMD_gpu_association,
        _GetGPUIDsAMD = cast(PFN_glXGetGPUIDsAMD)loadSymbol(loader, "glXGetGPUIDsAMD", []);
        _GetGPUInfoAMD = cast(PFN_glXGetGPUInfoAMD)loadSymbol(loader, "glXGetGPUInfoAMD", []);
        _GetContextGPUIDAMD = cast(PFN_glXGetContextGPUIDAMD)loadSymbol(loader, "glXGetContextGPUIDAMD", []);
        _CreateAssociatedContextAMD = cast(PFN_glXCreateAssociatedContextAMD)loadSymbol(loader, "glXCreateAssociatedContextAMD", []);
        _CreateAssociatedContextAttribsAMD = cast(PFN_glXCreateAssociatedContextAttribsAMD)loadSymbol(loader, "glXCreateAssociatedContextAttribsAMD", []);
        _DeleteAssociatedContextAMD = cast(PFN_glXDeleteAssociatedContextAMD)loadSymbol(loader, "glXDeleteAssociatedContextAMD", []);
        _MakeAssociatedContextCurrentAMD = cast(PFN_glXMakeAssociatedContextCurrentAMD)loadSymbol(loader, "glXMakeAssociatedContextCurrentAMD", []);
        _GetCurrentAssociatedContextAMD = cast(PFN_glXGetCurrentAssociatedContextAMD)loadSymbol(loader, "glXGetCurrentAssociatedContextAMD", []);
        _BlitContextFramebufferAMD = cast(PFN_glXBlitContextFramebufferAMD)loadSymbol(loader, "glXBlitContextFramebufferAMD", []);

        // GLX_EXT_import_context,
        _GetCurrentDisplayEXT = cast(PFN_glXGetCurrentDisplayEXT)loadSymbol(loader, "glXGetCurrentDisplayEXT", []);
        _QueryContextInfoEXT = cast(PFN_glXQueryContextInfoEXT)loadSymbol(loader, "glXQueryContextInfoEXT", []);
        _GetContextIDEXT = cast(PFN_glXGetContextIDEXT)loadSymbol(loader, "glXGetContextIDEXT", []);
        _ImportContextEXT = cast(PFN_glXImportContextEXT)loadSymbol(loader, "glXImportContextEXT", []);
        _FreeContextEXT = cast(PFN_glXFreeContextEXT)loadSymbol(loader, "glXFreeContextEXT", []);

        // GLX_EXT_swap_control,
        _SwapIntervalEXT = cast(PFN_glXSwapIntervalEXT)loadSymbol(loader, "glXSwapIntervalEXT", []);

        // GLX_EXT_texture_from_pixmap,
        _BindTexImageEXT = cast(PFN_glXBindTexImageEXT)loadSymbol(loader, "glXBindTexImageEXT", []);
        _ReleaseTexImageEXT = cast(PFN_glXReleaseTexImageEXT)loadSymbol(loader, "glXReleaseTexImageEXT", []);

        // GLX_MESA_agp_offset,
        _GetAGPOffsetMESA = cast(PFN_glXGetAGPOffsetMESA)loadSymbol(loader, "glXGetAGPOffsetMESA", []);

        // GLX_MESA_copy_sub_buffer,
        _CopySubBufferMESA = cast(PFN_glXCopySubBufferMESA)loadSymbol(loader, "glXCopySubBufferMESA", []);

        // GLX_MESA_pixmap_colormap,
        _CreateGLXPixmapMESA = cast(PFN_glXCreateGLXPixmapMESA)loadSymbol(loader, "glXCreateGLXPixmapMESA", []);

        // GLX_MESA_query_renderer,
        _QueryCurrentRendererIntegerMESA = cast(PFN_glXQueryCurrentRendererIntegerMESA)loadSymbol(loader, "glXQueryCurrentRendererIntegerMESA", []);
        _QueryCurrentRendererStringMESA = cast(PFN_glXQueryCurrentRendererStringMESA)loadSymbol(loader, "glXQueryCurrentRendererStringMESA", []);
        _QueryRendererIntegerMESA = cast(PFN_glXQueryRendererIntegerMESA)loadSymbol(loader, "glXQueryRendererIntegerMESA", []);
        _QueryRendererStringMESA = cast(PFN_glXQueryRendererStringMESA)loadSymbol(loader, "glXQueryRendererStringMESA", []);

        // GLX_MESA_release_buffers,
        _ReleaseBuffersMESA = cast(PFN_glXReleaseBuffersMESA)loadSymbol(loader, "glXReleaseBuffersMESA", []);

        // GLX_MESA_set_3dfx_mode,
        _Set3DfxModeMESA = cast(PFN_glXSet3DfxModeMESA)loadSymbol(loader, "glXSet3DfxModeMESA", []);

        // GLX_MESA_swap_control,
        _GetSwapIntervalMESA = cast(PFN_glXGetSwapIntervalMESA)loadSymbol(loader, "glXGetSwapIntervalMESA", []);
        _SwapIntervalMESA = cast(PFN_glXSwapIntervalMESA)loadSymbol(loader, "glXSwapIntervalMESA", []);

        // GLX_NV_copy_buffer,
        _CopyBufferSubDataNV = cast(PFN_glXCopyBufferSubDataNV)loadSymbol(loader, "glXCopyBufferSubDataNV", []);
        _NamedCopyBufferSubDataNV = cast(PFN_glXNamedCopyBufferSubDataNV)loadSymbol(loader, "glXNamedCopyBufferSubDataNV", []);

        // GLX_NV_copy_image,
        _CopyImageSubDataNV = cast(PFN_glXCopyImageSubDataNV)loadSymbol(loader, "glXCopyImageSubDataNV", []);

        // GLX_NV_delay_before_swap,
        _DelayBeforeSwapNV = cast(PFN_glXDelayBeforeSwapNV)loadSymbol(loader, "glXDelayBeforeSwapNV", []);

        // GLX_NV_present_video,
        _EnumerateVideoDevicesNV = cast(PFN_glXEnumerateVideoDevicesNV)loadSymbol(loader, "glXEnumerateVideoDevicesNV", []);
        _BindVideoDeviceNV = cast(PFN_glXBindVideoDeviceNV)loadSymbol(loader, "glXBindVideoDeviceNV", []);

        // GLX_NV_swap_group,
        _JoinSwapGroupNV = cast(PFN_glXJoinSwapGroupNV)loadSymbol(loader, "glXJoinSwapGroupNV", []);
        _BindSwapBarrierNV = cast(PFN_glXBindSwapBarrierNV)loadSymbol(loader, "glXBindSwapBarrierNV", []);
        _QuerySwapGroupNV = cast(PFN_glXQuerySwapGroupNV)loadSymbol(loader, "glXQuerySwapGroupNV", []);
        _QueryMaxSwapGroupsNV = cast(PFN_glXQueryMaxSwapGroupsNV)loadSymbol(loader, "glXQueryMaxSwapGroupsNV", []);
        _QueryFrameCountNV = cast(PFN_glXQueryFrameCountNV)loadSymbol(loader, "glXQueryFrameCountNV", []);
        _ResetFrameCountNV = cast(PFN_glXResetFrameCountNV)loadSymbol(loader, "glXResetFrameCountNV", []);

        // GLX_NV_video_capture,
        _BindVideoCaptureDeviceNV = cast(PFN_glXBindVideoCaptureDeviceNV)loadSymbol(loader, "glXBindVideoCaptureDeviceNV", []);
        _EnumerateVideoCaptureDevicesNV = cast(PFN_glXEnumerateVideoCaptureDevicesNV)loadSymbol(loader, "glXEnumerateVideoCaptureDevicesNV", []);
        _LockVideoCaptureDeviceNV = cast(PFN_glXLockVideoCaptureDeviceNV)loadSymbol(loader, "glXLockVideoCaptureDeviceNV", []);
        _QueryVideoCaptureDeviceNV = cast(PFN_glXQueryVideoCaptureDeviceNV)loadSymbol(loader, "glXQueryVideoCaptureDeviceNV", []);
        _ReleaseVideoCaptureDeviceNV = cast(PFN_glXReleaseVideoCaptureDeviceNV)loadSymbol(loader, "glXReleaseVideoCaptureDeviceNV", []);

        // GLX_NV_video_out,
        _GetVideoDeviceNV = cast(PFN_glXGetVideoDeviceNV)loadSymbol(loader, "glXGetVideoDeviceNV", []);
        _ReleaseVideoDeviceNV = cast(PFN_glXReleaseVideoDeviceNV)loadSymbol(loader, "glXReleaseVideoDeviceNV", []);
        _BindVideoImageNV = cast(PFN_glXBindVideoImageNV)loadSymbol(loader, "glXBindVideoImageNV", []);
        _ReleaseVideoImageNV = cast(PFN_glXReleaseVideoImageNV)loadSymbol(loader, "glXReleaseVideoImageNV", []);
        _SendPbufferToVideoNV = cast(PFN_glXSendPbufferToVideoNV)loadSymbol(loader, "glXSendPbufferToVideoNV", []);
        _GetVideoInfoNV = cast(PFN_glXGetVideoInfoNV)loadSymbol(loader, "glXGetVideoInfoNV", []);

        // GLX_OML_sync_control,
        _GetSyncValuesOML = cast(PFN_glXGetSyncValuesOML)loadSymbol(loader, "glXGetSyncValuesOML", []);
        _GetMscRateOML = cast(PFN_glXGetMscRateOML)loadSymbol(loader, "glXGetMscRateOML", []);
        _SwapBuffersMscOML = cast(PFN_glXSwapBuffersMscOML)loadSymbol(loader, "glXSwapBuffersMscOML", []);
        _WaitForMscOML = cast(PFN_glXWaitForMscOML)loadSymbol(loader, "glXWaitForMscOML", []);
        _WaitForSbcOML = cast(PFN_glXWaitForSbcOML)loadSymbol(loader, "glXWaitForSbcOML", []);

        // GLX_SGIX_fbconfig,
        _GetFBConfigAttribSGIX = cast(PFN_glXGetFBConfigAttribSGIX)loadSymbol(loader, "glXGetFBConfigAttribSGIX", []);
        _ChooseFBConfigSGIX = cast(PFN_glXChooseFBConfigSGIX)loadSymbol(loader, "glXChooseFBConfigSGIX", []);
        _CreateGLXPixmapWithConfigSGIX = cast(PFN_glXCreateGLXPixmapWithConfigSGIX)loadSymbol(loader, "glXCreateGLXPixmapWithConfigSGIX", []);
        _CreateContextWithConfigSGIX = cast(PFN_glXCreateContextWithConfigSGIX)loadSymbol(loader, "glXCreateContextWithConfigSGIX", []);
        _GetVisualFromFBConfigSGIX = cast(PFN_glXGetVisualFromFBConfigSGIX)loadSymbol(loader, "glXGetVisualFromFBConfigSGIX", []);
        _GetFBConfigFromVisualSGIX = cast(PFN_glXGetFBConfigFromVisualSGIX)loadSymbol(loader, "glXGetFBConfigFromVisualSGIX", []);

        // GLX_SGIX_hyperpipe,
        _QueryHyperpipeNetworkSGIX = cast(PFN_glXQueryHyperpipeNetworkSGIX)loadSymbol(loader, "glXQueryHyperpipeNetworkSGIX", []);
        _HyperpipeConfigSGIX = cast(PFN_glXHyperpipeConfigSGIX)loadSymbol(loader, "glXHyperpipeConfigSGIX", []);
        _QueryHyperpipeConfigSGIX = cast(PFN_glXQueryHyperpipeConfigSGIX)loadSymbol(loader, "glXQueryHyperpipeConfigSGIX", []);
        _DestroyHyperpipeConfigSGIX = cast(PFN_glXDestroyHyperpipeConfigSGIX)loadSymbol(loader, "glXDestroyHyperpipeConfigSGIX", []);
        _BindHyperpipeSGIX = cast(PFN_glXBindHyperpipeSGIX)loadSymbol(loader, "glXBindHyperpipeSGIX", []);
        _QueryHyperpipeBestAttribSGIX = cast(PFN_glXQueryHyperpipeBestAttribSGIX)loadSymbol(loader, "glXQueryHyperpipeBestAttribSGIX", []);
        _HyperpipeAttribSGIX = cast(PFN_glXHyperpipeAttribSGIX)loadSymbol(loader, "glXHyperpipeAttribSGIX", []);
        _QueryHyperpipeAttribSGIX = cast(PFN_glXQueryHyperpipeAttribSGIX)loadSymbol(loader, "glXQueryHyperpipeAttribSGIX", []);

        // GLX_SGIX_pbuffer,
        _CreateGLXPbufferSGIX = cast(PFN_glXCreateGLXPbufferSGIX)loadSymbol(loader, "glXCreateGLXPbufferSGIX", []);
        _DestroyGLXPbufferSGIX = cast(PFN_glXDestroyGLXPbufferSGIX)loadSymbol(loader, "glXDestroyGLXPbufferSGIX", []);
        _QueryGLXPbufferSGIX = cast(PFN_glXQueryGLXPbufferSGIX)loadSymbol(loader, "glXQueryGLXPbufferSGIX", []);
        _SelectEventSGIX = cast(PFN_glXSelectEventSGIX)loadSymbol(loader, "glXSelectEventSGIX", []);
        _GetSelectedEventSGIX = cast(PFN_glXGetSelectedEventSGIX)loadSymbol(loader, "glXGetSelectedEventSGIX", []);

        // GLX_SGIX_swap_barrier,
        _BindSwapBarrierSGIX = cast(PFN_glXBindSwapBarrierSGIX)loadSymbol(loader, "glXBindSwapBarrierSGIX", []);
        _QueryMaxSwapBarriersSGIX = cast(PFN_glXQueryMaxSwapBarriersSGIX)loadSymbol(loader, "glXQueryMaxSwapBarriersSGIX", []);

        // GLX_SGIX_swap_group,
        _JoinSwapGroupSGIX = cast(PFN_glXJoinSwapGroupSGIX)loadSymbol(loader, "glXJoinSwapGroupSGIX", []);

        // GLX_SGIX_video_resize,
        _BindChannelToWindowSGIX = cast(PFN_glXBindChannelToWindowSGIX)loadSymbol(loader, "glXBindChannelToWindowSGIX", []);
        _ChannelRectSGIX = cast(PFN_glXChannelRectSGIX)loadSymbol(loader, "glXChannelRectSGIX", []);
        _QueryChannelRectSGIX = cast(PFN_glXQueryChannelRectSGIX)loadSymbol(loader, "glXQueryChannelRectSGIX", []);
        _QueryChannelDeltasSGIX = cast(PFN_glXQueryChannelDeltasSGIX)loadSymbol(loader, "glXQueryChannelDeltasSGIX", []);
        _ChannelRectSyncSGIX = cast(PFN_glXChannelRectSyncSGIX)loadSymbol(loader, "glXChannelRectSyncSGIX", []);

        // GLX_SGI_cushion,
        _CushionSGI = cast(PFN_glXCushionSGI)loadSymbol(loader, "glXCushionSGI", []);

        // GLX_SGI_make_current_read,
        _MakeCurrentReadSGI = cast(PFN_glXMakeCurrentReadSGI)loadSymbol(loader, "glXMakeCurrentReadSGI", []);
        _GetCurrentReadDrawableSGI = cast(PFN_glXGetCurrentReadDrawableSGI)loadSymbol(loader, "glXGetCurrentReadDrawableSGI", []);

        // GLX_SGI_swap_control,
        _SwapIntervalSGI = cast(PFN_glXSwapIntervalSGI)loadSymbol(loader, "glXSwapIntervalSGI", []);

        // GLX_SGI_video_sync,
        _GetVideoSyncSGI = cast(PFN_glXGetVideoSyncSGI)loadSymbol(loader, "glXGetVideoSyncSGI", []);
        _WaitVideoSyncSGI = cast(PFN_glXWaitVideoSyncSGI)loadSymbol(loader, "glXWaitVideoSyncSGI", []);

        // GLX_SUN_get_transparent_index,
        _GetTransparentIndexSUN = cast(PFN_glXGetTransparentIndexSUN)loadSymbol(loader, "glXGetTransparentIndexSUN", []);
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

    /// Commands for GLX_VERSION_1_0
    public XVisualInfo * ChooseVisual (Display* dpy, int screen, int* attribList) const {
        assert(_ChooseVisual !is null, "GLX command glXChooseVisual was not loaded");
        return _ChooseVisual (dpy, screen, attribList);
    }
    /// ditto
    public GLXContext CreateContext (Display* dpy, XVisualInfo* vis, GLXContext shareList, Bool direct) const {
        assert(_CreateContext !is null, "GLX command glXCreateContext was not loaded");
        return _CreateContext (dpy, vis, shareList, direct);
    }
    /// ditto
    public void DestroyContext (Display* dpy, GLXContext ctx) const {
        assert(_DestroyContext !is null, "GLX command glXDestroyContext was not loaded");
        return _DestroyContext (dpy, ctx);
    }
    /// ditto
    public Bool MakeCurrent (Display* dpy, GLXDrawable drawable, GLXContext ctx) const {
        assert(_MakeCurrent !is null, "GLX command glXMakeCurrent was not loaded");
        return _MakeCurrent (dpy, drawable, ctx);
    }
    /// ditto
    public void CopyContext (Display* dpy, GLXContext src, GLXContext dst, c_ulong mask) const {
        assert(_CopyContext !is null, "GLX command glXCopyContext was not loaded");
        return _CopyContext (dpy, src, dst, mask);
    }
    /// ditto
    public void SwapBuffers (Display* dpy, GLXDrawable drawable) const {
        assert(_SwapBuffers !is null, "GLX command glXSwapBuffers was not loaded");
        return _SwapBuffers (dpy, drawable);
    }
    /// ditto
    public GLXPixmap CreateGLXPixmap (Display* dpy, XVisualInfo* visual, Pixmap pixmap) const {
        assert(_CreateGLXPixmap !is null, "GLX command glXCreateGLXPixmap was not loaded");
        return _CreateGLXPixmap (dpy, visual, pixmap);
    }
    /// ditto
    public void DestroyGLXPixmap (Display* dpy, GLXPixmap pixmap) const {
        assert(_DestroyGLXPixmap !is null, "GLX command glXDestroyGLXPixmap was not loaded");
        return _DestroyGLXPixmap (dpy, pixmap);
    }
    /// ditto
    public Bool QueryExtension (Display* dpy, int* errorb, int* event) const {
        assert(_QueryExtension !is null, "GLX command glXQueryExtension was not loaded");
        return _QueryExtension (dpy, errorb, event);
    }
    /// ditto
    public Bool QueryVersion (Display* dpy, int* maj, int* min) const {
        assert(_QueryVersion !is null, "GLX command glXQueryVersion was not loaded");
        return _QueryVersion (dpy, maj, min);
    }
    /// ditto
    public Bool IsDirect (Display* dpy, GLXContext ctx) const {
        assert(_IsDirect !is null, "GLX command glXIsDirect was not loaded");
        return _IsDirect (dpy, ctx);
    }
    /// ditto
    public int GetConfig (Display* dpy, XVisualInfo* visual, int attrib, int* value) const {
        assert(_GetConfig !is null, "GLX command glXGetConfig was not loaded");
        return _GetConfig (dpy, visual, attrib, value);
    }
    /// ditto
    public GLXContext GetCurrentContext () const {
        assert(_GetCurrentContext !is null, "GLX command glXGetCurrentContext was not loaded");
        return _GetCurrentContext ();
    }
    /// ditto
    public GLXDrawable GetCurrentDrawable () const {
        assert(_GetCurrentDrawable !is null, "GLX command glXGetCurrentDrawable was not loaded");
        return _GetCurrentDrawable ();
    }
    /// ditto
    public void WaitGL () const {
        assert(_WaitGL !is null, "GLX command glXWaitGL was not loaded");
        return _WaitGL ();
    }
    /// ditto
    public void WaitX () const {
        assert(_WaitX !is null, "GLX command glXWaitX was not loaded");
        return _WaitX ();
    }
    /// ditto
    public void UseXFont (Font font, int first, int count, int list) const {
        assert(_UseXFont !is null, "GLX command glXUseXFont was not loaded");
        return _UseXFont (font, first, count, list);
    }

    /// Commands for GLX_VERSION_1_1
    public const(char)* QueryExtensionsString (Display* dpy, int screen) const {
        assert(_QueryExtensionsString !is null, "GLX command glXQueryExtensionsString was not loaded");
        return _QueryExtensionsString (dpy, screen);
    }
    /// ditto
    public const(char)* QueryServerString (Display* dpy, int screen, int name) const {
        assert(_QueryServerString !is null, "GLX command glXQueryServerString was not loaded");
        return _QueryServerString (dpy, screen, name);
    }
    /// ditto
    public const(char)* GetClientString (Display* dpy, int name) const {
        assert(_GetClientString !is null, "GLX command glXGetClientString was not loaded");
        return _GetClientString (dpy, name);
    }

    /// Commands for GLX_VERSION_1_2
    public Display * GetCurrentDisplay () const {
        assert(_GetCurrentDisplay !is null, "GLX command glXGetCurrentDisplay was not loaded");
        return _GetCurrentDisplay ();
    }

    /// Commands for GLX_VERSION_1_3
    public GLXFBConfig * GetFBConfigs (Display* dpy, int screen, int* nelements) const {
        assert(_GetFBConfigs !is null, "GLX command glXGetFBConfigs was not loaded");
        return _GetFBConfigs (dpy, screen, nelements);
    }
    /// ditto
    public GLXFBConfig * ChooseFBConfig (Display* dpy, int screen, const(int)* attrib_list, int* nelements) const {
        assert(_ChooseFBConfig !is null, "GLX command glXChooseFBConfig was not loaded");
        return _ChooseFBConfig (dpy, screen, attrib_list, nelements);
    }
    /// ditto
    public int GetFBConfigAttrib (Display* dpy, GLXFBConfig config, int attribute, int* value) const {
        assert(_GetFBConfigAttrib !is null, "GLX command glXGetFBConfigAttrib was not loaded");
        return _GetFBConfigAttrib (dpy, config, attribute, value);
    }
    /// ditto
    public XVisualInfo * GetVisualFromFBConfig (Display* dpy, GLXFBConfig config) const {
        assert(_GetVisualFromFBConfig !is null, "GLX command glXGetVisualFromFBConfig was not loaded");
        return _GetVisualFromFBConfig (dpy, config);
    }
    /// ditto
    public GLXWindow CreateWindow (Display* dpy, GLXFBConfig config, Window win, const(int)* attrib_list) const {
        assert(_CreateWindow !is null, "GLX command glXCreateWindow was not loaded");
        return _CreateWindow (dpy, config, win, attrib_list);
    }
    /// ditto
    public void DestroyWindow (Display* dpy, GLXWindow win) const {
        assert(_DestroyWindow !is null, "GLX command glXDestroyWindow was not loaded");
        return _DestroyWindow (dpy, win);
    }
    /// ditto
    public GLXPixmap CreatePixmap (Display* dpy, GLXFBConfig config, Pixmap pixmap, const(int)* attrib_list) const {
        assert(_CreatePixmap !is null, "GLX command glXCreatePixmap was not loaded");
        return _CreatePixmap (dpy, config, pixmap, attrib_list);
    }
    /// ditto
    public void DestroyPixmap (Display* dpy, GLXPixmap pixmap) const {
        assert(_DestroyPixmap !is null, "GLX command glXDestroyPixmap was not loaded");
        return _DestroyPixmap (dpy, pixmap);
    }
    /// ditto
    public GLXPbuffer CreatePbuffer (Display* dpy, GLXFBConfig config, const(int)* attrib_list) const {
        assert(_CreatePbuffer !is null, "GLX command glXCreatePbuffer was not loaded");
        return _CreatePbuffer (dpy, config, attrib_list);
    }
    /// ditto
    public void DestroyPbuffer (Display* dpy, GLXPbuffer pbuf) const {
        assert(_DestroyPbuffer !is null, "GLX command glXDestroyPbuffer was not loaded");
        return _DestroyPbuffer (dpy, pbuf);
    }
    /// ditto
    public void QueryDrawable (Display* dpy, GLXDrawable draw, int attribute, uint* value) const {
        assert(_QueryDrawable !is null, "GLX command glXQueryDrawable was not loaded");
        return _QueryDrawable (dpy, draw, attribute, value);
    }
    /// ditto
    public GLXContext CreateNewContext (Display* dpy, GLXFBConfig config, int render_type, GLXContext share_list, Bool direct) const {
        assert(_CreateNewContext !is null, "GLX command glXCreateNewContext was not loaded");
        return _CreateNewContext (dpy, config, render_type, share_list, direct);
    }
    /// ditto
    public Bool MakeContextCurrent (Display* dpy, GLXDrawable draw, GLXDrawable read, GLXContext ctx) const {
        assert(_MakeContextCurrent !is null, "GLX command glXMakeContextCurrent was not loaded");
        return _MakeContextCurrent (dpy, draw, read, ctx);
    }
    /// ditto
    public GLXDrawable GetCurrentReadDrawable () const {
        assert(_GetCurrentReadDrawable !is null, "GLX command glXGetCurrentReadDrawable was not loaded");
        return _GetCurrentReadDrawable ();
    }
    /// ditto
    public int QueryContext (Display* dpy, GLXContext ctx, int attribute, int* value) const {
        assert(_QueryContext !is null, "GLX command glXQueryContext was not loaded");
        return _QueryContext (dpy, ctx, attribute, value);
    }
    /// ditto
    public void SelectEvent (Display* dpy, GLXDrawable draw, c_ulong event_mask) const {
        assert(_SelectEvent !is null, "GLX command glXSelectEvent was not loaded");
        return _SelectEvent (dpy, draw, event_mask);
    }
    /// ditto
    public void GetSelectedEvent (Display* dpy, GLXDrawable draw, c_ulong* event_mask) const {
        assert(_GetSelectedEvent !is null, "GLX command glXGetSelectedEvent was not loaded");
        return _GetSelectedEvent (dpy, draw, event_mask);
    }

    /// Commands for GLX_VERSION_1_4
    public __GLXextFuncPtr GetProcAddress (const(GLubyte)* procName) const {
        assert(_GetProcAddress !is null, "GLX command glXGetProcAddress was not loaded");
        return _GetProcAddress (procName);
    }

    /// Commands for GLX_ARB_create_context
    public GLXContext CreateContextAttribsARB (Display* dpy, GLXFBConfig config, GLXContext share_context, Bool direct, const(int)* attrib_list) const {
        assert(_CreateContextAttribsARB !is null, "GLX command glXCreateContextAttribsARB was not loaded");
        return _CreateContextAttribsARB (dpy, config, share_context, direct, attrib_list);
    }

    /// Commands for GLX_ARB_get_proc_address
    public __GLXextFuncPtr GetProcAddressARB (const(GLubyte)* procName) const {
        assert(_GetProcAddressARB !is null, "GLX command glXGetProcAddressARB was not loaded");
        return _GetProcAddressARB (procName);
    }

    /// Commands for GLX_AMD_gpu_association
    public uint GetGPUIDsAMD (uint maxCount, uint* ids) const {
        assert(_GetGPUIDsAMD !is null, "GLX command glXGetGPUIDsAMD was not loaded");
        return _GetGPUIDsAMD (maxCount, ids);
    }
    /// ditto
    public int GetGPUInfoAMD (uint id, int property, GLenum dataType, uint size, void* data) const {
        assert(_GetGPUInfoAMD !is null, "GLX command glXGetGPUInfoAMD was not loaded");
        return _GetGPUInfoAMD (id, property, dataType, size, data);
    }
    /// ditto
    public uint GetContextGPUIDAMD (GLXContext ctx) const {
        assert(_GetContextGPUIDAMD !is null, "GLX command glXGetContextGPUIDAMD was not loaded");
        return _GetContextGPUIDAMD (ctx);
    }
    /// ditto
    public GLXContext CreateAssociatedContextAMD (uint id, GLXContext share_list) const {
        assert(_CreateAssociatedContextAMD !is null, "GLX command glXCreateAssociatedContextAMD was not loaded");
        return _CreateAssociatedContextAMD (id, share_list);
    }
    /// ditto
    public GLXContext CreateAssociatedContextAttribsAMD (uint id, GLXContext share_context, const(int)* attribList) const {
        assert(_CreateAssociatedContextAttribsAMD !is null, "GLX command glXCreateAssociatedContextAttribsAMD was not loaded");
        return _CreateAssociatedContextAttribsAMD (id, share_context, attribList);
    }
    /// ditto
    public Bool DeleteAssociatedContextAMD (GLXContext ctx) const {
        assert(_DeleteAssociatedContextAMD !is null, "GLX command glXDeleteAssociatedContextAMD was not loaded");
        return _DeleteAssociatedContextAMD (ctx);
    }
    /// ditto
    public Bool MakeAssociatedContextCurrentAMD (GLXContext ctx) const {
        assert(_MakeAssociatedContextCurrentAMD !is null, "GLX command glXMakeAssociatedContextCurrentAMD was not loaded");
        return _MakeAssociatedContextCurrentAMD (ctx);
    }
    /// ditto
    public GLXContext GetCurrentAssociatedContextAMD () const {
        assert(_GetCurrentAssociatedContextAMD !is null, "GLX command glXGetCurrentAssociatedContextAMD was not loaded");
        return _GetCurrentAssociatedContextAMD ();
    }
    /// ditto
    public void BlitContextFramebufferAMD (GLXContext dstCtx, GLint srcX0, GLint srcY0, GLint srcX1, GLint srcY1, GLint dstX0, GLint dstY0, GLint dstX1, GLint dstY1, GLbitfield mask, GLenum filter) const {
        assert(_BlitContextFramebufferAMD !is null, "GLX command glXBlitContextFramebufferAMD was not loaded");
        return _BlitContextFramebufferAMD (dstCtx, srcX0, srcY0, srcX1, srcY1, dstX0, dstY0, dstX1, dstY1, mask, filter);
    }

    /// Commands for GLX_EXT_import_context
    public Display * GetCurrentDisplayEXT () const {
        assert(_GetCurrentDisplayEXT !is null, "GLX command glXGetCurrentDisplayEXT was not loaded");
        return _GetCurrentDisplayEXT ();
    }
    /// ditto
    public int QueryContextInfoEXT (Display* dpy, GLXContext context, int attribute, int* value) const {
        assert(_QueryContextInfoEXT !is null, "GLX command glXQueryContextInfoEXT was not loaded");
        return _QueryContextInfoEXT (dpy, context, attribute, value);
    }
    /// ditto
    public GLXContextID GetContextIDEXT (const GLXContext context) const {
        assert(_GetContextIDEXT !is null, "GLX command glXGetContextIDEXT was not loaded");
        return _GetContextIDEXT (context);
    }
    /// ditto
    public GLXContext ImportContextEXT (Display* dpy, GLXContextID contextID) const {
        assert(_ImportContextEXT !is null, "GLX command glXImportContextEXT was not loaded");
        return _ImportContextEXT (dpy, contextID);
    }
    /// ditto
    public void FreeContextEXT (Display* dpy, GLXContext context) const {
        assert(_FreeContextEXT !is null, "GLX command glXFreeContextEXT was not loaded");
        return _FreeContextEXT (dpy, context);
    }

    /// Commands for GLX_EXT_swap_control
    public void SwapIntervalEXT (Display* dpy, GLXDrawable drawable, int interval) const {
        assert(_SwapIntervalEXT !is null, "GLX command glXSwapIntervalEXT was not loaded");
        return _SwapIntervalEXT (dpy, drawable, interval);
    }

    /// Commands for GLX_EXT_texture_from_pixmap
    public void BindTexImageEXT (Display* dpy, GLXDrawable drawable, int buffer, const(int)* attrib_list) const {
        assert(_BindTexImageEXT !is null, "GLX command glXBindTexImageEXT was not loaded");
        return _BindTexImageEXT (dpy, drawable, buffer, attrib_list);
    }
    /// ditto
    public void ReleaseTexImageEXT (Display* dpy, GLXDrawable drawable, int buffer) const {
        assert(_ReleaseTexImageEXT !is null, "GLX command glXReleaseTexImageEXT was not loaded");
        return _ReleaseTexImageEXT (dpy, drawable, buffer);
    }

    /// Commands for GLX_MESA_agp_offset
    public uint GetAGPOffsetMESA (const(void)* pointer) const {
        assert(_GetAGPOffsetMESA !is null, "GLX command glXGetAGPOffsetMESA was not loaded");
        return _GetAGPOffsetMESA (pointer);
    }

    /// Commands for GLX_MESA_copy_sub_buffer
    public void CopySubBufferMESA (Display* dpy, GLXDrawable drawable, int x, int y, int width, int height) const {
        assert(_CopySubBufferMESA !is null, "GLX command glXCopySubBufferMESA was not loaded");
        return _CopySubBufferMESA (dpy, drawable, x, y, width, height);
    }

    /// Commands for GLX_MESA_pixmap_colormap
    public GLXPixmap CreateGLXPixmapMESA (Display* dpy, XVisualInfo* visual, Pixmap pixmap, Colormap cmap) const {
        assert(_CreateGLXPixmapMESA !is null, "GLX command glXCreateGLXPixmapMESA was not loaded");
        return _CreateGLXPixmapMESA (dpy, visual, pixmap, cmap);
    }

    /// Commands for GLX_MESA_query_renderer
    public Bool QueryCurrentRendererIntegerMESA (int attribute, uint* value) const {
        assert(_QueryCurrentRendererIntegerMESA !is null, "GLX command glXQueryCurrentRendererIntegerMESA was not loaded");
        return _QueryCurrentRendererIntegerMESA (attribute, value);
    }
    /// ditto
    public const(char)* QueryCurrentRendererStringMESA (int attribute) const {
        assert(_QueryCurrentRendererStringMESA !is null, "GLX command glXQueryCurrentRendererStringMESA was not loaded");
        return _QueryCurrentRendererStringMESA (attribute);
    }
    /// ditto
    public Bool QueryRendererIntegerMESA (Display* dpy, int screen, int renderer, int attribute, uint* value) const {
        assert(_QueryRendererIntegerMESA !is null, "GLX command glXQueryRendererIntegerMESA was not loaded");
        return _QueryRendererIntegerMESA (dpy, screen, renderer, attribute, value);
    }
    /// ditto
    public const(char)* QueryRendererStringMESA (Display* dpy, int screen, int renderer, int attribute) const {
        assert(_QueryRendererStringMESA !is null, "GLX command glXQueryRendererStringMESA was not loaded");
        return _QueryRendererStringMESA (dpy, screen, renderer, attribute);
    }

    /// Commands for GLX_MESA_release_buffers
    public Bool ReleaseBuffersMESA (Display* dpy, GLXDrawable drawable) const {
        assert(_ReleaseBuffersMESA !is null, "GLX command glXReleaseBuffersMESA was not loaded");
        return _ReleaseBuffersMESA (dpy, drawable);
    }

    /// Commands for GLX_MESA_set_3dfx_mode
    public Bool Set3DfxModeMESA (int mode) const {
        assert(_Set3DfxModeMESA !is null, "GLX command glXSet3DfxModeMESA was not loaded");
        return _Set3DfxModeMESA (mode);
    }

    /// Commands for GLX_MESA_swap_control
    public int GetSwapIntervalMESA () const {
        assert(_GetSwapIntervalMESA !is null, "GLX command glXGetSwapIntervalMESA was not loaded");
        return _GetSwapIntervalMESA ();
    }
    /// ditto
    public int SwapIntervalMESA (uint interval) const {
        assert(_SwapIntervalMESA !is null, "GLX command glXSwapIntervalMESA was not loaded");
        return _SwapIntervalMESA (interval);
    }

    /// Commands for GLX_NV_copy_buffer
    public void CopyBufferSubDataNV (Display* dpy, GLXContext readCtx, GLXContext writeCtx, GLenum readTarget, GLenum writeTarget, GLintptr readOffset, GLintptr writeOffset, GLsizeiptr size) const {
        assert(_CopyBufferSubDataNV !is null, "GLX command glXCopyBufferSubDataNV was not loaded");
        return _CopyBufferSubDataNV (dpy, readCtx, writeCtx, readTarget, writeTarget, readOffset, writeOffset, size);
    }
    /// ditto
    public void NamedCopyBufferSubDataNV (Display* dpy, GLXContext readCtx, GLXContext writeCtx, GLuint readBuffer, GLuint writeBuffer, GLintptr readOffset, GLintptr writeOffset, GLsizeiptr size) const {
        assert(_NamedCopyBufferSubDataNV !is null, "GLX command glXNamedCopyBufferSubDataNV was not loaded");
        return _NamedCopyBufferSubDataNV (dpy, readCtx, writeCtx, readBuffer, writeBuffer, readOffset, writeOffset, size);
    }

    /// Commands for GLX_NV_copy_image
    public void CopyImageSubDataNV (Display* dpy, GLXContext srcCtx, GLuint srcName, GLenum srcTarget, GLint srcLevel, GLint srcX, GLint srcY, GLint srcZ, GLXContext dstCtx, GLuint dstName, GLenum dstTarget, GLint dstLevel, GLint dstX, GLint dstY, GLint dstZ, GLsizei width, GLsizei height, GLsizei depth) const {
        assert(_CopyImageSubDataNV !is null, "GLX command glXCopyImageSubDataNV was not loaded");
        return _CopyImageSubDataNV (dpy, srcCtx, srcName, srcTarget, srcLevel, srcX, srcY, srcZ, dstCtx, dstName, dstTarget, dstLevel, dstX, dstY, dstZ, width, height, depth);
    }

    /// Commands for GLX_NV_delay_before_swap
    public Bool DelayBeforeSwapNV (Display* dpy, GLXDrawable drawable, GLfloat seconds) const {
        assert(_DelayBeforeSwapNV !is null, "GLX command glXDelayBeforeSwapNV was not loaded");
        return _DelayBeforeSwapNV (dpy, drawable, seconds);
    }

    /// Commands for GLX_NV_present_video
    public uint * EnumerateVideoDevicesNV (Display* dpy, int screen, int* nelements) const {
        assert(_EnumerateVideoDevicesNV !is null, "GLX command glXEnumerateVideoDevicesNV was not loaded");
        return _EnumerateVideoDevicesNV (dpy, screen, nelements);
    }
    /// ditto
    public int BindVideoDeviceNV (Display* dpy, uint video_slot, uint video_device, const(int)* attrib_list) const {
        assert(_BindVideoDeviceNV !is null, "GLX command glXBindVideoDeviceNV was not loaded");
        return _BindVideoDeviceNV (dpy, video_slot, video_device, attrib_list);
    }

    /// Commands for GLX_NV_swap_group
    public Bool JoinSwapGroupNV (Display* dpy, GLXDrawable drawable, GLuint group) const {
        assert(_JoinSwapGroupNV !is null, "GLX command glXJoinSwapGroupNV was not loaded");
        return _JoinSwapGroupNV (dpy, drawable, group);
    }
    /// ditto
    public Bool BindSwapBarrierNV (Display* dpy, GLuint group, GLuint barrier) const {
        assert(_BindSwapBarrierNV !is null, "GLX command glXBindSwapBarrierNV was not loaded");
        return _BindSwapBarrierNV (dpy, group, barrier);
    }
    /// ditto
    public Bool QuerySwapGroupNV (Display* dpy, GLXDrawable drawable, GLuint* group, GLuint* barrier) const {
        assert(_QuerySwapGroupNV !is null, "GLX command glXQuerySwapGroupNV was not loaded");
        return _QuerySwapGroupNV (dpy, drawable, group, barrier);
    }
    /// ditto
    public Bool QueryMaxSwapGroupsNV (Display* dpy, int screen, GLuint* maxGroups, GLuint* maxBarriers) const {
        assert(_QueryMaxSwapGroupsNV !is null, "GLX command glXQueryMaxSwapGroupsNV was not loaded");
        return _QueryMaxSwapGroupsNV (dpy, screen, maxGroups, maxBarriers);
    }
    /// ditto
    public Bool QueryFrameCountNV (Display* dpy, int screen, GLuint* count) const {
        assert(_QueryFrameCountNV !is null, "GLX command glXQueryFrameCountNV was not loaded");
        return _QueryFrameCountNV (dpy, screen, count);
    }
    /// ditto
    public Bool ResetFrameCountNV (Display* dpy, int screen) const {
        assert(_ResetFrameCountNV !is null, "GLX command glXResetFrameCountNV was not loaded");
        return _ResetFrameCountNV (dpy, screen);
    }

    /// Commands for GLX_NV_video_capture
    public int BindVideoCaptureDeviceNV (Display* dpy, uint video_capture_slot, GLXVideoCaptureDeviceNV device) const {
        assert(_BindVideoCaptureDeviceNV !is null, "GLX command glXBindVideoCaptureDeviceNV was not loaded");
        return _BindVideoCaptureDeviceNV (dpy, video_capture_slot, device);
    }
    /// ditto
    public GLXVideoCaptureDeviceNV * EnumerateVideoCaptureDevicesNV (Display* dpy, int screen, int* nelements) const {
        assert(_EnumerateVideoCaptureDevicesNV !is null, "GLX command glXEnumerateVideoCaptureDevicesNV was not loaded");
        return _EnumerateVideoCaptureDevicesNV (dpy, screen, nelements);
    }
    /// ditto
    public void LockVideoCaptureDeviceNV (Display* dpy, GLXVideoCaptureDeviceNV device) const {
        assert(_LockVideoCaptureDeviceNV !is null, "GLX command glXLockVideoCaptureDeviceNV was not loaded");
        return _LockVideoCaptureDeviceNV (dpy, device);
    }
    /// ditto
    public int QueryVideoCaptureDeviceNV (Display* dpy, GLXVideoCaptureDeviceNV device, int attribute, int* value) const {
        assert(_QueryVideoCaptureDeviceNV !is null, "GLX command glXQueryVideoCaptureDeviceNV was not loaded");
        return _QueryVideoCaptureDeviceNV (dpy, device, attribute, value);
    }
    /// ditto
    public void ReleaseVideoCaptureDeviceNV (Display* dpy, GLXVideoCaptureDeviceNV device) const {
        assert(_ReleaseVideoCaptureDeviceNV !is null, "GLX command glXReleaseVideoCaptureDeviceNV was not loaded");
        return _ReleaseVideoCaptureDeviceNV (dpy, device);
    }

    /// Commands for GLX_NV_video_out
    public int GetVideoDeviceNV (Display* dpy, int screen, int numVideoDevices, GLXVideoDeviceNV* pVideoDevice) const {
        assert(_GetVideoDeviceNV !is null, "GLX command glXGetVideoDeviceNV was not loaded");
        return _GetVideoDeviceNV (dpy, screen, numVideoDevices, pVideoDevice);
    }
    /// ditto
    public int ReleaseVideoDeviceNV (Display* dpy, int screen, GLXVideoDeviceNV VideoDevice) const {
        assert(_ReleaseVideoDeviceNV !is null, "GLX command glXReleaseVideoDeviceNV was not loaded");
        return _ReleaseVideoDeviceNV (dpy, screen, VideoDevice);
    }
    /// ditto
    public int BindVideoImageNV (Display* dpy, GLXVideoDeviceNV VideoDevice, GLXPbuffer pbuf, int iVideoBuffer) const {
        assert(_BindVideoImageNV !is null, "GLX command glXBindVideoImageNV was not loaded");
        return _BindVideoImageNV (dpy, VideoDevice, pbuf, iVideoBuffer);
    }
    /// ditto
    public int ReleaseVideoImageNV (Display* dpy, GLXPbuffer pbuf) const {
        assert(_ReleaseVideoImageNV !is null, "GLX command glXReleaseVideoImageNV was not loaded");
        return _ReleaseVideoImageNV (dpy, pbuf);
    }
    /// ditto
    public int SendPbufferToVideoNV (Display* dpy, GLXPbuffer pbuf, int iBufferType, c_ulong* pulCounterPbuffer, GLboolean bBlock) const {
        assert(_SendPbufferToVideoNV !is null, "GLX command glXSendPbufferToVideoNV was not loaded");
        return _SendPbufferToVideoNV (dpy, pbuf, iBufferType, pulCounterPbuffer, bBlock);
    }
    /// ditto
    public int GetVideoInfoNV (Display* dpy, int screen, GLXVideoDeviceNV VideoDevice, c_ulong* pulCounterOutputPbuffer, c_ulong* pulCounterOutputVideo) const {
        assert(_GetVideoInfoNV !is null, "GLX command glXGetVideoInfoNV was not loaded");
        return _GetVideoInfoNV (dpy, screen, VideoDevice, pulCounterOutputPbuffer, pulCounterOutputVideo);
    }

    /// Commands for GLX_OML_sync_control
    public Bool GetSyncValuesOML (Display* dpy, GLXDrawable drawable, int64_t* ust, int64_t* msc, int64_t* sbc) const {
        assert(_GetSyncValuesOML !is null, "GLX command glXGetSyncValuesOML was not loaded");
        return _GetSyncValuesOML (dpy, drawable, ust, msc, sbc);
    }
    /// ditto
    public Bool GetMscRateOML (Display* dpy, GLXDrawable drawable, int32_t* numerator, int32_t* denominator) const {
        assert(_GetMscRateOML !is null, "GLX command glXGetMscRateOML was not loaded");
        return _GetMscRateOML (dpy, drawable, numerator, denominator);
    }
    /// ditto
    public int64_t SwapBuffersMscOML (Display* dpy, GLXDrawable drawable, int64_t target_msc, int64_t divisor, int64_t remainder) const {
        assert(_SwapBuffersMscOML !is null, "GLX command glXSwapBuffersMscOML was not loaded");
        return _SwapBuffersMscOML (dpy, drawable, target_msc, divisor, remainder);
    }
    /// ditto
    public Bool WaitForMscOML (Display* dpy, GLXDrawable drawable, int64_t target_msc, int64_t divisor, int64_t remainder, int64_t* ust, int64_t* msc, int64_t* sbc) const {
        assert(_WaitForMscOML !is null, "GLX command glXWaitForMscOML was not loaded");
        return _WaitForMscOML (dpy, drawable, target_msc, divisor, remainder, ust, msc, sbc);
    }
    /// ditto
    public Bool WaitForSbcOML (Display* dpy, GLXDrawable drawable, int64_t target_sbc, int64_t* ust, int64_t* msc, int64_t* sbc) const {
        assert(_WaitForSbcOML !is null, "GLX command glXWaitForSbcOML was not loaded");
        return _WaitForSbcOML (dpy, drawable, target_sbc, ust, msc, sbc);
    }

    /// Commands for GLX_SGIX_fbconfig
    public int GetFBConfigAttribSGIX (Display* dpy, GLXFBConfigSGIX config, int attribute, int* value) const {
        assert(_GetFBConfigAttribSGIX !is null, "GLX command glXGetFBConfigAttribSGIX was not loaded");
        return _GetFBConfigAttribSGIX (dpy, config, attribute, value);
    }
    /// ditto
    public GLXFBConfigSGIX * ChooseFBConfigSGIX (Display* dpy, int screen, int* attrib_list, int* nelements) const {
        assert(_ChooseFBConfigSGIX !is null, "GLX command glXChooseFBConfigSGIX was not loaded");
        return _ChooseFBConfigSGIX (dpy, screen, attrib_list, nelements);
    }
    /// ditto
    public GLXPixmap CreateGLXPixmapWithConfigSGIX (Display* dpy, GLXFBConfigSGIX config, Pixmap pixmap) const {
        assert(_CreateGLXPixmapWithConfigSGIX !is null, "GLX command glXCreateGLXPixmapWithConfigSGIX was not loaded");
        return _CreateGLXPixmapWithConfigSGIX (dpy, config, pixmap);
    }
    /// ditto
    public GLXContext CreateContextWithConfigSGIX (Display* dpy, GLXFBConfigSGIX config, int render_type, GLXContext share_list, Bool direct) const {
        assert(_CreateContextWithConfigSGIX !is null, "GLX command glXCreateContextWithConfigSGIX was not loaded");
        return _CreateContextWithConfigSGIX (dpy, config, render_type, share_list, direct);
    }
    /// ditto
    public XVisualInfo * GetVisualFromFBConfigSGIX (Display* dpy, GLXFBConfigSGIX config) const {
        assert(_GetVisualFromFBConfigSGIX !is null, "GLX command glXGetVisualFromFBConfigSGIX was not loaded");
        return _GetVisualFromFBConfigSGIX (dpy, config);
    }
    /// ditto
    public GLXFBConfigSGIX GetFBConfigFromVisualSGIX (Display* dpy, XVisualInfo* vis) const {
        assert(_GetFBConfigFromVisualSGIX !is null, "GLX command glXGetFBConfigFromVisualSGIX was not loaded");
        return _GetFBConfigFromVisualSGIX (dpy, vis);
    }

    /// Commands for GLX_SGIX_hyperpipe
    public GLXHyperpipeNetworkSGIX * QueryHyperpipeNetworkSGIX (Display* dpy, int* npipes) const {
        assert(_QueryHyperpipeNetworkSGIX !is null, "GLX command glXQueryHyperpipeNetworkSGIX was not loaded");
        return _QueryHyperpipeNetworkSGIX (dpy, npipes);
    }
    /// ditto
    public int HyperpipeConfigSGIX (Display* dpy, int networkId, int npipes, GLXHyperpipeConfigSGIX* cfg, int* hpId) const {
        assert(_HyperpipeConfigSGIX !is null, "GLX command glXHyperpipeConfigSGIX was not loaded");
        return _HyperpipeConfigSGIX (dpy, networkId, npipes, cfg, hpId);
    }
    /// ditto
    public GLXHyperpipeConfigSGIX * QueryHyperpipeConfigSGIX (Display* dpy, int hpId, int* npipes) const {
        assert(_QueryHyperpipeConfigSGIX !is null, "GLX command glXQueryHyperpipeConfigSGIX was not loaded");
        return _QueryHyperpipeConfigSGIX (dpy, hpId, npipes);
    }
    /// ditto
    public int DestroyHyperpipeConfigSGIX (Display* dpy, int hpId) const {
        assert(_DestroyHyperpipeConfigSGIX !is null, "GLX command glXDestroyHyperpipeConfigSGIX was not loaded");
        return _DestroyHyperpipeConfigSGIX (dpy, hpId);
    }
    /// ditto
    public int BindHyperpipeSGIX (Display* dpy, int hpId) const {
        assert(_BindHyperpipeSGIX !is null, "GLX command glXBindHyperpipeSGIX was not loaded");
        return _BindHyperpipeSGIX (dpy, hpId);
    }
    /// ditto
    public int QueryHyperpipeBestAttribSGIX (Display* dpy, int timeSlice, int attrib, int size, void* attribList, void* returnAttribList) const {
        assert(_QueryHyperpipeBestAttribSGIX !is null, "GLX command glXQueryHyperpipeBestAttribSGIX was not loaded");
        return _QueryHyperpipeBestAttribSGIX (dpy, timeSlice, attrib, size, attribList, returnAttribList);
    }
    /// ditto
    public int HyperpipeAttribSGIX (Display* dpy, int timeSlice, int attrib, int size, void* attribList) const {
        assert(_HyperpipeAttribSGIX !is null, "GLX command glXHyperpipeAttribSGIX was not loaded");
        return _HyperpipeAttribSGIX (dpy, timeSlice, attrib, size, attribList);
    }
    /// ditto
    public int QueryHyperpipeAttribSGIX (Display* dpy, int timeSlice, int attrib, int size, void* returnAttribList) const {
        assert(_QueryHyperpipeAttribSGIX !is null, "GLX command glXQueryHyperpipeAttribSGIX was not loaded");
        return _QueryHyperpipeAttribSGIX (dpy, timeSlice, attrib, size, returnAttribList);
    }

    /// Commands for GLX_SGIX_pbuffer
    public GLXPbufferSGIX CreateGLXPbufferSGIX (Display* dpy, GLXFBConfigSGIX config, uint width, uint height, int* attrib_list) const {
        assert(_CreateGLXPbufferSGIX !is null, "GLX command glXCreateGLXPbufferSGIX was not loaded");
        return _CreateGLXPbufferSGIX (dpy, config, width, height, attrib_list);
    }
    /// ditto
    public void DestroyGLXPbufferSGIX (Display* dpy, GLXPbufferSGIX pbuf) const {
        assert(_DestroyGLXPbufferSGIX !is null, "GLX command glXDestroyGLXPbufferSGIX was not loaded");
        return _DestroyGLXPbufferSGIX (dpy, pbuf);
    }
    /// ditto
    public int QueryGLXPbufferSGIX (Display* dpy, GLXPbufferSGIX pbuf, int attribute, uint* value) const {
        assert(_QueryGLXPbufferSGIX !is null, "GLX command glXQueryGLXPbufferSGIX was not loaded");
        return _QueryGLXPbufferSGIX (dpy, pbuf, attribute, value);
    }
    /// ditto
    public void SelectEventSGIX (Display* dpy, GLXDrawable drawable, c_ulong mask) const {
        assert(_SelectEventSGIX !is null, "GLX command glXSelectEventSGIX was not loaded");
        return _SelectEventSGIX (dpy, drawable, mask);
    }
    /// ditto
    public void GetSelectedEventSGIX (Display* dpy, GLXDrawable drawable, c_ulong* mask) const {
        assert(_GetSelectedEventSGIX !is null, "GLX command glXGetSelectedEventSGIX was not loaded");
        return _GetSelectedEventSGIX (dpy, drawable, mask);
    }

    /// Commands for GLX_SGIX_swap_barrier
    public void BindSwapBarrierSGIX (Display* dpy, GLXDrawable drawable, int barrier) const {
        assert(_BindSwapBarrierSGIX !is null, "GLX command glXBindSwapBarrierSGIX was not loaded");
        return _BindSwapBarrierSGIX (dpy, drawable, barrier);
    }
    /// ditto
    public Bool QueryMaxSwapBarriersSGIX (Display* dpy, int screen, int* max) const {
        assert(_QueryMaxSwapBarriersSGIX !is null, "GLX command glXQueryMaxSwapBarriersSGIX was not loaded");
        return _QueryMaxSwapBarriersSGIX (dpy, screen, max);
    }

    /// Commands for GLX_SGIX_swap_group
    public void JoinSwapGroupSGIX (Display* dpy, GLXDrawable drawable, GLXDrawable member) const {
        assert(_JoinSwapGroupSGIX !is null, "GLX command glXJoinSwapGroupSGIX was not loaded");
        return _JoinSwapGroupSGIX (dpy, drawable, member);
    }

    /// Commands for GLX_SGIX_video_resize
    public int BindChannelToWindowSGIX (Display* display, int screen, int channel, Window window) const {
        assert(_BindChannelToWindowSGIX !is null, "GLX command glXBindChannelToWindowSGIX was not loaded");
        return _BindChannelToWindowSGIX (display, screen, channel, window);
    }
    /// ditto
    public int ChannelRectSGIX (Display* display, int screen, int channel, int x, int y, int w, int h) const {
        assert(_ChannelRectSGIX !is null, "GLX command glXChannelRectSGIX was not loaded");
        return _ChannelRectSGIX (display, screen, channel, x, y, w, h);
    }
    /// ditto
    public int QueryChannelRectSGIX (Display* display, int screen, int channel, int* dx, int* dy, int* dw, int* dh) const {
        assert(_QueryChannelRectSGIX !is null, "GLX command glXQueryChannelRectSGIX was not loaded");
        return _QueryChannelRectSGIX (display, screen, channel, dx, dy, dw, dh);
    }
    /// ditto
    public int QueryChannelDeltasSGIX (Display* display, int screen, int channel, int* x, int* y, int* w, int* h) const {
        assert(_QueryChannelDeltasSGIX !is null, "GLX command glXQueryChannelDeltasSGIX was not loaded");
        return _QueryChannelDeltasSGIX (display, screen, channel, x, y, w, h);
    }
    /// ditto
    public int ChannelRectSyncSGIX (Display* display, int screen, int channel, GLenum synctype) const {
        assert(_ChannelRectSyncSGIX !is null, "GLX command glXChannelRectSyncSGIX was not loaded");
        return _ChannelRectSyncSGIX (display, screen, channel, synctype);
    }

    /// Commands for GLX_SGI_cushion
    public void CushionSGI (Display* dpy, Window window, float cushion) const {
        assert(_CushionSGI !is null, "GLX command glXCushionSGI was not loaded");
        return _CushionSGI (dpy, window, cushion);
    }

    /// Commands for GLX_SGI_make_current_read
    public Bool MakeCurrentReadSGI (Display* dpy, GLXDrawable draw, GLXDrawable read, GLXContext ctx) const {
        assert(_MakeCurrentReadSGI !is null, "GLX command glXMakeCurrentReadSGI was not loaded");
        return _MakeCurrentReadSGI (dpy, draw, read, ctx);
    }
    /// ditto
    public GLXDrawable GetCurrentReadDrawableSGI () const {
        assert(_GetCurrentReadDrawableSGI !is null, "GLX command glXGetCurrentReadDrawableSGI was not loaded");
        return _GetCurrentReadDrawableSGI ();
    }

    /// Commands for GLX_SGI_swap_control
    public int SwapIntervalSGI (int interval) const {
        assert(_SwapIntervalSGI !is null, "GLX command glXSwapIntervalSGI was not loaded");
        return _SwapIntervalSGI (interval);
    }

    /// Commands for GLX_SGI_video_sync
    public int GetVideoSyncSGI (uint* count) const {
        assert(_GetVideoSyncSGI !is null, "GLX command glXGetVideoSyncSGI was not loaded");
        return _GetVideoSyncSGI (count);
    }
    /// ditto
    public int WaitVideoSyncSGI (int divisor, int remainder, uint* count) const {
        assert(_WaitVideoSyncSGI !is null, "GLX command glXWaitVideoSyncSGI was not loaded");
        return _WaitVideoSyncSGI (divisor, remainder, count);
    }

    /// Commands for GLX_SUN_get_transparent_index
    public Status GetTransparentIndexSUN (Display* dpy, Window overlay, Window underlay, long* pTransparentIndex) const {
        assert(_GetTransparentIndexSUN !is null, "GLX command glXGetTransparentIndexSUN was not loaded");
        return _GetTransparentIndexSUN (dpy, overlay, underlay, pTransparentIndex);
    }

    // GLX_VERSION_1_0
    private PFN_glXChooseVisual _ChooseVisual;
    private PFN_glXCreateContext _CreateContext;
    private PFN_glXDestroyContext _DestroyContext;
    private PFN_glXMakeCurrent _MakeCurrent;
    private PFN_glXCopyContext _CopyContext;
    private PFN_glXSwapBuffers _SwapBuffers;
    private PFN_glXCreateGLXPixmap _CreateGLXPixmap;
    private PFN_glXDestroyGLXPixmap _DestroyGLXPixmap;
    private PFN_glXQueryExtension _QueryExtension;
    private PFN_glXQueryVersion _QueryVersion;
    private PFN_glXIsDirect _IsDirect;
    private PFN_glXGetConfig _GetConfig;
    private PFN_glXGetCurrentContext _GetCurrentContext;
    private PFN_glXGetCurrentDrawable _GetCurrentDrawable;
    private PFN_glXWaitGL _WaitGL;
    private PFN_glXWaitX _WaitX;
    private PFN_glXUseXFont _UseXFont;

    // GLX_VERSION_1_1
    private PFN_glXQueryExtensionsString _QueryExtensionsString;
    private PFN_glXQueryServerString _QueryServerString;
    private PFN_glXGetClientString _GetClientString;

    // GLX_VERSION_1_2
    private PFN_glXGetCurrentDisplay _GetCurrentDisplay;

    // GLX_VERSION_1_3
    private PFN_glXGetFBConfigs _GetFBConfigs;
    private PFN_glXChooseFBConfig _ChooseFBConfig;
    private PFN_glXGetFBConfigAttrib _GetFBConfigAttrib;
    private PFN_glXGetVisualFromFBConfig _GetVisualFromFBConfig;
    private PFN_glXCreateWindow _CreateWindow;
    private PFN_glXDestroyWindow _DestroyWindow;
    private PFN_glXCreatePixmap _CreatePixmap;
    private PFN_glXDestroyPixmap _DestroyPixmap;
    private PFN_glXCreatePbuffer _CreatePbuffer;
    private PFN_glXDestroyPbuffer _DestroyPbuffer;
    private PFN_glXQueryDrawable _QueryDrawable;
    private PFN_glXCreateNewContext _CreateNewContext;
    private PFN_glXMakeContextCurrent _MakeContextCurrent;
    private PFN_glXGetCurrentReadDrawable _GetCurrentReadDrawable;
    private PFN_glXQueryContext _QueryContext;
    private PFN_glXSelectEvent _SelectEvent;
    private PFN_glXGetSelectedEvent _GetSelectedEvent;

    // GLX_VERSION_1_4
    private PFN_glXGetProcAddress _GetProcAddress;

    // GLX_ARB_create_context,
    private PFN_glXCreateContextAttribsARB _CreateContextAttribsARB;

    // GLX_ARB_get_proc_address,
    private PFN_glXGetProcAddressARB _GetProcAddressARB;

    // GLX_AMD_gpu_association,
    private PFN_glXGetGPUIDsAMD _GetGPUIDsAMD;
    private PFN_glXGetGPUInfoAMD _GetGPUInfoAMD;
    private PFN_glXGetContextGPUIDAMD _GetContextGPUIDAMD;
    private PFN_glXCreateAssociatedContextAMD _CreateAssociatedContextAMD;
    private PFN_glXCreateAssociatedContextAttribsAMD _CreateAssociatedContextAttribsAMD;
    private PFN_glXDeleteAssociatedContextAMD _DeleteAssociatedContextAMD;
    private PFN_glXMakeAssociatedContextCurrentAMD _MakeAssociatedContextCurrentAMD;
    private PFN_glXGetCurrentAssociatedContextAMD _GetCurrentAssociatedContextAMD;
    private PFN_glXBlitContextFramebufferAMD _BlitContextFramebufferAMD;

    // GLX_EXT_import_context,
    private PFN_glXGetCurrentDisplayEXT _GetCurrentDisplayEXT;
    private PFN_glXQueryContextInfoEXT _QueryContextInfoEXT;
    private PFN_glXGetContextIDEXT _GetContextIDEXT;
    private PFN_glXImportContextEXT _ImportContextEXT;
    private PFN_glXFreeContextEXT _FreeContextEXT;

    // GLX_EXT_swap_control,
    private PFN_glXSwapIntervalEXT _SwapIntervalEXT;

    // GLX_EXT_texture_from_pixmap,
    private PFN_glXBindTexImageEXT _BindTexImageEXT;
    private PFN_glXReleaseTexImageEXT _ReleaseTexImageEXT;

    // GLX_MESA_agp_offset,
    private PFN_glXGetAGPOffsetMESA _GetAGPOffsetMESA;

    // GLX_MESA_copy_sub_buffer,
    private PFN_glXCopySubBufferMESA _CopySubBufferMESA;

    // GLX_MESA_pixmap_colormap,
    private PFN_glXCreateGLXPixmapMESA _CreateGLXPixmapMESA;

    // GLX_MESA_query_renderer,
    private PFN_glXQueryCurrentRendererIntegerMESA _QueryCurrentRendererIntegerMESA;
    private PFN_glXQueryCurrentRendererStringMESA _QueryCurrentRendererStringMESA;
    private PFN_glXQueryRendererIntegerMESA _QueryRendererIntegerMESA;
    private PFN_glXQueryRendererStringMESA _QueryRendererStringMESA;

    // GLX_MESA_release_buffers,
    private PFN_glXReleaseBuffersMESA _ReleaseBuffersMESA;

    // GLX_MESA_set_3dfx_mode,
    private PFN_glXSet3DfxModeMESA _Set3DfxModeMESA;

    // GLX_MESA_swap_control,
    private PFN_glXGetSwapIntervalMESA _GetSwapIntervalMESA;
    private PFN_glXSwapIntervalMESA _SwapIntervalMESA;

    // GLX_NV_copy_buffer,
    private PFN_glXCopyBufferSubDataNV _CopyBufferSubDataNV;
    private PFN_glXNamedCopyBufferSubDataNV _NamedCopyBufferSubDataNV;

    // GLX_NV_copy_image,
    private PFN_glXCopyImageSubDataNV _CopyImageSubDataNV;

    // GLX_NV_delay_before_swap,
    private PFN_glXDelayBeforeSwapNV _DelayBeforeSwapNV;

    // GLX_NV_present_video,
    private PFN_glXEnumerateVideoDevicesNV _EnumerateVideoDevicesNV;
    private PFN_glXBindVideoDeviceNV _BindVideoDeviceNV;

    // GLX_NV_swap_group,
    private PFN_glXJoinSwapGroupNV _JoinSwapGroupNV;
    private PFN_glXBindSwapBarrierNV _BindSwapBarrierNV;
    private PFN_glXQuerySwapGroupNV _QuerySwapGroupNV;
    private PFN_glXQueryMaxSwapGroupsNV _QueryMaxSwapGroupsNV;
    private PFN_glXQueryFrameCountNV _QueryFrameCountNV;
    private PFN_glXResetFrameCountNV _ResetFrameCountNV;

    // GLX_NV_video_capture,
    private PFN_glXBindVideoCaptureDeviceNV _BindVideoCaptureDeviceNV;
    private PFN_glXEnumerateVideoCaptureDevicesNV _EnumerateVideoCaptureDevicesNV;
    private PFN_glXLockVideoCaptureDeviceNV _LockVideoCaptureDeviceNV;
    private PFN_glXQueryVideoCaptureDeviceNV _QueryVideoCaptureDeviceNV;
    private PFN_glXReleaseVideoCaptureDeviceNV _ReleaseVideoCaptureDeviceNV;

    // GLX_NV_video_out,
    private PFN_glXGetVideoDeviceNV _GetVideoDeviceNV;
    private PFN_glXReleaseVideoDeviceNV _ReleaseVideoDeviceNV;
    private PFN_glXBindVideoImageNV _BindVideoImageNV;
    private PFN_glXReleaseVideoImageNV _ReleaseVideoImageNV;
    private PFN_glXSendPbufferToVideoNV _SendPbufferToVideoNV;
    private PFN_glXGetVideoInfoNV _GetVideoInfoNV;

    // GLX_OML_sync_control,
    private PFN_glXGetSyncValuesOML _GetSyncValuesOML;
    private PFN_glXGetMscRateOML _GetMscRateOML;
    private PFN_glXSwapBuffersMscOML _SwapBuffersMscOML;
    private PFN_glXWaitForMscOML _WaitForMscOML;
    private PFN_glXWaitForSbcOML _WaitForSbcOML;

    // GLX_SGIX_fbconfig,
    private PFN_glXGetFBConfigAttribSGIX _GetFBConfigAttribSGIX;
    private PFN_glXChooseFBConfigSGIX _ChooseFBConfigSGIX;
    private PFN_glXCreateGLXPixmapWithConfigSGIX _CreateGLXPixmapWithConfigSGIX;
    private PFN_glXCreateContextWithConfigSGIX _CreateContextWithConfigSGIX;
    private PFN_glXGetVisualFromFBConfigSGIX _GetVisualFromFBConfigSGIX;
    private PFN_glXGetFBConfigFromVisualSGIX _GetFBConfigFromVisualSGIX;

    // GLX_SGIX_hyperpipe,
    private PFN_glXQueryHyperpipeNetworkSGIX _QueryHyperpipeNetworkSGIX;
    private PFN_glXHyperpipeConfigSGIX _HyperpipeConfigSGIX;
    private PFN_glXQueryHyperpipeConfigSGIX _QueryHyperpipeConfigSGIX;
    private PFN_glXDestroyHyperpipeConfigSGIX _DestroyHyperpipeConfigSGIX;
    private PFN_glXBindHyperpipeSGIX _BindHyperpipeSGIX;
    private PFN_glXQueryHyperpipeBestAttribSGIX _QueryHyperpipeBestAttribSGIX;
    private PFN_glXHyperpipeAttribSGIX _HyperpipeAttribSGIX;
    private PFN_glXQueryHyperpipeAttribSGIX _QueryHyperpipeAttribSGIX;

    // GLX_SGIX_pbuffer,
    private PFN_glXCreateGLXPbufferSGIX _CreateGLXPbufferSGIX;
    private PFN_glXDestroyGLXPbufferSGIX _DestroyGLXPbufferSGIX;
    private PFN_glXQueryGLXPbufferSGIX _QueryGLXPbufferSGIX;
    private PFN_glXSelectEventSGIX _SelectEventSGIX;
    private PFN_glXGetSelectedEventSGIX _GetSelectedEventSGIX;

    // GLX_SGIX_swap_barrier,
    private PFN_glXBindSwapBarrierSGIX _BindSwapBarrierSGIX;
    private PFN_glXQueryMaxSwapBarriersSGIX _QueryMaxSwapBarriersSGIX;

    // GLX_SGIX_swap_group,
    private PFN_glXJoinSwapGroupSGIX _JoinSwapGroupSGIX;

    // GLX_SGIX_video_resize,
    private PFN_glXBindChannelToWindowSGIX _BindChannelToWindowSGIX;
    private PFN_glXChannelRectSGIX _ChannelRectSGIX;
    private PFN_glXQueryChannelRectSGIX _QueryChannelRectSGIX;
    private PFN_glXQueryChannelDeltasSGIX _QueryChannelDeltasSGIX;
    private PFN_glXChannelRectSyncSGIX _ChannelRectSyncSGIX;

    // GLX_SGI_cushion,
    private PFN_glXCushionSGI _CushionSGI;

    // GLX_SGI_make_current_read,
    private PFN_glXMakeCurrentReadSGI _MakeCurrentReadSGI;
    private PFN_glXGetCurrentReadDrawableSGI _GetCurrentReadDrawableSGI;

    // GLX_SGI_swap_control,
    private PFN_glXSwapIntervalSGI _SwapIntervalSGI;

    // GLX_SGI_video_sync,
    private PFN_glXGetVideoSyncSGI _GetVideoSyncSGI;
    private PFN_glXWaitVideoSyncSGI _WaitVideoSyncSGI;

    // GLX_SUN_get_transparent_index,
    private PFN_glXGetTransparentIndexSUN _GetTransparentIndexSUN;
}
