/// Vector linear algebra module
module gfx.math.vec;

import std.traits : isFloatingPoint, isNumeric, isStaticArray;

pure @safe nothrow @nogc:

alias Vec2(T) = Vec!(T, 2);
alias Vec3(T) = Vec!(T, 3);
alias Vec4(T) = Vec!(T, 4);

alias DVec(int N) = Vec!(double, N);
alias FVec(int N) = Vec!(float, N);
alias IVec(int N) = Vec!(int, N);

alias DVec2 = Vec!(double, 2);
alias DVec3 = Vec!(double, 3);
alias DVec4 = Vec!(double, 4);

alias FVec2 = Vec!(float, 2);
alias FVec3 = Vec!(float, 3);
alias FVec4 = Vec!(float, 4);

alias IVec2 = Vec!(int, 2);
alias IVec3 = Vec!(int, 3);
alias IVec4 = Vec!(int, 4);


/// Build a Vec whose component type and size is deducted from arguments.
auto vec(Comps...)(Comps comps)
if (Comps.length > 0 && !(Comps.length == 1 && isStaticArray!(Comps[0])))
{
    import std.traits : CommonType, Unqual;
    alias FlatTup = CompTup!(Comps);
    alias CompType = Unqual!(CommonType!(typeof(FlatTup.init.expand)));
    alias ResVec = Vec!(CompType, FlatTup.length);
    return ResVec (comps);
}

/// ditto
auto vec(Arr)(in Arr arr)
if (isStaticArray!Arr)
{
    import std.traits : Unqual;
    alias CompType = Unqual!(typeof(arr[0]));
    alias ResVec = Vec!(CompType, Arr.length);
    return ResVec(arr);
}

///
unittest
{
    import std.algorithm : equal;
    import std.traits : Unqual;

    immutable v1 = vec (1, 2, 4.0, 0); // CommonType!(int, double) is double
    immutable int[4] arr1 = [1, 2, 4, 0];

    static assert( is(Unqual!(typeof(v1)) == DVec4) );

    assert(equal(v1.data, arr1[]));

    immutable int[3] arr2 = [0, 1, 2];
    immutable v2 = vec (arr2);
    static assert( is(Unqual!(typeof(v2)) == IVec3) );
    assert(equal(v2.data, arr2[]));
}

/// Build a Vec with specified component type T and size deducted from arguments.
template vec (T) if (isNumeric!T)
{
    auto vec (Comps...)(Comps comps)
    if (Comps.length > 0 && !(Comps.length == 1 && isStaticArray!(Comps[0])))
    {
        alias ResVec = Vec!(T, numComps!Comps);
        return ResVec (comps);
    }
    auto vec (ArrT)(in ArrT arr)
    if (isStaticArray!ArrT)
    {
        alias ResVec = Vec!(T, ArrT.length);
        return ResVec (arr);
    }
}

/// ditto
alias dvec = vec!double;
/// ditto
alias fvec = vec!float;
/// ditto
alias ivec = vec!int;

///
unittest
{
    import std.algorithm : equal;
    import std.traits : Unqual;

    immutable v1 = dvec (1, 2, 4, 0); // none of the args is double
    immutable int[4] arr1 = [1, 2, 4, 0];
    static assert( is(Unqual!(typeof(v1)) == DVec4) );
    assert(equal(v1.data, arr1[]));

    immutable int[3] arr2 = [0, 1, 2];
    immutable v2 = fvec(arr2);
    static assert( is(Unqual!(typeof(v2)) == FVec3) );
    assert(equal(v2.data, arr2[]));

    immutable int[4] arr3 = [0, 1, 2, 3];
    immutable v3 = dvec (1, 2);
    immutable v4 = dvec (0, v3, 3);
    static assert( is(Unqual!(typeof(v4)) == DVec4) );
    assert(equal(v4.data, arr3[]));
}

/// Build a Vec with specified size and type deducted from arguments
template vec (size_t N)
{
    import std.traits : isDynamicArray, Unqual;

    auto vec (Arr)(in Arr arr) if (isDynamicArray!Arr)
    in {
        assert(arr.length == N);
    }
    body {
        alias CompType = Unqual!(typeof(arr[0]));
        return Vec!(CompType, N)(arr);
    }

    auto vec (T)(in T comp) if (isNumeric!T)
    {
        return Vec!(Unqual!T, N)(comp);
    }
}

