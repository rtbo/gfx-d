module gfx.core.program;

import gfx.core : Device, Resource, ResourceHolder;
import gfx.core.rc : RefCounted, Rc, rcCode;

import std.typecons : BitFlags, Flag;
import std.experimental.logger;

enum ShaderStage {
    Vertex, Geometry, Pixel,
}

enum ShaderUsage {
    None = 0,
    Vertex = 1,
    Geometry = 2,
    Pixel = 4,
}
alias ShaderUsageFlags = BitFlags!ShaderUsage;

ShaderUsage toUsage(in ShaderStage stage) {
    final switch(stage) {
    case ShaderStage.Vertex: return ShaderUsage.Vertex;
    case ShaderStage.Geometry: return ShaderUsage.Geometry;
    case ShaderStage.Pixel: return ShaderUsage.Pixel;
    }
}

enum BaseType {
    I32, U32, F32, F64, Bool
}

enum MatrixOrder {
    ColumnMajor, RowMajor,
}

struct VarType {
    BaseType baseType;
    ubyte dim1 = 1;
    ubyte dim2 = 1;
    MatrixOrder order = MatrixOrder.ColumnMajor;

    // scalar ctor
    this(in BaseType baseType) {
        this.baseType = baseType;
    }
    // vector ctor
    this(in BaseType baseType, in ubyte dim) {
        this.baseType = baseType;
        this.dim1 = dim;
    }
    // matrix ctor
    this(in BaseType baseType, in ubyte dim1, in ubyte dim2) {
        this.baseType = baseType;
        this.dim1 = dim1;
        this.dim2 = dim2;
    }
    // matrix ctor
    this(in BaseType baseType, in ubyte dim1, in ubyte dim2, in MatrixOrder order) {
        this.baseType = baseType;
        this.dim1 = dim1;
        this.dim2 = dim2;
        this.order = order;
    }

    @property size_t size() const {
        size_t baseSize() {
            final switch(baseType) {
            case BaseType.I32:
            case BaseType.U32:
            case BaseType.F32:
                return 4;
            case BaseType.F64:
                return 8;
            case BaseType.Bool:
                return 1;
            }
        }
        return dim1*dim2*baseSize();
    }

    @property bool isScalar() const {
        return dim1 == 1 && dim2 == 1;
    }

    @property bool isVector() const {
        return dim1 > 1 && dim2 == 1;
    }

    @property bool isMatrix() const {
        return dim1 > 1 && dim2 > 1;
    }
}

template isVarBaseType(T) {
    enum isVarBaseType =    is(T == int) ||
                            is(T == uint) ||
                            is(T == float) ||
                            is(T == double) ||
                            is(T == bool);
}

// multi purpose template
private template VarTypeTemplate(T, MatrixOrder order=MatrixOrder.ColumnMajor)
{
    template baseType(T) {
        static if (is(T == int)) {
            enum baseType = BaseType.I32;
        }
        else static if (is(T == uint)) {
            enum baseType = BaseType.U32;
        }
        else static if (is(T == float)) {
            enum baseType = BaseType.F32;
        }
        else static if (is(T == double)) {
            enum baseType = BaseType.F64;
        }
        else static if (is(T == bool)) {
            enum baseType = BaseType.Bool;
        }
    }

    static if (isVarBaseType!T) {
        enum type = baseType!T;
        enum dim1 = 1;
        enum dim2 = 1;
    }
    else static if (is(T == U[N], U, ubyte N)) {
        static if (isVarBaseType!U) {
            enum type = baseType!U;
            enum dim1 = N;
            enum dim2 = 1;
        }
        else static if (is(U == V[M], V, ubyte M)) {
            enum type = baseType!V;
            enum dim1 = N;
            enum dim2 = M;
        }
        else {
            static assert(false, "unsupported var type: "~T.stringof);
        }
    }
    else {
        static assert(false, "unsupported var type: "~T.stringof);
    }
    enum matrixOrder = order;
    enum varType = VarType(type, dim1, dim2, order);
}

template varBaseType(T) {
    alias vtt = VarTypeTemplate!T;
    enum varBaseType = vtt.type;
}

template isScalarVarType(T) {
    alias vtt = VarTypeTemplate!T;
    enum isScalarVarType = vtt.dim1 == 1 && vtt.dim1 == 1;
}

template isVectorVarType(T) {
    // should matrices also be vectors? at the moment no.
    alias vtt = VarTypeTemplate!T;
    enum isVectorVarType = vtt.dim1 > 1 && vtt.dim2 == 1;
}

template isMatrixVarType(T) {
    alias vtt = VarTypeTemplate!T;
    enum isMatrixVarType = vtt.dim1 > 1 && vtt.dim2 > 1;
}

template varType(T, MatrixOrder order=MatrixOrder.ColumnMajor) {
    alias vtt = VarTypeTemplate!(T, order);
    enum varType = vtt.varType;
}

template varDim1(T) {
    alias vtt = VarTypeTemplate!T;
    enum varDim1 = vtt.dim1;
}

template varDim2(T) {
    alias vtt = VarTypeTemplate!T;
    enum varDim2 = vtt.dim2;
}

version(unittest) {
    static assert(varBaseType!int == BaseType.I32);
    static assert( isScalarVarType!float);
    static assert(!isVectorVarType!float);
    static assert(!isMatrixVarType!float);

    static assert(!isScalarVarType!(float[3]));
    static assert( isVectorVarType!(float[3]));
    static assert(!isMatrixVarType!(float[3]));

    static assert(!isScalarVarType!(float[3][3]));
    static assert(!isVectorVarType!(float[3][3]));
    static assert( isMatrixVarType!(float[3][3]));

    unittest {
        immutable vt = varType!(int[4]);
        assert(vt.baseType == BaseType.I32);
        assert(vt.dim1 == 4);
        assert(vt.dim2 == 1);
        assert(!vt.isScalar);
        assert( vt.isVector);
        assert(!vt.isMatrix);
        assert(vt.size == 16);
    }
}


