/// Matrix determinant and inverse
module gfx.math.inverse;

import gfx.math.mat;

pure @safe @nogc nothrow:

// algos in this module are from GLM

/// Compute the determinant of a matrix.
@property auto determinant(M)(in M m) if (isMat2!M)
{
    return m.ct!(0, 0) * m.ct!(1, 1) - m.ct!(0, 1) * m.ct!(1, 0);
}

/// ditto
@property auto determinant(M)(in M m) if (isMat3!M)
{
    return
        + m.ct!(0, 0) * (m.ct!(1, 1) * m.ct!(2, 2) - m.ct!(1, 2) * m.ct!(2, 1))
        - m.ct!(0, 1) * (m.ct!(1, 0) * m.ct!(2, 2) - m.ct!(1, 2) * m.ct!(2, 0))
        + m.ct!(0, 2) * (m.ct!(1, 0) * m.ct!(2, 1) - m.ct!(1, 1) * m.ct!(2, 0));
}

/// ditto
@property auto determinant(M)(in M m) if (isMat4!M)
{
    import gfx.math.vec : vec4;

    const subFactor00 = m.ct!(2, 2) * m.ct!(3, 3) - m.ct!(2, 3) * m.ct!(3, 2);
    const subFactor01 = m.ct!(1, 2) * m.ct!(3, 3) - m.ct!(1, 3) * m.ct!(3, 2);
    const subFactor02 = m.ct!(1, 2) * m.ct!(2, 3) - m.ct!(1, 3) * m.ct!(2, 2);
    const subFactor03 = m.ct!(0, 2) * m.ct!(3, 3) - m.ct!(0, 3) * m.ct!(3, 2);
    const subFactor04 = m.ct!(0, 2) * m.ct!(2, 3) - m.ct!(0, 3) * m.ct!(2, 2);
    const subFactor05 = m.ct!(0, 2) * m.ct!(1, 3) - m.ct!(0, 3) * m.ct!(1, 2);

    const detCof = vec4 (
        + (m.ct!(1, 1) * subFactor00 - m.ct!(2, 1) * subFactor01 + m.ct!(3, 1) * subFactor02),
        - (m.ct!(0, 1) * subFactor00 - m.ct!(2, 1) * subFactor03 + m.ct!(3, 1) * subFactor04),
        + (m.ct!(0, 1) * subFactor01 - m.ct!(1, 1) * subFactor03 + m.ct!(3, 1) * subFactor05),
        - (m.ct!(0, 1) * subFactor02 - m.ct!(1, 1) * subFactor04 + m.ct!(2, 1) * subFactor05)
    );

    return
        m.ct!(0, 0) * detCof[0] + m.ct!(1, 0) * detCof[1] +
        m.ct!(2, 0) * detCof[2] + m.ct!(3, 0) * detCof[3];
}

/// Compute the inverse of a matrix
M inverse(M)(in M m) if (isMat2!M)
{
    alias T = M.Component;

    const oneOverD = T(1) / (
        + m.ct!(0, 0) * m.ct!(1, 1)
        - m.ct!(0, 1) * m.ct!(1, 0));

    return Mat2!T (
        + m.ct!(1, 1) * oneOverD,
        - m.ct!(1, 0) * oneOverD,
        - m.ct!(0, 1) * oneOverD,
        + m.ct!(0, 0) * oneOverD
    );
}

/// ditto
M inverse(M)(in M m) if (isMat3!M)
{
    alias T = M.Component;

    const oneOverD = T(1) / (
        + m.ct!(0, 0) * (m.ct!(1, 1) * m.ct!(2, 2) - m.ct!(1, 2) * m.ct!(2, 1))
        - m.ct!(0, 1) * (m.ct!(1, 0) * m.ct!(2, 2) - m.ct!(1, 2) * m.ct!(2, 0))
        + m.ct!(0, 2) * (m.ct!(1, 0) * m.ct!(2, 1) - m.ct!(1, 1) * m.ct!(2, 0))
    );

    return M(
        + (m.ct!(1, 1) * m.ct!(2, 2) - m.ct!(1, 2) * m.ct!(2, 1)) * oneOverD,
        - (m.ct!(0, 1) * m.ct!(2, 2) - m.ct!(0, 2) * m.ct!(2, 1)) * oneOverD,
        + (m.ct!(0, 1) * m.ct!(1, 2) - m.ct!(0, 2) * m.ct!(1, 1)) * oneOverD,
        - (m.ct!(1, 0) * m.ct!(2, 2) - m.ct!(1, 2) * m.ct!(2, 0)) * oneOverD,
        + (m.ct!(0, 0) * m.ct!(2, 2) - m.ct!(0, 2) * m.ct!(2, 0)) * oneOverD,
        - (m.ct!(0, 0) * m.ct!(1, 2) - m.ct!(0, 2) * m.ct!(1, 0)) * oneOverD,
        + (m.ct!(1, 0) * m.ct!(2, 1) - m.ct!(1, 1) * m.ct!(2, 0)) * oneOverD,
        - (m.ct!(0, 0) * m.ct!(2, 1) - m.ct!(0, 1) * m.ct!(2, 0)) * oneOverD,
        + (m.ct!(0, 0) * m.ct!(1, 1) - m.ct!(0, 1) * m.ct!(1, 0)) * oneOverD,
    );
}

