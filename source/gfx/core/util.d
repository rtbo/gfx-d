module gfx.core.util;

/// Down cast of a reference to a child class reference
/// runtime check is disabled in release build
/// If T is a base class of U, this does a blind cast to the same address.
/// If T is an interface implemented by U, it first offset address to the object base address
/// and does a blind cast to that address.
U unsafeCast(U, T)(T obj)
        if ((is(T==class) || is(T==interface)) &&
            is(U==class) && is(U : T))
{
    if (!obj) return null;
    debug {
        auto uObj = cast(U)obj;
        assert(uObj, "unsafeCast from "~T.stringof~" to "~U.stringof~" failed");
        return uObj;
    }
    else {
        static if (is(T == interface)) {
            return cast(U)(cast(void*)(cast(Object)obj));
        }
        else {
            return cast(U)(cast(void*)obj);
        }
    }
}

/// ditto
const(U) unsafeCast(U, T)(const(T) obj)
        if ((is(T==class) || is(T==interface)) &&
            is(U==class) && is(U : T))
{
    if (!obj) return null;
    debug {
        auto uObj = cast(const(U))obj;
        assert(uObj, "unsafeCast from "~T.stringof~" to "~U.stringof~" failed");
        return uObj;
    }
    else {
        static if (is(T == interface)) {
            return cast(const(U))(cast(const(void*))(cast(const(Object))obj));
        }
        else {
            return cast(const(U))(cast(const(void*))obj);
        }
    }
}
