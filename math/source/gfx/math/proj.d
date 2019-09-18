/// NDC agnostic projection matrices.
/// Each projection can be parameterized with a NDC configuration.
/// NDC defines how the clip space will translate to screen coordinates.
/// Note that after transformation by a projection matrix, X, Y and Z vertex
/// coordinates must be divided by W to obtain coordinates in final NDC space.
/// NDC has two components (XYClip and ZClip) that will affect how the
/// coordinates are transformed in the final normalized clipping space.
/// XYClip affects only X and Y (X always to the right, Y either upwards or downwards
/// for leftHanded and rightHanded respectively), and ZClip affects Z depth range.
module gfx.math.proj;

import gfx.math.mat;
import gfx.math.vec;
import std.traits : isFloatingPoint;

pure @safe @nogc nothrow:

/// Determines whether the default projection matrices will project to a clip space
/// where Y points upwards (left hand NDC) or downwards (right hand NDC).
/// Default is right hand NDC, but can be changed by setting version(GfxMathLeftHandNDC)
/// X-Y clip space spans from [-1 .. 1] in both cases.
enum XYClip
{
    /// right handed NDC (Y points downwards)
    rightHand       = 0,
    /// left handed NDC (Y points upwards)
    leftHand        = 2,
}

/// Determines whether the default projection matrices will project to a clip space
/// whose depth range is [0 .. 1] or [-1 .. 1].
/// Default is [0 .. 1] but can be changed by setting version(GfxMathDepthMinusOneToOne)
/// Z points into the screen in both cases.
enum ZClip
{
    /// Depth range is [0 .. 1]
    zeroToOne       = 0,
    /// Depth range is [-1 .. 1]
    minusOneToOne   = 1,
}

/// NDC aggregates both XYClip and ZClip
enum NDC
{
    /// XYClip.rightHand and ZClip.zeroToOne
    RH_01   = 0,
    /// XYClip.rightHand and ZClip.minusOneToOne
    RH_M11  = 1,
    /// XYClip.leftHand and ZClip.zeroToOne
    LH_01   = 2,
    /// XYClip.leftHand and ZClip.minusOneToOne
    LH_M11  = 3,
}

/// Build NDC from XYClip and ZClip
NDC ndc(in XYClip xy, in ZClip z)
{
    return cast(NDC)(cast(uint)xy | cast(uint)z);
}

/// Get XYClip from NDC
@property XYClip xyClip(in NDC ndc)
{
    return cast(XYClip)(cast(uint)ndc & 0x02);
}

/// Get ZClip from NDC
@property ZClip zClip(in NDC ndc)
{
    return cast(ZClip)(cast(uint)ndc & 0x01);
}

/// Build an orthographic projection matrix with right-hand NDC and [0 .. 1] depth clipping
/// Params:
///     l =     X position of the left plane
///     r =     X position of the right plane
///     b =     Y position of the bottom plane
///     t =     Y position of the top plane
///     n =     distance from origin to near plane (in Z-)
///     f =     distance from origin to far plane (in Z-)
/// Returns: an affine matrix that maps from eye coordinates to NDC.
Mat4!T ortho_RH_01(T) (in T l, in T r, in T b, in T t, in T n, in T f)
{
    const rl = r-l;
    const bt = b-t;
    const fn = f-n;
    return Mat4!T(
        T(2)/rl,        0,              0,          -(r+l)/rl,
        0,              T(2)/bt,        0,          -(b+t)/bt,
        0,              0,              T(-1)/fn,   -n/fn,
        0,              0,              0,          1,
    );
}

///
unittest {
    import gfx.math.approx : approxUlp;
    const m = ortho_RH_01(3f, 5f, -2f, 7f, 1f, 10f);
    const vl = vec(3f, -2f, -1f, 1f);
    const vh = vec(5f, 7f, -10f, 1f);
    const vc = vec(4f, 2.5f, -5.5f, 1f);

    assert(approxUlp( m * vl, vec(-1f, 1f, 0f, 1f) ));
    assert(approxUlp( m * vh, vec(1f, -1f, 1f, 1f) ));
    assert(approxUlp( m * vc, vec(0f, 0f, 0.5f, 1f) ));
}


