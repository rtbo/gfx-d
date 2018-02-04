module gfx.genmesh.cube;

import gfx.genmesh.poly;

import std.typecons : Flag, Yes;



auto genCube(Flag!"normals" normals = Yes.normals)() {
    return CubeGenerator!normals.init;
}

/// cube face generator
/// pass Yes.normals as parameter to get vertices normals
struct CubeGenerator(Flag!"normals" normals) {

    alias GV = GenVertex!normals;

    private size_t faceFrontIdx =0;
    private size_t faceBackIdx  =6;


    Quad!GV face(in size_t fi) const {
        static if (normals == Yes.normals) {
            float[3] normal () {
                switch (fi) {
                    case 0: return [ 0,  0,  1 ];
                    case 1: return [ 0,  0, -1 ];
                    case 2: return [ 0,  1,  0 ];
                    case 3: return [ 0, -1,  0 ];
                    case 4: return [ 1,  0,  0 ];
                    case 5: return [-1,  0,  0 ];
                    default: assert(false);
                }
            }
            immutable n = normal();
        }

        Quad!ubyte maskFace() {
            switch (fi) {
                case 0: return quad!ubyte(0b001, 0b101, 0b111, 0b011);    // Z+
                case 1: return quad!ubyte(0b100, 0b000, 0b010, 0b110);    // Z-
                case 2: return quad!ubyte(0b011, 0b111, 0b110, 0b010);    // Y+
                case 3: return quad!ubyte(0b101, 0b001, 0b000, 0b100);    // Y-
                case 4: return quad!ubyte(0b101, 0b100, 0b110, 0b111);    // X+
                case 5: return quad!ubyte(0b000, 0b001, 0b011, 0b010);    // X-
                default: assert(false);
            }
        }

        import gfx.genmesh.algorithm : vertexMap;

        return maskFace().vertexMap!((ubyte m) {
            immutable x = (m & 0b100) ? 1f : -1f;
            immutable y = (m & 0b010) ? 1f : -1f;
            immutable z = (m & 0b001) ? 1f : -1f;
            static if (normals == Yes.normals)
                return GV([x, y, z], n);
            else
                return GV([x, y, z]);
        });
    }

    // input
    @property Quad!GV front() const { return face(faceFrontIdx); }

    void popFront() { faceFrontIdx += 1; }

    @property bool empty() const { return faceFrontIdx >= faceBackIdx; }

    // forward
    @property auto save() const {
        return typeof(this)(faceFrontIdx, faceBackIdx);
    }

    // bidir
    @property Quad!GV back() const { return face(faceBackIdx-1); }

    void popBack() { faceBackIdx -= 1; }

    // random access
    @property size_t length() const { return faceBackIdx - faceFrontIdx; }

    Quad!GV opIndex(in size_t fIdx) const {
        return face(fIdx);
    }
}


///
unittest {
    import gfx.genmesh.algorithm;
    import std.algorithm : map, each, equal;
    import std.stdio;

    struct Vertex {
        float[3] pos;
        float[3] normal;
        float[2] texCoord;
    }
    auto cube = genCube()                               // faces of internal vertex type
            .vertexMap!((v) {
                return typeof(v)([2*v.p[0], 2*v.p[1], 2*v.p[2]], v.n);
            })                                          // same face type with a transform (scaled by 2)
            .map!(f => quad(
                Vertex(f[0].p, f[0].n, [0f, 0f]),
                Vertex(f[1].p, f[1].n, [0f, 1f]),
                Vertex(f[2].p, f[2].n, [1f, 1f]),
                Vertex(f[3].p, f[3].n, [1f, 0f]),
            ))                                          // faces with application vertex type (tex coord added)
            .triangulate()                              // triangular faces (with app vertex type)
            .vertices()                                 // application vertices
            .indexCollectMesh();                        // mesh type with array members "indices" and "vertices"

    // only the last step actually pull and transform the data all along the chain

    foreach (f; 0 .. 6) {
        immutable f6 = f*6;
        immutable f4 = f*4;
        assert(cube.indices[f6 .. f6+6].equal([f4, f4+1, f4+2, f4, f4+2, f4+3]));
    }
}
