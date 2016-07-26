module gfx.backend.gl3.buffer;

import gfx.core.rc : rcCode;
import gfx.core.factory : Factory;
import gfx.core.program : BaseType;
import gfx.core.buffer : BufferRes, BufferRole, BufferUsage, BufferSliceInfo;
import gfx.core.pso : VertexAttribDesc;

import derelict.opengl3.gl3;

import std.experimental.logger;


GLenum roleToGlTarget(in BufferRole role) {
    final switch(role) {
        case BufferRole.Vertex: return GL_ARRAY_BUFFER;
        case BufferRole.Index: return GL_ELEMENT_ARRAY_BUFFER;
        case BufferRole.Constant: return GL_UNIFORM_BUFFER;
        case BufferRole.ShaderResource: return GL_TEXTURE_BUFFER;
    }
}

GLenum usageToGl(in BufferUsage usage) {
    final switch(usage) {
        case BufferUsage.GpuOnly:
        case BufferUsage.Const: return GL_STATIC_DRAW;
        case BufferUsage.Dynamic: return GL_DYNAMIC_DRAW;
        case BufferUsage.CpuOnly: return GL_STREAM_DRAW;
    }
}

GLenum baseTypeToGl(in BaseType type) {
    final switch(type) {
        case BaseType.I32: return GL_INT;
        case BaseType.U32: return GL_UNSIGNED_INT;
        case BaseType.F32: return GL_FLOAT;
        case BaseType.F64: return GL_DOUBLE;
        case BaseType.Bool: return GL_UNSIGNED_BYTE;
    }
}


GlBuffer makeBufferImpl(in Factory.BufferCreationDesc desc, const(ubyte)[] data) {
    if (desc.role == BufferRole.Vertex) {
        return new GlVertexBuffer(desc, data);
    }
    else {
        return new GlBuffer(desc, data);
    }
}


class GlBuffer : BufferRes {
    mixin(rcCode);

    GLuint _name;
    GLenum _target;
    GLenum _usage;
    GLsizeiptr _size;


    this(in Factory.BufferCreationDesc desc, const(ubyte)[] data) {
        glGenBuffers(1, &_name);
        _target = roleToGlTarget(desc.role);
        _usage = usageToGl(desc.usage);
        _size = desc.size;
        GLvoid* ptr = data.length == 0 ? null : cast(GLvoid*)data.ptr;
        glBindBuffer(_target, _name);
        glBufferData(_target, _size, ptr, _usage);
    }

    void drop() {
        glDeleteBuffers(1, &_name);
    }
    void bind() {
        glBindBuffer(_target, _name);
    }
    void update(BufferSliceInfo slice, const(ubyte)[] data) {
        assert(slice.size <= data.length);
        assert(_size >= slice.offset+slice.size);
        glBufferSubData(_target, slice.offset, slice.size, cast(const(GLvoid*))data.ptr);
    }

    @property GLuint name() const { return _name; }
    @property GLenum target() const { return _target; }
}


class GlVertexBuffer : GlBuffer {

    this(in Factory.BufferCreationDesc desc, const(ubyte)[] data) {
        assert(desc.role == BufferRole.Vertex);
        super(desc, data);
    }

    void bindWithAttrib(in VertexAttribDesc attrib, bool instanceRateSupport) {
        import gfx.core.program : BaseType;

        assert(!attrib.field.type.isMatrix);
        immutable glType = baseTypeToGl(attrib.field.type.baseType);
        immutable count = attrib.field.type.dim1;

        bind();
        auto offset = cast(const(GLvoid)*)attrib.field.offset;
        immutable stride = cast(GLint)attrib.field.stride;
        switch (attrib.field.type.baseType) {
            case BaseType.I32:
            case BaseType.U32:
                glVertexAttribIPointer(attrib.slot, count, glType, stride, offset);
                break;
            case BaseType.F32:
                glVertexAttribPointer(attrib.slot, count, glType, GL_FALSE, stride, offset);
                break;
            default:
                errorf("bind vertex: unsupported base type: %s", attrib.field.type.baseType);
                break;
        }
        glEnableVertexAttribArray(attrib.slot);
        if (instanceRateSupport) {
            glVertexAttribDivisor(attrib.slot, attrib.instanceRate);
        }
        else if (attrib.instanceRate != 0) {
            error("bind vertex: instanceRate unsupported");
        }
    }
}
