/// Matrix definition module
module gfx.math.mat;

import gfx.math.vec;
import gfx.foundation.util : staticRange;

import std.traits;
import std.typecons : tuple, Tuple;
import std.meta;
import std.exception : enforce;

version(unittest)
{
    import std.algorithm : equal;
}

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
    static assert(hasConsistentLength!Rows, "All rows must have the same number of components");
    immutable rt = rowTuple(rows);
    alias CompTup = ComponentTuple!(typeof(rt).Types);
    alias Comp = CommonType!(CompTup.Types);
    enum rowLength = rt.length;
    enum colLength = rt[0].length;
    return Mat!(Comp, rowLength, colLength)(rt.expand);
}

///
unittest
{
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

/// Row major matrix type.
/// Mat.init is a null matrix.
struct Mat(T, size_t R, size_t C)
if (isNumeric!T && R > 0 && C > 0)
{
    private T[R * C] _rep = 0;

    /// The amount of rows in the matrix.
    enum rowLength = R;
    /// The amount of columns in the matrix.
    enum columnLength = C;
    /// The matrix rows type.
    alias Row = Vec!(T, columnLength);
    /// The matrix columns type.
    alias Column = Vec!(T, rowLength);
    /// The type of the componetypeof(rt.expand)nts.
    alias Component = T;

    /// The identity matrix.
    enum identity = mixin(identityCode);

    /// Build a matrix from its elements.
    /// To be provided row major.
    this (Args...)(in Args args)
    if (Args.length == R*C &&
        allSatisfy!(isNumeric, Args) &&
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
        foreach (r, arg; args)
        {
            static if (isStaticArray!(typeof(arg)))
            {
                static assert(arg.length == columnLength);
            }
            else
            {
                assert(arg.length == columnLength);
            }
            _rep[r*columnLength .. (r+1)*columnLength] = arg;
        }
    }

    /// ditto
    this (Args...)(in Args args)
    if (Args.length == rowLength &&
        allSatisfy!(isVec, Args))
    {
        foreach(r, arg; args)
        {
            static assert(arg.length == columnLength, "incorrect row size");
            static if (is(typeof(arg[0]) == T))
            {
                _rep[r*columnLength .. (r+1)*columnLength] = arg._rep;
            }
            else
            {
                foreach (c; staticRange!(0, columnLength))
                {
                    _rep[r*columnLength + c] = cast(T)arg[c];
                }
            }
        }
    }

    /// Build a matrix from the provided data.
    /// data.length must be rowLength*columns.
    this (in T[] data)
    {
        enforce(data.length == rowLength*columnLength);
        _rep[] = data;
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
         foreach (i; staticRange!(0, rowLength*columnLength))
         {
             res._rep[i] = cast(U)_rep[i];
         }
         return res;
    }

    // compile time indexing

    /// Index a matrix component at compile time
    @property T ctComp(size_t r, size_t c)() const
    {
        static assert (r < rowLength, "row out of bounds");
        static assert (c < columnLength, "column out of bounds");
        return _rep[r*columnLength + c];
    }

    /// Assign a matrix component with index known at compile time
    @property void ctComp(size_t r, size_t c, U)(in U val)
    if (isImplicitlyConvertible!(U, T))
    {
        static assert (r < rowLength, "row out of bounds");
        static assert (c < columnLength, "column out of bounds");
        _rep[r*columnLength + c] = val;
    }

    /// Index a row at compile time
    @property Row ctRow(size_t r)() const
    {
        static assert (r < rowLength, "row out of bounds");
        return Row(_rep[r*columnLength .. (r+1)*columnLength]);
    }

    /// Assign a row with index known at compile time
    @property void ctRow(size_t r)(in Row row)
    {
        static assert (r < rowLength, "row out of bounds");
        _rep[r*columnLength .. (r+1)*columnLength] = row._rep;
    }

    /// Index a column at compile time
    @property Column ctColumn(size_t c)() const
    {
        static assert (c < columnLength, "column out of bounds");
        Column col = void;
        foreach (r; staticRange!(0, rowLength))
        {
            col.ctComp!r = ctComp!(r, c);
        }
        return col;
    }

    /// Assign a column with index known at compile time
    @property void ctColumn(size_t c)(in Column column)
    {
        static assert (c < columnLength, "column out of bounds");
        foreach(r; staticRange!(0, rowLength))
        {
            ctComp!(r, c) = column.ctComp!(r);
        }
    }

    /// Return a slice whose size is known at compile-time.
    @property Mat!(T, RE-RS, CE-CS) ctSlice(size_t RS, size_t RE, size_t CS, size_t CE)() const
    if (RE > RS && RE <= rowLength && CE > CS && CE <= columnLength)
    {
        Mat!(T, RE-RS, CE-CS) res = void;
        foreach (r; staticRange!(RS, RE))
        {
            foreach (c; staticRange!(CS, CE))
            {
                res.ctComp!(r-RS, c-CS) = ctComp!(r, c);
            }
        }
        return res;
    }

    /// Assign a slice whose size is known at compile-time.
    /// e.g: $(D_CODE mat.ctSlice!(0, 2) = otherMat;)
    @property void ctSlice(size_t RS, size_t CS, U, size_t UR, size_t UC)(in Mat!(U, UR, UC) mat)
    if (RS+UR <= rowLength && CS+UC <= columnLength && isImplicitlyConvertible!(U, T))
    {
        foreach (r; staticRange!(0, UR))
        {
            foreach (c; staticRange!(0, UC))
            {
                ctComp!(r+RS, c+CS) = mat.ctComp!(r, c);
            }
        }
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
        foreach (r; staticRange!(0, rowLength))
        {
            res.ctComp!r = _rep[index(r, c)];
        }
        return res;
    }

    /// Index a matrix component
    T comp(in size_t r, in size_t c) const
    {
        return _rep[index(r, c)];
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
        res.ctSlice!(0, 0) = this;
        res.ctSlice!(0, columnLength) = mat;
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
        foreach (r; staticRange!(0, rowLength))
        {
            foreach (c; staticRange!(0, columnLength))
            {
                mixin("res.ctComp!(r, c) = ctComp!(r, c) "~op~" ctComp!(r, c)");
            }
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
        foreach(r; staticRange!(0, rowLength))
        {
            foreach (c; staticRange!(0, UC))
            {
                ResMat.Component resComp = 0;
                foreach (rc; staticRange!(0, columnLength))
                {
                    resComp += ctComp!(r, rc) * oth.ctComp!(rc, c);
                }
                res.ctComp!(r, c) = resComp;
            }
        }
        return res;
    }

    /// Multiply a matrix by a vector to its right.
    auto opBinary(string op, U, size_t N)(in Vec!(U, N) vec) const
    if (op == "*" && N == columnLength && !is(CommonType!(T, U) == void))
    {
        // same as matrix with one column
        alias ResVec = Vec!(CommonType!(T, U), rowLength);
        ResVec res = void;
        foreach (r; staticRange!(0, rowLength))
        {
            ResVec.Component resComp = 0;
            foreach (c; staticRange!(0, columnLength))
            {
                resComp += ctComp!(r, c) * vec.ctComp!c;
            }
            res.ctComp!r = resComp;
        }
        return res;
    }

    /// Multiply a matrix by a vector to its left.
    auto opBinaryRight(string op, U, size_t N)(in Vec!(U, N) vec) const
    if (op == "*" && N == rowLength && !is(CommonType!(T, U) == void))
    {
        // same as matrix with one row
        alias ResVec = Vec!(CommonType!(T, U), columnLength);
        ResVec res = void;
        foreach (c; staticRange!(0, columnLength))
        {
            ResVec.Component resComp = 0;
            foreach (r; staticRange!(0, rowLength))
            {
                resComp += vec.ctComp!r * ctComp!(r, c);
            }
            res.ctComp!c = resComp;
        }
        return res;
    }


    /// Operation of a matrix with a scalar on its right.
    auto opBinary(string op, U)(in U val) const
    if ((op == "+" || op == "-" || op == "*" || op == "/") &&
        !is(CommonType!(T, U) == void))
    {
        alias ResMat = Mat!(CommonType!(T, U), rowLength, columnLength);
        ResMat res = void;
        foreach (r; staticRange!(0, rowLength))
        {
            foreach (c; staticRange!(0, columnLength))
            {
                mixin("res.ctComp!(r, c) = ctComp!(r, c) "~op~" val;");
            }
        }
        return res;
    }

    /// Operation of a matrix with a scalar on its left.
    auto opBinaryRight(string op, U)(in U val) const
    if ((op == "+" || op == "-" || op == "*" || op == "/") &&
        !is(CommonType!(T, U) == void))
    {
        alias ResMat = Mat!(CommonType!(T, U), rowLength, columnLength);
        ResMat res = void;
        foreach (r; staticRange!(0, rowLength))
        {
            foreach (c; staticRange!(0, columnLength))
            {
                mixin("res.ctComp!(r, c) = val "~op~" ctComp!(r, c);");
            }
        }
        return res;
    }

    /// Assign operation of a matrix with a scalar on its right.
    auto opOpAssign(string op, U)(in U val)
    if ((op == "+" || op == "-" || op == "*" || op == "/") &&
        !is(CommonType!(T, U) == void))
    {
        foreach (r; staticRange!(0, rowLength))
        {
            foreach (c; staticRange!(0, columnLength))
            {
                mixin("_rep[r*columnLength+c] "~op~"= val;");
            }
        }
        return res;
    }


    string toString() const
    {
        /// [
        ///     [      1.0000,       2.0000 ],
        ///     [      3.0000,       4.0000 ]
        /// ]
        import std.format : format;
        string res = "[\n";
        foreach (r; staticRange!(0, rowLength))
        {
            static if (isFloatingPoint!T)
            {
                enum fmt = "   [ %(%#10.4f%|, %) ]";
            }
            else
            {
                enum fmt = "   [ %(% 10s%|, %) ]";
            }
            res ~= format(fmt, _rep[r*columnLength .. (r+1)*columnLength]);
            if (r != rowLength-1) res ~= ",\n";
            else res ~= "\n";
        }
        return res ~ "]";
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
}



/// Return a sequence of vectors and matrices as a flat tuple of rows.
template rowTuple(Rows...)
{
    auto rowTuple(Rows rows)
    {
        static if (Rows.length == 0)
        {
            return tuple();
        }
        else static if (Rows.length == 1)
        {
            static if (isVec!(Rows[0]))
            {
                return tuple(rows[0]);
            }
            else static if (isMat!(Rows[0]))
            {
                return rows[0].rowTup;
            }
            else
            {
                static assert(false, "only vectors and matrices allowed in rowTuple");
            }
        }
        else
        {
            return tuple(
                rowTuple(rows[0]).expand,
                rowTuple(rows[1 .. $]).expand
            );
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
    alias Tup = RowTuple!Rows;
    template lengthOK(R)
    {
        enum lengthOK = R.length == Tup[0].length;
    }
    enum hasConsistentLength = allSatisfy!(lengthOK, Tup.Types[1 .. $]);
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

/// Give the transposed form of a matrix.
template transpose(T, size_t R, size_t C)
{
    @property Mat!(T, C, R) transpose(in Mat!(T, R, C) mat)
    {
        Mat!(T, C, R) res = void;
        foreach (r; staticRange!(0, R))
        {
            foreach (c; staticRange!(0, C))
            {
                res[c, r] = mat[r, c];
            }
        }
        return res;
    }
}

/// Compute the determinant of a matrix.
template determinant(T)
{
    @property T determinant(in Mat2!T mat)
    {
        return mat[0, 0]*mat[1, 1] - mat[0, 1]*mat[1, 0];
    }
    @property T determinant(in Mat3!T mat)
    {
        return mat[0, 0] * determinant(Mat2!T(mat[1, 1], mat[1, 2], mat[2, 1], mat[2, 2]))
            - mat[1, 0] * determinant(Mat2!T(mat[0, 1], mat[0, 2], mat[2, 1], mat[2, 2]))
            + mat[2, 0] * determinant(Mat2!T(mat[0, 1], mat[0, 2], mat[1, 1], mat[1, 2]));
    }
    @property T determinant(in Mat4!T mat)
    {
        return mat[0, 0] * determinant(Mat3!T(
            mat[1, 1], mat[1, 2], mat[1, 3],
            mat[2, 1], mat[2, 2], mat[2, 3],
            mat[3, 1], mat[3, 2], mat[3, 3],
        ))
        - mat[1, 0] * determinant(Mat3!T(
            mat[0, 1], mat[0, 2], mat[0, 3],
            mat[2, 1], mat[2, 2], mat[2, 3],
            mat[3, 1], mat[3, 2], mat[3, 3],
        ))
        + mat[2, 0] * determinant(Mat3!T(
            mat[0, 1], mat[0, 2], mat[0, 3],
            mat[1, 1], mat[1, 2], mat[1, 3],
            mat[3, 1], mat[3, 2], mat[3, 3],
        ))
        - mat[2, 0] * determinant(Mat3!T(
            mat[0, 1], mat[0, 2], mat[0, 3],
            mat[1, 1], mat[1, 2], mat[1, 3],
            mat[2, 1], mat[2, 2], mat[2, 3],
        ));
    }
}

/// Compute the inverse of a matrix.
/// Complexity O(n3).
template inverse (T, size_t N)
if (isFloatingPoint!T)
{
    @property Mat!(T, N, N) inverse(in Mat!(T, N, N) mat)
    {
        // Gaussian elimination method
        auto pivot = mat ~ Mat!(real, N, N).identity;
        static assert(is(pivot.Component == real));
        ptrdiff_t pivotR = -1;
        foreach (c; staticRange!(0, N))
        {
            // find the max row of column c.
            auto colMax = pivot[pivotR+1, c];
            ptrdiff_t maxR = pivotR+1;
            foreach (r; pivotR+2 .. N)
            {
                immutable val = pivot[r, c];
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
                foreach (cc; staticRange!(0, 2*N))
                {
                    pivot[maxR, cc] /= colMax;
                }
                // switching pivot row with the max row
                if (pivotR != maxR)
                {
                    foreach (cc; staticRange!(0, 2*N))
                    {
                        immutable swapTmp = pivot[maxR, cc];
                        pivot[maxR, cc] = pivot[pivotR, cc];
                        pivot[pivotR, cc] = swapTmp;
                    }
                }
                foreach (r; staticRange!(0, N))
                {
                    if (r != pivotR)
                    {
                        immutable fact = pivot.ctComp!(r, c);
                        if (fact != 0)
                        {
                            foreach (cc; staticRange!(0, 2*N))
                            {
                                pivot.ctComp!(r, cc) = pivot.ctComp!(r, cc) - fact * pivot[pivotR, cc];
                            }
                        }
                    }
                }
            }
        }
        return cast(Mat!(T, N, N)) pivot.ctSlice!(0, N, N, 2*N);
    }
}


import gfx.math.approx : approxUlp;

///
unittest
{
    assert(approxUlp(FMat2x2.identity, FMat2x2(
        1, 0,
        0, 1
    )));
}

///
unittest
{
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

///
unittest
{
    /// Example from https://en.wikipedia.org/wiki/Gaussian_elimination
    immutable m = FMat3(
        2, -1, 0,
        -1, 2, -1,
        0, -1, 2
    );
    immutable invM = inverse(m);
    assert(approxUlp(invM, FMat3(
        0.75f, 0.5f, 0.25f,
        0.5f,  1f,   0.5f,
        0.25f, 0.5f, 0.75f
    )));
    assert(approxUlp(inverse(invM), m));
}
