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


/// Return a bit by bit unchecked identical representation of the passed argument
template transmute(U)
{
    import std.traits : isDynamicArray;

    static if (!isDynamicArray!U) {
        @system @nogc nothrow pure
        U transmute(T)(in T value)
        {
            static assert(T.sizeof == U.sizeof, "can only transmute to identical type size");
            static assert(!is(T == class) && !is(T == interface), "cannot used transmute on objects");
            static assert(!is(U == class) && !is(U == interface), "cannot used transmute on objects");

            return *cast(U*)cast(void*)&value;
        }
    }
    else {
        @system @nogc nothrow pure
        U transmute(T)(T[] value)
        {
            import std.traits : isMutable;

            alias V = typeof(U.init[0]);

            static assert(T.sizeof == V.sizeof, "can only transmute to identical type size");
            static assert(!is(T == class) && !is(T == interface), "cannot used transmute on objects");
            static assert(!is(V == class) && !is(V == interface), "cannot used transmute on objects");
            static if (!isMutable!V) {
                static assert(!isMutable!T, "transmute is not meant to cast constness away");
            }

            return (cast(V*)cast(void*)value.ptr)[0 .. value.length];
        }
    }
}
