module gfx.backend.gl3.program;

import gfx.backend;
import gfx.core.context;
import gfx.core.rc;
import gfx.core.program;
import gfx.core.error;

import derelict.opengl3.gl3;

import std.experimental.logger;
import std.typecons : Flag, Yes, No;


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
        case GL_SAMPLER_2D_MULTISAMPLE_ARRAY : return Storage.makeSampler(BaseType.F32, TextureVarType.D2ArrayMultisample, 
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


void queryUniforms(in bool uboSupport, in GLuint program, in ShaderUsageFlags usage,
        out ConstVar[] consts, out TextureVar[] textures,
        out SamplerVar[] samplers) {

    import std.algorithm : filter, startsWith;
    import std.array : array;
    import std.range : iota, repeat, take;

    immutable numUniforms = getProgramInt(program, GL_ACTIVE_UNIFORMS);
    immutable inds = array(iota(cast(GLuint)numUniforms));

    auto blockInds = array(repeat(-1).take(numUniforms));
    if (uboSupport) {
        glGetActiveUniformsiv(program, numUniforms, inds.ptr,
                GL_UNIFORM_BLOCK_INDEX, blockInds.ptr);
    }

    immutable maxNameLen = getProgramInt(program, GL_ACTIVE_UNIFORM_MAX_LENGTH);
    auto nameBuf = new char[maxNameLen];

    glUseProgram(program); // necessary for glUniform
    int texSlot = 0;

    foreach(i; inds.filter!(i => blockInds[i] < 0)) {
        GLint size;
        GLenum type;
        GLsizei nameLen;
        glGetActiveUniform(program, i, maxNameLen, &nameLen, &size, &type, nameBuf.ptr);
        auto loc = glGetUniformLocation(program, nameBuf.ptr);

        auto name = nameBuf[0 .. nameLen].idup;
        if(name.startsWith("gl_")) continue;


        auto storage = glTypeToStorage(type);
        final switch(storage.type) {
            case StorageType.Var:
                consts ~= ConstVar(name, cast(ubyte)loc, cast(ubyte)size, storage.varType);
                infof("Uniform[%s] = %s\t%s", loc, name, storage.varType);
                break;

            case StorageType.Sampler:
                // affect a slot to each sampler
                auto slot = texSlot;
                texSlot += 1;
                glUniform1i(loc, slot);
                textures ~= TextureVar(name, cast(ubyte)slot, storage.baseType, storage.texType, usage);
                infof("Sampler[%s] = %s\t%s\t%s", slot, name, storage.baseType, storage.texType);
                if (storage.texType.canSample())
                    samplers ~= SamplerVar(name, cast(ubyte)slot,
                        storage.rectSampler, storage.compareSampler, usage);
                break;

            case StorageType.Unknown:
                break;
        }
    }
}

AttributeVar[] queryAttributes(in GLuint prog) {
    import std.algorithm : startsWith;
    import std.exception : enforce;

    immutable numAttrs = getProgramInt(prog, GL_ACTIVE_ATTRIBUTES);
    immutable maxNameLen = getProgramInt(prog, GL_ACTIVE_ATTRIBUTE_MAX_LENGTH);
    auto nameBuf = new char[maxNameLen];
    AttributeVar[] res;
    foreach(GLuint i; 0 .. numAttrs) {
        GLsizei len;
        GLint size;
        GLenum type;
        glGetActiveAttrib(prog, i, maxNameLen, &len, &size, &type, nameBuf.ptr);
        auto loc = glGetAttribLocation(prog, nameBuf.ptr);

        string name = nameBuf[0 .. len].idup;
        if (name.startsWith("gl_")) continue;

        immutable storage = glTypeToStorage(type);
        enforce(storage.type == StorageType.Var);

        res ~= AttributeVar(name, cast(ubyte)loc, storage.varType);
    }

    return res;
}

ConstBufferVar[] queryBlocks(in GLuint prog) {

    import std.algorithm : map, any;
    import std.array : array;
    import std.exception : assumeUnique;
    import std.range : iota;
    import std.typecons : BitFlags;

    immutable numBlocks = getProgramInt(prog, GL_ACTIVE_UNIFORM_BLOCKS);
    immutable bindings = assumeUnique(array(iota(numBlocks).map!(
        (idx) {
            return cast(GLuint)getBlockInt(prog, idx, GL_UNIFORM_BLOCK_BINDING);
        }
    )));
    immutable explicitBindings = bindings.any!(b => b>0);
    ConstBufferVar[] res;

    foreach(GLuint idx, bind; bindings) {
        immutable nameSize = cast(GLsizei)getBlockInt(prog, idx, GL_UNIFORM_BLOCK_NAME_LENGTH);
        auto nameBuf = new char[nameSize];
        GLsizei nameLen;
        glGetActiveUniformBlockName(prog, idx, nameSize, &nameLen, nameBuf.ptr);
        string name = nameBuf[0 .. nameLen].idup;

        ShaderUsageFlags usage;
        if (getBlockInt(prog, idx, GL_UNIFORM_BLOCK_REFERENCED_BY_VERTEX_SHADER))
            usage |= ShaderUsage.Vertex;
        if (getBlockInt(prog, idx, GL_UNIFORM_BLOCK_REFERENCED_BY_GEOMETRY_SHADER))
            usage |= ShaderUsage.Geometry;
        if (getBlockInt(prog, idx, GL_UNIFORM_BLOCK_REFERENCED_BY_FRAGMENT_SHADER))
            usage |= ShaderUsage.Pixel;

        immutable size = cast(size_t)getBlockInt(prog, idx, GL_UNIFORM_BLOCK_DATA_SIZE);
        ubyte slot;
        if (explicitBindings) {
            slot = cast(ubyte)bind;
        } else {
            glUniformBlockBinding(prog, idx, idx);
            slot = cast(ubyte)idx;
        }

        res ~= ConstBufferVar(name, slot, size, usage);
    }
    return res;
}



class GlShader : ShaderRes {
    mixin RcCode!();

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
    mixin RcCode!();

    GLuint _name;

    this(in bool uboSupport, ShaderRes[] shaders, out ProgramVars vars) {
        import std.algorithm : map, each, fold;
         
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

        ShaderUsageFlags usage = shaders.map!(s => s.stage)
            .fold!((u, s) => u | s.toUsage())(ShaderUsage.None);

        vars.attributes = queryAttributes(_name);
        queryUniforms(uboSupport, _name, usage, vars.consts, vars.textures, vars.samplers);
        if(uboSupport) vars.constBuffers = queryBlocks(_name);
    }

    void drop() {
        glDeleteProgram(_name);
    }

    void bind() {
        glUseProgram(_name);
    }
}