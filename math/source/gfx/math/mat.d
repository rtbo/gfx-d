/// Matrix linear algebra module
module gfx.math.mat;

pure @safe nothrow:

alias FMat(size_t R, size_t C) = Mat!(float, R, C);
alias DMat(size_t R, size_t C) = Mat!(double, R, C);
alias IMat(size_t R, size_t C) = Mat!(int, R, C);

alias Mat2x2(T) = Mat!(T, 2, 2);
alias Mat3x3(T) = Mat!(T, 3, 3);
alias Mat4x4(T) = Mat!(T, 4, 4);
alias Mat2x3(T) = Mat!(T, 2, 3);
alias Mat2x4(T) = Mat!(T, 2, 4);
alias Mat3x4(T) = Mat!(T, 3, 4);
alias Mat3x2(T) = Mat!(T, 3, 2);
alias Mat4x2(T) = Mat!(T, 4, 2);
alias Mat4x3(T) = Mat!(T, 4, 3);

alias FMat2x2 = Mat!(float, 2, 2);
alias FMat3x3 = Mat!(float, 3, 3);
alias FMat4x4 = Mat!(float, 4, 4);
alias FMat2x3 = Mat!(float, 2, 3);
alias FMat2x4 = Mat!(float, 2, 4);
alias FMat3x4 = Mat!(float, 3, 4);
alias FMat3x2 = Mat!(float, 3, 2);
alias FMat4x2 = Mat!(float, 4, 2);
alias FMat4x3 = Mat!(float, 4, 3);

alias DMat2x2 = Mat!(double, 2, 2);
alias DMat3x3 = Mat!(double, 3, 3);
alias DMat4x4 = Mat!(double, 4, 4);
alias DMat2x3 = Mat!(double, 2, 3);
alias DMat2x4 = Mat!(double, 2, 4);
alias DMat3x4 = Mat!(double, 3, 4);
alias DMat3x2 = Mat!(double, 3, 2);
alias DMat4x2 = Mat!(double, 4, 2);
alias DMat4x3 = Mat!(double, 4, 3);

alias IMat2x2 = Mat!(int, 2, 2);
alias IMat3x3 = Mat!(int, 3, 3);
alias IMat4x4 = Mat!(int, 4, 4);
alias IMat2x3 = Mat!(int, 2, 3);
alias IMat2x4 = Mat!(int, 2, 4);
alias IMat3x4 = Mat!(int, 3, 4);
alias IMat3x2 = Mat!(int, 3, 2);
alias IMat4x2 = Mat!(int, 4, 2);
alias IMat4x3 = Mat!(int, 4, 3);

// further shortcuts
alias Mat2(T) = Mat2x2!T;
alias Mat3(T) = Mat3x3!T;
alias Mat4(T) = Mat4x4!T;
alias FMat2 = FMat2x2;
alias FMat3 = FMat3x3;
alias FMat4 = FMat4x4;
alias DMat2 = DMat2x2;
alias DMat3 = DMat3x3;
alias DMat4 = DMat4x4;
alias IMat2 = IMat2x2;
alias IMat3 = IMat3x3;
alias IMat4 = IMat4x4;

/// Build a matrix whose component type and size is inferred from arguments.
/// Arguments must be rows or matrices with consistent column count.
auto mat(Rows...)(in Rows rows)
{
    import gfx.math.vec : CompTup;
    import std.traits : CommonType;

    static assert(hasConsistentLength!Rows, "All rows must have the same number of components");
    immutable rt = rowTuple(rows);
    alias CT = CompTup!(typeof(rt).Types);
    alias Comp = CommonType!(CT.Types);
    enum rowLength = rt.length;
    enum colLength = rt[0].length;
    return Mat!(Comp, rowLength, colLength)(rt.expand);
}

