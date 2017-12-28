module gfx.device.gl3.buffer;

import gfx.foundation.rc : gfxRcCode;
import gfx.device.factory : Factory;
import gfx.pipeline.program : BaseType;
import gfx.pipeline.buffer : BufferRes, BufferRole, BufferUsage;
import gfx.pipeline.pso : VertexAttribDesc;

import derelict.opengl3.gl3;

import std.experimental.logger;


GLenum roleToGlTarget(in BufferRole role) {
    final switch(role) {
        case BufferRole.vertex: return GL_ARRAY_BUFFER;
        case BufferRole.index: return GL_ELEMENT_ARRAY_BUFFER;
        case BufferRole.constant: return GL_UNIFORM_BUFFER;
        case BufferRole.shaderResource: return GL_TEXTURE_BUFFER;
    }
}

GLenum usageToGl(in BufferUsage usage) {
    final switch(usage) {
        case BufferUsage.gpuOnly:
        case BufferUsage.constant: return GL_STATIC_DRAW;
        case BufferUsage.dynamic: return GL_DYNAMIC_DRAW;
        case BufferUsage.cpuOnly: return GL_STREAM_DRAW;
    }
}

GLenum baseTypeToGl(in BaseType type) {
    final switch(type) {
        case BaseType.i32: return GL_INT;
        case BaseType.u32: return GL_UNSIGNED_INT;
        case BaseType.f32: return GL_FLOAT;
        case BaseType.f64: return GL_DOUBLE;
        case BaseType.boolean: return GL_UNSIGNED_BYTE;
    }
}


GlBuffer makeBufferImpl(in Factory.BufferCreationDesc desc, const(ubyte)[] data) {
    if (desc.role == BufferRole.vertex) {
        return new GlVertexBuffer(desc, data);
    }
    else {
        return new GlBuffer(desc, data);
    }
}


class GlBuffer : BufferRes {
    mixin(gfxRcCode);

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

    final void dispose() {
        glDeleteBuffers(1, &_name);
    }
    final void bind() {
        glBindBuffer(_target, _name);
    }
    final void update(size_t offset, const(ubyte)[] data) {
        assert(_size >= offset+data.length);
        bind();
        glBufferSubData(_target, offset, data.length, cast(const(GLvoid*))data.ptr);
    }

    final @property GLuint name() const { return _name; }
    final @property GLenum target() const { return _target; }
}


class GlVertexBuffer : GlBuffer {

    this(in Factory.BufferCreationDesc desc, const(ubyte)[] data) {
        assert(desc.role == BufferRole.vertex);
        super(desc, data);
    }

    final void bindWithAttrib(in VertexAttribDesc attrib, bool instanceRateSupport) {
        import gfx.pipeline.program : BaseType;

        assert(!attrib.field.type.isMatrix);
        immutable glType = baseTypeToGl(attrib.field.type.baseType);
        immutable count = attrib.field.type.dim1;

        bind();
        auto offset = cast(const(GLvoid)*)attrib.field.offset;
        immutable stride = cast(GLint)attrib.field.stride;
        switch (attrib.field.type.baseType) {
            case BaseType.i32:
            case BaseType.u32:
                glVertexAttribIPointer(attrib.slot, count, glType, stride, offset);
                break;
            case BaseType.f32:
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
