/// Affine transforms module
module gfx.math.transform;

import gfx.math.mat;
import gfx.math.vec;
import std.meta : allSatisfy;
import std.traits : CommonType, isFloatingPoint, isNumeric;

pure @safe @nogc nothrow:

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
auto translation(V)(in V v) if (isVec2!V)
{
    return Mat3x3!(V.Component) (
        1, 0, v.x,
        0, 1, v.y,
        0, 0, 1,
    );
}

/// ditto
auto affineTranslation(X, Y)(in X x, in Y y)
{
    alias ResMat = Mat2x3!(CommonType!(X, Y));

    return ResMat(
        1, 0, x,
        0, 1, y
    );
}

/// ditto
auto affineTranslation(V)(in V v) if (isVec2!V)
{
    alias ResMat = Mat2x3!(V.Component);

    return ResMat(
        1, 0, v.x,
        0, 1, v.y
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
auto translation(V)(in V v) if (isVec3!V)
{
    return Mat4x4!(V.Component) (
        1, 0, 0, v.x,
        0, 1, 0, v.y,
        0, 0, 1, v.z,
        0, 0, 0, 1,
    );
}

unittest
{
    import gfx.math.approx : approxUlp;

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
        m[0, 0] + m[2, 0] * x,
        m[0, 1] + m[2, 1] * x,
        m[0, 2] + m[2, 2] * x,
        // row 2
        m[1, 0] + m[2, 0] * y,
        m[1, 1] + m[2, 1] * y,
        m[1, 2] + m[2, 2] * y,
        // row 3
        m[2, 0], m[2, 1], m[2, 2]
    );
}

/// ditto
M translate(M, X, Y)(in M m, in X x, in Y y)
if (isMat!(2, 3, M) && allSatisfy!(isNumeric, X, Y))
{
    return M (
        // row 1
        m[0, 0],
        m[0, 1],
        m[0, 2] + x,
        // row 2
        m[1, 0],
        m[1, 1],
        m[1, 2] + y,
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
        m[0, 0] + m[3, 0] * x,
        m[0, 1] + m[3, 1] * x,
        m[0, 2] + m[3, 2] * x,
        m[0, 3] + m[3, 3] * x,
        // row 2
        m[1, 0] + m[3, 0] * y,
        m[1, 1] + m[3, 1] * y,
        m[1, 2] + m[3, 2] * y,
        m[1, 3] + m[3, 3] * y,
        // row 3
        m[2, 0] + m[3, 0] * z,
        m[2, 1] + m[3, 1] * z,
        m[2, 2] + m[3, 2] * z,
        m[2, 3] + m[3, 3] * z,
        // row 4
        m[3, 0], m[3, 1], m[3, 2], m[3, 3]
    );
}

/// ditto
M translate (M, X, Y, Z)(in M m, in X x, in Y y, in Z z)
if (isMat!(3, 4, M) && allSatisfy!(isNumeric, X, Y, Z))
{
    return M (
        // row 1
        m[0, 0] + m[3, 0] * x,
        m[0, 1] + m[3, 1] * x,
        m[0, 2] + m[3, 2] * x,
        m[0, 3] + m[3, 3] * x,
        // row 2
        m[1, 0] + m[3, 0] * y,
        m[1, 1] + m[3, 1] * y,
        m[1, 2] + m[3, 2] * y,
        m[1, 3] + m[3, 3] * y,
        // row 3
        m[2, 0] + m[3, 0] * z,
        m[2, 1] + m[3, 1] * z,
        m[2, 2] + m[3, 2] * z,
        m[2, 3] + m[3, 3] * z,
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
    import gfx.math.approx : approxUlp;

    immutable m = DMat3( 1, 2, 3, 4, 5, 6, 7, 8, 9 );

    immutable expected = translation(7, 12) * m;  // full multiplication
    immutable result = translate(m, 7, 12);       // simplified multiplication

    assert (approxUlp(expected, result));
}
///
unittest
{
    import gfx.math.approx : approxUlp;

    immutable m = DMat4( 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 );

    immutable expected = translation(7, 12, 18) * m;  // full multiplication
    immutable result = translate(m, 7, 12, 18);       // simplified multiplication

    assert (approxUlp(expected, result));
}


/// Build a pure 3d rotation matrix with angle in radians
auto rotationPure(T, V) (in T angle, in V axis)
if (isFloatingPoint!T && isVec!(3, V))
{
    static assert (
        isFloatingPoint!(V.Component),
        "rotationPure must be passed a floating point axis"
    );
    import std.math : cos, sin;
    const u = normalize(axis);
    const c = cos(angle);
    const s = sin(angle);
    const c1 = 1 - c;
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
Mat3x3!T rotation(T) (in T angle) if (isFloatingPoint!T)
{
    import std.math : cos, sin;
    const c = cast(T) cos(angle);
    const s = cast(T) sin(angle);
    return Mat3x3!T (
        c, -s, 0,
        s, c, 0,
        0, 0, 1
    );
}

Mat2x3!T affineRotation(T) (in T angle) if (isFloatingPoint!T)
{
    import std.math : cos, sin;
    const c = cast(T) cos(angle);
    const s = cast(T) sin(angle);
    return Mat2x3!T (
        c, -s, 0,
        s, c, 0,
    );
}

/// ditto
auto rotation(T, V) (in T angle, in V axis)
if (isVec!(3, V) && isFloatingPoint!T)
{
    static assert (
        isFloatingPoint!(V.Component),
        "rotation must be passed a floating point axis"
    );
    const m = rotationPure(angle, axis);
    return mat(
        vec(m[0], 0),
        vec(m[1], 0),
        vec(m[2], 0),
        vec(0, 0,  0,  1)
    );
}

/// ditto
auto rotation(T) (in T angle, in T x, in T y, in T z)
if (isFloatingPoint!T)
{
    return rotation(angle, vec(x, y, z));
}

/// Append a rotation transform inferred from arguments to the matrix m.
/// This is equivalent to the expression $(D_CODE rotation(...) * m)
/// but actually save computation by knowing
/// where the ones and zeros are in a pure rotation matrix.
M rotate (M, T) (in M m, in T angle)
if (isMat!(3, 3, M) && isFloatingPoint!T)
{
    import std.math : cos, sin;
    immutable c = cos(angle);
    immutable s = sin(angle);
    return M (
        // row 1
        c * m[0, 0] - s * m[1, 0],
        c * m[0, 1] - s * m[1, 1],
        c * m[0, 2] - s * m[1, 2],
        // row 2
        s * m[0, 0] + c * m[1, 0],
        s * m[0, 1] + c * m[1, 1],
        s * m[0, 2] + c * m[1, 2],
        // row 3
        m[2, 0], m[2, 1], m[2, 2]
    );
}

/// ditto
M rotate (M, T) (in M m, in T angle)
if (isMat!(2, 3, M) && isFloatingPoint!T)
{
    import std.math : cos, sin;
    immutable c = cos(angle);
    immutable s = sin(angle);
    return M (
        // row 1
        c * m[0, 0] - s * m[1, 0],
        c * m[0, 1] - s * m[1, 1],
        c * m[0, 2] - s * m[1, 2],
        // row 2
        s * m[0, 0] + c * m[1, 0],
        s * m[0, 1] + c * m[1, 1],
        s * m[0, 2] + c * m[1, 2]
    );
}

/// ditto
M rotate (M, T, V) (in M m, in T angle, in V axis)
if (isMat!(4, 4, M) && isFloatingPoint!T && isVec!(3, V))
{
    static assert (
        isFloatingPoint!(V.Component),
        "rotate must be passed a floating point axis"
    );
    immutable r = rotationPure(angle, axis);
    return M (
        // row 1
        r[0, 0]*m[0, 0] + r[0, 1]*m[1, 0] + r[0, 2]*m[2, 0],
        r[0, 0]*m[0, 1] + r[0, 1]*m[1, 1] + r[0, 2]*m[2, 1],
        r[0, 0]*m[0, 2] + r[0, 1]*m[1, 2] + r[0, 2]*m[2, 2],
        r[0, 0]*m[0, 3] + r[0, 1]*m[1, 3] + r[0, 2]*m[2, 3],
        // row 2
        r[1, 0]*m[0, 0] + r[1, 1]*m[1, 0] + r[1, 2]*m[2, 0],
        r[1, 0]*m[0, 1] + r[1, 1]*m[1, 1] + r[1, 2]*m[2, 1],
        r[1, 0]*m[0, 2] + r[1, 1]*m[1, 2] + r[1, 2]*m[2, 2],
        r[1, 0]*m[0, 3] + r[1, 1]*m[1, 3] + r[1, 2]*m[2, 3],
        // row 3
        r[2, 0]*m[0, 0] + r[2, 1]*m[1, 0] + r[2, 2]*m[2, 0],
        r[2, 0]*m[0, 1] + r[2, 1]*m[1, 1] + r[2, 2]*m[2, 1],
        r[2, 0]*m[0, 2] + r[2, 1]*m[1, 2] + r[2, 2]*m[2, 2],
        r[2, 0]*m[0, 3] + r[2, 1]*m[1, 3] + r[2, 2]*m[2, 3],
        // row 4
        m[3, 0], m[3, 1], m[3, 2], m[3, 3]
    );
}

/// ditto
M rotate (M, T, V) (in M m, in T angle, in V axis)
if (isMat!(3, 4, M) && isVec!(3, V) && isFloatingPoint!T)
{
    static assert (
        isFloatingPoint!(V.Component),
        "rotate must be passed a floating point axis"
    );
    const r = rotationPure(angle, axis);
    return M (
        // row 1
        r[0, 0]*m[0, 0] + r[0, 1]*m[1, 0] + r[0, 2]*m[2, 0],
        r[0, 0]*m[0, 1] + r[0, 1]*m[1, 1] + r[0, 2]*m[2, 1],
        r[0, 0]*m[0, 2] + r[0, 1]*m[1, 2] + r[0, 2]*m[2, 2],
        r[0, 0]*m[0, 3] + r[0, 1]*m[1, 3] + r[0, 2]*m[2, 3],
        // row 2
        r[1, 0]*m[0, 0] + r[1, 1]*m[1, 0] + r[1, 2]*m[2, 0],
        r[1, 0]*m[0, 1] + r[1, 1]*m[1, 1] + r[1, 2]*m[2, 1],
        r[1, 0]*m[0, 2] + r[1, 1]*m[1, 2] + r[1, 2]*m[2, 2],
        r[1, 0]*m[0, 3] + r[1, 1]*m[1, 3] + r[1, 2]*m[2, 3],
        // row 3
        r[2, 0]*m[0, 0] + r[2, 1]*m[1, 0] + r[2, 2]*m[2, 0],
        r[2, 0]*m[0, 1] + r[2, 1]*m[1, 1] + r[2, 2]*m[2, 1],
        r[2, 0]*m[0, 2] + r[2, 1]*m[1, 2] + r[2, 2]*m[2, 2],
        r[2, 0]*m[0, 3] + r[2, 1]*m[1, 3] + r[2, 2]*m[2, 3],
    );
}

/// ditto
M rotate (M, T) (in M m, in T angle, in T x, in T y, in T z)
if ((isMat!(3, 4, M) || isMat!(4, 4, M)) && isFloatingPoint!T)
{
    return rotate(m, angle, vec(x, y, z));
}

///
unittest
{
    import gfx.math.approx : approxUlp;
    import std.math : PI;

    immutable m = DMat3( 1, 2, 3, 4, 5, 6, 7, 8, 9 );

    immutable expected = rotation!double(PI) * m; // full multiplication
    immutable result = rotate(m, PI);      // simplified multiplication

    assert (approxUlp(expected, result));
}
///
unittest
{
    import gfx.math.approx : approxUlp;
    import std.math : PI;

    immutable m = DMat4( 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 );
    immutable angle = PI;
    immutable v = fvec(3, 4, 5);

    immutable expected = rotation(angle, v) * m; // full multiplication
    immutable result = rotate(m, angle, v);      // simplified multiplication

    assert (approxUlp(expected, result));
}

/// Build a rotation matrix from Euler angles
/// The convention taken is Xa, Zb, Xc
Mat3!T eulerAngles(T) (in T a, in T b, in T c)
if (isFloatingPoint!T)
{
    import std.math : cos, sin;

    immutable sa = sin(a);
    immutable sb = sin(b);
    immutable sc = sin(c);

    immutable ca = cos(a);
    immutable cb = cos(b);
    immutable cc = cos(c);

    return Mat3!T (
        cb,     -cc*sb,             sb*sc,
        ca*sb,  ca*cb*cc - sa*sc,   -cc*sa - ca*cb*sc,
        sa*sb,  ca*sc + cb*cc*sa,   ca*cc - cb*sa*sc,
    );
}

auto eulerAngles(V) (in V angles)
if (isVec!(3, V) && isFloatingPoint!(V.Component))
{
    return eulerAngles(angles[0], angles[1], angles[2]);
}

/// ditto

///
unittest {
    import gfx.math.approx : approxUlpAndAbs;
    import std.math : PI;

    const v = fvec(0, 0, 1);
    // rotate PI/2 around X, then no rotation around Z, then again PI/2 around X
    const m = eulerAngles(float(PI / 2), 0f, float(PI / 2));
    const result = m * v;
    const expected = fvec(0, 0, -1);

    assert(approxUlpAndAbs(result, expected));
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
auto scale(V) (in V v) if (isVec2!V)
{
    return Mat3!(V.Component) (
        v.x, 0, 0,
        0, v.y, 0,
        0, 0, 1,
    );
}

/// ditto
Mat2x3!(CommonType!(X, Y)) affineScale(X, Y) (in X x, in Y y)
if (allSatisfy!(isNumeric, X, Y))
{
    return Mat2x3!(CommonType!(X, Y))(
        x, 0, 0,
        0, y, 0,
    );
}

/// ditto
auto affineScale(V) (in V v) if (isVec2!V)
{
    return Mat2x3!(V.Component) (
        v.x, 0, 0,
        0, v.y, 0,
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
auto scale(V) (in V v) if (isVec3!V)
{
    return Mat4!(V.Component) (
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
        m[0, 0] * x,
        m[0, 1] * x,
        m[0, 2] * x,
        // row 2
        m[1, 0] * y,
        m[1, 1] * y,
        m[1, 2] * y,
        // row 3
        m[2, 0], m[2, 1], m[2, 2]
    );
}

/// ditto
M scale (M, X, Y)(in M m, in X x, in Y y)
if (isMat!(2, 3, M) && allSatisfy!(isNumeric, X, Y))
{
    return M (
        // row 1
        m[0, 0] * x,
        m[0, 1] * x,
        m[0, 2] * x,
        // row 2
        m[1, 0] * y,
        m[1, 1] * y,
        m[1, 2] * y,
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
        m[0, 0] * x,
        m[0, 1] * x,
        m[0, 2] * x,
        m[0, 3] * x,
        // row 2
        m[1, 0] * y,
        m[1, 1] * y,
        m[1, 2] * y,
        m[1, 3] * y,
        // row 3
        m[2, 0] * z,
        m[2, 1] * z,
        m[2, 2] * z,
        m[2, 3] * z,
        // row 4
        m[3, 0], m[3, 1], m[3, 2], m[3, 3]
    );
}

/// ditto
M scale (M, X, Y, Z)(in M m, in X x, in Y y, in Z z)
if (isMat!(3, 4, M) && allSatisfy!(isNumeric, X, Y, Z))
{
    return M (
        // row 1
        m[0, 0] * x,
        m[0, 1] * x,
        m[0, 2] * x,
        m[0, 3] * x,
        // row 2
        m[1, 0] * y,
        m[1, 1] * y,
        m[1, 2] * y,
        m[1, 3] * y,
        // row 3
        m[2, 0] * z,
        m[2, 1] * z,
        m[2, 2] * z,
        m[2, 3] * z,
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
    import gfx.math.approx : approxUlp;

    immutable m = DMat3( 1, 2, 3, 4, 5, 6, 7, 8, 9 );

    immutable expected = scale(4, 5) * m; // full multiplication
    immutable result = scale(m, 4, 5);   // simplified multiplication

    assert (approxUlp(expected, result));
}
///
unittest
{
    import gfx.math.approx : approxUlp;

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
    static foreach(r; 0 .. rowLength)
    {
        static foreach (c; 0 .. columnLength)
        {{
            Comp resComp = 0;
            static foreach (rc; 0 .. rowLength) // that is columnCount-1
            {
                resComp += ml[r, rc] * mr[rc, c];
            }
            static if (c == columnLength-1)
            {
                resComp += ml[r, c]; // that is the last one in the last row
            }
            res[r, c] = resComp;
        }}
    }
    return res;
}

///
unittest
{
    import gfx.math.approx : approxUlp;

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

    immutable expected = (fm1 * fm2).slice!(0, 2, 0, 3);
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
/// ditto
auto transform(V, M)(in V v, in M m)
if (isVec!(4, V) && isMat!(4, 4, M))
{
    return m * v;
}

unittest
{
    import gfx.math.approx : approxUlp;

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
    import gfx.math.approx : approxUlp, approxUlpAndAbs;
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

///
unittest
{
    import gfx.math.approx : approxUlp;

    auto st = scale!float(2, 2).translate(3, 1);
    assert( approxUlp(transform(fvec(0, 0), st), fvec(3, 1)) );
    assert( approxUlp(transform(fvec(1, 1), st), fvec(5, 3)) );

    auto ts = translation!float(3, 1).scale(2, 2);
    assert( approxUlp(transform(fvec(0, 0), ts), fvec(6, 2)) );
    assert( approxUlp(transform(fvec(1, 1), ts), fvec(8, 4)) );
}
