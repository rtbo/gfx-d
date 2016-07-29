module gfx.backend.gl3.program;

import gfx.core.factory : Factory;
import gfx.core.rc : rcCode;
import gfx.core.program;
import gfx.core.error;

import derelict.opengl3.gl3;

import std.experimental.logger;
import std.typecons : Flag, Yes, No;
import std.exception : enforce, assumeUnique;


GLenum stageToGlType(in ShaderStage stage) {
    final switch(stage) {
        case ShaderStage.Vertex:
            return GL_VERTEX_SHADER;
        case ShaderStage.Geometry:
            return GL_GEOMETRY_SHADER;
        case ShaderStage.Pixel:
            return GL_FRAGMENT_SHADER;
    }
}

GLint getShaderInt(in GLuint name, in GLenum pname) {
    GLint res;
    glGetShaderiv(name, pname, &res);
    return res;
}

bool getShaderCompileStatus(in GLuint name) {
    return getShaderInt(name, GL_COMPILE_STATUS) != GL_FALSE;
}

string getShaderLog(in GLuint name) {
    GLsizei len = getShaderInt(name, GL_INFO_LOG_LENGTH);
    if (len > 0) {
        auto msg = new char[len];
        glGetShaderInfoLog(name, len, &len, msg.ptr);
        return msg[0..len].idup;
    }
    else {
        return [];
    }
}



GLint getProgramInt(in GLuint name, in GLenum pname) {
    GLint res;
    glGetProgramiv(name, pname, &res);
    return res;
}

bool getProgramLinkStatus(in GLuint name) {
    return getProgramInt(name, GL_LINK_STATUS) != GL_FALSE;
}


string getProgramLog(in GLuint name) {
    GLsizei len = getProgramInt(name, GL_INFO_LOG_LENGTH);
    if (len > 0) {
        auto msg = new char[len];
        glGetProgramInfoLog(name, len, &len, msg.ptr);
        return msg[0..len].idup;
    }
    else {
        return [];
    }
}


GLint getBlockInt(in GLuint prog, in GLuint ind, in GLenum pname) {
    GLint res;
    glGetActiveUniformBlockiv(prog, ind, pname, &res);
    return res;
}

GLint getProgramInterfaceInt(in GLuint prog, in GLenum interf, in GLenum pname) {
    GLint res;
    glGetProgramInterfaceiv(prog, interf, pname, &res);
    return res;
}

GLint getProgramResourceInt(in GLuint prog, in GLenum interf, in GLuint index, in GLenum prop) {
    GLint res;
    GLsizei numWritten;
    glGetProgramResourceiv(prog, interf, index, 1, &prop, 1, &numWritten, &res);
    enforce(numWritten == 1);
    return res;
}

immutable(GLint)[] getProgramResourceInts(in GLuint prog, in GLenum interf, in GLuint index, in GLenum[] props) {
    auto res = new GLint[props.length];
    GLsizei numWritten;
    glGetProgramResourceiv(prog, interf, index, cast(GLsizei)props.length,
            props.ptr, cast(GLsizei)res.length, &numWritten, res.ptr);
    enforce(numWritten == props.length);
    return assumeUnique(res);
}


GLint getProgramOutputInt(in GLuint prog, in GLuint ind, in GLenum pname) {
    GLint res;
    glGetProgramResourceiv(prog, GL_PROGRAM_OUTPUT, ind, 1, &pname, 1, null, &res);
    return res;
}




enum StorageType {
    Unknown,
    Var, Sampler,
}
struct Storage {
    StorageType type;

    // for vars
    VarType varType;

    // for samplers
    BaseType baseType;
    TextureVarType texType;
    Flag!"compare" compareSampler;
    Flag!"rect" rectSampler;


    static Storage makeVar(VarType varType) {
        Storage res;
        res.type = StorageType.Var;
        res.varType = varType;
        return res;
    }

    static Storage makeSampler(BaseType baseType, TextureVarType texType,
                Flag!"compare" compareSampler, Flag!"rect" rectSampler) {
        Storage res;
        res.type = StorageType.Sampler;
        res.baseType = baseType;
        res.texType = texType;
        res.rectSampler = rectSampler;
        res.compareSampler = compareSampler;
        return res;
    }
}