/// Build an orthographic projection matrix with right-hand NDC and [-1 .. 1] depth clipping
/// Params:
///     l =     X position of the left plane
///     r =     X position of the right plane
///     b =     Y position of the bottom plane
///     t =     Y position of the top plane
///     n =     distance from origin to near plane (in Z-)
///     f =     distance from origin to far plane (in Z-)
/// Returns: an affine matrix that maps from eye coordinates to NDC.
Mat4!T ortho_RH_M11(T) (in T l, in T r, in T b, in T t, in T n, in T f)
{
    const rl = r-l;
    const bt = b-t;
    const fn = f-n;
    return Mat4!T(
        T(2)/rl,        0,              0,          -(r+l)/rl,
        0,              T(2)/bt,        0,          -(b+t)/bt,
        0,              0,              T(-2)/fn,   -(f+n)/fn,
        0,              0,              0,          1,
    );
}

///
unittest {
    import gfx.math.approx : approxUlp;
    const m = ortho_RH_M11(3f, 5f, -2f, 7f, 1f, 10f);
    const v1 = vec(3f, -2f, -1f, 1f);
    const v2 = vec(5f, 7f, -10f, 1f);
    const v0 = vec(4f, 2.5f, -5.5f, 1f);

    assert(approxUlp( m * v1, vec(-1f, 1f, -1f, 1f) ));
    assert(approxUlp( m * v2, vec(1f, -1f, 1f, 1f) ));
    assert(approxUlp( m * v0, vec(0f, 0f, 0f, 1f) ));
}


/// Build an orthographic projection matrix with left-hand NDC and [0 .. 1] depth clipping
/// Params:
///     l =     X position of the left plane
///     r =     X position of the right plane
///     b =     Y position of the bottom plane
///     t =     Y position of the top plane
///     n =     distance from origin to near plane (in Z-)
///     f =     distance from origin to far plane (in Z-)
/// Returns: an affine matrix that maps from eye coordinates to NDC.
Mat4!T ortho_LH_01(T) (in T l, in T r, in T b, in T t, in T n, in T f)
{
    const rl = r-l;
    const tb = t-b;
    const fn = f-n;
    return Mat4!T(
        T(2)/rl,        0,              0,          -(r+l)/rl,
        0,              T(2)/tb,        0,          -(t+b)/tb,
        0,              0,              T(-1)/fn,   -n/fn,
        0,              0,              0,          1,
    );
}


///
unittest {
    import gfx.math.approx : approxUlp;
    const m = ortho_LH_01(3f, 5f, -2f, 7f, 1f, 10f);
    const v1 = vec(3f, -2f, -1f, 1f);
    const v2 = vec(5f, 7f, -10f, 1f);
    const v0 = vec(4f, 2.5f, -5.5f, 1f);

    assert(approxUlp( m * v1, vec(-1f, -1f, 0f, 1f) ));
    assert(approxUlp( m * v2, vec(1f, 1f, 1f, 1f) ));
    assert(approxUlp( m * v0, vec(0f, 0f, 0.5f, 1f) ));
}

/// Build an orthographic projection matrix with left-hand NDC and [-1 .. 1] depth clipping
/// Params:
///     l =     X position of the left plane
///     r =     X position of the right plane
///     b =     Y position of the bottom plane
///     t =     Y position of the top plane
///     n =     distance from origin to near plane (in Z-)
///     f =     distance from origin to far plane (in Z-)
/// Returns: an affine matrix that maps from eye coordinates to NDC.
Mat4!T ortho_LH_M11(T) (in T l, in T r, in T b, in T t, in T n, in T f)
{
    const rl = r-l;
    const tb = t-b;
    const fn = f-n;
    return Mat4!T(
        T(2)/rl,        0,              0,          -(r+l)/rl,
        0,              T(2)/tb,        0,          -(t+b)/tb,
        0,              0,              T(-2)/fn,   -(f+n)/fn,
        0,              0,              0,          1,
    );
}

///
unittest {
    import gfx.math.approx : approxUlp;
    const m = ortho_LH_M11(3f, 5f, -2f, 7f, 1f, 10f);
    const v1 = vec(3f, -2f, -1f, 1f);
    const v2 = vec(5f, 7f, -10f, 1f);
    const v0 = vec(4f, 2.5f, -5.5f, 1f);

    assert(approxUlp( m * v1, vec(-1f, -1f, -1f, 1f) ));
    assert(approxUlp( m * v2, vec(1f, 1f, 1f, 1f) ));
    assert(approxUlp( m * v0, vec(0f, 0f, 0f, 1f) ));
}

