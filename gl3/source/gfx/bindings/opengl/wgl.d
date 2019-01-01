/// WinGL bindings for D. Generated automatically by gldgen.
/// See https://github.com/rtbo/gldgen
module gfx.bindings.opengl.wgl;

version(Windows):
import core.stdc.config : c_ulong;
import core.sys.windows.windef;
import core.sys.windows.wingdi;
import gfx.bindings.opengl.loader : SymbolLoader;
import gfx.bindings.opengl.gl;

// Base Types

// Types for WGL_NV_gpu_affinity
alias PGPU_DEVICE = _GPU_DEVICE*;

// Handle declarations
alias HPBUFFERARB = void*;
alias HPBUFFEREXT = void*;
alias HGPUNV = void*;
alias HVIDEOOUTPUTDEVICENV = void*;
alias HVIDEOINPUTDEVICENV = void*;
alias HPVIDEODEV = void*;

// Struct definitions
// Structs for WGL_NV_gpu_affinity
struct _GPU_DEVICE {
    DWORD cb;
    CHAR[32] DeviceName;
    CHAR[128] DeviceString;
    DWORD Flags;
    RECT rcVirtualScreen;
}


// Constants for WGL_VERSION_1_0
enum WGL_FONT_LINES      = 0;
enum WGL_FONT_POLYGONS   = 1;
enum WGL_SWAP_MAIN_PLANE = 0x00000001;
enum WGL_SWAP_OVERLAY1   = 0x00000002;
enum WGL_SWAP_OVERLAY2   = 0x00000004;
enum WGL_SWAP_OVERLAY3   = 0x00000008;
enum WGL_SWAP_OVERLAY4   = 0x00000010;
enum WGL_SWAP_OVERLAY5   = 0x00000020;
enum WGL_SWAP_OVERLAY6   = 0x00000040;
enum WGL_SWAP_OVERLAY7   = 0x00000080;
enum WGL_SWAP_OVERLAY8   = 0x00000100;
enum WGL_SWAP_OVERLAY9   = 0x00000200;
enum WGL_SWAP_OVERLAY10  = 0x00000400;
enum WGL_SWAP_OVERLAY11  = 0x00000800;
enum WGL_SWAP_OVERLAY12  = 0x00001000;
enum WGL_SWAP_OVERLAY13  = 0x00002000;
enum WGL_SWAP_OVERLAY14  = 0x00004000;
enum WGL_SWAP_OVERLAY15  = 0x00008000;
enum WGL_SWAP_UNDERLAY1  = 0x00010000;
enum WGL_SWAP_UNDERLAY2  = 0x00020000;
enum WGL_SWAP_UNDERLAY3  = 0x00040000;
enum WGL_SWAP_UNDERLAY4  = 0x00080000;
enum WGL_SWAP_UNDERLAY5  = 0x00100000;
enum WGL_SWAP_UNDERLAY6  = 0x00200000;
enum WGL_SWAP_UNDERLAY7  = 0x00400000;
enum WGL_SWAP_UNDERLAY8  = 0x00800000;
enum WGL_SWAP_UNDERLAY9  = 0x01000000;
enum WGL_SWAP_UNDERLAY10 = 0x02000000;
enum WGL_SWAP_UNDERLAY11 = 0x04000000;
enum WGL_SWAP_UNDERLAY12 = 0x08000000;
enum WGL_SWAP_UNDERLAY13 = 0x10000000;
enum WGL_SWAP_UNDERLAY14 = 0x20000000;
enum WGL_SWAP_UNDERLAY15 = 0x40000000;

// Constants for WGL_ARB_buffer_region
enum WGL_FRONT_COLOR_BUFFER_BIT_ARB = 0x00000001;
enum WGL_BACK_COLOR_BUFFER_BIT_ARB  = 0x00000002;
enum WGL_DEPTH_BUFFER_BIT_ARB       = 0x00000004;
enum WGL_STENCIL_BUFFER_BIT_ARB     = 0x00000008;

// Constants for WGL_ARB_context_flush_control
enum WGL_CONTEXT_RELEASE_BEHAVIOR_ARB       = 0x2097;
enum WGL_CONTEXT_RELEASE_BEHAVIOR_NONE_ARB  = 0;
enum WGL_CONTEXT_RELEASE_BEHAVIOR_FLUSH_ARB = 0x2098;

// Constants for WGL_ARB_create_context
enum WGL_CONTEXT_DEBUG_BIT_ARB              = 0x00000001;
enum WGL_CONTEXT_FORWARD_COMPATIBLE_BIT_ARB = 0x00000002;
enum WGL_CONTEXT_MAJOR_VERSION_ARB          = 0x2091;
enum WGL_CONTEXT_MINOR_VERSION_ARB          = 0x2092;
enum WGL_CONTEXT_LAYER_PLANE_ARB            = 0x2093;
enum WGL_CONTEXT_FLAGS_ARB                  = 0x2094;
enum ERROR_INVALID_VERSION_ARB              = 0x2095;

// Constants for WGL_ARB_create_context_no_error
enum WGL_CONTEXT_OPENGL_NO_ERROR_ARB = 0x31B3;

// Constants for WGL_ARB_create_context_profile
enum WGL_CONTEXT_PROFILE_MASK_ARB              = 0x9126;
enum WGL_CONTEXT_CORE_PROFILE_BIT_ARB          = 0x00000001;
enum WGL_CONTEXT_COMPATIBILITY_PROFILE_BIT_ARB = 0x00000002;
enum ERROR_INVALID_PROFILE_ARB                 = 0x2096;

// Constants for WGL_ARB_create_context_robustness
enum WGL_CONTEXT_ROBUST_ACCESS_BIT_ARB           = 0x00000004;
enum WGL_LOSE_CONTEXT_ON_RESET_ARB               = 0x8252;
enum WGL_CONTEXT_RESET_NOTIFICATION_STRATEGY_ARB = 0x8256;
enum WGL_NO_RESET_NOTIFICATION_ARB               = 0x8261;

// Constants for WGL_ARB_framebuffer_sRGB
enum WGL_FRAMEBUFFER_SRGB_CAPABLE_ARB = 0x20A9;

// Constants for WGL_ARB_make_current_read
enum ERROR_INVALID_PIXEL_TYPE_ARB           = 0x2043;
enum ERROR_INCOMPATIBLE_DEVICE_CONTEXTS_ARB = 0x2054;

// Constants for WGL_ARB_multisample
enum WGL_SAMPLE_BUFFERS_ARB = 0x2041;
enum WGL_SAMPLES_ARB        = 0x2042;

// Constants for WGL_ARB_pbuffer
enum WGL_DRAW_TO_PBUFFER_ARB    = 0x202D;
enum WGL_MAX_PBUFFER_PIXELS_ARB = 0x202E;
enum WGL_MAX_PBUFFER_WIDTH_ARB  = 0x202F;
enum WGL_MAX_PBUFFER_HEIGHT_ARB = 0x2030;
enum WGL_PBUFFER_LARGEST_ARB    = 0x2033;
enum WGL_PBUFFER_WIDTH_ARB      = 0x2034;
enum WGL_PBUFFER_HEIGHT_ARB     = 0x2035;
enum WGL_PBUFFER_LOST_ARB       = 0x2036;

// Constants for WGL_ARB_pixel_format
enum WGL_NUMBER_PIXEL_FORMATS_ARB    = 0x2000;
enum WGL_DRAW_TO_WINDOW_ARB          = 0x2001;
enum WGL_DRAW_TO_BITMAP_ARB          = 0x2002;
enum WGL_ACCELERATION_ARB            = 0x2003;
enum WGL_NEED_PALETTE_ARB            = 0x2004;
enum WGL_NEED_SYSTEM_PALETTE_ARB     = 0x2005;
enum WGL_SWAP_LAYER_BUFFERS_ARB      = 0x2006;
enum WGL_SWAP_METHOD_ARB             = 0x2007;
enum WGL_NUMBER_OVERLAYS_ARB         = 0x2008;
enum WGL_NUMBER_UNDERLAYS_ARB        = 0x2009;
enum WGL_TRANSPARENT_ARB             = 0x200A;
enum WGL_TRANSPARENT_RED_VALUE_ARB   = 0x2037;
enum WGL_TRANSPARENT_GREEN_VALUE_ARB = 0x2038;
enum WGL_TRANSPARENT_BLUE_VALUE_ARB  = 0x2039;
enum WGL_TRANSPARENT_ALPHA_VALUE_ARB = 0x203A;
enum WGL_TRANSPARENT_INDEX_VALUE_ARB = 0x203B;
enum WGL_SHARE_DEPTH_ARB             = 0x200C;
enum WGL_SHARE_STENCIL_ARB           = 0x200D;
enum WGL_SHARE_ACCUM_ARB             = 0x200E;
enum WGL_SUPPORT_GDI_ARB             = 0x200F;
enum WGL_SUPPORT_OPENGL_ARB          = 0x2010;
enum WGL_DOUBLE_BUFFER_ARB           = 0x2011;
enum WGL_STEREO_ARB                  = 0x2012;
enum WGL_PIXEL_TYPE_ARB              = 0x2013;
enum WGL_COLOR_BITS_ARB              = 0x2014;
enum WGL_RED_BITS_ARB                = 0x2015;
enum WGL_RED_SHIFT_ARB               = 0x2016;
enum WGL_GREEN_BITS_ARB              = 0x2017;
enum WGL_GREEN_SHIFT_ARB             = 0x2018;
enum WGL_BLUE_BITS_ARB               = 0x2019;
enum WGL_BLUE_SHIFT_ARB              = 0x201A;
enum WGL_ALPHA_BITS_ARB              = 0x201B;
enum WGL_ALPHA_SHIFT_ARB             = 0x201C;
enum WGL_ACCUM_BITS_ARB              = 0x201D;
enum WGL_ACCUM_RED_BITS_ARB          = 0x201E;
enum WGL_ACCUM_GREEN_BITS_ARB        = 0x201F;
enum WGL_ACCUM_BLUE_BITS_ARB         = 0x2020;
enum WGL_ACCUM_ALPHA_BITS_ARB        = 0x2021;
enum WGL_DEPTH_BITS_ARB              = 0x2022;
enum WGL_STENCIL_BITS_ARB            = 0x2023;
enum WGL_AUX_BUFFERS_ARB             = 0x2024;
enum WGL_NO_ACCELERATION_ARB         = 0x2025;
enum WGL_GENERIC_ACCELERATION_ARB    = 0x2026;
enum WGL_FULL_ACCELERATION_ARB       = 0x2027;
enum WGL_SWAP_EXCHANGE_ARB           = 0x2028;
enum WGL_SWAP_COPY_ARB               = 0x2029;
enum WGL_SWAP_UNDEFINED_ARB          = 0x202A;
enum WGL_TYPE_RGBA_ARB               = 0x202B;
enum WGL_TYPE_COLORINDEX_ARB         = 0x202C;

// Constants for WGL_ARB_pixel_format_float
enum WGL_TYPE_RGBA_FLOAT_ARB = 0x21A0;

// Constants for WGL_ARB_render_texture
enum WGL_BIND_TO_TEXTURE_RGB_ARB         = 0x2070;
enum WGL_BIND_TO_TEXTURE_RGBA_ARB        = 0x2071;
enum WGL_TEXTURE_FORMAT_ARB              = 0x2072;
enum WGL_TEXTURE_TARGET_ARB              = 0x2073;
enum WGL_MIPMAP_TEXTURE_ARB              = 0x2074;
enum WGL_TEXTURE_RGB_ARB                 = 0x2075;
enum WGL_TEXTURE_RGBA_ARB                = 0x2076;
enum WGL_NO_TEXTURE_ARB                  = 0x2077;
enum WGL_TEXTURE_CUBE_MAP_ARB            = 0x2078;
enum WGL_TEXTURE_1D_ARB                  = 0x2079;
enum WGL_TEXTURE_2D_ARB                  = 0x207A;
enum WGL_MIPMAP_LEVEL_ARB                = 0x207B;
enum WGL_CUBE_MAP_FACE_ARB               = 0x207C;
enum WGL_TEXTURE_CUBE_MAP_POSITIVE_X_ARB = 0x207D;
enum WGL_TEXTURE_CUBE_MAP_NEGATIVE_X_ARB = 0x207E;
enum WGL_TEXTURE_CUBE_MAP_POSITIVE_Y_ARB = 0x207F;
enum WGL_TEXTURE_CUBE_MAP_NEGATIVE_Y_ARB = 0x2080;
enum WGL_TEXTURE_CUBE_MAP_POSITIVE_Z_ARB = 0x2081;
enum WGL_TEXTURE_CUBE_MAP_NEGATIVE_Z_ARB = 0x2082;
enum WGL_FRONT_LEFT_ARB                  = 0x2083;
enum WGL_FRONT_RIGHT_ARB                 = 0x2084;
enum WGL_BACK_LEFT_ARB                   = 0x2085;
enum WGL_BACK_RIGHT_ARB                  = 0x2086;
enum WGL_AUX0_ARB                        = 0x2087;
enum WGL_AUX1_ARB                        = 0x2088;
enum WGL_AUX2_ARB                        = 0x2089;
enum WGL_AUX3_ARB                        = 0x208A;
enum WGL_AUX4_ARB                        = 0x208B;
enum WGL_AUX5_ARB                        = 0x208C;
enum WGL_AUX6_ARB                        = 0x208D;
enum WGL_AUX7_ARB                        = 0x208E;
enum WGL_AUX8_ARB                        = 0x208F;
enum WGL_AUX9_ARB                        = 0x2090;

// Constants for WGL_ARB_robustness_application_isolation
enum WGL_CONTEXT_RESET_ISOLATION_BIT_ARB = 0x00000008;

// Constants for WGL_3DFX_multisample
enum WGL_SAMPLE_BUFFERS_3DFX = 0x2060;
enum WGL_SAMPLES_3DFX        = 0x2061;

// Constants for WGL_3DL_stereo_control
enum WGL_STEREO_EMITTER_ENABLE_3DL  = 0x2055;
enum WGL_STEREO_EMITTER_DISABLE_3DL = 0x2056;
enum WGL_STEREO_POLARITY_NORMAL_3DL = 0x2057;
enum WGL_STEREO_POLARITY_INVERT_3DL = 0x2058;

// Constants for WGL_AMD_gpu_association
enum WGL_GPU_VENDOR_AMD                = 0x1F00;
enum WGL_GPU_RENDERER_STRING_AMD       = 0x1F01;
enum WGL_GPU_OPENGL_VERSION_STRING_AMD = 0x1F02;
enum WGL_GPU_FASTEST_TARGET_GPUS_AMD   = 0x21A2;
enum WGL_GPU_RAM_AMD                   = 0x21A3;
enum WGL_GPU_CLOCK_AMD                 = 0x21A4;
enum WGL_GPU_NUM_PIPES_AMD             = 0x21A5;
enum WGL_GPU_NUM_SIMD_AMD              = 0x21A6;
enum WGL_GPU_NUM_RB_AMD                = 0x21A7;
enum WGL_GPU_NUM_SPI_AMD               = 0x21A8;

// Constants for WGL_ATI_pixel_format_float
enum WGL_TYPE_RGBA_FLOAT_ATI = 0x21A0;

// Constants for WGL_ATI_render_texture_rectangle
enum WGL_TEXTURE_RECTANGLE_ATI = 0x21A5;

// Constants for WGL_EXT_colorspace
enum WGL_COLORSPACE_EXT        = 0x309D;
enum WGL_COLORSPACE_SRGB_EXT   = 0x3089;
enum WGL_COLORSPACE_LINEAR_EXT = 0x308A;

// Constants for WGL_EXT_create_context_es2_profile
enum WGL_CONTEXT_ES2_PROFILE_BIT_EXT = 0x00000004;

// Constants for WGL_EXT_create_context_es_profile
enum WGL_CONTEXT_ES_PROFILE_BIT_EXT = 0x00000004;

// Constants for WGL_EXT_depth_float
enum WGL_DEPTH_FLOAT_EXT = 0x2040;

// Constants for WGL_EXT_framebuffer_sRGB
enum WGL_FRAMEBUFFER_SRGB_CAPABLE_EXT = 0x20A9;

// Constants for WGL_EXT_make_current_read
enum ERROR_INVALID_PIXEL_TYPE_EXT = 0x2043;

// Constants for WGL_EXT_multisample
enum WGL_SAMPLE_BUFFERS_EXT = 0x2041;
enum WGL_SAMPLES_EXT        = 0x2042;

