/// Affine geometric transformation module
module gfx.math.transform;

import gfx.math.vec;
import gfx.math.mat;
import gfx.foundation.util : staticRange;
version (unittest)
{
    import gfx.math.approx;
}

import std.traits;
import std.meta;
import std.typecons : Flag, Yes, No;

/// Build a translation matrix.
auto translation(X, Y)(in X x, in Y y)
{
    alias ResMat = Mat3x3!(CommonType!(X, Y));
    return ResMat(
        1, 0, x,
        0, 1, y,
        0, 0, 1,
    );
}

/// ditto
Mat3x3!T translation(T)(in Vec2!T v)
{
    return Mat3x3!T (
        1, 0, v.x,
        0, 1, v.y,
        0, 0, 1,
    );
}

/// ditto
auto translation(X, Y, Z)(in X x, in Y y, in Z z)
{
    alias ResMat = Mat4x4!(CommonType!(X, Y, Z));
    return ResMat(
        1, 0, 0, x,
        0, 1, 0, y,
        0, 0, 1, z,
        0, 0, 0, 1,
    );
}

/// ditto
Mat4x4!T translation(T)(in Vec3!T v)
{
    return Mat4x4!T (
        1, 0, 0, v.x,
        0, 1, 0, v.y,
        0, 0, 1, v.z,
        0, 0, 0, 1,
    );
}

unittest
{
    immutable v2 = dvec(4, 6);
    assert( approxUlp(translation(2, 7) * dvec(v2, 1), dvec(6, 13, 1)) );

    immutable v3 = dvec(5, 6, 7);
    assert( approxUlp(translation(7, 4, 1) * dvec(v3, 1), dvec(12, 10, 8, 1)) );
}

/// Append a translation transform inferred from arguments to the matrix m.
/// This is equivalent to the expression $(D_CODE translation(...) * m)
/// but actually save computation by knowing
/// where the ones and zeros are in a pure translation matrix.
M translate(M, X, Y)(in M m, in X x, in Y y)
if (isMat!(3, 3, M) && allSatisfy!(isNumeric, X, Y))
{
    return M (
        // row 1
        m.ctComp!(0, 0) + m.ctComp!(2, 0) * x,
        m.ctComp!(0, 1) + m.ctComp!(2, 1) * x,
        m.ctComp!(0, 2) + m.ctComp!(2, 2) * x,
        // row 2
        m.ctComp!(1, 0) + m.ctComp!(2, 0) * y,
        m.ctComp!(1, 1) + m.ctComp!(2, 1) * y,
        m.ctComp!(1, 2) + m.ctComp!(2, 2) * y,
        // row 3
        m.ctComp!(2, 0), m.ctComp!(2, 1), m.ctComp!(2, 2)
    );
}

/// ditto
M translate(M, X, Y)(in M m, in X x, in Y y)
if (isMat!(2, 3, M) && allSatisfy!(isNumeric, X, Y))
{
    return M (
        // row 1
        m.ctComp!(0, 0),
        m.ctComp!(0, 1),
        m.ctComp!(0, 2) + x,
        // row 2
        m.ctComp!(1, 0),
        m.ctComp!(1, 1),
        m.ctComp!(1, 2) + y,
    );
}

/// ditto
M translate(M, V)(in M m, in V v)
if ((isMat!(2, 3, M) || isMat!(3, 3, M)) && isVec!(2, V))
{
    return translate (m, v[0] ,v[1]);
}