/// ditto
alias vec2 = vec!2;
/// ditto
alias vec3 = vec!3;
/// ditto
alias vec4 = vec!4;

///
unittest
{
    import std.algorithm : equal;
    import std.array : staticArray;
    import std.traits : Unqual;

    const double[4] arr1 = [1, 2, 4, 0];
    const v1 = vec4 (arr1[]);            // passing slice to erase compile-time length
    static assert( is(Unqual!(typeof(v1)) == DVec4) );
    assert(equal(v1.data, arr1[]));

    const int comp = 2;
    const v2 = vec4 (comp);
    static assert( is(Unqual!(typeof(v2)) == IVec4) );
    assert(equal(v2.data, staticArray([2, 2, 2, 2])[]));
}


struct Vec(T, size_t N) if(N > 0 && isNumeric!T)
{
    import std.meta : Repeat;
    import std.traits : isArray, isImplicitlyConvertible;
    import std.typecons : Tuple;

    package T[N] _rep = 0;

    static if (isFloatingPoint!T)
    {
        /// A vector with each component set as NaN (not a number)
        enum nan = Vec!(T, N)(T.nan);
    }

    /// The number of components in the vector
    enum length = N;

    /// The type of a vector component
    alias Component = T;

    /// Build a vector from its components
    /// Can be called with any combination of scalar or vectors, as long as
    /// the total number of scalar fit with length
    this (Comps...)(in Comps comps) pure nothrow @nogc @safe
    if (Comps.length > 1)
    {
        import std.conv : to;

        enum nc = numComps!(Comps);
        static assert(nc == N,
            "type sequence "~Comps.stringof~" (size "~nc.to!string~
            ") do not fit the size of "~Vec!(T, N).stringof~" (size "~N.to!string~").");

        const ct = compTup(comps);

        static if (
            is(typeof([ ct.expand ])) &&
            isImplicitlyConvertible!(typeof([ ct.expand ]), typeof(_rep))
        )
        {
            _rep = [ ct.expand ];
        }
        else {
            static foreach (i; 0 .. ct.length) {
                _rep[i] = cast(T)ct[i];
            }
        }
    }

    /// Build a vector from an array.
    this(Arr)(in Arr arr)
    if (isArray!Arr)
    {
        static if (isStaticArray!Arr) {
            static assert(Arr.length == length);
        }
        else {
            assert(arr.length == length);
        }
        static if (is(typeof(arr[0]) == T)) {
            _rep[] = arr;
        }
        else {
            static assert(isImplicitlyConvertible!(typeof(arr[0]), T));
            static foreach (i; 0..N)
            {
                _rep[i] = arr[i];
            }
        }
    }

    /// Build a vector with all components assigned to one value
    this(in T comp)
    {
        _rep = comp;
    }

    // Tuple representation

    /// Alias to a type sequence holding all components
    alias CompSeq = Repeat!(N, T);

    /// All components in a tuple
    @property Tuple!(CompSeq) tup() const
    {
        return Tuple!(CompSeq)(_rep);
    }

    /// Return the data of the array
    @property inout(T)[] data() inout
    {
        return _rep[];
    }

    /// All components in a static array
    @property T[length] array() const
    {
        return _rep;
    }

    // access by name and swizzling

    private template compNameIndex(char c)
    {
        static if (c == 'x' || c == 'r' || c == 's' || c == 'u')
        {
            enum compNameIndex = 0;
        }
        else static if (c == 'y' || c == 'g' || c == 't' || c == 'v')
        {
            enum compNameIndex =  1;
        }
        else static if (c == 'z' || c == 'b' || c == 'p')
        {
            static assert (N >= 3, "component "~c~" is only accessible with 3 or more components vectors");
            enum compNameIndex =  2;
        }
        else static if (c == 'w' || c == 'a' || c == 'q')
        {
            static assert (N >= 4, "component "~c~" is only accessible with 4 or more components vectors");
            enum compNameIndex =  3;
        }
        else
        {
            static assert (false, "component "~c~" is not recognized");
        }
    }

    /// Access the component by name.
    @property T opDispatch(string name)() const
    if (name.length == 1)
    {
        return _rep[compNameIndex!(name[0])];
    }

