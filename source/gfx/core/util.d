module gfx.core.util;

/// Down cast of a reference to a child class reference
/// runtime check is disabled in release build
/// If T is a base class of U, this does a blind cast to the same address.
/// If T is an interface implemented by U, it first offset address to the object base address
/// and does a blind cast to that address.
template unsafeCast(U) if (!is(U == const))
{
    static assert (!is(U == interface), "unsafeCast cannot be used to return interfaces");
    static assert (is(U == class), "unsafeCast can only be used with objects");

    @system
    U unsafeCast(T)(T obj)
            if ((is(T==class) || is(T==interface)) && is(U : T))
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

}

/// ditto
template unsafeCast(U) if (is(U == const))
{
    static assert (!is(U == interface), "unsafeCast cannot be used to return interfaces");
    static assert (is(U == class), "unsafeCast can only be used with objects");

    @system
    U unsafeCast(T)(const(T) obj)
            if ((is(T==class) || is(T==interface)) && is(U : const(T)))
    {
        if (!obj) return null;
        debug {
            auto uObj = cast(U)obj;
            assert(uObj, "unsafeCast from "~T.stringof~" to "~U.stringof~" failed");
            return uObj;
        }
        else {
            static if (is(T == interface)) {
                return cast(U)(cast(const(void*))(cast(const(Object))obj));
            }
            else {
                return cast(U)(cast(const(void*))obj);
            }
        }
    }
}

