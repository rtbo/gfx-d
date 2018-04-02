/// OpenGL bindings for D. Generated automatically by gldgen.py
module gfx.bindings.opengl.gl;

import core.stdc.stdint;
import gfx.bindings.core;

// Base Types

// Types for GL_VERSION_1_0
alias GLvoid     = void;
alias GLenum     = uint;
alias GLfloat    = float;
alias GLint      = int;
alias GLsizei    = int;
alias GLbitfield = uint;
alias GLdouble   = double;
alias GLuint     = uint;
alias GLboolean  = ubyte;
alias GLubyte    = ubyte;

// Types for GL_VERSION_1_1
alias GLclampf = float;
alias GLclampd = double;

// Types for GL_VERSION_1_5
alias GLsizeiptr = ptrdiff_t;
alias GLintptr   = ptrdiff_t;

// Types for GL_VERSION_2_0
alias GLchar   = char;
alias GLshort  = short;
alias GLbyte   = byte;
alias GLushort = ushort;

// Types for GL_VERSION_3_0
alias GLhalf = ushort;

// Types for GL_VERSION_3_2
alias GLsync   = __GLsync*;
alias GLuint64 = uint64_t;
alias GLint64  = int64_t;

// Types for GL_ARB_bindless_texture
alias GLuint64EXT = uint64_t;

// Types for GL_NV_gpu_shader5
alias GLint64EXT = int64_t;

// Struct declarations
struct __GLsync;
struct _cl_context;
struct _cl_event;

// Function pointers

extern(C) nothrow @nogc {

    // for GL_VERSION_4_3
    alias GLDEBUGPROC = void function(
        GLenum         source,
        GLenum         type,
        GLuint         id,
        GLenum         severity,
        GLsizei        length,
        const(GLchar)* message,
        const(void)*   userParam
    );

    // for GL_ARB_debug_output
    alias GLDEBUGPROCARB = void function(
        GLenum         source,
        GLenum         type,
        GLuint         id,
        GLenum         severity,
        GLsizei        length,
        const(GLchar)* message,
        const(void)*   userParam
    );

    // for GL_NV_draw_vulkan_image
    alias GLVULKANPROCNV = void function();
}


// Constants for GL_VERSION_1_0
enum GL_DEPTH_BUFFER_BIT        = 0x00000100;
enum GL_STENCIL_BUFFER_BIT      = 0x00000400;
enum GL_COLOR_BUFFER_BIT        = 0x00004000;
enum GL_FALSE                   = 0;
enum GL_TRUE                    = 1;
enum GL_POINTS                  = 0x0000;
enum GL_LINES                   = 0x0001;
enum GL_LINE_LOOP               = 0x0002;
enum GL_LINE_STRIP              = 0x0003;
enum GL_TRIANGLES               = 0x0004;
enum GL_TRIANGLE_STRIP          = 0x0005;
enum GL_TRIANGLE_FAN            = 0x0006;
enum GL_QUADS                   = 0x0007;
enum GL_NEVER                   = 0x0200;
enum GL_LESS                    = 0x0201;
enum GL_EQUAL                   = 0x0202;
enum GL_LEQUAL                  = 0x0203;
enum GL_GREATER                 = 0x0204;
enum GL_NOTEQUAL                = 0x0205;
enum GL_GEQUAL                  = 0x0206;
enum GL_ALWAYS                  = 0x0207;
enum GL_ZERO                    = 0;
enum GL_ONE                     = 1;
enum GL_SRC_COLOR               = 0x0300;
enum GL_ONE_MINUS_SRC_COLOR     = 0x0301;
enum GL_SRC_ALPHA               = 0x0302;
enum GL_ONE_MINUS_SRC_ALPHA     = 0x0303;
enum GL_DST_ALPHA               = 0x0304;
enum GL_ONE_MINUS_DST_ALPHA     = 0x0305;
enum GL_DST_COLOR               = 0x0306;
enum GL_ONE_MINUS_DST_COLOR     = 0x0307;
enum GL_SRC_ALPHA_SATURATE      = 0x0308;
enum GL_NONE                    = 0;
enum GL_FRONT_LEFT              = 0x0400;
enum GL_FRONT_RIGHT             = 0x0401;
enum GL_BACK_LEFT               = 0x0402;
enum GL_BACK_RIGHT              = 0x0403;
enum GL_FRONT                   = 0x0404;
enum GL_BACK                    = 0x0405;
enum GL_LEFT                    = 0x0406;
enum GL_RIGHT                   = 0x0407;
enum GL_FRONT_AND_BACK          = 0x0408;
enum GL_NO_ERROR                = 0;
enum GL_INVALID_ENUM            = 0x0500;
enum GL_INVALID_VALUE           = 0x0501;
enum GL_INVALID_OPERATION       = 0x0502;
enum GL_OUT_OF_MEMORY           = 0x0505;
enum GL_CW                      = 0x0900;
enum GL_CCW                     = 0x0901;
enum GL_POINT_SIZE              = 0x0B11;
enum GL_POINT_SIZE_RANGE        = 0x0B12;
enum GL_POINT_SIZE_GRANULARITY  = 0x0B13;
enum GL_LINE_SMOOTH             = 0x0B20;
enum GL_LINE_WIDTH              = 0x0B21;
enum GL_LINE_WIDTH_RANGE        = 0x0B22;
enum GL_LINE_WIDTH_GRANULARITY  = 0x0B23;
enum GL_POLYGON_MODE            = 0x0B40;
enum GL_POLYGON_SMOOTH          = 0x0B41;
enum GL_CULL_FACE               = 0x0B44;
enum GL_CULL_FACE_MODE          = 0x0B45;
enum GL_FRONT_FACE              = 0x0B46;
enum GL_DEPTH_RANGE             = 0x0B70;
enum GL_DEPTH_TEST              = 0x0B71;
enum GL_DEPTH_WRITEMASK         = 0x0B72;
enum GL_DEPTH_CLEAR_VALUE       = 0x0B73;
enum GL_DEPTH_FUNC              = 0x0B74;
enum GL_STENCIL_TEST            = 0x0B90;
enum GL_STENCIL_CLEAR_VALUE     = 0x0B91;
enum GL_STENCIL_FUNC            = 0x0B92;
enum GL_STENCIL_VALUE_MASK      = 0x0B93;
enum GL_STENCIL_FAIL            = 0x0B94;
enum GL_STENCIL_PASS_DEPTH_FAIL = 0x0B95;
enum GL_STENCIL_PASS_DEPTH_PASS = 0x0B96;
enum GL_STENCIL_REF             = 0x0B97;
enum GL_STENCIL_WRITEMASK       = 0x0B98;
enum GL_VIEWPORT                = 0x0BA2;
enum GL_DITHER                  = 0x0BD0;
enum GL_BLEND_DST               = 0x0BE0;
enum GL_BLEND_SRC               = 0x0BE1;
enum GL_BLEND                   = 0x0BE2;
enum GL_LOGIC_OP_MODE           = 0x0BF0;
enum GL_DRAW_BUFFER             = 0x0C01;
enum GL_READ_BUFFER             = 0x0C02;
enum GL_SCISSOR_BOX             = 0x0C10;
enum GL_SCISSOR_TEST            = 0x0C11;
enum GL_COLOR_CLEAR_VALUE       = 0x0C22;
enum GL_COLOR_WRITEMASK         = 0x0C23;
enum GL_DOUBLEBUFFER            = 0x0C32;
enum GL_STEREO                  = 0x0C33;
enum GL_LINE_SMOOTH_HINT        = 0x0C52;
enum GL_POLYGON_SMOOTH_HINT     = 0x0C53;
enum GL_UNPACK_SWAP_BYTES       = 0x0CF0;
enum GL_UNPACK_LSB_FIRST        = 0x0CF1;
enum GL_UNPACK_ROW_LENGTH       = 0x0CF2;
enum GL_UNPACK_SKIP_ROWS        = 0x0CF3;
enum GL_UNPACK_SKIP_PIXELS      = 0x0CF4;
enum GL_UNPACK_ALIGNMENT        = 0x0CF5;
enum GL_PACK_SWAP_BYTES         = 0x0D00;
enum GL_PACK_LSB_FIRST          = 0x0D01;
enum GL_PACK_ROW_LENGTH         = 0x0D02;
enum GL_PACK_SKIP_ROWS          = 0x0D03;
enum GL_PACK_SKIP_PIXELS        = 0x0D04;
enum GL_PACK_ALIGNMENT          = 0x0D05;
enum GL_MAX_TEXTURE_SIZE        = 0x0D33;
enum GL_MAX_VIEWPORT_DIMS       = 0x0D3A;
enum GL_SUBPIXEL_BITS           = 0x0D50;
enum GL_TEXTURE_1D              = 0x0DE0;
enum GL_TEXTURE_2D              = 0x0DE1;
enum GL_TEXTURE_WIDTH           = 0x1000;
enum GL_TEXTURE_HEIGHT          = 0x1001;
enum GL_TEXTURE_BORDER_COLOR    = 0x1004;
enum GL_DONT_CARE               = 0x1100;
enum GL_FASTEST                 = 0x1101;
enum GL_NICEST                  = 0x1102;
enum GL_BYTE                    = 0x1400;
enum GL_UNSIGNED_BYTE           = 0x1401;
enum GL_SHORT                   = 0x1402;
enum GL_UNSIGNED_SHORT          = 0x1403;
enum GL_INT                     = 0x1404;
enum GL_UNSIGNED_INT            = 0x1405;
enum GL_FLOAT                   = 0x1406;
enum GL_STACK_OVERFLOW          = 0x0503;
enum GL_STACK_UNDERFLOW         = 0x0504;
enum GL_CLEAR                   = 0x1500;
enum GL_AND                     = 0x1501;
enum GL_AND_REVERSE             = 0x1502;
enum GL_COPY                    = 0x1503;
enum GL_AND_INVERTED            = 0x1504;
enum GL_NOOP                    = 0x1505;
enum GL_XOR                     = 0x1506;
enum GL_OR                      = 0x1507;
enum GL_NOR                     = 0x1508;
enum GL_EQUIV                   = 0x1509;
enum GL_INVERT                  = 0x150A;
enum GL_OR_REVERSE              = 0x150B;
enum GL_COPY_INVERTED           = 0x150C;
enum GL_OR_INVERTED             = 0x150D;
enum GL_NAND                    = 0x150E;
enum GL_SET                     = 0x150F;
enum GL_TEXTURE                 = 0x1702;
enum GL_COLOR                   = 0x1800;
enum GL_DEPTH                   = 0x1801;
enum GL_STENCIL                 = 0x1802;
enum GL_STENCIL_INDEX           = 0x1901;
enum GL_DEPTH_COMPONENT         = 0x1902;
enum GL_RED                     = 0x1903;
enum GL_GREEN                   = 0x1904;
enum GL_BLUE                    = 0x1905;
enum GL_ALPHA                   = 0x1906;
enum GL_RGB                     = 0x1907;
enum GL_RGBA                    = 0x1908;
enum GL_POINT                   = 0x1B00;
enum GL_LINE                    = 0x1B01;
enum GL_FILL                    = 0x1B02;
enum GL_KEEP                    = 0x1E00;
enum GL_REPLACE                 = 0x1E01;
enum GL_INCR                    = 0x1E02;
enum GL_DECR                    = 0x1E03;
enum GL_VENDOR                  = 0x1F00;
enum GL_RENDERER                = 0x1F01;
enum GL_VERSION                 = 0x1F02;
enum GL_EXTENSIONS              = 0x1F03;
enum GL_NEAREST                 = 0x2600;
enum GL_LINEAR                  = 0x2601;
enum GL_NEAREST_MIPMAP_NEAREST  = 0x2700;
enum GL_LINEAR_MIPMAP_NEAREST   = 0x2701;
enum GL_NEAREST_MIPMAP_LINEAR   = 0x2702;
enum GL_LINEAR_MIPMAP_LINEAR    = 0x2703;
enum GL_TEXTURE_MAG_FILTER      = 0x2800;
enum GL_TEXTURE_MIN_FILTER      = 0x2801;
enum GL_TEXTURE_WRAP_S          = 0x2802;
enum GL_TEXTURE_WRAP_T          = 0x2803;
enum GL_REPEAT                  = 0x2901;

// Constants for GL_VERSION_1_1
enum GL_COLOR_LOGIC_OP          = 0x0BF2;
enum GL_POLYGON_OFFSET_UNITS    = 0x2A00;
enum GL_POLYGON_OFFSET_POINT    = 0x2A01;
enum GL_POLYGON_OFFSET_LINE     = 0x2A02;
enum GL_POLYGON_OFFSET_FILL     = 0x8037;
enum GL_POLYGON_OFFSET_FACTOR   = 0x8038;
enum GL_TEXTURE_BINDING_1D      = 0x8068;
enum GL_TEXTURE_BINDING_2D      = 0x8069;
enum GL_TEXTURE_INTERNAL_FORMAT = 0x1003;
enum GL_TEXTURE_RED_SIZE        = 0x805C;
enum GL_TEXTURE_GREEN_SIZE      = 0x805D;
enum GL_TEXTURE_BLUE_SIZE       = 0x805E;
enum GL_TEXTURE_ALPHA_SIZE      = 0x805F;
enum GL_DOUBLE                  = 0x140A;
enum GL_PROXY_TEXTURE_1D        = 0x8063;
enum GL_PROXY_TEXTURE_2D        = 0x8064;
enum GL_R3_G3_B2                = 0x2A10;
enum GL_RGB4                    = 0x804F;
enum GL_RGB5                    = 0x8050;
enum GL_RGB8                    = 0x8051;
enum GL_RGB10                   = 0x8052;
enum GL_RGB12                   = 0x8053;
enum GL_RGB16                   = 0x8054;
enum GL_RGBA2                   = 0x8055;
enum GL_RGBA4                   = 0x8056;
enum GL_RGB5_A1                 = 0x8057;
enum GL_RGBA8                   = 0x8058;
enum GL_RGB10_A2                = 0x8059;
enum GL_RGBA12                  = 0x805A;
enum GL_RGBA16                  = 0x805B;
enum GL_VERTEX_ARRAY            = 0x8074;

// Constants for GL_VERSION_1_2
enum GL_UNSIGNED_BYTE_3_3_2           = 0x8032;
enum GL_UNSIGNED_SHORT_4_4_4_4        = 0x8033;
enum GL_UNSIGNED_SHORT_5_5_5_1        = 0x8034;
enum GL_UNSIGNED_INT_8_8_8_8          = 0x8035;
enum GL_UNSIGNED_INT_10_10_10_2       = 0x8036;
enum GL_TEXTURE_BINDING_3D            = 0x806A;
enum GL_PACK_SKIP_IMAGES              = 0x806B;
enum GL_PACK_IMAGE_HEIGHT             = 0x806C;
enum GL_UNPACK_SKIP_IMAGES            = 0x806D;
enum GL_UNPACK_IMAGE_HEIGHT           = 0x806E;
enum GL_TEXTURE_3D                    = 0x806F;
enum GL_PROXY_TEXTURE_3D              = 0x8070;
enum GL_TEXTURE_DEPTH                 = 0x8071;
enum GL_TEXTURE_WRAP_R                = 0x8072;
enum GL_MAX_3D_TEXTURE_SIZE           = 0x8073;
enum GL_UNSIGNED_BYTE_2_3_3_REV       = 0x8362;
enum GL_UNSIGNED_SHORT_5_6_5          = 0x8363;
enum GL_UNSIGNED_SHORT_5_6_5_REV      = 0x8364;
enum GL_UNSIGNED_SHORT_4_4_4_4_REV    = 0x8365;
enum GL_UNSIGNED_SHORT_1_5_5_5_REV    = 0x8366;
enum GL_UNSIGNED_INT_8_8_8_8_REV      = 0x8367;
enum GL_UNSIGNED_INT_2_10_10_10_REV   = 0x8368;
enum GL_BGR                           = 0x80E0;
enum GL_BGRA                          = 0x80E1;
enum GL_MAX_ELEMENTS_VERTICES         = 0x80E8;
enum GL_MAX_ELEMENTS_INDICES          = 0x80E9;
enum GL_CLAMP_TO_EDGE                 = 0x812F;
enum GL_TEXTURE_MIN_LOD               = 0x813A;
enum GL_TEXTURE_MAX_LOD               = 0x813B;
enum GL_TEXTURE_BASE_LEVEL            = 0x813C;
enum GL_TEXTURE_MAX_LEVEL             = 0x813D;
enum GL_SMOOTH_POINT_SIZE_RANGE       = 0x0B12;
enum GL_SMOOTH_POINT_SIZE_GRANULARITY = 0x0B13;
enum GL_SMOOTH_LINE_WIDTH_RANGE       = 0x0B22;
enum GL_SMOOTH_LINE_WIDTH_GRANULARITY = 0x0B23;
enum GL_ALIASED_LINE_WIDTH_RANGE      = 0x846E;

// Constants for GL_VERSION_1_3
enum GL_TEXTURE0                       = 0x84C0;
enum GL_TEXTURE1                       = 0x84C1;
enum GL_TEXTURE2                       = 0x84C2;
enum GL_TEXTURE3                       = 0x84C3;
enum GL_TEXTURE4                       = 0x84C4;
enum GL_TEXTURE5                       = 0x84C5;
enum GL_TEXTURE6                       = 0x84C6;
enum GL_TEXTURE7                       = 0x84C7;
enum GL_TEXTURE8                       = 0x84C8;
enum GL_TEXTURE9                       = 0x84C9;
enum GL_TEXTURE10                      = 0x84CA;
enum GL_TEXTURE11                      = 0x84CB;
enum GL_TEXTURE12                      = 0x84CC;
enum GL_TEXTURE13                      = 0x84CD;
enum GL_TEXTURE14                      = 0x84CE;
enum GL_TEXTURE15                      = 0x84CF;
enum GL_TEXTURE16                      = 0x84D0;
enum GL_TEXTURE17                      = 0x84D1;
enum GL_TEXTURE18                      = 0x84D2;
enum GL_TEXTURE19                      = 0x84D3;
enum GL_TEXTURE20                      = 0x84D4;
enum GL_TEXTURE21                      = 0x84D5;
enum GL_TEXTURE22                      = 0x84D6;
enum GL_TEXTURE23                      = 0x84D7;
enum GL_TEXTURE24                      = 0x84D8;
enum GL_TEXTURE25                      = 0x84D9;
enum GL_TEXTURE26                      = 0x84DA;
enum GL_TEXTURE27                      = 0x84DB;
enum GL_TEXTURE28                      = 0x84DC;
enum GL_TEXTURE29                      = 0x84DD;
enum GL_TEXTURE30                      = 0x84DE;
enum GL_TEXTURE31                      = 0x84DF;
enum GL_ACTIVE_TEXTURE                 = 0x84E0;
enum GL_MULTISAMPLE                    = 0x809D;
enum GL_SAMPLE_ALPHA_TO_COVERAGE       = 0x809E;
enum GL_SAMPLE_ALPHA_TO_ONE            = 0x809F;
enum GL_SAMPLE_COVERAGE                = 0x80A0;
enum GL_SAMPLE_BUFFERS                 = 0x80A8;
enum GL_SAMPLES                        = 0x80A9;
enum GL_SAMPLE_COVERAGE_VALUE          = 0x80AA;
enum GL_SAMPLE_COVERAGE_INVERT         = 0x80AB;
enum GL_TEXTURE_CUBE_MAP               = 0x8513;
enum GL_TEXTURE_BINDING_CUBE_MAP       = 0x8514;
enum GL_TEXTURE_CUBE_MAP_POSITIVE_X    = 0x8515;
enum GL_TEXTURE_CUBE_MAP_NEGATIVE_X    = 0x8516;
enum GL_TEXTURE_CUBE_MAP_POSITIVE_Y    = 0x8517;
enum GL_TEXTURE_CUBE_MAP_NEGATIVE_Y    = 0x8518;
enum GL_TEXTURE_CUBE_MAP_POSITIVE_Z    = 0x8519;
enum GL_TEXTURE_CUBE_MAP_NEGATIVE_Z    = 0x851A;
enum GL_PROXY_TEXTURE_CUBE_MAP         = 0x851B;
enum GL_MAX_CUBE_MAP_TEXTURE_SIZE      = 0x851C;
enum GL_COMPRESSED_RGB                 = 0x84ED;
enum GL_COMPRESSED_RGBA                = 0x84EE;
enum GL_TEXTURE_COMPRESSION_HINT       = 0x84EF;
enum GL_TEXTURE_COMPRESSED_IMAGE_SIZE  = 0x86A0;
enum GL_TEXTURE_COMPRESSED             = 0x86A1;
enum GL_NUM_COMPRESSED_TEXTURE_FORMATS = 0x86A2;
enum GL_COMPRESSED_TEXTURE_FORMATS     = 0x86A3;
enum GL_CLAMP_TO_BORDER                = 0x812D;

// Constants for GL_VERSION_1_4
enum GL_BLEND_DST_RGB             = 0x80C8;
enum GL_BLEND_SRC_RGB             = 0x80C9;
enum GL_BLEND_DST_ALPHA           = 0x80CA;
enum GL_BLEND_SRC_ALPHA           = 0x80CB;
enum GL_POINT_FADE_THRESHOLD_SIZE = 0x8128;
enum GL_DEPTH_COMPONENT16         = 0x81A5;
enum GL_DEPTH_COMPONENT24         = 0x81A6;
enum GL_DEPTH_COMPONENT32         = 0x81A7;
enum GL_MIRRORED_REPEAT           = 0x8370;
enum GL_MAX_TEXTURE_LOD_BIAS      = 0x84FD;
enum GL_TEXTURE_LOD_BIAS          = 0x8501;
enum GL_INCR_WRAP                 = 0x8507;
enum GL_DECR_WRAP                 = 0x8508;
enum GL_TEXTURE_DEPTH_SIZE        = 0x884A;
enum GL_TEXTURE_COMPARE_MODE      = 0x884C;
enum GL_TEXTURE_COMPARE_FUNC      = 0x884D;
enum GL_BLEND_COLOR               = 0x8005;
enum GL_BLEND_EQUATION            = 0x8009;
enum GL_CONSTANT_COLOR            = 0x8001;
enum GL_ONE_MINUS_CONSTANT_COLOR  = 0x8002;
enum GL_CONSTANT_ALPHA            = 0x8003;
enum GL_ONE_MINUS_CONSTANT_ALPHA  = 0x8004;
enum GL_FUNC_ADD                  = 0x8006;
enum GL_FUNC_REVERSE_SUBTRACT     = 0x800B;
enum GL_FUNC_SUBTRACT             = 0x800A;
enum GL_MIN                       = 0x8007;
enum GL_MAX                       = 0x8008;

// Constants for GL_VERSION_1_5
enum GL_BUFFER_SIZE                        = 0x8764;
enum GL_BUFFER_USAGE                       = 0x8765;
enum GL_QUERY_COUNTER_BITS                 = 0x8864;
enum GL_CURRENT_QUERY                      = 0x8865;
enum GL_QUERY_RESULT                       = 0x8866;
enum GL_QUERY_RESULT_AVAILABLE             = 0x8867;
enum GL_ARRAY_BUFFER                       = 0x8892;
enum GL_ELEMENT_ARRAY_BUFFER               = 0x8893;
enum GL_ARRAY_BUFFER_BINDING               = 0x8894;
enum GL_ELEMENT_ARRAY_BUFFER_BINDING       = 0x8895;
enum GL_VERTEX_ATTRIB_ARRAY_BUFFER_BINDING = 0x889F;
enum GL_READ_ONLY                          = 0x88B8;
enum GL_WRITE_ONLY                         = 0x88B9;
enum GL_READ_WRITE                         = 0x88BA;
enum GL_BUFFER_ACCESS                      = 0x88BB;
enum GL_BUFFER_MAPPED                      = 0x88BC;
enum GL_BUFFER_MAP_POINTER                 = 0x88BD;
enum GL_STREAM_DRAW                        = 0x88E0;
enum GL_STREAM_READ                        = 0x88E1;
enum GL_STREAM_COPY                        = 0x88E2;
enum GL_STATIC_DRAW                        = 0x88E4;
enum GL_STATIC_READ                        = 0x88E5;
enum GL_STATIC_COPY                        = 0x88E6;
enum GL_DYNAMIC_DRAW                       = 0x88E8;
enum GL_DYNAMIC_READ                       = 0x88E9;
enum GL_DYNAMIC_COPY                       = 0x88EA;
enum GL_SAMPLES_PASSED                     = 0x8914;
enum GL_SRC1_ALPHA                         = 0x8589;

// Constants for GL_VERSION_2_0
enum GL_BLEND_EQUATION_RGB               = 0x8009;
enum GL_VERTEX_ATTRIB_ARRAY_ENABLED      = 0x8622;
enum GL_VERTEX_ATTRIB_ARRAY_SIZE         = 0x8623;
enum GL_VERTEX_ATTRIB_ARRAY_STRIDE       = 0x8624;
enum GL_VERTEX_ATTRIB_ARRAY_TYPE         = 0x8625;
enum GL_CURRENT_VERTEX_ATTRIB            = 0x8626;
enum GL_VERTEX_PROGRAM_POINT_SIZE        = 0x8642;
enum GL_VERTEX_ATTRIB_ARRAY_POINTER      = 0x8645;
enum GL_STENCIL_BACK_FUNC                = 0x8800;
enum GL_STENCIL_BACK_FAIL                = 0x8801;
enum GL_STENCIL_BACK_PASS_DEPTH_FAIL     = 0x8802;
enum GL_STENCIL_BACK_PASS_DEPTH_PASS     = 0x8803;
enum GL_MAX_DRAW_BUFFERS                 = 0x8824;
enum GL_DRAW_BUFFER0                     = 0x8825;
enum GL_DRAW_BUFFER1                     = 0x8826;
enum GL_DRAW_BUFFER2                     = 0x8827;
enum GL_DRAW_BUFFER3                     = 0x8828;
enum GL_DRAW_BUFFER4                     = 0x8829;
enum GL_DRAW_BUFFER5                     = 0x882A;
enum GL_DRAW_BUFFER6                     = 0x882B;
enum GL_DRAW_BUFFER7                     = 0x882C;
enum GL_DRAW_BUFFER8                     = 0x882D;
enum GL_DRAW_BUFFER9                     = 0x882E;
enum GL_DRAW_BUFFER10                    = 0x882F;
enum GL_DRAW_BUFFER11                    = 0x8830;
enum GL_DRAW_BUFFER12                    = 0x8831;
enum GL_DRAW_BUFFER13                    = 0x8832;
enum GL_DRAW_BUFFER14                    = 0x8833;
enum GL_DRAW_BUFFER15                    = 0x8834;
enum GL_BLEND_EQUATION_ALPHA             = 0x883D;
enum GL_MAX_VERTEX_ATTRIBS               = 0x8869;
enum GL_VERTEX_ATTRIB_ARRAY_NORMALIZED   = 0x886A;
enum GL_MAX_TEXTURE_IMAGE_UNITS          = 0x8872;
enum GL_FRAGMENT_SHADER                  = 0x8B30;
enum GL_VERTEX_SHADER                    = 0x8B31;
enum GL_MAX_FRAGMENT_UNIFORM_COMPONENTS  = 0x8B49;
enum GL_MAX_VERTEX_UNIFORM_COMPONENTS    = 0x8B4A;
enum GL_MAX_VARYING_FLOATS               = 0x8B4B;
enum GL_MAX_VERTEX_TEXTURE_IMAGE_UNITS   = 0x8B4C;
enum GL_MAX_COMBINED_TEXTURE_IMAGE_UNITS = 0x8B4D;
enum GL_SHADER_TYPE                      = 0x8B4F;
enum GL_FLOAT_VEC2                       = 0x8B50;
enum GL_FLOAT_VEC3                       = 0x8B51;
enum GL_FLOAT_VEC4                       = 0x8B52;
enum GL_INT_VEC2                         = 0x8B53;
enum GL_INT_VEC3                         = 0x8B54;
enum GL_INT_VEC4                         = 0x8B55;
enum GL_BOOL                             = 0x8B56;
enum GL_BOOL_VEC2                        = 0x8B57;
enum GL_BOOL_VEC3                        = 0x8B58;
enum GL_BOOL_VEC4                        = 0x8B59;
enum GL_FLOAT_MAT2                       = 0x8B5A;
enum GL_FLOAT_MAT3                       = 0x8B5B;
enum GL_FLOAT_MAT4                       = 0x8B5C;
enum GL_SAMPLER_1D                       = 0x8B5D;
enum GL_SAMPLER_2D                       = 0x8B5E;
enum GL_SAMPLER_3D                       = 0x8B5F;
enum GL_SAMPLER_CUBE                     = 0x8B60;
enum GL_SAMPLER_1D_SHADOW                = 0x8B61;
enum GL_SAMPLER_2D_SHADOW                = 0x8B62;
enum GL_DELETE_STATUS                    = 0x8B80;
enum GL_COMPILE_STATUS                   = 0x8B81;
enum GL_LINK_STATUS                      = 0x8B82;
enum GL_VALIDATE_STATUS                  = 0x8B83;
enum GL_INFO_LOG_LENGTH                  = 0x8B84;
enum GL_ATTACHED_SHADERS                 = 0x8B85;
enum GL_ACTIVE_UNIFORMS                  = 0x8B86;
enum GL_ACTIVE_UNIFORM_MAX_LENGTH        = 0x8B87;
enum GL_SHADER_SOURCE_LENGTH             = 0x8B88;
enum GL_ACTIVE_ATTRIBUTES                = 0x8B89;
enum GL_ACTIVE_ATTRIBUTE_MAX_LENGTH      = 0x8B8A;
enum GL_FRAGMENT_SHADER_DERIVATIVE_HINT  = 0x8B8B;
enum GL_SHADING_LANGUAGE_VERSION         = 0x8B8C;
enum GL_CURRENT_PROGRAM                  = 0x8B8D;
enum GL_POINT_SPRITE_COORD_ORIGIN        = 0x8CA0;
enum GL_LOWER_LEFT                       = 0x8CA1;
enum GL_UPPER_LEFT                       = 0x8CA2;
enum GL_STENCIL_BACK_REF                 = 0x8CA3;
enum GL_STENCIL_BACK_VALUE_MASK          = 0x8CA4;
enum GL_STENCIL_BACK_WRITEMASK           = 0x8CA5;

// Constants for GL_VERSION_2_1
enum GL_PIXEL_PACK_BUFFER           = 0x88EB;
enum GL_PIXEL_UNPACK_BUFFER         = 0x88EC;
enum GL_PIXEL_PACK_BUFFER_BINDING   = 0x88ED;
enum GL_PIXEL_UNPACK_BUFFER_BINDING = 0x88EF;
enum GL_FLOAT_MAT2x3                = 0x8B65;
enum GL_FLOAT_MAT2x4                = 0x8B66;
enum GL_FLOAT_MAT3x2                = 0x8B67;
enum GL_FLOAT_MAT3x4                = 0x8B68;
enum GL_FLOAT_MAT4x2                = 0x8B69;
enum GL_FLOAT_MAT4x3                = 0x8B6A;
enum GL_SRGB                        = 0x8C40;
enum GL_SRGB8                       = 0x8C41;
enum GL_SRGB_ALPHA                  = 0x8C42;
enum GL_SRGB8_ALPHA8                = 0x8C43;
enum GL_COMPRESSED_SRGB             = 0x8C48;
enum GL_COMPRESSED_SRGB_ALPHA       = 0x8C49;

// Constants for GL_VERSION_3_0
enum GL_COMPARE_REF_TO_TEXTURE                        = 0x884E;
enum GL_CLIP_DISTANCE0                                = 0x3000;
enum GL_CLIP_DISTANCE1                                = 0x3001;
enum GL_CLIP_DISTANCE2                                = 0x3002;
enum GL_CLIP_DISTANCE3                                = 0x3003;
enum GL_CLIP_DISTANCE4                                = 0x3004;
enum GL_CLIP_DISTANCE5                                = 0x3005;
enum GL_CLIP_DISTANCE6                                = 0x3006;
enum GL_CLIP_DISTANCE7                                = 0x3007;
enum GL_MAX_CLIP_DISTANCES                            = 0x0D32;
enum GL_MAJOR_VERSION                                 = 0x821B;
enum GL_MINOR_VERSION                                 = 0x821C;
enum GL_NUM_EXTENSIONS                                = 0x821D;
enum GL_CONTEXT_FLAGS                                 = 0x821E;
enum GL_COMPRESSED_RED                                = 0x8225;
enum GL_COMPRESSED_RG                                 = 0x8226;
enum GL_CONTEXT_FLAG_FORWARD_COMPATIBLE_BIT           = 0x00000001;
enum GL_RGBA32F                                       = 0x8814;
enum GL_RGB32F                                        = 0x8815;
enum GL_RGBA16F                                       = 0x881A;
enum GL_RGB16F                                        = 0x881B;
enum GL_VERTEX_ATTRIB_ARRAY_INTEGER                   = 0x88FD;
enum GL_MAX_ARRAY_TEXTURE_LAYERS                      = 0x88FF;
enum GL_MIN_PROGRAM_TEXEL_OFFSET                      = 0x8904;
enum GL_MAX_PROGRAM_TEXEL_OFFSET                      = 0x8905;
enum GL_CLAMP_READ_COLOR                              = 0x891C;
enum GL_FIXED_ONLY                                    = 0x891D;
enum GL_MAX_VARYING_COMPONENTS                        = 0x8B4B;
enum GL_TEXTURE_1D_ARRAY                              = 0x8C18;
enum GL_PROXY_TEXTURE_1D_ARRAY                        = 0x8C19;
enum GL_TEXTURE_2D_ARRAY                              = 0x8C1A;
enum GL_PROXY_TEXTURE_2D_ARRAY                        = 0x8C1B;
enum GL_TEXTURE_BINDING_1D_ARRAY                      = 0x8C1C;
enum GL_TEXTURE_BINDING_2D_ARRAY                      = 0x8C1D;
enum GL_R11F_G11F_B10F                                = 0x8C3A;
enum GL_UNSIGNED_INT_10F_11F_11F_REV                  = 0x8C3B;
enum GL_RGB9_E5                                       = 0x8C3D;
enum GL_UNSIGNED_INT_5_9_9_9_REV                      = 0x8C3E;
enum GL_TEXTURE_SHARED_SIZE                           = 0x8C3F;
enum GL_TRANSFORM_FEEDBACK_VARYING_MAX_LENGTH         = 0x8C76;
enum GL_TRANSFORM_FEEDBACK_BUFFER_MODE                = 0x8C7F;
enum GL_MAX_TRANSFORM_FEEDBACK_SEPARATE_COMPONENTS    = 0x8C80;
enum GL_TRANSFORM_FEEDBACK_VARYINGS                   = 0x8C83;
enum GL_TRANSFORM_FEEDBACK_BUFFER_START               = 0x8C84;
enum GL_TRANSFORM_FEEDBACK_BUFFER_SIZE                = 0x8C85;
enum GL_PRIMITIVES_GENERATED                          = 0x8C87;
enum GL_TRANSFORM_FEEDBACK_PRIMITIVES_WRITTEN         = 0x8C88;
enum GL_RASTERIZER_DISCARD                            = 0x8C89;
enum GL_MAX_TRANSFORM_FEEDBACK_INTERLEAVED_COMPONENTS = 0x8C8A;
enum GL_MAX_TRANSFORM_FEEDBACK_SEPARATE_ATTRIBS       = 0x8C8B;
enum GL_INTERLEAVED_ATTRIBS                           = 0x8C8C;
enum GL_SEPARATE_ATTRIBS                              = 0x8C8D;
enum GL_TRANSFORM_FEEDBACK_BUFFER                     = 0x8C8E;
enum GL_TRANSFORM_FEEDBACK_BUFFER_BINDING             = 0x8C8F;
enum GL_RGBA32UI                                      = 0x8D70;
enum GL_RGB32UI                                       = 0x8D71;
enum GL_RGBA16UI                                      = 0x8D76;
enum GL_RGB16UI                                       = 0x8D77;
enum GL_RGBA8UI                                       = 0x8D7C;
enum GL_RGB8UI                                        = 0x8D7D;
enum GL_RGBA32I                                       = 0x8D82;
enum GL_RGB32I                                        = 0x8D83;
enum GL_RGBA16I                                       = 0x8D88;
enum GL_RGB16I                                        = 0x8D89;
enum GL_RGBA8I                                        = 0x8D8E;
enum GL_RGB8I                                         = 0x8D8F;
enum GL_RED_INTEGER                                   = 0x8D94;
enum GL_GREEN_INTEGER                                 = 0x8D95;
enum GL_BLUE_INTEGER                                  = 0x8D96;
enum GL_RGB_INTEGER                                   = 0x8D98;
enum GL_RGBA_INTEGER                                  = 0x8D99;
enum GL_BGR_INTEGER                                   = 0x8D9A;
enum GL_BGRA_INTEGER                                  = 0x8D9B;
enum GL_SAMPLER_1D_ARRAY                              = 0x8DC0;
enum GL_SAMPLER_2D_ARRAY                              = 0x8DC1;
enum GL_SAMPLER_1D_ARRAY_SHADOW                       = 0x8DC3;
enum GL_SAMPLER_2D_ARRAY_SHADOW                       = 0x8DC4;
enum GL_SAMPLER_CUBE_SHADOW                           = 0x8DC5;
enum GL_UNSIGNED_INT_VEC2                             = 0x8DC6;
enum GL_UNSIGNED_INT_VEC3                             = 0x8DC7;
enum GL_UNSIGNED_INT_VEC4                             = 0x8DC8;
enum GL_INT_SAMPLER_1D                                = 0x8DC9;
enum GL_INT_SAMPLER_2D                                = 0x8DCA;
enum GL_INT_SAMPLER_3D                                = 0x8DCB;
enum GL_INT_SAMPLER_CUBE                              = 0x8DCC;
enum GL_INT_SAMPLER_1D_ARRAY                          = 0x8DCE;
enum GL_INT_SAMPLER_2D_ARRAY                          = 0x8DCF;
enum GL_UNSIGNED_INT_SAMPLER_1D                       = 0x8DD1;
enum GL_UNSIGNED_INT_SAMPLER_2D                       = 0x8DD2;
enum GL_UNSIGNED_INT_SAMPLER_3D                       = 0x8DD3;
enum GL_UNSIGNED_INT_SAMPLER_CUBE                     = 0x8DD4;
enum GL_UNSIGNED_INT_SAMPLER_1D_ARRAY                 = 0x8DD6;
enum GL_UNSIGNED_INT_SAMPLER_2D_ARRAY                 = 0x8DD7;
enum GL_QUERY_WAIT                                    = 0x8E13;
enum GL_QUERY_NO_WAIT                                 = 0x8E14;
enum GL_QUERY_BY_REGION_WAIT                          = 0x8E15;
enum GL_QUERY_BY_REGION_NO_WAIT                       = 0x8E16;
enum GL_BUFFER_ACCESS_FLAGS                           = 0x911F;
enum GL_BUFFER_MAP_LENGTH                             = 0x9120;
enum GL_BUFFER_MAP_OFFSET                             = 0x9121;
enum GL_DEPTH_COMPONENT32F                            = 0x8CAC;
enum GL_DEPTH32F_STENCIL8                             = 0x8CAD;
enum GL_FLOAT_32_UNSIGNED_INT_24_8_REV                = 0x8DAD;
enum GL_INVALID_FRAMEBUFFER_OPERATION                 = 0x0506;
enum GL_FRAMEBUFFER_ATTACHMENT_COLOR_ENCODING         = 0x8210;
enum GL_FRAMEBUFFER_ATTACHMENT_COMPONENT_TYPE         = 0x8211;
enum GL_FRAMEBUFFER_ATTACHMENT_RED_SIZE               = 0x8212;
enum GL_FRAMEBUFFER_ATTACHMENT_GREEN_SIZE             = 0x8213;
enum GL_FRAMEBUFFER_ATTACHMENT_BLUE_SIZE              = 0x8214;
enum GL_FRAMEBUFFER_ATTACHMENT_ALPHA_SIZE             = 0x8215;
enum GL_FRAMEBUFFER_ATTACHMENT_DEPTH_SIZE             = 0x8216;
enum GL_FRAMEBUFFER_ATTACHMENT_STENCIL_SIZE           = 0x8217;
enum GL_FRAMEBUFFER_DEFAULT                           = 0x8218;
enum GL_FRAMEBUFFER_UNDEFINED                         = 0x8219;
enum GL_DEPTH_STENCIL_ATTACHMENT                      = 0x821A;
enum GL_MAX_RENDERBUFFER_SIZE                         = 0x84E8;
enum GL_DEPTH_STENCIL                                 = 0x84F9;
enum GL_UNSIGNED_INT_24_8                             = 0x84FA;
enum GL_DEPTH24_STENCIL8                              = 0x88F0;
enum GL_TEXTURE_STENCIL_SIZE                          = 0x88F1;
enum GL_TEXTURE_RED_TYPE                              = 0x8C10;
enum GL_TEXTURE_GREEN_TYPE                            = 0x8C11;
enum GL_TEXTURE_BLUE_TYPE                             = 0x8C12;
enum GL_TEXTURE_ALPHA_TYPE                            = 0x8C13;
enum GL_TEXTURE_DEPTH_TYPE                            = 0x8C16;
enum GL_UNSIGNED_NORMALIZED                           = 0x8C17;
enum GL_FRAMEBUFFER_BINDING                           = 0x8CA6;
enum GL_DRAW_FRAMEBUFFER_BINDING                      = 0x8CA6;
enum GL_RENDERBUFFER_BINDING                          = 0x8CA7;
enum GL_READ_FRAMEBUFFER                              = 0x8CA8;
enum GL_DRAW_FRAMEBUFFER                              = 0x8CA9;
enum GL_READ_FRAMEBUFFER_BINDING                      = 0x8CAA;
enum GL_RENDERBUFFER_SAMPLES                          = 0x8CAB;
enum GL_FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE            = 0x8CD0;
enum GL_FRAMEBUFFER_ATTACHMENT_OBJECT_NAME            = 0x8CD1;
enum GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL          = 0x8CD2;
enum GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE  = 0x8CD3;
enum GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_LAYER          = 0x8CD4;
enum GL_FRAMEBUFFER_COMPLETE                          = 0x8CD5;
enum GL_FRAMEBUFFER_INCOMPLETE_ATTACHMENT             = 0x8CD6;
enum GL_FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT     = 0x8CD7;
enum GL_FRAMEBUFFER_INCOMPLETE_DRAW_BUFFER            = 0x8CDB;
enum GL_FRAMEBUFFER_INCOMPLETE_READ_BUFFER            = 0x8CDC;
enum GL_FRAMEBUFFER_UNSUPPORTED                       = 0x8CDD;
enum GL_MAX_COLOR_ATTACHMENTS                         = 0x8CDF;
enum GL_COLOR_ATTACHMENT0                             = 0x8CE0;
enum GL_COLOR_ATTACHMENT1                             = 0x8CE1;
enum GL_COLOR_ATTACHMENT2                             = 0x8CE2;
enum GL_COLOR_ATTACHMENT3                             = 0x8CE3;
enum GL_COLOR_ATTACHMENT4                             = 0x8CE4;
enum GL_COLOR_ATTACHMENT5                             = 0x8CE5;
enum GL_COLOR_ATTACHMENT6                             = 0x8CE6;
enum GL_COLOR_ATTACHMENT7                             = 0x8CE7;
enum GL_COLOR_ATTACHMENT8                             = 0x8CE8;
enum GL_COLOR_ATTACHMENT9                             = 0x8CE9;
enum GL_COLOR_ATTACHMENT10                            = 0x8CEA;
enum GL_COLOR_ATTACHMENT11                            = 0x8CEB;
enum GL_COLOR_ATTACHMENT12                            = 0x8CEC;
enum GL_COLOR_ATTACHMENT13                            = 0x8CED;
enum GL_COLOR_ATTACHMENT14                            = 0x8CEE;
enum GL_COLOR_ATTACHMENT15                            = 0x8CEF;
enum GL_COLOR_ATTACHMENT16                            = 0x8CF0;
enum GL_COLOR_ATTACHMENT17                            = 0x8CF1;
enum GL_COLOR_ATTACHMENT18                            = 0x8CF2;
enum GL_COLOR_ATTACHMENT19                            = 0x8CF3;
enum GL_COLOR_ATTACHMENT20                            = 0x8CF4;
enum GL_COLOR_ATTACHMENT21                            = 0x8CF5;
enum GL_COLOR_ATTACHMENT22                            = 0x8CF6;
enum GL_COLOR_ATTACHMENT23                            = 0x8CF7;
enum GL_COLOR_ATTACHMENT24                            = 0x8CF8;
enum GL_COLOR_ATTACHMENT25                            = 0x8CF9;
enum GL_COLOR_ATTACHMENT26                            = 0x8CFA;
enum GL_COLOR_ATTACHMENT27                            = 0x8CFB;
enum GL_COLOR_ATTACHMENT28                            = 0x8CFC;
enum GL_COLOR_ATTACHMENT29                            = 0x8CFD;
enum GL_COLOR_ATTACHMENT30                            = 0x8CFE;
enum GL_COLOR_ATTACHMENT31                            = 0x8CFF;
enum GL_DEPTH_ATTACHMENT                              = 0x8D00;
enum GL_STENCIL_ATTACHMENT                            = 0x8D20;
enum GL_FRAMEBUFFER                                   = 0x8D40;
enum GL_RENDERBUFFER                                  = 0x8D41;
enum GL_RENDERBUFFER_WIDTH                            = 0x8D42;
enum GL_RENDERBUFFER_HEIGHT                           = 0x8D43;
enum GL_RENDERBUFFER_INTERNAL_FORMAT                  = 0x8D44;
enum GL_STENCIL_INDEX1                                = 0x8D46;
enum GL_STENCIL_INDEX4                                = 0x8D47;
enum GL_STENCIL_INDEX8                                = 0x8D48;
enum GL_STENCIL_INDEX16                               = 0x8D49;
enum GL_RENDERBUFFER_RED_SIZE                         = 0x8D50;
enum GL_RENDERBUFFER_GREEN_SIZE                       = 0x8D51;
enum GL_RENDERBUFFER_BLUE_SIZE                        = 0x8D52;
enum GL_RENDERBUFFER_ALPHA_SIZE                       = 0x8D53;
enum GL_RENDERBUFFER_DEPTH_SIZE                       = 0x8D54;
enum GL_RENDERBUFFER_STENCIL_SIZE                     = 0x8D55;
enum GL_FRAMEBUFFER_INCOMPLETE_MULTISAMPLE            = 0x8D56;
enum GL_MAX_SAMPLES                                   = 0x8D57;
enum GL_FRAMEBUFFER_SRGB                              = 0x8DB9;
enum GL_HALF_FLOAT                                    = 0x140B;
enum GL_MAP_READ_BIT                                  = 0x0001;
enum GL_MAP_WRITE_BIT                                 = 0x0002;
enum GL_MAP_INVALIDATE_RANGE_BIT                      = 0x0004;
enum GL_MAP_INVALIDATE_BUFFER_BIT                     = 0x0008;
enum GL_MAP_FLUSH_EXPLICIT_BIT                        = 0x0010;
enum GL_MAP_UNSYNCHRONIZED_BIT                        = 0x0020;
enum GL_COMPRESSED_RED_RGTC1                          = 0x8DBB;
enum GL_COMPRESSED_SIGNED_RED_RGTC1                   = 0x8DBC;
enum GL_COMPRESSED_RG_RGTC2                           = 0x8DBD;
enum GL_COMPRESSED_SIGNED_RG_RGTC2                    = 0x8DBE;
enum GL_RG                                            = 0x8227;
enum GL_RG_INTEGER                                    = 0x8228;
enum GL_R8                                            = 0x8229;
enum GL_R16                                           = 0x822A;
enum GL_RG8                                           = 0x822B;
enum GL_RG16                                          = 0x822C;
enum GL_R16F                                          = 0x822D;
enum GL_R32F                                          = 0x822E;
enum GL_RG16F                                         = 0x822F;
enum GL_RG32F                                         = 0x8230;
enum GL_R8I                                           = 0x8231;
enum GL_R8UI                                          = 0x8232;
enum GL_R16I                                          = 0x8233;
enum GL_R16UI                                         = 0x8234;
enum GL_R32I                                          = 0x8235;
enum GL_R32UI                                         = 0x8236;
enum GL_RG8I                                          = 0x8237;
enum GL_RG8UI                                         = 0x8238;
enum GL_RG16I                                         = 0x8239;
enum GL_RG16UI                                        = 0x823A;
enum GL_RG32I                                         = 0x823B;
enum GL_RG32UI                                        = 0x823C;
enum GL_VERTEX_ARRAY_BINDING                          = 0x85B5;

// Constants for GL_VERSION_3_1
enum GL_SAMPLER_2D_RECT                             = 0x8B63;
enum GL_SAMPLER_2D_RECT_SHADOW                      = 0x8B64;
enum GL_SAMPLER_BUFFER                              = 0x8DC2;
enum GL_INT_SAMPLER_2D_RECT                         = 0x8DCD;
enum GL_INT_SAMPLER_BUFFER                          = 0x8DD0;
enum GL_UNSIGNED_INT_SAMPLER_2D_RECT                = 0x8DD5;
enum GL_UNSIGNED_INT_SAMPLER_BUFFER                 = 0x8DD8;
enum GL_TEXTURE_BUFFER                              = 0x8C2A;
enum GL_MAX_TEXTURE_BUFFER_SIZE                     = 0x8C2B;
enum GL_TEXTURE_BINDING_BUFFER                      = 0x8C2C;
enum GL_TEXTURE_BUFFER_DATA_STORE_BINDING           = 0x8C2D;
enum GL_TEXTURE_RECTANGLE                           = 0x84F5;
enum GL_TEXTURE_BINDING_RECTANGLE                   = 0x84F6;
enum GL_PROXY_TEXTURE_RECTANGLE                     = 0x84F7;
enum GL_MAX_RECTANGLE_TEXTURE_SIZE                  = 0x84F8;
enum GL_R8_SNORM                                    = 0x8F94;
enum GL_RG8_SNORM                                   = 0x8F95;
enum GL_RGB8_SNORM                                  = 0x8F96;
enum GL_RGBA8_SNORM                                 = 0x8F97;
enum GL_R16_SNORM                                   = 0x8F98;
enum GL_RG16_SNORM                                  = 0x8F99;
enum GL_RGB16_SNORM                                 = 0x8F9A;
enum GL_RGBA16_SNORM                                = 0x8F9B;
enum GL_SIGNED_NORMALIZED                           = 0x8F9C;
enum GL_PRIMITIVE_RESTART                           = 0x8F9D;
enum GL_PRIMITIVE_RESTART_INDEX                     = 0x8F9E;
enum GL_COPY_READ_BUFFER                            = 0x8F36;
enum GL_COPY_WRITE_BUFFER                           = 0x8F37;
enum GL_UNIFORM_BUFFER                              = 0x8A11;
enum GL_UNIFORM_BUFFER_BINDING                      = 0x8A28;
enum GL_UNIFORM_BUFFER_START                        = 0x8A29;
enum GL_UNIFORM_BUFFER_SIZE                         = 0x8A2A;
enum GL_MAX_VERTEX_UNIFORM_BLOCKS                   = 0x8A2B;
enum GL_MAX_GEOMETRY_UNIFORM_BLOCKS                 = 0x8A2C;
enum GL_MAX_FRAGMENT_UNIFORM_BLOCKS                 = 0x8A2D;
enum GL_MAX_COMBINED_UNIFORM_BLOCKS                 = 0x8A2E;
enum GL_MAX_UNIFORM_BUFFER_BINDINGS                 = 0x8A2F;
enum GL_MAX_UNIFORM_BLOCK_SIZE                      = 0x8A30;
enum GL_MAX_COMBINED_VERTEX_UNIFORM_COMPONENTS      = 0x8A31;
enum GL_MAX_COMBINED_GEOMETRY_UNIFORM_COMPONENTS    = 0x8A32;
enum GL_MAX_COMBINED_FRAGMENT_UNIFORM_COMPONENTS    = 0x8A33;
enum GL_UNIFORM_BUFFER_OFFSET_ALIGNMENT             = 0x8A34;
enum GL_ACTIVE_UNIFORM_BLOCK_MAX_NAME_LENGTH        = 0x8A35;
enum GL_ACTIVE_UNIFORM_BLOCKS                       = 0x8A36;
enum GL_UNIFORM_TYPE                                = 0x8A37;
enum GL_UNIFORM_SIZE                                = 0x8A38;
enum GL_UNIFORM_NAME_LENGTH                         = 0x8A39;
enum GL_UNIFORM_BLOCK_INDEX                         = 0x8A3A;
enum GL_UNIFORM_OFFSET                              = 0x8A3B;
enum GL_UNIFORM_ARRAY_STRIDE                        = 0x8A3C;
enum GL_UNIFORM_MATRIX_STRIDE                       = 0x8A3D;
enum GL_UNIFORM_IS_ROW_MAJOR                        = 0x8A3E;
enum GL_UNIFORM_BLOCK_BINDING                       = 0x8A3F;
enum GL_UNIFORM_BLOCK_DATA_SIZE                     = 0x8A40;
enum GL_UNIFORM_BLOCK_NAME_LENGTH                   = 0x8A41;
enum GL_UNIFORM_BLOCK_ACTIVE_UNIFORMS               = 0x8A42;
enum GL_UNIFORM_BLOCK_ACTIVE_UNIFORM_INDICES        = 0x8A43;
enum GL_UNIFORM_BLOCK_REFERENCED_BY_VERTEX_SHADER   = 0x8A44;
enum GL_UNIFORM_BLOCK_REFERENCED_BY_GEOMETRY_SHADER = 0x8A45;
enum GL_UNIFORM_BLOCK_REFERENCED_BY_FRAGMENT_SHADER = 0x8A46;
enum GL_INVALID_INDEX                               = 0xFFFFFFFF;

// Constants for GL_VERSION_3_2
enum GL_CONTEXT_CORE_PROFILE_BIT                  = 0x00000001;
enum GL_CONTEXT_COMPATIBILITY_PROFILE_BIT         = 0x00000002;
enum GL_LINES_ADJACENCY                           = 0x000A;
enum GL_LINE_STRIP_ADJACENCY                      = 0x000B;
enum GL_TRIANGLES_ADJACENCY                       = 0x000C;
enum GL_TRIANGLE_STRIP_ADJACENCY                  = 0x000D;
enum GL_PROGRAM_POINT_SIZE                        = 0x8642;
enum GL_MAX_GEOMETRY_TEXTURE_IMAGE_UNITS          = 0x8C29;
enum GL_FRAMEBUFFER_ATTACHMENT_LAYERED            = 0x8DA7;
enum GL_FRAMEBUFFER_INCOMPLETE_LAYER_TARGETS      = 0x8DA8;
enum GL_GEOMETRY_SHADER                           = 0x8DD9;
enum GL_GEOMETRY_VERTICES_OUT                     = 0x8916;
enum GL_GEOMETRY_INPUT_TYPE                       = 0x8917;
enum GL_GEOMETRY_OUTPUT_TYPE                      = 0x8918;
enum GL_MAX_GEOMETRY_UNIFORM_COMPONENTS           = 0x8DDF;
enum GL_MAX_GEOMETRY_OUTPUT_VERTICES              = 0x8DE0;
enum GL_MAX_GEOMETRY_TOTAL_OUTPUT_COMPONENTS      = 0x8DE1;
enum GL_MAX_VERTEX_OUTPUT_COMPONENTS              = 0x9122;
enum GL_MAX_GEOMETRY_INPUT_COMPONENTS             = 0x9123;
enum GL_MAX_GEOMETRY_OUTPUT_COMPONENTS            = 0x9124;
enum GL_MAX_FRAGMENT_INPUT_COMPONENTS             = 0x9125;
enum GL_CONTEXT_PROFILE_MASK                      = 0x9126;
enum GL_DEPTH_CLAMP                               = 0x864F;
enum GL_QUADS_FOLLOW_PROVOKING_VERTEX_CONVENTION  = 0x8E4C;
enum GL_FIRST_VERTEX_CONVENTION                   = 0x8E4D;
enum GL_LAST_VERTEX_CONVENTION                    = 0x8E4E;
enum GL_PROVOKING_VERTEX                          = 0x8E4F;
enum GL_TEXTURE_CUBE_MAP_SEAMLESS                 = 0x884F;
enum GL_MAX_SERVER_WAIT_TIMEOUT                   = 0x9111;
enum GL_OBJECT_TYPE                               = 0x9112;
enum GL_SYNC_CONDITION                            = 0x9113;
enum GL_SYNC_STATUS                               = 0x9114;
enum GL_SYNC_FLAGS                                = 0x9115;
enum GL_SYNC_FENCE                                = 0x9116;
enum GL_SYNC_GPU_COMMANDS_COMPLETE                = 0x9117;
enum GL_UNSIGNALED                                = 0x9118;
enum GL_SIGNALED                                  = 0x9119;
enum GL_ALREADY_SIGNALED                          = 0x911A;
enum GL_TIMEOUT_EXPIRED                           = 0x911B;
enum GL_CONDITION_SATISFIED                       = 0x911C;
enum GL_WAIT_FAILED                               = 0x911D;
enum GL_TIMEOUT_IGNORED                           = 0xFFFFFFFFFFFFFFFF;
enum GL_SYNC_FLUSH_COMMANDS_BIT                   = 0x00000001;
enum GL_SAMPLE_POSITION                           = 0x8E50;
enum GL_SAMPLE_MASK                               = 0x8E51;
enum GL_SAMPLE_MASK_VALUE                         = 0x8E52;
enum GL_MAX_SAMPLE_MASK_WORDS                     = 0x8E59;
enum GL_TEXTURE_2D_MULTISAMPLE                    = 0x9100;
enum GL_PROXY_TEXTURE_2D_MULTISAMPLE              = 0x9101;
enum GL_TEXTURE_2D_MULTISAMPLE_ARRAY              = 0x9102;
enum GL_PROXY_TEXTURE_2D_MULTISAMPLE_ARRAY        = 0x9103;
enum GL_TEXTURE_BINDING_2D_MULTISAMPLE            = 0x9104;
enum GL_TEXTURE_BINDING_2D_MULTISAMPLE_ARRAY      = 0x9105;
enum GL_TEXTURE_SAMPLES                           = 0x9106;
enum GL_TEXTURE_FIXED_SAMPLE_LOCATIONS            = 0x9107;
enum GL_SAMPLER_2D_MULTISAMPLE                    = 0x9108;
enum GL_INT_SAMPLER_2D_MULTISAMPLE                = 0x9109;
enum GL_UNSIGNED_INT_SAMPLER_2D_MULTISAMPLE       = 0x910A;
enum GL_SAMPLER_2D_MULTISAMPLE_ARRAY              = 0x910B;
enum GL_INT_SAMPLER_2D_MULTISAMPLE_ARRAY          = 0x910C;
enum GL_UNSIGNED_INT_SAMPLER_2D_MULTISAMPLE_ARRAY = 0x910D;
enum GL_MAX_COLOR_TEXTURE_SAMPLES                 = 0x910E;
enum GL_MAX_DEPTH_TEXTURE_SAMPLES                 = 0x910F;
enum GL_MAX_INTEGER_SAMPLES                       = 0x9110;

// Constants for GL_VERSION_3_3
enum GL_VERTEX_ATTRIB_ARRAY_DIVISOR  = 0x88FE;
enum GL_SRC1_COLOR                   = 0x88F9;
enum GL_ONE_MINUS_SRC1_COLOR         = 0x88FA;
enum GL_ONE_MINUS_SRC1_ALPHA         = 0x88FB;
enum GL_MAX_DUAL_SOURCE_DRAW_BUFFERS = 0x88FC;
enum GL_ANY_SAMPLES_PASSED           = 0x8C2F;
enum GL_SAMPLER_BINDING              = 0x8919;
enum GL_RGB10_A2UI                   = 0x906F;
enum GL_TEXTURE_SWIZZLE_R            = 0x8E42;
enum GL_TEXTURE_SWIZZLE_G            = 0x8E43;
enum GL_TEXTURE_SWIZZLE_B            = 0x8E44;
enum GL_TEXTURE_SWIZZLE_A            = 0x8E45;
enum GL_TEXTURE_SWIZZLE_RGBA         = 0x8E46;
enum GL_TIME_ELAPSED                 = 0x88BF;
enum GL_TIMESTAMP                    = 0x8E28;
enum GL_INT_2_10_10_10_REV           = 0x8D9F;

// Constants for GL_VERSION_4_0
enum GL_SAMPLE_SHADING                                     = 0x8C36;
enum GL_MIN_SAMPLE_SHADING_VALUE                           = 0x8C37;
enum GL_MIN_PROGRAM_TEXTURE_GATHER_OFFSET                  = 0x8E5E;
enum GL_MAX_PROGRAM_TEXTURE_GATHER_OFFSET                  = 0x8E5F;
enum GL_TEXTURE_CUBE_MAP_ARRAY                             = 0x9009;
enum GL_TEXTURE_BINDING_CUBE_MAP_ARRAY                     = 0x900A;
enum GL_PROXY_TEXTURE_CUBE_MAP_ARRAY                       = 0x900B;
enum GL_SAMPLER_CUBE_MAP_ARRAY                             = 0x900C;
enum GL_SAMPLER_CUBE_MAP_ARRAY_SHADOW                      = 0x900D;
enum GL_INT_SAMPLER_CUBE_MAP_ARRAY                         = 0x900E;
enum GL_UNSIGNED_INT_SAMPLER_CUBE_MAP_ARRAY                = 0x900F;
enum GL_DRAW_INDIRECT_BUFFER                               = 0x8F3F;
enum GL_DRAW_INDIRECT_BUFFER_BINDING                       = 0x8F43;
enum GL_GEOMETRY_SHADER_INVOCATIONS                        = 0x887F;
enum GL_MAX_GEOMETRY_SHADER_INVOCATIONS                    = 0x8E5A;
enum GL_MIN_FRAGMENT_INTERPOLATION_OFFSET                  = 0x8E5B;
enum GL_MAX_FRAGMENT_INTERPOLATION_OFFSET                  = 0x8E5C;
enum GL_FRAGMENT_INTERPOLATION_OFFSET_BITS                 = 0x8E5D;
enum GL_MAX_VERTEX_STREAMS                                 = 0x8E71;
enum GL_DOUBLE_VEC2                                        = 0x8FFC;
enum GL_DOUBLE_VEC3                                        = 0x8FFD;
enum GL_DOUBLE_VEC4                                        = 0x8FFE;
enum GL_DOUBLE_MAT2                                        = 0x8F46;
enum GL_DOUBLE_MAT3                                        = 0x8F47;
enum GL_DOUBLE_MAT4                                        = 0x8F48;
enum GL_DOUBLE_MAT2x3                                      = 0x8F49;
enum GL_DOUBLE_MAT2x4                                      = 0x8F4A;
enum GL_DOUBLE_MAT3x2                                      = 0x8F4B;
enum GL_DOUBLE_MAT3x4                                      = 0x8F4C;
enum GL_DOUBLE_MAT4x2                                      = 0x8F4D;
enum GL_DOUBLE_MAT4x3                                      = 0x8F4E;
enum GL_ACTIVE_SUBROUTINES                                 = 0x8DE5;
enum GL_ACTIVE_SUBROUTINE_UNIFORMS                         = 0x8DE6;
enum GL_ACTIVE_SUBROUTINE_UNIFORM_LOCATIONS                = 0x8E47;
enum GL_ACTIVE_SUBROUTINE_MAX_LENGTH                       = 0x8E48;
enum GL_ACTIVE_SUBROUTINE_UNIFORM_MAX_LENGTH               = 0x8E49;
enum GL_MAX_SUBROUTINES                                    = 0x8DE7;
enum GL_MAX_SUBROUTINE_UNIFORM_LOCATIONS                   = 0x8DE8;
enum GL_NUM_COMPATIBLE_SUBROUTINES                         = 0x8E4A;
enum GL_COMPATIBLE_SUBROUTINES                             = 0x8E4B;
enum GL_PATCHES                                            = 0x000E;
enum GL_PATCH_VERTICES                                     = 0x8E72;
enum GL_PATCH_DEFAULT_INNER_LEVEL                          = 0x8E73;
enum GL_PATCH_DEFAULT_OUTER_LEVEL                          = 0x8E74;
enum GL_TESS_CONTROL_OUTPUT_VERTICES                       = 0x8E75;
enum GL_TESS_GEN_MODE                                      = 0x8E76;
enum GL_TESS_GEN_SPACING                                   = 0x8E77;
enum GL_TESS_GEN_VERTEX_ORDER                              = 0x8E78;
enum GL_TESS_GEN_POINT_MODE                                = 0x8E79;
enum GL_ISOLINES                                           = 0x8E7A;
enum GL_FRACTIONAL_ODD                                     = 0x8E7B;
enum GL_FRACTIONAL_EVEN                                    = 0x8E7C;
enum GL_MAX_PATCH_VERTICES                                 = 0x8E7D;
enum GL_MAX_TESS_GEN_LEVEL                                 = 0x8E7E;
enum GL_MAX_TESS_CONTROL_UNIFORM_COMPONENTS                = 0x8E7F;
enum GL_MAX_TESS_EVALUATION_UNIFORM_COMPONENTS             = 0x8E80;
enum GL_MAX_TESS_CONTROL_TEXTURE_IMAGE_UNITS               = 0x8E81;
enum GL_MAX_TESS_EVALUATION_TEXTURE_IMAGE_UNITS            = 0x8E82;
enum GL_MAX_TESS_CONTROL_OUTPUT_COMPONENTS                 = 0x8E83;
enum GL_MAX_TESS_PATCH_COMPONENTS                          = 0x8E84;
enum GL_MAX_TESS_CONTROL_TOTAL_OUTPUT_COMPONENTS           = 0x8E85;
enum GL_MAX_TESS_EVALUATION_OUTPUT_COMPONENTS              = 0x8E86;
enum GL_MAX_TESS_CONTROL_UNIFORM_BLOCKS                    = 0x8E89;
enum GL_MAX_TESS_EVALUATION_UNIFORM_BLOCKS                 = 0x8E8A;
enum GL_MAX_TESS_CONTROL_INPUT_COMPONENTS                  = 0x886C;
enum GL_MAX_TESS_EVALUATION_INPUT_COMPONENTS               = 0x886D;
enum GL_MAX_COMBINED_TESS_CONTROL_UNIFORM_COMPONENTS       = 0x8E1E;
enum GL_MAX_COMBINED_TESS_EVALUATION_UNIFORM_COMPONENTS    = 0x8E1F;
enum GL_UNIFORM_BLOCK_REFERENCED_BY_TESS_CONTROL_SHADER    = 0x84F0;
enum GL_UNIFORM_BLOCK_REFERENCED_BY_TESS_EVALUATION_SHADER = 0x84F1;
enum GL_TESS_EVALUATION_SHADER                             = 0x8E87;
enum GL_TESS_CONTROL_SHADER                                = 0x8E88;
enum GL_TRANSFORM_FEEDBACK                                 = 0x8E22;
enum GL_TRANSFORM_FEEDBACK_BUFFER_PAUSED                   = 0x8E23;
enum GL_TRANSFORM_FEEDBACK_BUFFER_ACTIVE                   = 0x8E24;
enum GL_TRANSFORM_FEEDBACK_BINDING                         = 0x8E25;
enum GL_MAX_TRANSFORM_FEEDBACK_BUFFERS                     = 0x8E70;

// Constants for GL_VERSION_4_1
enum GL_FIXED                            = 0x140C;
enum GL_IMPLEMENTATION_COLOR_READ_TYPE   = 0x8B9A;
enum GL_IMPLEMENTATION_COLOR_READ_FORMAT = 0x8B9B;
enum GL_LOW_FLOAT                        = 0x8DF0;
enum GL_MEDIUM_FLOAT                     = 0x8DF1;
enum GL_HIGH_FLOAT                       = 0x8DF2;
enum GL_LOW_INT                          = 0x8DF3;
enum GL_MEDIUM_INT                       = 0x8DF4;
enum GL_HIGH_INT                         = 0x8DF5;
enum GL_SHADER_COMPILER                  = 0x8DFA;
enum GL_SHADER_BINARY_FORMATS            = 0x8DF8;
enum GL_NUM_SHADER_BINARY_FORMATS        = 0x8DF9;
enum GL_MAX_VERTEX_UNIFORM_VECTORS       = 0x8DFB;
enum GL_MAX_VARYING_VECTORS              = 0x8DFC;
enum GL_MAX_FRAGMENT_UNIFORM_VECTORS     = 0x8DFD;
enum GL_RGB565                           = 0x8D62;
enum GL_PROGRAM_BINARY_RETRIEVABLE_HINT  = 0x8257;
enum GL_PROGRAM_BINARY_LENGTH            = 0x8741;
enum GL_NUM_PROGRAM_BINARY_FORMATS       = 0x87FE;
enum GL_PROGRAM_BINARY_FORMATS           = 0x87FF;
enum GL_VERTEX_SHADER_BIT                = 0x00000001;
enum GL_FRAGMENT_SHADER_BIT              = 0x00000002;
enum GL_GEOMETRY_SHADER_BIT              = 0x00000004;
enum GL_TESS_CONTROL_SHADER_BIT          = 0x00000008;
enum GL_TESS_EVALUATION_SHADER_BIT       = 0x00000010;
enum GL_ALL_SHADER_BITS                  = 0xFFFFFFFF;
enum GL_PROGRAM_SEPARABLE                = 0x8258;
enum GL_ACTIVE_PROGRAM                   = 0x8259;
enum GL_PROGRAM_PIPELINE_BINDING         = 0x825A;
enum GL_MAX_VIEWPORTS                    = 0x825B;
enum GL_VIEWPORT_SUBPIXEL_BITS           = 0x825C;
enum GL_VIEWPORT_BOUNDS_RANGE            = 0x825D;
enum GL_LAYER_PROVOKING_VERTEX           = 0x825E;
enum GL_VIEWPORT_INDEX_PROVOKING_VERTEX  = 0x825F;
enum GL_UNDEFINED_VERTEX                 = 0x8260;

// Constants for GL_VERSION_4_2
enum GL_COPY_READ_BUFFER_BINDING                                   = 0x8F36;
enum GL_COPY_WRITE_BUFFER_BINDING                                  = 0x8F37;
enum GL_TRANSFORM_FEEDBACK_ACTIVE                                  = 0x8E24;
enum GL_TRANSFORM_FEEDBACK_PAUSED                                  = 0x8E23;
enum GL_UNPACK_COMPRESSED_BLOCK_WIDTH                              = 0x9127;
enum GL_UNPACK_COMPRESSED_BLOCK_HEIGHT                             = 0x9128;
enum GL_UNPACK_COMPRESSED_BLOCK_DEPTH                              = 0x9129;
enum GL_UNPACK_COMPRESSED_BLOCK_SIZE                               = 0x912A;
enum GL_PACK_COMPRESSED_BLOCK_WIDTH                                = 0x912B;
enum GL_PACK_COMPRESSED_BLOCK_HEIGHT                               = 0x912C;
enum GL_PACK_COMPRESSED_BLOCK_DEPTH                                = 0x912D;
enum GL_PACK_COMPRESSED_BLOCK_SIZE                                 = 0x912E;
enum GL_NUM_SAMPLE_COUNTS                                          = 0x9380;
enum GL_MIN_MAP_BUFFER_ALIGNMENT                                   = 0x90BC;
enum GL_ATOMIC_COUNTER_BUFFER                                      = 0x92C0;
enum GL_ATOMIC_COUNTER_BUFFER_BINDING                              = 0x92C1;
enum GL_ATOMIC_COUNTER_BUFFER_START                                = 0x92C2;
enum GL_ATOMIC_COUNTER_BUFFER_SIZE                                 = 0x92C3;
enum GL_ATOMIC_COUNTER_BUFFER_DATA_SIZE                            = 0x92C4;
enum GL_ATOMIC_COUNTER_BUFFER_ACTIVE_ATOMIC_COUNTERS               = 0x92C5;
enum GL_ATOMIC_COUNTER_BUFFER_ACTIVE_ATOMIC_COUNTER_INDICES        = 0x92C6;
enum GL_ATOMIC_COUNTER_BUFFER_REFERENCED_BY_VERTEX_SHADER          = 0x92C7;
enum GL_ATOMIC_COUNTER_BUFFER_REFERENCED_BY_TESS_CONTROL_SHADER    = 0x92C8;
enum GL_ATOMIC_COUNTER_BUFFER_REFERENCED_BY_TESS_EVALUATION_SHADER = 0x92C9;
enum GL_ATOMIC_COUNTER_BUFFER_REFERENCED_BY_GEOMETRY_SHADER        = 0x92CA;
enum GL_ATOMIC_COUNTER_BUFFER_REFERENCED_BY_FRAGMENT_SHADER        = 0x92CB;
enum GL_MAX_VERTEX_ATOMIC_COUNTER_BUFFERS                          = 0x92CC;
enum GL_MAX_TESS_CONTROL_ATOMIC_COUNTER_BUFFERS                    = 0x92CD;
enum GL_MAX_TESS_EVALUATION_ATOMIC_COUNTER_BUFFERS                 = 0x92CE;
enum GL_MAX_GEOMETRY_ATOMIC_COUNTER_BUFFERS                        = 0x92CF;
enum GL_MAX_FRAGMENT_ATOMIC_COUNTER_BUFFERS                        = 0x92D0;
enum GL_MAX_COMBINED_ATOMIC_COUNTER_BUFFERS                        = 0x92D1;
enum GL_MAX_VERTEX_ATOMIC_COUNTERS                                 = 0x92D2;
enum GL_MAX_TESS_CONTROL_ATOMIC_COUNTERS                           = 0x92D3;
enum GL_MAX_TESS_EVALUATION_ATOMIC_COUNTERS                        = 0x92D4;
enum GL_MAX_GEOMETRY_ATOMIC_COUNTERS                               = 0x92D5;
enum GL_MAX_FRAGMENT_ATOMIC_COUNTERS                               = 0x92D6;
enum GL_MAX_COMBINED_ATOMIC_COUNTERS                               = 0x92D7;
enum GL_MAX_ATOMIC_COUNTER_BUFFER_SIZE                             = 0x92D8;
enum GL_MAX_ATOMIC_COUNTER_BUFFER_BINDINGS                         = 0x92DC;
enum GL_ACTIVE_ATOMIC_COUNTER_BUFFERS                              = 0x92D9;
enum GL_UNIFORM_ATOMIC_COUNTER_BUFFER_INDEX                        = 0x92DA;
enum GL_UNSIGNED_INT_ATOMIC_COUNTER                                = 0x92DB;
enum GL_VERTEX_ATTRIB_ARRAY_BARRIER_BIT                            = 0x00000001;
enum GL_ELEMENT_ARRAY_BARRIER_BIT                                  = 0x00000002;
enum GL_UNIFORM_BARRIER_BIT                                        = 0x00000004;
enum GL_TEXTURE_FETCH_BARRIER_BIT                                  = 0x00000008;
enum GL_SHADER_IMAGE_ACCESS_BARRIER_BIT                            = 0x00000020;
enum GL_COMMAND_BARRIER_BIT                                        = 0x00000040;
enum GL_PIXEL_BUFFER_BARRIER_BIT                                   = 0x00000080;
enum GL_TEXTURE_UPDATE_BARRIER_BIT                                 = 0x00000100;
enum GL_BUFFER_UPDATE_BARRIER_BIT                                  = 0x00000200;
enum GL_FRAMEBUFFER_BARRIER_BIT                                    = 0x00000400;
enum GL_TRANSFORM_FEEDBACK_BARRIER_BIT                             = 0x00000800;
enum GL_ATOMIC_COUNTER_BARRIER_BIT                                 = 0x00001000;
enum GL_ALL_BARRIER_BITS                                           = 0xFFFFFFFF;
enum GL_MAX_IMAGE_UNITS                                            = 0x8F38;
enum GL_MAX_COMBINED_IMAGE_UNITS_AND_FRAGMENT_OUTPUTS              = 0x8F39;
enum GL_IMAGE_BINDING_NAME                                         = 0x8F3A;
enum GL_IMAGE_BINDING_LEVEL                                        = 0x8F3B;
enum GL_IMAGE_BINDING_LAYERED                                      = 0x8F3C;
enum GL_IMAGE_BINDING_LAYER                                        = 0x8F3D;
enum GL_IMAGE_BINDING_ACCESS                                       = 0x8F3E;
enum GL_IMAGE_1D                                                   = 0x904C;
enum GL_IMAGE_2D                                                   = 0x904D;
enum GL_IMAGE_3D                                                   = 0x904E;
enum GL_IMAGE_2D_RECT                                              = 0x904F;
enum GL_IMAGE_CUBE                                                 = 0x9050;
enum GL_IMAGE_BUFFER                                               = 0x9051;
enum GL_IMAGE_1D_ARRAY                                             = 0x9052;
enum GL_IMAGE_2D_ARRAY                                             = 0x9053;
enum GL_IMAGE_CUBE_MAP_ARRAY                                       = 0x9054;
enum GL_IMAGE_2D_MULTISAMPLE                                       = 0x9055;
enum GL_IMAGE_2D_MULTISAMPLE_ARRAY                                 = 0x9056;
enum GL_INT_IMAGE_1D                                               = 0x9057;
enum GL_INT_IMAGE_2D                                               = 0x9058;
enum GL_INT_IMAGE_3D                                               = 0x9059;
enum GL_INT_IMAGE_2D_RECT                                          = 0x905A;
enum GL_INT_IMAGE_CUBE                                             = 0x905B;
enum GL_INT_IMAGE_BUFFER                                           = 0x905C;
enum GL_INT_IMAGE_1D_ARRAY                                         = 0x905D;
enum GL_INT_IMAGE_2D_ARRAY                                         = 0x905E;
enum GL_INT_IMAGE_CUBE_MAP_ARRAY                                   = 0x905F;
enum GL_INT_IMAGE_2D_MULTISAMPLE                                   = 0x9060;
enum GL_INT_IMAGE_2D_MULTISAMPLE_ARRAY                             = 0x9061;
enum GL_UNSIGNED_INT_IMAGE_1D                                      = 0x9062;
enum GL_UNSIGNED_INT_IMAGE_2D                                      = 0x9063;
enum GL_UNSIGNED_INT_IMAGE_3D                                      = 0x9064;
enum GL_UNSIGNED_INT_IMAGE_2D_RECT                                 = 0x9065;
enum GL_UNSIGNED_INT_IMAGE_CUBE                                    = 0x9066;
enum GL_UNSIGNED_INT_IMAGE_BUFFER                                  = 0x9067;
enum GL_UNSIGNED_INT_IMAGE_1D_ARRAY                                = 0x9068;
enum GL_UNSIGNED_INT_IMAGE_2D_ARRAY                                = 0x9069;
enum GL_UNSIGNED_INT_IMAGE_CUBE_MAP_ARRAY                          = 0x906A;
enum GL_UNSIGNED_INT_IMAGE_2D_MULTISAMPLE                          = 0x906B;
enum GL_UNSIGNED_INT_IMAGE_2D_MULTISAMPLE_ARRAY                    = 0x906C;
enum GL_MAX_IMAGE_SAMPLES                                          = 0x906D;
enum GL_IMAGE_BINDING_FORMAT                                       = 0x906E;
enum GL_IMAGE_FORMAT_COMPATIBILITY_TYPE                            = 0x90C7;
enum GL_IMAGE_FORMAT_COMPATIBILITY_BY_SIZE                         = 0x90C8;
enum GL_IMAGE_FORMAT_COMPATIBILITY_BY_CLASS                        = 0x90C9;
enum GL_MAX_VERTEX_IMAGE_UNIFORMS                                  = 0x90CA;
enum GL_MAX_TESS_CONTROL_IMAGE_UNIFORMS                            = 0x90CB;
enum GL_MAX_TESS_EVALUATION_IMAGE_UNIFORMS                         = 0x90CC;
enum GL_MAX_GEOMETRY_IMAGE_UNIFORMS                                = 0x90CD;
enum GL_MAX_FRAGMENT_IMAGE_UNIFORMS                                = 0x90CE;
enum GL_MAX_COMBINED_IMAGE_UNIFORMS                                = 0x90CF;
enum GL_COMPRESSED_RGBA_BPTC_UNORM                                 = 0x8E8C;
enum GL_COMPRESSED_SRGB_ALPHA_BPTC_UNORM                           = 0x8E8D;
enum GL_COMPRESSED_RGB_BPTC_SIGNED_FLOAT                           = 0x8E8E;
enum GL_COMPRESSED_RGB_BPTC_UNSIGNED_FLOAT                         = 0x8E8F;
enum GL_TEXTURE_IMMUTABLE_FORMAT                                   = 0x912F;

// Constants for GL_VERSION_4_3
enum GL_NUM_SHADING_LANGUAGE_VERSIONS                      = 0x82E9;
enum GL_VERTEX_ATTRIB_ARRAY_LONG                           = 0x874E;
enum GL_COMPRESSED_RGB8_ETC2                               = 0x9274;
enum GL_COMPRESSED_SRGB8_ETC2                              = 0x9275;
enum GL_COMPRESSED_RGB8_PUNCHTHROUGH_ALPHA1_ETC2           = 0x9276;
enum GL_COMPRESSED_SRGB8_PUNCHTHROUGH_ALPHA1_ETC2          = 0x9277;
enum GL_COMPRESSED_RGBA8_ETC2_EAC                          = 0x9278;
enum GL_COMPRESSED_SRGB8_ALPHA8_ETC2_EAC                   = 0x9279;
enum GL_COMPRESSED_R11_EAC                                 = 0x9270;
enum GL_COMPRESSED_SIGNED_R11_EAC                          = 0x9271;
enum GL_COMPRESSED_RG11_EAC                                = 0x9272;
enum GL_COMPRESSED_SIGNED_RG11_EAC                         = 0x9273;
enum GL_PRIMITIVE_RESTART_FIXED_INDEX                      = 0x8D69;
enum GL_ANY_SAMPLES_PASSED_CONSERVATIVE                    = 0x8D6A;
enum GL_MAX_ELEMENT_INDEX                                  = 0x8D6B;
enum GL_COMPUTE_SHADER                                     = 0x91B9;
enum GL_MAX_COMPUTE_UNIFORM_BLOCKS                         = 0x91BB;
enum GL_MAX_COMPUTE_TEXTURE_IMAGE_UNITS                    = 0x91BC;
enum GL_MAX_COMPUTE_IMAGE_UNIFORMS                         = 0x91BD;
enum GL_MAX_COMPUTE_SHARED_MEMORY_SIZE                     = 0x8262;
enum GL_MAX_COMPUTE_UNIFORM_COMPONENTS                     = 0x8263;
enum GL_MAX_COMPUTE_ATOMIC_COUNTER_BUFFERS                 = 0x8264;
enum GL_MAX_COMPUTE_ATOMIC_COUNTERS                        = 0x8265;
enum GL_MAX_COMBINED_COMPUTE_UNIFORM_COMPONENTS            = 0x8266;
enum GL_MAX_COMPUTE_WORK_GROUP_INVOCATIONS                 = 0x90EB;
enum GL_MAX_COMPUTE_WORK_GROUP_COUNT                       = 0x91BE;
enum GL_MAX_COMPUTE_WORK_GROUP_SIZE                        = 0x91BF;
enum GL_COMPUTE_WORK_GROUP_SIZE                            = 0x8267;
enum GL_UNIFORM_BLOCK_REFERENCED_BY_COMPUTE_SHADER         = 0x90EC;
enum GL_ATOMIC_COUNTER_BUFFER_REFERENCED_BY_COMPUTE_SHADER = 0x90ED;
enum GL_DISPATCH_INDIRECT_BUFFER                           = 0x90EE;
enum GL_DISPATCH_INDIRECT_BUFFER_BINDING                   = 0x90EF;
enum GL_COMPUTE_SHADER_BIT                                 = 0x00000020;
enum GL_DEBUG_OUTPUT_SYNCHRONOUS                           = 0x8242;
enum GL_DEBUG_NEXT_LOGGED_MESSAGE_LENGTH                   = 0x8243;
enum GL_DEBUG_CALLBACK_FUNCTION                            = 0x8244;
enum GL_DEBUG_CALLBACK_USER_PARAM                          = 0x8245;
enum GL_DEBUG_SOURCE_API                                   = 0x8246;
enum GL_DEBUG_SOURCE_WINDOW_SYSTEM                         = 0x8247;
enum GL_DEBUG_SOURCE_SHADER_COMPILER                       = 0x8248;
enum GL_DEBUG_SOURCE_THIRD_PARTY                           = 0x8249;
enum GL_DEBUG_SOURCE_APPLICATION                           = 0x824A;
enum GL_DEBUG_SOURCE_OTHER                                 = 0x824B;
enum GL_DEBUG_TYPE_ERROR                                   = 0x824C;
enum GL_DEBUG_TYPE_DEPRECATED_BEHAVIOR                     = 0x824D;
enum GL_DEBUG_TYPE_UNDEFINED_BEHAVIOR                      = 0x824E;
enum GL_DEBUG_TYPE_PORTABILITY                             = 0x824F;
enum GL_DEBUG_TYPE_PERFORMANCE                             = 0x8250;
enum GL_DEBUG_TYPE_OTHER                                   = 0x8251;
enum GL_MAX_DEBUG_MESSAGE_LENGTH                           = 0x9143;
enum GL_MAX_DEBUG_LOGGED_MESSAGES                          = 0x9144;
enum GL_DEBUG_LOGGED_MESSAGES                              = 0x9145;
enum GL_DEBUG_SEVERITY_HIGH                                = 0x9146;
enum GL_DEBUG_SEVERITY_MEDIUM                              = 0x9147;
enum GL_DEBUG_SEVERITY_LOW                                 = 0x9148;
enum GL_DEBUG_TYPE_MARKER                                  = 0x8268;
enum GL_DEBUG_TYPE_PUSH_GROUP                              = 0x8269;
enum GL_DEBUG_TYPE_POP_GROUP                               = 0x826A;
enum GL_DEBUG_SEVERITY_NOTIFICATION                        = 0x826B;
enum GL_MAX_DEBUG_GROUP_STACK_DEPTH                        = 0x826C;
enum GL_DEBUG_GROUP_STACK_DEPTH                            = 0x826D;
enum GL_BUFFER                                             = 0x82E0;
enum GL_SHADER                                             = 0x82E1;
enum GL_PROGRAM                                            = 0x82E2;
enum GL_QUERY                                              = 0x82E3;
enum GL_PROGRAM_PIPELINE                                   = 0x82E4;
enum GL_SAMPLER                                            = 0x82E6;
enum GL_MAX_LABEL_LENGTH                                   = 0x82E8;
enum GL_DEBUG_OUTPUT                                       = 0x92E0;
enum GL_CONTEXT_FLAG_DEBUG_BIT                             = 0x00000002;
enum GL_MAX_UNIFORM_LOCATIONS                              = 0x826E;
enum GL_FRAMEBUFFER_DEFAULT_WIDTH                          = 0x9310;
enum GL_FRAMEBUFFER_DEFAULT_HEIGHT                         = 0x9311;
enum GL_FRAMEBUFFER_DEFAULT_LAYERS                         = 0x9312;
enum GL_FRAMEBUFFER_DEFAULT_SAMPLES                        = 0x9313;
enum GL_FRAMEBUFFER_DEFAULT_FIXED_SAMPLE_LOCATIONS         = 0x9314;
enum GL_MAX_FRAMEBUFFER_WIDTH                              = 0x9315;
enum GL_MAX_FRAMEBUFFER_HEIGHT                             = 0x9316;
enum GL_MAX_FRAMEBUFFER_LAYERS                             = 0x9317;
enum GL_MAX_FRAMEBUFFER_SAMPLES                            = 0x9318;
enum GL_INTERNALFORMAT_SUPPORTED                           = 0x826F;
enum GL_INTERNALFORMAT_PREFERRED                           = 0x8270;
enum GL_INTERNALFORMAT_RED_SIZE                            = 0x8271;
enum GL_INTERNALFORMAT_GREEN_SIZE                          = 0x8272;
enum GL_INTERNALFORMAT_BLUE_SIZE                           = 0x8273;
enum GL_INTERNALFORMAT_ALPHA_SIZE                          = 0x8274;
enum GL_INTERNALFORMAT_DEPTH_SIZE                          = 0x8275;
enum GL_INTERNALFORMAT_STENCIL_SIZE                        = 0x8276;
enum GL_INTERNALFORMAT_SHARED_SIZE                         = 0x8277;
enum GL_INTERNALFORMAT_RED_TYPE                            = 0x8278;
enum GL_INTERNALFORMAT_GREEN_TYPE                          = 0x8279;
enum GL_INTERNALFORMAT_BLUE_TYPE                           = 0x827A;
enum GL_INTERNALFORMAT_ALPHA_TYPE                          = 0x827B;
enum GL_INTERNALFORMAT_DEPTH_TYPE                          = 0x827C;
enum GL_INTERNALFORMAT_STENCIL_TYPE                        = 0x827D;
enum GL_MAX_WIDTH                                          = 0x827E;
enum GL_MAX_HEIGHT                                         = 0x827F;
enum GL_MAX_DEPTH                                          = 0x8280;
enum GL_MAX_LAYERS                                         = 0x8281;
enum GL_MAX_COMBINED_DIMENSIONS                            = 0x8282;
enum GL_COLOR_COMPONENTS                                   = 0x8283;
enum GL_DEPTH_COMPONENTS                                   = 0x8284;
enum GL_STENCIL_COMPONENTS                                 = 0x8285;
enum GL_COLOR_RENDERABLE                                   = 0x8286;
enum GL_DEPTH_RENDERABLE                                   = 0x8287;
enum GL_STENCIL_RENDERABLE                                 = 0x8288;
enum GL_FRAMEBUFFER_RENDERABLE                             = 0x8289;
enum GL_FRAMEBUFFER_RENDERABLE_LAYERED                     = 0x828A;
enum GL_FRAMEBUFFER_BLEND                                  = 0x828B;
enum GL_READ_PIXELS                                        = 0x828C;
enum GL_READ_PIXELS_FORMAT                                 = 0x828D;
enum GL_READ_PIXELS_TYPE                                   = 0x828E;
enum GL_TEXTURE_IMAGE_FORMAT                               = 0x828F;
enum GL_TEXTURE_IMAGE_TYPE                                 = 0x8290;
enum GL_GET_TEXTURE_IMAGE_FORMAT                           = 0x8291;
enum GL_GET_TEXTURE_IMAGE_TYPE                             = 0x8292;
enum GL_MIPMAP                                             = 0x8293;
enum GL_MANUAL_GENERATE_MIPMAP                             = 0x8294;
enum GL_AUTO_GENERATE_MIPMAP                               = 0x8295;
enum GL_COLOR_ENCODING                                     = 0x8296;
enum GL_SRGB_READ                                          = 0x8297;
enum GL_SRGB_WRITE                                         = 0x8298;
enum GL_FILTER                                             = 0x829A;
enum GL_VERTEX_TEXTURE                                     = 0x829B;
enum GL_TESS_CONTROL_TEXTURE                               = 0x829C;
enum GL_TESS_EVALUATION_TEXTURE                            = 0x829D;
enum GL_GEOMETRY_TEXTURE                                   = 0x829E;
enum GL_FRAGMENT_TEXTURE                                   = 0x829F;
enum GL_COMPUTE_TEXTURE                                    = 0x82A0;
enum GL_TEXTURE_SHADOW                                     = 0x82A1;
enum GL_TEXTURE_GATHER                                     = 0x82A2;
enum GL_TEXTURE_GATHER_SHADOW                              = 0x82A3;
enum GL_SHADER_IMAGE_LOAD                                  = 0x82A4;
enum GL_SHADER_IMAGE_STORE                                 = 0x82A5;
enum GL_SHADER_IMAGE_ATOMIC                                = 0x82A6;
enum GL_IMAGE_TEXEL_SIZE                                   = 0x82A7;
enum GL_IMAGE_COMPATIBILITY_CLASS                          = 0x82A8;
enum GL_IMAGE_PIXEL_FORMAT                                 = 0x82A9;
enum GL_IMAGE_PIXEL_TYPE                                   = 0x82AA;
enum GL_SIMULTANEOUS_TEXTURE_AND_DEPTH_TEST                = 0x82AC;
enum GL_SIMULTANEOUS_TEXTURE_AND_STENCIL_TEST              = 0x82AD;
enum GL_SIMULTANEOUS_TEXTURE_AND_DEPTH_WRITE               = 0x82AE;
enum GL_SIMULTANEOUS_TEXTURE_AND_STENCIL_WRITE             = 0x82AF;
enum GL_TEXTURE_COMPRESSED_BLOCK_WIDTH                     = 0x82B1;
enum GL_TEXTURE_COMPRESSED_BLOCK_HEIGHT                    = 0x82B2;
enum GL_TEXTURE_COMPRESSED_BLOCK_SIZE                      = 0x82B3;
enum GL_CLEAR_BUFFER                                       = 0x82B4;
enum GL_TEXTURE_VIEW                                       = 0x82B5;
enum GL_VIEW_COMPATIBILITY_CLASS                           = 0x82B6;
enum GL_FULL_SUPPORT                                       = 0x82B7;
enum GL_CAVEAT_SUPPORT                                     = 0x82B8;
enum GL_IMAGE_CLASS_4_X_32                                 = 0x82B9;
enum GL_IMAGE_CLASS_2_X_32                                 = 0x82BA;
enum GL_IMAGE_CLASS_1_X_32                                 = 0x82BB;
enum GL_IMAGE_CLASS_4_X_16                                 = 0x82BC;
enum GL_IMAGE_CLASS_2_X_16                                 = 0x82BD;
enum GL_IMAGE_CLASS_1_X_16                                 = 0x82BE;
enum GL_IMAGE_CLASS_4_X_8                                  = 0x82BF;
enum GL_IMAGE_CLASS_2_X_8                                  = 0x82C0;
enum GL_IMAGE_CLASS_1_X_8                                  = 0x82C1;
enum GL_IMAGE_CLASS_11_11_10                               = 0x82C2;
enum GL_IMAGE_CLASS_10_10_10_2                             = 0x82C3;
enum GL_VIEW_CLASS_128_BITS                                = 0x82C4;
enum GL_VIEW_CLASS_96_BITS                                 = 0x82C5;
enum GL_VIEW_CLASS_64_BITS                                 = 0x82C6;
enum GL_VIEW_CLASS_48_BITS                                 = 0x82C7;
enum GL_VIEW_CLASS_32_BITS                                 = 0x82C8;
enum GL_VIEW_CLASS_24_BITS                                 = 0x82C9;
enum GL_VIEW_CLASS_16_BITS                                 = 0x82CA;
enum GL_VIEW_CLASS_8_BITS                                  = 0x82CB;
enum GL_VIEW_CLASS_S3TC_DXT1_RGB                           = 0x82CC;
enum GL_VIEW_CLASS_S3TC_DXT1_RGBA                          = 0x82CD;
enum GL_VIEW_CLASS_S3TC_DXT3_RGBA                          = 0x82CE;
enum GL_VIEW_CLASS_S3TC_DXT5_RGBA                          = 0x82CF;
enum GL_VIEW_CLASS_RGTC1_RED                               = 0x82D0;
enum GL_VIEW_CLASS_RGTC2_RG                                = 0x82D1;
enum GL_VIEW_CLASS_BPTC_UNORM                              = 0x82D2;
enum GL_VIEW_CLASS_BPTC_FLOAT                              = 0x82D3;
enum GL_UNIFORM                                            = 0x92E1;
enum GL_UNIFORM_BLOCK                                      = 0x92E2;
enum GL_PROGRAM_INPUT                                      = 0x92E3;
enum GL_PROGRAM_OUTPUT                                     = 0x92E4;
enum GL_BUFFER_VARIABLE                                    = 0x92E5;
enum GL_SHADER_STORAGE_BLOCK                               = 0x92E6;
enum GL_VERTEX_SUBROUTINE                                  = 0x92E8;
enum GL_TESS_CONTROL_SUBROUTINE                            = 0x92E9;
enum GL_TESS_EVALUATION_SUBROUTINE                         = 0x92EA;
enum GL_GEOMETRY_SUBROUTINE                                = 0x92EB;
enum GL_FRAGMENT_SUBROUTINE                                = 0x92EC;
enum GL_COMPUTE_SUBROUTINE                                 = 0x92ED;
enum GL_VERTEX_SUBROUTINE_UNIFORM                          = 0x92EE;
enum GL_TESS_CONTROL_SUBROUTINE_UNIFORM                    = 0x92EF;
enum GL_TESS_EVALUATION_SUBROUTINE_UNIFORM                 = 0x92F0;
enum GL_GEOMETRY_SUBROUTINE_UNIFORM                        = 0x92F1;
enum GL_FRAGMENT_SUBROUTINE_UNIFORM                        = 0x92F2;
enum GL_COMPUTE_SUBROUTINE_UNIFORM                         = 0x92F3;
enum GL_TRANSFORM_FEEDBACK_VARYING                         = 0x92F4;
enum GL_ACTIVE_RESOURCES                                   = 0x92F5;
enum GL_MAX_NAME_LENGTH                                    = 0x92F6;
enum GL_MAX_NUM_ACTIVE_VARIABLES                           = 0x92F7;
enum GL_MAX_NUM_COMPATIBLE_SUBROUTINES                     = 0x92F8;
enum GL_NAME_LENGTH                                        = 0x92F9;
enum GL_TYPE                                               = 0x92FA;
enum GL_ARRAY_SIZE                                         = 0x92FB;
enum GL_OFFSET                                             = 0x92FC;
enum GL_BLOCK_INDEX                                        = 0x92FD;
enum GL_ARRAY_STRIDE                                       = 0x92FE;
enum GL_MATRIX_STRIDE                                      = 0x92FF;
enum GL_IS_ROW_MAJOR                                       = 0x9300;
enum GL_ATOMIC_COUNTER_BUFFER_INDEX                        = 0x9301;
enum GL_BUFFER_BINDING                                     = 0x9302;
enum GL_BUFFER_DATA_SIZE                                   = 0x9303;
enum GL_NUM_ACTIVE_VARIABLES                               = 0x9304;
enum GL_ACTIVE_VARIABLES                                   = 0x9305;
enum GL_REFERENCED_BY_VERTEX_SHADER                        = 0x9306;
enum GL_REFERENCED_BY_TESS_CONTROL_SHADER                  = 0x9307;
enum GL_REFERENCED_BY_TESS_EVALUATION_SHADER               = 0x9308;
enum GL_REFERENCED_BY_GEOMETRY_SHADER                      = 0x9309;
enum GL_REFERENCED_BY_FRAGMENT_SHADER                      = 0x930A;
enum GL_REFERENCED_BY_COMPUTE_SHADER                       = 0x930B;
enum GL_TOP_LEVEL_ARRAY_SIZE                               = 0x930C;
enum GL_TOP_LEVEL_ARRAY_STRIDE                             = 0x930D;
enum GL_LOCATION                                           = 0x930E;
enum GL_LOCATION_INDEX                                     = 0x930F;
enum GL_IS_PER_PATCH                                       = 0x92E7;
enum GL_SHADER_STORAGE_BUFFER                              = 0x90D2;
enum GL_SHADER_STORAGE_BUFFER_BINDING                      = 0x90D3;
enum GL_SHADER_STORAGE_BUFFER_START                        = 0x90D4;
enum GL_SHADER_STORAGE_BUFFER_SIZE                         = 0x90D5;
enum GL_MAX_VERTEX_SHADER_STORAGE_BLOCKS                   = 0x90D6;
enum GL_MAX_GEOMETRY_SHADER_STORAGE_BLOCKS                 = 0x90D7;
enum GL_MAX_TESS_CONTROL_SHADER_STORAGE_BLOCKS             = 0x90D8;
enum GL_MAX_TESS_EVALUATION_SHADER_STORAGE_BLOCKS          = 0x90D9;
enum GL_MAX_FRAGMENT_SHADER_STORAGE_BLOCKS                 = 0x90DA;
enum GL_MAX_COMPUTE_SHADER_STORAGE_BLOCKS                  = 0x90DB;
enum GL_MAX_COMBINED_SHADER_STORAGE_BLOCKS                 = 0x90DC;
enum GL_MAX_SHADER_STORAGE_BUFFER_BINDINGS                 = 0x90DD;
enum GL_MAX_SHADER_STORAGE_BLOCK_SIZE                      = 0x90DE;
enum GL_SHADER_STORAGE_BUFFER_OFFSET_ALIGNMENT             = 0x90DF;
enum GL_SHADER_STORAGE_BARRIER_BIT                         = 0x00002000;
enum GL_MAX_COMBINED_SHADER_OUTPUT_RESOURCES               = 0x8F39;
enum GL_DEPTH_STENCIL_TEXTURE_MODE                         = 0x90EA;
enum GL_TEXTURE_BUFFER_OFFSET                              = 0x919D;
enum GL_TEXTURE_BUFFER_SIZE                                = 0x919E;
enum GL_TEXTURE_BUFFER_OFFSET_ALIGNMENT                    = 0x919F;
enum GL_TEXTURE_VIEW_MIN_LEVEL                             = 0x82DB;
enum GL_TEXTURE_VIEW_NUM_LEVELS                            = 0x82DC;
enum GL_TEXTURE_VIEW_MIN_LAYER                             = 0x82DD;
enum GL_TEXTURE_VIEW_NUM_LAYERS                            = 0x82DE;
enum GL_TEXTURE_IMMUTABLE_LEVELS                           = 0x82DF;
enum GL_VERTEX_ATTRIB_BINDING                              = 0x82D4;
enum GL_VERTEX_ATTRIB_RELATIVE_OFFSET                      = 0x82D5;
enum GL_VERTEX_BINDING_DIVISOR                             = 0x82D6;
enum GL_VERTEX_BINDING_OFFSET                              = 0x82D7;
enum GL_VERTEX_BINDING_STRIDE                              = 0x82D8;
enum GL_MAX_VERTEX_ATTRIB_RELATIVE_OFFSET                  = 0x82D9;
enum GL_MAX_VERTEX_ATTRIB_BINDINGS                         = 0x82DA;
enum GL_VERTEX_BINDING_BUFFER                              = 0x8F4F;

// Constants for GL_VERSION_4_4
enum GL_MAX_VERTEX_ATTRIB_STRIDE                = 0x82E5;
enum GL_PRIMITIVE_RESTART_FOR_PATCHES_SUPPORTED = 0x8221;
enum GL_TEXTURE_BUFFER_BINDING                  = 0x8C2A;
enum GL_MAP_PERSISTENT_BIT                      = 0x0040;
enum GL_MAP_COHERENT_BIT                        = 0x0080;
enum GL_DYNAMIC_STORAGE_BIT                     = 0x0100;
enum GL_CLIENT_STORAGE_BIT                      = 0x0200;
enum GL_CLIENT_MAPPED_BUFFER_BARRIER_BIT        = 0x00004000;
enum GL_BUFFER_IMMUTABLE_STORAGE                = 0x821F;
enum GL_BUFFER_STORAGE_FLAGS                    = 0x8220;
enum GL_CLEAR_TEXTURE                           = 0x9365;
enum GL_LOCATION_COMPONENT                      = 0x934A;
enum GL_TRANSFORM_FEEDBACK_BUFFER_INDEX         = 0x934B;
enum GL_TRANSFORM_FEEDBACK_BUFFER_STRIDE        = 0x934C;
enum GL_QUERY_BUFFER                            = 0x9192;
enum GL_QUERY_BUFFER_BARRIER_BIT                = 0x00008000;
enum GL_QUERY_BUFFER_BINDING                    = 0x9193;
enum GL_QUERY_RESULT_NO_WAIT                    = 0x9194;
enum GL_MIRROR_CLAMP_TO_EDGE                    = 0x8743;

// Constants for GL_VERSION_4_5
enum GL_CONTEXT_LOST                         = 0x0507;
enum GL_NEGATIVE_ONE_TO_ONE                  = 0x935E;
enum GL_ZERO_TO_ONE                          = 0x935F;
enum GL_CLIP_ORIGIN                          = 0x935C;
enum GL_CLIP_DEPTH_MODE                      = 0x935D;
enum GL_QUERY_WAIT_INVERTED                  = 0x8E17;
enum GL_QUERY_NO_WAIT_INVERTED               = 0x8E18;
enum GL_QUERY_BY_REGION_WAIT_INVERTED        = 0x8E19;
enum GL_QUERY_BY_REGION_NO_WAIT_INVERTED     = 0x8E1A;
enum GL_MAX_CULL_DISTANCES                   = 0x82F9;
enum GL_MAX_COMBINED_CLIP_AND_CULL_DISTANCES = 0x82FA;
enum GL_TEXTURE_TARGET                       = 0x1006;
enum GL_QUERY_TARGET                         = 0x82EA;
enum GL_GUILTY_CONTEXT_RESET                 = 0x8253;
enum GL_INNOCENT_CONTEXT_RESET               = 0x8254;
enum GL_UNKNOWN_CONTEXT_RESET                = 0x8255;
enum GL_RESET_NOTIFICATION_STRATEGY          = 0x8256;
enum GL_LOSE_CONTEXT_ON_RESET                = 0x8252;
enum GL_NO_RESET_NOTIFICATION                = 0x8261;
enum GL_CONTEXT_FLAG_ROBUST_ACCESS_BIT       = 0x00000004;
enum GL_CONTEXT_RELEASE_BEHAVIOR             = 0x82FB;
enum GL_CONTEXT_RELEASE_BEHAVIOR_FLUSH       = 0x82FC;

// Constants for GL_VERSION_4_6
enum GL_SHADER_BINARY_FORMAT_SPIR_V        = 0x9551;
enum GL_SPIR_V_BINARY                      = 0x9552;
enum GL_PARAMETER_BUFFER                   = 0x80EE;
enum GL_PARAMETER_BUFFER_BINDING           = 0x80EF;
enum GL_CONTEXT_FLAG_NO_ERROR_BIT          = 0x00000008;
enum GL_VERTICES_SUBMITTED                 = 0x82EE;
enum GL_PRIMITIVES_SUBMITTED               = 0x82EF;
enum GL_VERTEX_SHADER_INVOCATIONS          = 0x82F0;
enum GL_TESS_CONTROL_SHADER_PATCHES        = 0x82F1;
enum GL_TESS_EVALUATION_SHADER_INVOCATIONS = 0x82F2;
enum GL_GEOMETRY_SHADER_PRIMITIVES_EMITTED = 0x82F3;
enum GL_FRAGMENT_SHADER_INVOCATIONS        = 0x82F4;
enum GL_COMPUTE_SHADER_INVOCATIONS         = 0x82F5;
enum GL_CLIPPING_INPUT_PRIMITIVES          = 0x82F6;
enum GL_CLIPPING_OUTPUT_PRIMITIVES         = 0x82F7;
enum GL_POLYGON_OFFSET_CLAMP               = 0x8E1B;
enum GL_SPIR_V_EXTENSIONS                  = 0x9553;
enum GL_NUM_SPIR_V_EXTENSIONS              = 0x9554;
enum GL_TEXTURE_MAX_ANISOTROPY             = 0x84FE;
enum GL_MAX_TEXTURE_MAX_ANISOTROPY         = 0x84FF;
enum GL_TRANSFORM_FEEDBACK_OVERFLOW        = 0x82EC;
enum GL_TRANSFORM_FEEDBACK_STREAM_OVERFLOW = 0x82ED;

// Constants for GL_ARB_ES3_2_compatibility
enum GL_PRIMITIVE_BOUNDING_BOX_ARB             = 0x92BE;
enum GL_MULTISAMPLE_LINE_WIDTH_RANGE_ARB       = 0x9381;
enum GL_MULTISAMPLE_LINE_WIDTH_GRANULARITY_ARB = 0x9382;

// Constants for GL_ARB_bindless_texture
enum GL_UNSIGNED_INT64_ARB = 0x140F;

// Constants for GL_ARB_cl_event
enum GL_SYNC_CL_EVENT_ARB          = 0x8240;
enum GL_SYNC_CL_EVENT_COMPLETE_ARB = 0x8241;

// Constants for GL_ARB_compute_variable_group_size
enum GL_MAX_COMPUTE_VARIABLE_GROUP_INVOCATIONS_ARB = 0x9344;
enum GL_MAX_COMPUTE_FIXED_GROUP_INVOCATIONS_ARB    = 0x90EB;
enum GL_MAX_COMPUTE_VARIABLE_GROUP_SIZE_ARB        = 0x9345;
enum GL_MAX_COMPUTE_FIXED_GROUP_SIZE_ARB           = 0x91BF;

// Constants for GL_ARB_debug_output
enum GL_DEBUG_OUTPUT_SYNCHRONOUS_ARB         = 0x8242;
enum GL_DEBUG_NEXT_LOGGED_MESSAGE_LENGTH_ARB = 0x8243;
enum GL_DEBUG_CALLBACK_FUNCTION_ARB          = 0x8244;
enum GL_DEBUG_CALLBACK_USER_PARAM_ARB        = 0x8245;
enum GL_DEBUG_SOURCE_API_ARB                 = 0x8246;
enum GL_DEBUG_SOURCE_WINDOW_SYSTEM_ARB       = 0x8247;
enum GL_DEBUG_SOURCE_SHADER_COMPILER_ARB     = 0x8248;
enum GL_DEBUG_SOURCE_THIRD_PARTY_ARB         = 0x8249;
enum GL_DEBUG_SOURCE_APPLICATION_ARB         = 0x824A;
enum GL_DEBUG_SOURCE_OTHER_ARB               = 0x824B;
enum GL_DEBUG_TYPE_ERROR_ARB                 = 0x824C;
enum GL_DEBUG_TYPE_DEPRECATED_BEHAVIOR_ARB   = 0x824D;
enum GL_DEBUG_TYPE_UNDEFINED_BEHAVIOR_ARB    = 0x824E;
enum GL_DEBUG_TYPE_PORTABILITY_ARB           = 0x824F;
enum GL_DEBUG_TYPE_PERFORMANCE_ARB           = 0x8250;
enum GL_DEBUG_TYPE_OTHER_ARB                 = 0x8251;
enum GL_MAX_DEBUG_MESSAGE_LENGTH_ARB         = 0x9143;
enum GL_MAX_DEBUG_LOGGED_MESSAGES_ARB        = 0x9144;
enum GL_DEBUG_LOGGED_MESSAGES_ARB            = 0x9145;
enum GL_DEBUG_SEVERITY_HIGH_ARB              = 0x9146;
enum GL_DEBUG_SEVERITY_MEDIUM_ARB            = 0x9147;
enum GL_DEBUG_SEVERITY_LOW_ARB               = 0x9148;

// Constants for GL_ARB_geometry_shader4
enum GL_LINES_ADJACENCY_ARB                      = 0x000A;
enum GL_LINE_STRIP_ADJACENCY_ARB                 = 0x000B;
enum GL_TRIANGLES_ADJACENCY_ARB                  = 0x000C;
enum GL_TRIANGLE_STRIP_ADJACENCY_ARB             = 0x000D;
enum GL_PROGRAM_POINT_SIZE_ARB                   = 0x8642;
enum GL_MAX_GEOMETRY_TEXTURE_IMAGE_UNITS_ARB     = 0x8C29;
enum GL_FRAMEBUFFER_ATTACHMENT_LAYERED_ARB       = 0x8DA7;
enum GL_FRAMEBUFFER_INCOMPLETE_LAYER_TARGETS_ARB = 0x8DA8;
enum GL_FRAMEBUFFER_INCOMPLETE_LAYER_COUNT_ARB   = 0x8DA9;
enum GL_GEOMETRY_SHADER_ARB                      = 0x8DD9;
enum GL_GEOMETRY_VERTICES_OUT_ARB                = 0x8DDA;
enum GL_GEOMETRY_INPUT_TYPE_ARB                  = 0x8DDB;
enum GL_GEOMETRY_OUTPUT_TYPE_ARB                 = 0x8DDC;
enum GL_MAX_GEOMETRY_VARYING_COMPONENTS_ARB      = 0x8DDD;
enum GL_MAX_VERTEX_VARYING_COMPONENTS_ARB        = 0x8DDE;
enum GL_MAX_GEOMETRY_UNIFORM_COMPONENTS_ARB      = 0x8DDF;
enum GL_MAX_GEOMETRY_OUTPUT_VERTICES_ARB         = 0x8DE0;
enum GL_MAX_GEOMETRY_TOTAL_OUTPUT_COMPONENTS_ARB = 0x8DE1;

// Constants for GL_ARB_gl_spirv
enum GL_SHADER_BINARY_FORMAT_SPIR_V_ARB = 0x9551;
enum GL_SPIR_V_BINARY_ARB               = 0x9552;

// Constants for GL_ARB_gpu_shader_int64
enum GL_INT64_ARB               = 0x140E;
enum GL_INT64_VEC2_ARB          = 0x8FE9;
enum GL_INT64_VEC3_ARB          = 0x8FEA;
enum GL_INT64_VEC4_ARB          = 0x8FEB;
enum GL_UNSIGNED_INT64_VEC2_ARB = 0x8FF5;
enum GL_UNSIGNED_INT64_VEC3_ARB = 0x8FF6;
enum GL_UNSIGNED_INT64_VEC4_ARB = 0x8FF7;

// Constants for GL_ARB_indirect_parameters
enum GL_PARAMETER_BUFFER_ARB         = 0x80EE;
enum GL_PARAMETER_BUFFER_BINDING_ARB = 0x80EF;

// Constants for GL_ARB_instanced_arrays
enum GL_VERTEX_ATTRIB_ARRAY_DIVISOR_ARB = 0x88FE;

// Constants for GL_ARB_internalformat_query2
enum GL_SRGB_DECODE_ARB = 0x8299;

// Constants for GL_ARB_parallel_shader_compile
enum GL_MAX_SHADER_COMPILER_THREADS_ARB = 0x91B0;
enum GL_COMPLETION_STATUS_ARB           = 0x91B1;

// Constants for GL_ARB_pipeline_statistics_query
enum GL_VERTICES_SUBMITTED_ARB                 = 0x82EE;
enum GL_PRIMITIVES_SUBMITTED_ARB               = 0x82EF;
enum GL_VERTEX_SHADER_INVOCATIONS_ARB          = 0x82F0;
enum GL_TESS_CONTROL_SHADER_PATCHES_ARB        = 0x82F1;
enum GL_TESS_EVALUATION_SHADER_INVOCATIONS_ARB = 0x82F2;
enum GL_GEOMETRY_SHADER_PRIMITIVES_EMITTED_ARB = 0x82F3;
enum GL_FRAGMENT_SHADER_INVOCATIONS_ARB        = 0x82F4;
enum GL_COMPUTE_SHADER_INVOCATIONS_ARB         = 0x82F5;
enum GL_CLIPPING_INPUT_PRIMITIVES_ARB          = 0x82F6;
enum GL_CLIPPING_OUTPUT_PRIMITIVES_ARB         = 0x82F7;

// Constants for GL_ARB_pixel_buffer_object
enum GL_PIXEL_PACK_BUFFER_ARB           = 0x88EB;
enum GL_PIXEL_UNPACK_BUFFER_ARB         = 0x88EC;
enum GL_PIXEL_PACK_BUFFER_BINDING_ARB   = 0x88ED;
enum GL_PIXEL_UNPACK_BUFFER_BINDING_ARB = 0x88EF;

// Constants for GL_ARB_robustness
enum GL_CONTEXT_FLAG_ROBUST_ACCESS_BIT_ARB = 0x00000004;
enum GL_LOSE_CONTEXT_ON_RESET_ARB          = 0x8252;
enum GL_GUILTY_CONTEXT_RESET_ARB           = 0x8253;
enum GL_INNOCENT_CONTEXT_RESET_ARB         = 0x8254;
enum GL_UNKNOWN_CONTEXT_RESET_ARB          = 0x8255;
enum GL_RESET_NOTIFICATION_STRATEGY_ARB    = 0x8256;
enum GL_NO_RESET_NOTIFICATION_ARB          = 0x8261;

// Constants for GL_ARB_sample_locations
enum GL_SAMPLE_LOCATION_SUBPIXEL_BITS_ARB             = 0x933D;
enum GL_SAMPLE_LOCATION_PIXEL_GRID_WIDTH_ARB          = 0x933E;
enum GL_SAMPLE_LOCATION_PIXEL_GRID_HEIGHT_ARB         = 0x933F;
enum GL_PROGRAMMABLE_SAMPLE_LOCATION_TABLE_SIZE_ARB   = 0x9340;
enum GL_SAMPLE_LOCATION_ARB                           = 0x8E50;
enum GL_PROGRAMMABLE_SAMPLE_LOCATION_ARB              = 0x9341;
enum GL_FRAMEBUFFER_PROGRAMMABLE_SAMPLE_LOCATIONS_ARB = 0x9342;
enum GL_FRAMEBUFFER_SAMPLE_LOCATION_PIXEL_GRID_ARB    = 0x9343;

// Constants for GL_ARB_sample_shading
enum GL_SAMPLE_SHADING_ARB           = 0x8C36;
enum GL_MIN_SAMPLE_SHADING_VALUE_ARB = 0x8C37;

// Constants for GL_ARB_shading_language_include
enum GL_SHADER_INCLUDE_ARB      = 0x8DAE;
enum GL_NAMED_STRING_LENGTH_ARB = 0x8DE9;
enum GL_NAMED_STRING_TYPE_ARB   = 0x8DEA;

// Constants for GL_ARB_sparse_buffer
enum GL_SPARSE_STORAGE_BIT_ARB      = 0x0400;
enum GL_SPARSE_BUFFER_PAGE_SIZE_ARB = 0x82F8;

// Constants for GL_ARB_sparse_texture
enum GL_TEXTURE_SPARSE_ARB                         = 0x91A6;
enum GL_VIRTUAL_PAGE_SIZE_INDEX_ARB                = 0x91A7;
enum GL_NUM_SPARSE_LEVELS_ARB                      = 0x91AA;
enum GL_NUM_VIRTUAL_PAGE_SIZES_ARB                 = 0x91A8;
enum GL_VIRTUAL_PAGE_SIZE_X_ARB                    = 0x9195;
enum GL_VIRTUAL_PAGE_SIZE_Y_ARB                    = 0x9196;
enum GL_VIRTUAL_PAGE_SIZE_Z_ARB                    = 0x9197;
enum GL_MAX_SPARSE_TEXTURE_SIZE_ARB                = 0x9198;
enum GL_MAX_SPARSE_3D_TEXTURE_SIZE_ARB             = 0x9199;
enum GL_MAX_SPARSE_ARRAY_TEXTURE_LAYERS_ARB        = 0x919A;
enum GL_SPARSE_TEXTURE_FULL_ARRAY_CUBE_MIPMAPS_ARB = 0x91A9;

// Constants for GL_ARB_texture_border_clamp
enum GL_CLAMP_TO_BORDER_ARB = 0x812D;

// Constants for GL_ARB_texture_buffer_object
enum GL_TEXTURE_BUFFER_ARB                    = 0x8C2A;
enum GL_MAX_TEXTURE_BUFFER_SIZE_ARB           = 0x8C2B;
enum GL_TEXTURE_BINDING_BUFFER_ARB            = 0x8C2C;
enum GL_TEXTURE_BUFFER_DATA_STORE_BINDING_ARB = 0x8C2D;
enum GL_TEXTURE_BUFFER_FORMAT_ARB             = 0x8C2E;

// Constants for GL_ARB_texture_compression_bptc
enum GL_COMPRESSED_RGBA_BPTC_UNORM_ARB         = 0x8E8C;
enum GL_COMPRESSED_SRGB_ALPHA_BPTC_UNORM_ARB   = 0x8E8D;
enum GL_COMPRESSED_RGB_BPTC_SIGNED_FLOAT_ARB   = 0x8E8E;
enum GL_COMPRESSED_RGB_BPTC_UNSIGNED_FLOAT_ARB = 0x8E8F;

// Constants for GL_ARB_texture_cube_map_array
enum GL_TEXTURE_CUBE_MAP_ARRAY_ARB              = 0x9009;
enum GL_TEXTURE_BINDING_CUBE_MAP_ARRAY_ARB      = 0x900A;
enum GL_PROXY_TEXTURE_CUBE_MAP_ARRAY_ARB        = 0x900B;
enum GL_SAMPLER_CUBE_MAP_ARRAY_ARB              = 0x900C;
enum GL_SAMPLER_CUBE_MAP_ARRAY_SHADOW_ARB       = 0x900D;
enum GL_INT_SAMPLER_CUBE_MAP_ARRAY_ARB          = 0x900E;
enum GL_UNSIGNED_INT_SAMPLER_CUBE_MAP_ARRAY_ARB = 0x900F;

// Constants for GL_ARB_texture_filter_minmax
enum GL_TEXTURE_REDUCTION_MODE_ARB = 0x9366;
enum GL_WEIGHTED_AVERAGE_ARB       = 0x9367;

// Constants for GL_ARB_texture_gather
enum GL_MIN_PROGRAM_TEXTURE_GATHER_OFFSET_ARB     = 0x8E5E;
enum GL_MAX_PROGRAM_TEXTURE_GATHER_OFFSET_ARB     = 0x8E5F;
enum GL_MAX_PROGRAM_TEXTURE_GATHER_COMPONENTS_ARB = 0x8F9F;

// Constants for GL_ARB_texture_mirrored_repeat
enum GL_MIRRORED_REPEAT_ARB = 0x8370;

// Constants for GL_ARB_transform_feedback_overflow_query
enum GL_TRANSFORM_FEEDBACK_OVERFLOW_ARB        = 0x82EC;
enum GL_TRANSFORM_FEEDBACK_STREAM_OVERFLOW_ARB = 0x82ED;

// Constants for GL_KHR_blend_equation_advanced
enum GL_MULTIPLY_KHR       = 0x9294;
enum GL_SCREEN_KHR         = 0x9295;
enum GL_OVERLAY_KHR        = 0x9296;
enum GL_DARKEN_KHR         = 0x9297;
enum GL_LIGHTEN_KHR        = 0x9298;
enum GL_COLORDODGE_KHR     = 0x9299;
enum GL_COLORBURN_KHR      = 0x929A;
enum GL_HARDLIGHT_KHR      = 0x929B;
enum GL_SOFTLIGHT_KHR      = 0x929C;
enum GL_DIFFERENCE_KHR     = 0x929E;
enum GL_EXCLUSION_KHR      = 0x92A0;
enum GL_HSL_HUE_KHR        = 0x92AD;
enum GL_HSL_SATURATION_KHR = 0x92AE;
enum GL_HSL_COLOR_KHR      = 0x92AF;
enum GL_HSL_LUMINOSITY_KHR = 0x92B0;

// Constants for GL_KHR_blend_equation_advanced_coherent
enum GL_BLEND_ADVANCED_COHERENT_KHR = 0x9285;

// Constants for GL_KHR_no_error
enum GL_CONTEXT_FLAG_NO_ERROR_BIT_KHR = 0x00000008;

// Constants for GL_KHR_parallel_shader_compile
enum GL_MAX_SHADER_COMPILER_THREADS_KHR = 0x91B0;
enum GL_COMPLETION_STATUS_KHR           = 0x91B1;

// Constants for GL_KHR_robustness
enum GL_CONTEXT_ROBUST_ACCESS = 0x90F3;

// Constants for GL_KHR_texture_compression_astc_hdr
enum GL_COMPRESSED_RGBA_ASTC_4x4_KHR           = 0x93B0;
enum GL_COMPRESSED_RGBA_ASTC_5x4_KHR           = 0x93B1;
enum GL_COMPRESSED_RGBA_ASTC_5x5_KHR           = 0x93B2;
enum GL_COMPRESSED_RGBA_ASTC_6x5_KHR           = 0x93B3;
enum GL_COMPRESSED_RGBA_ASTC_6x6_KHR           = 0x93B4;
enum GL_COMPRESSED_RGBA_ASTC_8x5_KHR           = 0x93B5;
enum GL_COMPRESSED_RGBA_ASTC_8x6_KHR           = 0x93B6;
enum GL_COMPRESSED_RGBA_ASTC_8x8_KHR           = 0x93B7;
enum GL_COMPRESSED_RGBA_ASTC_10x5_KHR          = 0x93B8;
enum GL_COMPRESSED_RGBA_ASTC_10x6_KHR          = 0x93B9;
enum GL_COMPRESSED_RGBA_ASTC_10x8_KHR          = 0x93BA;
enum GL_COMPRESSED_RGBA_ASTC_10x10_KHR         = 0x93BB;
enum GL_COMPRESSED_RGBA_ASTC_12x10_KHR         = 0x93BC;
enum GL_COMPRESSED_RGBA_ASTC_12x12_KHR         = 0x93BD;
enum GL_COMPRESSED_SRGB8_ALPHA8_ASTC_4x4_KHR   = 0x93D0;
enum GL_COMPRESSED_SRGB8_ALPHA8_ASTC_5x4_KHR   = 0x93D1;
enum GL_COMPRESSED_SRGB8_ALPHA8_ASTC_5x5_KHR   = 0x93D2;
enum GL_COMPRESSED_SRGB8_ALPHA8_ASTC_6x5_KHR   = 0x93D3;
enum GL_COMPRESSED_SRGB8_ALPHA8_ASTC_6x6_KHR   = 0x93D4;
enum GL_COMPRESSED_SRGB8_ALPHA8_ASTC_8x5_KHR   = 0x93D5;
enum GL_COMPRESSED_SRGB8_ALPHA8_ASTC_8x6_KHR   = 0x93D6;
enum GL_COMPRESSED_SRGB8_ALPHA8_ASTC_8x8_KHR   = 0x93D7;
enum GL_COMPRESSED_SRGB8_ALPHA8_ASTC_10x5_KHR  = 0x93D8;
enum GL_COMPRESSED_SRGB8_ALPHA8_ASTC_10x6_KHR  = 0x93D9;
enum GL_COMPRESSED_SRGB8_ALPHA8_ASTC_10x8_KHR  = 0x93DA;
enum GL_COMPRESSED_SRGB8_ALPHA8_ASTC_10x10_KHR = 0x93DB;
enum GL_COMPRESSED_SRGB8_ALPHA8_ASTC_12x10_KHR = 0x93DC;
enum GL_COMPRESSED_SRGB8_ALPHA8_ASTC_12x12_KHR = 0x93DD;

// Constants for GL_AMD_performance_monitor
enum GL_COUNTER_TYPE_AMD             = 0x8BC0;
enum GL_COUNTER_RANGE_AMD            = 0x8BC1;
enum GL_UNSIGNED_INT64_AMD           = 0x8BC2;
enum GL_PERCENTAGE_AMD               = 0x8BC3;
enum GL_PERFMON_RESULT_AVAILABLE_AMD = 0x8BC4;
enum GL_PERFMON_RESULT_SIZE_AMD      = 0x8BC5;
enum GL_PERFMON_RESULT_AMD           = 0x8BC6;

// Constants for GL_APPLE_rgb_422
enum GL_RGB_422_APPLE                = 0x8A1F;
enum GL_UNSIGNED_SHORT_8_8_APPLE     = 0x85BA;
enum GL_UNSIGNED_SHORT_8_8_REV_APPLE = 0x85BB;
enum GL_RGB_RAW_422_APPLE            = 0x8A51;

// Constants for GL_EXT_debug_label
enum GL_PROGRAM_PIPELINE_OBJECT_EXT = 0x8A4F;
enum GL_PROGRAM_OBJECT_EXT          = 0x8B40;
enum GL_SHADER_OBJECT_EXT           = 0x8B48;
enum GL_BUFFER_OBJECT_EXT           = 0x9151;
enum GL_QUERY_OBJECT_EXT            = 0x9153;
enum GL_VERTEX_ARRAY_OBJECT_EXT     = 0x9154;

// Constants for GL_EXT_direct_state_access
enum GL_PROGRAM_MATRIX_EXT             = 0x8E2D;
enum GL_TRANSPOSE_PROGRAM_MATRIX_EXT   = 0x8E2E;
enum GL_PROGRAM_MATRIX_STACK_DEPTH_EXT = 0x8E2F;

// Constants for GL_EXT_polygon_offset_clamp
enum GL_POLYGON_OFFSET_CLAMP_EXT = 0x8E1B;

// Constants for GL_EXT_raster_multisample
enum GL_RASTER_MULTISAMPLE_EXT                = 0x9327;
enum GL_RASTER_SAMPLES_EXT                    = 0x9328;
enum GL_MAX_RASTER_SAMPLES_EXT                = 0x9329;
enum GL_RASTER_FIXED_SAMPLE_LOCATIONS_EXT     = 0x932A;
enum GL_MULTISAMPLE_RASTERIZATION_ALLOWED_EXT = 0x932B;
enum GL_EFFECTIVE_RASTER_SAMPLES_EXT          = 0x932C;

// Constants for GL_EXT_separate_shader_objects
enum GL_ACTIVE_PROGRAM_EXT = 0x8B8D;

// Constants for GL_EXT_texture_compression_s3tc
enum GL_COMPRESSED_RGB_S3TC_DXT1_EXT  = 0x83F0;
enum GL_COMPRESSED_RGBA_S3TC_DXT1_EXT = 0x83F1;
enum GL_COMPRESSED_RGBA_S3TC_DXT3_EXT = 0x83F2;
enum GL_COMPRESSED_RGBA_S3TC_DXT5_EXT = 0x83F3;

// Constants for GL_EXT_texture_filter_minmax
enum GL_TEXTURE_REDUCTION_MODE_EXT = 0x9366;
enum GL_WEIGHTED_AVERAGE_EXT       = 0x9367;

// Constants for GL_EXT_texture_sRGB_decode
enum GL_TEXTURE_SRGB_DECODE_EXT = 0x8A48;
enum GL_DECODE_EXT              = 0x8A49;
enum GL_SKIP_DECODE_EXT         = 0x8A4A;

// Constants for GL_EXT_window_rectangles
enum GL_INCLUSIVE_EXT             = 0x8F10;
enum GL_EXCLUSIVE_EXT             = 0x8F11;
enum GL_WINDOW_RECTANGLE_EXT      = 0x8F12;
enum GL_WINDOW_RECTANGLE_MODE_EXT = 0x8F13;
enum GL_MAX_WINDOW_RECTANGLES_EXT = 0x8F14;
enum GL_NUM_WINDOW_RECTANGLES_EXT = 0x8F15;

// Constants for GL_INTEL_conservative_rasterization
enum GL_CONSERVATIVE_RASTERIZATION_INTEL = 0x83FE;

// Constants for GL_INTEL_performance_query
enum GL_PERFQUERY_SINGLE_CONTEXT_INTEL          = 0x00000000;
enum GL_PERFQUERY_GLOBAL_CONTEXT_INTEL          = 0x00000001;
enum GL_PERFQUERY_WAIT_INTEL                    = 0x83FB;
enum GL_PERFQUERY_FLUSH_INTEL                   = 0x83FA;
enum GL_PERFQUERY_DONOT_FLUSH_INTEL             = 0x83F9;
enum GL_PERFQUERY_COUNTER_EVENT_INTEL           = 0x94F0;
enum GL_PERFQUERY_COUNTER_DURATION_NORM_INTEL   = 0x94F1;
enum GL_PERFQUERY_COUNTER_DURATION_RAW_INTEL    = 0x94F2;
enum GL_PERFQUERY_COUNTER_THROUGHPUT_INTEL      = 0x94F3;
enum GL_PERFQUERY_COUNTER_RAW_INTEL             = 0x94F4;
enum GL_PERFQUERY_COUNTER_TIMESTAMP_INTEL       = 0x94F5;
enum GL_PERFQUERY_COUNTER_DATA_UINT32_INTEL     = 0x94F8;
enum GL_PERFQUERY_COUNTER_DATA_UINT64_INTEL     = 0x94F9;
enum GL_PERFQUERY_COUNTER_DATA_FLOAT_INTEL      = 0x94FA;
enum GL_PERFQUERY_COUNTER_DATA_DOUBLE_INTEL     = 0x94FB;
enum GL_PERFQUERY_COUNTER_DATA_BOOL32_INTEL     = 0x94FC;
enum GL_PERFQUERY_QUERY_NAME_LENGTH_MAX_INTEL   = 0x94FD;
enum GL_PERFQUERY_COUNTER_NAME_LENGTH_MAX_INTEL = 0x94FE;
enum GL_PERFQUERY_COUNTER_DESC_LENGTH_MAX_INTEL = 0x94FF;
enum GL_PERFQUERY_GPA_EXTENDED_COUNTERS_INTEL   = 0x9500;

// Constants for GL_NV_blend_equation_advanced
enum GL_BLEND_OVERLAP_NV           = 0x9281;
enum GL_BLEND_PREMULTIPLIED_SRC_NV = 0x9280;
enum GL_BLUE_NV                    = 0x1905;
enum GL_COLORBURN_NV               = 0x929A;
enum GL_COLORDODGE_NV              = 0x9299;
enum GL_CONJOINT_NV                = 0x9284;
enum GL_CONTRAST_NV                = 0x92A1;
enum GL_DARKEN_NV                  = 0x9297;
enum GL_DIFFERENCE_NV              = 0x929E;
enum GL_DISJOINT_NV                = 0x9283;
enum GL_DST_ATOP_NV                = 0x928F;
enum GL_DST_IN_NV                  = 0x928B;
enum GL_DST_NV                     = 0x9287;
enum GL_DST_OUT_NV                 = 0x928D;
enum GL_DST_OVER_NV                = 0x9289;
enum GL_EXCLUSION_NV               = 0x92A0;
enum GL_GREEN_NV                   = 0x1904;
enum GL_HARDLIGHT_NV               = 0x929B;
enum GL_HARDMIX_NV                 = 0x92A9;
enum GL_HSL_COLOR_NV               = 0x92AF;
enum GL_HSL_HUE_NV                 = 0x92AD;
enum GL_HSL_LUMINOSITY_NV          = 0x92B0;
enum GL_HSL_SATURATION_NV          = 0x92AE;
enum GL_INVERT_OVG_NV              = 0x92B4;
enum GL_INVERT_RGB_NV              = 0x92A3;
enum GL_LIGHTEN_NV                 = 0x9298;
enum GL_LINEARBURN_NV              = 0x92A5;
enum GL_LINEARDODGE_NV             = 0x92A4;
enum GL_LINEARLIGHT_NV             = 0x92A7;
enum GL_MINUS_CLAMPED_NV           = 0x92B3;
enum GL_MINUS_NV                   = 0x929F;
enum GL_MULTIPLY_NV                = 0x9294;
enum GL_OVERLAY_NV                 = 0x9296;
enum GL_PINLIGHT_NV                = 0x92A8;
enum GL_PLUS_CLAMPED_ALPHA_NV      = 0x92B2;
enum GL_PLUS_CLAMPED_NV            = 0x92B1;
enum GL_PLUS_DARKER_NV             = 0x9292;
enum GL_PLUS_NV                    = 0x9291;
enum GL_RED_NV                     = 0x1903;
enum GL_SCREEN_NV                  = 0x9295;
enum GL_SOFTLIGHT_NV               = 0x929C;
enum GL_SRC_ATOP_NV                = 0x928E;
enum GL_SRC_IN_NV                  = 0x928A;
enum GL_SRC_NV                     = 0x9286;
enum GL_SRC_OUT_NV                 = 0x928C;
enum GL_SRC_OVER_NV                = 0x9288;
enum GL_UNCORRELATED_NV            = 0x9282;
enum GL_VIVIDLIGHT_NV              = 0x92A6;
enum GL_XOR_NV                     = 0x1506;

// Constants for GL_NV_blend_equation_advanced_coherent
enum GL_BLEND_ADVANCED_COHERENT_NV = 0x9285;

// Constants for GL_NV_blend_minmax_factor
enum GL_FACTOR_MIN_AMD = 0x901C;
enum GL_FACTOR_MAX_AMD = 0x901D;

// Constants for GL_NV_clip_space_w_scaling
enum GL_VIEWPORT_POSITION_W_SCALE_NV         = 0x937C;
enum GL_VIEWPORT_POSITION_W_SCALE_X_COEFF_NV = 0x937D;
enum GL_VIEWPORT_POSITION_W_SCALE_Y_COEFF_NV = 0x937E;

// Constants for GL_NV_command_list
enum GL_TERMINATE_SEQUENCE_COMMAND_NV      = 0x0000;
enum GL_NOP_COMMAND_NV                     = 0x0001;
enum GL_DRAW_ELEMENTS_COMMAND_NV           = 0x0002;
enum GL_DRAW_ARRAYS_COMMAND_NV             = 0x0003;
enum GL_DRAW_ELEMENTS_STRIP_COMMAND_NV     = 0x0004;
enum GL_DRAW_ARRAYS_STRIP_COMMAND_NV       = 0x0005;
enum GL_DRAW_ELEMENTS_INSTANCED_COMMAND_NV = 0x0006;
enum GL_DRAW_ARRAYS_INSTANCED_COMMAND_NV   = 0x0007;
enum GL_ELEMENT_ADDRESS_COMMAND_NV         = 0x0008;
enum GL_ATTRIBUTE_ADDRESS_COMMAND_NV       = 0x0009;
enum GL_UNIFORM_ADDRESS_COMMAND_NV         = 0x000A;
enum GL_BLEND_COLOR_COMMAND_NV             = 0x000B;
enum GL_STENCIL_REF_COMMAND_NV             = 0x000C;
enum GL_LINE_WIDTH_COMMAND_NV              = 0x000D;
enum GL_POLYGON_OFFSET_COMMAND_NV          = 0x000E;
enum GL_ALPHA_REF_COMMAND_NV               = 0x000F;
enum GL_VIEWPORT_COMMAND_NV                = 0x0010;
enum GL_SCISSOR_COMMAND_NV                 = 0x0011;
enum GL_FRONT_FACE_COMMAND_NV              = 0x0012;

// Constants for GL_NV_conditional_render
enum GL_QUERY_WAIT_NV              = 0x8E13;
enum GL_QUERY_NO_WAIT_NV           = 0x8E14;
enum GL_QUERY_BY_REGION_WAIT_NV    = 0x8E15;
enum GL_QUERY_BY_REGION_NO_WAIT_NV = 0x8E16;

// Constants for GL_NV_conservative_raster
enum GL_CONSERVATIVE_RASTERIZATION_NV       = 0x9346;
enum GL_SUBPIXEL_PRECISION_BIAS_X_BITS_NV   = 0x9347;
enum GL_SUBPIXEL_PRECISION_BIAS_Y_BITS_NV   = 0x9348;
enum GL_MAX_SUBPIXEL_PRECISION_BIAS_BITS_NV = 0x9349;

// Constants for GL_NV_conservative_raster_dilate
enum GL_CONSERVATIVE_RASTER_DILATE_NV             = 0x9379;
enum GL_CONSERVATIVE_RASTER_DILATE_RANGE_NV       = 0x937A;
enum GL_CONSERVATIVE_RASTER_DILATE_GRANULARITY_NV = 0x937B;

// Constants for GL_NV_conservative_raster_pre_snap
enum GL_CONSERVATIVE_RASTER_MODE_PRE_SNAP_NV = 0x9550;

// Constants for GL_NV_conservative_raster_pre_snap_triangles
enum GL_CONSERVATIVE_RASTER_MODE_NV                    = 0x954D;
enum GL_CONSERVATIVE_RASTER_MODE_POST_SNAP_NV          = 0x954E;
enum GL_CONSERVATIVE_RASTER_MODE_PRE_SNAP_TRIANGLES_NV = 0x954F;

// Constants for GL_NV_fill_rectangle
enum GL_FILL_RECTANGLE_NV = 0x933C;

// Constants for GL_NV_fragment_coverage_to_color
enum GL_FRAGMENT_COVERAGE_TO_COLOR_NV = 0x92DD;
enum GL_FRAGMENT_COVERAGE_COLOR_NV    = 0x92DE;

// Constants for GL_NV_framebuffer_mixed_samples
enum GL_COVERAGE_MODULATION_TABLE_NV       = 0x9331;
enum GL_COLOR_SAMPLES_NV                   = 0x8E20;
enum GL_DEPTH_SAMPLES_NV                   = 0x932D;
enum GL_STENCIL_SAMPLES_NV                 = 0x932E;
enum GL_MIXED_DEPTH_SAMPLES_SUPPORTED_NV   = 0x932F;
enum GL_MIXED_STENCIL_SAMPLES_SUPPORTED_NV = 0x9330;
enum GL_COVERAGE_MODULATION_NV             = 0x9332;
enum GL_COVERAGE_MODULATION_TABLE_SIZE_NV  = 0x9333;

// Constants for GL_NV_framebuffer_multisample_coverage
enum GL_RENDERBUFFER_COVERAGE_SAMPLES_NV  = 0x8CAB;
enum GL_RENDERBUFFER_COLOR_SAMPLES_NV     = 0x8E10;
enum GL_MAX_MULTISAMPLE_COVERAGE_MODES_NV = 0x8E11;
enum GL_MULTISAMPLE_COVERAGE_MODES_NV     = 0x8E12;

// Constants for GL_NV_gpu_shader5
enum GL_INT64_NV               = 0x140E;
enum GL_UNSIGNED_INT64_NV      = 0x140F;
enum GL_INT8_NV                = 0x8FE0;
enum GL_INT8_VEC2_NV           = 0x8FE1;
enum GL_INT8_VEC3_NV           = 0x8FE2;
enum GL_INT8_VEC4_NV           = 0x8FE3;
enum GL_INT16_NV               = 0x8FE4;
enum GL_INT16_VEC2_NV          = 0x8FE5;
enum GL_INT16_VEC3_NV          = 0x8FE6;
enum GL_INT16_VEC4_NV          = 0x8FE7;
enum GL_INT64_VEC2_NV          = 0x8FE9;
enum GL_INT64_VEC3_NV          = 0x8FEA;
enum GL_INT64_VEC4_NV          = 0x8FEB;
enum GL_UNSIGNED_INT8_NV       = 0x8FEC;
enum GL_UNSIGNED_INT8_VEC2_NV  = 0x8FED;
enum GL_UNSIGNED_INT8_VEC3_NV  = 0x8FEE;
enum GL_UNSIGNED_INT8_VEC4_NV  = 0x8FEF;
enum GL_UNSIGNED_INT16_NV      = 0x8FF0;
enum GL_UNSIGNED_INT16_VEC2_NV = 0x8FF1;
enum GL_UNSIGNED_INT16_VEC3_NV = 0x8FF2;
enum GL_UNSIGNED_INT16_VEC4_NV = 0x8FF3;
enum GL_UNSIGNED_INT64_VEC2_NV = 0x8FF5;
enum GL_UNSIGNED_INT64_VEC3_NV = 0x8FF6;
enum GL_UNSIGNED_INT64_VEC4_NV = 0x8FF7;
enum GL_FLOAT16_NV             = 0x8FF8;
enum GL_FLOAT16_VEC2_NV        = 0x8FF9;
enum GL_FLOAT16_VEC3_NV        = 0x8FFA;
enum GL_FLOAT16_VEC4_NV        = 0x8FFB;

// Constants for GL_NV_internalformat_sample_query
enum GL_MULTISAMPLES_NV        = 0x9371;
enum GL_SUPERSAMPLE_SCALE_X_NV = 0x9372;
enum GL_SUPERSAMPLE_SCALE_Y_NV = 0x9373;
enum GL_CONFORMANT_NV          = 0x9374;

// Constants for GL_NV_path_rendering
enum GL_PATH_FORMAT_SVG_NV                      = 0x9070;
enum GL_PATH_FORMAT_PS_NV                       = 0x9071;
enum GL_STANDARD_FONT_NAME_NV                   = 0x9072;
enum GL_SYSTEM_FONT_NAME_NV                     = 0x9073;
enum GL_FILE_NAME_NV                            = 0x9074;
enum GL_PATH_STROKE_WIDTH_NV                    = 0x9075;
enum GL_PATH_END_CAPS_NV                        = 0x9076;
enum GL_PATH_INITIAL_END_CAP_NV                 = 0x9077;
enum GL_PATH_TERMINAL_END_CAP_NV                = 0x9078;
enum GL_PATH_JOIN_STYLE_NV                      = 0x9079;
enum GL_PATH_MITER_LIMIT_NV                     = 0x907A;
enum GL_PATH_DASH_CAPS_NV                       = 0x907B;
enum GL_PATH_INITIAL_DASH_CAP_NV                = 0x907C;
enum GL_PATH_TERMINAL_DASH_CAP_NV               = 0x907D;
enum GL_PATH_DASH_OFFSET_NV                     = 0x907E;
enum GL_PATH_CLIENT_LENGTH_NV                   = 0x907F;
enum GL_PATH_FILL_MODE_NV                       = 0x9080;
enum GL_PATH_FILL_MASK_NV                       = 0x9081;
enum GL_PATH_FILL_COVER_MODE_NV                 = 0x9082;
enum GL_PATH_STROKE_COVER_MODE_NV               = 0x9083;
enum GL_PATH_STROKE_MASK_NV                     = 0x9084;
enum GL_COUNT_UP_NV                             = 0x9088;
enum GL_COUNT_DOWN_NV                           = 0x9089;
enum GL_PATH_OBJECT_BOUNDING_BOX_NV             = 0x908A;
enum GL_CONVEX_HULL_NV                          = 0x908B;
enum GL_BOUNDING_BOX_NV                         = 0x908D;
enum GL_TRANSLATE_X_NV                          = 0x908E;
enum GL_TRANSLATE_Y_NV                          = 0x908F;
enum GL_TRANSLATE_2D_NV                         = 0x9090;
enum GL_TRANSLATE_3D_NV                         = 0x9091;
enum GL_AFFINE_2D_NV                            = 0x9092;
enum GL_AFFINE_3D_NV                            = 0x9094;
enum GL_TRANSPOSE_AFFINE_2D_NV                  = 0x9096;
enum GL_TRANSPOSE_AFFINE_3D_NV                  = 0x9098;
enum GL_UTF8_NV                                 = 0x909A;
enum GL_UTF16_NV                                = 0x909B;
enum GL_BOUNDING_BOX_OF_BOUNDING_BOXES_NV       = 0x909C;
enum GL_PATH_COMMAND_COUNT_NV                   = 0x909D;
enum GL_PATH_COORD_COUNT_NV                     = 0x909E;
enum GL_PATH_DASH_ARRAY_COUNT_NV                = 0x909F;
enum GL_PATH_COMPUTED_LENGTH_NV                 = 0x90A0;
enum GL_PATH_FILL_BOUNDING_BOX_NV               = 0x90A1;
enum GL_PATH_STROKE_BOUNDING_BOX_NV             = 0x90A2;
enum GL_SQUARE_NV                               = 0x90A3;
enum GL_ROUND_NV                                = 0x90A4;
enum GL_TRIANGULAR_NV                           = 0x90A5;
enum GL_BEVEL_NV                                = 0x90A6;
enum GL_MITER_REVERT_NV                         = 0x90A7;
enum GL_MITER_TRUNCATE_NV                       = 0x90A8;
enum GL_SKIP_MISSING_GLYPH_NV                   = 0x90A9;
enum GL_USE_MISSING_GLYPH_NV                    = 0x90AA;
enum GL_PATH_ERROR_POSITION_NV                  = 0x90AB;
enum GL_ACCUM_ADJACENT_PAIRS_NV                 = 0x90AD;
enum GL_ADJACENT_PAIRS_NV                       = 0x90AE;
enum GL_FIRST_TO_REST_NV                        = 0x90AF;
enum GL_PATH_GEN_MODE_NV                        = 0x90B0;
enum GL_PATH_GEN_COEFF_NV                       = 0x90B1;
enum GL_PATH_GEN_COMPONENTS_NV                  = 0x90B3;
enum GL_PATH_STENCIL_FUNC_NV                    = 0x90B7;
enum GL_PATH_STENCIL_REF_NV                     = 0x90B8;
enum GL_PATH_STENCIL_VALUE_MASK_NV              = 0x90B9;
enum GL_PATH_STENCIL_DEPTH_OFFSET_FACTOR_NV     = 0x90BD;
enum GL_PATH_STENCIL_DEPTH_OFFSET_UNITS_NV      = 0x90BE;
enum GL_PATH_COVER_DEPTH_FUNC_NV                = 0x90BF;
enum GL_PATH_DASH_OFFSET_RESET_NV               = 0x90B4;
enum GL_MOVE_TO_RESETS_NV                       = 0x90B5;
enum GL_MOVE_TO_CONTINUES_NV                    = 0x90B6;
enum GL_CLOSE_PATH_NV                           = 0x00;
enum GL_MOVE_TO_NV                              = 0x02;
enum GL_RELATIVE_MOVE_TO_NV                     = 0x03;
enum GL_LINE_TO_NV                              = 0x04;
enum GL_RELATIVE_LINE_TO_NV                     = 0x05;
enum GL_HORIZONTAL_LINE_TO_NV                   = 0x06;
enum GL_RELATIVE_HORIZONTAL_LINE_TO_NV          = 0x07;
enum GL_VERTICAL_LINE_TO_NV                     = 0x08;
enum GL_RELATIVE_VERTICAL_LINE_TO_NV            = 0x09;
enum GL_QUADRATIC_CURVE_TO_NV                   = 0x0A;
enum GL_RELATIVE_QUADRATIC_CURVE_TO_NV          = 0x0B;
enum GL_CUBIC_CURVE_TO_NV                       = 0x0C;
enum GL_RELATIVE_CUBIC_CURVE_TO_NV              = 0x0D;
enum GL_SMOOTH_QUADRATIC_CURVE_TO_NV            = 0x0E;
enum GL_RELATIVE_SMOOTH_QUADRATIC_CURVE_TO_NV   = 0x0F;
enum GL_SMOOTH_CUBIC_CURVE_TO_NV                = 0x10;
enum GL_RELATIVE_SMOOTH_CUBIC_CURVE_TO_NV       = 0x11;
enum GL_SMALL_CCW_ARC_TO_NV                     = 0x12;
enum GL_RELATIVE_SMALL_CCW_ARC_TO_NV            = 0x13;
enum GL_SMALL_CW_ARC_TO_NV                      = 0x14;
enum GL_RELATIVE_SMALL_CW_ARC_TO_NV             = 0x15;
enum GL_LARGE_CCW_ARC_TO_NV                     = 0x16;
enum GL_RELATIVE_LARGE_CCW_ARC_TO_NV            = 0x17;
enum GL_LARGE_CW_ARC_TO_NV                      = 0x18;
enum GL_RELATIVE_LARGE_CW_ARC_TO_NV             = 0x19;
enum GL_RESTART_PATH_NV                         = 0xF0;
enum GL_DUP_FIRST_CUBIC_CURVE_TO_NV             = 0xF2;
enum GL_DUP_LAST_CUBIC_CURVE_TO_NV              = 0xF4;
enum GL_RECT_NV                                 = 0xF6;
enum GL_CIRCULAR_CCW_ARC_TO_NV                  = 0xF8;
enum GL_CIRCULAR_CW_ARC_TO_NV                   = 0xFA;
enum GL_CIRCULAR_TANGENT_ARC_TO_NV              = 0xFC;
enum GL_ARC_TO_NV                               = 0xFE;
enum GL_RELATIVE_ARC_TO_NV                      = 0xFF;
enum GL_BOLD_BIT_NV                             = 0x01;
enum GL_ITALIC_BIT_NV                           = 0x02;
enum GL_GLYPH_WIDTH_BIT_NV                      = 0x01;
enum GL_GLYPH_HEIGHT_BIT_NV                     = 0x02;
enum GL_GLYPH_HORIZONTAL_BEARING_X_BIT_NV       = 0x04;
enum GL_GLYPH_HORIZONTAL_BEARING_Y_BIT_NV       = 0x08;
enum GL_GLYPH_HORIZONTAL_BEARING_ADVANCE_BIT_NV = 0x10;
enum GL_GLYPH_VERTICAL_BEARING_X_BIT_NV         = 0x20;
enum GL_GLYPH_VERTICAL_BEARING_Y_BIT_NV         = 0x40;
enum GL_GLYPH_VERTICAL_BEARING_ADVANCE_BIT_NV   = 0x80;
enum GL_GLYPH_HAS_KERNING_BIT_NV                = 0x100;
enum GL_FONT_X_MIN_BOUNDS_BIT_NV                = 0x00010000;
enum GL_FONT_Y_MIN_BOUNDS_BIT_NV                = 0x00020000;
enum GL_FONT_X_MAX_BOUNDS_BIT_NV                = 0x00040000;
enum GL_FONT_Y_MAX_BOUNDS_BIT_NV                = 0x00080000;
enum GL_FONT_UNITS_PER_EM_BIT_NV                = 0x00100000;
enum GL_FONT_ASCENDER_BIT_NV                    = 0x00200000;
enum GL_FONT_DESCENDER_BIT_NV                   = 0x00400000;
enum GL_FONT_HEIGHT_BIT_NV                      = 0x00800000;
enum GL_FONT_MAX_ADVANCE_WIDTH_BIT_NV           = 0x01000000;
enum GL_FONT_MAX_ADVANCE_HEIGHT_BIT_NV          = 0x02000000;
enum GL_FONT_UNDERLINE_POSITION_BIT_NV          = 0x04000000;
enum GL_FONT_UNDERLINE_THICKNESS_BIT_NV         = 0x08000000;
enum GL_FONT_HAS_KERNING_BIT_NV                 = 0x10000000;
enum GL_ROUNDED_RECT_NV                         = 0xE8;
enum GL_RELATIVE_ROUNDED_RECT_NV                = 0xE9;
enum GL_ROUNDED_RECT2_NV                        = 0xEA;
enum GL_RELATIVE_ROUNDED_RECT2_NV               = 0xEB;
enum GL_ROUNDED_RECT4_NV                        = 0xEC;
enum GL_RELATIVE_ROUNDED_RECT4_NV               = 0xED;
enum GL_ROUNDED_RECT8_NV                        = 0xEE;
enum GL_RELATIVE_ROUNDED_RECT8_NV               = 0xEF;
enum GL_RELATIVE_RECT_NV                        = 0xF7;
enum GL_FONT_GLYPHS_AVAILABLE_NV                = 0x9368;
enum GL_FONT_TARGET_UNAVAILABLE_NV              = 0x9369;
enum GL_FONT_UNAVAILABLE_NV                     = 0x936A;
enum GL_FONT_UNINTELLIGIBLE_NV                  = 0x936B;
enum GL_CONIC_CURVE_TO_NV                       = 0x1A;
enum GL_RELATIVE_CONIC_CURVE_TO_NV              = 0x1B;
enum GL_FONT_NUM_GLYPH_INDICES_BIT_NV           = 0x20000000;
enum GL_STANDARD_FONT_FORMAT_NV                 = 0x936C;
enum GL_PATH_PROJECTION_NV                      = 0x1701;
enum GL_PATH_MODELVIEW_NV                       = 0x1700;
enum GL_PATH_MODELVIEW_STACK_DEPTH_NV           = 0x0BA3;
enum GL_PATH_MODELVIEW_MATRIX_NV                = 0x0BA6;
enum GL_PATH_MAX_MODELVIEW_STACK_DEPTH_NV       = 0x0D36;
enum GL_PATH_TRANSPOSE_MODELVIEW_MATRIX_NV      = 0x84E3;
enum GL_PATH_PROJECTION_STACK_DEPTH_NV          = 0x0BA4;
enum GL_PATH_PROJECTION_MATRIX_NV               = 0x0BA7;
enum GL_PATH_MAX_PROJECTION_STACK_DEPTH_NV      = 0x0D38;
enum GL_PATH_TRANSPOSE_PROJECTION_MATRIX_NV     = 0x84E4;
enum GL_FRAGMENT_INPUT_NV                       = 0x936D;

// Constants for GL_NV_path_rendering_shared_edge
enum GL_SHARED_EDGE_NV = 0xC0;

// Constants for GL_NV_sample_locations
enum GL_SAMPLE_LOCATION_SUBPIXEL_BITS_NV             = 0x933D;
enum GL_SAMPLE_LOCATION_PIXEL_GRID_WIDTH_NV          = 0x933E;
enum GL_SAMPLE_LOCATION_PIXEL_GRID_HEIGHT_NV         = 0x933F;
enum GL_PROGRAMMABLE_SAMPLE_LOCATION_TABLE_SIZE_NV   = 0x9340;
enum GL_SAMPLE_LOCATION_NV                           = 0x8E50;
enum GL_PROGRAMMABLE_SAMPLE_LOCATION_NV              = 0x9341;
enum GL_FRAMEBUFFER_PROGRAMMABLE_SAMPLE_LOCATIONS_NV = 0x9342;
enum GL_FRAMEBUFFER_SAMPLE_LOCATION_PIXEL_GRID_NV    = 0x9343;

// Constants for GL_NV_shader_buffer_load
enum GL_BUFFER_GPU_ADDRESS_NV        = 0x8F1D;
enum GL_GPU_ADDRESS_NV               = 0x8F34;
enum GL_MAX_SHADER_BUFFER_ADDRESS_NV = 0x8F35;

// Constants for GL_NV_shader_buffer_store
enum GL_SHADER_GLOBAL_ACCESS_BARRIER_BIT_NV = 0x00000010;

// Constants for GL_NV_shader_thread_group
enum GL_WARP_SIZE_NV    = 0x9339;
enum GL_WARPS_PER_SM_NV = 0x933A;
enum GL_SM_COUNT_NV     = 0x933B;

// Constants for GL_NV_uniform_buffer_unified_memory
enum GL_UNIFORM_BUFFER_UNIFIED_NV = 0x936E;
enum GL_UNIFORM_BUFFER_ADDRESS_NV = 0x936F;
enum GL_UNIFORM_BUFFER_LENGTH_NV  = 0x9370;

// Constants for GL_NV_vertex_buffer_unified_memory
enum GL_VERTEX_ATTRIB_ARRAY_UNIFIED_NV   = 0x8F1E;
enum GL_ELEMENT_ARRAY_UNIFIED_NV         = 0x8F1F;
enum GL_VERTEX_ATTRIB_ARRAY_ADDRESS_NV   = 0x8F20;
enum GL_VERTEX_ARRAY_ADDRESS_NV          = 0x8F21;
enum GL_NORMAL_ARRAY_ADDRESS_NV          = 0x8F22;
enum GL_COLOR_ARRAY_ADDRESS_NV           = 0x8F23;
enum GL_INDEX_ARRAY_ADDRESS_NV           = 0x8F24;
enum GL_TEXTURE_COORD_ARRAY_ADDRESS_NV   = 0x8F25;
enum GL_EDGE_FLAG_ARRAY_ADDRESS_NV       = 0x8F26;
enum GL_SECONDARY_COLOR_ARRAY_ADDRESS_NV = 0x8F27;
enum GL_FOG_COORD_ARRAY_ADDRESS_NV       = 0x8F28;
enum GL_ELEMENT_ARRAY_ADDRESS_NV         = 0x8F29;
enum GL_VERTEX_ATTRIB_ARRAY_LENGTH_NV    = 0x8F2A;
enum GL_VERTEX_ARRAY_LENGTH_NV           = 0x8F2B;
enum GL_NORMAL_ARRAY_LENGTH_NV           = 0x8F2C;
enum GL_COLOR_ARRAY_LENGTH_NV            = 0x8F2D;
enum GL_INDEX_ARRAY_LENGTH_NV            = 0x8F2E;
enum GL_TEXTURE_COORD_ARRAY_LENGTH_NV    = 0x8F2F;
enum GL_EDGE_FLAG_ARRAY_LENGTH_NV        = 0x8F30;
enum GL_SECONDARY_COLOR_ARRAY_LENGTH_NV  = 0x8F31;
enum GL_FOG_COORD_ARRAY_LENGTH_NV        = 0x8F32;
enum GL_ELEMENT_ARRAY_LENGTH_NV          = 0x8F33;
enum GL_DRAW_INDIRECT_UNIFIED_NV         = 0x8F40;
enum GL_DRAW_INDIRECT_ADDRESS_NV         = 0x8F41;
enum GL_DRAW_INDIRECT_LENGTH_NV          = 0x8F42;

// Constants for GL_NV_viewport_swizzle
enum GL_VIEWPORT_SWIZZLE_POSITIVE_X_NV = 0x9350;
enum GL_VIEWPORT_SWIZZLE_NEGATIVE_X_NV = 0x9351;
enum GL_VIEWPORT_SWIZZLE_POSITIVE_Y_NV = 0x9352;
enum GL_VIEWPORT_SWIZZLE_NEGATIVE_Y_NV = 0x9353;
enum GL_VIEWPORT_SWIZZLE_POSITIVE_Z_NV = 0x9354;
enum GL_VIEWPORT_SWIZZLE_NEGATIVE_Z_NV = 0x9355;
enum GL_VIEWPORT_SWIZZLE_POSITIVE_W_NV = 0x9356;
enum GL_VIEWPORT_SWIZZLE_NEGATIVE_W_NV = 0x9357;
enum GL_VIEWPORT_SWIZZLE_X_NV          = 0x9358;
enum GL_VIEWPORT_SWIZZLE_Y_NV          = 0x9359;
enum GL_VIEWPORT_SWIZZLE_Z_NV          = 0x935A;
enum GL_VIEWPORT_SWIZZLE_W_NV          = 0x935B;

// Constants for GL_OVR_multiview
enum GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_NUM_VIEWS_OVR       = 0x9630;
enum GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_BASE_VIEW_INDEX_OVR = 0x9632;
enum GL_MAX_VIEWS_OVR                                      = 0x9631;
enum GL_FRAMEBUFFER_INCOMPLETE_VIEW_TARGETS_OVR            = 0x9633;

// Command pointer aliases

extern(C) nothrow @nogc {

    // Command pointers for GL_VERSION_1_0
    alias PFN_glCullFace = void function (
        GLenum mode,
    );
    alias PFN_glFrontFace = void function (
        GLenum mode,
    );
    alias PFN_glHint = void function (
        GLenum target,
        GLenum mode,
    );
    alias PFN_glLineWidth = void function (
        GLfloat width,
    );
    alias PFN_glPointSize = void function (
        GLfloat size,
    );
    alias PFN_glPolygonMode = void function (
        GLenum face,
        GLenum mode,
    );
    alias PFN_glScissor = void function (
        GLint   x,
        GLint   y,
        GLsizei width,
        GLsizei height,
    );
    alias PFN_glTexParameterf = void function (
        GLenum  target,
        GLenum  pname,
        GLfloat param,
    );
    alias PFN_glTexParameterfv = void function (
        GLenum          target,
        GLenum          pname,
        const(GLfloat)* params,
    );
    alias PFN_glTexParameteri = void function (
        GLenum target,
        GLenum pname,
        GLint  param,
    );
    alias PFN_glTexParameteriv = void function (
        GLenum        target,
        GLenum        pname,
        const(GLint)* params,
    );
    alias PFN_glTexImage1D = void function (
        GLenum       target,
        GLint        level,
        GLint        internalformat,
        GLsizei      width,
        GLint        border,
        GLenum       format,
        GLenum       type,
        const(void)* pixels,
    );
    alias PFN_glTexImage2D = void function (
        GLenum       target,
        GLint        level,
        GLint        internalformat,
        GLsizei      width,
        GLsizei      height,
        GLint        border,
        GLenum       format,
        GLenum       type,
        const(void)* pixels,
    );
    alias PFN_glDrawBuffer = void function (
        GLenum buf,
    );
    alias PFN_glClear = void function (
        GLbitfield mask,
    );
    alias PFN_glClearColor = void function (
        GLfloat red,
        GLfloat green,
        GLfloat blue,
        GLfloat alpha,
    );
    alias PFN_glClearStencil = void function (
        GLint s,
    );
    alias PFN_glClearDepth = void function (
        GLdouble depth,
    );
    alias PFN_glStencilMask = void function (
        GLuint mask,
    );
    alias PFN_glColorMask = void function (
        GLboolean red,
        GLboolean green,
        GLboolean blue,
        GLboolean alpha,
    );
    alias PFN_glDepthMask = void function (
        GLboolean flag,
    );
    alias PFN_glDisable = void function (
        GLenum cap,
    );
    alias PFN_glEnable = void function (
        GLenum cap,
    );
    alias PFN_glFinish = void function ();
    alias PFN_glFlush = void function ();
    alias PFN_glBlendFunc = void function (
        GLenum sfactor,
        GLenum dfactor,
    );
    alias PFN_glLogicOp = void function (
        GLenum opcode,
    );
    alias PFN_glStencilFunc = void function (
        GLenum func,
        GLint  ref_,
        GLuint mask,
    );
    alias PFN_glStencilOp = void function (
        GLenum fail,
        GLenum zfail,
        GLenum zpass,
    );
    alias PFN_glDepthFunc = void function (
        GLenum func,
    );
    alias PFN_glPixelStoref = void function (
        GLenum  pname,
        GLfloat param,
    );
    alias PFN_glPixelStorei = void function (
        GLenum pname,
        GLint  param,
    );
    alias PFN_glReadBuffer = void function (
        GLenum src,
    );
    alias PFN_glReadPixels = void function (
        GLint   x,
        GLint   y,
        GLsizei width,
        GLsizei height,
        GLenum  format,
        GLenum  type,
        void*   pixels,
    );
    alias PFN_glGetBooleanv = void function (
        GLenum     pname,
        GLboolean* data,
    );
    alias PFN_glGetDoublev = void function (
        GLenum    pname,
        GLdouble* data,
    );
    alias PFN_glGetError = GLenum function ();
    alias PFN_glGetFloatv = void function (
        GLenum   pname,
        GLfloat* data,
    );
    alias PFN_glGetIntegerv = void function (
        GLenum pname,
        GLint* data,
    );
    alias PFN_glGetString = const(GLubyte)* function (
        GLenum name,
    );
    alias PFN_glGetTexImage = void function (
        GLenum target,
        GLint  level,
        GLenum format,
        GLenum type,
        void*  pixels,
    );
    alias PFN_glGetTexParameterfv = void function (
        GLenum   target,
        GLenum   pname,
        GLfloat* params,
    );
    alias PFN_glGetTexParameteriv = void function (
        GLenum target,
        GLenum pname,
        GLint* params,
    );
    alias PFN_glGetTexLevelParameterfv = void function (
        GLenum   target,
        GLint    level,
        GLenum   pname,
        GLfloat* params,
    );
    alias PFN_glGetTexLevelParameteriv = void function (
        GLenum target,
        GLint  level,
        GLenum pname,
        GLint* params,
    );
    alias PFN_glIsEnabled = GLboolean function (
        GLenum cap,
    );
    alias PFN_glDepthRange = void function (
        GLdouble near,
        GLdouble far,
    );
    alias PFN_glViewport = void function (
        GLint   x,
        GLint   y,
        GLsizei width,
        GLsizei height,
    );

    // Command pointers for GL_VERSION_1_1
    alias PFN_glDrawArrays = void function (
        GLenum  mode,
        GLint   first,
        GLsizei count,
    );
    alias PFN_glDrawElements = void function (
        GLenum       mode,
        GLsizei      count,
        GLenum       type,
        const(void)* indices,
    );
    alias PFN_glGetPointerv = void function (
        GLenum pname,
        void** params,
    );
    alias PFN_glPolygonOffset = void function (
        GLfloat factor,
        GLfloat units,
    );
    alias PFN_glCopyTexImage1D = void function (
        GLenum  target,
        GLint   level,
        GLenum  internalformat,
        GLint   x,
        GLint   y,
        GLsizei width,
        GLint   border,
    );
    alias PFN_glCopyTexImage2D = void function (
        GLenum  target,
        GLint   level,
        GLenum  internalformat,
        GLint   x,
        GLint   y,
        GLsizei width,
        GLsizei height,
        GLint   border,
    );
    alias PFN_glCopyTexSubImage1D = void function (
        GLenum  target,
        GLint   level,
        GLint   xoffset,
        GLint   x,
        GLint   y,
        GLsizei width,
    );
    alias PFN_glCopyTexSubImage2D = void function (
        GLenum  target,
        GLint   level,
        GLint   xoffset,
        GLint   yoffset,
        GLint   x,
        GLint   y,
        GLsizei width,
        GLsizei height,
    );
    alias PFN_glTexSubImage1D = void function (
        GLenum       target,
        GLint        level,
        GLint        xoffset,
        GLsizei      width,
        GLenum       format,
        GLenum       type,
        const(void)* pixels,
    );
    alias PFN_glTexSubImage2D = void function (
        GLenum       target,
        GLint        level,
        GLint        xoffset,
        GLint        yoffset,
        GLsizei      width,
        GLsizei      height,
        GLenum       format,
        GLenum       type,
        const(void)* pixels,
    );
    alias PFN_glBindTexture = void function (
        GLenum target,
        GLuint texture,
    );
    alias PFN_glDeleteTextures = void function (
        GLsizei        n,
        const(GLuint)* textures,
    );
    alias PFN_glGenTextures = void function (
        GLsizei n,
        GLuint* textures,
    );
    alias PFN_glIsTexture = GLboolean function (
        GLuint texture,
    );

    // Command pointers for GL_VERSION_1_2
    alias PFN_glDrawRangeElements = void function (
        GLenum       mode,
        GLuint       start,
        GLuint       end,
        GLsizei      count,
        GLenum       type,
        const(void)* indices,
    );
    alias PFN_glTexImage3D = void function (
        GLenum       target,
        GLint        level,
        GLint        internalformat,
        GLsizei      width,
        GLsizei      height,
        GLsizei      depth,
        GLint        border,
        GLenum       format,
        GLenum       type,
        const(void)* pixels,
    );
    alias PFN_glTexSubImage3D = void function (
        GLenum       target,
        GLint        level,
        GLint        xoffset,
        GLint        yoffset,
        GLint        zoffset,
        GLsizei      width,
        GLsizei      height,
        GLsizei      depth,
        GLenum       format,
        GLenum       type,
        const(void)* pixels,
    );
    alias PFN_glCopyTexSubImage3D = void function (
        GLenum  target,
        GLint   level,
        GLint   xoffset,
        GLint   yoffset,
        GLint   zoffset,
        GLint   x,
        GLint   y,
        GLsizei width,
        GLsizei height,
    );

    // Command pointers for GL_VERSION_1_3
    alias PFN_glActiveTexture = void function (
        GLenum texture,
    );
    alias PFN_glSampleCoverage = void function (
        GLfloat   value,
        GLboolean invert,
    );
    alias PFN_glCompressedTexImage3D = void function (
        GLenum       target,
        GLint        level,
        GLenum       internalformat,
        GLsizei      width,
        GLsizei      height,
        GLsizei      depth,
        GLint        border,
        GLsizei      imageSize,
        const(void)* data,
    );
    alias PFN_glCompressedTexImage2D = void function (
        GLenum       target,
        GLint        level,
        GLenum       internalformat,
        GLsizei      width,
        GLsizei      height,
        GLint        border,
        GLsizei      imageSize,
        const(void)* data,
    );
    alias PFN_glCompressedTexImage1D = void function (
        GLenum       target,
        GLint        level,
        GLenum       internalformat,
        GLsizei      width,
        GLint        border,
        GLsizei      imageSize,
        const(void)* data,
    );
    alias PFN_glCompressedTexSubImage3D = void function (
        GLenum       target,
        GLint        level,
        GLint        xoffset,
        GLint        yoffset,
        GLint        zoffset,
        GLsizei      width,
        GLsizei      height,
        GLsizei      depth,
        GLenum       format,
        GLsizei      imageSize,
        const(void)* data,
    );
    alias PFN_glCompressedTexSubImage2D = void function (
        GLenum       target,
        GLint        level,
        GLint        xoffset,
        GLint        yoffset,
        GLsizei      width,
        GLsizei      height,
        GLenum       format,
        GLsizei      imageSize,
        const(void)* data,
    );
    alias PFN_glCompressedTexSubImage1D = void function (
        GLenum       target,
        GLint        level,
        GLint        xoffset,
        GLsizei      width,
        GLenum       format,
        GLsizei      imageSize,
        const(void)* data,
    );
    alias PFN_glGetCompressedTexImage = void function (
        GLenum target,
        GLint  level,
        void*  img,
    );

    // Command pointers for GL_VERSION_1_4
    alias PFN_glBlendFuncSeparate = void function (
        GLenum sfactorRGB,
        GLenum dfactorRGB,
        GLenum sfactorAlpha,
        GLenum dfactorAlpha,
    );
    alias PFN_glMultiDrawArrays = void function (
        GLenum          mode,
        const(GLint)*   first,
        const(GLsizei)* count,
        GLsizei         drawcount,
    );
    alias PFN_glMultiDrawElements = void function (
        GLenum          mode,
        const(GLsizei)* count,
        GLenum          type,
        const(void*)*   indices,
        GLsizei         drawcount,
    );
    alias PFN_glPointParameterf = void function (
        GLenum  pname,
        GLfloat param,
    );
    alias PFN_glPointParameterfv = void function (
        GLenum          pname,
        const(GLfloat)* params,
    );
    alias PFN_glPointParameteri = void function (
        GLenum pname,
        GLint  param,
    );
    alias PFN_glPointParameteriv = void function (
        GLenum        pname,
        const(GLint)* params,
    );
    alias PFN_glBlendColor = void function (
        GLfloat red,
        GLfloat green,
        GLfloat blue,
        GLfloat alpha,
    );
    alias PFN_glBlendEquation = void function (
        GLenum mode,
    );

    // Command pointers for GL_VERSION_1_5
    alias PFN_glGenQueries = void function (
        GLsizei n,
        GLuint* ids,
    );
    alias PFN_glDeleteQueries = void function (
        GLsizei        n,
        const(GLuint)* ids,
    );
    alias PFN_glIsQuery = GLboolean function (
        GLuint id,
    );
    alias PFN_glBeginQuery = void function (
        GLenum target,
        GLuint id,
    );
    alias PFN_glEndQuery = void function (
        GLenum target,
    );
    alias PFN_glGetQueryiv = void function (
        GLenum target,
        GLenum pname,
        GLint* params,
    );
    alias PFN_glGetQueryObjectiv = void function (
        GLuint id,
        GLenum pname,
        GLint* params,
    );
    alias PFN_glGetQueryObjectuiv = void function (
        GLuint  id,
        GLenum  pname,
        GLuint* params,
    );
    alias PFN_glBindBuffer = void function (
        GLenum target,
        GLuint buffer,
    );
    alias PFN_glDeleteBuffers = void function (
        GLsizei        n,
        const(GLuint)* buffers,
    );
    alias PFN_glGenBuffers = void function (
        GLsizei n,
        GLuint* buffers,
    );
    alias PFN_glIsBuffer = GLboolean function (
        GLuint buffer,
    );
    alias PFN_glBufferData = void function (
        GLenum       target,
        GLsizeiptr   size,
        const(void)* data,
        GLenum       usage,
    );
    alias PFN_glBufferSubData = void function (
        GLenum       target,
        GLintptr     offset,
        GLsizeiptr   size,
        const(void)* data,
    );
    alias PFN_glGetBufferSubData = void function (
        GLenum     target,
        GLintptr   offset,
        GLsizeiptr size,
        void*      data,
    );
    alias PFN_glMapBuffer = void * function (
        GLenum target,
        GLenum access,
    );
    alias PFN_glUnmapBuffer = GLboolean function (
        GLenum target,
    );
    alias PFN_glGetBufferParameteriv = void function (
        GLenum target,
        GLenum pname,
        GLint* params,
    );
    alias PFN_glGetBufferPointerv = void function (
        GLenum target,
        GLenum pname,
        void** params,
    );

    // Command pointers for GL_VERSION_2_0
    alias PFN_glBlendEquationSeparate = void function (
        GLenum modeRGB,
        GLenum modeAlpha,
    );
    alias PFN_glDrawBuffers = void function (
        GLsizei        n,
        const(GLenum)* bufs,
    );
    alias PFN_glStencilOpSeparate = void function (
        GLenum face,
        GLenum sfail,
        GLenum dpfail,
        GLenum dppass,
    );
    alias PFN_glStencilFuncSeparate = void function (
        GLenum face,
        GLenum func,
        GLint  ref_,
        GLuint mask,
    );
    alias PFN_glStencilMaskSeparate = void function (
        GLenum face,
        GLuint mask,
    );
    alias PFN_glAttachShader = void function (
        GLuint program,
        GLuint shader,
    );
    alias PFN_glBindAttribLocation = void function (
        GLuint         program,
        GLuint         index,
        const(GLchar)* name,
    );
    alias PFN_glCompileShader = void function (
        GLuint shader,
    );
    alias PFN_glCreateProgram = GLuint function ();
    alias PFN_glCreateShader = GLuint function (
        GLenum type,
    );
    alias PFN_glDeleteProgram = void function (
        GLuint program,
    );
    alias PFN_glDeleteShader = void function (
        GLuint shader,
    );
    alias PFN_glDetachShader = void function (
        GLuint program,
        GLuint shader,
    );
    alias PFN_glDisableVertexAttribArray = void function (
        GLuint index,
    );
    alias PFN_glEnableVertexAttribArray = void function (
        GLuint index,
    );
    alias PFN_glGetActiveAttrib = void function (
        GLuint   program,
        GLuint   index,
        GLsizei  bufSize,
        GLsizei* length,
        GLint*   size,
        GLenum*  type,
        GLchar*  name,
    );
    alias PFN_glGetActiveUniform = void function (
        GLuint   program,
        GLuint   index,
        GLsizei  bufSize,
        GLsizei* length,
        GLint*   size,
        GLenum*  type,
        GLchar*  name,
    );
    alias PFN_glGetAttachedShaders = void function (
        GLuint   program,
        GLsizei  maxCount,
        GLsizei* count,
        GLuint*  shaders,
    );
    alias PFN_glGetAttribLocation = GLint function (
        GLuint         program,
        const(GLchar)* name,
    );
    alias PFN_glGetProgramiv = void function (
        GLuint program,
        GLenum pname,
        GLint* params,
    );
    alias PFN_glGetProgramInfoLog = void function (
        GLuint   program,
        GLsizei  bufSize,
        GLsizei* length,
        GLchar*  infoLog,
    );
    alias PFN_glGetShaderiv = void function (
        GLuint shader,
        GLenum pname,
        GLint* params,
    );
    alias PFN_glGetShaderInfoLog = void function (
        GLuint   shader,
        GLsizei  bufSize,
        GLsizei* length,
        GLchar*  infoLog,
    );
    alias PFN_glGetShaderSource = void function (
        GLuint   shader,
        GLsizei  bufSize,
        GLsizei* length,
        GLchar*  source,
    );
    alias PFN_glGetUniformLocation = GLint function (
        GLuint         program,
        const(GLchar)* name,
    );
    alias PFN_glGetUniformfv = void function (
        GLuint   program,
        GLint    location,
        GLfloat* params,
    );
    alias PFN_glGetUniformiv = void function (
        GLuint program,
        GLint  location,
        GLint* params,
    );
    alias PFN_glGetVertexAttribdv = void function (
        GLuint    index,
        GLenum    pname,
        GLdouble* params,
    );
    alias PFN_glGetVertexAttribfv = void function (
        GLuint   index,
        GLenum   pname,
        GLfloat* params,
    );
    alias PFN_glGetVertexAttribiv = void function (
        GLuint index,
        GLenum pname,
        GLint* params,
    );
    alias PFN_glGetVertexAttribPointerv = void function (
        GLuint index,
        GLenum pname,
        void** pointer,
    );
    alias PFN_glIsProgram = GLboolean function (
        GLuint program,
    );
    alias PFN_glIsShader = GLboolean function (
        GLuint shader,
    );
    alias PFN_glLinkProgram = void function (
        GLuint program,
    );
    alias PFN_glShaderSource = void function (
        GLuint          shader,
        GLsizei         count,
        const(GLchar*)* string,
        const(GLint)*   length,
    );
    alias PFN_glUseProgram = void function (
        GLuint program,
    );
    alias PFN_glUniform1f = void function (
        GLint   location,
        GLfloat v0,
    );
    alias PFN_glUniform2f = void function (
        GLint   location,
        GLfloat v0,
        GLfloat v1,
    );
    alias PFN_glUniform3f = void function (
        GLint   location,
        GLfloat v0,
        GLfloat v1,
        GLfloat v2,
    );
    alias PFN_glUniform4f = void function (
        GLint   location,
        GLfloat v0,
        GLfloat v1,
        GLfloat v2,
        GLfloat v3,
    );
    alias PFN_glUniform1i = void function (
        GLint location,
        GLint v0,
    );
    alias PFN_glUniform2i = void function (
        GLint location,
        GLint v0,
        GLint v1,
    );
    alias PFN_glUniform3i = void function (
        GLint location,
        GLint v0,
        GLint v1,
        GLint v2,
    );
    alias PFN_glUniform4i = void function (
        GLint location,
        GLint v0,
        GLint v1,
        GLint v2,
        GLint v3,
    );
    alias PFN_glUniform1fv = void function (
        GLint           location,
        GLsizei         count,
        const(GLfloat)* value,
    );
    alias PFN_glUniform2fv = void function (
        GLint           location,
        GLsizei         count,
        const(GLfloat)* value,
    );
    alias PFN_glUniform3fv = void function (
        GLint           location,
        GLsizei         count,
        const(GLfloat)* value,
    );
    alias PFN_glUniform4fv = void function (
        GLint           location,
        GLsizei         count,
        const(GLfloat)* value,
    );
    alias PFN_glUniform1iv = void function (
        GLint         location,
        GLsizei       count,
        const(GLint)* value,
    );
    alias PFN_glUniform2iv = void function (
        GLint         location,
        GLsizei       count,
        const(GLint)* value,
    );
    alias PFN_glUniform3iv = void function (
        GLint         location,
        GLsizei       count,
        const(GLint)* value,
    );
    alias PFN_glUniform4iv = void function (
        GLint         location,
        GLsizei       count,
        const(GLint)* value,
    );
    alias PFN_glUniformMatrix2fv = void function (
        GLint           location,
        GLsizei         count,
        GLboolean       transpose,
        const(GLfloat)* value,
    );
    alias PFN_glUniformMatrix3fv = void function (
        GLint           location,
        GLsizei         count,
        GLboolean       transpose,
        const(GLfloat)* value,
    );
    alias PFN_glUniformMatrix4fv = void function (
        GLint           location,
        GLsizei         count,
        GLboolean       transpose,
        const(GLfloat)* value,
    );
    alias PFN_glValidateProgram = void function (
        GLuint program,
    );
    alias PFN_glVertexAttrib1d = void function (
        GLuint   index,
        GLdouble x,
    );
    alias PFN_glVertexAttrib1dv = void function (
        GLuint           index,
        const(GLdouble)* v,
    );
    alias PFN_glVertexAttrib1f = void function (
        GLuint  index,
        GLfloat x,
    );
    alias PFN_glVertexAttrib1fv = void function (
        GLuint          index,
        const(GLfloat)* v,
    );
    alias PFN_glVertexAttrib1s = void function (
        GLuint  index,
        GLshort x,
    );
    alias PFN_glVertexAttrib1sv = void function (
        GLuint          index,
        const(GLshort)* v,
    );
    alias PFN_glVertexAttrib2d = void function (
        GLuint   index,
        GLdouble x,
        GLdouble y,
    );
    alias PFN_glVertexAttrib2dv = void function (
        GLuint           index,
        const(GLdouble)* v,
    );
    alias PFN_glVertexAttrib2f = void function (
        GLuint  index,
        GLfloat x,
        GLfloat y,
    );
    alias PFN_glVertexAttrib2fv = void function (
        GLuint          index,
        const(GLfloat)* v,
    );
    alias PFN_glVertexAttrib2s = void function (
        GLuint  index,
        GLshort x,
        GLshort y,
    );
    alias PFN_glVertexAttrib2sv = void function (
        GLuint          index,
        const(GLshort)* v,
    );
    alias PFN_glVertexAttrib3d = void function (
        GLuint   index,
        GLdouble x,
        GLdouble y,
        GLdouble z,
    );
    alias PFN_glVertexAttrib3dv = void function (
        GLuint           index,
        const(GLdouble)* v,
    );
    alias PFN_glVertexAttrib3f = void function (
        GLuint  index,
        GLfloat x,
        GLfloat y,
        GLfloat z,
    );
    alias PFN_glVertexAttrib3fv = void function (
        GLuint          index,
        const(GLfloat)* v,
    );
    alias PFN_glVertexAttrib3s = void function (
        GLuint  index,
        GLshort x,
        GLshort y,
        GLshort z,
    );
    alias PFN_glVertexAttrib3sv = void function (
        GLuint          index,
        const(GLshort)* v,
    );
    alias PFN_glVertexAttrib4Nbv = void function (
        GLuint         index,
        const(GLbyte)* v,
    );
    alias PFN_glVertexAttrib4Niv = void function (
        GLuint        index,
        const(GLint)* v,
    );
    alias PFN_glVertexAttrib4Nsv = void function (
        GLuint          index,
        const(GLshort)* v,
    );
    alias PFN_glVertexAttrib4Nub = void function (
        GLuint  index,
        GLubyte x,
        GLubyte y,
        GLubyte z,
        GLubyte w,
    );
    alias PFN_glVertexAttrib4Nubv = void function (
        GLuint          index,
        const(GLubyte)* v,
    );
    alias PFN_glVertexAttrib4Nuiv = void function (
        GLuint         index,
        const(GLuint)* v,
    );
    alias PFN_glVertexAttrib4Nusv = void function (
        GLuint           index,
        const(GLushort)* v,
    );
    alias PFN_glVertexAttrib4bv = void function (
        GLuint         index,
        const(GLbyte)* v,
    );
    alias PFN_glVertexAttrib4d = void function (
        GLuint   index,
        GLdouble x,
        GLdouble y,
        GLdouble z,
        GLdouble w,
    );
    alias PFN_glVertexAttrib4dv = void function (
        GLuint           index,
        const(GLdouble)* v,
    );
    alias PFN_glVertexAttrib4f = void function (
        GLuint  index,
        GLfloat x,
        GLfloat y,
        GLfloat z,
        GLfloat w,
    );
    alias PFN_glVertexAttrib4fv = void function (
        GLuint          index,
        const(GLfloat)* v,
    );
    alias PFN_glVertexAttrib4iv = void function (
        GLuint        index,
        const(GLint)* v,
    );
    alias PFN_glVertexAttrib4s = void function (
        GLuint  index,
        GLshort x,
        GLshort y,
        GLshort z,
        GLshort w,
    );
    alias PFN_glVertexAttrib4sv = void function (
        GLuint          index,
        const(GLshort)* v,
    );
    alias PFN_glVertexAttrib4ubv = void function (
        GLuint          index,
        const(GLubyte)* v,
    );
    alias PFN_glVertexAttrib4uiv = void function (
        GLuint         index,
        const(GLuint)* v,
    );
    alias PFN_glVertexAttrib4usv = void function (
        GLuint           index,
        const(GLushort)* v,
    );
    alias PFN_glVertexAttribPointer = void function (
        GLuint       index,
        GLint        size,
        GLenum       type,
        GLboolean    normalized,
        GLsizei      stride,
        const(void)* pointer,
    );

    // Command pointers for GL_VERSION_2_1
    alias PFN_glUniformMatrix2x3fv = void function (
        GLint           location,
        GLsizei         count,
        GLboolean       transpose,
        const(GLfloat)* value,
    );
    alias PFN_glUniformMatrix3x2fv = void function (
        GLint           location,
        GLsizei         count,
        GLboolean       transpose,
        const(GLfloat)* value,
    );
    alias PFN_glUniformMatrix2x4fv = void function (
        GLint           location,
        GLsizei         count,
        GLboolean       transpose,
        const(GLfloat)* value,
    );
    alias PFN_glUniformMatrix4x2fv = void function (
        GLint           location,
        GLsizei         count,
        GLboolean       transpose,
        const(GLfloat)* value,
    );
    alias PFN_glUniformMatrix3x4fv = void function (
        GLint           location,
        GLsizei         count,
        GLboolean       transpose,
        const(GLfloat)* value,
    );
    alias PFN_glUniformMatrix4x3fv = void function (
        GLint           location,
        GLsizei         count,
        GLboolean       transpose,
        const(GLfloat)* value,
    );

    // Command pointers for GL_VERSION_3_0
    alias PFN_glColorMaski = void function (
        GLuint    index,
        GLboolean r,
        GLboolean g,
        GLboolean b,
        GLboolean a,
    );
    alias PFN_glGetBooleani_v = void function (
        GLenum     target,
        GLuint     index,
        GLboolean* data,
    );
    alias PFN_glGetIntegeri_v = void function (
        GLenum target,
        GLuint index,
        GLint* data,
    );
    alias PFN_glEnablei = void function (
        GLenum target,
        GLuint index,
    );
    alias PFN_glDisablei = void function (
        GLenum target,
        GLuint index,
    );
    alias PFN_glIsEnabledi = GLboolean function (
        GLenum target,
        GLuint index,
    );
    alias PFN_glBeginTransformFeedback = void function (
        GLenum primitiveMode,
    );
    alias PFN_glEndTransformFeedback = void function ();
    alias PFN_glBindBufferRange = void function (
        GLenum     target,
        GLuint     index,
        GLuint     buffer,
        GLintptr   offset,
        GLsizeiptr size,
    );
    alias PFN_glBindBufferBase = void function (
        GLenum target,
        GLuint index,
        GLuint buffer,
    );
    alias PFN_glTransformFeedbackVaryings = void function (
        GLuint          program,
        GLsizei         count,
        const(GLchar*)* varyings,
        GLenum          bufferMode,
    );
    alias PFN_glGetTransformFeedbackVarying = void function (
        GLuint   program,
        GLuint   index,
        GLsizei  bufSize,
        GLsizei* length,
        GLsizei* size,
        GLenum*  type,
        GLchar*  name,
    );
    alias PFN_glClampColor = void function (
        GLenum target,
        GLenum clamp,
    );
    alias PFN_glBeginConditionalRender = void function (
        GLuint id,
        GLenum mode,
    );
    alias PFN_glEndConditionalRender = void function ();
    alias PFN_glVertexAttribIPointer = void function (
        GLuint       index,
        GLint        size,
        GLenum       type,
        GLsizei      stride,
        const(void)* pointer,
    );
    alias PFN_glGetVertexAttribIiv = void function (
        GLuint index,
        GLenum pname,
        GLint* params,
    );
    alias PFN_glGetVertexAttribIuiv = void function (
        GLuint  index,
        GLenum  pname,
        GLuint* params,
    );
    alias PFN_glVertexAttribI1i = void function (
        GLuint index,
        GLint  x,
    );
    alias PFN_glVertexAttribI2i = void function (
        GLuint index,
        GLint  x,
        GLint  y,
    );
    alias PFN_glVertexAttribI3i = void function (
        GLuint index,
        GLint  x,
        GLint  y,
        GLint  z,
    );
    alias PFN_glVertexAttribI4i = void function (
        GLuint index,
        GLint  x,
        GLint  y,
        GLint  z,
        GLint  w,
    );
    alias PFN_glVertexAttribI1ui = void function (
        GLuint index,
        GLuint x,
    );
    alias PFN_glVertexAttribI2ui = void function (
        GLuint index,
        GLuint x,
        GLuint y,
    );
    alias PFN_glVertexAttribI3ui = void function (
        GLuint index,
        GLuint x,
        GLuint y,
        GLuint z,
    );
    alias PFN_glVertexAttribI4ui = void function (
        GLuint index,
        GLuint x,
        GLuint y,
        GLuint z,
        GLuint w,
    );
    alias PFN_glVertexAttribI1iv = void function (
        GLuint        index,
        const(GLint)* v,
    );
    alias PFN_glVertexAttribI2iv = void function (
        GLuint        index,
        const(GLint)* v,
    );
    alias PFN_glVertexAttribI3iv = void function (
        GLuint        index,
        const(GLint)* v,
    );
    alias PFN_glVertexAttribI4iv = void function (
        GLuint        index,
        const(GLint)* v,
    );
    alias PFN_glVertexAttribI1uiv = void function (
        GLuint         index,
        const(GLuint)* v,
    );
    alias PFN_glVertexAttribI2uiv = void function (
        GLuint         index,
        const(GLuint)* v,
    );
    alias PFN_glVertexAttribI3uiv = void function (
        GLuint         index,
        const(GLuint)* v,
    );
    alias PFN_glVertexAttribI4uiv = void function (
        GLuint         index,
        const(GLuint)* v,
    );
    alias PFN_glVertexAttribI4bv = void function (
        GLuint         index,
        const(GLbyte)* v,
    );
    alias PFN_glVertexAttribI4sv = void function (
        GLuint          index,
        const(GLshort)* v,
    );
    alias PFN_glVertexAttribI4ubv = void function (
        GLuint          index,
        const(GLubyte)* v,
    );
    alias PFN_glVertexAttribI4usv = void function (
        GLuint           index,
        const(GLushort)* v,
    );
    alias PFN_glGetUniformuiv = void function (
        GLuint  program,
        GLint   location,
        GLuint* params,
    );
    alias PFN_glBindFragDataLocation = void function (
        GLuint         program,
        GLuint         color,
        const(GLchar)* name,
    );
    alias PFN_glGetFragDataLocation = GLint function (
        GLuint         program,
        const(GLchar)* name,
    );
    alias PFN_glUniform1ui = void function (
        GLint  location,
        GLuint v0,
    );
    alias PFN_glUniform2ui = void function (
        GLint  location,
        GLuint v0,
        GLuint v1,
    );
    alias PFN_glUniform3ui = void function (
        GLint  location,
        GLuint v0,
        GLuint v1,
        GLuint v2,
    );
    alias PFN_glUniform4ui = void function (
        GLint  location,
        GLuint v0,
        GLuint v1,
        GLuint v2,
        GLuint v3,
    );
    alias PFN_glUniform1uiv = void function (
        GLint          location,
        GLsizei        count,
        const(GLuint)* value,
    );
    alias PFN_glUniform2uiv = void function (
        GLint          location,
        GLsizei        count,
        const(GLuint)* value,
    );
    alias PFN_glUniform3uiv = void function (
        GLint          location,
        GLsizei        count,
        const(GLuint)* value,
    );
    alias PFN_glUniform4uiv = void function (
        GLint          location,
        GLsizei        count,
        const(GLuint)* value,
    );
    alias PFN_glTexParameterIiv = void function (
        GLenum        target,
        GLenum        pname,
        const(GLint)* params,
    );
    alias PFN_glTexParameterIuiv = void function (
        GLenum         target,
        GLenum         pname,
        const(GLuint)* params,
    );
    alias PFN_glGetTexParameterIiv = void function (
        GLenum target,
        GLenum pname,
        GLint* params,
    );
    alias PFN_glGetTexParameterIuiv = void function (
        GLenum  target,
        GLenum  pname,
        GLuint* params,
    );
    alias PFN_glClearBufferiv = void function (
        GLenum        buffer,
        GLint         drawbuffer,
        const(GLint)* value,
    );
    alias PFN_glClearBufferuiv = void function (
        GLenum         buffer,
        GLint          drawbuffer,
        const(GLuint)* value,
    );
    alias PFN_glClearBufferfv = void function (
        GLenum          buffer,
        GLint           drawbuffer,
        const(GLfloat)* value,
    );
    alias PFN_glClearBufferfi = void function (
        GLenum  buffer,
        GLint   drawbuffer,
        GLfloat depth,
        GLint   stencil,
    );
    alias PFN_glGetStringi = const(GLubyte)* function (
        GLenum name,
        GLuint index,
    );
    alias PFN_glIsRenderbuffer = GLboolean function (
        GLuint renderbuffer,
    );
    alias PFN_glBindRenderbuffer = void function (
        GLenum target,
        GLuint renderbuffer,
    );
    alias PFN_glDeleteRenderbuffers = void function (
        GLsizei        n,
        const(GLuint)* renderbuffers,
    );
    alias PFN_glGenRenderbuffers = void function (
        GLsizei n,
        GLuint* renderbuffers,
    );
    alias PFN_glRenderbufferStorage = void function (
        GLenum  target,
        GLenum  internalformat,
        GLsizei width,
        GLsizei height,
    );
    alias PFN_glGetRenderbufferParameteriv = void function (
        GLenum target,
        GLenum pname,
        GLint* params,
    );
    alias PFN_glIsFramebuffer = GLboolean function (
        GLuint framebuffer,
    );
    alias PFN_glBindFramebuffer = void function (
        GLenum target,
        GLuint framebuffer,
    );
    alias PFN_glDeleteFramebuffers = void function (
        GLsizei        n,
        const(GLuint)* framebuffers,
    );
    alias PFN_glGenFramebuffers = void function (
        GLsizei n,
        GLuint* framebuffers,
    );
    alias PFN_glCheckFramebufferStatus = GLenum function (
        GLenum target,
    );
    alias PFN_glFramebufferTexture1D = void function (
        GLenum target,
        GLenum attachment,
        GLenum textarget,
        GLuint texture,
        GLint  level,
    );
    alias PFN_glFramebufferTexture2D = void function (
        GLenum target,
        GLenum attachment,
        GLenum textarget,
        GLuint texture,
        GLint  level,
    );
    alias PFN_glFramebufferTexture3D = void function (
        GLenum target,
        GLenum attachment,
        GLenum textarget,
        GLuint texture,
        GLint  level,
        GLint  zoffset,
    );
    alias PFN_glFramebufferRenderbuffer = void function (
        GLenum target,
        GLenum attachment,
        GLenum renderbuffertarget,
        GLuint renderbuffer,
    );
    alias PFN_glGetFramebufferAttachmentParameteriv = void function (
        GLenum target,
        GLenum attachment,
        GLenum pname,
        GLint* params,
    );
    alias PFN_glGenerateMipmap = void function (
        GLenum target,
    );
    alias PFN_glBlitFramebuffer = void function (
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
    alias PFN_glRenderbufferStorageMultisample = void function (
        GLenum  target,
        GLsizei samples,
        GLenum  internalformat,
        GLsizei width,
        GLsizei height,
    );
    alias PFN_glFramebufferTextureLayer = void function (
        GLenum target,
        GLenum attachment,
        GLuint texture,
        GLint  level,
        GLint  layer,
    );
    alias PFN_glMapBufferRange = void * function (
        GLenum     target,
        GLintptr   offset,
        GLsizeiptr length,
        GLbitfield access,
    );
    alias PFN_glFlushMappedBufferRange = void function (
        GLenum     target,
        GLintptr   offset,
        GLsizeiptr length,
    );
    alias PFN_glBindVertexArray = void function (
        GLuint array,
    );
    alias PFN_glDeleteVertexArrays = void function (
        GLsizei        n,
        const(GLuint)* arrays,
    );
    alias PFN_glGenVertexArrays = void function (
        GLsizei n,
        GLuint* arrays,
    );
    alias PFN_glIsVertexArray = GLboolean function (
        GLuint array,
    );

    // Command pointers for GL_VERSION_3_1
    alias PFN_glDrawArraysInstanced = void function (
        GLenum  mode,
        GLint   first,
        GLsizei count,
        GLsizei instancecount,
    );
    alias PFN_glDrawElementsInstanced = void function (
        GLenum       mode,
        GLsizei      count,
        GLenum       type,
        const(void)* indices,
        GLsizei      instancecount,
    );
    alias PFN_glTexBuffer = void function (
        GLenum target,
        GLenum internalformat,
        GLuint buffer,
    );
    alias PFN_glPrimitiveRestartIndex = void function (
        GLuint index,
    );
    alias PFN_glCopyBufferSubData = void function (
        GLenum     readTarget,
        GLenum     writeTarget,
        GLintptr   readOffset,
        GLintptr   writeOffset,
        GLsizeiptr size,
    );
    alias PFN_glGetUniformIndices = void function (
        GLuint          program,
        GLsizei         uniformCount,
        const(GLchar*)* uniformNames,
        GLuint*         uniformIndices,
    );
    alias PFN_glGetActiveUniformsiv = void function (
        GLuint         program,
        GLsizei        uniformCount,
        const(GLuint)* uniformIndices,
        GLenum         pname,
        GLint*         params,
    );
    alias PFN_glGetActiveUniformName = void function (
        GLuint   program,
        GLuint   uniformIndex,
        GLsizei  bufSize,
        GLsizei* length,
        GLchar*  uniformName,
    );
    alias PFN_glGetUniformBlockIndex = GLuint function (
        GLuint         program,
        const(GLchar)* uniformBlockName,
    );
    alias PFN_glGetActiveUniformBlockiv = void function (
        GLuint program,
        GLuint uniformBlockIndex,
        GLenum pname,
        GLint* params,
    );
    alias PFN_glGetActiveUniformBlockName = void function (
        GLuint   program,
        GLuint   uniformBlockIndex,
        GLsizei  bufSize,
        GLsizei* length,
        GLchar*  uniformBlockName,
    );
    alias PFN_glUniformBlockBinding = void function (
        GLuint program,
        GLuint uniformBlockIndex,
        GLuint uniformBlockBinding,
    );

    // Command pointers for GL_VERSION_3_2
    alias PFN_glDrawElementsBaseVertex = void function (
        GLenum       mode,
        GLsizei      count,
        GLenum       type,
        const(void)* indices,
        GLint        basevertex,
    );
    alias PFN_glDrawRangeElementsBaseVertex = void function (
        GLenum       mode,
        GLuint       start,
        GLuint       end,
        GLsizei      count,
        GLenum       type,
        const(void)* indices,
        GLint        basevertex,
    );
    alias PFN_glDrawElementsInstancedBaseVertex = void function (
        GLenum       mode,
        GLsizei      count,
        GLenum       type,
        const(void)* indices,
        GLsizei      instancecount,
        GLint        basevertex,
    );
    alias PFN_glMultiDrawElementsBaseVertex = void function (
        GLenum          mode,
        const(GLsizei)* count,
        GLenum          type,
        const(void*)*   indices,
        GLsizei         drawcount,
        const(GLint)*   basevertex,
    );
    alias PFN_glProvokingVertex = void function (
        GLenum mode,
    );
    alias PFN_glFenceSync = GLsync function (
        GLenum     condition,
        GLbitfield flags,
    );
    alias PFN_glIsSync = GLboolean function (
        GLsync sync,
    );
    alias PFN_glDeleteSync = void function (
        GLsync sync,
    );
    alias PFN_glClientWaitSync = GLenum function (
        GLsync     sync,
        GLbitfield flags,
        GLuint64   timeout,
    );
    alias PFN_glWaitSync = void function (
        GLsync     sync,
        GLbitfield flags,
        GLuint64   timeout,
    );
    alias PFN_glGetInteger64v = void function (
        GLenum   pname,
        GLint64* data,
    );
    alias PFN_glGetSynciv = void function (
        GLsync   sync,
        GLenum   pname,
        GLsizei  bufSize,
        GLsizei* length,
        GLint*   values,
    );
    alias PFN_glGetInteger64i_v = void function (
        GLenum   target,
        GLuint   index,
        GLint64* data,
    );
    alias PFN_glGetBufferParameteri64v = void function (
        GLenum   target,
        GLenum   pname,
        GLint64* params,
    );
    alias PFN_glFramebufferTexture = void function (
        GLenum target,
        GLenum attachment,
        GLuint texture,
        GLint  level,
    );
    alias PFN_glTexImage2DMultisample = void function (
        GLenum    target,
        GLsizei   samples,
        GLenum    internalformat,
        GLsizei   width,
        GLsizei   height,
        GLboolean fixedsamplelocations,
    );
    alias PFN_glTexImage3DMultisample = void function (
        GLenum    target,
        GLsizei   samples,
        GLenum    internalformat,
        GLsizei   width,
        GLsizei   height,
        GLsizei   depth,
        GLboolean fixedsamplelocations,
    );
    alias PFN_glGetMultisamplefv = void function (
        GLenum   pname,
        GLuint   index,
        GLfloat* val,
    );
    alias PFN_glSampleMaski = void function (
        GLuint     maskNumber,
        GLbitfield mask,
    );

    // Command pointers for GL_VERSION_3_3
    alias PFN_glBindFragDataLocationIndexed = void function (
        GLuint         program,
        GLuint         colorNumber,
        GLuint         index,
        const(GLchar)* name,
    );
    alias PFN_glGetFragDataIndex = GLint function (
        GLuint         program,
        const(GLchar)* name,
    );
    alias PFN_glGenSamplers = void function (
        GLsizei count,
        GLuint* samplers,
    );
    alias PFN_glDeleteSamplers = void function (
        GLsizei        count,
        const(GLuint)* samplers,
    );
    alias PFN_glIsSampler = GLboolean function (
        GLuint sampler,
    );
    alias PFN_glBindSampler = void function (
        GLuint unit,
        GLuint sampler,
    );
    alias PFN_glSamplerParameteri = void function (
        GLuint sampler,
        GLenum pname,
        GLint  param,
    );
    alias PFN_glSamplerParameteriv = void function (
        GLuint        sampler,
        GLenum        pname,
        const(GLint)* param,
    );
    alias PFN_glSamplerParameterf = void function (
        GLuint  sampler,
        GLenum  pname,
        GLfloat param,
    );
    alias PFN_glSamplerParameterfv = void function (
        GLuint          sampler,
        GLenum          pname,
        const(GLfloat)* param,
    );
    alias PFN_glSamplerParameterIiv = void function (
        GLuint        sampler,
        GLenum        pname,
        const(GLint)* param,
    );
    alias PFN_glSamplerParameterIuiv = void function (
        GLuint         sampler,
        GLenum         pname,
        const(GLuint)* param,
    );
    alias PFN_glGetSamplerParameteriv = void function (
        GLuint sampler,
        GLenum pname,
        GLint* params,
    );
    alias PFN_glGetSamplerParameterIiv = void function (
        GLuint sampler,
        GLenum pname,
        GLint* params,
    );
    alias PFN_glGetSamplerParameterfv = void function (
        GLuint   sampler,
        GLenum   pname,
        GLfloat* params,
    );
    alias PFN_glGetSamplerParameterIuiv = void function (
        GLuint  sampler,
        GLenum  pname,
        GLuint* params,
    );
    alias PFN_glQueryCounter = void function (
        GLuint id,
        GLenum target,
    );
    alias PFN_glGetQueryObjecti64v = void function (
        GLuint   id,
        GLenum   pname,
        GLint64* params,
    );
    alias PFN_glGetQueryObjectui64v = void function (
        GLuint    id,
        GLenum    pname,
        GLuint64* params,
    );
    alias PFN_glVertexAttribDivisor = void function (
        GLuint index,
        GLuint divisor,
    );
    alias PFN_glVertexAttribP1ui = void function (
        GLuint    index,
        GLenum    type,
        GLboolean normalized,
        GLuint    value,
    );
    alias PFN_glVertexAttribP1uiv = void function (
        GLuint         index,
        GLenum         type,
        GLboolean      normalized,
        const(GLuint)* value,
    );
    alias PFN_glVertexAttribP2ui = void function (
        GLuint    index,
        GLenum    type,
        GLboolean normalized,
        GLuint    value,
    );
    alias PFN_glVertexAttribP2uiv = void function (
        GLuint         index,
        GLenum         type,
        GLboolean      normalized,
        const(GLuint)* value,
    );
    alias PFN_glVertexAttribP3ui = void function (
        GLuint    index,
        GLenum    type,
        GLboolean normalized,
        GLuint    value,
    );
    alias PFN_glVertexAttribP3uiv = void function (
        GLuint         index,
        GLenum         type,
        GLboolean      normalized,
        const(GLuint)* value,
    );
    alias PFN_glVertexAttribP4ui = void function (
        GLuint    index,
        GLenum    type,
        GLboolean normalized,
        GLuint    value,
    );
    alias PFN_glVertexAttribP4uiv = void function (
        GLuint         index,
        GLenum         type,
        GLboolean      normalized,
        const(GLuint)* value,
    );

    // Command pointers for GL_VERSION_4_0
    alias PFN_glMinSampleShading = void function (
        GLfloat value,
    );
    alias PFN_glBlendEquationi = void function (
        GLuint buf,
        GLenum mode,
    );
    alias PFN_glBlendEquationSeparatei = void function (
        GLuint buf,
        GLenum modeRGB,
        GLenum modeAlpha,
    );
    alias PFN_glBlendFunci = void function (
        GLuint buf,
        GLenum src,
        GLenum dst,
    );
    alias PFN_glBlendFuncSeparatei = void function (
        GLuint buf,
        GLenum srcRGB,
        GLenum dstRGB,
        GLenum srcAlpha,
        GLenum dstAlpha,
    );
    alias PFN_glDrawArraysIndirect = void function (
        GLenum       mode,
        const(void)* indirect,
    );
    alias PFN_glDrawElementsIndirect = void function (
        GLenum       mode,
        GLenum       type,
        const(void)* indirect,
    );
    alias PFN_glUniform1d = void function (
        GLint    location,
        GLdouble x,
    );
    alias PFN_glUniform2d = void function (
        GLint    location,
        GLdouble x,
        GLdouble y,
    );
    alias PFN_glUniform3d = void function (
        GLint    location,
        GLdouble x,
        GLdouble y,
        GLdouble z,
    );
    alias PFN_glUniform4d = void function (
        GLint    location,
        GLdouble x,
        GLdouble y,
        GLdouble z,
        GLdouble w,
    );
    alias PFN_glUniform1dv = void function (
        GLint            location,
        GLsizei          count,
        const(GLdouble)* value,
    );
    alias PFN_glUniform2dv = void function (
        GLint            location,
        GLsizei          count,
        const(GLdouble)* value,
    );
    alias PFN_glUniform3dv = void function (
        GLint            location,
        GLsizei          count,
        const(GLdouble)* value,
    );
    alias PFN_glUniform4dv = void function (
        GLint            location,
        GLsizei          count,
        const(GLdouble)* value,
    );
    alias PFN_glUniformMatrix2dv = void function (
        GLint            location,
        GLsizei          count,
        GLboolean        transpose,
        const(GLdouble)* value,
    );
    alias PFN_glUniformMatrix3dv = void function (
        GLint            location,
        GLsizei          count,
        GLboolean        transpose,
        const(GLdouble)* value,
    );
    alias PFN_glUniformMatrix4dv = void function (
        GLint            location,
        GLsizei          count,
        GLboolean        transpose,
        const(GLdouble)* value,
    );
    alias PFN_glUniformMatrix2x3dv = void function (
        GLint            location,
        GLsizei          count,
        GLboolean        transpose,
        const(GLdouble)* value,
    );
    alias PFN_glUniformMatrix2x4dv = void function (
        GLint            location,
        GLsizei          count,
        GLboolean        transpose,
        const(GLdouble)* value,
    );
    alias PFN_glUniformMatrix3x2dv = void function (
        GLint            location,
        GLsizei          count,
        GLboolean        transpose,
        const(GLdouble)* value,
    );
    alias PFN_glUniformMatrix3x4dv = void function (
        GLint            location,
        GLsizei          count,
        GLboolean        transpose,
        const(GLdouble)* value,
    );
    alias PFN_glUniformMatrix4x2dv = void function (
        GLint            location,
        GLsizei          count,
        GLboolean        transpose,
        const(GLdouble)* value,
    );
    alias PFN_glUniformMatrix4x3dv = void function (
        GLint            location,
        GLsizei          count,
        GLboolean        transpose,
        const(GLdouble)* value,
    );
    alias PFN_glGetUniformdv = void function (
        GLuint    program,
        GLint     location,
        GLdouble* params,
    );
    alias PFN_glGetSubroutineUniformLocation = GLint function (
        GLuint         program,
        GLenum         shadertype,
        const(GLchar)* name,
    );
    alias PFN_glGetSubroutineIndex = GLuint function (
        GLuint         program,
        GLenum         shadertype,
        const(GLchar)* name,
    );
    alias PFN_glGetActiveSubroutineUniformiv = void function (
        GLuint program,
        GLenum shadertype,
        GLuint index,
        GLenum pname,
        GLint* values,
    );
    alias PFN_glGetActiveSubroutineUniformName = void function (
        GLuint   program,
        GLenum   shadertype,
        GLuint   index,
        GLsizei  bufsize,
        GLsizei* length,
        GLchar*  name,
    );
    alias PFN_glGetActiveSubroutineName = void function (
        GLuint   program,
        GLenum   shadertype,
        GLuint   index,
        GLsizei  bufsize,
        GLsizei* length,
        GLchar*  name,
    );
    alias PFN_glUniformSubroutinesuiv = void function (
        GLenum         shadertype,
        GLsizei        count,
        const(GLuint)* indices,
    );
    alias PFN_glGetUniformSubroutineuiv = void function (
        GLenum  shadertype,
        GLint   location,
        GLuint* params,
    );
    alias PFN_glGetProgramStageiv = void function (
        GLuint program,
        GLenum shadertype,
        GLenum pname,
        GLint* values,
    );
    alias PFN_glPatchParameteri = void function (
        GLenum pname,
        GLint  value,
    );
    alias PFN_glPatchParameterfv = void function (
        GLenum          pname,
        const(GLfloat)* values,
    );
    alias PFN_glBindTransformFeedback = void function (
        GLenum target,
        GLuint id,
    );
    alias PFN_glDeleteTransformFeedbacks = void function (
        GLsizei        n,
        const(GLuint)* ids,
    );
    alias PFN_glGenTransformFeedbacks = void function (
        GLsizei n,
        GLuint* ids,
    );
    alias PFN_glIsTransformFeedback = GLboolean function (
        GLuint id,
    );
    alias PFN_glPauseTransformFeedback = void function ();
    alias PFN_glResumeTransformFeedback = void function ();
    alias PFN_glDrawTransformFeedback = void function (
        GLenum mode,
        GLuint id,
    );
    alias PFN_glDrawTransformFeedbackStream = void function (
        GLenum mode,
        GLuint id,
        GLuint stream,
    );
    alias PFN_glBeginQueryIndexed = void function (
        GLenum target,
        GLuint index,
        GLuint id,
    );
    alias PFN_glEndQueryIndexed = void function (
        GLenum target,
        GLuint index,
    );
    alias PFN_glGetQueryIndexediv = void function (
        GLenum target,
        GLuint index,
        GLenum pname,
        GLint* params,
    );

    // Command pointers for GL_VERSION_4_1
    alias PFN_glReleaseShaderCompiler = void function ();
    alias PFN_glShaderBinary = void function (
        GLsizei        count,
        const(GLuint)* shaders,
        GLenum         binaryformat,
        const(void)*   binary,
        GLsizei        length,
    );
    alias PFN_glGetShaderPrecisionFormat = void function (
        GLenum shadertype,
        GLenum precisiontype,
        GLint* range,
        GLint* precision,
    );
    alias PFN_glDepthRangef = void function (
        GLfloat n,
        GLfloat f,
    );
    alias PFN_glClearDepthf = void function (
        GLfloat d,
    );
    alias PFN_glGetProgramBinary = void function (
        GLuint   program,
        GLsizei  bufSize,
        GLsizei* length,
        GLenum*  binaryFormat,
        void*    binary,
    );
    alias PFN_glProgramBinary = void function (
        GLuint       program,
        GLenum       binaryFormat,
        const(void)* binary,
        GLsizei      length,
    );
    alias PFN_glProgramParameteri = void function (
        GLuint program,
        GLenum pname,
        GLint  value,
    );
    alias PFN_glUseProgramStages = void function (
        GLuint     pipeline,
        GLbitfield stages,
        GLuint     program,
    );
    alias PFN_glActiveShaderProgram = void function (
        GLuint pipeline,
        GLuint program,
    );
    alias PFN_glCreateShaderProgramv = GLuint function (
        GLenum          type,
        GLsizei         count,
        const(GLchar*)* strings,
    );
    alias PFN_glBindProgramPipeline = void function (
        GLuint pipeline,
    );
    alias PFN_glDeleteProgramPipelines = void function (
        GLsizei        n,
        const(GLuint)* pipelines,
    );
    alias PFN_glGenProgramPipelines = void function (
        GLsizei n,
        GLuint* pipelines,
    );
    alias PFN_glIsProgramPipeline = GLboolean function (
        GLuint pipeline,
    );
    alias PFN_glGetProgramPipelineiv = void function (
        GLuint pipeline,
        GLenum pname,
        GLint* params,
    );
    alias PFN_glProgramUniform1i = void function (
        GLuint program,
        GLint  location,
        GLint  v0,
    );
    alias PFN_glProgramUniform1iv = void function (
        GLuint        program,
        GLint         location,
        GLsizei       count,
        const(GLint)* value,
    );
    alias PFN_glProgramUniform1f = void function (
        GLuint  program,
        GLint   location,
        GLfloat v0,
    );
    alias PFN_glProgramUniform1fv = void function (
        GLuint          program,
        GLint           location,
        GLsizei         count,
        const(GLfloat)* value,
    );
    alias PFN_glProgramUniform1d = void function (
        GLuint   program,
        GLint    location,
        GLdouble v0,
    );
    alias PFN_glProgramUniform1dv = void function (
        GLuint           program,
        GLint            location,
        GLsizei          count,
        const(GLdouble)* value,
    );
    alias PFN_glProgramUniform1ui = void function (
        GLuint program,
        GLint  location,
        GLuint v0,
    );
    alias PFN_glProgramUniform1uiv = void function (
        GLuint         program,
        GLint          location,
        GLsizei        count,
        const(GLuint)* value,
    );
    alias PFN_glProgramUniform2i = void function (
        GLuint program,
        GLint  location,
        GLint  v0,
        GLint  v1,
    );
    alias PFN_glProgramUniform2iv = void function (
        GLuint        program,
        GLint         location,
        GLsizei       count,
        const(GLint)* value,
    );
    alias PFN_glProgramUniform2f = void function (
        GLuint  program,
        GLint   location,
        GLfloat v0,
        GLfloat v1,
    );
    alias PFN_glProgramUniform2fv = void function (
        GLuint          program,
        GLint           location,
        GLsizei         count,
        const(GLfloat)* value,
    );
    alias PFN_glProgramUniform2d = void function (
        GLuint   program,
        GLint    location,
        GLdouble v0,
        GLdouble v1,
    );
    alias PFN_glProgramUniform2dv = void function (
        GLuint           program,
        GLint            location,
        GLsizei          count,
        const(GLdouble)* value,
    );
    alias PFN_glProgramUniform2ui = void function (
        GLuint program,
        GLint  location,
        GLuint v0,
        GLuint v1,
    );
    alias PFN_glProgramUniform2uiv = void function (
        GLuint         program,
        GLint          location,
        GLsizei        count,
        const(GLuint)* value,
    );
    alias PFN_glProgramUniform3i = void function (
        GLuint program,
        GLint  location,
        GLint  v0,
        GLint  v1,
        GLint  v2,
    );
    alias PFN_glProgramUniform3iv = void function (
        GLuint        program,
        GLint         location,
        GLsizei       count,
        const(GLint)* value,
    );
    alias PFN_glProgramUniform3f = void function (
        GLuint  program,
        GLint   location,
        GLfloat v0,
        GLfloat v1,
        GLfloat v2,
    );
    alias PFN_glProgramUniform3fv = void function (
        GLuint          program,
        GLint           location,
        GLsizei         count,
        const(GLfloat)* value,
    );
    alias PFN_glProgramUniform3d = void function (
        GLuint   program,
        GLint    location,
        GLdouble v0,
        GLdouble v1,
        GLdouble v2,
    );
    alias PFN_glProgramUniform3dv = void function (
        GLuint           program,
        GLint            location,
        GLsizei          count,
        const(GLdouble)* value,
    );
    alias PFN_glProgramUniform3ui = void function (
        GLuint program,
        GLint  location,
        GLuint v0,
        GLuint v1,
        GLuint v2,
    );
    alias PFN_glProgramUniform3uiv = void function (
        GLuint         program,
        GLint          location,
        GLsizei        count,
        const(GLuint)* value,
    );
    alias PFN_glProgramUniform4i = void function (
        GLuint program,
        GLint  location,
        GLint  v0,
        GLint  v1,
        GLint  v2,
        GLint  v3,
    );
    alias PFN_glProgramUniform4iv = void function (
        GLuint        program,
        GLint         location,
        GLsizei       count,
        const(GLint)* value,
    );
    alias PFN_glProgramUniform4f = void function (
        GLuint  program,
        GLint   location,
        GLfloat v0,
        GLfloat v1,
        GLfloat v2,
        GLfloat v3,
    );
    alias PFN_glProgramUniform4fv = void function (
        GLuint          program,
        GLint           location,
        GLsizei         count,
        const(GLfloat)* value,
    );
    alias PFN_glProgramUniform4d = void function (
        GLuint   program,
        GLint    location,
        GLdouble v0,
        GLdouble v1,
        GLdouble v2,
        GLdouble v3,
    );
    alias PFN_glProgramUniform4dv = void function (
        GLuint           program,
        GLint            location,
        GLsizei          count,
        const(GLdouble)* value,
    );
    alias PFN_glProgramUniform4ui = void function (
        GLuint program,
        GLint  location,
        GLuint v0,
        GLuint v1,
        GLuint v2,
        GLuint v3,
    );
    alias PFN_glProgramUniform4uiv = void function (
        GLuint         program,
        GLint          location,
        GLsizei        count,
        const(GLuint)* value,
    );
    alias PFN_glProgramUniformMatrix2fv = void function (
        GLuint          program,
        GLint           location,
        GLsizei         count,
        GLboolean       transpose,
        const(GLfloat)* value,
    );
    alias PFN_glProgramUniformMatrix3fv = void function (
        GLuint          program,
        GLint           location,
        GLsizei         count,
        GLboolean       transpose,
        const(GLfloat)* value,
    );
    alias PFN_glProgramUniformMatrix4fv = void function (
        GLuint          program,
        GLint           location,
        GLsizei         count,
        GLboolean       transpose,
        const(GLfloat)* value,
    );
    alias PFN_glProgramUniformMatrix2dv = void function (
        GLuint           program,
        GLint            location,
        GLsizei          count,
        GLboolean        transpose,
        const(GLdouble)* value,
    );
    alias PFN_glProgramUniformMatrix3dv = void function (
        GLuint           program,
        GLint            location,
        GLsizei          count,
        GLboolean        transpose,
        const(GLdouble)* value,
    );
    alias PFN_glProgramUniformMatrix4dv = void function (
        GLuint           program,
        GLint            location,
        GLsizei          count,
        GLboolean        transpose,
        const(GLdouble)* value,
    );
    alias PFN_glProgramUniformMatrix2x3fv = void function (
        GLuint          program,
        GLint           location,
        GLsizei         count,
        GLboolean       transpose,
        const(GLfloat)* value,
    );
    alias PFN_glProgramUniformMatrix3x2fv = void function (
        GLuint          program,
        GLint           location,
        GLsizei         count,
        GLboolean       transpose,
        const(GLfloat)* value,
    );
    alias PFN_glProgramUniformMatrix2x4fv = void function (
        GLuint          program,
        GLint           location,
        GLsizei         count,
        GLboolean       transpose,
        const(GLfloat)* value,
    );
    alias PFN_glProgramUniformMatrix4x2fv = void function (
        GLuint          program,
        GLint           location,
        GLsizei         count,
        GLboolean       transpose,
        const(GLfloat)* value,
    );
    alias PFN_glProgramUniformMatrix3x4fv = void function (
        GLuint          program,
        GLint           location,
        GLsizei         count,
        GLboolean       transpose,
        const(GLfloat)* value,
    );
    alias PFN_glProgramUniformMatrix4x3fv = void function (
        GLuint          program,
        GLint           location,
        GLsizei         count,
        GLboolean       transpose,
        const(GLfloat)* value,
    );
    alias PFN_glProgramUniformMatrix2x3dv = void function (
        GLuint           program,
        GLint            location,
        GLsizei          count,
        GLboolean        transpose,
        const(GLdouble)* value,
    );
    alias PFN_glProgramUniformMatrix3x2dv = void function (
        GLuint           program,
        GLint            location,
        GLsizei          count,
        GLboolean        transpose,
        const(GLdouble)* value,
    );
    alias PFN_glProgramUniformMatrix2x4dv = void function (
        GLuint           program,
        GLint            location,
        GLsizei          count,
        GLboolean        transpose,
        const(GLdouble)* value,
    );
    alias PFN_glProgramUniformMatrix4x2dv = void function (
        GLuint           program,
        GLint            location,
        GLsizei          count,
        GLboolean        transpose,
        const(GLdouble)* value,
    );
    alias PFN_glProgramUniformMatrix3x4dv = void function (
        GLuint           program,
        GLint            location,
        GLsizei          count,
        GLboolean        transpose,
        const(GLdouble)* value,
    );
    alias PFN_glProgramUniformMatrix4x3dv = void function (
        GLuint           program,
        GLint            location,
        GLsizei          count,
        GLboolean        transpose,
        const(GLdouble)* value,
    );
    alias PFN_glValidateProgramPipeline = void function (
        GLuint pipeline,
    );
    alias PFN_glGetProgramPipelineInfoLog = void function (
        GLuint   pipeline,
        GLsizei  bufSize,
        GLsizei* length,
        GLchar*  infoLog,
    );
    alias PFN_glVertexAttribL1d = void function (
        GLuint   index,
        GLdouble x,
    );
    alias PFN_glVertexAttribL2d = void function (
        GLuint   index,
        GLdouble x,
        GLdouble y,
    );
    alias PFN_glVertexAttribL3d = void function (
        GLuint   index,
        GLdouble x,
        GLdouble y,
        GLdouble z,
    );
    alias PFN_glVertexAttribL4d = void function (
        GLuint   index,
        GLdouble x,
        GLdouble y,
        GLdouble z,
        GLdouble w,
    );
    alias PFN_glVertexAttribL1dv = void function (
        GLuint           index,
        const(GLdouble)* v,
    );
    alias PFN_glVertexAttribL2dv = void function (
        GLuint           index,
        const(GLdouble)* v,
    );
    alias PFN_glVertexAttribL3dv = void function (
        GLuint           index,
        const(GLdouble)* v,
    );
    alias PFN_glVertexAttribL4dv = void function (
        GLuint           index,
        const(GLdouble)* v,
    );
    alias PFN_glVertexAttribLPointer = void function (
        GLuint       index,
        GLint        size,
        GLenum       type,
        GLsizei      stride,
        const(void)* pointer,
    );
    alias PFN_glGetVertexAttribLdv = void function (
        GLuint    index,
        GLenum    pname,
        GLdouble* params,
    );
    alias PFN_glViewportArrayv = void function (
        GLuint          first,
        GLsizei         count,
        const(GLfloat)* v,
    );
    alias PFN_glViewportIndexedf = void function (
        GLuint  index,
        GLfloat x,
        GLfloat y,
        GLfloat w,
        GLfloat h,
    );
    alias PFN_glViewportIndexedfv = void function (
        GLuint          index,
        const(GLfloat)* v,
    );
    alias PFN_glScissorArrayv = void function (
        GLuint        first,
        GLsizei       count,
        const(GLint)* v,
    );
    alias PFN_glScissorIndexed = void function (
        GLuint  index,
        GLint   left,
        GLint   bottom,
        GLsizei width,
        GLsizei height,
    );
    alias PFN_glScissorIndexedv = void function (
        GLuint        index,
        const(GLint)* v,
    );
    alias PFN_glDepthRangeArrayv = void function (
        GLuint           first,
        GLsizei          count,
        const(GLdouble)* v,
    );
    alias PFN_glDepthRangeIndexed = void function (
        GLuint   index,
        GLdouble n,
        GLdouble f,
    );
    alias PFN_glGetFloati_v = void function (
        GLenum   target,
        GLuint   index,
        GLfloat* data,
    );
    alias PFN_glGetDoublei_v = void function (
        GLenum    target,
        GLuint    index,
        GLdouble* data,
    );

    // Command pointers for GL_VERSION_4_2
    alias PFN_glDrawArraysInstancedBaseInstance = void function (
        GLenum  mode,
        GLint   first,
        GLsizei count,
        GLsizei instancecount,
        GLuint  baseinstance,
    );
    alias PFN_glDrawElementsInstancedBaseInstance = void function (
        GLenum       mode,
        GLsizei      count,
        GLenum       type,
        const(void)* indices,
        GLsizei      instancecount,
        GLuint       baseinstance,
    );
    alias PFN_glDrawElementsInstancedBaseVertexBaseInstance = void function (
        GLenum       mode,
        GLsizei      count,
        GLenum       type,
        const(void)* indices,
        GLsizei      instancecount,
        GLint        basevertex,
        GLuint       baseinstance,
    );
    alias PFN_glGetInternalformativ = void function (
        GLenum  target,
        GLenum  internalformat,
        GLenum  pname,
        GLsizei bufSize,
        GLint*  params,
    );
    alias PFN_glGetActiveAtomicCounterBufferiv = void function (
        GLuint program,
        GLuint bufferIndex,
        GLenum pname,
        GLint* params,
    );
    alias PFN_glBindImageTexture = void function (
        GLuint    unit,
        GLuint    texture,
        GLint     level,
        GLboolean layered,
        GLint     layer,
        GLenum    access,
        GLenum    format,
    );
    alias PFN_glMemoryBarrier = void function (
        GLbitfield barriers,
    );
    alias PFN_glTexStorage1D = void function (
        GLenum  target,
        GLsizei levels,
        GLenum  internalformat,
        GLsizei width,
    );
    alias PFN_glTexStorage2D = void function (
        GLenum  target,
        GLsizei levels,
        GLenum  internalformat,
        GLsizei width,
        GLsizei height,
    );
    alias PFN_glTexStorage3D = void function (
        GLenum  target,
        GLsizei levels,
        GLenum  internalformat,
        GLsizei width,
        GLsizei height,
        GLsizei depth,
    );
    alias PFN_glDrawTransformFeedbackInstanced = void function (
        GLenum  mode,
        GLuint  id,
        GLsizei instancecount,
    );
    alias PFN_glDrawTransformFeedbackStreamInstanced = void function (
        GLenum  mode,
        GLuint  id,
        GLuint  stream,
        GLsizei instancecount,
    );

    // Command pointers for GL_VERSION_4_3
    alias PFN_glClearBufferData = void function (
        GLenum       target,
        GLenum       internalformat,
        GLenum       format,
        GLenum       type,
        const(void)* data,
    );
    alias PFN_glClearBufferSubData = void function (
        GLenum       target,
        GLenum       internalformat,
        GLintptr     offset,
        GLsizeiptr   size,
        GLenum       format,
        GLenum       type,
        const(void)* data,
    );
    alias PFN_glDispatchCompute = void function (
        GLuint num_groups_x,
        GLuint num_groups_y,
        GLuint num_groups_z,
    );
    alias PFN_glDispatchComputeIndirect = void function (
        GLintptr indirect,
    );
    alias PFN_glCopyImageSubData = void function (
        GLuint  srcName,
        GLenum  srcTarget,
        GLint   srcLevel,
        GLint   srcX,
        GLint   srcY,
        GLint   srcZ,
        GLuint  dstName,
        GLenum  dstTarget,
        GLint   dstLevel,
        GLint   dstX,
        GLint   dstY,
        GLint   dstZ,
        GLsizei srcWidth,
        GLsizei srcHeight,
        GLsizei srcDepth,
    );
    alias PFN_glFramebufferParameteri = void function (
        GLenum target,
        GLenum pname,
        GLint  param,
    );
    alias PFN_glGetFramebufferParameteriv = void function (
        GLenum target,
        GLenum pname,
        GLint* params,
    );
    alias PFN_glGetInternalformati64v = void function (
        GLenum   target,
        GLenum   internalformat,
        GLenum   pname,
        GLsizei  bufSize,
        GLint64* params,
    );
    alias PFN_glInvalidateTexSubImage = void function (
        GLuint  texture,
        GLint   level,
        GLint   xoffset,
        GLint   yoffset,
        GLint   zoffset,
        GLsizei width,
        GLsizei height,
        GLsizei depth,
    );
    alias PFN_glInvalidateTexImage = void function (
        GLuint texture,
        GLint  level,
    );
    alias PFN_glInvalidateBufferSubData = void function (
        GLuint     buffer,
        GLintptr   offset,
        GLsizeiptr length,
    );
    alias PFN_glInvalidateBufferData = void function (
        GLuint buffer,
    );
    alias PFN_glInvalidateFramebuffer = void function (
        GLenum         target,
        GLsizei        numAttachments,
        const(GLenum)* attachments,
    );
    alias PFN_glInvalidateSubFramebuffer = void function (
        GLenum         target,
        GLsizei        numAttachments,
        const(GLenum)* attachments,
        GLint          x,
        GLint          y,
        GLsizei        width,
        GLsizei        height,
    );
    alias PFN_glMultiDrawArraysIndirect = void function (
        GLenum       mode,
        const(void)* indirect,
        GLsizei      drawcount,
        GLsizei      stride,
    );
    alias PFN_glMultiDrawElementsIndirect = void function (
        GLenum       mode,
        GLenum       type,
        const(void)* indirect,
        GLsizei      drawcount,
        GLsizei      stride,
    );
    alias PFN_glGetProgramInterfaceiv = void function (
        GLuint program,
        GLenum programInterface,
        GLenum pname,
        GLint* params,
    );
    alias PFN_glGetProgramResourceIndex = GLuint function (
        GLuint         program,
        GLenum         programInterface,
        const(GLchar)* name,
    );
    alias PFN_glGetProgramResourceName = void function (
        GLuint   program,
        GLenum   programInterface,
        GLuint   index,
        GLsizei  bufSize,
        GLsizei* length,
        GLchar*  name,
    );
    alias PFN_glGetProgramResourceiv = void function (
        GLuint         program,
        GLenum         programInterface,
        GLuint         index,
        GLsizei        propCount,
        const(GLenum)* props,
        GLsizei        bufSize,
        GLsizei*       length,
        GLint*         params,
    );
    alias PFN_glGetProgramResourceLocation = GLint function (
        GLuint         program,
        GLenum         programInterface,
        const(GLchar)* name,
    );
    alias PFN_glGetProgramResourceLocationIndex = GLint function (
        GLuint         program,
        GLenum         programInterface,
        const(GLchar)* name,
    );
    alias PFN_glShaderStorageBlockBinding = void function (
        GLuint program,
        GLuint storageBlockIndex,
        GLuint storageBlockBinding,
    );
    alias PFN_glTexBufferRange = void function (
        GLenum     target,
        GLenum     internalformat,
        GLuint     buffer,
        GLintptr   offset,
        GLsizeiptr size,
    );
    alias PFN_glTexStorage2DMultisample = void function (
        GLenum    target,
        GLsizei   samples,
        GLenum    internalformat,
        GLsizei   width,
        GLsizei   height,
        GLboolean fixedsamplelocations,
    );
    alias PFN_glTexStorage3DMultisample = void function (
        GLenum    target,
        GLsizei   samples,
        GLenum    internalformat,
        GLsizei   width,
        GLsizei   height,
        GLsizei   depth,
        GLboolean fixedsamplelocations,
    );
    alias PFN_glTextureView = void function (
        GLuint texture,
        GLenum target,
        GLuint origtexture,
        GLenum internalformat,
        GLuint minlevel,
        GLuint numlevels,
        GLuint minlayer,
        GLuint numlayers,
    );
    alias PFN_glBindVertexBuffer = void function (
        GLuint   bindingindex,
        GLuint   buffer,
        GLintptr offset,
        GLsizei  stride,
    );
    alias PFN_glVertexAttribFormat = void function (
        GLuint    attribindex,
        GLint     size,
        GLenum    type,
        GLboolean normalized,
        GLuint    relativeoffset,
    );
    alias PFN_glVertexAttribIFormat = void function (
        GLuint attribindex,
        GLint  size,
        GLenum type,
        GLuint relativeoffset,
    );
    alias PFN_glVertexAttribLFormat = void function (
        GLuint attribindex,
        GLint  size,
        GLenum type,
        GLuint relativeoffset,
    );
    alias PFN_glVertexAttribBinding = void function (
        GLuint attribindex,
        GLuint bindingindex,
    );
    alias PFN_glVertexBindingDivisor = void function (
        GLuint bindingindex,
        GLuint divisor,
    );
    alias PFN_glDebugMessageControl = void function (
        GLenum         source,
        GLenum         type,
        GLenum         severity,
        GLsizei        count,
        const(GLuint)* ids,
        GLboolean      enabled,
    );
    alias PFN_glDebugMessageInsert = void function (
        GLenum         source,
        GLenum         type,
        GLuint         id,
        GLenum         severity,
        GLsizei        length,
        const(GLchar)* buf,
    );
    alias PFN_glDebugMessageCallback = void function (
        GLDEBUGPROC  callback,
        const(void)* userParam,
    );
    alias PFN_glGetDebugMessageLog = GLuint function (
        GLuint   count,
        GLsizei  bufSize,
        GLenum*  sources,
        GLenum*  types,
        GLuint*  ids,
        GLenum*  severities,
        GLsizei* lengths,
        GLchar*  messageLog,
    );
    alias PFN_glPushDebugGroup = void function (
        GLenum         source,
        GLuint         id,
        GLsizei        length,
        const(GLchar)* message,
    );
    alias PFN_glPopDebugGroup = void function ();
    alias PFN_glObjectLabel = void function (
        GLenum         identifier,
        GLuint         name,
        GLsizei        length,
        const(GLchar)* label,
    );
    alias PFN_glGetObjectLabel = void function (
        GLenum   identifier,
        GLuint   name,
        GLsizei  bufSize,
        GLsizei* length,
        GLchar*  label,
    );
    alias PFN_glObjectPtrLabel = void function (
        const(void)*   ptr,
        GLsizei        length,
        const(GLchar)* label,
    );
    alias PFN_glGetObjectPtrLabel = void function (
        const(void)* ptr,
        GLsizei      bufSize,
        GLsizei*     length,
        GLchar*      label,
    );

    // Command pointers for GL_VERSION_4_4
    alias PFN_glBufferStorage = void function (
        GLenum       target,
        GLsizeiptr   size,
        const(void)* data,
        GLbitfield   flags,
    );
    alias PFN_glClearTexImage = void function (
        GLuint       texture,
        GLint        level,
        GLenum       format,
        GLenum       type,
        const(void)* data,
    );
    alias PFN_glClearTexSubImage = void function (
        GLuint       texture,
        GLint        level,
        GLint        xoffset,
        GLint        yoffset,
        GLint        zoffset,
        GLsizei      width,
        GLsizei      height,
        GLsizei      depth,
        GLenum       format,
        GLenum       type,
        const(void)* data,
    );
    alias PFN_glBindBuffersBase = void function (
        GLenum         target,
        GLuint         first,
        GLsizei        count,
        const(GLuint)* buffers,
    );
    alias PFN_glBindBuffersRange = void function (
        GLenum             target,
        GLuint             first,
        GLsizei            count,
        const(GLuint)*     buffers,
        const(GLintptr)*   offsets,
        const(GLsizeiptr)* sizes,
    );
    alias PFN_glBindTextures = void function (
        GLuint         first,
        GLsizei        count,
        const(GLuint)* textures,
    );
    alias PFN_glBindSamplers = void function (
        GLuint         first,
        GLsizei        count,
        const(GLuint)* samplers,
    );
    alias PFN_glBindImageTextures = void function (
        GLuint         first,
        GLsizei        count,
        const(GLuint)* textures,
    );
    alias PFN_glBindVertexBuffers = void function (
        GLuint           first,
        GLsizei          count,
        const(GLuint)*   buffers,
        const(GLintptr)* offsets,
        const(GLsizei)*  strides,
    );

    // Command pointers for GL_VERSION_4_5
    alias PFN_glClipControl = void function (
        GLenum origin,
        GLenum depth,
    );
    alias PFN_glCreateTransformFeedbacks = void function (
        GLsizei n,
        GLuint* ids,
    );
    alias PFN_glTransformFeedbackBufferBase = void function (
        GLuint xfb,
        GLuint index,
        GLuint buffer,
    );
    alias PFN_glTransformFeedbackBufferRange = void function (
        GLuint     xfb,
        GLuint     index,
        GLuint     buffer,
        GLintptr   offset,
        GLsizeiptr size,
    );
    alias PFN_glGetTransformFeedbackiv = void function (
        GLuint xfb,
        GLenum pname,
        GLint* param,
    );
    alias PFN_glGetTransformFeedbacki_v = void function (
        GLuint xfb,
        GLenum pname,
        GLuint index,
        GLint* param,
    );
    alias PFN_glGetTransformFeedbacki64_v = void function (
        GLuint   xfb,
        GLenum   pname,
        GLuint   index,
        GLint64* param,
    );
    alias PFN_glCreateBuffers = void function (
        GLsizei n,
        GLuint* buffers,
    );
    alias PFN_glNamedBufferStorage = void function (
        GLuint       buffer,
        GLsizeiptr   size,
        const(void)* data,
        GLbitfield   flags,
    );
    alias PFN_glNamedBufferData = void function (
        GLuint       buffer,
        GLsizeiptr   size,
        const(void)* data,
        GLenum       usage,
    );
    alias PFN_glNamedBufferSubData = void function (
        GLuint       buffer,
        GLintptr     offset,
        GLsizeiptr   size,
        const(void)* data,
    );
    alias PFN_glCopyNamedBufferSubData = void function (
        GLuint     readBuffer,
        GLuint     writeBuffer,
        GLintptr   readOffset,
        GLintptr   writeOffset,
        GLsizeiptr size,
    );
    alias PFN_glClearNamedBufferData = void function (
        GLuint       buffer,
        GLenum       internalformat,
        GLenum       format,
        GLenum       type,
        const(void)* data,
    );
    alias PFN_glClearNamedBufferSubData = void function (
        GLuint       buffer,
        GLenum       internalformat,
        GLintptr     offset,
        GLsizeiptr   size,
        GLenum       format,
        GLenum       type,
        const(void)* data,
    );
    alias PFN_glMapNamedBuffer = void * function (
        GLuint buffer,
        GLenum access,
    );
    alias PFN_glMapNamedBufferRange = void * function (
        GLuint     buffer,
        GLintptr   offset,
        GLsizeiptr length,
        GLbitfield access,
    );
    alias PFN_glUnmapNamedBuffer = GLboolean function (
        GLuint buffer,
    );
    alias PFN_glFlushMappedNamedBufferRange = void function (
        GLuint     buffer,
        GLintptr   offset,
        GLsizeiptr length,
    );
    alias PFN_glGetNamedBufferParameteriv = void function (
        GLuint buffer,
        GLenum pname,
        GLint* params,
    );
    alias PFN_glGetNamedBufferParameteri64v = void function (
        GLuint   buffer,
        GLenum   pname,
        GLint64* params,
    );
    alias PFN_glGetNamedBufferPointerv = void function (
        GLuint buffer,
        GLenum pname,
        void** params,
    );
    alias PFN_glGetNamedBufferSubData = void function (
        GLuint     buffer,
        GLintptr   offset,
        GLsizeiptr size,
        void*      data,
    );
    alias PFN_glCreateFramebuffers = void function (
        GLsizei n,
        GLuint* framebuffers,
    );
    alias PFN_glNamedFramebufferRenderbuffer = void function (
        GLuint framebuffer,
        GLenum attachment,
        GLenum renderbuffertarget,
        GLuint renderbuffer,
    );
    alias PFN_glNamedFramebufferParameteri = void function (
        GLuint framebuffer,
        GLenum pname,
        GLint  param,
    );
    alias PFN_glNamedFramebufferTexture = void function (
        GLuint framebuffer,
        GLenum attachment,
        GLuint texture,
        GLint  level,
    );
    alias PFN_glNamedFramebufferTextureLayer = void function (
        GLuint framebuffer,
        GLenum attachment,
        GLuint texture,
        GLint  level,
        GLint  layer,
    );
    alias PFN_glNamedFramebufferDrawBuffer = void function (
        GLuint framebuffer,
        GLenum buf,
    );
    alias PFN_glNamedFramebufferDrawBuffers = void function (
        GLuint         framebuffer,
        GLsizei        n,
        const(GLenum)* bufs,
    );
    alias PFN_glNamedFramebufferReadBuffer = void function (
        GLuint framebuffer,
        GLenum src,
    );
    alias PFN_glInvalidateNamedFramebufferData = void function (
        GLuint         framebuffer,
        GLsizei        numAttachments,
        const(GLenum)* attachments,
    );
    alias PFN_glInvalidateNamedFramebufferSubData = void function (
        GLuint         framebuffer,
        GLsizei        numAttachments,
        const(GLenum)* attachments,
        GLint          x,
        GLint          y,
        GLsizei        width,
        GLsizei        height,
    );
    alias PFN_glClearNamedFramebufferiv = void function (
        GLuint        framebuffer,
        GLenum        buffer,
        GLint         drawbuffer,
        const(GLint)* value,
    );
    alias PFN_glClearNamedFramebufferuiv = void function (
        GLuint         framebuffer,
        GLenum         buffer,
        GLint          drawbuffer,
        const(GLuint)* value,
    );
    alias PFN_glClearNamedFramebufferfv = void function (
        GLuint          framebuffer,
        GLenum          buffer,
        GLint           drawbuffer,
        const(GLfloat)* value,
    );
    alias PFN_glClearNamedFramebufferfi = void function (
        GLuint  framebuffer,
        GLenum  buffer,
        GLint   drawbuffer,
        GLfloat depth,
        GLint   stencil,
    );
    alias PFN_glBlitNamedFramebuffer = void function (
        GLuint     readFramebuffer,
        GLuint     drawFramebuffer,
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
    alias PFN_glCheckNamedFramebufferStatus = GLenum function (
        GLuint framebuffer,
        GLenum target,
    );
    alias PFN_glGetNamedFramebufferParameteriv = void function (
        GLuint framebuffer,
        GLenum pname,
        GLint* param,
    );
    alias PFN_glGetNamedFramebufferAttachmentParameteriv = void function (
        GLuint framebuffer,
        GLenum attachment,
        GLenum pname,
        GLint* params,
    );
    alias PFN_glCreateRenderbuffers = void function (
        GLsizei n,
        GLuint* renderbuffers,
    );
    alias PFN_glNamedRenderbufferStorage = void function (
        GLuint  renderbuffer,
        GLenum  internalformat,
        GLsizei width,
        GLsizei height,
    );
    alias PFN_glNamedRenderbufferStorageMultisample = void function (
        GLuint  renderbuffer,
        GLsizei samples,
        GLenum  internalformat,
        GLsizei width,
        GLsizei height,
    );
    alias PFN_glGetNamedRenderbufferParameteriv = void function (
        GLuint renderbuffer,
        GLenum pname,
        GLint* params,
    );
    alias PFN_glCreateTextures = void function (
        GLenum  target,
        GLsizei n,
        GLuint* textures,
    );
    alias PFN_glTextureBuffer = void function (
        GLuint texture,
        GLenum internalformat,
        GLuint buffer,
    );
    alias PFN_glTextureBufferRange = void function (
        GLuint     texture,
        GLenum     internalformat,
        GLuint     buffer,
        GLintptr   offset,
        GLsizeiptr size,
    );
    alias PFN_glTextureStorage1D = void function (
        GLuint  texture,
        GLsizei levels,
        GLenum  internalformat,
        GLsizei width,
    );
    alias PFN_glTextureStorage2D = void function (
        GLuint  texture,
        GLsizei levels,
        GLenum  internalformat,
        GLsizei width,
        GLsizei height,
    );
    alias PFN_glTextureStorage3D = void function (
        GLuint  texture,
        GLsizei levels,
        GLenum  internalformat,
        GLsizei width,
        GLsizei height,
        GLsizei depth,
    );
    alias PFN_glTextureStorage2DMultisample = void function (
        GLuint    texture,
        GLsizei   samples,
        GLenum    internalformat,
        GLsizei   width,
        GLsizei   height,
        GLboolean fixedsamplelocations,
    );
    alias PFN_glTextureStorage3DMultisample = void function (
        GLuint    texture,
        GLsizei   samples,
        GLenum    internalformat,
        GLsizei   width,
        GLsizei   height,
        GLsizei   depth,
        GLboolean fixedsamplelocations,
    );
    alias PFN_glTextureSubImage1D = void function (
        GLuint       texture,
        GLint        level,
        GLint        xoffset,
        GLsizei      width,
        GLenum       format,
        GLenum       type,
        const(void)* pixels,
    );
    alias PFN_glTextureSubImage2D = void function (
        GLuint       texture,
        GLint        level,
        GLint        xoffset,
        GLint        yoffset,
        GLsizei      width,
        GLsizei      height,
        GLenum       format,
        GLenum       type,
        const(void)* pixels,
    );
    alias PFN_glTextureSubImage3D = void function (
        GLuint       texture,
        GLint        level,
        GLint        xoffset,
        GLint        yoffset,
        GLint        zoffset,
        GLsizei      width,
        GLsizei      height,
        GLsizei      depth,
        GLenum       format,
        GLenum       type,
        const(void)* pixels,
    );
    alias PFN_glCompressedTextureSubImage1D = void function (
        GLuint       texture,
        GLint        level,
        GLint        xoffset,
        GLsizei      width,
        GLenum       format,
        GLsizei      imageSize,
        const(void)* data,
    );
    alias PFN_glCompressedTextureSubImage2D = void function (
        GLuint       texture,
        GLint        level,
        GLint        xoffset,
        GLint        yoffset,
        GLsizei      width,
        GLsizei      height,
        GLenum       format,
        GLsizei      imageSize,
        const(void)* data,
    );
    alias PFN_glCompressedTextureSubImage3D = void function (
        GLuint       texture,
        GLint        level,
        GLint        xoffset,
        GLint        yoffset,
        GLint        zoffset,
        GLsizei      width,
        GLsizei      height,
        GLsizei      depth,
        GLenum       format,
        GLsizei      imageSize,
        const(void)* data,
    );
    alias PFN_glCopyTextureSubImage1D = void function (
        GLuint  texture,
        GLint   level,
        GLint   xoffset,
        GLint   x,
        GLint   y,
        GLsizei width,
    );
    alias PFN_glCopyTextureSubImage2D = void function (
        GLuint  texture,
        GLint   level,
        GLint   xoffset,
        GLint   yoffset,
        GLint   x,
        GLint   y,
        GLsizei width,
        GLsizei height,
    );
    alias PFN_glCopyTextureSubImage3D = void function (
        GLuint  texture,
        GLint   level,
        GLint   xoffset,
        GLint   yoffset,
        GLint   zoffset,
        GLint   x,
        GLint   y,
        GLsizei width,
        GLsizei height,
    );
    alias PFN_glTextureParameterf = void function (
        GLuint  texture,
        GLenum  pname,
        GLfloat param,
    );
    alias PFN_glTextureParameterfv = void function (
        GLuint          texture,
        GLenum          pname,
        const(GLfloat)* param,
    );
    alias PFN_glTextureParameteri = void function (
        GLuint texture,
        GLenum pname,
        GLint  param,
    );
    alias PFN_glTextureParameterIiv = void function (
        GLuint        texture,
        GLenum        pname,
        const(GLint)* params,
    );
    alias PFN_glTextureParameterIuiv = void function (
        GLuint         texture,
        GLenum         pname,
        const(GLuint)* params,
    );
    alias PFN_glTextureParameteriv = void function (
        GLuint        texture,
        GLenum        pname,
        const(GLint)* param,
    );
    alias PFN_glGenerateTextureMipmap = void function (
        GLuint texture,
    );
    alias PFN_glBindTextureUnit = void function (
        GLuint unit,
        GLuint texture,
    );
    alias PFN_glGetTextureImage = void function (
        GLuint  texture,
        GLint   level,
        GLenum  format,
        GLenum  type,
        GLsizei bufSize,
        void*   pixels,
    );
    alias PFN_glGetCompressedTextureImage = void function (
        GLuint  texture,
        GLint   level,
        GLsizei bufSize,
        void*   pixels,
    );
    alias PFN_glGetTextureLevelParameterfv = void function (
        GLuint   texture,
        GLint    level,
        GLenum   pname,
        GLfloat* params,
    );
    alias PFN_glGetTextureLevelParameteriv = void function (
        GLuint texture,
        GLint  level,
        GLenum pname,
        GLint* params,
    );
    alias PFN_glGetTextureParameterfv = void function (
        GLuint   texture,
        GLenum   pname,
        GLfloat* params,
    );
    alias PFN_glGetTextureParameterIiv = void function (
        GLuint texture,
        GLenum pname,
        GLint* params,
    );
    alias PFN_glGetTextureParameterIuiv = void function (
        GLuint  texture,
        GLenum  pname,
        GLuint* params,
    );
    alias PFN_glGetTextureParameteriv = void function (
        GLuint texture,
        GLenum pname,
        GLint* params,
    );
    alias PFN_glCreateVertexArrays = void function (
        GLsizei n,
        GLuint* arrays,
    );
    alias PFN_glDisableVertexArrayAttrib = void function (
        GLuint vaobj,
        GLuint index,
    );
    alias PFN_glEnableVertexArrayAttrib = void function (
        GLuint vaobj,
        GLuint index,
    );
    alias PFN_glVertexArrayElementBuffer = void function (
        GLuint vaobj,
        GLuint buffer,
    );
    alias PFN_glVertexArrayVertexBuffer = void function (
        GLuint   vaobj,
        GLuint   bindingindex,
        GLuint   buffer,
        GLintptr offset,
        GLsizei  stride,
    );
    alias PFN_glVertexArrayVertexBuffers = void function (
        GLuint           vaobj,
        GLuint           first,
        GLsizei          count,
        const(GLuint)*   buffers,
        const(GLintptr)* offsets,
        const(GLsizei)*  strides,
    );
    alias PFN_glVertexArrayAttribBinding = void function (
        GLuint vaobj,
        GLuint attribindex,
        GLuint bindingindex,
    );
    alias PFN_glVertexArrayAttribFormat = void function (
        GLuint    vaobj,
        GLuint    attribindex,
        GLint     size,
        GLenum    type,
        GLboolean normalized,
        GLuint    relativeoffset,
    );
    alias PFN_glVertexArrayAttribIFormat = void function (
        GLuint vaobj,
        GLuint attribindex,
        GLint  size,
        GLenum type,
        GLuint relativeoffset,
    );
    alias PFN_glVertexArrayAttribLFormat = void function (
        GLuint vaobj,
        GLuint attribindex,
        GLint  size,
        GLenum type,
        GLuint relativeoffset,
    );
    alias PFN_glVertexArrayBindingDivisor = void function (
        GLuint vaobj,
        GLuint bindingindex,
        GLuint divisor,
    );
    alias PFN_glGetVertexArrayiv = void function (
        GLuint vaobj,
        GLenum pname,
        GLint* param,
    );
    alias PFN_glGetVertexArrayIndexediv = void function (
        GLuint vaobj,
        GLuint index,
        GLenum pname,
        GLint* param,
    );
    alias PFN_glGetVertexArrayIndexed64iv = void function (
        GLuint   vaobj,
        GLuint   index,
        GLenum   pname,
        GLint64* param,
    );
    alias PFN_glCreateSamplers = void function (
        GLsizei n,
        GLuint* samplers,
    );
    alias PFN_glCreateProgramPipelines = void function (
        GLsizei n,
        GLuint* pipelines,
    );
    alias PFN_glCreateQueries = void function (
        GLenum  target,
        GLsizei n,
        GLuint* ids,
    );
    alias PFN_glGetQueryBufferObjecti64v = void function (
        GLuint   id,
        GLuint   buffer,
        GLenum   pname,
        GLintptr offset,
    );
    alias PFN_glGetQueryBufferObjectiv = void function (
        GLuint   id,
        GLuint   buffer,
        GLenum   pname,
        GLintptr offset,
    );
    alias PFN_glGetQueryBufferObjectui64v = void function (
        GLuint   id,
        GLuint   buffer,
        GLenum   pname,
        GLintptr offset,
    );
    alias PFN_glGetQueryBufferObjectuiv = void function (
        GLuint   id,
        GLuint   buffer,
        GLenum   pname,
        GLintptr offset,
    );
    alias PFN_glMemoryBarrierByRegion = void function (
        GLbitfield barriers,
    );
    alias PFN_glGetTextureSubImage = void function (
        GLuint  texture,
        GLint   level,
        GLint   xoffset,
        GLint   yoffset,
        GLint   zoffset,
        GLsizei width,
        GLsizei height,
        GLsizei depth,
        GLenum  format,
        GLenum  type,
        GLsizei bufSize,
        void*   pixels,
    );
    alias PFN_glGetCompressedTextureSubImage = void function (
        GLuint  texture,
        GLint   level,
        GLint   xoffset,
        GLint   yoffset,
        GLint   zoffset,
        GLsizei width,
        GLsizei height,
        GLsizei depth,
        GLsizei bufSize,
        void*   pixels,
    );
    alias PFN_glGetGraphicsResetStatus = GLenum function ();
    alias PFN_glGetnCompressedTexImage = void function (
        GLenum  target,
        GLint   lod,
        GLsizei bufSize,
        void*   pixels,
    );
    alias PFN_glGetnTexImage = void function (
        GLenum  target,
        GLint   level,
        GLenum  format,
        GLenum  type,
        GLsizei bufSize,
        void*   pixels,
    );
    alias PFN_glGetnUniformdv = void function (
        GLuint    program,
        GLint     location,
        GLsizei   bufSize,
        GLdouble* params,
    );
    alias PFN_glGetnUniformfv = void function (
        GLuint   program,
        GLint    location,
        GLsizei  bufSize,
        GLfloat* params,
    );
    alias PFN_glGetnUniformiv = void function (
        GLuint  program,
        GLint   location,
        GLsizei bufSize,
        GLint*  params,
    );
    alias PFN_glGetnUniformuiv = void function (
        GLuint  program,
        GLint   location,
        GLsizei bufSize,
        GLuint* params,
    );
    alias PFN_glReadnPixels = void function (
        GLint   x,
        GLint   y,
        GLsizei width,
        GLsizei height,
        GLenum  format,
        GLenum  type,
        GLsizei bufSize,
        void*   data,
    );
    alias PFN_glTextureBarrier = void function ();

    // Command pointers for GL_VERSION_4_6
    alias PFN_glSpecializeShader = void function (
        GLuint         shader,
        const(GLchar)* pEntryPoint,
        GLuint         numSpecializationConstants,
        const(GLuint)* pConstantIndex,
        const(GLuint)* pConstantValue,
    );
    alias PFN_glMultiDrawArraysIndirectCount = void function (
        GLenum       mode,
        const(void)* indirect,
        GLintptr     drawcount,
        GLsizei      maxdrawcount,
        GLsizei      stride,
    );
    alias PFN_glMultiDrawElementsIndirectCount = void function (
        GLenum       mode,
        GLenum       type,
        const(void)* indirect,
        GLintptr     drawcount,
        GLsizei      maxdrawcount,
        GLsizei      stride,
    );
    alias PFN_glPolygonOffsetClamp = void function (
        GLfloat factor,
        GLfloat units,
        GLfloat clamp,
    );

    // Command pointers for GL_ARB_ES3_2_compatibility
    alias PFN_glPrimitiveBoundingBoxARB = void function (
        GLfloat minX,
        GLfloat minY,
        GLfloat minZ,
        GLfloat minW,
        GLfloat maxX,
        GLfloat maxY,
        GLfloat maxZ,
        GLfloat maxW,
    );

    // Command pointers for GL_ARB_bindless_texture
    alias PFN_glGetTextureHandleARB = GLuint64 function (
        GLuint texture,
    );
    alias PFN_glGetTextureSamplerHandleARB = GLuint64 function (
        GLuint texture,
        GLuint sampler,
    );
    alias PFN_glMakeTextureHandleResidentARB = void function (
        GLuint64 handle,
    );
    alias PFN_glMakeTextureHandleNonResidentARB = void function (
        GLuint64 handle,
    );
    alias PFN_glGetImageHandleARB = GLuint64 function (
        GLuint    texture,
        GLint     level,
        GLboolean layered,
        GLint     layer,
        GLenum    format,
    );
    alias PFN_glMakeImageHandleResidentARB = void function (
        GLuint64 handle,
        GLenum   access,
    );
    alias PFN_glMakeImageHandleNonResidentARB = void function (
        GLuint64 handle,
    );
    alias PFN_glUniformHandleui64ARB = void function (
        GLint    location,
        GLuint64 value,
    );
    alias PFN_glUniformHandleui64vARB = void function (
        GLint            location,
        GLsizei          count,
        const(GLuint64)* value,
    );
    alias PFN_glProgramUniformHandleui64ARB = void function (
        GLuint   program,
        GLint    location,
        GLuint64 value,
    );
    alias PFN_glProgramUniformHandleui64vARB = void function (
        GLuint           program,
        GLint            location,
        GLsizei          count,
        const(GLuint64)* values,
    );
    alias PFN_glIsTextureHandleResidentARB = GLboolean function (
        GLuint64 handle,
    );
    alias PFN_glIsImageHandleResidentARB = GLboolean function (
        GLuint64 handle,
    );
    alias PFN_glVertexAttribL1ui64ARB = void function (
        GLuint      index,
        GLuint64EXT x,
    );
    alias PFN_glVertexAttribL1ui64vARB = void function (
        GLuint              index,
        const(GLuint64EXT)* v,
    );
    alias PFN_glGetVertexAttribLui64vARB = void function (
        GLuint       index,
        GLenum       pname,
        GLuint64EXT* params,
    );

    // Command pointers for GL_ARB_cl_event
    alias PFN_glCreateSyncFromCLeventARB = GLsync function (
        _cl_context* context,
        _cl_event*   event,
        GLbitfield   flags,
    );

    // Command pointers for GL_ARB_compute_variable_group_size
    alias PFN_glDispatchComputeGroupSizeARB = void function (
        GLuint num_groups_x,
        GLuint num_groups_y,
        GLuint num_groups_z,
        GLuint group_size_x,
        GLuint group_size_y,
        GLuint group_size_z,
    );

    // Command pointers for GL_ARB_geometry_shader4
    alias PFN_glFramebufferTextureFaceARB = void function (
        GLenum target,
        GLenum attachment,
        GLuint texture,
        GLint  level,
        GLenum face,
    );

    // Command pointers for GL_ARB_gpu_shader_int64
    alias PFN_glUniform1i64ARB = void function (
        GLint   location,
        GLint64 x,
    );
    alias PFN_glUniform2i64ARB = void function (
        GLint   location,
        GLint64 x,
        GLint64 y,
    );
    alias PFN_glUniform3i64ARB = void function (
        GLint   location,
        GLint64 x,
        GLint64 y,
        GLint64 z,
    );
    alias PFN_glUniform4i64ARB = void function (
        GLint   location,
        GLint64 x,
        GLint64 y,
        GLint64 z,
        GLint64 w,
    );
    alias PFN_glUniform1i64vARB = void function (
        GLint           location,
        GLsizei         count,
        const(GLint64)* value,
    );
    alias PFN_glUniform2i64vARB = void function (
        GLint           location,
        GLsizei         count,
        const(GLint64)* value,
    );
    alias PFN_glUniform3i64vARB = void function (
        GLint           location,
        GLsizei         count,
        const(GLint64)* value,
    );
    alias PFN_glUniform4i64vARB = void function (
        GLint           location,
        GLsizei         count,
        const(GLint64)* value,
    );
    alias PFN_glUniform1ui64ARB = void function (
        GLint    location,
        GLuint64 x,
    );
    alias PFN_glUniform2ui64ARB = void function (
        GLint    location,
        GLuint64 x,
        GLuint64 y,
    );
    alias PFN_glUniform3ui64ARB = void function (
        GLint    location,
        GLuint64 x,
        GLuint64 y,
        GLuint64 z,
    );
    alias PFN_glUniform4ui64ARB = void function (
        GLint    location,
        GLuint64 x,
        GLuint64 y,
        GLuint64 z,
        GLuint64 w,
    );
    alias PFN_glUniform1ui64vARB = void function (
        GLint            location,
        GLsizei          count,
        const(GLuint64)* value,
    );
    alias PFN_glUniform2ui64vARB = void function (
        GLint            location,
        GLsizei          count,
        const(GLuint64)* value,
    );
    alias PFN_glUniform3ui64vARB = void function (
        GLint            location,
        GLsizei          count,
        const(GLuint64)* value,
    );
    alias PFN_glUniform4ui64vARB = void function (
        GLint            location,
        GLsizei          count,
        const(GLuint64)* value,
    );
    alias PFN_glGetUniformi64vARB = void function (
        GLuint   program,
        GLint    location,
        GLint64* params,
    );
    alias PFN_glGetUniformui64vARB = void function (
        GLuint    program,
        GLint     location,
        GLuint64* params,
    );
    alias PFN_glGetnUniformi64vARB = void function (
        GLuint   program,
        GLint    location,
        GLsizei  bufSize,
        GLint64* params,
    );
    alias PFN_glGetnUniformui64vARB = void function (
        GLuint    program,
        GLint     location,
        GLsizei   bufSize,
        GLuint64* params,
    );
    alias PFN_glProgramUniform1i64ARB = void function (
        GLuint  program,
        GLint   location,
        GLint64 x,
    );
    alias PFN_glProgramUniform2i64ARB = void function (
        GLuint  program,
        GLint   location,
        GLint64 x,
        GLint64 y,
    );
    alias PFN_glProgramUniform3i64ARB = void function (
        GLuint  program,
        GLint   location,
        GLint64 x,
        GLint64 y,
        GLint64 z,
    );
    alias PFN_glProgramUniform4i64ARB = void function (
        GLuint  program,
        GLint   location,
        GLint64 x,
        GLint64 y,
        GLint64 z,
        GLint64 w,
    );
    alias PFN_glProgramUniform1i64vARB = void function (
        GLuint          program,
        GLint           location,
        GLsizei         count,
        const(GLint64)* value,
    );
    alias PFN_glProgramUniform2i64vARB = void function (
        GLuint          program,
        GLint           location,
        GLsizei         count,
        const(GLint64)* value,
    );
    alias PFN_glProgramUniform3i64vARB = void function (
        GLuint          program,
        GLint           location,
        GLsizei         count,
        const(GLint64)* value,
    );
    alias PFN_glProgramUniform4i64vARB = void function (
        GLuint          program,
        GLint           location,
        GLsizei         count,
        const(GLint64)* value,
    );
    alias PFN_glProgramUniform1ui64ARB = void function (
        GLuint   program,
        GLint    location,
        GLuint64 x,
    );
    alias PFN_glProgramUniform2ui64ARB = void function (
        GLuint   program,
        GLint    location,
        GLuint64 x,
        GLuint64 y,
    );
    alias PFN_glProgramUniform3ui64ARB = void function (
        GLuint   program,
        GLint    location,
        GLuint64 x,
        GLuint64 y,
        GLuint64 z,
    );
    alias PFN_glProgramUniform4ui64ARB = void function (
        GLuint   program,
        GLint    location,
        GLuint64 x,
        GLuint64 y,
        GLuint64 z,
        GLuint64 w,
    );
    alias PFN_glProgramUniform1ui64vARB = void function (
        GLuint           program,
        GLint            location,
        GLsizei          count,
        const(GLuint64)* value,
    );
    alias PFN_glProgramUniform2ui64vARB = void function (
        GLuint           program,
        GLint            location,
        GLsizei          count,
        const(GLuint64)* value,
    );
    alias PFN_glProgramUniform3ui64vARB = void function (
        GLuint           program,
        GLint            location,
        GLsizei          count,
        const(GLuint64)* value,
    );
    alias PFN_glProgramUniform4ui64vARB = void function (
        GLuint           program,
        GLint            location,
        GLsizei          count,
        const(GLuint64)* value,
    );

    // Command pointers for GL_ARB_parallel_shader_compile
    alias PFN_glMaxShaderCompilerThreadsARB = void function (
        GLuint count,
    );

    // Command pointers for GL_ARB_robustness
    alias PFN_glGetGraphicsResetStatusARB = GLenum function ();
    alias PFN_glGetnTexImageARB = void function (
        GLenum  target,
        GLint   level,
        GLenum  format,
        GLenum  type,
        GLsizei bufSize,
        void*   img,
    );
    alias PFN_glGetnCompressedTexImageARB = void function (
        GLenum  target,
        GLint   lod,
        GLsizei bufSize,
        void*   img,
    );
    alias PFN_glGetnUniformfvARB = void function (
        GLuint   program,
        GLint    location,
        GLsizei  bufSize,
        GLfloat* params,
    );
    alias PFN_glGetnUniformivARB = void function (
        GLuint  program,
        GLint   location,
        GLsizei bufSize,
        GLint*  params,
    );
    alias PFN_glGetnUniformuivARB = void function (
        GLuint  program,
        GLint   location,
        GLsizei bufSize,
        GLuint* params,
    );
    alias PFN_glGetnUniformdvARB = void function (
        GLuint    program,
        GLint     location,
        GLsizei   bufSize,
        GLdouble* params,
    );

    // Command pointers for GL_ARB_sample_locations
    alias PFN_glFramebufferSampleLocationsfvARB = void function (
        GLenum          target,
        GLuint          start,
        GLsizei         count,
        const(GLfloat)* v,
    );
    alias PFN_glNamedFramebufferSampleLocationsfvARB = void function (
        GLuint          framebuffer,
        GLuint          start,
        GLsizei         count,
        const(GLfloat)* v,
    );
    alias PFN_glEvaluateDepthValuesARB = void function ();

    // Command pointers for GL_ARB_shading_language_include
    alias PFN_glNamedStringARB = void function (
        GLenum         type,
        GLint          namelen,
        const(GLchar)* name,
        GLint          stringlen,
        const(GLchar)* string,
    );
    alias PFN_glDeleteNamedStringARB = void function (
        GLint          namelen,
        const(GLchar)* name,
    );
    alias PFN_glCompileShaderIncludeARB = void function (
        GLuint          shader,
        GLsizei         count,
        const(GLchar*)* path,
        const(GLint)*   length,
    );
    alias PFN_glIsNamedStringARB = GLboolean function (
        GLint          namelen,
        const(GLchar)* name,
    );
    alias PFN_glGetNamedStringARB = void function (
        GLint          namelen,
        const(GLchar)* name,
        GLsizei        bufSize,
        GLint*         stringlen,
        GLchar*        string,
    );
    alias PFN_glGetNamedStringivARB = void function (
        GLint          namelen,
        const(GLchar)* name,
        GLenum         pname,
        GLint*         params,
    );

    // Command pointers for GL_ARB_sparse_buffer
    alias PFN_glBufferPageCommitmentARB = void function (
        GLenum     target,
        GLintptr   offset,
        GLsizeiptr size,
        GLboolean  commit,
    );
    alias PFN_glNamedBufferPageCommitmentEXT = void function (
        GLuint     buffer,
        GLintptr   offset,
        GLsizeiptr size,
        GLboolean  commit,
    );
    alias PFN_glNamedBufferPageCommitmentARB = void function (
        GLuint     buffer,
        GLintptr   offset,
        GLsizeiptr size,
        GLboolean  commit,
    );

    // Command pointers for GL_ARB_sparse_texture
    alias PFN_glTexPageCommitmentARB = void function (
        GLenum    target,
        GLint     level,
        GLint     xoffset,
        GLint     yoffset,
        GLint     zoffset,
        GLsizei   width,
        GLsizei   height,
        GLsizei   depth,
        GLboolean commit,
    );

    // Command pointers for GL_KHR_blend_equation_advanced
    alias PFN_glBlendBarrierKHR = void function ();

    // Command pointers for GL_KHR_parallel_shader_compile
    alias PFN_glMaxShaderCompilerThreadsKHR = void function (
        GLuint count,
    );

    // Command pointers for GL_AMD_performance_monitor
    alias PFN_glGetPerfMonitorGroupsAMD = void function (
        GLint*  numGroups,
        GLsizei groupsSize,
        GLuint* groups,
    );
    alias PFN_glGetPerfMonitorCountersAMD = void function (
        GLuint  group,
        GLint*  numCounters,
        GLint*  maxActiveCounters,
        GLsizei counterSize,
        GLuint* counters,
    );
    alias PFN_glGetPerfMonitorGroupStringAMD = void function (
        GLuint   group,
        GLsizei  bufSize,
        GLsizei* length,
        GLchar*  groupString,
    );
    alias PFN_glGetPerfMonitorCounterStringAMD = void function (
        GLuint   group,
        GLuint   counter,
        GLsizei  bufSize,
        GLsizei* length,
        GLchar*  counterString,
    );
    alias PFN_glGetPerfMonitorCounterInfoAMD = void function (
        GLuint group,
        GLuint counter,
        GLenum pname,
        void*  data,
    );
    alias PFN_glGenPerfMonitorsAMD = void function (
        GLsizei n,
        GLuint* monitors,
    );
    alias PFN_glDeletePerfMonitorsAMD = void function (
        GLsizei n,
        GLuint* monitors,
    );
    alias PFN_glSelectPerfMonitorCountersAMD = void function (
        GLuint    monitor,
        GLboolean enable,
        GLuint    group,
        GLint     numCounters,
        GLuint*   counterList,
    );
    alias PFN_glBeginPerfMonitorAMD = void function (
        GLuint monitor,
    );
    alias PFN_glEndPerfMonitorAMD = void function (
        GLuint monitor,
    );
    alias PFN_glGetPerfMonitorCounterDataAMD = void function (
        GLuint  monitor,
        GLenum  pname,
        GLsizei dataSize,
        GLuint* data,
        GLint*  bytesWritten,
    );

    // Command pointers for GL_EXT_debug_label
    alias PFN_glLabelObjectEXT = void function (
        GLenum         type,
        GLuint         object,
        GLsizei        length,
        const(GLchar)* label,
    );
    alias PFN_glGetObjectLabelEXT = void function (
        GLenum   type,
        GLuint   object,
        GLsizei  bufSize,
        GLsizei* length,
        GLchar*  label,
    );

    // Command pointers for GL_EXT_debug_marker
    alias PFN_glInsertEventMarkerEXT = void function (
        GLsizei        length,
        const(GLchar)* marker,
    );
    alias PFN_glPushGroupMarkerEXT = void function (
        GLsizei        length,
        const(GLchar)* marker,
    );
    alias PFN_glPopGroupMarkerEXT = void function ();

    // Command pointers for GL_EXT_direct_state_access
    alias PFN_glMatrixLoadfEXT = void function (
        GLenum          mode,
        const(GLfloat)* m,
    );
    alias PFN_glMatrixLoaddEXT = void function (
        GLenum           mode,
        const(GLdouble)* m,
    );
    alias PFN_glMatrixMultfEXT = void function (
        GLenum          mode,
        const(GLfloat)* m,
    );
    alias PFN_glMatrixMultdEXT = void function (
        GLenum           mode,
        const(GLdouble)* m,
    );
    alias PFN_glMatrixLoadIdentityEXT = void function (
        GLenum mode,
    );
    alias PFN_glMatrixRotatefEXT = void function (
        GLenum  mode,
        GLfloat angle,
        GLfloat x,
        GLfloat y,
        GLfloat z,
    );
    alias PFN_glMatrixRotatedEXT = void function (
        GLenum   mode,
        GLdouble angle,
        GLdouble x,
        GLdouble y,
        GLdouble z,
    );
    alias PFN_glMatrixScalefEXT = void function (
        GLenum  mode,
        GLfloat x,
        GLfloat y,
        GLfloat z,
    );
    alias PFN_glMatrixScaledEXT = void function (
        GLenum   mode,
        GLdouble x,
        GLdouble y,
        GLdouble z,
    );
    alias PFN_glMatrixTranslatefEXT = void function (
        GLenum  mode,
        GLfloat x,
        GLfloat y,
        GLfloat z,
    );
    alias PFN_glMatrixTranslatedEXT = void function (
        GLenum   mode,
        GLdouble x,
        GLdouble y,
        GLdouble z,
    );
    alias PFN_glMatrixFrustumEXT = void function (
        GLenum   mode,
        GLdouble left,
        GLdouble right,
        GLdouble bottom,
        GLdouble top,
        GLdouble zNear,
        GLdouble zFar,
    );
    alias PFN_glMatrixOrthoEXT = void function (
        GLenum   mode,
        GLdouble left,
        GLdouble right,
        GLdouble bottom,
        GLdouble top,
        GLdouble zNear,
        GLdouble zFar,
    );
    alias PFN_glMatrixPopEXT = void function (
        GLenum mode,
    );
    alias PFN_glMatrixPushEXT = void function (
        GLenum mode,
    );
    alias PFN_glClientAttribDefaultEXT = void function (
        GLbitfield mask,
    );
    alias PFN_glPushClientAttribDefaultEXT = void function (
        GLbitfield mask,
    );
    alias PFN_glTextureParameterfEXT = void function (
        GLuint  texture,
        GLenum  target,
        GLenum  pname,
        GLfloat param,
    );
    alias PFN_glTextureParameterfvEXT = void function (
        GLuint          texture,
        GLenum          target,
        GLenum          pname,
        const(GLfloat)* params,
    );
    alias PFN_glTextureParameteriEXT = void function (
        GLuint texture,
        GLenum target,
        GLenum pname,
        GLint  param,
    );
    alias PFN_glTextureParameterivEXT = void function (
        GLuint        texture,
        GLenum        target,
        GLenum        pname,
        const(GLint)* params,
    );
    alias PFN_glTextureImage1DEXT = void function (
        GLuint       texture,
        GLenum       target,
        GLint        level,
        GLint        internalformat,
        GLsizei      width,
        GLint        border,
        GLenum       format,
        GLenum       type,
        const(void)* pixels,
    );
    alias PFN_glTextureImage2DEXT = void function (
        GLuint       texture,
        GLenum       target,
        GLint        level,
        GLint        internalformat,
        GLsizei      width,
        GLsizei      height,
        GLint        border,
        GLenum       format,
        GLenum       type,
        const(void)* pixels,
    );
    alias PFN_glTextureSubImage1DEXT = void function (
        GLuint       texture,
        GLenum       target,
        GLint        level,
        GLint        xoffset,
        GLsizei      width,
        GLenum       format,
        GLenum       type,
        const(void)* pixels,
    );
    alias PFN_glTextureSubImage2DEXT = void function (
        GLuint       texture,
        GLenum       target,
        GLint        level,
        GLint        xoffset,
        GLint        yoffset,
        GLsizei      width,
        GLsizei      height,
        GLenum       format,
        GLenum       type,
        const(void)* pixels,
    );
    alias PFN_glCopyTextureImage1DEXT = void function (
        GLuint  texture,
        GLenum  target,
        GLint   level,
        GLenum  internalformat,
        GLint   x,
        GLint   y,
        GLsizei width,
        GLint   border,
    );
    alias PFN_glCopyTextureImage2DEXT = void function (
        GLuint  texture,
        GLenum  target,
        GLint   level,
        GLenum  internalformat,
        GLint   x,
        GLint   y,
        GLsizei width,
        GLsizei height,
        GLint   border,
    );
    alias PFN_glCopyTextureSubImage1DEXT = void function (
        GLuint  texture,
        GLenum  target,
        GLint   level,
        GLint   xoffset,
        GLint   x,
        GLint   y,
        GLsizei width,
    );
    alias PFN_glCopyTextureSubImage2DEXT = void function (
        GLuint  texture,
        GLenum  target,
        GLint   level,
        GLint   xoffset,
        GLint   yoffset,
        GLint   x,
        GLint   y,
        GLsizei width,
        GLsizei height,
    );
    alias PFN_glGetTextureImageEXT = void function (
        GLuint texture,
        GLenum target,
        GLint  level,
        GLenum format,
        GLenum type,
        void*  pixels,
    );
    alias PFN_glGetTextureParameterfvEXT = void function (
        GLuint   texture,
        GLenum   target,
        GLenum   pname,
        GLfloat* params,
    );
    alias PFN_glGetTextureParameterivEXT = void function (
        GLuint texture,
        GLenum target,
        GLenum pname,
        GLint* params,
    );
    alias PFN_glGetTextureLevelParameterfvEXT = void function (
        GLuint   texture,
        GLenum   target,
        GLint    level,
        GLenum   pname,
        GLfloat* params,
    );
    alias PFN_glGetTextureLevelParameterivEXT = void function (
        GLuint texture,
        GLenum target,
        GLint  level,
        GLenum pname,
        GLint* params,
    );
    alias PFN_glTextureImage3DEXT = void function (
        GLuint       texture,
        GLenum       target,
        GLint        level,
        GLint        internalformat,
        GLsizei      width,
        GLsizei      height,
        GLsizei      depth,
        GLint        border,
        GLenum       format,
        GLenum       type,
        const(void)* pixels,
    );
    alias PFN_glTextureSubImage3DEXT = void function (
        GLuint       texture,
        GLenum       target,
        GLint        level,
        GLint        xoffset,
        GLint        yoffset,
        GLint        zoffset,
        GLsizei      width,
        GLsizei      height,
        GLsizei      depth,
        GLenum       format,
        GLenum       type,
        const(void)* pixels,
    );
    alias PFN_glCopyTextureSubImage3DEXT = void function (
        GLuint  texture,
        GLenum  target,
        GLint   level,
        GLint   xoffset,
        GLint   yoffset,
        GLint   zoffset,
        GLint   x,
        GLint   y,
        GLsizei width,
        GLsizei height,
    );
    alias PFN_glBindMultiTextureEXT = void function (
        GLenum texunit,
        GLenum target,
        GLuint texture,
    );
    alias PFN_glMultiTexCoordPointerEXT = void function (
        GLenum       texunit,
        GLint        size,
        GLenum       type,
        GLsizei      stride,
        const(void)* pointer,
    );
    alias PFN_glMultiTexEnvfEXT = void function (
        GLenum  texunit,
        GLenum  target,
        GLenum  pname,
        GLfloat param,
    );
    alias PFN_glMultiTexEnvfvEXT = void function (
        GLenum          texunit,
        GLenum          target,
        GLenum          pname,
        const(GLfloat)* params,
    );
    alias PFN_glMultiTexEnviEXT = void function (
        GLenum texunit,
        GLenum target,
        GLenum pname,
        GLint  param,
    );
    alias PFN_glMultiTexEnvivEXT = void function (
        GLenum        texunit,
        GLenum        target,
        GLenum        pname,
        const(GLint)* params,
    );
    alias PFN_glMultiTexGendEXT = void function (
        GLenum   texunit,
        GLenum   coord,
        GLenum   pname,
        GLdouble param,
    );
    alias PFN_glMultiTexGendvEXT = void function (
        GLenum           texunit,
        GLenum           coord,
        GLenum           pname,
        const(GLdouble)* params,
    );
    alias PFN_glMultiTexGenfEXT = void function (
        GLenum  texunit,
        GLenum  coord,
        GLenum  pname,
        GLfloat param,
    );
    alias PFN_glMultiTexGenfvEXT = void function (
        GLenum          texunit,
        GLenum          coord,
        GLenum          pname,
        const(GLfloat)* params,
    );
    alias PFN_glMultiTexGeniEXT = void function (
        GLenum texunit,
        GLenum coord,
        GLenum pname,
        GLint  param,
    );
    alias PFN_glMultiTexGenivEXT = void function (
        GLenum        texunit,
        GLenum        coord,
        GLenum        pname,
        const(GLint)* params,
    );
    alias PFN_glGetMultiTexEnvfvEXT = void function (
        GLenum   texunit,
        GLenum   target,
        GLenum   pname,
        GLfloat* params,
    );
    alias PFN_glGetMultiTexEnvivEXT = void function (
        GLenum texunit,
        GLenum target,
        GLenum pname,
        GLint* params,
    );
    alias PFN_glGetMultiTexGendvEXT = void function (
        GLenum    texunit,
        GLenum    coord,
        GLenum    pname,
        GLdouble* params,
    );
    alias PFN_glGetMultiTexGenfvEXT = void function (
        GLenum   texunit,
        GLenum   coord,
        GLenum   pname,
        GLfloat* params,
    );
    alias PFN_glGetMultiTexGenivEXT = void function (
        GLenum texunit,
        GLenum coord,
        GLenum pname,
        GLint* params,
    );
    alias PFN_glMultiTexParameteriEXT = void function (
        GLenum texunit,
        GLenum target,
        GLenum pname,
        GLint  param,
    );
    alias PFN_glMultiTexParameterivEXT = void function (
        GLenum        texunit,
        GLenum        target,
        GLenum        pname,
        const(GLint)* params,
    );
    alias PFN_glMultiTexParameterfEXT = void function (
        GLenum  texunit,
        GLenum  target,
        GLenum  pname,
        GLfloat param,
    );
    alias PFN_glMultiTexParameterfvEXT = void function (
        GLenum          texunit,
        GLenum          target,
        GLenum          pname,
        const(GLfloat)* params,
    );
    alias PFN_glMultiTexImage1DEXT = void function (
        GLenum       texunit,
        GLenum       target,
        GLint        level,
        GLint        internalformat,
        GLsizei      width,
        GLint        border,
        GLenum       format,
        GLenum       type,
        const(void)* pixels,
    );
    alias PFN_glMultiTexImage2DEXT = void function (
        GLenum       texunit,
        GLenum       target,
        GLint        level,
        GLint        internalformat,
        GLsizei      width,
        GLsizei      height,
        GLint        border,
        GLenum       format,
        GLenum       type,
        const(void)* pixels,
    );
    alias PFN_glMultiTexSubImage1DEXT = void function (
        GLenum       texunit,
        GLenum       target,
        GLint        level,
        GLint        xoffset,
        GLsizei      width,
        GLenum       format,
        GLenum       type,
        const(void)* pixels,
    );
    alias PFN_glMultiTexSubImage2DEXT = void function (
        GLenum       texunit,
        GLenum       target,
        GLint        level,
        GLint        xoffset,
        GLint        yoffset,
        GLsizei      width,
        GLsizei      height,
        GLenum       format,
        GLenum       type,
        const(void)* pixels,
    );
    alias PFN_glCopyMultiTexImage1DEXT = void function (
        GLenum  texunit,
        GLenum  target,
        GLint   level,
        GLenum  internalformat,
        GLint   x,
        GLint   y,
        GLsizei width,
        GLint   border,
    );
    alias PFN_glCopyMultiTexImage2DEXT = void function (
        GLenum  texunit,
        GLenum  target,
        GLint   level,
        GLenum  internalformat,
        GLint   x,
        GLint   y,
        GLsizei width,
        GLsizei height,
        GLint   border,
    );
    alias PFN_glCopyMultiTexSubImage1DEXT = void function (
        GLenum  texunit,
        GLenum  target,
        GLint   level,
        GLint   xoffset,
        GLint   x,
        GLint   y,
        GLsizei width,
    );
    alias PFN_glCopyMultiTexSubImage2DEXT = void function (
        GLenum  texunit,
        GLenum  target,
        GLint   level,
        GLint   xoffset,
        GLint   yoffset,
        GLint   x,
        GLint   y,
        GLsizei width,
        GLsizei height,
    );
    alias PFN_glGetMultiTexImageEXT = void function (
        GLenum texunit,
        GLenum target,
        GLint  level,
        GLenum format,
        GLenum type,
        void*  pixels,
    );
    alias PFN_glGetMultiTexParameterfvEXT = void function (
        GLenum   texunit,
        GLenum   target,
        GLenum   pname,
        GLfloat* params,
    );
    alias PFN_glGetMultiTexParameterivEXT = void function (
        GLenum texunit,
        GLenum target,
        GLenum pname,
        GLint* params,
    );
    alias PFN_glGetMultiTexLevelParameterfvEXT = void function (
        GLenum   texunit,
        GLenum   target,
        GLint    level,
        GLenum   pname,
        GLfloat* params,
    );
    alias PFN_glGetMultiTexLevelParameterivEXT = void function (
        GLenum texunit,
        GLenum target,
        GLint  level,
        GLenum pname,
        GLint* params,
    );
    alias PFN_glMultiTexImage3DEXT = void function (
        GLenum       texunit,
        GLenum       target,
        GLint        level,
        GLint        internalformat,
        GLsizei      width,
        GLsizei      height,
        GLsizei      depth,
        GLint        border,
        GLenum       format,
        GLenum       type,
        const(void)* pixels,
    );
    alias PFN_glMultiTexSubImage3DEXT = void function (
        GLenum       texunit,
        GLenum       target,
        GLint        level,
        GLint        xoffset,
        GLint        yoffset,
        GLint        zoffset,
        GLsizei      width,
        GLsizei      height,
        GLsizei      depth,
        GLenum       format,
        GLenum       type,
        const(void)* pixels,
    );
    alias PFN_glCopyMultiTexSubImage3DEXT = void function (
        GLenum  texunit,
        GLenum  target,
        GLint   level,
        GLint   xoffset,
        GLint   yoffset,
        GLint   zoffset,
        GLint   x,
        GLint   y,
        GLsizei width,
        GLsizei height,
    );
    alias PFN_glEnableClientStateIndexedEXT = void function (
        GLenum array,
        GLuint index,
    );
    alias PFN_glDisableClientStateIndexedEXT = void function (
        GLenum array,
        GLuint index,
    );
    alias PFN_glGetPointerIndexedvEXT = void function (
        GLenum target,
        GLuint index,
        void** data,
    );
    alias PFN_glCompressedTextureImage3DEXT = void function (
        GLuint       texture,
        GLenum       target,
        GLint        level,
        GLenum       internalformat,
        GLsizei      width,
        GLsizei      height,
        GLsizei      depth,
        GLint        border,
        GLsizei      imageSize,
        const(void)* bits,
    );
    alias PFN_glCompressedTextureImage2DEXT = void function (
        GLuint       texture,
        GLenum       target,
        GLint        level,
        GLenum       internalformat,
        GLsizei      width,
        GLsizei      height,
        GLint        border,
        GLsizei      imageSize,
        const(void)* bits,
    );
    alias PFN_glCompressedTextureImage1DEXT = void function (
        GLuint       texture,
        GLenum       target,
        GLint        level,
        GLenum       internalformat,
        GLsizei      width,
        GLint        border,
        GLsizei      imageSize,
        const(void)* bits,
    );
    alias PFN_glCompressedTextureSubImage3DEXT = void function (
        GLuint       texture,
        GLenum       target,
        GLint        level,
        GLint        xoffset,
        GLint        yoffset,
        GLint        zoffset,
        GLsizei      width,
        GLsizei      height,
        GLsizei      depth,
        GLenum       format,
        GLsizei      imageSize,
        const(void)* bits,
    );
    alias PFN_glCompressedTextureSubImage2DEXT = void function (
        GLuint       texture,
        GLenum       target,
        GLint        level,
        GLint        xoffset,
        GLint        yoffset,
        GLsizei      width,
        GLsizei      height,
        GLenum       format,
        GLsizei      imageSize,
        const(void)* bits,
    );
    alias PFN_glCompressedTextureSubImage1DEXT = void function (
        GLuint       texture,
        GLenum       target,
        GLint        level,
        GLint        xoffset,
        GLsizei      width,
        GLenum       format,
        GLsizei      imageSize,
        const(void)* bits,
    );
    alias PFN_glGetCompressedTextureImageEXT = void function (
        GLuint texture,
        GLenum target,
        GLint  lod,
        void*  img,
    );
    alias PFN_glCompressedMultiTexImage3DEXT = void function (
        GLenum       texunit,
        GLenum       target,
        GLint        level,
        GLenum       internalformat,
        GLsizei      width,
        GLsizei      height,
        GLsizei      depth,
        GLint        border,
        GLsizei      imageSize,
        const(void)* bits,
    );
    alias PFN_glCompressedMultiTexImage2DEXT = void function (
        GLenum       texunit,
        GLenum       target,
        GLint        level,
        GLenum       internalformat,
        GLsizei      width,
        GLsizei      height,
        GLint        border,
        GLsizei      imageSize,
        const(void)* bits,
    );
    alias PFN_glCompressedMultiTexImage1DEXT = void function (
        GLenum       texunit,
        GLenum       target,
        GLint        level,
        GLenum       internalformat,
        GLsizei      width,
        GLint        border,
        GLsizei      imageSize,
        const(void)* bits,
    );
    alias PFN_glCompressedMultiTexSubImage3DEXT = void function (
        GLenum       texunit,
        GLenum       target,
        GLint        level,
        GLint        xoffset,
        GLint        yoffset,
        GLint        zoffset,
        GLsizei      width,
        GLsizei      height,
        GLsizei      depth,
        GLenum       format,
        GLsizei      imageSize,
        const(void)* bits,
    );
    alias PFN_glCompressedMultiTexSubImage2DEXT = void function (
        GLenum       texunit,
        GLenum       target,
        GLint        level,
        GLint        xoffset,
        GLint        yoffset,
        GLsizei      width,
        GLsizei      height,
        GLenum       format,
        GLsizei      imageSize,
        const(void)* bits,
    );
    alias PFN_glCompressedMultiTexSubImage1DEXT = void function (
        GLenum       texunit,
        GLenum       target,
        GLint        level,
        GLint        xoffset,
        GLsizei      width,
        GLenum       format,
        GLsizei      imageSize,
        const(void)* bits,
    );
    alias PFN_glGetCompressedMultiTexImageEXT = void function (
        GLenum texunit,
        GLenum target,
        GLint  lod,
        void*  img,
    );
    alias PFN_glMatrixLoadTransposefEXT = void function (
        GLenum          mode,
        const(GLfloat)* m,
    );
    alias PFN_glMatrixLoadTransposedEXT = void function (
        GLenum           mode,
        const(GLdouble)* m,
    );
    alias PFN_glMatrixMultTransposefEXT = void function (
        GLenum          mode,
        const(GLfloat)* m,
    );
    alias PFN_glMatrixMultTransposedEXT = void function (
        GLenum           mode,
        const(GLdouble)* m,
    );
    alias PFN_glNamedBufferDataEXT = void function (
        GLuint       buffer,
        GLsizeiptr   size,
        const(void)* data,
        GLenum       usage,
    );
    alias PFN_glMapNamedBufferEXT = void * function (
        GLuint buffer,
        GLenum access,
    );
    alias PFN_glUnmapNamedBufferEXT = GLboolean function (
        GLuint buffer,
    );
    alias PFN_glGetNamedBufferParameterivEXT = void function (
        GLuint buffer,
        GLenum pname,
        GLint* params,
    );
    alias PFN_glGetNamedBufferPointervEXT = void function (
        GLuint buffer,
        GLenum pname,
        void** params,
    );
    alias PFN_glGetNamedBufferSubDataEXT = void function (
        GLuint     buffer,
        GLintptr   offset,
        GLsizeiptr size,
        void*      data,
    );
    alias PFN_glTextureBufferEXT = void function (
        GLuint texture,
        GLenum target,
        GLenum internalformat,
        GLuint buffer,
    );
    alias PFN_glMultiTexBufferEXT = void function (
        GLenum texunit,
        GLenum target,
        GLenum internalformat,
        GLuint buffer,
    );
    alias PFN_glTextureParameterIivEXT = void function (
        GLuint        texture,
        GLenum        target,
        GLenum        pname,
        const(GLint)* params,
    );
    alias PFN_glTextureParameterIuivEXT = void function (
        GLuint         texture,
        GLenum         target,
        GLenum         pname,
        const(GLuint)* params,
    );
    alias PFN_glGetTextureParameterIivEXT = void function (
        GLuint texture,
        GLenum target,
        GLenum pname,
        GLint* params,
    );
    alias PFN_glGetTextureParameterIuivEXT = void function (
        GLuint  texture,
        GLenum  target,
        GLenum  pname,
        GLuint* params,
    );
    alias PFN_glMultiTexParameterIivEXT = void function (
        GLenum        texunit,
        GLenum        target,
        GLenum        pname,
        const(GLint)* params,
    );
    alias PFN_glMultiTexParameterIuivEXT = void function (
        GLenum         texunit,
        GLenum         target,
        GLenum         pname,
        const(GLuint)* params,
    );
    alias PFN_glGetMultiTexParameterIivEXT = void function (
        GLenum texunit,
        GLenum target,
        GLenum pname,
        GLint* params,
    );
    alias PFN_glGetMultiTexParameterIuivEXT = void function (
        GLenum  texunit,
        GLenum  target,
        GLenum  pname,
        GLuint* params,
    );
    alias PFN_glNamedProgramLocalParameters4fvEXT = void function (
        GLuint          program,
        GLenum          target,
        GLuint          index,
        GLsizei         count,
        const(GLfloat)* params,
    );
    alias PFN_glNamedProgramLocalParameterI4iEXT = void function (
        GLuint program,
        GLenum target,
        GLuint index,
        GLint  x,
        GLint  y,
        GLint  z,
        GLint  w,
    );
    alias PFN_glNamedProgramLocalParameterI4ivEXT = void function (
        GLuint        program,
        GLenum        target,
        GLuint        index,
        const(GLint)* params,
    );
    alias PFN_glNamedProgramLocalParametersI4ivEXT = void function (
        GLuint        program,
        GLenum        target,
        GLuint        index,
        GLsizei       count,
        const(GLint)* params,
    );
    alias PFN_glNamedProgramLocalParameterI4uiEXT = void function (
        GLuint program,
        GLenum target,
        GLuint index,
        GLuint x,
        GLuint y,
        GLuint z,
        GLuint w,
    );
    alias PFN_glNamedProgramLocalParameterI4uivEXT = void function (
        GLuint         program,
        GLenum         target,
        GLuint         index,
        const(GLuint)* params,
    );
    alias PFN_glNamedProgramLocalParametersI4uivEXT = void function (
        GLuint         program,
        GLenum         target,
        GLuint         index,
        GLsizei        count,
        const(GLuint)* params,
    );
    alias PFN_glGetNamedProgramLocalParameterIivEXT = void function (
        GLuint program,
        GLenum target,
        GLuint index,
        GLint* params,
    );
    alias PFN_glGetNamedProgramLocalParameterIuivEXT = void function (
        GLuint  program,
        GLenum  target,
        GLuint  index,
        GLuint* params,
    );
    alias PFN_glEnableClientStateiEXT = void function (
        GLenum array,
        GLuint index,
    );
    alias PFN_glDisableClientStateiEXT = void function (
        GLenum array,
        GLuint index,
    );
    alias PFN_glGetPointeri_vEXT = void function (
        GLenum pname,
        GLuint index,
        void** params,
    );
    alias PFN_glNamedProgramStringEXT = void function (
        GLuint       program,
        GLenum       target,
        GLenum       format,
        GLsizei      len,
        const(void)* string,
    );
    alias PFN_glNamedProgramLocalParameter4dEXT = void function (
        GLuint   program,
        GLenum   target,
        GLuint   index,
        GLdouble x,
        GLdouble y,
        GLdouble z,
        GLdouble w,
    );
    alias PFN_glNamedProgramLocalParameter4dvEXT = void function (
        GLuint           program,
        GLenum           target,
        GLuint           index,
        const(GLdouble)* params,
    );
    alias PFN_glNamedProgramLocalParameter4fEXT = void function (
        GLuint  program,
        GLenum  target,
        GLuint  index,
        GLfloat x,
        GLfloat y,
        GLfloat z,
        GLfloat w,
    );
    alias PFN_glNamedProgramLocalParameter4fvEXT = void function (
        GLuint          program,
        GLenum          target,
        GLuint          index,
        const(GLfloat)* params,
    );
    alias PFN_glGetNamedProgramLocalParameterdvEXT = void function (
        GLuint    program,
        GLenum    target,
        GLuint    index,
        GLdouble* params,
    );
    alias PFN_glGetNamedProgramLocalParameterfvEXT = void function (
        GLuint   program,
        GLenum   target,
        GLuint   index,
        GLfloat* params,
    );
    alias PFN_glGetNamedProgramivEXT = void function (
        GLuint program,
        GLenum target,
        GLenum pname,
        GLint* params,
    );
    alias PFN_glGetNamedProgramStringEXT = void function (
        GLuint program,
        GLenum target,
        GLenum pname,
        void*  string,
    );
    alias PFN_glNamedRenderbufferStorageEXT = void function (
        GLuint  renderbuffer,
        GLenum  internalformat,
        GLsizei width,
        GLsizei height,
    );
    alias PFN_glGetNamedRenderbufferParameterivEXT = void function (
        GLuint renderbuffer,
        GLenum pname,
        GLint* params,
    );
    alias PFN_glNamedRenderbufferStorageMultisampleEXT = void function (
        GLuint  renderbuffer,
        GLsizei samples,
        GLenum  internalformat,
        GLsizei width,
        GLsizei height,
    );
    alias PFN_glNamedRenderbufferStorageMultisampleCoverageEXT = void function (
        GLuint  renderbuffer,
        GLsizei coverageSamples,
        GLsizei colorSamples,
        GLenum  internalformat,
        GLsizei width,
        GLsizei height,
    );
    alias PFN_glCheckNamedFramebufferStatusEXT = GLenum function (
        GLuint framebuffer,
        GLenum target,
    );
    alias PFN_glNamedFramebufferTexture1DEXT = void function (
        GLuint framebuffer,
        GLenum attachment,
        GLenum textarget,
        GLuint texture,
        GLint  level,
    );
    alias PFN_glNamedFramebufferTexture2DEXT = void function (
        GLuint framebuffer,
        GLenum attachment,
        GLenum textarget,
        GLuint texture,
        GLint  level,
    );
    alias PFN_glNamedFramebufferTexture3DEXT = void function (
        GLuint framebuffer,
        GLenum attachment,
        GLenum textarget,
        GLuint texture,
        GLint  level,
        GLint  zoffset,
    );
    alias PFN_glNamedFramebufferRenderbufferEXT = void function (
        GLuint framebuffer,
        GLenum attachment,
        GLenum renderbuffertarget,
        GLuint renderbuffer,
    );
    alias PFN_glGetNamedFramebufferAttachmentParameterivEXT = void function (
        GLuint framebuffer,
        GLenum attachment,
        GLenum pname,
        GLint* params,
    );
    alias PFN_glGenerateTextureMipmapEXT = void function (
        GLuint texture,
        GLenum target,
    );
    alias PFN_glGenerateMultiTexMipmapEXT = void function (
        GLenum texunit,
        GLenum target,
    );
    alias PFN_glFramebufferDrawBufferEXT = void function (
        GLuint framebuffer,
        GLenum mode,
    );
    alias PFN_glFramebufferDrawBuffersEXT = void function (
        GLuint         framebuffer,
        GLsizei        n,
        const(GLenum)* bufs,
    );
    alias PFN_glFramebufferReadBufferEXT = void function (
        GLuint framebuffer,
        GLenum mode,
    );
    alias PFN_glGetFramebufferParameterivEXT = void function (
        GLuint framebuffer,
        GLenum pname,
        GLint* params,
    );
    alias PFN_glNamedCopyBufferSubDataEXT = void function (
        GLuint     readBuffer,
        GLuint     writeBuffer,
        GLintptr   readOffset,
        GLintptr   writeOffset,
        GLsizeiptr size,
    );
    alias PFN_glNamedFramebufferTextureEXT = void function (
        GLuint framebuffer,
        GLenum attachment,
        GLuint texture,
        GLint  level,
    );
    alias PFN_glNamedFramebufferTextureLayerEXT = void function (
        GLuint framebuffer,
        GLenum attachment,
        GLuint texture,
        GLint  level,
        GLint  layer,
    );
    alias PFN_glNamedFramebufferTextureFaceEXT = void function (
        GLuint framebuffer,
        GLenum attachment,
        GLuint texture,
        GLint  level,
        GLenum face,
    );
    alias PFN_glTextureRenderbufferEXT = void function (
        GLuint texture,
        GLenum target,
        GLuint renderbuffer,
    );
    alias PFN_glMultiTexRenderbufferEXT = void function (
        GLenum texunit,
        GLenum target,
        GLuint renderbuffer,
    );
    alias PFN_glVertexArrayVertexOffsetEXT = void function (
        GLuint   vaobj,
        GLuint   buffer,
        GLint    size,
        GLenum   type,
        GLsizei  stride,
        GLintptr offset,
    );
    alias PFN_glVertexArrayColorOffsetEXT = void function (
        GLuint   vaobj,
        GLuint   buffer,
        GLint    size,
        GLenum   type,
        GLsizei  stride,
        GLintptr offset,
    );
    alias PFN_glVertexArrayEdgeFlagOffsetEXT = void function (
        GLuint   vaobj,
        GLuint   buffer,
        GLsizei  stride,
        GLintptr offset,
    );
    alias PFN_glVertexArrayIndexOffsetEXT = void function (
        GLuint   vaobj,
        GLuint   buffer,
        GLenum   type,
        GLsizei  stride,
        GLintptr offset,
    );
    alias PFN_glVertexArrayNormalOffsetEXT = void function (
        GLuint   vaobj,
        GLuint   buffer,
        GLenum   type,
        GLsizei  stride,
        GLintptr offset,
    );
    alias PFN_glVertexArrayTexCoordOffsetEXT = void function (
        GLuint   vaobj,
        GLuint   buffer,
        GLint    size,
        GLenum   type,
        GLsizei  stride,
        GLintptr offset,
    );
    alias PFN_glVertexArrayMultiTexCoordOffsetEXT = void function (
        GLuint   vaobj,
        GLuint   buffer,
        GLenum   texunit,
        GLint    size,
        GLenum   type,
        GLsizei  stride,
        GLintptr offset,
    );
    alias PFN_glVertexArrayFogCoordOffsetEXT = void function (
        GLuint   vaobj,
        GLuint   buffer,
        GLenum   type,
        GLsizei  stride,
        GLintptr offset,
    );
    alias PFN_glVertexArraySecondaryColorOffsetEXT = void function (
        GLuint   vaobj,
        GLuint   buffer,
        GLint    size,
        GLenum   type,
        GLsizei  stride,
        GLintptr offset,
    );
    alias PFN_glVertexArrayVertexAttribOffsetEXT = void function (
        GLuint    vaobj,
        GLuint    buffer,
        GLuint    index,
        GLint     size,
        GLenum    type,
        GLboolean normalized,
        GLsizei   stride,
        GLintptr  offset,
    );
    alias PFN_glVertexArrayVertexAttribIOffsetEXT = void function (
        GLuint   vaobj,
        GLuint   buffer,
        GLuint   index,
        GLint    size,
        GLenum   type,
        GLsizei  stride,
        GLintptr offset,
    );
    alias PFN_glEnableVertexArrayEXT = void function (
        GLuint vaobj,
        GLenum array,
    );
    alias PFN_glDisableVertexArrayEXT = void function (
        GLuint vaobj,
        GLenum array,
    );
    alias PFN_glEnableVertexArrayAttribEXT = void function (
        GLuint vaobj,
        GLuint index,
    );
    alias PFN_glDisableVertexArrayAttribEXT = void function (
        GLuint vaobj,
        GLuint index,
    );
    alias PFN_glGetVertexArrayIntegervEXT = void function (
        GLuint vaobj,
        GLenum pname,
        GLint* param,
    );
    alias PFN_glGetVertexArrayPointervEXT = void function (
        GLuint vaobj,
        GLenum pname,
        void** param,
    );
    alias PFN_glGetVertexArrayIntegeri_vEXT = void function (
        GLuint vaobj,
        GLuint index,
        GLenum pname,
        GLint* param,
    );
    alias PFN_glGetVertexArrayPointeri_vEXT = void function (
        GLuint vaobj,
        GLuint index,
        GLenum pname,
        void** param,
    );
    alias PFN_glMapNamedBufferRangeEXT = void * function (
        GLuint     buffer,
        GLintptr   offset,
        GLsizeiptr length,
        GLbitfield access,
    );
    alias PFN_glFlushMappedNamedBufferRangeEXT = void function (
        GLuint     buffer,
        GLintptr   offset,
        GLsizeiptr length,
    );
    alias PFN_glClearNamedBufferDataEXT = void function (
        GLuint       buffer,
        GLenum       internalformat,
        GLenum       format,
        GLenum       type,
        const(void)* data,
    );
    alias PFN_glClearNamedBufferSubDataEXT = void function (
        GLuint       buffer,
        GLenum       internalformat,
        GLsizeiptr   offset,
        GLsizeiptr   size,
        GLenum       format,
        GLenum       type,
        const(void)* data,
    );
    alias PFN_glNamedFramebufferParameteriEXT = void function (
        GLuint framebuffer,
        GLenum pname,
        GLint  param,
    );
    alias PFN_glGetNamedFramebufferParameterivEXT = void function (
        GLuint framebuffer,
        GLenum pname,
        GLint* params,
    );
    alias PFN_glProgramUniform1dEXT = void function (
        GLuint   program,
        GLint    location,
        GLdouble x,
    );
    alias PFN_glProgramUniform2dEXT = void function (
        GLuint   program,
        GLint    location,
        GLdouble x,
        GLdouble y,
    );
    alias PFN_glProgramUniform3dEXT = void function (
        GLuint   program,
        GLint    location,
        GLdouble x,
        GLdouble y,
        GLdouble z,
    );
    alias PFN_glProgramUniform4dEXT = void function (
        GLuint   program,
        GLint    location,
        GLdouble x,
        GLdouble y,
        GLdouble z,
        GLdouble w,
    );
    alias PFN_glProgramUniform1dvEXT = void function (
        GLuint           program,
        GLint            location,
        GLsizei          count,
        const(GLdouble)* value,
    );
    alias PFN_glProgramUniform2dvEXT = void function (
        GLuint           program,
        GLint            location,
        GLsizei          count,
        const(GLdouble)* value,
    );
    alias PFN_glProgramUniform3dvEXT = void function (
        GLuint           program,
        GLint            location,
        GLsizei          count,
        const(GLdouble)* value,
    );
    alias PFN_glProgramUniform4dvEXT = void function (
        GLuint           program,
        GLint            location,
        GLsizei          count,
        const(GLdouble)* value,
    );
    alias PFN_glProgramUniformMatrix2dvEXT = void function (
        GLuint           program,
        GLint            location,
        GLsizei          count,
        GLboolean        transpose,
        const(GLdouble)* value,
    );
    alias PFN_glProgramUniformMatrix3dvEXT = void function (
        GLuint           program,
        GLint            location,
        GLsizei          count,
        GLboolean        transpose,
        const(GLdouble)* value,
    );
    alias PFN_glProgramUniformMatrix4dvEXT = void function (
        GLuint           program,
        GLint            location,
        GLsizei          count,
        GLboolean        transpose,
        const(GLdouble)* value,
    );
    alias PFN_glProgramUniformMatrix2x3dvEXT = void function (
        GLuint           program,
        GLint            location,
        GLsizei          count,
        GLboolean        transpose,
        const(GLdouble)* value,
    );
    alias PFN_glProgramUniformMatrix2x4dvEXT = void function (
        GLuint           program,
        GLint            location,
        GLsizei          count,
        GLboolean        transpose,
        const(GLdouble)* value,
    );
    alias PFN_glProgramUniformMatrix3x2dvEXT = void function (
        GLuint           program,
        GLint            location,
        GLsizei          count,
        GLboolean        transpose,
        const(GLdouble)* value,
    );
    alias PFN_glProgramUniformMatrix3x4dvEXT = void function (
        GLuint           program,
        GLint            location,
        GLsizei          count,
        GLboolean        transpose,
        const(GLdouble)* value,
    );
    alias PFN_glProgramUniformMatrix4x2dvEXT = void function (
        GLuint           program,
        GLint            location,
        GLsizei          count,
        GLboolean        transpose,
        const(GLdouble)* value,
    );
    alias PFN_glProgramUniformMatrix4x3dvEXT = void function (
        GLuint           program,
        GLint            location,
        GLsizei          count,
        GLboolean        transpose,
        const(GLdouble)* value,
    );
    alias PFN_glTextureBufferRangeEXT = void function (
        GLuint     texture,
        GLenum     target,
        GLenum     internalformat,
        GLuint     buffer,
        GLintptr   offset,
        GLsizeiptr size,
    );
    alias PFN_glTextureStorage1DEXT = void function (
        GLuint  texture,
        GLenum  target,
        GLsizei levels,
        GLenum  internalformat,
        GLsizei width,
    );
    alias PFN_glTextureStorage2DEXT = void function (
        GLuint  texture,
        GLenum  target,
        GLsizei levels,
        GLenum  internalformat,
        GLsizei width,
        GLsizei height,
    );
    alias PFN_glTextureStorage3DEXT = void function (
        GLuint  texture,
        GLenum  target,
        GLsizei levels,
        GLenum  internalformat,
        GLsizei width,
        GLsizei height,
        GLsizei depth,
    );
    alias PFN_glTextureStorage2DMultisampleEXT = void function (
        GLuint    texture,
        GLenum    target,
        GLsizei   samples,
        GLenum    internalformat,
        GLsizei   width,
        GLsizei   height,
        GLboolean fixedsamplelocations,
    );
    alias PFN_glTextureStorage3DMultisampleEXT = void function (
        GLuint    texture,
        GLenum    target,
        GLsizei   samples,
        GLenum    internalformat,
        GLsizei   width,
        GLsizei   height,
        GLsizei   depth,
        GLboolean fixedsamplelocations,
    );
    alias PFN_glVertexArrayBindVertexBufferEXT = void function (
        GLuint   vaobj,
        GLuint   bindingindex,
        GLuint   buffer,
        GLintptr offset,
        GLsizei  stride,
    );
    alias PFN_glVertexArrayVertexAttribFormatEXT = void function (
        GLuint    vaobj,
        GLuint    attribindex,
        GLint     size,
        GLenum    type,
        GLboolean normalized,
        GLuint    relativeoffset,
    );
    alias PFN_glVertexArrayVertexAttribIFormatEXT = void function (
        GLuint vaobj,
        GLuint attribindex,
        GLint  size,
        GLenum type,
        GLuint relativeoffset,
    );
    alias PFN_glVertexArrayVertexAttribLFormatEXT = void function (
        GLuint vaobj,
        GLuint attribindex,
        GLint  size,
        GLenum type,
        GLuint relativeoffset,
    );
    alias PFN_glVertexArrayVertexAttribBindingEXT = void function (
        GLuint vaobj,
        GLuint attribindex,
        GLuint bindingindex,
    );
    alias PFN_glVertexArrayVertexBindingDivisorEXT = void function (
        GLuint vaobj,
        GLuint bindingindex,
        GLuint divisor,
    );
    alias PFN_glVertexArrayVertexAttribLOffsetEXT = void function (
        GLuint   vaobj,
        GLuint   buffer,
        GLuint   index,
        GLint    size,
        GLenum   type,
        GLsizei  stride,
        GLintptr offset,
    );
    alias PFN_glTexturePageCommitmentEXT = void function (
        GLuint    texture,
        GLint     level,
        GLint     xoffset,
        GLint     yoffset,
        GLint     zoffset,
        GLsizei   width,
        GLsizei   height,
        GLsizei   depth,
        GLboolean commit,
    );
    alias PFN_glVertexArrayVertexAttribDivisorEXT = void function (
        GLuint vaobj,
        GLuint index,
        GLuint divisor,
    );

    // Command pointers for GL_EXT_raster_multisample
    alias PFN_glRasterSamplesEXT = void function (
        GLuint    samples,
        GLboolean fixedsamplelocations,
    );

    // Command pointers for GL_EXT_separate_shader_objects
    alias PFN_glUseShaderProgramEXT = void function (
        GLenum type,
        GLuint program,
    );
    alias PFN_glActiveProgramEXT = void function (
        GLuint program,
    );
    alias PFN_glCreateShaderProgramEXT = GLuint function (
        GLenum         type,
        const(GLchar)* string,
    );

    // Command pointers for GL_EXT_window_rectangles
    alias PFN_glWindowRectanglesEXT = void function (
        GLenum        mode,
        GLsizei       count,
        const(GLint)* box,
    );

    // Command pointers for GL_INTEL_framebuffer_CMAA
    alias PFN_glApplyFramebufferAttachmentCMAAINTEL = void function ();

    // Command pointers for GL_INTEL_performance_query
    alias PFN_glBeginPerfQueryINTEL = void function (
        GLuint queryHandle,
    );
    alias PFN_glCreatePerfQueryINTEL = void function (
        GLuint  queryId,
        GLuint* queryHandle,
    );
    alias PFN_glDeletePerfQueryINTEL = void function (
        GLuint queryHandle,
    );
    alias PFN_glEndPerfQueryINTEL = void function (
        GLuint queryHandle,
    );
    alias PFN_glGetFirstPerfQueryIdINTEL = void function (
        GLuint* queryId,
    );
    alias PFN_glGetNextPerfQueryIdINTEL = void function (
        GLuint  queryId,
        GLuint* nextQueryId,
    );
    alias PFN_glGetPerfCounterInfoINTEL = void function (
        GLuint    queryId,
        GLuint    counterId,
        GLuint    counterNameLength,
        GLchar*   counterName,
        GLuint    counterDescLength,
        GLchar*   counterDesc,
        GLuint*   counterOffset,
        GLuint*   counterDataSize,
        GLuint*   counterTypeEnum,
        GLuint*   counterDataTypeEnum,
        GLuint64* rawCounterMaxValue,
    );
    alias PFN_glGetPerfQueryDataINTEL = void function (
        GLuint  queryHandle,
        GLuint  flags,
        GLsizei dataSize,
        void*   data,
        GLuint* bytesWritten,
    );
    alias PFN_glGetPerfQueryIdByNameINTEL = void function (
        GLchar* queryName,
        GLuint* queryId,
    );
    alias PFN_glGetPerfQueryInfoINTEL = void function (
        GLuint  queryId,
        GLuint  queryNameLength,
        GLchar* queryName,
        GLuint* dataSize,
        GLuint* noCounters,
        GLuint* noInstances,
        GLuint* capsMask,
    );

    // Command pointers for GL_NV_bindless_multi_draw_indirect
    alias PFN_glMultiDrawArraysIndirectBindlessNV = void function (
        GLenum       mode,
        const(void)* indirect,
        GLsizei      drawCount,
        GLsizei      stride,
        GLint        vertexBufferCount,
    );
    alias PFN_glMultiDrawElementsIndirectBindlessNV = void function (
        GLenum       mode,
        GLenum       type,
        const(void)* indirect,
        GLsizei      drawCount,
        GLsizei      stride,
        GLint        vertexBufferCount,
    );

    // Command pointers for GL_NV_bindless_multi_draw_indirect_count
    alias PFN_glMultiDrawArraysIndirectBindlessCountNV = void function (
        GLenum       mode,
        const(void)* indirect,
        GLsizei      drawCount,
        GLsizei      maxDrawCount,
        GLsizei      stride,
        GLint        vertexBufferCount,
    );
    alias PFN_glMultiDrawElementsIndirectBindlessCountNV = void function (
        GLenum       mode,
        GLenum       type,
        const(void)* indirect,
        GLsizei      drawCount,
        GLsizei      maxDrawCount,
        GLsizei      stride,
        GLint        vertexBufferCount,
    );

    // Command pointers for GL_NV_bindless_texture
    alias PFN_glGetTextureHandleNV = GLuint64 function (
        GLuint texture,
    );
    alias PFN_glGetTextureSamplerHandleNV = GLuint64 function (
        GLuint texture,
        GLuint sampler,
    );
    alias PFN_glMakeTextureHandleResidentNV = void function (
        GLuint64 handle,
    );
    alias PFN_glMakeTextureHandleNonResidentNV = void function (
        GLuint64 handle,
    );
    alias PFN_glGetImageHandleNV = GLuint64 function (
        GLuint    texture,
        GLint     level,
        GLboolean layered,
        GLint     layer,
        GLenum    format,
    );
    alias PFN_glMakeImageHandleResidentNV = void function (
        GLuint64 handle,
        GLenum   access,
    );
    alias PFN_glMakeImageHandleNonResidentNV = void function (
        GLuint64 handle,
    );
    alias PFN_glUniformHandleui64NV = void function (
        GLint    location,
        GLuint64 value,
    );
    alias PFN_glUniformHandleui64vNV = void function (
        GLint            location,
        GLsizei          count,
        const(GLuint64)* value,
    );
    alias PFN_glProgramUniformHandleui64NV = void function (
        GLuint   program,
        GLint    location,
        GLuint64 value,
    );
    alias PFN_glProgramUniformHandleui64vNV = void function (
        GLuint           program,
        GLint            location,
        GLsizei          count,
        const(GLuint64)* values,
    );
    alias PFN_glIsTextureHandleResidentNV = GLboolean function (
        GLuint64 handle,
    );
    alias PFN_glIsImageHandleResidentNV = GLboolean function (
        GLuint64 handle,
    );

    // Command pointers for GL_NV_blend_equation_advanced
    alias PFN_glBlendParameteriNV = void function (
        GLenum pname,
        GLint  value,
    );
    alias PFN_glBlendBarrierNV = void function ();

    // Command pointers for GL_NV_clip_space_w_scaling
    alias PFN_glViewportPositionWScaleNV = void function (
        GLuint  index,
        GLfloat xcoeff,
        GLfloat ycoeff,
    );

    // Command pointers for GL_NV_command_list
    alias PFN_glCreateStatesNV = void function (
        GLsizei n,
        GLuint* states,
    );
    alias PFN_glDeleteStatesNV = void function (
        GLsizei        n,
        const(GLuint)* states,
    );
    alias PFN_glIsStateNV = GLboolean function (
        GLuint state,
    );
    alias PFN_glStateCaptureNV = void function (
        GLuint state,
        GLenum mode,
    );
    alias PFN_glGetCommandHeaderNV = GLuint function (
        GLenum tokenID,
        GLuint size,
    );
    alias PFN_glGetStageIndexNV = GLushort function (
        GLenum shadertype,
    );
    alias PFN_glDrawCommandsNV = void function (
        GLenum           primitiveMode,
        GLuint           buffer,
        const(GLintptr)* indirects,
        const(GLsizei)*  sizes,
        GLuint           count,
    );
    alias PFN_glDrawCommandsAddressNV = void function (
        GLenum           primitiveMode,
        const(GLuint64)* indirects,
        const(GLsizei)*  sizes,
        GLuint           count,
    );
    alias PFN_glDrawCommandsStatesNV = void function (
        GLuint           buffer,
        const(GLintptr)* indirects,
        const(GLsizei)*  sizes,
        const(GLuint)*   states,
        const(GLuint)*   fbos,
        GLuint           count,
    );
    alias PFN_glDrawCommandsStatesAddressNV = void function (
        const(GLuint64)* indirects,
        const(GLsizei)*  sizes,
        const(GLuint)*   states,
        const(GLuint)*   fbos,
        GLuint           count,
    );
    alias PFN_glCreateCommandListsNV = void function (
        GLsizei n,
        GLuint* lists,
    );
    alias PFN_glDeleteCommandListsNV = void function (
        GLsizei        n,
        const(GLuint)* lists,
    );
    alias PFN_glIsCommandListNV = GLboolean function (
        GLuint list,
    );
    alias PFN_glListDrawCommandsStatesClientNV = void function (
        GLuint          list,
        GLuint          segment,
        const(void*)*   indirects,
        const(GLsizei)* sizes,
        const(GLuint)*  states,
        const(GLuint)*  fbos,
        GLuint          count,
    );
    alias PFN_glCommandListSegmentsNV = void function (
        GLuint list,
        GLuint segments,
    );
    alias PFN_glCompileCommandListNV = void function (
        GLuint list,
    );
    alias PFN_glCallCommandListNV = void function (
        GLuint list,
    );

    // Command pointers for GL_NV_conservative_raster
    alias PFN_glSubpixelPrecisionBiasNV = void function (
        GLuint xbits,
        GLuint ybits,
    );

    // Command pointers for GL_NV_conservative_raster_dilate
    alias PFN_glConservativeRasterParameterfNV = void function (
        GLenum  pname,
        GLfloat value,
    );

    // Command pointers for GL_NV_conservative_raster_pre_snap_triangles
    alias PFN_glConservativeRasterParameteriNV = void function (
        GLenum pname,
        GLint  param,
    );

    // Command pointers for GL_NV_draw_vulkan_image
    alias PFN_glDrawVkImageNV = void function (
        GLuint64 vkImage,
        GLuint   sampler,
        GLfloat  x0,
        GLfloat  y0,
        GLfloat  x1,
        GLfloat  y1,
        GLfloat  z,
        GLfloat  s0,
        GLfloat  t0,
        GLfloat  s1,
        GLfloat  t1,
    );
    alias PFN_glGetVkProcAddrNV = GLVULKANPROCNV function (
        const(GLchar)* name,
    );
    alias PFN_glWaitVkSemaphoreNV = void function (
        GLuint64 vkSemaphore,
    );
    alias PFN_glSignalVkSemaphoreNV = void function (
        GLuint64 vkSemaphore,
    );
    alias PFN_glSignalVkFenceNV = void function (
        GLuint64 vkFence,
    );

    // Command pointers for GL_NV_fragment_coverage_to_color
    alias PFN_glFragmentCoverageColorNV = void function (
        GLuint color,
    );

    // Command pointers for GL_NV_framebuffer_mixed_samples
    alias PFN_glCoverageModulationTableNV = void function (
        GLsizei         n,
        const(GLfloat)* v,
    );
    alias PFN_glGetCoverageModulationTableNV = void function (
        GLsizei  bufsize,
        GLfloat* v,
    );
    alias PFN_glCoverageModulationNV = void function (
        GLenum components,
    );

    // Command pointers for GL_NV_framebuffer_multisample_coverage
    alias PFN_glRenderbufferStorageMultisampleCoverageNV = void function (
        GLenum  target,
        GLsizei coverageSamples,
        GLsizei colorSamples,
        GLenum  internalformat,
        GLsizei width,
        GLsizei height,
    );

    // Command pointers for GL_NV_gpu_shader5
    alias PFN_glUniform1i64NV = void function (
        GLint      location,
        GLint64EXT x,
    );
    alias PFN_glUniform2i64NV = void function (
        GLint      location,
        GLint64EXT x,
        GLint64EXT y,
    );
    alias PFN_glUniform3i64NV = void function (
        GLint      location,
        GLint64EXT x,
        GLint64EXT y,
        GLint64EXT z,
    );
    alias PFN_glUniform4i64NV = void function (
        GLint      location,
        GLint64EXT x,
        GLint64EXT y,
        GLint64EXT z,
        GLint64EXT w,
    );
    alias PFN_glUniform1i64vNV = void function (
        GLint              location,
        GLsizei            count,
        const(GLint64EXT)* value,
    );
    alias PFN_glUniform2i64vNV = void function (
        GLint              location,
        GLsizei            count,
        const(GLint64EXT)* value,
    );
    alias PFN_glUniform3i64vNV = void function (
        GLint              location,
        GLsizei            count,
        const(GLint64EXT)* value,
    );
    alias PFN_glUniform4i64vNV = void function (
        GLint              location,
        GLsizei            count,
        const(GLint64EXT)* value,
    );
    alias PFN_glUniform1ui64NV = void function (
        GLint       location,
        GLuint64EXT x,
    );
    alias PFN_glUniform2ui64NV = void function (
        GLint       location,
        GLuint64EXT x,
        GLuint64EXT y,
    );
    alias PFN_glUniform3ui64NV = void function (
        GLint       location,
        GLuint64EXT x,
        GLuint64EXT y,
        GLuint64EXT z,
    );
    alias PFN_glUniform4ui64NV = void function (
        GLint       location,
        GLuint64EXT x,
        GLuint64EXT y,
        GLuint64EXT z,
        GLuint64EXT w,
    );
    alias PFN_glUniform1ui64vNV = void function (
        GLint               location,
        GLsizei             count,
        const(GLuint64EXT)* value,
    );
    alias PFN_glUniform2ui64vNV = void function (
        GLint               location,
        GLsizei             count,
        const(GLuint64EXT)* value,
    );
    alias PFN_glUniform3ui64vNV = void function (
        GLint               location,
        GLsizei             count,
        const(GLuint64EXT)* value,
    );
    alias PFN_glUniform4ui64vNV = void function (
        GLint               location,
        GLsizei             count,
        const(GLuint64EXT)* value,
    );
    alias PFN_glGetUniformi64vNV = void function (
        GLuint      program,
        GLint       location,
        GLint64EXT* params,
    );
    alias PFN_glProgramUniform1i64NV = void function (
        GLuint     program,
        GLint      location,
        GLint64EXT x,
    );
    alias PFN_glProgramUniform2i64NV = void function (
        GLuint     program,
        GLint      location,
        GLint64EXT x,
        GLint64EXT y,
    );
    alias PFN_glProgramUniform3i64NV = void function (
        GLuint     program,
        GLint      location,
        GLint64EXT x,
        GLint64EXT y,
        GLint64EXT z,
    );
    alias PFN_glProgramUniform4i64NV = void function (
        GLuint     program,
        GLint      location,
        GLint64EXT x,
        GLint64EXT y,
        GLint64EXT z,
        GLint64EXT w,
    );
    alias PFN_glProgramUniform1i64vNV = void function (
        GLuint             program,
        GLint              location,
        GLsizei            count,
        const(GLint64EXT)* value,
    );
    alias PFN_glProgramUniform2i64vNV = void function (
        GLuint             program,
        GLint              location,
        GLsizei            count,
        const(GLint64EXT)* value,
    );
    alias PFN_glProgramUniform3i64vNV = void function (
        GLuint             program,
        GLint              location,
        GLsizei            count,
        const(GLint64EXT)* value,
    );
    alias PFN_glProgramUniform4i64vNV = void function (
        GLuint             program,
        GLint              location,
        GLsizei            count,
        const(GLint64EXT)* value,
    );
    alias PFN_glProgramUniform1ui64NV = void function (
        GLuint      program,
        GLint       location,
        GLuint64EXT x,
    );
    alias PFN_glProgramUniform2ui64NV = void function (
        GLuint      program,
        GLint       location,
        GLuint64EXT x,
        GLuint64EXT y,
    );
    alias PFN_glProgramUniform3ui64NV = void function (
        GLuint      program,
        GLint       location,
        GLuint64EXT x,
        GLuint64EXT y,
        GLuint64EXT z,
    );
    alias PFN_glProgramUniform4ui64NV = void function (
        GLuint      program,
        GLint       location,
        GLuint64EXT x,
        GLuint64EXT y,
        GLuint64EXT z,
        GLuint64EXT w,
    );
    alias PFN_glProgramUniform1ui64vNV = void function (
        GLuint              program,
        GLint               location,
        GLsizei             count,
        const(GLuint64EXT)* value,
    );
    alias PFN_glProgramUniform2ui64vNV = void function (
        GLuint              program,
        GLint               location,
        GLsizei             count,
        const(GLuint64EXT)* value,
    );
    alias PFN_glProgramUniform3ui64vNV = void function (
        GLuint              program,
        GLint               location,
        GLsizei             count,
        const(GLuint64EXT)* value,
    );
    alias PFN_glProgramUniform4ui64vNV = void function (
        GLuint              program,
        GLint               location,
        GLsizei             count,
        const(GLuint64EXT)* value,
    );

    // Command pointers for GL_NV_internalformat_sample_query
    alias PFN_glGetInternalformatSampleivNV = void function (
        GLenum  target,
        GLenum  internalformat,
        GLsizei samples,
        GLenum  pname,
        GLsizei bufSize,
        GLint*  params,
    );

    // Command pointers for GL_NV_path_rendering
    alias PFN_glGenPathsNV = GLuint function (
        GLsizei range,
    );
    alias PFN_glDeletePathsNV = void function (
        GLuint  path,
        GLsizei range,
    );
    alias PFN_glIsPathNV = GLboolean function (
        GLuint path,
    );
    alias PFN_glPathCommandsNV = void function (
        GLuint          path,
        GLsizei         numCommands,
        const(GLubyte)* commands,
        GLsizei         numCoords,
        GLenum          coordType,
        const(void)*    coords,
    );
    alias PFN_glPathCoordsNV = void function (
        GLuint       path,
        GLsizei      numCoords,
        GLenum       coordType,
        const(void)* coords,
    );
    alias PFN_glPathSubCommandsNV = void function (
        GLuint          path,
        GLsizei         commandStart,
        GLsizei         commandsToDelete,
        GLsizei         numCommands,
        const(GLubyte)* commands,
        GLsizei         numCoords,
        GLenum          coordType,
        const(void)*    coords,
    );
    alias PFN_glPathSubCoordsNV = void function (
        GLuint       path,
        GLsizei      coordStart,
        GLsizei      numCoords,
        GLenum       coordType,
        const(void)* coords,
    );
    alias PFN_glPathStringNV = void function (
        GLuint       path,
        GLenum       format,
        GLsizei      length,
        const(void)* pathString,
    );
    alias PFN_glPathGlyphsNV = void function (
        GLuint       firstPathName,
        GLenum       fontTarget,
        const(void)* fontName,
        GLbitfield   fontStyle,
        GLsizei      numGlyphs,
        GLenum       type,
        const(void)* charcodes,
        GLenum       handleMissingGlyphs,
        GLuint       pathParameterTemplate,
        GLfloat      emScale,
    );
    alias PFN_glPathGlyphRangeNV = void function (
        GLuint       firstPathName,
        GLenum       fontTarget,
        const(void)* fontName,
        GLbitfield   fontStyle,
        GLuint       firstGlyph,
        GLsizei      numGlyphs,
        GLenum       handleMissingGlyphs,
        GLuint       pathParameterTemplate,
        GLfloat      emScale,
    );
    alias PFN_glWeightPathsNV = void function (
        GLuint          resultPath,
        GLsizei         numPaths,
        const(GLuint)*  paths,
        const(GLfloat)* weights,
    );
    alias PFN_glCopyPathNV = void function (
        GLuint resultPath,
        GLuint srcPath,
    );
    alias PFN_glInterpolatePathsNV = void function (
        GLuint  resultPath,
        GLuint  pathA,
        GLuint  pathB,
        GLfloat weight,
    );
    alias PFN_glTransformPathNV = void function (
        GLuint          resultPath,
        GLuint          srcPath,
        GLenum          transformType,
        const(GLfloat)* transformValues,
    );
    alias PFN_glPathParameterivNV = void function (
        GLuint        path,
        GLenum        pname,
        const(GLint)* value,
    );
    alias PFN_glPathParameteriNV = void function (
        GLuint path,
        GLenum pname,
        GLint  value,
    );
    alias PFN_glPathParameterfvNV = void function (
        GLuint          path,
        GLenum          pname,
        const(GLfloat)* value,
    );
    alias PFN_glPathParameterfNV = void function (
        GLuint  path,
        GLenum  pname,
        GLfloat value,
    );
    alias PFN_glPathDashArrayNV = void function (
        GLuint          path,
        GLsizei         dashCount,
        const(GLfloat)* dashArray,
    );
    alias PFN_glPathStencilFuncNV = void function (
        GLenum func,
        GLint  ref_,
        GLuint mask,
    );
    alias PFN_glPathStencilDepthOffsetNV = void function (
        GLfloat factor,
        GLfloat units,
    );
    alias PFN_glStencilFillPathNV = void function (
        GLuint path,
        GLenum fillMode,
        GLuint mask,
    );
    alias PFN_glStencilStrokePathNV = void function (
        GLuint path,
        GLint  reference,
        GLuint mask,
    );
    alias PFN_glStencilFillPathInstancedNV = void function (
        GLsizei         numPaths,
        GLenum          pathNameType,
        const(void)*    paths,
        GLuint          pathBase,
        GLenum          fillMode,
        GLuint          mask,
        GLenum          transformType,
        const(GLfloat)* transformValues,
    );
    alias PFN_glStencilStrokePathInstancedNV = void function (
        GLsizei         numPaths,
        GLenum          pathNameType,
        const(void)*    paths,
        GLuint          pathBase,
        GLint           reference,
        GLuint          mask,
        GLenum          transformType,
        const(GLfloat)* transformValues,
    );
    alias PFN_glPathCoverDepthFuncNV = void function (
        GLenum func,
    );
    alias PFN_glCoverFillPathNV = void function (
        GLuint path,
        GLenum coverMode,
    );
    alias PFN_glCoverStrokePathNV = void function (
        GLuint path,
        GLenum coverMode,
    );
    alias PFN_glCoverFillPathInstancedNV = void function (
        GLsizei         numPaths,
        GLenum          pathNameType,
        const(void)*    paths,
        GLuint          pathBase,
        GLenum          coverMode,
        GLenum          transformType,
        const(GLfloat)* transformValues,
    );
    alias PFN_glCoverStrokePathInstancedNV = void function (
        GLsizei         numPaths,
        GLenum          pathNameType,
        const(void)*    paths,
        GLuint          pathBase,
        GLenum          coverMode,
        GLenum          transformType,
        const(GLfloat)* transformValues,
    );
    alias PFN_glGetPathParameterivNV = void function (
        GLuint path,
        GLenum pname,
        GLint* value,
    );
    alias PFN_glGetPathParameterfvNV = void function (
        GLuint   path,
        GLenum   pname,
        GLfloat* value,
    );
    alias PFN_glGetPathCommandsNV = void function (
        GLuint   path,
        GLubyte* commands,
    );
    alias PFN_glGetPathCoordsNV = void function (
        GLuint   path,
        GLfloat* coords,
    );
    alias PFN_glGetPathDashArrayNV = void function (
        GLuint   path,
        GLfloat* dashArray,
    );
    alias PFN_glGetPathMetricsNV = void function (
        GLbitfield   metricQueryMask,
        GLsizei      numPaths,
        GLenum       pathNameType,
        const(void)* paths,
        GLuint       pathBase,
        GLsizei      stride,
        GLfloat*     metrics,
    );
    alias PFN_glGetPathMetricRangeNV = void function (
        GLbitfield metricQueryMask,
        GLuint     firstPathName,
        GLsizei    numPaths,
        GLsizei    stride,
        GLfloat*   metrics,
    );
    alias PFN_glGetPathSpacingNV = void function (
        GLenum       pathListMode,
        GLsizei      numPaths,
        GLenum       pathNameType,
        const(void)* paths,
        GLuint       pathBase,
        GLfloat      advanceScale,
        GLfloat      kerningScale,
        GLenum       transformType,
        GLfloat*     returnedSpacing,
    );
    alias PFN_glIsPointInFillPathNV = GLboolean function (
        GLuint  path,
        GLuint  mask,
        GLfloat x,
        GLfloat y,
    );
    alias PFN_glIsPointInStrokePathNV = GLboolean function (
        GLuint  path,
        GLfloat x,
        GLfloat y,
    );
    alias PFN_glGetPathLengthNV = GLfloat function (
        GLuint  path,
        GLsizei startSegment,
        GLsizei numSegments,
    );
    alias PFN_glPointAlongPathNV = GLboolean function (
        GLuint   path,
        GLsizei  startSegment,
        GLsizei  numSegments,
        GLfloat  distance,
        GLfloat* x,
        GLfloat* y,
        GLfloat* tangentX,
        GLfloat* tangentY,
    );
    alias PFN_glMatrixLoad3x2fNV = void function (
        GLenum          matrixMode,
        const(GLfloat)* m,
    );
    alias PFN_glMatrixLoad3x3fNV = void function (
        GLenum          matrixMode,
        const(GLfloat)* m,
    );
    alias PFN_glMatrixLoadTranspose3x3fNV = void function (
        GLenum          matrixMode,
        const(GLfloat)* m,
    );
    alias PFN_glMatrixMult3x2fNV = void function (
        GLenum          matrixMode,
        const(GLfloat)* m,
    );
    alias PFN_glMatrixMult3x3fNV = void function (
        GLenum          matrixMode,
        const(GLfloat)* m,
    );
    alias PFN_glMatrixMultTranspose3x3fNV = void function (
        GLenum          matrixMode,
        const(GLfloat)* m,
    );
    alias PFN_glStencilThenCoverFillPathNV = void function (
        GLuint path,
        GLenum fillMode,
        GLuint mask,
        GLenum coverMode,
    );
    alias PFN_glStencilThenCoverStrokePathNV = void function (
        GLuint path,
        GLint  reference,
        GLuint mask,
        GLenum coverMode,
    );
    alias PFN_glStencilThenCoverFillPathInstancedNV = void function (
        GLsizei         numPaths,
        GLenum          pathNameType,
        const(void)*    paths,
        GLuint          pathBase,
        GLenum          fillMode,
        GLuint          mask,
        GLenum          coverMode,
        GLenum          transformType,
        const(GLfloat)* transformValues,
    );
    alias PFN_glStencilThenCoverStrokePathInstancedNV = void function (
        GLsizei         numPaths,
        GLenum          pathNameType,
        const(void)*    paths,
        GLuint          pathBase,
        GLint           reference,
        GLuint          mask,
        GLenum          coverMode,
        GLenum          transformType,
        const(GLfloat)* transformValues,
    );
    alias PFN_glPathGlyphIndexRangeNV = GLenum function (
        GLenum       fontTarget,
        const(void)* fontName,
        GLbitfield   fontStyle,
        GLuint       pathParameterTemplate,
        GLfloat      emScale,
        GLuint [2]   baseAndCount,
    );
    alias PFN_glPathGlyphIndexArrayNV = GLenum function (
        GLuint       firstPathName,
        GLenum       fontTarget,
        const(void)* fontName,
        GLbitfield   fontStyle,
        GLuint       firstGlyphIndex,
        GLsizei      numGlyphs,
        GLuint       pathParameterTemplate,
        GLfloat      emScale,
    );
    alias PFN_glPathMemoryGlyphIndexArrayNV = GLenum function (
        GLuint       firstPathName,
        GLenum       fontTarget,
        GLsizeiptr   fontSize,
        const(void)* fontData,
        GLsizei      faceIndex,
        GLuint       firstGlyphIndex,
        GLsizei      numGlyphs,
        GLuint       pathParameterTemplate,
        GLfloat      emScale,
    );
    alias PFN_glProgramPathFragmentInputGenNV = void function (
        GLuint          program,
        GLint           location,
        GLenum          genMode,
        GLint           components,
        const(GLfloat)* coeffs,
    );
    alias PFN_glGetProgramResourcefvNV = void function (
        GLuint         program,
        GLenum         programInterface,
        GLuint         index,
        GLsizei        propCount,
        const(GLenum)* props,
        GLsizei        bufSize,
        GLsizei*       length,
        GLfloat*       params,
    );

    // Command pointers for GL_NV_sample_locations
    alias PFN_glFramebufferSampleLocationsfvNV = void function (
        GLenum          target,
        GLuint          start,
        GLsizei         count,
        const(GLfloat)* v,
    );
    alias PFN_glNamedFramebufferSampleLocationsfvNV = void function (
        GLuint          framebuffer,
        GLuint          start,
        GLsizei         count,
        const(GLfloat)* v,
    );
    alias PFN_glResolveDepthValuesNV = void function ();

    // Command pointers for GL_NV_shader_buffer_load
    alias PFN_glMakeBufferResidentNV = void function (
        GLenum target,
        GLenum access,
    );
    alias PFN_glMakeBufferNonResidentNV = void function (
        GLenum target,
    );
    alias PFN_glIsBufferResidentNV = GLboolean function (
        GLenum target,
    );
    alias PFN_glMakeNamedBufferResidentNV = void function (
        GLuint buffer,
        GLenum access,
    );
    alias PFN_glMakeNamedBufferNonResidentNV = void function (
        GLuint buffer,
    );
    alias PFN_glIsNamedBufferResidentNV = GLboolean function (
        GLuint buffer,
    );
    alias PFN_glGetBufferParameterui64vNV = void function (
        GLenum       target,
        GLenum       pname,
        GLuint64EXT* params,
    );
    alias PFN_glGetNamedBufferParameterui64vNV = void function (
        GLuint       buffer,
        GLenum       pname,
        GLuint64EXT* params,
    );
    alias PFN_glGetIntegerui64vNV = void function (
        GLenum       value,
        GLuint64EXT* result,
    );
    alias PFN_glUniformui64NV = void function (
        GLint       location,
        GLuint64EXT value,
    );
    alias PFN_glUniformui64vNV = void function (
        GLint               location,
        GLsizei             count,
        const(GLuint64EXT)* value,
    );
    alias PFN_glGetUniformui64vNV = void function (
        GLuint       program,
        GLint        location,
        GLuint64EXT* params,
    );
    alias PFN_glProgramUniformui64NV = void function (
        GLuint      program,
        GLint       location,
        GLuint64EXT value,
    );
    alias PFN_glProgramUniformui64vNV = void function (
        GLuint              program,
        GLint               location,
        GLsizei             count,
        const(GLuint64EXT)* value,
    );

    // Command pointers for GL_NV_texture_barrier
    alias PFN_glTextureBarrierNV = void function ();

    // Command pointers for GL_NV_vertex_attrib_integer_64bit
    alias PFN_glVertexAttribL1i64NV = void function (
        GLuint     index,
        GLint64EXT x,
    );
    alias PFN_glVertexAttribL2i64NV = void function (
        GLuint     index,
        GLint64EXT x,
        GLint64EXT y,
    );
    alias PFN_glVertexAttribL3i64NV = void function (
        GLuint     index,
        GLint64EXT x,
        GLint64EXT y,
        GLint64EXT z,
    );
    alias PFN_glVertexAttribL4i64NV = void function (
        GLuint     index,
        GLint64EXT x,
        GLint64EXT y,
        GLint64EXT z,
        GLint64EXT w,
    );
    alias PFN_glVertexAttribL1i64vNV = void function (
        GLuint             index,
        const(GLint64EXT)* v,
    );
    alias PFN_glVertexAttribL2i64vNV = void function (
        GLuint             index,
        const(GLint64EXT)* v,
    );
    alias PFN_glVertexAttribL3i64vNV = void function (
        GLuint             index,
        const(GLint64EXT)* v,
    );
    alias PFN_glVertexAttribL4i64vNV = void function (
        GLuint             index,
        const(GLint64EXT)* v,
    );
    alias PFN_glVertexAttribL1ui64NV = void function (
        GLuint      index,
        GLuint64EXT x,
    );
    alias PFN_glVertexAttribL2ui64NV = void function (
        GLuint      index,
        GLuint64EXT x,
        GLuint64EXT y,
    );
    alias PFN_glVertexAttribL3ui64NV = void function (
        GLuint      index,
        GLuint64EXT x,
        GLuint64EXT y,
        GLuint64EXT z,
    );
    alias PFN_glVertexAttribL4ui64NV = void function (
        GLuint      index,
        GLuint64EXT x,
        GLuint64EXT y,
        GLuint64EXT z,
        GLuint64EXT w,
    );
    alias PFN_glVertexAttribL1ui64vNV = void function (
        GLuint              index,
        const(GLuint64EXT)* v,
    );
    alias PFN_glVertexAttribL2ui64vNV = void function (
        GLuint              index,
        const(GLuint64EXT)* v,
    );
    alias PFN_glVertexAttribL3ui64vNV = void function (
        GLuint              index,
        const(GLuint64EXT)* v,
    );
    alias PFN_glVertexAttribL4ui64vNV = void function (
        GLuint              index,
        const(GLuint64EXT)* v,
    );
    alias PFN_glGetVertexAttribLi64vNV = void function (
        GLuint      index,
        GLenum      pname,
        GLint64EXT* params,
    );
    alias PFN_glGetVertexAttribLui64vNV = void function (
        GLuint       index,
        GLenum       pname,
        GLuint64EXT* params,
    );
    alias PFN_glVertexAttribLFormatNV = void function (
        GLuint  index,
        GLint   size,
        GLenum  type,
        GLsizei stride,
    );

    // Command pointers for GL_NV_vertex_buffer_unified_memory
    alias PFN_glBufferAddressRangeNV = void function (
        GLenum      pname,
        GLuint      index,
        GLuint64EXT address,
        GLsizeiptr  length,
    );
    alias PFN_glVertexFormatNV = void function (
        GLint   size,
        GLenum  type,
        GLsizei stride,
    );
    alias PFN_glNormalFormatNV = void function (
        GLenum  type,
        GLsizei stride,
    );
    alias PFN_glColorFormatNV = void function (
        GLint   size,
        GLenum  type,
        GLsizei stride,
    );
    alias PFN_glIndexFormatNV = void function (
        GLenum  type,
        GLsizei stride,
    );
    alias PFN_glTexCoordFormatNV = void function (
        GLint   size,
        GLenum  type,
        GLsizei stride,
    );
    alias PFN_glEdgeFlagFormatNV = void function (
        GLsizei stride,
    );
    alias PFN_glSecondaryColorFormatNV = void function (
        GLint   size,
        GLenum  type,
        GLsizei stride,
    );
    alias PFN_glFogCoordFormatNV = void function (
        GLenum  type,
        GLsizei stride,
    );
    alias PFN_glVertexAttribFormatNV = void function (
        GLuint    index,
        GLint     size,
        GLenum    type,
        GLboolean normalized,
        GLsizei   stride,
    );
    alias PFN_glVertexAttribIFormatNV = void function (
        GLuint  index,
        GLint   size,
        GLenum  type,
        GLsizei stride,
    );
    alias PFN_glGetIntegerui64i_vNV = void function (
        GLenum       value,
        GLuint       index,
        GLuint64EXT* result,
    );

    // Command pointers for GL_NV_viewport_swizzle
    alias PFN_glViewportSwizzleNV = void function (
        GLuint index,
        GLenum swizzlex,
        GLenum swizzley,
        GLenum swizzlez,
        GLenum swizzlew,
    );

    // Command pointers for GL_OVR_multiview
    alias PFN_glFramebufferTextureMultiviewOVR = void function (
        GLenum  target,
        GLenum  attachment,
        GLuint  texture,
        GLint   level,
        GLint   baseViewIndex,
        GLsizei numViews,
    );
}

/// GlVersion describes the version of OpenGL
enum GlVersion {
    gl10 = 10,
    gl11 = 11,
    gl12 = 12,
    gl13 = 13,
    gl14 = 14,
    gl15 = 15,
    gl20 = 20,
    gl21 = 21,
    gl30 = 30,
    gl31 = 31,
    gl32 = 32,
    gl33 = 33,
    gl40 = 40,
    gl41 = 41,
    gl42 = 42,
    gl43 = 43,
    gl44 = 44,
    gl45 = 45,
    gl46 = 46,
}

/// OpenGL loader base class
final class Gl {
    this(SymbolLoader loader) {

        // GL_VERSION_1_0
        _CullFace = cast(PFN_glCullFace)loadSymbol(loader, "glCullFace", []);
        _FrontFace = cast(PFN_glFrontFace)loadSymbol(loader, "glFrontFace", []);
        _Hint = cast(PFN_glHint)loadSymbol(loader, "glHint", []);
        _LineWidth = cast(PFN_glLineWidth)loadSymbol(loader, "glLineWidth", []);
        _PointSize = cast(PFN_glPointSize)loadSymbol(loader, "glPointSize", []);
        _PolygonMode = cast(PFN_glPolygonMode)loadSymbol(loader, "glPolygonMode", []);
        _Scissor = cast(PFN_glScissor)loadSymbol(loader, "glScissor", []);
        _TexParameterf = cast(PFN_glTexParameterf)loadSymbol(loader, "glTexParameterf", []);
        _TexParameterfv = cast(PFN_glTexParameterfv)loadSymbol(loader, "glTexParameterfv", []);
        _TexParameteri = cast(PFN_glTexParameteri)loadSymbol(loader, "glTexParameteri", []);
        _TexParameteriv = cast(PFN_glTexParameteriv)loadSymbol(loader, "glTexParameteriv", []);
        _TexImage1D = cast(PFN_glTexImage1D)loadSymbol(loader, "glTexImage1D", []);
        _TexImage2D = cast(PFN_glTexImage2D)loadSymbol(loader, "glTexImage2D", []);
        _DrawBuffer = cast(PFN_glDrawBuffer)loadSymbol(loader, "glDrawBuffer", []);
        _Clear = cast(PFN_glClear)loadSymbol(loader, "glClear", []);
        _ClearColor = cast(PFN_glClearColor)loadSymbol(loader, "glClearColor", []);
        _ClearStencil = cast(PFN_glClearStencil)loadSymbol(loader, "glClearStencil", []);
        _ClearDepth = cast(PFN_glClearDepth)loadSymbol(loader, "glClearDepth", []);
        _StencilMask = cast(PFN_glStencilMask)loadSymbol(loader, "glStencilMask", []);
        _ColorMask = cast(PFN_glColorMask)loadSymbol(loader, "glColorMask", []);
        _DepthMask = cast(PFN_glDepthMask)loadSymbol(loader, "glDepthMask", []);
        _Disable = cast(PFN_glDisable)loadSymbol(loader, "glDisable", []);
        _Enable = cast(PFN_glEnable)loadSymbol(loader, "glEnable", []);
        _Finish = cast(PFN_glFinish)loadSymbol(loader, "glFinish", []);
        _Flush = cast(PFN_glFlush)loadSymbol(loader, "glFlush", []);
        _BlendFunc = cast(PFN_glBlendFunc)loadSymbol(loader, "glBlendFunc", []);
        _LogicOp = cast(PFN_glLogicOp)loadSymbol(loader, "glLogicOp", []);
        _StencilFunc = cast(PFN_glStencilFunc)loadSymbol(loader, "glStencilFunc", []);
        _StencilOp = cast(PFN_glStencilOp)loadSymbol(loader, "glStencilOp", []);
        _DepthFunc = cast(PFN_glDepthFunc)loadSymbol(loader, "glDepthFunc", []);
        _PixelStoref = cast(PFN_glPixelStoref)loadSymbol(loader, "glPixelStoref", []);
        _PixelStorei = cast(PFN_glPixelStorei)loadSymbol(loader, "glPixelStorei", []);
        _ReadBuffer = cast(PFN_glReadBuffer)loadSymbol(loader, "glReadBuffer", []);
        _ReadPixels = cast(PFN_glReadPixels)loadSymbol(loader, "glReadPixels", []);
        _GetBooleanv = cast(PFN_glGetBooleanv)loadSymbol(loader, "glGetBooleanv", []);
        _GetDoublev = cast(PFN_glGetDoublev)loadSymbol(loader, "glGetDoublev", []);
        _GetError = cast(PFN_glGetError)loadSymbol(loader, "glGetError", []);
        _GetFloatv = cast(PFN_glGetFloatv)loadSymbol(loader, "glGetFloatv", []);
        _GetIntegerv = cast(PFN_glGetIntegerv)loadSymbol(loader, "glGetIntegerv", []);
        _GetString = cast(PFN_glGetString)loadSymbol(loader, "glGetString", []);
        _GetTexImage = cast(PFN_glGetTexImage)loadSymbol(loader, "glGetTexImage", []);
        _GetTexParameterfv = cast(PFN_glGetTexParameterfv)loadSymbol(loader, "glGetTexParameterfv", []);
        _GetTexParameteriv = cast(PFN_glGetTexParameteriv)loadSymbol(loader, "glGetTexParameteriv", []);
        _GetTexLevelParameterfv = cast(PFN_glGetTexLevelParameterfv)loadSymbol(loader, "glGetTexLevelParameterfv", []);
        _GetTexLevelParameteriv = cast(PFN_glGetTexLevelParameteriv)loadSymbol(loader, "glGetTexLevelParameteriv", []);
        _IsEnabled = cast(PFN_glIsEnabled)loadSymbol(loader, "glIsEnabled", []);
        _DepthRange = cast(PFN_glDepthRange)loadSymbol(loader, "glDepthRange", []);
        _Viewport = cast(PFN_glViewport)loadSymbol(loader, "glViewport", []);

        // GL_VERSION_1_1
        _DrawArrays = cast(PFN_glDrawArrays)loadSymbol(loader, "glDrawArrays", []);
        _DrawElements = cast(PFN_glDrawElements)loadSymbol(loader, "glDrawElements", []);
        _GetPointerv = cast(PFN_glGetPointerv)loadSymbol(loader, "glGetPointerv", []);
        _PolygonOffset = cast(PFN_glPolygonOffset)loadSymbol(loader, "glPolygonOffset", []);
        _CopyTexImage1D = cast(PFN_glCopyTexImage1D)loadSymbol(loader, "glCopyTexImage1D", []);
        _CopyTexImage2D = cast(PFN_glCopyTexImage2D)loadSymbol(loader, "glCopyTexImage2D", []);
        _CopyTexSubImage1D = cast(PFN_glCopyTexSubImage1D)loadSymbol(loader, "glCopyTexSubImage1D", []);
        _CopyTexSubImage2D = cast(PFN_glCopyTexSubImage2D)loadSymbol(loader, "glCopyTexSubImage2D", []);
        _TexSubImage1D = cast(PFN_glTexSubImage1D)loadSymbol(loader, "glTexSubImage1D", []);
        _TexSubImage2D = cast(PFN_glTexSubImage2D)loadSymbol(loader, "glTexSubImage2D", []);
        _BindTexture = cast(PFN_glBindTexture)loadSymbol(loader, "glBindTexture", []);
        _DeleteTextures = cast(PFN_glDeleteTextures)loadSymbol(loader, "glDeleteTextures", []);
        _GenTextures = cast(PFN_glGenTextures)loadSymbol(loader, "glGenTextures", []);
        _IsTexture = cast(PFN_glIsTexture)loadSymbol(loader, "glIsTexture", []);

        // GL_VERSION_1_2
        _DrawRangeElements = cast(PFN_glDrawRangeElements)loadSymbol(loader, "glDrawRangeElements", []);
        _TexImage3D = cast(PFN_glTexImage3D)loadSymbol(loader, "glTexImage3D", []);
        _TexSubImage3D = cast(PFN_glTexSubImage3D)loadSymbol(loader, "glTexSubImage3D", []);
        _CopyTexSubImage3D = cast(PFN_glCopyTexSubImage3D)loadSymbol(loader, "glCopyTexSubImage3D", []);

        // GL_VERSION_1_3
        _ActiveTexture = cast(PFN_glActiveTexture)loadSymbol(loader, "glActiveTexture", []);
        _SampleCoverage = cast(PFN_glSampleCoverage)loadSymbol(loader, "glSampleCoverage", []);
        _CompressedTexImage3D = cast(PFN_glCompressedTexImage3D)loadSymbol(loader, "glCompressedTexImage3D", []);
        _CompressedTexImage2D = cast(PFN_glCompressedTexImage2D)loadSymbol(loader, "glCompressedTexImage2D", []);
        _CompressedTexImage1D = cast(PFN_glCompressedTexImage1D)loadSymbol(loader, "glCompressedTexImage1D", []);
        _CompressedTexSubImage3D = cast(PFN_glCompressedTexSubImage3D)loadSymbol(loader, "glCompressedTexSubImage3D", []);
        _CompressedTexSubImage2D = cast(PFN_glCompressedTexSubImage2D)loadSymbol(loader, "glCompressedTexSubImage2D", []);
        _CompressedTexSubImage1D = cast(PFN_glCompressedTexSubImage1D)loadSymbol(loader, "glCompressedTexSubImage1D", []);
        _GetCompressedTexImage = cast(PFN_glGetCompressedTexImage)loadSymbol(loader, "glGetCompressedTexImage", []);

        // GL_VERSION_1_4
        _BlendFuncSeparate = cast(PFN_glBlendFuncSeparate)loadSymbol(loader, "glBlendFuncSeparate", []);
        _MultiDrawArrays = cast(PFN_glMultiDrawArrays)loadSymbol(loader, "glMultiDrawArrays", []);
        _MultiDrawElements = cast(PFN_glMultiDrawElements)loadSymbol(loader, "glMultiDrawElements", []);
        _PointParameterf = cast(PFN_glPointParameterf)loadSymbol(loader, "glPointParameterf", []);
        _PointParameterfv = cast(PFN_glPointParameterfv)loadSymbol(loader, "glPointParameterfv", []);
        _PointParameteri = cast(PFN_glPointParameteri)loadSymbol(loader, "glPointParameteri", []);
        _PointParameteriv = cast(PFN_glPointParameteriv)loadSymbol(loader, "glPointParameteriv", []);
        _BlendColor = cast(PFN_glBlendColor)loadSymbol(loader, "glBlendColor", []);
        _BlendEquation = cast(PFN_glBlendEquation)loadSymbol(loader, "glBlendEquation", []);

        // GL_VERSION_1_5
        _GenQueries = cast(PFN_glGenQueries)loadSymbol(loader, "glGenQueries", []);
        _DeleteQueries = cast(PFN_glDeleteQueries)loadSymbol(loader, "glDeleteQueries", []);
        _IsQuery = cast(PFN_glIsQuery)loadSymbol(loader, "glIsQuery", []);
        _BeginQuery = cast(PFN_glBeginQuery)loadSymbol(loader, "glBeginQuery", []);
        _EndQuery = cast(PFN_glEndQuery)loadSymbol(loader, "glEndQuery", []);
        _GetQueryiv = cast(PFN_glGetQueryiv)loadSymbol(loader, "glGetQueryiv", []);
        _GetQueryObjectiv = cast(PFN_glGetQueryObjectiv)loadSymbol(loader, "glGetQueryObjectiv", []);
        _GetQueryObjectuiv = cast(PFN_glGetQueryObjectuiv)loadSymbol(loader, "glGetQueryObjectuiv", []);
        _BindBuffer = cast(PFN_glBindBuffer)loadSymbol(loader, "glBindBuffer", []);
        _DeleteBuffers = cast(PFN_glDeleteBuffers)loadSymbol(loader, "glDeleteBuffers", []);
        _GenBuffers = cast(PFN_glGenBuffers)loadSymbol(loader, "glGenBuffers", []);
        _IsBuffer = cast(PFN_glIsBuffer)loadSymbol(loader, "glIsBuffer", []);
        _BufferData = cast(PFN_glBufferData)loadSymbol(loader, "glBufferData", []);
        _BufferSubData = cast(PFN_glBufferSubData)loadSymbol(loader, "glBufferSubData", []);
        _GetBufferSubData = cast(PFN_glGetBufferSubData)loadSymbol(loader, "glGetBufferSubData", []);
        _MapBuffer = cast(PFN_glMapBuffer)loadSymbol(loader, "glMapBuffer", []);
        _UnmapBuffer = cast(PFN_glUnmapBuffer)loadSymbol(loader, "glUnmapBuffer", []);
        _GetBufferParameteriv = cast(PFN_glGetBufferParameteriv)loadSymbol(loader, "glGetBufferParameteriv", []);
        _GetBufferPointerv = cast(PFN_glGetBufferPointerv)loadSymbol(loader, "glGetBufferPointerv", []);

        // GL_VERSION_2_0
        _BlendEquationSeparate = cast(PFN_glBlendEquationSeparate)loadSymbol(loader, "glBlendEquationSeparate", []);
        _DrawBuffers = cast(PFN_glDrawBuffers)loadSymbol(loader, "glDrawBuffers", []);
        _StencilOpSeparate = cast(PFN_glStencilOpSeparate)loadSymbol(loader, "glStencilOpSeparate", []);
        _StencilFuncSeparate = cast(PFN_glStencilFuncSeparate)loadSymbol(loader, "glStencilFuncSeparate", []);
        _StencilMaskSeparate = cast(PFN_glStencilMaskSeparate)loadSymbol(loader, "glStencilMaskSeparate", []);
        _AttachShader = cast(PFN_glAttachShader)loadSymbol(loader, "glAttachShader", []);
        _BindAttribLocation = cast(PFN_glBindAttribLocation)loadSymbol(loader, "glBindAttribLocation", []);
        _CompileShader = cast(PFN_glCompileShader)loadSymbol(loader, "glCompileShader", []);
        _CreateProgram = cast(PFN_glCreateProgram)loadSymbol(loader, "glCreateProgram", []);
        _CreateShader = cast(PFN_glCreateShader)loadSymbol(loader, "glCreateShader", []);
        _DeleteProgram = cast(PFN_glDeleteProgram)loadSymbol(loader, "glDeleteProgram", []);
        _DeleteShader = cast(PFN_glDeleteShader)loadSymbol(loader, "glDeleteShader", []);
        _DetachShader = cast(PFN_glDetachShader)loadSymbol(loader, "glDetachShader", []);
        _DisableVertexAttribArray = cast(PFN_glDisableVertexAttribArray)loadSymbol(loader, "glDisableVertexAttribArray", []);
        _EnableVertexAttribArray = cast(PFN_glEnableVertexAttribArray)loadSymbol(loader, "glEnableVertexAttribArray", []);
        _GetActiveAttrib = cast(PFN_glGetActiveAttrib)loadSymbol(loader, "glGetActiveAttrib", []);
        _GetActiveUniform = cast(PFN_glGetActiveUniform)loadSymbol(loader, "glGetActiveUniform", []);
        _GetAttachedShaders = cast(PFN_glGetAttachedShaders)loadSymbol(loader, "glGetAttachedShaders", []);
        _GetAttribLocation = cast(PFN_glGetAttribLocation)loadSymbol(loader, "glGetAttribLocation", []);
        _GetProgramiv = cast(PFN_glGetProgramiv)loadSymbol(loader, "glGetProgramiv", []);
        _GetProgramInfoLog = cast(PFN_glGetProgramInfoLog)loadSymbol(loader, "glGetProgramInfoLog", []);
        _GetShaderiv = cast(PFN_glGetShaderiv)loadSymbol(loader, "glGetShaderiv", []);
        _GetShaderInfoLog = cast(PFN_glGetShaderInfoLog)loadSymbol(loader, "glGetShaderInfoLog", []);
        _GetShaderSource = cast(PFN_glGetShaderSource)loadSymbol(loader, "glGetShaderSource", []);
        _GetUniformLocation = cast(PFN_glGetUniformLocation)loadSymbol(loader, "glGetUniformLocation", []);
        _GetUniformfv = cast(PFN_glGetUniformfv)loadSymbol(loader, "glGetUniformfv", []);
        _GetUniformiv = cast(PFN_glGetUniformiv)loadSymbol(loader, "glGetUniformiv", []);
        _GetVertexAttribdv = cast(PFN_glGetVertexAttribdv)loadSymbol(loader, "glGetVertexAttribdv", []);
        _GetVertexAttribfv = cast(PFN_glGetVertexAttribfv)loadSymbol(loader, "glGetVertexAttribfv", []);
        _GetVertexAttribiv = cast(PFN_glGetVertexAttribiv)loadSymbol(loader, "glGetVertexAttribiv", []);
        _GetVertexAttribPointerv = cast(PFN_glGetVertexAttribPointerv)loadSymbol(loader, "glGetVertexAttribPointerv", []);
        _IsProgram = cast(PFN_glIsProgram)loadSymbol(loader, "glIsProgram", []);
        _IsShader = cast(PFN_glIsShader)loadSymbol(loader, "glIsShader", []);
        _LinkProgram = cast(PFN_glLinkProgram)loadSymbol(loader, "glLinkProgram", []);
        _ShaderSource = cast(PFN_glShaderSource)loadSymbol(loader, "glShaderSource", []);
        _UseProgram = cast(PFN_glUseProgram)loadSymbol(loader, "glUseProgram", []);
        _Uniform1f = cast(PFN_glUniform1f)loadSymbol(loader, "glUniform1f", []);
        _Uniform2f = cast(PFN_glUniform2f)loadSymbol(loader, "glUniform2f", []);
        _Uniform3f = cast(PFN_glUniform3f)loadSymbol(loader, "glUniform3f", []);
        _Uniform4f = cast(PFN_glUniform4f)loadSymbol(loader, "glUniform4f", []);
        _Uniform1i = cast(PFN_glUniform1i)loadSymbol(loader, "glUniform1i", []);
        _Uniform2i = cast(PFN_glUniform2i)loadSymbol(loader, "glUniform2i", []);
        _Uniform3i = cast(PFN_glUniform3i)loadSymbol(loader, "glUniform3i", []);
        _Uniform4i = cast(PFN_glUniform4i)loadSymbol(loader, "glUniform4i", []);
        _Uniform1fv = cast(PFN_glUniform1fv)loadSymbol(loader, "glUniform1fv", []);
        _Uniform2fv = cast(PFN_glUniform2fv)loadSymbol(loader, "glUniform2fv", []);
        _Uniform3fv = cast(PFN_glUniform3fv)loadSymbol(loader, "glUniform3fv", []);
        _Uniform4fv = cast(PFN_glUniform4fv)loadSymbol(loader, "glUniform4fv", []);
        _Uniform1iv = cast(PFN_glUniform1iv)loadSymbol(loader, "glUniform1iv", []);
        _Uniform2iv = cast(PFN_glUniform2iv)loadSymbol(loader, "glUniform2iv", []);
        _Uniform3iv = cast(PFN_glUniform3iv)loadSymbol(loader, "glUniform3iv", []);
        _Uniform4iv = cast(PFN_glUniform4iv)loadSymbol(loader, "glUniform4iv", []);
        _UniformMatrix2fv = cast(PFN_glUniformMatrix2fv)loadSymbol(loader, "glUniformMatrix2fv", []);
        _UniformMatrix3fv = cast(PFN_glUniformMatrix3fv)loadSymbol(loader, "glUniformMatrix3fv", []);
        _UniformMatrix4fv = cast(PFN_glUniformMatrix4fv)loadSymbol(loader, "glUniformMatrix4fv", []);
        _ValidateProgram = cast(PFN_glValidateProgram)loadSymbol(loader, "glValidateProgram", []);
        _VertexAttrib1d = cast(PFN_glVertexAttrib1d)loadSymbol(loader, "glVertexAttrib1d", []);
        _VertexAttrib1dv = cast(PFN_glVertexAttrib1dv)loadSymbol(loader, "glVertexAttrib1dv", []);
        _VertexAttrib1f = cast(PFN_glVertexAttrib1f)loadSymbol(loader, "glVertexAttrib1f", []);
        _VertexAttrib1fv = cast(PFN_glVertexAttrib1fv)loadSymbol(loader, "glVertexAttrib1fv", []);
        _VertexAttrib1s = cast(PFN_glVertexAttrib1s)loadSymbol(loader, "glVertexAttrib1s", []);
        _VertexAttrib1sv = cast(PFN_glVertexAttrib1sv)loadSymbol(loader, "glVertexAttrib1sv", []);
        _VertexAttrib2d = cast(PFN_glVertexAttrib2d)loadSymbol(loader, "glVertexAttrib2d", []);
        _VertexAttrib2dv = cast(PFN_glVertexAttrib2dv)loadSymbol(loader, "glVertexAttrib2dv", []);
        _VertexAttrib2f = cast(PFN_glVertexAttrib2f)loadSymbol(loader, "glVertexAttrib2f", []);
        _VertexAttrib2fv = cast(PFN_glVertexAttrib2fv)loadSymbol(loader, "glVertexAttrib2fv", []);
        _VertexAttrib2s = cast(PFN_glVertexAttrib2s)loadSymbol(loader, "glVertexAttrib2s", []);
        _VertexAttrib2sv = cast(PFN_glVertexAttrib2sv)loadSymbol(loader, "glVertexAttrib2sv", []);
        _VertexAttrib3d = cast(PFN_glVertexAttrib3d)loadSymbol(loader, "glVertexAttrib3d", []);
        _VertexAttrib3dv = cast(PFN_glVertexAttrib3dv)loadSymbol(loader, "glVertexAttrib3dv", []);
        _VertexAttrib3f = cast(PFN_glVertexAttrib3f)loadSymbol(loader, "glVertexAttrib3f", []);
        _VertexAttrib3fv = cast(PFN_glVertexAttrib3fv)loadSymbol(loader, "glVertexAttrib3fv", []);
        _VertexAttrib3s = cast(PFN_glVertexAttrib3s)loadSymbol(loader, "glVertexAttrib3s", []);
        _VertexAttrib3sv = cast(PFN_glVertexAttrib3sv)loadSymbol(loader, "glVertexAttrib3sv", []);
        _VertexAttrib4Nbv = cast(PFN_glVertexAttrib4Nbv)loadSymbol(loader, "glVertexAttrib4Nbv", []);
        _VertexAttrib4Niv = cast(PFN_glVertexAttrib4Niv)loadSymbol(loader, "glVertexAttrib4Niv", []);
        _VertexAttrib4Nsv = cast(PFN_glVertexAttrib4Nsv)loadSymbol(loader, "glVertexAttrib4Nsv", []);
        _VertexAttrib4Nub = cast(PFN_glVertexAttrib4Nub)loadSymbol(loader, "glVertexAttrib4Nub", []);
        _VertexAttrib4Nubv = cast(PFN_glVertexAttrib4Nubv)loadSymbol(loader, "glVertexAttrib4Nubv", []);
        _VertexAttrib4Nuiv = cast(PFN_glVertexAttrib4Nuiv)loadSymbol(loader, "glVertexAttrib4Nuiv", []);
        _VertexAttrib4Nusv = cast(PFN_glVertexAttrib4Nusv)loadSymbol(loader, "glVertexAttrib4Nusv", []);
        _VertexAttrib4bv = cast(PFN_glVertexAttrib4bv)loadSymbol(loader, "glVertexAttrib4bv", []);
        _VertexAttrib4d = cast(PFN_glVertexAttrib4d)loadSymbol(loader, "glVertexAttrib4d", []);
        _VertexAttrib4dv = cast(PFN_glVertexAttrib4dv)loadSymbol(loader, "glVertexAttrib4dv", []);
        _VertexAttrib4f = cast(PFN_glVertexAttrib4f)loadSymbol(loader, "glVertexAttrib4f", []);
        _VertexAttrib4fv = cast(PFN_glVertexAttrib4fv)loadSymbol(loader, "glVertexAttrib4fv", []);
        _VertexAttrib4iv = cast(PFN_glVertexAttrib4iv)loadSymbol(loader, "glVertexAttrib4iv", []);
        _VertexAttrib4s = cast(PFN_glVertexAttrib4s)loadSymbol(loader, "glVertexAttrib4s", []);
        _VertexAttrib4sv = cast(PFN_glVertexAttrib4sv)loadSymbol(loader, "glVertexAttrib4sv", []);
        _VertexAttrib4ubv = cast(PFN_glVertexAttrib4ubv)loadSymbol(loader, "glVertexAttrib4ubv", []);
        _VertexAttrib4uiv = cast(PFN_glVertexAttrib4uiv)loadSymbol(loader, "glVertexAttrib4uiv", []);
        _VertexAttrib4usv = cast(PFN_glVertexAttrib4usv)loadSymbol(loader, "glVertexAttrib4usv", []);
        _VertexAttribPointer = cast(PFN_glVertexAttribPointer)loadSymbol(loader, "glVertexAttribPointer", []);

        // GL_VERSION_2_1
        _UniformMatrix2x3fv = cast(PFN_glUniformMatrix2x3fv)loadSymbol(loader, "glUniformMatrix2x3fv", []);
        _UniformMatrix3x2fv = cast(PFN_glUniformMatrix3x2fv)loadSymbol(loader, "glUniformMatrix3x2fv", []);
        _UniformMatrix2x4fv = cast(PFN_glUniformMatrix2x4fv)loadSymbol(loader, "glUniformMatrix2x4fv", []);
        _UniformMatrix4x2fv = cast(PFN_glUniformMatrix4x2fv)loadSymbol(loader, "glUniformMatrix4x2fv", []);
        _UniformMatrix3x4fv = cast(PFN_glUniformMatrix3x4fv)loadSymbol(loader, "glUniformMatrix3x4fv", []);
        _UniformMatrix4x3fv = cast(PFN_glUniformMatrix4x3fv)loadSymbol(loader, "glUniformMatrix4x3fv", []);

        // GL_VERSION_3_0
        _ColorMaski = cast(PFN_glColorMaski)loadSymbol(loader, "glColorMaski", []);
        _GetBooleani_v = cast(PFN_glGetBooleani_v)loadSymbol(loader, "glGetBooleani_v", ["glGetBooleanIndexedvEXT"]);
        _GetIntegeri_v = cast(PFN_glGetIntegeri_v)loadSymbol(loader, "glGetIntegeri_v", ["glGetIntegerIndexedvEXT"]);
        _Enablei = cast(PFN_glEnablei)loadSymbol(loader, "glEnablei", ["glEnableIndexedEXT"]);
        _Disablei = cast(PFN_glDisablei)loadSymbol(loader, "glDisablei", ["glDisableIndexedEXT"]);
        _IsEnabledi = cast(PFN_glIsEnabledi)loadSymbol(loader, "glIsEnabledi", ["glIsEnabledIndexedEXT"]);
        _BeginTransformFeedback = cast(PFN_glBeginTransformFeedback)loadSymbol(loader, "glBeginTransformFeedback", []);
        _EndTransformFeedback = cast(PFN_glEndTransformFeedback)loadSymbol(loader, "glEndTransformFeedback", []);
        _BindBufferRange = cast(PFN_glBindBufferRange)loadSymbol(loader, "glBindBufferRange", []);
        _BindBufferBase = cast(PFN_glBindBufferBase)loadSymbol(loader, "glBindBufferBase", []);
        _TransformFeedbackVaryings = cast(PFN_glTransformFeedbackVaryings)loadSymbol(loader, "glTransformFeedbackVaryings", []);
        _GetTransformFeedbackVarying = cast(PFN_glGetTransformFeedbackVarying)loadSymbol(loader, "glGetTransformFeedbackVarying", []);
        _ClampColor = cast(PFN_glClampColor)loadSymbol(loader, "glClampColor", []);
        _BeginConditionalRender = cast(PFN_glBeginConditionalRender)loadSymbol(loader, "glBeginConditionalRender", ["glBeginConditionalRenderNV"]);
        _EndConditionalRender = cast(PFN_glEndConditionalRender)loadSymbol(loader, "glEndConditionalRender", ["glEndConditionalRenderNV"]);
        _VertexAttribIPointer = cast(PFN_glVertexAttribIPointer)loadSymbol(loader, "glVertexAttribIPointer", []);
        _GetVertexAttribIiv = cast(PFN_glGetVertexAttribIiv)loadSymbol(loader, "glGetVertexAttribIiv", []);
        _GetVertexAttribIuiv = cast(PFN_glGetVertexAttribIuiv)loadSymbol(loader, "glGetVertexAttribIuiv", []);
        _VertexAttribI1i = cast(PFN_glVertexAttribI1i)loadSymbol(loader, "glVertexAttribI1i", []);
        _VertexAttribI2i = cast(PFN_glVertexAttribI2i)loadSymbol(loader, "glVertexAttribI2i", []);
        _VertexAttribI3i = cast(PFN_glVertexAttribI3i)loadSymbol(loader, "glVertexAttribI3i", []);
        _VertexAttribI4i = cast(PFN_glVertexAttribI4i)loadSymbol(loader, "glVertexAttribI4i", []);
        _VertexAttribI1ui = cast(PFN_glVertexAttribI1ui)loadSymbol(loader, "glVertexAttribI1ui", []);
        _VertexAttribI2ui = cast(PFN_glVertexAttribI2ui)loadSymbol(loader, "glVertexAttribI2ui", []);
        _VertexAttribI3ui = cast(PFN_glVertexAttribI3ui)loadSymbol(loader, "glVertexAttribI3ui", []);
        _VertexAttribI4ui = cast(PFN_glVertexAttribI4ui)loadSymbol(loader, "glVertexAttribI4ui", []);
        _VertexAttribI1iv = cast(PFN_glVertexAttribI1iv)loadSymbol(loader, "glVertexAttribI1iv", []);
        _VertexAttribI2iv = cast(PFN_glVertexAttribI2iv)loadSymbol(loader, "glVertexAttribI2iv", []);
        _VertexAttribI3iv = cast(PFN_glVertexAttribI3iv)loadSymbol(loader, "glVertexAttribI3iv", []);
        _VertexAttribI4iv = cast(PFN_glVertexAttribI4iv)loadSymbol(loader, "glVertexAttribI4iv", []);
        _VertexAttribI1uiv = cast(PFN_glVertexAttribI1uiv)loadSymbol(loader, "glVertexAttribI1uiv", []);
        _VertexAttribI2uiv = cast(PFN_glVertexAttribI2uiv)loadSymbol(loader, "glVertexAttribI2uiv", []);
        _VertexAttribI3uiv = cast(PFN_glVertexAttribI3uiv)loadSymbol(loader, "glVertexAttribI3uiv", []);
        _VertexAttribI4uiv = cast(PFN_glVertexAttribI4uiv)loadSymbol(loader, "glVertexAttribI4uiv", []);
        _VertexAttribI4bv = cast(PFN_glVertexAttribI4bv)loadSymbol(loader, "glVertexAttribI4bv", []);
        _VertexAttribI4sv = cast(PFN_glVertexAttribI4sv)loadSymbol(loader, "glVertexAttribI4sv", []);
        _VertexAttribI4ubv = cast(PFN_glVertexAttribI4ubv)loadSymbol(loader, "glVertexAttribI4ubv", []);
        _VertexAttribI4usv = cast(PFN_glVertexAttribI4usv)loadSymbol(loader, "glVertexAttribI4usv", []);
        _GetUniformuiv = cast(PFN_glGetUniformuiv)loadSymbol(loader, "glGetUniformuiv", []);
        _BindFragDataLocation = cast(PFN_glBindFragDataLocation)loadSymbol(loader, "glBindFragDataLocation", []);
        _GetFragDataLocation = cast(PFN_glGetFragDataLocation)loadSymbol(loader, "glGetFragDataLocation", []);
        _Uniform1ui = cast(PFN_glUniform1ui)loadSymbol(loader, "glUniform1ui", []);
        _Uniform2ui = cast(PFN_glUniform2ui)loadSymbol(loader, "glUniform2ui", []);
        _Uniform3ui = cast(PFN_glUniform3ui)loadSymbol(loader, "glUniform3ui", []);
        _Uniform4ui = cast(PFN_glUniform4ui)loadSymbol(loader, "glUniform4ui", []);
        _Uniform1uiv = cast(PFN_glUniform1uiv)loadSymbol(loader, "glUniform1uiv", []);
        _Uniform2uiv = cast(PFN_glUniform2uiv)loadSymbol(loader, "glUniform2uiv", []);
        _Uniform3uiv = cast(PFN_glUniform3uiv)loadSymbol(loader, "glUniform3uiv", []);
        _Uniform4uiv = cast(PFN_glUniform4uiv)loadSymbol(loader, "glUniform4uiv", []);
        _TexParameterIiv = cast(PFN_glTexParameterIiv)loadSymbol(loader, "glTexParameterIiv", []);
        _TexParameterIuiv = cast(PFN_glTexParameterIuiv)loadSymbol(loader, "glTexParameterIuiv", []);
        _GetTexParameterIiv = cast(PFN_glGetTexParameterIiv)loadSymbol(loader, "glGetTexParameterIiv", []);
        _GetTexParameterIuiv = cast(PFN_glGetTexParameterIuiv)loadSymbol(loader, "glGetTexParameterIuiv", []);
        _ClearBufferiv = cast(PFN_glClearBufferiv)loadSymbol(loader, "glClearBufferiv", []);
        _ClearBufferuiv = cast(PFN_glClearBufferuiv)loadSymbol(loader, "glClearBufferuiv", []);
        _ClearBufferfv = cast(PFN_glClearBufferfv)loadSymbol(loader, "glClearBufferfv", []);
        _ClearBufferfi = cast(PFN_glClearBufferfi)loadSymbol(loader, "glClearBufferfi", []);
        _GetStringi = cast(PFN_glGetStringi)loadSymbol(loader, "glGetStringi", []);
        _IsRenderbuffer = cast(PFN_glIsRenderbuffer)loadSymbol(loader, "glIsRenderbuffer", []);
        _BindRenderbuffer = cast(PFN_glBindRenderbuffer)loadSymbol(loader, "glBindRenderbuffer", []);
        _DeleteRenderbuffers = cast(PFN_glDeleteRenderbuffers)loadSymbol(loader, "glDeleteRenderbuffers", []);
        _GenRenderbuffers = cast(PFN_glGenRenderbuffers)loadSymbol(loader, "glGenRenderbuffers", []);
        _RenderbufferStorage = cast(PFN_glRenderbufferStorage)loadSymbol(loader, "glRenderbufferStorage", []);
        _GetRenderbufferParameteriv = cast(PFN_glGetRenderbufferParameteriv)loadSymbol(loader, "glGetRenderbufferParameteriv", []);
        _IsFramebuffer = cast(PFN_glIsFramebuffer)loadSymbol(loader, "glIsFramebuffer", []);
        _BindFramebuffer = cast(PFN_glBindFramebuffer)loadSymbol(loader, "glBindFramebuffer", []);
        _DeleteFramebuffers = cast(PFN_glDeleteFramebuffers)loadSymbol(loader, "glDeleteFramebuffers", []);
        _GenFramebuffers = cast(PFN_glGenFramebuffers)loadSymbol(loader, "glGenFramebuffers", []);
        _CheckFramebufferStatus = cast(PFN_glCheckFramebufferStatus)loadSymbol(loader, "glCheckFramebufferStatus", []);
        _FramebufferTexture1D = cast(PFN_glFramebufferTexture1D)loadSymbol(loader, "glFramebufferTexture1D", []);
        _FramebufferTexture2D = cast(PFN_glFramebufferTexture2D)loadSymbol(loader, "glFramebufferTexture2D", []);
        _FramebufferTexture3D = cast(PFN_glFramebufferTexture3D)loadSymbol(loader, "glFramebufferTexture3D", []);
        _FramebufferRenderbuffer = cast(PFN_glFramebufferRenderbuffer)loadSymbol(loader, "glFramebufferRenderbuffer", []);
        _GetFramebufferAttachmentParameteriv = cast(PFN_glGetFramebufferAttachmentParameteriv)loadSymbol(loader, "glGetFramebufferAttachmentParameteriv", []);
        _GenerateMipmap = cast(PFN_glGenerateMipmap)loadSymbol(loader, "glGenerateMipmap", []);
        _BlitFramebuffer = cast(PFN_glBlitFramebuffer)loadSymbol(loader, "glBlitFramebuffer", []);
        _RenderbufferStorageMultisample = cast(PFN_glRenderbufferStorageMultisample)loadSymbol(loader, "glRenderbufferStorageMultisample", []);
        _FramebufferTextureLayer = cast(PFN_glFramebufferTextureLayer)loadSymbol(loader, "glFramebufferTextureLayer", ["glFramebufferTextureLayerARB"]);
        _MapBufferRange = cast(PFN_glMapBufferRange)loadSymbol(loader, "glMapBufferRange", []);
        _FlushMappedBufferRange = cast(PFN_glFlushMappedBufferRange)loadSymbol(loader, "glFlushMappedBufferRange", []);
        _BindVertexArray = cast(PFN_glBindVertexArray)loadSymbol(loader, "glBindVertexArray", []);
        _DeleteVertexArrays = cast(PFN_glDeleteVertexArrays)loadSymbol(loader, "glDeleteVertexArrays", []);
        _GenVertexArrays = cast(PFN_glGenVertexArrays)loadSymbol(loader, "glGenVertexArrays", []);
        _IsVertexArray = cast(PFN_glIsVertexArray)loadSymbol(loader, "glIsVertexArray", []);

        // GL_VERSION_3_1
        _DrawArraysInstanced = cast(PFN_glDrawArraysInstanced)loadSymbol(loader, "glDrawArraysInstanced", ["glDrawArraysInstancedARB", "glDrawArraysInstancedEXT"]);
        _DrawElementsInstanced = cast(PFN_glDrawElementsInstanced)loadSymbol(loader, "glDrawElementsInstanced", ["glDrawElementsInstancedARB", "glDrawElementsInstancedEXT"]);
        _TexBuffer = cast(PFN_glTexBuffer)loadSymbol(loader, "glTexBuffer", ["glTexBufferARB"]);
        _PrimitiveRestartIndex = cast(PFN_glPrimitiveRestartIndex)loadSymbol(loader, "glPrimitiveRestartIndex", []);
        _CopyBufferSubData = cast(PFN_glCopyBufferSubData)loadSymbol(loader, "glCopyBufferSubData", []);
        _GetUniformIndices = cast(PFN_glGetUniformIndices)loadSymbol(loader, "glGetUniformIndices", []);
        _GetActiveUniformsiv = cast(PFN_glGetActiveUniformsiv)loadSymbol(loader, "glGetActiveUniformsiv", []);
        _GetActiveUniformName = cast(PFN_glGetActiveUniformName)loadSymbol(loader, "glGetActiveUniformName", []);
        _GetUniformBlockIndex = cast(PFN_glGetUniformBlockIndex)loadSymbol(loader, "glGetUniformBlockIndex", []);
        _GetActiveUniformBlockiv = cast(PFN_glGetActiveUniformBlockiv)loadSymbol(loader, "glGetActiveUniformBlockiv", []);
        _GetActiveUniformBlockName = cast(PFN_glGetActiveUniformBlockName)loadSymbol(loader, "glGetActiveUniformBlockName", []);
        _UniformBlockBinding = cast(PFN_glUniformBlockBinding)loadSymbol(loader, "glUniformBlockBinding", []);

        // GL_VERSION_3_2
        _DrawElementsBaseVertex = cast(PFN_glDrawElementsBaseVertex)loadSymbol(loader, "glDrawElementsBaseVertex", []);
        _DrawRangeElementsBaseVertex = cast(PFN_glDrawRangeElementsBaseVertex)loadSymbol(loader, "glDrawRangeElementsBaseVertex", []);
        _DrawElementsInstancedBaseVertex = cast(PFN_glDrawElementsInstancedBaseVertex)loadSymbol(loader, "glDrawElementsInstancedBaseVertex", []);
        _MultiDrawElementsBaseVertex = cast(PFN_glMultiDrawElementsBaseVertex)loadSymbol(loader, "glMultiDrawElementsBaseVertex", []);
        _ProvokingVertex = cast(PFN_glProvokingVertex)loadSymbol(loader, "glProvokingVertex", []);
        _FenceSync = cast(PFN_glFenceSync)loadSymbol(loader, "glFenceSync", []);
        _IsSync = cast(PFN_glIsSync)loadSymbol(loader, "glIsSync", []);
        _DeleteSync = cast(PFN_glDeleteSync)loadSymbol(loader, "glDeleteSync", []);
        _ClientWaitSync = cast(PFN_glClientWaitSync)loadSymbol(loader, "glClientWaitSync", []);
        _WaitSync = cast(PFN_glWaitSync)loadSymbol(loader, "glWaitSync", []);
        _GetInteger64v = cast(PFN_glGetInteger64v)loadSymbol(loader, "glGetInteger64v", []);
        _GetSynciv = cast(PFN_glGetSynciv)loadSymbol(loader, "glGetSynciv", []);
        _GetInteger64i_v = cast(PFN_glGetInteger64i_v)loadSymbol(loader, "glGetInteger64i_v", []);
        _GetBufferParameteri64v = cast(PFN_glGetBufferParameteri64v)loadSymbol(loader, "glGetBufferParameteri64v", []);
        _FramebufferTexture = cast(PFN_glFramebufferTexture)loadSymbol(loader, "glFramebufferTexture", ["glFramebufferTextureARB"]);
        _TexImage2DMultisample = cast(PFN_glTexImage2DMultisample)loadSymbol(loader, "glTexImage2DMultisample", []);
        _TexImage3DMultisample = cast(PFN_glTexImage3DMultisample)loadSymbol(loader, "glTexImage3DMultisample", []);
        _GetMultisamplefv = cast(PFN_glGetMultisamplefv)loadSymbol(loader, "glGetMultisamplefv", []);
        _SampleMaski = cast(PFN_glSampleMaski)loadSymbol(loader, "glSampleMaski", []);

        // GL_VERSION_3_3
        _BindFragDataLocationIndexed = cast(PFN_glBindFragDataLocationIndexed)loadSymbol(loader, "glBindFragDataLocationIndexed", []);
        _GetFragDataIndex = cast(PFN_glGetFragDataIndex)loadSymbol(loader, "glGetFragDataIndex", []);
        _GenSamplers = cast(PFN_glGenSamplers)loadSymbol(loader, "glGenSamplers", []);
        _DeleteSamplers = cast(PFN_glDeleteSamplers)loadSymbol(loader, "glDeleteSamplers", []);
        _IsSampler = cast(PFN_glIsSampler)loadSymbol(loader, "glIsSampler", []);
        _BindSampler = cast(PFN_glBindSampler)loadSymbol(loader, "glBindSampler", []);
        _SamplerParameteri = cast(PFN_glSamplerParameteri)loadSymbol(loader, "glSamplerParameteri", []);
        _SamplerParameteriv = cast(PFN_glSamplerParameteriv)loadSymbol(loader, "glSamplerParameteriv", []);
        _SamplerParameterf = cast(PFN_glSamplerParameterf)loadSymbol(loader, "glSamplerParameterf", []);
        _SamplerParameterfv = cast(PFN_glSamplerParameterfv)loadSymbol(loader, "glSamplerParameterfv", []);
        _SamplerParameterIiv = cast(PFN_glSamplerParameterIiv)loadSymbol(loader, "glSamplerParameterIiv", []);
        _SamplerParameterIuiv = cast(PFN_glSamplerParameterIuiv)loadSymbol(loader, "glSamplerParameterIuiv", []);
        _GetSamplerParameteriv = cast(PFN_glGetSamplerParameteriv)loadSymbol(loader, "glGetSamplerParameteriv", []);
        _GetSamplerParameterIiv = cast(PFN_glGetSamplerParameterIiv)loadSymbol(loader, "glGetSamplerParameterIiv", []);
        _GetSamplerParameterfv = cast(PFN_glGetSamplerParameterfv)loadSymbol(loader, "glGetSamplerParameterfv", []);
        _GetSamplerParameterIuiv = cast(PFN_glGetSamplerParameterIuiv)loadSymbol(loader, "glGetSamplerParameterIuiv", []);
        _QueryCounter = cast(PFN_glQueryCounter)loadSymbol(loader, "glQueryCounter", []);
        _GetQueryObjecti64v = cast(PFN_glGetQueryObjecti64v)loadSymbol(loader, "glGetQueryObjecti64v", []);
        _GetQueryObjectui64v = cast(PFN_glGetQueryObjectui64v)loadSymbol(loader, "glGetQueryObjectui64v", []);
        _VertexAttribDivisor = cast(PFN_glVertexAttribDivisor)loadSymbol(loader, "glVertexAttribDivisor", ["glVertexAttribDivisorARB"]);
        _VertexAttribP1ui = cast(PFN_glVertexAttribP1ui)loadSymbol(loader, "glVertexAttribP1ui", []);
        _VertexAttribP1uiv = cast(PFN_glVertexAttribP1uiv)loadSymbol(loader, "glVertexAttribP1uiv", []);
        _VertexAttribP2ui = cast(PFN_glVertexAttribP2ui)loadSymbol(loader, "glVertexAttribP2ui", []);
        _VertexAttribP2uiv = cast(PFN_glVertexAttribP2uiv)loadSymbol(loader, "glVertexAttribP2uiv", []);
        _VertexAttribP3ui = cast(PFN_glVertexAttribP3ui)loadSymbol(loader, "glVertexAttribP3ui", []);
        _VertexAttribP3uiv = cast(PFN_glVertexAttribP3uiv)loadSymbol(loader, "glVertexAttribP3uiv", []);
        _VertexAttribP4ui = cast(PFN_glVertexAttribP4ui)loadSymbol(loader, "glVertexAttribP4ui", []);
        _VertexAttribP4uiv = cast(PFN_glVertexAttribP4uiv)loadSymbol(loader, "glVertexAttribP4uiv", []);

        // GL_VERSION_4_0
        _MinSampleShading = cast(PFN_glMinSampleShading)loadSymbol(loader, "glMinSampleShading", ["glMinSampleShadingARB"]);
        _BlendEquationi = cast(PFN_glBlendEquationi)loadSymbol(loader, "glBlendEquationi", ["glBlendEquationiARB"]);
        _BlendEquationSeparatei = cast(PFN_glBlendEquationSeparatei)loadSymbol(loader, "glBlendEquationSeparatei", ["glBlendEquationSeparateiARB"]);
        _BlendFunci = cast(PFN_glBlendFunci)loadSymbol(loader, "glBlendFunci", ["glBlendFunciARB"]);
        _BlendFuncSeparatei = cast(PFN_glBlendFuncSeparatei)loadSymbol(loader, "glBlendFuncSeparatei", ["glBlendFuncSeparateiARB"]);
        _DrawArraysIndirect = cast(PFN_glDrawArraysIndirect)loadSymbol(loader, "glDrawArraysIndirect", []);
        _DrawElementsIndirect = cast(PFN_glDrawElementsIndirect)loadSymbol(loader, "glDrawElementsIndirect", []);
        _Uniform1d = cast(PFN_glUniform1d)loadSymbol(loader, "glUniform1d", []);
        _Uniform2d = cast(PFN_glUniform2d)loadSymbol(loader, "glUniform2d", []);
        _Uniform3d = cast(PFN_glUniform3d)loadSymbol(loader, "glUniform3d", []);
        _Uniform4d = cast(PFN_glUniform4d)loadSymbol(loader, "glUniform4d", []);
        _Uniform1dv = cast(PFN_glUniform1dv)loadSymbol(loader, "glUniform1dv", []);
        _Uniform2dv = cast(PFN_glUniform2dv)loadSymbol(loader, "glUniform2dv", []);
        _Uniform3dv = cast(PFN_glUniform3dv)loadSymbol(loader, "glUniform3dv", []);
        _Uniform4dv = cast(PFN_glUniform4dv)loadSymbol(loader, "glUniform4dv", []);
        _UniformMatrix2dv = cast(PFN_glUniformMatrix2dv)loadSymbol(loader, "glUniformMatrix2dv", []);
        _UniformMatrix3dv = cast(PFN_glUniformMatrix3dv)loadSymbol(loader, "glUniformMatrix3dv", []);
        _UniformMatrix4dv = cast(PFN_glUniformMatrix4dv)loadSymbol(loader, "glUniformMatrix4dv", []);
        _UniformMatrix2x3dv = cast(PFN_glUniformMatrix2x3dv)loadSymbol(loader, "glUniformMatrix2x3dv", []);
        _UniformMatrix2x4dv = cast(PFN_glUniformMatrix2x4dv)loadSymbol(loader, "glUniformMatrix2x4dv", []);
        _UniformMatrix3x2dv = cast(PFN_glUniformMatrix3x2dv)loadSymbol(loader, "glUniformMatrix3x2dv", []);
        _UniformMatrix3x4dv = cast(PFN_glUniformMatrix3x4dv)loadSymbol(loader, "glUniformMatrix3x4dv", []);
        _UniformMatrix4x2dv = cast(PFN_glUniformMatrix4x2dv)loadSymbol(loader, "glUniformMatrix4x2dv", []);
        _UniformMatrix4x3dv = cast(PFN_glUniformMatrix4x3dv)loadSymbol(loader, "glUniformMatrix4x3dv", []);
        _GetUniformdv = cast(PFN_glGetUniformdv)loadSymbol(loader, "glGetUniformdv", []);
        _GetSubroutineUniformLocation = cast(PFN_glGetSubroutineUniformLocation)loadSymbol(loader, "glGetSubroutineUniformLocation", []);
        _GetSubroutineIndex = cast(PFN_glGetSubroutineIndex)loadSymbol(loader, "glGetSubroutineIndex", []);
        _GetActiveSubroutineUniformiv = cast(PFN_glGetActiveSubroutineUniformiv)loadSymbol(loader, "glGetActiveSubroutineUniformiv", []);
        _GetActiveSubroutineUniformName = cast(PFN_glGetActiveSubroutineUniformName)loadSymbol(loader, "glGetActiveSubroutineUniformName", []);
        _GetActiveSubroutineName = cast(PFN_glGetActiveSubroutineName)loadSymbol(loader, "glGetActiveSubroutineName", []);
        _UniformSubroutinesuiv = cast(PFN_glUniformSubroutinesuiv)loadSymbol(loader, "glUniformSubroutinesuiv", []);
        _GetUniformSubroutineuiv = cast(PFN_glGetUniformSubroutineuiv)loadSymbol(loader, "glGetUniformSubroutineuiv", []);
        _GetProgramStageiv = cast(PFN_glGetProgramStageiv)loadSymbol(loader, "glGetProgramStageiv", []);
        _PatchParameteri = cast(PFN_glPatchParameteri)loadSymbol(loader, "glPatchParameteri", []);
        _PatchParameterfv = cast(PFN_glPatchParameterfv)loadSymbol(loader, "glPatchParameterfv", []);
        _BindTransformFeedback = cast(PFN_glBindTransformFeedback)loadSymbol(loader, "glBindTransformFeedback", []);
        _DeleteTransformFeedbacks = cast(PFN_glDeleteTransformFeedbacks)loadSymbol(loader, "glDeleteTransformFeedbacks", []);
        _GenTransformFeedbacks = cast(PFN_glGenTransformFeedbacks)loadSymbol(loader, "glGenTransformFeedbacks", []);
        _IsTransformFeedback = cast(PFN_glIsTransformFeedback)loadSymbol(loader, "glIsTransformFeedback", []);
        _PauseTransformFeedback = cast(PFN_glPauseTransformFeedback)loadSymbol(loader, "glPauseTransformFeedback", []);
        _ResumeTransformFeedback = cast(PFN_glResumeTransformFeedback)loadSymbol(loader, "glResumeTransformFeedback", []);
        _DrawTransformFeedback = cast(PFN_glDrawTransformFeedback)loadSymbol(loader, "glDrawTransformFeedback", []);
        _DrawTransformFeedbackStream = cast(PFN_glDrawTransformFeedbackStream)loadSymbol(loader, "glDrawTransformFeedbackStream", []);
        _BeginQueryIndexed = cast(PFN_glBeginQueryIndexed)loadSymbol(loader, "glBeginQueryIndexed", []);
        _EndQueryIndexed = cast(PFN_glEndQueryIndexed)loadSymbol(loader, "glEndQueryIndexed", []);
        _GetQueryIndexediv = cast(PFN_glGetQueryIndexediv)loadSymbol(loader, "glGetQueryIndexediv", []);

        // GL_VERSION_4_1
        _ReleaseShaderCompiler = cast(PFN_glReleaseShaderCompiler)loadSymbol(loader, "glReleaseShaderCompiler", []);
        _ShaderBinary = cast(PFN_glShaderBinary)loadSymbol(loader, "glShaderBinary", []);
        _GetShaderPrecisionFormat = cast(PFN_glGetShaderPrecisionFormat)loadSymbol(loader, "glGetShaderPrecisionFormat", []);
        _DepthRangef = cast(PFN_glDepthRangef)loadSymbol(loader, "glDepthRangef", []);
        _ClearDepthf = cast(PFN_glClearDepthf)loadSymbol(loader, "glClearDepthf", []);
        _GetProgramBinary = cast(PFN_glGetProgramBinary)loadSymbol(loader, "glGetProgramBinary", []);
        _ProgramBinary = cast(PFN_glProgramBinary)loadSymbol(loader, "glProgramBinary", []);
        _ProgramParameteri = cast(PFN_glProgramParameteri)loadSymbol(loader, "glProgramParameteri", ["glProgramParameteriARB"]);
        _UseProgramStages = cast(PFN_glUseProgramStages)loadSymbol(loader, "glUseProgramStages", []);
        _ActiveShaderProgram = cast(PFN_glActiveShaderProgram)loadSymbol(loader, "glActiveShaderProgram", []);
        _CreateShaderProgramv = cast(PFN_glCreateShaderProgramv)loadSymbol(loader, "glCreateShaderProgramv", []);
        _BindProgramPipeline = cast(PFN_glBindProgramPipeline)loadSymbol(loader, "glBindProgramPipeline", []);
        _DeleteProgramPipelines = cast(PFN_glDeleteProgramPipelines)loadSymbol(loader, "glDeleteProgramPipelines", []);
        _GenProgramPipelines = cast(PFN_glGenProgramPipelines)loadSymbol(loader, "glGenProgramPipelines", []);
        _IsProgramPipeline = cast(PFN_glIsProgramPipeline)loadSymbol(loader, "glIsProgramPipeline", []);
        _GetProgramPipelineiv = cast(PFN_glGetProgramPipelineiv)loadSymbol(loader, "glGetProgramPipelineiv", []);
        _ProgramUniform1i = cast(PFN_glProgramUniform1i)loadSymbol(loader, "glProgramUniform1i", ["glProgramUniform1iEXT"]);
        _ProgramUniform1iv = cast(PFN_glProgramUniform1iv)loadSymbol(loader, "glProgramUniform1iv", ["glProgramUniform1ivEXT"]);
        _ProgramUniform1f = cast(PFN_glProgramUniform1f)loadSymbol(loader, "glProgramUniform1f", ["glProgramUniform1fEXT"]);
        _ProgramUniform1fv = cast(PFN_glProgramUniform1fv)loadSymbol(loader, "glProgramUniform1fv", ["glProgramUniform1fvEXT"]);
        _ProgramUniform1d = cast(PFN_glProgramUniform1d)loadSymbol(loader, "glProgramUniform1d", []);
        _ProgramUniform1dv = cast(PFN_glProgramUniform1dv)loadSymbol(loader, "glProgramUniform1dv", []);
        _ProgramUniform1ui = cast(PFN_glProgramUniform1ui)loadSymbol(loader, "glProgramUniform1ui", ["glProgramUniform1uiEXT"]);
        _ProgramUniform1uiv = cast(PFN_glProgramUniform1uiv)loadSymbol(loader, "glProgramUniform1uiv", ["glProgramUniform1uivEXT"]);
        _ProgramUniform2i = cast(PFN_glProgramUniform2i)loadSymbol(loader, "glProgramUniform2i", ["glProgramUniform2iEXT"]);
        _ProgramUniform2iv = cast(PFN_glProgramUniform2iv)loadSymbol(loader, "glProgramUniform2iv", ["glProgramUniform2ivEXT"]);
        _ProgramUniform2f = cast(PFN_glProgramUniform2f)loadSymbol(loader, "glProgramUniform2f", ["glProgramUniform2fEXT"]);
        _ProgramUniform2fv = cast(PFN_glProgramUniform2fv)loadSymbol(loader, "glProgramUniform2fv", ["glProgramUniform2fvEXT"]);
        _ProgramUniform2d = cast(PFN_glProgramUniform2d)loadSymbol(loader, "glProgramUniform2d", []);
        _ProgramUniform2dv = cast(PFN_glProgramUniform2dv)loadSymbol(loader, "glProgramUniform2dv", []);
        _ProgramUniform2ui = cast(PFN_glProgramUniform2ui)loadSymbol(loader, "glProgramUniform2ui", ["glProgramUniform2uiEXT"]);
        _ProgramUniform2uiv = cast(PFN_glProgramUniform2uiv)loadSymbol(loader, "glProgramUniform2uiv", ["glProgramUniform2uivEXT"]);
        _ProgramUniform3i = cast(PFN_glProgramUniform3i)loadSymbol(loader, "glProgramUniform3i", ["glProgramUniform3iEXT"]);
        _ProgramUniform3iv = cast(PFN_glProgramUniform3iv)loadSymbol(loader, "glProgramUniform3iv", ["glProgramUniform3ivEXT"]);
        _ProgramUniform3f = cast(PFN_glProgramUniform3f)loadSymbol(loader, "glProgramUniform3f", ["glProgramUniform3fEXT"]);
        _ProgramUniform3fv = cast(PFN_glProgramUniform3fv)loadSymbol(loader, "glProgramUniform3fv", ["glProgramUniform3fvEXT"]);
        _ProgramUniform3d = cast(PFN_glProgramUniform3d)loadSymbol(loader, "glProgramUniform3d", []);
        _ProgramUniform3dv = cast(PFN_glProgramUniform3dv)loadSymbol(loader, "glProgramUniform3dv", []);
        _ProgramUniform3ui = cast(PFN_glProgramUniform3ui)loadSymbol(loader, "glProgramUniform3ui", ["glProgramUniform3uiEXT"]);
        _ProgramUniform3uiv = cast(PFN_glProgramUniform3uiv)loadSymbol(loader, "glProgramUniform3uiv", ["glProgramUniform3uivEXT"]);
        _ProgramUniform4i = cast(PFN_glProgramUniform4i)loadSymbol(loader, "glProgramUniform4i", ["glProgramUniform4iEXT"]);
        _ProgramUniform4iv = cast(PFN_glProgramUniform4iv)loadSymbol(loader, "glProgramUniform4iv", ["glProgramUniform4ivEXT"]);
        _ProgramUniform4f = cast(PFN_glProgramUniform4f)loadSymbol(loader, "glProgramUniform4f", ["glProgramUniform4fEXT"]);
        _ProgramUniform4fv = cast(PFN_glProgramUniform4fv)loadSymbol(loader, "glProgramUniform4fv", ["glProgramUniform4fvEXT"]);
        _ProgramUniform4d = cast(PFN_glProgramUniform4d)loadSymbol(loader, "glProgramUniform4d", []);
        _ProgramUniform4dv = cast(PFN_glProgramUniform4dv)loadSymbol(loader, "glProgramUniform4dv", []);
        _ProgramUniform4ui = cast(PFN_glProgramUniform4ui)loadSymbol(loader, "glProgramUniform4ui", ["glProgramUniform4uiEXT"]);
        _ProgramUniform4uiv = cast(PFN_glProgramUniform4uiv)loadSymbol(loader, "glProgramUniform4uiv", ["glProgramUniform4uivEXT"]);
        _ProgramUniformMatrix2fv = cast(PFN_glProgramUniformMatrix2fv)loadSymbol(loader, "glProgramUniformMatrix2fv", ["glProgramUniformMatrix2fvEXT"]);
        _ProgramUniformMatrix3fv = cast(PFN_glProgramUniformMatrix3fv)loadSymbol(loader, "glProgramUniformMatrix3fv", ["glProgramUniformMatrix3fvEXT"]);
        _ProgramUniformMatrix4fv = cast(PFN_glProgramUniformMatrix4fv)loadSymbol(loader, "glProgramUniformMatrix4fv", ["glProgramUniformMatrix4fvEXT"]);
        _ProgramUniformMatrix2dv = cast(PFN_glProgramUniformMatrix2dv)loadSymbol(loader, "glProgramUniformMatrix2dv", []);
        _ProgramUniformMatrix3dv = cast(PFN_glProgramUniformMatrix3dv)loadSymbol(loader, "glProgramUniformMatrix3dv", []);
        _ProgramUniformMatrix4dv = cast(PFN_glProgramUniformMatrix4dv)loadSymbol(loader, "glProgramUniformMatrix4dv", []);
        _ProgramUniformMatrix2x3fv = cast(PFN_glProgramUniformMatrix2x3fv)loadSymbol(loader, "glProgramUniformMatrix2x3fv", ["glProgramUniformMatrix2x3fvEXT"]);
        _ProgramUniformMatrix3x2fv = cast(PFN_glProgramUniformMatrix3x2fv)loadSymbol(loader, "glProgramUniformMatrix3x2fv", ["glProgramUniformMatrix3x2fvEXT"]);
        _ProgramUniformMatrix2x4fv = cast(PFN_glProgramUniformMatrix2x4fv)loadSymbol(loader, "glProgramUniformMatrix2x4fv", ["glProgramUniformMatrix2x4fvEXT"]);
        _ProgramUniformMatrix4x2fv = cast(PFN_glProgramUniformMatrix4x2fv)loadSymbol(loader, "glProgramUniformMatrix4x2fv", ["glProgramUniformMatrix4x2fvEXT"]);
        _ProgramUniformMatrix3x4fv = cast(PFN_glProgramUniformMatrix3x4fv)loadSymbol(loader, "glProgramUniformMatrix3x4fv", ["glProgramUniformMatrix3x4fvEXT"]);
        _ProgramUniformMatrix4x3fv = cast(PFN_glProgramUniformMatrix4x3fv)loadSymbol(loader, "glProgramUniformMatrix4x3fv", ["glProgramUniformMatrix4x3fvEXT"]);
        _ProgramUniformMatrix2x3dv = cast(PFN_glProgramUniformMatrix2x3dv)loadSymbol(loader, "glProgramUniformMatrix2x3dv", []);
        _ProgramUniformMatrix3x2dv = cast(PFN_glProgramUniformMatrix3x2dv)loadSymbol(loader, "glProgramUniformMatrix3x2dv", []);
        _ProgramUniformMatrix2x4dv = cast(PFN_glProgramUniformMatrix2x4dv)loadSymbol(loader, "glProgramUniformMatrix2x4dv", []);
        _ProgramUniformMatrix4x2dv = cast(PFN_glProgramUniformMatrix4x2dv)loadSymbol(loader, "glProgramUniformMatrix4x2dv", []);
        _ProgramUniformMatrix3x4dv = cast(PFN_glProgramUniformMatrix3x4dv)loadSymbol(loader, "glProgramUniformMatrix3x4dv", []);
        _ProgramUniformMatrix4x3dv = cast(PFN_glProgramUniformMatrix4x3dv)loadSymbol(loader, "glProgramUniformMatrix4x3dv", []);
        _ValidateProgramPipeline = cast(PFN_glValidateProgramPipeline)loadSymbol(loader, "glValidateProgramPipeline", []);
        _GetProgramPipelineInfoLog = cast(PFN_glGetProgramPipelineInfoLog)loadSymbol(loader, "glGetProgramPipelineInfoLog", []);
        _VertexAttribL1d = cast(PFN_glVertexAttribL1d)loadSymbol(loader, "glVertexAttribL1d", []);
        _VertexAttribL2d = cast(PFN_glVertexAttribL2d)loadSymbol(loader, "glVertexAttribL2d", []);
        _VertexAttribL3d = cast(PFN_glVertexAttribL3d)loadSymbol(loader, "glVertexAttribL3d", []);
        _VertexAttribL4d = cast(PFN_glVertexAttribL4d)loadSymbol(loader, "glVertexAttribL4d", []);
        _VertexAttribL1dv = cast(PFN_glVertexAttribL1dv)loadSymbol(loader, "glVertexAttribL1dv", []);
        _VertexAttribL2dv = cast(PFN_glVertexAttribL2dv)loadSymbol(loader, "glVertexAttribL2dv", []);
        _VertexAttribL3dv = cast(PFN_glVertexAttribL3dv)loadSymbol(loader, "glVertexAttribL3dv", []);
        _VertexAttribL4dv = cast(PFN_glVertexAttribL4dv)loadSymbol(loader, "glVertexAttribL4dv", []);
        _VertexAttribLPointer = cast(PFN_glVertexAttribLPointer)loadSymbol(loader, "glVertexAttribLPointer", []);
        _GetVertexAttribLdv = cast(PFN_glGetVertexAttribLdv)loadSymbol(loader, "glGetVertexAttribLdv", []);
        _ViewportArrayv = cast(PFN_glViewportArrayv)loadSymbol(loader, "glViewportArrayv", []);
        _ViewportIndexedf = cast(PFN_glViewportIndexedf)loadSymbol(loader, "glViewportIndexedf", []);
        _ViewportIndexedfv = cast(PFN_glViewportIndexedfv)loadSymbol(loader, "glViewportIndexedfv", []);
        _ScissorArrayv = cast(PFN_glScissorArrayv)loadSymbol(loader, "glScissorArrayv", []);
        _ScissorIndexed = cast(PFN_glScissorIndexed)loadSymbol(loader, "glScissorIndexed", []);
        _ScissorIndexedv = cast(PFN_glScissorIndexedv)loadSymbol(loader, "glScissorIndexedv", []);
        _DepthRangeArrayv = cast(PFN_glDepthRangeArrayv)loadSymbol(loader, "glDepthRangeArrayv", []);
        _DepthRangeIndexed = cast(PFN_glDepthRangeIndexed)loadSymbol(loader, "glDepthRangeIndexed", []);
        _GetFloati_v = cast(PFN_glGetFloati_v)loadSymbol(loader, "glGetFloati_v", ["glGetFloatIndexedvEXT", "glGetFloati_vEXT"]);
        _GetDoublei_v = cast(PFN_glGetDoublei_v)loadSymbol(loader, "glGetDoublei_v", ["glGetDoubleIndexedvEXT", "glGetDoublei_vEXT"]);

        // GL_VERSION_4_2
        _DrawArraysInstancedBaseInstance = cast(PFN_glDrawArraysInstancedBaseInstance)loadSymbol(loader, "glDrawArraysInstancedBaseInstance", []);
        _DrawElementsInstancedBaseInstance = cast(PFN_glDrawElementsInstancedBaseInstance)loadSymbol(loader, "glDrawElementsInstancedBaseInstance", []);
        _DrawElementsInstancedBaseVertexBaseInstance = cast(PFN_glDrawElementsInstancedBaseVertexBaseInstance)loadSymbol(loader, "glDrawElementsInstancedBaseVertexBaseInstance", []);
        _GetInternalformativ = cast(PFN_glGetInternalformativ)loadSymbol(loader, "glGetInternalformativ", []);
        _GetActiveAtomicCounterBufferiv = cast(PFN_glGetActiveAtomicCounterBufferiv)loadSymbol(loader, "glGetActiveAtomicCounterBufferiv", []);
        _BindImageTexture = cast(PFN_glBindImageTexture)loadSymbol(loader, "glBindImageTexture", []);
        _MemoryBarrier = cast(PFN_glMemoryBarrier)loadSymbol(loader, "glMemoryBarrier", []);
        _TexStorage1D = cast(PFN_glTexStorage1D)loadSymbol(loader, "glTexStorage1D", []);
        _TexStorage2D = cast(PFN_glTexStorage2D)loadSymbol(loader, "glTexStorage2D", []);
        _TexStorage3D = cast(PFN_glTexStorage3D)loadSymbol(loader, "glTexStorage3D", []);
        _DrawTransformFeedbackInstanced = cast(PFN_glDrawTransformFeedbackInstanced)loadSymbol(loader, "glDrawTransformFeedbackInstanced", []);
        _DrawTransformFeedbackStreamInstanced = cast(PFN_glDrawTransformFeedbackStreamInstanced)loadSymbol(loader, "glDrawTransformFeedbackStreamInstanced", []);

        // GL_VERSION_4_3
        _ClearBufferData = cast(PFN_glClearBufferData)loadSymbol(loader, "glClearBufferData", []);
        _ClearBufferSubData = cast(PFN_glClearBufferSubData)loadSymbol(loader, "glClearBufferSubData", []);
        _DispatchCompute = cast(PFN_glDispatchCompute)loadSymbol(loader, "glDispatchCompute", []);
        _DispatchComputeIndirect = cast(PFN_glDispatchComputeIndirect)loadSymbol(loader, "glDispatchComputeIndirect", []);
        _CopyImageSubData = cast(PFN_glCopyImageSubData)loadSymbol(loader, "glCopyImageSubData", []);
        _FramebufferParameteri = cast(PFN_glFramebufferParameteri)loadSymbol(loader, "glFramebufferParameteri", []);
        _GetFramebufferParameteriv = cast(PFN_glGetFramebufferParameteriv)loadSymbol(loader, "glGetFramebufferParameteriv", []);
        _GetInternalformati64v = cast(PFN_glGetInternalformati64v)loadSymbol(loader, "glGetInternalformati64v", []);
        _InvalidateTexSubImage = cast(PFN_glInvalidateTexSubImage)loadSymbol(loader, "glInvalidateTexSubImage", []);
        _InvalidateTexImage = cast(PFN_glInvalidateTexImage)loadSymbol(loader, "glInvalidateTexImage", []);
        _InvalidateBufferSubData = cast(PFN_glInvalidateBufferSubData)loadSymbol(loader, "glInvalidateBufferSubData", []);
        _InvalidateBufferData = cast(PFN_glInvalidateBufferData)loadSymbol(loader, "glInvalidateBufferData", []);
        _InvalidateFramebuffer = cast(PFN_glInvalidateFramebuffer)loadSymbol(loader, "glInvalidateFramebuffer", []);
        _InvalidateSubFramebuffer = cast(PFN_glInvalidateSubFramebuffer)loadSymbol(loader, "glInvalidateSubFramebuffer", []);
        _MultiDrawArraysIndirect = cast(PFN_glMultiDrawArraysIndirect)loadSymbol(loader, "glMultiDrawArraysIndirect", []);
        _MultiDrawElementsIndirect = cast(PFN_glMultiDrawElementsIndirect)loadSymbol(loader, "glMultiDrawElementsIndirect", []);
        _GetProgramInterfaceiv = cast(PFN_glGetProgramInterfaceiv)loadSymbol(loader, "glGetProgramInterfaceiv", []);
        _GetProgramResourceIndex = cast(PFN_glGetProgramResourceIndex)loadSymbol(loader, "glGetProgramResourceIndex", []);
        _GetProgramResourceName = cast(PFN_glGetProgramResourceName)loadSymbol(loader, "glGetProgramResourceName", []);
        _GetProgramResourceiv = cast(PFN_glGetProgramResourceiv)loadSymbol(loader, "glGetProgramResourceiv", []);
        _GetProgramResourceLocation = cast(PFN_glGetProgramResourceLocation)loadSymbol(loader, "glGetProgramResourceLocation", []);
        _GetProgramResourceLocationIndex = cast(PFN_glGetProgramResourceLocationIndex)loadSymbol(loader, "glGetProgramResourceLocationIndex", []);
        _ShaderStorageBlockBinding = cast(PFN_glShaderStorageBlockBinding)loadSymbol(loader, "glShaderStorageBlockBinding", []);
        _TexBufferRange = cast(PFN_glTexBufferRange)loadSymbol(loader, "glTexBufferRange", []);
        _TexStorage2DMultisample = cast(PFN_glTexStorage2DMultisample)loadSymbol(loader, "glTexStorage2DMultisample", []);
        _TexStorage3DMultisample = cast(PFN_glTexStorage3DMultisample)loadSymbol(loader, "glTexStorage3DMultisample", []);
        _TextureView = cast(PFN_glTextureView)loadSymbol(loader, "glTextureView", []);
        _BindVertexBuffer = cast(PFN_glBindVertexBuffer)loadSymbol(loader, "glBindVertexBuffer", []);
        _VertexAttribFormat = cast(PFN_glVertexAttribFormat)loadSymbol(loader, "glVertexAttribFormat", []);
        _VertexAttribIFormat = cast(PFN_glVertexAttribIFormat)loadSymbol(loader, "glVertexAttribIFormat", []);
        _VertexAttribLFormat = cast(PFN_glVertexAttribLFormat)loadSymbol(loader, "glVertexAttribLFormat", []);
        _VertexAttribBinding = cast(PFN_glVertexAttribBinding)loadSymbol(loader, "glVertexAttribBinding", []);
        _VertexBindingDivisor = cast(PFN_glVertexBindingDivisor)loadSymbol(loader, "glVertexBindingDivisor", []);
        _DebugMessageControl = cast(PFN_glDebugMessageControl)loadSymbol(loader, "glDebugMessageControl", ["glDebugMessageControlARB"]);
        _DebugMessageInsert = cast(PFN_glDebugMessageInsert)loadSymbol(loader, "glDebugMessageInsert", ["glDebugMessageInsertARB"]);
        _DebugMessageCallback = cast(PFN_glDebugMessageCallback)loadSymbol(loader, "glDebugMessageCallback", ["glDebugMessageCallbackARB"]);
        _GetDebugMessageLog = cast(PFN_glGetDebugMessageLog)loadSymbol(loader, "glGetDebugMessageLog", ["glGetDebugMessageLogARB"]);
        _PushDebugGroup = cast(PFN_glPushDebugGroup)loadSymbol(loader, "glPushDebugGroup", []);
        _PopDebugGroup = cast(PFN_glPopDebugGroup)loadSymbol(loader, "glPopDebugGroup", []);
        _ObjectLabel = cast(PFN_glObjectLabel)loadSymbol(loader, "glObjectLabel", []);
        _GetObjectLabel = cast(PFN_glGetObjectLabel)loadSymbol(loader, "glGetObjectLabel", []);
        _ObjectPtrLabel = cast(PFN_glObjectPtrLabel)loadSymbol(loader, "glObjectPtrLabel", []);
        _GetObjectPtrLabel = cast(PFN_glGetObjectPtrLabel)loadSymbol(loader, "glGetObjectPtrLabel", []);

        // GL_VERSION_4_4
        _BufferStorage = cast(PFN_glBufferStorage)loadSymbol(loader, "glBufferStorage", []);
        _ClearTexImage = cast(PFN_glClearTexImage)loadSymbol(loader, "glClearTexImage", []);
        _ClearTexSubImage = cast(PFN_glClearTexSubImage)loadSymbol(loader, "glClearTexSubImage", []);
        _BindBuffersBase = cast(PFN_glBindBuffersBase)loadSymbol(loader, "glBindBuffersBase", []);
        _BindBuffersRange = cast(PFN_glBindBuffersRange)loadSymbol(loader, "glBindBuffersRange", []);
        _BindTextures = cast(PFN_glBindTextures)loadSymbol(loader, "glBindTextures", []);
        _BindSamplers = cast(PFN_glBindSamplers)loadSymbol(loader, "glBindSamplers", []);
        _BindImageTextures = cast(PFN_glBindImageTextures)loadSymbol(loader, "glBindImageTextures", []);
        _BindVertexBuffers = cast(PFN_glBindVertexBuffers)loadSymbol(loader, "glBindVertexBuffers", []);

        // GL_VERSION_4_5
        _ClipControl = cast(PFN_glClipControl)loadSymbol(loader, "glClipControl", []);
        _CreateTransformFeedbacks = cast(PFN_glCreateTransformFeedbacks)loadSymbol(loader, "glCreateTransformFeedbacks", []);
        _TransformFeedbackBufferBase = cast(PFN_glTransformFeedbackBufferBase)loadSymbol(loader, "glTransformFeedbackBufferBase", []);
        _TransformFeedbackBufferRange = cast(PFN_glTransformFeedbackBufferRange)loadSymbol(loader, "glTransformFeedbackBufferRange", []);
        _GetTransformFeedbackiv = cast(PFN_glGetTransformFeedbackiv)loadSymbol(loader, "glGetTransformFeedbackiv", []);
        _GetTransformFeedbacki_v = cast(PFN_glGetTransformFeedbacki_v)loadSymbol(loader, "glGetTransformFeedbacki_v", []);
        _GetTransformFeedbacki64_v = cast(PFN_glGetTransformFeedbacki64_v)loadSymbol(loader, "glGetTransformFeedbacki64_v", []);
        _CreateBuffers = cast(PFN_glCreateBuffers)loadSymbol(loader, "glCreateBuffers", []);
        _NamedBufferStorage = cast(PFN_glNamedBufferStorage)loadSymbol(loader, "glNamedBufferStorage", ["glNamedBufferStorageEXT"]);
        _NamedBufferData = cast(PFN_glNamedBufferData)loadSymbol(loader, "glNamedBufferData", []);
        _NamedBufferSubData = cast(PFN_glNamedBufferSubData)loadSymbol(loader, "glNamedBufferSubData", ["glNamedBufferSubDataEXT"]);
        _CopyNamedBufferSubData = cast(PFN_glCopyNamedBufferSubData)loadSymbol(loader, "glCopyNamedBufferSubData", []);
        _ClearNamedBufferData = cast(PFN_glClearNamedBufferData)loadSymbol(loader, "glClearNamedBufferData", []);
        _ClearNamedBufferSubData = cast(PFN_glClearNamedBufferSubData)loadSymbol(loader, "glClearNamedBufferSubData", []);
        _MapNamedBuffer = cast(PFN_glMapNamedBuffer)loadSymbol(loader, "glMapNamedBuffer", []);
        _MapNamedBufferRange = cast(PFN_glMapNamedBufferRange)loadSymbol(loader, "glMapNamedBufferRange", []);
        _UnmapNamedBuffer = cast(PFN_glUnmapNamedBuffer)loadSymbol(loader, "glUnmapNamedBuffer", []);
        _FlushMappedNamedBufferRange = cast(PFN_glFlushMappedNamedBufferRange)loadSymbol(loader, "glFlushMappedNamedBufferRange", []);
        _GetNamedBufferParameteriv = cast(PFN_glGetNamedBufferParameteriv)loadSymbol(loader, "glGetNamedBufferParameteriv", []);
        _GetNamedBufferParameteri64v = cast(PFN_glGetNamedBufferParameteri64v)loadSymbol(loader, "glGetNamedBufferParameteri64v", []);
        _GetNamedBufferPointerv = cast(PFN_glGetNamedBufferPointerv)loadSymbol(loader, "glGetNamedBufferPointerv", []);
        _GetNamedBufferSubData = cast(PFN_glGetNamedBufferSubData)loadSymbol(loader, "glGetNamedBufferSubData", []);
        _CreateFramebuffers = cast(PFN_glCreateFramebuffers)loadSymbol(loader, "glCreateFramebuffers", []);
        _NamedFramebufferRenderbuffer = cast(PFN_glNamedFramebufferRenderbuffer)loadSymbol(loader, "glNamedFramebufferRenderbuffer", []);
        _NamedFramebufferParameteri = cast(PFN_glNamedFramebufferParameteri)loadSymbol(loader, "glNamedFramebufferParameteri", []);
        _NamedFramebufferTexture = cast(PFN_glNamedFramebufferTexture)loadSymbol(loader, "glNamedFramebufferTexture", []);
        _NamedFramebufferTextureLayer = cast(PFN_glNamedFramebufferTextureLayer)loadSymbol(loader, "glNamedFramebufferTextureLayer", []);
        _NamedFramebufferDrawBuffer = cast(PFN_glNamedFramebufferDrawBuffer)loadSymbol(loader, "glNamedFramebufferDrawBuffer", []);
        _NamedFramebufferDrawBuffers = cast(PFN_glNamedFramebufferDrawBuffers)loadSymbol(loader, "glNamedFramebufferDrawBuffers", []);
        _NamedFramebufferReadBuffer = cast(PFN_glNamedFramebufferReadBuffer)loadSymbol(loader, "glNamedFramebufferReadBuffer", []);
        _InvalidateNamedFramebufferData = cast(PFN_glInvalidateNamedFramebufferData)loadSymbol(loader, "glInvalidateNamedFramebufferData", []);
        _InvalidateNamedFramebufferSubData = cast(PFN_glInvalidateNamedFramebufferSubData)loadSymbol(loader, "glInvalidateNamedFramebufferSubData", []);
        _ClearNamedFramebufferiv = cast(PFN_glClearNamedFramebufferiv)loadSymbol(loader, "glClearNamedFramebufferiv", []);
        _ClearNamedFramebufferuiv = cast(PFN_glClearNamedFramebufferuiv)loadSymbol(loader, "glClearNamedFramebufferuiv", []);
        _ClearNamedFramebufferfv = cast(PFN_glClearNamedFramebufferfv)loadSymbol(loader, "glClearNamedFramebufferfv", []);
        _ClearNamedFramebufferfi = cast(PFN_glClearNamedFramebufferfi)loadSymbol(loader, "glClearNamedFramebufferfi", []);
        _BlitNamedFramebuffer = cast(PFN_glBlitNamedFramebuffer)loadSymbol(loader, "glBlitNamedFramebuffer", []);
        _CheckNamedFramebufferStatus = cast(PFN_glCheckNamedFramebufferStatus)loadSymbol(loader, "glCheckNamedFramebufferStatus", []);
        _GetNamedFramebufferParameteriv = cast(PFN_glGetNamedFramebufferParameteriv)loadSymbol(loader, "glGetNamedFramebufferParameteriv", []);
        _GetNamedFramebufferAttachmentParameteriv = cast(PFN_glGetNamedFramebufferAttachmentParameteriv)loadSymbol(loader, "glGetNamedFramebufferAttachmentParameteriv", []);
        _CreateRenderbuffers = cast(PFN_glCreateRenderbuffers)loadSymbol(loader, "glCreateRenderbuffers", []);
        _NamedRenderbufferStorage = cast(PFN_glNamedRenderbufferStorage)loadSymbol(loader, "glNamedRenderbufferStorage", []);
        _NamedRenderbufferStorageMultisample = cast(PFN_glNamedRenderbufferStorageMultisample)loadSymbol(loader, "glNamedRenderbufferStorageMultisample", []);
        _GetNamedRenderbufferParameteriv = cast(PFN_glGetNamedRenderbufferParameteriv)loadSymbol(loader, "glGetNamedRenderbufferParameteriv", []);
        _CreateTextures = cast(PFN_glCreateTextures)loadSymbol(loader, "glCreateTextures", []);
        _TextureBuffer = cast(PFN_glTextureBuffer)loadSymbol(loader, "glTextureBuffer", []);
        _TextureBufferRange = cast(PFN_glTextureBufferRange)loadSymbol(loader, "glTextureBufferRange", []);
        _TextureStorage1D = cast(PFN_glTextureStorage1D)loadSymbol(loader, "glTextureStorage1D", []);
        _TextureStorage2D = cast(PFN_glTextureStorage2D)loadSymbol(loader, "glTextureStorage2D", []);
        _TextureStorage3D = cast(PFN_glTextureStorage3D)loadSymbol(loader, "glTextureStorage3D", []);
        _TextureStorage2DMultisample = cast(PFN_glTextureStorage2DMultisample)loadSymbol(loader, "glTextureStorage2DMultisample", []);
        _TextureStorage3DMultisample = cast(PFN_glTextureStorage3DMultisample)loadSymbol(loader, "glTextureStorage3DMultisample", []);
        _TextureSubImage1D = cast(PFN_glTextureSubImage1D)loadSymbol(loader, "glTextureSubImage1D", []);
        _TextureSubImage2D = cast(PFN_glTextureSubImage2D)loadSymbol(loader, "glTextureSubImage2D", []);
        _TextureSubImage3D = cast(PFN_glTextureSubImage3D)loadSymbol(loader, "glTextureSubImage3D", []);
        _CompressedTextureSubImage1D = cast(PFN_glCompressedTextureSubImage1D)loadSymbol(loader, "glCompressedTextureSubImage1D", []);
        _CompressedTextureSubImage2D = cast(PFN_glCompressedTextureSubImage2D)loadSymbol(loader, "glCompressedTextureSubImage2D", []);
        _CompressedTextureSubImage3D = cast(PFN_glCompressedTextureSubImage3D)loadSymbol(loader, "glCompressedTextureSubImage3D", []);
        _CopyTextureSubImage1D = cast(PFN_glCopyTextureSubImage1D)loadSymbol(loader, "glCopyTextureSubImage1D", []);
        _CopyTextureSubImage2D = cast(PFN_glCopyTextureSubImage2D)loadSymbol(loader, "glCopyTextureSubImage2D", []);
        _CopyTextureSubImage3D = cast(PFN_glCopyTextureSubImage3D)loadSymbol(loader, "glCopyTextureSubImage3D", []);
        _TextureParameterf = cast(PFN_glTextureParameterf)loadSymbol(loader, "glTextureParameterf", []);
        _TextureParameterfv = cast(PFN_glTextureParameterfv)loadSymbol(loader, "glTextureParameterfv", []);
        _TextureParameteri = cast(PFN_glTextureParameteri)loadSymbol(loader, "glTextureParameteri", []);
        _TextureParameterIiv = cast(PFN_glTextureParameterIiv)loadSymbol(loader, "glTextureParameterIiv", []);
        _TextureParameterIuiv = cast(PFN_glTextureParameterIuiv)loadSymbol(loader, "glTextureParameterIuiv", []);
        _TextureParameteriv = cast(PFN_glTextureParameteriv)loadSymbol(loader, "glTextureParameteriv", []);
        _GenerateTextureMipmap = cast(PFN_glGenerateTextureMipmap)loadSymbol(loader, "glGenerateTextureMipmap", []);
        _BindTextureUnit = cast(PFN_glBindTextureUnit)loadSymbol(loader, "glBindTextureUnit", []);
        _GetTextureImage = cast(PFN_glGetTextureImage)loadSymbol(loader, "glGetTextureImage", []);
        _GetCompressedTextureImage = cast(PFN_glGetCompressedTextureImage)loadSymbol(loader, "glGetCompressedTextureImage", []);
        _GetTextureLevelParameterfv = cast(PFN_glGetTextureLevelParameterfv)loadSymbol(loader, "glGetTextureLevelParameterfv", []);
        _GetTextureLevelParameteriv = cast(PFN_glGetTextureLevelParameteriv)loadSymbol(loader, "glGetTextureLevelParameteriv", []);
        _GetTextureParameterfv = cast(PFN_glGetTextureParameterfv)loadSymbol(loader, "glGetTextureParameterfv", []);
        _GetTextureParameterIiv = cast(PFN_glGetTextureParameterIiv)loadSymbol(loader, "glGetTextureParameterIiv", []);
        _GetTextureParameterIuiv = cast(PFN_glGetTextureParameterIuiv)loadSymbol(loader, "glGetTextureParameterIuiv", []);
        _GetTextureParameteriv = cast(PFN_glGetTextureParameteriv)loadSymbol(loader, "glGetTextureParameteriv", []);
        _CreateVertexArrays = cast(PFN_glCreateVertexArrays)loadSymbol(loader, "glCreateVertexArrays", []);
        _DisableVertexArrayAttrib = cast(PFN_glDisableVertexArrayAttrib)loadSymbol(loader, "glDisableVertexArrayAttrib", []);
        _EnableVertexArrayAttrib = cast(PFN_glEnableVertexArrayAttrib)loadSymbol(loader, "glEnableVertexArrayAttrib", []);
        _VertexArrayElementBuffer = cast(PFN_glVertexArrayElementBuffer)loadSymbol(loader, "glVertexArrayElementBuffer", []);
        _VertexArrayVertexBuffer = cast(PFN_glVertexArrayVertexBuffer)loadSymbol(loader, "glVertexArrayVertexBuffer", []);
        _VertexArrayVertexBuffers = cast(PFN_glVertexArrayVertexBuffers)loadSymbol(loader, "glVertexArrayVertexBuffers", []);
        _VertexArrayAttribBinding = cast(PFN_glVertexArrayAttribBinding)loadSymbol(loader, "glVertexArrayAttribBinding", []);
        _VertexArrayAttribFormat = cast(PFN_glVertexArrayAttribFormat)loadSymbol(loader, "glVertexArrayAttribFormat", []);
        _VertexArrayAttribIFormat = cast(PFN_glVertexArrayAttribIFormat)loadSymbol(loader, "glVertexArrayAttribIFormat", []);
        _VertexArrayAttribLFormat = cast(PFN_glVertexArrayAttribLFormat)loadSymbol(loader, "glVertexArrayAttribLFormat", []);
        _VertexArrayBindingDivisor = cast(PFN_glVertexArrayBindingDivisor)loadSymbol(loader, "glVertexArrayBindingDivisor", []);
        _GetVertexArrayiv = cast(PFN_glGetVertexArrayiv)loadSymbol(loader, "glGetVertexArrayiv", []);
        _GetVertexArrayIndexediv = cast(PFN_glGetVertexArrayIndexediv)loadSymbol(loader, "glGetVertexArrayIndexediv", []);
        _GetVertexArrayIndexed64iv = cast(PFN_glGetVertexArrayIndexed64iv)loadSymbol(loader, "glGetVertexArrayIndexed64iv", []);
        _CreateSamplers = cast(PFN_glCreateSamplers)loadSymbol(loader, "glCreateSamplers", []);
        _CreateProgramPipelines = cast(PFN_glCreateProgramPipelines)loadSymbol(loader, "glCreateProgramPipelines", []);
        _CreateQueries = cast(PFN_glCreateQueries)loadSymbol(loader, "glCreateQueries", []);
        _GetQueryBufferObjecti64v = cast(PFN_glGetQueryBufferObjecti64v)loadSymbol(loader, "glGetQueryBufferObjecti64v", []);
        _GetQueryBufferObjectiv = cast(PFN_glGetQueryBufferObjectiv)loadSymbol(loader, "glGetQueryBufferObjectiv", []);
        _GetQueryBufferObjectui64v = cast(PFN_glGetQueryBufferObjectui64v)loadSymbol(loader, "glGetQueryBufferObjectui64v", []);
        _GetQueryBufferObjectuiv = cast(PFN_glGetQueryBufferObjectuiv)loadSymbol(loader, "glGetQueryBufferObjectuiv", []);
        _MemoryBarrierByRegion = cast(PFN_glMemoryBarrierByRegion)loadSymbol(loader, "glMemoryBarrierByRegion", []);
        _GetTextureSubImage = cast(PFN_glGetTextureSubImage)loadSymbol(loader, "glGetTextureSubImage", []);
        _GetCompressedTextureSubImage = cast(PFN_glGetCompressedTextureSubImage)loadSymbol(loader, "glGetCompressedTextureSubImage", []);
        _GetGraphicsResetStatus = cast(PFN_glGetGraphicsResetStatus)loadSymbol(loader, "glGetGraphicsResetStatus", []);
        _GetnCompressedTexImage = cast(PFN_glGetnCompressedTexImage)loadSymbol(loader, "glGetnCompressedTexImage", []);
        _GetnTexImage = cast(PFN_glGetnTexImage)loadSymbol(loader, "glGetnTexImage", []);
        _GetnUniformdv = cast(PFN_glGetnUniformdv)loadSymbol(loader, "glGetnUniformdv", []);
        _GetnUniformfv = cast(PFN_glGetnUniformfv)loadSymbol(loader, "glGetnUniformfv", []);
        _GetnUniformiv = cast(PFN_glGetnUniformiv)loadSymbol(loader, "glGetnUniformiv", []);
        _GetnUniformuiv = cast(PFN_glGetnUniformuiv)loadSymbol(loader, "glGetnUniformuiv", []);
        _ReadnPixels = cast(PFN_glReadnPixels)loadSymbol(loader, "glReadnPixels", ["glReadnPixelsARB"]);
        _TextureBarrier = cast(PFN_glTextureBarrier)loadSymbol(loader, "glTextureBarrier", []);

        // GL_VERSION_4_6
        _SpecializeShader = cast(PFN_glSpecializeShader)loadSymbol(loader, "glSpecializeShader", ["glSpecializeShaderARB"]);
        _MultiDrawArraysIndirectCount = cast(PFN_glMultiDrawArraysIndirectCount)loadSymbol(loader, "glMultiDrawArraysIndirectCount", ["glMultiDrawArraysIndirectCountARB"]);
        _MultiDrawElementsIndirectCount = cast(PFN_glMultiDrawElementsIndirectCount)loadSymbol(loader, "glMultiDrawElementsIndirectCount", ["glMultiDrawElementsIndirectCountARB"]);
        _PolygonOffsetClamp = cast(PFN_glPolygonOffsetClamp)loadSymbol(loader, "glPolygonOffsetClamp", ["glPolygonOffsetClampEXT"]);

        // GL_ARB_ES3_2_compatibility,
        _PrimitiveBoundingBoxARB = cast(PFN_glPrimitiveBoundingBoxARB)loadSymbol(loader, "glPrimitiveBoundingBoxARB", []);

        // GL_ARB_bindless_texture,
        _GetTextureHandleARB = cast(PFN_glGetTextureHandleARB)loadSymbol(loader, "glGetTextureHandleARB", []);
        _GetTextureSamplerHandleARB = cast(PFN_glGetTextureSamplerHandleARB)loadSymbol(loader, "glGetTextureSamplerHandleARB", []);
        _MakeTextureHandleResidentARB = cast(PFN_glMakeTextureHandleResidentARB)loadSymbol(loader, "glMakeTextureHandleResidentARB", []);
        _MakeTextureHandleNonResidentARB = cast(PFN_glMakeTextureHandleNonResidentARB)loadSymbol(loader, "glMakeTextureHandleNonResidentARB", []);
        _GetImageHandleARB = cast(PFN_glGetImageHandleARB)loadSymbol(loader, "glGetImageHandleARB", []);
        _MakeImageHandleResidentARB = cast(PFN_glMakeImageHandleResidentARB)loadSymbol(loader, "glMakeImageHandleResidentARB", []);
        _MakeImageHandleNonResidentARB = cast(PFN_glMakeImageHandleNonResidentARB)loadSymbol(loader, "glMakeImageHandleNonResidentARB", []);
        _UniformHandleui64ARB = cast(PFN_glUniformHandleui64ARB)loadSymbol(loader, "glUniformHandleui64ARB", []);
        _UniformHandleui64vARB = cast(PFN_glUniformHandleui64vARB)loadSymbol(loader, "glUniformHandleui64vARB", []);
        _ProgramUniformHandleui64ARB = cast(PFN_glProgramUniformHandleui64ARB)loadSymbol(loader, "glProgramUniformHandleui64ARB", []);
        _ProgramUniformHandleui64vARB = cast(PFN_glProgramUniformHandleui64vARB)loadSymbol(loader, "glProgramUniformHandleui64vARB", []);
        _IsTextureHandleResidentARB = cast(PFN_glIsTextureHandleResidentARB)loadSymbol(loader, "glIsTextureHandleResidentARB", []);
        _IsImageHandleResidentARB = cast(PFN_glIsImageHandleResidentARB)loadSymbol(loader, "glIsImageHandleResidentARB", []);
        _VertexAttribL1ui64ARB = cast(PFN_glVertexAttribL1ui64ARB)loadSymbol(loader, "glVertexAttribL1ui64ARB", []);
        _VertexAttribL1ui64vARB = cast(PFN_glVertexAttribL1ui64vARB)loadSymbol(loader, "glVertexAttribL1ui64vARB", []);
        _GetVertexAttribLui64vARB = cast(PFN_glGetVertexAttribLui64vARB)loadSymbol(loader, "glGetVertexAttribLui64vARB", []);

        // GL_ARB_cl_event,
        _CreateSyncFromCLeventARB = cast(PFN_glCreateSyncFromCLeventARB)loadSymbol(loader, "glCreateSyncFromCLeventARB", []);

        // GL_ARB_compute_variable_group_size,
        _DispatchComputeGroupSizeARB = cast(PFN_glDispatchComputeGroupSizeARB)loadSymbol(loader, "glDispatchComputeGroupSizeARB", []);

        // GL_ARB_geometry_shader4,
        _FramebufferTextureFaceARB = cast(PFN_glFramebufferTextureFaceARB)loadSymbol(loader, "glFramebufferTextureFaceARB", []);

        // GL_ARB_gpu_shader_int64,
        _Uniform1i64ARB = cast(PFN_glUniform1i64ARB)loadSymbol(loader, "glUniform1i64ARB", []);
        _Uniform2i64ARB = cast(PFN_glUniform2i64ARB)loadSymbol(loader, "glUniform2i64ARB", []);
        _Uniform3i64ARB = cast(PFN_glUniform3i64ARB)loadSymbol(loader, "glUniform3i64ARB", []);
        _Uniform4i64ARB = cast(PFN_glUniform4i64ARB)loadSymbol(loader, "glUniform4i64ARB", []);
        _Uniform1i64vARB = cast(PFN_glUniform1i64vARB)loadSymbol(loader, "glUniform1i64vARB", []);
        _Uniform2i64vARB = cast(PFN_glUniform2i64vARB)loadSymbol(loader, "glUniform2i64vARB", []);
        _Uniform3i64vARB = cast(PFN_glUniform3i64vARB)loadSymbol(loader, "glUniform3i64vARB", []);
        _Uniform4i64vARB = cast(PFN_glUniform4i64vARB)loadSymbol(loader, "glUniform4i64vARB", []);
        _Uniform1ui64ARB = cast(PFN_glUniform1ui64ARB)loadSymbol(loader, "glUniform1ui64ARB", []);
        _Uniform2ui64ARB = cast(PFN_glUniform2ui64ARB)loadSymbol(loader, "glUniform2ui64ARB", []);
        _Uniform3ui64ARB = cast(PFN_glUniform3ui64ARB)loadSymbol(loader, "glUniform3ui64ARB", []);
        _Uniform4ui64ARB = cast(PFN_glUniform4ui64ARB)loadSymbol(loader, "glUniform4ui64ARB", []);
        _Uniform1ui64vARB = cast(PFN_glUniform1ui64vARB)loadSymbol(loader, "glUniform1ui64vARB", []);
        _Uniform2ui64vARB = cast(PFN_glUniform2ui64vARB)loadSymbol(loader, "glUniform2ui64vARB", []);
        _Uniform3ui64vARB = cast(PFN_glUniform3ui64vARB)loadSymbol(loader, "glUniform3ui64vARB", []);
        _Uniform4ui64vARB = cast(PFN_glUniform4ui64vARB)loadSymbol(loader, "glUniform4ui64vARB", []);
        _GetUniformi64vARB = cast(PFN_glGetUniformi64vARB)loadSymbol(loader, "glGetUniformi64vARB", []);
        _GetUniformui64vARB = cast(PFN_glGetUniformui64vARB)loadSymbol(loader, "glGetUniformui64vARB", []);
        _GetnUniformi64vARB = cast(PFN_glGetnUniformi64vARB)loadSymbol(loader, "glGetnUniformi64vARB", []);
        _GetnUniformui64vARB = cast(PFN_glGetnUniformui64vARB)loadSymbol(loader, "glGetnUniformui64vARB", []);
        _ProgramUniform1i64ARB = cast(PFN_glProgramUniform1i64ARB)loadSymbol(loader, "glProgramUniform1i64ARB", []);
        _ProgramUniform2i64ARB = cast(PFN_glProgramUniform2i64ARB)loadSymbol(loader, "glProgramUniform2i64ARB", []);
        _ProgramUniform3i64ARB = cast(PFN_glProgramUniform3i64ARB)loadSymbol(loader, "glProgramUniform3i64ARB", []);
        _ProgramUniform4i64ARB = cast(PFN_glProgramUniform4i64ARB)loadSymbol(loader, "glProgramUniform4i64ARB", []);
        _ProgramUniform1i64vARB = cast(PFN_glProgramUniform1i64vARB)loadSymbol(loader, "glProgramUniform1i64vARB", []);
        _ProgramUniform2i64vARB = cast(PFN_glProgramUniform2i64vARB)loadSymbol(loader, "glProgramUniform2i64vARB", []);
        _ProgramUniform3i64vARB = cast(PFN_glProgramUniform3i64vARB)loadSymbol(loader, "glProgramUniform3i64vARB", []);
        _ProgramUniform4i64vARB = cast(PFN_glProgramUniform4i64vARB)loadSymbol(loader, "glProgramUniform4i64vARB", []);
        _ProgramUniform1ui64ARB = cast(PFN_glProgramUniform1ui64ARB)loadSymbol(loader, "glProgramUniform1ui64ARB", []);
        _ProgramUniform2ui64ARB = cast(PFN_glProgramUniform2ui64ARB)loadSymbol(loader, "glProgramUniform2ui64ARB", []);
        _ProgramUniform3ui64ARB = cast(PFN_glProgramUniform3ui64ARB)loadSymbol(loader, "glProgramUniform3ui64ARB", []);
        _ProgramUniform4ui64ARB = cast(PFN_glProgramUniform4ui64ARB)loadSymbol(loader, "glProgramUniform4ui64ARB", []);
        _ProgramUniform1ui64vARB = cast(PFN_glProgramUniform1ui64vARB)loadSymbol(loader, "glProgramUniform1ui64vARB", []);
        _ProgramUniform2ui64vARB = cast(PFN_glProgramUniform2ui64vARB)loadSymbol(loader, "glProgramUniform2ui64vARB", []);
        _ProgramUniform3ui64vARB = cast(PFN_glProgramUniform3ui64vARB)loadSymbol(loader, "glProgramUniform3ui64vARB", []);
        _ProgramUniform4ui64vARB = cast(PFN_glProgramUniform4ui64vARB)loadSymbol(loader, "glProgramUniform4ui64vARB", []);

        // GL_ARB_parallel_shader_compile,
        _MaxShaderCompilerThreadsARB = cast(PFN_glMaxShaderCompilerThreadsARB)loadSymbol(loader, "glMaxShaderCompilerThreadsARB", []);

        // GL_ARB_robustness,
        _GetGraphicsResetStatusARB = cast(PFN_glGetGraphicsResetStatusARB)loadSymbol(loader, "glGetGraphicsResetStatusARB", []);
        _GetnTexImageARB = cast(PFN_glGetnTexImageARB)loadSymbol(loader, "glGetnTexImageARB", []);
        _GetnCompressedTexImageARB = cast(PFN_glGetnCompressedTexImageARB)loadSymbol(loader, "glGetnCompressedTexImageARB", []);
        _GetnUniformfvARB = cast(PFN_glGetnUniformfvARB)loadSymbol(loader, "glGetnUniformfvARB", []);
        _GetnUniformivARB = cast(PFN_glGetnUniformivARB)loadSymbol(loader, "glGetnUniformivARB", []);
        _GetnUniformuivARB = cast(PFN_glGetnUniformuivARB)loadSymbol(loader, "glGetnUniformuivARB", []);
        _GetnUniformdvARB = cast(PFN_glGetnUniformdvARB)loadSymbol(loader, "glGetnUniformdvARB", []);

        // GL_ARB_sample_locations,
        _FramebufferSampleLocationsfvARB = cast(PFN_glFramebufferSampleLocationsfvARB)loadSymbol(loader, "glFramebufferSampleLocationsfvARB", []);
        _NamedFramebufferSampleLocationsfvARB = cast(PFN_glNamedFramebufferSampleLocationsfvARB)loadSymbol(loader, "glNamedFramebufferSampleLocationsfvARB", []);
        _EvaluateDepthValuesARB = cast(PFN_glEvaluateDepthValuesARB)loadSymbol(loader, "glEvaluateDepthValuesARB", []);

        // GL_ARB_shading_language_include,
        _NamedStringARB = cast(PFN_glNamedStringARB)loadSymbol(loader, "glNamedStringARB", []);
        _DeleteNamedStringARB = cast(PFN_glDeleteNamedStringARB)loadSymbol(loader, "glDeleteNamedStringARB", []);
        _CompileShaderIncludeARB = cast(PFN_glCompileShaderIncludeARB)loadSymbol(loader, "glCompileShaderIncludeARB", []);
        _IsNamedStringARB = cast(PFN_glIsNamedStringARB)loadSymbol(loader, "glIsNamedStringARB", []);
        _GetNamedStringARB = cast(PFN_glGetNamedStringARB)loadSymbol(loader, "glGetNamedStringARB", []);
        _GetNamedStringivARB = cast(PFN_glGetNamedStringivARB)loadSymbol(loader, "glGetNamedStringivARB", []);

        // GL_ARB_sparse_buffer,
        _BufferPageCommitmentARB = cast(PFN_glBufferPageCommitmentARB)loadSymbol(loader, "glBufferPageCommitmentARB", []);
        _NamedBufferPageCommitmentEXT = cast(PFN_glNamedBufferPageCommitmentEXT)loadSymbol(loader, "glNamedBufferPageCommitmentEXT", []);
        _NamedBufferPageCommitmentARB = cast(PFN_glNamedBufferPageCommitmentARB)loadSymbol(loader, "glNamedBufferPageCommitmentARB", []);

        // GL_ARB_sparse_texture,
        _TexPageCommitmentARB = cast(PFN_glTexPageCommitmentARB)loadSymbol(loader, "glTexPageCommitmentARB", []);

        // GL_KHR_blend_equation_advanced,
        _BlendBarrierKHR = cast(PFN_glBlendBarrierKHR)loadSymbol(loader, "glBlendBarrierKHR", []);

        // GL_KHR_parallel_shader_compile,
        _MaxShaderCompilerThreadsKHR = cast(PFN_glMaxShaderCompilerThreadsKHR)loadSymbol(loader, "glMaxShaderCompilerThreadsKHR", []);

        // GL_AMD_performance_monitor,
        _GetPerfMonitorGroupsAMD = cast(PFN_glGetPerfMonitorGroupsAMD)loadSymbol(loader, "glGetPerfMonitorGroupsAMD", []);
        _GetPerfMonitorCountersAMD = cast(PFN_glGetPerfMonitorCountersAMD)loadSymbol(loader, "glGetPerfMonitorCountersAMD", []);
        _GetPerfMonitorGroupStringAMD = cast(PFN_glGetPerfMonitorGroupStringAMD)loadSymbol(loader, "glGetPerfMonitorGroupStringAMD", []);
        _GetPerfMonitorCounterStringAMD = cast(PFN_glGetPerfMonitorCounterStringAMD)loadSymbol(loader, "glGetPerfMonitorCounterStringAMD", []);
        _GetPerfMonitorCounterInfoAMD = cast(PFN_glGetPerfMonitorCounterInfoAMD)loadSymbol(loader, "glGetPerfMonitorCounterInfoAMD", []);
        _GenPerfMonitorsAMD = cast(PFN_glGenPerfMonitorsAMD)loadSymbol(loader, "glGenPerfMonitorsAMD", []);
        _DeletePerfMonitorsAMD = cast(PFN_glDeletePerfMonitorsAMD)loadSymbol(loader, "glDeletePerfMonitorsAMD", []);
        _SelectPerfMonitorCountersAMD = cast(PFN_glSelectPerfMonitorCountersAMD)loadSymbol(loader, "glSelectPerfMonitorCountersAMD", []);
        _BeginPerfMonitorAMD = cast(PFN_glBeginPerfMonitorAMD)loadSymbol(loader, "glBeginPerfMonitorAMD", []);
        _EndPerfMonitorAMD = cast(PFN_glEndPerfMonitorAMD)loadSymbol(loader, "glEndPerfMonitorAMD", []);
        _GetPerfMonitorCounterDataAMD = cast(PFN_glGetPerfMonitorCounterDataAMD)loadSymbol(loader, "glGetPerfMonitorCounterDataAMD", []);

        // GL_EXT_debug_label,
        _LabelObjectEXT = cast(PFN_glLabelObjectEXT)loadSymbol(loader, "glLabelObjectEXT", []);
        _GetObjectLabelEXT = cast(PFN_glGetObjectLabelEXT)loadSymbol(loader, "glGetObjectLabelEXT", []);

        // GL_EXT_debug_marker,
        _InsertEventMarkerEXT = cast(PFN_glInsertEventMarkerEXT)loadSymbol(loader, "glInsertEventMarkerEXT", []);
        _PushGroupMarkerEXT = cast(PFN_glPushGroupMarkerEXT)loadSymbol(loader, "glPushGroupMarkerEXT", []);
        _PopGroupMarkerEXT = cast(PFN_glPopGroupMarkerEXT)loadSymbol(loader, "glPopGroupMarkerEXT", []);

        // GL_EXT_direct_state_access,
        _MatrixLoadfEXT = cast(PFN_glMatrixLoadfEXT)loadSymbol(loader, "glMatrixLoadfEXT", []);
        _MatrixLoaddEXT = cast(PFN_glMatrixLoaddEXT)loadSymbol(loader, "glMatrixLoaddEXT", []);
        _MatrixMultfEXT = cast(PFN_glMatrixMultfEXT)loadSymbol(loader, "glMatrixMultfEXT", []);
        _MatrixMultdEXT = cast(PFN_glMatrixMultdEXT)loadSymbol(loader, "glMatrixMultdEXT", []);
        _MatrixLoadIdentityEXT = cast(PFN_glMatrixLoadIdentityEXT)loadSymbol(loader, "glMatrixLoadIdentityEXT", []);
        _MatrixRotatefEXT = cast(PFN_glMatrixRotatefEXT)loadSymbol(loader, "glMatrixRotatefEXT", []);
        _MatrixRotatedEXT = cast(PFN_glMatrixRotatedEXT)loadSymbol(loader, "glMatrixRotatedEXT", []);
        _MatrixScalefEXT = cast(PFN_glMatrixScalefEXT)loadSymbol(loader, "glMatrixScalefEXT", []);
        _MatrixScaledEXT = cast(PFN_glMatrixScaledEXT)loadSymbol(loader, "glMatrixScaledEXT", []);
        _MatrixTranslatefEXT = cast(PFN_glMatrixTranslatefEXT)loadSymbol(loader, "glMatrixTranslatefEXT", []);
        _MatrixTranslatedEXT = cast(PFN_glMatrixTranslatedEXT)loadSymbol(loader, "glMatrixTranslatedEXT", []);
        _MatrixFrustumEXT = cast(PFN_glMatrixFrustumEXT)loadSymbol(loader, "glMatrixFrustumEXT", []);
        _MatrixOrthoEXT = cast(PFN_glMatrixOrthoEXT)loadSymbol(loader, "glMatrixOrthoEXT", []);
        _MatrixPopEXT = cast(PFN_glMatrixPopEXT)loadSymbol(loader, "glMatrixPopEXT", []);
        _MatrixPushEXT = cast(PFN_glMatrixPushEXT)loadSymbol(loader, "glMatrixPushEXT", []);
        _ClientAttribDefaultEXT = cast(PFN_glClientAttribDefaultEXT)loadSymbol(loader, "glClientAttribDefaultEXT", []);
        _PushClientAttribDefaultEXT = cast(PFN_glPushClientAttribDefaultEXT)loadSymbol(loader, "glPushClientAttribDefaultEXT", []);
        _TextureParameterfEXT = cast(PFN_glTextureParameterfEXT)loadSymbol(loader, "glTextureParameterfEXT", []);
        _TextureParameterfvEXT = cast(PFN_glTextureParameterfvEXT)loadSymbol(loader, "glTextureParameterfvEXT", []);
        _TextureParameteriEXT = cast(PFN_glTextureParameteriEXT)loadSymbol(loader, "glTextureParameteriEXT", []);
        _TextureParameterivEXT = cast(PFN_glTextureParameterivEXT)loadSymbol(loader, "glTextureParameterivEXT", []);
        _TextureImage1DEXT = cast(PFN_glTextureImage1DEXT)loadSymbol(loader, "glTextureImage1DEXT", []);
        _TextureImage2DEXT = cast(PFN_glTextureImage2DEXT)loadSymbol(loader, "glTextureImage2DEXT", []);
        _TextureSubImage1DEXT = cast(PFN_glTextureSubImage1DEXT)loadSymbol(loader, "glTextureSubImage1DEXT", []);
        _TextureSubImage2DEXT = cast(PFN_glTextureSubImage2DEXT)loadSymbol(loader, "glTextureSubImage2DEXT", []);
        _CopyTextureImage1DEXT = cast(PFN_glCopyTextureImage1DEXT)loadSymbol(loader, "glCopyTextureImage1DEXT", []);
        _CopyTextureImage2DEXT = cast(PFN_glCopyTextureImage2DEXT)loadSymbol(loader, "glCopyTextureImage2DEXT", []);
        _CopyTextureSubImage1DEXT = cast(PFN_glCopyTextureSubImage1DEXT)loadSymbol(loader, "glCopyTextureSubImage1DEXT", []);
        _CopyTextureSubImage2DEXT = cast(PFN_glCopyTextureSubImage2DEXT)loadSymbol(loader, "glCopyTextureSubImage2DEXT", []);
        _GetTextureImageEXT = cast(PFN_glGetTextureImageEXT)loadSymbol(loader, "glGetTextureImageEXT", []);
        _GetTextureParameterfvEXT = cast(PFN_glGetTextureParameterfvEXT)loadSymbol(loader, "glGetTextureParameterfvEXT", []);
        _GetTextureParameterivEXT = cast(PFN_glGetTextureParameterivEXT)loadSymbol(loader, "glGetTextureParameterivEXT", []);
        _GetTextureLevelParameterfvEXT = cast(PFN_glGetTextureLevelParameterfvEXT)loadSymbol(loader, "glGetTextureLevelParameterfvEXT", []);
        _GetTextureLevelParameterivEXT = cast(PFN_glGetTextureLevelParameterivEXT)loadSymbol(loader, "glGetTextureLevelParameterivEXT", []);
        _TextureImage3DEXT = cast(PFN_glTextureImage3DEXT)loadSymbol(loader, "glTextureImage3DEXT", []);
        _TextureSubImage3DEXT = cast(PFN_glTextureSubImage3DEXT)loadSymbol(loader, "glTextureSubImage3DEXT", []);
        _CopyTextureSubImage3DEXT = cast(PFN_glCopyTextureSubImage3DEXT)loadSymbol(loader, "glCopyTextureSubImage3DEXT", []);
        _BindMultiTextureEXT = cast(PFN_glBindMultiTextureEXT)loadSymbol(loader, "glBindMultiTextureEXT", []);
        _MultiTexCoordPointerEXT = cast(PFN_glMultiTexCoordPointerEXT)loadSymbol(loader, "glMultiTexCoordPointerEXT", []);
        _MultiTexEnvfEXT = cast(PFN_glMultiTexEnvfEXT)loadSymbol(loader, "glMultiTexEnvfEXT", []);
        _MultiTexEnvfvEXT = cast(PFN_glMultiTexEnvfvEXT)loadSymbol(loader, "glMultiTexEnvfvEXT", []);
        _MultiTexEnviEXT = cast(PFN_glMultiTexEnviEXT)loadSymbol(loader, "glMultiTexEnviEXT", []);
        _MultiTexEnvivEXT = cast(PFN_glMultiTexEnvivEXT)loadSymbol(loader, "glMultiTexEnvivEXT", []);
        _MultiTexGendEXT = cast(PFN_glMultiTexGendEXT)loadSymbol(loader, "glMultiTexGendEXT", []);
        _MultiTexGendvEXT = cast(PFN_glMultiTexGendvEXT)loadSymbol(loader, "glMultiTexGendvEXT", []);
        _MultiTexGenfEXT = cast(PFN_glMultiTexGenfEXT)loadSymbol(loader, "glMultiTexGenfEXT", []);
        _MultiTexGenfvEXT = cast(PFN_glMultiTexGenfvEXT)loadSymbol(loader, "glMultiTexGenfvEXT", []);
        _MultiTexGeniEXT = cast(PFN_glMultiTexGeniEXT)loadSymbol(loader, "glMultiTexGeniEXT", []);
        _MultiTexGenivEXT = cast(PFN_glMultiTexGenivEXT)loadSymbol(loader, "glMultiTexGenivEXT", []);
        _GetMultiTexEnvfvEXT = cast(PFN_glGetMultiTexEnvfvEXT)loadSymbol(loader, "glGetMultiTexEnvfvEXT", []);
        _GetMultiTexEnvivEXT = cast(PFN_glGetMultiTexEnvivEXT)loadSymbol(loader, "glGetMultiTexEnvivEXT", []);
        _GetMultiTexGendvEXT = cast(PFN_glGetMultiTexGendvEXT)loadSymbol(loader, "glGetMultiTexGendvEXT", []);
        _GetMultiTexGenfvEXT = cast(PFN_glGetMultiTexGenfvEXT)loadSymbol(loader, "glGetMultiTexGenfvEXT", []);
        _GetMultiTexGenivEXT = cast(PFN_glGetMultiTexGenivEXT)loadSymbol(loader, "glGetMultiTexGenivEXT", []);
        _MultiTexParameteriEXT = cast(PFN_glMultiTexParameteriEXT)loadSymbol(loader, "glMultiTexParameteriEXT", []);
        _MultiTexParameterivEXT = cast(PFN_glMultiTexParameterivEXT)loadSymbol(loader, "glMultiTexParameterivEXT", []);
        _MultiTexParameterfEXT = cast(PFN_glMultiTexParameterfEXT)loadSymbol(loader, "glMultiTexParameterfEXT", []);
        _MultiTexParameterfvEXT = cast(PFN_glMultiTexParameterfvEXT)loadSymbol(loader, "glMultiTexParameterfvEXT", []);
        _MultiTexImage1DEXT = cast(PFN_glMultiTexImage1DEXT)loadSymbol(loader, "glMultiTexImage1DEXT", []);
        _MultiTexImage2DEXT = cast(PFN_glMultiTexImage2DEXT)loadSymbol(loader, "glMultiTexImage2DEXT", []);
        _MultiTexSubImage1DEXT = cast(PFN_glMultiTexSubImage1DEXT)loadSymbol(loader, "glMultiTexSubImage1DEXT", []);
        _MultiTexSubImage2DEXT = cast(PFN_glMultiTexSubImage2DEXT)loadSymbol(loader, "glMultiTexSubImage2DEXT", []);
        _CopyMultiTexImage1DEXT = cast(PFN_glCopyMultiTexImage1DEXT)loadSymbol(loader, "glCopyMultiTexImage1DEXT", []);
        _CopyMultiTexImage2DEXT = cast(PFN_glCopyMultiTexImage2DEXT)loadSymbol(loader, "glCopyMultiTexImage2DEXT", []);
        _CopyMultiTexSubImage1DEXT = cast(PFN_glCopyMultiTexSubImage1DEXT)loadSymbol(loader, "glCopyMultiTexSubImage1DEXT", []);
        _CopyMultiTexSubImage2DEXT = cast(PFN_glCopyMultiTexSubImage2DEXT)loadSymbol(loader, "glCopyMultiTexSubImage2DEXT", []);
        _GetMultiTexImageEXT = cast(PFN_glGetMultiTexImageEXT)loadSymbol(loader, "glGetMultiTexImageEXT", []);
        _GetMultiTexParameterfvEXT = cast(PFN_glGetMultiTexParameterfvEXT)loadSymbol(loader, "glGetMultiTexParameterfvEXT", []);
        _GetMultiTexParameterivEXT = cast(PFN_glGetMultiTexParameterivEXT)loadSymbol(loader, "glGetMultiTexParameterivEXT", []);
        _GetMultiTexLevelParameterfvEXT = cast(PFN_glGetMultiTexLevelParameterfvEXT)loadSymbol(loader, "glGetMultiTexLevelParameterfvEXT", []);
        _GetMultiTexLevelParameterivEXT = cast(PFN_glGetMultiTexLevelParameterivEXT)loadSymbol(loader, "glGetMultiTexLevelParameterivEXT", []);
        _MultiTexImage3DEXT = cast(PFN_glMultiTexImage3DEXT)loadSymbol(loader, "glMultiTexImage3DEXT", []);
        _MultiTexSubImage3DEXT = cast(PFN_glMultiTexSubImage3DEXT)loadSymbol(loader, "glMultiTexSubImage3DEXT", []);
        _CopyMultiTexSubImage3DEXT = cast(PFN_glCopyMultiTexSubImage3DEXT)loadSymbol(loader, "glCopyMultiTexSubImage3DEXT", []);
        _EnableClientStateIndexedEXT = cast(PFN_glEnableClientStateIndexedEXT)loadSymbol(loader, "glEnableClientStateIndexedEXT", []);
        _DisableClientStateIndexedEXT = cast(PFN_glDisableClientStateIndexedEXT)loadSymbol(loader, "glDisableClientStateIndexedEXT", []);
        _GetPointerIndexedvEXT = cast(PFN_glGetPointerIndexedvEXT)loadSymbol(loader, "glGetPointerIndexedvEXT", []);
        _CompressedTextureImage3DEXT = cast(PFN_glCompressedTextureImage3DEXT)loadSymbol(loader, "glCompressedTextureImage3DEXT", []);
        _CompressedTextureImage2DEXT = cast(PFN_glCompressedTextureImage2DEXT)loadSymbol(loader, "glCompressedTextureImage2DEXT", []);
        _CompressedTextureImage1DEXT = cast(PFN_glCompressedTextureImage1DEXT)loadSymbol(loader, "glCompressedTextureImage1DEXT", []);
        _CompressedTextureSubImage3DEXT = cast(PFN_glCompressedTextureSubImage3DEXT)loadSymbol(loader, "glCompressedTextureSubImage3DEXT", []);
        _CompressedTextureSubImage2DEXT = cast(PFN_glCompressedTextureSubImage2DEXT)loadSymbol(loader, "glCompressedTextureSubImage2DEXT", []);
        _CompressedTextureSubImage1DEXT = cast(PFN_glCompressedTextureSubImage1DEXT)loadSymbol(loader, "glCompressedTextureSubImage1DEXT", []);
        _GetCompressedTextureImageEXT = cast(PFN_glGetCompressedTextureImageEXT)loadSymbol(loader, "glGetCompressedTextureImageEXT", []);
        _CompressedMultiTexImage3DEXT = cast(PFN_glCompressedMultiTexImage3DEXT)loadSymbol(loader, "glCompressedMultiTexImage3DEXT", []);
        _CompressedMultiTexImage2DEXT = cast(PFN_glCompressedMultiTexImage2DEXT)loadSymbol(loader, "glCompressedMultiTexImage2DEXT", []);
        _CompressedMultiTexImage1DEXT = cast(PFN_glCompressedMultiTexImage1DEXT)loadSymbol(loader, "glCompressedMultiTexImage1DEXT", []);
        _CompressedMultiTexSubImage3DEXT = cast(PFN_glCompressedMultiTexSubImage3DEXT)loadSymbol(loader, "glCompressedMultiTexSubImage3DEXT", []);
        _CompressedMultiTexSubImage2DEXT = cast(PFN_glCompressedMultiTexSubImage2DEXT)loadSymbol(loader, "glCompressedMultiTexSubImage2DEXT", []);
        _CompressedMultiTexSubImage1DEXT = cast(PFN_glCompressedMultiTexSubImage1DEXT)loadSymbol(loader, "glCompressedMultiTexSubImage1DEXT", []);
        _GetCompressedMultiTexImageEXT = cast(PFN_glGetCompressedMultiTexImageEXT)loadSymbol(loader, "glGetCompressedMultiTexImageEXT", []);
        _MatrixLoadTransposefEXT = cast(PFN_glMatrixLoadTransposefEXT)loadSymbol(loader, "glMatrixLoadTransposefEXT", []);
        _MatrixLoadTransposedEXT = cast(PFN_glMatrixLoadTransposedEXT)loadSymbol(loader, "glMatrixLoadTransposedEXT", []);
        _MatrixMultTransposefEXT = cast(PFN_glMatrixMultTransposefEXT)loadSymbol(loader, "glMatrixMultTransposefEXT", []);
        _MatrixMultTransposedEXT = cast(PFN_glMatrixMultTransposedEXT)loadSymbol(loader, "glMatrixMultTransposedEXT", []);
        _NamedBufferDataEXT = cast(PFN_glNamedBufferDataEXT)loadSymbol(loader, "glNamedBufferDataEXT", []);
        _MapNamedBufferEXT = cast(PFN_glMapNamedBufferEXT)loadSymbol(loader, "glMapNamedBufferEXT", []);
        _UnmapNamedBufferEXT = cast(PFN_glUnmapNamedBufferEXT)loadSymbol(loader, "glUnmapNamedBufferEXT", []);
        _GetNamedBufferParameterivEXT = cast(PFN_glGetNamedBufferParameterivEXT)loadSymbol(loader, "glGetNamedBufferParameterivEXT", []);
        _GetNamedBufferPointervEXT = cast(PFN_glGetNamedBufferPointervEXT)loadSymbol(loader, "glGetNamedBufferPointervEXT", []);
        _GetNamedBufferSubDataEXT = cast(PFN_glGetNamedBufferSubDataEXT)loadSymbol(loader, "glGetNamedBufferSubDataEXT", []);
        _TextureBufferEXT = cast(PFN_glTextureBufferEXT)loadSymbol(loader, "glTextureBufferEXT", []);
        _MultiTexBufferEXT = cast(PFN_glMultiTexBufferEXT)loadSymbol(loader, "glMultiTexBufferEXT", []);
        _TextureParameterIivEXT = cast(PFN_glTextureParameterIivEXT)loadSymbol(loader, "glTextureParameterIivEXT", []);
        _TextureParameterIuivEXT = cast(PFN_glTextureParameterIuivEXT)loadSymbol(loader, "glTextureParameterIuivEXT", []);
        _GetTextureParameterIivEXT = cast(PFN_glGetTextureParameterIivEXT)loadSymbol(loader, "glGetTextureParameterIivEXT", []);
        _GetTextureParameterIuivEXT = cast(PFN_glGetTextureParameterIuivEXT)loadSymbol(loader, "glGetTextureParameterIuivEXT", []);
        _MultiTexParameterIivEXT = cast(PFN_glMultiTexParameterIivEXT)loadSymbol(loader, "glMultiTexParameterIivEXT", []);
        _MultiTexParameterIuivEXT = cast(PFN_glMultiTexParameterIuivEXT)loadSymbol(loader, "glMultiTexParameterIuivEXT", []);
        _GetMultiTexParameterIivEXT = cast(PFN_glGetMultiTexParameterIivEXT)loadSymbol(loader, "glGetMultiTexParameterIivEXT", []);
        _GetMultiTexParameterIuivEXT = cast(PFN_glGetMultiTexParameterIuivEXT)loadSymbol(loader, "glGetMultiTexParameterIuivEXT", []);
        _NamedProgramLocalParameters4fvEXT = cast(PFN_glNamedProgramLocalParameters4fvEXT)loadSymbol(loader, "glNamedProgramLocalParameters4fvEXT", []);
        _NamedProgramLocalParameterI4iEXT = cast(PFN_glNamedProgramLocalParameterI4iEXT)loadSymbol(loader, "glNamedProgramLocalParameterI4iEXT", []);
        _NamedProgramLocalParameterI4ivEXT = cast(PFN_glNamedProgramLocalParameterI4ivEXT)loadSymbol(loader, "glNamedProgramLocalParameterI4ivEXT", []);
        _NamedProgramLocalParametersI4ivEXT = cast(PFN_glNamedProgramLocalParametersI4ivEXT)loadSymbol(loader, "glNamedProgramLocalParametersI4ivEXT", []);
        _NamedProgramLocalParameterI4uiEXT = cast(PFN_glNamedProgramLocalParameterI4uiEXT)loadSymbol(loader, "glNamedProgramLocalParameterI4uiEXT", []);
        _NamedProgramLocalParameterI4uivEXT = cast(PFN_glNamedProgramLocalParameterI4uivEXT)loadSymbol(loader, "glNamedProgramLocalParameterI4uivEXT", []);
        _NamedProgramLocalParametersI4uivEXT = cast(PFN_glNamedProgramLocalParametersI4uivEXT)loadSymbol(loader, "glNamedProgramLocalParametersI4uivEXT", []);
        _GetNamedProgramLocalParameterIivEXT = cast(PFN_glGetNamedProgramLocalParameterIivEXT)loadSymbol(loader, "glGetNamedProgramLocalParameterIivEXT", []);
        _GetNamedProgramLocalParameterIuivEXT = cast(PFN_glGetNamedProgramLocalParameterIuivEXT)loadSymbol(loader, "glGetNamedProgramLocalParameterIuivEXT", []);
        _EnableClientStateiEXT = cast(PFN_glEnableClientStateiEXT)loadSymbol(loader, "glEnableClientStateiEXT", []);
        _DisableClientStateiEXT = cast(PFN_glDisableClientStateiEXT)loadSymbol(loader, "glDisableClientStateiEXT", []);
        _GetPointeri_vEXT = cast(PFN_glGetPointeri_vEXT)loadSymbol(loader, "glGetPointeri_vEXT", []);
        _NamedProgramStringEXT = cast(PFN_glNamedProgramStringEXT)loadSymbol(loader, "glNamedProgramStringEXT", []);
        _NamedProgramLocalParameter4dEXT = cast(PFN_glNamedProgramLocalParameter4dEXT)loadSymbol(loader, "glNamedProgramLocalParameter4dEXT", []);
        _NamedProgramLocalParameter4dvEXT = cast(PFN_glNamedProgramLocalParameter4dvEXT)loadSymbol(loader, "glNamedProgramLocalParameter4dvEXT", []);
        _NamedProgramLocalParameter4fEXT = cast(PFN_glNamedProgramLocalParameter4fEXT)loadSymbol(loader, "glNamedProgramLocalParameter4fEXT", []);
        _NamedProgramLocalParameter4fvEXT = cast(PFN_glNamedProgramLocalParameter4fvEXT)loadSymbol(loader, "glNamedProgramLocalParameter4fvEXT", []);
        _GetNamedProgramLocalParameterdvEXT = cast(PFN_glGetNamedProgramLocalParameterdvEXT)loadSymbol(loader, "glGetNamedProgramLocalParameterdvEXT", []);
        _GetNamedProgramLocalParameterfvEXT = cast(PFN_glGetNamedProgramLocalParameterfvEXT)loadSymbol(loader, "glGetNamedProgramLocalParameterfvEXT", []);
        _GetNamedProgramivEXT = cast(PFN_glGetNamedProgramivEXT)loadSymbol(loader, "glGetNamedProgramivEXT", []);
        _GetNamedProgramStringEXT = cast(PFN_glGetNamedProgramStringEXT)loadSymbol(loader, "glGetNamedProgramStringEXT", []);
        _NamedRenderbufferStorageEXT = cast(PFN_glNamedRenderbufferStorageEXT)loadSymbol(loader, "glNamedRenderbufferStorageEXT", []);
        _GetNamedRenderbufferParameterivEXT = cast(PFN_glGetNamedRenderbufferParameterivEXT)loadSymbol(loader, "glGetNamedRenderbufferParameterivEXT", []);
        _NamedRenderbufferStorageMultisampleEXT = cast(PFN_glNamedRenderbufferStorageMultisampleEXT)loadSymbol(loader, "glNamedRenderbufferStorageMultisampleEXT", []);
        _NamedRenderbufferStorageMultisampleCoverageEXT = cast(PFN_glNamedRenderbufferStorageMultisampleCoverageEXT)loadSymbol(loader, "glNamedRenderbufferStorageMultisampleCoverageEXT", []);
        _CheckNamedFramebufferStatusEXT = cast(PFN_glCheckNamedFramebufferStatusEXT)loadSymbol(loader, "glCheckNamedFramebufferStatusEXT", []);
        _NamedFramebufferTexture1DEXT = cast(PFN_glNamedFramebufferTexture1DEXT)loadSymbol(loader, "glNamedFramebufferTexture1DEXT", []);
        _NamedFramebufferTexture2DEXT = cast(PFN_glNamedFramebufferTexture2DEXT)loadSymbol(loader, "glNamedFramebufferTexture2DEXT", []);
        _NamedFramebufferTexture3DEXT = cast(PFN_glNamedFramebufferTexture3DEXT)loadSymbol(loader, "glNamedFramebufferTexture3DEXT", []);
        _NamedFramebufferRenderbufferEXT = cast(PFN_glNamedFramebufferRenderbufferEXT)loadSymbol(loader, "glNamedFramebufferRenderbufferEXT", []);
        _GetNamedFramebufferAttachmentParameterivEXT = cast(PFN_glGetNamedFramebufferAttachmentParameterivEXT)loadSymbol(loader, "glGetNamedFramebufferAttachmentParameterivEXT", []);
        _GenerateTextureMipmapEXT = cast(PFN_glGenerateTextureMipmapEXT)loadSymbol(loader, "glGenerateTextureMipmapEXT", []);
        _GenerateMultiTexMipmapEXT = cast(PFN_glGenerateMultiTexMipmapEXT)loadSymbol(loader, "glGenerateMultiTexMipmapEXT", []);
        _FramebufferDrawBufferEXT = cast(PFN_glFramebufferDrawBufferEXT)loadSymbol(loader, "glFramebufferDrawBufferEXT", []);
        _FramebufferDrawBuffersEXT = cast(PFN_glFramebufferDrawBuffersEXT)loadSymbol(loader, "glFramebufferDrawBuffersEXT", []);
        _FramebufferReadBufferEXT = cast(PFN_glFramebufferReadBufferEXT)loadSymbol(loader, "glFramebufferReadBufferEXT", []);
        _GetFramebufferParameterivEXT = cast(PFN_glGetFramebufferParameterivEXT)loadSymbol(loader, "glGetFramebufferParameterivEXT", []);
        _NamedCopyBufferSubDataEXT = cast(PFN_glNamedCopyBufferSubDataEXT)loadSymbol(loader, "glNamedCopyBufferSubDataEXT", []);
        _NamedFramebufferTextureEXT = cast(PFN_glNamedFramebufferTextureEXT)loadSymbol(loader, "glNamedFramebufferTextureEXT", []);
        _NamedFramebufferTextureLayerEXT = cast(PFN_glNamedFramebufferTextureLayerEXT)loadSymbol(loader, "glNamedFramebufferTextureLayerEXT", []);
        _NamedFramebufferTextureFaceEXT = cast(PFN_glNamedFramebufferTextureFaceEXT)loadSymbol(loader, "glNamedFramebufferTextureFaceEXT", []);
        _TextureRenderbufferEXT = cast(PFN_glTextureRenderbufferEXT)loadSymbol(loader, "glTextureRenderbufferEXT", []);
        _MultiTexRenderbufferEXT = cast(PFN_glMultiTexRenderbufferEXT)loadSymbol(loader, "glMultiTexRenderbufferEXT", []);
        _VertexArrayVertexOffsetEXT = cast(PFN_glVertexArrayVertexOffsetEXT)loadSymbol(loader, "glVertexArrayVertexOffsetEXT", []);
        _VertexArrayColorOffsetEXT = cast(PFN_glVertexArrayColorOffsetEXT)loadSymbol(loader, "glVertexArrayColorOffsetEXT", []);
        _VertexArrayEdgeFlagOffsetEXT = cast(PFN_glVertexArrayEdgeFlagOffsetEXT)loadSymbol(loader, "glVertexArrayEdgeFlagOffsetEXT", []);
        _VertexArrayIndexOffsetEXT = cast(PFN_glVertexArrayIndexOffsetEXT)loadSymbol(loader, "glVertexArrayIndexOffsetEXT", []);
        _VertexArrayNormalOffsetEXT = cast(PFN_glVertexArrayNormalOffsetEXT)loadSymbol(loader, "glVertexArrayNormalOffsetEXT", []);
        _VertexArrayTexCoordOffsetEXT = cast(PFN_glVertexArrayTexCoordOffsetEXT)loadSymbol(loader, "glVertexArrayTexCoordOffsetEXT", []);
        _VertexArrayMultiTexCoordOffsetEXT = cast(PFN_glVertexArrayMultiTexCoordOffsetEXT)loadSymbol(loader, "glVertexArrayMultiTexCoordOffsetEXT", []);
        _VertexArrayFogCoordOffsetEXT = cast(PFN_glVertexArrayFogCoordOffsetEXT)loadSymbol(loader, "glVertexArrayFogCoordOffsetEXT", []);
        _VertexArraySecondaryColorOffsetEXT = cast(PFN_glVertexArraySecondaryColorOffsetEXT)loadSymbol(loader, "glVertexArraySecondaryColorOffsetEXT", []);
        _VertexArrayVertexAttribOffsetEXT = cast(PFN_glVertexArrayVertexAttribOffsetEXT)loadSymbol(loader, "glVertexArrayVertexAttribOffsetEXT", []);
        _VertexArrayVertexAttribIOffsetEXT = cast(PFN_glVertexArrayVertexAttribIOffsetEXT)loadSymbol(loader, "glVertexArrayVertexAttribIOffsetEXT", []);
        _EnableVertexArrayEXT = cast(PFN_glEnableVertexArrayEXT)loadSymbol(loader, "glEnableVertexArrayEXT", []);
        _DisableVertexArrayEXT = cast(PFN_glDisableVertexArrayEXT)loadSymbol(loader, "glDisableVertexArrayEXT", []);
        _EnableVertexArrayAttribEXT = cast(PFN_glEnableVertexArrayAttribEXT)loadSymbol(loader, "glEnableVertexArrayAttribEXT", []);
        _DisableVertexArrayAttribEXT = cast(PFN_glDisableVertexArrayAttribEXT)loadSymbol(loader, "glDisableVertexArrayAttribEXT", []);
        _GetVertexArrayIntegervEXT = cast(PFN_glGetVertexArrayIntegervEXT)loadSymbol(loader, "glGetVertexArrayIntegervEXT", []);
        _GetVertexArrayPointervEXT = cast(PFN_glGetVertexArrayPointervEXT)loadSymbol(loader, "glGetVertexArrayPointervEXT", []);
        _GetVertexArrayIntegeri_vEXT = cast(PFN_glGetVertexArrayIntegeri_vEXT)loadSymbol(loader, "glGetVertexArrayIntegeri_vEXT", []);
        _GetVertexArrayPointeri_vEXT = cast(PFN_glGetVertexArrayPointeri_vEXT)loadSymbol(loader, "glGetVertexArrayPointeri_vEXT", []);
        _MapNamedBufferRangeEXT = cast(PFN_glMapNamedBufferRangeEXT)loadSymbol(loader, "glMapNamedBufferRangeEXT", []);
        _FlushMappedNamedBufferRangeEXT = cast(PFN_glFlushMappedNamedBufferRangeEXT)loadSymbol(loader, "glFlushMappedNamedBufferRangeEXT", []);
        _ClearNamedBufferDataEXT = cast(PFN_glClearNamedBufferDataEXT)loadSymbol(loader, "glClearNamedBufferDataEXT", []);
        _ClearNamedBufferSubDataEXT = cast(PFN_glClearNamedBufferSubDataEXT)loadSymbol(loader, "glClearNamedBufferSubDataEXT", []);
        _NamedFramebufferParameteriEXT = cast(PFN_glNamedFramebufferParameteriEXT)loadSymbol(loader, "glNamedFramebufferParameteriEXT", []);
        _GetNamedFramebufferParameterivEXT = cast(PFN_glGetNamedFramebufferParameterivEXT)loadSymbol(loader, "glGetNamedFramebufferParameterivEXT", []);
        _ProgramUniform1dEXT = cast(PFN_glProgramUniform1dEXT)loadSymbol(loader, "glProgramUniform1dEXT", []);
        _ProgramUniform2dEXT = cast(PFN_glProgramUniform2dEXT)loadSymbol(loader, "glProgramUniform2dEXT", []);
        _ProgramUniform3dEXT = cast(PFN_glProgramUniform3dEXT)loadSymbol(loader, "glProgramUniform3dEXT", []);
        _ProgramUniform4dEXT = cast(PFN_glProgramUniform4dEXT)loadSymbol(loader, "glProgramUniform4dEXT", []);
        _ProgramUniform1dvEXT = cast(PFN_glProgramUniform1dvEXT)loadSymbol(loader, "glProgramUniform1dvEXT", []);
        _ProgramUniform2dvEXT = cast(PFN_glProgramUniform2dvEXT)loadSymbol(loader, "glProgramUniform2dvEXT", []);
        _ProgramUniform3dvEXT = cast(PFN_glProgramUniform3dvEXT)loadSymbol(loader, "glProgramUniform3dvEXT", []);
        _ProgramUniform4dvEXT = cast(PFN_glProgramUniform4dvEXT)loadSymbol(loader, "glProgramUniform4dvEXT", []);
        _ProgramUniformMatrix2dvEXT = cast(PFN_glProgramUniformMatrix2dvEXT)loadSymbol(loader, "glProgramUniformMatrix2dvEXT", []);
        _ProgramUniformMatrix3dvEXT = cast(PFN_glProgramUniformMatrix3dvEXT)loadSymbol(loader, "glProgramUniformMatrix3dvEXT", []);
        _ProgramUniformMatrix4dvEXT = cast(PFN_glProgramUniformMatrix4dvEXT)loadSymbol(loader, "glProgramUniformMatrix4dvEXT", []);
        _ProgramUniformMatrix2x3dvEXT = cast(PFN_glProgramUniformMatrix2x3dvEXT)loadSymbol(loader, "glProgramUniformMatrix2x3dvEXT", []);
        _ProgramUniformMatrix2x4dvEXT = cast(PFN_glProgramUniformMatrix2x4dvEXT)loadSymbol(loader, "glProgramUniformMatrix2x4dvEXT", []);
        _ProgramUniformMatrix3x2dvEXT = cast(PFN_glProgramUniformMatrix3x2dvEXT)loadSymbol(loader, "glProgramUniformMatrix3x2dvEXT", []);
        _ProgramUniformMatrix3x4dvEXT = cast(PFN_glProgramUniformMatrix3x4dvEXT)loadSymbol(loader, "glProgramUniformMatrix3x4dvEXT", []);
        _ProgramUniformMatrix4x2dvEXT = cast(PFN_glProgramUniformMatrix4x2dvEXT)loadSymbol(loader, "glProgramUniformMatrix4x2dvEXT", []);
        _ProgramUniformMatrix4x3dvEXT = cast(PFN_glProgramUniformMatrix4x3dvEXT)loadSymbol(loader, "glProgramUniformMatrix4x3dvEXT", []);
        _TextureBufferRangeEXT = cast(PFN_glTextureBufferRangeEXT)loadSymbol(loader, "glTextureBufferRangeEXT", []);
        _TextureStorage1DEXT = cast(PFN_glTextureStorage1DEXT)loadSymbol(loader, "glTextureStorage1DEXT", []);
        _TextureStorage2DEXT = cast(PFN_glTextureStorage2DEXT)loadSymbol(loader, "glTextureStorage2DEXT", []);
        _TextureStorage3DEXT = cast(PFN_glTextureStorage3DEXT)loadSymbol(loader, "glTextureStorage3DEXT", []);
        _TextureStorage2DMultisampleEXT = cast(PFN_glTextureStorage2DMultisampleEXT)loadSymbol(loader, "glTextureStorage2DMultisampleEXT", []);
        _TextureStorage3DMultisampleEXT = cast(PFN_glTextureStorage3DMultisampleEXT)loadSymbol(loader, "glTextureStorage3DMultisampleEXT", []);
        _VertexArrayBindVertexBufferEXT = cast(PFN_glVertexArrayBindVertexBufferEXT)loadSymbol(loader, "glVertexArrayBindVertexBufferEXT", []);
        _VertexArrayVertexAttribFormatEXT = cast(PFN_glVertexArrayVertexAttribFormatEXT)loadSymbol(loader, "glVertexArrayVertexAttribFormatEXT", []);
        _VertexArrayVertexAttribIFormatEXT = cast(PFN_glVertexArrayVertexAttribIFormatEXT)loadSymbol(loader, "glVertexArrayVertexAttribIFormatEXT", []);
        _VertexArrayVertexAttribLFormatEXT = cast(PFN_glVertexArrayVertexAttribLFormatEXT)loadSymbol(loader, "glVertexArrayVertexAttribLFormatEXT", []);
        _VertexArrayVertexAttribBindingEXT = cast(PFN_glVertexArrayVertexAttribBindingEXT)loadSymbol(loader, "glVertexArrayVertexAttribBindingEXT", []);
        _VertexArrayVertexBindingDivisorEXT = cast(PFN_glVertexArrayVertexBindingDivisorEXT)loadSymbol(loader, "glVertexArrayVertexBindingDivisorEXT", []);
        _VertexArrayVertexAttribLOffsetEXT = cast(PFN_glVertexArrayVertexAttribLOffsetEXT)loadSymbol(loader, "glVertexArrayVertexAttribLOffsetEXT", []);
        _TexturePageCommitmentEXT = cast(PFN_glTexturePageCommitmentEXT)loadSymbol(loader, "glTexturePageCommitmentEXT", []);
        _VertexArrayVertexAttribDivisorEXT = cast(PFN_glVertexArrayVertexAttribDivisorEXT)loadSymbol(loader, "glVertexArrayVertexAttribDivisorEXT", []);

        // GL_EXT_raster_multisample,
        _RasterSamplesEXT = cast(PFN_glRasterSamplesEXT)loadSymbol(loader, "glRasterSamplesEXT", []);

        // GL_EXT_separate_shader_objects,
        _UseShaderProgramEXT = cast(PFN_glUseShaderProgramEXT)loadSymbol(loader, "glUseShaderProgramEXT", []);
        _ActiveProgramEXT = cast(PFN_glActiveProgramEXT)loadSymbol(loader, "glActiveProgramEXT", []);
        _CreateShaderProgramEXT = cast(PFN_glCreateShaderProgramEXT)loadSymbol(loader, "glCreateShaderProgramEXT", []);

        // GL_EXT_window_rectangles,
        _WindowRectanglesEXT = cast(PFN_glWindowRectanglesEXT)loadSymbol(loader, "glWindowRectanglesEXT", []);

        // GL_INTEL_framebuffer_CMAA,
        _ApplyFramebufferAttachmentCMAAINTEL = cast(PFN_glApplyFramebufferAttachmentCMAAINTEL)loadSymbol(loader, "glApplyFramebufferAttachmentCMAAINTEL", []);

        // GL_INTEL_performance_query,
        _BeginPerfQueryINTEL = cast(PFN_glBeginPerfQueryINTEL)loadSymbol(loader, "glBeginPerfQueryINTEL", []);
        _CreatePerfQueryINTEL = cast(PFN_glCreatePerfQueryINTEL)loadSymbol(loader, "glCreatePerfQueryINTEL", []);
        _DeletePerfQueryINTEL = cast(PFN_glDeletePerfQueryINTEL)loadSymbol(loader, "glDeletePerfQueryINTEL", []);
        _EndPerfQueryINTEL = cast(PFN_glEndPerfQueryINTEL)loadSymbol(loader, "glEndPerfQueryINTEL", []);
        _GetFirstPerfQueryIdINTEL = cast(PFN_glGetFirstPerfQueryIdINTEL)loadSymbol(loader, "glGetFirstPerfQueryIdINTEL", []);
        _GetNextPerfQueryIdINTEL = cast(PFN_glGetNextPerfQueryIdINTEL)loadSymbol(loader, "glGetNextPerfQueryIdINTEL", []);
        _GetPerfCounterInfoINTEL = cast(PFN_glGetPerfCounterInfoINTEL)loadSymbol(loader, "glGetPerfCounterInfoINTEL", []);
        _GetPerfQueryDataINTEL = cast(PFN_glGetPerfQueryDataINTEL)loadSymbol(loader, "glGetPerfQueryDataINTEL", []);
        _GetPerfQueryIdByNameINTEL = cast(PFN_glGetPerfQueryIdByNameINTEL)loadSymbol(loader, "glGetPerfQueryIdByNameINTEL", []);
        _GetPerfQueryInfoINTEL = cast(PFN_glGetPerfQueryInfoINTEL)loadSymbol(loader, "glGetPerfQueryInfoINTEL", []);

        // GL_NV_bindless_multi_draw_indirect,
        _MultiDrawArraysIndirectBindlessNV = cast(PFN_glMultiDrawArraysIndirectBindlessNV)loadSymbol(loader, "glMultiDrawArraysIndirectBindlessNV", []);
        _MultiDrawElementsIndirectBindlessNV = cast(PFN_glMultiDrawElementsIndirectBindlessNV)loadSymbol(loader, "glMultiDrawElementsIndirectBindlessNV", []);

        // GL_NV_bindless_multi_draw_indirect_count,
        _MultiDrawArraysIndirectBindlessCountNV = cast(PFN_glMultiDrawArraysIndirectBindlessCountNV)loadSymbol(loader, "glMultiDrawArraysIndirectBindlessCountNV", []);
        _MultiDrawElementsIndirectBindlessCountNV = cast(PFN_glMultiDrawElementsIndirectBindlessCountNV)loadSymbol(loader, "glMultiDrawElementsIndirectBindlessCountNV", []);

        // GL_NV_bindless_texture,
        _GetTextureHandleNV = cast(PFN_glGetTextureHandleNV)loadSymbol(loader, "glGetTextureHandleNV", []);
        _GetTextureSamplerHandleNV = cast(PFN_glGetTextureSamplerHandleNV)loadSymbol(loader, "glGetTextureSamplerHandleNV", []);
        _MakeTextureHandleResidentNV = cast(PFN_glMakeTextureHandleResidentNV)loadSymbol(loader, "glMakeTextureHandleResidentNV", []);
        _MakeTextureHandleNonResidentNV = cast(PFN_glMakeTextureHandleNonResidentNV)loadSymbol(loader, "glMakeTextureHandleNonResidentNV", []);
        _GetImageHandleNV = cast(PFN_glGetImageHandleNV)loadSymbol(loader, "glGetImageHandleNV", []);
        _MakeImageHandleResidentNV = cast(PFN_glMakeImageHandleResidentNV)loadSymbol(loader, "glMakeImageHandleResidentNV", []);
        _MakeImageHandleNonResidentNV = cast(PFN_glMakeImageHandleNonResidentNV)loadSymbol(loader, "glMakeImageHandleNonResidentNV", []);
        _UniformHandleui64NV = cast(PFN_glUniformHandleui64NV)loadSymbol(loader, "glUniformHandleui64NV", []);
        _UniformHandleui64vNV = cast(PFN_glUniformHandleui64vNV)loadSymbol(loader, "glUniformHandleui64vNV", []);
        _ProgramUniformHandleui64NV = cast(PFN_glProgramUniformHandleui64NV)loadSymbol(loader, "glProgramUniformHandleui64NV", []);
        _ProgramUniformHandleui64vNV = cast(PFN_glProgramUniformHandleui64vNV)loadSymbol(loader, "glProgramUniformHandleui64vNV", []);
        _IsTextureHandleResidentNV = cast(PFN_glIsTextureHandleResidentNV)loadSymbol(loader, "glIsTextureHandleResidentNV", []);
        _IsImageHandleResidentNV = cast(PFN_glIsImageHandleResidentNV)loadSymbol(loader, "glIsImageHandleResidentNV", []);

        // GL_NV_blend_equation_advanced,
        _BlendParameteriNV = cast(PFN_glBlendParameteriNV)loadSymbol(loader, "glBlendParameteriNV", []);
        _BlendBarrierNV = cast(PFN_glBlendBarrierNV)loadSymbol(loader, "glBlendBarrierNV", []);

        // GL_NV_clip_space_w_scaling,
        _ViewportPositionWScaleNV = cast(PFN_glViewportPositionWScaleNV)loadSymbol(loader, "glViewportPositionWScaleNV", []);

        // GL_NV_command_list,
        _CreateStatesNV = cast(PFN_glCreateStatesNV)loadSymbol(loader, "glCreateStatesNV", []);
        _DeleteStatesNV = cast(PFN_glDeleteStatesNV)loadSymbol(loader, "glDeleteStatesNV", []);
        _IsStateNV = cast(PFN_glIsStateNV)loadSymbol(loader, "glIsStateNV", []);
        _StateCaptureNV = cast(PFN_glStateCaptureNV)loadSymbol(loader, "glStateCaptureNV", []);
        _GetCommandHeaderNV = cast(PFN_glGetCommandHeaderNV)loadSymbol(loader, "glGetCommandHeaderNV", []);
        _GetStageIndexNV = cast(PFN_glGetStageIndexNV)loadSymbol(loader, "glGetStageIndexNV", []);
        _DrawCommandsNV = cast(PFN_glDrawCommandsNV)loadSymbol(loader, "glDrawCommandsNV", []);
        _DrawCommandsAddressNV = cast(PFN_glDrawCommandsAddressNV)loadSymbol(loader, "glDrawCommandsAddressNV", []);
        _DrawCommandsStatesNV = cast(PFN_glDrawCommandsStatesNV)loadSymbol(loader, "glDrawCommandsStatesNV", []);
        _DrawCommandsStatesAddressNV = cast(PFN_glDrawCommandsStatesAddressNV)loadSymbol(loader, "glDrawCommandsStatesAddressNV", []);
        _CreateCommandListsNV = cast(PFN_glCreateCommandListsNV)loadSymbol(loader, "glCreateCommandListsNV", []);
        _DeleteCommandListsNV = cast(PFN_glDeleteCommandListsNV)loadSymbol(loader, "glDeleteCommandListsNV", []);
        _IsCommandListNV = cast(PFN_glIsCommandListNV)loadSymbol(loader, "glIsCommandListNV", []);
        _ListDrawCommandsStatesClientNV = cast(PFN_glListDrawCommandsStatesClientNV)loadSymbol(loader, "glListDrawCommandsStatesClientNV", []);
        _CommandListSegmentsNV = cast(PFN_glCommandListSegmentsNV)loadSymbol(loader, "glCommandListSegmentsNV", []);
        _CompileCommandListNV = cast(PFN_glCompileCommandListNV)loadSymbol(loader, "glCompileCommandListNV", []);
        _CallCommandListNV = cast(PFN_glCallCommandListNV)loadSymbol(loader, "glCallCommandListNV", []);

        // GL_NV_conservative_raster,
        _SubpixelPrecisionBiasNV = cast(PFN_glSubpixelPrecisionBiasNV)loadSymbol(loader, "glSubpixelPrecisionBiasNV", []);

        // GL_NV_conservative_raster_dilate,
        _ConservativeRasterParameterfNV = cast(PFN_glConservativeRasterParameterfNV)loadSymbol(loader, "glConservativeRasterParameterfNV", []);

        // GL_NV_conservative_raster_pre_snap_triangles,
        _ConservativeRasterParameteriNV = cast(PFN_glConservativeRasterParameteriNV)loadSymbol(loader, "glConservativeRasterParameteriNV", []);

        // GL_NV_draw_vulkan_image,
        _DrawVkImageNV = cast(PFN_glDrawVkImageNV)loadSymbol(loader, "glDrawVkImageNV", []);
        _GetVkProcAddrNV = cast(PFN_glGetVkProcAddrNV)loadSymbol(loader, "glGetVkProcAddrNV", []);
        _WaitVkSemaphoreNV = cast(PFN_glWaitVkSemaphoreNV)loadSymbol(loader, "glWaitVkSemaphoreNV", []);
        _SignalVkSemaphoreNV = cast(PFN_glSignalVkSemaphoreNV)loadSymbol(loader, "glSignalVkSemaphoreNV", []);
        _SignalVkFenceNV = cast(PFN_glSignalVkFenceNV)loadSymbol(loader, "glSignalVkFenceNV", []);

        // GL_NV_fragment_coverage_to_color,
        _FragmentCoverageColorNV = cast(PFN_glFragmentCoverageColorNV)loadSymbol(loader, "glFragmentCoverageColorNV", []);

        // GL_NV_framebuffer_mixed_samples,
        _CoverageModulationTableNV = cast(PFN_glCoverageModulationTableNV)loadSymbol(loader, "glCoverageModulationTableNV", []);
        _GetCoverageModulationTableNV = cast(PFN_glGetCoverageModulationTableNV)loadSymbol(loader, "glGetCoverageModulationTableNV", []);
        _CoverageModulationNV = cast(PFN_glCoverageModulationNV)loadSymbol(loader, "glCoverageModulationNV", []);

        // GL_NV_framebuffer_multisample_coverage,
        _RenderbufferStorageMultisampleCoverageNV = cast(PFN_glRenderbufferStorageMultisampleCoverageNV)loadSymbol(loader, "glRenderbufferStorageMultisampleCoverageNV", []);

        // GL_NV_gpu_shader5,
        _Uniform1i64NV = cast(PFN_glUniform1i64NV)loadSymbol(loader, "glUniform1i64NV", []);
        _Uniform2i64NV = cast(PFN_glUniform2i64NV)loadSymbol(loader, "glUniform2i64NV", []);
        _Uniform3i64NV = cast(PFN_glUniform3i64NV)loadSymbol(loader, "glUniform3i64NV", []);
        _Uniform4i64NV = cast(PFN_glUniform4i64NV)loadSymbol(loader, "glUniform4i64NV", []);
        _Uniform1i64vNV = cast(PFN_glUniform1i64vNV)loadSymbol(loader, "glUniform1i64vNV", []);
        _Uniform2i64vNV = cast(PFN_glUniform2i64vNV)loadSymbol(loader, "glUniform2i64vNV", []);
        _Uniform3i64vNV = cast(PFN_glUniform3i64vNV)loadSymbol(loader, "glUniform3i64vNV", []);
        _Uniform4i64vNV = cast(PFN_glUniform4i64vNV)loadSymbol(loader, "glUniform4i64vNV", []);
        _Uniform1ui64NV = cast(PFN_glUniform1ui64NV)loadSymbol(loader, "glUniform1ui64NV", []);
        _Uniform2ui64NV = cast(PFN_glUniform2ui64NV)loadSymbol(loader, "glUniform2ui64NV", []);
        _Uniform3ui64NV = cast(PFN_glUniform3ui64NV)loadSymbol(loader, "glUniform3ui64NV", []);
        _Uniform4ui64NV = cast(PFN_glUniform4ui64NV)loadSymbol(loader, "glUniform4ui64NV", []);
        _Uniform1ui64vNV = cast(PFN_glUniform1ui64vNV)loadSymbol(loader, "glUniform1ui64vNV", []);
        _Uniform2ui64vNV = cast(PFN_glUniform2ui64vNV)loadSymbol(loader, "glUniform2ui64vNV", []);
        _Uniform3ui64vNV = cast(PFN_glUniform3ui64vNV)loadSymbol(loader, "glUniform3ui64vNV", []);
        _Uniform4ui64vNV = cast(PFN_glUniform4ui64vNV)loadSymbol(loader, "glUniform4ui64vNV", []);
        _GetUniformi64vNV = cast(PFN_glGetUniformi64vNV)loadSymbol(loader, "glGetUniformi64vNV", []);
        _ProgramUniform1i64NV = cast(PFN_glProgramUniform1i64NV)loadSymbol(loader, "glProgramUniform1i64NV", []);
        _ProgramUniform2i64NV = cast(PFN_glProgramUniform2i64NV)loadSymbol(loader, "glProgramUniform2i64NV", []);
        _ProgramUniform3i64NV = cast(PFN_glProgramUniform3i64NV)loadSymbol(loader, "glProgramUniform3i64NV", []);
        _ProgramUniform4i64NV = cast(PFN_glProgramUniform4i64NV)loadSymbol(loader, "glProgramUniform4i64NV", []);
        _ProgramUniform1i64vNV = cast(PFN_glProgramUniform1i64vNV)loadSymbol(loader, "glProgramUniform1i64vNV", []);
        _ProgramUniform2i64vNV = cast(PFN_glProgramUniform2i64vNV)loadSymbol(loader, "glProgramUniform2i64vNV", []);
        _ProgramUniform3i64vNV = cast(PFN_glProgramUniform3i64vNV)loadSymbol(loader, "glProgramUniform3i64vNV", []);
        _ProgramUniform4i64vNV = cast(PFN_glProgramUniform4i64vNV)loadSymbol(loader, "glProgramUniform4i64vNV", []);
        _ProgramUniform1ui64NV = cast(PFN_glProgramUniform1ui64NV)loadSymbol(loader, "glProgramUniform1ui64NV", []);
        _ProgramUniform2ui64NV = cast(PFN_glProgramUniform2ui64NV)loadSymbol(loader, "glProgramUniform2ui64NV", []);
        _ProgramUniform3ui64NV = cast(PFN_glProgramUniform3ui64NV)loadSymbol(loader, "glProgramUniform3ui64NV", []);
        _ProgramUniform4ui64NV = cast(PFN_glProgramUniform4ui64NV)loadSymbol(loader, "glProgramUniform4ui64NV", []);
        _ProgramUniform1ui64vNV = cast(PFN_glProgramUniform1ui64vNV)loadSymbol(loader, "glProgramUniform1ui64vNV", []);
        _ProgramUniform2ui64vNV = cast(PFN_glProgramUniform2ui64vNV)loadSymbol(loader, "glProgramUniform2ui64vNV", []);
        _ProgramUniform3ui64vNV = cast(PFN_glProgramUniform3ui64vNV)loadSymbol(loader, "glProgramUniform3ui64vNV", []);
        _ProgramUniform4ui64vNV = cast(PFN_glProgramUniform4ui64vNV)loadSymbol(loader, "glProgramUniform4ui64vNV", []);

        // GL_NV_internalformat_sample_query,
        _GetInternalformatSampleivNV = cast(PFN_glGetInternalformatSampleivNV)loadSymbol(loader, "glGetInternalformatSampleivNV", []);

        // GL_NV_path_rendering,
        _GenPathsNV = cast(PFN_glGenPathsNV)loadSymbol(loader, "glGenPathsNV", []);
        _DeletePathsNV = cast(PFN_glDeletePathsNV)loadSymbol(loader, "glDeletePathsNV", []);
        _IsPathNV = cast(PFN_glIsPathNV)loadSymbol(loader, "glIsPathNV", []);
        _PathCommandsNV = cast(PFN_glPathCommandsNV)loadSymbol(loader, "glPathCommandsNV", []);
        _PathCoordsNV = cast(PFN_glPathCoordsNV)loadSymbol(loader, "glPathCoordsNV", []);
        _PathSubCommandsNV = cast(PFN_glPathSubCommandsNV)loadSymbol(loader, "glPathSubCommandsNV", []);
        _PathSubCoordsNV = cast(PFN_glPathSubCoordsNV)loadSymbol(loader, "glPathSubCoordsNV", []);
        _PathStringNV = cast(PFN_glPathStringNV)loadSymbol(loader, "glPathStringNV", []);
        _PathGlyphsNV = cast(PFN_glPathGlyphsNV)loadSymbol(loader, "glPathGlyphsNV", []);
        _PathGlyphRangeNV = cast(PFN_glPathGlyphRangeNV)loadSymbol(loader, "glPathGlyphRangeNV", []);
        _WeightPathsNV = cast(PFN_glWeightPathsNV)loadSymbol(loader, "glWeightPathsNV", []);
        _CopyPathNV = cast(PFN_glCopyPathNV)loadSymbol(loader, "glCopyPathNV", []);
        _InterpolatePathsNV = cast(PFN_glInterpolatePathsNV)loadSymbol(loader, "glInterpolatePathsNV", []);
        _TransformPathNV = cast(PFN_glTransformPathNV)loadSymbol(loader, "glTransformPathNV", []);
        _PathParameterivNV = cast(PFN_glPathParameterivNV)loadSymbol(loader, "glPathParameterivNV", []);
        _PathParameteriNV = cast(PFN_glPathParameteriNV)loadSymbol(loader, "glPathParameteriNV", []);
        _PathParameterfvNV = cast(PFN_glPathParameterfvNV)loadSymbol(loader, "glPathParameterfvNV", []);
        _PathParameterfNV = cast(PFN_glPathParameterfNV)loadSymbol(loader, "glPathParameterfNV", []);
        _PathDashArrayNV = cast(PFN_glPathDashArrayNV)loadSymbol(loader, "glPathDashArrayNV", []);
        _PathStencilFuncNV = cast(PFN_glPathStencilFuncNV)loadSymbol(loader, "glPathStencilFuncNV", []);
        _PathStencilDepthOffsetNV = cast(PFN_glPathStencilDepthOffsetNV)loadSymbol(loader, "glPathStencilDepthOffsetNV", []);
        _StencilFillPathNV = cast(PFN_glStencilFillPathNV)loadSymbol(loader, "glStencilFillPathNV", []);
        _StencilStrokePathNV = cast(PFN_glStencilStrokePathNV)loadSymbol(loader, "glStencilStrokePathNV", []);
        _StencilFillPathInstancedNV = cast(PFN_glStencilFillPathInstancedNV)loadSymbol(loader, "glStencilFillPathInstancedNV", []);
        _StencilStrokePathInstancedNV = cast(PFN_glStencilStrokePathInstancedNV)loadSymbol(loader, "glStencilStrokePathInstancedNV", []);
        _PathCoverDepthFuncNV = cast(PFN_glPathCoverDepthFuncNV)loadSymbol(loader, "glPathCoverDepthFuncNV", []);
        _CoverFillPathNV = cast(PFN_glCoverFillPathNV)loadSymbol(loader, "glCoverFillPathNV", []);
        _CoverStrokePathNV = cast(PFN_glCoverStrokePathNV)loadSymbol(loader, "glCoverStrokePathNV", []);
        _CoverFillPathInstancedNV = cast(PFN_glCoverFillPathInstancedNV)loadSymbol(loader, "glCoverFillPathInstancedNV", []);
        _CoverStrokePathInstancedNV = cast(PFN_glCoverStrokePathInstancedNV)loadSymbol(loader, "glCoverStrokePathInstancedNV", []);
        _GetPathParameterivNV = cast(PFN_glGetPathParameterivNV)loadSymbol(loader, "glGetPathParameterivNV", []);
        _GetPathParameterfvNV = cast(PFN_glGetPathParameterfvNV)loadSymbol(loader, "glGetPathParameterfvNV", []);
        _GetPathCommandsNV = cast(PFN_glGetPathCommandsNV)loadSymbol(loader, "glGetPathCommandsNV", []);
        _GetPathCoordsNV = cast(PFN_glGetPathCoordsNV)loadSymbol(loader, "glGetPathCoordsNV", []);
        _GetPathDashArrayNV = cast(PFN_glGetPathDashArrayNV)loadSymbol(loader, "glGetPathDashArrayNV", []);
        _GetPathMetricsNV = cast(PFN_glGetPathMetricsNV)loadSymbol(loader, "glGetPathMetricsNV", []);
        _GetPathMetricRangeNV = cast(PFN_glGetPathMetricRangeNV)loadSymbol(loader, "glGetPathMetricRangeNV", []);
        _GetPathSpacingNV = cast(PFN_glGetPathSpacingNV)loadSymbol(loader, "glGetPathSpacingNV", []);
        _IsPointInFillPathNV = cast(PFN_glIsPointInFillPathNV)loadSymbol(loader, "glIsPointInFillPathNV", []);
        _IsPointInStrokePathNV = cast(PFN_glIsPointInStrokePathNV)loadSymbol(loader, "glIsPointInStrokePathNV", []);
        _GetPathLengthNV = cast(PFN_glGetPathLengthNV)loadSymbol(loader, "glGetPathLengthNV", []);
        _PointAlongPathNV = cast(PFN_glPointAlongPathNV)loadSymbol(loader, "glPointAlongPathNV", []);
        _MatrixLoad3x2fNV = cast(PFN_glMatrixLoad3x2fNV)loadSymbol(loader, "glMatrixLoad3x2fNV", []);
        _MatrixLoad3x3fNV = cast(PFN_glMatrixLoad3x3fNV)loadSymbol(loader, "glMatrixLoad3x3fNV", []);
        _MatrixLoadTranspose3x3fNV = cast(PFN_glMatrixLoadTranspose3x3fNV)loadSymbol(loader, "glMatrixLoadTranspose3x3fNV", []);
        _MatrixMult3x2fNV = cast(PFN_glMatrixMult3x2fNV)loadSymbol(loader, "glMatrixMult3x2fNV", []);
        _MatrixMult3x3fNV = cast(PFN_glMatrixMult3x3fNV)loadSymbol(loader, "glMatrixMult3x3fNV", []);
        _MatrixMultTranspose3x3fNV = cast(PFN_glMatrixMultTranspose3x3fNV)loadSymbol(loader, "glMatrixMultTranspose3x3fNV", []);
        _StencilThenCoverFillPathNV = cast(PFN_glStencilThenCoverFillPathNV)loadSymbol(loader, "glStencilThenCoverFillPathNV", []);
        _StencilThenCoverStrokePathNV = cast(PFN_glStencilThenCoverStrokePathNV)loadSymbol(loader, "glStencilThenCoverStrokePathNV", []);
        _StencilThenCoverFillPathInstancedNV = cast(PFN_glStencilThenCoverFillPathInstancedNV)loadSymbol(loader, "glStencilThenCoverFillPathInstancedNV", []);
        _StencilThenCoverStrokePathInstancedNV = cast(PFN_glStencilThenCoverStrokePathInstancedNV)loadSymbol(loader, "glStencilThenCoverStrokePathInstancedNV", []);
        _PathGlyphIndexRangeNV = cast(PFN_glPathGlyphIndexRangeNV)loadSymbol(loader, "glPathGlyphIndexRangeNV", []);
        _PathGlyphIndexArrayNV = cast(PFN_glPathGlyphIndexArrayNV)loadSymbol(loader, "glPathGlyphIndexArrayNV", []);
        _PathMemoryGlyphIndexArrayNV = cast(PFN_glPathMemoryGlyphIndexArrayNV)loadSymbol(loader, "glPathMemoryGlyphIndexArrayNV", []);
        _ProgramPathFragmentInputGenNV = cast(PFN_glProgramPathFragmentInputGenNV)loadSymbol(loader, "glProgramPathFragmentInputGenNV", []);
        _GetProgramResourcefvNV = cast(PFN_glGetProgramResourcefvNV)loadSymbol(loader, "glGetProgramResourcefvNV", []);

        // GL_NV_sample_locations,
        _FramebufferSampleLocationsfvNV = cast(PFN_glFramebufferSampleLocationsfvNV)loadSymbol(loader, "glFramebufferSampleLocationsfvNV", []);
        _NamedFramebufferSampleLocationsfvNV = cast(PFN_glNamedFramebufferSampleLocationsfvNV)loadSymbol(loader, "glNamedFramebufferSampleLocationsfvNV", []);
        _ResolveDepthValuesNV = cast(PFN_glResolveDepthValuesNV)loadSymbol(loader, "glResolveDepthValuesNV", []);

        // GL_NV_shader_buffer_load,
        _MakeBufferResidentNV = cast(PFN_glMakeBufferResidentNV)loadSymbol(loader, "glMakeBufferResidentNV", []);
        _MakeBufferNonResidentNV = cast(PFN_glMakeBufferNonResidentNV)loadSymbol(loader, "glMakeBufferNonResidentNV", []);
        _IsBufferResidentNV = cast(PFN_glIsBufferResidentNV)loadSymbol(loader, "glIsBufferResidentNV", []);
        _MakeNamedBufferResidentNV = cast(PFN_glMakeNamedBufferResidentNV)loadSymbol(loader, "glMakeNamedBufferResidentNV", []);
        _MakeNamedBufferNonResidentNV = cast(PFN_glMakeNamedBufferNonResidentNV)loadSymbol(loader, "glMakeNamedBufferNonResidentNV", []);
        _IsNamedBufferResidentNV = cast(PFN_glIsNamedBufferResidentNV)loadSymbol(loader, "glIsNamedBufferResidentNV", []);
        _GetBufferParameterui64vNV = cast(PFN_glGetBufferParameterui64vNV)loadSymbol(loader, "glGetBufferParameterui64vNV", []);
        _GetNamedBufferParameterui64vNV = cast(PFN_glGetNamedBufferParameterui64vNV)loadSymbol(loader, "glGetNamedBufferParameterui64vNV", []);
        _GetIntegerui64vNV = cast(PFN_glGetIntegerui64vNV)loadSymbol(loader, "glGetIntegerui64vNV", []);
        _Uniformui64NV = cast(PFN_glUniformui64NV)loadSymbol(loader, "glUniformui64NV", []);
        _Uniformui64vNV = cast(PFN_glUniformui64vNV)loadSymbol(loader, "glUniformui64vNV", []);
        _GetUniformui64vNV = cast(PFN_glGetUniformui64vNV)loadSymbol(loader, "glGetUniformui64vNV", []);
        _ProgramUniformui64NV = cast(PFN_glProgramUniformui64NV)loadSymbol(loader, "glProgramUniformui64NV", []);
        _ProgramUniformui64vNV = cast(PFN_glProgramUniformui64vNV)loadSymbol(loader, "glProgramUniformui64vNV", []);

        // GL_NV_texture_barrier,
        _TextureBarrierNV = cast(PFN_glTextureBarrierNV)loadSymbol(loader, "glTextureBarrierNV", []);

        // GL_NV_vertex_attrib_integer_64bit,
        _VertexAttribL1i64NV = cast(PFN_glVertexAttribL1i64NV)loadSymbol(loader, "glVertexAttribL1i64NV", []);
        _VertexAttribL2i64NV = cast(PFN_glVertexAttribL2i64NV)loadSymbol(loader, "glVertexAttribL2i64NV", []);
        _VertexAttribL3i64NV = cast(PFN_glVertexAttribL3i64NV)loadSymbol(loader, "glVertexAttribL3i64NV", []);
        _VertexAttribL4i64NV = cast(PFN_glVertexAttribL4i64NV)loadSymbol(loader, "glVertexAttribL4i64NV", []);
        _VertexAttribL1i64vNV = cast(PFN_glVertexAttribL1i64vNV)loadSymbol(loader, "glVertexAttribL1i64vNV", []);
        _VertexAttribL2i64vNV = cast(PFN_glVertexAttribL2i64vNV)loadSymbol(loader, "glVertexAttribL2i64vNV", []);
        _VertexAttribL3i64vNV = cast(PFN_glVertexAttribL3i64vNV)loadSymbol(loader, "glVertexAttribL3i64vNV", []);
        _VertexAttribL4i64vNV = cast(PFN_glVertexAttribL4i64vNV)loadSymbol(loader, "glVertexAttribL4i64vNV", []);
        _VertexAttribL1ui64NV = cast(PFN_glVertexAttribL1ui64NV)loadSymbol(loader, "glVertexAttribL1ui64NV", []);
        _VertexAttribL2ui64NV = cast(PFN_glVertexAttribL2ui64NV)loadSymbol(loader, "glVertexAttribL2ui64NV", []);
        _VertexAttribL3ui64NV = cast(PFN_glVertexAttribL3ui64NV)loadSymbol(loader, "glVertexAttribL3ui64NV", []);
        _VertexAttribL4ui64NV = cast(PFN_glVertexAttribL4ui64NV)loadSymbol(loader, "glVertexAttribL4ui64NV", []);
        _VertexAttribL1ui64vNV = cast(PFN_glVertexAttribL1ui64vNV)loadSymbol(loader, "glVertexAttribL1ui64vNV", []);
        _VertexAttribL2ui64vNV = cast(PFN_glVertexAttribL2ui64vNV)loadSymbol(loader, "glVertexAttribL2ui64vNV", []);
        _VertexAttribL3ui64vNV = cast(PFN_glVertexAttribL3ui64vNV)loadSymbol(loader, "glVertexAttribL3ui64vNV", []);
        _VertexAttribL4ui64vNV = cast(PFN_glVertexAttribL4ui64vNV)loadSymbol(loader, "glVertexAttribL4ui64vNV", []);
        _GetVertexAttribLi64vNV = cast(PFN_glGetVertexAttribLi64vNV)loadSymbol(loader, "glGetVertexAttribLi64vNV", []);
        _GetVertexAttribLui64vNV = cast(PFN_glGetVertexAttribLui64vNV)loadSymbol(loader, "glGetVertexAttribLui64vNV", []);
        _VertexAttribLFormatNV = cast(PFN_glVertexAttribLFormatNV)loadSymbol(loader, "glVertexAttribLFormatNV", []);

        // GL_NV_vertex_buffer_unified_memory,
        _BufferAddressRangeNV = cast(PFN_glBufferAddressRangeNV)loadSymbol(loader, "glBufferAddressRangeNV", []);
        _VertexFormatNV = cast(PFN_glVertexFormatNV)loadSymbol(loader, "glVertexFormatNV", []);
        _NormalFormatNV = cast(PFN_glNormalFormatNV)loadSymbol(loader, "glNormalFormatNV", []);
        _ColorFormatNV = cast(PFN_glColorFormatNV)loadSymbol(loader, "glColorFormatNV", []);
        _IndexFormatNV = cast(PFN_glIndexFormatNV)loadSymbol(loader, "glIndexFormatNV", []);
        _TexCoordFormatNV = cast(PFN_glTexCoordFormatNV)loadSymbol(loader, "glTexCoordFormatNV", []);
        _EdgeFlagFormatNV = cast(PFN_glEdgeFlagFormatNV)loadSymbol(loader, "glEdgeFlagFormatNV", []);
        _SecondaryColorFormatNV = cast(PFN_glSecondaryColorFormatNV)loadSymbol(loader, "glSecondaryColorFormatNV", []);
        _FogCoordFormatNV = cast(PFN_glFogCoordFormatNV)loadSymbol(loader, "glFogCoordFormatNV", []);
        _VertexAttribFormatNV = cast(PFN_glVertexAttribFormatNV)loadSymbol(loader, "glVertexAttribFormatNV", []);
        _VertexAttribIFormatNV = cast(PFN_glVertexAttribIFormatNV)loadSymbol(loader, "glVertexAttribIFormatNV", []);
        _GetIntegerui64i_vNV = cast(PFN_glGetIntegerui64i_vNV)loadSymbol(loader, "glGetIntegerui64i_vNV", []);

        // GL_NV_viewport_swizzle,
        _ViewportSwizzleNV = cast(PFN_glViewportSwizzleNV)loadSymbol(loader, "glViewportSwizzleNV", []);

        // GL_OVR_multiview,
        _FramebufferTextureMultiviewOVR = cast(PFN_glFramebufferTextureMultiviewOVR)loadSymbol(loader, "glFramebufferTextureMultiviewOVR", []);
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

    /// Commands for GL_VERSION_1_0
    public void CullFace (GLenum mode) const {
        assert(_CullFace !is null, "OpenGL command glCullFace was not loaded");
        return _CullFace (mode);
    }
    /// ditto
    public void FrontFace (GLenum mode) const {
        assert(_FrontFace !is null, "OpenGL command glFrontFace was not loaded");
        return _FrontFace (mode);
    }
    /// ditto
    public void Hint (GLenum target, GLenum mode) const {
        assert(_Hint !is null, "OpenGL command glHint was not loaded");
        return _Hint (target, mode);
    }
    /// ditto
    public void LineWidth (GLfloat width) const {
        assert(_LineWidth !is null, "OpenGL command glLineWidth was not loaded");
        return _LineWidth (width);
    }
    /// ditto
    public void PointSize (GLfloat size) const {
        assert(_PointSize !is null, "OpenGL command glPointSize was not loaded");
        return _PointSize (size);
    }
    /// ditto
    public void PolygonMode (GLenum face, GLenum mode) const {
        assert(_PolygonMode !is null, "OpenGL command glPolygonMode was not loaded");
        return _PolygonMode (face, mode);
    }
    /// ditto
    public void Scissor (GLint x, GLint y, GLsizei width, GLsizei height) const {
        assert(_Scissor !is null, "OpenGL command glScissor was not loaded");
        return _Scissor (x, y, width, height);
    }
    /// ditto
    public void TexParameterf (GLenum target, GLenum pname, GLfloat param) const {
        assert(_TexParameterf !is null, "OpenGL command glTexParameterf was not loaded");
        return _TexParameterf (target, pname, param);
    }
    /// ditto
    public void TexParameterfv (GLenum target, GLenum pname, const(GLfloat)* params) const {
        assert(_TexParameterfv !is null, "OpenGL command glTexParameterfv was not loaded");
        return _TexParameterfv (target, pname, params);
    }
    /// ditto
    public void TexParameteri (GLenum target, GLenum pname, GLint param) const {
        assert(_TexParameteri !is null, "OpenGL command glTexParameteri was not loaded");
        return _TexParameteri (target, pname, param);
    }
    /// ditto
    public void TexParameteriv (GLenum target, GLenum pname, const(GLint)* params) const {
        assert(_TexParameteriv !is null, "OpenGL command glTexParameteriv was not loaded");
        return _TexParameteriv (target, pname, params);
    }
    /// ditto
    public void TexImage1D (GLenum target, GLint level, GLint internalformat, GLsizei width, GLint border, GLenum format, GLenum type, const(void)* pixels) const {
        assert(_TexImage1D !is null, "OpenGL command glTexImage1D was not loaded");
        return _TexImage1D (target, level, internalformat, width, border, format, type, pixels);
    }
    /// ditto
    public void TexImage2D (GLenum target, GLint level, GLint internalformat, GLsizei width, GLsizei height, GLint border, GLenum format, GLenum type, const(void)* pixels) const {
        assert(_TexImage2D !is null, "OpenGL command glTexImage2D was not loaded");
        return _TexImage2D (target, level, internalformat, width, height, border, format, type, pixels);
    }
    /// ditto
    public void DrawBuffer (GLenum buf) const {
        assert(_DrawBuffer !is null, "OpenGL command glDrawBuffer was not loaded");
        return _DrawBuffer (buf);
    }
    /// ditto
    public void Clear (GLbitfield mask) const {
        assert(_Clear !is null, "OpenGL command glClear was not loaded");
        return _Clear (mask);
    }
    /// ditto
    public void ClearColor (GLfloat red, GLfloat green, GLfloat blue, GLfloat alpha) const {
        assert(_ClearColor !is null, "OpenGL command glClearColor was not loaded");
        return _ClearColor (red, green, blue, alpha);
    }
    /// ditto
    public void ClearStencil (GLint s) const {
        assert(_ClearStencil !is null, "OpenGL command glClearStencil was not loaded");
        return _ClearStencil (s);
    }
    /// ditto
    public void ClearDepth (GLdouble depth) const {
        assert(_ClearDepth !is null, "OpenGL command glClearDepth was not loaded");
        return _ClearDepth (depth);
    }
    /// ditto
    public void StencilMask (GLuint mask) const {
        assert(_StencilMask !is null, "OpenGL command glStencilMask was not loaded");
        return _StencilMask (mask);
    }
    /// ditto
    public void ColorMask (GLboolean red, GLboolean green, GLboolean blue, GLboolean alpha) const {
        assert(_ColorMask !is null, "OpenGL command glColorMask was not loaded");
        return _ColorMask (red, green, blue, alpha);
    }
    /// ditto
    public void DepthMask (GLboolean flag) const {
        assert(_DepthMask !is null, "OpenGL command glDepthMask was not loaded");
        return _DepthMask (flag);
    }
    /// ditto
    public void Disable (GLenum cap) const {
        assert(_Disable !is null, "OpenGL command glDisable was not loaded");
        return _Disable (cap);
    }
    /// ditto
    public void Enable (GLenum cap) const {
        assert(_Enable !is null, "OpenGL command glEnable was not loaded");
        return _Enable (cap);
    }
    /// ditto
    public void Finish () const {
        assert(_Finish !is null, "OpenGL command glFinish was not loaded");
        return _Finish ();
    }
    /// ditto
    public void Flush () const {
        assert(_Flush !is null, "OpenGL command glFlush was not loaded");
        return _Flush ();
    }
    /// ditto
    public void BlendFunc (GLenum sfactor, GLenum dfactor) const {
        assert(_BlendFunc !is null, "OpenGL command glBlendFunc was not loaded");
        return _BlendFunc (sfactor, dfactor);
    }
    /// ditto
    public void LogicOp (GLenum opcode) const {
        assert(_LogicOp !is null, "OpenGL command glLogicOp was not loaded");
        return _LogicOp (opcode);
    }
    /// ditto
    public void StencilFunc (GLenum func, GLint ref_, GLuint mask) const {
        assert(_StencilFunc !is null, "OpenGL command glStencilFunc was not loaded");
        return _StencilFunc (func, ref_, mask);
    }
    /// ditto
    public void StencilOp (GLenum fail, GLenum zfail, GLenum zpass) const {
        assert(_StencilOp !is null, "OpenGL command glStencilOp was not loaded");
        return _StencilOp (fail, zfail, zpass);
    }
    /// ditto
    public void DepthFunc (GLenum func) const {
        assert(_DepthFunc !is null, "OpenGL command glDepthFunc was not loaded");
        return _DepthFunc (func);
    }
    /// ditto
    public void PixelStoref (GLenum pname, GLfloat param) const {
        assert(_PixelStoref !is null, "OpenGL command glPixelStoref was not loaded");
        return _PixelStoref (pname, param);
    }
    /// ditto
    public void PixelStorei (GLenum pname, GLint param) const {
        assert(_PixelStorei !is null, "OpenGL command glPixelStorei was not loaded");
        return _PixelStorei (pname, param);
    }
    /// ditto
    public void ReadBuffer (GLenum src) const {
        assert(_ReadBuffer !is null, "OpenGL command glReadBuffer was not loaded");
        return _ReadBuffer (src);
    }
    /// ditto
    public void ReadPixels (GLint x, GLint y, GLsizei width, GLsizei height, GLenum format, GLenum type, void* pixels) const {
        assert(_ReadPixels !is null, "OpenGL command glReadPixels was not loaded");
        return _ReadPixels (x, y, width, height, format, type, pixels);
    }
    /// ditto
    public void GetBooleanv (GLenum pname, GLboolean* data) const {
        assert(_GetBooleanv !is null, "OpenGL command glGetBooleanv was not loaded");
        return _GetBooleanv (pname, data);
    }
    /// ditto
    public void GetDoublev (GLenum pname, GLdouble* data) const {
        assert(_GetDoublev !is null, "OpenGL command glGetDoublev was not loaded");
        return _GetDoublev (pname, data);
    }
    /// ditto
    public GLenum GetError () const {
        assert(_GetError !is null, "OpenGL command glGetError was not loaded");
        return _GetError ();
    }
    /// ditto
    public void GetFloatv (GLenum pname, GLfloat* data) const {
        assert(_GetFloatv !is null, "OpenGL command glGetFloatv was not loaded");
        return _GetFloatv (pname, data);
    }
    /// ditto
    public void GetIntegerv (GLenum pname, GLint* data) const {
        assert(_GetIntegerv !is null, "OpenGL command glGetIntegerv was not loaded");
        return _GetIntegerv (pname, data);
    }
    /// ditto
    public const(GLubyte)* GetString (GLenum name) const {
        assert(_GetString !is null, "OpenGL command glGetString was not loaded");
        return _GetString (name);
    }
    /// ditto
    public void GetTexImage (GLenum target, GLint level, GLenum format, GLenum type, void* pixels) const {
        assert(_GetTexImage !is null, "OpenGL command glGetTexImage was not loaded");
        return _GetTexImage (target, level, format, type, pixels);
    }
    /// ditto
    public void GetTexParameterfv (GLenum target, GLenum pname, GLfloat* params) const {
        assert(_GetTexParameterfv !is null, "OpenGL command glGetTexParameterfv was not loaded");
        return _GetTexParameterfv (target, pname, params);
    }
    /// ditto
    public void GetTexParameteriv (GLenum target, GLenum pname, GLint* params) const {
        assert(_GetTexParameteriv !is null, "OpenGL command glGetTexParameteriv was not loaded");
        return _GetTexParameteriv (target, pname, params);
    }
    /// ditto
    public void GetTexLevelParameterfv (GLenum target, GLint level, GLenum pname, GLfloat* params) const {
        assert(_GetTexLevelParameterfv !is null, "OpenGL command glGetTexLevelParameterfv was not loaded");
        return _GetTexLevelParameterfv (target, level, pname, params);
    }
    /// ditto
    public void GetTexLevelParameteriv (GLenum target, GLint level, GLenum pname, GLint* params) const {
        assert(_GetTexLevelParameteriv !is null, "OpenGL command glGetTexLevelParameteriv was not loaded");
        return _GetTexLevelParameteriv (target, level, pname, params);
    }
    /// ditto
    public GLboolean IsEnabled (GLenum cap) const {
        assert(_IsEnabled !is null, "OpenGL command glIsEnabled was not loaded");
        return _IsEnabled (cap);
    }
    /// ditto
    public void DepthRange (GLdouble near, GLdouble far) const {
        assert(_DepthRange !is null, "OpenGL command glDepthRange was not loaded");
        return _DepthRange (near, far);
    }
    /// ditto
    public void Viewport (GLint x, GLint y, GLsizei width, GLsizei height) const {
        assert(_Viewport !is null, "OpenGL command glViewport was not loaded");
        return _Viewport (x, y, width, height);
    }

    /// Commands for GL_VERSION_1_1
    public void DrawArrays (GLenum mode, GLint first, GLsizei count) const {
        assert(_DrawArrays !is null, "OpenGL command glDrawArrays was not loaded");
        return _DrawArrays (mode, first, count);
    }
    /// ditto
    public void DrawElements (GLenum mode, GLsizei count, GLenum type, const(void)* indices) const {
        assert(_DrawElements !is null, "OpenGL command glDrawElements was not loaded");
        return _DrawElements (mode, count, type, indices);
    }
    /// ditto
    public void GetPointerv (GLenum pname, void** params) const {
        assert(_GetPointerv !is null, "OpenGL command glGetPointerv was not loaded");
        return _GetPointerv (pname, params);
    }
    /// ditto
    public void PolygonOffset (GLfloat factor, GLfloat units) const {
        assert(_PolygonOffset !is null, "OpenGL command glPolygonOffset was not loaded");
        return _PolygonOffset (factor, units);
    }
    /// ditto
    public void CopyTexImage1D (GLenum target, GLint level, GLenum internalformat, GLint x, GLint y, GLsizei width, GLint border) const {
        assert(_CopyTexImage1D !is null, "OpenGL command glCopyTexImage1D was not loaded");
        return _CopyTexImage1D (target, level, internalformat, x, y, width, border);
    }
    /// ditto
    public void CopyTexImage2D (GLenum target, GLint level, GLenum internalformat, GLint x, GLint y, GLsizei width, GLsizei height, GLint border) const {
        assert(_CopyTexImage2D !is null, "OpenGL command glCopyTexImage2D was not loaded");
        return _CopyTexImage2D (target, level, internalformat, x, y, width, height, border);
    }
    /// ditto
    public void CopyTexSubImage1D (GLenum target, GLint level, GLint xoffset, GLint x, GLint y, GLsizei width) const {
        assert(_CopyTexSubImage1D !is null, "OpenGL command glCopyTexSubImage1D was not loaded");
        return _CopyTexSubImage1D (target, level, xoffset, x, y, width);
    }
    /// ditto
    public void CopyTexSubImage2D (GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint x, GLint y, GLsizei width, GLsizei height) const {
        assert(_CopyTexSubImage2D !is null, "OpenGL command glCopyTexSubImage2D was not loaded");
        return _CopyTexSubImage2D (target, level, xoffset, yoffset, x, y, width, height);
    }
    /// ditto
    public void TexSubImage1D (GLenum target, GLint level, GLint xoffset, GLsizei width, GLenum format, GLenum type, const(void)* pixels) const {
        assert(_TexSubImage1D !is null, "OpenGL command glTexSubImage1D was not loaded");
        return _TexSubImage1D (target, level, xoffset, width, format, type, pixels);
    }
    /// ditto
    public void TexSubImage2D (GLenum target, GLint level, GLint xoffset, GLint yoffset, GLsizei width, GLsizei height, GLenum format, GLenum type, const(void)* pixels) const {
        assert(_TexSubImage2D !is null, "OpenGL command glTexSubImage2D was not loaded");
        return _TexSubImage2D (target, level, xoffset, yoffset, width, height, format, type, pixels);
    }
    /// ditto
    public void BindTexture (GLenum target, GLuint texture) const {
        assert(_BindTexture !is null, "OpenGL command glBindTexture was not loaded");
        return _BindTexture (target, texture);
    }
    /// ditto
    public void DeleteTextures (GLsizei n, const(GLuint)* textures) const {
        assert(_DeleteTextures !is null, "OpenGL command glDeleteTextures was not loaded");
        return _DeleteTextures (n, textures);
    }
    /// ditto
    public void GenTextures (GLsizei n, GLuint* textures) const {
        assert(_GenTextures !is null, "OpenGL command glGenTextures was not loaded");
        return _GenTextures (n, textures);
    }
    /// ditto
    public GLboolean IsTexture (GLuint texture) const {
        assert(_IsTexture !is null, "OpenGL command glIsTexture was not loaded");
        return _IsTexture (texture);
    }

    /// Commands for GL_VERSION_1_2
    public void DrawRangeElements (GLenum mode, GLuint start, GLuint end, GLsizei count, GLenum type, const(void)* indices) const {
        assert(_DrawRangeElements !is null, "OpenGL command glDrawRangeElements was not loaded");
        return _DrawRangeElements (mode, start, end, count, type, indices);
    }
    /// ditto
    public void TexImage3D (GLenum target, GLint level, GLint internalformat, GLsizei width, GLsizei height, GLsizei depth, GLint border, GLenum format, GLenum type, const(void)* pixels) const {
        assert(_TexImage3D !is null, "OpenGL command glTexImage3D was not loaded");
        return _TexImage3D (target, level, internalformat, width, height, depth, border, format, type, pixels);
    }
    /// ditto
    public void TexSubImage3D (GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint zoffset, GLsizei width, GLsizei height, GLsizei depth, GLenum format, GLenum type, const(void)* pixels) const {
        assert(_TexSubImage3D !is null, "OpenGL command glTexSubImage3D was not loaded");
        return _TexSubImage3D (target, level, xoffset, yoffset, zoffset, width, height, depth, format, type, pixels);
    }
    /// ditto
    public void CopyTexSubImage3D (GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint zoffset, GLint x, GLint y, GLsizei width, GLsizei height) const {
        assert(_CopyTexSubImage3D !is null, "OpenGL command glCopyTexSubImage3D was not loaded");
        return _CopyTexSubImage3D (target, level, xoffset, yoffset, zoffset, x, y, width, height);
    }

    /// Commands for GL_VERSION_1_3
    public void ActiveTexture (GLenum texture) const {
        assert(_ActiveTexture !is null, "OpenGL command glActiveTexture was not loaded");
        return _ActiveTexture (texture);
    }
    /// ditto
    public void SampleCoverage (GLfloat value, GLboolean invert) const {
        assert(_SampleCoverage !is null, "OpenGL command glSampleCoverage was not loaded");
        return _SampleCoverage (value, invert);
    }
    /// ditto
    public void CompressedTexImage3D (GLenum target, GLint level, GLenum internalformat, GLsizei width, GLsizei height, GLsizei depth, GLint border, GLsizei imageSize, const(void)* data) const {
        assert(_CompressedTexImage3D !is null, "OpenGL command glCompressedTexImage3D was not loaded");
        return _CompressedTexImage3D (target, level, internalformat, width, height, depth, border, imageSize, data);
    }
    /// ditto
    public void CompressedTexImage2D (GLenum target, GLint level, GLenum internalformat, GLsizei width, GLsizei height, GLint border, GLsizei imageSize, const(void)* data) const {
        assert(_CompressedTexImage2D !is null, "OpenGL command glCompressedTexImage2D was not loaded");
        return _CompressedTexImage2D (target, level, internalformat, width, height, border, imageSize, data);
    }
    /// ditto
    public void CompressedTexImage1D (GLenum target, GLint level, GLenum internalformat, GLsizei width, GLint border, GLsizei imageSize, const(void)* data) const {
        assert(_CompressedTexImage1D !is null, "OpenGL command glCompressedTexImage1D was not loaded");
        return _CompressedTexImage1D (target, level, internalformat, width, border, imageSize, data);
    }
    /// ditto
    public void CompressedTexSubImage3D (GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint zoffset, GLsizei width, GLsizei height, GLsizei depth, GLenum format, GLsizei imageSize, const(void)* data) const {
        assert(_CompressedTexSubImage3D !is null, "OpenGL command glCompressedTexSubImage3D was not loaded");
        return _CompressedTexSubImage3D (target, level, xoffset, yoffset, zoffset, width, height, depth, format, imageSize, data);
    }
    /// ditto
    public void CompressedTexSubImage2D (GLenum target, GLint level, GLint xoffset, GLint yoffset, GLsizei width, GLsizei height, GLenum format, GLsizei imageSize, const(void)* data) const {
        assert(_CompressedTexSubImage2D !is null, "OpenGL command glCompressedTexSubImage2D was not loaded");
        return _CompressedTexSubImage2D (target, level, xoffset, yoffset, width, height, format, imageSize, data);
    }
    /// ditto
    public void CompressedTexSubImage1D (GLenum target, GLint level, GLint xoffset, GLsizei width, GLenum format, GLsizei imageSize, const(void)* data) const {
        assert(_CompressedTexSubImage1D !is null, "OpenGL command glCompressedTexSubImage1D was not loaded");
        return _CompressedTexSubImage1D (target, level, xoffset, width, format, imageSize, data);
    }
    /// ditto
    public void GetCompressedTexImage (GLenum target, GLint level, void* img) const {
        assert(_GetCompressedTexImage !is null, "OpenGL command glGetCompressedTexImage was not loaded");
        return _GetCompressedTexImage (target, level, img);
    }

    /// Commands for GL_VERSION_1_4
    public void BlendFuncSeparate (GLenum sfactorRGB, GLenum dfactorRGB, GLenum sfactorAlpha, GLenum dfactorAlpha) const {
        assert(_BlendFuncSeparate !is null, "OpenGL command glBlendFuncSeparate was not loaded");
        return _BlendFuncSeparate (sfactorRGB, dfactorRGB, sfactorAlpha, dfactorAlpha);
    }
    /// ditto
    public void MultiDrawArrays (GLenum mode, const(GLint)* first, const(GLsizei)* count, GLsizei drawcount) const {
        assert(_MultiDrawArrays !is null, "OpenGL command glMultiDrawArrays was not loaded");
        return _MultiDrawArrays (mode, first, count, drawcount);
    }
    /// ditto
    public void MultiDrawElements (GLenum mode, const(GLsizei)* count, GLenum type, const(void*)* indices, GLsizei drawcount) const {
        assert(_MultiDrawElements !is null, "OpenGL command glMultiDrawElements was not loaded");
        return _MultiDrawElements (mode, count, type, indices, drawcount);
    }
    /// ditto
    public void PointParameterf (GLenum pname, GLfloat param) const {
        assert(_PointParameterf !is null, "OpenGL command glPointParameterf was not loaded");
        return _PointParameterf (pname, param);
    }
    /// ditto
    public void PointParameterfv (GLenum pname, const(GLfloat)* params) const {
        assert(_PointParameterfv !is null, "OpenGL command glPointParameterfv was not loaded");
        return _PointParameterfv (pname, params);
    }
    /// ditto
    public void PointParameteri (GLenum pname, GLint param) const {
        assert(_PointParameteri !is null, "OpenGL command glPointParameteri was not loaded");
        return _PointParameteri (pname, param);
    }
    /// ditto
    public void PointParameteriv (GLenum pname, const(GLint)* params) const {
        assert(_PointParameteriv !is null, "OpenGL command glPointParameteriv was not loaded");
        return _PointParameteriv (pname, params);
    }
    /// ditto
    public void BlendColor (GLfloat red, GLfloat green, GLfloat blue, GLfloat alpha) const {
        assert(_BlendColor !is null, "OpenGL command glBlendColor was not loaded");
        return _BlendColor (red, green, blue, alpha);
    }
    /// ditto
    public void BlendEquation (GLenum mode) const {
        assert(_BlendEquation !is null, "OpenGL command glBlendEquation was not loaded");
        return _BlendEquation (mode);
    }

    /// Commands for GL_VERSION_1_5
    public void GenQueries (GLsizei n, GLuint* ids) const {
        assert(_GenQueries !is null, "OpenGL command glGenQueries was not loaded");
        return _GenQueries (n, ids);
    }
    /// ditto
    public void DeleteQueries (GLsizei n, const(GLuint)* ids) const {
        assert(_DeleteQueries !is null, "OpenGL command glDeleteQueries was not loaded");
        return _DeleteQueries (n, ids);
    }
    /// ditto
    public GLboolean IsQuery (GLuint id) const {
        assert(_IsQuery !is null, "OpenGL command glIsQuery was not loaded");
        return _IsQuery (id);
    }
    /// ditto
    public void BeginQuery (GLenum target, GLuint id) const {
        assert(_BeginQuery !is null, "OpenGL command glBeginQuery was not loaded");
        return _BeginQuery (target, id);
    }
    /// ditto
    public void EndQuery (GLenum target) const {
        assert(_EndQuery !is null, "OpenGL command glEndQuery was not loaded");
        return _EndQuery (target);
    }
    /// ditto
    public void GetQueryiv (GLenum target, GLenum pname, GLint* params) const {
        assert(_GetQueryiv !is null, "OpenGL command glGetQueryiv was not loaded");
        return _GetQueryiv (target, pname, params);
    }
    /// ditto
    public void GetQueryObjectiv (GLuint id, GLenum pname, GLint* params) const {
        assert(_GetQueryObjectiv !is null, "OpenGL command glGetQueryObjectiv was not loaded");
        return _GetQueryObjectiv (id, pname, params);
    }
    /// ditto
    public void GetQueryObjectuiv (GLuint id, GLenum pname, GLuint* params) const {
        assert(_GetQueryObjectuiv !is null, "OpenGL command glGetQueryObjectuiv was not loaded");
        return _GetQueryObjectuiv (id, pname, params);
    }
    /// ditto
    public void BindBuffer (GLenum target, GLuint buffer) const {
        assert(_BindBuffer !is null, "OpenGL command glBindBuffer was not loaded");
        return _BindBuffer (target, buffer);
    }
    /// ditto
    public void DeleteBuffers (GLsizei n, const(GLuint)* buffers) const {
        assert(_DeleteBuffers !is null, "OpenGL command glDeleteBuffers was not loaded");
        return _DeleteBuffers (n, buffers);
    }
    /// ditto
    public void GenBuffers (GLsizei n, GLuint* buffers) const {
        assert(_GenBuffers !is null, "OpenGL command glGenBuffers was not loaded");
        return _GenBuffers (n, buffers);
    }
    /// ditto
    public GLboolean IsBuffer (GLuint buffer) const {
        assert(_IsBuffer !is null, "OpenGL command glIsBuffer was not loaded");
        return _IsBuffer (buffer);
    }
    /// ditto
    public void BufferData (GLenum target, GLsizeiptr size, const(void)* data, GLenum usage) const {
        assert(_BufferData !is null, "OpenGL command glBufferData was not loaded");
        return _BufferData (target, size, data, usage);
    }
    /// ditto
    public void BufferSubData (GLenum target, GLintptr offset, GLsizeiptr size, const(void)* data) const {
        assert(_BufferSubData !is null, "OpenGL command glBufferSubData was not loaded");
        return _BufferSubData (target, offset, size, data);
    }
    /// ditto
    public void GetBufferSubData (GLenum target, GLintptr offset, GLsizeiptr size, void* data) const {
        assert(_GetBufferSubData !is null, "OpenGL command glGetBufferSubData was not loaded");
        return _GetBufferSubData (target, offset, size, data);
    }
    /// ditto
    public void * MapBuffer (GLenum target, GLenum access) const {
        assert(_MapBuffer !is null, "OpenGL command glMapBuffer was not loaded");
        return _MapBuffer (target, access);
    }
    /// ditto
    public GLboolean UnmapBuffer (GLenum target) const {
        assert(_UnmapBuffer !is null, "OpenGL command glUnmapBuffer was not loaded");
        return _UnmapBuffer (target);
    }
    /// ditto
    public void GetBufferParameteriv (GLenum target, GLenum pname, GLint* params) const {
        assert(_GetBufferParameteriv !is null, "OpenGL command glGetBufferParameteriv was not loaded");
        return _GetBufferParameteriv (target, pname, params);
    }
    /// ditto
    public void GetBufferPointerv (GLenum target, GLenum pname, void** params) const {
        assert(_GetBufferPointerv !is null, "OpenGL command glGetBufferPointerv was not loaded");
        return _GetBufferPointerv (target, pname, params);
    }

    /// Commands for GL_VERSION_2_0
    public void BlendEquationSeparate (GLenum modeRGB, GLenum modeAlpha) const {
        assert(_BlendEquationSeparate !is null, "OpenGL command glBlendEquationSeparate was not loaded");
        return _BlendEquationSeparate (modeRGB, modeAlpha);
    }
    /// ditto
    public void DrawBuffers (GLsizei n, const(GLenum)* bufs) const {
        assert(_DrawBuffers !is null, "OpenGL command glDrawBuffers was not loaded");
        return _DrawBuffers (n, bufs);
    }
    /// ditto
    public void StencilOpSeparate (GLenum face, GLenum sfail, GLenum dpfail, GLenum dppass) const {
        assert(_StencilOpSeparate !is null, "OpenGL command glStencilOpSeparate was not loaded");
        return _StencilOpSeparate (face, sfail, dpfail, dppass);
    }
    /// ditto
    public void StencilFuncSeparate (GLenum face, GLenum func, GLint ref_, GLuint mask) const {
        assert(_StencilFuncSeparate !is null, "OpenGL command glStencilFuncSeparate was not loaded");
        return _StencilFuncSeparate (face, func, ref_, mask);
    }
    /// ditto
    public void StencilMaskSeparate (GLenum face, GLuint mask) const {
        assert(_StencilMaskSeparate !is null, "OpenGL command glStencilMaskSeparate was not loaded");
        return _StencilMaskSeparate (face, mask);
    }
    /// ditto
    public void AttachShader (GLuint program, GLuint shader) const {
        assert(_AttachShader !is null, "OpenGL command glAttachShader was not loaded");
        return _AttachShader (program, shader);
    }
    /// ditto
    public void BindAttribLocation (GLuint program, GLuint index, const(GLchar)* name) const {
        assert(_BindAttribLocation !is null, "OpenGL command glBindAttribLocation was not loaded");
        return _BindAttribLocation (program, index, name);
    }
    /// ditto
    public void CompileShader (GLuint shader) const {
        assert(_CompileShader !is null, "OpenGL command glCompileShader was not loaded");
        return _CompileShader (shader);
    }
    /// ditto
    public GLuint CreateProgram () const {
        assert(_CreateProgram !is null, "OpenGL command glCreateProgram was not loaded");
        return _CreateProgram ();
    }
    /// ditto
    public GLuint CreateShader (GLenum type) const {
        assert(_CreateShader !is null, "OpenGL command glCreateShader was not loaded");
        return _CreateShader (type);
    }
    /// ditto
    public void DeleteProgram (GLuint program) const {
        assert(_DeleteProgram !is null, "OpenGL command glDeleteProgram was not loaded");
        return _DeleteProgram (program);
    }
    /// ditto
    public void DeleteShader (GLuint shader) const {
        assert(_DeleteShader !is null, "OpenGL command glDeleteShader was not loaded");
        return _DeleteShader (shader);
    }
    /// ditto
    public void DetachShader (GLuint program, GLuint shader) const {
        assert(_DetachShader !is null, "OpenGL command glDetachShader was not loaded");
        return _DetachShader (program, shader);
    }
    /// ditto
    public void DisableVertexAttribArray (GLuint index) const {
        assert(_DisableVertexAttribArray !is null, "OpenGL command glDisableVertexAttribArray was not loaded");
        return _DisableVertexAttribArray (index);
    }
    /// ditto
    public void EnableVertexAttribArray (GLuint index) const {
        assert(_EnableVertexAttribArray !is null, "OpenGL command glEnableVertexAttribArray was not loaded");
        return _EnableVertexAttribArray (index);
    }
    /// ditto
    public void GetActiveAttrib (GLuint program, GLuint index, GLsizei bufSize, GLsizei* length, GLint* size, GLenum* type, GLchar* name) const {
        assert(_GetActiveAttrib !is null, "OpenGL command glGetActiveAttrib was not loaded");
        return _GetActiveAttrib (program, index, bufSize, length, size, type, name);
    }
    /// ditto
    public void GetActiveUniform (GLuint program, GLuint index, GLsizei bufSize, GLsizei* length, GLint* size, GLenum* type, GLchar* name) const {
        assert(_GetActiveUniform !is null, "OpenGL command glGetActiveUniform was not loaded");
        return _GetActiveUniform (program, index, bufSize, length, size, type, name);
    }
    /// ditto
    public void GetAttachedShaders (GLuint program, GLsizei maxCount, GLsizei* count, GLuint* shaders) const {
        assert(_GetAttachedShaders !is null, "OpenGL command glGetAttachedShaders was not loaded");
        return _GetAttachedShaders (program, maxCount, count, shaders);
    }
    /// ditto
    public GLint GetAttribLocation (GLuint program, const(GLchar)* name) const {
        assert(_GetAttribLocation !is null, "OpenGL command glGetAttribLocation was not loaded");
        return _GetAttribLocation (program, name);
    }
    /// ditto
    public void GetProgramiv (GLuint program, GLenum pname, GLint* params) const {
        assert(_GetProgramiv !is null, "OpenGL command glGetProgramiv was not loaded");
        return _GetProgramiv (program, pname, params);
    }
    /// ditto
    public void GetProgramInfoLog (GLuint program, GLsizei bufSize, GLsizei* length, GLchar* infoLog) const {
        assert(_GetProgramInfoLog !is null, "OpenGL command glGetProgramInfoLog was not loaded");
        return _GetProgramInfoLog (program, bufSize, length, infoLog);
    }
    /// ditto
    public void GetShaderiv (GLuint shader, GLenum pname, GLint* params) const {
        assert(_GetShaderiv !is null, "OpenGL command glGetShaderiv was not loaded");
        return _GetShaderiv (shader, pname, params);
    }
    /// ditto
    public void GetShaderInfoLog (GLuint shader, GLsizei bufSize, GLsizei* length, GLchar* infoLog) const {
        assert(_GetShaderInfoLog !is null, "OpenGL command glGetShaderInfoLog was not loaded");
        return _GetShaderInfoLog (shader, bufSize, length, infoLog);
    }
    /// ditto
    public void GetShaderSource (GLuint shader, GLsizei bufSize, GLsizei* length, GLchar* source) const {
        assert(_GetShaderSource !is null, "OpenGL command glGetShaderSource was not loaded");
        return _GetShaderSource (shader, bufSize, length, source);
    }
    /// ditto
    public GLint GetUniformLocation (GLuint program, const(GLchar)* name) const {
        assert(_GetUniformLocation !is null, "OpenGL command glGetUniformLocation was not loaded");
        return _GetUniformLocation (program, name);
    }
    /// ditto
    public void GetUniformfv (GLuint program, GLint location, GLfloat* params) const {
        assert(_GetUniformfv !is null, "OpenGL command glGetUniformfv was not loaded");
        return _GetUniformfv (program, location, params);
    }
    /// ditto
    public void GetUniformiv (GLuint program, GLint location, GLint* params) const {
        assert(_GetUniformiv !is null, "OpenGL command glGetUniformiv was not loaded");
        return _GetUniformiv (program, location, params);
    }
    /// ditto
    public void GetVertexAttribdv (GLuint index, GLenum pname, GLdouble* params) const {
        assert(_GetVertexAttribdv !is null, "OpenGL command glGetVertexAttribdv was not loaded");
        return _GetVertexAttribdv (index, pname, params);
    }
    /// ditto
    public void GetVertexAttribfv (GLuint index, GLenum pname, GLfloat* params) const {
        assert(_GetVertexAttribfv !is null, "OpenGL command glGetVertexAttribfv was not loaded");
        return _GetVertexAttribfv (index, pname, params);
    }
    /// ditto
    public void GetVertexAttribiv (GLuint index, GLenum pname, GLint* params) const {
        assert(_GetVertexAttribiv !is null, "OpenGL command glGetVertexAttribiv was not loaded");
        return _GetVertexAttribiv (index, pname, params);
    }
    /// ditto
    public void GetVertexAttribPointerv (GLuint index, GLenum pname, void** pointer) const {
        assert(_GetVertexAttribPointerv !is null, "OpenGL command glGetVertexAttribPointerv was not loaded");
        return _GetVertexAttribPointerv (index, pname, pointer);
    }
    /// ditto
    public GLboolean IsProgram (GLuint program) const {
        assert(_IsProgram !is null, "OpenGL command glIsProgram was not loaded");
        return _IsProgram (program);
    }
    /// ditto
    public GLboolean IsShader (GLuint shader) const {
        assert(_IsShader !is null, "OpenGL command glIsShader was not loaded");
        return _IsShader (shader);
    }
    /// ditto
    public void LinkProgram (GLuint program) const {
        assert(_LinkProgram !is null, "OpenGL command glLinkProgram was not loaded");
        return _LinkProgram (program);
    }
    /// ditto
    public void ShaderSource (GLuint shader, GLsizei count, const(GLchar*)* string, const(GLint)* length) const {
        assert(_ShaderSource !is null, "OpenGL command glShaderSource was not loaded");
        return _ShaderSource (shader, count, string, length);
    }
    /// ditto
    public void UseProgram (GLuint program) const {
        assert(_UseProgram !is null, "OpenGL command glUseProgram was not loaded");
        return _UseProgram (program);
    }
    /// ditto
    public void Uniform1f (GLint location, GLfloat v0) const {
        assert(_Uniform1f !is null, "OpenGL command glUniform1f was not loaded");
        return _Uniform1f (location, v0);
    }
    /// ditto
    public void Uniform2f (GLint location, GLfloat v0, GLfloat v1) const {
        assert(_Uniform2f !is null, "OpenGL command glUniform2f was not loaded");
        return _Uniform2f (location, v0, v1);
    }
    /// ditto
    public void Uniform3f (GLint location, GLfloat v0, GLfloat v1, GLfloat v2) const {
        assert(_Uniform3f !is null, "OpenGL command glUniform3f was not loaded");
        return _Uniform3f (location, v0, v1, v2);
    }
    /// ditto
    public void Uniform4f (GLint location, GLfloat v0, GLfloat v1, GLfloat v2, GLfloat v3) const {
        assert(_Uniform4f !is null, "OpenGL command glUniform4f was not loaded");
        return _Uniform4f (location, v0, v1, v2, v3);
    }
    /// ditto
    public void Uniform1i (GLint location, GLint v0) const {
        assert(_Uniform1i !is null, "OpenGL command glUniform1i was not loaded");
        return _Uniform1i (location, v0);
    }
    /// ditto
    public void Uniform2i (GLint location, GLint v0, GLint v1) const {
        assert(_Uniform2i !is null, "OpenGL command glUniform2i was not loaded");
        return _Uniform2i (location, v0, v1);
    }
    /// ditto
    public void Uniform3i (GLint location, GLint v0, GLint v1, GLint v2) const {
        assert(_Uniform3i !is null, "OpenGL command glUniform3i was not loaded");
        return _Uniform3i (location, v0, v1, v2);
    }
    /// ditto
    public void Uniform4i (GLint location, GLint v0, GLint v1, GLint v2, GLint v3) const {
        assert(_Uniform4i !is null, "OpenGL command glUniform4i was not loaded");
        return _Uniform4i (location, v0, v1, v2, v3);
    }
    /// ditto
    public void Uniform1fv (GLint location, GLsizei count, const(GLfloat)* value) const {
        assert(_Uniform1fv !is null, "OpenGL command glUniform1fv was not loaded");
        return _Uniform1fv (location, count, value);
    }
    /// ditto
    public void Uniform2fv (GLint location, GLsizei count, const(GLfloat)* value) const {
        assert(_Uniform2fv !is null, "OpenGL command glUniform2fv was not loaded");
        return _Uniform2fv (location, count, value);
    }
    /// ditto
    public void Uniform3fv (GLint location, GLsizei count, const(GLfloat)* value) const {
        assert(_Uniform3fv !is null, "OpenGL command glUniform3fv was not loaded");
        return _Uniform3fv (location, count, value);
    }
    /// ditto
    public void Uniform4fv (GLint location, GLsizei count, const(GLfloat)* value) const {
        assert(_Uniform4fv !is null, "OpenGL command glUniform4fv was not loaded");
        return _Uniform4fv (location, count, value);
    }
    /// ditto
    public void Uniform1iv (GLint location, GLsizei count, const(GLint)* value) const {
        assert(_Uniform1iv !is null, "OpenGL command glUniform1iv was not loaded");
        return _Uniform1iv (location, count, value);
    }
    /// ditto
    public void Uniform2iv (GLint location, GLsizei count, const(GLint)* value) const {
        assert(_Uniform2iv !is null, "OpenGL command glUniform2iv was not loaded");
        return _Uniform2iv (location, count, value);
    }
    /// ditto
    public void Uniform3iv (GLint location, GLsizei count, const(GLint)* value) const {
        assert(_Uniform3iv !is null, "OpenGL command glUniform3iv was not loaded");
        return _Uniform3iv (location, count, value);
    }
    /// ditto
    public void Uniform4iv (GLint location, GLsizei count, const(GLint)* value) const {
        assert(_Uniform4iv !is null, "OpenGL command glUniform4iv was not loaded");
        return _Uniform4iv (location, count, value);
    }
    /// ditto
    public void UniformMatrix2fv (GLint location, GLsizei count, GLboolean transpose, const(GLfloat)* value) const {
        assert(_UniformMatrix2fv !is null, "OpenGL command glUniformMatrix2fv was not loaded");
        return _UniformMatrix2fv (location, count, transpose, value);
    }
    /// ditto
    public void UniformMatrix3fv (GLint location, GLsizei count, GLboolean transpose, const(GLfloat)* value) const {
        assert(_UniformMatrix3fv !is null, "OpenGL command glUniformMatrix3fv was not loaded");
        return _UniformMatrix3fv (location, count, transpose, value);
    }
    /// ditto
    public void UniformMatrix4fv (GLint location, GLsizei count, GLboolean transpose, const(GLfloat)* value) const {
        assert(_UniformMatrix4fv !is null, "OpenGL command glUniformMatrix4fv was not loaded");
        return _UniformMatrix4fv (location, count, transpose, value);
    }
    /// ditto
    public void ValidateProgram (GLuint program) const {
        assert(_ValidateProgram !is null, "OpenGL command glValidateProgram was not loaded");
        return _ValidateProgram (program);
    }
    /// ditto
    public void VertexAttrib1d (GLuint index, GLdouble x) const {
        assert(_VertexAttrib1d !is null, "OpenGL command glVertexAttrib1d was not loaded");
        return _VertexAttrib1d (index, x);
    }
    /// ditto
    public void VertexAttrib1dv (GLuint index, const(GLdouble)* v) const {
        assert(_VertexAttrib1dv !is null, "OpenGL command glVertexAttrib1dv was not loaded");
        return _VertexAttrib1dv (index, v);
    }
    /// ditto
    public void VertexAttrib1f (GLuint index, GLfloat x) const {
        assert(_VertexAttrib1f !is null, "OpenGL command glVertexAttrib1f was not loaded");
        return _VertexAttrib1f (index, x);
    }
    /// ditto
    public void VertexAttrib1fv (GLuint index, const(GLfloat)* v) const {
        assert(_VertexAttrib1fv !is null, "OpenGL command glVertexAttrib1fv was not loaded");
        return _VertexAttrib1fv (index, v);
    }
    /// ditto
    public void VertexAttrib1s (GLuint index, GLshort x) const {
        assert(_VertexAttrib1s !is null, "OpenGL command glVertexAttrib1s was not loaded");
        return _VertexAttrib1s (index, x);
    }
    /// ditto
    public void VertexAttrib1sv (GLuint index, const(GLshort)* v) const {
        assert(_VertexAttrib1sv !is null, "OpenGL command glVertexAttrib1sv was not loaded");
        return _VertexAttrib1sv (index, v);
    }
    /// ditto
    public void VertexAttrib2d (GLuint index, GLdouble x, GLdouble y) const {
        assert(_VertexAttrib2d !is null, "OpenGL command glVertexAttrib2d was not loaded");
        return _VertexAttrib2d (index, x, y);
    }
    /// ditto
    public void VertexAttrib2dv (GLuint index, const(GLdouble)* v) const {
        assert(_VertexAttrib2dv !is null, "OpenGL command glVertexAttrib2dv was not loaded");
        return _VertexAttrib2dv (index, v);
    }
    /// ditto
    public void VertexAttrib2f (GLuint index, GLfloat x, GLfloat y) const {
        assert(_VertexAttrib2f !is null, "OpenGL command glVertexAttrib2f was not loaded");
        return _VertexAttrib2f (index, x, y);
    }
    /// ditto
    public void VertexAttrib2fv (GLuint index, const(GLfloat)* v) const {
        assert(_VertexAttrib2fv !is null, "OpenGL command glVertexAttrib2fv was not loaded");
        return _VertexAttrib2fv (index, v);
    }
    /// ditto
    public void VertexAttrib2s (GLuint index, GLshort x, GLshort y) const {
        assert(_VertexAttrib2s !is null, "OpenGL command glVertexAttrib2s was not loaded");
        return _VertexAttrib2s (index, x, y);
    }
    /// ditto
    public void VertexAttrib2sv (GLuint index, const(GLshort)* v) const {
        assert(_VertexAttrib2sv !is null, "OpenGL command glVertexAttrib2sv was not loaded");
        return _VertexAttrib2sv (index, v);
    }
    /// ditto
    public void VertexAttrib3d (GLuint index, GLdouble x, GLdouble y, GLdouble z) const {
        assert(_VertexAttrib3d !is null, "OpenGL command glVertexAttrib3d was not loaded");
        return _VertexAttrib3d (index, x, y, z);
    }
    /// ditto
    public void VertexAttrib3dv (GLuint index, const(GLdouble)* v) const {
        assert(_VertexAttrib3dv !is null, "OpenGL command glVertexAttrib3dv was not loaded");
        return _VertexAttrib3dv (index, v);
    }
    /// ditto
    public void VertexAttrib3f (GLuint index, GLfloat x, GLfloat y, GLfloat z) const {
        assert(_VertexAttrib3f !is null, "OpenGL command glVertexAttrib3f was not loaded");
        return _VertexAttrib3f (index, x, y, z);
    }
    /// ditto
    public void VertexAttrib3fv (GLuint index, const(GLfloat)* v) const {
        assert(_VertexAttrib3fv !is null, "OpenGL command glVertexAttrib3fv was not loaded");
        return _VertexAttrib3fv (index, v);
    }
    /// ditto
    public void VertexAttrib3s (GLuint index, GLshort x, GLshort y, GLshort z) const {
        assert(_VertexAttrib3s !is null, "OpenGL command glVertexAttrib3s was not loaded");
        return _VertexAttrib3s (index, x, y, z);
    }
    /// ditto
    public void VertexAttrib3sv (GLuint index, const(GLshort)* v) const {
        assert(_VertexAttrib3sv !is null, "OpenGL command glVertexAttrib3sv was not loaded");
        return _VertexAttrib3sv (index, v);
    }
    /// ditto
    public void VertexAttrib4Nbv (GLuint index, const(GLbyte)* v) const {
        assert(_VertexAttrib4Nbv !is null, "OpenGL command glVertexAttrib4Nbv was not loaded");
        return _VertexAttrib4Nbv (index, v);
    }
    /// ditto
    public void VertexAttrib4Niv (GLuint index, const(GLint)* v) const {
        assert(_VertexAttrib4Niv !is null, "OpenGL command glVertexAttrib4Niv was not loaded");
        return _VertexAttrib4Niv (index, v);
    }
    /// ditto
    public void VertexAttrib4Nsv (GLuint index, const(GLshort)* v) const {
        assert(_VertexAttrib4Nsv !is null, "OpenGL command glVertexAttrib4Nsv was not loaded");
        return _VertexAttrib4Nsv (index, v);
    }
    /// ditto
    public void VertexAttrib4Nub (GLuint index, GLubyte x, GLubyte y, GLubyte z, GLubyte w) const {
        assert(_VertexAttrib4Nub !is null, "OpenGL command glVertexAttrib4Nub was not loaded");
        return _VertexAttrib4Nub (index, x, y, z, w);
    }
    /// ditto
    public void VertexAttrib4Nubv (GLuint index, const(GLubyte)* v) const {
        assert(_VertexAttrib4Nubv !is null, "OpenGL command glVertexAttrib4Nubv was not loaded");
        return _VertexAttrib4Nubv (index, v);
    }
    /// ditto
    public void VertexAttrib4Nuiv (GLuint index, const(GLuint)* v) const {
        assert(_VertexAttrib4Nuiv !is null, "OpenGL command glVertexAttrib4Nuiv was not loaded");
        return _VertexAttrib4Nuiv (index, v);
    }
    /// ditto
    public void VertexAttrib4Nusv (GLuint index, const(GLushort)* v) const {
        assert(_VertexAttrib4Nusv !is null, "OpenGL command glVertexAttrib4Nusv was not loaded");
        return _VertexAttrib4Nusv (index, v);
    }
    /// ditto
    public void VertexAttrib4bv (GLuint index, const(GLbyte)* v) const {
        assert(_VertexAttrib4bv !is null, "OpenGL command glVertexAttrib4bv was not loaded");
        return _VertexAttrib4bv (index, v);
    }
    /// ditto
    public void VertexAttrib4d (GLuint index, GLdouble x, GLdouble y, GLdouble z, GLdouble w) const {
        assert(_VertexAttrib4d !is null, "OpenGL command glVertexAttrib4d was not loaded");
        return _VertexAttrib4d (index, x, y, z, w);
    }
    /// ditto
    public void VertexAttrib4dv (GLuint index, const(GLdouble)* v) const {
        assert(_VertexAttrib4dv !is null, "OpenGL command glVertexAttrib4dv was not loaded");
        return _VertexAttrib4dv (index, v);
    }
    /// ditto
    public void VertexAttrib4f (GLuint index, GLfloat x, GLfloat y, GLfloat z, GLfloat w) const {
        assert(_VertexAttrib4f !is null, "OpenGL command glVertexAttrib4f was not loaded");
        return _VertexAttrib4f (index, x, y, z, w);
    }
    /// ditto
    public void VertexAttrib4fv (GLuint index, const(GLfloat)* v) const {
        assert(_VertexAttrib4fv !is null, "OpenGL command glVertexAttrib4fv was not loaded");
        return _VertexAttrib4fv (index, v);
    }
    /// ditto
    public void VertexAttrib4iv (GLuint index, const(GLint)* v) const {
        assert(_VertexAttrib4iv !is null, "OpenGL command glVertexAttrib4iv was not loaded");
        return _VertexAttrib4iv (index, v);
    }
    /// ditto
    public void VertexAttrib4s (GLuint index, GLshort x, GLshort y, GLshort z, GLshort w) const {
        assert(_VertexAttrib4s !is null, "OpenGL command glVertexAttrib4s was not loaded");
        return _VertexAttrib4s (index, x, y, z, w);
    }
    /// ditto
    public void VertexAttrib4sv (GLuint index, const(GLshort)* v) const {
        assert(_VertexAttrib4sv !is null, "OpenGL command glVertexAttrib4sv was not loaded");
        return _VertexAttrib4sv (index, v);
    }
    /// ditto
    public void VertexAttrib4ubv (GLuint index, const(GLubyte)* v) const {
        assert(_VertexAttrib4ubv !is null, "OpenGL command glVertexAttrib4ubv was not loaded");
        return _VertexAttrib4ubv (index, v);
    }
    /// ditto
    public void VertexAttrib4uiv (GLuint index, const(GLuint)* v) const {
        assert(_VertexAttrib4uiv !is null, "OpenGL command glVertexAttrib4uiv was not loaded");
        return _VertexAttrib4uiv (index, v);
    }
    /// ditto
    public void VertexAttrib4usv (GLuint index, const(GLushort)* v) const {
        assert(_VertexAttrib4usv !is null, "OpenGL command glVertexAttrib4usv was not loaded");
        return _VertexAttrib4usv (index, v);
    }
    /// ditto
    public void VertexAttribPointer (GLuint index, GLint size, GLenum type, GLboolean normalized, GLsizei stride, const(void)* pointer) const {
        assert(_VertexAttribPointer !is null, "OpenGL command glVertexAttribPointer was not loaded");
        return _VertexAttribPointer (index, size, type, normalized, stride, pointer);
    }

    /// Commands for GL_VERSION_2_1
    public void UniformMatrix2x3fv (GLint location, GLsizei count, GLboolean transpose, const(GLfloat)* value) const {
        assert(_UniformMatrix2x3fv !is null, "OpenGL command glUniformMatrix2x3fv was not loaded");
        return _UniformMatrix2x3fv (location, count, transpose, value);
    }
    /// ditto
    public void UniformMatrix3x2fv (GLint location, GLsizei count, GLboolean transpose, const(GLfloat)* value) const {
        assert(_UniformMatrix3x2fv !is null, "OpenGL command glUniformMatrix3x2fv was not loaded");
        return _UniformMatrix3x2fv (location, count, transpose, value);
    }
    /// ditto
    public void UniformMatrix2x4fv (GLint location, GLsizei count, GLboolean transpose, const(GLfloat)* value) const {
        assert(_UniformMatrix2x4fv !is null, "OpenGL command glUniformMatrix2x4fv was not loaded");
        return _UniformMatrix2x4fv (location, count, transpose, value);
    }
    /// ditto
    public void UniformMatrix4x2fv (GLint location, GLsizei count, GLboolean transpose, const(GLfloat)* value) const {
        assert(_UniformMatrix4x2fv !is null, "OpenGL command glUniformMatrix4x2fv was not loaded");
        return _UniformMatrix4x2fv (location, count, transpose, value);
    }
    /// ditto
    public void UniformMatrix3x4fv (GLint location, GLsizei count, GLboolean transpose, const(GLfloat)* value) const {
        assert(_UniformMatrix3x4fv !is null, "OpenGL command glUniformMatrix3x4fv was not loaded");
        return _UniformMatrix3x4fv (location, count, transpose, value);
    }
    /// ditto
    public void UniformMatrix4x3fv (GLint location, GLsizei count, GLboolean transpose, const(GLfloat)* value) const {
        assert(_UniformMatrix4x3fv !is null, "OpenGL command glUniformMatrix4x3fv was not loaded");
        return _UniformMatrix4x3fv (location, count, transpose, value);
    }

    /// Commands for GL_VERSION_3_0
    public void ColorMaski (GLuint index, GLboolean r, GLboolean g, GLboolean b, GLboolean a) const {
        assert(_ColorMaski !is null, "OpenGL command glColorMaski was not loaded");
        return _ColorMaski (index, r, g, b, a);
    }
    /// ditto
    public void GetBooleani_v (GLenum target, GLuint index, GLboolean* data) const {
        assert(_GetBooleani_v !is null, "OpenGL command glGetBooleani_v was not loaded");
        return _GetBooleani_v (target, index, data);
    }
    /// ditto
    public void GetIntegeri_v (GLenum target, GLuint index, GLint* data) const {
        assert(_GetIntegeri_v !is null, "OpenGL command glGetIntegeri_v was not loaded");
        return _GetIntegeri_v (target, index, data);
    }
    /// ditto
    public void Enablei (GLenum target, GLuint index) const {
        assert(_Enablei !is null, "OpenGL command glEnablei was not loaded");
        return _Enablei (target, index);
    }
    /// ditto
    public void Disablei (GLenum target, GLuint index) const {
        assert(_Disablei !is null, "OpenGL command glDisablei was not loaded");
        return _Disablei (target, index);
    }
    /// ditto
    public GLboolean IsEnabledi (GLenum target, GLuint index) const {
        assert(_IsEnabledi !is null, "OpenGL command glIsEnabledi was not loaded");
        return _IsEnabledi (target, index);
    }
    /// ditto
    public void BeginTransformFeedback (GLenum primitiveMode) const {
        assert(_BeginTransformFeedback !is null, "OpenGL command glBeginTransformFeedback was not loaded");
        return _BeginTransformFeedback (primitiveMode);
    }
    /// ditto
    public void EndTransformFeedback () const {
        assert(_EndTransformFeedback !is null, "OpenGL command glEndTransformFeedback was not loaded");
        return _EndTransformFeedback ();
    }
    /// ditto
    public void BindBufferRange (GLenum target, GLuint index, GLuint buffer, GLintptr offset, GLsizeiptr size) const {
        assert(_BindBufferRange !is null, "OpenGL command glBindBufferRange was not loaded");
        return _BindBufferRange (target, index, buffer, offset, size);
    }
    /// ditto
    public void BindBufferBase (GLenum target, GLuint index, GLuint buffer) const {
        assert(_BindBufferBase !is null, "OpenGL command glBindBufferBase was not loaded");
        return _BindBufferBase (target, index, buffer);
    }
    /// ditto
    public void TransformFeedbackVaryings (GLuint program, GLsizei count, const(GLchar*)* varyings, GLenum bufferMode) const {
        assert(_TransformFeedbackVaryings !is null, "OpenGL command glTransformFeedbackVaryings was not loaded");
        return _TransformFeedbackVaryings (program, count, varyings, bufferMode);
    }
    /// ditto
    public void GetTransformFeedbackVarying (GLuint program, GLuint index, GLsizei bufSize, GLsizei* length, GLsizei* size, GLenum* type, GLchar* name) const {
        assert(_GetTransformFeedbackVarying !is null, "OpenGL command glGetTransformFeedbackVarying was not loaded");
        return _GetTransformFeedbackVarying (program, index, bufSize, length, size, type, name);
    }
    /// ditto
    public void ClampColor (GLenum target, GLenum clamp) const {
        assert(_ClampColor !is null, "OpenGL command glClampColor was not loaded");
        return _ClampColor (target, clamp);
    }
    /// ditto
    public void BeginConditionalRender (GLuint id, GLenum mode) const {
        assert(_BeginConditionalRender !is null, "OpenGL command glBeginConditionalRender was not loaded");
        return _BeginConditionalRender (id, mode);
    }
    /// ditto
    public void EndConditionalRender () const {
        assert(_EndConditionalRender !is null, "OpenGL command glEndConditionalRender was not loaded");
        return _EndConditionalRender ();
    }
    /// ditto
    public void VertexAttribIPointer (GLuint index, GLint size, GLenum type, GLsizei stride, const(void)* pointer) const {
        assert(_VertexAttribIPointer !is null, "OpenGL command glVertexAttribIPointer was not loaded");
        return _VertexAttribIPointer (index, size, type, stride, pointer);
    }
    /// ditto
    public void GetVertexAttribIiv (GLuint index, GLenum pname, GLint* params) const {
        assert(_GetVertexAttribIiv !is null, "OpenGL command glGetVertexAttribIiv was not loaded");
        return _GetVertexAttribIiv (index, pname, params);
    }
    /// ditto
    public void GetVertexAttribIuiv (GLuint index, GLenum pname, GLuint* params) const {
        assert(_GetVertexAttribIuiv !is null, "OpenGL command glGetVertexAttribIuiv was not loaded");
        return _GetVertexAttribIuiv (index, pname, params);
    }
    /// ditto
    public void VertexAttribI1i (GLuint index, GLint x) const {
        assert(_VertexAttribI1i !is null, "OpenGL command glVertexAttribI1i was not loaded");
        return _VertexAttribI1i (index, x);
    }
    /// ditto
    public void VertexAttribI2i (GLuint index, GLint x, GLint y) const {
        assert(_VertexAttribI2i !is null, "OpenGL command glVertexAttribI2i was not loaded");
        return _VertexAttribI2i (index, x, y);
    }
    /// ditto
    public void VertexAttribI3i (GLuint index, GLint x, GLint y, GLint z) const {
        assert(_VertexAttribI3i !is null, "OpenGL command glVertexAttribI3i was not loaded");
        return _VertexAttribI3i (index, x, y, z);
    }
    /// ditto
    public void VertexAttribI4i (GLuint index, GLint x, GLint y, GLint z, GLint w) const {
        assert(_VertexAttribI4i !is null, "OpenGL command glVertexAttribI4i was not loaded");
        return _VertexAttribI4i (index, x, y, z, w);
    }
    /// ditto
    public void VertexAttribI1ui (GLuint index, GLuint x) const {
        assert(_VertexAttribI1ui !is null, "OpenGL command glVertexAttribI1ui was not loaded");
        return _VertexAttribI1ui (index, x);
    }
    /// ditto
    public void VertexAttribI2ui (GLuint index, GLuint x, GLuint y) const {
        assert(_VertexAttribI2ui !is null, "OpenGL command glVertexAttribI2ui was not loaded");
        return _VertexAttribI2ui (index, x, y);
    }
    /// ditto
    public void VertexAttribI3ui (GLuint index, GLuint x, GLuint y, GLuint z) const {
        assert(_VertexAttribI3ui !is null, "OpenGL command glVertexAttribI3ui was not loaded");
        return _VertexAttribI3ui (index, x, y, z);
    }
    /// ditto
    public void VertexAttribI4ui (GLuint index, GLuint x, GLuint y, GLuint z, GLuint w) const {
        assert(_VertexAttribI4ui !is null, "OpenGL command glVertexAttribI4ui was not loaded");
        return _VertexAttribI4ui (index, x, y, z, w);
    }
    /// ditto
    public void VertexAttribI1iv (GLuint index, const(GLint)* v) const {
        assert(_VertexAttribI1iv !is null, "OpenGL command glVertexAttribI1iv was not loaded");
        return _VertexAttribI1iv (index, v);
    }
    /// ditto
    public void VertexAttribI2iv (GLuint index, const(GLint)* v) const {
        assert(_VertexAttribI2iv !is null, "OpenGL command glVertexAttribI2iv was not loaded");
        return _VertexAttribI2iv (index, v);
    }
    /// ditto
    public void VertexAttribI3iv (GLuint index, const(GLint)* v) const {
        assert(_VertexAttribI3iv !is null, "OpenGL command glVertexAttribI3iv was not loaded");
        return _VertexAttribI3iv (index, v);
    }
    /// ditto
    public void VertexAttribI4iv (GLuint index, const(GLint)* v) const {
        assert(_VertexAttribI4iv !is null, "OpenGL command glVertexAttribI4iv was not loaded");
        return _VertexAttribI4iv (index, v);
    }
    /// ditto
    public void VertexAttribI1uiv (GLuint index, const(GLuint)* v) const {
        assert(_VertexAttribI1uiv !is null, "OpenGL command glVertexAttribI1uiv was not loaded");
        return _VertexAttribI1uiv (index, v);
    }
    /// ditto
    public void VertexAttribI2uiv (GLuint index, const(GLuint)* v) const {
        assert(_VertexAttribI2uiv !is null, "OpenGL command glVertexAttribI2uiv was not loaded");
        return _VertexAttribI2uiv (index, v);
    }
    /// ditto
    public void VertexAttribI3uiv (GLuint index, const(GLuint)* v) const {
        assert(_VertexAttribI3uiv !is null, "OpenGL command glVertexAttribI3uiv was not loaded");
        return _VertexAttribI3uiv (index, v);
    }
    /// ditto
    public void VertexAttribI4uiv (GLuint index, const(GLuint)* v) const {
        assert(_VertexAttribI4uiv !is null, "OpenGL command glVertexAttribI4uiv was not loaded");
        return _VertexAttribI4uiv (index, v);
    }
    /// ditto
    public void VertexAttribI4bv (GLuint index, const(GLbyte)* v) const {
        assert(_VertexAttribI4bv !is null, "OpenGL command glVertexAttribI4bv was not loaded");
        return _VertexAttribI4bv (index, v);
    }
    /// ditto
    public void VertexAttribI4sv (GLuint index, const(GLshort)* v) const {
        assert(_VertexAttribI4sv !is null, "OpenGL command glVertexAttribI4sv was not loaded");
        return _VertexAttribI4sv (index, v);
    }
    /// ditto
    public void VertexAttribI4ubv (GLuint index, const(GLubyte)* v) const {
        assert(_VertexAttribI4ubv !is null, "OpenGL command glVertexAttribI4ubv was not loaded");
        return _VertexAttribI4ubv (index, v);
    }
    /// ditto
    public void VertexAttribI4usv (GLuint index, const(GLushort)* v) const {
        assert(_VertexAttribI4usv !is null, "OpenGL command glVertexAttribI4usv was not loaded");
        return _VertexAttribI4usv (index, v);
    }
    /// ditto
    public void GetUniformuiv (GLuint program, GLint location, GLuint* params) const {
        assert(_GetUniformuiv !is null, "OpenGL command glGetUniformuiv was not loaded");
        return _GetUniformuiv (program, location, params);
    }
    /// ditto
    public void BindFragDataLocation (GLuint program, GLuint color, const(GLchar)* name) const {
        assert(_BindFragDataLocation !is null, "OpenGL command glBindFragDataLocation was not loaded");
        return _BindFragDataLocation (program, color, name);
    }
    /// ditto
    public GLint GetFragDataLocation (GLuint program, const(GLchar)* name) const {
        assert(_GetFragDataLocation !is null, "OpenGL command glGetFragDataLocation was not loaded");
        return _GetFragDataLocation (program, name);
    }
    /// ditto
    public void Uniform1ui (GLint location, GLuint v0) const {
        assert(_Uniform1ui !is null, "OpenGL command glUniform1ui was not loaded");
        return _Uniform1ui (location, v0);
    }
    /// ditto
    public void Uniform2ui (GLint location, GLuint v0, GLuint v1) const {
        assert(_Uniform2ui !is null, "OpenGL command glUniform2ui was not loaded");
        return _Uniform2ui (location, v0, v1);
    }
    /// ditto
    public void Uniform3ui (GLint location, GLuint v0, GLuint v1, GLuint v2) const {
        assert(_Uniform3ui !is null, "OpenGL command glUniform3ui was not loaded");
        return _Uniform3ui (location, v0, v1, v2);
    }
    /// ditto
    public void Uniform4ui (GLint location, GLuint v0, GLuint v1, GLuint v2, GLuint v3) const {
        assert(_Uniform4ui !is null, "OpenGL command glUniform4ui was not loaded");
        return _Uniform4ui (location, v0, v1, v2, v3);
    }
    /// ditto
    public void Uniform1uiv (GLint location, GLsizei count, const(GLuint)* value) const {
        assert(_Uniform1uiv !is null, "OpenGL command glUniform1uiv was not loaded");
        return _Uniform1uiv (location, count, value);
    }
    /// ditto
    public void Uniform2uiv (GLint location, GLsizei count, const(GLuint)* value) const {
        assert(_Uniform2uiv !is null, "OpenGL command glUniform2uiv was not loaded");
        return _Uniform2uiv (location, count, value);
    }
    /// ditto
    public void Uniform3uiv (GLint location, GLsizei count, const(GLuint)* value) const {
        assert(_Uniform3uiv !is null, "OpenGL command glUniform3uiv was not loaded");
        return _Uniform3uiv (location, count, value);
    }
    /// ditto
    public void Uniform4uiv (GLint location, GLsizei count, const(GLuint)* value) const {
        assert(_Uniform4uiv !is null, "OpenGL command glUniform4uiv was not loaded");
        return _Uniform4uiv (location, count, value);
    }
    /// ditto
    public void TexParameterIiv (GLenum target, GLenum pname, const(GLint)* params) const {
        assert(_TexParameterIiv !is null, "OpenGL command glTexParameterIiv was not loaded");
        return _TexParameterIiv (target, pname, params);
    }
    /// ditto
    public void TexParameterIuiv (GLenum target, GLenum pname, const(GLuint)* params) const {
        assert(_TexParameterIuiv !is null, "OpenGL command glTexParameterIuiv was not loaded");
        return _TexParameterIuiv (target, pname, params);
    }
    /// ditto
    public void GetTexParameterIiv (GLenum target, GLenum pname, GLint* params) const {
        assert(_GetTexParameterIiv !is null, "OpenGL command glGetTexParameterIiv was not loaded");
        return _GetTexParameterIiv (target, pname, params);
    }
    /// ditto
    public void GetTexParameterIuiv (GLenum target, GLenum pname, GLuint* params) const {
        assert(_GetTexParameterIuiv !is null, "OpenGL command glGetTexParameterIuiv was not loaded");
        return _GetTexParameterIuiv (target, pname, params);
    }
    /// ditto
    public void ClearBufferiv (GLenum buffer, GLint drawbuffer, const(GLint)* value) const {
        assert(_ClearBufferiv !is null, "OpenGL command glClearBufferiv was not loaded");
        return _ClearBufferiv (buffer, drawbuffer, value);
    }
    /// ditto
    public void ClearBufferuiv (GLenum buffer, GLint drawbuffer, const(GLuint)* value) const {
        assert(_ClearBufferuiv !is null, "OpenGL command glClearBufferuiv was not loaded");
        return _ClearBufferuiv (buffer, drawbuffer, value);
    }
    /// ditto
    public void ClearBufferfv (GLenum buffer, GLint drawbuffer, const(GLfloat)* value) const {
        assert(_ClearBufferfv !is null, "OpenGL command glClearBufferfv was not loaded");
        return _ClearBufferfv (buffer, drawbuffer, value);
    }
    /// ditto
    public void ClearBufferfi (GLenum buffer, GLint drawbuffer, GLfloat depth, GLint stencil) const {
        assert(_ClearBufferfi !is null, "OpenGL command glClearBufferfi was not loaded");
        return _ClearBufferfi (buffer, drawbuffer, depth, stencil);
    }
    /// ditto
    public const(GLubyte)* GetStringi (GLenum name, GLuint index) const {
        assert(_GetStringi !is null, "OpenGL command glGetStringi was not loaded");
        return _GetStringi (name, index);
    }
    /// ditto
    public GLboolean IsRenderbuffer (GLuint renderbuffer) const {
        assert(_IsRenderbuffer !is null, "OpenGL command glIsRenderbuffer was not loaded");
        return _IsRenderbuffer (renderbuffer);
    }
    /// ditto
    public void BindRenderbuffer (GLenum target, GLuint renderbuffer) const {
        assert(_BindRenderbuffer !is null, "OpenGL command glBindRenderbuffer was not loaded");
        return _BindRenderbuffer (target, renderbuffer);
    }
    /// ditto
    public void DeleteRenderbuffers (GLsizei n, const(GLuint)* renderbuffers) const {
        assert(_DeleteRenderbuffers !is null, "OpenGL command glDeleteRenderbuffers was not loaded");
        return _DeleteRenderbuffers (n, renderbuffers);
    }
    /// ditto
    public void GenRenderbuffers (GLsizei n, GLuint* renderbuffers) const {
        assert(_GenRenderbuffers !is null, "OpenGL command glGenRenderbuffers was not loaded");
        return _GenRenderbuffers (n, renderbuffers);
    }
    /// ditto
    public void RenderbufferStorage (GLenum target, GLenum internalformat, GLsizei width, GLsizei height) const {
        assert(_RenderbufferStorage !is null, "OpenGL command glRenderbufferStorage was not loaded");
        return _RenderbufferStorage (target, internalformat, width, height);
    }
    /// ditto
    public void GetRenderbufferParameteriv (GLenum target, GLenum pname, GLint* params) const {
        assert(_GetRenderbufferParameteriv !is null, "OpenGL command glGetRenderbufferParameteriv was not loaded");
        return _GetRenderbufferParameteriv (target, pname, params);
    }
    /// ditto
    public GLboolean IsFramebuffer (GLuint framebuffer) const {
        assert(_IsFramebuffer !is null, "OpenGL command glIsFramebuffer was not loaded");
        return _IsFramebuffer (framebuffer);
    }
    /// ditto
    public void BindFramebuffer (GLenum target, GLuint framebuffer) const {
        assert(_BindFramebuffer !is null, "OpenGL command glBindFramebuffer was not loaded");
        return _BindFramebuffer (target, framebuffer);
    }
    /// ditto
    public void DeleteFramebuffers (GLsizei n, const(GLuint)* framebuffers) const {
        assert(_DeleteFramebuffers !is null, "OpenGL command glDeleteFramebuffers was not loaded");
        return _DeleteFramebuffers (n, framebuffers);
    }
    /// ditto
    public void GenFramebuffers (GLsizei n, GLuint* framebuffers) const {
        assert(_GenFramebuffers !is null, "OpenGL command glGenFramebuffers was not loaded");
        return _GenFramebuffers (n, framebuffers);
    }
    /// ditto
    public GLenum CheckFramebufferStatus (GLenum target) const {
        assert(_CheckFramebufferStatus !is null, "OpenGL command glCheckFramebufferStatus was not loaded");
        return _CheckFramebufferStatus (target);
    }
    /// ditto
    public void FramebufferTexture1D (GLenum target, GLenum attachment, GLenum textarget, GLuint texture, GLint level) const {
        assert(_FramebufferTexture1D !is null, "OpenGL command glFramebufferTexture1D was not loaded");
        return _FramebufferTexture1D (target, attachment, textarget, texture, level);
    }
    /// ditto
    public void FramebufferTexture2D (GLenum target, GLenum attachment, GLenum textarget, GLuint texture, GLint level) const {
        assert(_FramebufferTexture2D !is null, "OpenGL command glFramebufferTexture2D was not loaded");
        return _FramebufferTexture2D (target, attachment, textarget, texture, level);
    }
    /// ditto
    public void FramebufferTexture3D (GLenum target, GLenum attachment, GLenum textarget, GLuint texture, GLint level, GLint zoffset) const {
        assert(_FramebufferTexture3D !is null, "OpenGL command glFramebufferTexture3D was not loaded");
        return _FramebufferTexture3D (target, attachment, textarget, texture, level, zoffset);
    }
    /// ditto
    public void FramebufferRenderbuffer (GLenum target, GLenum attachment, GLenum renderbuffertarget, GLuint renderbuffer) const {
        assert(_FramebufferRenderbuffer !is null, "OpenGL command glFramebufferRenderbuffer was not loaded");
        return _FramebufferRenderbuffer (target, attachment, renderbuffertarget, renderbuffer);
    }
    /// ditto
    public void GetFramebufferAttachmentParameteriv (GLenum target, GLenum attachment, GLenum pname, GLint* params) const {
        assert(_GetFramebufferAttachmentParameteriv !is null, "OpenGL command glGetFramebufferAttachmentParameteriv was not loaded");
        return _GetFramebufferAttachmentParameteriv (target, attachment, pname, params);
    }
    /// ditto
    public void GenerateMipmap (GLenum target) const {
        assert(_GenerateMipmap !is null, "OpenGL command glGenerateMipmap was not loaded");
        return _GenerateMipmap (target);
    }
    /// ditto
    public void BlitFramebuffer (GLint srcX0, GLint srcY0, GLint srcX1, GLint srcY1, GLint dstX0, GLint dstY0, GLint dstX1, GLint dstY1, GLbitfield mask, GLenum filter) const {
        assert(_BlitFramebuffer !is null, "OpenGL command glBlitFramebuffer was not loaded");
        return _BlitFramebuffer (srcX0, srcY0, srcX1, srcY1, dstX0, dstY0, dstX1, dstY1, mask, filter);
    }
    /// ditto
    public void RenderbufferStorageMultisample (GLenum target, GLsizei samples, GLenum internalformat, GLsizei width, GLsizei height) const {
        assert(_RenderbufferStorageMultisample !is null, "OpenGL command glRenderbufferStorageMultisample was not loaded");
        return _RenderbufferStorageMultisample (target, samples, internalformat, width, height);
    }
    /// ditto
    public void FramebufferTextureLayer (GLenum target, GLenum attachment, GLuint texture, GLint level, GLint layer) const {
        assert(_FramebufferTextureLayer !is null, "OpenGL command glFramebufferTextureLayer was not loaded");
        return _FramebufferTextureLayer (target, attachment, texture, level, layer);
    }
    /// ditto
    public void * MapBufferRange (GLenum target, GLintptr offset, GLsizeiptr length, GLbitfield access) const {
        assert(_MapBufferRange !is null, "OpenGL command glMapBufferRange was not loaded");
        return _MapBufferRange (target, offset, length, access);
    }
    /// ditto
    public void FlushMappedBufferRange (GLenum target, GLintptr offset, GLsizeiptr length) const {
        assert(_FlushMappedBufferRange !is null, "OpenGL command glFlushMappedBufferRange was not loaded");
        return _FlushMappedBufferRange (target, offset, length);
    }
    /// ditto
    public void BindVertexArray (GLuint array) const {
        assert(_BindVertexArray !is null, "OpenGL command glBindVertexArray was not loaded");
        return _BindVertexArray (array);
    }
    /// ditto
    public void DeleteVertexArrays (GLsizei n, const(GLuint)* arrays) const {
        assert(_DeleteVertexArrays !is null, "OpenGL command glDeleteVertexArrays was not loaded");
        return _DeleteVertexArrays (n, arrays);
    }
    /// ditto
    public void GenVertexArrays (GLsizei n, GLuint* arrays) const {
        assert(_GenVertexArrays !is null, "OpenGL command glGenVertexArrays was not loaded");
        return _GenVertexArrays (n, arrays);
    }
    /// ditto
    public GLboolean IsVertexArray (GLuint array) const {
        assert(_IsVertexArray !is null, "OpenGL command glIsVertexArray was not loaded");
        return _IsVertexArray (array);
    }

    /// Commands for GL_VERSION_3_1
    public void DrawArraysInstanced (GLenum mode, GLint first, GLsizei count, GLsizei instancecount) const {
        assert(_DrawArraysInstanced !is null, "OpenGL command glDrawArraysInstanced was not loaded");
        return _DrawArraysInstanced (mode, first, count, instancecount);
    }
    /// ditto
    public void DrawElementsInstanced (GLenum mode, GLsizei count, GLenum type, const(void)* indices, GLsizei instancecount) const {
        assert(_DrawElementsInstanced !is null, "OpenGL command glDrawElementsInstanced was not loaded");
        return _DrawElementsInstanced (mode, count, type, indices, instancecount);
    }
    /// ditto
    public void TexBuffer (GLenum target, GLenum internalformat, GLuint buffer) const {
        assert(_TexBuffer !is null, "OpenGL command glTexBuffer was not loaded");
        return _TexBuffer (target, internalformat, buffer);
    }
    /// ditto
    public void PrimitiveRestartIndex (GLuint index) const {
        assert(_PrimitiveRestartIndex !is null, "OpenGL command glPrimitiveRestartIndex was not loaded");
        return _PrimitiveRestartIndex (index);
    }
    /// ditto
    public void CopyBufferSubData (GLenum readTarget, GLenum writeTarget, GLintptr readOffset, GLintptr writeOffset, GLsizeiptr size) const {
        assert(_CopyBufferSubData !is null, "OpenGL command glCopyBufferSubData was not loaded");
        return _CopyBufferSubData (readTarget, writeTarget, readOffset, writeOffset, size);
    }
    /// ditto
    public void GetUniformIndices (GLuint program, GLsizei uniformCount, const(GLchar*)* uniformNames, GLuint* uniformIndices) const {
        assert(_GetUniformIndices !is null, "OpenGL command glGetUniformIndices was not loaded");
        return _GetUniformIndices (program, uniformCount, uniformNames, uniformIndices);
    }
    /// ditto
    public void GetActiveUniformsiv (GLuint program, GLsizei uniformCount, const(GLuint)* uniformIndices, GLenum pname, GLint* params) const {
        assert(_GetActiveUniformsiv !is null, "OpenGL command glGetActiveUniformsiv was not loaded");
        return _GetActiveUniformsiv (program, uniformCount, uniformIndices, pname, params);
    }
    /// ditto
    public void GetActiveUniformName (GLuint program, GLuint uniformIndex, GLsizei bufSize, GLsizei* length, GLchar* uniformName) const {
        assert(_GetActiveUniformName !is null, "OpenGL command glGetActiveUniformName was not loaded");
        return _GetActiveUniformName (program, uniformIndex, bufSize, length, uniformName);
    }
    /// ditto
    public GLuint GetUniformBlockIndex (GLuint program, const(GLchar)* uniformBlockName) const {
        assert(_GetUniformBlockIndex !is null, "OpenGL command glGetUniformBlockIndex was not loaded");
        return _GetUniformBlockIndex (program, uniformBlockName);
    }
    /// ditto
    public void GetActiveUniformBlockiv (GLuint program, GLuint uniformBlockIndex, GLenum pname, GLint* params) const {
        assert(_GetActiveUniformBlockiv !is null, "OpenGL command glGetActiveUniformBlockiv was not loaded");
        return _GetActiveUniformBlockiv (program, uniformBlockIndex, pname, params);
    }
    /// ditto
    public void GetActiveUniformBlockName (GLuint program, GLuint uniformBlockIndex, GLsizei bufSize, GLsizei* length, GLchar* uniformBlockName) const {
        assert(_GetActiveUniformBlockName !is null, "OpenGL command glGetActiveUniformBlockName was not loaded");
        return _GetActiveUniformBlockName (program, uniformBlockIndex, bufSize, length, uniformBlockName);
    }
    /// ditto
    public void UniformBlockBinding (GLuint program, GLuint uniformBlockIndex, GLuint uniformBlockBinding) const {
        assert(_UniformBlockBinding !is null, "OpenGL command glUniformBlockBinding was not loaded");
        return _UniformBlockBinding (program, uniformBlockIndex, uniformBlockBinding);
    }

    /// Commands for GL_VERSION_3_2
    public void DrawElementsBaseVertex (GLenum mode, GLsizei count, GLenum type, const(void)* indices, GLint basevertex) const {
        assert(_DrawElementsBaseVertex !is null, "OpenGL command glDrawElementsBaseVertex was not loaded");
        return _DrawElementsBaseVertex (mode, count, type, indices, basevertex);
    }
    /// ditto
    public void DrawRangeElementsBaseVertex (GLenum mode, GLuint start, GLuint end, GLsizei count, GLenum type, const(void)* indices, GLint basevertex) const {
        assert(_DrawRangeElementsBaseVertex !is null, "OpenGL command glDrawRangeElementsBaseVertex was not loaded");
        return _DrawRangeElementsBaseVertex (mode, start, end, count, type, indices, basevertex);
    }
    /// ditto
    public void DrawElementsInstancedBaseVertex (GLenum mode, GLsizei count, GLenum type, const(void)* indices, GLsizei instancecount, GLint basevertex) const {
        assert(_DrawElementsInstancedBaseVertex !is null, "OpenGL command glDrawElementsInstancedBaseVertex was not loaded");
        return _DrawElementsInstancedBaseVertex (mode, count, type, indices, instancecount, basevertex);
    }
    /// ditto
    public void MultiDrawElementsBaseVertex (GLenum mode, const(GLsizei)* count, GLenum type, const(void*)* indices, GLsizei drawcount, const(GLint)* basevertex) const {
        assert(_MultiDrawElementsBaseVertex !is null, "OpenGL command glMultiDrawElementsBaseVertex was not loaded");
        return _MultiDrawElementsBaseVertex (mode, count, type, indices, drawcount, basevertex);
    }
    /// ditto
    public void ProvokingVertex (GLenum mode) const {
        assert(_ProvokingVertex !is null, "OpenGL command glProvokingVertex was not loaded");
        return _ProvokingVertex (mode);
    }
    /// ditto
    public GLsync FenceSync (GLenum condition, GLbitfield flags) const {
        assert(_FenceSync !is null, "OpenGL command glFenceSync was not loaded");
        return _FenceSync (condition, flags);
    }
    /// ditto
    public GLboolean IsSync (GLsync sync) const {
        assert(_IsSync !is null, "OpenGL command glIsSync was not loaded");
        return _IsSync (sync);
    }
    /// ditto
    public void DeleteSync (GLsync sync) const {
        assert(_DeleteSync !is null, "OpenGL command glDeleteSync was not loaded");
        return _DeleteSync (sync);
    }
    /// ditto
    public GLenum ClientWaitSync (GLsync sync, GLbitfield flags, GLuint64 timeout) const {
        assert(_ClientWaitSync !is null, "OpenGL command glClientWaitSync was not loaded");
        return _ClientWaitSync (sync, flags, timeout);
    }
    /// ditto
    public void WaitSync (GLsync sync, GLbitfield flags, GLuint64 timeout) const {
        assert(_WaitSync !is null, "OpenGL command glWaitSync was not loaded");
        return _WaitSync (sync, flags, timeout);
    }
    /// ditto
    public void GetInteger64v (GLenum pname, GLint64* data) const {
        assert(_GetInteger64v !is null, "OpenGL command glGetInteger64v was not loaded");
        return _GetInteger64v (pname, data);
    }
    /// ditto
    public void GetSynciv (GLsync sync, GLenum pname, GLsizei bufSize, GLsizei* length, GLint* values) const {
        assert(_GetSynciv !is null, "OpenGL command glGetSynciv was not loaded");
        return _GetSynciv (sync, pname, bufSize, length, values);
    }
    /// ditto
    public void GetInteger64i_v (GLenum target, GLuint index, GLint64* data) const {
        assert(_GetInteger64i_v !is null, "OpenGL command glGetInteger64i_v was not loaded");
        return _GetInteger64i_v (target, index, data);
    }
    /// ditto
    public void GetBufferParameteri64v (GLenum target, GLenum pname, GLint64* params) const {
        assert(_GetBufferParameteri64v !is null, "OpenGL command glGetBufferParameteri64v was not loaded");
        return _GetBufferParameteri64v (target, pname, params);
    }
    /// ditto
    public void FramebufferTexture (GLenum target, GLenum attachment, GLuint texture, GLint level) const {
        assert(_FramebufferTexture !is null, "OpenGL command glFramebufferTexture was not loaded");
        return _FramebufferTexture (target, attachment, texture, level);
    }
    /// ditto
    public void TexImage2DMultisample (GLenum target, GLsizei samples, GLenum internalformat, GLsizei width, GLsizei height, GLboolean fixedsamplelocations) const {
        assert(_TexImage2DMultisample !is null, "OpenGL command glTexImage2DMultisample was not loaded");
        return _TexImage2DMultisample (target, samples, internalformat, width, height, fixedsamplelocations);
    }
    /// ditto
    public void TexImage3DMultisample (GLenum target, GLsizei samples, GLenum internalformat, GLsizei width, GLsizei height, GLsizei depth, GLboolean fixedsamplelocations) const {
        assert(_TexImage3DMultisample !is null, "OpenGL command glTexImage3DMultisample was not loaded");
        return _TexImage3DMultisample (target, samples, internalformat, width, height, depth, fixedsamplelocations);
    }
    /// ditto
    public void GetMultisamplefv (GLenum pname, GLuint index, GLfloat* val) const {
        assert(_GetMultisamplefv !is null, "OpenGL command glGetMultisamplefv was not loaded");
        return _GetMultisamplefv (pname, index, val);
    }
    /// ditto
    public void SampleMaski (GLuint maskNumber, GLbitfield mask) const {
        assert(_SampleMaski !is null, "OpenGL command glSampleMaski was not loaded");
        return _SampleMaski (maskNumber, mask);
    }

    /// Commands for GL_VERSION_3_3
    public void BindFragDataLocationIndexed (GLuint program, GLuint colorNumber, GLuint index, const(GLchar)* name) const {
        assert(_BindFragDataLocationIndexed !is null, "OpenGL command glBindFragDataLocationIndexed was not loaded");
        return _BindFragDataLocationIndexed (program, colorNumber, index, name);
    }
    /// ditto
    public GLint GetFragDataIndex (GLuint program, const(GLchar)* name) const {
        assert(_GetFragDataIndex !is null, "OpenGL command glGetFragDataIndex was not loaded");
        return _GetFragDataIndex (program, name);
    }
    /// ditto
    public void GenSamplers (GLsizei count, GLuint* samplers) const {
        assert(_GenSamplers !is null, "OpenGL command glGenSamplers was not loaded");
        return _GenSamplers (count, samplers);
    }
    /// ditto
    public void DeleteSamplers (GLsizei count, const(GLuint)* samplers) const {
        assert(_DeleteSamplers !is null, "OpenGL command glDeleteSamplers was not loaded");
        return _DeleteSamplers (count, samplers);
    }
    /// ditto
    public GLboolean IsSampler (GLuint sampler) const {
        assert(_IsSampler !is null, "OpenGL command glIsSampler was not loaded");
        return _IsSampler (sampler);
    }
    /// ditto
    public void BindSampler (GLuint unit, GLuint sampler) const {
        assert(_BindSampler !is null, "OpenGL command glBindSampler was not loaded");
        return _BindSampler (unit, sampler);
    }
    /// ditto
    public void SamplerParameteri (GLuint sampler, GLenum pname, GLint param) const {
        assert(_SamplerParameteri !is null, "OpenGL command glSamplerParameteri was not loaded");
        return _SamplerParameteri (sampler, pname, param);
    }
    /// ditto
    public void SamplerParameteriv (GLuint sampler, GLenum pname, const(GLint)* param) const {
        assert(_SamplerParameteriv !is null, "OpenGL command glSamplerParameteriv was not loaded");
        return _SamplerParameteriv (sampler, pname, param);
    }
    /// ditto
    public void SamplerParameterf (GLuint sampler, GLenum pname, GLfloat param) const {
        assert(_SamplerParameterf !is null, "OpenGL command glSamplerParameterf was not loaded");
        return _SamplerParameterf (sampler, pname, param);
    }
    /// ditto
    public void SamplerParameterfv (GLuint sampler, GLenum pname, const(GLfloat)* param) const {
        assert(_SamplerParameterfv !is null, "OpenGL command glSamplerParameterfv was not loaded");
        return _SamplerParameterfv (sampler, pname, param);
    }
    /// ditto
    public void SamplerParameterIiv (GLuint sampler, GLenum pname, const(GLint)* param) const {
        assert(_SamplerParameterIiv !is null, "OpenGL command glSamplerParameterIiv was not loaded");
        return _SamplerParameterIiv (sampler, pname, param);
    }
    /// ditto
    public void SamplerParameterIuiv (GLuint sampler, GLenum pname, const(GLuint)* param) const {
        assert(_SamplerParameterIuiv !is null, "OpenGL command glSamplerParameterIuiv was not loaded");
        return _SamplerParameterIuiv (sampler, pname, param);
    }
    /// ditto
    public void GetSamplerParameteriv (GLuint sampler, GLenum pname, GLint* params) const {
        assert(_GetSamplerParameteriv !is null, "OpenGL command glGetSamplerParameteriv was not loaded");
        return _GetSamplerParameteriv (sampler, pname, params);
    }
    /// ditto
    public void GetSamplerParameterIiv (GLuint sampler, GLenum pname, GLint* params) const {
        assert(_GetSamplerParameterIiv !is null, "OpenGL command glGetSamplerParameterIiv was not loaded");
        return _GetSamplerParameterIiv (sampler, pname, params);
    }
    /// ditto
    public void GetSamplerParameterfv (GLuint sampler, GLenum pname, GLfloat* params) const {
        assert(_GetSamplerParameterfv !is null, "OpenGL command glGetSamplerParameterfv was not loaded");
        return _GetSamplerParameterfv (sampler, pname, params);
    }
    /// ditto
    public void GetSamplerParameterIuiv (GLuint sampler, GLenum pname, GLuint* params) const {
        assert(_GetSamplerParameterIuiv !is null, "OpenGL command glGetSamplerParameterIuiv was not loaded");
        return _GetSamplerParameterIuiv (sampler, pname, params);
    }
    /// ditto
    public void QueryCounter (GLuint id, GLenum target) const {
        assert(_QueryCounter !is null, "OpenGL command glQueryCounter was not loaded");
        return _QueryCounter (id, target);
    }
    /// ditto
    public void GetQueryObjecti64v (GLuint id, GLenum pname, GLint64* params) const {
        assert(_GetQueryObjecti64v !is null, "OpenGL command glGetQueryObjecti64v was not loaded");
        return _GetQueryObjecti64v (id, pname, params);
    }
    /// ditto
    public void GetQueryObjectui64v (GLuint id, GLenum pname, GLuint64* params) const {
        assert(_GetQueryObjectui64v !is null, "OpenGL command glGetQueryObjectui64v was not loaded");
        return _GetQueryObjectui64v (id, pname, params);
    }
    /// ditto
    public void VertexAttribDivisor (GLuint index, GLuint divisor) const {
        assert(_VertexAttribDivisor !is null, "OpenGL command glVertexAttribDivisor was not loaded");
        return _VertexAttribDivisor (index, divisor);
    }
    /// ditto
    public void VertexAttribP1ui (GLuint index, GLenum type, GLboolean normalized, GLuint value) const {
        assert(_VertexAttribP1ui !is null, "OpenGL command glVertexAttribP1ui was not loaded");
        return _VertexAttribP1ui (index, type, normalized, value);
    }
    /// ditto
    public void VertexAttribP1uiv (GLuint index, GLenum type, GLboolean normalized, const(GLuint)* value) const {
        assert(_VertexAttribP1uiv !is null, "OpenGL command glVertexAttribP1uiv was not loaded");
        return _VertexAttribP1uiv (index, type, normalized, value);
    }
    /// ditto
    public void VertexAttribP2ui (GLuint index, GLenum type, GLboolean normalized, GLuint value) const {
        assert(_VertexAttribP2ui !is null, "OpenGL command glVertexAttribP2ui was not loaded");
        return _VertexAttribP2ui (index, type, normalized, value);
    }
    /// ditto
    public void VertexAttribP2uiv (GLuint index, GLenum type, GLboolean normalized, const(GLuint)* value) const {
        assert(_VertexAttribP2uiv !is null, "OpenGL command glVertexAttribP2uiv was not loaded");
        return _VertexAttribP2uiv (index, type, normalized, value);
    }
    /// ditto
    public void VertexAttribP3ui (GLuint index, GLenum type, GLboolean normalized, GLuint value) const {
        assert(_VertexAttribP3ui !is null, "OpenGL command glVertexAttribP3ui was not loaded");
        return _VertexAttribP3ui (index, type, normalized, value);
    }
    /// ditto
    public void VertexAttribP3uiv (GLuint index, GLenum type, GLboolean normalized, const(GLuint)* value) const {
        assert(_VertexAttribP3uiv !is null, "OpenGL command glVertexAttribP3uiv was not loaded");
        return _VertexAttribP3uiv (index, type, normalized, value);
    }
    /// ditto
    public void VertexAttribP4ui (GLuint index, GLenum type, GLboolean normalized, GLuint value) const {
        assert(_VertexAttribP4ui !is null, "OpenGL command glVertexAttribP4ui was not loaded");
        return _VertexAttribP4ui (index, type, normalized, value);
    }
    /// ditto
    public void VertexAttribP4uiv (GLuint index, GLenum type, GLboolean normalized, const(GLuint)* value) const {
        assert(_VertexAttribP4uiv !is null, "OpenGL command glVertexAttribP4uiv was not loaded");
        return _VertexAttribP4uiv (index, type, normalized, value);
    }

    /// Commands for GL_VERSION_4_0
    public void MinSampleShading (GLfloat value) const {
        assert(_MinSampleShading !is null, "OpenGL command glMinSampleShading was not loaded");
        return _MinSampleShading (value);
    }
    /// ditto
    public void BlendEquationi (GLuint buf, GLenum mode) const {
        assert(_BlendEquationi !is null, "OpenGL command glBlendEquationi was not loaded");
        return _BlendEquationi (buf, mode);
    }
    /// ditto
    public void BlendEquationSeparatei (GLuint buf, GLenum modeRGB, GLenum modeAlpha) const {
        assert(_BlendEquationSeparatei !is null, "OpenGL command glBlendEquationSeparatei was not loaded");
        return _BlendEquationSeparatei (buf, modeRGB, modeAlpha);
    }
    /// ditto
    public void BlendFunci (GLuint buf, GLenum src, GLenum dst) const {
        assert(_BlendFunci !is null, "OpenGL command glBlendFunci was not loaded");
        return _BlendFunci (buf, src, dst);
    }
    /// ditto
    public void BlendFuncSeparatei (GLuint buf, GLenum srcRGB, GLenum dstRGB, GLenum srcAlpha, GLenum dstAlpha) const {
        assert(_BlendFuncSeparatei !is null, "OpenGL command glBlendFuncSeparatei was not loaded");
        return _BlendFuncSeparatei (buf, srcRGB, dstRGB, srcAlpha, dstAlpha);
    }
    /// ditto
    public void DrawArraysIndirect (GLenum mode, const(void)* indirect) const {
        assert(_DrawArraysIndirect !is null, "OpenGL command glDrawArraysIndirect was not loaded");
        return _DrawArraysIndirect (mode, indirect);
    }
    /// ditto
    public void DrawElementsIndirect (GLenum mode, GLenum type, const(void)* indirect) const {
        assert(_DrawElementsIndirect !is null, "OpenGL command glDrawElementsIndirect was not loaded");
        return _DrawElementsIndirect (mode, type, indirect);
    }
    /// ditto
    public void Uniform1d (GLint location, GLdouble x) const {
        assert(_Uniform1d !is null, "OpenGL command glUniform1d was not loaded");
        return _Uniform1d (location, x);
    }
    /// ditto
    public void Uniform2d (GLint location, GLdouble x, GLdouble y) const {
        assert(_Uniform2d !is null, "OpenGL command glUniform2d was not loaded");
        return _Uniform2d (location, x, y);
    }
    /// ditto
    public void Uniform3d (GLint location, GLdouble x, GLdouble y, GLdouble z) const {
        assert(_Uniform3d !is null, "OpenGL command glUniform3d was not loaded");
        return _Uniform3d (location, x, y, z);
    }
    /// ditto
    public void Uniform4d (GLint location, GLdouble x, GLdouble y, GLdouble z, GLdouble w) const {
        assert(_Uniform4d !is null, "OpenGL command glUniform4d was not loaded");
        return _Uniform4d (location, x, y, z, w);
    }
    /// ditto
    public void Uniform1dv (GLint location, GLsizei count, const(GLdouble)* value) const {
        assert(_Uniform1dv !is null, "OpenGL command glUniform1dv was not loaded");
        return _Uniform1dv (location, count, value);
    }
    /// ditto
    public void Uniform2dv (GLint location, GLsizei count, const(GLdouble)* value) const {
        assert(_Uniform2dv !is null, "OpenGL command glUniform2dv was not loaded");
        return _Uniform2dv (location, count, value);
    }
    /// ditto
    public void Uniform3dv (GLint location, GLsizei count, const(GLdouble)* value) const {
        assert(_Uniform3dv !is null, "OpenGL command glUniform3dv was not loaded");
        return _Uniform3dv (location, count, value);
    }
    /// ditto
    public void Uniform4dv (GLint location, GLsizei count, const(GLdouble)* value) const {
        assert(_Uniform4dv !is null, "OpenGL command glUniform4dv was not loaded");
        return _Uniform4dv (location, count, value);
    }
    /// ditto
    public void UniformMatrix2dv (GLint location, GLsizei count, GLboolean transpose, const(GLdouble)* value) const {
        assert(_UniformMatrix2dv !is null, "OpenGL command glUniformMatrix2dv was not loaded");
        return _UniformMatrix2dv (location, count, transpose, value);
    }
    /// ditto
    public void UniformMatrix3dv (GLint location, GLsizei count, GLboolean transpose, const(GLdouble)* value) const {
        assert(_UniformMatrix3dv !is null, "OpenGL command glUniformMatrix3dv was not loaded");
        return _UniformMatrix3dv (location, count, transpose, value);
    }
    /// ditto
    public void UniformMatrix4dv (GLint location, GLsizei count, GLboolean transpose, const(GLdouble)* value) const {
        assert(_UniformMatrix4dv !is null, "OpenGL command glUniformMatrix4dv was not loaded");
        return _UniformMatrix4dv (location, count, transpose, value);
    }
    /// ditto
    public void UniformMatrix2x3dv (GLint location, GLsizei count, GLboolean transpose, const(GLdouble)* value) const {
        assert(_UniformMatrix2x3dv !is null, "OpenGL command glUniformMatrix2x3dv was not loaded");
        return _UniformMatrix2x3dv (location, count, transpose, value);
    }
    /// ditto
    public void UniformMatrix2x4dv (GLint location, GLsizei count, GLboolean transpose, const(GLdouble)* value) const {
        assert(_UniformMatrix2x4dv !is null, "OpenGL command glUniformMatrix2x4dv was not loaded");
        return _UniformMatrix2x4dv (location, count, transpose, value);
    }
    /// ditto
    public void UniformMatrix3x2dv (GLint location, GLsizei count, GLboolean transpose, const(GLdouble)* value) const {
        assert(_UniformMatrix3x2dv !is null, "OpenGL command glUniformMatrix3x2dv was not loaded");
        return _UniformMatrix3x2dv (location, count, transpose, value);
    }
    /// ditto
    public void UniformMatrix3x4dv (GLint location, GLsizei count, GLboolean transpose, const(GLdouble)* value) const {
        assert(_UniformMatrix3x4dv !is null, "OpenGL command glUniformMatrix3x4dv was not loaded");
        return _UniformMatrix3x4dv (location, count, transpose, value);
    }
    /// ditto
    public void UniformMatrix4x2dv (GLint location, GLsizei count, GLboolean transpose, const(GLdouble)* value) const {
        assert(_UniformMatrix4x2dv !is null, "OpenGL command glUniformMatrix4x2dv was not loaded");
        return _UniformMatrix4x2dv (location, count, transpose, value);
    }
    /// ditto
    public void UniformMatrix4x3dv (GLint location, GLsizei count, GLboolean transpose, const(GLdouble)* value) const {
        assert(_UniformMatrix4x3dv !is null, "OpenGL command glUniformMatrix4x3dv was not loaded");
        return _UniformMatrix4x3dv (location, count, transpose, value);
    }
    /// ditto
    public void GetUniformdv (GLuint program, GLint location, GLdouble* params) const {
        assert(_GetUniformdv !is null, "OpenGL command glGetUniformdv was not loaded");
        return _GetUniformdv (program, location, params);
    }
    /// ditto
    public GLint GetSubroutineUniformLocation (GLuint program, GLenum shadertype, const(GLchar)* name) const {
        assert(_GetSubroutineUniformLocation !is null, "OpenGL command glGetSubroutineUniformLocation was not loaded");
        return _GetSubroutineUniformLocation (program, shadertype, name);
    }
    /// ditto
    public GLuint GetSubroutineIndex (GLuint program, GLenum shadertype, const(GLchar)* name) const {
        assert(_GetSubroutineIndex !is null, "OpenGL command glGetSubroutineIndex was not loaded");
        return _GetSubroutineIndex (program, shadertype, name);
    }
    /// ditto
    public void GetActiveSubroutineUniformiv (GLuint program, GLenum shadertype, GLuint index, GLenum pname, GLint* values) const {
        assert(_GetActiveSubroutineUniformiv !is null, "OpenGL command glGetActiveSubroutineUniformiv was not loaded");
        return _GetActiveSubroutineUniformiv (program, shadertype, index, pname, values);
    }
    /// ditto
    public void GetActiveSubroutineUniformName (GLuint program, GLenum shadertype, GLuint index, GLsizei bufsize, GLsizei* length, GLchar* name) const {
        assert(_GetActiveSubroutineUniformName !is null, "OpenGL command glGetActiveSubroutineUniformName was not loaded");
        return _GetActiveSubroutineUniformName (program, shadertype, index, bufsize, length, name);
    }
    /// ditto
    public void GetActiveSubroutineName (GLuint program, GLenum shadertype, GLuint index, GLsizei bufsize, GLsizei* length, GLchar* name) const {
        assert(_GetActiveSubroutineName !is null, "OpenGL command glGetActiveSubroutineName was not loaded");
        return _GetActiveSubroutineName (program, shadertype, index, bufsize, length, name);
    }
    /// ditto
    public void UniformSubroutinesuiv (GLenum shadertype, GLsizei count, const(GLuint)* indices) const {
        assert(_UniformSubroutinesuiv !is null, "OpenGL command glUniformSubroutinesuiv was not loaded");
        return _UniformSubroutinesuiv (shadertype, count, indices);
    }
    /// ditto
    public void GetUniformSubroutineuiv (GLenum shadertype, GLint location, GLuint* params) const {
        assert(_GetUniformSubroutineuiv !is null, "OpenGL command glGetUniformSubroutineuiv was not loaded");
        return _GetUniformSubroutineuiv (shadertype, location, params);
    }
    /// ditto
    public void GetProgramStageiv (GLuint program, GLenum shadertype, GLenum pname, GLint* values) const {
        assert(_GetProgramStageiv !is null, "OpenGL command glGetProgramStageiv was not loaded");
        return _GetProgramStageiv (program, shadertype, pname, values);
    }
    /// ditto
    public void PatchParameteri (GLenum pname, GLint value) const {
        assert(_PatchParameteri !is null, "OpenGL command glPatchParameteri was not loaded");
        return _PatchParameteri (pname, value);
    }
    /// ditto
    public void PatchParameterfv (GLenum pname, const(GLfloat)* values) const {
        assert(_PatchParameterfv !is null, "OpenGL command glPatchParameterfv was not loaded");
        return _PatchParameterfv (pname, values);
    }
    /// ditto
    public void BindTransformFeedback (GLenum target, GLuint id) const {
        assert(_BindTransformFeedback !is null, "OpenGL command glBindTransformFeedback was not loaded");
        return _BindTransformFeedback (target, id);
    }
    /// ditto
    public void DeleteTransformFeedbacks (GLsizei n, const(GLuint)* ids) const {
        assert(_DeleteTransformFeedbacks !is null, "OpenGL command glDeleteTransformFeedbacks was not loaded");
        return _DeleteTransformFeedbacks (n, ids);
    }
    /// ditto
    public void GenTransformFeedbacks (GLsizei n, GLuint* ids) const {
        assert(_GenTransformFeedbacks !is null, "OpenGL command glGenTransformFeedbacks was not loaded");
        return _GenTransformFeedbacks (n, ids);
    }
    /// ditto
    public GLboolean IsTransformFeedback (GLuint id) const {
        assert(_IsTransformFeedback !is null, "OpenGL command glIsTransformFeedback was not loaded");
        return _IsTransformFeedback (id);
    }
    /// ditto
    public void PauseTransformFeedback () const {
        assert(_PauseTransformFeedback !is null, "OpenGL command glPauseTransformFeedback was not loaded");
        return _PauseTransformFeedback ();
    }
    /// ditto
    public void ResumeTransformFeedback () const {
        assert(_ResumeTransformFeedback !is null, "OpenGL command glResumeTransformFeedback was not loaded");
        return _ResumeTransformFeedback ();
    }
    /// ditto
    public void DrawTransformFeedback (GLenum mode, GLuint id) const {
        assert(_DrawTransformFeedback !is null, "OpenGL command glDrawTransformFeedback was not loaded");
        return _DrawTransformFeedback (mode, id);
    }
    /// ditto
    public void DrawTransformFeedbackStream (GLenum mode, GLuint id, GLuint stream) const {
        assert(_DrawTransformFeedbackStream !is null, "OpenGL command glDrawTransformFeedbackStream was not loaded");
        return _DrawTransformFeedbackStream (mode, id, stream);
    }
    /// ditto
    public void BeginQueryIndexed (GLenum target, GLuint index, GLuint id) const {
        assert(_BeginQueryIndexed !is null, "OpenGL command glBeginQueryIndexed was not loaded");
        return _BeginQueryIndexed (target, index, id);
    }
    /// ditto
    public void EndQueryIndexed (GLenum target, GLuint index) const {
        assert(_EndQueryIndexed !is null, "OpenGL command glEndQueryIndexed was not loaded");
        return _EndQueryIndexed (target, index);
    }
    /// ditto
    public void GetQueryIndexediv (GLenum target, GLuint index, GLenum pname, GLint* params) const {
        assert(_GetQueryIndexediv !is null, "OpenGL command glGetQueryIndexediv was not loaded");
        return _GetQueryIndexediv (target, index, pname, params);
    }

    /// Commands for GL_VERSION_4_1
    public void ReleaseShaderCompiler () const {
        assert(_ReleaseShaderCompiler !is null, "OpenGL command glReleaseShaderCompiler was not loaded");
        return _ReleaseShaderCompiler ();
    }
    /// ditto
    public void ShaderBinary (GLsizei count, const(GLuint)* shaders, GLenum binaryformat, const(void)* binary, GLsizei length) const {
        assert(_ShaderBinary !is null, "OpenGL command glShaderBinary was not loaded");
        return _ShaderBinary (count, shaders, binaryformat, binary, length);
    }
    /// ditto
    public void GetShaderPrecisionFormat (GLenum shadertype, GLenum precisiontype, GLint* range, GLint* precision) const {
        assert(_GetShaderPrecisionFormat !is null, "OpenGL command glGetShaderPrecisionFormat was not loaded");
        return _GetShaderPrecisionFormat (shadertype, precisiontype, range, precision);
    }
    /// ditto
    public void DepthRangef (GLfloat n, GLfloat f) const {
        assert(_DepthRangef !is null, "OpenGL command glDepthRangef was not loaded");
        return _DepthRangef (n, f);
    }
    /// ditto
    public void ClearDepthf (GLfloat d) const {
        assert(_ClearDepthf !is null, "OpenGL command glClearDepthf was not loaded");
        return _ClearDepthf (d);
    }
    /// ditto
    public void GetProgramBinary (GLuint program, GLsizei bufSize, GLsizei* length, GLenum* binaryFormat, void* binary) const {
        assert(_GetProgramBinary !is null, "OpenGL command glGetProgramBinary was not loaded");
        return _GetProgramBinary (program, bufSize, length, binaryFormat, binary);
    }
    /// ditto
    public void ProgramBinary (GLuint program, GLenum binaryFormat, const(void)* binary, GLsizei length) const {
        assert(_ProgramBinary !is null, "OpenGL command glProgramBinary was not loaded");
        return _ProgramBinary (program, binaryFormat, binary, length);
    }
    /// ditto
    public void ProgramParameteri (GLuint program, GLenum pname, GLint value) const {
        assert(_ProgramParameteri !is null, "OpenGL command glProgramParameteri was not loaded");
        return _ProgramParameteri (program, pname, value);
    }
    /// ditto
    public void UseProgramStages (GLuint pipeline, GLbitfield stages, GLuint program) const {
        assert(_UseProgramStages !is null, "OpenGL command glUseProgramStages was not loaded");
        return _UseProgramStages (pipeline, stages, program);
    }
    /// ditto
    public void ActiveShaderProgram (GLuint pipeline, GLuint program) const {
        assert(_ActiveShaderProgram !is null, "OpenGL command glActiveShaderProgram was not loaded");
        return _ActiveShaderProgram (pipeline, program);
    }
    /// ditto
    public GLuint CreateShaderProgramv (GLenum type, GLsizei count, const(GLchar*)* strings) const {
        assert(_CreateShaderProgramv !is null, "OpenGL command glCreateShaderProgramv was not loaded");
        return _CreateShaderProgramv (type, count, strings);
    }
    /// ditto
    public void BindProgramPipeline (GLuint pipeline) const {
        assert(_BindProgramPipeline !is null, "OpenGL command glBindProgramPipeline was not loaded");
        return _BindProgramPipeline (pipeline);
    }
    /// ditto
    public void DeleteProgramPipelines (GLsizei n, const(GLuint)* pipelines) const {
        assert(_DeleteProgramPipelines !is null, "OpenGL command glDeleteProgramPipelines was not loaded");
        return _DeleteProgramPipelines (n, pipelines);
    }
    /// ditto
    public void GenProgramPipelines (GLsizei n, GLuint* pipelines) const {
        assert(_GenProgramPipelines !is null, "OpenGL command glGenProgramPipelines was not loaded");
        return _GenProgramPipelines (n, pipelines);
    }
    /// ditto
    public GLboolean IsProgramPipeline (GLuint pipeline) const {
        assert(_IsProgramPipeline !is null, "OpenGL command glIsProgramPipeline was not loaded");
        return _IsProgramPipeline (pipeline);
    }
    /// ditto
    public void GetProgramPipelineiv (GLuint pipeline, GLenum pname, GLint* params) const {
        assert(_GetProgramPipelineiv !is null, "OpenGL command glGetProgramPipelineiv was not loaded");
        return _GetProgramPipelineiv (pipeline, pname, params);
    }
    /// ditto
    public void ProgramUniform1i (GLuint program, GLint location, GLint v0) const {
        assert(_ProgramUniform1i !is null, "OpenGL command glProgramUniform1i was not loaded");
        return _ProgramUniform1i (program, location, v0);
    }
    /// ditto
    public void ProgramUniform1iv (GLuint program, GLint location, GLsizei count, const(GLint)* value) const {
        assert(_ProgramUniform1iv !is null, "OpenGL command glProgramUniform1iv was not loaded");
        return _ProgramUniform1iv (program, location, count, value);
    }
    /// ditto
    public void ProgramUniform1f (GLuint program, GLint location, GLfloat v0) const {
        assert(_ProgramUniform1f !is null, "OpenGL command glProgramUniform1f was not loaded");
        return _ProgramUniform1f (program, location, v0);
    }
    /// ditto
    public void ProgramUniform1fv (GLuint program, GLint location, GLsizei count, const(GLfloat)* value) const {
        assert(_ProgramUniform1fv !is null, "OpenGL command glProgramUniform1fv was not loaded");
        return _ProgramUniform1fv (program, location, count, value);
    }
    /// ditto
    public void ProgramUniform1d (GLuint program, GLint location, GLdouble v0) const {
        assert(_ProgramUniform1d !is null, "OpenGL command glProgramUniform1d was not loaded");
        return _ProgramUniform1d (program, location, v0);
    }
    /// ditto
    public void ProgramUniform1dv (GLuint program, GLint location, GLsizei count, const(GLdouble)* value) const {
        assert(_ProgramUniform1dv !is null, "OpenGL command glProgramUniform1dv was not loaded");
        return _ProgramUniform1dv (program, location, count, value);
    }
    /// ditto
    public void ProgramUniform1ui (GLuint program, GLint location, GLuint v0) const {
        assert(_ProgramUniform1ui !is null, "OpenGL command glProgramUniform1ui was not loaded");
        return _ProgramUniform1ui (program, location, v0);
    }
    /// ditto
    public void ProgramUniform1uiv (GLuint program, GLint location, GLsizei count, const(GLuint)* value) const {
        assert(_ProgramUniform1uiv !is null, "OpenGL command glProgramUniform1uiv was not loaded");
        return _ProgramUniform1uiv (program, location, count, value);
    }
    /// ditto
    public void ProgramUniform2i (GLuint program, GLint location, GLint v0, GLint v1) const {
        assert(_ProgramUniform2i !is null, "OpenGL command glProgramUniform2i was not loaded");
        return _ProgramUniform2i (program, location, v0, v1);
    }
    /// ditto
    public void ProgramUniform2iv (GLuint program, GLint location, GLsizei count, const(GLint)* value) const {
        assert(_ProgramUniform2iv !is null, "OpenGL command glProgramUniform2iv was not loaded");
        return _ProgramUniform2iv (program, location, count, value);
    }
    /// ditto
    public void ProgramUniform2f (GLuint program, GLint location, GLfloat v0, GLfloat v1) const {
        assert(_ProgramUniform2f !is null, "OpenGL command glProgramUniform2f was not loaded");
        return _ProgramUniform2f (program, location, v0, v1);
    }
    /// ditto
    public void ProgramUniform2fv (GLuint program, GLint location, GLsizei count, const(GLfloat)* value) const {
        assert(_ProgramUniform2fv !is null, "OpenGL command glProgramUniform2fv was not loaded");
        return _ProgramUniform2fv (program, location, count, value);
    }
    /// ditto
    public void ProgramUniform2d (GLuint program, GLint location, GLdouble v0, GLdouble v1) const {
        assert(_ProgramUniform2d !is null, "OpenGL command glProgramUniform2d was not loaded");
        return _ProgramUniform2d (program, location, v0, v1);
    }
    /// ditto
    public void ProgramUniform2dv (GLuint program, GLint location, GLsizei count, const(GLdouble)* value) const {
        assert(_ProgramUniform2dv !is null, "OpenGL command glProgramUniform2dv was not loaded");
        return _ProgramUniform2dv (program, location, count, value);
    }
    /// ditto
    public void ProgramUniform2ui (GLuint program, GLint location, GLuint v0, GLuint v1) const {
        assert(_ProgramUniform2ui !is null, "OpenGL command glProgramUniform2ui was not loaded");
        return _ProgramUniform2ui (program, location, v0, v1);
    }
    /// ditto
    public void ProgramUniform2uiv (GLuint program, GLint location, GLsizei count, const(GLuint)* value) const {
        assert(_ProgramUniform2uiv !is null, "OpenGL command glProgramUniform2uiv was not loaded");
        return _ProgramUniform2uiv (program, location, count, value);
    }
    /// ditto
    public void ProgramUniform3i (GLuint program, GLint location, GLint v0, GLint v1, GLint v2) const {
        assert(_ProgramUniform3i !is null, "OpenGL command glProgramUniform3i was not loaded");
        return _ProgramUniform3i (program, location, v0, v1, v2);
    }
    /// ditto
    public void ProgramUniform3iv (GLuint program, GLint location, GLsizei count, const(GLint)* value) const {
        assert(_ProgramUniform3iv !is null, "OpenGL command glProgramUniform3iv was not loaded");
        return _ProgramUniform3iv (program, location, count, value);
    }
    /// ditto
    public void ProgramUniform3f (GLuint program, GLint location, GLfloat v0, GLfloat v1, GLfloat v2) const {
        assert(_ProgramUniform3f !is null, "OpenGL command glProgramUniform3f was not loaded");
        return _ProgramUniform3f (program, location, v0, v1, v2);
    }
    /// ditto
    public void ProgramUniform3fv (GLuint program, GLint location, GLsizei count, const(GLfloat)* value) const {
        assert(_ProgramUniform3fv !is null, "OpenGL command glProgramUniform3fv was not loaded");
        return _ProgramUniform3fv (program, location, count, value);
    }
    /// ditto
    public void ProgramUniform3d (GLuint program, GLint location, GLdouble v0, GLdouble v1, GLdouble v2) const {
        assert(_ProgramUniform3d !is null, "OpenGL command glProgramUniform3d was not loaded");
        return _ProgramUniform3d (program, location, v0, v1, v2);
    }
    /// ditto
    public void ProgramUniform3dv (GLuint program, GLint location, GLsizei count, const(GLdouble)* value) const {
        assert(_ProgramUniform3dv !is null, "OpenGL command glProgramUniform3dv was not loaded");
        return _ProgramUniform3dv (program, location, count, value);
    }
    /// ditto
    public void ProgramUniform3ui (GLuint program, GLint location, GLuint v0, GLuint v1, GLuint v2) const {
        assert(_ProgramUniform3ui !is null, "OpenGL command glProgramUniform3ui was not loaded");
        return _ProgramUniform3ui (program, location, v0, v1, v2);
    }
    /// ditto
    public void ProgramUniform3uiv (GLuint program, GLint location, GLsizei count, const(GLuint)* value) const {
        assert(_ProgramUniform3uiv !is null, "OpenGL command glProgramUniform3uiv was not loaded");
        return _ProgramUniform3uiv (program, location, count, value);
    }
    /// ditto
    public void ProgramUniform4i (GLuint program, GLint location, GLint v0, GLint v1, GLint v2, GLint v3) const {
        assert(_ProgramUniform4i !is null, "OpenGL command glProgramUniform4i was not loaded");
        return _ProgramUniform4i (program, location, v0, v1, v2, v3);
    }
    /// ditto
    public void ProgramUniform4iv (GLuint program, GLint location, GLsizei count, const(GLint)* value) const {
        assert(_ProgramUniform4iv !is null, "OpenGL command glProgramUniform4iv was not loaded");
        return _ProgramUniform4iv (program, location, count, value);
    }
    /// ditto
    public void ProgramUniform4f (GLuint program, GLint location, GLfloat v0, GLfloat v1, GLfloat v2, GLfloat v3) const {
        assert(_ProgramUniform4f !is null, "OpenGL command glProgramUniform4f was not loaded");
        return _ProgramUniform4f (program, location, v0, v1, v2, v3);
    }
    /// ditto
    public void ProgramUniform4fv (GLuint program, GLint location, GLsizei count, const(GLfloat)* value) const {
        assert(_ProgramUniform4fv !is null, "OpenGL command glProgramUniform4fv was not loaded");
        return _ProgramUniform4fv (program, location, count, value);
    }
    /// ditto
    public void ProgramUniform4d (GLuint program, GLint location, GLdouble v0, GLdouble v1, GLdouble v2, GLdouble v3) const {
        assert(_ProgramUniform4d !is null, "OpenGL command glProgramUniform4d was not loaded");
        return _ProgramUniform4d (program, location, v0, v1, v2, v3);
    }
    /// ditto
    public void ProgramUniform4dv (GLuint program, GLint location, GLsizei count, const(GLdouble)* value) const {
        assert(_ProgramUniform4dv !is null, "OpenGL command glProgramUniform4dv was not loaded");
        return _ProgramUniform4dv (program, location, count, value);
    }
    /// ditto
    public void ProgramUniform4ui (GLuint program, GLint location, GLuint v0, GLuint v1, GLuint v2, GLuint v3) const {
        assert(_ProgramUniform4ui !is null, "OpenGL command glProgramUniform4ui was not loaded");
        return _ProgramUniform4ui (program, location, v0, v1, v2, v3);
    }
    /// ditto
    public void ProgramUniform4uiv (GLuint program, GLint location, GLsizei count, const(GLuint)* value) const {
        assert(_ProgramUniform4uiv !is null, "OpenGL command glProgramUniform4uiv was not loaded");
        return _ProgramUniform4uiv (program, location, count, value);
    }
    /// ditto
    public void ProgramUniformMatrix2fv (GLuint program, GLint location, GLsizei count, GLboolean transpose, const(GLfloat)* value) const {
        assert(_ProgramUniformMatrix2fv !is null, "OpenGL command glProgramUniformMatrix2fv was not loaded");
        return _ProgramUniformMatrix2fv (program, location, count, transpose, value);
    }
    /// ditto
    public void ProgramUniformMatrix3fv (GLuint program, GLint location, GLsizei count, GLboolean transpose, const(GLfloat)* value) const {
        assert(_ProgramUniformMatrix3fv !is null, "OpenGL command glProgramUniformMatrix3fv was not loaded");
        return _ProgramUniformMatrix3fv (program, location, count, transpose, value);
    }
    /// ditto
    public void ProgramUniformMatrix4fv (GLuint program, GLint location, GLsizei count, GLboolean transpose, const(GLfloat)* value) const {
        assert(_ProgramUniformMatrix4fv !is null, "OpenGL command glProgramUniformMatrix4fv was not loaded");
        return _ProgramUniformMatrix4fv (program, location, count, transpose, value);
    }
    /// ditto
    public void ProgramUniformMatrix2dv (GLuint program, GLint location, GLsizei count, GLboolean transpose, const(GLdouble)* value) const {
        assert(_ProgramUniformMatrix2dv !is null, "OpenGL command glProgramUniformMatrix2dv was not loaded");
        return _ProgramUniformMatrix2dv (program, location, count, transpose, value);
    }
    /// ditto
    public void ProgramUniformMatrix3dv (GLuint program, GLint location, GLsizei count, GLboolean transpose, const(GLdouble)* value) const {
        assert(_ProgramUniformMatrix3dv !is null, "OpenGL command glProgramUniformMatrix3dv was not loaded");
        return _ProgramUniformMatrix3dv (program, location, count, transpose, value);
    }
    /// ditto
    public void ProgramUniformMatrix4dv (GLuint program, GLint location, GLsizei count, GLboolean transpose, const(GLdouble)* value) const {
        assert(_ProgramUniformMatrix4dv !is null, "OpenGL command glProgramUniformMatrix4dv was not loaded");
        return _ProgramUniformMatrix4dv (program, location, count, transpose, value);
    }
    /// ditto
    public void ProgramUniformMatrix2x3fv (GLuint program, GLint location, GLsizei count, GLboolean transpose, const(GLfloat)* value) const {
        assert(_ProgramUniformMatrix2x3fv !is null, "OpenGL command glProgramUniformMatrix2x3fv was not loaded");
        return _ProgramUniformMatrix2x3fv (program, location, count, transpose, value);
    }
    /// ditto
    public void ProgramUniformMatrix3x2fv (GLuint program, GLint location, GLsizei count, GLboolean transpose, const(GLfloat)* value) const {
        assert(_ProgramUniformMatrix3x2fv !is null, "OpenGL command glProgramUniformMatrix3x2fv was not loaded");
        return _ProgramUniformMatrix3x2fv (program, location, count, transpose, value);
    }
    /// ditto
    public void ProgramUniformMatrix2x4fv (GLuint program, GLint location, GLsizei count, GLboolean transpose, const(GLfloat)* value) const {
        assert(_ProgramUniformMatrix2x4fv !is null, "OpenGL command glProgramUniformMatrix2x4fv was not loaded");
        return _ProgramUniformMatrix2x4fv (program, location, count, transpose, value);
    }
    /// ditto
    public void ProgramUniformMatrix4x2fv (GLuint program, GLint location, GLsizei count, GLboolean transpose, const(GLfloat)* value) const {
        assert(_ProgramUniformMatrix4x2fv !is null, "OpenGL command glProgramUniformMatrix4x2fv was not loaded");
        return _ProgramUniformMatrix4x2fv (program, location, count, transpose, value);
    }
    /// ditto
    public void ProgramUniformMatrix3x4fv (GLuint program, GLint location, GLsizei count, GLboolean transpose, const(GLfloat)* value) const {
        assert(_ProgramUniformMatrix3x4fv !is null, "OpenGL command glProgramUniformMatrix3x4fv was not loaded");
        return _ProgramUniformMatrix3x4fv (program, location, count, transpose, value);
    }
    /// ditto
    public void ProgramUniformMatrix4x3fv (GLuint program, GLint location, GLsizei count, GLboolean transpose, const(GLfloat)* value) const {
        assert(_ProgramUniformMatrix4x3fv !is null, "OpenGL command glProgramUniformMatrix4x3fv was not loaded");
        return _ProgramUniformMatrix4x3fv (program, location, count, transpose, value);
    }
    /// ditto
    public void ProgramUniformMatrix2x3dv (GLuint program, GLint location, GLsizei count, GLboolean transpose, const(GLdouble)* value) const {
        assert(_ProgramUniformMatrix2x3dv !is null, "OpenGL command glProgramUniformMatrix2x3dv was not loaded");
        return _ProgramUniformMatrix2x3dv (program, location, count, transpose, value);
    }
    /// ditto
    public void ProgramUniformMatrix3x2dv (GLuint program, GLint location, GLsizei count, GLboolean transpose, const(GLdouble)* value) const {
        assert(_ProgramUniformMatrix3x2dv !is null, "OpenGL command glProgramUniformMatrix3x2dv was not loaded");
        return _ProgramUniformMatrix3x2dv (program, location, count, transpose, value);
    }
    /// ditto
    public void ProgramUniformMatrix2x4dv (GLuint program, GLint location, GLsizei count, GLboolean transpose, const(GLdouble)* value) const {
        assert(_ProgramUniformMatrix2x4dv !is null, "OpenGL command glProgramUniformMatrix2x4dv was not loaded");
        return _ProgramUniformMatrix2x4dv (program, location, count, transpose, value);
    }
    /// ditto
    public void ProgramUniformMatrix4x2dv (GLuint program, GLint location, GLsizei count, GLboolean transpose, const(GLdouble)* value) const {
        assert(_ProgramUniformMatrix4x2dv !is null, "OpenGL command glProgramUniformMatrix4x2dv was not loaded");
        return _ProgramUniformMatrix4x2dv (program, location, count, transpose, value);
    }
    /// ditto
    public void ProgramUniformMatrix3x4dv (GLuint program, GLint location, GLsizei count, GLboolean transpose, const(GLdouble)* value) const {
        assert(_ProgramUniformMatrix3x4dv !is null, "OpenGL command glProgramUniformMatrix3x4dv was not loaded");
        return _ProgramUniformMatrix3x4dv (program, location, count, transpose, value);
    }
    /// ditto
    public void ProgramUniformMatrix4x3dv (GLuint program, GLint location, GLsizei count, GLboolean transpose, const(GLdouble)* value) const {
        assert(_ProgramUniformMatrix4x3dv !is null, "OpenGL command glProgramUniformMatrix4x3dv was not loaded");
        return _ProgramUniformMatrix4x3dv (program, location, count, transpose, value);
    }
    /// ditto
    public void ValidateProgramPipeline (GLuint pipeline) const {
        assert(_ValidateProgramPipeline !is null, "OpenGL command glValidateProgramPipeline was not loaded");
        return _ValidateProgramPipeline (pipeline);
    }
    /// ditto
    public void GetProgramPipelineInfoLog (GLuint pipeline, GLsizei bufSize, GLsizei* length, GLchar* infoLog) const {
        assert(_GetProgramPipelineInfoLog !is null, "OpenGL command glGetProgramPipelineInfoLog was not loaded");
        return _GetProgramPipelineInfoLog (pipeline, bufSize, length, infoLog);
    }
    /// ditto
    public void VertexAttribL1d (GLuint index, GLdouble x) const {
        assert(_VertexAttribL1d !is null, "OpenGL command glVertexAttribL1d was not loaded");
        return _VertexAttribL1d (index, x);
    }
    /// ditto
    public void VertexAttribL2d (GLuint index, GLdouble x, GLdouble y) const {
        assert(_VertexAttribL2d !is null, "OpenGL command glVertexAttribL2d was not loaded");
        return _VertexAttribL2d (index, x, y);
    }
    /// ditto
    public void VertexAttribL3d (GLuint index, GLdouble x, GLdouble y, GLdouble z) const {
        assert(_VertexAttribL3d !is null, "OpenGL command glVertexAttribL3d was not loaded");
        return _VertexAttribL3d (index, x, y, z);
    }
    /// ditto
    public void VertexAttribL4d (GLuint index, GLdouble x, GLdouble y, GLdouble z, GLdouble w) const {
        assert(_VertexAttribL4d !is null, "OpenGL command glVertexAttribL4d was not loaded");
        return _VertexAttribL4d (index, x, y, z, w);
    }
    /// ditto
    public void VertexAttribL1dv (GLuint index, const(GLdouble)* v) const {
        assert(_VertexAttribL1dv !is null, "OpenGL command glVertexAttribL1dv was not loaded");
        return _VertexAttribL1dv (index, v);
    }
    /// ditto
    public void VertexAttribL2dv (GLuint index, const(GLdouble)* v) const {
        assert(_VertexAttribL2dv !is null, "OpenGL command glVertexAttribL2dv was not loaded");
        return _VertexAttribL2dv (index, v);
    }
    /// ditto
    public void VertexAttribL3dv (GLuint index, const(GLdouble)* v) const {
        assert(_VertexAttribL3dv !is null, "OpenGL command glVertexAttribL3dv was not loaded");
        return _VertexAttribL3dv (index, v);
    }
    /// ditto
    public void VertexAttribL4dv (GLuint index, const(GLdouble)* v) const {
        assert(_VertexAttribL4dv !is null, "OpenGL command glVertexAttribL4dv was not loaded");
        return _VertexAttribL4dv (index, v);
    }
    /// ditto
    public void VertexAttribLPointer (GLuint index, GLint size, GLenum type, GLsizei stride, const(void)* pointer) const {
        assert(_VertexAttribLPointer !is null, "OpenGL command glVertexAttribLPointer was not loaded");
        return _VertexAttribLPointer (index, size, type, stride, pointer);
    }
    /// ditto
    public void GetVertexAttribLdv (GLuint index, GLenum pname, GLdouble* params) const {
        assert(_GetVertexAttribLdv !is null, "OpenGL command glGetVertexAttribLdv was not loaded");
        return _GetVertexAttribLdv (index, pname, params);
    }
    /// ditto
    public void ViewportArrayv (GLuint first, GLsizei count, const(GLfloat)* v) const {
        assert(_ViewportArrayv !is null, "OpenGL command glViewportArrayv was not loaded");
        return _ViewportArrayv (first, count, v);
    }
    /// ditto
    public void ViewportIndexedf (GLuint index, GLfloat x, GLfloat y, GLfloat w, GLfloat h) const {
        assert(_ViewportIndexedf !is null, "OpenGL command glViewportIndexedf was not loaded");
        return _ViewportIndexedf (index, x, y, w, h);
    }
    /// ditto
    public void ViewportIndexedfv (GLuint index, const(GLfloat)* v) const {
        assert(_ViewportIndexedfv !is null, "OpenGL command glViewportIndexedfv was not loaded");
        return _ViewportIndexedfv (index, v);
    }
    /// ditto
    public void ScissorArrayv (GLuint first, GLsizei count, const(GLint)* v) const {
        assert(_ScissorArrayv !is null, "OpenGL command glScissorArrayv was not loaded");
        return _ScissorArrayv (first, count, v);
    }
    /// ditto
    public void ScissorIndexed (GLuint index, GLint left, GLint bottom, GLsizei width, GLsizei height) const {
        assert(_ScissorIndexed !is null, "OpenGL command glScissorIndexed was not loaded");
        return _ScissorIndexed (index, left, bottom, width, height);
    }
    /// ditto
    public void ScissorIndexedv (GLuint index, const(GLint)* v) const {
        assert(_ScissorIndexedv !is null, "OpenGL command glScissorIndexedv was not loaded");
        return _ScissorIndexedv (index, v);
    }
    /// ditto
    public void DepthRangeArrayv (GLuint first, GLsizei count, const(GLdouble)* v) const {
        assert(_DepthRangeArrayv !is null, "OpenGL command glDepthRangeArrayv was not loaded");
        return _DepthRangeArrayv (first, count, v);
    }
    /// ditto
    public void DepthRangeIndexed (GLuint index, GLdouble n, GLdouble f) const {
        assert(_DepthRangeIndexed !is null, "OpenGL command glDepthRangeIndexed was not loaded");
        return _DepthRangeIndexed (index, n, f);
    }
    /// ditto
    public void GetFloati_v (GLenum target, GLuint index, GLfloat* data) const {
        assert(_GetFloati_v !is null, "OpenGL command glGetFloati_v was not loaded");
        return _GetFloati_v (target, index, data);
    }
    /// ditto
    public void GetDoublei_v (GLenum target, GLuint index, GLdouble* data) const {
        assert(_GetDoublei_v !is null, "OpenGL command glGetDoublei_v was not loaded");
        return _GetDoublei_v (target, index, data);
    }

    /// Commands for GL_VERSION_4_2
    public void DrawArraysInstancedBaseInstance (GLenum mode, GLint first, GLsizei count, GLsizei instancecount, GLuint baseinstance) const {
        assert(_DrawArraysInstancedBaseInstance !is null, "OpenGL command glDrawArraysInstancedBaseInstance was not loaded");
        return _DrawArraysInstancedBaseInstance (mode, first, count, instancecount, baseinstance);
    }
    /// ditto
    public void DrawElementsInstancedBaseInstance (GLenum mode, GLsizei count, GLenum type, const(void)* indices, GLsizei instancecount, GLuint baseinstance) const {
        assert(_DrawElementsInstancedBaseInstance !is null, "OpenGL command glDrawElementsInstancedBaseInstance was not loaded");
        return _DrawElementsInstancedBaseInstance (mode, count, type, indices, instancecount, baseinstance);
    }
    /// ditto
    public void DrawElementsInstancedBaseVertexBaseInstance (GLenum mode, GLsizei count, GLenum type, const(void)* indices, GLsizei instancecount, GLint basevertex, GLuint baseinstance) const {
        assert(_DrawElementsInstancedBaseVertexBaseInstance !is null, "OpenGL command glDrawElementsInstancedBaseVertexBaseInstance was not loaded");
        return _DrawElementsInstancedBaseVertexBaseInstance (mode, count, type, indices, instancecount, basevertex, baseinstance);
    }
    /// ditto
    public void GetInternalformativ (GLenum target, GLenum internalformat, GLenum pname, GLsizei bufSize, GLint* params) const {
        assert(_GetInternalformativ !is null, "OpenGL command glGetInternalformativ was not loaded");
        return _GetInternalformativ (target, internalformat, pname, bufSize, params);
    }
    /// ditto
    public void GetActiveAtomicCounterBufferiv (GLuint program, GLuint bufferIndex, GLenum pname, GLint* params) const {
        assert(_GetActiveAtomicCounterBufferiv !is null, "OpenGL command glGetActiveAtomicCounterBufferiv was not loaded");
        return _GetActiveAtomicCounterBufferiv (program, bufferIndex, pname, params);
    }
    /// ditto
    public void BindImageTexture (GLuint unit, GLuint texture, GLint level, GLboolean layered, GLint layer, GLenum access, GLenum format) const {
        assert(_BindImageTexture !is null, "OpenGL command glBindImageTexture was not loaded");
        return _BindImageTexture (unit, texture, level, layered, layer, access, format);
    }
    /// ditto
    public void MemoryBarrier (GLbitfield barriers) const {
        assert(_MemoryBarrier !is null, "OpenGL command glMemoryBarrier was not loaded");
        return _MemoryBarrier (barriers);
    }
    /// ditto
    public void TexStorage1D (GLenum target, GLsizei levels, GLenum internalformat, GLsizei width) const {
        assert(_TexStorage1D !is null, "OpenGL command glTexStorage1D was not loaded");
        return _TexStorage1D (target, levels, internalformat, width);
    }
    /// ditto
    public void TexStorage2D (GLenum target, GLsizei levels, GLenum internalformat, GLsizei width, GLsizei height) const {
        assert(_TexStorage2D !is null, "OpenGL command glTexStorage2D was not loaded");
        return _TexStorage2D (target, levels, internalformat, width, height);
    }
    /// ditto
    public void TexStorage3D (GLenum target, GLsizei levels, GLenum internalformat, GLsizei width, GLsizei height, GLsizei depth) const {
        assert(_TexStorage3D !is null, "OpenGL command glTexStorage3D was not loaded");
        return _TexStorage3D (target, levels, internalformat, width, height, depth);
    }
    /// ditto
    public void DrawTransformFeedbackInstanced (GLenum mode, GLuint id, GLsizei instancecount) const {
        assert(_DrawTransformFeedbackInstanced !is null, "OpenGL command glDrawTransformFeedbackInstanced was not loaded");
        return _DrawTransformFeedbackInstanced (mode, id, instancecount);
    }
    /// ditto
    public void DrawTransformFeedbackStreamInstanced (GLenum mode, GLuint id, GLuint stream, GLsizei instancecount) const {
        assert(_DrawTransformFeedbackStreamInstanced !is null, "OpenGL command glDrawTransformFeedbackStreamInstanced was not loaded");
        return _DrawTransformFeedbackStreamInstanced (mode, id, stream, instancecount);
    }

    /// Commands for GL_VERSION_4_3
    public void ClearBufferData (GLenum target, GLenum internalformat, GLenum format, GLenum type, const(void)* data) const {
        assert(_ClearBufferData !is null, "OpenGL command glClearBufferData was not loaded");
        return _ClearBufferData (target, internalformat, format, type, data);
    }
    /// ditto
    public void ClearBufferSubData (GLenum target, GLenum internalformat, GLintptr offset, GLsizeiptr size, GLenum format, GLenum type, const(void)* data) const {
        assert(_ClearBufferSubData !is null, "OpenGL command glClearBufferSubData was not loaded");
        return _ClearBufferSubData (target, internalformat, offset, size, format, type, data);
    }
    /// ditto
    public void DispatchCompute (GLuint num_groups_x, GLuint num_groups_y, GLuint num_groups_z) const {
        assert(_DispatchCompute !is null, "OpenGL command glDispatchCompute was not loaded");
        return _DispatchCompute (num_groups_x, num_groups_y, num_groups_z);
    }
    /// ditto
    public void DispatchComputeIndirect (GLintptr indirect) const {
        assert(_DispatchComputeIndirect !is null, "OpenGL command glDispatchComputeIndirect was not loaded");
        return _DispatchComputeIndirect (indirect);
    }
    /// ditto
    public void CopyImageSubData (GLuint srcName, GLenum srcTarget, GLint srcLevel, GLint srcX, GLint srcY, GLint srcZ, GLuint dstName, GLenum dstTarget, GLint dstLevel, GLint dstX, GLint dstY, GLint dstZ, GLsizei srcWidth, GLsizei srcHeight, GLsizei srcDepth) const {
        assert(_CopyImageSubData !is null, "OpenGL command glCopyImageSubData was not loaded");
        return _CopyImageSubData (srcName, srcTarget, srcLevel, srcX, srcY, srcZ, dstName, dstTarget, dstLevel, dstX, dstY, dstZ, srcWidth, srcHeight, srcDepth);
    }
    /// ditto
    public void FramebufferParameteri (GLenum target, GLenum pname, GLint param) const {
        assert(_FramebufferParameteri !is null, "OpenGL command glFramebufferParameteri was not loaded");
        return _FramebufferParameteri (target, pname, param);
    }
    /// ditto
    public void GetFramebufferParameteriv (GLenum target, GLenum pname, GLint* params) const {
        assert(_GetFramebufferParameteriv !is null, "OpenGL command glGetFramebufferParameteriv was not loaded");
        return _GetFramebufferParameteriv (target, pname, params);
    }
    /// ditto
    public void GetInternalformati64v (GLenum target, GLenum internalformat, GLenum pname, GLsizei bufSize, GLint64* params) const {
        assert(_GetInternalformati64v !is null, "OpenGL command glGetInternalformati64v was not loaded");
        return _GetInternalformati64v (target, internalformat, pname, bufSize, params);
    }
    /// ditto
    public void InvalidateTexSubImage (GLuint texture, GLint level, GLint xoffset, GLint yoffset, GLint zoffset, GLsizei width, GLsizei height, GLsizei depth) const {
        assert(_InvalidateTexSubImage !is null, "OpenGL command glInvalidateTexSubImage was not loaded");
        return _InvalidateTexSubImage (texture, level, xoffset, yoffset, zoffset, width, height, depth);
    }
    /// ditto
    public void InvalidateTexImage (GLuint texture, GLint level) const {
        assert(_InvalidateTexImage !is null, "OpenGL command glInvalidateTexImage was not loaded");
        return _InvalidateTexImage (texture, level);
    }
    /// ditto
    public void InvalidateBufferSubData (GLuint buffer, GLintptr offset, GLsizeiptr length) const {
        assert(_InvalidateBufferSubData !is null, "OpenGL command glInvalidateBufferSubData was not loaded");
        return _InvalidateBufferSubData (buffer, offset, length);
    }
    /// ditto
    public void InvalidateBufferData (GLuint buffer) const {
        assert(_InvalidateBufferData !is null, "OpenGL command glInvalidateBufferData was not loaded");
        return _InvalidateBufferData (buffer);
    }
    /// ditto
    public void InvalidateFramebuffer (GLenum target, GLsizei numAttachments, const(GLenum)* attachments) const {
        assert(_InvalidateFramebuffer !is null, "OpenGL command glInvalidateFramebuffer was not loaded");
        return _InvalidateFramebuffer (target, numAttachments, attachments);
    }
    /// ditto
    public void InvalidateSubFramebuffer (GLenum target, GLsizei numAttachments, const(GLenum)* attachments, GLint x, GLint y, GLsizei width, GLsizei height) const {
        assert(_InvalidateSubFramebuffer !is null, "OpenGL command glInvalidateSubFramebuffer was not loaded");
        return _InvalidateSubFramebuffer (target, numAttachments, attachments, x, y, width, height);
    }
    /// ditto
    public void MultiDrawArraysIndirect (GLenum mode, const(void)* indirect, GLsizei drawcount, GLsizei stride) const {
        assert(_MultiDrawArraysIndirect !is null, "OpenGL command glMultiDrawArraysIndirect was not loaded");
        return _MultiDrawArraysIndirect (mode, indirect, drawcount, stride);
    }
    /// ditto
    public void MultiDrawElementsIndirect (GLenum mode, GLenum type, const(void)* indirect, GLsizei drawcount, GLsizei stride) const {
        assert(_MultiDrawElementsIndirect !is null, "OpenGL command glMultiDrawElementsIndirect was not loaded");
        return _MultiDrawElementsIndirect (mode, type, indirect, drawcount, stride);
    }
    /// ditto
    public void GetProgramInterfaceiv (GLuint program, GLenum programInterface, GLenum pname, GLint* params) const {
        assert(_GetProgramInterfaceiv !is null, "OpenGL command glGetProgramInterfaceiv was not loaded");
        return _GetProgramInterfaceiv (program, programInterface, pname, params);
    }
    /// ditto
    public GLuint GetProgramResourceIndex (GLuint program, GLenum programInterface, const(GLchar)* name) const {
        assert(_GetProgramResourceIndex !is null, "OpenGL command glGetProgramResourceIndex was not loaded");
        return _GetProgramResourceIndex (program, programInterface, name);
    }
    /// ditto
    public void GetProgramResourceName (GLuint program, GLenum programInterface, GLuint index, GLsizei bufSize, GLsizei* length, GLchar* name) const {
        assert(_GetProgramResourceName !is null, "OpenGL command glGetProgramResourceName was not loaded");
        return _GetProgramResourceName (program, programInterface, index, bufSize, length, name);
    }
    /// ditto
    public void GetProgramResourceiv (GLuint program, GLenum programInterface, GLuint index, GLsizei propCount, const(GLenum)* props, GLsizei bufSize, GLsizei* length, GLint* params) const {
        assert(_GetProgramResourceiv !is null, "OpenGL command glGetProgramResourceiv was not loaded");
        return _GetProgramResourceiv (program, programInterface, index, propCount, props, bufSize, length, params);
    }
    /// ditto
    public GLint GetProgramResourceLocation (GLuint program, GLenum programInterface, const(GLchar)* name) const {
        assert(_GetProgramResourceLocation !is null, "OpenGL command glGetProgramResourceLocation was not loaded");
        return _GetProgramResourceLocation (program, programInterface, name);
    }
    /// ditto
    public GLint GetProgramResourceLocationIndex (GLuint program, GLenum programInterface, const(GLchar)* name) const {
        assert(_GetProgramResourceLocationIndex !is null, "OpenGL command glGetProgramResourceLocationIndex was not loaded");
        return _GetProgramResourceLocationIndex (program, programInterface, name);
    }
    /// ditto
    public void ShaderStorageBlockBinding (GLuint program, GLuint storageBlockIndex, GLuint storageBlockBinding) const {
        assert(_ShaderStorageBlockBinding !is null, "OpenGL command glShaderStorageBlockBinding was not loaded");
        return _ShaderStorageBlockBinding (program, storageBlockIndex, storageBlockBinding);
    }
    /// ditto
    public void TexBufferRange (GLenum target, GLenum internalformat, GLuint buffer, GLintptr offset, GLsizeiptr size) const {
        assert(_TexBufferRange !is null, "OpenGL command glTexBufferRange was not loaded");
        return _TexBufferRange (target, internalformat, buffer, offset, size);
    }
    /// ditto
    public void TexStorage2DMultisample (GLenum target, GLsizei samples, GLenum internalformat, GLsizei width, GLsizei height, GLboolean fixedsamplelocations) const {
        assert(_TexStorage2DMultisample !is null, "OpenGL command glTexStorage2DMultisample was not loaded");
        return _TexStorage2DMultisample (target, samples, internalformat, width, height, fixedsamplelocations);
    }
    /// ditto
    public void TexStorage3DMultisample (GLenum target, GLsizei samples, GLenum internalformat, GLsizei width, GLsizei height, GLsizei depth, GLboolean fixedsamplelocations) const {
        assert(_TexStorage3DMultisample !is null, "OpenGL command glTexStorage3DMultisample was not loaded");
        return _TexStorage3DMultisample (target, samples, internalformat, width, height, depth, fixedsamplelocations);
    }
    /// ditto
    public void TextureView (GLuint texture, GLenum target, GLuint origtexture, GLenum internalformat, GLuint minlevel, GLuint numlevels, GLuint minlayer, GLuint numlayers) const {
        assert(_TextureView !is null, "OpenGL command glTextureView was not loaded");
        return _TextureView (texture, target, origtexture, internalformat, minlevel, numlevels, minlayer, numlayers);
    }
    /// ditto
    public void BindVertexBuffer (GLuint bindingindex, GLuint buffer, GLintptr offset, GLsizei stride) const {
        assert(_BindVertexBuffer !is null, "OpenGL command glBindVertexBuffer was not loaded");
        return _BindVertexBuffer (bindingindex, buffer, offset, stride);
    }
    /// ditto
    public void VertexAttribFormat (GLuint attribindex, GLint size, GLenum type, GLboolean normalized, GLuint relativeoffset) const {
        assert(_VertexAttribFormat !is null, "OpenGL command glVertexAttribFormat was not loaded");
        return _VertexAttribFormat (attribindex, size, type, normalized, relativeoffset);
    }
    /// ditto
    public void VertexAttribIFormat (GLuint attribindex, GLint size, GLenum type, GLuint relativeoffset) const {
        assert(_VertexAttribIFormat !is null, "OpenGL command glVertexAttribIFormat was not loaded");
        return _VertexAttribIFormat (attribindex, size, type, relativeoffset);
    }
    /// ditto
    public void VertexAttribLFormat (GLuint attribindex, GLint size, GLenum type, GLuint relativeoffset) const {
        assert(_VertexAttribLFormat !is null, "OpenGL command glVertexAttribLFormat was not loaded");
        return _VertexAttribLFormat (attribindex, size, type, relativeoffset);
    }
    /// ditto
    public void VertexAttribBinding (GLuint attribindex, GLuint bindingindex) const {
        assert(_VertexAttribBinding !is null, "OpenGL command glVertexAttribBinding was not loaded");
        return _VertexAttribBinding (attribindex, bindingindex);
    }
    /// ditto
    public void VertexBindingDivisor (GLuint bindingindex, GLuint divisor) const {
        assert(_VertexBindingDivisor !is null, "OpenGL command glVertexBindingDivisor was not loaded");
        return _VertexBindingDivisor (bindingindex, divisor);
    }
    /// ditto
    public void DebugMessageControl (GLenum source, GLenum type, GLenum severity, GLsizei count, const(GLuint)* ids, GLboolean enabled) const {
        assert(_DebugMessageControl !is null, "OpenGL command glDebugMessageControl was not loaded");
        return _DebugMessageControl (source, type, severity, count, ids, enabled);
    }
    /// ditto
    public void DebugMessageInsert (GLenum source, GLenum type, GLuint id, GLenum severity, GLsizei length, const(GLchar)* buf) const {
        assert(_DebugMessageInsert !is null, "OpenGL command glDebugMessageInsert was not loaded");
        return _DebugMessageInsert (source, type, id, severity, length, buf);
    }
    /// ditto
    public void DebugMessageCallback (GLDEBUGPROC callback, const(void)* userParam) const {
        assert(_DebugMessageCallback !is null, "OpenGL command glDebugMessageCallback was not loaded");
        return _DebugMessageCallback (callback, userParam);
    }
    /// ditto
    public GLuint GetDebugMessageLog (GLuint count, GLsizei bufSize, GLenum* sources, GLenum* types, GLuint* ids, GLenum* severities, GLsizei* lengths, GLchar* messageLog) const {
        assert(_GetDebugMessageLog !is null, "OpenGL command glGetDebugMessageLog was not loaded");
        return _GetDebugMessageLog (count, bufSize, sources, types, ids, severities, lengths, messageLog);
    }
    /// ditto
    public void PushDebugGroup (GLenum source, GLuint id, GLsizei length, const(GLchar)* message) const {
        assert(_PushDebugGroup !is null, "OpenGL command glPushDebugGroup was not loaded");
        return _PushDebugGroup (source, id, length, message);
    }
    /// ditto
    public void PopDebugGroup () const {
        assert(_PopDebugGroup !is null, "OpenGL command glPopDebugGroup was not loaded");
        return _PopDebugGroup ();
    }
    /// ditto
    public void ObjectLabel (GLenum identifier, GLuint name, GLsizei length, const(GLchar)* label) const {
        assert(_ObjectLabel !is null, "OpenGL command glObjectLabel was not loaded");
        return _ObjectLabel (identifier, name, length, label);
    }
    /// ditto
    public void GetObjectLabel (GLenum identifier, GLuint name, GLsizei bufSize, GLsizei* length, GLchar* label) const {
        assert(_GetObjectLabel !is null, "OpenGL command glGetObjectLabel was not loaded");
        return _GetObjectLabel (identifier, name, bufSize, length, label);
    }
    /// ditto
    public void ObjectPtrLabel (const(void)* ptr, GLsizei length, const(GLchar)* label) const {
        assert(_ObjectPtrLabel !is null, "OpenGL command glObjectPtrLabel was not loaded");
        return _ObjectPtrLabel (ptr, length, label);
    }
    /// ditto
    public void GetObjectPtrLabel (const(void)* ptr, GLsizei bufSize, GLsizei* length, GLchar* label) const {
        assert(_GetObjectPtrLabel !is null, "OpenGL command glGetObjectPtrLabel was not loaded");
        return _GetObjectPtrLabel (ptr, bufSize, length, label);
    }

    /// Commands for GL_VERSION_4_4
    public void BufferStorage (GLenum target, GLsizeiptr size, const(void)* data, GLbitfield flags) const {
        assert(_BufferStorage !is null, "OpenGL command glBufferStorage was not loaded");
        return _BufferStorage (target, size, data, flags);
    }
    /// ditto
    public void ClearTexImage (GLuint texture, GLint level, GLenum format, GLenum type, const(void)* data) const {
        assert(_ClearTexImage !is null, "OpenGL command glClearTexImage was not loaded");
        return _ClearTexImage (texture, level, format, type, data);
    }
    /// ditto
    public void ClearTexSubImage (GLuint texture, GLint level, GLint xoffset, GLint yoffset, GLint zoffset, GLsizei width, GLsizei height, GLsizei depth, GLenum format, GLenum type, const(void)* data) const {
        assert(_ClearTexSubImage !is null, "OpenGL command glClearTexSubImage was not loaded");
        return _ClearTexSubImage (texture, level, xoffset, yoffset, zoffset, width, height, depth, format, type, data);
    }
    /// ditto
    public void BindBuffersBase (GLenum target, GLuint first, GLsizei count, const(GLuint)* buffers) const {
        assert(_BindBuffersBase !is null, "OpenGL command glBindBuffersBase was not loaded");
        return _BindBuffersBase (target, first, count, buffers);
    }
    /// ditto
    public void BindBuffersRange (GLenum target, GLuint first, GLsizei count, const(GLuint)* buffers, const(GLintptr)* offsets, const(GLsizeiptr)* sizes) const {
        assert(_BindBuffersRange !is null, "OpenGL command glBindBuffersRange was not loaded");
        return _BindBuffersRange (target, first, count, buffers, offsets, sizes);
    }
    /// ditto
    public void BindTextures (GLuint first, GLsizei count, const(GLuint)* textures) const {
        assert(_BindTextures !is null, "OpenGL command glBindTextures was not loaded");
        return _BindTextures (first, count, textures);
    }
    /// ditto
    public void BindSamplers (GLuint first, GLsizei count, const(GLuint)* samplers) const {
        assert(_BindSamplers !is null, "OpenGL command glBindSamplers was not loaded");
        return _BindSamplers (first, count, samplers);
    }
    /// ditto
    public void BindImageTextures (GLuint first, GLsizei count, const(GLuint)* textures) const {
        assert(_BindImageTextures !is null, "OpenGL command glBindImageTextures was not loaded");
        return _BindImageTextures (first, count, textures);
    }
    /// ditto
    public void BindVertexBuffers (GLuint first, GLsizei count, const(GLuint)* buffers, const(GLintptr)* offsets, const(GLsizei)* strides) const {
        assert(_BindVertexBuffers !is null, "OpenGL command glBindVertexBuffers was not loaded");
        return _BindVertexBuffers (first, count, buffers, offsets, strides);
    }

    /// Commands for GL_VERSION_4_5
    public void ClipControl (GLenum origin, GLenum depth) const {
        assert(_ClipControl !is null, "OpenGL command glClipControl was not loaded");
        return _ClipControl (origin, depth);
    }
    /// ditto
    public void CreateTransformFeedbacks (GLsizei n, GLuint* ids) const {
        assert(_CreateTransformFeedbacks !is null, "OpenGL command glCreateTransformFeedbacks was not loaded");
        return _CreateTransformFeedbacks (n, ids);
    }
    /// ditto
    public void TransformFeedbackBufferBase (GLuint xfb, GLuint index, GLuint buffer) const {
        assert(_TransformFeedbackBufferBase !is null, "OpenGL command glTransformFeedbackBufferBase was not loaded");
        return _TransformFeedbackBufferBase (xfb, index, buffer);
    }
    /// ditto
    public void TransformFeedbackBufferRange (GLuint xfb, GLuint index, GLuint buffer, GLintptr offset, GLsizeiptr size) const {
        assert(_TransformFeedbackBufferRange !is null, "OpenGL command glTransformFeedbackBufferRange was not loaded");
        return _TransformFeedbackBufferRange (xfb, index, buffer, offset, size);
    }
    /// ditto
    public void GetTransformFeedbackiv (GLuint xfb, GLenum pname, GLint* param) const {
        assert(_GetTransformFeedbackiv !is null, "OpenGL command glGetTransformFeedbackiv was not loaded");
        return _GetTransformFeedbackiv (xfb, pname, param);
    }
    /// ditto
    public void GetTransformFeedbacki_v (GLuint xfb, GLenum pname, GLuint index, GLint* param) const {
        assert(_GetTransformFeedbacki_v !is null, "OpenGL command glGetTransformFeedbacki_v was not loaded");
        return _GetTransformFeedbacki_v (xfb, pname, index, param);
    }
    /// ditto
    public void GetTransformFeedbacki64_v (GLuint xfb, GLenum pname, GLuint index, GLint64* param) const {
        assert(_GetTransformFeedbacki64_v !is null, "OpenGL command glGetTransformFeedbacki64_v was not loaded");
        return _GetTransformFeedbacki64_v (xfb, pname, index, param);
    }
    /// ditto
    public void CreateBuffers (GLsizei n, GLuint* buffers) const {
        assert(_CreateBuffers !is null, "OpenGL command glCreateBuffers was not loaded");
        return _CreateBuffers (n, buffers);
    }
    /// ditto
    public void NamedBufferStorage (GLuint buffer, GLsizeiptr size, const(void)* data, GLbitfield flags) const {
        assert(_NamedBufferStorage !is null, "OpenGL command glNamedBufferStorage was not loaded");
        return _NamedBufferStorage (buffer, size, data, flags);
    }
    /// ditto
    public void NamedBufferData (GLuint buffer, GLsizeiptr size, const(void)* data, GLenum usage) const {
        assert(_NamedBufferData !is null, "OpenGL command glNamedBufferData was not loaded");
        return _NamedBufferData (buffer, size, data, usage);
    }
    /// ditto
    public void NamedBufferSubData (GLuint buffer, GLintptr offset, GLsizeiptr size, const(void)* data) const {
        assert(_NamedBufferSubData !is null, "OpenGL command glNamedBufferSubData was not loaded");
        return _NamedBufferSubData (buffer, offset, size, data);
    }
    /// ditto
    public void CopyNamedBufferSubData (GLuint readBuffer, GLuint writeBuffer, GLintptr readOffset, GLintptr writeOffset, GLsizeiptr size) const {
        assert(_CopyNamedBufferSubData !is null, "OpenGL command glCopyNamedBufferSubData was not loaded");
        return _CopyNamedBufferSubData (readBuffer, writeBuffer, readOffset, writeOffset, size);
    }
    /// ditto
    public void ClearNamedBufferData (GLuint buffer, GLenum internalformat, GLenum format, GLenum type, const(void)* data) const {
        assert(_ClearNamedBufferData !is null, "OpenGL command glClearNamedBufferData was not loaded");
        return _ClearNamedBufferData (buffer, internalformat, format, type, data);
    }
    /// ditto
    public void ClearNamedBufferSubData (GLuint buffer, GLenum internalformat, GLintptr offset, GLsizeiptr size, GLenum format, GLenum type, const(void)* data) const {
        assert(_ClearNamedBufferSubData !is null, "OpenGL command glClearNamedBufferSubData was not loaded");
        return _ClearNamedBufferSubData (buffer, internalformat, offset, size, format, type, data);
    }
    /// ditto
    public void * MapNamedBuffer (GLuint buffer, GLenum access) const {
        assert(_MapNamedBuffer !is null, "OpenGL command glMapNamedBuffer was not loaded");
        return _MapNamedBuffer (buffer, access);
    }
    /// ditto
    public void * MapNamedBufferRange (GLuint buffer, GLintptr offset, GLsizeiptr length, GLbitfield access) const {
        assert(_MapNamedBufferRange !is null, "OpenGL command glMapNamedBufferRange was not loaded");
        return _MapNamedBufferRange (buffer, offset, length, access);
    }
    /// ditto
    public GLboolean UnmapNamedBuffer (GLuint buffer) const {
        assert(_UnmapNamedBuffer !is null, "OpenGL command glUnmapNamedBuffer was not loaded");
        return _UnmapNamedBuffer (buffer);
    }
    /// ditto
    public void FlushMappedNamedBufferRange (GLuint buffer, GLintptr offset, GLsizeiptr length) const {
        assert(_FlushMappedNamedBufferRange !is null, "OpenGL command glFlushMappedNamedBufferRange was not loaded");
        return _FlushMappedNamedBufferRange (buffer, offset, length);
    }
    /// ditto
    public void GetNamedBufferParameteriv (GLuint buffer, GLenum pname, GLint* params) const {
        assert(_GetNamedBufferParameteriv !is null, "OpenGL command glGetNamedBufferParameteriv was not loaded");
        return _GetNamedBufferParameteriv (buffer, pname, params);
    }
    /// ditto
    public void GetNamedBufferParameteri64v (GLuint buffer, GLenum pname, GLint64* params) const {
        assert(_GetNamedBufferParameteri64v !is null, "OpenGL command glGetNamedBufferParameteri64v was not loaded");
        return _GetNamedBufferParameteri64v (buffer, pname, params);
    }
    /// ditto
    public void GetNamedBufferPointerv (GLuint buffer, GLenum pname, void** params) const {
        assert(_GetNamedBufferPointerv !is null, "OpenGL command glGetNamedBufferPointerv was not loaded");
        return _GetNamedBufferPointerv (buffer, pname, params);
    }
    /// ditto
    public void GetNamedBufferSubData (GLuint buffer, GLintptr offset, GLsizeiptr size, void* data) const {
        assert(_GetNamedBufferSubData !is null, "OpenGL command glGetNamedBufferSubData was not loaded");
        return _GetNamedBufferSubData (buffer, offset, size, data);
    }
    /// ditto
    public void CreateFramebuffers (GLsizei n, GLuint* framebuffers) const {
        assert(_CreateFramebuffers !is null, "OpenGL command glCreateFramebuffers was not loaded");
        return _CreateFramebuffers (n, framebuffers);
    }
    /// ditto
    public void NamedFramebufferRenderbuffer (GLuint framebuffer, GLenum attachment, GLenum renderbuffertarget, GLuint renderbuffer) const {
        assert(_NamedFramebufferRenderbuffer !is null, "OpenGL command glNamedFramebufferRenderbuffer was not loaded");
        return _NamedFramebufferRenderbuffer (framebuffer, attachment, renderbuffertarget, renderbuffer);
    }
    /// ditto
    public void NamedFramebufferParameteri (GLuint framebuffer, GLenum pname, GLint param) const {
        assert(_NamedFramebufferParameteri !is null, "OpenGL command glNamedFramebufferParameteri was not loaded");
        return _NamedFramebufferParameteri (framebuffer, pname, param);
    }
    /// ditto
    public void NamedFramebufferTexture (GLuint framebuffer, GLenum attachment, GLuint texture, GLint level) const {
        assert(_NamedFramebufferTexture !is null, "OpenGL command glNamedFramebufferTexture was not loaded");
        return _NamedFramebufferTexture (framebuffer, attachment, texture, level);
    }
    /// ditto
    public void NamedFramebufferTextureLayer (GLuint framebuffer, GLenum attachment, GLuint texture, GLint level, GLint layer) const {
        assert(_NamedFramebufferTextureLayer !is null, "OpenGL command glNamedFramebufferTextureLayer was not loaded");
        return _NamedFramebufferTextureLayer (framebuffer, attachment, texture, level, layer);
    }
    /// ditto
    public void NamedFramebufferDrawBuffer (GLuint framebuffer, GLenum buf) const {
        assert(_NamedFramebufferDrawBuffer !is null, "OpenGL command glNamedFramebufferDrawBuffer was not loaded");
        return _NamedFramebufferDrawBuffer (framebuffer, buf);
    }
    /// ditto
    public void NamedFramebufferDrawBuffers (GLuint framebuffer, GLsizei n, const(GLenum)* bufs) const {
        assert(_NamedFramebufferDrawBuffers !is null, "OpenGL command glNamedFramebufferDrawBuffers was not loaded");
        return _NamedFramebufferDrawBuffers (framebuffer, n, bufs);
    }
    /// ditto
    public void NamedFramebufferReadBuffer (GLuint framebuffer, GLenum src) const {
        assert(_NamedFramebufferReadBuffer !is null, "OpenGL command glNamedFramebufferReadBuffer was not loaded");
        return _NamedFramebufferReadBuffer (framebuffer, src);
    }
    /// ditto
    public void InvalidateNamedFramebufferData (GLuint framebuffer, GLsizei numAttachments, const(GLenum)* attachments) const {
        assert(_InvalidateNamedFramebufferData !is null, "OpenGL command glInvalidateNamedFramebufferData was not loaded");
        return _InvalidateNamedFramebufferData (framebuffer, numAttachments, attachments);
    }
    /// ditto
    public void InvalidateNamedFramebufferSubData (GLuint framebuffer, GLsizei numAttachments, const(GLenum)* attachments, GLint x, GLint y, GLsizei width, GLsizei height) const {
        assert(_InvalidateNamedFramebufferSubData !is null, "OpenGL command glInvalidateNamedFramebufferSubData was not loaded");
        return _InvalidateNamedFramebufferSubData (framebuffer, numAttachments, attachments, x, y, width, height);
    }
    /// ditto
    public void ClearNamedFramebufferiv (GLuint framebuffer, GLenum buffer, GLint drawbuffer, const(GLint)* value) const {
        assert(_ClearNamedFramebufferiv !is null, "OpenGL command glClearNamedFramebufferiv was not loaded");
        return _ClearNamedFramebufferiv (framebuffer, buffer, drawbuffer, value);
    }
    /// ditto
    public void ClearNamedFramebufferuiv (GLuint framebuffer, GLenum buffer, GLint drawbuffer, const(GLuint)* value) const {
        assert(_ClearNamedFramebufferuiv !is null, "OpenGL command glClearNamedFramebufferuiv was not loaded");
        return _ClearNamedFramebufferuiv (framebuffer, buffer, drawbuffer, value);
    }
    /// ditto
    public void ClearNamedFramebufferfv (GLuint framebuffer, GLenum buffer, GLint drawbuffer, const(GLfloat)* value) const {
        assert(_ClearNamedFramebufferfv !is null, "OpenGL command glClearNamedFramebufferfv was not loaded");
        return _ClearNamedFramebufferfv (framebuffer, buffer, drawbuffer, value);
    }
    /// ditto
    public void ClearNamedFramebufferfi (GLuint framebuffer, GLenum buffer, GLint drawbuffer, GLfloat depth, GLint stencil) const {
        assert(_ClearNamedFramebufferfi !is null, "OpenGL command glClearNamedFramebufferfi was not loaded");
        return _ClearNamedFramebufferfi (framebuffer, buffer, drawbuffer, depth, stencil);
    }
    /// ditto
    public void BlitNamedFramebuffer (GLuint readFramebuffer, GLuint drawFramebuffer, GLint srcX0, GLint srcY0, GLint srcX1, GLint srcY1, GLint dstX0, GLint dstY0, GLint dstX1, GLint dstY1, GLbitfield mask, GLenum filter) const {
        assert(_BlitNamedFramebuffer !is null, "OpenGL command glBlitNamedFramebuffer was not loaded");
        return _BlitNamedFramebuffer (readFramebuffer, drawFramebuffer, srcX0, srcY0, srcX1, srcY1, dstX0, dstY0, dstX1, dstY1, mask, filter);
    }
    /// ditto
    public GLenum CheckNamedFramebufferStatus (GLuint framebuffer, GLenum target) const {
        assert(_CheckNamedFramebufferStatus !is null, "OpenGL command glCheckNamedFramebufferStatus was not loaded");
        return _CheckNamedFramebufferStatus (framebuffer, target);
    }
    /// ditto
    public void GetNamedFramebufferParameteriv (GLuint framebuffer, GLenum pname, GLint* param) const {
        assert(_GetNamedFramebufferParameteriv !is null, "OpenGL command glGetNamedFramebufferParameteriv was not loaded");
        return _GetNamedFramebufferParameteriv (framebuffer, pname, param);
    }
    /// ditto
    public void GetNamedFramebufferAttachmentParameteriv (GLuint framebuffer, GLenum attachment, GLenum pname, GLint* params) const {
        assert(_GetNamedFramebufferAttachmentParameteriv !is null, "OpenGL command glGetNamedFramebufferAttachmentParameteriv was not loaded");
        return _GetNamedFramebufferAttachmentParameteriv (framebuffer, attachment, pname, params);
    }
    /// ditto
    public void CreateRenderbuffers (GLsizei n, GLuint* renderbuffers) const {
        assert(_CreateRenderbuffers !is null, "OpenGL command glCreateRenderbuffers was not loaded");
        return _CreateRenderbuffers (n, renderbuffers);
    }
    /// ditto
    public void NamedRenderbufferStorage (GLuint renderbuffer, GLenum internalformat, GLsizei width, GLsizei height) const {
        assert(_NamedRenderbufferStorage !is null, "OpenGL command glNamedRenderbufferStorage was not loaded");
        return _NamedRenderbufferStorage (renderbuffer, internalformat, width, height);
    }
    /// ditto
    public void NamedRenderbufferStorageMultisample (GLuint renderbuffer, GLsizei samples, GLenum internalformat, GLsizei width, GLsizei height) const {
        assert(_NamedRenderbufferStorageMultisample !is null, "OpenGL command glNamedRenderbufferStorageMultisample was not loaded");
        return _NamedRenderbufferStorageMultisample (renderbuffer, samples, internalformat, width, height);
    }
    /// ditto
    public void GetNamedRenderbufferParameteriv (GLuint renderbuffer, GLenum pname, GLint* params) const {
        assert(_GetNamedRenderbufferParameteriv !is null, "OpenGL command glGetNamedRenderbufferParameteriv was not loaded");
        return _GetNamedRenderbufferParameteriv (renderbuffer, pname, params);
    }
    /// ditto
    public void CreateTextures (GLenum target, GLsizei n, GLuint* textures) const {
        assert(_CreateTextures !is null, "OpenGL command glCreateTextures was not loaded");
        return _CreateTextures (target, n, textures);
    }
    /// ditto
    public void TextureBuffer (GLuint texture, GLenum internalformat, GLuint buffer) const {
        assert(_TextureBuffer !is null, "OpenGL command glTextureBuffer was not loaded");
        return _TextureBuffer (texture, internalformat, buffer);
    }
    /// ditto
    public void TextureBufferRange (GLuint texture, GLenum internalformat, GLuint buffer, GLintptr offset, GLsizeiptr size) const {
        assert(_TextureBufferRange !is null, "OpenGL command glTextureBufferRange was not loaded");
        return _TextureBufferRange (texture, internalformat, buffer, offset, size);
    }
    /// ditto
    public void TextureStorage1D (GLuint texture, GLsizei levels, GLenum internalformat, GLsizei width) const {
        assert(_TextureStorage1D !is null, "OpenGL command glTextureStorage1D was not loaded");
        return _TextureStorage1D (texture, levels, internalformat, width);
    }
    /// ditto
    public void TextureStorage2D (GLuint texture, GLsizei levels, GLenum internalformat, GLsizei width, GLsizei height) const {
        assert(_TextureStorage2D !is null, "OpenGL command glTextureStorage2D was not loaded");
        return _TextureStorage2D (texture, levels, internalformat, width, height);
    }
    /// ditto
    public void TextureStorage3D (GLuint texture, GLsizei levels, GLenum internalformat, GLsizei width, GLsizei height, GLsizei depth) const {
        assert(_TextureStorage3D !is null, "OpenGL command glTextureStorage3D was not loaded");
        return _TextureStorage3D (texture, levels, internalformat, width, height, depth);
    }
    /// ditto
    public void TextureStorage2DMultisample (GLuint texture, GLsizei samples, GLenum internalformat, GLsizei width, GLsizei height, GLboolean fixedsamplelocations) const {
        assert(_TextureStorage2DMultisample !is null, "OpenGL command glTextureStorage2DMultisample was not loaded");
        return _TextureStorage2DMultisample (texture, samples, internalformat, width, height, fixedsamplelocations);
    }
    /// ditto
    public void TextureStorage3DMultisample (GLuint texture, GLsizei samples, GLenum internalformat, GLsizei width, GLsizei height, GLsizei depth, GLboolean fixedsamplelocations) const {
        assert(_TextureStorage3DMultisample !is null, "OpenGL command glTextureStorage3DMultisample was not loaded");
        return _TextureStorage3DMultisample (texture, samples, internalformat, width, height, depth, fixedsamplelocations);
    }
    /// ditto
    public void TextureSubImage1D (GLuint texture, GLint level, GLint xoffset, GLsizei width, GLenum format, GLenum type, const(void)* pixels) const {
        assert(_TextureSubImage1D !is null, "OpenGL command glTextureSubImage1D was not loaded");
        return _TextureSubImage1D (texture, level, xoffset, width, format, type, pixels);
    }
    /// ditto
    public void TextureSubImage2D (GLuint texture, GLint level, GLint xoffset, GLint yoffset, GLsizei width, GLsizei height, GLenum format, GLenum type, const(void)* pixels) const {
        assert(_TextureSubImage2D !is null, "OpenGL command glTextureSubImage2D was not loaded");
        return _TextureSubImage2D (texture, level, xoffset, yoffset, width, height, format, type, pixels);
    }
    /// ditto
    public void TextureSubImage3D (GLuint texture, GLint level, GLint xoffset, GLint yoffset, GLint zoffset, GLsizei width, GLsizei height, GLsizei depth, GLenum format, GLenum type, const(void)* pixels) const {
        assert(_TextureSubImage3D !is null, "OpenGL command glTextureSubImage3D was not loaded");
        return _TextureSubImage3D (texture, level, xoffset, yoffset, zoffset, width, height, depth, format, type, pixels);
    }
    /// ditto
    public void CompressedTextureSubImage1D (GLuint texture, GLint level, GLint xoffset, GLsizei width, GLenum format, GLsizei imageSize, const(void)* data) const {
        assert(_CompressedTextureSubImage1D !is null, "OpenGL command glCompressedTextureSubImage1D was not loaded");
        return _CompressedTextureSubImage1D (texture, level, xoffset, width, format, imageSize, data);
    }
    /// ditto
    public void CompressedTextureSubImage2D (GLuint texture, GLint level, GLint xoffset, GLint yoffset, GLsizei width, GLsizei height, GLenum format, GLsizei imageSize, const(void)* data) const {
        assert(_CompressedTextureSubImage2D !is null, "OpenGL command glCompressedTextureSubImage2D was not loaded");
        return _CompressedTextureSubImage2D (texture, level, xoffset, yoffset, width, height, format, imageSize, data);
    }
    /// ditto
    public void CompressedTextureSubImage3D (GLuint texture, GLint level, GLint xoffset, GLint yoffset, GLint zoffset, GLsizei width, GLsizei height, GLsizei depth, GLenum format, GLsizei imageSize, const(void)* data) const {
        assert(_CompressedTextureSubImage3D !is null, "OpenGL command glCompressedTextureSubImage3D was not loaded");
        return _CompressedTextureSubImage3D (texture, level, xoffset, yoffset, zoffset, width, height, depth, format, imageSize, data);
    }
    /// ditto
    public void CopyTextureSubImage1D (GLuint texture, GLint level, GLint xoffset, GLint x, GLint y, GLsizei width) const {
        assert(_CopyTextureSubImage1D !is null, "OpenGL command glCopyTextureSubImage1D was not loaded");
        return _CopyTextureSubImage1D (texture, level, xoffset, x, y, width);
    }
    /// ditto
    public void CopyTextureSubImage2D (GLuint texture, GLint level, GLint xoffset, GLint yoffset, GLint x, GLint y, GLsizei width, GLsizei height) const {
        assert(_CopyTextureSubImage2D !is null, "OpenGL command glCopyTextureSubImage2D was not loaded");
        return _CopyTextureSubImage2D (texture, level, xoffset, yoffset, x, y, width, height);
    }
    /// ditto
    public void CopyTextureSubImage3D (GLuint texture, GLint level, GLint xoffset, GLint yoffset, GLint zoffset, GLint x, GLint y, GLsizei width, GLsizei height) const {
        assert(_CopyTextureSubImage3D !is null, "OpenGL command glCopyTextureSubImage3D was not loaded");
        return _CopyTextureSubImage3D (texture, level, xoffset, yoffset, zoffset, x, y, width, height);
    }
    /// ditto
    public void TextureParameterf (GLuint texture, GLenum pname, GLfloat param) const {
        assert(_TextureParameterf !is null, "OpenGL command glTextureParameterf was not loaded");
        return _TextureParameterf (texture, pname, param);
    }
    /// ditto
    public void TextureParameterfv (GLuint texture, GLenum pname, const(GLfloat)* param) const {
        assert(_TextureParameterfv !is null, "OpenGL command glTextureParameterfv was not loaded");
        return _TextureParameterfv (texture, pname, param);
    }
    /// ditto
    public void TextureParameteri (GLuint texture, GLenum pname, GLint param) const {
        assert(_TextureParameteri !is null, "OpenGL command glTextureParameteri was not loaded");
        return _TextureParameteri (texture, pname, param);
    }
    /// ditto
    public void TextureParameterIiv (GLuint texture, GLenum pname, const(GLint)* params) const {
        assert(_TextureParameterIiv !is null, "OpenGL command glTextureParameterIiv was not loaded");
        return _TextureParameterIiv (texture, pname, params);
    }
    /// ditto
    public void TextureParameterIuiv (GLuint texture, GLenum pname, const(GLuint)* params) const {
        assert(_TextureParameterIuiv !is null, "OpenGL command glTextureParameterIuiv was not loaded");
        return _TextureParameterIuiv (texture, pname, params);
    }
    /// ditto
    public void TextureParameteriv (GLuint texture, GLenum pname, const(GLint)* param) const {
        assert(_TextureParameteriv !is null, "OpenGL command glTextureParameteriv was not loaded");
        return _TextureParameteriv (texture, pname, param);
    }
    /// ditto
    public void GenerateTextureMipmap (GLuint texture) const {
        assert(_GenerateTextureMipmap !is null, "OpenGL command glGenerateTextureMipmap was not loaded");
        return _GenerateTextureMipmap (texture);
    }
    /// ditto
    public void BindTextureUnit (GLuint unit, GLuint texture) const {
        assert(_BindTextureUnit !is null, "OpenGL command glBindTextureUnit was not loaded");
        return _BindTextureUnit (unit, texture);
    }
    /// ditto
    public void GetTextureImage (GLuint texture, GLint level, GLenum format, GLenum type, GLsizei bufSize, void* pixels) const {
        assert(_GetTextureImage !is null, "OpenGL command glGetTextureImage was not loaded");
        return _GetTextureImage (texture, level, format, type, bufSize, pixels);
    }
    /// ditto
    public void GetCompressedTextureImage (GLuint texture, GLint level, GLsizei bufSize, void* pixels) const {
        assert(_GetCompressedTextureImage !is null, "OpenGL command glGetCompressedTextureImage was not loaded");
        return _GetCompressedTextureImage (texture, level, bufSize, pixels);
    }
    /// ditto
    public void GetTextureLevelParameterfv (GLuint texture, GLint level, GLenum pname, GLfloat* params) const {
        assert(_GetTextureLevelParameterfv !is null, "OpenGL command glGetTextureLevelParameterfv was not loaded");
        return _GetTextureLevelParameterfv (texture, level, pname, params);
    }
    /// ditto
    public void GetTextureLevelParameteriv (GLuint texture, GLint level, GLenum pname, GLint* params) const {
        assert(_GetTextureLevelParameteriv !is null, "OpenGL command glGetTextureLevelParameteriv was not loaded");
        return _GetTextureLevelParameteriv (texture, level, pname, params);
    }
    /// ditto
    public void GetTextureParameterfv (GLuint texture, GLenum pname, GLfloat* params) const {
        assert(_GetTextureParameterfv !is null, "OpenGL command glGetTextureParameterfv was not loaded");
        return _GetTextureParameterfv (texture, pname, params);
    }
    /// ditto
    public void GetTextureParameterIiv (GLuint texture, GLenum pname, GLint* params) const {
        assert(_GetTextureParameterIiv !is null, "OpenGL command glGetTextureParameterIiv was not loaded");
        return _GetTextureParameterIiv (texture, pname, params);
    }
    /// ditto
    public void GetTextureParameterIuiv (GLuint texture, GLenum pname, GLuint* params) const {
        assert(_GetTextureParameterIuiv !is null, "OpenGL command glGetTextureParameterIuiv was not loaded");
        return _GetTextureParameterIuiv (texture, pname, params);
    }
    /// ditto
    public void GetTextureParameteriv (GLuint texture, GLenum pname, GLint* params) const {
        assert(_GetTextureParameteriv !is null, "OpenGL command glGetTextureParameteriv was not loaded");
        return _GetTextureParameteriv (texture, pname, params);
    }
    /// ditto
    public void CreateVertexArrays (GLsizei n, GLuint* arrays) const {
        assert(_CreateVertexArrays !is null, "OpenGL command glCreateVertexArrays was not loaded");
        return _CreateVertexArrays (n, arrays);
    }
    /// ditto
    public void DisableVertexArrayAttrib (GLuint vaobj, GLuint index) const {
        assert(_DisableVertexArrayAttrib !is null, "OpenGL command glDisableVertexArrayAttrib was not loaded");
        return _DisableVertexArrayAttrib (vaobj, index);
    }
    /// ditto
    public void EnableVertexArrayAttrib (GLuint vaobj, GLuint index) const {
        assert(_EnableVertexArrayAttrib !is null, "OpenGL command glEnableVertexArrayAttrib was not loaded");
        return _EnableVertexArrayAttrib (vaobj, index);
    }
    /// ditto
    public void VertexArrayElementBuffer (GLuint vaobj, GLuint buffer) const {
        assert(_VertexArrayElementBuffer !is null, "OpenGL command glVertexArrayElementBuffer was not loaded");
        return _VertexArrayElementBuffer (vaobj, buffer);
    }
    /// ditto
    public void VertexArrayVertexBuffer (GLuint vaobj, GLuint bindingindex, GLuint buffer, GLintptr offset, GLsizei stride) const {
        assert(_VertexArrayVertexBuffer !is null, "OpenGL command glVertexArrayVertexBuffer was not loaded");
        return _VertexArrayVertexBuffer (vaobj, bindingindex, buffer, offset, stride);
    }
    /// ditto
    public void VertexArrayVertexBuffers (GLuint vaobj, GLuint first, GLsizei count, const(GLuint)* buffers, const(GLintptr)* offsets, const(GLsizei)* strides) const {
        assert(_VertexArrayVertexBuffers !is null, "OpenGL command glVertexArrayVertexBuffers was not loaded");
        return _VertexArrayVertexBuffers (vaobj, first, count, buffers, offsets, strides);
    }
    /// ditto
    public void VertexArrayAttribBinding (GLuint vaobj, GLuint attribindex, GLuint bindingindex) const {
        assert(_VertexArrayAttribBinding !is null, "OpenGL command glVertexArrayAttribBinding was not loaded");
        return _VertexArrayAttribBinding (vaobj, attribindex, bindingindex);
    }
    /// ditto
    public void VertexArrayAttribFormat (GLuint vaobj, GLuint attribindex, GLint size, GLenum type, GLboolean normalized, GLuint relativeoffset) const {
        assert(_VertexArrayAttribFormat !is null, "OpenGL command glVertexArrayAttribFormat was not loaded");
        return _VertexArrayAttribFormat (vaobj, attribindex, size, type, normalized, relativeoffset);
    }
    /// ditto
    public void VertexArrayAttribIFormat (GLuint vaobj, GLuint attribindex, GLint size, GLenum type, GLuint relativeoffset) const {
        assert(_VertexArrayAttribIFormat !is null, "OpenGL command glVertexArrayAttribIFormat was not loaded");
        return _VertexArrayAttribIFormat (vaobj, attribindex, size, type, relativeoffset);
    }
    /// ditto
    public void VertexArrayAttribLFormat (GLuint vaobj, GLuint attribindex, GLint size, GLenum type, GLuint relativeoffset) const {
        assert(_VertexArrayAttribLFormat !is null, "OpenGL command glVertexArrayAttribLFormat was not loaded");
        return _VertexArrayAttribLFormat (vaobj, attribindex, size, type, relativeoffset);
    }
    /// ditto
    public void VertexArrayBindingDivisor (GLuint vaobj, GLuint bindingindex, GLuint divisor) const {
        assert(_VertexArrayBindingDivisor !is null, "OpenGL command glVertexArrayBindingDivisor was not loaded");
        return _VertexArrayBindingDivisor (vaobj, bindingindex, divisor);
    }
    /// ditto
    public void GetVertexArrayiv (GLuint vaobj, GLenum pname, GLint* param) const {
        assert(_GetVertexArrayiv !is null, "OpenGL command glGetVertexArrayiv was not loaded");
        return _GetVertexArrayiv (vaobj, pname, param);
    }
    /// ditto
    public void GetVertexArrayIndexediv (GLuint vaobj, GLuint index, GLenum pname, GLint* param) const {
        assert(_GetVertexArrayIndexediv !is null, "OpenGL command glGetVertexArrayIndexediv was not loaded");
        return _GetVertexArrayIndexediv (vaobj, index, pname, param);
    }
    /// ditto
    public void GetVertexArrayIndexed64iv (GLuint vaobj, GLuint index, GLenum pname, GLint64* param) const {
        assert(_GetVertexArrayIndexed64iv !is null, "OpenGL command glGetVertexArrayIndexed64iv was not loaded");
        return _GetVertexArrayIndexed64iv (vaobj, index, pname, param);
    }
    /// ditto
    public void CreateSamplers (GLsizei n, GLuint* samplers) const {
        assert(_CreateSamplers !is null, "OpenGL command glCreateSamplers was not loaded");
        return _CreateSamplers (n, samplers);
    }
    /// ditto
    public void CreateProgramPipelines (GLsizei n, GLuint* pipelines) const {
        assert(_CreateProgramPipelines !is null, "OpenGL command glCreateProgramPipelines was not loaded");
        return _CreateProgramPipelines (n, pipelines);
    }
    /// ditto
    public void CreateQueries (GLenum target, GLsizei n, GLuint* ids) const {
        assert(_CreateQueries !is null, "OpenGL command glCreateQueries was not loaded");
        return _CreateQueries (target, n, ids);
    }
    /// ditto
    public void GetQueryBufferObjecti64v (GLuint id, GLuint buffer, GLenum pname, GLintptr offset) const {
        assert(_GetQueryBufferObjecti64v !is null, "OpenGL command glGetQueryBufferObjecti64v was not loaded");
        return _GetQueryBufferObjecti64v (id, buffer, pname, offset);
    }
    /// ditto
    public void GetQueryBufferObjectiv (GLuint id, GLuint buffer, GLenum pname, GLintptr offset) const {
        assert(_GetQueryBufferObjectiv !is null, "OpenGL command glGetQueryBufferObjectiv was not loaded");
        return _GetQueryBufferObjectiv (id, buffer, pname, offset);
    }
    /// ditto
    public void GetQueryBufferObjectui64v (GLuint id, GLuint buffer, GLenum pname, GLintptr offset) const {
        assert(_GetQueryBufferObjectui64v !is null, "OpenGL command glGetQueryBufferObjectui64v was not loaded");
        return _GetQueryBufferObjectui64v (id, buffer, pname, offset);
    }
    /// ditto
    public void GetQueryBufferObjectuiv (GLuint id, GLuint buffer, GLenum pname, GLintptr offset) const {
        assert(_GetQueryBufferObjectuiv !is null, "OpenGL command glGetQueryBufferObjectuiv was not loaded");
        return _GetQueryBufferObjectuiv (id, buffer, pname, offset);
    }
    /// ditto
    public void MemoryBarrierByRegion (GLbitfield barriers) const {
        assert(_MemoryBarrierByRegion !is null, "OpenGL command glMemoryBarrierByRegion was not loaded");
        return _MemoryBarrierByRegion (barriers);
    }
    /// ditto
    public void GetTextureSubImage (GLuint texture, GLint level, GLint xoffset, GLint yoffset, GLint zoffset, GLsizei width, GLsizei height, GLsizei depth, GLenum format, GLenum type, GLsizei bufSize, void* pixels) const {
        assert(_GetTextureSubImage !is null, "OpenGL command glGetTextureSubImage was not loaded");
        return _GetTextureSubImage (texture, level, xoffset, yoffset, zoffset, width, height, depth, format, type, bufSize, pixels);
    }
    /// ditto
    public void GetCompressedTextureSubImage (GLuint texture, GLint level, GLint xoffset, GLint yoffset, GLint zoffset, GLsizei width, GLsizei height, GLsizei depth, GLsizei bufSize, void* pixels) const {
        assert(_GetCompressedTextureSubImage !is null, "OpenGL command glGetCompressedTextureSubImage was not loaded");
        return _GetCompressedTextureSubImage (texture, level, xoffset, yoffset, zoffset, width, height, depth, bufSize, pixels);
    }
    /// ditto
    public GLenum GetGraphicsResetStatus () const {
        assert(_GetGraphicsResetStatus !is null, "OpenGL command glGetGraphicsResetStatus was not loaded");
        return _GetGraphicsResetStatus ();
    }
    /// ditto
    public void GetnCompressedTexImage (GLenum target, GLint lod, GLsizei bufSize, void* pixels) const {
        assert(_GetnCompressedTexImage !is null, "OpenGL command glGetnCompressedTexImage was not loaded");
        return _GetnCompressedTexImage (target, lod, bufSize, pixels);
    }
    /// ditto
    public void GetnTexImage (GLenum target, GLint level, GLenum format, GLenum type, GLsizei bufSize, void* pixels) const {
        assert(_GetnTexImage !is null, "OpenGL command glGetnTexImage was not loaded");
        return _GetnTexImage (target, level, format, type, bufSize, pixels);
    }
    /// ditto
    public void GetnUniformdv (GLuint program, GLint location, GLsizei bufSize, GLdouble* params) const {
        assert(_GetnUniformdv !is null, "OpenGL command glGetnUniformdv was not loaded");
        return _GetnUniformdv (program, location, bufSize, params);
    }
    /// ditto
    public void GetnUniformfv (GLuint program, GLint location, GLsizei bufSize, GLfloat* params) const {
        assert(_GetnUniformfv !is null, "OpenGL command glGetnUniformfv was not loaded");
        return _GetnUniformfv (program, location, bufSize, params);
    }
    /// ditto
    public void GetnUniformiv (GLuint program, GLint location, GLsizei bufSize, GLint* params) const {
        assert(_GetnUniformiv !is null, "OpenGL command glGetnUniformiv was not loaded");
        return _GetnUniformiv (program, location, bufSize, params);
    }
    /// ditto
    public void GetnUniformuiv (GLuint program, GLint location, GLsizei bufSize, GLuint* params) const {
        assert(_GetnUniformuiv !is null, "OpenGL command glGetnUniformuiv was not loaded");
        return _GetnUniformuiv (program, location, bufSize, params);
    }
    /// ditto
    public void ReadnPixels (GLint x, GLint y, GLsizei width, GLsizei height, GLenum format, GLenum type, GLsizei bufSize, void* data) const {
        assert(_ReadnPixels !is null, "OpenGL command glReadnPixels was not loaded");
        return _ReadnPixels (x, y, width, height, format, type, bufSize, data);
    }
    /// ditto
    public void TextureBarrier () const {
        assert(_TextureBarrier !is null, "OpenGL command glTextureBarrier was not loaded");
        return _TextureBarrier ();
    }

    /// Commands for GL_VERSION_4_6
    public void SpecializeShader (GLuint shader, const(GLchar)* pEntryPoint, GLuint numSpecializationConstants, const(GLuint)* pConstantIndex, const(GLuint)* pConstantValue) const {
        assert(_SpecializeShader !is null, "OpenGL command glSpecializeShader was not loaded");
        return _SpecializeShader (shader, pEntryPoint, numSpecializationConstants, pConstantIndex, pConstantValue);
    }
    /// ditto
    public void MultiDrawArraysIndirectCount (GLenum mode, const(void)* indirect, GLintptr drawcount, GLsizei maxdrawcount, GLsizei stride) const {
        assert(_MultiDrawArraysIndirectCount !is null, "OpenGL command glMultiDrawArraysIndirectCount was not loaded");
        return _MultiDrawArraysIndirectCount (mode, indirect, drawcount, maxdrawcount, stride);
    }
    /// ditto
    public void MultiDrawElementsIndirectCount (GLenum mode, GLenum type, const(void)* indirect, GLintptr drawcount, GLsizei maxdrawcount, GLsizei stride) const {
        assert(_MultiDrawElementsIndirectCount !is null, "OpenGL command glMultiDrawElementsIndirectCount was not loaded");
        return _MultiDrawElementsIndirectCount (mode, type, indirect, drawcount, maxdrawcount, stride);
    }
    /// ditto
    public void PolygonOffsetClamp (GLfloat factor, GLfloat units, GLfloat clamp) const {
        assert(_PolygonOffsetClamp !is null, "OpenGL command glPolygonOffsetClamp was not loaded");
        return _PolygonOffsetClamp (factor, units, clamp);
    }

    /// Commands for GL_ARB_ES3_2_compatibility
    public void PrimitiveBoundingBoxARB (GLfloat minX, GLfloat minY, GLfloat minZ, GLfloat minW, GLfloat maxX, GLfloat maxY, GLfloat maxZ, GLfloat maxW) const {
        assert(_PrimitiveBoundingBoxARB !is null, "OpenGL command glPrimitiveBoundingBoxARB was not loaded");
        return _PrimitiveBoundingBoxARB (minX, minY, minZ, minW, maxX, maxY, maxZ, maxW);
    }

    /// Commands for GL_ARB_bindless_texture
    public GLuint64 GetTextureHandleARB (GLuint texture) const {
        assert(_GetTextureHandleARB !is null, "OpenGL command glGetTextureHandleARB was not loaded");
        return _GetTextureHandleARB (texture);
    }
    /// ditto
    public GLuint64 GetTextureSamplerHandleARB (GLuint texture, GLuint sampler) const {
        assert(_GetTextureSamplerHandleARB !is null, "OpenGL command glGetTextureSamplerHandleARB was not loaded");
        return _GetTextureSamplerHandleARB (texture, sampler);
    }
    /// ditto
    public void MakeTextureHandleResidentARB (GLuint64 handle) const {
        assert(_MakeTextureHandleResidentARB !is null, "OpenGL command glMakeTextureHandleResidentARB was not loaded");
        return _MakeTextureHandleResidentARB (handle);
    }
    /// ditto
    public void MakeTextureHandleNonResidentARB (GLuint64 handle) const {
        assert(_MakeTextureHandleNonResidentARB !is null, "OpenGL command glMakeTextureHandleNonResidentARB was not loaded");
        return _MakeTextureHandleNonResidentARB (handle);
    }
    /// ditto
    public GLuint64 GetImageHandleARB (GLuint texture, GLint level, GLboolean layered, GLint layer, GLenum format) const {
        assert(_GetImageHandleARB !is null, "OpenGL command glGetImageHandleARB was not loaded");
        return _GetImageHandleARB (texture, level, layered, layer, format);
    }
    /// ditto
    public void MakeImageHandleResidentARB (GLuint64 handle, GLenum access) const {
        assert(_MakeImageHandleResidentARB !is null, "OpenGL command glMakeImageHandleResidentARB was not loaded");
        return _MakeImageHandleResidentARB (handle, access);
    }
    /// ditto
    public void MakeImageHandleNonResidentARB (GLuint64 handle) const {
        assert(_MakeImageHandleNonResidentARB !is null, "OpenGL command glMakeImageHandleNonResidentARB was not loaded");
        return _MakeImageHandleNonResidentARB (handle);
    }
    /// ditto
    public void UniformHandleui64ARB (GLint location, GLuint64 value) const {
        assert(_UniformHandleui64ARB !is null, "OpenGL command glUniformHandleui64ARB was not loaded");
        return _UniformHandleui64ARB (location, value);
    }
    /// ditto
    public void UniformHandleui64vARB (GLint location, GLsizei count, const(GLuint64)* value) const {
        assert(_UniformHandleui64vARB !is null, "OpenGL command glUniformHandleui64vARB was not loaded");
        return _UniformHandleui64vARB (location, count, value);
    }
    /// ditto
    public void ProgramUniformHandleui64ARB (GLuint program, GLint location, GLuint64 value) const {
        assert(_ProgramUniformHandleui64ARB !is null, "OpenGL command glProgramUniformHandleui64ARB was not loaded");
        return _ProgramUniformHandleui64ARB (program, location, value);
    }
    /// ditto
    public void ProgramUniformHandleui64vARB (GLuint program, GLint location, GLsizei count, const(GLuint64)* values) const {
        assert(_ProgramUniformHandleui64vARB !is null, "OpenGL command glProgramUniformHandleui64vARB was not loaded");
        return _ProgramUniformHandleui64vARB (program, location, count, values);
    }
    /// ditto
    public GLboolean IsTextureHandleResidentARB (GLuint64 handle) const {
        assert(_IsTextureHandleResidentARB !is null, "OpenGL command glIsTextureHandleResidentARB was not loaded");
        return _IsTextureHandleResidentARB (handle);
    }
    /// ditto
    public GLboolean IsImageHandleResidentARB (GLuint64 handle) const {
        assert(_IsImageHandleResidentARB !is null, "OpenGL command glIsImageHandleResidentARB was not loaded");
        return _IsImageHandleResidentARB (handle);
    }
    /// ditto
    public void VertexAttribL1ui64ARB (GLuint index, GLuint64EXT x) const {
        assert(_VertexAttribL1ui64ARB !is null, "OpenGL command glVertexAttribL1ui64ARB was not loaded");
        return _VertexAttribL1ui64ARB (index, x);
    }
    /// ditto
    public void VertexAttribL1ui64vARB (GLuint index, const(GLuint64EXT)* v) const {
        assert(_VertexAttribL1ui64vARB !is null, "OpenGL command glVertexAttribL1ui64vARB was not loaded");
        return _VertexAttribL1ui64vARB (index, v);
    }
    /// ditto
    public void GetVertexAttribLui64vARB (GLuint index, GLenum pname, GLuint64EXT* params) const {
        assert(_GetVertexAttribLui64vARB !is null, "OpenGL command glGetVertexAttribLui64vARB was not loaded");
        return _GetVertexAttribLui64vARB (index, pname, params);
    }

    /// Commands for GL_ARB_cl_event
    public GLsync CreateSyncFromCLeventARB (_cl_context* context, _cl_event* event, GLbitfield flags) const {
        assert(_CreateSyncFromCLeventARB !is null, "OpenGL command glCreateSyncFromCLeventARB was not loaded");
        return _CreateSyncFromCLeventARB (context, event, flags);
    }

    /// Commands for GL_ARB_compute_variable_group_size
    public void DispatchComputeGroupSizeARB (GLuint num_groups_x, GLuint num_groups_y, GLuint num_groups_z, GLuint group_size_x, GLuint group_size_y, GLuint group_size_z) const {
        assert(_DispatchComputeGroupSizeARB !is null, "OpenGL command glDispatchComputeGroupSizeARB was not loaded");
        return _DispatchComputeGroupSizeARB (num_groups_x, num_groups_y, num_groups_z, group_size_x, group_size_y, group_size_z);
    }

    /// Commands for GL_ARB_geometry_shader4
    public void FramebufferTextureFaceARB (GLenum target, GLenum attachment, GLuint texture, GLint level, GLenum face) const {
        assert(_FramebufferTextureFaceARB !is null, "OpenGL command glFramebufferTextureFaceARB was not loaded");
        return _FramebufferTextureFaceARB (target, attachment, texture, level, face);
    }

    /// Commands for GL_ARB_gpu_shader_int64
    public void Uniform1i64ARB (GLint location, GLint64 x) const {
        assert(_Uniform1i64ARB !is null, "OpenGL command glUniform1i64ARB was not loaded");
        return _Uniform1i64ARB (location, x);
    }
    /// ditto
    public void Uniform2i64ARB (GLint location, GLint64 x, GLint64 y) const {
        assert(_Uniform2i64ARB !is null, "OpenGL command glUniform2i64ARB was not loaded");
        return _Uniform2i64ARB (location, x, y);
    }
    /// ditto
    public void Uniform3i64ARB (GLint location, GLint64 x, GLint64 y, GLint64 z) const {
        assert(_Uniform3i64ARB !is null, "OpenGL command glUniform3i64ARB was not loaded");
        return _Uniform3i64ARB (location, x, y, z);
    }
    /// ditto
    public void Uniform4i64ARB (GLint location, GLint64 x, GLint64 y, GLint64 z, GLint64 w) const {
        assert(_Uniform4i64ARB !is null, "OpenGL command glUniform4i64ARB was not loaded");
        return _Uniform4i64ARB (location, x, y, z, w);
    }
    /// ditto
    public void Uniform1i64vARB (GLint location, GLsizei count, const(GLint64)* value) const {
        assert(_Uniform1i64vARB !is null, "OpenGL command glUniform1i64vARB was not loaded");
        return _Uniform1i64vARB (location, count, value);
    }
    /// ditto
    public void Uniform2i64vARB (GLint location, GLsizei count, const(GLint64)* value) const {
        assert(_Uniform2i64vARB !is null, "OpenGL command glUniform2i64vARB was not loaded");
        return _Uniform2i64vARB (location, count, value);
    }
    /// ditto
    public void Uniform3i64vARB (GLint location, GLsizei count, const(GLint64)* value) const {
        assert(_Uniform3i64vARB !is null, "OpenGL command glUniform3i64vARB was not loaded");
        return _Uniform3i64vARB (location, count, value);
    }
    /// ditto
    public void Uniform4i64vARB (GLint location, GLsizei count, const(GLint64)* value) const {
        assert(_Uniform4i64vARB !is null, "OpenGL command glUniform4i64vARB was not loaded");
        return _Uniform4i64vARB (location, count, value);
    }
    /// ditto
    public void Uniform1ui64ARB (GLint location, GLuint64 x) const {
        assert(_Uniform1ui64ARB !is null, "OpenGL command glUniform1ui64ARB was not loaded");
        return _Uniform1ui64ARB (location, x);
    }
    /// ditto
    public void Uniform2ui64ARB (GLint location, GLuint64 x, GLuint64 y) const {
        assert(_Uniform2ui64ARB !is null, "OpenGL command glUniform2ui64ARB was not loaded");
        return _Uniform2ui64ARB (location, x, y);
    }
    /// ditto
    public void Uniform3ui64ARB (GLint location, GLuint64 x, GLuint64 y, GLuint64 z) const {
        assert(_Uniform3ui64ARB !is null, "OpenGL command glUniform3ui64ARB was not loaded");
        return _Uniform3ui64ARB (location, x, y, z);
    }
    /// ditto
    public void Uniform4ui64ARB (GLint location, GLuint64 x, GLuint64 y, GLuint64 z, GLuint64 w) const {
        assert(_Uniform4ui64ARB !is null, "OpenGL command glUniform4ui64ARB was not loaded");
        return _Uniform4ui64ARB (location, x, y, z, w);
    }
    /// ditto
    public void Uniform1ui64vARB (GLint location, GLsizei count, const(GLuint64)* value) const {
        assert(_Uniform1ui64vARB !is null, "OpenGL command glUniform1ui64vARB was not loaded");
        return _Uniform1ui64vARB (location, count, value);
    }
    /// ditto
    public void Uniform2ui64vARB (GLint location, GLsizei count, const(GLuint64)* value) const {
        assert(_Uniform2ui64vARB !is null, "OpenGL command glUniform2ui64vARB was not loaded");
        return _Uniform2ui64vARB (location, count, value);
    }
    /// ditto
    public void Uniform3ui64vARB (GLint location, GLsizei count, const(GLuint64)* value) const {
        assert(_Uniform3ui64vARB !is null, "OpenGL command glUniform3ui64vARB was not loaded");
        return _Uniform3ui64vARB (location, count, value);
    }
    /// ditto
    public void Uniform4ui64vARB (GLint location, GLsizei count, const(GLuint64)* value) const {
        assert(_Uniform4ui64vARB !is null, "OpenGL command glUniform4ui64vARB was not loaded");
        return _Uniform4ui64vARB (location, count, value);
    }
    /// ditto
    public void GetUniformi64vARB (GLuint program, GLint location, GLint64* params) const {
        assert(_GetUniformi64vARB !is null, "OpenGL command glGetUniformi64vARB was not loaded");
        return _GetUniformi64vARB (program, location, params);
    }
    /// ditto
    public void GetUniformui64vARB (GLuint program, GLint location, GLuint64* params) const {
        assert(_GetUniformui64vARB !is null, "OpenGL command glGetUniformui64vARB was not loaded");
        return _GetUniformui64vARB (program, location, params);
    }
    /// ditto
    public void GetnUniformi64vARB (GLuint program, GLint location, GLsizei bufSize, GLint64* params) const {
        assert(_GetnUniformi64vARB !is null, "OpenGL command glGetnUniformi64vARB was not loaded");
        return _GetnUniformi64vARB (program, location, bufSize, params);
    }
    /// ditto
    public void GetnUniformui64vARB (GLuint program, GLint location, GLsizei bufSize, GLuint64* params) const {
        assert(_GetnUniformui64vARB !is null, "OpenGL command glGetnUniformui64vARB was not loaded");
        return _GetnUniformui64vARB (program, location, bufSize, params);
    }
    /// ditto
    public void ProgramUniform1i64ARB (GLuint program, GLint location, GLint64 x) const {
        assert(_ProgramUniform1i64ARB !is null, "OpenGL command glProgramUniform1i64ARB was not loaded");
        return _ProgramUniform1i64ARB (program, location, x);
    }
    /// ditto
    public void ProgramUniform2i64ARB (GLuint program, GLint location, GLint64 x, GLint64 y) const {
        assert(_ProgramUniform2i64ARB !is null, "OpenGL command glProgramUniform2i64ARB was not loaded");
        return _ProgramUniform2i64ARB (program, location, x, y);
    }
    /// ditto
    public void ProgramUniform3i64ARB (GLuint program, GLint location, GLint64 x, GLint64 y, GLint64 z) const {
        assert(_ProgramUniform3i64ARB !is null, "OpenGL command glProgramUniform3i64ARB was not loaded");
        return _ProgramUniform3i64ARB (program, location, x, y, z);
    }
    /// ditto
    public void ProgramUniform4i64ARB (GLuint program, GLint location, GLint64 x, GLint64 y, GLint64 z, GLint64 w) const {
        assert(_ProgramUniform4i64ARB !is null, "OpenGL command glProgramUniform4i64ARB was not loaded");
        return _ProgramUniform4i64ARB (program, location, x, y, z, w);
    }
    /// ditto
    public void ProgramUniform1i64vARB (GLuint program, GLint location, GLsizei count, const(GLint64)* value) const {
        assert(_ProgramUniform1i64vARB !is null, "OpenGL command glProgramUniform1i64vARB was not loaded");
        return _ProgramUniform1i64vARB (program, location, count, value);
    }
    /// ditto
    public void ProgramUniform2i64vARB (GLuint program, GLint location, GLsizei count, const(GLint64)* value) const {
        assert(_ProgramUniform2i64vARB !is null, "OpenGL command glProgramUniform2i64vARB was not loaded");
        return _ProgramUniform2i64vARB (program, location, count, value);
    }
    /// ditto
    public void ProgramUniform3i64vARB (GLuint program, GLint location, GLsizei count, const(GLint64)* value) const {
        assert(_ProgramUniform3i64vARB !is null, "OpenGL command glProgramUniform3i64vARB was not loaded");
        return _ProgramUniform3i64vARB (program, location, count, value);
    }
    /// ditto
    public void ProgramUniform4i64vARB (GLuint program, GLint location, GLsizei count, const(GLint64)* value) const {
        assert(_ProgramUniform4i64vARB !is null, "OpenGL command glProgramUniform4i64vARB was not loaded");
        return _ProgramUniform4i64vARB (program, location, count, value);
    }
    /// ditto
    public void ProgramUniform1ui64ARB (GLuint program, GLint location, GLuint64 x) const {
        assert(_ProgramUniform1ui64ARB !is null, "OpenGL command glProgramUniform1ui64ARB was not loaded");
        return _ProgramUniform1ui64ARB (program, location, x);
    }
    /// ditto
    public void ProgramUniform2ui64ARB (GLuint program, GLint location, GLuint64 x, GLuint64 y) const {
        assert(_ProgramUniform2ui64ARB !is null, "OpenGL command glProgramUniform2ui64ARB was not loaded");
        return _ProgramUniform2ui64ARB (program, location, x, y);
    }
    /// ditto
    public void ProgramUniform3ui64ARB (GLuint program, GLint location, GLuint64 x, GLuint64 y, GLuint64 z) const {
        assert(_ProgramUniform3ui64ARB !is null, "OpenGL command glProgramUniform3ui64ARB was not loaded");
        return _ProgramUniform3ui64ARB (program, location, x, y, z);
    }
    /// ditto
    public void ProgramUniform4ui64ARB (GLuint program, GLint location, GLuint64 x, GLuint64 y, GLuint64 z, GLuint64 w) const {
        assert(_ProgramUniform4ui64ARB !is null, "OpenGL command glProgramUniform4ui64ARB was not loaded");
        return _ProgramUniform4ui64ARB (program, location, x, y, z, w);
    }
    /// ditto
    public void ProgramUniform1ui64vARB (GLuint program, GLint location, GLsizei count, const(GLuint64)* value) const {
        assert(_ProgramUniform1ui64vARB !is null, "OpenGL command glProgramUniform1ui64vARB was not loaded");
        return _ProgramUniform1ui64vARB (program, location, count, value);
    }
    /// ditto
    public void ProgramUniform2ui64vARB (GLuint program, GLint location, GLsizei count, const(GLuint64)* value) const {
        assert(_ProgramUniform2ui64vARB !is null, "OpenGL command glProgramUniform2ui64vARB was not loaded");
        return _ProgramUniform2ui64vARB (program, location, count, value);
    }
    /// ditto
    public void ProgramUniform3ui64vARB (GLuint program, GLint location, GLsizei count, const(GLuint64)* value) const {
        assert(_ProgramUniform3ui64vARB !is null, "OpenGL command glProgramUniform3ui64vARB was not loaded");
        return _ProgramUniform3ui64vARB (program, location, count, value);
    }
    /// ditto
    public void ProgramUniform4ui64vARB (GLuint program, GLint location, GLsizei count, const(GLuint64)* value) const {
        assert(_ProgramUniform4ui64vARB !is null, "OpenGL command glProgramUniform4ui64vARB was not loaded");
        return _ProgramUniform4ui64vARB (program, location, count, value);
    }

    /// Commands for GL_ARB_parallel_shader_compile
    public void MaxShaderCompilerThreadsARB (GLuint count) const {
        assert(_MaxShaderCompilerThreadsARB !is null, "OpenGL command glMaxShaderCompilerThreadsARB was not loaded");
        return _MaxShaderCompilerThreadsARB (count);
    }

    /// Commands for GL_ARB_robustness
    public GLenum GetGraphicsResetStatusARB () const {
        assert(_GetGraphicsResetStatusARB !is null, "OpenGL command glGetGraphicsResetStatusARB was not loaded");
        return _GetGraphicsResetStatusARB ();
    }
    /// ditto
    public void GetnTexImageARB (GLenum target, GLint level, GLenum format, GLenum type, GLsizei bufSize, void* img) const {
        assert(_GetnTexImageARB !is null, "OpenGL command glGetnTexImageARB was not loaded");
        return _GetnTexImageARB (target, level, format, type, bufSize, img);
    }
    /// ditto
    public void GetnCompressedTexImageARB (GLenum target, GLint lod, GLsizei bufSize, void* img) const {
        assert(_GetnCompressedTexImageARB !is null, "OpenGL command glGetnCompressedTexImageARB was not loaded");
        return _GetnCompressedTexImageARB (target, lod, bufSize, img);
    }
    /// ditto
    public void GetnUniformfvARB (GLuint program, GLint location, GLsizei bufSize, GLfloat* params) const {
        assert(_GetnUniformfvARB !is null, "OpenGL command glGetnUniformfvARB was not loaded");
        return _GetnUniformfvARB (program, location, bufSize, params);
    }
    /// ditto
    public void GetnUniformivARB (GLuint program, GLint location, GLsizei bufSize, GLint* params) const {
        assert(_GetnUniformivARB !is null, "OpenGL command glGetnUniformivARB was not loaded");
        return _GetnUniformivARB (program, location, bufSize, params);
    }
    /// ditto
    public void GetnUniformuivARB (GLuint program, GLint location, GLsizei bufSize, GLuint* params) const {
        assert(_GetnUniformuivARB !is null, "OpenGL command glGetnUniformuivARB was not loaded");
        return _GetnUniformuivARB (program, location, bufSize, params);
    }
    /// ditto
    public void GetnUniformdvARB (GLuint program, GLint location, GLsizei bufSize, GLdouble* params) const {
        assert(_GetnUniformdvARB !is null, "OpenGL command glGetnUniformdvARB was not loaded");
        return _GetnUniformdvARB (program, location, bufSize, params);
    }

    /// Commands for GL_ARB_sample_locations
    public void FramebufferSampleLocationsfvARB (GLenum target, GLuint start, GLsizei count, const(GLfloat)* v) const {
        assert(_FramebufferSampleLocationsfvARB !is null, "OpenGL command glFramebufferSampleLocationsfvARB was not loaded");
        return _FramebufferSampleLocationsfvARB (target, start, count, v);
    }
    /// ditto
    public void NamedFramebufferSampleLocationsfvARB (GLuint framebuffer, GLuint start, GLsizei count, const(GLfloat)* v) const {
        assert(_NamedFramebufferSampleLocationsfvARB !is null, "OpenGL command glNamedFramebufferSampleLocationsfvARB was not loaded");
        return _NamedFramebufferSampleLocationsfvARB (framebuffer, start, count, v);
    }
    /// ditto
    public void EvaluateDepthValuesARB () const {
        assert(_EvaluateDepthValuesARB !is null, "OpenGL command glEvaluateDepthValuesARB was not loaded");
        return _EvaluateDepthValuesARB ();
    }

    /// Commands for GL_ARB_shading_language_include
    public void NamedStringARB (GLenum type, GLint namelen, const(GLchar)* name, GLint stringlen, const(GLchar)* string) const {
        assert(_NamedStringARB !is null, "OpenGL command glNamedStringARB was not loaded");
        return _NamedStringARB (type, namelen, name, stringlen, string);
    }
    /// ditto
    public void DeleteNamedStringARB (GLint namelen, const(GLchar)* name) const {
        assert(_DeleteNamedStringARB !is null, "OpenGL command glDeleteNamedStringARB was not loaded");
        return _DeleteNamedStringARB (namelen, name);
    }
    /// ditto
    public void CompileShaderIncludeARB (GLuint shader, GLsizei count, const(GLchar*)* path, const(GLint)* length) const {
        assert(_CompileShaderIncludeARB !is null, "OpenGL command glCompileShaderIncludeARB was not loaded");
        return _CompileShaderIncludeARB (shader, count, path, length);
    }
    /// ditto
    public GLboolean IsNamedStringARB (GLint namelen, const(GLchar)* name) const {
        assert(_IsNamedStringARB !is null, "OpenGL command glIsNamedStringARB was not loaded");
        return _IsNamedStringARB (namelen, name);
    }
    /// ditto
    public void GetNamedStringARB (GLint namelen, const(GLchar)* name, GLsizei bufSize, GLint* stringlen, GLchar* string) const {
        assert(_GetNamedStringARB !is null, "OpenGL command glGetNamedStringARB was not loaded");
        return _GetNamedStringARB (namelen, name, bufSize, stringlen, string);
    }
    /// ditto
    public void GetNamedStringivARB (GLint namelen, const(GLchar)* name, GLenum pname, GLint* params) const {
        assert(_GetNamedStringivARB !is null, "OpenGL command glGetNamedStringivARB was not loaded");
        return _GetNamedStringivARB (namelen, name, pname, params);
    }

    /// Commands for GL_ARB_sparse_buffer
    public void BufferPageCommitmentARB (GLenum target, GLintptr offset, GLsizeiptr size, GLboolean commit) const {
        assert(_BufferPageCommitmentARB !is null, "OpenGL command glBufferPageCommitmentARB was not loaded");
        return _BufferPageCommitmentARB (target, offset, size, commit);
    }
    /// ditto
    public void NamedBufferPageCommitmentEXT (GLuint buffer, GLintptr offset, GLsizeiptr size, GLboolean commit) const {
        assert(_NamedBufferPageCommitmentEXT !is null, "OpenGL command glNamedBufferPageCommitmentEXT was not loaded");
        return _NamedBufferPageCommitmentEXT (buffer, offset, size, commit);
    }
    /// ditto
    public void NamedBufferPageCommitmentARB (GLuint buffer, GLintptr offset, GLsizeiptr size, GLboolean commit) const {
        assert(_NamedBufferPageCommitmentARB !is null, "OpenGL command glNamedBufferPageCommitmentARB was not loaded");
        return _NamedBufferPageCommitmentARB (buffer, offset, size, commit);
    }

    /// Commands for GL_ARB_sparse_texture
    public void TexPageCommitmentARB (GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint zoffset, GLsizei width, GLsizei height, GLsizei depth, GLboolean commit) const {
        assert(_TexPageCommitmentARB !is null, "OpenGL command glTexPageCommitmentARB was not loaded");
        return _TexPageCommitmentARB (target, level, xoffset, yoffset, zoffset, width, height, depth, commit);
    }

    /// Commands for GL_KHR_blend_equation_advanced
    public void BlendBarrierKHR () const {
        assert(_BlendBarrierKHR !is null, "OpenGL command glBlendBarrierKHR was not loaded");
        return _BlendBarrierKHR ();
    }

    /// Commands for GL_KHR_parallel_shader_compile
    public void MaxShaderCompilerThreadsKHR (GLuint count) const {
        assert(_MaxShaderCompilerThreadsKHR !is null, "OpenGL command glMaxShaderCompilerThreadsKHR was not loaded");
        return _MaxShaderCompilerThreadsKHR (count);
    }

    /// Commands for GL_AMD_performance_monitor
    public void GetPerfMonitorGroupsAMD (GLint* numGroups, GLsizei groupsSize, GLuint* groups) const {
        assert(_GetPerfMonitorGroupsAMD !is null, "OpenGL command glGetPerfMonitorGroupsAMD was not loaded");
        return _GetPerfMonitorGroupsAMD (numGroups, groupsSize, groups);
    }
    /// ditto
    public void GetPerfMonitorCountersAMD (GLuint group, GLint* numCounters, GLint* maxActiveCounters, GLsizei counterSize, GLuint* counters) const {
        assert(_GetPerfMonitorCountersAMD !is null, "OpenGL command glGetPerfMonitorCountersAMD was not loaded");
        return _GetPerfMonitorCountersAMD (group, numCounters, maxActiveCounters, counterSize, counters);
    }
    /// ditto
    public void GetPerfMonitorGroupStringAMD (GLuint group, GLsizei bufSize, GLsizei* length, GLchar* groupString) const {
        assert(_GetPerfMonitorGroupStringAMD !is null, "OpenGL command glGetPerfMonitorGroupStringAMD was not loaded");
        return _GetPerfMonitorGroupStringAMD (group, bufSize, length, groupString);
    }
    /// ditto
    public void GetPerfMonitorCounterStringAMD (GLuint group, GLuint counter, GLsizei bufSize, GLsizei* length, GLchar* counterString) const {
        assert(_GetPerfMonitorCounterStringAMD !is null, "OpenGL command glGetPerfMonitorCounterStringAMD was not loaded");
        return _GetPerfMonitorCounterStringAMD (group, counter, bufSize, length, counterString);
    }
    /// ditto
    public void GetPerfMonitorCounterInfoAMD (GLuint group, GLuint counter, GLenum pname, void* data) const {
        assert(_GetPerfMonitorCounterInfoAMD !is null, "OpenGL command glGetPerfMonitorCounterInfoAMD was not loaded");
        return _GetPerfMonitorCounterInfoAMD (group, counter, pname, data);
    }
    /// ditto
    public void GenPerfMonitorsAMD (GLsizei n, GLuint* monitors) const {
        assert(_GenPerfMonitorsAMD !is null, "OpenGL command glGenPerfMonitorsAMD was not loaded");
        return _GenPerfMonitorsAMD (n, monitors);
    }
    /// ditto
    public void DeletePerfMonitorsAMD (GLsizei n, GLuint* monitors) const {
        assert(_DeletePerfMonitorsAMD !is null, "OpenGL command glDeletePerfMonitorsAMD was not loaded");
        return _DeletePerfMonitorsAMD (n, monitors);
    }
    /// ditto
    public void SelectPerfMonitorCountersAMD (GLuint monitor, GLboolean enable, GLuint group, GLint numCounters, GLuint* counterList) const {
        assert(_SelectPerfMonitorCountersAMD !is null, "OpenGL command glSelectPerfMonitorCountersAMD was not loaded");
        return _SelectPerfMonitorCountersAMD (monitor, enable, group, numCounters, counterList);
    }
    /// ditto
    public void BeginPerfMonitorAMD (GLuint monitor) const {
        assert(_BeginPerfMonitorAMD !is null, "OpenGL command glBeginPerfMonitorAMD was not loaded");
        return _BeginPerfMonitorAMD (monitor);
    }
    /// ditto
    public void EndPerfMonitorAMD (GLuint monitor) const {
        assert(_EndPerfMonitorAMD !is null, "OpenGL command glEndPerfMonitorAMD was not loaded");
        return _EndPerfMonitorAMD (monitor);
    }
    /// ditto
    public void GetPerfMonitorCounterDataAMD (GLuint monitor, GLenum pname, GLsizei dataSize, GLuint* data, GLint* bytesWritten) const {
        assert(_GetPerfMonitorCounterDataAMD !is null, "OpenGL command glGetPerfMonitorCounterDataAMD was not loaded");
        return _GetPerfMonitorCounterDataAMD (monitor, pname, dataSize, data, bytesWritten);
    }

    /// Commands for GL_EXT_debug_label
    public void LabelObjectEXT (GLenum type, GLuint object, GLsizei length, const(GLchar)* label) const {
        assert(_LabelObjectEXT !is null, "OpenGL command glLabelObjectEXT was not loaded");
        return _LabelObjectEXT (type, object, length, label);
    }
    /// ditto
    public void GetObjectLabelEXT (GLenum type, GLuint object, GLsizei bufSize, GLsizei* length, GLchar* label) const {
        assert(_GetObjectLabelEXT !is null, "OpenGL command glGetObjectLabelEXT was not loaded");
        return _GetObjectLabelEXT (type, object, bufSize, length, label);
    }

    /// Commands for GL_EXT_debug_marker
    public void InsertEventMarkerEXT (GLsizei length, const(GLchar)* marker) const {
        assert(_InsertEventMarkerEXT !is null, "OpenGL command glInsertEventMarkerEXT was not loaded");
        return _InsertEventMarkerEXT (length, marker);
    }
    /// ditto
    public void PushGroupMarkerEXT (GLsizei length, const(GLchar)* marker) const {
        assert(_PushGroupMarkerEXT !is null, "OpenGL command glPushGroupMarkerEXT was not loaded");
        return _PushGroupMarkerEXT (length, marker);
    }
    /// ditto
    public void PopGroupMarkerEXT () const {
        assert(_PopGroupMarkerEXT !is null, "OpenGL command glPopGroupMarkerEXT was not loaded");
        return _PopGroupMarkerEXT ();
    }

    /// Commands for GL_EXT_direct_state_access
    public void MatrixLoadfEXT (GLenum mode, const(GLfloat)* m) const {
        assert(_MatrixLoadfEXT !is null, "OpenGL command glMatrixLoadfEXT was not loaded");
        return _MatrixLoadfEXT (mode, m);
    }
    /// ditto
    public void MatrixLoaddEXT (GLenum mode, const(GLdouble)* m) const {
        assert(_MatrixLoaddEXT !is null, "OpenGL command glMatrixLoaddEXT was not loaded");
        return _MatrixLoaddEXT (mode, m);
    }
    /// ditto
    public void MatrixMultfEXT (GLenum mode, const(GLfloat)* m) const {
        assert(_MatrixMultfEXT !is null, "OpenGL command glMatrixMultfEXT was not loaded");
        return _MatrixMultfEXT (mode, m);
    }
    /// ditto
    public void MatrixMultdEXT (GLenum mode, const(GLdouble)* m) const {
        assert(_MatrixMultdEXT !is null, "OpenGL command glMatrixMultdEXT was not loaded");
        return _MatrixMultdEXT (mode, m);
    }
    /// ditto
    public void MatrixLoadIdentityEXT (GLenum mode) const {
        assert(_MatrixLoadIdentityEXT !is null, "OpenGL command glMatrixLoadIdentityEXT was not loaded");
        return _MatrixLoadIdentityEXT (mode);
    }
    /// ditto
    public void MatrixRotatefEXT (GLenum mode, GLfloat angle, GLfloat x, GLfloat y, GLfloat z) const {
        assert(_MatrixRotatefEXT !is null, "OpenGL command glMatrixRotatefEXT was not loaded");
        return _MatrixRotatefEXT (mode, angle, x, y, z);
    }
    /// ditto
    public void MatrixRotatedEXT (GLenum mode, GLdouble angle, GLdouble x, GLdouble y, GLdouble z) const {
        assert(_MatrixRotatedEXT !is null, "OpenGL command glMatrixRotatedEXT was not loaded");
        return _MatrixRotatedEXT (mode, angle, x, y, z);
    }
    /// ditto
    public void MatrixScalefEXT (GLenum mode, GLfloat x, GLfloat y, GLfloat z) const {
        assert(_MatrixScalefEXT !is null, "OpenGL command glMatrixScalefEXT was not loaded");
        return _MatrixScalefEXT (mode, x, y, z);
    }
    /// ditto
    public void MatrixScaledEXT (GLenum mode, GLdouble x, GLdouble y, GLdouble z) const {
        assert(_MatrixScaledEXT !is null, "OpenGL command glMatrixScaledEXT was not loaded");
        return _MatrixScaledEXT (mode, x, y, z);
    }
    /// ditto
    public void MatrixTranslatefEXT (GLenum mode, GLfloat x, GLfloat y, GLfloat z) const {
        assert(_MatrixTranslatefEXT !is null, "OpenGL command glMatrixTranslatefEXT was not loaded");
        return _MatrixTranslatefEXT (mode, x, y, z);
    }
    /// ditto
    public void MatrixTranslatedEXT (GLenum mode, GLdouble x, GLdouble y, GLdouble z) const {
        assert(_MatrixTranslatedEXT !is null, "OpenGL command glMatrixTranslatedEXT was not loaded");
        return _MatrixTranslatedEXT (mode, x, y, z);
    }
    /// ditto
    public void MatrixFrustumEXT (GLenum mode, GLdouble left, GLdouble right, GLdouble bottom, GLdouble top, GLdouble zNear, GLdouble zFar) const {
        assert(_MatrixFrustumEXT !is null, "OpenGL command glMatrixFrustumEXT was not loaded");
        return _MatrixFrustumEXT (mode, left, right, bottom, top, zNear, zFar);
    }
    /// ditto
    public void MatrixOrthoEXT (GLenum mode, GLdouble left, GLdouble right, GLdouble bottom, GLdouble top, GLdouble zNear, GLdouble zFar) const {
        assert(_MatrixOrthoEXT !is null, "OpenGL command glMatrixOrthoEXT was not loaded");
        return _MatrixOrthoEXT (mode, left, right, bottom, top, zNear, zFar);
    }
    /// ditto
    public void MatrixPopEXT (GLenum mode) const {
        assert(_MatrixPopEXT !is null, "OpenGL command glMatrixPopEXT was not loaded");
        return _MatrixPopEXT (mode);
    }
    /// ditto
    public void MatrixPushEXT (GLenum mode) const {
        assert(_MatrixPushEXT !is null, "OpenGL command glMatrixPushEXT was not loaded");
        return _MatrixPushEXT (mode);
    }
    /// ditto
    public void ClientAttribDefaultEXT (GLbitfield mask) const {
        assert(_ClientAttribDefaultEXT !is null, "OpenGL command glClientAttribDefaultEXT was not loaded");
        return _ClientAttribDefaultEXT (mask);
    }
    /// ditto
    public void PushClientAttribDefaultEXT (GLbitfield mask) const {
        assert(_PushClientAttribDefaultEXT !is null, "OpenGL command glPushClientAttribDefaultEXT was not loaded");
        return _PushClientAttribDefaultEXT (mask);
    }
    /// ditto
    public void TextureParameterfEXT (GLuint texture, GLenum target, GLenum pname, GLfloat param) const {
        assert(_TextureParameterfEXT !is null, "OpenGL command glTextureParameterfEXT was not loaded");
        return _TextureParameterfEXT (texture, target, pname, param);
    }
    /// ditto
    public void TextureParameterfvEXT (GLuint texture, GLenum target, GLenum pname, const(GLfloat)* params) const {
        assert(_TextureParameterfvEXT !is null, "OpenGL command glTextureParameterfvEXT was not loaded");
        return _TextureParameterfvEXT (texture, target, pname, params);
    }
    /// ditto
    public void TextureParameteriEXT (GLuint texture, GLenum target, GLenum pname, GLint param) const {
        assert(_TextureParameteriEXT !is null, "OpenGL command glTextureParameteriEXT was not loaded");
        return _TextureParameteriEXT (texture, target, pname, param);
    }
    /// ditto
    public void TextureParameterivEXT (GLuint texture, GLenum target, GLenum pname, const(GLint)* params) const {
        assert(_TextureParameterivEXT !is null, "OpenGL command glTextureParameterivEXT was not loaded");
        return _TextureParameterivEXT (texture, target, pname, params);
    }
    /// ditto
    public void TextureImage1DEXT (GLuint texture, GLenum target, GLint level, GLint internalformat, GLsizei width, GLint border, GLenum format, GLenum type, const(void)* pixels) const {
        assert(_TextureImage1DEXT !is null, "OpenGL command glTextureImage1DEXT was not loaded");
        return _TextureImage1DEXT (texture, target, level, internalformat, width, border, format, type, pixels);
    }
    /// ditto
    public void TextureImage2DEXT (GLuint texture, GLenum target, GLint level, GLint internalformat, GLsizei width, GLsizei height, GLint border, GLenum format, GLenum type, const(void)* pixels) const {
        assert(_TextureImage2DEXT !is null, "OpenGL command glTextureImage2DEXT was not loaded");
        return _TextureImage2DEXT (texture, target, level, internalformat, width, height, border, format, type, pixels);
    }
    /// ditto
    public void TextureSubImage1DEXT (GLuint texture, GLenum target, GLint level, GLint xoffset, GLsizei width, GLenum format, GLenum type, const(void)* pixels) const {
        assert(_TextureSubImage1DEXT !is null, "OpenGL command glTextureSubImage1DEXT was not loaded");
        return _TextureSubImage1DEXT (texture, target, level, xoffset, width, format, type, pixels);
    }
    /// ditto
    public void TextureSubImage2DEXT (GLuint texture, GLenum target, GLint level, GLint xoffset, GLint yoffset, GLsizei width, GLsizei height, GLenum format, GLenum type, const(void)* pixels) const {
        assert(_TextureSubImage2DEXT !is null, "OpenGL command glTextureSubImage2DEXT was not loaded");
        return _TextureSubImage2DEXT (texture, target, level, xoffset, yoffset, width, height, format, type, pixels);
    }
    /// ditto
    public void CopyTextureImage1DEXT (GLuint texture, GLenum target, GLint level, GLenum internalformat, GLint x, GLint y, GLsizei width, GLint border) const {
        assert(_CopyTextureImage1DEXT !is null, "OpenGL command glCopyTextureImage1DEXT was not loaded");
        return _CopyTextureImage1DEXT (texture, target, level, internalformat, x, y, width, border);
    }
    /// ditto
    public void CopyTextureImage2DEXT (GLuint texture, GLenum target, GLint level, GLenum internalformat, GLint x, GLint y, GLsizei width, GLsizei height, GLint border) const {
        assert(_CopyTextureImage2DEXT !is null, "OpenGL command glCopyTextureImage2DEXT was not loaded");
        return _CopyTextureImage2DEXT (texture, target, level, internalformat, x, y, width, height, border);
    }
    /// ditto
    public void CopyTextureSubImage1DEXT (GLuint texture, GLenum target, GLint level, GLint xoffset, GLint x, GLint y, GLsizei width) const {
        assert(_CopyTextureSubImage1DEXT !is null, "OpenGL command glCopyTextureSubImage1DEXT was not loaded");
        return _CopyTextureSubImage1DEXT (texture, target, level, xoffset, x, y, width);
    }
    /// ditto
    public void CopyTextureSubImage2DEXT (GLuint texture, GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint x, GLint y, GLsizei width, GLsizei height) const {
        assert(_CopyTextureSubImage2DEXT !is null, "OpenGL command glCopyTextureSubImage2DEXT was not loaded");
        return _CopyTextureSubImage2DEXT (texture, target, level, xoffset, yoffset, x, y, width, height);
    }
    /// ditto
    public void GetTextureImageEXT (GLuint texture, GLenum target, GLint level, GLenum format, GLenum type, void* pixels) const {
        assert(_GetTextureImageEXT !is null, "OpenGL command glGetTextureImageEXT was not loaded");
        return _GetTextureImageEXT (texture, target, level, format, type, pixels);
    }
    /// ditto
    public void GetTextureParameterfvEXT (GLuint texture, GLenum target, GLenum pname, GLfloat* params) const {
        assert(_GetTextureParameterfvEXT !is null, "OpenGL command glGetTextureParameterfvEXT was not loaded");
        return _GetTextureParameterfvEXT (texture, target, pname, params);
    }
    /// ditto
    public void GetTextureParameterivEXT (GLuint texture, GLenum target, GLenum pname, GLint* params) const {
        assert(_GetTextureParameterivEXT !is null, "OpenGL command glGetTextureParameterivEXT was not loaded");
        return _GetTextureParameterivEXT (texture, target, pname, params);
    }
    /// ditto
    public void GetTextureLevelParameterfvEXT (GLuint texture, GLenum target, GLint level, GLenum pname, GLfloat* params) const {
        assert(_GetTextureLevelParameterfvEXT !is null, "OpenGL command glGetTextureLevelParameterfvEXT was not loaded");
        return _GetTextureLevelParameterfvEXT (texture, target, level, pname, params);
    }
    /// ditto
    public void GetTextureLevelParameterivEXT (GLuint texture, GLenum target, GLint level, GLenum pname, GLint* params) const {
        assert(_GetTextureLevelParameterivEXT !is null, "OpenGL command glGetTextureLevelParameterivEXT was not loaded");
        return _GetTextureLevelParameterivEXT (texture, target, level, pname, params);
    }
    /// ditto
    public void TextureImage3DEXT (GLuint texture, GLenum target, GLint level, GLint internalformat, GLsizei width, GLsizei height, GLsizei depth, GLint border, GLenum format, GLenum type, const(void)* pixels) const {
        assert(_TextureImage3DEXT !is null, "OpenGL command glTextureImage3DEXT was not loaded");
        return _TextureImage3DEXT (texture, target, level, internalformat, width, height, depth, border, format, type, pixels);
    }
    /// ditto
    public void TextureSubImage3DEXT (GLuint texture, GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint zoffset, GLsizei width, GLsizei height, GLsizei depth, GLenum format, GLenum type, const(void)* pixels) const {
        assert(_TextureSubImage3DEXT !is null, "OpenGL command glTextureSubImage3DEXT was not loaded");
        return _TextureSubImage3DEXT (texture, target, level, xoffset, yoffset, zoffset, width, height, depth, format, type, pixels);
    }
    /// ditto
    public void CopyTextureSubImage3DEXT (GLuint texture, GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint zoffset, GLint x, GLint y, GLsizei width, GLsizei height) const {
        assert(_CopyTextureSubImage3DEXT !is null, "OpenGL command glCopyTextureSubImage3DEXT was not loaded");
        return _CopyTextureSubImage3DEXT (texture, target, level, xoffset, yoffset, zoffset, x, y, width, height);
    }
    /// ditto
    public void BindMultiTextureEXT (GLenum texunit, GLenum target, GLuint texture) const {
        assert(_BindMultiTextureEXT !is null, "OpenGL command glBindMultiTextureEXT was not loaded");
        return _BindMultiTextureEXT (texunit, target, texture);
    }
    /// ditto
    public void MultiTexCoordPointerEXT (GLenum texunit, GLint size, GLenum type, GLsizei stride, const(void)* pointer) const {
        assert(_MultiTexCoordPointerEXT !is null, "OpenGL command glMultiTexCoordPointerEXT was not loaded");
        return _MultiTexCoordPointerEXT (texunit, size, type, stride, pointer);
    }
    /// ditto
    public void MultiTexEnvfEXT (GLenum texunit, GLenum target, GLenum pname, GLfloat param) const {
        assert(_MultiTexEnvfEXT !is null, "OpenGL command glMultiTexEnvfEXT was not loaded");
        return _MultiTexEnvfEXT (texunit, target, pname, param);
    }
    /// ditto
    public void MultiTexEnvfvEXT (GLenum texunit, GLenum target, GLenum pname, const(GLfloat)* params) const {
        assert(_MultiTexEnvfvEXT !is null, "OpenGL command glMultiTexEnvfvEXT was not loaded");
        return _MultiTexEnvfvEXT (texunit, target, pname, params);
    }
    /// ditto
    public void MultiTexEnviEXT (GLenum texunit, GLenum target, GLenum pname, GLint param) const {
        assert(_MultiTexEnviEXT !is null, "OpenGL command glMultiTexEnviEXT was not loaded");
        return _MultiTexEnviEXT (texunit, target, pname, param);
    }
    /// ditto
    public void MultiTexEnvivEXT (GLenum texunit, GLenum target, GLenum pname, const(GLint)* params) const {
        assert(_MultiTexEnvivEXT !is null, "OpenGL command glMultiTexEnvivEXT was not loaded");
        return _MultiTexEnvivEXT (texunit, target, pname, params);
    }
    /// ditto
    public void MultiTexGendEXT (GLenum texunit, GLenum coord, GLenum pname, GLdouble param) const {
        assert(_MultiTexGendEXT !is null, "OpenGL command glMultiTexGendEXT was not loaded");
        return _MultiTexGendEXT (texunit, coord, pname, param);
    }
    /// ditto
    public void MultiTexGendvEXT (GLenum texunit, GLenum coord, GLenum pname, const(GLdouble)* params) const {
        assert(_MultiTexGendvEXT !is null, "OpenGL command glMultiTexGendvEXT was not loaded");
        return _MultiTexGendvEXT (texunit, coord, pname, params);
    }
    /// ditto
    public void MultiTexGenfEXT (GLenum texunit, GLenum coord, GLenum pname, GLfloat param) const {
        assert(_MultiTexGenfEXT !is null, "OpenGL command glMultiTexGenfEXT was not loaded");
        return _MultiTexGenfEXT (texunit, coord, pname, param);
    }
    /// ditto
    public void MultiTexGenfvEXT (GLenum texunit, GLenum coord, GLenum pname, const(GLfloat)* params) const {
        assert(_MultiTexGenfvEXT !is null, "OpenGL command glMultiTexGenfvEXT was not loaded");
        return _MultiTexGenfvEXT (texunit, coord, pname, params);
    }
    /// ditto
    public void MultiTexGeniEXT (GLenum texunit, GLenum coord, GLenum pname, GLint param) const {
        assert(_MultiTexGeniEXT !is null, "OpenGL command glMultiTexGeniEXT was not loaded");
        return _MultiTexGeniEXT (texunit, coord, pname, param);
    }
    /// ditto
    public void MultiTexGenivEXT (GLenum texunit, GLenum coord, GLenum pname, const(GLint)* params) const {
        assert(_MultiTexGenivEXT !is null, "OpenGL command glMultiTexGenivEXT was not loaded");
        return _MultiTexGenivEXT (texunit, coord, pname, params);
    }
    /// ditto
    public void GetMultiTexEnvfvEXT (GLenum texunit, GLenum target, GLenum pname, GLfloat* params) const {
        assert(_GetMultiTexEnvfvEXT !is null, "OpenGL command glGetMultiTexEnvfvEXT was not loaded");
        return _GetMultiTexEnvfvEXT (texunit, target, pname, params);
    }
    /// ditto
    public void GetMultiTexEnvivEXT (GLenum texunit, GLenum target, GLenum pname, GLint* params) const {
        assert(_GetMultiTexEnvivEXT !is null, "OpenGL command glGetMultiTexEnvivEXT was not loaded");
        return _GetMultiTexEnvivEXT (texunit, target, pname, params);
    }
    /// ditto
    public void GetMultiTexGendvEXT (GLenum texunit, GLenum coord, GLenum pname, GLdouble* params) const {
        assert(_GetMultiTexGendvEXT !is null, "OpenGL command glGetMultiTexGendvEXT was not loaded");
        return _GetMultiTexGendvEXT (texunit, coord, pname, params);
    }
    /// ditto
    public void GetMultiTexGenfvEXT (GLenum texunit, GLenum coord, GLenum pname, GLfloat* params) const {
        assert(_GetMultiTexGenfvEXT !is null, "OpenGL command glGetMultiTexGenfvEXT was not loaded");
        return _GetMultiTexGenfvEXT (texunit, coord, pname, params);
    }
    /// ditto
    public void GetMultiTexGenivEXT (GLenum texunit, GLenum coord, GLenum pname, GLint* params) const {
        assert(_GetMultiTexGenivEXT !is null, "OpenGL command glGetMultiTexGenivEXT was not loaded");
        return _GetMultiTexGenivEXT (texunit, coord, pname, params);
    }
    /// ditto
    public void MultiTexParameteriEXT (GLenum texunit, GLenum target, GLenum pname, GLint param) const {
        assert(_MultiTexParameteriEXT !is null, "OpenGL command glMultiTexParameteriEXT was not loaded");
        return _MultiTexParameteriEXT (texunit, target, pname, param);
    }
    /// ditto
    public void MultiTexParameterivEXT (GLenum texunit, GLenum target, GLenum pname, const(GLint)* params) const {
        assert(_MultiTexParameterivEXT !is null, "OpenGL command glMultiTexParameterivEXT was not loaded");
        return _MultiTexParameterivEXT (texunit, target, pname, params);
    }
    /// ditto
    public void MultiTexParameterfEXT (GLenum texunit, GLenum target, GLenum pname, GLfloat param) const {
        assert(_MultiTexParameterfEXT !is null, "OpenGL command glMultiTexParameterfEXT was not loaded");
        return _MultiTexParameterfEXT (texunit, target, pname, param);
    }
    /// ditto
    public void MultiTexParameterfvEXT (GLenum texunit, GLenum target, GLenum pname, const(GLfloat)* params) const {
        assert(_MultiTexParameterfvEXT !is null, "OpenGL command glMultiTexParameterfvEXT was not loaded");
        return _MultiTexParameterfvEXT (texunit, target, pname, params);
    }
    /// ditto
    public void MultiTexImage1DEXT (GLenum texunit, GLenum target, GLint level, GLint internalformat, GLsizei width, GLint border, GLenum format, GLenum type, const(void)* pixels) const {
        assert(_MultiTexImage1DEXT !is null, "OpenGL command glMultiTexImage1DEXT was not loaded");
        return _MultiTexImage1DEXT (texunit, target, level, internalformat, width, border, format, type, pixels);
    }
    /// ditto
    public void MultiTexImage2DEXT (GLenum texunit, GLenum target, GLint level, GLint internalformat, GLsizei width, GLsizei height, GLint border, GLenum format, GLenum type, const(void)* pixels) const {
        assert(_MultiTexImage2DEXT !is null, "OpenGL command glMultiTexImage2DEXT was not loaded");
        return _MultiTexImage2DEXT (texunit, target, level, internalformat, width, height, border, format, type, pixels);
    }
    /// ditto
    public void MultiTexSubImage1DEXT (GLenum texunit, GLenum target, GLint level, GLint xoffset, GLsizei width, GLenum format, GLenum type, const(void)* pixels) const {
        assert(_MultiTexSubImage1DEXT !is null, "OpenGL command glMultiTexSubImage1DEXT was not loaded");
        return _MultiTexSubImage1DEXT (texunit, target, level, xoffset, width, format, type, pixels);
    }
    /// ditto
    public void MultiTexSubImage2DEXT (GLenum texunit, GLenum target, GLint level, GLint xoffset, GLint yoffset, GLsizei width, GLsizei height, GLenum format, GLenum type, const(void)* pixels) const {
        assert(_MultiTexSubImage2DEXT !is null, "OpenGL command glMultiTexSubImage2DEXT was not loaded");
        return _MultiTexSubImage2DEXT (texunit, target, level, xoffset, yoffset, width, height, format, type, pixels);
    }
    /// ditto
    public void CopyMultiTexImage1DEXT (GLenum texunit, GLenum target, GLint level, GLenum internalformat, GLint x, GLint y, GLsizei width, GLint border) const {
        assert(_CopyMultiTexImage1DEXT !is null, "OpenGL command glCopyMultiTexImage1DEXT was not loaded");
        return _CopyMultiTexImage1DEXT (texunit, target, level, internalformat, x, y, width, border);
    }
    /// ditto
    public void CopyMultiTexImage2DEXT (GLenum texunit, GLenum target, GLint level, GLenum internalformat, GLint x, GLint y, GLsizei width, GLsizei height, GLint border) const {
        assert(_CopyMultiTexImage2DEXT !is null, "OpenGL command glCopyMultiTexImage2DEXT was not loaded");
        return _CopyMultiTexImage2DEXT (texunit, target, level, internalformat, x, y, width, height, border);
    }
    /// ditto
    public void CopyMultiTexSubImage1DEXT (GLenum texunit, GLenum target, GLint level, GLint xoffset, GLint x, GLint y, GLsizei width) const {
        assert(_CopyMultiTexSubImage1DEXT !is null, "OpenGL command glCopyMultiTexSubImage1DEXT was not loaded");
        return _CopyMultiTexSubImage1DEXT (texunit, target, level, xoffset, x, y, width);
    }
    /// ditto
    public void CopyMultiTexSubImage2DEXT (GLenum texunit, GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint x, GLint y, GLsizei width, GLsizei height) const {
        assert(_CopyMultiTexSubImage2DEXT !is null, "OpenGL command glCopyMultiTexSubImage2DEXT was not loaded");
        return _CopyMultiTexSubImage2DEXT (texunit, target, level, xoffset, yoffset, x, y, width, height);
    }
    /// ditto
    public void GetMultiTexImageEXT (GLenum texunit, GLenum target, GLint level, GLenum format, GLenum type, void* pixels) const {
        assert(_GetMultiTexImageEXT !is null, "OpenGL command glGetMultiTexImageEXT was not loaded");
        return _GetMultiTexImageEXT (texunit, target, level, format, type, pixels);
    }
    /// ditto
    public void GetMultiTexParameterfvEXT (GLenum texunit, GLenum target, GLenum pname, GLfloat* params) const {
        assert(_GetMultiTexParameterfvEXT !is null, "OpenGL command glGetMultiTexParameterfvEXT was not loaded");
        return _GetMultiTexParameterfvEXT (texunit, target, pname, params);
    }
    /// ditto
    public void GetMultiTexParameterivEXT (GLenum texunit, GLenum target, GLenum pname, GLint* params) const {
        assert(_GetMultiTexParameterivEXT !is null, "OpenGL command glGetMultiTexParameterivEXT was not loaded");
        return _GetMultiTexParameterivEXT (texunit, target, pname, params);
    }
    /// ditto
    public void GetMultiTexLevelParameterfvEXT (GLenum texunit, GLenum target, GLint level, GLenum pname, GLfloat* params) const {
        assert(_GetMultiTexLevelParameterfvEXT !is null, "OpenGL command glGetMultiTexLevelParameterfvEXT was not loaded");
        return _GetMultiTexLevelParameterfvEXT (texunit, target, level, pname, params);
    }
    /// ditto
    public void GetMultiTexLevelParameterivEXT (GLenum texunit, GLenum target, GLint level, GLenum pname, GLint* params) const {
        assert(_GetMultiTexLevelParameterivEXT !is null, "OpenGL command glGetMultiTexLevelParameterivEXT was not loaded");
        return _GetMultiTexLevelParameterivEXT (texunit, target, level, pname, params);
    }
    /// ditto
    public void MultiTexImage3DEXT (GLenum texunit, GLenum target, GLint level, GLint internalformat, GLsizei width, GLsizei height, GLsizei depth, GLint border, GLenum format, GLenum type, const(void)* pixels) const {
        assert(_MultiTexImage3DEXT !is null, "OpenGL command glMultiTexImage3DEXT was not loaded");
        return _MultiTexImage3DEXT (texunit, target, level, internalformat, width, height, depth, border, format, type, pixels);
    }
    /// ditto
    public void MultiTexSubImage3DEXT (GLenum texunit, GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint zoffset, GLsizei width, GLsizei height, GLsizei depth, GLenum format, GLenum type, const(void)* pixels) const {
        assert(_MultiTexSubImage3DEXT !is null, "OpenGL command glMultiTexSubImage3DEXT was not loaded");
        return _MultiTexSubImage3DEXT (texunit, target, level, xoffset, yoffset, zoffset, width, height, depth, format, type, pixels);
    }
    /// ditto
    public void CopyMultiTexSubImage3DEXT (GLenum texunit, GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint zoffset, GLint x, GLint y, GLsizei width, GLsizei height) const {
        assert(_CopyMultiTexSubImage3DEXT !is null, "OpenGL command glCopyMultiTexSubImage3DEXT was not loaded");
        return _CopyMultiTexSubImage3DEXT (texunit, target, level, xoffset, yoffset, zoffset, x, y, width, height);
    }
    /// ditto
    public void EnableClientStateIndexedEXT (GLenum array, GLuint index) const {
        assert(_EnableClientStateIndexedEXT !is null, "OpenGL command glEnableClientStateIndexedEXT was not loaded");
        return _EnableClientStateIndexedEXT (array, index);
    }
    /// ditto
    public void DisableClientStateIndexedEXT (GLenum array, GLuint index) const {
        assert(_DisableClientStateIndexedEXT !is null, "OpenGL command glDisableClientStateIndexedEXT was not loaded");
        return _DisableClientStateIndexedEXT (array, index);
    }
    /// ditto
    public void GetPointerIndexedvEXT (GLenum target, GLuint index, void** data) const {
        assert(_GetPointerIndexedvEXT !is null, "OpenGL command glGetPointerIndexedvEXT was not loaded");
        return _GetPointerIndexedvEXT (target, index, data);
    }
    /// ditto
    public void CompressedTextureImage3DEXT (GLuint texture, GLenum target, GLint level, GLenum internalformat, GLsizei width, GLsizei height, GLsizei depth, GLint border, GLsizei imageSize, const(void)* bits) const {
        assert(_CompressedTextureImage3DEXT !is null, "OpenGL command glCompressedTextureImage3DEXT was not loaded");
        return _CompressedTextureImage3DEXT (texture, target, level, internalformat, width, height, depth, border, imageSize, bits);
    }
    /// ditto
    public void CompressedTextureImage2DEXT (GLuint texture, GLenum target, GLint level, GLenum internalformat, GLsizei width, GLsizei height, GLint border, GLsizei imageSize, const(void)* bits) const {
        assert(_CompressedTextureImage2DEXT !is null, "OpenGL command glCompressedTextureImage2DEXT was not loaded");
        return _CompressedTextureImage2DEXT (texture, target, level, internalformat, width, height, border, imageSize, bits);
    }
    /// ditto
    public void CompressedTextureImage1DEXT (GLuint texture, GLenum target, GLint level, GLenum internalformat, GLsizei width, GLint border, GLsizei imageSize, const(void)* bits) const {
        assert(_CompressedTextureImage1DEXT !is null, "OpenGL command glCompressedTextureImage1DEXT was not loaded");
        return _CompressedTextureImage1DEXT (texture, target, level, internalformat, width, border, imageSize, bits);
    }
    /// ditto
    public void CompressedTextureSubImage3DEXT (GLuint texture, GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint zoffset, GLsizei width, GLsizei height, GLsizei depth, GLenum format, GLsizei imageSize, const(void)* bits) const {
        assert(_CompressedTextureSubImage3DEXT !is null, "OpenGL command glCompressedTextureSubImage3DEXT was not loaded");
        return _CompressedTextureSubImage3DEXT (texture, target, level, xoffset, yoffset, zoffset, width, height, depth, format, imageSize, bits);
    }
    /// ditto
    public void CompressedTextureSubImage2DEXT (GLuint texture, GLenum target, GLint level, GLint xoffset, GLint yoffset, GLsizei width, GLsizei height, GLenum format, GLsizei imageSize, const(void)* bits) const {
        assert(_CompressedTextureSubImage2DEXT !is null, "OpenGL command glCompressedTextureSubImage2DEXT was not loaded");
        return _CompressedTextureSubImage2DEXT (texture, target, level, xoffset, yoffset, width, height, format, imageSize, bits);
    }
    /// ditto
    public void CompressedTextureSubImage1DEXT (GLuint texture, GLenum target, GLint level, GLint xoffset, GLsizei width, GLenum format, GLsizei imageSize, const(void)* bits) const {
        assert(_CompressedTextureSubImage1DEXT !is null, "OpenGL command glCompressedTextureSubImage1DEXT was not loaded");
        return _CompressedTextureSubImage1DEXT (texture, target, level, xoffset, width, format, imageSize, bits);
    }
    /// ditto
    public void GetCompressedTextureImageEXT (GLuint texture, GLenum target, GLint lod, void* img) const {
        assert(_GetCompressedTextureImageEXT !is null, "OpenGL command glGetCompressedTextureImageEXT was not loaded");
        return _GetCompressedTextureImageEXT (texture, target, lod, img);
    }
    /// ditto
    public void CompressedMultiTexImage3DEXT (GLenum texunit, GLenum target, GLint level, GLenum internalformat, GLsizei width, GLsizei height, GLsizei depth, GLint border, GLsizei imageSize, const(void)* bits) const {
        assert(_CompressedMultiTexImage3DEXT !is null, "OpenGL command glCompressedMultiTexImage3DEXT was not loaded");
        return _CompressedMultiTexImage3DEXT (texunit, target, level, internalformat, width, height, depth, border, imageSize, bits);
    }
    /// ditto
    public void CompressedMultiTexImage2DEXT (GLenum texunit, GLenum target, GLint level, GLenum internalformat, GLsizei width, GLsizei height, GLint border, GLsizei imageSize, const(void)* bits) const {
        assert(_CompressedMultiTexImage2DEXT !is null, "OpenGL command glCompressedMultiTexImage2DEXT was not loaded");
        return _CompressedMultiTexImage2DEXT (texunit, target, level, internalformat, width, height, border, imageSize, bits);
    }
    /// ditto
    public void CompressedMultiTexImage1DEXT (GLenum texunit, GLenum target, GLint level, GLenum internalformat, GLsizei width, GLint border, GLsizei imageSize, const(void)* bits) const {
        assert(_CompressedMultiTexImage1DEXT !is null, "OpenGL command glCompressedMultiTexImage1DEXT was not loaded");
        return _CompressedMultiTexImage1DEXT (texunit, target, level, internalformat, width, border, imageSize, bits);
    }
    /// ditto
    public void CompressedMultiTexSubImage3DEXT (GLenum texunit, GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint zoffset, GLsizei width, GLsizei height, GLsizei depth, GLenum format, GLsizei imageSize, const(void)* bits) const {
        assert(_CompressedMultiTexSubImage3DEXT !is null, "OpenGL command glCompressedMultiTexSubImage3DEXT was not loaded");
        return _CompressedMultiTexSubImage3DEXT (texunit, target, level, xoffset, yoffset, zoffset, width, height, depth, format, imageSize, bits);
    }
    /// ditto
    public void CompressedMultiTexSubImage2DEXT (GLenum texunit, GLenum target, GLint level, GLint xoffset, GLint yoffset, GLsizei width, GLsizei height, GLenum format, GLsizei imageSize, const(void)* bits) const {
        assert(_CompressedMultiTexSubImage2DEXT !is null, "OpenGL command glCompressedMultiTexSubImage2DEXT was not loaded");
        return _CompressedMultiTexSubImage2DEXT (texunit, target, level, xoffset, yoffset, width, height, format, imageSize, bits);
    }
    /// ditto
    public void CompressedMultiTexSubImage1DEXT (GLenum texunit, GLenum target, GLint level, GLint xoffset, GLsizei width, GLenum format, GLsizei imageSize, const(void)* bits) const {
        assert(_CompressedMultiTexSubImage1DEXT !is null, "OpenGL command glCompressedMultiTexSubImage1DEXT was not loaded");
        return _CompressedMultiTexSubImage1DEXT (texunit, target, level, xoffset, width, format, imageSize, bits);
    }
    /// ditto
    public void GetCompressedMultiTexImageEXT (GLenum texunit, GLenum target, GLint lod, void* img) const {
        assert(_GetCompressedMultiTexImageEXT !is null, "OpenGL command glGetCompressedMultiTexImageEXT was not loaded");
        return _GetCompressedMultiTexImageEXT (texunit, target, lod, img);
    }
    /// ditto
    public void MatrixLoadTransposefEXT (GLenum mode, const(GLfloat)* m) const {
        assert(_MatrixLoadTransposefEXT !is null, "OpenGL command glMatrixLoadTransposefEXT was not loaded");
        return _MatrixLoadTransposefEXT (mode, m);
    }
    /// ditto
    public void MatrixLoadTransposedEXT (GLenum mode, const(GLdouble)* m) const {
        assert(_MatrixLoadTransposedEXT !is null, "OpenGL command glMatrixLoadTransposedEXT was not loaded");
        return _MatrixLoadTransposedEXT (mode, m);
    }
    /// ditto
    public void MatrixMultTransposefEXT (GLenum mode, const(GLfloat)* m) const {
        assert(_MatrixMultTransposefEXT !is null, "OpenGL command glMatrixMultTransposefEXT was not loaded");
        return _MatrixMultTransposefEXT (mode, m);
    }
    /// ditto
    public void MatrixMultTransposedEXT (GLenum mode, const(GLdouble)* m) const {
        assert(_MatrixMultTransposedEXT !is null, "OpenGL command glMatrixMultTransposedEXT was not loaded");
        return _MatrixMultTransposedEXT (mode, m);
    }
    /// ditto
    public void NamedBufferDataEXT (GLuint buffer, GLsizeiptr size, const(void)* data, GLenum usage) const {
        assert(_NamedBufferDataEXT !is null, "OpenGL command glNamedBufferDataEXT was not loaded");
        return _NamedBufferDataEXT (buffer, size, data, usage);
    }
    /// ditto
    public void * MapNamedBufferEXT (GLuint buffer, GLenum access) const {
        assert(_MapNamedBufferEXT !is null, "OpenGL command glMapNamedBufferEXT was not loaded");
        return _MapNamedBufferEXT (buffer, access);
    }
    /// ditto
    public GLboolean UnmapNamedBufferEXT (GLuint buffer) const {
        assert(_UnmapNamedBufferEXT !is null, "OpenGL command glUnmapNamedBufferEXT was not loaded");
        return _UnmapNamedBufferEXT (buffer);
    }
    /// ditto
    public void GetNamedBufferParameterivEXT (GLuint buffer, GLenum pname, GLint* params) const {
        assert(_GetNamedBufferParameterivEXT !is null, "OpenGL command glGetNamedBufferParameterivEXT was not loaded");
        return _GetNamedBufferParameterivEXT (buffer, pname, params);
    }
    /// ditto
    public void GetNamedBufferPointervEXT (GLuint buffer, GLenum pname, void** params) const {
        assert(_GetNamedBufferPointervEXT !is null, "OpenGL command glGetNamedBufferPointervEXT was not loaded");
        return _GetNamedBufferPointervEXT (buffer, pname, params);
    }
    /// ditto
    public void GetNamedBufferSubDataEXT (GLuint buffer, GLintptr offset, GLsizeiptr size, void* data) const {
        assert(_GetNamedBufferSubDataEXT !is null, "OpenGL command glGetNamedBufferSubDataEXT was not loaded");
        return _GetNamedBufferSubDataEXT (buffer, offset, size, data);
    }
    /// ditto
    public void TextureBufferEXT (GLuint texture, GLenum target, GLenum internalformat, GLuint buffer) const {
        assert(_TextureBufferEXT !is null, "OpenGL command glTextureBufferEXT was not loaded");
        return _TextureBufferEXT (texture, target, internalformat, buffer);
    }
    /// ditto
    public void MultiTexBufferEXT (GLenum texunit, GLenum target, GLenum internalformat, GLuint buffer) const {
        assert(_MultiTexBufferEXT !is null, "OpenGL command glMultiTexBufferEXT was not loaded");
        return _MultiTexBufferEXT (texunit, target, internalformat, buffer);
    }
    /// ditto
    public void TextureParameterIivEXT (GLuint texture, GLenum target, GLenum pname, const(GLint)* params) const {
        assert(_TextureParameterIivEXT !is null, "OpenGL command glTextureParameterIivEXT was not loaded");
        return _TextureParameterIivEXT (texture, target, pname, params);
    }
    /// ditto
    public void TextureParameterIuivEXT (GLuint texture, GLenum target, GLenum pname, const(GLuint)* params) const {
        assert(_TextureParameterIuivEXT !is null, "OpenGL command glTextureParameterIuivEXT was not loaded");
        return _TextureParameterIuivEXT (texture, target, pname, params);
    }
    /// ditto
    public void GetTextureParameterIivEXT (GLuint texture, GLenum target, GLenum pname, GLint* params) const {
        assert(_GetTextureParameterIivEXT !is null, "OpenGL command glGetTextureParameterIivEXT was not loaded");
        return _GetTextureParameterIivEXT (texture, target, pname, params);
    }
    /// ditto
    public void GetTextureParameterIuivEXT (GLuint texture, GLenum target, GLenum pname, GLuint* params) const {
        assert(_GetTextureParameterIuivEXT !is null, "OpenGL command glGetTextureParameterIuivEXT was not loaded");
        return _GetTextureParameterIuivEXT (texture, target, pname, params);
    }
    /// ditto
    public void MultiTexParameterIivEXT (GLenum texunit, GLenum target, GLenum pname, const(GLint)* params) const {
        assert(_MultiTexParameterIivEXT !is null, "OpenGL command glMultiTexParameterIivEXT was not loaded");
        return _MultiTexParameterIivEXT (texunit, target, pname, params);
    }
    /// ditto
    public void MultiTexParameterIuivEXT (GLenum texunit, GLenum target, GLenum pname, const(GLuint)* params) const {
        assert(_MultiTexParameterIuivEXT !is null, "OpenGL command glMultiTexParameterIuivEXT was not loaded");
        return _MultiTexParameterIuivEXT (texunit, target, pname, params);
    }
    /// ditto
    public void GetMultiTexParameterIivEXT (GLenum texunit, GLenum target, GLenum pname, GLint* params) const {
        assert(_GetMultiTexParameterIivEXT !is null, "OpenGL command glGetMultiTexParameterIivEXT was not loaded");
        return _GetMultiTexParameterIivEXT (texunit, target, pname, params);
    }
    /// ditto
    public void GetMultiTexParameterIuivEXT (GLenum texunit, GLenum target, GLenum pname, GLuint* params) const {
        assert(_GetMultiTexParameterIuivEXT !is null, "OpenGL command glGetMultiTexParameterIuivEXT was not loaded");
        return _GetMultiTexParameterIuivEXT (texunit, target, pname, params);
    }
    /// ditto
    public void NamedProgramLocalParameters4fvEXT (GLuint program, GLenum target, GLuint index, GLsizei count, const(GLfloat)* params) const {
        assert(_NamedProgramLocalParameters4fvEXT !is null, "OpenGL command glNamedProgramLocalParameters4fvEXT was not loaded");
        return _NamedProgramLocalParameters4fvEXT (program, target, index, count, params);
    }
    /// ditto
    public void NamedProgramLocalParameterI4iEXT (GLuint program, GLenum target, GLuint index, GLint x, GLint y, GLint z, GLint w) const {
        assert(_NamedProgramLocalParameterI4iEXT !is null, "OpenGL command glNamedProgramLocalParameterI4iEXT was not loaded");
        return _NamedProgramLocalParameterI4iEXT (program, target, index, x, y, z, w);
    }
    /// ditto
    public void NamedProgramLocalParameterI4ivEXT (GLuint program, GLenum target, GLuint index, const(GLint)* params) const {
        assert(_NamedProgramLocalParameterI4ivEXT !is null, "OpenGL command glNamedProgramLocalParameterI4ivEXT was not loaded");
        return _NamedProgramLocalParameterI4ivEXT (program, target, index, params);
    }
    /// ditto
    public void NamedProgramLocalParametersI4ivEXT (GLuint program, GLenum target, GLuint index, GLsizei count, const(GLint)* params) const {
        assert(_NamedProgramLocalParametersI4ivEXT !is null, "OpenGL command glNamedProgramLocalParametersI4ivEXT was not loaded");
        return _NamedProgramLocalParametersI4ivEXT (program, target, index, count, params);
    }
    /// ditto
    public void NamedProgramLocalParameterI4uiEXT (GLuint program, GLenum target, GLuint index, GLuint x, GLuint y, GLuint z, GLuint w) const {
        assert(_NamedProgramLocalParameterI4uiEXT !is null, "OpenGL command glNamedProgramLocalParameterI4uiEXT was not loaded");
        return _NamedProgramLocalParameterI4uiEXT (program, target, index, x, y, z, w);
    }
    /// ditto
    public void NamedProgramLocalParameterI4uivEXT (GLuint program, GLenum target, GLuint index, const(GLuint)* params) const {
        assert(_NamedProgramLocalParameterI4uivEXT !is null, "OpenGL command glNamedProgramLocalParameterI4uivEXT was not loaded");
        return _NamedProgramLocalParameterI4uivEXT (program, target, index, params);
    }
    /// ditto
    public void NamedProgramLocalParametersI4uivEXT (GLuint program, GLenum target, GLuint index, GLsizei count, const(GLuint)* params) const {
        assert(_NamedProgramLocalParametersI4uivEXT !is null, "OpenGL command glNamedProgramLocalParametersI4uivEXT was not loaded");
        return _NamedProgramLocalParametersI4uivEXT (program, target, index, count, params);
    }
    /// ditto
    public void GetNamedProgramLocalParameterIivEXT (GLuint program, GLenum target, GLuint index, GLint* params) const {
        assert(_GetNamedProgramLocalParameterIivEXT !is null, "OpenGL command glGetNamedProgramLocalParameterIivEXT was not loaded");
        return _GetNamedProgramLocalParameterIivEXT (program, target, index, params);
    }
    /// ditto
    public void GetNamedProgramLocalParameterIuivEXT (GLuint program, GLenum target, GLuint index, GLuint* params) const {
        assert(_GetNamedProgramLocalParameterIuivEXT !is null, "OpenGL command glGetNamedProgramLocalParameterIuivEXT was not loaded");
        return _GetNamedProgramLocalParameterIuivEXT (program, target, index, params);
    }
    /// ditto
    public void EnableClientStateiEXT (GLenum array, GLuint index) const {
        assert(_EnableClientStateiEXT !is null, "OpenGL command glEnableClientStateiEXT was not loaded");
        return _EnableClientStateiEXT (array, index);
    }
    /// ditto
    public void DisableClientStateiEXT (GLenum array, GLuint index) const {
        assert(_DisableClientStateiEXT !is null, "OpenGL command glDisableClientStateiEXT was not loaded");
        return _DisableClientStateiEXT (array, index);
    }
    /// ditto
    public void GetPointeri_vEXT (GLenum pname, GLuint index, void** params) const {
        assert(_GetPointeri_vEXT !is null, "OpenGL command glGetPointeri_vEXT was not loaded");
        return _GetPointeri_vEXT (pname, index, params);
    }
    /// ditto
    public void NamedProgramStringEXT (GLuint program, GLenum target, GLenum format, GLsizei len, const(void)* string) const {
        assert(_NamedProgramStringEXT !is null, "OpenGL command glNamedProgramStringEXT was not loaded");
        return _NamedProgramStringEXT (program, target, format, len, string);
    }
    /// ditto
    public void NamedProgramLocalParameter4dEXT (GLuint program, GLenum target, GLuint index, GLdouble x, GLdouble y, GLdouble z, GLdouble w) const {
        assert(_NamedProgramLocalParameter4dEXT !is null, "OpenGL command glNamedProgramLocalParameter4dEXT was not loaded");
        return _NamedProgramLocalParameter4dEXT (program, target, index, x, y, z, w);
    }
    /// ditto
    public void NamedProgramLocalParameter4dvEXT (GLuint program, GLenum target, GLuint index, const(GLdouble)* params) const {
        assert(_NamedProgramLocalParameter4dvEXT !is null, "OpenGL command glNamedProgramLocalParameter4dvEXT was not loaded");
        return _NamedProgramLocalParameter4dvEXT (program, target, index, params);
    }
    /// ditto
    public void NamedProgramLocalParameter4fEXT (GLuint program, GLenum target, GLuint index, GLfloat x, GLfloat y, GLfloat z, GLfloat w) const {
        assert(_NamedProgramLocalParameter4fEXT !is null, "OpenGL command glNamedProgramLocalParameter4fEXT was not loaded");
        return _NamedProgramLocalParameter4fEXT (program, target, index, x, y, z, w);
    }
    /// ditto
    public void NamedProgramLocalParameter4fvEXT (GLuint program, GLenum target, GLuint index, const(GLfloat)* params) const {
        assert(_NamedProgramLocalParameter4fvEXT !is null, "OpenGL command glNamedProgramLocalParameter4fvEXT was not loaded");
        return _NamedProgramLocalParameter4fvEXT (program, target, index, params);
    }
    /// ditto
    public void GetNamedProgramLocalParameterdvEXT (GLuint program, GLenum target, GLuint index, GLdouble* params) const {
        assert(_GetNamedProgramLocalParameterdvEXT !is null, "OpenGL command glGetNamedProgramLocalParameterdvEXT was not loaded");
        return _GetNamedProgramLocalParameterdvEXT (program, target, index, params);
    }
    /// ditto
    public void GetNamedProgramLocalParameterfvEXT (GLuint program, GLenum target, GLuint index, GLfloat* params) const {
        assert(_GetNamedProgramLocalParameterfvEXT !is null, "OpenGL command glGetNamedProgramLocalParameterfvEXT was not loaded");
        return _GetNamedProgramLocalParameterfvEXT (program, target, index, params);
    }
    /// ditto
    public void GetNamedProgramivEXT (GLuint program, GLenum target, GLenum pname, GLint* params) const {
        assert(_GetNamedProgramivEXT !is null, "OpenGL command glGetNamedProgramivEXT was not loaded");
        return _GetNamedProgramivEXT (program, target, pname, params);
    }
    /// ditto
    public void GetNamedProgramStringEXT (GLuint program, GLenum target, GLenum pname, void* string) const {
        assert(_GetNamedProgramStringEXT !is null, "OpenGL command glGetNamedProgramStringEXT was not loaded");
        return _GetNamedProgramStringEXT (program, target, pname, string);
    }
    /// ditto
    public void NamedRenderbufferStorageEXT (GLuint renderbuffer, GLenum internalformat, GLsizei width, GLsizei height) const {
        assert(_NamedRenderbufferStorageEXT !is null, "OpenGL command glNamedRenderbufferStorageEXT was not loaded");
        return _NamedRenderbufferStorageEXT (renderbuffer, internalformat, width, height);
    }
    /// ditto
    public void GetNamedRenderbufferParameterivEXT (GLuint renderbuffer, GLenum pname, GLint* params) const {
        assert(_GetNamedRenderbufferParameterivEXT !is null, "OpenGL command glGetNamedRenderbufferParameterivEXT was not loaded");
        return _GetNamedRenderbufferParameterivEXT (renderbuffer, pname, params);
    }
    /// ditto
    public void NamedRenderbufferStorageMultisampleEXT (GLuint renderbuffer, GLsizei samples, GLenum internalformat, GLsizei width, GLsizei height) const {
        assert(_NamedRenderbufferStorageMultisampleEXT !is null, "OpenGL command glNamedRenderbufferStorageMultisampleEXT was not loaded");
        return _NamedRenderbufferStorageMultisampleEXT (renderbuffer, samples, internalformat, width, height);
    }
    /// ditto
    public void NamedRenderbufferStorageMultisampleCoverageEXT (GLuint renderbuffer, GLsizei coverageSamples, GLsizei colorSamples, GLenum internalformat, GLsizei width, GLsizei height) const {
        assert(_NamedRenderbufferStorageMultisampleCoverageEXT !is null, "OpenGL command glNamedRenderbufferStorageMultisampleCoverageEXT was not loaded");
        return _NamedRenderbufferStorageMultisampleCoverageEXT (renderbuffer, coverageSamples, colorSamples, internalformat, width, height);
    }
    /// ditto
    public GLenum CheckNamedFramebufferStatusEXT (GLuint framebuffer, GLenum target) const {
        assert(_CheckNamedFramebufferStatusEXT !is null, "OpenGL command glCheckNamedFramebufferStatusEXT was not loaded");
        return _CheckNamedFramebufferStatusEXT (framebuffer, target);
    }
    /// ditto
    public void NamedFramebufferTexture1DEXT (GLuint framebuffer, GLenum attachment, GLenum textarget, GLuint texture, GLint level) const {
        assert(_NamedFramebufferTexture1DEXT !is null, "OpenGL command glNamedFramebufferTexture1DEXT was not loaded");
        return _NamedFramebufferTexture1DEXT (framebuffer, attachment, textarget, texture, level);
    }
    /// ditto
    public void NamedFramebufferTexture2DEXT (GLuint framebuffer, GLenum attachment, GLenum textarget, GLuint texture, GLint level) const {
        assert(_NamedFramebufferTexture2DEXT !is null, "OpenGL command glNamedFramebufferTexture2DEXT was not loaded");
        return _NamedFramebufferTexture2DEXT (framebuffer, attachment, textarget, texture, level);
    }
    /// ditto
    public void NamedFramebufferTexture3DEXT (GLuint framebuffer, GLenum attachment, GLenum textarget, GLuint texture, GLint level, GLint zoffset) const {
        assert(_NamedFramebufferTexture3DEXT !is null, "OpenGL command glNamedFramebufferTexture3DEXT was not loaded");
        return _NamedFramebufferTexture3DEXT (framebuffer, attachment, textarget, texture, level, zoffset);
    }
    /// ditto
    public void NamedFramebufferRenderbufferEXT (GLuint framebuffer, GLenum attachment, GLenum renderbuffertarget, GLuint renderbuffer) const {
        assert(_NamedFramebufferRenderbufferEXT !is null, "OpenGL command glNamedFramebufferRenderbufferEXT was not loaded");
        return _NamedFramebufferRenderbufferEXT (framebuffer, attachment, renderbuffertarget, renderbuffer);
    }
    /// ditto
    public void GetNamedFramebufferAttachmentParameterivEXT (GLuint framebuffer, GLenum attachment, GLenum pname, GLint* params) const {
        assert(_GetNamedFramebufferAttachmentParameterivEXT !is null, "OpenGL command glGetNamedFramebufferAttachmentParameterivEXT was not loaded");
        return _GetNamedFramebufferAttachmentParameterivEXT (framebuffer, attachment, pname, params);
    }
    /// ditto
    public void GenerateTextureMipmapEXT (GLuint texture, GLenum target) const {
        assert(_GenerateTextureMipmapEXT !is null, "OpenGL command glGenerateTextureMipmapEXT was not loaded");
        return _GenerateTextureMipmapEXT (texture, target);
    }
    /// ditto
    public void GenerateMultiTexMipmapEXT (GLenum texunit, GLenum target) const {
        assert(_GenerateMultiTexMipmapEXT !is null, "OpenGL command glGenerateMultiTexMipmapEXT was not loaded");
        return _GenerateMultiTexMipmapEXT (texunit, target);
    }
    /// ditto
    public void FramebufferDrawBufferEXT (GLuint framebuffer, GLenum mode) const {
        assert(_FramebufferDrawBufferEXT !is null, "OpenGL command glFramebufferDrawBufferEXT was not loaded");
        return _FramebufferDrawBufferEXT (framebuffer, mode);
    }
    /// ditto
    public void FramebufferDrawBuffersEXT (GLuint framebuffer, GLsizei n, const(GLenum)* bufs) const {
        assert(_FramebufferDrawBuffersEXT !is null, "OpenGL command glFramebufferDrawBuffersEXT was not loaded");
        return _FramebufferDrawBuffersEXT (framebuffer, n, bufs);
    }
    /// ditto
    public void FramebufferReadBufferEXT (GLuint framebuffer, GLenum mode) const {
        assert(_FramebufferReadBufferEXT !is null, "OpenGL command glFramebufferReadBufferEXT was not loaded");
        return _FramebufferReadBufferEXT (framebuffer, mode);
    }
    /// ditto
    public void GetFramebufferParameterivEXT (GLuint framebuffer, GLenum pname, GLint* params) const {
        assert(_GetFramebufferParameterivEXT !is null, "OpenGL command glGetFramebufferParameterivEXT was not loaded");
        return _GetFramebufferParameterivEXT (framebuffer, pname, params);
    }
    /// ditto
    public void NamedCopyBufferSubDataEXT (GLuint readBuffer, GLuint writeBuffer, GLintptr readOffset, GLintptr writeOffset, GLsizeiptr size) const {
        assert(_NamedCopyBufferSubDataEXT !is null, "OpenGL command glNamedCopyBufferSubDataEXT was not loaded");
        return _NamedCopyBufferSubDataEXT (readBuffer, writeBuffer, readOffset, writeOffset, size);
    }
    /// ditto
    public void NamedFramebufferTextureEXT (GLuint framebuffer, GLenum attachment, GLuint texture, GLint level) const {
        assert(_NamedFramebufferTextureEXT !is null, "OpenGL command glNamedFramebufferTextureEXT was not loaded");
        return _NamedFramebufferTextureEXT (framebuffer, attachment, texture, level);
    }
    /// ditto
    public void NamedFramebufferTextureLayerEXT (GLuint framebuffer, GLenum attachment, GLuint texture, GLint level, GLint layer) const {
        assert(_NamedFramebufferTextureLayerEXT !is null, "OpenGL command glNamedFramebufferTextureLayerEXT was not loaded");
        return _NamedFramebufferTextureLayerEXT (framebuffer, attachment, texture, level, layer);
    }
    /// ditto
    public void NamedFramebufferTextureFaceEXT (GLuint framebuffer, GLenum attachment, GLuint texture, GLint level, GLenum face) const {
        assert(_NamedFramebufferTextureFaceEXT !is null, "OpenGL command glNamedFramebufferTextureFaceEXT was not loaded");
        return _NamedFramebufferTextureFaceEXT (framebuffer, attachment, texture, level, face);
    }
    /// ditto
    public void TextureRenderbufferEXT (GLuint texture, GLenum target, GLuint renderbuffer) const {
        assert(_TextureRenderbufferEXT !is null, "OpenGL command glTextureRenderbufferEXT was not loaded");
        return _TextureRenderbufferEXT (texture, target, renderbuffer);
    }
    /// ditto
    public void MultiTexRenderbufferEXT (GLenum texunit, GLenum target, GLuint renderbuffer) const {
        assert(_MultiTexRenderbufferEXT !is null, "OpenGL command glMultiTexRenderbufferEXT was not loaded");
        return _MultiTexRenderbufferEXT (texunit, target, renderbuffer);
    }
    /// ditto
    public void VertexArrayVertexOffsetEXT (GLuint vaobj, GLuint buffer, GLint size, GLenum type, GLsizei stride, GLintptr offset) const {
        assert(_VertexArrayVertexOffsetEXT !is null, "OpenGL command glVertexArrayVertexOffsetEXT was not loaded");
        return _VertexArrayVertexOffsetEXT (vaobj, buffer, size, type, stride, offset);
    }
    /// ditto
    public void VertexArrayColorOffsetEXT (GLuint vaobj, GLuint buffer, GLint size, GLenum type, GLsizei stride, GLintptr offset) const {
        assert(_VertexArrayColorOffsetEXT !is null, "OpenGL command glVertexArrayColorOffsetEXT was not loaded");
        return _VertexArrayColorOffsetEXT (vaobj, buffer, size, type, stride, offset);
    }
    /// ditto
    public void VertexArrayEdgeFlagOffsetEXT (GLuint vaobj, GLuint buffer, GLsizei stride, GLintptr offset) const {
        assert(_VertexArrayEdgeFlagOffsetEXT !is null, "OpenGL command glVertexArrayEdgeFlagOffsetEXT was not loaded");
        return _VertexArrayEdgeFlagOffsetEXT (vaobj, buffer, stride, offset);
    }
    /// ditto
    public void VertexArrayIndexOffsetEXT (GLuint vaobj, GLuint buffer, GLenum type, GLsizei stride, GLintptr offset) const {
        assert(_VertexArrayIndexOffsetEXT !is null, "OpenGL command glVertexArrayIndexOffsetEXT was not loaded");
        return _VertexArrayIndexOffsetEXT (vaobj, buffer, type, stride, offset);
    }
    /// ditto
    public void VertexArrayNormalOffsetEXT (GLuint vaobj, GLuint buffer, GLenum type, GLsizei stride, GLintptr offset) const {
        assert(_VertexArrayNormalOffsetEXT !is null, "OpenGL command glVertexArrayNormalOffsetEXT was not loaded");
        return _VertexArrayNormalOffsetEXT (vaobj, buffer, type, stride, offset);
    }
    /// ditto
    public void VertexArrayTexCoordOffsetEXT (GLuint vaobj, GLuint buffer, GLint size, GLenum type, GLsizei stride, GLintptr offset) const {
        assert(_VertexArrayTexCoordOffsetEXT !is null, "OpenGL command glVertexArrayTexCoordOffsetEXT was not loaded");
        return _VertexArrayTexCoordOffsetEXT (vaobj, buffer, size, type, stride, offset);
    }
    /// ditto
    public void VertexArrayMultiTexCoordOffsetEXT (GLuint vaobj, GLuint buffer, GLenum texunit, GLint size, GLenum type, GLsizei stride, GLintptr offset) const {
        assert(_VertexArrayMultiTexCoordOffsetEXT !is null, "OpenGL command glVertexArrayMultiTexCoordOffsetEXT was not loaded");
        return _VertexArrayMultiTexCoordOffsetEXT (vaobj, buffer, texunit, size, type, stride, offset);
    }
    /// ditto
    public void VertexArrayFogCoordOffsetEXT (GLuint vaobj, GLuint buffer, GLenum type, GLsizei stride, GLintptr offset) const {
        assert(_VertexArrayFogCoordOffsetEXT !is null, "OpenGL command glVertexArrayFogCoordOffsetEXT was not loaded");
        return _VertexArrayFogCoordOffsetEXT (vaobj, buffer, type, stride, offset);
    }
    /// ditto
    public void VertexArraySecondaryColorOffsetEXT (GLuint vaobj, GLuint buffer, GLint size, GLenum type, GLsizei stride, GLintptr offset) const {
        assert(_VertexArraySecondaryColorOffsetEXT !is null, "OpenGL command glVertexArraySecondaryColorOffsetEXT was not loaded");
        return _VertexArraySecondaryColorOffsetEXT (vaobj, buffer, size, type, stride, offset);
    }
    /// ditto
    public void VertexArrayVertexAttribOffsetEXT (GLuint vaobj, GLuint buffer, GLuint index, GLint size, GLenum type, GLboolean normalized, GLsizei stride, GLintptr offset) const {
        assert(_VertexArrayVertexAttribOffsetEXT !is null, "OpenGL command glVertexArrayVertexAttribOffsetEXT was not loaded");
        return _VertexArrayVertexAttribOffsetEXT (vaobj, buffer, index, size, type, normalized, stride, offset);
    }
    /// ditto
    public void VertexArrayVertexAttribIOffsetEXT (GLuint vaobj, GLuint buffer, GLuint index, GLint size, GLenum type, GLsizei stride, GLintptr offset) const {
        assert(_VertexArrayVertexAttribIOffsetEXT !is null, "OpenGL command glVertexArrayVertexAttribIOffsetEXT was not loaded");
        return _VertexArrayVertexAttribIOffsetEXT (vaobj, buffer, index, size, type, stride, offset);
    }
    /// ditto
    public void EnableVertexArrayEXT (GLuint vaobj, GLenum array) const {
        assert(_EnableVertexArrayEXT !is null, "OpenGL command glEnableVertexArrayEXT was not loaded");
        return _EnableVertexArrayEXT (vaobj, array);
    }
    /// ditto
    public void DisableVertexArrayEXT (GLuint vaobj, GLenum array) const {
        assert(_DisableVertexArrayEXT !is null, "OpenGL command glDisableVertexArrayEXT was not loaded");
        return _DisableVertexArrayEXT (vaobj, array);
    }
    /// ditto
    public void EnableVertexArrayAttribEXT (GLuint vaobj, GLuint index) const {
        assert(_EnableVertexArrayAttribEXT !is null, "OpenGL command glEnableVertexArrayAttribEXT was not loaded");
        return _EnableVertexArrayAttribEXT (vaobj, index);
    }
    /// ditto
    public void DisableVertexArrayAttribEXT (GLuint vaobj, GLuint index) const {
        assert(_DisableVertexArrayAttribEXT !is null, "OpenGL command glDisableVertexArrayAttribEXT was not loaded");
        return _DisableVertexArrayAttribEXT (vaobj, index);
    }
    /// ditto
    public void GetVertexArrayIntegervEXT (GLuint vaobj, GLenum pname, GLint* param) const {
        assert(_GetVertexArrayIntegervEXT !is null, "OpenGL command glGetVertexArrayIntegervEXT was not loaded");
        return _GetVertexArrayIntegervEXT (vaobj, pname, param);
    }
    /// ditto
    public void GetVertexArrayPointervEXT (GLuint vaobj, GLenum pname, void** param) const {
        assert(_GetVertexArrayPointervEXT !is null, "OpenGL command glGetVertexArrayPointervEXT was not loaded");
        return _GetVertexArrayPointervEXT (vaobj, pname, param);
    }
    /// ditto
    public void GetVertexArrayIntegeri_vEXT (GLuint vaobj, GLuint index, GLenum pname, GLint* param) const {
        assert(_GetVertexArrayIntegeri_vEXT !is null, "OpenGL command glGetVertexArrayIntegeri_vEXT was not loaded");
        return _GetVertexArrayIntegeri_vEXT (vaobj, index, pname, param);
    }
    /// ditto
    public void GetVertexArrayPointeri_vEXT (GLuint vaobj, GLuint index, GLenum pname, void** param) const {
        assert(_GetVertexArrayPointeri_vEXT !is null, "OpenGL command glGetVertexArrayPointeri_vEXT was not loaded");
        return _GetVertexArrayPointeri_vEXT (vaobj, index, pname, param);
    }
    /// ditto
    public void * MapNamedBufferRangeEXT (GLuint buffer, GLintptr offset, GLsizeiptr length, GLbitfield access) const {
        assert(_MapNamedBufferRangeEXT !is null, "OpenGL command glMapNamedBufferRangeEXT was not loaded");
        return _MapNamedBufferRangeEXT (buffer, offset, length, access);
    }
    /// ditto
    public void FlushMappedNamedBufferRangeEXT (GLuint buffer, GLintptr offset, GLsizeiptr length) const {
        assert(_FlushMappedNamedBufferRangeEXT !is null, "OpenGL command glFlushMappedNamedBufferRangeEXT was not loaded");
        return _FlushMappedNamedBufferRangeEXT (buffer, offset, length);
    }
    /// ditto
    public void ClearNamedBufferDataEXT (GLuint buffer, GLenum internalformat, GLenum format, GLenum type, const(void)* data) const {
        assert(_ClearNamedBufferDataEXT !is null, "OpenGL command glClearNamedBufferDataEXT was not loaded");
        return _ClearNamedBufferDataEXT (buffer, internalformat, format, type, data);
    }
    /// ditto
    public void ClearNamedBufferSubDataEXT (GLuint buffer, GLenum internalformat, GLsizeiptr offset, GLsizeiptr size, GLenum format, GLenum type, const(void)* data) const {
        assert(_ClearNamedBufferSubDataEXT !is null, "OpenGL command glClearNamedBufferSubDataEXT was not loaded");
        return _ClearNamedBufferSubDataEXT (buffer, internalformat, offset, size, format, type, data);
    }
    /// ditto
    public void NamedFramebufferParameteriEXT (GLuint framebuffer, GLenum pname, GLint param) const {
        assert(_NamedFramebufferParameteriEXT !is null, "OpenGL command glNamedFramebufferParameteriEXT was not loaded");
        return _NamedFramebufferParameteriEXT (framebuffer, pname, param);
    }
    /// ditto
    public void GetNamedFramebufferParameterivEXT (GLuint framebuffer, GLenum pname, GLint* params) const {
        assert(_GetNamedFramebufferParameterivEXT !is null, "OpenGL command glGetNamedFramebufferParameterivEXT was not loaded");
        return _GetNamedFramebufferParameterivEXT (framebuffer, pname, params);
    }
    /// ditto
    public void ProgramUniform1dEXT (GLuint program, GLint location, GLdouble x) const {
        assert(_ProgramUniform1dEXT !is null, "OpenGL command glProgramUniform1dEXT was not loaded");
        return _ProgramUniform1dEXT (program, location, x);
    }
    /// ditto
    public void ProgramUniform2dEXT (GLuint program, GLint location, GLdouble x, GLdouble y) const {
        assert(_ProgramUniform2dEXT !is null, "OpenGL command glProgramUniform2dEXT was not loaded");
        return _ProgramUniform2dEXT (program, location, x, y);
    }
    /// ditto
    public void ProgramUniform3dEXT (GLuint program, GLint location, GLdouble x, GLdouble y, GLdouble z) const {
        assert(_ProgramUniform3dEXT !is null, "OpenGL command glProgramUniform3dEXT was not loaded");
        return _ProgramUniform3dEXT (program, location, x, y, z);
    }
    /// ditto
    public void ProgramUniform4dEXT (GLuint program, GLint location, GLdouble x, GLdouble y, GLdouble z, GLdouble w) const {
        assert(_ProgramUniform4dEXT !is null, "OpenGL command glProgramUniform4dEXT was not loaded");
        return _ProgramUniform4dEXT (program, location, x, y, z, w);
    }
    /// ditto
    public void ProgramUniform1dvEXT (GLuint program, GLint location, GLsizei count, const(GLdouble)* value) const {
        assert(_ProgramUniform1dvEXT !is null, "OpenGL command glProgramUniform1dvEXT was not loaded");
        return _ProgramUniform1dvEXT (program, location, count, value);
    }
    /// ditto
    public void ProgramUniform2dvEXT (GLuint program, GLint location, GLsizei count, const(GLdouble)* value) const {
        assert(_ProgramUniform2dvEXT !is null, "OpenGL command glProgramUniform2dvEXT was not loaded");
        return _ProgramUniform2dvEXT (program, location, count, value);
    }
    /// ditto
    public void ProgramUniform3dvEXT (GLuint program, GLint location, GLsizei count, const(GLdouble)* value) const {
        assert(_ProgramUniform3dvEXT !is null, "OpenGL command glProgramUniform3dvEXT was not loaded");
        return _ProgramUniform3dvEXT (program, location, count, value);
    }
    /// ditto
    public void ProgramUniform4dvEXT (GLuint program, GLint location, GLsizei count, const(GLdouble)* value) const {
        assert(_ProgramUniform4dvEXT !is null, "OpenGL command glProgramUniform4dvEXT was not loaded");
        return _ProgramUniform4dvEXT (program, location, count, value);
    }
    /// ditto
    public void ProgramUniformMatrix2dvEXT (GLuint program, GLint location, GLsizei count, GLboolean transpose, const(GLdouble)* value) const {
        assert(_ProgramUniformMatrix2dvEXT !is null, "OpenGL command glProgramUniformMatrix2dvEXT was not loaded");
        return _ProgramUniformMatrix2dvEXT (program, location, count, transpose, value);
    }
    /// ditto
    public void ProgramUniformMatrix3dvEXT (GLuint program, GLint location, GLsizei count, GLboolean transpose, const(GLdouble)* value) const {
        assert(_ProgramUniformMatrix3dvEXT !is null, "OpenGL command glProgramUniformMatrix3dvEXT was not loaded");
        return _ProgramUniformMatrix3dvEXT (program, location, count, transpose, value);
    }
    /// ditto
    public void ProgramUniformMatrix4dvEXT (GLuint program, GLint location, GLsizei count, GLboolean transpose, const(GLdouble)* value) const {
        assert(_ProgramUniformMatrix4dvEXT !is null, "OpenGL command glProgramUniformMatrix4dvEXT was not loaded");
        return _ProgramUniformMatrix4dvEXT (program, location, count, transpose, value);
    }
    /// ditto
    public void ProgramUniformMatrix2x3dvEXT (GLuint program, GLint location, GLsizei count, GLboolean transpose, const(GLdouble)* value) const {
        assert(_ProgramUniformMatrix2x3dvEXT !is null, "OpenGL command glProgramUniformMatrix2x3dvEXT was not loaded");
        return _ProgramUniformMatrix2x3dvEXT (program, location, count, transpose, value);
    }
    /// ditto
    public void ProgramUniformMatrix2x4dvEXT (GLuint program, GLint location, GLsizei count, GLboolean transpose, const(GLdouble)* value) const {
        assert(_ProgramUniformMatrix2x4dvEXT !is null, "OpenGL command glProgramUniformMatrix2x4dvEXT was not loaded");
        return _ProgramUniformMatrix2x4dvEXT (program, location, count, transpose, value);
    }
    /// ditto
    public void ProgramUniformMatrix3x2dvEXT (GLuint program, GLint location, GLsizei count, GLboolean transpose, const(GLdouble)* value) const {
        assert(_ProgramUniformMatrix3x2dvEXT !is null, "OpenGL command glProgramUniformMatrix3x2dvEXT was not loaded");
        return _ProgramUniformMatrix3x2dvEXT (program, location, count, transpose, value);
    }
    /// ditto
    public void ProgramUniformMatrix3x4dvEXT (GLuint program, GLint location, GLsizei count, GLboolean transpose, const(GLdouble)* value) const {
        assert(_ProgramUniformMatrix3x4dvEXT !is null, "OpenGL command glProgramUniformMatrix3x4dvEXT was not loaded");
        return _ProgramUniformMatrix3x4dvEXT (program, location, count, transpose, value);
    }
    /// ditto
    public void ProgramUniformMatrix4x2dvEXT (GLuint program, GLint location, GLsizei count, GLboolean transpose, const(GLdouble)* value) const {
        assert(_ProgramUniformMatrix4x2dvEXT !is null, "OpenGL command glProgramUniformMatrix4x2dvEXT was not loaded");
        return _ProgramUniformMatrix4x2dvEXT (program, location, count, transpose, value);
    }
    /// ditto
    public void ProgramUniformMatrix4x3dvEXT (GLuint program, GLint location, GLsizei count, GLboolean transpose, const(GLdouble)* value) const {
        assert(_ProgramUniformMatrix4x3dvEXT !is null, "OpenGL command glProgramUniformMatrix4x3dvEXT was not loaded");
        return _ProgramUniformMatrix4x3dvEXT (program, location, count, transpose, value);
    }
    /// ditto
    public void TextureBufferRangeEXT (GLuint texture, GLenum target, GLenum internalformat, GLuint buffer, GLintptr offset, GLsizeiptr size) const {
        assert(_TextureBufferRangeEXT !is null, "OpenGL command glTextureBufferRangeEXT was not loaded");
        return _TextureBufferRangeEXT (texture, target, internalformat, buffer, offset, size);
    }
    /// ditto
    public void TextureStorage1DEXT (GLuint texture, GLenum target, GLsizei levels, GLenum internalformat, GLsizei width) const {
        assert(_TextureStorage1DEXT !is null, "OpenGL command glTextureStorage1DEXT was not loaded");
        return _TextureStorage1DEXT (texture, target, levels, internalformat, width);
    }
    /// ditto
    public void TextureStorage2DEXT (GLuint texture, GLenum target, GLsizei levels, GLenum internalformat, GLsizei width, GLsizei height) const {
        assert(_TextureStorage2DEXT !is null, "OpenGL command glTextureStorage2DEXT was not loaded");
        return _TextureStorage2DEXT (texture, target, levels, internalformat, width, height);
    }
    /// ditto
    public void TextureStorage3DEXT (GLuint texture, GLenum target, GLsizei levels, GLenum internalformat, GLsizei width, GLsizei height, GLsizei depth) const {
        assert(_TextureStorage3DEXT !is null, "OpenGL command glTextureStorage3DEXT was not loaded");
        return _TextureStorage3DEXT (texture, target, levels, internalformat, width, height, depth);
    }
    /// ditto
    public void TextureStorage2DMultisampleEXT (GLuint texture, GLenum target, GLsizei samples, GLenum internalformat, GLsizei width, GLsizei height, GLboolean fixedsamplelocations) const {
        assert(_TextureStorage2DMultisampleEXT !is null, "OpenGL command glTextureStorage2DMultisampleEXT was not loaded");
        return _TextureStorage2DMultisampleEXT (texture, target, samples, internalformat, width, height, fixedsamplelocations);
    }
    /// ditto
    public void TextureStorage3DMultisampleEXT (GLuint texture, GLenum target, GLsizei samples, GLenum internalformat, GLsizei width, GLsizei height, GLsizei depth, GLboolean fixedsamplelocations) const {
        assert(_TextureStorage3DMultisampleEXT !is null, "OpenGL command glTextureStorage3DMultisampleEXT was not loaded");
        return _TextureStorage3DMultisampleEXT (texture, target, samples, internalformat, width, height, depth, fixedsamplelocations);
    }
    /// ditto
    public void VertexArrayBindVertexBufferEXT (GLuint vaobj, GLuint bindingindex, GLuint buffer, GLintptr offset, GLsizei stride) const {
        assert(_VertexArrayBindVertexBufferEXT !is null, "OpenGL command glVertexArrayBindVertexBufferEXT was not loaded");
        return _VertexArrayBindVertexBufferEXT (vaobj, bindingindex, buffer, offset, stride);
    }
    /// ditto
    public void VertexArrayVertexAttribFormatEXT (GLuint vaobj, GLuint attribindex, GLint size, GLenum type, GLboolean normalized, GLuint relativeoffset) const {
        assert(_VertexArrayVertexAttribFormatEXT !is null, "OpenGL command glVertexArrayVertexAttribFormatEXT was not loaded");
        return _VertexArrayVertexAttribFormatEXT (vaobj, attribindex, size, type, normalized, relativeoffset);
    }
    /// ditto
    public void VertexArrayVertexAttribIFormatEXT (GLuint vaobj, GLuint attribindex, GLint size, GLenum type, GLuint relativeoffset) const {
        assert(_VertexArrayVertexAttribIFormatEXT !is null, "OpenGL command glVertexArrayVertexAttribIFormatEXT was not loaded");
        return _VertexArrayVertexAttribIFormatEXT (vaobj, attribindex, size, type, relativeoffset);
    }
    /// ditto
    public void VertexArrayVertexAttribLFormatEXT (GLuint vaobj, GLuint attribindex, GLint size, GLenum type, GLuint relativeoffset) const {
        assert(_VertexArrayVertexAttribLFormatEXT !is null, "OpenGL command glVertexArrayVertexAttribLFormatEXT was not loaded");
        return _VertexArrayVertexAttribLFormatEXT (vaobj, attribindex, size, type, relativeoffset);
    }
    /// ditto
    public void VertexArrayVertexAttribBindingEXT (GLuint vaobj, GLuint attribindex, GLuint bindingindex) const {
        assert(_VertexArrayVertexAttribBindingEXT !is null, "OpenGL command glVertexArrayVertexAttribBindingEXT was not loaded");
        return _VertexArrayVertexAttribBindingEXT (vaobj, attribindex, bindingindex);
    }
    /// ditto
    public void VertexArrayVertexBindingDivisorEXT (GLuint vaobj, GLuint bindingindex, GLuint divisor) const {
        assert(_VertexArrayVertexBindingDivisorEXT !is null, "OpenGL command glVertexArrayVertexBindingDivisorEXT was not loaded");
        return _VertexArrayVertexBindingDivisorEXT (vaobj, bindingindex, divisor);
    }
    /// ditto
    public void VertexArrayVertexAttribLOffsetEXT (GLuint vaobj, GLuint buffer, GLuint index, GLint size, GLenum type, GLsizei stride, GLintptr offset) const {
        assert(_VertexArrayVertexAttribLOffsetEXT !is null, "OpenGL command glVertexArrayVertexAttribLOffsetEXT was not loaded");
        return _VertexArrayVertexAttribLOffsetEXT (vaobj, buffer, index, size, type, stride, offset);
    }
    /// ditto
    public void TexturePageCommitmentEXT (GLuint texture, GLint level, GLint xoffset, GLint yoffset, GLint zoffset, GLsizei width, GLsizei height, GLsizei depth, GLboolean commit) const {
        assert(_TexturePageCommitmentEXT !is null, "OpenGL command glTexturePageCommitmentEXT was not loaded");
        return _TexturePageCommitmentEXT (texture, level, xoffset, yoffset, zoffset, width, height, depth, commit);
    }
    /// ditto
    public void VertexArrayVertexAttribDivisorEXT (GLuint vaobj, GLuint index, GLuint divisor) const {
        assert(_VertexArrayVertexAttribDivisorEXT !is null, "OpenGL command glVertexArrayVertexAttribDivisorEXT was not loaded");
        return _VertexArrayVertexAttribDivisorEXT (vaobj, index, divisor);
    }

    /// Commands for GL_EXT_raster_multisample
    public void RasterSamplesEXT (GLuint samples, GLboolean fixedsamplelocations) const {
        assert(_RasterSamplesEXT !is null, "OpenGL command glRasterSamplesEXT was not loaded");
        return _RasterSamplesEXT (samples, fixedsamplelocations);
    }

    /// Commands for GL_EXT_separate_shader_objects
    public void UseShaderProgramEXT (GLenum type, GLuint program) const {
        assert(_UseShaderProgramEXT !is null, "OpenGL command glUseShaderProgramEXT was not loaded");
        return _UseShaderProgramEXT (type, program);
    }
    /// ditto
    public void ActiveProgramEXT (GLuint program) const {
        assert(_ActiveProgramEXT !is null, "OpenGL command glActiveProgramEXT was not loaded");
        return _ActiveProgramEXT (program);
    }
    /// ditto
    public GLuint CreateShaderProgramEXT (GLenum type, const(GLchar)* string) const {
        assert(_CreateShaderProgramEXT !is null, "OpenGL command glCreateShaderProgramEXT was not loaded");
        return _CreateShaderProgramEXT (type, string);
    }

    /// Commands for GL_EXT_window_rectangles
    public void WindowRectanglesEXT (GLenum mode, GLsizei count, const(GLint)* box) const {
        assert(_WindowRectanglesEXT !is null, "OpenGL command glWindowRectanglesEXT was not loaded");
        return _WindowRectanglesEXT (mode, count, box);
    }

    /// Commands for GL_INTEL_framebuffer_CMAA
    public void ApplyFramebufferAttachmentCMAAINTEL () const {
        assert(_ApplyFramebufferAttachmentCMAAINTEL !is null, "OpenGL command glApplyFramebufferAttachmentCMAAINTEL was not loaded");
        return _ApplyFramebufferAttachmentCMAAINTEL ();
    }

    /// Commands for GL_INTEL_performance_query
    public void BeginPerfQueryINTEL (GLuint queryHandle) const {
        assert(_BeginPerfQueryINTEL !is null, "OpenGL command glBeginPerfQueryINTEL was not loaded");
        return _BeginPerfQueryINTEL (queryHandle);
    }
    /// ditto
    public void CreatePerfQueryINTEL (GLuint queryId, GLuint* queryHandle) const {
        assert(_CreatePerfQueryINTEL !is null, "OpenGL command glCreatePerfQueryINTEL was not loaded");
        return _CreatePerfQueryINTEL (queryId, queryHandle);
    }
    /// ditto
    public void DeletePerfQueryINTEL (GLuint queryHandle) const {
        assert(_DeletePerfQueryINTEL !is null, "OpenGL command glDeletePerfQueryINTEL was not loaded");
        return _DeletePerfQueryINTEL (queryHandle);
    }
    /// ditto
    public void EndPerfQueryINTEL (GLuint queryHandle) const {
        assert(_EndPerfQueryINTEL !is null, "OpenGL command glEndPerfQueryINTEL was not loaded");
        return _EndPerfQueryINTEL (queryHandle);
    }
    /// ditto
    public void GetFirstPerfQueryIdINTEL (GLuint* queryId) const {
        assert(_GetFirstPerfQueryIdINTEL !is null, "OpenGL command glGetFirstPerfQueryIdINTEL was not loaded");
        return _GetFirstPerfQueryIdINTEL (queryId);
    }
    /// ditto
    public void GetNextPerfQueryIdINTEL (GLuint queryId, GLuint* nextQueryId) const {
        assert(_GetNextPerfQueryIdINTEL !is null, "OpenGL command glGetNextPerfQueryIdINTEL was not loaded");
        return _GetNextPerfQueryIdINTEL (queryId, nextQueryId);
    }
    /// ditto
    public void GetPerfCounterInfoINTEL (GLuint queryId, GLuint counterId, GLuint counterNameLength, GLchar* counterName, GLuint counterDescLength, GLchar* counterDesc, GLuint* counterOffset, GLuint* counterDataSize, GLuint* counterTypeEnum, GLuint* counterDataTypeEnum, GLuint64* rawCounterMaxValue) const {
        assert(_GetPerfCounterInfoINTEL !is null, "OpenGL command glGetPerfCounterInfoINTEL was not loaded");
        return _GetPerfCounterInfoINTEL (queryId, counterId, counterNameLength, counterName, counterDescLength, counterDesc, counterOffset, counterDataSize, counterTypeEnum, counterDataTypeEnum, rawCounterMaxValue);
    }
    /// ditto
    public void GetPerfQueryDataINTEL (GLuint queryHandle, GLuint flags, GLsizei dataSize, void* data, GLuint* bytesWritten) const {
        assert(_GetPerfQueryDataINTEL !is null, "OpenGL command glGetPerfQueryDataINTEL was not loaded");
        return _GetPerfQueryDataINTEL (queryHandle, flags, dataSize, data, bytesWritten);
    }
    /// ditto
    public void GetPerfQueryIdByNameINTEL (GLchar* queryName, GLuint* queryId) const {
        assert(_GetPerfQueryIdByNameINTEL !is null, "OpenGL command glGetPerfQueryIdByNameINTEL was not loaded");
        return _GetPerfQueryIdByNameINTEL (queryName, queryId);
    }
    /// ditto
    public void GetPerfQueryInfoINTEL (GLuint queryId, GLuint queryNameLength, GLchar* queryName, GLuint* dataSize, GLuint* noCounters, GLuint* noInstances, GLuint* capsMask) const {
        assert(_GetPerfQueryInfoINTEL !is null, "OpenGL command glGetPerfQueryInfoINTEL was not loaded");
        return _GetPerfQueryInfoINTEL (queryId, queryNameLength, queryName, dataSize, noCounters, noInstances, capsMask);
    }

    /// Commands for GL_NV_bindless_multi_draw_indirect
    public void MultiDrawArraysIndirectBindlessNV (GLenum mode, const(void)* indirect, GLsizei drawCount, GLsizei stride, GLint vertexBufferCount) const {
        assert(_MultiDrawArraysIndirectBindlessNV !is null, "OpenGL command glMultiDrawArraysIndirectBindlessNV was not loaded");
        return _MultiDrawArraysIndirectBindlessNV (mode, indirect, drawCount, stride, vertexBufferCount);
    }
    /// ditto
    public void MultiDrawElementsIndirectBindlessNV (GLenum mode, GLenum type, const(void)* indirect, GLsizei drawCount, GLsizei stride, GLint vertexBufferCount) const {
        assert(_MultiDrawElementsIndirectBindlessNV !is null, "OpenGL command glMultiDrawElementsIndirectBindlessNV was not loaded");
        return _MultiDrawElementsIndirectBindlessNV (mode, type, indirect, drawCount, stride, vertexBufferCount);
    }

    /// Commands for GL_NV_bindless_multi_draw_indirect_count
    public void MultiDrawArraysIndirectBindlessCountNV (GLenum mode, const(void)* indirect, GLsizei drawCount, GLsizei maxDrawCount, GLsizei stride, GLint vertexBufferCount) const {
        assert(_MultiDrawArraysIndirectBindlessCountNV !is null, "OpenGL command glMultiDrawArraysIndirectBindlessCountNV was not loaded");
        return _MultiDrawArraysIndirectBindlessCountNV (mode, indirect, drawCount, maxDrawCount, stride, vertexBufferCount);
    }
    /// ditto
    public void MultiDrawElementsIndirectBindlessCountNV (GLenum mode, GLenum type, const(void)* indirect, GLsizei drawCount, GLsizei maxDrawCount, GLsizei stride, GLint vertexBufferCount) const {
        assert(_MultiDrawElementsIndirectBindlessCountNV !is null, "OpenGL command glMultiDrawElementsIndirectBindlessCountNV was not loaded");
        return _MultiDrawElementsIndirectBindlessCountNV (mode, type, indirect, drawCount, maxDrawCount, stride, vertexBufferCount);
    }

    /// Commands for GL_NV_bindless_texture
    public GLuint64 GetTextureHandleNV (GLuint texture) const {
        assert(_GetTextureHandleNV !is null, "OpenGL command glGetTextureHandleNV was not loaded");
        return _GetTextureHandleNV (texture);
    }
    /// ditto
    public GLuint64 GetTextureSamplerHandleNV (GLuint texture, GLuint sampler) const {
        assert(_GetTextureSamplerHandleNV !is null, "OpenGL command glGetTextureSamplerHandleNV was not loaded");
        return _GetTextureSamplerHandleNV (texture, sampler);
    }
    /// ditto
    public void MakeTextureHandleResidentNV (GLuint64 handle) const {
        assert(_MakeTextureHandleResidentNV !is null, "OpenGL command glMakeTextureHandleResidentNV was not loaded");
        return _MakeTextureHandleResidentNV (handle);
    }
    /// ditto
    public void MakeTextureHandleNonResidentNV (GLuint64 handle) const {
        assert(_MakeTextureHandleNonResidentNV !is null, "OpenGL command glMakeTextureHandleNonResidentNV was not loaded");
        return _MakeTextureHandleNonResidentNV (handle);
    }
    /// ditto
    public GLuint64 GetImageHandleNV (GLuint texture, GLint level, GLboolean layered, GLint layer, GLenum format) const {
        assert(_GetImageHandleNV !is null, "OpenGL command glGetImageHandleNV was not loaded");
        return _GetImageHandleNV (texture, level, layered, layer, format);
    }
    /// ditto
    public void MakeImageHandleResidentNV (GLuint64 handle, GLenum access) const {
        assert(_MakeImageHandleResidentNV !is null, "OpenGL command glMakeImageHandleResidentNV was not loaded");
        return _MakeImageHandleResidentNV (handle, access);
    }
    /// ditto
    public void MakeImageHandleNonResidentNV (GLuint64 handle) const {
        assert(_MakeImageHandleNonResidentNV !is null, "OpenGL command glMakeImageHandleNonResidentNV was not loaded");
        return _MakeImageHandleNonResidentNV (handle);
    }
    /// ditto
    public void UniformHandleui64NV (GLint location, GLuint64 value) const {
        assert(_UniformHandleui64NV !is null, "OpenGL command glUniformHandleui64NV was not loaded");
        return _UniformHandleui64NV (location, value);
    }
    /// ditto
    public void UniformHandleui64vNV (GLint location, GLsizei count, const(GLuint64)* value) const {
        assert(_UniformHandleui64vNV !is null, "OpenGL command glUniformHandleui64vNV was not loaded");
        return _UniformHandleui64vNV (location, count, value);
    }
    /// ditto
    public void ProgramUniformHandleui64NV (GLuint program, GLint location, GLuint64 value) const {
        assert(_ProgramUniformHandleui64NV !is null, "OpenGL command glProgramUniformHandleui64NV was not loaded");
        return _ProgramUniformHandleui64NV (program, location, value);
    }
    /// ditto
    public void ProgramUniformHandleui64vNV (GLuint program, GLint location, GLsizei count, const(GLuint64)* values) const {
        assert(_ProgramUniformHandleui64vNV !is null, "OpenGL command glProgramUniformHandleui64vNV was not loaded");
        return _ProgramUniformHandleui64vNV (program, location, count, values);
    }
    /// ditto
    public GLboolean IsTextureHandleResidentNV (GLuint64 handle) const {
        assert(_IsTextureHandleResidentNV !is null, "OpenGL command glIsTextureHandleResidentNV was not loaded");
        return _IsTextureHandleResidentNV (handle);
    }
    /// ditto
    public GLboolean IsImageHandleResidentNV (GLuint64 handle) const {
        assert(_IsImageHandleResidentNV !is null, "OpenGL command glIsImageHandleResidentNV was not loaded");
        return _IsImageHandleResidentNV (handle);
    }

    /// Commands for GL_NV_blend_equation_advanced
    public void BlendParameteriNV (GLenum pname, GLint value) const {
        assert(_BlendParameteriNV !is null, "OpenGL command glBlendParameteriNV was not loaded");
        return _BlendParameteriNV (pname, value);
    }
    /// ditto
    public void BlendBarrierNV () const {
        assert(_BlendBarrierNV !is null, "OpenGL command glBlendBarrierNV was not loaded");
        return _BlendBarrierNV ();
    }

    /// Commands for GL_NV_clip_space_w_scaling
    public void ViewportPositionWScaleNV (GLuint index, GLfloat xcoeff, GLfloat ycoeff) const {
        assert(_ViewportPositionWScaleNV !is null, "OpenGL command glViewportPositionWScaleNV was not loaded");
        return _ViewportPositionWScaleNV (index, xcoeff, ycoeff);
    }

    /// Commands for GL_NV_command_list
    public void CreateStatesNV (GLsizei n, GLuint* states) const {
        assert(_CreateStatesNV !is null, "OpenGL command glCreateStatesNV was not loaded");
        return _CreateStatesNV (n, states);
    }
    /// ditto
    public void DeleteStatesNV (GLsizei n, const(GLuint)* states) const {
        assert(_DeleteStatesNV !is null, "OpenGL command glDeleteStatesNV was not loaded");
        return _DeleteStatesNV (n, states);
    }
    /// ditto
    public GLboolean IsStateNV (GLuint state) const {
        assert(_IsStateNV !is null, "OpenGL command glIsStateNV was not loaded");
        return _IsStateNV (state);
    }
    /// ditto
    public void StateCaptureNV (GLuint state, GLenum mode) const {
        assert(_StateCaptureNV !is null, "OpenGL command glStateCaptureNV was not loaded");
        return _StateCaptureNV (state, mode);
    }
    /// ditto
    public GLuint GetCommandHeaderNV (GLenum tokenID, GLuint size) const {
        assert(_GetCommandHeaderNV !is null, "OpenGL command glGetCommandHeaderNV was not loaded");
        return _GetCommandHeaderNV (tokenID, size);
    }
    /// ditto
    public GLushort GetStageIndexNV (GLenum shadertype) const {
        assert(_GetStageIndexNV !is null, "OpenGL command glGetStageIndexNV was not loaded");
        return _GetStageIndexNV (shadertype);
    }
    /// ditto
    public void DrawCommandsNV (GLenum primitiveMode, GLuint buffer, const(GLintptr)* indirects, const(GLsizei)* sizes, GLuint count) const {
        assert(_DrawCommandsNV !is null, "OpenGL command glDrawCommandsNV was not loaded");
        return _DrawCommandsNV (primitiveMode, buffer, indirects, sizes, count);
    }
    /// ditto
    public void DrawCommandsAddressNV (GLenum primitiveMode, const(GLuint64)* indirects, const(GLsizei)* sizes, GLuint count) const {
        assert(_DrawCommandsAddressNV !is null, "OpenGL command glDrawCommandsAddressNV was not loaded");
        return _DrawCommandsAddressNV (primitiveMode, indirects, sizes, count);
    }
    /// ditto
    public void DrawCommandsStatesNV (GLuint buffer, const(GLintptr)* indirects, const(GLsizei)* sizes, const(GLuint)* states, const(GLuint)* fbos, GLuint count) const {
        assert(_DrawCommandsStatesNV !is null, "OpenGL command glDrawCommandsStatesNV was not loaded");
        return _DrawCommandsStatesNV (buffer, indirects, sizes, states, fbos, count);
    }
    /// ditto
    public void DrawCommandsStatesAddressNV (const(GLuint64)* indirects, const(GLsizei)* sizes, const(GLuint)* states, const(GLuint)* fbos, GLuint count) const {
        assert(_DrawCommandsStatesAddressNV !is null, "OpenGL command glDrawCommandsStatesAddressNV was not loaded");
        return _DrawCommandsStatesAddressNV (indirects, sizes, states, fbos, count);
    }
    /// ditto
    public void CreateCommandListsNV (GLsizei n, GLuint* lists) const {
        assert(_CreateCommandListsNV !is null, "OpenGL command glCreateCommandListsNV was not loaded");
        return _CreateCommandListsNV (n, lists);
    }
    /// ditto
    public void DeleteCommandListsNV (GLsizei n, const(GLuint)* lists) const {
        assert(_DeleteCommandListsNV !is null, "OpenGL command glDeleteCommandListsNV was not loaded");
        return _DeleteCommandListsNV (n, lists);
    }
    /// ditto
    public GLboolean IsCommandListNV (GLuint list) const {
        assert(_IsCommandListNV !is null, "OpenGL command glIsCommandListNV was not loaded");
        return _IsCommandListNV (list);
    }
    /// ditto
    public void ListDrawCommandsStatesClientNV (GLuint list, GLuint segment, const(void*)* indirects, const(GLsizei)* sizes, const(GLuint)* states, const(GLuint)* fbos, GLuint count) const {
        assert(_ListDrawCommandsStatesClientNV !is null, "OpenGL command glListDrawCommandsStatesClientNV was not loaded");
        return _ListDrawCommandsStatesClientNV (list, segment, indirects, sizes, states, fbos, count);
    }
    /// ditto
    public void CommandListSegmentsNV (GLuint list, GLuint segments) const {
        assert(_CommandListSegmentsNV !is null, "OpenGL command glCommandListSegmentsNV was not loaded");
        return _CommandListSegmentsNV (list, segments);
    }
    /// ditto
    public void CompileCommandListNV (GLuint list) const {
        assert(_CompileCommandListNV !is null, "OpenGL command glCompileCommandListNV was not loaded");
        return _CompileCommandListNV (list);
    }
    /// ditto
    public void CallCommandListNV (GLuint list) const {
        assert(_CallCommandListNV !is null, "OpenGL command glCallCommandListNV was not loaded");
        return _CallCommandListNV (list);
    }

    /// Commands for GL_NV_conservative_raster
    public void SubpixelPrecisionBiasNV (GLuint xbits, GLuint ybits) const {
        assert(_SubpixelPrecisionBiasNV !is null, "OpenGL command glSubpixelPrecisionBiasNV was not loaded");
        return _SubpixelPrecisionBiasNV (xbits, ybits);
    }

    /// Commands for GL_NV_conservative_raster_dilate
    public void ConservativeRasterParameterfNV (GLenum pname, GLfloat value) const {
        assert(_ConservativeRasterParameterfNV !is null, "OpenGL command glConservativeRasterParameterfNV was not loaded");
        return _ConservativeRasterParameterfNV (pname, value);
    }

    /// Commands for GL_NV_conservative_raster_pre_snap_triangles
    public void ConservativeRasterParameteriNV (GLenum pname, GLint param) const {
        assert(_ConservativeRasterParameteriNV !is null, "OpenGL command glConservativeRasterParameteriNV was not loaded");
        return _ConservativeRasterParameteriNV (pname, param);
    }

    /// Commands for GL_NV_draw_vulkan_image
    public void DrawVkImageNV (GLuint64 vkImage, GLuint sampler, GLfloat x0, GLfloat y0, GLfloat x1, GLfloat y1, GLfloat z, GLfloat s0, GLfloat t0, GLfloat s1, GLfloat t1) const {
        assert(_DrawVkImageNV !is null, "OpenGL command glDrawVkImageNV was not loaded");
        return _DrawVkImageNV (vkImage, sampler, x0, y0, x1, y1, z, s0, t0, s1, t1);
    }
    /// ditto
    public GLVULKANPROCNV GetVkProcAddrNV (const(GLchar)* name) const {
        assert(_GetVkProcAddrNV !is null, "OpenGL command glGetVkProcAddrNV was not loaded");
        return _GetVkProcAddrNV (name);
    }
    /// ditto
    public void WaitVkSemaphoreNV (GLuint64 vkSemaphore) const {
        assert(_WaitVkSemaphoreNV !is null, "OpenGL command glWaitVkSemaphoreNV was not loaded");
        return _WaitVkSemaphoreNV (vkSemaphore);
    }
    /// ditto
    public void SignalVkSemaphoreNV (GLuint64 vkSemaphore) const {
        assert(_SignalVkSemaphoreNV !is null, "OpenGL command glSignalVkSemaphoreNV was not loaded");
        return _SignalVkSemaphoreNV (vkSemaphore);
    }
    /// ditto
    public void SignalVkFenceNV (GLuint64 vkFence) const {
        assert(_SignalVkFenceNV !is null, "OpenGL command glSignalVkFenceNV was not loaded");
        return _SignalVkFenceNV (vkFence);
    }

    /// Commands for GL_NV_fragment_coverage_to_color
    public void FragmentCoverageColorNV (GLuint color) const {
        assert(_FragmentCoverageColorNV !is null, "OpenGL command glFragmentCoverageColorNV was not loaded");
        return _FragmentCoverageColorNV (color);
    }

    /// Commands for GL_NV_framebuffer_mixed_samples
    public void CoverageModulationTableNV (GLsizei n, const(GLfloat)* v) const {
        assert(_CoverageModulationTableNV !is null, "OpenGL command glCoverageModulationTableNV was not loaded");
        return _CoverageModulationTableNV (n, v);
    }
    /// ditto
    public void GetCoverageModulationTableNV (GLsizei bufsize, GLfloat* v) const {
        assert(_GetCoverageModulationTableNV !is null, "OpenGL command glGetCoverageModulationTableNV was not loaded");
        return _GetCoverageModulationTableNV (bufsize, v);
    }
    /// ditto
    public void CoverageModulationNV (GLenum components) const {
        assert(_CoverageModulationNV !is null, "OpenGL command glCoverageModulationNV was not loaded");
        return _CoverageModulationNV (components);
    }

    /// Commands for GL_NV_framebuffer_multisample_coverage
    public void RenderbufferStorageMultisampleCoverageNV (GLenum target, GLsizei coverageSamples, GLsizei colorSamples, GLenum internalformat, GLsizei width, GLsizei height) const {
        assert(_RenderbufferStorageMultisampleCoverageNV !is null, "OpenGL command glRenderbufferStorageMultisampleCoverageNV was not loaded");
        return _RenderbufferStorageMultisampleCoverageNV (target, coverageSamples, colorSamples, internalformat, width, height);
    }

    /// Commands for GL_NV_gpu_shader5
    public void Uniform1i64NV (GLint location, GLint64EXT x) const {
        assert(_Uniform1i64NV !is null, "OpenGL command glUniform1i64NV was not loaded");
        return _Uniform1i64NV (location, x);
    }
    /// ditto
    public void Uniform2i64NV (GLint location, GLint64EXT x, GLint64EXT y) const {
        assert(_Uniform2i64NV !is null, "OpenGL command glUniform2i64NV was not loaded");
        return _Uniform2i64NV (location, x, y);
    }
    /// ditto
    public void Uniform3i64NV (GLint location, GLint64EXT x, GLint64EXT y, GLint64EXT z) const {
        assert(_Uniform3i64NV !is null, "OpenGL command glUniform3i64NV was not loaded");
        return _Uniform3i64NV (location, x, y, z);
    }
    /// ditto
    public void Uniform4i64NV (GLint location, GLint64EXT x, GLint64EXT y, GLint64EXT z, GLint64EXT w) const {
        assert(_Uniform4i64NV !is null, "OpenGL command glUniform4i64NV was not loaded");
        return _Uniform4i64NV (location, x, y, z, w);
    }
    /// ditto
    public void Uniform1i64vNV (GLint location, GLsizei count, const(GLint64EXT)* value) const {
        assert(_Uniform1i64vNV !is null, "OpenGL command glUniform1i64vNV was not loaded");
        return _Uniform1i64vNV (location, count, value);
    }
    /// ditto
    public void Uniform2i64vNV (GLint location, GLsizei count, const(GLint64EXT)* value) const {
        assert(_Uniform2i64vNV !is null, "OpenGL command glUniform2i64vNV was not loaded");
        return _Uniform2i64vNV (location, count, value);
    }
    /// ditto
    public void Uniform3i64vNV (GLint location, GLsizei count, const(GLint64EXT)* value) const {
        assert(_Uniform3i64vNV !is null, "OpenGL command glUniform3i64vNV was not loaded");
        return _Uniform3i64vNV (location, count, value);
    }
    /// ditto
    public void Uniform4i64vNV (GLint location, GLsizei count, const(GLint64EXT)* value) const {
        assert(_Uniform4i64vNV !is null, "OpenGL command glUniform4i64vNV was not loaded");
        return _Uniform4i64vNV (location, count, value);
    }
    /// ditto
    public void Uniform1ui64NV (GLint location, GLuint64EXT x) const {
        assert(_Uniform1ui64NV !is null, "OpenGL command glUniform1ui64NV was not loaded");
        return _Uniform1ui64NV (location, x);
    }
    /// ditto
    public void Uniform2ui64NV (GLint location, GLuint64EXT x, GLuint64EXT y) const {
        assert(_Uniform2ui64NV !is null, "OpenGL command glUniform2ui64NV was not loaded");
        return _Uniform2ui64NV (location, x, y);
    }
    /// ditto
    public void Uniform3ui64NV (GLint location, GLuint64EXT x, GLuint64EXT y, GLuint64EXT z) const {
        assert(_Uniform3ui64NV !is null, "OpenGL command glUniform3ui64NV was not loaded");
        return _Uniform3ui64NV (location, x, y, z);
    }
    /// ditto
    public void Uniform4ui64NV (GLint location, GLuint64EXT x, GLuint64EXT y, GLuint64EXT z, GLuint64EXT w) const {
        assert(_Uniform4ui64NV !is null, "OpenGL command glUniform4ui64NV was not loaded");
        return _Uniform4ui64NV (location, x, y, z, w);
    }
    /// ditto
    public void Uniform1ui64vNV (GLint location, GLsizei count, const(GLuint64EXT)* value) const {
        assert(_Uniform1ui64vNV !is null, "OpenGL command glUniform1ui64vNV was not loaded");
        return _Uniform1ui64vNV (location, count, value);
    }
    /// ditto
    public void Uniform2ui64vNV (GLint location, GLsizei count, const(GLuint64EXT)* value) const {
        assert(_Uniform2ui64vNV !is null, "OpenGL command glUniform2ui64vNV was not loaded");
        return _Uniform2ui64vNV (location, count, value);
    }
    /// ditto
    public void Uniform3ui64vNV (GLint location, GLsizei count, const(GLuint64EXT)* value) const {
        assert(_Uniform3ui64vNV !is null, "OpenGL command glUniform3ui64vNV was not loaded");
        return _Uniform3ui64vNV (location, count, value);
    }
    /// ditto
    public void Uniform4ui64vNV (GLint location, GLsizei count, const(GLuint64EXT)* value) const {
        assert(_Uniform4ui64vNV !is null, "OpenGL command glUniform4ui64vNV was not loaded");
        return _Uniform4ui64vNV (location, count, value);
    }
    /// ditto
    public void GetUniformi64vNV (GLuint program, GLint location, GLint64EXT* params) const {
        assert(_GetUniformi64vNV !is null, "OpenGL command glGetUniformi64vNV was not loaded");
        return _GetUniformi64vNV (program, location, params);
    }
    /// ditto
    public void ProgramUniform1i64NV (GLuint program, GLint location, GLint64EXT x) const {
        assert(_ProgramUniform1i64NV !is null, "OpenGL command glProgramUniform1i64NV was not loaded");
        return _ProgramUniform1i64NV (program, location, x);
    }
    /// ditto
    public void ProgramUniform2i64NV (GLuint program, GLint location, GLint64EXT x, GLint64EXT y) const {
        assert(_ProgramUniform2i64NV !is null, "OpenGL command glProgramUniform2i64NV was not loaded");
        return _ProgramUniform2i64NV (program, location, x, y);
    }
    /// ditto
    public void ProgramUniform3i64NV (GLuint program, GLint location, GLint64EXT x, GLint64EXT y, GLint64EXT z) const {
        assert(_ProgramUniform3i64NV !is null, "OpenGL command glProgramUniform3i64NV was not loaded");
        return _ProgramUniform3i64NV (program, location, x, y, z);
    }
    /// ditto
    public void ProgramUniform4i64NV (GLuint program, GLint location, GLint64EXT x, GLint64EXT y, GLint64EXT z, GLint64EXT w) const {
        assert(_ProgramUniform4i64NV !is null, "OpenGL command glProgramUniform4i64NV was not loaded");
        return _ProgramUniform4i64NV (program, location, x, y, z, w);
    }
    /// ditto
    public void ProgramUniform1i64vNV (GLuint program, GLint location, GLsizei count, const(GLint64EXT)* value) const {
        assert(_ProgramUniform1i64vNV !is null, "OpenGL command glProgramUniform1i64vNV was not loaded");
        return _ProgramUniform1i64vNV (program, location, count, value);
    }
    /// ditto
    public void ProgramUniform2i64vNV (GLuint program, GLint location, GLsizei count, const(GLint64EXT)* value) const {
        assert(_ProgramUniform2i64vNV !is null, "OpenGL command glProgramUniform2i64vNV was not loaded");
        return _ProgramUniform2i64vNV (program, location, count, value);
    }
    /// ditto
    public void ProgramUniform3i64vNV (GLuint program, GLint location, GLsizei count, const(GLint64EXT)* value) const {
        assert(_ProgramUniform3i64vNV !is null, "OpenGL command glProgramUniform3i64vNV was not loaded");
        return _ProgramUniform3i64vNV (program, location, count, value);
    }
    /// ditto
    public void ProgramUniform4i64vNV (GLuint program, GLint location, GLsizei count, const(GLint64EXT)* value) const {
        assert(_ProgramUniform4i64vNV !is null, "OpenGL command glProgramUniform4i64vNV was not loaded");
        return _ProgramUniform4i64vNV (program, location, count, value);
    }
    /// ditto
    public void ProgramUniform1ui64NV (GLuint program, GLint location, GLuint64EXT x) const {
        assert(_ProgramUniform1ui64NV !is null, "OpenGL command glProgramUniform1ui64NV was not loaded");
        return _ProgramUniform1ui64NV (program, location, x);
    }
    /// ditto
    public void ProgramUniform2ui64NV (GLuint program, GLint location, GLuint64EXT x, GLuint64EXT y) const {
        assert(_ProgramUniform2ui64NV !is null, "OpenGL command glProgramUniform2ui64NV was not loaded");
        return _ProgramUniform2ui64NV (program, location, x, y);
    }
    /// ditto
    public void ProgramUniform3ui64NV (GLuint program, GLint location, GLuint64EXT x, GLuint64EXT y, GLuint64EXT z) const {
        assert(_ProgramUniform3ui64NV !is null, "OpenGL command glProgramUniform3ui64NV was not loaded");
        return _ProgramUniform3ui64NV (program, location, x, y, z);
    }
    /// ditto
    public void ProgramUniform4ui64NV (GLuint program, GLint location, GLuint64EXT x, GLuint64EXT y, GLuint64EXT z, GLuint64EXT w) const {
        assert(_ProgramUniform4ui64NV !is null, "OpenGL command glProgramUniform4ui64NV was not loaded");
        return _ProgramUniform4ui64NV (program, location, x, y, z, w);
    }
    /// ditto
    public void ProgramUniform1ui64vNV (GLuint program, GLint location, GLsizei count, const(GLuint64EXT)* value) const {
        assert(_ProgramUniform1ui64vNV !is null, "OpenGL command glProgramUniform1ui64vNV was not loaded");
        return _ProgramUniform1ui64vNV (program, location, count, value);
    }
    /// ditto
    public void ProgramUniform2ui64vNV (GLuint program, GLint location, GLsizei count, const(GLuint64EXT)* value) const {
        assert(_ProgramUniform2ui64vNV !is null, "OpenGL command glProgramUniform2ui64vNV was not loaded");
        return _ProgramUniform2ui64vNV (program, location, count, value);
    }
    /// ditto
    public void ProgramUniform3ui64vNV (GLuint program, GLint location, GLsizei count, const(GLuint64EXT)* value) const {
        assert(_ProgramUniform3ui64vNV !is null, "OpenGL command glProgramUniform3ui64vNV was not loaded");
        return _ProgramUniform3ui64vNV (program, location, count, value);
    }
    /// ditto
    public void ProgramUniform4ui64vNV (GLuint program, GLint location, GLsizei count, const(GLuint64EXT)* value) const {
        assert(_ProgramUniform4ui64vNV !is null, "OpenGL command glProgramUniform4ui64vNV was not loaded");
        return _ProgramUniform4ui64vNV (program, location, count, value);
    }

    /// Commands for GL_NV_internalformat_sample_query
    public void GetInternalformatSampleivNV (GLenum target, GLenum internalformat, GLsizei samples, GLenum pname, GLsizei bufSize, GLint* params) const {
        assert(_GetInternalformatSampleivNV !is null, "OpenGL command glGetInternalformatSampleivNV was not loaded");
        return _GetInternalformatSampleivNV (target, internalformat, samples, pname, bufSize, params);
    }

    /// Commands for GL_NV_path_rendering
    public GLuint GenPathsNV (GLsizei range) const {
        assert(_GenPathsNV !is null, "OpenGL command glGenPathsNV was not loaded");
        return _GenPathsNV (range);
    }
    /// ditto
    public void DeletePathsNV (GLuint path, GLsizei range) const {
        assert(_DeletePathsNV !is null, "OpenGL command glDeletePathsNV was not loaded");
        return _DeletePathsNV (path, range);
    }
    /// ditto
    public GLboolean IsPathNV (GLuint path) const {
        assert(_IsPathNV !is null, "OpenGL command glIsPathNV was not loaded");
        return _IsPathNV (path);
    }
    /// ditto
    public void PathCommandsNV (GLuint path, GLsizei numCommands, const(GLubyte)* commands, GLsizei numCoords, GLenum coordType, const(void)* coords) const {
        assert(_PathCommandsNV !is null, "OpenGL command glPathCommandsNV was not loaded");
        return _PathCommandsNV (path, numCommands, commands, numCoords, coordType, coords);
    }
    /// ditto
    public void PathCoordsNV (GLuint path, GLsizei numCoords, GLenum coordType, const(void)* coords) const {
        assert(_PathCoordsNV !is null, "OpenGL command glPathCoordsNV was not loaded");
        return _PathCoordsNV (path, numCoords, coordType, coords);
    }
    /// ditto
    public void PathSubCommandsNV (GLuint path, GLsizei commandStart, GLsizei commandsToDelete, GLsizei numCommands, const(GLubyte)* commands, GLsizei numCoords, GLenum coordType, const(void)* coords) const {
        assert(_PathSubCommandsNV !is null, "OpenGL command glPathSubCommandsNV was not loaded");
        return _PathSubCommandsNV (path, commandStart, commandsToDelete, numCommands, commands, numCoords, coordType, coords);
    }
    /// ditto
    public void PathSubCoordsNV (GLuint path, GLsizei coordStart, GLsizei numCoords, GLenum coordType, const(void)* coords) const {
        assert(_PathSubCoordsNV !is null, "OpenGL command glPathSubCoordsNV was not loaded");
        return _PathSubCoordsNV (path, coordStart, numCoords, coordType, coords);
    }
    /// ditto
    public void PathStringNV (GLuint path, GLenum format, GLsizei length, const(void)* pathString) const {
        assert(_PathStringNV !is null, "OpenGL command glPathStringNV was not loaded");
        return _PathStringNV (path, format, length, pathString);
    }
    /// ditto
    public void PathGlyphsNV (GLuint firstPathName, GLenum fontTarget, const(void)* fontName, GLbitfield fontStyle, GLsizei numGlyphs, GLenum type, const(void)* charcodes, GLenum handleMissingGlyphs, GLuint pathParameterTemplate, GLfloat emScale) const {
        assert(_PathGlyphsNV !is null, "OpenGL command glPathGlyphsNV was not loaded");
        return _PathGlyphsNV (firstPathName, fontTarget, fontName, fontStyle, numGlyphs, type, charcodes, handleMissingGlyphs, pathParameterTemplate, emScale);
    }
    /// ditto
    public void PathGlyphRangeNV (GLuint firstPathName, GLenum fontTarget, const(void)* fontName, GLbitfield fontStyle, GLuint firstGlyph, GLsizei numGlyphs, GLenum handleMissingGlyphs, GLuint pathParameterTemplate, GLfloat emScale) const {
        assert(_PathGlyphRangeNV !is null, "OpenGL command glPathGlyphRangeNV was not loaded");
        return _PathGlyphRangeNV (firstPathName, fontTarget, fontName, fontStyle, firstGlyph, numGlyphs, handleMissingGlyphs, pathParameterTemplate, emScale);
    }
    /// ditto
    public void WeightPathsNV (GLuint resultPath, GLsizei numPaths, const(GLuint)* paths, const(GLfloat)* weights) const {
        assert(_WeightPathsNV !is null, "OpenGL command glWeightPathsNV was not loaded");
        return _WeightPathsNV (resultPath, numPaths, paths, weights);
    }
    /// ditto
    public void CopyPathNV (GLuint resultPath, GLuint srcPath) const {
        assert(_CopyPathNV !is null, "OpenGL command glCopyPathNV was not loaded");
        return _CopyPathNV (resultPath, srcPath);
    }
    /// ditto
    public void InterpolatePathsNV (GLuint resultPath, GLuint pathA, GLuint pathB, GLfloat weight) const {
        assert(_InterpolatePathsNV !is null, "OpenGL command glInterpolatePathsNV was not loaded");
        return _InterpolatePathsNV (resultPath, pathA, pathB, weight);
    }
    /// ditto
    public void TransformPathNV (GLuint resultPath, GLuint srcPath, GLenum transformType, const(GLfloat)* transformValues) const {
        assert(_TransformPathNV !is null, "OpenGL command glTransformPathNV was not loaded");
        return _TransformPathNV (resultPath, srcPath, transformType, transformValues);
    }
    /// ditto
    public void PathParameterivNV (GLuint path, GLenum pname, const(GLint)* value) const {
        assert(_PathParameterivNV !is null, "OpenGL command glPathParameterivNV was not loaded");
        return _PathParameterivNV (path, pname, value);
    }
    /// ditto
    public void PathParameteriNV (GLuint path, GLenum pname, GLint value) const {
        assert(_PathParameteriNV !is null, "OpenGL command glPathParameteriNV was not loaded");
        return _PathParameteriNV (path, pname, value);
    }
    /// ditto
    public void PathParameterfvNV (GLuint path, GLenum pname, const(GLfloat)* value) const {
        assert(_PathParameterfvNV !is null, "OpenGL command glPathParameterfvNV was not loaded");
        return _PathParameterfvNV (path, pname, value);
    }
    /// ditto
    public void PathParameterfNV (GLuint path, GLenum pname, GLfloat value) const {
        assert(_PathParameterfNV !is null, "OpenGL command glPathParameterfNV was not loaded");
        return _PathParameterfNV (path, pname, value);
    }
    /// ditto
    public void PathDashArrayNV (GLuint path, GLsizei dashCount, const(GLfloat)* dashArray) const {
        assert(_PathDashArrayNV !is null, "OpenGL command glPathDashArrayNV was not loaded");
        return _PathDashArrayNV (path, dashCount, dashArray);
    }
    /// ditto
    public void PathStencilFuncNV (GLenum func, GLint ref_, GLuint mask) const {
        assert(_PathStencilFuncNV !is null, "OpenGL command glPathStencilFuncNV was not loaded");
        return _PathStencilFuncNV (func, ref_, mask);
    }
    /// ditto
    public void PathStencilDepthOffsetNV (GLfloat factor, GLfloat units) const {
        assert(_PathStencilDepthOffsetNV !is null, "OpenGL command glPathStencilDepthOffsetNV was not loaded");
        return _PathStencilDepthOffsetNV (factor, units);
    }
    /// ditto
    public void StencilFillPathNV (GLuint path, GLenum fillMode, GLuint mask) const {
        assert(_StencilFillPathNV !is null, "OpenGL command glStencilFillPathNV was not loaded");
        return _StencilFillPathNV (path, fillMode, mask);
    }
    /// ditto
    public void StencilStrokePathNV (GLuint path, GLint reference, GLuint mask) const {
        assert(_StencilStrokePathNV !is null, "OpenGL command glStencilStrokePathNV was not loaded");
        return _StencilStrokePathNV (path, reference, mask);
    }
    /// ditto
    public void StencilFillPathInstancedNV (GLsizei numPaths, GLenum pathNameType, const(void)* paths, GLuint pathBase, GLenum fillMode, GLuint mask, GLenum transformType, const(GLfloat)* transformValues) const {
        assert(_StencilFillPathInstancedNV !is null, "OpenGL command glStencilFillPathInstancedNV was not loaded");
        return _StencilFillPathInstancedNV (numPaths, pathNameType, paths, pathBase, fillMode, mask, transformType, transformValues);
    }
    /// ditto
    public void StencilStrokePathInstancedNV (GLsizei numPaths, GLenum pathNameType, const(void)* paths, GLuint pathBase, GLint reference, GLuint mask, GLenum transformType, const(GLfloat)* transformValues) const {
        assert(_StencilStrokePathInstancedNV !is null, "OpenGL command glStencilStrokePathInstancedNV was not loaded");
        return _StencilStrokePathInstancedNV (numPaths, pathNameType, paths, pathBase, reference, mask, transformType, transformValues);
    }
    /// ditto
    public void PathCoverDepthFuncNV (GLenum func) const {
        assert(_PathCoverDepthFuncNV !is null, "OpenGL command glPathCoverDepthFuncNV was not loaded");
        return _PathCoverDepthFuncNV (func);
    }
    /// ditto
    public void CoverFillPathNV (GLuint path, GLenum coverMode) const {
        assert(_CoverFillPathNV !is null, "OpenGL command glCoverFillPathNV was not loaded");
        return _CoverFillPathNV (path, coverMode);
    }
    /// ditto
    public void CoverStrokePathNV (GLuint path, GLenum coverMode) const {
        assert(_CoverStrokePathNV !is null, "OpenGL command glCoverStrokePathNV was not loaded");
        return _CoverStrokePathNV (path, coverMode);
    }
    /// ditto
    public void CoverFillPathInstancedNV (GLsizei numPaths, GLenum pathNameType, const(void)* paths, GLuint pathBase, GLenum coverMode, GLenum transformType, const(GLfloat)* transformValues) const {
        assert(_CoverFillPathInstancedNV !is null, "OpenGL command glCoverFillPathInstancedNV was not loaded");
        return _CoverFillPathInstancedNV (numPaths, pathNameType, paths, pathBase, coverMode, transformType, transformValues);
    }
    /// ditto
    public void CoverStrokePathInstancedNV (GLsizei numPaths, GLenum pathNameType, const(void)* paths, GLuint pathBase, GLenum coverMode, GLenum transformType, const(GLfloat)* transformValues) const {
        assert(_CoverStrokePathInstancedNV !is null, "OpenGL command glCoverStrokePathInstancedNV was not loaded");
        return _CoverStrokePathInstancedNV (numPaths, pathNameType, paths, pathBase, coverMode, transformType, transformValues);
    }
    /// ditto
    public void GetPathParameterivNV (GLuint path, GLenum pname, GLint* value) const {
        assert(_GetPathParameterivNV !is null, "OpenGL command glGetPathParameterivNV was not loaded");
        return _GetPathParameterivNV (path, pname, value);
    }
    /// ditto
    public void GetPathParameterfvNV (GLuint path, GLenum pname, GLfloat* value) const {
        assert(_GetPathParameterfvNV !is null, "OpenGL command glGetPathParameterfvNV was not loaded");
        return _GetPathParameterfvNV (path, pname, value);
    }
    /// ditto
    public void GetPathCommandsNV (GLuint path, GLubyte* commands) const {
        assert(_GetPathCommandsNV !is null, "OpenGL command glGetPathCommandsNV was not loaded");
        return _GetPathCommandsNV (path, commands);
    }
    /// ditto
    public void GetPathCoordsNV (GLuint path, GLfloat* coords) const {
        assert(_GetPathCoordsNV !is null, "OpenGL command glGetPathCoordsNV was not loaded");
        return _GetPathCoordsNV (path, coords);
    }
    /// ditto
    public void GetPathDashArrayNV (GLuint path, GLfloat* dashArray) const {
        assert(_GetPathDashArrayNV !is null, "OpenGL command glGetPathDashArrayNV was not loaded");
        return _GetPathDashArrayNV (path, dashArray);
    }
    /// ditto
    public void GetPathMetricsNV (GLbitfield metricQueryMask, GLsizei numPaths, GLenum pathNameType, const(void)* paths, GLuint pathBase, GLsizei stride, GLfloat* metrics) const {
        assert(_GetPathMetricsNV !is null, "OpenGL command glGetPathMetricsNV was not loaded");
        return _GetPathMetricsNV (metricQueryMask, numPaths, pathNameType, paths, pathBase, stride, metrics);
    }
    /// ditto
    public void GetPathMetricRangeNV (GLbitfield metricQueryMask, GLuint firstPathName, GLsizei numPaths, GLsizei stride, GLfloat* metrics) const {
        assert(_GetPathMetricRangeNV !is null, "OpenGL command glGetPathMetricRangeNV was not loaded");
        return _GetPathMetricRangeNV (metricQueryMask, firstPathName, numPaths, stride, metrics);
    }
    /// ditto
    public void GetPathSpacingNV (GLenum pathListMode, GLsizei numPaths, GLenum pathNameType, const(void)* paths, GLuint pathBase, GLfloat advanceScale, GLfloat kerningScale, GLenum transformType, GLfloat* returnedSpacing) const {
        assert(_GetPathSpacingNV !is null, "OpenGL command glGetPathSpacingNV was not loaded");
        return _GetPathSpacingNV (pathListMode, numPaths, pathNameType, paths, pathBase, advanceScale, kerningScale, transformType, returnedSpacing);
    }
    /// ditto
    public GLboolean IsPointInFillPathNV (GLuint path, GLuint mask, GLfloat x, GLfloat y) const {
        assert(_IsPointInFillPathNV !is null, "OpenGL command glIsPointInFillPathNV was not loaded");
        return _IsPointInFillPathNV (path, mask, x, y);
    }
    /// ditto
    public GLboolean IsPointInStrokePathNV (GLuint path, GLfloat x, GLfloat y) const {
        assert(_IsPointInStrokePathNV !is null, "OpenGL command glIsPointInStrokePathNV was not loaded");
        return _IsPointInStrokePathNV (path, x, y);
    }
    /// ditto
    public GLfloat GetPathLengthNV (GLuint path, GLsizei startSegment, GLsizei numSegments) const {
        assert(_GetPathLengthNV !is null, "OpenGL command glGetPathLengthNV was not loaded");
        return _GetPathLengthNV (path, startSegment, numSegments);
    }
    /// ditto
    public GLboolean PointAlongPathNV (GLuint path, GLsizei startSegment, GLsizei numSegments, GLfloat distance, GLfloat* x, GLfloat* y, GLfloat* tangentX, GLfloat* tangentY) const {
        assert(_PointAlongPathNV !is null, "OpenGL command glPointAlongPathNV was not loaded");
        return _PointAlongPathNV (path, startSegment, numSegments, distance, x, y, tangentX, tangentY);
    }
    /// ditto
    public void MatrixLoad3x2fNV (GLenum matrixMode, const(GLfloat)* m) const {
        assert(_MatrixLoad3x2fNV !is null, "OpenGL command glMatrixLoad3x2fNV was not loaded");
        return _MatrixLoad3x2fNV (matrixMode, m);
    }
    /// ditto
    public void MatrixLoad3x3fNV (GLenum matrixMode, const(GLfloat)* m) const {
        assert(_MatrixLoad3x3fNV !is null, "OpenGL command glMatrixLoad3x3fNV was not loaded");
        return _MatrixLoad3x3fNV (matrixMode, m);
    }
    /// ditto
    public void MatrixLoadTranspose3x3fNV (GLenum matrixMode, const(GLfloat)* m) const {
        assert(_MatrixLoadTranspose3x3fNV !is null, "OpenGL command glMatrixLoadTranspose3x3fNV was not loaded");
        return _MatrixLoadTranspose3x3fNV (matrixMode, m);
    }
    /// ditto
    public void MatrixMult3x2fNV (GLenum matrixMode, const(GLfloat)* m) const {
        assert(_MatrixMult3x2fNV !is null, "OpenGL command glMatrixMult3x2fNV was not loaded");
        return _MatrixMult3x2fNV (matrixMode, m);
    }
    /// ditto
    public void MatrixMult3x3fNV (GLenum matrixMode, const(GLfloat)* m) const {
        assert(_MatrixMult3x3fNV !is null, "OpenGL command glMatrixMult3x3fNV was not loaded");
        return _MatrixMult3x3fNV (matrixMode, m);
    }
    /// ditto
    public void MatrixMultTranspose3x3fNV (GLenum matrixMode, const(GLfloat)* m) const {
        assert(_MatrixMultTranspose3x3fNV !is null, "OpenGL command glMatrixMultTranspose3x3fNV was not loaded");
        return _MatrixMultTranspose3x3fNV (matrixMode, m);
    }
    /// ditto
    public void StencilThenCoverFillPathNV (GLuint path, GLenum fillMode, GLuint mask, GLenum coverMode) const {
        assert(_StencilThenCoverFillPathNV !is null, "OpenGL command glStencilThenCoverFillPathNV was not loaded");
        return _StencilThenCoverFillPathNV (path, fillMode, mask, coverMode);
    }
    /// ditto
    public void StencilThenCoverStrokePathNV (GLuint path, GLint reference, GLuint mask, GLenum coverMode) const {
        assert(_StencilThenCoverStrokePathNV !is null, "OpenGL command glStencilThenCoverStrokePathNV was not loaded");
        return _StencilThenCoverStrokePathNV (path, reference, mask, coverMode);
    }
    /// ditto
    public void StencilThenCoverFillPathInstancedNV (GLsizei numPaths, GLenum pathNameType, const(void)* paths, GLuint pathBase, GLenum fillMode, GLuint mask, GLenum coverMode, GLenum transformType, const(GLfloat)* transformValues) const {
        assert(_StencilThenCoverFillPathInstancedNV !is null, "OpenGL command glStencilThenCoverFillPathInstancedNV was not loaded");
        return _StencilThenCoverFillPathInstancedNV (numPaths, pathNameType, paths, pathBase, fillMode, mask, coverMode, transformType, transformValues);
    }
    /// ditto
    public void StencilThenCoverStrokePathInstancedNV (GLsizei numPaths, GLenum pathNameType, const(void)* paths, GLuint pathBase, GLint reference, GLuint mask, GLenum coverMode, GLenum transformType, const(GLfloat)* transformValues) const {
        assert(_StencilThenCoverStrokePathInstancedNV !is null, "OpenGL command glStencilThenCoverStrokePathInstancedNV was not loaded");
        return _StencilThenCoverStrokePathInstancedNV (numPaths, pathNameType, paths, pathBase, reference, mask, coverMode, transformType, transformValues);
    }
    /// ditto
    public GLenum PathGlyphIndexRangeNV (GLenum fontTarget, const(void)* fontName, GLbitfield fontStyle, GLuint pathParameterTemplate, GLfloat emScale, GLuint [2] baseAndCount) const {
        assert(_PathGlyphIndexRangeNV !is null, "OpenGL command glPathGlyphIndexRangeNV was not loaded");
        return _PathGlyphIndexRangeNV (fontTarget, fontName, fontStyle, pathParameterTemplate, emScale, baseAndCount);
    }
    /// ditto
    public GLenum PathGlyphIndexArrayNV (GLuint firstPathName, GLenum fontTarget, const(void)* fontName, GLbitfield fontStyle, GLuint firstGlyphIndex, GLsizei numGlyphs, GLuint pathParameterTemplate, GLfloat emScale) const {
        assert(_PathGlyphIndexArrayNV !is null, "OpenGL command glPathGlyphIndexArrayNV was not loaded");
        return _PathGlyphIndexArrayNV (firstPathName, fontTarget, fontName, fontStyle, firstGlyphIndex, numGlyphs, pathParameterTemplate, emScale);
    }
    /// ditto
    public GLenum PathMemoryGlyphIndexArrayNV (GLuint firstPathName, GLenum fontTarget, GLsizeiptr fontSize, const(void)* fontData, GLsizei faceIndex, GLuint firstGlyphIndex, GLsizei numGlyphs, GLuint pathParameterTemplate, GLfloat emScale) const {
        assert(_PathMemoryGlyphIndexArrayNV !is null, "OpenGL command glPathMemoryGlyphIndexArrayNV was not loaded");
        return _PathMemoryGlyphIndexArrayNV (firstPathName, fontTarget, fontSize, fontData, faceIndex, firstGlyphIndex, numGlyphs, pathParameterTemplate, emScale);
    }
    /// ditto
    public void ProgramPathFragmentInputGenNV (GLuint program, GLint location, GLenum genMode, GLint components, const(GLfloat)* coeffs) const {
        assert(_ProgramPathFragmentInputGenNV !is null, "OpenGL command glProgramPathFragmentInputGenNV was not loaded");
        return _ProgramPathFragmentInputGenNV (program, location, genMode, components, coeffs);
    }
    /// ditto
    public void GetProgramResourcefvNV (GLuint program, GLenum programInterface, GLuint index, GLsizei propCount, const(GLenum)* props, GLsizei bufSize, GLsizei* length, GLfloat* params) const {
        assert(_GetProgramResourcefvNV !is null, "OpenGL command glGetProgramResourcefvNV was not loaded");
        return _GetProgramResourcefvNV (program, programInterface, index, propCount, props, bufSize, length, params);
    }

    /// Commands for GL_NV_sample_locations
    public void FramebufferSampleLocationsfvNV (GLenum target, GLuint start, GLsizei count, const(GLfloat)* v) const {
        assert(_FramebufferSampleLocationsfvNV !is null, "OpenGL command glFramebufferSampleLocationsfvNV was not loaded");
        return _FramebufferSampleLocationsfvNV (target, start, count, v);
    }
    /// ditto
    public void NamedFramebufferSampleLocationsfvNV (GLuint framebuffer, GLuint start, GLsizei count, const(GLfloat)* v) const {
        assert(_NamedFramebufferSampleLocationsfvNV !is null, "OpenGL command glNamedFramebufferSampleLocationsfvNV was not loaded");
        return _NamedFramebufferSampleLocationsfvNV (framebuffer, start, count, v);
    }
    /// ditto
    public void ResolveDepthValuesNV () const {
        assert(_ResolveDepthValuesNV !is null, "OpenGL command glResolveDepthValuesNV was not loaded");
        return _ResolveDepthValuesNV ();
    }

    /// Commands for GL_NV_shader_buffer_load
    public void MakeBufferResidentNV (GLenum target, GLenum access) const {
        assert(_MakeBufferResidentNV !is null, "OpenGL command glMakeBufferResidentNV was not loaded");
        return _MakeBufferResidentNV (target, access);
    }
    /// ditto
    public void MakeBufferNonResidentNV (GLenum target) const {
        assert(_MakeBufferNonResidentNV !is null, "OpenGL command glMakeBufferNonResidentNV was not loaded");
        return _MakeBufferNonResidentNV (target);
    }
    /// ditto
    public GLboolean IsBufferResidentNV (GLenum target) const {
        assert(_IsBufferResidentNV !is null, "OpenGL command glIsBufferResidentNV was not loaded");
        return _IsBufferResidentNV (target);
    }
    /// ditto
    public void MakeNamedBufferResidentNV (GLuint buffer, GLenum access) const {
        assert(_MakeNamedBufferResidentNV !is null, "OpenGL command glMakeNamedBufferResidentNV was not loaded");
        return _MakeNamedBufferResidentNV (buffer, access);
    }
    /// ditto
    public void MakeNamedBufferNonResidentNV (GLuint buffer) const {
        assert(_MakeNamedBufferNonResidentNV !is null, "OpenGL command glMakeNamedBufferNonResidentNV was not loaded");
        return _MakeNamedBufferNonResidentNV (buffer);
    }
    /// ditto
    public GLboolean IsNamedBufferResidentNV (GLuint buffer) const {
        assert(_IsNamedBufferResidentNV !is null, "OpenGL command glIsNamedBufferResidentNV was not loaded");
        return _IsNamedBufferResidentNV (buffer);
    }
    /// ditto
    public void GetBufferParameterui64vNV (GLenum target, GLenum pname, GLuint64EXT* params) const {
        assert(_GetBufferParameterui64vNV !is null, "OpenGL command glGetBufferParameterui64vNV was not loaded");
        return _GetBufferParameterui64vNV (target, pname, params);
    }
    /// ditto
    public void GetNamedBufferParameterui64vNV (GLuint buffer, GLenum pname, GLuint64EXT* params) const {
        assert(_GetNamedBufferParameterui64vNV !is null, "OpenGL command glGetNamedBufferParameterui64vNV was not loaded");
        return _GetNamedBufferParameterui64vNV (buffer, pname, params);
    }
    /// ditto
    public void GetIntegerui64vNV (GLenum value, GLuint64EXT* result) const {
        assert(_GetIntegerui64vNV !is null, "OpenGL command glGetIntegerui64vNV was not loaded");
        return _GetIntegerui64vNV (value, result);
    }
    /// ditto
    public void Uniformui64NV (GLint location, GLuint64EXT value) const {
        assert(_Uniformui64NV !is null, "OpenGL command glUniformui64NV was not loaded");
        return _Uniformui64NV (location, value);
    }
    /// ditto
    public void Uniformui64vNV (GLint location, GLsizei count, const(GLuint64EXT)* value) const {
        assert(_Uniformui64vNV !is null, "OpenGL command glUniformui64vNV was not loaded");
        return _Uniformui64vNV (location, count, value);
    }
    /// ditto
    public void GetUniformui64vNV (GLuint program, GLint location, GLuint64EXT* params) const {
        assert(_GetUniformui64vNV !is null, "OpenGL command glGetUniformui64vNV was not loaded");
        return _GetUniformui64vNV (program, location, params);
    }
    /// ditto
    public void ProgramUniformui64NV (GLuint program, GLint location, GLuint64EXT value) const {
        assert(_ProgramUniformui64NV !is null, "OpenGL command glProgramUniformui64NV was not loaded");
        return _ProgramUniformui64NV (program, location, value);
    }
    /// ditto
    public void ProgramUniformui64vNV (GLuint program, GLint location, GLsizei count, const(GLuint64EXT)* value) const {
        assert(_ProgramUniformui64vNV !is null, "OpenGL command glProgramUniformui64vNV was not loaded");
        return _ProgramUniformui64vNV (program, location, count, value);
    }

    /// Commands for GL_NV_texture_barrier
    public void TextureBarrierNV () const {
        assert(_TextureBarrierNV !is null, "OpenGL command glTextureBarrierNV was not loaded");
        return _TextureBarrierNV ();
    }

    /// Commands for GL_NV_vertex_attrib_integer_64bit
    public void VertexAttribL1i64NV (GLuint index, GLint64EXT x) const {
        assert(_VertexAttribL1i64NV !is null, "OpenGL command glVertexAttribL1i64NV was not loaded");
        return _VertexAttribL1i64NV (index, x);
    }
    /// ditto
    public void VertexAttribL2i64NV (GLuint index, GLint64EXT x, GLint64EXT y) const {
        assert(_VertexAttribL2i64NV !is null, "OpenGL command glVertexAttribL2i64NV was not loaded");
        return _VertexAttribL2i64NV (index, x, y);
    }
    /// ditto
    public void VertexAttribL3i64NV (GLuint index, GLint64EXT x, GLint64EXT y, GLint64EXT z) const {
        assert(_VertexAttribL3i64NV !is null, "OpenGL command glVertexAttribL3i64NV was not loaded");
        return _VertexAttribL3i64NV (index, x, y, z);
    }
    /// ditto
    public void VertexAttribL4i64NV (GLuint index, GLint64EXT x, GLint64EXT y, GLint64EXT z, GLint64EXT w) const {
        assert(_VertexAttribL4i64NV !is null, "OpenGL command glVertexAttribL4i64NV was not loaded");
        return _VertexAttribL4i64NV (index, x, y, z, w);
    }
    /// ditto
    public void VertexAttribL1i64vNV (GLuint index, const(GLint64EXT)* v) const {
        assert(_VertexAttribL1i64vNV !is null, "OpenGL command glVertexAttribL1i64vNV was not loaded");
        return _VertexAttribL1i64vNV (index, v);
    }
    /// ditto
    public void VertexAttribL2i64vNV (GLuint index, const(GLint64EXT)* v) const {
        assert(_VertexAttribL2i64vNV !is null, "OpenGL command glVertexAttribL2i64vNV was not loaded");
        return _VertexAttribL2i64vNV (index, v);
    }
    /// ditto
    public void VertexAttribL3i64vNV (GLuint index, const(GLint64EXT)* v) const {
        assert(_VertexAttribL3i64vNV !is null, "OpenGL command glVertexAttribL3i64vNV was not loaded");
        return _VertexAttribL3i64vNV (index, v);
    }
    /// ditto
    public void VertexAttribL4i64vNV (GLuint index, const(GLint64EXT)* v) const {
        assert(_VertexAttribL4i64vNV !is null, "OpenGL command glVertexAttribL4i64vNV was not loaded");
        return _VertexAttribL4i64vNV (index, v);
    }
    /// ditto
    public void VertexAttribL1ui64NV (GLuint index, GLuint64EXT x) const {
        assert(_VertexAttribL1ui64NV !is null, "OpenGL command glVertexAttribL1ui64NV was not loaded");
        return _VertexAttribL1ui64NV (index, x);
    }
    /// ditto
    public void VertexAttribL2ui64NV (GLuint index, GLuint64EXT x, GLuint64EXT y) const {
        assert(_VertexAttribL2ui64NV !is null, "OpenGL command glVertexAttribL2ui64NV was not loaded");
        return _VertexAttribL2ui64NV (index, x, y);
    }
    /// ditto
    public void VertexAttribL3ui64NV (GLuint index, GLuint64EXT x, GLuint64EXT y, GLuint64EXT z) const {
        assert(_VertexAttribL3ui64NV !is null, "OpenGL command glVertexAttribL3ui64NV was not loaded");
        return _VertexAttribL3ui64NV (index, x, y, z);
    }
    /// ditto
    public void VertexAttribL4ui64NV (GLuint index, GLuint64EXT x, GLuint64EXT y, GLuint64EXT z, GLuint64EXT w) const {
        assert(_VertexAttribL4ui64NV !is null, "OpenGL command glVertexAttribL4ui64NV was not loaded");
        return _VertexAttribL4ui64NV (index, x, y, z, w);
    }
    /// ditto
    public void VertexAttribL1ui64vNV (GLuint index, const(GLuint64EXT)* v) const {
        assert(_VertexAttribL1ui64vNV !is null, "OpenGL command glVertexAttribL1ui64vNV was not loaded");
        return _VertexAttribL1ui64vNV (index, v);
    }
    /// ditto
    public void VertexAttribL2ui64vNV (GLuint index, const(GLuint64EXT)* v) const {
        assert(_VertexAttribL2ui64vNV !is null, "OpenGL command glVertexAttribL2ui64vNV was not loaded");
        return _VertexAttribL2ui64vNV (index, v);
    }
    /// ditto
    public void VertexAttribL3ui64vNV (GLuint index, const(GLuint64EXT)* v) const {
        assert(_VertexAttribL3ui64vNV !is null, "OpenGL command glVertexAttribL3ui64vNV was not loaded");
        return _VertexAttribL3ui64vNV (index, v);
    }
    /// ditto
    public void VertexAttribL4ui64vNV (GLuint index, const(GLuint64EXT)* v) const {
        assert(_VertexAttribL4ui64vNV !is null, "OpenGL command glVertexAttribL4ui64vNV was not loaded");
        return _VertexAttribL4ui64vNV (index, v);
    }
    /// ditto
    public void GetVertexAttribLi64vNV (GLuint index, GLenum pname, GLint64EXT* params) const {
        assert(_GetVertexAttribLi64vNV !is null, "OpenGL command glGetVertexAttribLi64vNV was not loaded");
        return _GetVertexAttribLi64vNV (index, pname, params);
    }
    /// ditto
    public void GetVertexAttribLui64vNV (GLuint index, GLenum pname, GLuint64EXT* params) const {
        assert(_GetVertexAttribLui64vNV !is null, "OpenGL command glGetVertexAttribLui64vNV was not loaded");
        return _GetVertexAttribLui64vNV (index, pname, params);
    }
    /// ditto
    public void VertexAttribLFormatNV (GLuint index, GLint size, GLenum type, GLsizei stride) const {
        assert(_VertexAttribLFormatNV !is null, "OpenGL command glVertexAttribLFormatNV was not loaded");
        return _VertexAttribLFormatNV (index, size, type, stride);
    }

    /// Commands for GL_NV_vertex_buffer_unified_memory
    public void BufferAddressRangeNV (GLenum pname, GLuint index, GLuint64EXT address, GLsizeiptr length) const {
        assert(_BufferAddressRangeNV !is null, "OpenGL command glBufferAddressRangeNV was not loaded");
        return _BufferAddressRangeNV (pname, index, address, length);
    }
    /// ditto
    public void VertexFormatNV (GLint size, GLenum type, GLsizei stride) const {
        assert(_VertexFormatNV !is null, "OpenGL command glVertexFormatNV was not loaded");
        return _VertexFormatNV (size, type, stride);
    }
    /// ditto
    public void NormalFormatNV (GLenum type, GLsizei stride) const {
        assert(_NormalFormatNV !is null, "OpenGL command glNormalFormatNV was not loaded");
        return _NormalFormatNV (type, stride);
    }
    /// ditto
    public void ColorFormatNV (GLint size, GLenum type, GLsizei stride) const {
        assert(_ColorFormatNV !is null, "OpenGL command glColorFormatNV was not loaded");
        return _ColorFormatNV (size, type, stride);
    }
    /// ditto
    public void IndexFormatNV (GLenum type, GLsizei stride) const {
        assert(_IndexFormatNV !is null, "OpenGL command glIndexFormatNV was not loaded");
        return _IndexFormatNV (type, stride);
    }
    /// ditto
    public void TexCoordFormatNV (GLint size, GLenum type, GLsizei stride) const {
        assert(_TexCoordFormatNV !is null, "OpenGL command glTexCoordFormatNV was not loaded");
        return _TexCoordFormatNV (size, type, stride);
    }
    /// ditto
    public void EdgeFlagFormatNV (GLsizei stride) const {
        assert(_EdgeFlagFormatNV !is null, "OpenGL command glEdgeFlagFormatNV was not loaded");
        return _EdgeFlagFormatNV (stride);
    }
    /// ditto
    public void SecondaryColorFormatNV (GLint size, GLenum type, GLsizei stride) const {
        assert(_SecondaryColorFormatNV !is null, "OpenGL command glSecondaryColorFormatNV was not loaded");
        return _SecondaryColorFormatNV (size, type, stride);
    }
    /// ditto
    public void FogCoordFormatNV (GLenum type, GLsizei stride) const {
        assert(_FogCoordFormatNV !is null, "OpenGL command glFogCoordFormatNV was not loaded");
        return _FogCoordFormatNV (type, stride);
    }
    /// ditto
    public void VertexAttribFormatNV (GLuint index, GLint size, GLenum type, GLboolean normalized, GLsizei stride) const {
        assert(_VertexAttribFormatNV !is null, "OpenGL command glVertexAttribFormatNV was not loaded");
        return _VertexAttribFormatNV (index, size, type, normalized, stride);
    }
    /// ditto
    public void VertexAttribIFormatNV (GLuint index, GLint size, GLenum type, GLsizei stride) const {
        assert(_VertexAttribIFormatNV !is null, "OpenGL command glVertexAttribIFormatNV was not loaded");
        return _VertexAttribIFormatNV (index, size, type, stride);
    }
    /// ditto
    public void GetIntegerui64i_vNV (GLenum value, GLuint index, GLuint64EXT* result) const {
        assert(_GetIntegerui64i_vNV !is null, "OpenGL command glGetIntegerui64i_vNV was not loaded");
        return _GetIntegerui64i_vNV (value, index, result);
    }

    /// Commands for GL_NV_viewport_swizzle
    public void ViewportSwizzleNV (GLuint index, GLenum swizzlex, GLenum swizzley, GLenum swizzlez, GLenum swizzlew) const {
        assert(_ViewportSwizzleNV !is null, "OpenGL command glViewportSwizzleNV was not loaded");
        return _ViewportSwizzleNV (index, swizzlex, swizzley, swizzlez, swizzlew);
    }

    /// Commands for GL_OVR_multiview
    public void FramebufferTextureMultiviewOVR (GLenum target, GLenum attachment, GLuint texture, GLint level, GLint baseViewIndex, GLsizei numViews) const {
        assert(_FramebufferTextureMultiviewOVR !is null, "OpenGL command glFramebufferTextureMultiviewOVR was not loaded");
        return _FramebufferTextureMultiviewOVR (target, attachment, texture, level, baseViewIndex, numViews);
    }

    // GL_VERSION_1_0
    private PFN_glCullFace _CullFace;
    private PFN_glFrontFace _FrontFace;
    private PFN_glHint _Hint;
    private PFN_glLineWidth _LineWidth;
    private PFN_glPointSize _PointSize;
    private PFN_glPolygonMode _PolygonMode;
    private PFN_glScissor _Scissor;
    private PFN_glTexParameterf _TexParameterf;
    private PFN_glTexParameterfv _TexParameterfv;
    private PFN_glTexParameteri _TexParameteri;
    private PFN_glTexParameteriv _TexParameteriv;
    private PFN_glTexImage1D _TexImage1D;
    private PFN_glTexImage2D _TexImage2D;
    private PFN_glDrawBuffer _DrawBuffer;
    private PFN_glClear _Clear;
    private PFN_glClearColor _ClearColor;
    private PFN_glClearStencil _ClearStencil;
    private PFN_glClearDepth _ClearDepth;
    private PFN_glStencilMask _StencilMask;
    private PFN_glColorMask _ColorMask;
    private PFN_glDepthMask _DepthMask;
    private PFN_glDisable _Disable;
    private PFN_glEnable _Enable;
    private PFN_glFinish _Finish;
    private PFN_glFlush _Flush;
    private PFN_glBlendFunc _BlendFunc;
    private PFN_glLogicOp _LogicOp;
    private PFN_glStencilFunc _StencilFunc;
    private PFN_glStencilOp _StencilOp;
    private PFN_glDepthFunc _DepthFunc;
    private PFN_glPixelStoref _PixelStoref;
    private PFN_glPixelStorei _PixelStorei;
    private PFN_glReadBuffer _ReadBuffer;
    private PFN_glReadPixels _ReadPixels;
    private PFN_glGetBooleanv _GetBooleanv;
    private PFN_glGetDoublev _GetDoublev;
    private PFN_glGetError _GetError;
    private PFN_glGetFloatv _GetFloatv;
    private PFN_glGetIntegerv _GetIntegerv;
    private PFN_glGetString _GetString;
    private PFN_glGetTexImage _GetTexImage;
    private PFN_glGetTexParameterfv _GetTexParameterfv;
    private PFN_glGetTexParameteriv _GetTexParameteriv;
    private PFN_glGetTexLevelParameterfv _GetTexLevelParameterfv;
    private PFN_glGetTexLevelParameteriv _GetTexLevelParameteriv;
    private PFN_glIsEnabled _IsEnabled;
    private PFN_glDepthRange _DepthRange;
    private PFN_glViewport _Viewport;

    // GL_VERSION_1_1
    private PFN_glDrawArrays _DrawArrays;
    private PFN_glDrawElements _DrawElements;
    private PFN_glGetPointerv _GetPointerv;
    private PFN_glPolygonOffset _PolygonOffset;
    private PFN_glCopyTexImage1D _CopyTexImage1D;
    private PFN_glCopyTexImage2D _CopyTexImage2D;
    private PFN_glCopyTexSubImage1D _CopyTexSubImage1D;
    private PFN_glCopyTexSubImage2D _CopyTexSubImage2D;
    private PFN_glTexSubImage1D _TexSubImage1D;
    private PFN_glTexSubImage2D _TexSubImage2D;
    private PFN_glBindTexture _BindTexture;
    private PFN_glDeleteTextures _DeleteTextures;
    private PFN_glGenTextures _GenTextures;
    private PFN_glIsTexture _IsTexture;

    // GL_VERSION_1_2
    private PFN_glDrawRangeElements _DrawRangeElements;
    private PFN_glTexImage3D _TexImage3D;
    private PFN_glTexSubImage3D _TexSubImage3D;
    private PFN_glCopyTexSubImage3D _CopyTexSubImage3D;

    // GL_VERSION_1_3
    private PFN_glActiveTexture _ActiveTexture;
    private PFN_glSampleCoverage _SampleCoverage;
    private PFN_glCompressedTexImage3D _CompressedTexImage3D;
    private PFN_glCompressedTexImage2D _CompressedTexImage2D;
    private PFN_glCompressedTexImage1D _CompressedTexImage1D;
    private PFN_glCompressedTexSubImage3D _CompressedTexSubImage3D;
    private PFN_glCompressedTexSubImage2D _CompressedTexSubImage2D;
    private PFN_glCompressedTexSubImage1D _CompressedTexSubImage1D;
    private PFN_glGetCompressedTexImage _GetCompressedTexImage;

    // GL_VERSION_1_4
    private PFN_glBlendFuncSeparate _BlendFuncSeparate;
    private PFN_glMultiDrawArrays _MultiDrawArrays;
    private PFN_glMultiDrawElements _MultiDrawElements;
    private PFN_glPointParameterf _PointParameterf;
    private PFN_glPointParameterfv _PointParameterfv;
    private PFN_glPointParameteri _PointParameteri;
    private PFN_glPointParameteriv _PointParameteriv;
    private PFN_glBlendColor _BlendColor;
    private PFN_glBlendEquation _BlendEquation;

    // GL_VERSION_1_5
    private PFN_glGenQueries _GenQueries;
    private PFN_glDeleteQueries _DeleteQueries;
    private PFN_glIsQuery _IsQuery;
    private PFN_glBeginQuery _BeginQuery;
    private PFN_glEndQuery _EndQuery;
    private PFN_glGetQueryiv _GetQueryiv;
    private PFN_glGetQueryObjectiv _GetQueryObjectiv;
    private PFN_glGetQueryObjectuiv _GetQueryObjectuiv;
    private PFN_glBindBuffer _BindBuffer;
    private PFN_glDeleteBuffers _DeleteBuffers;
    private PFN_glGenBuffers _GenBuffers;
    private PFN_glIsBuffer _IsBuffer;
    private PFN_glBufferData _BufferData;
    private PFN_glBufferSubData _BufferSubData;
    private PFN_glGetBufferSubData _GetBufferSubData;
    private PFN_glMapBuffer _MapBuffer;
    private PFN_glUnmapBuffer _UnmapBuffer;
    private PFN_glGetBufferParameteriv _GetBufferParameteriv;
    private PFN_glGetBufferPointerv _GetBufferPointerv;

    // GL_VERSION_2_0
    private PFN_glBlendEquationSeparate _BlendEquationSeparate;
    private PFN_glDrawBuffers _DrawBuffers;
    private PFN_glStencilOpSeparate _StencilOpSeparate;
    private PFN_glStencilFuncSeparate _StencilFuncSeparate;
    private PFN_glStencilMaskSeparate _StencilMaskSeparate;
    private PFN_glAttachShader _AttachShader;
    private PFN_glBindAttribLocation _BindAttribLocation;
    private PFN_glCompileShader _CompileShader;
    private PFN_glCreateProgram _CreateProgram;
    private PFN_glCreateShader _CreateShader;
    private PFN_glDeleteProgram _DeleteProgram;
    private PFN_glDeleteShader _DeleteShader;
    private PFN_glDetachShader _DetachShader;
    private PFN_glDisableVertexAttribArray _DisableVertexAttribArray;
    private PFN_glEnableVertexAttribArray _EnableVertexAttribArray;
    private PFN_glGetActiveAttrib _GetActiveAttrib;
    private PFN_glGetActiveUniform _GetActiveUniform;
    private PFN_glGetAttachedShaders _GetAttachedShaders;
    private PFN_glGetAttribLocation _GetAttribLocation;
    private PFN_glGetProgramiv _GetProgramiv;
    private PFN_glGetProgramInfoLog _GetProgramInfoLog;
    private PFN_glGetShaderiv _GetShaderiv;
    private PFN_glGetShaderInfoLog _GetShaderInfoLog;
    private PFN_glGetShaderSource _GetShaderSource;
    private PFN_glGetUniformLocation _GetUniformLocation;
    private PFN_glGetUniformfv _GetUniformfv;
    private PFN_glGetUniformiv _GetUniformiv;
    private PFN_glGetVertexAttribdv _GetVertexAttribdv;
    private PFN_glGetVertexAttribfv _GetVertexAttribfv;
    private PFN_glGetVertexAttribiv _GetVertexAttribiv;
    private PFN_glGetVertexAttribPointerv _GetVertexAttribPointerv;
    private PFN_glIsProgram _IsProgram;
    private PFN_glIsShader _IsShader;
    private PFN_glLinkProgram _LinkProgram;
    private PFN_glShaderSource _ShaderSource;
    private PFN_glUseProgram _UseProgram;
    private PFN_glUniform1f _Uniform1f;
    private PFN_glUniform2f _Uniform2f;
    private PFN_glUniform3f _Uniform3f;
    private PFN_glUniform4f _Uniform4f;
    private PFN_glUniform1i _Uniform1i;
    private PFN_glUniform2i _Uniform2i;
    private PFN_glUniform3i _Uniform3i;
    private PFN_glUniform4i _Uniform4i;
    private PFN_glUniform1fv _Uniform1fv;
    private PFN_glUniform2fv _Uniform2fv;
    private PFN_glUniform3fv _Uniform3fv;
    private PFN_glUniform4fv _Uniform4fv;
    private PFN_glUniform1iv _Uniform1iv;
    private PFN_glUniform2iv _Uniform2iv;
    private PFN_glUniform3iv _Uniform3iv;
    private PFN_glUniform4iv _Uniform4iv;
    private PFN_glUniformMatrix2fv _UniformMatrix2fv;
    private PFN_glUniformMatrix3fv _UniformMatrix3fv;
    private PFN_glUniformMatrix4fv _UniformMatrix4fv;
    private PFN_glValidateProgram _ValidateProgram;
    private PFN_glVertexAttrib1d _VertexAttrib1d;
    private PFN_glVertexAttrib1dv _VertexAttrib1dv;
    private PFN_glVertexAttrib1f _VertexAttrib1f;
    private PFN_glVertexAttrib1fv _VertexAttrib1fv;
    private PFN_glVertexAttrib1s _VertexAttrib1s;
    private PFN_glVertexAttrib1sv _VertexAttrib1sv;
    private PFN_glVertexAttrib2d _VertexAttrib2d;
    private PFN_glVertexAttrib2dv _VertexAttrib2dv;
    private PFN_glVertexAttrib2f _VertexAttrib2f;
    private PFN_glVertexAttrib2fv _VertexAttrib2fv;
    private PFN_glVertexAttrib2s _VertexAttrib2s;
    private PFN_glVertexAttrib2sv _VertexAttrib2sv;
    private PFN_glVertexAttrib3d _VertexAttrib3d;
    private PFN_glVertexAttrib3dv _VertexAttrib3dv;
    private PFN_glVertexAttrib3f _VertexAttrib3f;
    private PFN_glVertexAttrib3fv _VertexAttrib3fv;
    private PFN_glVertexAttrib3s _VertexAttrib3s;
    private PFN_glVertexAttrib3sv _VertexAttrib3sv;
    private PFN_glVertexAttrib4Nbv _VertexAttrib4Nbv;
    private PFN_glVertexAttrib4Niv _VertexAttrib4Niv;
    private PFN_glVertexAttrib4Nsv _VertexAttrib4Nsv;
    private PFN_glVertexAttrib4Nub _VertexAttrib4Nub;
    private PFN_glVertexAttrib4Nubv _VertexAttrib4Nubv;
    private PFN_glVertexAttrib4Nuiv _VertexAttrib4Nuiv;
    private PFN_glVertexAttrib4Nusv _VertexAttrib4Nusv;
    private PFN_glVertexAttrib4bv _VertexAttrib4bv;
    private PFN_glVertexAttrib4d _VertexAttrib4d;
    private PFN_glVertexAttrib4dv _VertexAttrib4dv;
    private PFN_glVertexAttrib4f _VertexAttrib4f;
    private PFN_glVertexAttrib4fv _VertexAttrib4fv;
    private PFN_glVertexAttrib4iv _VertexAttrib4iv;
    private PFN_glVertexAttrib4s _VertexAttrib4s;
    private PFN_glVertexAttrib4sv _VertexAttrib4sv;
    private PFN_glVertexAttrib4ubv _VertexAttrib4ubv;
    private PFN_glVertexAttrib4uiv _VertexAttrib4uiv;
    private PFN_glVertexAttrib4usv _VertexAttrib4usv;
    private PFN_glVertexAttribPointer _VertexAttribPointer;

    // GL_VERSION_2_1
    private PFN_glUniformMatrix2x3fv _UniformMatrix2x3fv;
    private PFN_glUniformMatrix3x2fv _UniformMatrix3x2fv;
    private PFN_glUniformMatrix2x4fv _UniformMatrix2x4fv;
    private PFN_glUniformMatrix4x2fv _UniformMatrix4x2fv;
    private PFN_glUniformMatrix3x4fv _UniformMatrix3x4fv;
    private PFN_glUniformMatrix4x3fv _UniformMatrix4x3fv;

    // GL_VERSION_3_0
    private PFN_glColorMaski _ColorMaski;
    private PFN_glGetBooleani_v _GetBooleani_v;
    private PFN_glGetIntegeri_v _GetIntegeri_v;
    private PFN_glEnablei _Enablei;
    private PFN_glDisablei _Disablei;
    private PFN_glIsEnabledi _IsEnabledi;
    private PFN_glBeginTransformFeedback _BeginTransformFeedback;
    private PFN_glEndTransformFeedback _EndTransformFeedback;
    private PFN_glBindBufferRange _BindBufferRange;
    private PFN_glBindBufferBase _BindBufferBase;
    private PFN_glTransformFeedbackVaryings _TransformFeedbackVaryings;
    private PFN_glGetTransformFeedbackVarying _GetTransformFeedbackVarying;
    private PFN_glClampColor _ClampColor;
    private PFN_glBeginConditionalRender _BeginConditionalRender;
    private PFN_glEndConditionalRender _EndConditionalRender;
    private PFN_glVertexAttribIPointer _VertexAttribIPointer;
    private PFN_glGetVertexAttribIiv _GetVertexAttribIiv;
    private PFN_glGetVertexAttribIuiv _GetVertexAttribIuiv;
    private PFN_glVertexAttribI1i _VertexAttribI1i;
    private PFN_glVertexAttribI2i _VertexAttribI2i;
    private PFN_glVertexAttribI3i _VertexAttribI3i;
    private PFN_glVertexAttribI4i _VertexAttribI4i;
    private PFN_glVertexAttribI1ui _VertexAttribI1ui;
    private PFN_glVertexAttribI2ui _VertexAttribI2ui;
    private PFN_glVertexAttribI3ui _VertexAttribI3ui;
    private PFN_glVertexAttribI4ui _VertexAttribI4ui;
    private PFN_glVertexAttribI1iv _VertexAttribI1iv;
    private PFN_glVertexAttribI2iv _VertexAttribI2iv;
    private PFN_glVertexAttribI3iv _VertexAttribI3iv;
    private PFN_glVertexAttribI4iv _VertexAttribI4iv;
    private PFN_glVertexAttribI1uiv _VertexAttribI1uiv;
    private PFN_glVertexAttribI2uiv _VertexAttribI2uiv;
    private PFN_glVertexAttribI3uiv _VertexAttribI3uiv;
    private PFN_glVertexAttribI4uiv _VertexAttribI4uiv;
    private PFN_glVertexAttribI4bv _VertexAttribI4bv;
    private PFN_glVertexAttribI4sv _VertexAttribI4sv;
    private PFN_glVertexAttribI4ubv _VertexAttribI4ubv;
    private PFN_glVertexAttribI4usv _VertexAttribI4usv;
    private PFN_glGetUniformuiv _GetUniformuiv;
    private PFN_glBindFragDataLocation _BindFragDataLocation;
    private PFN_glGetFragDataLocation _GetFragDataLocation;
    private PFN_glUniform1ui _Uniform1ui;
    private PFN_glUniform2ui _Uniform2ui;
    private PFN_glUniform3ui _Uniform3ui;
    private PFN_glUniform4ui _Uniform4ui;
    private PFN_glUniform1uiv _Uniform1uiv;
    private PFN_glUniform2uiv _Uniform2uiv;
    private PFN_glUniform3uiv _Uniform3uiv;
    private PFN_glUniform4uiv _Uniform4uiv;
    private PFN_glTexParameterIiv _TexParameterIiv;
    private PFN_glTexParameterIuiv _TexParameterIuiv;
    private PFN_glGetTexParameterIiv _GetTexParameterIiv;
    private PFN_glGetTexParameterIuiv _GetTexParameterIuiv;
    private PFN_glClearBufferiv _ClearBufferiv;
    private PFN_glClearBufferuiv _ClearBufferuiv;
    private PFN_glClearBufferfv _ClearBufferfv;
    private PFN_glClearBufferfi _ClearBufferfi;
    private PFN_glGetStringi _GetStringi;
    private PFN_glIsRenderbuffer _IsRenderbuffer;
    private PFN_glBindRenderbuffer _BindRenderbuffer;
    private PFN_glDeleteRenderbuffers _DeleteRenderbuffers;
    private PFN_glGenRenderbuffers _GenRenderbuffers;
    private PFN_glRenderbufferStorage _RenderbufferStorage;
    private PFN_glGetRenderbufferParameteriv _GetRenderbufferParameteriv;
    private PFN_glIsFramebuffer _IsFramebuffer;
    private PFN_glBindFramebuffer _BindFramebuffer;
    private PFN_glDeleteFramebuffers _DeleteFramebuffers;
    private PFN_glGenFramebuffers _GenFramebuffers;
    private PFN_glCheckFramebufferStatus _CheckFramebufferStatus;
    private PFN_glFramebufferTexture1D _FramebufferTexture1D;
    private PFN_glFramebufferTexture2D _FramebufferTexture2D;
    private PFN_glFramebufferTexture3D _FramebufferTexture3D;
    private PFN_glFramebufferRenderbuffer _FramebufferRenderbuffer;
    private PFN_glGetFramebufferAttachmentParameteriv _GetFramebufferAttachmentParameteriv;
    private PFN_glGenerateMipmap _GenerateMipmap;
    private PFN_glBlitFramebuffer _BlitFramebuffer;
    private PFN_glRenderbufferStorageMultisample _RenderbufferStorageMultisample;
    private PFN_glFramebufferTextureLayer _FramebufferTextureLayer;
    private PFN_glMapBufferRange _MapBufferRange;
    private PFN_glFlushMappedBufferRange _FlushMappedBufferRange;
    private PFN_glBindVertexArray _BindVertexArray;
    private PFN_glDeleteVertexArrays _DeleteVertexArrays;
    private PFN_glGenVertexArrays _GenVertexArrays;
    private PFN_glIsVertexArray _IsVertexArray;

    // GL_VERSION_3_1
    private PFN_glDrawArraysInstanced _DrawArraysInstanced;
    private PFN_glDrawElementsInstanced _DrawElementsInstanced;
    private PFN_glTexBuffer _TexBuffer;
    private PFN_glPrimitiveRestartIndex _PrimitiveRestartIndex;
    private PFN_glCopyBufferSubData _CopyBufferSubData;
    private PFN_glGetUniformIndices _GetUniformIndices;
    private PFN_glGetActiveUniformsiv _GetActiveUniformsiv;
    private PFN_glGetActiveUniformName _GetActiveUniformName;
    private PFN_glGetUniformBlockIndex _GetUniformBlockIndex;
    private PFN_glGetActiveUniformBlockiv _GetActiveUniformBlockiv;
    private PFN_glGetActiveUniformBlockName _GetActiveUniformBlockName;
    private PFN_glUniformBlockBinding _UniformBlockBinding;

    // GL_VERSION_3_2
    private PFN_glDrawElementsBaseVertex _DrawElementsBaseVertex;
    private PFN_glDrawRangeElementsBaseVertex _DrawRangeElementsBaseVertex;
    private PFN_glDrawElementsInstancedBaseVertex _DrawElementsInstancedBaseVertex;
    private PFN_glMultiDrawElementsBaseVertex _MultiDrawElementsBaseVertex;
    private PFN_glProvokingVertex _ProvokingVertex;
    private PFN_glFenceSync _FenceSync;
    private PFN_glIsSync _IsSync;
    private PFN_glDeleteSync _DeleteSync;
    private PFN_glClientWaitSync _ClientWaitSync;
    private PFN_glWaitSync _WaitSync;
    private PFN_glGetInteger64v _GetInteger64v;
    private PFN_glGetSynciv _GetSynciv;
    private PFN_glGetInteger64i_v _GetInteger64i_v;
    private PFN_glGetBufferParameteri64v _GetBufferParameteri64v;
    private PFN_glFramebufferTexture _FramebufferTexture;
    private PFN_glTexImage2DMultisample _TexImage2DMultisample;
    private PFN_glTexImage3DMultisample _TexImage3DMultisample;
    private PFN_glGetMultisamplefv _GetMultisamplefv;
    private PFN_glSampleMaski _SampleMaski;

    // GL_VERSION_3_3
    private PFN_glBindFragDataLocationIndexed _BindFragDataLocationIndexed;
    private PFN_glGetFragDataIndex _GetFragDataIndex;
    private PFN_glGenSamplers _GenSamplers;
    private PFN_glDeleteSamplers _DeleteSamplers;
    private PFN_glIsSampler _IsSampler;
    private PFN_glBindSampler _BindSampler;
    private PFN_glSamplerParameteri _SamplerParameteri;
    private PFN_glSamplerParameteriv _SamplerParameteriv;
    private PFN_glSamplerParameterf _SamplerParameterf;
    private PFN_glSamplerParameterfv _SamplerParameterfv;
    private PFN_glSamplerParameterIiv _SamplerParameterIiv;
    private PFN_glSamplerParameterIuiv _SamplerParameterIuiv;
    private PFN_glGetSamplerParameteriv _GetSamplerParameteriv;
    private PFN_glGetSamplerParameterIiv _GetSamplerParameterIiv;
    private PFN_glGetSamplerParameterfv _GetSamplerParameterfv;
    private PFN_glGetSamplerParameterIuiv _GetSamplerParameterIuiv;
    private PFN_glQueryCounter _QueryCounter;
    private PFN_glGetQueryObjecti64v _GetQueryObjecti64v;
    private PFN_glGetQueryObjectui64v _GetQueryObjectui64v;
    private PFN_glVertexAttribDivisor _VertexAttribDivisor;
    private PFN_glVertexAttribP1ui _VertexAttribP1ui;
    private PFN_glVertexAttribP1uiv _VertexAttribP1uiv;
    private PFN_glVertexAttribP2ui _VertexAttribP2ui;
    private PFN_glVertexAttribP2uiv _VertexAttribP2uiv;
    private PFN_glVertexAttribP3ui _VertexAttribP3ui;
    private PFN_glVertexAttribP3uiv _VertexAttribP3uiv;
    private PFN_glVertexAttribP4ui _VertexAttribP4ui;
    private PFN_glVertexAttribP4uiv _VertexAttribP4uiv;

    // GL_VERSION_4_0
    private PFN_glMinSampleShading _MinSampleShading;
    private PFN_glBlendEquationi _BlendEquationi;
    private PFN_glBlendEquationSeparatei _BlendEquationSeparatei;
    private PFN_glBlendFunci _BlendFunci;
    private PFN_glBlendFuncSeparatei _BlendFuncSeparatei;
    private PFN_glDrawArraysIndirect _DrawArraysIndirect;
    private PFN_glDrawElementsIndirect _DrawElementsIndirect;
    private PFN_glUniform1d _Uniform1d;
    private PFN_glUniform2d _Uniform2d;
    private PFN_glUniform3d _Uniform3d;
    private PFN_glUniform4d _Uniform4d;
    private PFN_glUniform1dv _Uniform1dv;
    private PFN_glUniform2dv _Uniform2dv;
    private PFN_glUniform3dv _Uniform3dv;
    private PFN_glUniform4dv _Uniform4dv;
    private PFN_glUniformMatrix2dv _UniformMatrix2dv;
    private PFN_glUniformMatrix3dv _UniformMatrix3dv;
    private PFN_glUniformMatrix4dv _UniformMatrix4dv;
    private PFN_glUniformMatrix2x3dv _UniformMatrix2x3dv;
    private PFN_glUniformMatrix2x4dv _UniformMatrix2x4dv;
    private PFN_glUniformMatrix3x2dv _UniformMatrix3x2dv;
    private PFN_glUniformMatrix3x4dv _UniformMatrix3x4dv;
    private PFN_glUniformMatrix4x2dv _UniformMatrix4x2dv;
    private PFN_glUniformMatrix4x3dv _UniformMatrix4x3dv;
    private PFN_glGetUniformdv _GetUniformdv;
    private PFN_glGetSubroutineUniformLocation _GetSubroutineUniformLocation;
    private PFN_glGetSubroutineIndex _GetSubroutineIndex;
    private PFN_glGetActiveSubroutineUniformiv _GetActiveSubroutineUniformiv;
    private PFN_glGetActiveSubroutineUniformName _GetActiveSubroutineUniformName;
    private PFN_glGetActiveSubroutineName _GetActiveSubroutineName;
    private PFN_glUniformSubroutinesuiv _UniformSubroutinesuiv;
    private PFN_glGetUniformSubroutineuiv _GetUniformSubroutineuiv;
    private PFN_glGetProgramStageiv _GetProgramStageiv;
    private PFN_glPatchParameteri _PatchParameteri;
    private PFN_glPatchParameterfv _PatchParameterfv;
    private PFN_glBindTransformFeedback _BindTransformFeedback;
    private PFN_glDeleteTransformFeedbacks _DeleteTransformFeedbacks;
    private PFN_glGenTransformFeedbacks _GenTransformFeedbacks;
    private PFN_glIsTransformFeedback _IsTransformFeedback;
    private PFN_glPauseTransformFeedback _PauseTransformFeedback;
    private PFN_glResumeTransformFeedback _ResumeTransformFeedback;
    private PFN_glDrawTransformFeedback _DrawTransformFeedback;
    private PFN_glDrawTransformFeedbackStream _DrawTransformFeedbackStream;
    private PFN_glBeginQueryIndexed _BeginQueryIndexed;
    private PFN_glEndQueryIndexed _EndQueryIndexed;
    private PFN_glGetQueryIndexediv _GetQueryIndexediv;

    // GL_VERSION_4_1
    private PFN_glReleaseShaderCompiler _ReleaseShaderCompiler;
    private PFN_glShaderBinary _ShaderBinary;
    private PFN_glGetShaderPrecisionFormat _GetShaderPrecisionFormat;
    private PFN_glDepthRangef _DepthRangef;
    private PFN_glClearDepthf _ClearDepthf;
    private PFN_glGetProgramBinary _GetProgramBinary;
    private PFN_glProgramBinary _ProgramBinary;
    private PFN_glProgramParameteri _ProgramParameteri;
    private PFN_glUseProgramStages _UseProgramStages;
    private PFN_glActiveShaderProgram _ActiveShaderProgram;
    private PFN_glCreateShaderProgramv _CreateShaderProgramv;
    private PFN_glBindProgramPipeline _BindProgramPipeline;
    private PFN_glDeleteProgramPipelines _DeleteProgramPipelines;
    private PFN_glGenProgramPipelines _GenProgramPipelines;
    private PFN_glIsProgramPipeline _IsProgramPipeline;
    private PFN_glGetProgramPipelineiv _GetProgramPipelineiv;
    private PFN_glProgramUniform1i _ProgramUniform1i;
    private PFN_glProgramUniform1iv _ProgramUniform1iv;
    private PFN_glProgramUniform1f _ProgramUniform1f;
    private PFN_glProgramUniform1fv _ProgramUniform1fv;
    private PFN_glProgramUniform1d _ProgramUniform1d;
    private PFN_glProgramUniform1dv _ProgramUniform1dv;
    private PFN_glProgramUniform1ui _ProgramUniform1ui;
    private PFN_glProgramUniform1uiv _ProgramUniform1uiv;
    private PFN_glProgramUniform2i _ProgramUniform2i;
    private PFN_glProgramUniform2iv _ProgramUniform2iv;
    private PFN_glProgramUniform2f _ProgramUniform2f;
    private PFN_glProgramUniform2fv _ProgramUniform2fv;
    private PFN_glProgramUniform2d _ProgramUniform2d;
    private PFN_glProgramUniform2dv _ProgramUniform2dv;
    private PFN_glProgramUniform2ui _ProgramUniform2ui;
    private PFN_glProgramUniform2uiv _ProgramUniform2uiv;
    private PFN_glProgramUniform3i _ProgramUniform3i;
    private PFN_glProgramUniform3iv _ProgramUniform3iv;
    private PFN_glProgramUniform3f _ProgramUniform3f;
    private PFN_glProgramUniform3fv _ProgramUniform3fv;
    private PFN_glProgramUniform3d _ProgramUniform3d;
    private PFN_glProgramUniform3dv _ProgramUniform3dv;
    private PFN_glProgramUniform3ui _ProgramUniform3ui;
    private PFN_glProgramUniform3uiv _ProgramUniform3uiv;
    private PFN_glProgramUniform4i _ProgramUniform4i;
    private PFN_glProgramUniform4iv _ProgramUniform4iv;
    private PFN_glProgramUniform4f _ProgramUniform4f;
    private PFN_glProgramUniform4fv _ProgramUniform4fv;
    private PFN_glProgramUniform4d _ProgramUniform4d;
    private PFN_glProgramUniform4dv _ProgramUniform4dv;
    private PFN_glProgramUniform4ui _ProgramUniform4ui;
    private PFN_glProgramUniform4uiv _ProgramUniform4uiv;
    private PFN_glProgramUniformMatrix2fv _ProgramUniformMatrix2fv;
    private PFN_glProgramUniformMatrix3fv _ProgramUniformMatrix3fv;
    private PFN_glProgramUniformMatrix4fv _ProgramUniformMatrix4fv;
    private PFN_glProgramUniformMatrix2dv _ProgramUniformMatrix2dv;
    private PFN_glProgramUniformMatrix3dv _ProgramUniformMatrix3dv;
    private PFN_glProgramUniformMatrix4dv _ProgramUniformMatrix4dv;
    private PFN_glProgramUniformMatrix2x3fv _ProgramUniformMatrix2x3fv;
    private PFN_glProgramUniformMatrix3x2fv _ProgramUniformMatrix3x2fv;
    private PFN_glProgramUniformMatrix2x4fv _ProgramUniformMatrix2x4fv;
    private PFN_glProgramUniformMatrix4x2fv _ProgramUniformMatrix4x2fv;
    private PFN_glProgramUniformMatrix3x4fv _ProgramUniformMatrix3x4fv;
    private PFN_glProgramUniformMatrix4x3fv _ProgramUniformMatrix4x3fv;
    private PFN_glProgramUniformMatrix2x3dv _ProgramUniformMatrix2x3dv;
    private PFN_glProgramUniformMatrix3x2dv _ProgramUniformMatrix3x2dv;
    private PFN_glProgramUniformMatrix2x4dv _ProgramUniformMatrix2x4dv;
    private PFN_glProgramUniformMatrix4x2dv _ProgramUniformMatrix4x2dv;
    private PFN_glProgramUniformMatrix3x4dv _ProgramUniformMatrix3x4dv;
    private PFN_glProgramUniformMatrix4x3dv _ProgramUniformMatrix4x3dv;
    private PFN_glValidateProgramPipeline _ValidateProgramPipeline;
    private PFN_glGetProgramPipelineInfoLog _GetProgramPipelineInfoLog;
    private PFN_glVertexAttribL1d _VertexAttribL1d;
    private PFN_glVertexAttribL2d _VertexAttribL2d;
    private PFN_glVertexAttribL3d _VertexAttribL3d;
    private PFN_glVertexAttribL4d _VertexAttribL4d;
    private PFN_glVertexAttribL1dv _VertexAttribL1dv;
    private PFN_glVertexAttribL2dv _VertexAttribL2dv;
    private PFN_glVertexAttribL3dv _VertexAttribL3dv;
    private PFN_glVertexAttribL4dv _VertexAttribL4dv;
    private PFN_glVertexAttribLPointer _VertexAttribLPointer;
    private PFN_glGetVertexAttribLdv _GetVertexAttribLdv;
    private PFN_glViewportArrayv _ViewportArrayv;
    private PFN_glViewportIndexedf _ViewportIndexedf;
    private PFN_glViewportIndexedfv _ViewportIndexedfv;
    private PFN_glScissorArrayv _ScissorArrayv;
    private PFN_glScissorIndexed _ScissorIndexed;
    private PFN_glScissorIndexedv _ScissorIndexedv;
    private PFN_glDepthRangeArrayv _DepthRangeArrayv;
    private PFN_glDepthRangeIndexed _DepthRangeIndexed;
    private PFN_glGetFloati_v _GetFloati_v;
    private PFN_glGetDoublei_v _GetDoublei_v;

    // GL_VERSION_4_2
    private PFN_glDrawArraysInstancedBaseInstance _DrawArraysInstancedBaseInstance;
    private PFN_glDrawElementsInstancedBaseInstance _DrawElementsInstancedBaseInstance;
    private PFN_glDrawElementsInstancedBaseVertexBaseInstance _DrawElementsInstancedBaseVertexBaseInstance;
    private PFN_glGetInternalformativ _GetInternalformativ;
    private PFN_glGetActiveAtomicCounterBufferiv _GetActiveAtomicCounterBufferiv;
    private PFN_glBindImageTexture _BindImageTexture;
    private PFN_glMemoryBarrier _MemoryBarrier;
    private PFN_glTexStorage1D _TexStorage1D;
    private PFN_glTexStorage2D _TexStorage2D;
    private PFN_glTexStorage3D _TexStorage3D;
    private PFN_glDrawTransformFeedbackInstanced _DrawTransformFeedbackInstanced;
    private PFN_glDrawTransformFeedbackStreamInstanced _DrawTransformFeedbackStreamInstanced;

    // GL_VERSION_4_3
    private PFN_glClearBufferData _ClearBufferData;
    private PFN_glClearBufferSubData _ClearBufferSubData;
    private PFN_glDispatchCompute _DispatchCompute;
    private PFN_glDispatchComputeIndirect _DispatchComputeIndirect;
    private PFN_glCopyImageSubData _CopyImageSubData;
    private PFN_glFramebufferParameteri _FramebufferParameteri;
    private PFN_glGetFramebufferParameteriv _GetFramebufferParameteriv;
    private PFN_glGetInternalformati64v _GetInternalformati64v;
    private PFN_glInvalidateTexSubImage _InvalidateTexSubImage;
    private PFN_glInvalidateTexImage _InvalidateTexImage;
    private PFN_glInvalidateBufferSubData _InvalidateBufferSubData;
    private PFN_glInvalidateBufferData _InvalidateBufferData;
    private PFN_glInvalidateFramebuffer _InvalidateFramebuffer;
    private PFN_glInvalidateSubFramebuffer _InvalidateSubFramebuffer;
    private PFN_glMultiDrawArraysIndirect _MultiDrawArraysIndirect;
    private PFN_glMultiDrawElementsIndirect _MultiDrawElementsIndirect;
    private PFN_glGetProgramInterfaceiv _GetProgramInterfaceiv;
    private PFN_glGetProgramResourceIndex _GetProgramResourceIndex;
    private PFN_glGetProgramResourceName _GetProgramResourceName;
    private PFN_glGetProgramResourceiv _GetProgramResourceiv;
    private PFN_glGetProgramResourceLocation _GetProgramResourceLocation;
    private PFN_glGetProgramResourceLocationIndex _GetProgramResourceLocationIndex;
    private PFN_glShaderStorageBlockBinding _ShaderStorageBlockBinding;
    private PFN_glTexBufferRange _TexBufferRange;
    private PFN_glTexStorage2DMultisample _TexStorage2DMultisample;
    private PFN_glTexStorage3DMultisample _TexStorage3DMultisample;
    private PFN_glTextureView _TextureView;
    private PFN_glBindVertexBuffer _BindVertexBuffer;
    private PFN_glVertexAttribFormat _VertexAttribFormat;
    private PFN_glVertexAttribIFormat _VertexAttribIFormat;
    private PFN_glVertexAttribLFormat _VertexAttribLFormat;
    private PFN_glVertexAttribBinding _VertexAttribBinding;
    private PFN_glVertexBindingDivisor _VertexBindingDivisor;
    private PFN_glDebugMessageControl _DebugMessageControl;
    private PFN_glDebugMessageInsert _DebugMessageInsert;
    private PFN_glDebugMessageCallback _DebugMessageCallback;
    private PFN_glGetDebugMessageLog _GetDebugMessageLog;
    private PFN_glPushDebugGroup _PushDebugGroup;
    private PFN_glPopDebugGroup _PopDebugGroup;
    private PFN_glObjectLabel _ObjectLabel;
    private PFN_glGetObjectLabel _GetObjectLabel;
    private PFN_glObjectPtrLabel _ObjectPtrLabel;
    private PFN_glGetObjectPtrLabel _GetObjectPtrLabel;

    // GL_VERSION_4_4
    private PFN_glBufferStorage _BufferStorage;
    private PFN_glClearTexImage _ClearTexImage;
    private PFN_glClearTexSubImage _ClearTexSubImage;
    private PFN_glBindBuffersBase _BindBuffersBase;
    private PFN_glBindBuffersRange _BindBuffersRange;
    private PFN_glBindTextures _BindTextures;
    private PFN_glBindSamplers _BindSamplers;
    private PFN_glBindImageTextures _BindImageTextures;
    private PFN_glBindVertexBuffers _BindVertexBuffers;

    // GL_VERSION_4_5
    private PFN_glClipControl _ClipControl;
    private PFN_glCreateTransformFeedbacks _CreateTransformFeedbacks;
    private PFN_glTransformFeedbackBufferBase _TransformFeedbackBufferBase;
    private PFN_glTransformFeedbackBufferRange _TransformFeedbackBufferRange;
    private PFN_glGetTransformFeedbackiv _GetTransformFeedbackiv;
    private PFN_glGetTransformFeedbacki_v _GetTransformFeedbacki_v;
    private PFN_glGetTransformFeedbacki64_v _GetTransformFeedbacki64_v;
    private PFN_glCreateBuffers _CreateBuffers;
    private PFN_glNamedBufferStorage _NamedBufferStorage;
    private PFN_glNamedBufferData _NamedBufferData;
    private PFN_glNamedBufferSubData _NamedBufferSubData;
    private PFN_glCopyNamedBufferSubData _CopyNamedBufferSubData;
    private PFN_glClearNamedBufferData _ClearNamedBufferData;
    private PFN_glClearNamedBufferSubData _ClearNamedBufferSubData;
    private PFN_glMapNamedBuffer _MapNamedBuffer;
    private PFN_glMapNamedBufferRange _MapNamedBufferRange;
    private PFN_glUnmapNamedBuffer _UnmapNamedBuffer;
    private PFN_glFlushMappedNamedBufferRange _FlushMappedNamedBufferRange;
    private PFN_glGetNamedBufferParameteriv _GetNamedBufferParameteriv;
    private PFN_glGetNamedBufferParameteri64v _GetNamedBufferParameteri64v;
    private PFN_glGetNamedBufferPointerv _GetNamedBufferPointerv;
    private PFN_glGetNamedBufferSubData _GetNamedBufferSubData;
    private PFN_glCreateFramebuffers _CreateFramebuffers;
    private PFN_glNamedFramebufferRenderbuffer _NamedFramebufferRenderbuffer;
    private PFN_glNamedFramebufferParameteri _NamedFramebufferParameteri;
    private PFN_glNamedFramebufferTexture _NamedFramebufferTexture;
    private PFN_glNamedFramebufferTextureLayer _NamedFramebufferTextureLayer;
    private PFN_glNamedFramebufferDrawBuffer _NamedFramebufferDrawBuffer;
    private PFN_glNamedFramebufferDrawBuffers _NamedFramebufferDrawBuffers;
    private PFN_glNamedFramebufferReadBuffer _NamedFramebufferReadBuffer;
    private PFN_glInvalidateNamedFramebufferData _InvalidateNamedFramebufferData;
    private PFN_glInvalidateNamedFramebufferSubData _InvalidateNamedFramebufferSubData;
    private PFN_glClearNamedFramebufferiv _ClearNamedFramebufferiv;
    private PFN_glClearNamedFramebufferuiv _ClearNamedFramebufferuiv;
    private PFN_glClearNamedFramebufferfv _ClearNamedFramebufferfv;
    private PFN_glClearNamedFramebufferfi _ClearNamedFramebufferfi;
    private PFN_glBlitNamedFramebuffer _BlitNamedFramebuffer;
    private PFN_glCheckNamedFramebufferStatus _CheckNamedFramebufferStatus;
    private PFN_glGetNamedFramebufferParameteriv _GetNamedFramebufferParameteriv;
    private PFN_glGetNamedFramebufferAttachmentParameteriv _GetNamedFramebufferAttachmentParameteriv;
    private PFN_glCreateRenderbuffers _CreateRenderbuffers;
    private PFN_glNamedRenderbufferStorage _NamedRenderbufferStorage;
    private PFN_glNamedRenderbufferStorageMultisample _NamedRenderbufferStorageMultisample;
    private PFN_glGetNamedRenderbufferParameteriv _GetNamedRenderbufferParameteriv;
    private PFN_glCreateTextures _CreateTextures;
    private PFN_glTextureBuffer _TextureBuffer;
    private PFN_glTextureBufferRange _TextureBufferRange;
    private PFN_glTextureStorage1D _TextureStorage1D;
    private PFN_glTextureStorage2D _TextureStorage2D;
    private PFN_glTextureStorage3D _TextureStorage3D;
    private PFN_glTextureStorage2DMultisample _TextureStorage2DMultisample;
    private PFN_glTextureStorage3DMultisample _TextureStorage3DMultisample;
    private PFN_glTextureSubImage1D _TextureSubImage1D;
    private PFN_glTextureSubImage2D _TextureSubImage2D;
    private PFN_glTextureSubImage3D _TextureSubImage3D;
    private PFN_glCompressedTextureSubImage1D _CompressedTextureSubImage1D;
    private PFN_glCompressedTextureSubImage2D _CompressedTextureSubImage2D;
    private PFN_glCompressedTextureSubImage3D _CompressedTextureSubImage3D;
    private PFN_glCopyTextureSubImage1D _CopyTextureSubImage1D;
    private PFN_glCopyTextureSubImage2D _CopyTextureSubImage2D;
    private PFN_glCopyTextureSubImage3D _CopyTextureSubImage3D;
    private PFN_glTextureParameterf _TextureParameterf;
    private PFN_glTextureParameterfv _TextureParameterfv;
    private PFN_glTextureParameteri _TextureParameteri;
    private PFN_glTextureParameterIiv _TextureParameterIiv;
    private PFN_glTextureParameterIuiv _TextureParameterIuiv;
    private PFN_glTextureParameteriv _TextureParameteriv;
    private PFN_glGenerateTextureMipmap _GenerateTextureMipmap;
    private PFN_glBindTextureUnit _BindTextureUnit;
    private PFN_glGetTextureImage _GetTextureImage;
    private PFN_glGetCompressedTextureImage _GetCompressedTextureImage;
    private PFN_glGetTextureLevelParameterfv _GetTextureLevelParameterfv;
    private PFN_glGetTextureLevelParameteriv _GetTextureLevelParameteriv;
    private PFN_glGetTextureParameterfv _GetTextureParameterfv;
    private PFN_glGetTextureParameterIiv _GetTextureParameterIiv;
    private PFN_glGetTextureParameterIuiv _GetTextureParameterIuiv;
    private PFN_glGetTextureParameteriv _GetTextureParameteriv;
    private PFN_glCreateVertexArrays _CreateVertexArrays;
    private PFN_glDisableVertexArrayAttrib _DisableVertexArrayAttrib;
    private PFN_glEnableVertexArrayAttrib _EnableVertexArrayAttrib;
    private PFN_glVertexArrayElementBuffer _VertexArrayElementBuffer;
    private PFN_glVertexArrayVertexBuffer _VertexArrayVertexBuffer;
    private PFN_glVertexArrayVertexBuffers _VertexArrayVertexBuffers;
    private PFN_glVertexArrayAttribBinding _VertexArrayAttribBinding;
    private PFN_glVertexArrayAttribFormat _VertexArrayAttribFormat;
    private PFN_glVertexArrayAttribIFormat _VertexArrayAttribIFormat;
    private PFN_glVertexArrayAttribLFormat _VertexArrayAttribLFormat;
    private PFN_glVertexArrayBindingDivisor _VertexArrayBindingDivisor;
    private PFN_glGetVertexArrayiv _GetVertexArrayiv;
    private PFN_glGetVertexArrayIndexediv _GetVertexArrayIndexediv;
    private PFN_glGetVertexArrayIndexed64iv _GetVertexArrayIndexed64iv;
    private PFN_glCreateSamplers _CreateSamplers;
    private PFN_glCreateProgramPipelines _CreateProgramPipelines;
    private PFN_glCreateQueries _CreateQueries;
    private PFN_glGetQueryBufferObjecti64v _GetQueryBufferObjecti64v;
    private PFN_glGetQueryBufferObjectiv _GetQueryBufferObjectiv;
    private PFN_glGetQueryBufferObjectui64v _GetQueryBufferObjectui64v;
    private PFN_glGetQueryBufferObjectuiv _GetQueryBufferObjectuiv;
    private PFN_glMemoryBarrierByRegion _MemoryBarrierByRegion;
    private PFN_glGetTextureSubImage _GetTextureSubImage;
    private PFN_glGetCompressedTextureSubImage _GetCompressedTextureSubImage;
    private PFN_glGetGraphicsResetStatus _GetGraphicsResetStatus;
    private PFN_glGetnCompressedTexImage _GetnCompressedTexImage;
    private PFN_glGetnTexImage _GetnTexImage;
    private PFN_glGetnUniformdv _GetnUniformdv;
    private PFN_glGetnUniformfv _GetnUniformfv;
    private PFN_glGetnUniformiv _GetnUniformiv;
    private PFN_glGetnUniformuiv _GetnUniformuiv;
    private PFN_glReadnPixels _ReadnPixels;
    private PFN_glTextureBarrier _TextureBarrier;

    // GL_VERSION_4_6
    private PFN_glSpecializeShader _SpecializeShader;
    private PFN_glMultiDrawArraysIndirectCount _MultiDrawArraysIndirectCount;
    private PFN_glMultiDrawElementsIndirectCount _MultiDrawElementsIndirectCount;
    private PFN_glPolygonOffsetClamp _PolygonOffsetClamp;

    // GL_ARB_ES3_2_compatibility,
    private PFN_glPrimitiveBoundingBoxARB _PrimitiveBoundingBoxARB;

    // GL_ARB_bindless_texture,
    private PFN_glGetTextureHandleARB _GetTextureHandleARB;
    private PFN_glGetTextureSamplerHandleARB _GetTextureSamplerHandleARB;
    private PFN_glMakeTextureHandleResidentARB _MakeTextureHandleResidentARB;
    private PFN_glMakeTextureHandleNonResidentARB _MakeTextureHandleNonResidentARB;
    private PFN_glGetImageHandleARB _GetImageHandleARB;
    private PFN_glMakeImageHandleResidentARB _MakeImageHandleResidentARB;
    private PFN_glMakeImageHandleNonResidentARB _MakeImageHandleNonResidentARB;
    private PFN_glUniformHandleui64ARB _UniformHandleui64ARB;
    private PFN_glUniformHandleui64vARB _UniformHandleui64vARB;
    private PFN_glProgramUniformHandleui64ARB _ProgramUniformHandleui64ARB;
    private PFN_glProgramUniformHandleui64vARB _ProgramUniformHandleui64vARB;
    private PFN_glIsTextureHandleResidentARB _IsTextureHandleResidentARB;
    private PFN_glIsImageHandleResidentARB _IsImageHandleResidentARB;
    private PFN_glVertexAttribL1ui64ARB _VertexAttribL1ui64ARB;
    private PFN_glVertexAttribL1ui64vARB _VertexAttribL1ui64vARB;
    private PFN_glGetVertexAttribLui64vARB _GetVertexAttribLui64vARB;

    // GL_ARB_cl_event,
    private PFN_glCreateSyncFromCLeventARB _CreateSyncFromCLeventARB;

    // GL_ARB_compute_variable_group_size,
    private PFN_glDispatchComputeGroupSizeARB _DispatchComputeGroupSizeARB;

    // GL_ARB_geometry_shader4,
    private PFN_glFramebufferTextureFaceARB _FramebufferTextureFaceARB;

    // GL_ARB_gpu_shader_int64,
    private PFN_glUniform1i64ARB _Uniform1i64ARB;
    private PFN_glUniform2i64ARB _Uniform2i64ARB;
    private PFN_glUniform3i64ARB _Uniform3i64ARB;
    private PFN_glUniform4i64ARB _Uniform4i64ARB;
    private PFN_glUniform1i64vARB _Uniform1i64vARB;
    private PFN_glUniform2i64vARB _Uniform2i64vARB;
    private PFN_glUniform3i64vARB _Uniform3i64vARB;
    private PFN_glUniform4i64vARB _Uniform4i64vARB;
    private PFN_glUniform1ui64ARB _Uniform1ui64ARB;
    private PFN_glUniform2ui64ARB _Uniform2ui64ARB;
    private PFN_glUniform3ui64ARB _Uniform3ui64ARB;
    private PFN_glUniform4ui64ARB _Uniform4ui64ARB;
    private PFN_glUniform1ui64vARB _Uniform1ui64vARB;
    private PFN_glUniform2ui64vARB _Uniform2ui64vARB;
    private PFN_glUniform3ui64vARB _Uniform3ui64vARB;
    private PFN_glUniform4ui64vARB _Uniform4ui64vARB;
    private PFN_glGetUniformi64vARB _GetUniformi64vARB;
    private PFN_glGetUniformui64vARB _GetUniformui64vARB;
    private PFN_glGetnUniformi64vARB _GetnUniformi64vARB;
    private PFN_glGetnUniformui64vARB _GetnUniformui64vARB;
    private PFN_glProgramUniform1i64ARB _ProgramUniform1i64ARB;
    private PFN_glProgramUniform2i64ARB _ProgramUniform2i64ARB;
    private PFN_glProgramUniform3i64ARB _ProgramUniform3i64ARB;
    private PFN_glProgramUniform4i64ARB _ProgramUniform4i64ARB;
    private PFN_glProgramUniform1i64vARB _ProgramUniform1i64vARB;
    private PFN_glProgramUniform2i64vARB _ProgramUniform2i64vARB;
    private PFN_glProgramUniform3i64vARB _ProgramUniform3i64vARB;
    private PFN_glProgramUniform4i64vARB _ProgramUniform4i64vARB;
    private PFN_glProgramUniform1ui64ARB _ProgramUniform1ui64ARB;
    private PFN_glProgramUniform2ui64ARB _ProgramUniform2ui64ARB;
    private PFN_glProgramUniform3ui64ARB _ProgramUniform3ui64ARB;
    private PFN_glProgramUniform4ui64ARB _ProgramUniform4ui64ARB;
    private PFN_glProgramUniform1ui64vARB _ProgramUniform1ui64vARB;
    private PFN_glProgramUniform2ui64vARB _ProgramUniform2ui64vARB;
    private PFN_glProgramUniform3ui64vARB _ProgramUniform3ui64vARB;
    private PFN_glProgramUniform4ui64vARB _ProgramUniform4ui64vARB;

    // GL_ARB_parallel_shader_compile,
    private PFN_glMaxShaderCompilerThreadsARB _MaxShaderCompilerThreadsARB;

    // GL_ARB_robustness,
    private PFN_glGetGraphicsResetStatusARB _GetGraphicsResetStatusARB;
    private PFN_glGetnTexImageARB _GetnTexImageARB;
    private PFN_glGetnCompressedTexImageARB _GetnCompressedTexImageARB;
    private PFN_glGetnUniformfvARB _GetnUniformfvARB;
    private PFN_glGetnUniformivARB _GetnUniformivARB;
    private PFN_glGetnUniformuivARB _GetnUniformuivARB;
    private PFN_glGetnUniformdvARB _GetnUniformdvARB;

    // GL_ARB_sample_locations,
    private PFN_glFramebufferSampleLocationsfvARB _FramebufferSampleLocationsfvARB;
    private PFN_glNamedFramebufferSampleLocationsfvARB _NamedFramebufferSampleLocationsfvARB;
    private PFN_glEvaluateDepthValuesARB _EvaluateDepthValuesARB;

    // GL_ARB_shading_language_include,
    private PFN_glNamedStringARB _NamedStringARB;
    private PFN_glDeleteNamedStringARB _DeleteNamedStringARB;
    private PFN_glCompileShaderIncludeARB _CompileShaderIncludeARB;
    private PFN_glIsNamedStringARB _IsNamedStringARB;
    private PFN_glGetNamedStringARB _GetNamedStringARB;
    private PFN_glGetNamedStringivARB _GetNamedStringivARB;

    // GL_ARB_sparse_buffer,
    private PFN_glBufferPageCommitmentARB _BufferPageCommitmentARB;
    private PFN_glNamedBufferPageCommitmentEXT _NamedBufferPageCommitmentEXT;
    private PFN_glNamedBufferPageCommitmentARB _NamedBufferPageCommitmentARB;

    // GL_ARB_sparse_texture,
    private PFN_glTexPageCommitmentARB _TexPageCommitmentARB;

    // GL_KHR_blend_equation_advanced,
    private PFN_glBlendBarrierKHR _BlendBarrierKHR;

    // GL_KHR_parallel_shader_compile,
    private PFN_glMaxShaderCompilerThreadsKHR _MaxShaderCompilerThreadsKHR;

    // GL_AMD_performance_monitor,
    private PFN_glGetPerfMonitorGroupsAMD _GetPerfMonitorGroupsAMD;
    private PFN_glGetPerfMonitorCountersAMD _GetPerfMonitorCountersAMD;
    private PFN_glGetPerfMonitorGroupStringAMD _GetPerfMonitorGroupStringAMD;
    private PFN_glGetPerfMonitorCounterStringAMD _GetPerfMonitorCounterStringAMD;
    private PFN_glGetPerfMonitorCounterInfoAMD _GetPerfMonitorCounterInfoAMD;
    private PFN_glGenPerfMonitorsAMD _GenPerfMonitorsAMD;
    private PFN_glDeletePerfMonitorsAMD _DeletePerfMonitorsAMD;
    private PFN_glSelectPerfMonitorCountersAMD _SelectPerfMonitorCountersAMD;
    private PFN_glBeginPerfMonitorAMD _BeginPerfMonitorAMD;
    private PFN_glEndPerfMonitorAMD _EndPerfMonitorAMD;
    private PFN_glGetPerfMonitorCounterDataAMD _GetPerfMonitorCounterDataAMD;

    // GL_EXT_debug_label,
    private PFN_glLabelObjectEXT _LabelObjectEXT;
    private PFN_glGetObjectLabelEXT _GetObjectLabelEXT;

    // GL_EXT_debug_marker,
    private PFN_glInsertEventMarkerEXT _InsertEventMarkerEXT;
    private PFN_glPushGroupMarkerEXT _PushGroupMarkerEXT;
    private PFN_glPopGroupMarkerEXT _PopGroupMarkerEXT;

    // GL_EXT_direct_state_access,
    private PFN_glMatrixLoadfEXT _MatrixLoadfEXT;
    private PFN_glMatrixLoaddEXT _MatrixLoaddEXT;
    private PFN_glMatrixMultfEXT _MatrixMultfEXT;
    private PFN_glMatrixMultdEXT _MatrixMultdEXT;
    private PFN_glMatrixLoadIdentityEXT _MatrixLoadIdentityEXT;
    private PFN_glMatrixRotatefEXT _MatrixRotatefEXT;
    private PFN_glMatrixRotatedEXT _MatrixRotatedEXT;
    private PFN_glMatrixScalefEXT _MatrixScalefEXT;
    private PFN_glMatrixScaledEXT _MatrixScaledEXT;
    private PFN_glMatrixTranslatefEXT _MatrixTranslatefEXT;
    private PFN_glMatrixTranslatedEXT _MatrixTranslatedEXT;
    private PFN_glMatrixFrustumEXT _MatrixFrustumEXT;
    private PFN_glMatrixOrthoEXT _MatrixOrthoEXT;
    private PFN_glMatrixPopEXT _MatrixPopEXT;
    private PFN_glMatrixPushEXT _MatrixPushEXT;
    private PFN_glClientAttribDefaultEXT _ClientAttribDefaultEXT;
    private PFN_glPushClientAttribDefaultEXT _PushClientAttribDefaultEXT;
    private PFN_glTextureParameterfEXT _TextureParameterfEXT;
    private PFN_glTextureParameterfvEXT _TextureParameterfvEXT;
    private PFN_glTextureParameteriEXT _TextureParameteriEXT;
    private PFN_glTextureParameterivEXT _TextureParameterivEXT;
    private PFN_glTextureImage1DEXT _TextureImage1DEXT;
    private PFN_glTextureImage2DEXT _TextureImage2DEXT;
    private PFN_glTextureSubImage1DEXT _TextureSubImage1DEXT;
    private PFN_glTextureSubImage2DEXT _TextureSubImage2DEXT;
    private PFN_glCopyTextureImage1DEXT _CopyTextureImage1DEXT;
    private PFN_glCopyTextureImage2DEXT _CopyTextureImage2DEXT;
    private PFN_glCopyTextureSubImage1DEXT _CopyTextureSubImage1DEXT;
    private PFN_glCopyTextureSubImage2DEXT _CopyTextureSubImage2DEXT;
    private PFN_glGetTextureImageEXT _GetTextureImageEXT;
    private PFN_glGetTextureParameterfvEXT _GetTextureParameterfvEXT;
    private PFN_glGetTextureParameterivEXT _GetTextureParameterivEXT;
    private PFN_glGetTextureLevelParameterfvEXT _GetTextureLevelParameterfvEXT;
    private PFN_glGetTextureLevelParameterivEXT _GetTextureLevelParameterivEXT;
    private PFN_glTextureImage3DEXT _TextureImage3DEXT;
    private PFN_glTextureSubImage3DEXT _TextureSubImage3DEXT;
    private PFN_glCopyTextureSubImage3DEXT _CopyTextureSubImage3DEXT;
    private PFN_glBindMultiTextureEXT _BindMultiTextureEXT;
    private PFN_glMultiTexCoordPointerEXT _MultiTexCoordPointerEXT;
    private PFN_glMultiTexEnvfEXT _MultiTexEnvfEXT;
    private PFN_glMultiTexEnvfvEXT _MultiTexEnvfvEXT;
    private PFN_glMultiTexEnviEXT _MultiTexEnviEXT;
    private PFN_glMultiTexEnvivEXT _MultiTexEnvivEXT;
    private PFN_glMultiTexGendEXT _MultiTexGendEXT;
    private PFN_glMultiTexGendvEXT _MultiTexGendvEXT;
    private PFN_glMultiTexGenfEXT _MultiTexGenfEXT;
    private PFN_glMultiTexGenfvEXT _MultiTexGenfvEXT;
    private PFN_glMultiTexGeniEXT _MultiTexGeniEXT;
    private PFN_glMultiTexGenivEXT _MultiTexGenivEXT;
    private PFN_glGetMultiTexEnvfvEXT _GetMultiTexEnvfvEXT;
    private PFN_glGetMultiTexEnvivEXT _GetMultiTexEnvivEXT;
    private PFN_glGetMultiTexGendvEXT _GetMultiTexGendvEXT;
    private PFN_glGetMultiTexGenfvEXT _GetMultiTexGenfvEXT;
    private PFN_glGetMultiTexGenivEXT _GetMultiTexGenivEXT;
    private PFN_glMultiTexParameteriEXT _MultiTexParameteriEXT;
    private PFN_glMultiTexParameterivEXT _MultiTexParameterivEXT;
    private PFN_glMultiTexParameterfEXT _MultiTexParameterfEXT;
    private PFN_glMultiTexParameterfvEXT _MultiTexParameterfvEXT;
    private PFN_glMultiTexImage1DEXT _MultiTexImage1DEXT;
    private PFN_glMultiTexImage2DEXT _MultiTexImage2DEXT;
    private PFN_glMultiTexSubImage1DEXT _MultiTexSubImage1DEXT;
    private PFN_glMultiTexSubImage2DEXT _MultiTexSubImage2DEXT;
    private PFN_glCopyMultiTexImage1DEXT _CopyMultiTexImage1DEXT;
    private PFN_glCopyMultiTexImage2DEXT _CopyMultiTexImage2DEXT;
    private PFN_glCopyMultiTexSubImage1DEXT _CopyMultiTexSubImage1DEXT;
    private PFN_glCopyMultiTexSubImage2DEXT _CopyMultiTexSubImage2DEXT;
    private PFN_glGetMultiTexImageEXT _GetMultiTexImageEXT;
    private PFN_glGetMultiTexParameterfvEXT _GetMultiTexParameterfvEXT;
    private PFN_glGetMultiTexParameterivEXT _GetMultiTexParameterivEXT;
    private PFN_glGetMultiTexLevelParameterfvEXT _GetMultiTexLevelParameterfvEXT;
    private PFN_glGetMultiTexLevelParameterivEXT _GetMultiTexLevelParameterivEXT;
    private PFN_glMultiTexImage3DEXT _MultiTexImage3DEXT;
    private PFN_glMultiTexSubImage3DEXT _MultiTexSubImage3DEXT;
    private PFN_glCopyMultiTexSubImage3DEXT _CopyMultiTexSubImage3DEXT;
    private PFN_glEnableClientStateIndexedEXT _EnableClientStateIndexedEXT;
    private PFN_glDisableClientStateIndexedEXT _DisableClientStateIndexedEXT;
    private PFN_glGetPointerIndexedvEXT _GetPointerIndexedvEXT;
    private PFN_glCompressedTextureImage3DEXT _CompressedTextureImage3DEXT;
    private PFN_glCompressedTextureImage2DEXT _CompressedTextureImage2DEXT;
    private PFN_glCompressedTextureImage1DEXT _CompressedTextureImage1DEXT;
    private PFN_glCompressedTextureSubImage3DEXT _CompressedTextureSubImage3DEXT;
    private PFN_glCompressedTextureSubImage2DEXT _CompressedTextureSubImage2DEXT;
    private PFN_glCompressedTextureSubImage1DEXT _CompressedTextureSubImage1DEXT;
    private PFN_glGetCompressedTextureImageEXT _GetCompressedTextureImageEXT;
    private PFN_glCompressedMultiTexImage3DEXT _CompressedMultiTexImage3DEXT;
    private PFN_glCompressedMultiTexImage2DEXT _CompressedMultiTexImage2DEXT;
    private PFN_glCompressedMultiTexImage1DEXT _CompressedMultiTexImage1DEXT;
    private PFN_glCompressedMultiTexSubImage3DEXT _CompressedMultiTexSubImage3DEXT;
    private PFN_glCompressedMultiTexSubImage2DEXT _CompressedMultiTexSubImage2DEXT;
    private PFN_glCompressedMultiTexSubImage1DEXT _CompressedMultiTexSubImage1DEXT;
    private PFN_glGetCompressedMultiTexImageEXT _GetCompressedMultiTexImageEXT;
    private PFN_glMatrixLoadTransposefEXT _MatrixLoadTransposefEXT;
    private PFN_glMatrixLoadTransposedEXT _MatrixLoadTransposedEXT;
    private PFN_glMatrixMultTransposefEXT _MatrixMultTransposefEXT;
    private PFN_glMatrixMultTransposedEXT _MatrixMultTransposedEXT;
    private PFN_glNamedBufferDataEXT _NamedBufferDataEXT;
    private PFN_glMapNamedBufferEXT _MapNamedBufferEXT;
    private PFN_glUnmapNamedBufferEXT _UnmapNamedBufferEXT;
    private PFN_glGetNamedBufferParameterivEXT _GetNamedBufferParameterivEXT;
    private PFN_glGetNamedBufferPointervEXT _GetNamedBufferPointervEXT;
    private PFN_glGetNamedBufferSubDataEXT _GetNamedBufferSubDataEXT;
    private PFN_glTextureBufferEXT _TextureBufferEXT;
    private PFN_glMultiTexBufferEXT _MultiTexBufferEXT;
    private PFN_glTextureParameterIivEXT _TextureParameterIivEXT;
    private PFN_glTextureParameterIuivEXT _TextureParameterIuivEXT;
    private PFN_glGetTextureParameterIivEXT _GetTextureParameterIivEXT;
    private PFN_glGetTextureParameterIuivEXT _GetTextureParameterIuivEXT;
    private PFN_glMultiTexParameterIivEXT _MultiTexParameterIivEXT;
    private PFN_glMultiTexParameterIuivEXT _MultiTexParameterIuivEXT;
    private PFN_glGetMultiTexParameterIivEXT _GetMultiTexParameterIivEXT;
    private PFN_glGetMultiTexParameterIuivEXT _GetMultiTexParameterIuivEXT;
    private PFN_glNamedProgramLocalParameters4fvEXT _NamedProgramLocalParameters4fvEXT;
    private PFN_glNamedProgramLocalParameterI4iEXT _NamedProgramLocalParameterI4iEXT;
    private PFN_glNamedProgramLocalParameterI4ivEXT _NamedProgramLocalParameterI4ivEXT;
    private PFN_glNamedProgramLocalParametersI4ivEXT _NamedProgramLocalParametersI4ivEXT;
    private PFN_glNamedProgramLocalParameterI4uiEXT _NamedProgramLocalParameterI4uiEXT;
    private PFN_glNamedProgramLocalParameterI4uivEXT _NamedProgramLocalParameterI4uivEXT;
    private PFN_glNamedProgramLocalParametersI4uivEXT _NamedProgramLocalParametersI4uivEXT;
    private PFN_glGetNamedProgramLocalParameterIivEXT _GetNamedProgramLocalParameterIivEXT;
    private PFN_glGetNamedProgramLocalParameterIuivEXT _GetNamedProgramLocalParameterIuivEXT;
    private PFN_glEnableClientStateiEXT _EnableClientStateiEXT;
    private PFN_glDisableClientStateiEXT _DisableClientStateiEXT;
    private PFN_glGetPointeri_vEXT _GetPointeri_vEXT;
    private PFN_glNamedProgramStringEXT _NamedProgramStringEXT;
    private PFN_glNamedProgramLocalParameter4dEXT _NamedProgramLocalParameter4dEXT;
    private PFN_glNamedProgramLocalParameter4dvEXT _NamedProgramLocalParameter4dvEXT;
    private PFN_glNamedProgramLocalParameter4fEXT _NamedProgramLocalParameter4fEXT;
    private PFN_glNamedProgramLocalParameter4fvEXT _NamedProgramLocalParameter4fvEXT;
    private PFN_glGetNamedProgramLocalParameterdvEXT _GetNamedProgramLocalParameterdvEXT;
    private PFN_glGetNamedProgramLocalParameterfvEXT _GetNamedProgramLocalParameterfvEXT;
    private PFN_glGetNamedProgramivEXT _GetNamedProgramivEXT;
    private PFN_glGetNamedProgramStringEXT _GetNamedProgramStringEXT;
    private PFN_glNamedRenderbufferStorageEXT _NamedRenderbufferStorageEXT;
    private PFN_glGetNamedRenderbufferParameterivEXT _GetNamedRenderbufferParameterivEXT;
    private PFN_glNamedRenderbufferStorageMultisampleEXT _NamedRenderbufferStorageMultisampleEXT;
    private PFN_glNamedRenderbufferStorageMultisampleCoverageEXT _NamedRenderbufferStorageMultisampleCoverageEXT;
    private PFN_glCheckNamedFramebufferStatusEXT _CheckNamedFramebufferStatusEXT;
    private PFN_glNamedFramebufferTexture1DEXT _NamedFramebufferTexture1DEXT;
    private PFN_glNamedFramebufferTexture2DEXT _NamedFramebufferTexture2DEXT;
    private PFN_glNamedFramebufferTexture3DEXT _NamedFramebufferTexture3DEXT;
    private PFN_glNamedFramebufferRenderbufferEXT _NamedFramebufferRenderbufferEXT;
    private PFN_glGetNamedFramebufferAttachmentParameterivEXT _GetNamedFramebufferAttachmentParameterivEXT;
    private PFN_glGenerateTextureMipmapEXT _GenerateTextureMipmapEXT;
    private PFN_glGenerateMultiTexMipmapEXT _GenerateMultiTexMipmapEXT;
    private PFN_glFramebufferDrawBufferEXT _FramebufferDrawBufferEXT;
    private PFN_glFramebufferDrawBuffersEXT _FramebufferDrawBuffersEXT;
    private PFN_glFramebufferReadBufferEXT _FramebufferReadBufferEXT;
    private PFN_glGetFramebufferParameterivEXT _GetFramebufferParameterivEXT;
    private PFN_glNamedCopyBufferSubDataEXT _NamedCopyBufferSubDataEXT;
    private PFN_glNamedFramebufferTextureEXT _NamedFramebufferTextureEXT;
    private PFN_glNamedFramebufferTextureLayerEXT _NamedFramebufferTextureLayerEXT;
    private PFN_glNamedFramebufferTextureFaceEXT _NamedFramebufferTextureFaceEXT;
    private PFN_glTextureRenderbufferEXT _TextureRenderbufferEXT;
    private PFN_glMultiTexRenderbufferEXT _MultiTexRenderbufferEXT;
    private PFN_glVertexArrayVertexOffsetEXT _VertexArrayVertexOffsetEXT;
    private PFN_glVertexArrayColorOffsetEXT _VertexArrayColorOffsetEXT;
    private PFN_glVertexArrayEdgeFlagOffsetEXT _VertexArrayEdgeFlagOffsetEXT;
    private PFN_glVertexArrayIndexOffsetEXT _VertexArrayIndexOffsetEXT;
    private PFN_glVertexArrayNormalOffsetEXT _VertexArrayNormalOffsetEXT;
    private PFN_glVertexArrayTexCoordOffsetEXT _VertexArrayTexCoordOffsetEXT;
    private PFN_glVertexArrayMultiTexCoordOffsetEXT _VertexArrayMultiTexCoordOffsetEXT;
    private PFN_glVertexArrayFogCoordOffsetEXT _VertexArrayFogCoordOffsetEXT;
    private PFN_glVertexArraySecondaryColorOffsetEXT _VertexArraySecondaryColorOffsetEXT;
    private PFN_glVertexArrayVertexAttribOffsetEXT _VertexArrayVertexAttribOffsetEXT;
    private PFN_glVertexArrayVertexAttribIOffsetEXT _VertexArrayVertexAttribIOffsetEXT;
    private PFN_glEnableVertexArrayEXT _EnableVertexArrayEXT;
    private PFN_glDisableVertexArrayEXT _DisableVertexArrayEXT;
    private PFN_glEnableVertexArrayAttribEXT _EnableVertexArrayAttribEXT;
    private PFN_glDisableVertexArrayAttribEXT _DisableVertexArrayAttribEXT;
    private PFN_glGetVertexArrayIntegervEXT _GetVertexArrayIntegervEXT;
    private PFN_glGetVertexArrayPointervEXT _GetVertexArrayPointervEXT;
    private PFN_glGetVertexArrayIntegeri_vEXT _GetVertexArrayIntegeri_vEXT;
    private PFN_glGetVertexArrayPointeri_vEXT _GetVertexArrayPointeri_vEXT;
    private PFN_glMapNamedBufferRangeEXT _MapNamedBufferRangeEXT;
    private PFN_glFlushMappedNamedBufferRangeEXT _FlushMappedNamedBufferRangeEXT;
    private PFN_glClearNamedBufferDataEXT _ClearNamedBufferDataEXT;
    private PFN_glClearNamedBufferSubDataEXT _ClearNamedBufferSubDataEXT;
    private PFN_glNamedFramebufferParameteriEXT _NamedFramebufferParameteriEXT;
    private PFN_glGetNamedFramebufferParameterivEXT _GetNamedFramebufferParameterivEXT;
    private PFN_glProgramUniform1dEXT _ProgramUniform1dEXT;
    private PFN_glProgramUniform2dEXT _ProgramUniform2dEXT;
    private PFN_glProgramUniform3dEXT _ProgramUniform3dEXT;
    private PFN_glProgramUniform4dEXT _ProgramUniform4dEXT;
    private PFN_glProgramUniform1dvEXT _ProgramUniform1dvEXT;
    private PFN_glProgramUniform2dvEXT _ProgramUniform2dvEXT;
    private PFN_glProgramUniform3dvEXT _ProgramUniform3dvEXT;
    private PFN_glProgramUniform4dvEXT _ProgramUniform4dvEXT;
    private PFN_glProgramUniformMatrix2dvEXT _ProgramUniformMatrix2dvEXT;
    private PFN_glProgramUniformMatrix3dvEXT _ProgramUniformMatrix3dvEXT;
    private PFN_glProgramUniformMatrix4dvEXT _ProgramUniformMatrix4dvEXT;
    private PFN_glProgramUniformMatrix2x3dvEXT _ProgramUniformMatrix2x3dvEXT;
    private PFN_glProgramUniformMatrix2x4dvEXT _ProgramUniformMatrix2x4dvEXT;
    private PFN_glProgramUniformMatrix3x2dvEXT _ProgramUniformMatrix3x2dvEXT;
    private PFN_glProgramUniformMatrix3x4dvEXT _ProgramUniformMatrix3x4dvEXT;
    private PFN_glProgramUniformMatrix4x2dvEXT _ProgramUniformMatrix4x2dvEXT;
    private PFN_glProgramUniformMatrix4x3dvEXT _ProgramUniformMatrix4x3dvEXT;
    private PFN_glTextureBufferRangeEXT _TextureBufferRangeEXT;
    private PFN_glTextureStorage1DEXT _TextureStorage1DEXT;
    private PFN_glTextureStorage2DEXT _TextureStorage2DEXT;
    private PFN_glTextureStorage3DEXT _TextureStorage3DEXT;
    private PFN_glTextureStorage2DMultisampleEXT _TextureStorage2DMultisampleEXT;
    private PFN_glTextureStorage3DMultisampleEXT _TextureStorage3DMultisampleEXT;
    private PFN_glVertexArrayBindVertexBufferEXT _VertexArrayBindVertexBufferEXT;
    private PFN_glVertexArrayVertexAttribFormatEXT _VertexArrayVertexAttribFormatEXT;
    private PFN_glVertexArrayVertexAttribIFormatEXT _VertexArrayVertexAttribIFormatEXT;
    private PFN_glVertexArrayVertexAttribLFormatEXT _VertexArrayVertexAttribLFormatEXT;
    private PFN_glVertexArrayVertexAttribBindingEXT _VertexArrayVertexAttribBindingEXT;
    private PFN_glVertexArrayVertexBindingDivisorEXT _VertexArrayVertexBindingDivisorEXT;
    private PFN_glVertexArrayVertexAttribLOffsetEXT _VertexArrayVertexAttribLOffsetEXT;
    private PFN_glTexturePageCommitmentEXT _TexturePageCommitmentEXT;
    private PFN_glVertexArrayVertexAttribDivisorEXT _VertexArrayVertexAttribDivisorEXT;

    // GL_EXT_raster_multisample,
    private PFN_glRasterSamplesEXT _RasterSamplesEXT;

    // GL_EXT_separate_shader_objects,
    private PFN_glUseShaderProgramEXT _UseShaderProgramEXT;
    private PFN_glActiveProgramEXT _ActiveProgramEXT;
    private PFN_glCreateShaderProgramEXT _CreateShaderProgramEXT;

    // GL_EXT_window_rectangles,
    private PFN_glWindowRectanglesEXT _WindowRectanglesEXT;

    // GL_INTEL_framebuffer_CMAA,
    private PFN_glApplyFramebufferAttachmentCMAAINTEL _ApplyFramebufferAttachmentCMAAINTEL;

    // GL_INTEL_performance_query,
    private PFN_glBeginPerfQueryINTEL _BeginPerfQueryINTEL;
    private PFN_glCreatePerfQueryINTEL _CreatePerfQueryINTEL;
    private PFN_glDeletePerfQueryINTEL _DeletePerfQueryINTEL;
    private PFN_glEndPerfQueryINTEL _EndPerfQueryINTEL;
    private PFN_glGetFirstPerfQueryIdINTEL _GetFirstPerfQueryIdINTEL;
    private PFN_glGetNextPerfQueryIdINTEL _GetNextPerfQueryIdINTEL;
    private PFN_glGetPerfCounterInfoINTEL _GetPerfCounterInfoINTEL;
    private PFN_glGetPerfQueryDataINTEL _GetPerfQueryDataINTEL;
    private PFN_glGetPerfQueryIdByNameINTEL _GetPerfQueryIdByNameINTEL;
    private PFN_glGetPerfQueryInfoINTEL _GetPerfQueryInfoINTEL;

    // GL_NV_bindless_multi_draw_indirect,
    private PFN_glMultiDrawArraysIndirectBindlessNV _MultiDrawArraysIndirectBindlessNV;
    private PFN_glMultiDrawElementsIndirectBindlessNV _MultiDrawElementsIndirectBindlessNV;

    // GL_NV_bindless_multi_draw_indirect_count,
    private PFN_glMultiDrawArraysIndirectBindlessCountNV _MultiDrawArraysIndirectBindlessCountNV;
    private PFN_glMultiDrawElementsIndirectBindlessCountNV _MultiDrawElementsIndirectBindlessCountNV;

    // GL_NV_bindless_texture,
    private PFN_glGetTextureHandleNV _GetTextureHandleNV;
    private PFN_glGetTextureSamplerHandleNV _GetTextureSamplerHandleNV;
    private PFN_glMakeTextureHandleResidentNV _MakeTextureHandleResidentNV;
    private PFN_glMakeTextureHandleNonResidentNV _MakeTextureHandleNonResidentNV;
    private PFN_glGetImageHandleNV _GetImageHandleNV;
    private PFN_glMakeImageHandleResidentNV _MakeImageHandleResidentNV;
    private PFN_glMakeImageHandleNonResidentNV _MakeImageHandleNonResidentNV;
    private PFN_glUniformHandleui64NV _UniformHandleui64NV;
    private PFN_glUniformHandleui64vNV _UniformHandleui64vNV;
    private PFN_glProgramUniformHandleui64NV _ProgramUniformHandleui64NV;
    private PFN_glProgramUniformHandleui64vNV _ProgramUniformHandleui64vNV;
    private PFN_glIsTextureHandleResidentNV _IsTextureHandleResidentNV;
    private PFN_glIsImageHandleResidentNV _IsImageHandleResidentNV;

    // GL_NV_blend_equation_advanced,
    private PFN_glBlendParameteriNV _BlendParameteriNV;
    private PFN_glBlendBarrierNV _BlendBarrierNV;

    // GL_NV_clip_space_w_scaling,
    private PFN_glViewportPositionWScaleNV _ViewportPositionWScaleNV;

    // GL_NV_command_list,
    private PFN_glCreateStatesNV _CreateStatesNV;
    private PFN_glDeleteStatesNV _DeleteStatesNV;
    private PFN_glIsStateNV _IsStateNV;
    private PFN_glStateCaptureNV _StateCaptureNV;
    private PFN_glGetCommandHeaderNV _GetCommandHeaderNV;
    private PFN_glGetStageIndexNV _GetStageIndexNV;
    private PFN_glDrawCommandsNV _DrawCommandsNV;
    private PFN_glDrawCommandsAddressNV _DrawCommandsAddressNV;
    private PFN_glDrawCommandsStatesNV _DrawCommandsStatesNV;
    private PFN_glDrawCommandsStatesAddressNV _DrawCommandsStatesAddressNV;
    private PFN_glCreateCommandListsNV _CreateCommandListsNV;
    private PFN_glDeleteCommandListsNV _DeleteCommandListsNV;
    private PFN_glIsCommandListNV _IsCommandListNV;
    private PFN_glListDrawCommandsStatesClientNV _ListDrawCommandsStatesClientNV;
    private PFN_glCommandListSegmentsNV _CommandListSegmentsNV;
    private PFN_glCompileCommandListNV _CompileCommandListNV;
    private PFN_glCallCommandListNV _CallCommandListNV;

    // GL_NV_conservative_raster,
    private PFN_glSubpixelPrecisionBiasNV _SubpixelPrecisionBiasNV;

    // GL_NV_conservative_raster_dilate,
    private PFN_glConservativeRasterParameterfNV _ConservativeRasterParameterfNV;

    // GL_NV_conservative_raster_pre_snap_triangles,
    private PFN_glConservativeRasterParameteriNV _ConservativeRasterParameteriNV;

    // GL_NV_draw_vulkan_image,
    private PFN_glDrawVkImageNV _DrawVkImageNV;
    private PFN_glGetVkProcAddrNV _GetVkProcAddrNV;
    private PFN_glWaitVkSemaphoreNV _WaitVkSemaphoreNV;
    private PFN_glSignalVkSemaphoreNV _SignalVkSemaphoreNV;
    private PFN_glSignalVkFenceNV _SignalVkFenceNV;

    // GL_NV_fragment_coverage_to_color,
    private PFN_glFragmentCoverageColorNV _FragmentCoverageColorNV;

    // GL_NV_framebuffer_mixed_samples,
    private PFN_glCoverageModulationTableNV _CoverageModulationTableNV;
    private PFN_glGetCoverageModulationTableNV _GetCoverageModulationTableNV;
    private PFN_glCoverageModulationNV _CoverageModulationNV;

    // GL_NV_framebuffer_multisample_coverage,
    private PFN_glRenderbufferStorageMultisampleCoverageNV _RenderbufferStorageMultisampleCoverageNV;

    // GL_NV_gpu_shader5,
    private PFN_glUniform1i64NV _Uniform1i64NV;
    private PFN_glUniform2i64NV _Uniform2i64NV;
    private PFN_glUniform3i64NV _Uniform3i64NV;
    private PFN_glUniform4i64NV _Uniform4i64NV;
    private PFN_glUniform1i64vNV _Uniform1i64vNV;
    private PFN_glUniform2i64vNV _Uniform2i64vNV;
    private PFN_glUniform3i64vNV _Uniform3i64vNV;
    private PFN_glUniform4i64vNV _Uniform4i64vNV;
    private PFN_glUniform1ui64NV _Uniform1ui64NV;
    private PFN_glUniform2ui64NV _Uniform2ui64NV;
    private PFN_glUniform3ui64NV _Uniform3ui64NV;
    private PFN_glUniform4ui64NV _Uniform4ui64NV;
    private PFN_glUniform1ui64vNV _Uniform1ui64vNV;
    private PFN_glUniform2ui64vNV _Uniform2ui64vNV;
    private PFN_glUniform3ui64vNV _Uniform3ui64vNV;
    private PFN_glUniform4ui64vNV _Uniform4ui64vNV;
    private PFN_glGetUniformi64vNV _GetUniformi64vNV;
    private PFN_glProgramUniform1i64NV _ProgramUniform1i64NV;
    private PFN_glProgramUniform2i64NV _ProgramUniform2i64NV;
    private PFN_glProgramUniform3i64NV _ProgramUniform3i64NV;
    private PFN_glProgramUniform4i64NV _ProgramUniform4i64NV;
    private PFN_glProgramUniform1i64vNV _ProgramUniform1i64vNV;
    private PFN_glProgramUniform2i64vNV _ProgramUniform2i64vNV;
    private PFN_glProgramUniform3i64vNV _ProgramUniform3i64vNV;
    private PFN_glProgramUniform4i64vNV _ProgramUniform4i64vNV;
    private PFN_glProgramUniform1ui64NV _ProgramUniform1ui64NV;
    private PFN_glProgramUniform2ui64NV _ProgramUniform2ui64NV;
    private PFN_glProgramUniform3ui64NV _ProgramUniform3ui64NV;
    private PFN_glProgramUniform4ui64NV _ProgramUniform4ui64NV;
    private PFN_glProgramUniform1ui64vNV _ProgramUniform1ui64vNV;
    private PFN_glProgramUniform2ui64vNV _ProgramUniform2ui64vNV;
    private PFN_glProgramUniform3ui64vNV _ProgramUniform3ui64vNV;
    private PFN_glProgramUniform4ui64vNV _ProgramUniform4ui64vNV;

    // GL_NV_internalformat_sample_query,
    private PFN_glGetInternalformatSampleivNV _GetInternalformatSampleivNV;

    // GL_NV_path_rendering,
    private PFN_glGenPathsNV _GenPathsNV;
    private PFN_glDeletePathsNV _DeletePathsNV;
    private PFN_glIsPathNV _IsPathNV;
    private PFN_glPathCommandsNV _PathCommandsNV;
    private PFN_glPathCoordsNV _PathCoordsNV;
    private PFN_glPathSubCommandsNV _PathSubCommandsNV;
    private PFN_glPathSubCoordsNV _PathSubCoordsNV;
    private PFN_glPathStringNV _PathStringNV;
    private PFN_glPathGlyphsNV _PathGlyphsNV;
    private PFN_glPathGlyphRangeNV _PathGlyphRangeNV;
    private PFN_glWeightPathsNV _WeightPathsNV;
    private PFN_glCopyPathNV _CopyPathNV;
    private PFN_glInterpolatePathsNV _InterpolatePathsNV;
    private PFN_glTransformPathNV _TransformPathNV;
    private PFN_glPathParameterivNV _PathParameterivNV;
    private PFN_glPathParameteriNV _PathParameteriNV;
    private PFN_glPathParameterfvNV _PathParameterfvNV;
    private PFN_glPathParameterfNV _PathParameterfNV;
    private PFN_glPathDashArrayNV _PathDashArrayNV;
    private PFN_glPathStencilFuncNV _PathStencilFuncNV;
    private PFN_glPathStencilDepthOffsetNV _PathStencilDepthOffsetNV;
    private PFN_glStencilFillPathNV _StencilFillPathNV;
    private PFN_glStencilStrokePathNV _StencilStrokePathNV;
    private PFN_glStencilFillPathInstancedNV _StencilFillPathInstancedNV;
    private PFN_glStencilStrokePathInstancedNV _StencilStrokePathInstancedNV;
    private PFN_glPathCoverDepthFuncNV _PathCoverDepthFuncNV;
    private PFN_glCoverFillPathNV _CoverFillPathNV;
    private PFN_glCoverStrokePathNV _CoverStrokePathNV;
    private PFN_glCoverFillPathInstancedNV _CoverFillPathInstancedNV;
    private PFN_glCoverStrokePathInstancedNV _CoverStrokePathInstancedNV;
    private PFN_glGetPathParameterivNV _GetPathParameterivNV;
    private PFN_glGetPathParameterfvNV _GetPathParameterfvNV;
    private PFN_glGetPathCommandsNV _GetPathCommandsNV;
    private PFN_glGetPathCoordsNV _GetPathCoordsNV;
    private PFN_glGetPathDashArrayNV _GetPathDashArrayNV;
    private PFN_glGetPathMetricsNV _GetPathMetricsNV;
    private PFN_glGetPathMetricRangeNV _GetPathMetricRangeNV;
    private PFN_glGetPathSpacingNV _GetPathSpacingNV;
    private PFN_glIsPointInFillPathNV _IsPointInFillPathNV;
    private PFN_glIsPointInStrokePathNV _IsPointInStrokePathNV;
    private PFN_glGetPathLengthNV _GetPathLengthNV;
    private PFN_glPointAlongPathNV _PointAlongPathNV;
    private PFN_glMatrixLoad3x2fNV _MatrixLoad3x2fNV;
    private PFN_glMatrixLoad3x3fNV _MatrixLoad3x3fNV;
    private PFN_glMatrixLoadTranspose3x3fNV _MatrixLoadTranspose3x3fNV;
    private PFN_glMatrixMult3x2fNV _MatrixMult3x2fNV;
    private PFN_glMatrixMult3x3fNV _MatrixMult3x3fNV;
    private PFN_glMatrixMultTranspose3x3fNV _MatrixMultTranspose3x3fNV;
    private PFN_glStencilThenCoverFillPathNV _StencilThenCoverFillPathNV;
    private PFN_glStencilThenCoverStrokePathNV _StencilThenCoverStrokePathNV;
    private PFN_glStencilThenCoverFillPathInstancedNV _StencilThenCoverFillPathInstancedNV;
    private PFN_glStencilThenCoverStrokePathInstancedNV _StencilThenCoverStrokePathInstancedNV;
    private PFN_glPathGlyphIndexRangeNV _PathGlyphIndexRangeNV;
    private PFN_glPathGlyphIndexArrayNV _PathGlyphIndexArrayNV;
    private PFN_glPathMemoryGlyphIndexArrayNV _PathMemoryGlyphIndexArrayNV;
    private PFN_glProgramPathFragmentInputGenNV _ProgramPathFragmentInputGenNV;
    private PFN_glGetProgramResourcefvNV _GetProgramResourcefvNV;

    // GL_NV_sample_locations,
    private PFN_glFramebufferSampleLocationsfvNV _FramebufferSampleLocationsfvNV;
    private PFN_glNamedFramebufferSampleLocationsfvNV _NamedFramebufferSampleLocationsfvNV;
    private PFN_glResolveDepthValuesNV _ResolveDepthValuesNV;

    // GL_NV_shader_buffer_load,
    private PFN_glMakeBufferResidentNV _MakeBufferResidentNV;
    private PFN_glMakeBufferNonResidentNV _MakeBufferNonResidentNV;
    private PFN_glIsBufferResidentNV _IsBufferResidentNV;
    private PFN_glMakeNamedBufferResidentNV _MakeNamedBufferResidentNV;
    private PFN_glMakeNamedBufferNonResidentNV _MakeNamedBufferNonResidentNV;
    private PFN_glIsNamedBufferResidentNV _IsNamedBufferResidentNV;
    private PFN_glGetBufferParameterui64vNV _GetBufferParameterui64vNV;
    private PFN_glGetNamedBufferParameterui64vNV _GetNamedBufferParameterui64vNV;
    private PFN_glGetIntegerui64vNV _GetIntegerui64vNV;
    private PFN_glUniformui64NV _Uniformui64NV;
    private PFN_glUniformui64vNV _Uniformui64vNV;
    private PFN_glGetUniformui64vNV _GetUniformui64vNV;
    private PFN_glProgramUniformui64NV _ProgramUniformui64NV;
    private PFN_glProgramUniformui64vNV _ProgramUniformui64vNV;

    // GL_NV_texture_barrier,
    private PFN_glTextureBarrierNV _TextureBarrierNV;

    // GL_NV_vertex_attrib_integer_64bit,
    private PFN_glVertexAttribL1i64NV _VertexAttribL1i64NV;
    private PFN_glVertexAttribL2i64NV _VertexAttribL2i64NV;
    private PFN_glVertexAttribL3i64NV _VertexAttribL3i64NV;
    private PFN_glVertexAttribL4i64NV _VertexAttribL4i64NV;
    private PFN_glVertexAttribL1i64vNV _VertexAttribL1i64vNV;
    private PFN_glVertexAttribL2i64vNV _VertexAttribL2i64vNV;
    private PFN_glVertexAttribL3i64vNV _VertexAttribL3i64vNV;
    private PFN_glVertexAttribL4i64vNV _VertexAttribL4i64vNV;
    private PFN_glVertexAttribL1ui64NV _VertexAttribL1ui64NV;
    private PFN_glVertexAttribL2ui64NV _VertexAttribL2ui64NV;
    private PFN_glVertexAttribL3ui64NV _VertexAttribL3ui64NV;
    private PFN_glVertexAttribL4ui64NV _VertexAttribL4ui64NV;
    private PFN_glVertexAttribL1ui64vNV _VertexAttribL1ui64vNV;
    private PFN_glVertexAttribL2ui64vNV _VertexAttribL2ui64vNV;
    private PFN_glVertexAttribL3ui64vNV _VertexAttribL3ui64vNV;
    private PFN_glVertexAttribL4ui64vNV _VertexAttribL4ui64vNV;
    private PFN_glGetVertexAttribLi64vNV _GetVertexAttribLi64vNV;
    private PFN_glGetVertexAttribLui64vNV _GetVertexAttribLui64vNV;
    private PFN_glVertexAttribLFormatNV _VertexAttribLFormatNV;

    // GL_NV_vertex_buffer_unified_memory,
    private PFN_glBufferAddressRangeNV _BufferAddressRangeNV;
    private PFN_glVertexFormatNV _VertexFormatNV;
    private PFN_glNormalFormatNV _NormalFormatNV;
    private PFN_glColorFormatNV _ColorFormatNV;
    private PFN_glIndexFormatNV _IndexFormatNV;
    private PFN_glTexCoordFormatNV _TexCoordFormatNV;
    private PFN_glEdgeFlagFormatNV _EdgeFlagFormatNV;
    private PFN_glSecondaryColorFormatNV _SecondaryColorFormatNV;
    private PFN_glFogCoordFormatNV _FogCoordFormatNV;
    private PFN_glVertexAttribFormatNV _VertexAttribFormatNV;
    private PFN_glVertexAttribIFormatNV _VertexAttribIFormatNV;
    private PFN_glGetIntegerui64i_vNV _GetIntegerui64i_vNV;

    // GL_NV_viewport_swizzle,
    private PFN_glViewportSwizzleNV _ViewportSwizzleNV;

    // GL_OVR_multiview,
    private PFN_glFramebufferTextureMultiviewOVR _FramebufferTextureMultiviewOVR;
}