    /// Assign the component by name.
    @property void opDispatch(string name)(in T val)
    if (name.length == 1)
    {
        _rep[compNameIndex!(name[0])] = val;
    }

    /// Access the components by swizzling.
    @property auto opDispatch(string name)() const
    if (name.length > 1)
    {
        Vec!(T, name.length) res;
        static foreach (i; 0 .. name.length) {
            res[i] = _rep[compNameIndex!(name[i])];
        }
        return res;
    }

    /// Assign the components by swizzling.
    @property void opDispatch(string name, U, size_t num)(in Vec!(U, num) v)
    if (isImplicitlyConvertible!(U, T))
    {
        static assert(name.length == num, name~" number of components do not match with type "~(Vec!(U, num).stringof));
        static foreach (i; 0 .. name.length)
        {
            _rep[compNameIndex!(name[i])] = v[i];
        }
    }

    /// Cast the vector to another type of component
    auto opCast(V)() const if (isVec!(length, V))
    {
        V res;
        static foreach (i; 0 .. length) {
            res[i] = cast(V.Component)_rep[i];
        }
        return res;
    }

    /// Unary "+" operation.
    Vec!(T, N) opUnary(string op : "+")() const
    {
        return this;
    }
    /// Unary "-" operation.
    Vec!(T, N) opUnary(string op : "-")() const
    {
        Vec!(T, N) res = this;
        static foreach (i; 0 .. length) {
            res[i] = -res[i];
        }
        return res;
    }

    /// Perform a term by term assignment operation on the vector.
    ref Vec!(T, N) opOpAssign(string op, U)(in Vec!(U, N) oth)
            if ((op == "+" || op == "-" || op == "*" || op == "/") && isNumeric!U)
    {
        foreach (i, ref v; _rep)
        {
            mixin("v " ~ op ~ "= oth[i];");
        }
        return this;
    }

    /// Perform a scalar assignment operation on the vector.
    ref Vec!(T, N) opOpAssign(string op, U)(in U val)
            if ((op == "+" || op == "-" || op == "*" || op == "/" || (op == "%"
                && __traits(isIntegral, U))) && isNumeric!U)
    {
        foreach (ref v; _rep)
        {
            mixin("v " ~ op ~ "= val;");
        }
        return this;
    }

    /// Perform a term by term operation on the vector.
    Vec!(T, N) opBinary(string op, U)(in Vec!(U, N) oth) const
            if ((op == "+" || op == "-" || op == "*" || op == "/") && isNumeric!U)
    {
        Vec!(T, N) res = this;
        mixin("res " ~ op ~ "= oth;");
        return res;
    }

    /// Perform a scalar operation on the vector.
    Vec!(T, N) opBinary(string op, U)(in U val) const
            if ((op == "+" || op == "-" || op == "*" || op == "/" || (op == "%"
                && isIntegral!U)) && isNumeric!U)
    {
        Vec!(T, N) res = this;
        mixin("res " ~ op ~ "= val;");
        return res;
    }

    /// Perform a scalar operation on the vector.
    Vec!(T, N) opBinaryRight(string op, U)(in U val) const
            if ((op == "+" || op == "-" || op == "*" || op == "/" || (op == "%"
                && __traits(isIntegral, U))) && isNumeric!U)
    {
        Vec!(T, N) res = void;
        static foreach (i; 0 .. N) {
            mixin("res[i] = val " ~ op ~ " _rep[i];");
        }
        return res;
    }

    /// Foreach support.
    @system int opApply(int delegate(size_t i, ref T) dg)
    {
        int res;
        foreach (i, ref v; _rep)
        {
            res = dg(i, v);
            if (res)
                break;
        }
        return res;
    }

    /// Foreach support.
    @system int opApply(int delegate(ref T) dg)
    {
        int res;
        foreach (ref v; _rep)
        {
            res = dg(v);
            if (res)
                break;
        }
        return res;
    }

    /// Foreach support.
    @safe int opApply(int delegate(size_t i, ref T) @safe dg)
    {
        int res;
        foreach (i, ref v; _rep)
        {
            res = dg(i, v);
            if (res)
                break;
        }
        return res;
    }

    /// Foreach support.
    @safe int opApply(int delegate(ref T) @safe dg)
    {
        int res;
        foreach (ref v; _rep)
        {
            res = dg(v);
            if (res)
                break;
        }
        return res;
    }

