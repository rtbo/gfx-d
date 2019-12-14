module gfx.math.quat;

import gfx.math.vec;

pure @safe @nogc nothrow:

struct Quat(T)
{
    import std.traits : isFloatingPoint;

    static assert(isFloatingPoint!T, "Quaternions can only be defined with floating points");

    alias Component = T;

    private T[4] _rep;

    public static immutable Quat!T identity = Quat!T(1, 0, 0, 0);

    this(in T w, in T x, in T y, in T z)
    {
        _rep = [ w, x, y, z ];
    }

    this(in T w, in Vec3!T v)
    {
        _rep = [ w, v.x, v.y, v.z ];
    }

    @property T x() const { return _rep[0]; }
    @property T y() const { return _rep[1]; }
    @property T z() const { return _rep[2]; }
    @property T w() const { return _rep[3]; }


}

static assert((Quat!float).sizeof == 4 * float.sizeof);
static assert((Quat!double).sizeof == 4 * double.sizeof);
