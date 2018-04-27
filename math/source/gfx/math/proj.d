/// Projection matrices
module gfx.math.proj;

import gfx.math.mat;
import gfx.math.vec;
import std.traits : isFloatingPoint;

/// Determines whether the default projection matrices will project to a clip space
/// whose depth range is [0 .. 1] or [-1 .. 1].
/// Default is [0 .. 1] but can be changed by setting version(GfxMathDepthMinusOneToOne)
enum DepthClip {
    zeroToOne,
    minusOneToOne,
}

/// Determines whether the default projection matrices will project to a clip space
/// where Y points upwards (left hand NDC) or downwards (right hand NDC)
/// Default is right hand NDC, but can be changed by setting version(GfxMathLeftHandNDC)
enum NDC {
    rightHand,
    leftHand,
}


/// Build an orthographic projection matrix with right-hand NDC and [0 .. 1] depth clipping
/// Params:
///     l:      X position of the left plane
///     r:      X position of the right plane
///     b:      Y position of the bottom plane
///     t:      Y position of the top plane
///     n:      distance from origin to near plane (in Z-)
///     f:      distance from origin to far plane (in Z-)
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
///     l:      X position of the left plane
///     r:      X position of the right plane
///     b:      Y position of the bottom plane
///     t:      Y position of the top plane
///     n:      distance from origin to near plane (in Z-)
///     f:      distance from origin to far plane (in Z-)
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
///     l:      X position of the left plane
///     r:      X position of the right plane
///     b:      Y position of the bottom plane
///     t:      Y position of the top plane
///     n:      distance from origin to near plane (in Z-)
///     f:      distance from origin to far plane (in Z-)
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
///     l:      X position of the left plane
///     r:      X position of the right plane
///     b:      Y position of the bottom plane
///     t:      Y position of the top plane
///     n:      distance from origin to near plane (in Z-)
///     f:      distance from origin to far plane (in Z-)
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

/// Build an orthographic projection matrix with NDC and DepthClip set with compile-time params.
/// Params:
///     l:      X position of the left plane
///     r:      X position of the right plane
///     b:      Y position of the bottom plane
///     t:      Y position of the top plane
///     n:      distance from origin to near plane (in Z-)
///     f:      distance from origin to far plane (in Z-)
/// Returns: an affine matrix that maps from eye coordinates to NDC.
template orthoCT(NDC ndc, DepthClip dc)
{
    static if (ndc == NDC.rightHand && dc == DepthClip.zeroToOne) {
        alias orthoCT = ortho_RH_01;
    }
    else static if (ndc == NDC.rightHand && dc == DepthClip.minusOneToOne) {
        alias orthoCT = ortho_RH_M11;
    }
    else static if (ndc == NDC.leftHand && dc == DepthClip.zeroToOne) {
        alias orthoCT = ortho_LH_01;
    }
    else static if (ndc == NDC.leftHand && dc == DepthClip.minusOneToOne) {
        alias orthoCT = ortho_LH_M11;
    }
    else {
        static assert(false);
    }
}

/// Build an orthographic projection matrix with default NDC and DepthClip
/// Params:
///     l:      X position of the left plane
///     r:      X position of the right plane
///     b:      Y position of the bottom plane
///     t:      Y position of the top plane
///     n:      distance from origin to near plane (in Z-)
///     f:      distance from origin to far plane (in Z-)
/// Returns: an affine matrix that maps from eye coordinates to NDC.
alias ortho = orthoCT!(defNdc, defDepthClip);

/// Build an orthographic projection matrix with NDC and DepthClip selected at runtime
/// Params:
///     ndc:    the target NDC
///     dc:     the target depth clipping mode
///     l:      X position of the left plane
///     r:      X position of the right plane
///     b:      Y position of the bottom plane
///     t:      Y position of the top plane
///     n:      distance from origin to near plane (in Z-)
///     f:      distance from origin to far plane (in Z-)
/// Returns: an affine matrix that maps from eye coordinates to NDC.
Mat4!T orthoRT(T)(NDC ndc, DepthClip dc, in T l, in T r, in T b, in T t, in T n, in T f)
{
    if (ndc == NDC.rightHand && dc == DepthClip.zeroToOne) {
        return ortho_RH_01(l, r, b, t, n, f);
    }
    else if (ndc == NDC.rightHand && dc == DepthClip.minusOneToOne) {
        return ortho_RH_M11(l, r, b, t, n, f);
    }
    else if (ndc == NDC.leftHand && dc == DepthClip.zeroToOne) {
        return ortho_LH_01(l, r, b, t, n, f);
    }
    else if (ndc == NDC.leftHand && dc == DepthClip.minusOneToOne) {
        return ortho_LH_M11(l, r, b, t, n, f);
    }
    else {
        assert(false);
    }
}

