module gfx.backend;


package U unsafeCast(U, T)(T obj)
        if ((is(T==class) || is(T==interface)) &&
            (is(U==class) || is(U==interface)) &&
            is(U : T))
{
    debug {
        auto uObj = cast(U)obj;
        assert(uObj, "unsafeCast from "~T.stringof~" to "~U.stringof~" failed");
        return uObj;
    }
    else {
        return cast(U)(cast(void*)obj);
    }
}

package const(U) unsafeCast(U, T)(const(T) obj)
        if ((is(T==class) || is(T==interface)) &&
            (is(U==class) || is(U==interface)) &&
            is(U : T))
{
    debug {
        auto uObj = cast(const(U))obj;
        assert(uObj, "unsafeCast from "~T.stringof~" to "~U.stringof~" failed");
        return uObj;
    }
    else {
        return cast(const(U))(cast(const(void*))obj);
    }
}