///
unittest
{
    import gfx.math.vec : dvec;
    import std.algorithm : equal;
    import std.traits : Unqual;

    immutable r1 = dvec(1, 2, 3);
    immutable r2 = dvec(4, 5, 6);
    immutable m1 = mat(r1, r2);
    static assert( is(Unqual!(typeof(m1)) == DMat2x3) );
    assert(equal(m1.data, [ 1, 2, 3, 4, 5, 6 ]));

    immutable m2 = mat(r2, m1, r1);
    static assert( is(Unqual!(typeof(m2)) == DMat4x3) );
    assert(equal(m2.data, [ 4, 5, 6, 1, 2, 3, 4, 5, 6, 1, 2, 3]));

    // The following would yield an inconsistent column count.
    static assert( !__traits(compiles, mat(r1, dvec(1, 2))) );
}

/// Matrix type for linear algebra
struct Mat(T, size_t R, size_t C)
{
    import gfx.math.vec : isVec, Vec;
    import std.meta : allSatisfy, Repeat;
    import std.traits : CommonType, isArray, isNumeric, isImplicitlyConvertible;
    import std.typecons : Tuple;

    private T[R*C] _rep;

    /// The number of rows in the matrix.
    enum rowLength = R;
    /// The number of columns in the matrix.
    enum columnLength = C;
    /// The number of components in the matrix;
    enum compLength = R*C;
    /// The matrix rows type.
    alias Row = Vec!(T, columnLength);
    /// The matrix columns type.
    alias Column = Vec!(T, rowLength);
    /// The type of the componetypeof(rt.expand)nts.
    alias Component = T;
    /// row major container: length is the number of rows
    enum length = rowLength;

    /// The identity matrix.
    enum identity = mixin(identityCode);


    /// Build a matrix from its elements.
    /// To be provided row major.
    this (Args...)(in Args args)
    if (Args.length == R*C && allSatisfy!(isNumeric, Args) &&
        isImplicitlyConvertible!(CommonType!Args, T))
    {
        _rep = [ args ];
    }

    /// Build a matrix from the provided rows.
    /// Each row must be an array (static or dynamic) and have the correct number
    /// of elements.
    this (Args...)(in Args args)
    if (Args.length == rowLength && allSatisfy!(isArray, Args))
    {
        import std.traits : isStaticArray;

        static if (allSatisfy!(isStaticArray, Args)) {
            static foreach (r, arg; args) {
                static assert(arg.length == columnLength);
                _rep[ r*columnLength .. (r+1)*columnLength ] = arg;
            }
        }
        else {
            foreach (r, arg; args) {
                assert(arg.length == columnLength);
                _rep[ r*columnLength .. (r+1)*columnLength ] = arg;
            }
        }
    }

    /// ditto
    this (Args...)(in Args args)
    if (Args.length == rowLength && allSatisfy!(isVec, Args))
    {
        static foreach(r, arg; args)
        {
            static assert(arg.length == columnLength, "incorrect row size");
            static if (is(typeof(arg[0]) == T))
            {
                _rep[r*columnLength .. (r+1)*columnLength] = arg._rep;
            }
            else
            {
                static foreach (c; 0 .. columnLength)
                {
                    _rep[r*columnLength + c] = cast(T)arg[c];
                }
            }
        }
    }

    // representation in tuple

    /// Alias to a type sequence holding all rows
    alias RowSeq = Repeat!(rowLength, Row);
    /// Alias to a type sequence holding all components
    alias CompSeq = Repeat!(rowLength*columnLength, T);

    /// All rows in a tuple
    @property Tuple!RowSeq rowTup() const
    {
        return Tuple!RowSeq(cast(Row[rowLength])_rep);
    }
    /// All components in a tuple
    @property Tuple!CompSeq compTup() const
    {
        return Tuple!CompSeq(_rep);
    }

    // array representation

    /// Direct access to underlying data.
    /// Reminder: row major order!
    @property inout(Component)[] data() inout
    {
        return _rep[];
    }

    /// Cast a matrix to another type
    Mat!(U, rowLength, columnLength) opCast(V : Mat!(U, rowLength, columnLength), U)() const
    if (__traits(compiles, cast(U)T.init))
    {
        Mat!(U, rowLength, columnLength) res = void;
        static foreach (i; 0 .. compLength) {
            res._rep[i] = cast(U)_rep[i];
        }
        return res;
    }

    // compile time indexing

