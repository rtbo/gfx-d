/// Some transform utilities
module gfx.math.util;

import gfx.math.mat;
import gfx.math.vec;

pure @safe @nogc nothrow:

/// Build a look-at view matrix
auto lookAt(V)(in V eye, in V target, in V up) if (isVec!V)
{
    alias T = V.Component;

    const z = normalize(eye - target);
    const x = cross(normalize(up), z);
    const y = cross(z, x);

    return Mat4!T(
        Vec4!T( x,      -dot(x, eye)),
        Vec4!T( y,      -dot(y, eye)),
        Vec4!T( z,      -dot(z, eye)),
        Vec4!T( 0, 0, 0,    1       ),
    );
}

// TODO: test lookAt

// TODO: min, max, abs, clamp, smoothstep...