/// Build a perspective projection matrix with right-hand NDC and [0 .. 1] depth clipping
/// Params:
///     l:      X position of the left edge at the near plane
///     r:      X position of the right edge at the near plane
///     b:      Y position of the bottom edge at the near plane
///     t:      Y position of the top edge at the near plane
///     n:      distance from origin to near plane (in Z-)
///     f:      distance from origin to far plane (in Z-)
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
///     l:      X position of the left edge at the near plane
///     r:      X position of the right edge at the near plane
///     b:      Y position of the bottom edge at the near plane
///     t:      Y position of the top edge at the near plane
///     n:      distance from origin to near plane (in Z-)
///     f:      distance from origin to far plane (in Z-)
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
///     l:      X position of the left edge at the near plane
///     r:      X position of the right edge at the near plane
///     b:      Y position of the bottom edge at the near plane
///     t:      Y position of the top edge at the near plane
///     n:      distance from origin to near plane (in Z-)
///     f:      distance from origin to far plane (in Z-)
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
///     l:      X position of the left edge at the near plane
///     r:      X position of the right edge at the near plane
///     b:      Y position of the bottom edge at the near plane
///     t:      Y position of the top edge at the near plane
///     n:      distance from origin to near plane (in Z-)
///     f:      distance from origin to far plane (in Z-)
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


/// Build an frustum perspective projection matrix with NDC and DepthClip set with compile-time params.
/// Params:
///     l:      X position of the left edge at the near plane
///     r:      X position of the right edge at the near plane
///     b:      Y position of the bottom edge at the near plane
///     t:      Y position of the top edge at the near plane
///     n:      distance from origin to near plane (in Z-)
///     f:      distance from origin to far plane (in Z-)
/// Returns: a matrix that maps from eye space to clip space. To obtain NDC, the vector must be divided by w.
template frustumCT(NDC ndc, DepthClip dc)
{
    static if (ndc == NDC.rightHand && dc == DepthClip.zeroToOne) {
        alias frustumCT = frustum_RH_01;
    }
    else static if (ndc == NDC.rightHand && dc == DepthClip.minusOneToOne) {
        alias frustumCT = frustum_RH_M11;
    }
    else static if (ndc == NDC.leftHand && dc == DepthClip.zeroToOne) {
        alias frustumCT = frustum_LH_01;
    }
    else static if (ndc == NDC.leftHand && dc == DepthClip.minusOneToOne) {
        alias frustumCT = frustum_LH_M11;
    }
    else {
        static assert(false);
    }
}

/// Build an frustum perspective projection matrix with default NDC and DepthClip
/// Params:
///     l:      X position of the left edge at the near plane
///     r:      X position of the right edge at the near plane
///     b:      Y position of the bottom edge at the near plane
///     t:      Y position of the top edge at the near plane
///     n:      distance from origin to near plane (in Z-)
///     f:      distance from origin to far plane (in Z-)
/// Returns: a matrix that maps from eye space to clip space. To obtain NDC, the vector must be divided by w.
alias frustum = frustumCT!(defNdc, defDepthClip);

/// Build an frustum perspective projection matrix with NDC and DepthClip selected at runtime
/// Params:
///     ndc:    the target NDC
///     dc:     the target depth clipping mode
///     l:      X position of the left edge at the near plane
///     r:      X position of the right edge at the near plane
///     b:      Y position of the bottom edge at the near plane
///     t:      Y position of the top edge at the near plane
///     n:      distance from origin to near plane (in Z-)
///     f:      distance from origin to far plane (in Z-)
/// Returns: a matrix that maps from eye space to clip space. To obtain NDC, the vector must be divided by w.
Mat4!T frustumRT(T)(NDC ndc, DepthClip dc, in T l, in T r, in T b, in T t, in T n, in T f)
{
    if (ndc == NDC.rightHand && dc == DepthClip.zeroToOne) {
        return frustum_RH_01(l, r, b, t, n, f);
    }
    else if (ndc == NDC.rightHand && dc == DepthClip.minusOneToOne) {
        return frustum_RH_M11(l, r, b, t, n, f);
    }
    else if (ndc == NDC.leftHand && dc == DepthClip.zeroToOne) {
        return frustum_LH_01(l, r, b, t, n, f);
    }
    else if (ndc == NDC.leftHand && dc == DepthClip.minusOneToOne) {
        return frustum_LH_M11(l, r, b, t, n, f);
    }
    else {
        assert(false);
    }
}

