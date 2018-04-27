/// Some transform utilities
module gfx.math.util;

import gfx.math.mat;
import gfx.math.vec;

/// Build a look-at view matrix
auto lookAt(V)(in V eye, in V target, in V up) if (isVec!V)
{
    alias T = V.Component;

    const z = normalize(target - eye);
    const x = normalize(cross(z, up));
    const y = cross(x, z);

    return Mat4!T(
        x,      -dot(x, eye),
        y,      -dot(y, eye),
       -z,      -dot(z, eye),
        0, 0, 0, 1,
    );
}

// TODO: test lookAt