/// ditto
M translate (M, X, Y, Z)(in M m, in X x, in Y y, in Z z)
if (isMat!(4, 4, M) && allSatisfy!(isNumeric, X, Y, Z))
{
    return M (
        // row 1
        m.ctComp!(0, 0) + m.ctComp!(3, 0) * x,
        m.ctComp!(0, 1) + m.ctComp!(3, 1) * x,
        m.ctComp!(0, 2) + m.ctComp!(3, 2) * x,
        m.ctComp!(0, 3) + m.ctComp!(3, 3) * x,
        // row 2
        m.ctComp!(1, 0) + m.ctComp!(3, 0) * y,
        m.ctComp!(1, 1) + m.ctComp!(3, 1) * y,
        m.ctComp!(1, 2) + m.ctComp!(3, 2) * y,
        m.ctComp!(1, 3) + m.ctComp!(3, 3) * y,
        // row 3
        m.ctComp!(2, 0) + m.ctComp!(3, 0) * z,
        m.ctComp!(2, 1) + m.ctComp!(3, 1) * z,
        m.ctComp!(2, 2) + m.ctComp!(3, 2) * z,
        m.ctComp!(2, 3) + m.ctComp!(3, 3) * z,
        // row 4
        m.ctComp!(3, 0), m.ctComp!(3, 1), m.ctComp!(3, 2), m.ctComp!(3, 3)
    );
}

/// ditto
M translate (M, X, Y, Z)(in M m, in X x, in Y y, in Z z)
if (isMat!(3, 4, M) && allSatisfy!(isNumeric, X, Y, Z))
{
    return M (
        // row 1
        m.ctComp!(0, 0) + m.ctComp!(3, 0) * x,
        m.ctComp!(0, 1) + m.ctComp!(3, 1) * x,
        m.ctComp!(0, 2) + m.ctComp!(3, 2) * x,
        m.ctComp!(0, 3) + m.ctComp!(3, 3) * x,
        // row 2
        m.ctComp!(1, 0) + m.ctComp!(3, 0) * y,
        m.ctComp!(1, 1) + m.ctComp!(3, 1) * y,
        m.ctComp!(1, 2) + m.ctComp!(3, 2) * y,
        m.ctComp!(1, 3) + m.ctComp!(3, 3) * y,
        // row 3
        m.ctComp!(2, 0) + m.ctComp!(3, 0) * z,
        m.ctComp!(2, 1) + m.ctComp!(3, 1) * z,
        m.ctComp!(2, 2) + m.ctComp!(3, 2) * z,
        m.ctComp!(2, 3) + m.ctComp!(3, 3) * z,
    );
}

/// ditto
M translate(M, V)(in M m, in V v)
if ((isMat!(3, 4, M) || isMat!(4, 4, M)) && isVec!(3, V))
{
    return translate (m, v[0] ,v[1], v[2]);
}

///
unittest
{
    immutable m = DMat3( 1, 2, 3, 4, 5, 6, 7, 8, 9 );

    immutable expected = translation(7, 12) * m;  // full multiplication
    immutable result = translate(m, 7, 12);       // simplified multiplication

    assert (approxUlp(expected, result));
}
///
unittest
{
    immutable m = DMat4( 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 );

    immutable expected = translation(7, 12, 18) * m;  // full multiplication
    immutable result = translate(m, 7, 12, 18);       // simplified multiplication

    assert (approxUlp(expected, result));
}


/// Build a pure 3d rotation matrix with angle in radians
auto rotationPure(V) (in real angle, in V axis)
if (isVec!(3, V))
{
    static assert (
        isFloatingPoint!(V.Component),
        "rotationPure must be passed a floating point axis"
    );
    import std.math : cos, sin;
    immutable u = normalize(cast(Vec3!real)axis);
    immutable c = cos(angle);
    immutable s = sin(angle);
    immutable c1 = 1 - c;
    return Mat3x3!(V.Component) (
        // row 1
        c1 * u.x * u.x  +  c,
        c1 * u.x * u.y  -  s * u.z,
        c1 * u.x * u.z  +  s * u.y,
        // row 2
        c1 * u.y * u.x  +  s * u.z,
        c1 * u.y * u.y  +  c,
        c1 * u.y * u.z  -  s * u.x,
        // row 3
        c1 * u.z * u.x  -  s * u.y,
        c1 * u.z * u.y  +  s * u.x,
        c1 * u.z * u.z  +  c,
    );
}