    /// Index a component at compile time
    @property Component ct(size_t r, size_t c)() const
    {
        static assert(r < rowLength && c < columnLength);
        enum ind = r*columnLength + c;
        return _rep[ind];
    }

    /// Assign a compile time indexed component
    void ct(size_t r, size_t c)(in Component comp)
    {
        static assert(r < rowLength && c < columnLength);
        enum ind = r*columnLength + c;
        _rep[ind] = comp;
    }

    /// Index a row at compile time
    @property Row ct(size_t r)() const
    {
        static assert(r < rowLength);
        enum start = r*columnLength;
        enum end = (r+1)*columnLength;
        return Row(_rep[start .. end]);
    }

    /// Assign a row indexed at compile time
    void ct(size_t r)(in Row row)
    {
        static assert(r < rowLength);
        enum start = r*columnLength;
        enum end = (r+1)*columnLength;
        _rep[start .. end] = row.array;
    }

    /// Index a column at compile time
    @property Column ctCol(size_t c)() const
    {
        static assert(c < columnLength);
        Column col = void;
        static foreach (r; 0 .. rowLength) {{
            enum ind = r*columnLength + c;
            col[r] = _rep[ind];
        }}
        return col;
    }

    /// Assign a column indexed at compile time
    void ctCol(size_t c)(in Column col)
    {
        static assert(r < columnLength);
        static foreach (r; 0 .. rowLength) {{
            enum ind = r*columnLength + c;
            _rep[ind] = col[r];
        }}
    }

    // runtime indexing

    /// Index a matrix row.
    Row row(in size_t r) const
    {
        assert(r < rowLength);
        return Row(_rep[r*columnLength .. (r+1)*columnLength]);
    }

    /// Index a matrix column.
    Column column(in size_t c) const
    {
        assert(c < columnLength);
        Column res=void;
        static foreach (r; 0 .. rowLength)
        {
            res[r] = _rep[index(r, c)];
        }
        return res;
    }

    /// Index a matrix component
    T comp(in size_t r, in size_t c) const
    {
        return _rep[index(r, c)];
    }

    /// Return a slice of the matrix
    @property Mat!(T, RE-RS, CE-CS) slice(size_t RS, size_t RE, size_t CS, size_t CE)() const
    if (RE > RS && RE <= rowLength && CE > CS && CE <= columnLength)
    {
        Mat!(T, RE-RS, CE-CS) res = void;
        static foreach (r; RS .. RE)
        {
            static foreach (c; CS .. CE)
            {
                res[r-RS, c-CS] = comp(r, c);
            }
        }
        return res;
    }

    /// Assign a slice of this matrix
    /// e.g: $(D_CODE mat.slice!(0, 2) = otherMat;)
    @property void slice(size_t RS, size_t CS, U, size_t UR, size_t UC)(in Mat!(U, UR, UC) mat)
    if (RS+UR <= rowLength && CS+UC <= columnLength && isImplicitlyConvertible!(U, T))
    {
        static foreach (r; 0 .. UR)
        {
            static foreach (c; 0 .. UC)
            {
                _rep[index(r+RS, c+CS)] = mat[r, c];
            }
        }
    }

    /// Build an augmented matrix (add oth to the right of this matrix)
    /// ---
    /// immutable m = IMat2(4, 5, 6, 8);
    /// assert( m ~ IMat2.identity == IMat2x4(4, 5, 1, 0, 6, 8, 0, 1));
    /// ---
    auto opBinary(string op, U, size_t UC)(in Mat!(U, rowLength, UC) mat) const
    if (op == "~")
    {
        alias ResMat = Mat!(CommonType!(T, U), rowLength, columnLength+UC);
        ResMat res = void;
        static foreach (r; 0 .. rowLength) {
            static foreach (c; 0 .. columnLength) {
                res[r, c] = _rep[index(r, c)];
            }
            static foreach (c; columnLength .. columnLength+UC) {
                res[r, c] = mat[r, c-columnLength];
            }
        }
        return res;
    }

    /// Index a matrix component.
    T opIndex(in size_t r, in size_t c) const
    {
        return _rep[index(r, c)];
    }

    /// Assign a matrix component.
    void opIndexAssign(in T val, in size_t r, in size_t c)
    {
        _rep[index(r, c)] = val;
    }