Storage glTypeToStorage(in GLenum type) {
    switch(type) {
        case GL_FLOAT                        : return Storage.makeVar(VarType(BaseType.F32,  1, 1));
        case GL_FLOAT_VEC2                   : return Storage.makeVar(VarType(BaseType.F32,  2, 1));
        case GL_FLOAT_VEC3                   : return Storage.makeVar(VarType(BaseType.F32,  3, 1));
        case GL_FLOAT_VEC4                   : return Storage.makeVar(VarType(BaseType.F32,  4, 1));

        case GL_INT                          : return Storage.makeVar(VarType(BaseType.I32,  1, 1));
        case GL_INT_VEC2                     : return Storage.makeVar(VarType(BaseType.I32,  2, 1));
        case GL_INT_VEC3                     : return Storage.makeVar(VarType(BaseType.I32,  3, 1));
        case GL_INT_VEC4                     : return Storage.makeVar(VarType(BaseType.I32,  4, 1));

        case GL_UNSIGNED_INT                 : return Storage.makeVar(VarType(BaseType.U32,  1, 1));
        case GL_UNSIGNED_INT_VEC2            : return Storage.makeVar(VarType(BaseType.U32,  2, 1));
        case GL_UNSIGNED_INT_VEC3            : return Storage.makeVar(VarType(BaseType.U32,  3, 1));
        case GL_UNSIGNED_INT_VEC4            : return Storage.makeVar(VarType(BaseType.U32,  4, 1));

        case GL_BOOL                         : return Storage.makeVar(VarType(BaseType.Bool, 1, 1));
        case GL_BOOL_VEC2                    : return Storage.makeVar(VarType(BaseType.Bool, 2, 1));
        case GL_BOOL_VEC3                    : return Storage.makeVar(VarType(BaseType.Bool, 3, 1));
        case GL_BOOL_VEC4                    : return Storage.makeVar(VarType(BaseType.Bool, 4, 1));

        case GL_FLOAT_MAT2                   : return Storage.makeVar(VarType(BaseType.F32,  2, 2));
        case GL_FLOAT_MAT3                   : return Storage.makeVar(VarType(BaseType.F32,  3, 3));
        case GL_FLOAT_MAT4                   : return Storage.makeVar(VarType(BaseType.F32,  4, 4));

        case GL_FLOAT_MAT2x3                 : return Storage.makeVar(VarType(BaseType.F32,  2, 3));
        case GL_FLOAT_MAT2x4                 : return Storage.makeVar(VarType(BaseType.F32,  2, 4));
        case GL_FLOAT_MAT3x2                 : return Storage.makeVar(VarType(BaseType.F32,  3, 2));
        case GL_FLOAT_MAT3x4                 : return Storage.makeVar(VarType(BaseType.F32,  3, 4));
        case GL_FLOAT_MAT4x2                 : return Storage.makeVar(VarType(BaseType.F32,  4, 2));
        case GL_FLOAT_MAT4x3                 : return Storage.makeVar(VarType(BaseType.F32,  4, 3));

        // TODO: double matrices

        case GL_SAMPLER_1D                   : return Storage.makeSampler(BaseType.F32, TextureVarType.D1,
                                                                            No.compare,     No.rect);
        case GL_SAMPLER_1D_ARRAY             : return Storage.makeSampler(BaseType.F32, TextureVarType.D1Array,
                                                                            No.compare,     No.rect);
        case GL_SAMPLER_1D_SHADOW            : return Storage.makeSampler(BaseType.F32, TextureVarType.D1,
                                                                            Yes.compare,    No.rect);
        case GL_SAMPLER_1D_ARRAY_SHADOW      : return Storage.makeSampler(BaseType.F32, TextureVarType.D1Array,
                                                                            Yes.compare,    No.rect);

        case GL_SAMPLER_2D                   : return Storage.makeSampler(BaseType.F32, TextureVarType.D2,
                                                                            No.compare,     No.rect);
        case GL_SAMPLER_2D_ARRAY             : return Storage.makeSampler(BaseType.F32, TextureVarType.D2Array,
                                                                            No.compare,     No.rect);
        case GL_SAMPLER_2D_SHADOW            : return Storage.makeSampler(BaseType.F32, TextureVarType.D2,
                                                                            Yes.compare,    No.rect);
        case GL_SAMPLER_2D_MULTISAMPLE       : return Storage.makeSampler(BaseType.F32, TextureVarType.D2Multisample,
                                                                            No.compare,     No.rect);
        case GL_SAMPLER_2D_RECT              : return Storage.makeSampler(BaseType.F32, TextureVarType.D2,
                                                                            No.compare,     Yes.rect);
        case GL_SAMPLER_2D_ARRAY_SHADOW      : return Storage.makeSampler(BaseType.F32, TextureVarType.D2Array,
                                                                            Yes.compare,    No.rect);
        case GL_SAMPLER_2D_MULTISAMPLE_ARRAY : return Storage.makeSampler(BaseType.F32,
                                                                            TextureVarType.D2ArrayMultisample,
                                                                            No.compare,     No.rect);
        case GL_SAMPLER_2D_RECT_SHADOW       : return Storage.makeSampler(BaseType.F32, TextureVarType.D2,
                                                                            Yes.compare,    Yes.rect);

        case GL_SAMPLER_3D                   : return Storage.makeSampler(BaseType.F32, TextureVarType.D3,
                                                                            No.compare,     No.rect);

        case GL_SAMPLER_CUBE                 : return Storage.makeSampler(BaseType.F32, TextureVarType.Cube,
                                                                            No.compare,     No.rect);
        case GL_SAMPLER_CUBE_MAP_ARRAY       : return Storage.makeSampler(BaseType.F32, TextureVarType.CubeArray,
                                                                            No.compare,     No.rect);
        case GL_SAMPLER_CUBE_SHADOW          : return Storage.makeSampler(BaseType.F32, TextureVarType.Cube,
                                                                            Yes.compare,    No.rect);
        case GL_SAMPLER_CUBE_MAP_ARRAY_SHADOW: return Storage.makeSampler(BaseType.F32, TextureVarType.CubeArray,
                                                                            Yes.compare,    No.rect);

        case GL_INT_SAMPLER_BUFFER           : return Storage.makeSampler(BaseType.I32, TextureVarType.Buffer,
                                                                            No.compare,     No.rect);
        default:
            return Storage.init;
    }
}