/// Build a rotation matrix.
/// angle in radians.
Mat3x3!T rotation(T) (in real angle)
{
    import std.math : cos, sin;
    immutable c = cast(T) cos(angle);
    immutable s = cast(T) sin(angle);
    return Mat3x3!T (
        c, -s, 0,
        s, c, 0,
        0, 0, 1
    );
}

/// ditto
auto rotation(V) (in real angle, in V axis)
if (isVec!(3, V) && isFloatingPoint!(V.Component))
{
    static assert (
        isFloatingPoint!(V.Component),
        "rotation must be passed a floating point axis"
    );
    immutable m = rotationPure(angle, axis);
    return mat(
        vec(m.ctRow!0, 0),
        vec(m.ctRow!1, 0),
        vec(m.ctRow!2, 0),
        vec(0, 0,  0,  1)
    );
}

/// ditto
auto rotation(X, Y, Z) (in real angle, in X x, in Y y, in Z z)
if (allSatisfy!(isNumeric, X, Y, Z))
{
    static assert (
        allSatisfy!(isFloatingPoint, X, Y, Z),
        "rotation must be passed a floating point axis"
    );
    return rotation(angle, vec(x, y, z));
}

/// Append a rotation transform inferred from arguments to the matrix m.
/// This is equivalent to the expression $(D_CODE rotation(...) * m)
/// but actually save computation by knowing
/// where the ones and zeros are in a pure rotation matrix.
M rotate (M) (in M m, in real angle)
if (isMat!(3, 3, M))
{
    import std.math : cos, sin;
    immutable c = cos(angle);
    immutable s = sin(angle);
    return M (
        // row 1
        c * m.ctComp!(0, 0) - s * m.ctComp!(1, 0),
        c * m.ctComp!(0, 1) - s * m.ctComp!(1, 1),
        c * m.ctComp!(0, 2) - s * m.ctComp!(1, 2),
        // row 2
        s * m.ctComp!(0, 0) + c * m.ctComp!(1, 0),
        s * m.ctComp!(0, 1) + c * m.ctComp!(1, 1),
        s * m.ctComp!(0, 2) + c * m.ctComp!(1, 2),
        // row 3
        m.ctComp!(2, 0), m.ctComp!(2, 1), m.ctComp!(2, 2)
    );
}

/// ditto
M rotate (M) (in M m, in real angle)
if (isMat!(2, 3, M))
{
    import std.math : cos, sin;
    immutable c = cos(angle);
    immutable s = sin(angle);
    return M (
        // row 1
        c * m.ctComp!(0, 0) - s * m.ctComp!(1, 0),
        c * m.ctComp!(0, 1) - s * m.ctComp!(1, 1),
        c * m.ctComp!(0, 2) - s * m.ctComp!(1, 2),
        // row 2
        s * m.ctComp!(0, 0) + c * m.ctComp!(1, 0),
        s * m.ctComp!(0, 1) + c * m.ctComp!(1, 1),
        s * m.ctComp!(0, 2) + c * m.ctComp!(1, 2)
    );
}