struct AttributeVar {
    string name;
    ubyte loc;
    VarType type;
}

struct ConstVar {
    string name;
    ubyte loc;
    ubyte count;
    VarType type;
}

struct ConstBufferVar {
    string name;
    ubyte loc;
    size_t size;
    ConstVar[] vars;
}

enum TextureVarType {
    Buffer, D1, D1Array,
    D2, D2Array, D2Multisample, D2ArrayMultisample,
    D3, Cube, CubeArray
}
bool canSample(in TextureVarType tt) {
    final switch(tt) {
        case TextureVarType.Buffer:
        case TextureVarType.D2Multisample:
        case TextureVarType.D2ArrayMultisample:
            return false;
        case TextureVarType.D1:
        case TextureVarType.D1Array:
        case TextureVarType.D2:
        case TextureVarType.D2Array:
        case TextureVarType.D3:
        case TextureVarType.Cube:
        case TextureVarType.CubeArray:
            return true;
    }
}

struct TextureVar {
    string name;
    ubyte loc;
    BaseType baseType;
    TextureVarType type;
    //ShaderUsageFlags usage;
}

/// Sampler shader parameter.
struct SamplerVar {
    /// Name of this sampler variable.
    string name;
    /// Slot of this sampler variable.
    ubyte slot;
    /// Is it a rect sampler?
    Flag!"rect" isRect;
    /// Is it a compare sampler?
    Flag!"compare" isCompare;
    // What program stage this texture is used in.
    //ShaderUsageFlags usage;
}

struct OutputVar {
    string name;
    ubyte index;
    VarType type;
}

struct ProgramVars {
    AttributeVar[] attributes;
    ConstVar[] consts;
    ConstBufferVar[] constBuffers;
    TextureVar[] textures;
    SamplerVar[] samplers;
    OutputVar[] outputs;

    @property string infoString() const {
        import std.format : format;
        import std.conv : to;
        string res;
        res ~= format("Attributes:   %s\n", attributes.to!string);
        res ~= format("Consts:       %s\n", consts.to!string);
        res ~= format("ConstBuffers: %s\n", constBuffers.to!string);
        res ~= format("Textures:     %s\n", textures.to!string);
        res ~= format("Samplers:     %s\n", samplers.to!string);
        res ~= format("Outputs:      %s\n", outputs.to!string);
        return res;
    }
}


struct ShaderSet {
    private enum Type {
        VertexPixel,
        VertexGeometryPixel,
    }
    private Type type;
    private Shader[] shaders;

    this(Type type, Shader[] shaders) {
        this.type = type;
        this.shaders = shaders;

        import std.algorithm : each;
        this.shaders.each!(s => s.addRef());
    }

    this(this) {
        import std.algorithm: each;
        this.shaders.each!(s => s.addRef());
    }

    ~this() {
        import std.algorithm : each;
        this.shaders.each!(s => s.release());
    }

    static ShaderSet vertexPixel(string vertexCode, string pixelCode) {
        auto vs = new Shader(ShaderStage.Vertex, vertexCode);
        auto ps = new Shader(ShaderStage.Pixel, pixelCode);
        return ShaderSet(Type.VertexPixel, [vs, ps]);
    }

    static ShaderSet vertexGeometryPixel(string vertexCode, string geomCode, string pixelCode) {
        auto vs = new Shader(ShaderStage.Vertex, vertexCode);
        auto gs = new Shader(ShaderStage.Geometry, geomCode);
        auto ps = new Shader(ShaderStage.Pixel, pixelCode);
        return ShaderSet(Type.VertexGeometryPixel, [vs, gs, ps]);
    }
}


interface ShaderRes : Resource {
    @property ShaderStage stage() const;
}
interface ProgramRes : Resource {
    void bind();
    ProgramVars fetchVars() const;
}

class Shader : ResourceHolder {
    mixin(rcCode);

    Rc!ShaderRes _res;
    ShaderStage _stage;
    string _code;

    this(ShaderStage stage, string code) {
        _stage = stage;
        _code = code;
    }

    final @property ShaderStage stage() const { return _stage; }

    final @property inout(ShaderRes) res() inout { return _res; }

    final void pinResources(Device device) {
        _res = device.factory.makeShader(_stage, _code);
    }

    final void drop() {
        _res.unload();
    }
}

class Program : ResourceHolder {
    mixin(rcCode);

    Rc!ProgramRes _res;
    Shader[] _shaders;

    this(Shader[] shaders) {
        import std.algorithm : each;
        _shaders = shaders;
        _shaders.each!(s => s.addRef());
    }

    this(ShaderSet shaderSet) {
        import std.algorithm : each;
        _shaders = shaderSet.shaders;
        _shaders.each!(s => s.addRef());
    }

    final @property inout(ProgramRes) res() inout { return _res; }

    final void pinResources(Device device) {
        import std.algorithm : map, each;
        import std.array : array;
        _shaders.each!((s) { if(!s.pinned) s.pinResources(device); });
        auto resArr = _shaders.map!(s => s._res.obj).array();
        _res = device.factory.makeProgram(resArr);
        _shaders.each!(s => s.release());
        _shaders = [];
    }

    final ProgramVars fetchVars() const {
        assert(pinned);
        return _res.fetchVars();
    }


    final void drop() {
        import std.algorithm : each;
        _shaders.each!(s => s.release()); // in case pinResources was not called
        _shaders = [];
        _res.unload();
    }
}