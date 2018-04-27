/// Matrix determinant and inverse
module gfx.math.inverse;

import gfx.math.mat : isMat, Mat2, Mat3, Mat4;

// algos in this module are from GLM

/// Compute the determinant of a matrix.
@property T determinant(T)(in Mat2!T m)
{
    return m[0, 0] * m[1, 1] - m[0, 1] * m[1, 0];
}

/// ditto
@property T determinant(T)(in Mat3!T m)
{
    return
        + m[0, 0] * (m[1, 1] * m[2, 2] - m[1, 2] * m[2, 1])
        - m[0, 1] * (m[1, 0] * m[2, 2] - m[1, 2] * m[2, 0])
        + m[0, 2] * (m[1, 0] * m[2, 1] - m[1, 1] * m[2, 0]);
}

/// ditto
@property T determinant(T)(in Mat4!T m)
{
    import gfx.math.vec : vec4;

    const subFactor00 = m[2, 2] * m[3, 3] - m[2, 3] * m[3, 2];
    const subFactor01 = m[1, 2] * m[3, 3] - m[1, 3] * m[3, 2];
    const subFactor02 = m[1, 2] * m[2, 3] - m[1, 3] * m[2, 2];
    const subFactor03 = m[0, 2] * m[3, 3] - m[0, 3] * m[3, 2];
    const subFactor04 = m[0, 2] * m[2, 3] - m[0, 3] * m[2, 2];
    const subFactor05 = m[0, 2] * m[1, 3] - m[0, 3] * m[1, 2];

    const detCof = vec4 (
        + (m[1, 1] * subFactor00 - m[2, 1] * subFactor01 + m[3, 1] * subFactor02),
        - (m[0, 1] * subFactor00 - m[2, 1] * subFactor03 + m[3, 1] * subFactor04),
        + (m[0, 1] * subFactor01 - m[1, 1] * subFactor03 + m[3, 1] * subFactor05),
        - (m[0, 1] * subFactor02 - m[1, 1] * subFactor04 + m[2, 1] * subFactor05)
    );

    return
        m[0, 0] * detCof[0] + m[1, 0] * detCof[1] +
        m[2, 0] * detCof[2] + m[3, 0] * detCof[3];
}

/// Compute the inverse of a matrix
M inverse(M)(in M m) if (isMat!(2, 2, M))
{
    alias T = M.Component;

    const oneOverD = T(1) / (
        + m[0, 0] * m[1, 1]
        - m[0, 1] * m[1, 0]);

    return Mat2!T (
        + m[1, 1] * oneOverD,
        - m[1, 0] * oneOverD,
        - m[0, 1] * oneOverD,
        + m[0, 0] * oneOverD
    );
}

/// ditto
M inverse(M)(in M m) if (isMat!(3, 3, M))
{
    alias T = M.Component;

    const oneOverD = T(1) / (
        + m[0, 0] * (m[1, 1] * m[2, 2] - m[1, 2] * m[2, 1])
        - m[0, 1] * (m[1, 0] * m[2, 2] - m[1, 2] * m[2, 0])
        + m[0, 2] * (m[1, 0] * m[2, 1] - m[1, 1] * m[2, 0])
    );

    Mat3!T inv = void;
    inv[0, 0] = + (m[1, 1] * m[2, 2] - m[1, 2] * m[2, 1]) * oneOverD;
    inv[0, 1] = - (m[0, 1] * m[2, 2] - m[0, 2] * m[2, 1]) * oneOverD;
    inv[0, 2] = + (m[0, 1] * m[1, 2] - m[0, 2] * m[1, 1]) * oneOverD;
    inv[1, 0] = - (m[1, 0] * m[2, 2] - m[1, 2] * m[2, 0]) * oneOverD;
    inv[1, 1] = + (m[0, 0] * m[2, 2] - m[0, 2] * m[2, 0]) * oneOverD;
    inv[1, 2] = - (m[0, 0] * m[1, 2] - m[0, 2] * m[1, 0]) * oneOverD;
    inv[2, 0] = + (m[1, 0] * m[2, 1] - m[1, 1] * m[2, 0]) * oneOverD;
    inv[2, 1] = - (m[0, 0] * m[2, 1] - m[0, 1] * m[2, 0]) * oneOverD;
    inv[2, 2] = + (m[0, 0] * m[1, 1] - m[0, 1] * m[1, 0]) * oneOverD;

    return inv;
}