/// ditto
M rotate (M, V) (in M m, in real angle, in V axis)
if (isMat!(4, 4, M) && isVec!(3, V))
{
    static assert (
        allSatisfy!(isFloatingPoint, V.Component),
        "rotate must be passed a floating point axis"
    );
    immutable r = rotationPure(angle, axis);
    return M (
        // row 1
        r.ctComp!(0, 0)*m.ctComp!(0, 0) + r.ctComp!(0, 1)*m.ctComp!(1, 0) + r.ctComp!(0, 2)*m.ctComp!(2, 0),
        r.ctComp!(0, 0)*m.ctComp!(0, 1) + r.ctComp!(0, 1)*m.ctComp!(1, 1) + r.ctComp!(0, 2)*m.ctComp!(2, 1),
        r.ctComp!(0, 0)*m.ctComp!(0, 2) + r.ctComp!(0, 1)*m.ctComp!(1, 2) + r.ctComp!(0, 2)*m.ctComp!(2, 2),
        r.ctComp!(0, 0)*m.ctComp!(0, 3) + r.ctComp!(0, 1)*m.ctComp!(1, 3) + r.ctComp!(0, 2)*m.ctComp!(2, 3),
        // row 2
        r.ctComp!(1, 0)*m.ctComp!(0, 0) + r.ctComp!(1, 1)*m.ctComp!(1, 0) + r.ctComp!(1, 2)*m.ctComp!(2, 0),
        r.ctComp!(1, 0)*m.ctComp!(0, 1) + r.ctComp!(1, 1)*m.ctComp!(1, 1) + r.ctComp!(1, 2)*m.ctComp!(2, 1),
        r.ctComp!(1, 0)*m.ctComp!(0, 2) + r.ctComp!(1, 1)*m.ctComp!(1, 2) + r.ctComp!(1, 2)*m.ctComp!(2, 2),
        r.ctComp!(1, 0)*m.ctComp!(0, 3) + r.ctComp!(1, 1)*m.ctComp!(1, 3) + r.ctComp!(1, 2)*m.ctComp!(2, 3),
        // row 3
        r.ctComp!(2, 0)*m.ctComp!(0, 0) + r.ctComp!(2, 1)*m.ctComp!(1, 0) + r.ctComp!(2, 2)*m.ctComp!(2, 0),
        r.ctComp!(2, 0)*m.ctComp!(0, 1) + r.ctComp!(2, 1)*m.ctComp!(1, 1) + r.ctComp!(2, 2)*m.ctComp!(2, 1),
        r.ctComp!(2, 0)*m.ctComp!(0, 2) + r.ctComp!(2, 1)*m.ctComp!(1, 2) + r.ctComp!(2, 2)*m.ctComp!(2, 2),
        r.ctComp!(2, 0)*m.ctComp!(0, 3) + r.ctComp!(2, 1)*m.ctComp!(1, 3) + r.ctComp!(2, 2)*m.ctComp!(2, 3),
        // row 4
        m.ctComp!(3, 0), m.ctComp!(3, 1), m.ctComp!(3, 2), m.ctComp!(3, 3)
    );
}