// Constants for WGL_EXT_pbuffer
enum WGL_DRAW_TO_PBUFFER_EXT        = 0x202D;
enum WGL_MAX_PBUFFER_PIXELS_EXT     = 0x202E;
enum WGL_MAX_PBUFFER_WIDTH_EXT      = 0x202F;
enum WGL_MAX_PBUFFER_HEIGHT_EXT     = 0x2030;
enum WGL_OPTIMAL_PBUFFER_WIDTH_EXT  = 0x2031;
enum WGL_OPTIMAL_PBUFFER_HEIGHT_EXT = 0x2032;
enum WGL_PBUFFER_LARGEST_EXT        = 0x2033;
enum WGL_PBUFFER_WIDTH_EXT          = 0x2034;
enum WGL_PBUFFER_HEIGHT_EXT         = 0x2035;

// Constants for WGL_EXT_pixel_format
enum WGL_NUMBER_PIXEL_FORMATS_EXT = 0x2000;
enum WGL_DRAW_TO_WINDOW_EXT       = 0x2001;
enum WGL_DRAW_TO_BITMAP_EXT       = 0x2002;
enum WGL_ACCELERATION_EXT         = 0x2003;
enum WGL_NEED_PALETTE_EXT         = 0x2004;
enum WGL_NEED_SYSTEM_PALETTE_EXT  = 0x2005;
enum WGL_SWAP_LAYER_BUFFERS_EXT   = 0x2006;
enum WGL_SWAP_METHOD_EXT          = 0x2007;
enum WGL_NUMBER_OVERLAYS_EXT      = 0x2008;
enum WGL_NUMBER_UNDERLAYS_EXT     = 0x2009;
enum WGL_TRANSPARENT_EXT          = 0x200A;
enum WGL_TRANSPARENT_VALUE_EXT    = 0x200B;
enum WGL_SHARE_DEPTH_EXT          = 0x200C;
enum WGL_SHARE_STENCIL_EXT        = 0x200D;
enum WGL_SHARE_ACCUM_EXT          = 0x200E;
enum WGL_SUPPORT_GDI_EXT          = 0x200F;
enum WGL_SUPPORT_OPENGL_EXT       = 0x2010;
enum WGL_DOUBLE_BUFFER_EXT        = 0x2011;
enum WGL_STEREO_EXT               = 0x2012;
enum WGL_PIXEL_TYPE_EXT           = 0x2013;
enum WGL_COLOR_BITS_EXT           = 0x2014;
enum WGL_RED_BITS_EXT             = 0x2015;
enum WGL_RED_SHIFT_EXT            = 0x2016;
enum WGL_GREEN_BITS_EXT           = 0x2017;
enum WGL_GREEN_SHIFT_EXT          = 0x2018;
enum WGL_BLUE_BITS_EXT            = 0x2019;
enum WGL_BLUE_SHIFT_EXT           = 0x201A;
enum WGL_ALPHA_BITS_EXT           = 0x201B;
enum WGL_ALPHA_SHIFT_EXT          = 0x201C;
enum WGL_ACCUM_BITS_EXT           = 0x201D;
enum WGL_ACCUM_RED_BITS_EXT       = 0x201E;
enum WGL_ACCUM_GREEN_BITS_EXT     = 0x201F;
enum WGL_ACCUM_BLUE_BITS_EXT      = 0x2020;
enum WGL_ACCUM_ALPHA_BITS_EXT     = 0x2021;
enum WGL_DEPTH_BITS_EXT           = 0x2022;
enum WGL_STENCIL_BITS_EXT         = 0x2023;
enum WGL_AUX_BUFFERS_EXT          = 0x2024;
enum WGL_NO_ACCELERATION_EXT      = 0x2025;
enum WGL_GENERIC_ACCELERATION_EXT = 0x2026;
enum WGL_FULL_ACCELERATION_EXT    = 0x2027;
enum WGL_SWAP_EXCHANGE_EXT        = 0x2028;
enum WGL_SWAP_COPY_EXT            = 0x2029;
enum WGL_SWAP_UNDEFINED_EXT       = 0x202A;
enum WGL_TYPE_RGBA_EXT            = 0x202B;
enum WGL_TYPE_COLORINDEX_EXT      = 0x202C;

// Constants for WGL_EXT_pixel_format_packed_float
enum WGL_TYPE_RGBA_UNSIGNED_FLOAT_EXT = 0x20A8;

// Constants for WGL_I3D_digital_video_control
enum WGL_DIGITAL_VIDEO_CURSOR_ALPHA_FRAMEBUFFER_I3D = 0x2050;
enum WGL_DIGITAL_VIDEO_CURSOR_ALPHA_VALUE_I3D       = 0x2051;
enum WGL_DIGITAL_VIDEO_CURSOR_INCLUDED_I3D          = 0x2052;
enum WGL_DIGITAL_VIDEO_GAMMA_CORRECTED_I3D          = 0x2053;

// Constants for WGL_I3D_gamma
enum WGL_GAMMA_TABLE_SIZE_I3D      = 0x204E;
enum WGL_GAMMA_EXCLUDE_DESKTOP_I3D = 0x204F;

// Constants for WGL_I3D_genlock
enum WGL_GENLOCK_SOURCE_MULTIVIEW_I3D      = 0x2044;
enum WGL_GENLOCK_SOURCE_EXTERNAL_SYNC_I3D  = 0x2045;
enum WGL_GENLOCK_SOURCE_EXTERNAL_FIELD_I3D = 0x2046;
enum WGL_GENLOCK_SOURCE_EXTERNAL_TTL_I3D   = 0x2047;
enum WGL_GENLOCK_SOURCE_DIGITAL_SYNC_I3D   = 0x2048;
enum WGL_GENLOCK_SOURCE_DIGITAL_FIELD_I3D  = 0x2049;
enum WGL_GENLOCK_SOURCE_EDGE_FALLING_I3D   = 0x204A;
enum WGL_GENLOCK_SOURCE_EDGE_RISING_I3D    = 0x204B;
enum WGL_GENLOCK_SOURCE_EDGE_BOTH_I3D      = 0x204C;

// Constants for WGL_I3D_image_buffer
enum WGL_IMAGE_BUFFER_MIN_ACCESS_I3D = 0x00000001;
enum WGL_IMAGE_BUFFER_LOCK_I3D       = 0x00000002;

// Constants for WGL_NV_DX_interop
enum WGL_ACCESS_READ_ONLY_NV     = 0x00000000;
enum WGL_ACCESS_READ_WRITE_NV    = 0x00000001;
enum WGL_ACCESS_WRITE_DISCARD_NV = 0x00000002;

// Constants for WGL_NV_float_buffer
enum WGL_FLOAT_COMPONENTS_NV                     = 0x20B0;
enum WGL_BIND_TO_TEXTURE_RECTANGLE_FLOAT_R_NV    = 0x20B1;
enum WGL_BIND_TO_TEXTURE_RECTANGLE_FLOAT_RG_NV   = 0x20B2;
enum WGL_BIND_TO_TEXTURE_RECTANGLE_FLOAT_RGB_NV  = 0x20B3;
enum WGL_BIND_TO_TEXTURE_RECTANGLE_FLOAT_RGBA_NV = 0x20B4;
enum WGL_TEXTURE_FLOAT_R_NV                      = 0x20B5;
enum WGL_TEXTURE_FLOAT_RG_NV                     = 0x20B6;
enum WGL_TEXTURE_FLOAT_RGB_NV                    = 0x20B7;
enum WGL_TEXTURE_FLOAT_RGBA_NV                   = 0x20B8;

// Constants for WGL_NV_gpu_affinity
enum ERROR_INCOMPATIBLE_AFFINITY_MASKS_NV = 0x20D0;
enum ERROR_MISSING_AFFINITY_MASK_NV       = 0x20D1;

// Constants for WGL_NV_multisample_coverage
enum WGL_COVERAGE_SAMPLES_NV = 0x2042;
enum WGL_COLOR_SAMPLES_NV    = 0x20B9;

// Constants for WGL_NV_present_video
enum WGL_NUM_VIDEO_SLOTS_NV = 0x20F0;

// Constants for WGL_NV_render_depth_texture
enum WGL_BIND_TO_TEXTURE_DEPTH_NV           = 0x20A3;
enum WGL_BIND_TO_TEXTURE_RECTANGLE_DEPTH_NV = 0x20A4;
enum WGL_DEPTH_TEXTURE_FORMAT_NV            = 0x20A5;
enum WGL_TEXTURE_DEPTH_COMPONENT_NV         = 0x20A6;
enum WGL_DEPTH_COMPONENT_NV                 = 0x20A7;

// Constants for WGL_NV_render_texture_rectangle
enum WGL_BIND_TO_TEXTURE_RECTANGLE_RGB_NV  = 0x20A0;
enum WGL_BIND_TO_TEXTURE_RECTANGLE_RGBA_NV = 0x20A1;
enum WGL_TEXTURE_RECTANGLE_NV              = 0x20A2;

// Constants for WGL_NV_video_capture
enum WGL_UNIQUE_ID_NV               = 0x20CE;
enum WGL_NUM_VIDEO_CAPTURE_SLOTS_NV = 0x20CF;

// Constants for WGL_NV_video_output
enum WGL_BIND_TO_VIDEO_RGB_NV           = 0x20C0;
enum WGL_BIND_TO_VIDEO_RGBA_NV          = 0x20C1;
enum WGL_BIND_TO_VIDEO_RGB_AND_DEPTH_NV = 0x20C2;
enum WGL_VIDEO_OUT_COLOR_NV             = 0x20C3;
enum WGL_VIDEO_OUT_ALPHA_NV             = 0x20C4;
enum WGL_VIDEO_OUT_DEPTH_NV             = 0x20C5;
enum WGL_VIDEO_OUT_COLOR_AND_ALPHA_NV   = 0x20C6;
enum WGL_VIDEO_OUT_COLOR_AND_DEPTH_NV   = 0x20C7;
enum WGL_VIDEO_OUT_FRAME                = 0x20C8;
enum WGL_VIDEO_OUT_FIELD_1              = 0x20C9;
enum WGL_VIDEO_OUT_FIELD_2              = 0x20CA;
enum WGL_VIDEO_OUT_STACKED_FIELDS_1_2   = 0x20CB;
enum WGL_VIDEO_OUT_STACKED_FIELDS_2_1   = 0x20CC;

// Command pointer aliases