///
unittest
{
    import gfx.math.mat : FMat3;

    /// Example from https://en.wikipedia.org/wiki/Gaussian_elimination
    const m = FMat3(
        2, -1, 0,
        -1, 2, -1,
        0, -1, 2
    );
    const invM = inverse(m);

    import gfx.math.approx : approxUlp;
    assert(approxUlp(invM, FMat3(
        0.75f, 0.5f, 0.25f,
        0.5f,  1f,   0.5f,
        0.25f, 0.5f, 0.75f
    )));
    assert(approxUlp(inverse(invM), m));
}


/// ditto
M inverse(M)(in M m) if (isMat!(4, 4, M))
{
    import gfx.math.mat : mat, transpose;
    import gfx.math.vec : vec;

    alias T = M.Component;

    const coef00 = m[2, 2] * m[3, 3] - m[2, 3] * m[3, 2];
    const coef02 = m[2, 1] * m[3, 3] - m[2, 3] * m[3, 1];
    const coef03 = m[2, 1] * m[3, 2] - m[2, 2] * m[3, 1];

    const coef04 = m[1, 2] * m[3, 3] - m[1, 3] * m[3, 2];
    const coef06 = m[1, 1] * m[3, 3] - m[1, 3] * m[3, 1];
    const coef07 = m[1, 1] * m[3, 2] - m[1, 2] * m[3, 1];

    const coef08 = m[1, 2] * m[2, 3] - m[1, 3] * m[2, 2];
    const coef10 = m[1, 1] * m[2, 3] - m[1, 3] * m[2, 1];
    const coef11 = m[1, 1] * m[2, 2] - m[1, 2] * m[2, 1];

    const coef12 = m[0, 2] * m[3, 3] - m[0, 3] * m[3, 2];
    const coef14 = m[0, 1] * m[3, 3] - m[0, 3] * m[3, 1];
    const coef15 = m[0, 1] * m[3, 2] - m[0, 2] * m[3, 1];

    const coef16 = m[0, 2] * m[2, 3] - m[0, 3] * m[2, 2];
    const coef18 = m[0, 1] * m[2, 3] - m[0, 3] * m[2, 1];
    const coef19 = m[0, 1] * m[2, 2] - m[0, 2] * m[2, 1];

    const coef20 = m[0, 2] * m[1, 3] - m[0, 3] * m[1, 2];
    const coef22 = m[0, 1] * m[1, 3] - m[0, 3] * m[1, 1];
    const coef23 = m[0, 1] * m[1, 2] - m[0, 2] * m[1, 1];

    const fac0 = vec(coef00, coef00, coef02, coef03);
    const fac1 = vec(coef04, coef04, coef06, coef07);
    const fac2 = vec(coef08, coef08, coef10, coef11);
    const fac3 = vec(coef12, coef12, coef14, coef15);
    const fac4 = vec(coef16, coef16, coef18, coef19);
    const fac5 = vec(coef20, coef20, coef22, coef23);

    const v0 = vec(m[0, 1], m[0, 0], m[0, 0], m[0, 0]);
    const v1 = vec(m[1, 1], m[1, 0], m[1, 0], m[1, 0]);
    const v2 = vec(m[2, 1], m[2, 0], m[2, 0], m[2, 0]);
    const v3 = vec(m[3, 1], m[3, 0], m[3, 0], m[3, 0]);

    const inv0 = v1 * fac0 - v2 * fac1 + v3 * fac2;
    const inv1 = v0 * fac0 - v2 * fac3 + v3 * fac4;
    const inv2 = v0 * fac1 - v1 * fac3 + v3 * fac5;
    const inv3 = v0 * fac2 - v1 * fac4 + v2 * fac5;

    const signA = vec(+1, -1, +1, -1);
    const signB = vec(-1, +1, -1, +1);

    // GLM is column major!
    // We have to transpose or refactor the algorithm
    const inverse = transpose(mat(
        inv0 * signA, inv1 * signB, inv2 * signA, inv3 * signB
    ));

    const dot0 = m.column(0) * inverse.row(0);
    const dot1 = (dot0.x + dot0.y) + (dot0.z + dot0.w);

    const oneOverD = T(1) / dot1;

    return inverse * oneOverD;
}

///
unittest {
    import gfx.math.transform : translation;

    const trM = translation!float(3, 4, 5);
    const inv = inverse(trM);

}