/// ditto
M rotate (M, V) (in M m, in real angle, in V axis)
if (isMat!(3, 4, M) && isVec!(3, V) && isFloatingPoint!(V.Component))
{
    static assert (
        isFloatingPoint!(V.Component),
        "rotate must be passed a floating point axis"
    );
    immutable r = rotationPure(angle, axis);
    return M (
        // row 1
        r.ctComp!(0, 0)*m.ctComp!(0, 0) + r.ctComp!(0, 1)*m.ctComp!(1, 0) + r.ctComp!(0, 2)*m.ctComp!(2, 0),
        r.ctComp!(0, 0)*m.ctComp!(0, 1) + r.ctComp!(0, 1)*m.ctComp!(1, 1) + r.ctComp!(0, 2)*m.ctComp!(2, 1),
        r.ctComp!(0, 0)*m.ctComp!(0, 2) + r.ctComp!(0, 1)*m.ctComp!(1, 2) + r.ctComp!(0, 2)*m.ctComp!(2, 2),
        r.ctComp!(0, 0)*m.ctComp!(0, 3) + r.ctComp!(0, 1)*m.ctComp!(1, 3) + r.ctComp!(0, 2)*m.ctComp!(2, 3),
        // row 2
        r.ctComp!(1, 0)*m.ctComp!(0, 0) + r.ctComp!(1, 1)*m.ctComp!(1, 0) + r.ctComp!(1, 2)*m.ctComp!(2, 0),
        r.ctComp!(1, 0)*m.ctComp!(0, 1) + r.ctComp!(1, 1)*m.ctComp!(1, 1) + r.ctComp!(1, 2)*m.ctComp!(2, 1),
        r.ctComp!(1, 0)*m.ctComp!(0, 2) + r.ctComp!(1, 1)*m.ctComp!(1, 2) + r.ctComp!(1, 2)*m.ctComp!(2, 2),
        r.ctComp!(1, 0)*m.ctComp!(0, 3) + r.ctComp!(1, 1)*m.ctComp!(1, 3) + r.ctComp!(1, 2)*m.ctComp!(2, 3),
        // row 3
        r.ctComp!(2, 0)*m.ctComp!(0, 0) + r.ctComp!(2, 1)*m.ctComp!(1, 0) + r.ctComp!(2, 2)*m.ctComp!(2, 0),
        r.ctComp!(2, 0)*m.ctComp!(0, 1) + r.ctComp!(2, 1)*m.ctComp!(1, 1) + r.ctComp!(2, 2)*m.ctComp!(2, 1),
        r.ctComp!(2, 0)*m.ctComp!(0, 2) + r.ctComp!(2, 1)*m.ctComp!(1, 2) + r.ctComp!(2, 2)*m.ctComp!(2, 2),
        r.ctComp!(2, 0)*m.ctComp!(0, 3) + r.ctComp!(2, 1)*m.ctComp!(1, 3) + r.ctComp!(2, 2)*m.ctComp!(2, 3),
    );
}

/// ditto
M rotate (M, X, Y, Z) (in M m, in real angle, in X x, in Y y, in Z z)
if ((isMat!(3, 4, M) || isMat!(4, 4, M)) && allSatisfy!(isFloatingPoint, X, Y, Z))
{
    return rotate(m, angle, vec(x, y, z));
}

///
unittest
{
    import std.math : PI;
    immutable m = DMat3( 1, 2, 3, 4, 5, 6, 7, 8, 9 );

    immutable expected = rotation!double(PI) * m; // full multiplication
    immutable result = rotate(m, PI);      // simplified multiplication

    assert (approxUlp(expected, result));
}
///
unittest
{
    import std.math : PI;
    immutable m = DMat4( 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 );
    immutable angle = PI;
    immutable v = fvec(3, 4, 5);

    immutable expected = rotation(angle, v) * m; // full multiplication
    immutable result = rotate(m, angle, v);      // simplified multiplication

    assert (approxUlp(expected, result));
}


/// Build a scale matrix.
Mat3!(CommonType!(X, Y)) scale(X, Y) (in X x, in Y y)
if (allSatisfy!(isNumeric, X, Y))
{
    return Mat3!(CommonType!(X, Y))(
        x, 0, 0,
        0, y, 0,
        0, 0, 1,
    );
}

/// ditto
Mat3!T scale(T) (in Vec2!T v)
{
    return Mat3!T (
        v.x, 0, 0,
        0, v.y, 0,
        0, 0, 1,
    );
}

/// ditto
Mat4!(CommonType!(X, Y, Z)) scale (X, Y, Z) (in X x, in Y y, in Z z)
if (allSatisfy!(isNumeric, X, Y, Z))
{
    return Mat4!(CommonType!(X, Y, Z))(
        x, 0, 0, 0,
        0, y, 0, 0,
        0, 0, z, 0,
        0, 0, 0, 1,
    );
}

/// ditto
Mat4!T scale(T) (in Vec3!T v)
{
    return Mat4!T (
        v.x, 0, 0, 0,
        0, v.y, 0, 0,
        0, 0, v.z, 0,
        0, 0, 0, 1,
    );
}

