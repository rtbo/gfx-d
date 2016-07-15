module gfx.backend.gl3.buffer;

import gfx.core.rc : rcCode;
import gfx.core.context : Context;
import gfx.core.buffer : BufferRes, BufferRole, BufferUsage, BufferSliceInfo;

import derelict.opengl3.gl3;

GLenum roleToGlTarget(in BufferRole role) {
    final switch(role) {
        case BufferRole.Vertex: return GL_ARRAY_BUFFER;
        case BufferRole.Index: return GL_ELEMENT_ARRAY_BUFFER;
        case BufferRole.Constant: return GL_UNIFORM_BUFFER;
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

class GlBuffer : BufferRes {
    mixin(rcCode);

    GLuint _name;
    GLenum _target;
    GLenum _usage;
    GLsizeiptr _size;


    this(in Context.BufferCreationDesc desc, const(ubyte)[] data) {
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
}