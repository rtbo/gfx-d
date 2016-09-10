module gfx.genmesh.poly;

import std.typecons : Flag, Yes, No;


struct GenVertex(Flag!"normals" normals) {
    float[3] p;
    static if (normals == Yes.normals) {
        float[3] n;
    }
}


/// a generic face type
struct GenFace(size_t N, VT) {
    enum size_t length = N;
    VT[N] vertices;

    VT opIndex(size_t n) const {
        assert(n < length);
        return vertices[n];
    }
}

/// a triangular face type, with a vertex type parameter
/// T can be an index or actual vertex
alias Triangle(VT) = GenFace!(3, VT);

auto triangle(VT)(in VT v1, in VT v2, in VT v3) {
    return Triangle!VT([v1, v2, v3]);
}

/// a quad face type, with a vertex type parameter
/// T can be an index or actual vertex
alias Quad(VT) = GenFace!(4, VT);

auto quad(VT)(in VT v1, in VT v2, in VT v3, in VT v4) {
    return Quad!VT([v1, v2, v3, v4]);
}


/// a runtime flexible face
struct FlexFace(VT) {
    private Quad!VT q;
    VT[] vertices;

    this(in VT v1, in VT v2, in VT v3) {
        q = quad(v1, v2, v3, VT.init);
        vertices = q.vertices[0 .. 3];
    }

    this(in VT v1, in VT v2, in VT v3, in VT v4) {
        q = quad(v1, v2, v3, v4);
        vertices = q.vertices[0 .. 4];
    }

    @property size_t length() const {
        return vertices.length;
    }

    VT opIndex(size_t n) const {
        return vertices[n];
    }
}

auto flexFace(Args...)(Args args) if (Args.length == 3 || Args.length == 4) {
    return FlexFace!(Args[0]) (args);
}


enum isFlexFace(FT) = FaceTplt!FT.isFlexFace;
enum isGenFace(FT) = FaceTplt!FT.isGenFace;
enum isFace(FT) = isFlexFace!FT || isGenFace!FT;

template VertexType(FT) if (isFace!FT) {
    alias VertexType = FaceTplt!FT.VertexType;
}
template faceDim(FT) if (isGenFace!FT) {
    enum faceDim = FaceTplt!FT.faceDim;
}


private template FaceTplt(FT) {
    static if (is(FT == FlexFace!VT, VT)) {
        enum isFlexFace = true;
        alias VertexType = VT;
    }
    else {
        enum isFlexFace = false;
    }

    static if (is(FT == GenFace!(N, VT), size_t N, VT)) {
        enum isGenFace = true;
        enum faceDim = N;
        alias VertexType = VT;
    }
    else {
        enum isGenFace = false;
    }
}