/// Append a scale transform inferred from arguments to the matrix m.
/// This is equivalent to the expression $(D_CODE scale(...) * m)
/// but actually save computation by knowing
/// where the ones and zeros are in a pure scale matrix.
M scale (M, X, Y)(in M m, in X x, in Y y)
if (isMat!(3, 3, M) && allSatisfy!(isNumeric, X, Y))
{
    return M (
        // row 1
        m.ctComp!(0, 0) * x,
        m.ctComp!(0, 1) * x,
        m.ctComp!(0, 2) * x,
        // row 2
        m.ctComp!(1, 0) * y,
        m.ctComp!(1, 1) * y,
        m.ctComp!(1, 2) * y,
        // row 3
        m.ctComp!(2, 0), m.ctComp!(2, 1), m.ctComp!(2, 2)
    );
}

/// ditto
M scale (M, X, Y)(in M m, in X x, in Y y)
if (isMat!(2, 3, M) && allSatisfy!(isNumeric, X, Y))
{
    return M (
        // row 1
        m.ctComp!(0, 0) * x,
        m.ctComp!(0, 1) * x,
        m.ctComp!(0, 2) * x,
        // row 2
        m.ctComp!(1, 0) * y,
        m.ctComp!(1, 1) * y,
        m.ctComp!(1, 2) * y,
    );
}

/// ditto
M scale (M, V)(in M m, in V v)
if ((isMat!(2, 3, M) || isMat!(3, 3, M)) && isVec!(2, V))
{
    return scale(m, v[0], v[1]);
}

/// ditto
M scale (M, X, Y, Z)(in M m, in X x, in Y y, in Z z)
if (isMat!(4, 4, M) && allSatisfy!(isNumeric, X, Y, Z))
{
    return M (
        // row 1
        m.ctComp!(0, 0) * x,
        m.ctComp!(0, 1) * x,
        m.ctComp!(0, 2) * x,
        m.ctComp!(0, 3) * x,
        // row 2
        m.ctComp!(1, 0) * y,
        m.ctComp!(1, 1) * y,
        m.ctComp!(1, 2) * y,
        m.ctComp!(1, 3) * y,
        // row 3
        m.ctComp!(2, 0) * z,
        m.ctComp!(2, 1) * z,
        m.ctComp!(2, 2) * z,
        m.ctComp!(2, 3) * z,
        // row 4
        m.ctComp!(3, 0), m.ctComp!(3, 1), m.ctComp!(3, 2), m.ctComp!(3, 3)
    );
}

/// ditto
M scale (M, X, Y, Z)(in M m, in X x, in Y y, in Z z)
if (isMat!(3, 4, M) && allSatisfy!(isNumeric, X, Y, Z))
{
    return M (
        // row 1
        m.ctComp!(0, 0) * x,
        m.ctComp!(0, 1) * x,
        m.ctComp!(0, 2) * x,
        m.ctComp!(0, 3) * x,
        // row 2
        m.ctComp!(1, 0) * y,
        m.ctComp!(1, 1) * y,
        m.ctComp!(1, 2) * y,
        m.ctComp!(1, 3) * y,
        // row 3
        m.ctComp!(2, 0) * z,
        m.ctComp!(2, 1) * z,
        m.ctComp!(2, 2) * z,
        m.ctComp!(2, 3) * z,
    );
}

/// ditto
M scale (M, V)(in M m, in V v)
if ((isMat!(3, 4, M) || isMat!(4, 4, M)) && isVec!(3, V))
{
    return scale(m, v[0], v[1], v[2]);
}


///
unittest
{
    immutable m = DMat3( 1, 2, 3, 4, 5, 6, 7, 8, 9 );

    immutable expected = scale(4, 5) * m; // full multiplication
    immutable result = scale(m, 4, 5);   // simplified multiplication

    assert (approxUlp(expected, result));
}
///
unittest
{
    immutable m = DMat4( 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 );

    immutable expected = scale(4, 5, 6) * m; // full multiplication
    immutable result = scale(m, 4, 5, 6);   // simplified multiplication

    assert (approxUlp(expected, result));
}