/// Build a perspective projection matrix with right-hand NDC and [0 .. 1] depth clipping
/// Params:
///     fovx:   horizontal field of view in degrees
///     aspect: aspect ratio (width / height)
///     near:   position of the near plane
///     far:    position of the far plane
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
///     fovx:   horizontal field of view in degrees
///     aspect: aspect ratio (width / height)
///     near:   position of the near plane
///     far:    position of the far plane
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
///     fovx:   horizontal field of view in degrees
///     aspect: aspect ratio (width / height)
///     near:   position of the near plane
///     far:    position of the far plane
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
///     fovx:   horizontal field of view in degrees
///     aspect: aspect ratio (width / height)
///     near:   position of the near plane
///     far:    position of the far plane
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


/// Build an perspectivegraphic projection matrix with NDC and DepthClip set with compile-time params.
/// Params:
///     fovx:   horizontal field of view in degrees
///     aspect: aspect ratio (width / height)
///     near:   position of the near plane
///     far:    position of the far plane
/// Returns: a matrix that maps from eye space to clip space. To obtain NDC, the vector must be divided by w.
template perspectiveCT(NDC ndc, DepthClip dc)
{
    static if (ndc == NDC.rightHand && dc == DepthClip.zeroToOne) {
        alias perspectiveCT = perspective_RH_01;
    }
    else static if (ndc == NDC.rightHand && dc == DepthClip.minusOneToOne) {
        alias perspectiveCT = perspective_RH_M11;
    }
    else static if (ndc == NDC.leftHand && dc == DepthClip.zeroToOne) {
        alias perspectiveCT = perspective_LH_01;
    }
    else static if (ndc == NDC.leftHand && dc == DepthClip.minusOneToOne) {
        alias perspectiveCT = perspective_LH_M11;
    }
    else {
        static assert(false);
    }
}

/// Build a perspective projection matrix with default NDC and DepthClip
/// Params:
///     fovx:   horizontal field of view in degrees
///     aspect: aspect ratio (width / height)
///     near:   position of the near plane
///     far:    position of the far plane
/// Returns: a matrix that maps from eye space to clip space. To obtain NDC, the vector must be divided by w.
alias perspective = perspectiveCT!(defNdc, defDepthClip);

/// Build a perspective projection matrix with NDC and DepthClip selected at run-time.
/// Params:
///     ndc:    the target NDC
///     dc:     the target depth clipping mode
///     fovx:   horizontal field of view in degrees
///     aspect: aspect ratio (width / height)
///     near:   position of the near plane
///     far:    position of the far plane
/// Returns: a matrix that maps from eye space to clip space. To obtain NDC, the vector must be divided by w.
Mat4!T perspectiveRT(T)(NDC ndc, DepthClip dc, in T l, in T r, in T b, in T t, in T n, in T f)
{
    if (ndc == NDC.rightHand && dc == DepthClip.zeroToOne) {
        return perspective_RH_01(l, r, b, t, n, f);
    }
    else if (ndc == NDC.rightHand && dc == DepthClip.minusOneToOne) {
        return perspective_RH_M11(l, r, b, t, n, f);
    }
    else if (ndc == NDC.leftHand && dc == DepthClip.zeroToOne) {
        return perspective_LH_01(l, r, b, t, n, f);
    }
    else if (ndc == NDC.leftHand && dc == DepthClip.minusOneToOne) {
        return perspective_LH_M11(l, r, b, t, n, f);
    }
    else {
        assert(false);
    }
}


private:

version(GfxMathDepthMinusOneToOne) {
    enum defDepthClip = DepthClip.minusOneToOne;
}
else {
    enum defDepthClip = DepthClip.zeroToOne;
}

version(GfxMathLeftHandNDC) {
    enum defNdc = NDC.leftHand;
}
else {
    enum defNdc = NDC.rightHand;
}

