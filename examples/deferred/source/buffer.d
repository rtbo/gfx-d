module buffer;

import deferred;

import gfx.core;
import gfx.graal;
import gfx.math;

struct P3N3Vertex
{
    FVec3 pos;
    FVec3 normal;
}

struct P2T2Vertex
{
    FVec2 pos;
    FVec2 texCoord;
}

/// per frame UBO for the geom pipeline
struct GeomFrameUbo
{
    FMat4 viewProj = FMat4.identity;
}
/// per draw call UBO for the geom pipeline
struct GeomModelData
{
    FMat4 model = FMat4.identity;
    FVec4 color = fvec(0, 0, 0, 1);
    float[4] pad; // 32 bytes alignment for dynamic offset
}
static assert(GeomModelData.alignof / 32 == 0);
/// ditto
struct GeomModelUbo
{
    GeomModelData[3] data;
}
static assert(GeomModelUbo.alignof / 32 == 0);

/// per frame UBO for the light pipeline
struct LightFrameUbo
{
    FVec4 viewerPos = fvec(0, 0, 0, 1);
}
/// per draw call UBO for the light pipeline
struct LightModelUbo
{
    FMat4 modelViewProj = FMat4.identity;
    FVec4 position = fvec(0, 0, 0, 1);
    /// color in RGB, luminosity in A
    FVec4 colAndLum = fvec(0, 0, 0, 1);
    float[8] pad; // 32 bytes alignment for dynamic offset
}
static assert(LightModelUbo.alignof / 32 == 0);

struct MeshBuffer
{
    Rc!Buffer indexBuf;
    Rc!Buffer vertexBuf;
    Interval!size_t indices;
    Interval!size_t vertices;

    @property uint indicesCount()
    {
        return cast(uint)indices.length / ushort.sizeof;
    }

    void bindIndex(CommandBuffer cmd)
    {
        cmd.bindIndexBuffer(indexBuf, indices.start, IndexType.u16);
    }

    VertexBinding vertexBinding()
    {
        return VertexBinding(
            vertexBuf.obj, vertices.start,
        );
    }

    void release()
    {
        indexBuf.unload();
        vertexBuf.unload();
    }
}


struct DynBuffer(T)
{
    Rc!Buffer buffer;
    MemoryMap mmap;
    size_t len;

    this(DeferredExample ex, size_t len, BufferUsage usage)
    {
        buffer = ex.createDynamicBuffer(len * T.sizeof, usage);
        mmap = buffer.boundMemory.map();
        this.len = len;
    }

    ~this()
    {
        mmap = MemoryMap.init;
        buffer.unload();
    }

    @property T[] data()
    {
        return mmap.view!(T[])()[];
    }

    void addToMemorySet(ref MappedMemorySet mms)
    {
        mmap.addToSet(mms);
    }

    BufferDescriptor descriptor(in size_t start=0, in size_t size=0)
    {
        return buffer.descriptor(start*T.sizeof, size*T.sizeof);
    }
}

class DeferredBuffers : AtomicRefCounted
{
    MeshBuffer hiResSphere;
    // normals pointing inwards to render "bulbs" with point light inside
    MeshBuffer invertedSphere;
    MeshBuffer loResSphere;
    MeshBuffer square;

    DynBuffer!GeomFrameUbo geomFrameUbo;
    DynBuffer!GeomModelUbo geomModelUbo;
    DynBuffer!LightFrameUbo lightFrameUbo;
    DynBuffer!LightModelUbo lightModelUbo;

    this(DeferredExample ex, size_t saucerCount)
    {
        prepareMeshBuffers(ex);
        prepareUboBuffers(ex, saucerCount);
    }

    override void dispose()
    {
        import std.algorithm : move;

        hiResSphere.release();
        invertedSphere.release();
        loResSphere.release();
        square.release();
        move(geomFrameUbo);
        move(geomModelUbo);
        move(lightFrameUbo);
        move(lightModelUbo);
    }