/// Build an orthographic projection matrix with NDC set at compile-time.
template orthoCT(NDC ndc)
{
    static if (ndc == NDC.RH_01) {
        alias orthoCT = ortho_RH_01;
    }
    else static if (ndc == NDC.RH_M11) {
        alias orthoCT = ortho_RH_M11;
    }
    else static if (ndc == NDC.LH_01) {
        alias orthoCT = ortho_LH_01;
    }
    else static if (ndc == NDC.LH_M11) {
        alias orthoCT = ortho_LH_M11;
    }
    else {
        static assert(false);
    }
}

/// Build an orthographic projection matrix with default NDC
/// Params:
///     l =     X position of the left plane
///     r =     X position of the right plane
///     b =     Y position of the bottom plane
///     t =     Y position of the top plane
///     n =     distance from origin to near plane (in Z-)
///     f =     distance from origin to far plane (in Z-)
/// Returns: an affine matrix that maps from eye coordinates to NDC.
alias defOrtho = orthoCT!(defNdc);

/// Build an orthographic projection matrix with NDC determined at runtime
/// Params:
///     ndc =   the target NDC
///     l =     X position of the left plane
///     r =     X position of the right plane
///     b =     Y position of the bottom plane
///     t =     Y position of the top plane
///     n =     distance from origin to near plane (in Z-)
///     f =     distance from origin to far plane (in Z-)
/// Returns: an affine matrix that maps from eye coordinates to NDC.
Mat4!T ortho(T)(NDC ndc, in T l, in T r, in T b, in T t, in T n, in T f)
{
    final switch (ndc)
    {
    case NDC.RH_01:
        return ortho_RH_01(l, r, b, t, n, f);
    case NDC.RH_M11:
        return ortho_RH_M11(l, r, b, t, n, f);
    case NDC.LH_01:
        return ortho_LH_01(l, r, b, t, n, f);
    case NDC.LH_M11:
        return ortho_LH_M11(l, r, b, t, n, f);
    }
}

/// Build a perspective projection matrix with right-hand NDC and [0 .. 1] depth clipping
/// Params:
///     l =     X position of the left edge at the near plane
///     r =     X position of the right edge at the near plane
///     b =     Y position of the bottom edge at the near plane
///     t =     Y position of the top edge at the near plane
///     n =     distance from origin to near plane (in Z-)
///     f =     distance from origin to far plane (in Z-)
/// Returns: a matrix that maps from eye space to clip space. To obtain NDC, the vector must be divided by w.
Mat4!T frustum_RH_01(T)(in T l, in T r, in T b, in T t, in T n, in T f)
{
    const rl = r-l;
    const bt = b-t;
    const fn = f-n;

    return Mat4!T (
        2*n/rl, 0,          (r+l)/rl,   0,
        0,      2*n/bt,     (b+t)/bt,   0,
        0,      0,          -f/fn,      -f*n/fn,
        0,      0,          -1,         0,
    );
}

///
unittest {
    const m = frustum_RH_01!float(-2, 2, -4, 4, 2, 4);
    const vl = fvec(-2, -4, -2);
    const vh = fvec(4, 8, -4);
    const vc = fvec(0, 0, -3);

    auto toNdc(in FVec3 v) {
        const clip = m * fvec(v, 1);
        return (clip / clip.w).xyz;
    }

    import gfx.math.approx : approxUlp;
    assert(approxUlp( toNdc(vl), fvec(-1, 1, 0) ));
    assert(approxUlp( toNdc(vh), fvec(1, -1, 1) ));
    assert(approxUlp( toNdc(vc), fvec(0, 0, 2f/3f) ));
}


/// Build a perspective projection matrix with right-hand NDC and [0 .. 1] depth clipping
/// Params:
///     l =     X position of the left edge at the near plane
///     r =     X position of the right edge at the near plane
///     b =     Y position of the bottom edge at the near plane
///     t =     Y position of the top edge at the near plane
///     n =     distance from origin to near plane (in Z-)
///     f =     distance from origin to far plane (in Z-)
/// Returns: a matrix that maps from eye space to clip space. To obtain NDC, the vector must be divided by w.
Mat4!T frustum_RH_M11(T)(in T l, in T r, in T b, in T t, in T n, in T f)
{
    const rl = r-l;
    const bt = b-t;
    const fn = f-n;

    return Mat4!T (
        2*n/rl, 0,          (r+l)/rl,   0,
        0,      2*n/bt,     (b+t)/bt,   0,
        0,      0,          -(f+n)/fn,  -2*f*n/fn,
        0,      0,          -1,         0,
    );
}

