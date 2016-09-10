module gfx.meshgen.cube;

import gfx.meshgen.poly;

import std.typecons : Flag, Yes;



/// cube face generator
/// pass Yes.normals as parameter to get vertices normals
struct CubeGen(Flag!"normals" normals) {

    alias GV = GenVertex!normals;

    private size_t faceFrontIdx =0;
    private size_t faceBackIdx  =6;


    Quad!GV face(in size_t fi) const {
        static if (normals == Yes.normals) {
            float[3] normal () {
                switch (fi) {
                    case 0: return [ 0,  0,  1];
                    case 1: return [ 0,  0, -1];
                    case 2: return [ 0,  1,  0];
                    case 3: return [ 0, -1,  0];
                    case 4: return [ 1,  0,  0];
                    case 5: return [-1,  0,  0];
                    default: assert(false);
                }
            }
            immutable n = normal();
        }

        Quad!ubyte maskFace() {
            switch (fi) {
                case 0: return quad!ubyte(0b001, 0b101, 0b111, 0b011);    // Z+
                case 1: return quad!ubyte(0b000, 0b010, 0b110, 0b100);    // Z-
                case 2: return quad!ubyte(0b011, 0b111, 0b110, 0b010);    // Y+
                case 3: return quad!ubyte(0b001, 0b000, 0b100, 0b101);    // Y-
                case 4: return quad!ubyte(0b101, 0b100, 0b110, 0b111);    // X+
                case 5: return quad!ubyte(0b001, 0b011, 0b010, 0b000);    // X-
                default: assert(false);
            }
        }

        import gfx.meshgen.algorithm : vertexMap;

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


auto cubeGen(Flag!"normals" normals = Yes.normals)() {
    return CubeGen!normals.init;
}


unittest {
    import gfx.meshgen.algorithm;
    import std.algorithm : map, each;
    import std.stdio;

    struct Vertex {
        float[3] pos;
        float[3] normal;
        float[2] texCoord;
    }
    cubeGen()
            .map!(f => quad(
                Vertex(f[0].p, f[0].n, [0f, 0f]),
                Vertex(f[1].p, f[1].n, [0f, 1f]),
                Vertex(f[2].p, f[2].n, [1f, 1f]),
                Vertex(f[3].p, f[3].n, [1f, 0f]),
            ))
            .triangulate()
            .vertices()
            .each!writeln;
}