    // TODO: const opApply and foreach_reverse

    /// Index a vector component.
    T opIndex(in size_t index) const
    in {
        assert(index < N);
    }
    body {
        return _rep[index];
    }

    /// Assign a vector component.
    void opIndexAssign(in T val, in size_t index)
    in {
        assert(index < N);
    }
    body {
        _rep[index] = val;
    }

    /// Assign a vector component.
    void opIndexOpAssign(string op)(in T val, in size_t index)
    if (op == "+" || op == "-" || op == "*" || op == "/")
    in {
        assert(index < N);
    }
    body {
        mixin("_rep[index] "~op~"= val;");
    }

    /// Slicing support
    size_t[2] opSlice(in size_t start, in size_t end) const {
        assert(start <= end && end <= length);
        return [ start, end ];
    }

    /// ditto
    inout(T)[] opIndex(in size_t[2] slice) inout {
        return _rep[slice[0] .. slice[1]];
    }

    /// ditto
    inout(T)[] opIndex() inout {
        return _rep[];
    }

    /// ditto
    void opIndexAssign(U)(in U val, in size_t[2] slice) {
        assert(correctSlice(slice));
        _rep[slice[0] .. slice[1]] = val;
    }

    /// ditto
    void opIndexAssign(U)(in U[] val, in size_t[2] slice) {
        assert(val.length == slice[1]-slice[0] && correctSlice(slice));
        _rep[slice[0] .. slice[1]] = val;
    }

    /// ditto
    void opIndexAssign(U)(in U[] val) {
        assert(val.length == length);
        _rep[] = val;
    }

    /// ditto
    void opIndexOpAssign(string op, U)(in U val, in size_t[2] slice)
    if (op == "+" || op == "-" || op == "*" || op == "/")
    {
        foreach (i; slice[0]..slice[1]) {
            mixin("_rep[i] "~op~"= val;");
        }
    }

    /// Term by term sliced assignement operation.
    void opIndexOpAssign(string op, U)(in U val, in size_t[2] slice)
    if (op == "+" || op == "-" || op == "*" || op == "/")
    {
        foreach (i; slice[0]..slice[1]) {
            mixin("_rep[i] "~op~"= val;");
        }
    }

    /// End of the vector.
    size_t opDollar()
    {
        return length;
    }

    string toString() const
    {
        string res = "[ ";
        foreach(i, c; _rep)
        {
            import std.format : format;
            immutable fmt = i == length-1 ? "%s " : "%s, ";
            res ~= format(fmt, c);
        }
        return res ~ "]";
    }

    private static bool correctSlice(size_t[2] slice)
    {
        return slice[0] <= slice[1] && slice[1] <= length;
    }
}

///
unittest
{
    DVec3 v;

    assert(v._rep[0] == 0);
    assert(v._rep[1] == 0);
    assert(v._rep[2] == 0);

    v = DVec3(4, 5, 6);

    assert(v._rep[0] == 4);
    assert(v._rep[1] == 5);
    assert(v._rep[2] == 6);
    assert(v[1] == 5);
    assert(v.z == 6);
    assert(v[$ - 1] == 6);

    assert(-v == DVec3(-4, -5, -6));

    v.z = 2;
    v[1] = 1;
    assert(v[1] == 1);
    assert(v.z == 2);

    auto c = DVec4(0.2, 1, 0.6, 0.9);
    assert(c.r == 0.2);
    assert(c.g == 1);
    assert(c.b == 0.6);
    assert(c.a == 0.9);

    assert(c.rrwuzy == DVec!6(0.2, 0.2, 0.9, 0.2, 0.6, 1));
    c.bgra = DVec4(0.3, 0.4, 0.5, 0.6);
    assert(c.data == [0.5, 0.4, 0.3, 0.6]);
}


/// Compute the dot product of two vectors.
template dot(T, size_t N)
{
    T dot(in Vec!(T, N) v1, in Vec!(T, N) v2)
    pure nothrow @nogc @safe
    {
        T sum = 0;
        static foreach (i; 0 .. N)
        {
            sum += v1[i] * v2[i];
        }
        return sum;
    }
}

/// Compute the magnitude of a vector.
/// This is not to be confused with length which gives the number of components.
template magnitude(T, size_t N)
{
    T magnitude(in Vec!(T, N) v)
    pure nothrow @nogc @safe
    {
        import std.math : sqrt;
        return sqrt(squaredMag(v));
    }
}