    /// Apply op on a matrix component.
    void opIndexOpAssign(string op)(in T val, in size_t r, in size_t c)
    if (op == "+" || op == "-" || op == "*" || op == "/")
    {
        mixin("_rep[index(r, c)] "~op~"= val;");
    }

    /// Index a matrix row
    Row opIndex(in size_t r) const
    {
        return row(r);
    }

    /// Assign a row
    void opIndexAssign(in Row row, in size_t r) {
        _rep[r*columnLength .. (r+1)*columnLength] = row.data;
    }

    /// Number of components per direction.
    size_t opDollar(size_t i)() const
    {
        static assert(i < 2, "A matrix only has 2 dimensions.");
        static if(i == 0)
        {
            return rowLength;
        }
        else
        {
            return columnLength;
        }
    }

    /// Add/Subtract by a matrix to its right.
    auto opBinary(string op, U)(in Mat!(U, rowLength, columnLength) oth) const
    if ((op == "+" || op == "-") && !is(CommonType!(T, U) == void))
    {
        alias ResMat = Mat!(CommonType!(T, U), rowLength, columnLength);
        ResMat res = void;
        static foreach (i; 0 .. rowLength*columnLength)
        {
            mixin("res._rep[i] = _rep[i] "~op~" oth._rep[i];");
        }
        return res;
    }

    /// Multiply by a matrix to its right.
    auto opBinary(string op, U, size_t UR, size_t UC)(in Mat!(U, UR, UC) oth) const
    if (op == "*" && columnLength == UR && !is(CommonType!(T, U) == void))
    {
        // multiply the rows of this by the columns of oth.
        //  1 2 3     7 8     1*7 + 2*9 + 3*3   1*8 + 2*1 + 3*5
        //  4 5 6  x  9 1  =  4*7 + 5*9 + 6*3   4*8 + 5*9 + 6*3
        //            3 5

        alias ResMat = Mat!(CommonType!(T, U), rowLength, UC);
        ResMat res = void;

        // following is tested but reduces performance by an order of magnitude
        // it vectorizes row * col multiplication but has more indexing and moving of data
        // import core.simd : float4;
        // static if (is(T==float) && is(U==float) && R==4 && C==4 && __traits(compiles, float4.init * float4.init)) {
        //     static foreach (r; 0 .. 4)
        //     {
        //         static foreach (c; 0 .. 4)
        //         {{
        //             float4 thisRow;
        //             float4 othCol;
        //             float4 vecRes;
        //             thisRow.array[0..4] = (ct!r).array;
        //             othCol.array[0..4] = (oth.ctCol!c).array;
        //             vecRes = thisRow * othCol;

        //             float[4] arr = vecRes.array;
        //             ResMat.Component resComp = 0;
        //             static foreach (rc; 0 .. columnLength)
        //             {
        //                 resComp += arr[rc];
        //             }
        //             res.ct!(r, c) = resComp;
        //         }}
        //     }
        // }
        // else {
            static foreach(r; 0 .. rowLength)
            {
                static foreach (c; 0 .. UC)
                {{
                    ResMat.Component resComp = 0;
                    static foreach (rc; 0 .. columnLength)
                    {
                        resComp += ct!(r, rc) * oth.ct!(rc, c);
                    }
                    res.ct!(r, c) = resComp;
                }}
            }
        // }

        return res;
    }

    /// Multiply a matrix by a vector to its right.
    auto opBinary(string op, U, size_t N)(in Vec!(U, N) vec) const
    if (op == "*" && N == columnLength && !is(CommonType!(T, U) == void))
    {
        // same as matrix with one column
        alias ResVec = Vec!(CommonType!(T, U), rowLength);
        ResVec res = void;
        static foreach (r; 0 .. rowLength)
        {{
            ResVec.Component resComp = 0;
            static foreach (c; 0 .. columnLength)
            {
                resComp += ct!(r, c) * vec[c];
            }
            res[r] = resComp;
        }}
        return res;
    }

