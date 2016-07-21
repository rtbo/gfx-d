module gfx.backend.gl3.buffer;

import gfx.core.rc : rcCode;
import gfx.core.format : ChannelType, SurfaceType;
import gfx.core.context : Context;
import gfx.core.buffer : BufferRes, BufferRole, BufferUsage, BufferSliceInfo;
import gfx.core.pso : VertexAttribDesc;

import derelict.opengl3.gl3;

import std.experimental.logger;


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


GlBuffer makeBufferImpl(in Context.BufferCreationDesc desc, const(ubyte)[] data) {
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
    @property GLenum target() const { return _target; }
}


class GlVertexBuffer : GlBuffer {

    this(in Context.BufferCreationDesc desc, const(ubyte)[] data) {
        assert(desc.role == BufferRole.Vertex);
        super(desc, data);
    }

    void bindWithAttrib(VertexAttribDesc attrib, bool instanceRateSupport) {
        void doit(int count, GLenum glType) {
            bind();
            auto offset = cast(const(GLvoid)*)attrib.field.offset;
            immutable stride = cast(GLint)attrib.field.stride;
            switch (attrib.field.format.channel) {
                case ChannelType.Int:
                case ChannelType.Uint:
                    glVertexAttribIPointer(attrib.slot, count, glType, stride, offset);
                    break;
                case ChannelType.Inorm:
                case ChannelType.Unorm:
                    glVertexAttribPointer(attrib.slot, count, glType, GL_TRUE, stride, offset);
                    break;
                case ChannelType.Float:
                    glVertexAttribPointer(attrib.slot, count, glType, GL_FALSE, stride, offset);
                    break;
                default:
                    errorf("bind vertex: unsupported channel type: %s", attrib.field.format.channel);
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
        void doit8(int count) {
            final switch(attrib.field.format.channel) {
                case ChannelType.Int:
                case ChannelType.Inorm: doit(count, GL_BYTE); break;
                case ChannelType.Uint:
                case ChannelType.Unorm: doit(count, GL_UNSIGNED_BYTE); break;
                case ChannelType.Float: doit(count, GL_ZERO); break;
                case ChannelType.Srgb:
                    error("bind vertex: unsupported Srgb channel");
            }
        }
        void doit16(int count) {
            final switch(attrib.field.format.channel) {
                case ChannelType.Int:
                case ChannelType.Inorm: doit(count, GL_SHORT); break;
                case ChannelType.Uint:
                case ChannelType.Unorm: doit(count, GL_UNSIGNED_SHORT); break;
                case ChannelType.Float: doit(count, GL_HALF_FLOAT); break;
                case ChannelType.Srgb:
                    error("bind vertex: unsupported Srgb channel");
            }
        }
        void doit32(int count) {
            final switch(attrib.field.format.channel) {
                case ChannelType.Int:
                case ChannelType.Inorm: doit(count, GL_INT); break;
                case ChannelType.Uint:
                case ChannelType.Unorm: doit(count, GL_UNSIGNED_INT); break;
                case ChannelType.Float: doit(count, GL_FLOAT); break;
                case ChannelType.Srgb:
                    error("bind vertex: unsupported Srgb channel");
            }
        }

        switch (attrib.field.format.surface) {
            case SurfaceType.R8:                doit8(1); break;
            case SurfaceType.R8_G8:             doit8(2); break;
            case SurfaceType.R8_G8_B8_A8:       doit8(4); break;
            case SurfaceType.R16:               doit16(1); break;
            case SurfaceType.R16_G16:           doit16(2); break;
            case SurfaceType.R16_G16_B16:       doit16(3); break;
            case SurfaceType.R16_G16_B16_A16:   doit16(4); break;
            case SurfaceType.R32:               doit32(1); break;
            case SurfaceType.R32_G32:           doit32(2); break;
            case SurfaceType.R32_G32_B32:       doit32(3); break;
            case SurfaceType.R32_G32_B32_A32:   doit32(4); break;
            default:
                error("bind vertex: unsupported channel type");
        }
    }
}