///
unittest {
    const m = frustum_RH_M11!float(-2, 2, -4, 4, 2, 4);
    const vl = fvec(-2, -4, -2);
    const vh = fvec(4, 8, -4);
    const vc = fvec(0, 0, -3);

    auto toNdc(in FVec3 v) {
        const clip = m * fvec(v, 1);
        return (clip / clip.w).xyz;
    }

    import gfx.math.approx : approxUlp;
    assert(approxUlp( toNdc(vl), fvec(-1, 1, -1) ));
    assert(approxUlp( toNdc(vh), fvec(1, -1, 1) ));
    assert(approxUlp( toNdc(vc), fvec(0, 0, 1f/3f) ));
}

/// Build a perspective projection matrix with left-hand NDC and [0 .. 1] depth clipping
/// Params:
///     l =     X position of the left edge at the near plane
///     r =     X position of the right edge at the near plane
///     b =     Y position of the bottom edge at the near plane
///     t =     Y position of the top edge at the near plane
///     n =     distance from origin to near plane (in Z-)
///     f =     distance from origin to far plane (in Z-)
/// Returns: a matrix that maps from eye space to clip space. To obtain NDC, the vector must be divided by w.
Mat4!T frustum_LH_01(T)(in T l, in T r, in T b, in T t, in T n, in T f)
{
    const rl = r-l;
    const tb = t-b;
    const fn = f-n;

    return Mat4!T (
        2*n/rl, 0,          (r+l)/rl,   0,
        0,      2*n/tb,     (t+b)/tb,   0,
        0,      0,          -f/fn,      -f*n/fn,
        0,      0,          -1,         0,
    );
}

/// Build a perspective projection matrix with left-hand NDC and [-1 .. 1] depth clipping
/// Params:
///     l =     X position of the left edge at the near plane
///     r =     X position of the right edge at the near plane
///     b =     Y position of the bottom edge at the near plane
///     t =     Y position of the top edge at the near plane
///     n =     distance from origin to near plane (in Z-)
///     f =     distance from origin to far plane (in Z-)
/// Returns: a matrix that maps from eye space to clip space. To obtain NDC, the vector must be divided by w.
Mat4!T frustum_LH_M11(T)(in T l, in T r, in T b, in T t, in T n, in T f)
{
    const rl = r-l;
    const tb = t-b;
    const fn = f-n;

    return Mat4!T (
        2*n/rl, 0,          (r+l)/rl,   0,
        0,      2*n/tb,     (t+b)/tb,   0,
        0,      0,          -(f+n)/fn,  -2*f*n/fn,
        0,      0,          -1,         0,
    );
}

///
unittest {
    const m = frustum_LH_01!float(-2, 2, -4, 4, 2, 4);
    const vl = fvec(-2, -4, -2);
    const vh = fvec(4, 8, -4);
    const vc = fvec(0, 0, -3);

    auto toNdc(in FVec3 v) {
        const clip = m * fvec(v, 1);
        return (clip / clip.w).xyz;
    }

    import gfx.math.approx : approxUlp;
    assert(approxUlp( toNdc(vl), fvec(-1, -1, 0) ));
    assert(approxUlp( toNdc(vh), fvec(1, 1, 1) ));
    assert(approxUlp( toNdc(vc), fvec(0, 0, 2f/3f) ));
}


/// Build an frustum perspective projection matrix with NDC set at compile-time.
template frustumCT(NDC ndc)
{
    static if (ndc == NDC.RH_01) {
        alias frustumCT = frustum_RH_01;
    }
    else static if (ndc == NDC.RH_M11) {
        alias frustumCT = frustum_RH_M11;
    }
    else static if (ndc == NDC.LH_01) {
        alias frustumCT = frustum_LH_01;
    }
    else static if (ndc == NDC.LH_M11) {
        alias frustumCT = frustum_LH_M11;
    }
    else {
        static assert(false);
    }
}

/// Build an frustum perspective projection matrix with default NDC and DepthClip
/// Params:
///     l =     X position of the left edge at the near plane
///     r =     X position of the right edge at the near plane
///     b =     Y position of the bottom edge at the near plane
///     t =     Y position of the top edge at the near plane
///     n =     distance from origin to near plane (in Z-)
///     f =     distance from origin to far plane (in Z-)
/// Returns: a matrix that maps from eye space to clip space. To obtain NDC, the vector must be divided by w.
alias defFrustum = frustumCT!(defNdc);