    final void prepareMeshBuffers(DeferredExample ex)
    {
        import std.algorithm : map;
        import std.array : array;

        const hiRes = buildUvSpheroid(fvec(0, 0, 0), 1f, 1f, 15);
        const loRes = buildUvSpheroid(fvec(0, 0, 0), 1f, 1f, 6);

        const invertedVtx = hiRes.vertices.map!(v => P3N3Vertex(v.pos, -v.normal)).array;

        const ushort[] squareIndices = [ 0, 1, 2, 0, 2, 3 ];
        const squareVertices = [
            P2T2Vertex(fvec(-1, -1), fvec(0, 0)),
            P2T2Vertex(fvec(-1, 1), fvec(0, 1)),
            P2T2Vertex(fvec(1, 1), fvec(1, 1)),
            P2T2Vertex(fvec(1, -1), fvec(1, 0)),
        ];

        Rc!Buffer indexBuf = ex.createStaticBuffer(
            hiRes.indices ~ loRes.indices ~ squareIndices,
            BufferUsage.index
        );

        const hiResVData = cast(const(ubyte)[])hiRes.vertices;
        const invertedVData = cast(const(ubyte)[])invertedVtx;
        const loResVData = cast(const(ubyte)[])loRes.vertices.map!(v => v.pos).array;
        const squareVData = cast(const(ubyte)[])squareVertices;
        Rc!Buffer vertexBuf = ex.createStaticBuffer(
            hiResVData ~ invertedVData ~ loResVData ~ squareVData,
            BufferUsage.vertex);

        const hiResI = hiRes.indices.length * ushort.sizeof;
        const invertedI = hiResI;
        const loResI = invertedI + loRes.indices.length * ushort.sizeof;
        const squareI = loResI + squareIndices.length * ushort.sizeof;

        const hiResV = hiRes.vertices.length * P3N3Vertex.sizeof;
        const invertedV = 2 * hiResV;
        const loResV = invertedV + loRes.vertices.length * FVec3.sizeof;
        const squareV = loResV + squareVertices.length * P2T2Vertex.sizeof;

        hiResSphere.indexBuf = indexBuf;
        hiResSphere.vertexBuf = vertexBuf;
        hiResSphere.indices = interval(0, hiResI);
        hiResSphere.vertices = interval(0, hiResV);

        invertedSphere.indexBuf = indexBuf;
        invertedSphere.vertexBuf = vertexBuf;
        invertedSphere.indices = interval(0, hiResI);
        invertedSphere.vertices = interval(hiResV, invertedV);

        loResSphere.indexBuf = indexBuf;
        loResSphere.vertexBuf = vertexBuf;
        loResSphere.indices = interval(hiResI, loResI);
        loResSphere.vertices = interval(invertedV, loResV);

        square.indexBuf = indexBuf;
        square.vertexBuf = vertexBuf;
        square.indices = interval(loResI, squareI);
        square.vertices = interval(loResV, squareV);
    }

    final void prepareUboBuffers(DeferredExample ex, size_t saucerCount)
    {
        geomFrameUbo = DynBuffer!GeomFrameUbo(ex, 1, BufferUsage.uniform);
        geomModelUbo = DynBuffer!GeomModelUbo(ex, saucerCount, BufferUsage.uniform);
        lightFrameUbo = DynBuffer!LightFrameUbo(ex, 1, BufferUsage.uniform);
        lightModelUbo = DynBuffer!LightModelUbo(ex, saucerCount, BufferUsage.uniform);
    }

    final void flush(Device device)
    {
        MappedMemorySet mms;
        geomModelUbo.addToMemorySet(mms);
        geomFrameUbo.addToMemorySet(mms);
        lightModelUbo.addToMemorySet(mms);
        lightFrameUbo.addToMemorySet(mms);
        device.flushMappedMemory(mms);
    }
}

struct Mesh
{
    ushort[] indices;
    P3N3Vertex[] vertices;
}

Mesh buildUvSpheroid(in FVec3 center, in float radius, in float height,
        in uint latDivs = 8)
{
    import std.array : uninitializedArray;
    import std.math : PI, cos, sin;

    const longDivs = latDivs * 2;
    const totalVertices = 2 + (latDivs - 1) * longDivs;
    const totalIndices = 3 * longDivs * (2 + 2 * (latDivs - 2));

    auto vertices = uninitializedArray!(P3N3Vertex[])(totalVertices);

    size_t ind = 0;
    void unitVertex(in FVec3 pos)
    {
        const v = fvec(radius * pos.xy, height * pos.z);
        vertices[ind++] = P3N3Vertex(center + v, normalize(v));
    }

    const latAngle = PI / latDivs;
    const longAngle = 2 * PI / longDivs;

    // north pole
    unitVertex(fvec(0, 0, 1));
    // latitudes
    foreach (lat; 1 .. latDivs)
    {
        const alpha = latAngle * lat;
        const z = cos(alpha);
        const sa = sin(alpha);
        foreach (lng; 0 .. longDivs)
        {
            const beta = longAngle * lng;
            const x = cos(beta) * sa;
            const y = sin(beta) * sa;

            unitVertex(fvec(x, y, z));
        }
    }
    // south pole
    unitVertex(fvec(0, 0, -1));
    assert(ind == totalVertices);

    // build ccw triangle faces
    auto indices = uninitializedArray!(ushort[])(totalIndices);
    ind = 0;
    void face(in size_t v0, in size_t v1, in size_t v2)
    {
        indices[ind++] = cast(ushort) v0;
        indices[ind++] = cast(ushort) v1;
        indices[ind++] = cast(ushort) v2;
    }

    size_t left(size_t lng)
    {
        return lng;
    }

    size_t right(size_t lng)
    {
        return lng == longDivs - 1 ? 0 : lng + 1;
    }

    // northern div triangles
    foreach (lng; 0 .. longDivs)
    {
        const pole = 0;
        const bot = 1;
        face(pole, bot + left(lng), bot + right(lng));
    }
    // middle divs rectangles
    foreach (lat; 0 .. latDivs - 2)
    {
        const top = 1 + lat * longDivs;
        const bot = top + longDivs;
        foreach (lng; 0 .. longDivs)
        {
            const l = left(lng);
            const r = right(lng);

            face(top + l, bot + l, bot + r);
            face(top + l, bot + r, top + r);
        }
    }
    // southern div triangles
    foreach (lng; 0 .. longDivs)
    {
        const pole = totalVertices - 1;
        const top = 1 + (latDivs - 2) * longDivs;
        face(pole, top + right(lng), top + left(lng));
    }
    assert(ind == totalIndices);

    return Mesh(indices, vertices);
}