AttributeVar[] queryAttributes(in GLuint prog) {
    immutable bufLen = cast(GLsizei)getProgramInterfaceInt(prog, GL_PROGRAM_INPUT, GL_MAX_NAME_LENGTH);
    immutable numAttribs = getProgramInterfaceInt(prog, GL_PROGRAM_INPUT, GL_ACTIVE_RESOURCES);

    auto nameBuf = new char[bufLen];
    auto res = new AttributeVar[numAttribs];

    foreach(i; 0..numAttribs) {
        GLsizei nameLen;
        glGetProgramResourceName(prog, GL_PROGRAM_INPUT, i, bufLen, &nameLen, nameBuf.ptr);
        string name = nameBuf[0 .. nameLen].idup;

        immutable locType = getProgramResourceInts(prog, GL_PROGRAM_INPUT, i, [GL_LOCATION, GL_TYPE]);
        immutable storage = glTypeToStorage(locType[1]);
        enforce(storage.type == StorageType.Var);

        res[i] = AttributeVar(name, cast(ubyte)locType[0], storage.varType);
    }

    return res;
}


void queryUniforms(in GLuint prog, in bool supportsUbo,
out ConstVar[] consts, out ConstVar[][] blockVars, out TextureVar[] textures, out SamplerVar[] samplers) {

    immutable bufLen = cast(GLsizei)getProgramInterfaceInt(prog, GL_UNIFORM, GL_MAX_NAME_LENGTH);
    immutable numVars = getProgramInterfaceInt(prog, GL_UNIFORM, GL_ACTIVE_RESOURCES);
    if(supportsUbo) {
        immutable numUbos = getProgramInterfaceInt(prog, GL_UNIFORM_BLOCK, GL_ACTIVE_RESOURCES);
        blockVars.length = numUbos;
    }

    auto nameBuf = new char[bufLen];

    ubyte texSlot = 0;
    glUseProgram(prog);

    foreach(i; 0 .. numVars) {
        GLsizei nameLen;
        glGetProgramResourceName(prog, GL_UNIFORM, i, bufLen, &nameLen, nameBuf.ptr);
        string name = nameBuf[0 .. nameLen].idup;

        immutable location = getProgramResourceInt(prog, GL_UNIFORM, i, GL_LOCATION);
        immutable type = getProgramResourceInt(prog, GL_UNIFORM, i, GL_TYPE);
        immutable arraySize = getProgramResourceInt(prog, GL_UNIFORM, i, GL_ARRAY_SIZE);

        immutable storage = glTypeToStorage(type);
        if(storage.type == StorageType.Var) {
            auto var = ConstVar(name, cast(ubyte)location, cast(ubyte)arraySize, storage.varType);
            immutable index = getProgramResourceInt(prog, GL_UNIFORM, i, GL_BLOCK_INDEX);
            if(supportsUbo && index != -1) {
                blockVars[index] ~= var;
            }
            else {
                consts ~= var;
            }
        }
        else {
            immutable slot = texSlot;
            texSlot += 1;
            glUniform1i(location, slot);
            auto tex = TextureVar(name, slot, storage.baseType, storage.texType);
            auto sampler = SamplerVar(name, slot, storage.rectSampler, storage.compareSampler);
            textures ~= tex;
            samplers ~= sampler;
        }
    }
}