/// Build an frustum perspective projection matrix with NDC and DepthClip selected at runtime
/// Params:
///     ndc =   the target NDC
///     l =     X position of the left edge at the near plane
///     r =     X position of the right edge at the near plane
///     b =     Y position of the bottom edge at the near plane
///     t =     Y position of the top edge at the near plane
///     n =     distance from origin to near plane (in Z-)
///     f =     distance from origin to far plane (in Z-)
/// Returns: a matrix that maps from eye space to clip space. To obtain NDC, the vector must be divided by w.
Mat4!T frustum(T)(NDC ndc, in T l, in T r, in T b, in T t, in T n, in T f)
{
    final switch (ndc)
    {
    case NDC.RH_01:
        return frustum_RH_01(l, r, b, t, n, f);
    case NDC.RH_M11:
        return frustum_RH_M11(l, r, b, t, n, f);
    case NDC.LH_01:
        return frustum_LH_01(l, r, b, t, n, f);
    case NDC.LH_M11:
        return frustum_LH_M11(l, r, b, t, n, f);
    }
}

/// Build a perspective projection matrix with right-hand NDC and [0 .. 1] depth clipping
/// Params:
///     fovx =      horizontal field of view in degrees
///     aspect =    aspect ratio (width / height)
///     near =      position of the near plane
///     far =       position of the far plane
/// Returns: a matrix that maps from eye space to clip space. To obtain NDC, the vector must be divided by w.
Mat4!T perspective_RH_01(T)(in T fovx, in T aspect, in T near, in T far)
if (isFloatingPoint!T)
{
    import std.math : PI, tan;
    const r = cast(T)(near * tan(fovx * PI / T(360)));
    const t = r / aspect;
    return frustum_RH_01(-r, r, -t, t, near, far);
}

///
unittest {
    const m = perspective_RH_01!float(90, 2, 2, 4);
    const vl = fvec(-2, -1, -2);
    const vh = fvec(4, 2, -4);
    const vc = fvec(0, 0, -3);

    auto toNdc(in FVec3 v) {
        const clip = m * fvec(v, 1);
        return (clip / clip.w).xyz;
    }

    import gfx.math.approx : approxUlp;
    assert(approxUlp( toNdc(vl), fvec(-1, 1, 0) ));
    assert(approxUlp( toNdc(vh), fvec(1, -1, 1) ));
    assert(approxUlp( toNdc(vc), fvec(0, 0, 2f/3f) ));
}


/// Build a perspective projection matrix with right-hand NDC and [-1 .. 1] depth clipping
/// Params:
///     fovx =      horizontal field of view in degrees
///     aspect =    aspect ratio (width / height)
///     near =      position of the near plane
///     far =       position of the far plane
/// Returns: a matrix that maps from eye space to clip space. To obtain NDC, the vector must be divided by w.
Mat4!T perspective_RH_M11(T)(in T fovx, in T aspect, in T near, in T far)
if (isFloatingPoint!T)
{
    import std.math : PI, tan;
    const r = cast(T)(near * tan(fovx * PI / T(360)));
    const t = r / aspect;
    return frustum_RH_M11(-r, r, -t, t, near, far);
}

///
unittest {
    const m = perspective_RH_M11!float(90, 2, 2, 4);
    const vl = fvec(-2, -1, -2);
    const vh = fvec(4, 2, -4);
    const vc = fvec(0, 0, -3);

    auto toNdc(in FVec3 v) {
        const clip = m * fvec(v, 1);
        return (clip / clip.w).xyz;
    }

    import gfx.math.approx : approxUlp;
    assert(approxUlp( toNdc(vl), fvec(-1, 1, -1) ));
    assert(approxUlp( toNdc(vh), fvec(1, -1, 1) ));
    assert(approxUlp( toNdc(vc), fvec(0, 0, 1f/3f) ));
}


/// Build a perspective projection matrix with left-hand NDC and [0 .. 1] depth clipping
/// Params:
///     fovx =      horizontal field of view in degrees
///     aspect =    aspect ratio (width / height)
///     near =      position of the near plane
///     far =       position of the far plane
/// Returns: a matrix that maps from eye space to clip space. To obtain NDC, the vector must be divided by w.
Mat4!T perspective_LH_01(T)(in T fovx, in T aspect, in T near, in T far)
if (isFloatingPoint!T)
{
    import std.math : PI, tan;
    const r = cast(T)(near * tan(fovx * PI / T(360)));
    const t = r / aspect;
    return frustum_LH_01(-r, r, -t, t, near, far);
}