    /// Multiply a matrix by a vector to its left.
    auto opBinaryRight(string op, U, size_t N)(in Vec!(U, N) vec) const
    if (op == "*" && N == rowLength && !is(CommonType!(T, U) == void))
    {
        // same as matrix with one row
        alias ResVec = Vec!(CommonType!(T, U), columnLength);
        ResVec res = void;
        static foreach (c; 0 .. columnLength)
        {{
            ResVec.Component resComp = 0;
            static foreach (r; 0 .. rowLength)
            {
                resComp += vec[r] * ct!(r, c);
            }
            res[c] = resComp;
        }}
        return res;
    }


    /// Operation of a matrix with a scalar on its right.
    auto opBinary(string op, U)(in U val) const
    if ((op == "+" || op == "-" || op == "*" || op == "/") &&
        !is(CommonType!(T, U) == void))
    {
        // import core.simd;

        alias ResT = CommonType!(T, U);
        alias ResMat = Mat!(ResT, rowLength, columnLength);
        ResMat res = void;

        // static if ((compLength%8)==0 && hasSIMD && hasAVX && is(ResT == float) && is(typeof(mixin("float8.init"~op~"val")))) {
        //     simdScalarOp!(ResMat, U, float8, 8, "vec"~op~"val")(res, val);
        // }
        // else static if ((compLength%4)==0 && hasSIMD && is(ResT == float) && is(typeof(mixin("float4.init"~op~"val")))) {
        //     simdScalarOp!(ResMat, U, float4, 4, "vec"~op~"val")(res, val);
        // }
        // else {
            static foreach (i; 0 .. compLength) {
                mixin("res._rep[i] = _rep[i] "~op~" val;");
            }
        // }
        return res;
    }

    /// Operation of a matrix with a scalar on its left.
    auto opBinaryRight(string op, U)(in U val) const
    if ((op == "+" || op == "-" || op == "*" || op == "/") &&
        !is(CommonType!(T, U) == void))
    {
        // import core.simd;

        alias ResT = CommonType!(T, U);
        alias ResMat = Mat!(ResT, rowLength, columnLength);
        ResMat res = void;

        // static if ((compLength%8)==0 && hasSIMD && hasAVX && is(ResT == float) && is(typeof(mixin("val"~op~"float8.init")))) {
        //     simdScalarOp!(ResMat, U, float8, 8, "val"~op~"vec")(res, val);
        // }
        // else static if ((compLength%4)==0 && hasSIMD && is(ResT == float) && is(typeof(mixin("val"~op~"float4.init")))) {
        //     simdScalarOp!(ResMat, U, float4, 4, "val"~op~"vec")(res, val);
        // }
        // else {
            static foreach (i; 0 .. compLength) {
                mixin("res._rep[i] = val "~op~" _rep[i];");
            }
        // }
        return res;
    }

    /// Assign operation of a matrix with a scalar on its right.
    auto opOpAssign(string op, U)(in U val)
    if ((op == "+" || op == "-" || op == "*" || op == "/") &&
        !is(CommonType!(T, U) == void))
    {
        static foreach (i; 0 .. compLength) {
            mixin("_rep[i] "~op~"= val;");
        }
        return this;
    }

    /// Assign operation of a matrix with a matrix on its right.
    auto opOpAssign(string op, M)(in M mat)
    if ((op == "+" || op == "-" || op == "*") && is(typeof(mixin("this"~op~"mat"))))
    {
        const newThis = mixin("this "~op~" mat");
        _rep = newThis._rep;
        return this;
    }

    string toString() const
    {
        /// [
        ///     [      1.0000,       2.0000 ],
        ///     [      3.0000,       4.0000 ]
        /// ]
        import std.format : format;

        string res = "[\n";
        static foreach (r; 0 .. rowLength)
        {{
            import std.traits : isFloatingPoint;

            static if (isFloatingPoint!T) {
                enum fmt = "   [ %(%#10.4f%|, %) ]";
            }
            else {
                enum fmt = "   [ %(% 10s%|, %) ]";
            }
            res ~= format(fmt, _rep[r*columnLength .. (r+1)*columnLength]);
            if (r != rowLength-1) res ~= ",\n";
            else res ~= "\n";
        }}
        return res ~ "]";
    }

