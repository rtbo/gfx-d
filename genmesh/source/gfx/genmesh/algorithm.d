module gfx.genmesh.algorithm;

import gfx.genmesh.poly;

import std.range : isInputRange, isOutputRange, ElementType;
import std.traits : isIntegral;


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
    import std.range : isForwardRange, isBidirectionalRange, isRandomAccessRange, hasLength;

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
void eachTriangle(alias fun, FT)(in FT face)
if (isFace!FT)
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
auto triangulate(FR)(FR faceRange)
if (isInputRange!FR && isFace!(ElementType!FR))
{
    alias FT = ElementType!FR;
    alias VT = VertexType!FT;

    return DecompResult!(FR, Triangle!VT, eachTriangle)(faceRange);
}


/// turn a range of undertermined face type into a range of vertices
auto vertices(FR)(FR faceRange) if (isInputRange!FR && isFace!(ElementType!FR))
{
    alias FT = ElementType!FR;
    alias VT = VertexType!FT;

    // winding order not relevant for eachVertex
    return DecompResult!(FR, VT, eachVertex)(faceRange);
}


private struct DecompResult(FR, TargetType, alias eachAlgo) {

    import std.range : isForwardRange;

    alias FT = ElementType!FR;
    static assert(isFace!FT);

    FR faceRange;
    TargetType[] buf;

    this(FR faceRange) {
        this.faceRange = faceRange;
        decomp(this.faceRange.front);
    }
    // for save
    this(FR faceRange, TargetType[] buf) {
        this.faceRange = faceRange;
        this.buf = buf;
    }

    private void decomp(in FT face) {
        eachAlgo!((t) { buf ~= t; })(face);
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
                decomp(faceRange.front);
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


template isIndexer(Indexer)
{
    enum isIndexer = is(typeof((Indexer indexer) // construction is unspecified
    {
        import std.array : appender;
        import std.traits : Unqual;
        alias I = Indexer.IndexType;
        alias V = Indexer.VertexType;

        V[] outVertices;
        immutable i = indexer.index(V.init, appender(outVertices));

        static assert(isIntegral!(typeof(i)));
        static assert(is(Unqual!(typeof(i)) == Indexer.IndexType));
    }));
}

// template defaultIndexer(VR) if (isInputRange!VR)
// {
//     enum defaultIndexer = LruIndexer!(ushort, ElementType!VR)(8);
// }


/// Index the input vertex range into a range of indices with the given Indexer.
/// The shared vertices will be put into the given output range. (each vertex is given once)
auto index(VR, VOR, Indexer)(VR vertexInRange, VOR vertexOutRange,
                             Indexer indexer = LruIndexer!(ushort, ElementType!VR)(8))
if (isInputRange!VR && !isFace!(ElementType!VR) &&
    isOutputRange!(VOR, ElementType!VR) &&
    isIndexer!Indexer && is(ElementType!VR == Indexer.VertexType))
{
    return IndexResult!(VR, VOR, Indexer)(vertexInRange, vertexOutRange, indexer);
}

private struct IndexResult(VR, VOR, Indexer) {

    alias I = Indexer.IndexType;

    VR vertexInRange;
    VOR vertexOutRange;
    Indexer indexer;

    I idx = I.max;

    this(VR vertexInRange, VOR vertexOutRange, Indexer indexer) {
        this.vertexInRange = vertexInRange;
        this.vertexOutRange = vertexOutRange;
        this.indexer = indexer;

        if (!vertexInRange.empty) {
            this.idx = this.indexer.index(this.vertexInRange.front, this.vertexOutRange);
        }
        else {
            this.idx = I.max;
        }
    }

    @property I front() {
        assert(idx != I.max);
        return idx;
    }

    void popFront() {
        vertexInRange.popFront();
        if (!vertexInRange.empty) {
            idx = indexer.index(vertexInRange.front, vertexOutRange);
        }
        else {
            idx = I.max;
        }
    }

    @property bool empty() {
        return vertexInRange.empty;
    }
}



/// least recently used indexer
struct LruIndexer(IT, VT) {
    import std.container : make, DList;
    import std.typecons : Tuple;

    alias IndexType = IT;
    alias VertexType = VT;
    alias IndexedType = Tuple!(IndexType, VertexType);

    IndexType idx;
    DList!IndexedType cache;
    size_t cacheLen;
    size_t maxCacheLen;

    this (in size_t maxCacheLen) {
        this.idx = 0;
        this.cache = make!(DList!IndexedType)();
        this.cacheLen = 0;
        this.maxCacheLen = maxCacheLen;
    }

    /// index the given vertex.
    /// returns the index. if the vertex was not indexed yet, vfun is called with the vertex as argument
    IndexType index (VOR)(in VertexType vertex, VOR vertexOutRange)
    if (isOutputRange!(VOR, VertexType))
    {
        import std.algorithm : find;
        import std.range : take;
        import std.stdio;

        auto r = cache[].find!"a[1] == b"(vertex);

        if (r.empty) {
            // found new vertex
            if (cacheLen == maxCacheLen) {
                cache.removeBack();
                cacheLen -= 1;
            }

            vertexOutRange.put(vertex);

            immutable ind = idx++;
            cache.insertFront(IndexedType(ind, vertex));
            cacheLen += 1;

            return ind;
        }
        else {
            immutable indexed = r.front;
            cache.linearRemove(r.take(1));
            cache.insertFront(indexed);

            return indexed[0];
        }

    }
}

unittest {
    struct V { float[3] pos; }
    static assert (isIndexer!(LruIndexer!(ushort, V)));
}

/// eagerly index all vertices in the given range and collect them
/// into a struct that has an indices array member and a vertices array member
auto indexCollectMesh(VR, Indexer)(VR vertexRange, Indexer indexer = LruIndexer!(ushort, ElementType!VR)(8))
{
    import std.array : array, appender;

    alias VT = ElementType!VR;
    alias IT = Indexer.IndexType;

    struct Mesh {
        IT[] indices;
        VT[] vertices;
    }

    auto vertAppender = appender(VT[].init);
    IT[] indices = vertexRange.index(vertAppender, indexer).array();

    return Mesh(indices, vertAppender.data);
}