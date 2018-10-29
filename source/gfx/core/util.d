/// Utilities module
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


/// Utility to represent and retrieve the current stack-trace
struct StackTrace
{
    /// represent a single frame
    struct Frame {
        /// address of the frame
        void* addr;
        /// binary containing code
        string binary;
        /// function name and signature (with return type and arguments)
        string symbol;
        /// offset within the frame
        size_t offset;
    }

    /// options when retrieving stack frames
    enum Options {
        /// no option
        none = 0,
        /// Strip module qualifiers for names in symbols, keeping only the last components.
        /// Follows the common convention that module names are lowercase and type names are camelcase.
        unqualNames = 1,
        /// replace immutable(char)[] by string (and same for wchar and dchar)
        renameString = 2,

        /// sugar for both unqualNames and renameString
        all = unqualNames | renameString,
    }

    /// frames of the stack trace
    Frame[] frames;

    // TODO: index, slice, toString...

    static StackTrace obtain(in size_t maxFrames=0, in Options opts=Options.all)
    {
        version(linux) {
            import core.sys.linux.execinfo : backtrace, backtrace_symbols;
            import core.stdc.stdlib : free;
            import std.array : replace;
            import std.conv : parse;
            import std.demangle : demangle;
            import std.exception : enforce;
            import std.regex : ctRegex, matchFirst, replaceAll;
            import std.string : fromStringz;

            int sz = cast(int)maxFrames;
            const getAll = sz == 0;
            if (!sz) sz = 64;
            auto buf = new void*[sz];
            auto num = backtrace(&buf[0], sz);
            while (getAll && num == sz) {
                sz *= 2;
                buf = new void*[sz];
                num = backtrace(&buf[0], sz);
            }
            auto syms = backtrace_symbols(&buf[0], num);
            scope(exit) free(syms);

            auto linuxBtReg = ctRegex!(`([\w\./]+)\(([^\s\)\+]+)(\+0x([0-9a-fA-F]+))?\)`);
            auto unqualReg = ctRegex!(`([a-z]\w*\.)+(([A-Z]\w*\.)?\w+)`);

            auto frames = new Frame[num];
            foreach (i; 0 .. num) {
                auto sym = fromStringz(syms[i]).idup;
                auto captures = enforce(matchFirst(sym, linuxBtReg), "could not retrieve stack-trace");

                frames[i].addr = buf[i];
                frames[i].binary = captures[1];
                string symbol = demangle(captures[2]);
                if ((opts & Options.unqualNames) != Options.none) {
                    symbol = replaceAll(symbol, unqualReg, "$2");
                }
                if ((opts & Options.renameString) != Options.none) {
                    symbol = symbol.replace("immutable(char)[]", "string");
                    symbol = symbol.replace("immutable(wchar)[]", "wstring");
                    symbol = symbol.replace("immutable(dchar)[]", "dstring");
                }
                frames[i].symbol = symbol;
                string off = captures[4];
                if (off.length) frames[i].offset = parse!size_t(off, 16);

            }
            return StackTrace(frames);
        }
        else {
            assert(false, "not implemented");
        }
    }

}