///
unittest
{
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
M inverse(M)(in M m) if (isMat4!M)
{
    import gfx.math.vec : vec;

    alias T = M.Component;

    const coef00 = m.ct!(2, 2) * m.ct!(3, 3) - m.ct!(2, 3) * m.ct!(3, 2);
    const coef02 = m.ct!(2, 1) * m.ct!(3, 3) - m.ct!(2, 3) * m.ct!(3, 1);
    const coef03 = m.ct!(2, 1) * m.ct!(3, 2) - m.ct!(2, 2) * m.ct!(3, 1);

    const coef04 = m.ct!(1, 2) * m.ct!(3, 3) - m.ct!(1, 3) * m.ct!(3, 2);
    const coef06 = m.ct!(1, 1) * m.ct!(3, 3) - m.ct!(1, 3) * m.ct!(3, 1);
    const coef07 = m.ct!(1, 1) * m.ct!(3, 2) - m.ct!(1, 2) * m.ct!(3, 1);

    const coef08 = m.ct!(1, 2) * m.ct!(2, 3) - m.ct!(1, 3) * m.ct!(2, 2);
    const coef10 = m.ct!(1, 1) * m.ct!(2, 3) - m.ct!(1, 3) * m.ct!(2, 1);
    const coef11 = m.ct!(1, 1) * m.ct!(2, 2) - m.ct!(1, 2) * m.ct!(2, 1);

    const coef12 = m.ct!(0, 2) * m.ct!(3, 3) - m.ct!(0, 3) * m.ct!(3, 2);
    const coef14 = m.ct!(0, 1) * m.ct!(3, 3) - m.ct!(0, 3) * m.ct!(3, 1);
    const coef15 = m.ct!(0, 1) * m.ct!(3, 2) - m.ct!(0, 2) * m.ct!(3, 1);

    const coef16 = m.ct!(0, 2) * m.ct!(2, 3) - m.ct!(0, 3) * m.ct!(2, 2);
    const coef18 = m.ct!(0, 1) * m.ct!(2, 3) - m.ct!(0, 3) * m.ct!(2, 1);
    const coef19 = m.ct!(0, 1) * m.ct!(2, 2) - m.ct!(0, 2) * m.ct!(2, 1);

    const coef20 = m.ct!(0, 2) * m.ct!(1, 3) - m.ct!(0, 3) * m.ct!(1, 2);
    const coef22 = m.ct!(0, 1) * m.ct!(1, 3) - m.ct!(0, 3) * m.ct!(1, 1);
    const coef23 = m.ct!(0, 1) * m.ct!(1, 2) - m.ct!(0, 2) * m.ct!(1, 1);

    const fac0 = vec(coef00, coef00, coef02, coef03);
    const fac1 = vec(coef04, coef04, coef06, coef07);
    const fac2 = vec(coef08, coef08, coef10, coef11);
    const fac3 = vec(coef12, coef12, coef14, coef15);
    const fac4 = vec(coef16, coef16, coef18, coef19);
    const fac5 = vec(coef20, coef20, coef22, coef23);

    const v0 = vec(m.ct!(0, 1), m.ct!(0, 0), m.ct!(0, 0), m.ct!(0, 0));
    const v1 = vec(m.ct!(1, 1), m.ct!(1, 0), m.ct!(1, 0), m.ct!(1, 0));
    const v2 = vec(m.ct!(2, 1), m.ct!(2, 0), m.ct!(2, 0), m.ct!(2, 0));
    const v3 = vec(m.ct!(3, 1), m.ct!(3, 0), m.ct!(3, 0), m.ct!(3, 0));

    const inv0 = v1 * fac0 - v2 * fac1 + v3 * fac2;
    const inv1 = v0 * fac0 - v2 * fac3 + v3 * fac4;
    const inv2 = v0 * fac1 - v1 * fac3 + v3 * fac5;
    const inv3 = v0 * fac2 - v1 * fac4 + v2 * fac5;

    const signA = vec(+1, -1, +1, -1);
    const signB = vec(-1, +1, -1, +1);

    // GLM is column major!
    // We have to transpose or refactor the algorithm
    // Note: without this transpose gfx:math beats gl3n on inversion benchmark
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
    import gfx.math.approx : approxUlpAndAbs;

    const trM = translation!float(3, 4, 5);
    const expected = translation!float(-3, -4, -5);
    const inv = inverse(trM);

    assert(approxUlpAndAbs( inv, expected ));
    assert(approxUlpAndAbs( inverse(inv), trM ));
    assert(approxUlpAndAbs( inv * trM, FMat4.identity ));
}

/// Fast matrix inverse for affine matrices
M affineInverse(M)(in M m) if(isMat3!M)
{
    import gfx.math.vec : vec;
    alias T = M.Component;

    const inv = inverse(m.slice!(0, 2, 0, 2));
    const col = -inv * vec(m.column(2), T(1));

    return M (
        vec!T( inv[0], col[0] ),
        vec!T( inv[1], col[1] ),
        vec!T( 0, 0,    1 ),
    );
}

/// ditto
M affineInverse(M)(in M m) if(isMat4!M)
{
    import gfx.math.vec : vec;
    alias T = M.Component;

    const inv = inverse(m.slice!(0, 3, 0, 3));
    const col = -(inv * m.column(3).xyz);

    return M (
        vec!T( inv[0], col[0] ),
        vec!T( inv[1], col[1] ),
        vec!T( inv[2], col[2] ),
        vec!T( 0, 0, 0,    1 ),
    );
}

/// Compute the invert transpose of a matrix
M inverseTranspose(M)(in M m) if(isMat2!M)
{
    alias T = M.Component;

    const oneOverD = T(1) / (m.ct!(0, 0) * m.ct!(1, 1) - m.ct!(0, 1) * m.ct!(1, 0));

    return M (
        + m.ct!(1, 1) * oneOverD,
        - m.ct!(0, 1) * oneOverD,
        - m.ct!(1, 0) * oneOverD,
        + m.ct!(0, 0) * oneOverD,
    );
}

/// ditto
M inverseTranspose(M)(in M m) if(isMat3!M)
{
    alias T = M.Component;

    const oneOverD = T(1) / (
        + m.ct!(0, 0) * (m.ct!(1, 1) * m.ct!(2, 2) - m.ct!(2, 1) * m.ct!(1, 2))
        - m.ct!(1, 0) * (m.ct!(0, 1) * m.ct!(2, 2) - m.ct!(2, 1) * m.ct!(0, 2))
        + m.ct!(2, 0) * (m.ct!(0, 1) * m.ct!(1, 2) - m.ct!(1, 1) * m.ct!(0, 2))
    );

    return M (
        + (m.ct!(1, 1) * m.ct!(2, 2) - m.ct!(1, 2) * m.ct!(2, 1)) * oneOverD,
        - (m.ct!(0, 1) * m.ct!(2, 2) - m.ct!(0, 2) * m.ct!(2, 1)) * oneOverD,
        + (m.ct!(0, 1) * m.ct!(1, 2) - m.ct!(0, 2) * m.ct!(1, 1)) * oneOverD,
        - (m.ct!(1, 0) * m.ct!(2, 2) - m.ct!(1, 2) * m.ct!(2, 0)) * oneOverD,
        + (m.ct!(0, 0) * m.ct!(2, 2) - m.ct!(0, 2) * m.ct!(2, 0)) * oneOverD,
        - (m.ct!(0, 0) * m.ct!(1, 2) - m.ct!(0, 2) * m.ct!(1, 0)) * oneOverD,
        + (m.ct!(1, 0) * m.ct!(2, 1) - m.ct!(1, 1) * m.ct!(2, 0)) * oneOverD,
        - (m.ct!(0, 0) * m.ct!(2, 1) - m.ct!(0, 1) * m.ct!(2, 0)) * oneOverD,
        + (m.ct!(0, 0) * m.ct!(1, 1) - m.ct!(0, 1) * m.ct!(1, 0)) * oneOverD,
    );
}

/// ditto
M inverseTranspose(M)(in M m) if(isMat4!M)
{
    alias T = M.Component;

    const subFactor00 = m.ct!(2, 2) * m.ct!(3, 3) - m.ct!(2, 3) * m.ct!(3, 2);
    const subFactor01 = m.ct!(1, 2) * m.ct!(3, 3) - m.ct!(1, 3) * m.ct!(3, 2);
    const subFactor02 = m.ct!(1, 2) * m.ct!(2, 3) - m.ct!(1, 3) * m.ct!(2, 2);
    const subFactor03 = m.ct!(0, 2) * m.ct!(3, 3) - m.ct!(0, 3) * m.ct!(3, 2);
    const subFactor04 = m.ct!(0, 2) * m.ct!(2, 3) - m.ct!(0, 3) * m.ct!(2, 2);
    const subFactor05 = m.ct!(0, 2) * m.ct!(1, 3) - m.ct!(0, 3) * m.ct!(1, 2);
    const subFactor06 = m.ct!(2, 1) * m.ct!(3, 3) - m.ct!(2, 3) * m.ct!(3, 1);
    const subFactor07 = m.ct!(1, 1) * m.ct!(3, 3) - m.ct!(1, 3) * m.ct!(3, 1);
    const subFactor08 = m.ct!(1, 1) * m.ct!(2, 3) - m.ct!(1, 3) * m.ct!(2, 1);
    const subFactor09 = m.ct!(0, 1) * m.ct!(3, 3) - m.ct!(0, 3) * m.ct!(3, 1);
    const subFactor10 = m.ct!(0, 1) * m.ct!(2, 3) - m.ct!(0, 3) * m.ct!(2, 1);
    const subFactor11 = m.ct!(1, 1) * m.ct!(3, 3) - m.ct!(1, 3) * m.ct!(3, 1);
    const subFactor12 = m.ct!(0, 1) * m.ct!(1, 3) - m.ct!(0, 3) * m.ct!(1, 1);
    const subFactor13 = m.ct!(2, 1) * m.ct!(3, 2) - m.ct!(2, 2) * m.ct!(3, 1);
    const subFactor14 = m.ct!(1, 1) * m.ct!(3, 2) - m.ct!(1, 2) * m.ct!(3, 1);
    const subFactor15 = m.ct!(1, 1) * m.ct!(2, 2) - m.ct!(1, 2) * m.ct!(2, 1);
    const subFactor16 = m.ct!(0, 1) * m.ct!(3, 2) - m.ct!(0, 2) * m.ct!(3, 1);
    const subFactor17 = m.ct!(0, 1) * m.ct!(2, 2) - m.ct!(0, 2) * m.ct!(2, 1);
    const subFactor18 = m.ct!(0, 1) * m.ct!(1, 2) - m.ct!(0, 2) * m.ct!(1, 1);

    const inv = M (
        + (m.ct!(1, 1) * subFactor00 - m.ct!(2, 1) * subFactor01 + m.ct!(3, 1) * subFactor02),
        - (m.ct!(1, 0) * subFactor00 - m.ct!(2, 0) * subFactor01 + m.ct!(3, 0) * subFactor02),
        + (m.ct!(1, 0) * subFactor06 - m.ct!(2, 0) * subFactor07 + m.ct!(3, 0) * subFactor08),
        - (m.ct!(1, 0) * subFactor13 - m.ct!(2, 0) * subFactor14 + m.ct!(3, 0) * subFactor15),

        - (m.ct!(0, 1) * subFactor00 - m.ct!(2, 1) * subFactor03 + m.ct!(3, 1) * subFactor04),
        + (m.ct!(0, 0) * subFactor00 - m.ct!(2, 0) * subFactor03 + m.ct!(3, 0) * subFactor04),
        - (m.ct!(0, 0) * subFactor06 - m.ct!(2, 0) * subFactor09 + m.ct!(3, 0) * subFactor10),
        + (m.ct!(0, 0) * subFactor13 - m.ct!(2, 0) * subFactor16 + m.ct!(3, 0) * subFactor17),

        + (m.ct!(0, 1) * subFactor01 - m.ct!(1, 1) * subFactor03 + m.ct!(3, 1) * subFactor05),
        - (m.ct!(0, 0) * subFactor01 - m.ct!(1, 0) * subFactor03 + m.ct!(3, 0) * subFactor05),
        + (m.ct!(0, 0) * subFactor11 - m.ct!(1, 0) * subFactor09 + m.ct!(3, 0) * subFactor12),
        - (m.ct!(0, 0) * subFactor14 - m.ct!(1, 0) * subFactor16 + m.ct!(3, 0) * subFactor18),

        - (m.ct!(0, 1) * subFactor02 - m.ct!(1, 1) * subFactor04 + m.ct!(2, 1) * subFactor05),
        + (m.ct!(0, 0) * subFactor02 - m.ct!(1, 0) * subFactor04 + m.ct!(2, 0) * subFactor05),
        - (m.ct!(0, 0) * subFactor08 - m.ct!(1, 0) * subFactor10 + m.ct!(2, 0) * subFactor12),
        + (m.ct!(0, 0) * subFactor15 - m.ct!(1, 0) * subFactor17 + m.ct!(2, 0) * subFactor18),
    );

    const oneOverD = T(1) / (
        + m.ct!(0, 0) * inv.ct!(0, 0)
        + m.ct!(1, 0) * inv.ct!(1, 0)
        + m.ct!(2, 0) * inv.ct!(2, 0)
        + m.ct!(3, 0) * inv.ct!(3, 0)
    );

    return inv * oneOverD;
}
