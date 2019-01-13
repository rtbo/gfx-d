module matmul;

import std.stdio;

extern(C) int glm_matmul(int iter);

int glmMatMul(int iter)
{
    return glm_matmul(iter);
}

int gfxMatMul(int iter)
{
    import gfx.math;
    const axis = fvec(1, 2, 3);
    const sc = fvec(0.5, 2, 0.5);
    const tr = fvec(4, 5, 6);
    const even = rotation(0.01, axis) * scale(sc) * translation(tr);
    const odd = rotation(0.01, axis) * scale(1f / sc) * translation(-tr);
    auto m = FMat4.identity;

    foreach (i; 0 .. iter) {
        if (i % 2) {
            m = odd * m;
        }
        else {
            m = even * m;
        }
    }

    // writeln("gfx:", m);
    if (m == FMat4.identity) {
        writeln("only to make sure computation is not optimized away");
    }

    return iter;
}


int gl3nMatMul(int iter)
{
    import gl3n.linalg;
    const axis = vec3(1, 2, 3);
    const sc = vec3(0.5, 2, 0.5);
    const tr = vec3(4, 5, 6);
    const r = quat.axis_rotation(0.01, axis.normalized).to_matrix!(4, 4);
    const even = r * mat4.scaling(sc.x, sc.y, sc.z) * mat4.translation(tr);
    const odd = r * mat4.scaling(1f/sc.x, 1f/sc.y, 1f/sc.z) * mat4.translation(-tr);
    auto m = mat4.identity;

    foreach (i; 0 .. iter) {
        if (i % 2) {
            m = odd * m;
        }
        else {
            m = even * m;
        }
    }

    //writeln("gl3n:", m);
    if (m == mat4.identity) {
        writeln("only to make sure computation is not optimized away");
    }
    return iter;
}