/// Affine matrix multiplication.
///
/// Perform a multiplication of two 2x3 or two 3x4 matrices as if their last row
/// were [ 0, 0, 1] or [ 0, 0, 0, 1 ].
/// Allows manipulation of smaller matrices when only affine transformation are
/// required.
/// Note: translation, rotation, scaling, shearing and any combination of those
/// are affine transforms. Projection is not affine.
/// I.e. for 2D, an affine transform is held in 2x3 matrix, 2x2 for rotation and
/// scaling and an additional column for translation.
/// The same applies with 3D and 3x4 matrices.
///
/// This is not implemented as an operator as it is not a mathematical
/// operation (ml.columnLength != mr.rowLength).
auto affineMult(ML, MR)(in ML ml, in MR mr)
if (areMat!(2, 3, ML, MR) || areMat!(3, 4, ML, MR))
{
    alias Comp = CommonType!(ML.Component, MR.Component);
    enum rowLength = ML.rowLength;
    enum columnLength = ML.columnLength;
    alias ResMat = Mat!(Comp, rowLength, columnLength);

    ResMat res = void;
    foreach(r; staticRange!(0, rowLength))
    {
        foreach (c; staticRange!(0, columnLength))
        {
            Comp resComp = 0;
            foreach (rc; staticRange!(0, rowLength)) // that is columnCount-1
            {
                resComp += ml.ctComp!(r, rc) * mr.ctComp!(rc, c);
            }
            static if (c == columnLength-1)
            {
                resComp += ml.ctComp!(r, c); // that is the last one in the last row
            }
            res.ctComp!(r, c) = resComp;
        }
    }
    return res;
}

///
unittest
{
    /// full matrices
    immutable fm1 = FMat3x3(
        1, 2, 3,
        4, 5, 6,
        0, 0, 1
    );
    immutable fm2 = DMat3x3(
         7,  8,  9,
        10, 11, 12,
         0,  0,  1
    );

    /// affine matrices
    immutable am1 = FMat2x3(
        1, 2, 3,
        4, 5, 6,
    );
    immutable am2 = DMat2x3(
         7,  8,  9,
        10, 11, 12,
    );

    immutable expected = (fm1 * fm2).ctSlice!(0, 2, 0, 3);
    immutable result = affineMult(am1, am2);
    assert( approxUlp(expected, result) );
}


/// Transform a vector by a matrix in homogenous coordinates.
auto transform(V, M)(in V v, in M m)
if (isVec!(2, V) && isMat!(3, 3, M))
{
    return (m * vec(v, 1)).xy;
}
/// ditto
auto transform(V, M)(in V v, in M m)
if (isVec!(2, V) && isMat!(2, 3, M))
{
    return m * vec(v, 1);
}
/// ditto
auto transform(V, M)(in V v, in M m)
if (isVec!(3, V) && isMat!(4, 4, M))
{
    return (m * vec(v, 1)).xyz;
}
/// ditto
auto transform(V, M)(in V v, in M m)
if (isVec!(3, V) && isMat!(3, 4, M))
{
    return m * vec(v, 1);
}

unittest
{
    // 2x3 matrix can hold affine 2D transforms
    immutable transl = DMat2x3(
        1, 0, 3,
        0, 1, 2,
    );
    assert( approxUlp(transform(dvec(3, 5), transl), dvec(6, 7)) );
}

///
unittest
{
    import std.math : PI;
    immutable v = dvec(2, 0);
    auto m = DMat2x3.identity;

    m = m.rotate(PI/2);
    assert ( approxUlpAndAbs(transform(v, m), dvec(0, 2)) );

    m = m.translate(2, 2);
    assert ( approxUlp(transform(v, m), dvec(2, 4)) );

    m = m.scale(2, 2);
    assert ( approxUlp(transform(v, m), dvec(4, 8)) );
}