extern(C) nothrow @nogc {

    // Command pointers for WGL_VERSION_1_0
    alias PFN_wglCopyContext = BOOL function (
        HGLRC hglrcSrc,
        HGLRC hglrcDst,
        UINT  mask,
    );
    alias PFN_wglCreateContext = HGLRC function (
        HDC hDc,
    );
    alias PFN_wglCreateLayerContext = HGLRC function (
        HDC hDc,
        int level,
    );
    alias PFN_wglDeleteContext = BOOL function (
        HGLRC oldContext,
    );
    alias PFN_wglDescribeLayerPlane = BOOL function (
        HDC                          hDc,
        int                          pixelFormat,
        int                          layerPlane,
        UINT                         nBytes,
        const(LAYERPLANEDESCRIPTOR)* plpd,
    );
    alias PFN_wglGetCurrentContext = HGLRC function ();
    alias PFN_wglGetCurrentDC = HDC function ();
    alias PFN_wglGetLayerPaletteEntries = int function (
        HDC              hdc,
        int              iLayerPlane,
        int              iStart,
        int              cEntries,
        const(COLORREF)* pcr,
    );
    alias PFN_wglGetProcAddress = PROC function (
        LPCSTR lpszProc,
    );
    alias PFN_wglMakeCurrent = BOOL function (
        HDC   hDc,
        HGLRC newContext,
    );
    alias PFN_wglRealizeLayerPalette = BOOL function (
        HDC  hdc,
        int  iLayerPlane,
        BOOL bRealize,
    );
    alias PFN_wglSetLayerPaletteEntries = int function (
        HDC              hdc,
        int              iLayerPlane,
        int              iStart,
        int              cEntries,
        const(COLORREF)* pcr,
    );
    alias PFN_wglShareLists = BOOL function (
        HGLRC hrcSrvShare,
        HGLRC hrcSrvSource,
    );
    alias PFN_wglSwapLayerBuffers = BOOL function (
        HDC  hdc,
        UINT fuFlags,
    );
    alias PFN_wglUseFontBitmaps = BOOL function (
        HDC   hDC,
        DWORD first,
        DWORD count,
        DWORD listBase,
    );
    alias PFN_wglUseFontBitmapsA = BOOL function (
        HDC   hDC,
        DWORD first,
        DWORD count,
        DWORD listBase,
    );
    alias PFN_wglUseFontBitmapsW = BOOL function (
        HDC   hDC,
        DWORD first,
        DWORD count,
        DWORD listBase,
    );
    alias PFN_wglUseFontOutlines = BOOL function (
        HDC                 hDC,
        DWORD               first,
        DWORD               count,
        DWORD               listBase,
        FLOAT               deviation,
        FLOAT               extrusion,
        int                 format,
        LPGLYPHMETRICSFLOAT lpgmf,
    );
    alias PFN_wglUseFontOutlinesA = BOOL function (
        HDC                 hDC,
        DWORD               first,
        DWORD               count,
        DWORD               listBase,
        FLOAT               deviation,
        FLOAT               extrusion,
        int                 format,
        LPGLYPHMETRICSFLOAT lpgmf,
    );
    alias PFN_wglUseFontOutlinesW = BOOL function (
        HDC                 hDC,
        DWORD               first,
        DWORD               count,
        DWORD               listBase,
        FLOAT               deviation,
        FLOAT               extrusion,
        int                 format,
        LPGLYPHMETRICSFLOAT lpgmf,
    );

    // Command pointers for WGL_ARB_buffer_region
    alias PFN_wglCreateBufferRegionARB = HANDLE function (
        HDC  hDC,
        int  iLayerPlane,
        UINT uType,
    );
    alias PFN_wglDeleteBufferRegionARB = VOID function (
        HANDLE hRegion,
    );
    alias PFN_wglSaveBufferRegionARB = BOOL function (
        HANDLE hRegion,
        int    x,
        int    y,
        int    width,
        int    height,
    );
    alias PFN_wglRestoreBufferRegionARB = BOOL function (
        HANDLE hRegion,
        int    x,
        int    y,
        int    width,
        int    height,
        int    xSrc,
        int    ySrc,
    );

    // Command pointers for WGL_ARB_create_context
    alias PFN_wglCreateContextAttribsARB = HGLRC function (
        HDC         hDC,
        HGLRC       hShareContext,
        const(int)* attribList,
    );

    // Command pointers for WGL_ARB_extensions_string
    alias PFN_wglGetExtensionsStringARB = const(char)* function (
        HDC hdc,
    );

    // Command pointers for WGL_ARB_make_current_read
    alias PFN_wglMakeContextCurrentARB = BOOL function (
        HDC   hDrawDC,
        HDC   hReadDC,
        HGLRC hglrc,
    );
    alias PFN_wglGetCurrentReadDCARB = HDC function ();

    // Command pointers for WGL_ARB_pbuffer
    alias PFN_wglCreatePbufferARB = HPBUFFERARB function (
        HDC         hDC,
        int         iPixelFormat,
        int         iWidth,
        int         iHeight,
        const(int)* piAttribList,
    );
    alias PFN_wglGetPbufferDCARB = HDC function (
        HPBUFFERARB hPbuffer,
    );
    alias PFN_wglReleasePbufferDCARB = int function (
        HPBUFFERARB hPbuffer,
        HDC         hDC,
    );
    alias PFN_wglDestroyPbufferARB = BOOL function (
        HPBUFFERARB hPbuffer,
    );
    alias PFN_wglQueryPbufferARB = BOOL function (
        HPBUFFERARB hPbuffer,
        int         iAttribute,
        int*        piValue,
    );

    // Command pointers for WGL_ARB_pixel_format
    alias PFN_wglGetPixelFormatAttribivARB = BOOL function (
        HDC         hdc,
        int         iPixelFormat,
        int         iLayerPlane,
        UINT        nAttributes,
        const(int)* piAttributes,
        int*        piValues,
    );
    alias PFN_wglGetPixelFormatAttribfvARB = BOOL function (
        HDC         hdc,
        int         iPixelFormat,
        int         iLayerPlane,
        UINT        nAttributes,
        const(int)* piAttributes,
        FLOAT*      pfValues,
    );
    alias PFN_wglChoosePixelFormatARB = BOOL function (
        HDC           hdc,
        const(int)*   piAttribIList,
        const(FLOAT)* pfAttribFList,
        UINT          nMaxFormats,
        int*          piFormats,
        UINT*         nNumFormats,
    );

    // Command pointers for WGL_ARB_render_texture
    alias PFN_wglBindTexImageARB = BOOL function (
        HPBUFFERARB hPbuffer,
        int         iBuffer,
    );
    alias PFN_wglReleaseTexImageARB = BOOL function (
        HPBUFFERARB hPbuffer,
        int         iBuffer,
    );
    alias PFN_wglSetPbufferAttribARB = BOOL function (
        HPBUFFERARB hPbuffer,
        const(int)* piAttribList,
    );

    // Command pointers for WGL_3DL_stereo_control
    alias PFN_wglSetStereoEmitterState3DL = BOOL function (
        HDC  hDC,
        UINT uState,
    );

    // Command pointers for WGL_AMD_gpu_association
    alias PFN_wglGetGPUIDsAMD = UINT function (
        UINT  maxCount,
        UINT* ids,
    );
    alias PFN_wglGetGPUInfoAMD = INT function (
        UINT   id,
        int    property,
        GLenum dataType,
        UINT   size,
        void*  data,
    );
    alias PFN_wglGetContextGPUIDAMD = UINT function (
        HGLRC hglrc,
    );
    alias PFN_wglCreateAssociatedContextAMD = HGLRC function (
        UINT id,
    );
    alias PFN_wglCreateAssociatedContextAttribsAMD = HGLRC function (
        UINT        id,
        HGLRC       hShareContext,
        const(int)* attribList,
    );
    alias PFN_wglDeleteAssociatedContextAMD = BOOL function (
        HGLRC hglrc,
    );
    alias PFN_wglMakeAssociatedContextCurrentAMD = BOOL function (
        HGLRC hglrc,
    );
    alias PFN_wglGetCurrentAssociatedContextAMD = HGLRC function ();
    alias PFN_wglBlitContextFramebufferAMD = VOID function (
        HGLRC      dstCtx,
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

    // Command pointers for WGL_EXT_display_color_table
    alias PFN_wglCreateDisplayColorTableEXT = GLboolean function (
        GLushort id,
    );
    alias PFN_wglLoadDisplayColorTableEXT = GLboolean function (
        const(GLushort)* table,
        GLuint           length,
    );
    alias PFN_wglBindDisplayColorTableEXT = GLboolean function (
        GLushort id,
    );
    alias PFN_wglDestroyDisplayColorTableEXT = VOID function (
        GLushort id,
    );

    // Command pointers for WGL_EXT_extensions_string
    alias PFN_wglGetExtensionsStringEXT = const(char)* function ();

    // Command pointers for WGL_EXT_make_current_read
    alias PFN_wglMakeContextCurrentEXT = BOOL function (
        HDC   hDrawDC,
        HDC   hReadDC,
        HGLRC hglrc,
    );
    alias PFN_wglGetCurrentReadDCEXT = HDC function ();

    // Command pointers for WGL_EXT_pbuffer
    alias PFN_wglCreatePbufferEXT = HPBUFFEREXT function (
        HDC         hDC,
        int         iPixelFormat,
        int         iWidth,
        int         iHeight,
        const(int)* piAttribList,
    );
    alias PFN_wglGetPbufferDCEXT = HDC function (
        HPBUFFEREXT hPbuffer,
    );
    alias PFN_wglReleasePbufferDCEXT = int function (
        HPBUFFEREXT hPbuffer,
        HDC         hDC,
    );
    alias PFN_wglDestroyPbufferEXT = BOOL function (
        HPBUFFEREXT hPbuffer,
    );
    alias PFN_wglQueryPbufferEXT = BOOL function (
        HPBUFFEREXT hPbuffer,
        int         iAttribute,
        int*        piValue,
    );

    // Command pointers for WGL_EXT_pixel_format
    alias PFN_wglGetPixelFormatAttribivEXT = BOOL function (
        HDC  hdc,
        int  iPixelFormat,
        int  iLayerPlane,
        UINT nAttributes,
        int* piAttributes,
        int* piValues,
    );
    alias PFN_wglGetPixelFormatAttribfvEXT = BOOL function (
        HDC    hdc,
        int    iPixelFormat,
        int    iLayerPlane,
        UINT   nAttributes,
        int*   piAttributes,
        FLOAT* pfValues,
    );
    alias PFN_wglChoosePixelFormatEXT = BOOL function (
        HDC           hdc,
        const(int)*   piAttribIList,
        const(FLOAT)* pfAttribFList,
        UINT          nMaxFormats,
        int*          piFormats,
        UINT*         nNumFormats,
    );

    // Command pointers for WGL_EXT_swap_control
    alias PFN_wglSwapIntervalEXT = BOOL function (
        int interval,
    );
    alias PFN_wglGetSwapIntervalEXT = int function ();

    // Command pointers for WGL_I3D_digital_video_control
    alias PFN_wglGetDigitalVideoParametersI3D = BOOL function (
        HDC  hDC,
        int  iAttribute,
        int* piValue,
    );
    alias PFN_wglSetDigitalVideoParametersI3D = BOOL function (
        HDC         hDC,
        int         iAttribute,
        const(int)* piValue,
    );

    // Command pointers for WGL_I3D_gamma
    alias PFN_wglGetGammaTableParametersI3D = BOOL function (
        HDC  hDC,
        int  iAttribute,
        int* piValue,
    );
    alias PFN_wglSetGammaTableParametersI3D = BOOL function (
        HDC         hDC,
        int         iAttribute,
        const(int)* piValue,
    );
    alias PFN_wglGetGammaTableI3D = BOOL function (
        HDC     hDC,
        int     iEntries,
        USHORT* puRed,
        USHORT* puGreen,
        USHORT* puBlue,
    );
    alias PFN_wglSetGammaTableI3D = BOOL function (
        HDC            hDC,
        int            iEntries,
        const(USHORT)* puRed,
        const(USHORT)* puGreen,
        const(USHORT)* puBlue,
    );

    // Command pointers for WGL_I3D_genlock
    alias PFN_wglEnableGenlockI3D = BOOL function (
        HDC hDC,
    );
    alias PFN_wglDisableGenlockI3D = BOOL function (
        HDC hDC,
    );
    alias PFN_wglIsEnabledGenlockI3D = BOOL function (
        HDC   hDC,
        BOOL* pFlag,
    );
    alias PFN_wglGenlockSourceI3D = BOOL function (
        HDC  hDC,
        UINT uSource,
    );
    alias PFN_wglGetGenlockSourceI3D = BOOL function (
        HDC   hDC,
        UINT* uSource,
    );
    alias PFN_wglGenlockSourceEdgeI3D = BOOL function (
        HDC  hDC,
        UINT uEdge,
    );
    alias PFN_wglGetGenlockSourceEdgeI3D = BOOL function (
        HDC   hDC,
        UINT* uEdge,
    );
    alias PFN_wglGenlockSampleRateI3D = BOOL function (
        HDC  hDC,
        UINT uRate,
    );
    alias PFN_wglGetGenlockSampleRateI3D = BOOL function (
        HDC   hDC,
        UINT* uRate,
    );
    alias PFN_wglGenlockSourceDelayI3D = BOOL function (
        HDC  hDC,
        UINT uDelay,
    );
    alias PFN_wglGetGenlockSourceDelayI3D = BOOL function (
        HDC   hDC,
        UINT* uDelay,
    );
    alias PFN_wglQueryGenlockMaxSourceDelayI3D = BOOL function (
        HDC   hDC,
        UINT* uMaxLineDelay,
        UINT* uMaxPixelDelay,
    );

    // Command pointers for WGL_I3D_image_buffer
    alias PFN_wglCreateImageBufferI3D = LPVOID function (
        HDC   hDC,
        DWORD dwSize,
        UINT  uFlags,
    );
    alias PFN_wglDestroyImageBufferI3D = BOOL function (
        HDC    hDC,
        LPVOID pAddress,
    );
    alias PFN_wglAssociateImageBufferEventsI3D = BOOL function (
        HDC            hDC,
        const(HANDLE)* pEvent,
        const(LPVOID)* pAddress,
        const(DWORD)*  pSize,
        UINT           count,
    );
    alias PFN_wglReleaseImageBufferEventsI3D = BOOL function (
        HDC            hDC,
        const(LPVOID)* pAddress,
        UINT           count,
    );

    // Command pointers for WGL_I3D_swap_frame_lock
    alias PFN_wglEnableFrameLockI3D = BOOL function ();
    alias PFN_wglDisableFrameLockI3D = BOOL function ();
    alias PFN_wglIsEnabledFrameLockI3D = BOOL function (
        BOOL* pFlag,
    );
    alias PFN_wglQueryFrameLockMasterI3D = BOOL function (
        BOOL* pFlag,
    );

    // Command pointers for WGL_I3D_swap_frame_usage
    alias PFN_wglGetFrameUsageI3D = BOOL function (
        float* pUsage,
    );
    alias PFN_wglBeginFrameTrackingI3D = BOOL function ();
    alias PFN_wglEndFrameTrackingI3D = BOOL function ();
    alias PFN_wglQueryFrameTrackingI3D = BOOL function (
        DWORD* pFrameCount,
        DWORD* pMissedFrames,
        float* pLastMissedUsage,
    );

    // Command pointers for WGL_NV_DX_interop
    alias PFN_wglDXSetResourceShareHandleNV = BOOL function (
        void*  dxObject,
        HANDLE shareHandle,
    );
    alias PFN_wglDXOpenDeviceNV = HANDLE function (
        void* dxDevice,
    );
    alias PFN_wglDXCloseDeviceNV = BOOL function (
        HANDLE hDevice,
    );
    alias PFN_wglDXRegisterObjectNV = HANDLE function (
        HANDLE hDevice,
        void*  dxObject,
        GLuint name,
        GLenum type,
        GLenum access,
    );
    alias PFN_wglDXUnregisterObjectNV = BOOL function (
        HANDLE hDevice,
        HANDLE hObject,
    );
    alias PFN_wglDXObjectAccessNV = BOOL function (
        HANDLE hObject,
        GLenum access,
    );
    alias PFN_wglDXLockObjectsNV = BOOL function (
        HANDLE  hDevice,
        GLint   count,
        HANDLE* hObjects,
    );
    alias PFN_wglDXUnlockObjectsNV = BOOL function (
        HANDLE  hDevice,
        GLint   count,
        HANDLE* hObjects,
    );

    // Command pointers for WGL_NV_copy_image
    alias PFN_wglCopyImageSubDataNV = BOOL function (
        HGLRC   hSrcRC,
        GLuint  srcName,
        GLenum  srcTarget,
        GLint   srcLevel,
        GLint   srcX,
        GLint   srcY,
        GLint   srcZ,
        HGLRC   hDstRC,
        GLuint  dstName,
        GLenum  dstTarget,
        GLint   dstLevel,
        GLint   dstX,
        GLint   dstY,
        GLint   dstZ,
        GLsizei width,
        GLsizei height,
        GLsizei depth,
    );

    // Command pointers for WGL_NV_delay_before_swap
    alias PFN_wglDelayBeforeSwapNV = BOOL function (
        HDC     hDC,
        GLfloat seconds,
    );

    // Command pointers for WGL_NV_gpu_affinity
    alias PFN_wglEnumGpusNV = BOOL function (
        UINT    iGpuIndex,
        HGPUNV* phGpu,
    );
    alias PFN_wglEnumGpuDevicesNV = BOOL function (
        HGPUNV      hGpu,
        UINT        iDeviceIndex,
        PGPU_DEVICE lpGpuDevice,
    );
    alias PFN_wglCreateAffinityDCNV = HDC function (
        const(HGPUNV)* phGpuList,
    );
    alias PFN_wglEnumGpusFromAffinityDCNV = BOOL function (
        HDC     hAffinityDC,
        UINT    iGpuIndex,
        HGPUNV* hGpu,
    );
    alias PFN_wglDeleteDCNV = BOOL function (
        HDC hdc,
    );

    // Command pointers for WGL_NV_present_video
    alias PFN_wglEnumerateVideoDevicesNV = int function (
        HDC                   hDC,
        HVIDEOOUTPUTDEVICENV* phDeviceList,
    );
    alias PFN_wglBindVideoDeviceNV = BOOL function (
        HDC                  hDC,
        uint                 uVideoSlot,
        HVIDEOOUTPUTDEVICENV hVideoDevice,
        const(int)*          piAttribList,
    );
    alias PFN_wglQueryCurrentContextNV = BOOL function (
        int  iAttribute,
        int* piValue,
    );

    // Command pointers for WGL_NV_swap_group
    alias PFN_wglJoinSwapGroupNV = BOOL function (
        HDC    hDC,
        GLuint group,
    );
    alias PFN_wglBindSwapBarrierNV = BOOL function (
        GLuint group,
        GLuint barrier,
    );
    alias PFN_wglQuerySwapGroupNV = BOOL function (
        HDC     hDC,
        GLuint* group,
        GLuint* barrier,
    );
    alias PFN_wglQueryMaxSwapGroupsNV = BOOL function (
        HDC     hDC,
        GLuint* maxGroups,
        GLuint* maxBarriers,
    );
    alias PFN_wglQueryFrameCountNV = BOOL function (
        HDC     hDC,
        GLuint* count,
    );
    alias PFN_wglResetFrameCountNV = BOOL function (
        HDC hDC,
    );

    // Command pointers for WGL_NV_vertex_array_range
    alias PFN_wglAllocateMemoryNV = void * function (
        GLsizei size,
        GLfloat readfreq,
        GLfloat writefreq,
        GLfloat priority,
    );
    alias PFN_wglFreeMemoryNV = void function (
        void* pointer,
    );

    // Command pointers for WGL_NV_video_capture
    alias PFN_wglBindVideoCaptureDeviceNV = BOOL function (
        UINT                uVideoSlot,
        HVIDEOINPUTDEVICENV hDevice,
    );
    alias PFN_wglEnumerateVideoCaptureDevicesNV = UINT function (
        HDC                  hDc,
        HVIDEOINPUTDEVICENV* phDeviceList,
    );
    alias PFN_wglLockVideoCaptureDeviceNV = BOOL function (
        HDC                 hDc,
        HVIDEOINPUTDEVICENV hDevice,
    );
    alias PFN_wglQueryVideoCaptureDeviceNV = BOOL function (
        HDC                 hDc,
        HVIDEOINPUTDEVICENV hDevice,
        int                 iAttribute,
        int*                piValue,
    );
    alias PFN_wglReleaseVideoCaptureDeviceNV = BOOL function (
        HDC                 hDc,
        HVIDEOINPUTDEVICENV hDevice,
    );

    // Command pointers for WGL_NV_video_output
    alias PFN_wglGetVideoDeviceNV = BOOL function (
        HDC         hDC,
        int         numDevices,
        HPVIDEODEV* hVideoDevice,
    );
    alias PFN_wglReleaseVideoDeviceNV = BOOL function (
        HPVIDEODEV hVideoDevice,
    );
    alias PFN_wglBindVideoImageNV = BOOL function (
        HPVIDEODEV  hVideoDevice,
        HPBUFFERARB hPbuffer,
        int         iVideoBuffer,
    );
    alias PFN_wglReleaseVideoImageNV = BOOL function (
        HPBUFFERARB hPbuffer,
        int         iVideoBuffer,
    );
    alias PFN_wglSendPbufferToVideoNV = BOOL function (
        HPBUFFERARB hPbuffer,
        int         iBufferType,
        c_ulong*    pulCounterPbuffer,
        BOOL        bBlock,
    );
    alias PFN_wglGetVideoInfoNV = BOOL function (
        HPVIDEODEV hpVideoDevice,
        c_ulong*   pulCounterOutputPbuffer,
        c_ulong*   pulCounterOutputVideo,
    );

    // Command pointers for WGL_OML_sync_control
    alias PFN_wglGetSyncValuesOML = BOOL function (
        HDC    hdc,
        INT64* ust,
        INT64* msc,
        INT64* sbc,
    );
    alias PFN_wglGetMscRateOML = BOOL function (
        HDC    hdc,
        INT32* numerator,
        INT32* denominator,
    );
    alias PFN_wglSwapBuffersMscOML = INT64 function (
        HDC   hdc,
        INT64 target_msc,
        INT64 divisor,
        INT64 remainder,
    );
    alias PFN_wglSwapLayerBuffersMscOML = INT64 function (
        HDC   hdc,
        int   fuPlanes,
        INT64 target_msc,
        INT64 divisor,
        INT64 remainder,
    );
    alias PFN_wglWaitForMscOML = BOOL function (
        HDC    hdc,
        INT64  target_msc,
        INT64  divisor,
        INT64  remainder,
        INT64* ust,
        INT64* msc,
        INT64* sbc,
    );
    alias PFN_wglWaitForSbcOML = BOOL function (
        HDC    hdc,
        INT64  target_sbc,
        INT64* ust,
        INT64* msc,
        INT64* sbc,
    );
}

/// WglVersion describes the version of WinGL
enum WglVersion {
    wgl10 = 10,
}

/// WinGL loader base class
final class Wgl {
    this(SymbolLoader loader) {

        // WGL_VERSION_1_0
        _CopyContext = cast(PFN_wglCopyContext)loadSymbol(loader, "wglCopyContext", []);
        _CreateContext = cast(PFN_wglCreateContext)loadSymbol(loader, "wglCreateContext", []);
        _CreateLayerContext = cast(PFN_wglCreateLayerContext)loadSymbol(loader, "wglCreateLayerContext", []);
        _DeleteContext = cast(PFN_wglDeleteContext)loadSymbol(loader, "wglDeleteContext", []);
        _DescribeLayerPlane = cast(PFN_wglDescribeLayerPlane)loadSymbol(loader, "wglDescribeLayerPlane", []);
        _GetCurrentContext = cast(PFN_wglGetCurrentContext)loadSymbol(loader, "wglGetCurrentContext", []);
        _GetCurrentDC = cast(PFN_wglGetCurrentDC)loadSymbol(loader, "wglGetCurrentDC", []);
        _GetLayerPaletteEntries = cast(PFN_wglGetLayerPaletteEntries)loadSymbol(loader, "wglGetLayerPaletteEntries", []);
        _GetProcAddress = cast(PFN_wglGetProcAddress)loadSymbol(loader, "wglGetProcAddress", []);
        _MakeCurrent = cast(PFN_wglMakeCurrent)loadSymbol(loader, "wglMakeCurrent", []);
        _RealizeLayerPalette = cast(PFN_wglRealizeLayerPalette)loadSymbol(loader, "wglRealizeLayerPalette", []);
        _SetLayerPaletteEntries = cast(PFN_wglSetLayerPaletteEntries)loadSymbol(loader, "wglSetLayerPaletteEntries", []);
        _ShareLists = cast(PFN_wglShareLists)loadSymbol(loader, "wglShareLists", []);
        _SwapLayerBuffers = cast(PFN_wglSwapLayerBuffers)loadSymbol(loader, "wglSwapLayerBuffers", []);
        _UseFontBitmaps = cast(PFN_wglUseFontBitmaps)loadSymbol(loader, "wglUseFontBitmaps", []);
        _UseFontBitmapsA = cast(PFN_wglUseFontBitmapsA)loadSymbol(loader, "wglUseFontBitmapsA", []);
        _UseFontBitmapsW = cast(PFN_wglUseFontBitmapsW)loadSymbol(loader, "wglUseFontBitmapsW", []);
        _UseFontOutlines = cast(PFN_wglUseFontOutlines)loadSymbol(loader, "wglUseFontOutlines", []);
        _UseFontOutlinesA = cast(PFN_wglUseFontOutlinesA)loadSymbol(loader, "wglUseFontOutlinesA", []);
        _UseFontOutlinesW = cast(PFN_wglUseFontOutlinesW)loadSymbol(loader, "wglUseFontOutlinesW", []);

        // WGL_ARB_buffer_region,
        _CreateBufferRegionARB = cast(PFN_wglCreateBufferRegionARB)loadSymbol(loader, "wglCreateBufferRegionARB", []);
        _DeleteBufferRegionARB = cast(PFN_wglDeleteBufferRegionARB)loadSymbol(loader, "wglDeleteBufferRegionARB", []);
        _SaveBufferRegionARB = cast(PFN_wglSaveBufferRegionARB)loadSymbol(loader, "wglSaveBufferRegionARB", []);
        _RestoreBufferRegionARB = cast(PFN_wglRestoreBufferRegionARB)loadSymbol(loader, "wglRestoreBufferRegionARB", []);

        // WGL_ARB_create_context,
        _CreateContextAttribsARB = cast(PFN_wglCreateContextAttribsARB)loadSymbol(loader, "wglCreateContextAttribsARB", []);

        // WGL_ARB_extensions_string,
        _GetExtensionsStringARB = cast(PFN_wglGetExtensionsStringARB)loadSymbol(loader, "wglGetExtensionsStringARB", []);

        // WGL_ARB_make_current_read,
        _MakeContextCurrentARB = cast(PFN_wglMakeContextCurrentARB)loadSymbol(loader, "wglMakeContextCurrentARB", []);
        _GetCurrentReadDCARB = cast(PFN_wglGetCurrentReadDCARB)loadSymbol(loader, "wglGetCurrentReadDCARB", []);

        // WGL_ARB_pbuffer,
        _CreatePbufferARB = cast(PFN_wglCreatePbufferARB)loadSymbol(loader, "wglCreatePbufferARB", []);
        _GetPbufferDCARB = cast(PFN_wglGetPbufferDCARB)loadSymbol(loader, "wglGetPbufferDCARB", []);
        _ReleasePbufferDCARB = cast(PFN_wglReleasePbufferDCARB)loadSymbol(loader, "wglReleasePbufferDCARB", []);
        _DestroyPbufferARB = cast(PFN_wglDestroyPbufferARB)loadSymbol(loader, "wglDestroyPbufferARB", []);
        _QueryPbufferARB = cast(PFN_wglQueryPbufferARB)loadSymbol(loader, "wglQueryPbufferARB", []);

        // WGL_ARB_pixel_format,
        _GetPixelFormatAttribivARB = cast(PFN_wglGetPixelFormatAttribivARB)loadSymbol(loader, "wglGetPixelFormatAttribivARB", []);
        _GetPixelFormatAttribfvARB = cast(PFN_wglGetPixelFormatAttribfvARB)loadSymbol(loader, "wglGetPixelFormatAttribfvARB", []);
        _ChoosePixelFormatARB = cast(PFN_wglChoosePixelFormatARB)loadSymbol(loader, "wglChoosePixelFormatARB", []);

        // WGL_ARB_render_texture,
        _BindTexImageARB = cast(PFN_wglBindTexImageARB)loadSymbol(loader, "wglBindTexImageARB", []);
        _ReleaseTexImageARB = cast(PFN_wglReleaseTexImageARB)loadSymbol(loader, "wglReleaseTexImageARB", []);
        _SetPbufferAttribARB = cast(PFN_wglSetPbufferAttribARB)loadSymbol(loader, "wglSetPbufferAttribARB", []);

        // WGL_3DL_stereo_control,
        _SetStereoEmitterState3DL = cast(PFN_wglSetStereoEmitterState3DL)loadSymbol(loader, "wglSetStereoEmitterState3DL", []);

        // WGL_AMD_gpu_association,
        _GetGPUIDsAMD = cast(PFN_wglGetGPUIDsAMD)loadSymbol(loader, "wglGetGPUIDsAMD", []);
        _GetGPUInfoAMD = cast(PFN_wglGetGPUInfoAMD)loadSymbol(loader, "wglGetGPUInfoAMD", []);
        _GetContextGPUIDAMD = cast(PFN_wglGetContextGPUIDAMD)loadSymbol(loader, "wglGetContextGPUIDAMD", []);
        _CreateAssociatedContextAMD = cast(PFN_wglCreateAssociatedContextAMD)loadSymbol(loader, "wglCreateAssociatedContextAMD", []);
        _CreateAssociatedContextAttribsAMD = cast(PFN_wglCreateAssociatedContextAttribsAMD)loadSymbol(loader, "wglCreateAssociatedContextAttribsAMD", []);
        _DeleteAssociatedContextAMD = cast(PFN_wglDeleteAssociatedContextAMD)loadSymbol(loader, "wglDeleteAssociatedContextAMD", []);
        _MakeAssociatedContextCurrentAMD = cast(PFN_wglMakeAssociatedContextCurrentAMD)loadSymbol(loader, "wglMakeAssociatedContextCurrentAMD", []);
        _GetCurrentAssociatedContextAMD = cast(PFN_wglGetCurrentAssociatedContextAMD)loadSymbol(loader, "wglGetCurrentAssociatedContextAMD", []);
        _BlitContextFramebufferAMD = cast(PFN_wglBlitContextFramebufferAMD)loadSymbol(loader, "wglBlitContextFramebufferAMD", []);

        // WGL_EXT_display_color_table,
        _CreateDisplayColorTableEXT = cast(PFN_wglCreateDisplayColorTableEXT)loadSymbol(loader, "wglCreateDisplayColorTableEXT", []);
        _LoadDisplayColorTableEXT = cast(PFN_wglLoadDisplayColorTableEXT)loadSymbol(loader, "wglLoadDisplayColorTableEXT", []);
        _BindDisplayColorTableEXT = cast(PFN_wglBindDisplayColorTableEXT)loadSymbol(loader, "wglBindDisplayColorTableEXT", []);
        _DestroyDisplayColorTableEXT = cast(PFN_wglDestroyDisplayColorTableEXT)loadSymbol(loader, "wglDestroyDisplayColorTableEXT", []);

        // WGL_EXT_extensions_string,
        _GetExtensionsStringEXT = cast(PFN_wglGetExtensionsStringEXT)loadSymbol(loader, "wglGetExtensionsStringEXT", []);

        // WGL_EXT_make_current_read,
        _MakeContextCurrentEXT = cast(PFN_wglMakeContextCurrentEXT)loadSymbol(loader, "wglMakeContextCurrentEXT", []);
        _GetCurrentReadDCEXT = cast(PFN_wglGetCurrentReadDCEXT)loadSymbol(loader, "wglGetCurrentReadDCEXT", []);

        // WGL_EXT_pbuffer,
        _CreatePbufferEXT = cast(PFN_wglCreatePbufferEXT)loadSymbol(loader, "wglCreatePbufferEXT", []);
        _GetPbufferDCEXT = cast(PFN_wglGetPbufferDCEXT)loadSymbol(loader, "wglGetPbufferDCEXT", []);
        _ReleasePbufferDCEXT = cast(PFN_wglReleasePbufferDCEXT)loadSymbol(loader, "wglReleasePbufferDCEXT", []);
        _DestroyPbufferEXT = cast(PFN_wglDestroyPbufferEXT)loadSymbol(loader, "wglDestroyPbufferEXT", []);
        _QueryPbufferEXT = cast(PFN_wglQueryPbufferEXT)loadSymbol(loader, "wglQueryPbufferEXT", []);

        // WGL_EXT_pixel_format,
        _GetPixelFormatAttribivEXT = cast(PFN_wglGetPixelFormatAttribivEXT)loadSymbol(loader, "wglGetPixelFormatAttribivEXT", []);
        _GetPixelFormatAttribfvEXT = cast(PFN_wglGetPixelFormatAttribfvEXT)loadSymbol(loader, "wglGetPixelFormatAttribfvEXT", []);
        _ChoosePixelFormatEXT = cast(PFN_wglChoosePixelFormatEXT)loadSymbol(loader, "wglChoosePixelFormatEXT", []);

        // WGL_EXT_swap_control,
        _SwapIntervalEXT = cast(PFN_wglSwapIntervalEXT)loadSymbol(loader, "wglSwapIntervalEXT", []);
        _GetSwapIntervalEXT = cast(PFN_wglGetSwapIntervalEXT)loadSymbol(loader, "wglGetSwapIntervalEXT", []);

        // WGL_I3D_digital_video_control,
        _GetDigitalVideoParametersI3D = cast(PFN_wglGetDigitalVideoParametersI3D)loadSymbol(loader, "wglGetDigitalVideoParametersI3D", []);
        _SetDigitalVideoParametersI3D = cast(PFN_wglSetDigitalVideoParametersI3D)loadSymbol(loader, "wglSetDigitalVideoParametersI3D", []);

        // WGL_I3D_gamma,
        _GetGammaTableParametersI3D = cast(PFN_wglGetGammaTableParametersI3D)loadSymbol(loader, "wglGetGammaTableParametersI3D", []);
        _SetGammaTableParametersI3D = cast(PFN_wglSetGammaTableParametersI3D)loadSymbol(loader, "wglSetGammaTableParametersI3D", []);
        _GetGammaTableI3D = cast(PFN_wglGetGammaTableI3D)loadSymbol(loader, "wglGetGammaTableI3D", []);
        _SetGammaTableI3D = cast(PFN_wglSetGammaTableI3D)loadSymbol(loader, "wglSetGammaTableI3D", []);

        // WGL_I3D_genlock,
        _EnableGenlockI3D = cast(PFN_wglEnableGenlockI3D)loadSymbol(loader, "wglEnableGenlockI3D", []);
        _DisableGenlockI3D = cast(PFN_wglDisableGenlockI3D)loadSymbol(loader, "wglDisableGenlockI3D", []);
        _IsEnabledGenlockI3D = cast(PFN_wglIsEnabledGenlockI3D)loadSymbol(loader, "wglIsEnabledGenlockI3D", []);
        _GenlockSourceI3D = cast(PFN_wglGenlockSourceI3D)loadSymbol(loader, "wglGenlockSourceI3D", []);
        _GetGenlockSourceI3D = cast(PFN_wglGetGenlockSourceI3D)loadSymbol(loader, "wglGetGenlockSourceI3D", []);
        _GenlockSourceEdgeI3D = cast(PFN_wglGenlockSourceEdgeI3D)loadSymbol(loader, "wglGenlockSourceEdgeI3D", []);
        _GetGenlockSourceEdgeI3D = cast(PFN_wglGetGenlockSourceEdgeI3D)loadSymbol(loader, "wglGetGenlockSourceEdgeI3D", []);
        _GenlockSampleRateI3D = cast(PFN_wglGenlockSampleRateI3D)loadSymbol(loader, "wglGenlockSampleRateI3D", []);
        _GetGenlockSampleRateI3D = cast(PFN_wglGetGenlockSampleRateI3D)loadSymbol(loader, "wglGetGenlockSampleRateI3D", []);
        _GenlockSourceDelayI3D = cast(PFN_wglGenlockSourceDelayI3D)loadSymbol(loader, "wglGenlockSourceDelayI3D", []);
        _GetGenlockSourceDelayI3D = cast(PFN_wglGetGenlockSourceDelayI3D)loadSymbol(loader, "wglGetGenlockSourceDelayI3D", []);
        _QueryGenlockMaxSourceDelayI3D = cast(PFN_wglQueryGenlockMaxSourceDelayI3D)loadSymbol(loader, "wglQueryGenlockMaxSourceDelayI3D", []);

        // WGL_I3D_image_buffer,
        _CreateImageBufferI3D = cast(PFN_wglCreateImageBufferI3D)loadSymbol(loader, "wglCreateImageBufferI3D", []);
        _DestroyImageBufferI3D = cast(PFN_wglDestroyImageBufferI3D)loadSymbol(loader, "wglDestroyImageBufferI3D", []);
        _AssociateImageBufferEventsI3D = cast(PFN_wglAssociateImageBufferEventsI3D)loadSymbol(loader, "wglAssociateImageBufferEventsI3D", []);
        _ReleaseImageBufferEventsI3D = cast(PFN_wglReleaseImageBufferEventsI3D)loadSymbol(loader, "wglReleaseImageBufferEventsI3D", []);

        // WGL_I3D_swap_frame_lock,
        _EnableFrameLockI3D = cast(PFN_wglEnableFrameLockI3D)loadSymbol(loader, "wglEnableFrameLockI3D", []);
        _DisableFrameLockI3D = cast(PFN_wglDisableFrameLockI3D)loadSymbol(loader, "wglDisableFrameLockI3D", []);
        _IsEnabledFrameLockI3D = cast(PFN_wglIsEnabledFrameLockI3D)loadSymbol(loader, "wglIsEnabledFrameLockI3D", []);
        _QueryFrameLockMasterI3D = cast(PFN_wglQueryFrameLockMasterI3D)loadSymbol(loader, "wglQueryFrameLockMasterI3D", []);

        // WGL_I3D_swap_frame_usage,
        _GetFrameUsageI3D = cast(PFN_wglGetFrameUsageI3D)loadSymbol(loader, "wglGetFrameUsageI3D", []);
        _BeginFrameTrackingI3D = cast(PFN_wglBeginFrameTrackingI3D)loadSymbol(loader, "wglBeginFrameTrackingI3D", []);
        _EndFrameTrackingI3D = cast(PFN_wglEndFrameTrackingI3D)loadSymbol(loader, "wglEndFrameTrackingI3D", []);
        _QueryFrameTrackingI3D = cast(PFN_wglQueryFrameTrackingI3D)loadSymbol(loader, "wglQueryFrameTrackingI3D", []);

        // WGL_NV_DX_interop,
        _DXSetResourceShareHandleNV = cast(PFN_wglDXSetResourceShareHandleNV)loadSymbol(loader, "wglDXSetResourceShareHandleNV", []);
        _DXOpenDeviceNV = cast(PFN_wglDXOpenDeviceNV)loadSymbol(loader, "wglDXOpenDeviceNV", []);
        _DXCloseDeviceNV = cast(PFN_wglDXCloseDeviceNV)loadSymbol(loader, "wglDXCloseDeviceNV", []);
        _DXRegisterObjectNV = cast(PFN_wglDXRegisterObjectNV)loadSymbol(loader, "wglDXRegisterObjectNV", []);
        _DXUnregisterObjectNV = cast(PFN_wglDXUnregisterObjectNV)loadSymbol(loader, "wglDXUnregisterObjectNV", []);
        _DXObjectAccessNV = cast(PFN_wglDXObjectAccessNV)loadSymbol(loader, "wglDXObjectAccessNV", []);
        _DXLockObjectsNV = cast(PFN_wglDXLockObjectsNV)loadSymbol(loader, "wglDXLockObjectsNV", []);
        _DXUnlockObjectsNV = cast(PFN_wglDXUnlockObjectsNV)loadSymbol(loader, "wglDXUnlockObjectsNV", []);

        // WGL_NV_copy_image,
        _CopyImageSubDataNV = cast(PFN_wglCopyImageSubDataNV)loadSymbol(loader, "wglCopyImageSubDataNV", []);

        // WGL_NV_delay_before_swap,
        _DelayBeforeSwapNV = cast(PFN_wglDelayBeforeSwapNV)loadSymbol(loader, "wglDelayBeforeSwapNV", []);

        // WGL_NV_gpu_affinity,
        _EnumGpusNV = cast(PFN_wglEnumGpusNV)loadSymbol(loader, "wglEnumGpusNV", []);
        _EnumGpuDevicesNV = cast(PFN_wglEnumGpuDevicesNV)loadSymbol(loader, "wglEnumGpuDevicesNV", []);
        _CreateAffinityDCNV = cast(PFN_wglCreateAffinityDCNV)loadSymbol(loader, "wglCreateAffinityDCNV", []);
        _EnumGpusFromAffinityDCNV = cast(PFN_wglEnumGpusFromAffinityDCNV)loadSymbol(loader, "wglEnumGpusFromAffinityDCNV", []);
        _DeleteDCNV = cast(PFN_wglDeleteDCNV)loadSymbol(loader, "wglDeleteDCNV", []);

        // WGL_NV_present_video,
        _EnumerateVideoDevicesNV = cast(PFN_wglEnumerateVideoDevicesNV)loadSymbol(loader, "wglEnumerateVideoDevicesNV", []);
        _BindVideoDeviceNV = cast(PFN_wglBindVideoDeviceNV)loadSymbol(loader, "wglBindVideoDeviceNV", []);
        _QueryCurrentContextNV = cast(PFN_wglQueryCurrentContextNV)loadSymbol(loader, "wglQueryCurrentContextNV", []);

        // WGL_NV_swap_group,
        _JoinSwapGroupNV = cast(PFN_wglJoinSwapGroupNV)loadSymbol(loader, "wglJoinSwapGroupNV", []);
        _BindSwapBarrierNV = cast(PFN_wglBindSwapBarrierNV)loadSymbol(loader, "wglBindSwapBarrierNV", []);
        _QuerySwapGroupNV = cast(PFN_wglQuerySwapGroupNV)loadSymbol(loader, "wglQuerySwapGroupNV", []);
        _QueryMaxSwapGroupsNV = cast(PFN_wglQueryMaxSwapGroupsNV)loadSymbol(loader, "wglQueryMaxSwapGroupsNV", []);
        _QueryFrameCountNV = cast(PFN_wglQueryFrameCountNV)loadSymbol(loader, "wglQueryFrameCountNV", []);
        _ResetFrameCountNV = cast(PFN_wglResetFrameCountNV)loadSymbol(loader, "wglResetFrameCountNV", []);

        // WGL_NV_vertex_array_range,
        _AllocateMemoryNV = cast(PFN_wglAllocateMemoryNV)loadSymbol(loader, "wglAllocateMemoryNV", []);
        _FreeMemoryNV = cast(PFN_wglFreeMemoryNV)loadSymbol(loader, "wglFreeMemoryNV", []);

        // WGL_NV_video_capture,
        _BindVideoCaptureDeviceNV = cast(PFN_wglBindVideoCaptureDeviceNV)loadSymbol(loader, "wglBindVideoCaptureDeviceNV", []);
        _EnumerateVideoCaptureDevicesNV = cast(PFN_wglEnumerateVideoCaptureDevicesNV)loadSymbol(loader, "wglEnumerateVideoCaptureDevicesNV", []);
        _LockVideoCaptureDeviceNV = cast(PFN_wglLockVideoCaptureDeviceNV)loadSymbol(loader, "wglLockVideoCaptureDeviceNV", []);
        _QueryVideoCaptureDeviceNV = cast(PFN_wglQueryVideoCaptureDeviceNV)loadSymbol(loader, "wglQueryVideoCaptureDeviceNV", []);
        _ReleaseVideoCaptureDeviceNV = cast(PFN_wglReleaseVideoCaptureDeviceNV)loadSymbol(loader, "wglReleaseVideoCaptureDeviceNV", []);

        // WGL_NV_video_output,
        _GetVideoDeviceNV = cast(PFN_wglGetVideoDeviceNV)loadSymbol(loader, "wglGetVideoDeviceNV", []);
        _ReleaseVideoDeviceNV = cast(PFN_wglReleaseVideoDeviceNV)loadSymbol(loader, "wglReleaseVideoDeviceNV", []);
        _BindVideoImageNV = cast(PFN_wglBindVideoImageNV)loadSymbol(loader, "wglBindVideoImageNV", []);
        _ReleaseVideoImageNV = cast(PFN_wglReleaseVideoImageNV)loadSymbol(loader, "wglReleaseVideoImageNV", []);
        _SendPbufferToVideoNV = cast(PFN_wglSendPbufferToVideoNV)loadSymbol(loader, "wglSendPbufferToVideoNV", []);
        _GetVideoInfoNV = cast(PFN_wglGetVideoInfoNV)loadSymbol(loader, "wglGetVideoInfoNV", []);

        // WGL_OML_sync_control,
        _GetSyncValuesOML = cast(PFN_wglGetSyncValuesOML)loadSymbol(loader, "wglGetSyncValuesOML", []);
        _GetMscRateOML = cast(PFN_wglGetMscRateOML)loadSymbol(loader, "wglGetMscRateOML", []);
        _SwapBuffersMscOML = cast(PFN_wglSwapBuffersMscOML)loadSymbol(loader, "wglSwapBuffersMscOML", []);
        _SwapLayerBuffersMscOML = cast(PFN_wglSwapLayerBuffersMscOML)loadSymbol(loader, "wglSwapLayerBuffersMscOML", []);
        _WaitForMscOML = cast(PFN_wglWaitForMscOML)loadSymbol(loader, "wglWaitForMscOML", []);
        _WaitForSbcOML = cast(PFN_wglWaitForSbcOML)loadSymbol(loader, "wglWaitForSbcOML", []);
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

    /// Commands for WGL_VERSION_1_0
    public BOOL CopyContext (HGLRC hglrcSrc, HGLRC hglrcDst, UINT mask) const {
        assert(_CopyContext !is null, "WinGL command wglCopyContext was not loaded");
        return _CopyContext (hglrcSrc, hglrcDst, mask);
    }
    /// ditto
    public HGLRC CreateContext (HDC hDc) const {
        assert(_CreateContext !is null, "WinGL command wglCreateContext was not loaded");
        return _CreateContext (hDc);
    }
    /// ditto
    public HGLRC CreateLayerContext (HDC hDc, int level) const {
        assert(_CreateLayerContext !is null, "WinGL command wglCreateLayerContext was not loaded");
        return _CreateLayerContext (hDc, level);
    }
    /// ditto
    public BOOL DeleteContext (HGLRC oldContext) const {
        assert(_DeleteContext !is null, "WinGL command wglDeleteContext was not loaded");
        return _DeleteContext (oldContext);
    }
    /// ditto
    public BOOL DescribeLayerPlane (HDC hDc, int pixelFormat, int layerPlane, UINT nBytes, const(LAYERPLANEDESCRIPTOR)* plpd) const {
        assert(_DescribeLayerPlane !is null, "WinGL command wglDescribeLayerPlane was not loaded");
        return _DescribeLayerPlane (hDc, pixelFormat, layerPlane, nBytes, plpd);
    }
    /// ditto
    public HGLRC GetCurrentContext () const {
        assert(_GetCurrentContext !is null, "WinGL command wglGetCurrentContext was not loaded");
        return _GetCurrentContext ();
    }
    /// ditto
    public HDC GetCurrentDC () const {
        assert(_GetCurrentDC !is null, "WinGL command wglGetCurrentDC was not loaded");
        return _GetCurrentDC ();
    }
    /// ditto
    public int GetLayerPaletteEntries (HDC hdc, int iLayerPlane, int iStart, int cEntries, const(COLORREF)* pcr) const {
        assert(_GetLayerPaletteEntries !is null, "WinGL command wglGetLayerPaletteEntries was not loaded");
        return _GetLayerPaletteEntries (hdc, iLayerPlane, iStart, cEntries, pcr);
    }
    /// ditto
    public PROC GetProcAddress (LPCSTR lpszProc) const {
        assert(_GetProcAddress !is null, "WinGL command wglGetProcAddress was not loaded");
        return _GetProcAddress (lpszProc);
    }
    /// ditto
    public BOOL MakeCurrent (HDC hDc, HGLRC newContext) const {
        assert(_MakeCurrent !is null, "WinGL command wglMakeCurrent was not loaded");
        return _MakeCurrent (hDc, newContext);
    }
    /// ditto
    public BOOL RealizeLayerPalette (HDC hdc, int iLayerPlane, BOOL bRealize) const {
        assert(_RealizeLayerPalette !is null, "WinGL command wglRealizeLayerPalette was not loaded");
        return _RealizeLayerPalette (hdc, iLayerPlane, bRealize);
    }
    /// ditto
    public int SetLayerPaletteEntries (HDC hdc, int iLayerPlane, int iStart, int cEntries, const(COLORREF)* pcr) const {
        assert(_SetLayerPaletteEntries !is null, "WinGL command wglSetLayerPaletteEntries was not loaded");
        return _SetLayerPaletteEntries (hdc, iLayerPlane, iStart, cEntries, pcr);
    }
    /// ditto
    public BOOL ShareLists (HGLRC hrcSrvShare, HGLRC hrcSrvSource) const {
        assert(_ShareLists !is null, "WinGL command wglShareLists was not loaded");
        return _ShareLists (hrcSrvShare, hrcSrvSource);
    }
    /// ditto
    public BOOL SwapLayerBuffers (HDC hdc, UINT fuFlags) const {
        assert(_SwapLayerBuffers !is null, "WinGL command wglSwapLayerBuffers was not loaded");
        return _SwapLayerBuffers (hdc, fuFlags);
    }
    /// ditto
    public BOOL UseFontBitmaps (HDC hDC, DWORD first, DWORD count, DWORD listBase) const {
        assert(_UseFontBitmaps !is null, "WinGL command wglUseFontBitmaps was not loaded");
        return _UseFontBitmaps (hDC, first, count, listBase);
    }
    /// ditto
    public BOOL UseFontBitmapsA (HDC hDC, DWORD first, DWORD count, DWORD listBase) const {
        assert(_UseFontBitmapsA !is null, "WinGL command wglUseFontBitmapsA was not loaded");
        return _UseFontBitmapsA (hDC, first, count, listBase);
    }
    /// ditto
    public BOOL UseFontBitmapsW (HDC hDC, DWORD first, DWORD count, DWORD listBase) const {
        assert(_UseFontBitmapsW !is null, "WinGL command wglUseFontBitmapsW was not loaded");
        return _UseFontBitmapsW (hDC, first, count, listBase);
    }
    /// ditto
    public BOOL UseFontOutlines (HDC hDC, DWORD first, DWORD count, DWORD listBase, FLOAT deviation, FLOAT extrusion, int format, LPGLYPHMETRICSFLOAT lpgmf) const {
        assert(_UseFontOutlines !is null, "WinGL command wglUseFontOutlines was not loaded");
        return _UseFontOutlines (hDC, first, count, listBase, deviation, extrusion, format, lpgmf);
    }
    /// ditto
    public BOOL UseFontOutlinesA (HDC hDC, DWORD first, DWORD count, DWORD listBase, FLOAT deviation, FLOAT extrusion, int format, LPGLYPHMETRICSFLOAT lpgmf) const {
        assert(_UseFontOutlinesA !is null, "WinGL command wglUseFontOutlinesA was not loaded");
        return _UseFontOutlinesA (hDC, first, count, listBase, deviation, extrusion, format, lpgmf);
    }
    /// ditto
    public BOOL UseFontOutlinesW (HDC hDC, DWORD first, DWORD count, DWORD listBase, FLOAT deviation, FLOAT extrusion, int format, LPGLYPHMETRICSFLOAT lpgmf) const {
        assert(_UseFontOutlinesW !is null, "WinGL command wglUseFontOutlinesW was not loaded");
        return _UseFontOutlinesW (hDC, first, count, listBase, deviation, extrusion, format, lpgmf);
    }

    /// Commands for WGL_ARB_buffer_region
    public HANDLE CreateBufferRegionARB (HDC hDC, int iLayerPlane, UINT uType) const {
        assert(_CreateBufferRegionARB !is null, "WinGL command wglCreateBufferRegionARB was not loaded");
        return _CreateBufferRegionARB (hDC, iLayerPlane, uType);
    }
    /// ditto
    public VOID DeleteBufferRegionARB (HANDLE hRegion) const {
        assert(_DeleteBufferRegionARB !is null, "WinGL command wglDeleteBufferRegionARB was not loaded");
        return _DeleteBufferRegionARB (hRegion);
    }
    /// ditto
    public BOOL SaveBufferRegionARB (HANDLE hRegion, int x, int y, int width, int height) const {
        assert(_SaveBufferRegionARB !is null, "WinGL command wglSaveBufferRegionARB was not loaded");
        return _SaveBufferRegionARB (hRegion, x, y, width, height);
    }
    /// ditto
    public BOOL RestoreBufferRegionARB (HANDLE hRegion, int x, int y, int width, int height, int xSrc, int ySrc) const {
        assert(_RestoreBufferRegionARB !is null, "WinGL command wglRestoreBufferRegionARB was not loaded");
        return _RestoreBufferRegionARB (hRegion, x, y, width, height, xSrc, ySrc);
    }

    /// Commands for WGL_ARB_create_context
    public HGLRC CreateContextAttribsARB (HDC hDC, HGLRC hShareContext, const(int)* attribList) const {
        assert(_CreateContextAttribsARB !is null, "WinGL command wglCreateContextAttribsARB was not loaded");
        return _CreateContextAttribsARB (hDC, hShareContext, attribList);
    }

    /// Commands for WGL_ARB_extensions_string
    public const(char)* GetExtensionsStringARB (HDC hdc) const {
        assert(_GetExtensionsStringARB !is null, "WinGL command wglGetExtensionsStringARB was not loaded");
        return _GetExtensionsStringARB (hdc);
    }

    /// Commands for WGL_ARB_make_current_read
    public BOOL MakeContextCurrentARB (HDC hDrawDC, HDC hReadDC, HGLRC hglrc) const {
        assert(_MakeContextCurrentARB !is null, "WinGL command wglMakeContextCurrentARB was not loaded");
        return _MakeContextCurrentARB (hDrawDC, hReadDC, hglrc);
    }
    /// ditto
    public HDC GetCurrentReadDCARB () const {
        assert(_GetCurrentReadDCARB !is null, "WinGL command wglGetCurrentReadDCARB was not loaded");
        return _GetCurrentReadDCARB ();
    }

    /// Commands for WGL_ARB_pbuffer
    public HPBUFFERARB CreatePbufferARB (HDC hDC, int iPixelFormat, int iWidth, int iHeight, const(int)* piAttribList) const {
        assert(_CreatePbufferARB !is null, "WinGL command wglCreatePbufferARB was not loaded");
        return _CreatePbufferARB (hDC, iPixelFormat, iWidth, iHeight, piAttribList);
    }
    /// ditto
    public HDC GetPbufferDCARB (HPBUFFERARB hPbuffer) const {
        assert(_GetPbufferDCARB !is null, "WinGL command wglGetPbufferDCARB was not loaded");
        return _GetPbufferDCARB (hPbuffer);
    }
    /// ditto
    public int ReleasePbufferDCARB (HPBUFFERARB hPbuffer, HDC hDC) const {
        assert(_ReleasePbufferDCARB !is null, "WinGL command wglReleasePbufferDCARB was not loaded");
        return _ReleasePbufferDCARB (hPbuffer, hDC);
    }
    /// ditto
    public BOOL DestroyPbufferARB (HPBUFFERARB hPbuffer) const {
        assert(_DestroyPbufferARB !is null, "WinGL command wglDestroyPbufferARB was not loaded");
        return _DestroyPbufferARB (hPbuffer);
    }
    /// ditto
    public BOOL QueryPbufferARB (HPBUFFERARB hPbuffer, int iAttribute, int* piValue) const {
        assert(_QueryPbufferARB !is null, "WinGL command wglQueryPbufferARB was not loaded");
        return _QueryPbufferARB (hPbuffer, iAttribute, piValue);
    }

    /// Commands for WGL_ARB_pixel_format
    public BOOL GetPixelFormatAttribivARB (HDC hdc, int iPixelFormat, int iLayerPlane, UINT nAttributes, const(int)* piAttributes, int* piValues) const {
        assert(_GetPixelFormatAttribivARB !is null, "WinGL command wglGetPixelFormatAttribivARB was not loaded");
        return _GetPixelFormatAttribivARB (hdc, iPixelFormat, iLayerPlane, nAttributes, piAttributes, piValues);
    }
    /// ditto
    public BOOL GetPixelFormatAttribfvARB (HDC hdc, int iPixelFormat, int iLayerPlane, UINT nAttributes, const(int)* piAttributes, FLOAT* pfValues) const {
        assert(_GetPixelFormatAttribfvARB !is null, "WinGL command wglGetPixelFormatAttribfvARB was not loaded");
        return _GetPixelFormatAttribfvARB (hdc, iPixelFormat, iLayerPlane, nAttributes, piAttributes, pfValues);
    }
    /// ditto
    public BOOL ChoosePixelFormatARB (HDC hdc, const(int)* piAttribIList, const(FLOAT)* pfAttribFList, UINT nMaxFormats, int* piFormats, UINT* nNumFormats) const {
        assert(_ChoosePixelFormatARB !is null, "WinGL command wglChoosePixelFormatARB was not loaded");
        return _ChoosePixelFormatARB (hdc, piAttribIList, pfAttribFList, nMaxFormats, piFormats, nNumFormats);
    }

    /// Commands for WGL_ARB_render_texture
    public BOOL BindTexImageARB (HPBUFFERARB hPbuffer, int iBuffer) const {
        assert(_BindTexImageARB !is null, "WinGL command wglBindTexImageARB was not loaded");
        return _BindTexImageARB (hPbuffer, iBuffer);
    }
    /// ditto
    public BOOL ReleaseTexImageARB (HPBUFFERARB hPbuffer, int iBuffer) const {
        assert(_ReleaseTexImageARB !is null, "WinGL command wglReleaseTexImageARB was not loaded");
        return _ReleaseTexImageARB (hPbuffer, iBuffer);
    }
    /// ditto
    public BOOL SetPbufferAttribARB (HPBUFFERARB hPbuffer, const(int)* piAttribList) const {
        assert(_SetPbufferAttribARB !is null, "WinGL command wglSetPbufferAttribARB was not loaded");
        return _SetPbufferAttribARB (hPbuffer, piAttribList);
    }

    /// Commands for WGL_3DL_stereo_control
    public BOOL SetStereoEmitterState3DL (HDC hDC, UINT uState) const {
        assert(_SetStereoEmitterState3DL !is null, "WinGL command wglSetStereoEmitterState3DL was not loaded");
        return _SetStereoEmitterState3DL (hDC, uState);
    }

    /// Commands for WGL_AMD_gpu_association
    public UINT GetGPUIDsAMD (UINT maxCount, UINT* ids) const {
        assert(_GetGPUIDsAMD !is null, "WinGL command wglGetGPUIDsAMD was not loaded");
        return _GetGPUIDsAMD (maxCount, ids);
    }
    /// ditto
    public INT GetGPUInfoAMD (UINT id, int property, GLenum dataType, UINT size, void* data) const {
        assert(_GetGPUInfoAMD !is null, "WinGL command wglGetGPUInfoAMD was not loaded");
        return _GetGPUInfoAMD (id, property, dataType, size, data);
    }
    /// ditto
    public UINT GetContextGPUIDAMD (HGLRC hglrc) const {
        assert(_GetContextGPUIDAMD !is null, "WinGL command wglGetContextGPUIDAMD was not loaded");
        return _GetContextGPUIDAMD (hglrc);
    }
    /// ditto
    public HGLRC CreateAssociatedContextAMD (UINT id) const {
        assert(_CreateAssociatedContextAMD !is null, "WinGL command wglCreateAssociatedContextAMD was not loaded");
        return _CreateAssociatedContextAMD (id);
    }
    /// ditto
    public HGLRC CreateAssociatedContextAttribsAMD (UINT id, HGLRC hShareContext, const(int)* attribList) const {
        assert(_CreateAssociatedContextAttribsAMD !is null, "WinGL command wglCreateAssociatedContextAttribsAMD was not loaded");
        return _CreateAssociatedContextAttribsAMD (id, hShareContext, attribList);
    }
    /// ditto
    public BOOL DeleteAssociatedContextAMD (HGLRC hglrc) const {
        assert(_DeleteAssociatedContextAMD !is null, "WinGL command wglDeleteAssociatedContextAMD was not loaded");
        return _DeleteAssociatedContextAMD (hglrc);
    }
    /// ditto
    public BOOL MakeAssociatedContextCurrentAMD (HGLRC hglrc) const {
        assert(_MakeAssociatedContextCurrentAMD !is null, "WinGL command wglMakeAssociatedContextCurrentAMD was not loaded");
        return _MakeAssociatedContextCurrentAMD (hglrc);
    }
    /// ditto
    public HGLRC GetCurrentAssociatedContextAMD () const {
        assert(_GetCurrentAssociatedContextAMD !is null, "WinGL command wglGetCurrentAssociatedContextAMD was not loaded");
        return _GetCurrentAssociatedContextAMD ();
    }
    /// ditto
    public VOID BlitContextFramebufferAMD (HGLRC dstCtx, GLint srcX0, GLint srcY0, GLint srcX1, GLint srcY1, GLint dstX0, GLint dstY0, GLint dstX1, GLint dstY1, GLbitfield mask, GLenum filter) const {
        assert(_BlitContextFramebufferAMD !is null, "WinGL command wglBlitContextFramebufferAMD was not loaded");
        return _BlitContextFramebufferAMD (dstCtx, srcX0, srcY0, srcX1, srcY1, dstX0, dstY0, dstX1, dstY1, mask, filter);
    }

    /// Commands for WGL_EXT_display_color_table
    public GLboolean CreateDisplayColorTableEXT (GLushort id) const {
        assert(_CreateDisplayColorTableEXT !is null, "WinGL command wglCreateDisplayColorTableEXT was not loaded");
        return _CreateDisplayColorTableEXT (id);
    }
    /// ditto
    public GLboolean LoadDisplayColorTableEXT (const(GLushort)* table, GLuint length) const {
        assert(_LoadDisplayColorTableEXT !is null, "WinGL command wglLoadDisplayColorTableEXT was not loaded");
        return _LoadDisplayColorTableEXT (table, length);
    }
    /// ditto
    public GLboolean BindDisplayColorTableEXT (GLushort id) const {
        assert(_BindDisplayColorTableEXT !is null, "WinGL command wglBindDisplayColorTableEXT was not loaded");
        return _BindDisplayColorTableEXT (id);
    }
    /// ditto
    public VOID DestroyDisplayColorTableEXT (GLushort id) const {
        assert(_DestroyDisplayColorTableEXT !is null, "WinGL command wglDestroyDisplayColorTableEXT was not loaded");
        return _DestroyDisplayColorTableEXT (id);
    }

    /// Commands for WGL_EXT_extensions_string
    public const(char)* GetExtensionsStringEXT () const {
        assert(_GetExtensionsStringEXT !is null, "WinGL command wglGetExtensionsStringEXT was not loaded");
        return _GetExtensionsStringEXT ();
    }

    /// Commands for WGL_EXT_make_current_read
    public BOOL MakeContextCurrentEXT (HDC hDrawDC, HDC hReadDC, HGLRC hglrc) const {
        assert(_MakeContextCurrentEXT !is null, "WinGL command wglMakeContextCurrentEXT was not loaded");
        return _MakeContextCurrentEXT (hDrawDC, hReadDC, hglrc);
    }
    /// ditto
    public HDC GetCurrentReadDCEXT () const {
        assert(_GetCurrentReadDCEXT !is null, "WinGL command wglGetCurrentReadDCEXT was not loaded");
        return _GetCurrentReadDCEXT ();
    }

    /// Commands for WGL_EXT_pbuffer
    public HPBUFFEREXT CreatePbufferEXT (HDC hDC, int iPixelFormat, int iWidth, int iHeight, const(int)* piAttribList) const {
        assert(_CreatePbufferEXT !is null, "WinGL command wglCreatePbufferEXT was not loaded");
        return _CreatePbufferEXT (hDC, iPixelFormat, iWidth, iHeight, piAttribList);
    }
    /// ditto
    public HDC GetPbufferDCEXT (HPBUFFEREXT hPbuffer) const {
        assert(_GetPbufferDCEXT !is null, "WinGL command wglGetPbufferDCEXT was not loaded");
        return _GetPbufferDCEXT (hPbuffer);
    }
    /// ditto
    public int ReleasePbufferDCEXT (HPBUFFEREXT hPbuffer, HDC hDC) const {
        assert(_ReleasePbufferDCEXT !is null, "WinGL command wglReleasePbufferDCEXT was not loaded");
        return _ReleasePbufferDCEXT (hPbuffer, hDC);
    }
    /// ditto
    public BOOL DestroyPbufferEXT (HPBUFFEREXT hPbuffer) const {
        assert(_DestroyPbufferEXT !is null, "WinGL command wglDestroyPbufferEXT was not loaded");
        return _DestroyPbufferEXT (hPbuffer);
    }
    /// ditto
    public BOOL QueryPbufferEXT (HPBUFFEREXT hPbuffer, int iAttribute, int* piValue) const {
        assert(_QueryPbufferEXT !is null, "WinGL command wglQueryPbufferEXT was not loaded");
        return _QueryPbufferEXT (hPbuffer, iAttribute, piValue);
    }

    /// Commands for WGL_EXT_pixel_format
    public BOOL GetPixelFormatAttribivEXT (HDC hdc, int iPixelFormat, int iLayerPlane, UINT nAttributes, int* piAttributes, int* piValues) const {
        assert(_GetPixelFormatAttribivEXT !is null, "WinGL command wglGetPixelFormatAttribivEXT was not loaded");
        return _GetPixelFormatAttribivEXT (hdc, iPixelFormat, iLayerPlane, nAttributes, piAttributes, piValues);
    }
    /// ditto
    public BOOL GetPixelFormatAttribfvEXT (HDC hdc, int iPixelFormat, int iLayerPlane, UINT nAttributes, int* piAttributes, FLOAT* pfValues) const {
        assert(_GetPixelFormatAttribfvEXT !is null, "WinGL command wglGetPixelFormatAttribfvEXT was not loaded");
        return _GetPixelFormatAttribfvEXT (hdc, iPixelFormat, iLayerPlane, nAttributes, piAttributes, pfValues);
    }
    /// ditto
    public BOOL ChoosePixelFormatEXT (HDC hdc, const(int)* piAttribIList, const(FLOAT)* pfAttribFList, UINT nMaxFormats, int* piFormats, UINT* nNumFormats) const {
        assert(_ChoosePixelFormatEXT !is null, "WinGL command wglChoosePixelFormatEXT was not loaded");
        return _ChoosePixelFormatEXT (hdc, piAttribIList, pfAttribFList, nMaxFormats, piFormats, nNumFormats);
    }

    /// Commands for WGL_EXT_swap_control
    public BOOL SwapIntervalEXT (int interval) const {
        assert(_SwapIntervalEXT !is null, "WinGL command wglSwapIntervalEXT was not loaded");
        return _SwapIntervalEXT (interval);
    }
    /// ditto
    public int GetSwapIntervalEXT () const {
        assert(_GetSwapIntervalEXT !is null, "WinGL command wglGetSwapIntervalEXT was not loaded");
        return _GetSwapIntervalEXT ();
    }

    /// Commands for WGL_I3D_digital_video_control
    public BOOL GetDigitalVideoParametersI3D (HDC hDC, int iAttribute, int* piValue) const {
        assert(_GetDigitalVideoParametersI3D !is null, "WinGL command wglGetDigitalVideoParametersI3D was not loaded");
        return _GetDigitalVideoParametersI3D (hDC, iAttribute, piValue);
    }
    /// ditto
    public BOOL SetDigitalVideoParametersI3D (HDC hDC, int iAttribute, const(int)* piValue) const {
        assert(_SetDigitalVideoParametersI3D !is null, "WinGL command wglSetDigitalVideoParametersI3D was not loaded");
        return _SetDigitalVideoParametersI3D (hDC, iAttribute, piValue);
    }

    /// Commands for WGL_I3D_gamma
    public BOOL GetGammaTableParametersI3D (HDC hDC, int iAttribute, int* piValue) const {
        assert(_GetGammaTableParametersI3D !is null, "WinGL command wglGetGammaTableParametersI3D was not loaded");
        return _GetGammaTableParametersI3D (hDC, iAttribute, piValue);
    }
    /// ditto
    public BOOL SetGammaTableParametersI3D (HDC hDC, int iAttribute, const(int)* piValue) const {
        assert(_SetGammaTableParametersI3D !is null, "WinGL command wglSetGammaTableParametersI3D was not loaded");
        return _SetGammaTableParametersI3D (hDC, iAttribute, piValue);
    }
    /// ditto
    public BOOL GetGammaTableI3D (HDC hDC, int iEntries, USHORT* puRed, USHORT* puGreen, USHORT* puBlue) const {
        assert(_GetGammaTableI3D !is null, "WinGL command wglGetGammaTableI3D was not loaded");
        return _GetGammaTableI3D (hDC, iEntries, puRed, puGreen, puBlue);
    }
    /// ditto
    public BOOL SetGammaTableI3D (HDC hDC, int iEntries, const(USHORT)* puRed, const(USHORT)* puGreen, const(USHORT)* puBlue) const {
        assert(_SetGammaTableI3D !is null, "WinGL command wglSetGammaTableI3D was not loaded");
        return _SetGammaTableI3D (hDC, iEntries, puRed, puGreen, puBlue);
    }

    /// Commands for WGL_I3D_genlock
    public BOOL EnableGenlockI3D (HDC hDC) const {
        assert(_EnableGenlockI3D !is null, "WinGL command wglEnableGenlockI3D was not loaded");
        return _EnableGenlockI3D (hDC);
    }
    /// ditto
    public BOOL DisableGenlockI3D (HDC hDC) const {
        assert(_DisableGenlockI3D !is null, "WinGL command wglDisableGenlockI3D was not loaded");
        return _DisableGenlockI3D (hDC);
    }
    /// ditto
    public BOOL IsEnabledGenlockI3D (HDC hDC, BOOL* pFlag) const {
        assert(_IsEnabledGenlockI3D !is null, "WinGL command wglIsEnabledGenlockI3D was not loaded");
        return _IsEnabledGenlockI3D (hDC, pFlag);
    }
    /// ditto
    public BOOL GenlockSourceI3D (HDC hDC, UINT uSource) const {
        assert(_GenlockSourceI3D !is null, "WinGL command wglGenlockSourceI3D was not loaded");
        return _GenlockSourceI3D (hDC, uSource);
    }
    /// ditto
    public BOOL GetGenlockSourceI3D (HDC hDC, UINT* uSource) const {
        assert(_GetGenlockSourceI3D !is null, "WinGL command wglGetGenlockSourceI3D was not loaded");
        return _GetGenlockSourceI3D (hDC, uSource);
    }
    /// ditto
    public BOOL GenlockSourceEdgeI3D (HDC hDC, UINT uEdge) const {
        assert(_GenlockSourceEdgeI3D !is null, "WinGL command wglGenlockSourceEdgeI3D was not loaded");
        return _GenlockSourceEdgeI3D (hDC, uEdge);
    }
    /// ditto
    public BOOL GetGenlockSourceEdgeI3D (HDC hDC, UINT* uEdge) const {
        assert(_GetGenlockSourceEdgeI3D !is null, "WinGL command wglGetGenlockSourceEdgeI3D was not loaded");
        return _GetGenlockSourceEdgeI3D (hDC, uEdge);
    }
    /// ditto
    public BOOL GenlockSampleRateI3D (HDC hDC, UINT uRate) const {
        assert(_GenlockSampleRateI3D !is null, "WinGL command wglGenlockSampleRateI3D was not loaded");
        return _GenlockSampleRateI3D (hDC, uRate);
    }
    /// ditto
    public BOOL GetGenlockSampleRateI3D (HDC hDC, UINT* uRate) const {
        assert(_GetGenlockSampleRateI3D !is null, "WinGL command wglGetGenlockSampleRateI3D was not loaded");
        return _GetGenlockSampleRateI3D (hDC, uRate);
    }
    /// ditto
    public BOOL GenlockSourceDelayI3D (HDC hDC, UINT uDelay) const {
        assert(_GenlockSourceDelayI3D !is null, "WinGL command wglGenlockSourceDelayI3D was not loaded");
        return _GenlockSourceDelayI3D (hDC, uDelay);
    }
    /// ditto
    public BOOL GetGenlockSourceDelayI3D (HDC hDC, UINT* uDelay) const {
        assert(_GetGenlockSourceDelayI3D !is null, "WinGL command wglGetGenlockSourceDelayI3D was not loaded");
        return _GetGenlockSourceDelayI3D (hDC, uDelay);
    }
    /// ditto
    public BOOL QueryGenlockMaxSourceDelayI3D (HDC hDC, UINT* uMaxLineDelay, UINT* uMaxPixelDelay) const {
        assert(_QueryGenlockMaxSourceDelayI3D !is null, "WinGL command wglQueryGenlockMaxSourceDelayI3D was not loaded");
        return _QueryGenlockMaxSourceDelayI3D (hDC, uMaxLineDelay, uMaxPixelDelay);
    }

    /// Commands for WGL_I3D_image_buffer
    public LPVOID CreateImageBufferI3D (HDC hDC, DWORD dwSize, UINT uFlags) const {
        assert(_CreateImageBufferI3D !is null, "WinGL command wglCreateImageBufferI3D was not loaded");
        return _CreateImageBufferI3D (hDC, dwSize, uFlags);
    }
    /// ditto
    public BOOL DestroyImageBufferI3D (HDC hDC, LPVOID pAddress) const {
        assert(_DestroyImageBufferI3D !is null, "WinGL command wglDestroyImageBufferI3D was not loaded");
        return _DestroyImageBufferI3D (hDC, pAddress);
    }
    /// ditto
    public BOOL AssociateImageBufferEventsI3D (HDC hDC, const(HANDLE)* pEvent, const(LPVOID)* pAddress, const(DWORD)* pSize, UINT count) const {
        assert(_AssociateImageBufferEventsI3D !is null, "WinGL command wglAssociateImageBufferEventsI3D was not loaded");
        return _AssociateImageBufferEventsI3D (hDC, pEvent, pAddress, pSize, count);
    }
    /// ditto
    public BOOL ReleaseImageBufferEventsI3D (HDC hDC, const(LPVOID)* pAddress, UINT count) const {
        assert(_ReleaseImageBufferEventsI3D !is null, "WinGL command wglReleaseImageBufferEventsI3D was not loaded");
        return _ReleaseImageBufferEventsI3D (hDC, pAddress, count);
    }

    /// Commands for WGL_I3D_swap_frame_lock
    public BOOL EnableFrameLockI3D () const {
        assert(_EnableFrameLockI3D !is null, "WinGL command wglEnableFrameLockI3D was not loaded");
        return _EnableFrameLockI3D ();
    }
    /// ditto
    public BOOL DisableFrameLockI3D () const {
        assert(_DisableFrameLockI3D !is null, "WinGL command wglDisableFrameLockI3D was not loaded");
        return _DisableFrameLockI3D ();
    }
    /// ditto
    public BOOL IsEnabledFrameLockI3D (BOOL* pFlag) const {
        assert(_IsEnabledFrameLockI3D !is null, "WinGL command wglIsEnabledFrameLockI3D was not loaded");
        return _IsEnabledFrameLockI3D (pFlag);
    }
    /// ditto
    public BOOL QueryFrameLockMasterI3D (BOOL* pFlag) const {
        assert(_QueryFrameLockMasterI3D !is null, "WinGL command wglQueryFrameLockMasterI3D was not loaded");
        return _QueryFrameLockMasterI3D (pFlag);
    }

    /// Commands for WGL_I3D_swap_frame_usage
    public BOOL GetFrameUsageI3D (float* pUsage) const {
        assert(_GetFrameUsageI3D !is null, "WinGL command wglGetFrameUsageI3D was not loaded");
        return _GetFrameUsageI3D (pUsage);
    }
    /// ditto
    public BOOL BeginFrameTrackingI3D () const {
        assert(_BeginFrameTrackingI3D !is null, "WinGL command wglBeginFrameTrackingI3D was not loaded");
        return _BeginFrameTrackingI3D ();
    }
    /// ditto
    public BOOL EndFrameTrackingI3D () const {
        assert(_EndFrameTrackingI3D !is null, "WinGL command wglEndFrameTrackingI3D was not loaded");
        return _EndFrameTrackingI3D ();
    }
    /// ditto
    public BOOL QueryFrameTrackingI3D (DWORD* pFrameCount, DWORD* pMissedFrames, float* pLastMissedUsage) const {
        assert(_QueryFrameTrackingI3D !is null, "WinGL command wglQueryFrameTrackingI3D was not loaded");
        return _QueryFrameTrackingI3D (pFrameCount, pMissedFrames, pLastMissedUsage);
    }

    /// Commands for WGL_NV_DX_interop
    public BOOL DXSetResourceShareHandleNV (void* dxObject, HANDLE shareHandle) const {
        assert(_DXSetResourceShareHandleNV !is null, "WinGL command wglDXSetResourceShareHandleNV was not loaded");
        return _DXSetResourceShareHandleNV (dxObject, shareHandle);
    }
    /// ditto
    public HANDLE DXOpenDeviceNV (void* dxDevice) const {
        assert(_DXOpenDeviceNV !is null, "WinGL command wglDXOpenDeviceNV was not loaded");
        return _DXOpenDeviceNV (dxDevice);
    }
    /// ditto
    public BOOL DXCloseDeviceNV (HANDLE hDevice) const {
        assert(_DXCloseDeviceNV !is null, "WinGL command wglDXCloseDeviceNV was not loaded");
        return _DXCloseDeviceNV (hDevice);
    }
    /// ditto
    public HANDLE DXRegisterObjectNV (HANDLE hDevice, void* dxObject, GLuint name, GLenum type, GLenum access) const {
        assert(_DXRegisterObjectNV !is null, "WinGL command wglDXRegisterObjectNV was not loaded");
        return _DXRegisterObjectNV (hDevice, dxObject, name, type, access);
    }
    /// ditto
    public BOOL DXUnregisterObjectNV (HANDLE hDevice, HANDLE hObject) const {
        assert(_DXUnregisterObjectNV !is null, "WinGL command wglDXUnregisterObjectNV was not loaded");
        return _DXUnregisterObjectNV (hDevice, hObject);
    }
    /// ditto
    public BOOL DXObjectAccessNV (HANDLE hObject, GLenum access) const {
        assert(_DXObjectAccessNV !is null, "WinGL command wglDXObjectAccessNV was not loaded");
        return _DXObjectAccessNV (hObject, access);
    }
    /// ditto
    public BOOL DXLockObjectsNV (HANDLE hDevice, GLint count, HANDLE* hObjects) const {
        assert(_DXLockObjectsNV !is null, "WinGL command wglDXLockObjectsNV was not loaded");
        return _DXLockObjectsNV (hDevice, count, hObjects);
    }
    /// ditto
    public BOOL DXUnlockObjectsNV (HANDLE hDevice, GLint count, HANDLE* hObjects) const {
        assert(_DXUnlockObjectsNV !is null, "WinGL command wglDXUnlockObjectsNV was not loaded");
        return _DXUnlockObjectsNV (hDevice, count, hObjects);
    }

    /// Commands for WGL_NV_copy_image
    public BOOL CopyImageSubDataNV (HGLRC hSrcRC, GLuint srcName, GLenum srcTarget, GLint srcLevel, GLint srcX, GLint srcY, GLint srcZ, HGLRC hDstRC, GLuint dstName, GLenum dstTarget, GLint dstLevel, GLint dstX, GLint dstY, GLint dstZ, GLsizei width, GLsizei height, GLsizei depth) const {
        assert(_CopyImageSubDataNV !is null, "WinGL command wglCopyImageSubDataNV was not loaded");
        return _CopyImageSubDataNV (hSrcRC, srcName, srcTarget, srcLevel, srcX, srcY, srcZ, hDstRC, dstName, dstTarget, dstLevel, dstX, dstY, dstZ, width, height, depth);
    }

    /// Commands for WGL_NV_delay_before_swap
    public BOOL DelayBeforeSwapNV (HDC hDC, GLfloat seconds) const {
        assert(_DelayBeforeSwapNV !is null, "WinGL command wglDelayBeforeSwapNV was not loaded");
        return _DelayBeforeSwapNV (hDC, seconds);
    }

    /// Commands for WGL_NV_gpu_affinity
    public BOOL EnumGpusNV (UINT iGpuIndex, HGPUNV* phGpu) const {
        assert(_EnumGpusNV !is null, "WinGL command wglEnumGpusNV was not loaded");
        return _EnumGpusNV (iGpuIndex, phGpu);
    }
    /// ditto
    public BOOL EnumGpuDevicesNV (HGPUNV hGpu, UINT iDeviceIndex, PGPU_DEVICE lpGpuDevice) const {
        assert(_EnumGpuDevicesNV !is null, "WinGL command wglEnumGpuDevicesNV was not loaded");
        return _EnumGpuDevicesNV (hGpu, iDeviceIndex, lpGpuDevice);
    }
    /// ditto
    public HDC CreateAffinityDCNV (const(HGPUNV)* phGpuList) const {
        assert(_CreateAffinityDCNV !is null, "WinGL command wglCreateAffinityDCNV was not loaded");
        return _CreateAffinityDCNV (phGpuList);
    }
    /// ditto
    public BOOL EnumGpusFromAffinityDCNV (HDC hAffinityDC, UINT iGpuIndex, HGPUNV* hGpu) const {
        assert(_EnumGpusFromAffinityDCNV !is null, "WinGL command wglEnumGpusFromAffinityDCNV was not loaded");
        return _EnumGpusFromAffinityDCNV (hAffinityDC, iGpuIndex, hGpu);
    }
    /// ditto
    public BOOL DeleteDCNV (HDC hdc) const {
        assert(_DeleteDCNV !is null, "WinGL command wglDeleteDCNV was not loaded");
        return _DeleteDCNV (hdc);
    }

    /// Commands for WGL_NV_present_video
    public int EnumerateVideoDevicesNV (HDC hDC, HVIDEOOUTPUTDEVICENV* phDeviceList) const {
        assert(_EnumerateVideoDevicesNV !is null, "WinGL command wglEnumerateVideoDevicesNV was not loaded");
        return _EnumerateVideoDevicesNV (hDC, phDeviceList);
    }
    /// ditto
    public BOOL BindVideoDeviceNV (HDC hDC, uint uVideoSlot, HVIDEOOUTPUTDEVICENV hVideoDevice, const(int)* piAttribList) const {
        assert(_BindVideoDeviceNV !is null, "WinGL command wglBindVideoDeviceNV was not loaded");
        return _BindVideoDeviceNV (hDC, uVideoSlot, hVideoDevice, piAttribList);
    }
    /// ditto
    public BOOL QueryCurrentContextNV (int iAttribute, int* piValue) const {
        assert(_QueryCurrentContextNV !is null, "WinGL command wglQueryCurrentContextNV was not loaded");
        return _QueryCurrentContextNV (iAttribute, piValue);
    }

    /// Commands for WGL_NV_swap_group
    public BOOL JoinSwapGroupNV (HDC hDC, GLuint group) const {
        assert(_JoinSwapGroupNV !is null, "WinGL command wglJoinSwapGroupNV was not loaded");
        return _JoinSwapGroupNV (hDC, group);
    }
    /// ditto
    public BOOL BindSwapBarrierNV (GLuint group, GLuint barrier) const {
        assert(_BindSwapBarrierNV !is null, "WinGL command wglBindSwapBarrierNV was not loaded");
        return _BindSwapBarrierNV (group, barrier);
    }
    /// ditto
    public BOOL QuerySwapGroupNV (HDC hDC, GLuint* group, GLuint* barrier) const {
        assert(_QuerySwapGroupNV !is null, "WinGL command wglQuerySwapGroupNV was not loaded");
        return _QuerySwapGroupNV (hDC, group, barrier);
    }
    /// ditto
    public BOOL QueryMaxSwapGroupsNV (HDC hDC, GLuint* maxGroups, GLuint* maxBarriers) const {
        assert(_QueryMaxSwapGroupsNV !is null, "WinGL command wglQueryMaxSwapGroupsNV was not loaded");
        return _QueryMaxSwapGroupsNV (hDC, maxGroups, maxBarriers);
    }
    /// ditto
    public BOOL QueryFrameCountNV (HDC hDC, GLuint* count) const {
        assert(_QueryFrameCountNV !is null, "WinGL command wglQueryFrameCountNV was not loaded");
        return _QueryFrameCountNV (hDC, count);
    }
    /// ditto
    public BOOL ResetFrameCountNV (HDC hDC) const {
        assert(_ResetFrameCountNV !is null, "WinGL command wglResetFrameCountNV was not loaded");
        return _ResetFrameCountNV (hDC);
    }

    /// Commands for WGL_NV_vertex_array_range
    public void * AllocateMemoryNV (GLsizei size, GLfloat readfreq, GLfloat writefreq, GLfloat priority) const {
        assert(_AllocateMemoryNV !is null, "WinGL command wglAllocateMemoryNV was not loaded");
        return _AllocateMemoryNV (size, readfreq, writefreq, priority);
    }
    /// ditto
    public void FreeMemoryNV (void* pointer) const {
        assert(_FreeMemoryNV !is null, "WinGL command wglFreeMemoryNV was not loaded");
        return _FreeMemoryNV (pointer);
    }

    /// Commands for WGL_NV_video_capture
    public BOOL BindVideoCaptureDeviceNV (UINT uVideoSlot, HVIDEOINPUTDEVICENV hDevice) const {
        assert(_BindVideoCaptureDeviceNV !is null, "WinGL command wglBindVideoCaptureDeviceNV was not loaded");
        return _BindVideoCaptureDeviceNV (uVideoSlot, hDevice);
    }
    /// ditto
    public UINT EnumerateVideoCaptureDevicesNV (HDC hDc, HVIDEOINPUTDEVICENV* phDeviceList) const {
        assert(_EnumerateVideoCaptureDevicesNV !is null, "WinGL command wglEnumerateVideoCaptureDevicesNV was not loaded");
        return _EnumerateVideoCaptureDevicesNV (hDc, phDeviceList);
    }
    /// ditto
    public BOOL LockVideoCaptureDeviceNV (HDC hDc, HVIDEOINPUTDEVICENV hDevice) const {
        assert(_LockVideoCaptureDeviceNV !is null, "WinGL command wglLockVideoCaptureDeviceNV was not loaded");
        return _LockVideoCaptureDeviceNV (hDc, hDevice);
    }
    /// ditto
    public BOOL QueryVideoCaptureDeviceNV (HDC hDc, HVIDEOINPUTDEVICENV hDevice, int iAttribute, int* piValue) const {
        assert(_QueryVideoCaptureDeviceNV !is null, "WinGL command wglQueryVideoCaptureDeviceNV was not loaded");
        return _QueryVideoCaptureDeviceNV (hDc, hDevice, iAttribute, piValue);
    }
    /// ditto
    public BOOL ReleaseVideoCaptureDeviceNV (HDC hDc, HVIDEOINPUTDEVICENV hDevice) const {
        assert(_ReleaseVideoCaptureDeviceNV !is null, "WinGL command wglReleaseVideoCaptureDeviceNV was not loaded");
        return _ReleaseVideoCaptureDeviceNV (hDc, hDevice);
    }

    /// Commands for WGL_NV_video_output
    public BOOL GetVideoDeviceNV (HDC hDC, int numDevices, HPVIDEODEV* hVideoDevice) const {
        assert(_GetVideoDeviceNV !is null, "WinGL command wglGetVideoDeviceNV was not loaded");
        return _GetVideoDeviceNV (hDC, numDevices, hVideoDevice);
    }
    /// ditto
    public BOOL ReleaseVideoDeviceNV (HPVIDEODEV hVideoDevice) const {
        assert(_ReleaseVideoDeviceNV !is null, "WinGL command wglReleaseVideoDeviceNV was not loaded");
        return _ReleaseVideoDeviceNV (hVideoDevice);
    }
    /// ditto
    public BOOL BindVideoImageNV (HPVIDEODEV hVideoDevice, HPBUFFERARB hPbuffer, int iVideoBuffer) const {
        assert(_BindVideoImageNV !is null, "WinGL command wglBindVideoImageNV was not loaded");
        return _BindVideoImageNV (hVideoDevice, hPbuffer, iVideoBuffer);
    }
    /// ditto
    public BOOL ReleaseVideoImageNV (HPBUFFERARB hPbuffer, int iVideoBuffer) const {
        assert(_ReleaseVideoImageNV !is null, "WinGL command wglReleaseVideoImageNV was not loaded");
        return _ReleaseVideoImageNV (hPbuffer, iVideoBuffer);
    }
    /// ditto
    public BOOL SendPbufferToVideoNV (HPBUFFERARB hPbuffer, int iBufferType, c_ulong* pulCounterPbuffer, BOOL bBlock) const {
        assert(_SendPbufferToVideoNV !is null, "WinGL command wglSendPbufferToVideoNV was not loaded");
        return _SendPbufferToVideoNV (hPbuffer, iBufferType, pulCounterPbuffer, bBlock);
    }
    /// ditto
    public BOOL GetVideoInfoNV (HPVIDEODEV hpVideoDevice, c_ulong* pulCounterOutputPbuffer, c_ulong* pulCounterOutputVideo) const {
        assert(_GetVideoInfoNV !is null, "WinGL command wglGetVideoInfoNV was not loaded");
        return _GetVideoInfoNV (hpVideoDevice, pulCounterOutputPbuffer, pulCounterOutputVideo);
    }

    /// Commands for WGL_OML_sync_control
    public BOOL GetSyncValuesOML (HDC hdc, INT64* ust, INT64* msc, INT64* sbc) const {
        assert(_GetSyncValuesOML !is null, "WinGL command wglGetSyncValuesOML was not loaded");
        return _GetSyncValuesOML (hdc, ust, msc, sbc);
    }
    /// ditto
    public BOOL GetMscRateOML (HDC hdc, INT32* numerator, INT32* denominator) const {
        assert(_GetMscRateOML !is null, "WinGL command wglGetMscRateOML was not loaded");
        return _GetMscRateOML (hdc, numerator, denominator);
    }
    /// ditto
    public INT64 SwapBuffersMscOML (HDC hdc, INT64 target_msc, INT64 divisor, INT64 remainder) const {
        assert(_SwapBuffersMscOML !is null, "WinGL command wglSwapBuffersMscOML was not loaded");
        return _SwapBuffersMscOML (hdc, target_msc, divisor, remainder);
    }
    /// ditto
    public INT64 SwapLayerBuffersMscOML (HDC hdc, int fuPlanes, INT64 target_msc, INT64 divisor, INT64 remainder) const {
        assert(_SwapLayerBuffersMscOML !is null, "WinGL command wglSwapLayerBuffersMscOML was not loaded");
        return _SwapLayerBuffersMscOML (hdc, fuPlanes, target_msc, divisor, remainder);
    }
    /// ditto
    public BOOL WaitForMscOML (HDC hdc, INT64 target_msc, INT64 divisor, INT64 remainder, INT64* ust, INT64* msc, INT64* sbc) const {
        assert(_WaitForMscOML !is null, "WinGL command wglWaitForMscOML was not loaded");
        return _WaitForMscOML (hdc, target_msc, divisor, remainder, ust, msc, sbc);
    }
    /// ditto
    public BOOL WaitForSbcOML (HDC hdc, INT64 target_sbc, INT64* ust, INT64* msc, INT64* sbc) const {
        assert(_WaitForSbcOML !is null, "WinGL command wglWaitForSbcOML was not loaded");
        return _WaitForSbcOML (hdc, target_sbc, ust, msc, sbc);
    }

    // WGL_VERSION_1_0
    private PFN_wglCopyContext _CopyContext;
    private PFN_wglCreateContext _CreateContext;
    private PFN_wglCreateLayerContext _CreateLayerContext;
    private PFN_wglDeleteContext _DeleteContext;
    private PFN_wglDescribeLayerPlane _DescribeLayerPlane;
    private PFN_wglGetCurrentContext _GetCurrentContext;
    private PFN_wglGetCurrentDC _GetCurrentDC;
    private PFN_wglGetLayerPaletteEntries _GetLayerPaletteEntries;
    private PFN_wglGetProcAddress _GetProcAddress;
    private PFN_wglMakeCurrent _MakeCurrent;
    private PFN_wglRealizeLayerPalette _RealizeLayerPalette;
    private PFN_wglSetLayerPaletteEntries _SetLayerPaletteEntries;
    private PFN_wglShareLists _ShareLists;
    private PFN_wglSwapLayerBuffers _SwapLayerBuffers;
    private PFN_wglUseFontBitmaps _UseFontBitmaps;
    private PFN_wglUseFontBitmapsA _UseFontBitmapsA;
    private PFN_wglUseFontBitmapsW _UseFontBitmapsW;
    private PFN_wglUseFontOutlines _UseFontOutlines;
    private PFN_wglUseFontOutlinesA _UseFontOutlinesA;
    private PFN_wglUseFontOutlinesW _UseFontOutlinesW;

    // WGL_ARB_buffer_region,
    private PFN_wglCreateBufferRegionARB _CreateBufferRegionARB;
    private PFN_wglDeleteBufferRegionARB _DeleteBufferRegionARB;
    private PFN_wglSaveBufferRegionARB _SaveBufferRegionARB;
    private PFN_wglRestoreBufferRegionARB _RestoreBufferRegionARB;

    // WGL_ARB_create_context,
    private PFN_wglCreateContextAttribsARB _CreateContextAttribsARB;

    // WGL_ARB_extensions_string,
    private PFN_wglGetExtensionsStringARB _GetExtensionsStringARB;

    // WGL_ARB_make_current_read,
    private PFN_wglMakeContextCurrentARB _MakeContextCurrentARB;
    private PFN_wglGetCurrentReadDCARB _GetCurrentReadDCARB;

    // WGL_ARB_pbuffer,
    private PFN_wglCreatePbufferARB _CreatePbufferARB;
    private PFN_wglGetPbufferDCARB _GetPbufferDCARB;
    private PFN_wglReleasePbufferDCARB _ReleasePbufferDCARB;
    private PFN_wglDestroyPbufferARB _DestroyPbufferARB;
    private PFN_wglQueryPbufferARB _QueryPbufferARB;

    // WGL_ARB_pixel_format,
    private PFN_wglGetPixelFormatAttribivARB _GetPixelFormatAttribivARB;
    private PFN_wglGetPixelFormatAttribfvARB _GetPixelFormatAttribfvARB;
    private PFN_wglChoosePixelFormatARB _ChoosePixelFormatARB;

    // WGL_ARB_render_texture,
    private PFN_wglBindTexImageARB _BindTexImageARB;
    private PFN_wglReleaseTexImageARB _ReleaseTexImageARB;
    private PFN_wglSetPbufferAttribARB _SetPbufferAttribARB;

    // WGL_3DL_stereo_control,
    private PFN_wglSetStereoEmitterState3DL _SetStereoEmitterState3DL;

    // WGL_AMD_gpu_association,
    private PFN_wglGetGPUIDsAMD _GetGPUIDsAMD;
    private PFN_wglGetGPUInfoAMD _GetGPUInfoAMD;
    private PFN_wglGetContextGPUIDAMD _GetContextGPUIDAMD;
    private PFN_wglCreateAssociatedContextAMD _CreateAssociatedContextAMD;
    private PFN_wglCreateAssociatedContextAttribsAMD _CreateAssociatedContextAttribsAMD;
    private PFN_wglDeleteAssociatedContextAMD _DeleteAssociatedContextAMD;
    private PFN_wglMakeAssociatedContextCurrentAMD _MakeAssociatedContextCurrentAMD;
    private PFN_wglGetCurrentAssociatedContextAMD _GetCurrentAssociatedContextAMD;
    private PFN_wglBlitContextFramebufferAMD _BlitContextFramebufferAMD;

    // WGL_EXT_display_color_table,
    private PFN_wglCreateDisplayColorTableEXT _CreateDisplayColorTableEXT;
    private PFN_wglLoadDisplayColorTableEXT _LoadDisplayColorTableEXT;
    private PFN_wglBindDisplayColorTableEXT _BindDisplayColorTableEXT;
    private PFN_wglDestroyDisplayColorTableEXT _DestroyDisplayColorTableEXT;

    // WGL_EXT_extensions_string,
    private PFN_wglGetExtensionsStringEXT _GetExtensionsStringEXT;

    // WGL_EXT_make_current_read,
    private PFN_wglMakeContextCurrentEXT _MakeContextCurrentEXT;
    private PFN_wglGetCurrentReadDCEXT _GetCurrentReadDCEXT;

    // WGL_EXT_pbuffer,
    private PFN_wglCreatePbufferEXT _CreatePbufferEXT;
    private PFN_wglGetPbufferDCEXT _GetPbufferDCEXT;
    private PFN_wglReleasePbufferDCEXT _ReleasePbufferDCEXT;
    private PFN_wglDestroyPbufferEXT _DestroyPbufferEXT;
    private PFN_wglQueryPbufferEXT _QueryPbufferEXT;

    // WGL_EXT_pixel_format,
    private PFN_wglGetPixelFormatAttribivEXT _GetPixelFormatAttribivEXT;
    private PFN_wglGetPixelFormatAttribfvEXT _GetPixelFormatAttribfvEXT;
    private PFN_wglChoosePixelFormatEXT _ChoosePixelFormatEXT;

    // WGL_EXT_swap_control,
    private PFN_wglSwapIntervalEXT _SwapIntervalEXT;
    private PFN_wglGetSwapIntervalEXT _GetSwapIntervalEXT;

    // WGL_I3D_digital_video_control,
    private PFN_wglGetDigitalVideoParametersI3D _GetDigitalVideoParametersI3D;
    private PFN_wglSetDigitalVideoParametersI3D _SetDigitalVideoParametersI3D;

    // WGL_I3D_gamma,
    private PFN_wglGetGammaTableParametersI3D _GetGammaTableParametersI3D;
    private PFN_wglSetGammaTableParametersI3D _SetGammaTableParametersI3D;
    private PFN_wglGetGammaTableI3D _GetGammaTableI3D;
    private PFN_wglSetGammaTableI3D _SetGammaTableI3D;

    // WGL_I3D_genlock,
    private PFN_wglEnableGenlockI3D _EnableGenlockI3D;
    private PFN_wglDisableGenlockI3D _DisableGenlockI3D;
    private PFN_wglIsEnabledGenlockI3D _IsEnabledGenlockI3D;
    private PFN_wglGenlockSourceI3D _GenlockSourceI3D;
    private PFN_wglGetGenlockSourceI3D _GetGenlockSourceI3D;
    private PFN_wglGenlockSourceEdgeI3D _GenlockSourceEdgeI3D;
    private PFN_wglGetGenlockSourceEdgeI3D _GetGenlockSourceEdgeI3D;
    private PFN_wglGenlockSampleRateI3D _GenlockSampleRateI3D;
    private PFN_wglGetGenlockSampleRateI3D _GetGenlockSampleRateI3D;
    private PFN_wglGenlockSourceDelayI3D _GenlockSourceDelayI3D;
    private PFN_wglGetGenlockSourceDelayI3D _GetGenlockSourceDelayI3D;
    private PFN_wglQueryGenlockMaxSourceDelayI3D _QueryGenlockMaxSourceDelayI3D;

    // WGL_I3D_image_buffer,
    private PFN_wglCreateImageBufferI3D _CreateImageBufferI3D;
    private PFN_wglDestroyImageBufferI3D _DestroyImageBufferI3D;
    private PFN_wglAssociateImageBufferEventsI3D _AssociateImageBufferEventsI3D;
    private PFN_wglReleaseImageBufferEventsI3D _ReleaseImageBufferEventsI3D;

    // WGL_I3D_swap_frame_lock,
    private PFN_wglEnableFrameLockI3D _EnableFrameLockI3D;
    private PFN_wglDisableFrameLockI3D _DisableFrameLockI3D;
    private PFN_wglIsEnabledFrameLockI3D _IsEnabledFrameLockI3D;
    private PFN_wglQueryFrameLockMasterI3D _QueryFrameLockMasterI3D;

    // WGL_I3D_swap_frame_usage,
    private PFN_wglGetFrameUsageI3D _GetFrameUsageI3D;
    private PFN_wglBeginFrameTrackingI3D _BeginFrameTrackingI3D;
    private PFN_wglEndFrameTrackingI3D _EndFrameTrackingI3D;
    private PFN_wglQueryFrameTrackingI3D _QueryFrameTrackingI3D;

    // WGL_NV_DX_interop,
    private PFN_wglDXSetResourceShareHandleNV _DXSetResourceShareHandleNV;
    private PFN_wglDXOpenDeviceNV _DXOpenDeviceNV;
    private PFN_wglDXCloseDeviceNV _DXCloseDeviceNV;
    private PFN_wglDXRegisterObjectNV _DXRegisterObjectNV;
    private PFN_wglDXUnregisterObjectNV _DXUnregisterObjectNV;
    private PFN_wglDXObjectAccessNV _DXObjectAccessNV;
    private PFN_wglDXLockObjectsNV _DXLockObjectsNV;
    private PFN_wglDXUnlockObjectsNV _DXUnlockObjectsNV;

    // WGL_NV_copy_image,
    private PFN_wglCopyImageSubDataNV _CopyImageSubDataNV;

    // WGL_NV_delay_before_swap,
    private PFN_wglDelayBeforeSwapNV _DelayBeforeSwapNV;

    // WGL_NV_gpu_affinity,
    private PFN_wglEnumGpusNV _EnumGpusNV;
    private PFN_wglEnumGpuDevicesNV _EnumGpuDevicesNV;
    private PFN_wglCreateAffinityDCNV _CreateAffinityDCNV;
    private PFN_wglEnumGpusFromAffinityDCNV _EnumGpusFromAffinityDCNV;
    private PFN_wglDeleteDCNV _DeleteDCNV;

    // WGL_NV_present_video,
    private PFN_wglEnumerateVideoDevicesNV _EnumerateVideoDevicesNV;
    private PFN_wglBindVideoDeviceNV _BindVideoDeviceNV;
    private PFN_wglQueryCurrentContextNV _QueryCurrentContextNV;

    // WGL_NV_swap_group,
    private PFN_wglJoinSwapGroupNV _JoinSwapGroupNV;
    private PFN_wglBindSwapBarrierNV _BindSwapBarrierNV;
    private PFN_wglQuerySwapGroupNV _QuerySwapGroupNV;
    private PFN_wglQueryMaxSwapGroupsNV _QueryMaxSwapGroupsNV;
    private PFN_wglQueryFrameCountNV _QueryFrameCountNV;
    private PFN_wglResetFrameCountNV _ResetFrameCountNV;

    // WGL_NV_vertex_array_range,
    private PFN_wglAllocateMemoryNV _AllocateMemoryNV;
    private PFN_wglFreeMemoryNV _FreeMemoryNV;

    // WGL_NV_video_capture,
    private PFN_wglBindVideoCaptureDeviceNV _BindVideoCaptureDeviceNV;
    private PFN_wglEnumerateVideoCaptureDevicesNV _EnumerateVideoCaptureDevicesNV;
    private PFN_wglLockVideoCaptureDeviceNV _LockVideoCaptureDeviceNV;
    private PFN_wglQueryVideoCaptureDeviceNV _QueryVideoCaptureDeviceNV;
    private PFN_wglReleaseVideoCaptureDeviceNV _ReleaseVideoCaptureDeviceNV;

    // WGL_NV_video_output,
    private PFN_wglGetVideoDeviceNV _GetVideoDeviceNV;
    private PFN_wglReleaseVideoDeviceNV _ReleaseVideoDeviceNV;
    private PFN_wglBindVideoImageNV _BindVideoImageNV;
    private PFN_wglReleaseVideoImageNV _ReleaseVideoImageNV;
    private PFN_wglSendPbufferToVideoNV _SendPbufferToVideoNV;
    private PFN_wglGetVideoInfoNV _GetVideoInfoNV;

    // WGL_OML_sync_control,
    private PFN_wglGetSyncValuesOML _GetSyncValuesOML;
    private PFN_wglGetMscRateOML _GetMscRateOML;
    private PFN_wglSwapBuffersMscOML _SwapBuffersMscOML;
    private PFN_wglSwapLayerBuffersMscOML _SwapLayerBuffersMscOML;
    private PFN_wglWaitForMscOML _WaitForMscOML;
    private PFN_wglWaitForSbcOML _WaitForSbcOML;
}
