/// Definitions from `khrplatform.h`
module gfx.bindings.opengl.khrplatform;

alias khronos_int8_t                = byte;
alias khronos_uint8_t               = ubyte;
alias khronos_int16_t               = short;
alias khronos_uint16_t              = ushort;
alias khronos_int32_t               = int;
alias khronos_uint32_t              = uint;
alias khronos_int64_t               = long;
alias khronos_uint64_t              = ulong;
alias khronos_intptr_t              = ptrdiff_t;
alias khronos_uintptr_t             = size_t;
alias khronos_ssize_t               = ptrdiff_t;
alias khronos_usize_t               = size_t;
alias khronos_float_t               = float;
alias khronos_time_ns_t             = ulong;
alias khronos_stime_nanoseconds_t   = ulong;
alias khronos_utime_nanoseconds_t   = long;

enum khronos_boolean_enum_t {
    KHRONOS_FALSE, KHRONOS_TRUE
}
enum KHRONOS_FALSE = khronos_boolean_enum_t.KHRONOS_FALSE;
enum KHRONOS_TRUE  = khronos_boolean_enum_t.KHRONOS_TRUE;