ConstBufferVar[] queryUniformBlocks(GLuint prog, ConstVar[][] blockVars) {

    immutable bufLen = cast(GLsizei)getProgramInterfaceInt(prog, GL_UNIFORM_BLOCK, GL_MAX_NAME_LENGTH);

    auto nameBuf = new char[bufLen];
    auto res = new ConstBufferVar[blockVars.length];

    foreach(i; 0 .. cast(GLsizei)res.length) {
        GLsizei nameLen;
        glGetProgramResourceName(prog, GL_UNIFORM_BLOCK, i, bufLen, &nameLen, nameBuf.ptr);
        string name = nameBuf[0 .. nameLen].idup;

        immutable size = getProgramResourceInt(prog, GL_UNIFORM_BLOCK, i, GL_BUFFER_DATA_SIZE);
        immutable loc = getProgramResourceInt(prog, GL_UNIFORM_BLOCK, i, GL_BUFFER_BINDING);
        immutable numVars = getProgramResourceInt(prog, GL_UNIFORM_BLOCK, i, GL_NUM_ACTIVE_VARIABLES);

        enforce(numVars == blockVars[i].length);

        res[i] = ConstBufferVar(name, cast(ubyte)loc, size, blockVars[i]);
    }

    // check binding points
    import std.algorithm : map, canFind;
    if (!res.map!(cbv => cbv.loc).canFind!(loc => loc>1)) {
        // no binding points set manually, we set them ourselves
        foreach (GLuint i, ref cbv; res) {
            glUniformBlockBinding(prog, i, i);
            cbv.loc = cast(ubyte)i;
        }
    }

    return res;
}

OutputVar[] queryOutputs(GLuint prog) {
    immutable bufLen = cast(GLsizei)getProgramInterfaceInt(prog, GL_PROGRAM_OUTPUT, GL_MAX_NAME_LENGTH);
    immutable numOutputs = getProgramInterfaceInt(prog, GL_PROGRAM_OUTPUT, GL_ACTIVE_RESOURCES);

    auto nameBuf = new char[bufLen];
    auto res = new OutputVar[numOutputs];

    foreach(i; 0 .. numOutputs) {
        GLsizei nameLen;
        glGetProgramResourceName(prog, GL_PROGRAM_OUTPUT, i, bufLen, &nameLen, nameBuf.ptr);
        string name = nameBuf[0 .. nameLen].idup;

        immutable type = getProgramResourceInt(prog, GL_PROGRAM_OUTPUT, i, GL_TYPE);
        immutable location = getProgramResourceInt(prog, GL_PROGRAM_OUTPUT, i, GL_LOCATION);

        immutable storage = glTypeToStorage(type);
        enforce(storage.type == StorageType.Var);

        res[i] = OutputVar(name, cast(ubyte)location, storage.varType);
    }

    return res;
}


class GlShader : ShaderRes {
    mixin(rcCode);

    GLuint _name;
    ShaderStage _stage;

    this(ShaderStage stage, string code) {
        _name = glCreateShader(stageToGlType(stage));
        _stage = stage;
        scope(failure) glDeleteShader(_name);

        const(GLchar)* ptr = &code[0];
        auto len = cast(GLint)code.length;
        glShaderSource(_name, 1, &ptr, &len);

        glCompileShader(_name);

        auto log = getShaderLog(_name);
        if (!getShaderCompileStatus(_name)) {
            throw new ShaderCompileError(stage, code, log);
        }

        if (log.length != 0) {
            warningf("shader compile error message:\n%s", log);
        }
    }

    void drop() {
        glDeleteShader(_name);
    }

    @property ShaderStage stage() const { return _stage; }
}



class GlProgram : ProgramRes {
    mixin(rcCode);

    GLuint _name;
    bool _uboSupport;
    ShaderUsageFlags _usage;

    this(in bool uboSupport, ShaderRes[] shaders) {
        import std.algorithm : map, each/+, fold+/;
        import gfx.core.util : unsafeCast;

        _uboSupport = uboSupport;
        _name = glCreateProgram();

        shaders
            .map!(s => unsafeCast!GlShader(s))
            .each!(s => glAttachShader(_name, s._name));

        glLinkProgram(_name);
        string log = getProgramLog(_name);
        if (!getProgramLinkStatus(_name)) {
            throw new ProgramLinkError(log);
        }

        if (log.length != 0) {
            warningf("link error of shader program:\n%s", log);
        }

        //_usage = shaders.map!(s => s.stage)
        //    .fold!((u, s) => u | s.toUsage())(ShaderUsage.None);
        foreach(sh; shaders) {
            _usage |= sh.stage.toUsage();
        }
    }

    final void drop() {
        glDeleteProgram(_name);
    }

    final void bind() {
        glUseProgram(_name);
    }

    final ProgramVars fetchVars() const {
        ProgramVars vars;
        ConstVar[][] blockVars;

        vars.attributes = queryAttributes(_name);
        queryUniforms(_name, _uboSupport, vars.consts,  blockVars, vars.textures, vars.samplers);
        if(_uboSupport) vars.constBuffers = queryUniformBlocks(_name, blockVars);
        vars.outputs = queryOutputs(_name);

        return vars;
    }
}