    private static @property ctIndex(size_t r, size_t c)()
    {
        static assert(r < rowLength && c < columnLength);
        return r * columnLength + c;
    }

    private static size_t index(in size_t r, in size_t c)
    {
        assert(r < rowLength && c < columnLength);
        return r * columnLength + c;
    }

    private static @property string identityCode()
    {
        string code = "Mat (";
        foreach (r; 0 .. rowLength)
        {
            foreach (c; 0 .. columnLength)
            {
                code ~= r == c ? "1, " : "0, ";
            }
        }
        return code ~ ")";
    }

    private void simdScalarOp(M, U, SimdVecT, size_t size, string expr)(ref M res, in U val) const
    {
        static assert( (compLength % size) == 0 );
        SimdVecT vec = void;
        static foreach (i; 0 .. compLength/size) {{
            enum start = i*size; enum end = start+size;
            vec.array[0 .. size] = _rep[start .. end];
            vec = mixin(expr);
            res._rep[start .. end] = vec.array[0 .. size];
        }}
    }
}

///
unittest
{
    import gfx.math.approx : approxUlp;

    assert(approxUlp(FMat2x2.identity, FMat2x2(
        1, 0,
        0, 1
    )));
}

///
unittest
{
    import gfx.math.approx : approxUlp;

    immutable ml = Mat!(float, 2, 3)(
        1, 2, 3,
        4, 5, 6,
    );
    immutable mr = Mat!(float, 3, 2)(
        1, 2,
        3, 4,
        5, 6,
    );
    immutable exp = Mat!(float, 2, 2)(
        1+6+15,  2+8+18,
        4+15+30, 8+20+36
    );
    assert(approxUlp(ml * mr, exp));
}

/// Give the transposed form of a matrix.
auto transpose(M)(in M mat) if (isMat!M)
{
    alias T = M.Component;
    enum R = M.rowLength;
    enum C = M.columnLength;

    Mat!(T, C, R) res = void;
    static foreach (r; 0 .. R) {
        static foreach (c; 0 .. C) {
            res[c, r] = mat[r, c];
        }
    }
    return res;
}

/// Compute the inverse of a matrix with Gaussian elimination method.
/// Complexity O(n3).
@property M gaussianInverse(M)(in M mat)
if (isMat!M)
{
    import std.traits : isFloatingPoint;

    static assert(isFloatingPoint!(M.Component), "gaussianInverse only works with floating point matrices");
    static assert(M.rowLength == M.columnLength, "gaussianInverse only works with square matrices");

    alias T = M.Component;
    enum N = M.rowLength;

    auto pivot = mat ~ Mat!(real, N, N).identity;
    static assert(is(pivot.Component == real));
    ptrdiff_t pivotR = -1;
    static foreach (c; 0 .. N)
    {{
        // find the max row of column c.
        auto colMax = pivot[pivotR+1, c];
        ptrdiff_t maxR = pivotR+1;
        foreach (r; pivotR+2 .. N)
        {
            const val = pivot[r, c];
            if (val > colMax)
            {
                maxR = r;
                colMax = val;
            }
        }
        if (colMax != 0)
        {
            pivotR += 1;
            // normalizing the row where the max was found
            static foreach (cc; 0 .. 2*N)
            {
                pivot[maxR, cc] /= colMax;
            }
            // switching pivot row with the max row
            if (pivotR != maxR)
            {
                static foreach (cc; 0 .. 2*N)
                {{
                    const swapTmp = pivot[maxR, cc];
                    pivot[maxR, cc] = pivot[pivotR, cc];
                    pivot[pivotR, cc] = swapTmp;
                }}
            }
            static foreach (r; 0 .. N)
            {
                if (r != pivotR)
                {
                    const fact = pivot.ct!(r, c);
                    if (fact != 0)
                    {
                        static foreach (cc; 0 .. 2*N)
                        {
                            pivot.ct!(r, cc) = pivot.ct!(r, cc) - fact * pivot[pivotR, cc];
                        }
                    }
                }
            }
        }
    }}
    return cast(Mat!(T, N, N)) pivot.slice!(0, N, N, 2*N);
}

