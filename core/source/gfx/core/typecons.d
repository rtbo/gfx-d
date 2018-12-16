module gfx.core.typecons;

import std.range.primitives : isInputRange;

/// template that resolves to true if an object of type T can be assigned to null
template isNullAssignable(T) {
    enum isNullAssignable =
        is(typeof((inout int = 0) {
            T t = T.init;
            t = null;
        }));
}

version(unittest) {
    private interface   ITest {}
    private class       CTest {}
    private struct      STest {}
    static assert( isNullAssignable!ITest);
    static assert( isNullAssignable!CTest);
    static assert(!isNullAssignable!STest);
    static assert( isNullAssignable!(STest*));
}

/// constructs an option from a value
auto some(T)(T val) {
    static if (isNullAssignable!T) {
        return Option!T(val);
    }
    else {
        import std.traits : Unqual;
        return Option!(Unqual!T)(val);
    }
}

/// symbolic value that constructs an Option in none state
enum none(T) = Option!(T).init;

/// Check that init value yields a none
unittest {

    auto vopt = none!int;
    assert(vopt.isNone);
    vopt = 12;
    assert(vopt.isSome);
    assert(vopt.front == 12);

    // auto ropt = none!CTest;
    // assert(ropt.isNone);
    // assert(ropt._val is null);
    // ropt = new CTest;
    // assert(vopt.isSome);
}

auto option(R)(R input) if (isInputRange!R)
{
    import std.range.primitives : ElementType;
    alias T = ElementType!R;
    Option!T res;

    if (!input.empty) {
        res = input.front;
        input.popFront();
        assert(input.empty, "attempt to build Option with more than one element)");
    }

    return res;
}


struct Option(T)
{
    import std.traits : Unqual;
    alias ValT = Unqual!T;
    private ValT _val = ValT.init;

    static if (isNullAssignable!ValT) {
        this(inout ValT val) inout {
            _val = val;
        }

        @property bool isSome() const {
            return _val !is null;
        }

        @property bool isNone() const {
            return _val is null;
        }

        void setNone() {
            _val = null;
        }

        void opAssign()(T val) {
            _val = val;
        }
    }
    else {
        private bool _isSome    = false;

        this(inout ValT val) inout {
            _val = val;
            _isSome = true;
        }

        @property bool isSome() const {
            return _isSome;
        }

        @property bool isNone() const {
            return !_isSome;
        }

        void setNone() {
            .destroy(_val);
            _isSome = false;
        }

        void opAssign()(ValT val) {
            _val = val;
            _isSome = true;
        }
    }

    // casting to type that have implicit cast available (e.g Option!int to Option!uint)
    auto opCast(V : Option!U, U)() if (is(T : U)) {
        return Option!U(val_);
    }

    @property ref inout(ValT) get() inout @safe pure nothrow
    {
        enum message = "Called `get' on none Option!" ~ T.stringof ~ ".";
        assert(isSome, message);
        return _val;
    }

    template toString()
    {
        import std.format : FormatSpec, formatValue;
        // Needs to be a template because of DMD @@BUG@@ 13737.
        void toString()(scope void delegate(const(char)[]) sink, FormatSpec!char fmt)
        {
            if (isNull)
            {
                sink.formatValue("Option.none", fmt);
            }
            else
            {
                sink.formatValue(_value, fmt);
            }
        }

        // Issue 14940
        void toString()(scope void delegate(const(char)[]) @safe sink, FormatSpec!char fmt)
        {
            if (isNull)
            {
                sink.formatValue("Option.none", fmt);
            }
            else
            {
                sink.formatValue(_value, fmt);
            }
        }
    }

    // range interface

    @property bool empty() const {
        return isNone;
    }

    @property size_t length() const {
        return isSome ? 1 : 0;
    }

    @property void popFront() {
        setNone();
    }

    static if (isNullAssignable!ValT) {
        @property inout(ValT) front() inout {
            return get;
        }
        @property Option!(inout(ValT)) save() inout {
            return Option!(inout(ValT))(_val);
        }
    }
    else {
        @property ValT front() const {
            return get;
        }

        @property Option!ValT save() const {
            return isSome ? Option!ValT(_val) : none!T;
        }
    }

}


template isOption(T)
{
    import std.traits : TemplateOf;

    static if (__traits(compiles, TemplateOf!T)) {
        enum isOption = __traits(isSame, TemplateOf!T, Option);
    }
    else {
        enum isOption = false;
    }
}

static assert (isOption!(Option!int));
// static assert (isOption!(Option!Object));
static assert (!isOption!(Object));


/// execute fun with option value as parameter if option isSome
auto ifSome(alias fun, OptT)(OptT opt) {
    static assert(isOption!OptT, "ifSome must be called with Option");
    if (opt.isSome) {
        fun(opt.get);
    }
    return opt;
}
/// execute fun without parameter if option isNone
auto ifNone(alias fun, OptT)(OptT opt) {
    static assert(isOption!OptT, "ifNone must be called with Option");
    if (opt.isNone) {
        fun();
    }
    return opt;
}
