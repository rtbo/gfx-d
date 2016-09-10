module gfx.meshgen.algorithm;

import gfx.meshgen.poly;

import std.range : isInputRange, ElementType;


/// map a single face to another face of same shape with all elements mapped by the passed function.
/// element type of returned face can differ from element type in input face
auto vertexMap(alias fun, FT)(in FT face) if (isFace!FT) {
    import std.functional : unaryFun;

    alias _fun = unaryFun!fun;

    static if (isFlexFace!FT) {
        if (face.length == 3) {
            return flexFace(_fun(face[0]), _fun(face[1]), _fun(face[2]));
        }
        else {
            assert(face.length == 4);
            return flexFace(_fun(face[0]), _fun(face[1]), _fun(face[2]), _fun(face[3]));
        }
    }
    else static if (isGenFace!FT) {
        static if (face.length == 3) {
            return triangle(_fun(face[0]), _fun(face[1]), _fun(face[2]));
        }
        else {
            static assert(face.length == 4);
            return quad(_fun(face[0]), _fun(face[1]), _fun(face[2]), _fun(face[3]));
        }
    }
}


/// map a range of face to another range of face where each vertex is mapped (and whose type might change)
auto vertexMap(alias fun, FR)(FR faceRange) if (isInputRange!FR && isFace!(ElementType!FR)) {
    import std.functional : unaryFun;
    return VertexMapResult!(unaryFun!fun, FR)(faceRange);
}

private struct VertexMapResult(alias vfun, FR) {
    FR faceRange;
    this (FR fr) { faceRange = fr; }

    @property auto front() const {
        return vertexMap!vfun(faceRange.front);
    }

    void popFront() {
        faceRange.popFront();
    }

    @property bool empty() const {
        return faceRange.empty;
    }

    static if (isForwardRange!FR) {
        @property auto save() const {
            return typeof(this)(faceRange.save);
        }
    }

    static if (isBidirectionalRange!FR) {
        @property auto back() const {
            return vertexMap!vfun(faceRange.back);
        }
        void popBack() {
            faceRange.popBack();
        }
    }

    static if (isRandomAccessRange!FR) {
        static if (is(typeof(faceRange[ulong.max])))
            private alias opIndex_t = ulong;
        else
            private alias opIndex_t = uint;

        auto ref opIndex(opIndex_t index) {
            return vertexMap!vfun(faceRange[index]);
        }
    }

    static if (hasLength!FR) {
        @property auto length() const {
            return faceRange.length;
        }
        alias opDollar = length;
    }
}


/// eagerly call 'fun' for each triangle of the passed face
void eachTriangle(alias fun, FT)(in FT face) if (isFace!FT)
{
    import std.functional : unaryFun;

    alias _fun = unaryFun!fun;
    static assert(is(typeof(() {
        VertexType!FT v;
        _fun(triangle(v, v, v));
    })), "cannot pass the proper triangle type to "~fun.stringof);

    _fun(triangle(face[0], face[1], face[2]));

    static if (isFlexFace!FT) {
        if (face.length == 4) {
            _fun(triangle(face[0], face[2], face[3]));
        }
    }
    else static if (isGenFace!FT && face.length == 4) {
        _fun(triangle(face[0], face[2], face[3]));
    }
}


/// eagerly call 'fun' for each vertex of the passed face
void eachVertex(alias fun, FT)(in FT face) if (isFace!FT)
{
    import std.functional : unaryFun;

    alias _fun = unaryFun!fun;
    static assert(is(typeof(_fun(VertexType!FT.init))),
            "cannot pass the proper vertex type to "~fun.stringof);

    foreach(i; 0..face.length) {
        _fun(face[i]);
    }
}


/// turn a range of undertermined face type into a range of triangles
auto triangulate(FR)(FR faceRange) if (isInputRange!FR && isFace!(ElementType!FR)) {
    return TriangulateResult!FR(faceRange);
}

private struct TriangulateResult(FR) {

    import std.range : isForwardRange;

    alias FT = ElementType!FR;
    static assert (isFace!FT);

    alias VT = VertexType!(FT);

    FR faceRange;
    Triangle!VT[] buf;

    this(FR faceRange) {
        this.faceRange = faceRange;
        pushTriangles(this.faceRange.front);
    }

    // for save
    this(FR faceRange, Triangle!VT[] buf) {
        this.faceRange = faceRange;
        this.buf = buf;
    }

    private void pushTriangles(in FT face) {
        face.eachTriangle!((t) { buf ~= t; });
    }

    @property auto front() {
        assert(buf.length);
        return buf[0];
    }

    void popFront() {
        assert(buf.length);
        buf = buf[1 .. $];
        if (!buf.length) {
            faceRange.popFront();
            if (!faceRange.empty) {
                pushTriangles(faceRange.front);
            }
        }
    }

    @property bool empty() {
        return buf.length == 0 && faceRange.empty;
    }

    static if (isForwardRange!FR) {
        @property auto save() {
            return typeof(this)(faceRange.save, buf.dup);
        }
    }
}


auto vertices(FR)(FR faceRange) if (isInputRange!FR && isFace!(ElementType!FR))
{
    return VerticesResult!FR(faceRange);
}

private struct VerticesResult(FR) {

    import std.range : isForwardRange;

    alias FT = ElementType!FR;
    static assert (isFace!FT);

    alias VT = VertexType!(FT);

    FR faceRange;
    VT[] buf;

    this(FR faceRange) {
        this.faceRange = faceRange;
        pushVertices(this.faceRange.front);
    }

    // for save
    this(FR faceRange, VT[] buf) {
        this.faceRange = faceRange;
        this.buf = buf;
    }

    private void pushVertices(in FT face) {
        face.eachVertex!((t) { buf ~= t; });
    }

    @property auto front() {
        assert(buf.length);
        return buf[0];
    }

    void popFront() {
        assert(buf.length);
        buf = buf[1 .. $];
        if (!buf.length) {
            faceRange.popFront();
            if (!faceRange.empty) {
                pushVertices(faceRange.front);
            }
        }
    }

    @property bool empty() {
        return buf.length == 0 && faceRange.empty;
    }

    static if (isForwardRange!FR) {
        @property auto save() {
            return typeof(this)(faceRange.save, buf.dup);
        }
    }
}