///
unittest {
    const m = perspective_LH_01!float(90, 2, 2, 4);
    const vl = fvec(-2, -1, -2);
    const vh = fvec(4, 2, -4);
    const vc = fvec(0, 0, -3);

    auto toNdc(in FVec3 v) {
        const clip = m * fvec(v, 1);
        return (clip / clip.w).xyz;
    }

    import gfx.math.approx : approxUlp;
    assert(approxUlp( toNdc(vl), fvec(-1, -1, 0) ));
    assert(approxUlp( toNdc(vh), fvec(1, 1, 1) ));
    assert(approxUlp( toNdc(vc), fvec(0, 0, 2f/3f) ));
}


/// Build a perspective projection matrix with left-hand NDC and [-1 .. 1] depth clipping
/// Params:
///     fovx =      horizontal field of view in degrees
///     aspect =    aspect ratio (width / height)
///     near =      position of the near plane
///     far =       position of the far plane
/// Returns: a matrix that maps from eye space to clip space. To obtain NDC, the vector must be divided by w.
Mat4!T perspective_LH_M11(T)(in T fovx, in T aspect, in T near, in T far)
if (isFloatingPoint!T)
{
    import std.math : PI, tan;
    const r = cast(T)(near * tan(fovx * PI / T(360)));
    const t = r / aspect;
    return frustum_LH_M11(-r, r, -t, t, near, far);
}

///
unittest {
    const m = perspective_LH_M11!float(90, 2, 2, 4);
    const vl = fvec(-2, -1, -2);
    const vh = fvec(4, 2, -4);
    const vc = fvec(0, 0, -3);

    auto toNdc(in FVec3 v) {
        const clip = m * fvec(v, 1);
        return (clip / clip.w).xyz;
    }

    import gfx.math.approx : approxUlp;
    assert(approxUlp( toNdc(vl), fvec(-1, -1, -1) ));
    assert(approxUlp( toNdc(vh), fvec(1, 1, 1) ));
    assert(approxUlp( toNdc(vc), fvec(0, 0, 1f/3f) ));
}


/// Build an perspective projection matrix with NDC set at compile-time.
template perspectiveCT(NDC ndc)
{
    static if (ndc == NDC.RH_01) {
        alias perspectiveCT = perspective_RH_01;
    }
    else static if (ndc == NDC.RH_M11) {
        alias perspectiveCT = perspective_RH_M11;
    }
    else static if (ndc == NDC.LH_01) {
        alias perspectiveCT = perspective_LH_01;
    }
    else static if (ndc == NDC.LH_M11) {
        alias perspectiveCT = perspective_LH_M11;
    }
    else {
        static assert(false);
    }
}

/// Build a perspective projection matrix with default NDC and DepthClip
/// Params:
///     fovx =      horizontal field of view in degrees
///     aspect =    aspect ratio (width / height)
///     near =      position of the near plane
///     far =       position of the far plane
/// Returns: a matrix that maps from eye space to clip space. To obtain NDC, the vector must be divided by w.
alias defPerspective = perspectiveCT!(defNdc);

/// Build a perspective projection matrix with NDC selected at run-time.
/// Params:
///     ndc =       the target NDC
///     fovx =      horizontal field of view in degrees
///     aspect =    aspect ratio (width / height)
///     near =      position of the near plane
///     far =       position of the far plane
/// Returns: a matrix that maps from eye space to clip space. To obtain NDC, the vector must be divided by w.
Mat4!T perspective(T)(NDC ndc, in T fovx, in T aspect, in T near, in T far)
{
    final switch (ndc)
    {
    case NDC.RH_01:
        return perspective_RH_01(fovx, aspect, near, far);
    case NDC.RH_M11:
        return perspective_RH_M11(fovx, aspect, near, far);
    case NDC.LH_01:
        return perspective_LH_01(fovx, aspect, near, far);
    case NDC.LH_M11:
        return perspective_LH_M11(fovx, aspect, near, far);
    }
}


private:

version(GfxMathDepthMinusOneToOne) {
    enum defZClip = ZClip.minusOneToOne;
}
else {
    enum defZClip = ZClip.zeroToOne;
}

version(GfxMathLeftHandNDC) {
    enum defXYClip = XYClip.leftHand;
}
else {
    enum defXYClip = XYClip.rightHand;
}

enum defNdc = ndc(defXYClip, defZClip);