///
unittest
{
    /// Example from https://en.wikipedia.org/wiki/Gaussian_elimination
    const m = FMat3(
        2, -1, 0,
        -1, 2, -1,
        0, -1, 2
    );
    const invM = gaussianInverse(m);

    import gfx.math.approx : approxUlp;
    assert(approxUlp(invM, FMat3(
        0.75f, 0.5f, 0.25f,
        0.5f,  1f,   0.5f,
        0.25f, 0.5f, 0.75f
    )));
    assert(approxUlp(gaussianInverse(invM), m));
}


/// Check whether MatT is a Mat
template isMat(MatT)
{
    import std.traits : TemplateOf;
    static if (is(typeof(__traits(isSame, TemplateOf!MatT, Mat))))
    {
        enum isMat = __traits(isSame, TemplateOf!MatT, Mat);
    }
    else
    {
        enum isMat = false;
    }
}

/// Check whether MatT is a Mat with R rows and C columns
template isMat(size_t R, size_t C, MatT)
{
    static if (isMat!MatT)
    {
        enum isMat = MatT.rowLength == R && MatT.columnLength == C;
    }
    else
    {
        enum isMat = false;
    }
}

/// Check whether M is 2x2 matrix
enum isMat2(M) = isMat!(2, 2, M);
/// Check whether M is 3x3 matrix
enum isMat3(M) = isMat!(3, 3, M);
/// Check whether M is 4x4 matrix
enum isMat4(M) = isMat!(4, 4, M);

/// Check if all types of MatSeq are instantiation of Mat
template areMat(MatSeq...)
{
    enum areMat = allSatisfy!(isMat, MatSeq);
}

/// Check if all types of MatSeq are instantiation of Mat with R rows and C columns
template areMat(size_t R, size_t C, MatSeq...)
{
    static assert(MatSeq.length > 0);
    static if (MatSeq.length == 1)
    {
        enum areMat = isMat!(R, C, MatSeq[0]);
    }
    else
    {
        enum areMat = isMat!(R, C, MatSeq[0]) && areMat!(R, C, MatSeq[1 .. $]);
    }
}

private:


version (D_SIMD) { enum hasSIMD = true; } else { enum hasSIMD = false; }
version (D_AVX) { enum hasAVX = true; } else { enum hasAVX = false; }
version (D_AVX2) { enum hasAVX2 = true; } else { enum hasAVX2 = false; }


/// Return a sequence of vectors and matrices as a flat tuple of rows.
template rowTuple(Rows...)
{
    auto rowTuple(Rows rows)
    {
        import gfx.math.vec : isVec;
        import std.traits : isStaticArray;
        import std.typecons : tuple;

        static if (Rows.length == 0) {
            return tuple();
        }
        else static if (Rows.length == 1) {
            static if (isStaticArray!(Rows[0])) {
                return tuple(vec(rows[0]));
            }
            else static if (isVec!(Rows[0])) {
                return tuple(rows[0]);
            }
            else static if (isMat!(Rows[0])) {
                return rows[0].rowTup;
            }
            else {
                static assert(false, "only vectors and matrices allowed in rowTuple");
            }
        }
        else static if (Rows.length > 1) {
            return tuple(
                rowTuple(rows[0]).expand, rowTuple(rows[1 .. $]).expand
            );
        }
        else {
            static assert(false, "wrong arguments to rowTuple");
        }
    }
}


/// The type of row tuple from a sequence of vectors and tuples
template RowTuple (Rows...)
{
    alias RowTuple = typeof(rowTuple(Rows.init));
}

/// The number of rows in a row sequence
template rowLength (Rows...)
{
    enum rowLength = RowTuple!(Rows).length;
}

/// Check whether a row sequence has a consistent length.
/// (i.e. all rows have the same length).
template hasConsistentLength (Rows...)
{
    import std.meta : allSatisfy;

    alias Tup = RowTuple!Rows;
    template lengthOK(R)
    {
        enum lengthOK = R.length == Tup[0].length;
    }
    enum hasConsistentLength = allSatisfy!(lengthOK, Tup.Types[1 .. $]);
}
