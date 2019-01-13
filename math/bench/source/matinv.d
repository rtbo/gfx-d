module matinv;

import std.stdio;

extern(C) int glm_matinv(int iter);

int glmMatInv(int iter)
{
    return glm_matinv(iter);
}

int gfxMatInv(int iter)
{
    import gfx.math;
    const axis = fvec(1, 2, 3);
    const sc = fvec(0.5, 2, 0.5);
    const tr = fvec(4, 5, 6);
    auto m = rotation(0.01f, axis) * scale(sc) * translation(tr);

    foreach (i; 0 .. iter) {
        m = inverse(m);
    }

    //writeln("gfx:", m);
    if (m == FMat4.identity) {
        writeln("only to make sure computation is not optimized away");
    }

    return iter;
}


int gl3nMatInv(int iter)
{
    import gl3n.linalg;
    const axis = vec3(1, 2, 3);
    const sc = vec3(0.5, 2, 0.5);
    const tr = vec3(4, 5, 6);
    const r = quat.axis_rotation(0.01, axis.normalized).to_matrix!(4, 4);
    auto m = r * mat4.scaling(sc.x, sc.y, sc.z) * mat4.translation(tr);

    foreach (i; 0 .. iter) {
        m = m.inverse();
    }

    //writeln("gl3n:", m);
    if (m == mat4.identity) {
        writeln("only to make sure computation is not optimized away");
    }
    return iter;
}