/// Compute the squared magnitude of a vector.
template squaredMag(T, size_t N)
{
    T squaredMag(in Vec!(T, N) v)
    pure nothrow @nogc @safe
    {
        T sum = 0;
        static foreach (i; 0 .. N)
        {
            sum += v[i] * v[i];
        }
        return sum;
    }
}

/// Compute the normalization of a vector.
template normalize(T, size_t N) if (isFloatingPoint!T)
{
    import gfx.math.approx : approxUlpAndAbs;

    Vec!(T, N) normalize(in Vec!(T, N) v)
    pure nothrow @nogc @safe
    in {
        assert(!approxUlpAndAbs(magnitude(v), 0), "Cannot normalize a null vector.");
    }
    out (res) {
        assert(approxUlpAndAbs(magnitude(res), 1));
    }
    body
    {
        import std.math : sqrt;
        return v / magnitude(v);
    }
}

/// Vector cross product
template cross(T)
{
    Vec!(T, 3) cross(in Vec!(T, 3) lhs, in Vec!(T, 3) rhs)
    pure nothrow @nogc @safe
    {
        return Vec!(T, 3)(
            lhs[1]*rhs[2] - lhs[2]*rhs[1],
            lhs[2]*rhs[0] - lhs[0]*rhs[2],
            lhs[0]*rhs[1] - lhs[1]*rhs[0],
        );
    }
}

static assert(DVec2.sizeof == 16);
static assert(DVec3.sizeof == 24);
static assert(DVec4.sizeof == 32);

///
unittest
{
    import gfx.math.approx : approxUlp;

    auto v1 = DVec3(12, 4, 3);
    auto v2 = DVec3(-5, 3, 7);

    assert(approxUlp(dot(v1, v2), -27));

    auto v = DVec3(3, 4, 5);
    assert(approxUlp(squaredMag(v), 50));

    assert(approxUlp(normalize(FVec3(4, 0, 0)), FVec3(1, 0, 0)));
}


/// Check whether VecT is a Vec
template isVec(VecT)
{
    import std.traits : TemplateOf;
    static if (is(typeof(__traits(isSame, TemplateOf!VecT, Vec))))
    {
        enum isVec = __traits(isSame, TemplateOf!VecT, Vec);
    }
    else
    {
        enum isVec = false;
    }
}

static assert( isVec!(FVec2) );
static assert( !isVec!double );

/// Check whether VecT is a Vec of size N
template isVec(size_t N, VecT)
{
    static if (is(typeof(VecT.length)))
    {
        enum isVec = isVec!VecT && VecT.length == N;
    }
    else
    {
        enum isVec = false;
    }
}

/// ditto
enum isVec2(VecT) = isVec!(2, VecT);
/// ditto
enum isVec3(VecT) = isVec!(3, VecT);
/// ditto
enum isVec4(VecT) = isVec!(4, VecT);


package:

import std.typecons : Tuple;

template CompTup(T...)
{
    alias CompTup = typeof(compTup(T.init));
}

auto compTup(T...)(T vals) pure nothrow @nogc @safe
{
    import std.meta : Repeat;
    import std.traits : Unqual;
    import std.typecons : tuple;

    static if (T.length == 0) {
        return tuple();
    }
    else static if (T.length == 1 && isNumeric!(T[0])) {
        return tuple(vals[0]);
    }
    else static if (T.length == 1 && isStaticArray!(T[0])) {
        alias U = Unqual!(typeof(T[0][0]));
        return Tuple!(Repeat!(T[0].length, U))(vals);
    }
    else static if (T.length == 1 && isVec!(T[0])) {
        return vals[0].tup;
    }
    else static if (T.length > 1) {
        return tuple(compTup(vals[0]).expand, compTup(vals[1 .. $]).expand);
    }
    else {
        static assert(false, "wrong arguments to compTup");
    }
}

enum numComps(T...) = CompTup!(T).length;

static assert (numComps!DVec3 == 3);
static assert (is(CompTup!DVec3 == Tuple!(double, double, double)));
static assert (is(CompTup!(DVec2, int, float) == Tuple!(double, double, int, float)));


static assert(isVec!FVec3);
