module gfx.gl3.resource;

package:

import gfx.graal.buffer : Buffer;
import gfx.graal.image : Image;
import gfx.graal.memory : DeviceMemory;

final class GlDeviceMemory : DeviceMemory
{
    import gfx.core.rc : atomicRcCode;
    import gfx.graal.memory : MemProps;

    mixin(atomicRcCode);

    private uint _typeIndex;
    private MemProps _props;
    private size_t _size;
    private GlBuffer _buffer;


    this (in uint typeIndex, in MemProps props, in size_t size) {
        _typeIndex = typeIndex;
        _props = props;
        _size = size;
    }

    override void dispose() {
    }

    override @property uint typeIndex() {
        return _typeIndex;
    }
    override @property MemProps props() {
        return _props;
    }
    override @property size_t size() {
        return _size;
    }

    override void* map(in size_t offset, in size_t size) {
        import std.exception : enforce;
        enforce(_buffer, "GL backend does not support mapping without bound buffer");
        return _buffer.map(offset, size);
    }

    override void unmap() {
        import std.exception : enforce;
        enforce(_buffer, "GL backend does not support mapping without bound buffer");
        _buffer.unmap();
    }
}


final class GlBuffer : Buffer
{
    import gfx.bindings.opengl.gl;
    import gfx.core.rc : atomicRcCode, Rc;
    import gfx.gl3 : GlExts, GlShare;
    import gfx.gl3.context : GlContext;
    import gfx.graal.buffer : BufferUsage, BufferView;
    import gfx.graal.format : Format;
    import gfx.graal.memory : DeviceMemory, MemoryRequirements;

    mixin(atomicRcCode);

    private GlExts exts;
    private Gl gl;
    private BufferUsage _usage;
    private size_t _size;
    private GLuint _handle;
    private GLbitfield _accessFlags;
    private Rc!GlDeviceMemory _mem;

    this(GlShare share, in BufferUsage usage, in size_t size) {
        import gfx.gl3.conv : toGl;
        gl = share.gl;
        exts = share.exts;
        _usage = usage;
        _size = size;
        gl.GenBuffers(1, &_handle);
    }

    override void dispose() {
        gl.DeleteBuffers(1, &_handle);
        _handle = 0;
        _mem.unload();
    }

    override @property size_t size() {
        return _size;
    }
    override @property BufferUsage usage() {
        return _usage;
    }
    override @property MemoryRequirements memoryRequirements() {
        import gfx.graal.memory : MemProps;
        MemoryRequirements mr;
        mr.alignment = 4;
        mr.size = _size;
        mr.memTypeMask = 1;
        return mr;
    }

    override void bindMemory(DeviceMemory mem, in size_t offset) {
        _mem = cast(GlDeviceMemory)mem;
        _mem._buffer = this;

        const props = mem.props;

        gl.BindBuffer(GL_ARRAY_BUFFER, _handle);

        if (exts.bufferStorage) {
            GLbitfield flags = 0;
            if (props.hostVisible) flags |= (GL_MAP_READ_BIT | GL_MAP_WRITE_BIT);
            if (props.hostCoherent) flags |= GL_MAP_COHERENT_BIT;
            gl.BufferStorage(GL_ARRAY_BUFFER, cast(GLsizeiptr)_size, null, flags);
        }
        else {
            const glUsage = GL_STATIC_DRAW; //?
            gl.BufferData(GL_ARRAY_BUFFER, cast(GLsizeiptr)_size, null, glUsage);
        }

        gl.BindBuffer(GL_ARRAY_BUFFER, 0);
    }

    override @property DeviceMemory boundMemory() {
        return _mem.obj;
    }

    override BufferView createView(Format format, size_t offset, size_t size) {
        return null;
    }

    private void* map(in size_t offset, in size_t size) {
        const props = _mem.props;

        GLbitfield flags = GL_MAP_INVALIDATE_RANGE_BIT;
        if (props.hostVisible) flags |= (GL_MAP_READ_BIT | GL_MAP_WRITE_BIT);
        if (props.hostCoherent) flags |= GL_MAP_COHERENT_BIT;
        else flags |= GL_MAP_FLUSH_EXPLICIT_BIT;

        gl.BindBuffer(GL_ARRAY_BUFFER, _handle);
        auto ptr = gl.MapBufferRange(GL_ARRAY_BUFFER, cast(GLintptr)offset, cast(GLsizeiptr)size, flags);
        gl.BindBuffer(GL_ARRAY_BUFFER, 0);
        return ptr;
    }

    private void unmap() {
        gl.BindBuffer(GL_ARRAY_BUFFER, _handle);
        gl.UnmapBuffer(GL_ARRAY_BUFFER);
        gl.BindBuffer(GL_ARRAY_BUFFER, 0);
    }
}

final class GlImage : Image
{
    import gfx.bindings.opengl.gl : Gl, GLenum, GLuint;
    import gfx.core.rc : atomicRcCode, Rc;
    import gfx.graal.format : Format;
    import gfx.graal.image;
    import gfx.graal.memory : MemoryRequirements;
    import gfx.gl3 : GlExts, GlShare;

    mixin(atomicRcCode);

    private enum GlType {
        tex, renderBuf
    }

    private ImageType _type;
    private ImageDims _dims;
    private Format _format;
    private ImageUsage _usage;
    private ImageTiling _tiling;
    private uint _samples;
    private uint _levels;

    private GlType _glType;
    private GLuint _handle;
    private GLenum _glTexTarget;
    private GLenum _glFormat;
    private Gl gl;
    private GlExts exts;
    private Rc!GlDeviceMemory _mem;

    this(GlShare share, ImageType type, ImageDims dims, Format format, ImageUsage usage,
            ImageTiling tiling, uint samples, uint levels)
    {
        import std.exception : enforce;
        _type = type;
        _dims = dims;
        _format = format;
        _usage = usage;
        _tiling = tiling;
        _samples = samples;
        _levels = levels;

        gl = share.gl;
        exts = share.exts;

        const notRB = ~(ImageUsage.colorAttachment | ImageUsage.depthStencilAttachment);
        if ((usage & notRB) == ImageUsage.none && tiling == ImageTiling.optimal) {
            _glType = GlType.renderBuf;
            enforce(_type == ImageType.d2, "Gfx-GL3: ImageUsage indicates the use of a RenderBuffer, which only supports 2D images");
            gl.GenRenderbuffers(1, &_handle);
        }
        else {
            _glType = GlType.tex;
            gl.GenTextures(1, &_handle);
        }

        import gfx.gl3.conv : toGlImgFmt, toGlTexTarget;
        _glFormat = toGlImgFmt(format);
        _glTexTarget = toGlTexTarget(type, samples > 1);
    }

    override void dispose() {
        final switch(_glType) {
        case GlType.tex:
            gl.DeleteTextures(1, &_handle);
            break;
        case GlType.renderBuf:
            gl.DeleteRenderbuffers(1, &_handle);
            break;
        }
        _mem.unload();
    }

    override @property ImageType type() {
        return _type;
    }
    override @property Format format() {
        return _format;
    }
    override @property ImageDims dims() {
        return _dims;
    }
    override @property uint levels() {
        return _levels;
    }

    ImageView createView(ImageType viewtype, ImageSubresourceRange isr, Swizzle swizzle)
    {
        return null;
    }

    override @property MemoryRequirements memoryRequirements() {
        import gfx.graal.format : formatDesc, totalBits;
        import gfx.graal.memory : MemProps;

        const fd = formatDesc(_format);

        MemoryRequirements mr;
        mr.alignment = 4;
        mr.size = _dims.width * _dims.height * _dims.depth * _dims.layers * fd.surfaceType.totalBits / 8;
        mr.memTypeMask = 1;
        return mr;
    }

    void bindMemory(DeviceMemory mem, in size_t offset)
    {
        import gfx.bindings.opengl.gl : GL_RENDERBUFFER, GL_TRUE, GLsizei;

        _mem = cast(GlDeviceMemory)mem; // ignored

        final switch(_glType) {
        case GlType.tex:
            gl.BindTexture(_glTexTarget, _handle);
            if (exts.textureStorage) {
                final switch (_type) {
                case ImageType.d1:
                    gl.TexStorage1D(_glTexTarget, _levels, _glFormat, _dims.width);
                    break;
                case ImageType.d1Array:
                    gl.TexStorage2D(_glTexTarget, _levels, _glFormat, _dims.width, _dims.layers);
                    break;
                case ImageType.d2:
                    if (_samples <= 1)
                        gl.TexStorage2D(_glTexTarget, _levels, _glFormat, _dims.width, _dims.height);
                    else
                        gl.TexStorage2DMultisample(_glTexTarget, _samples, _glFormat, _dims.width, _dims.height, GL_TRUE);
                    break;
                case ImageType.d2Array:
                    if (_samples <= 1)
                        gl.TexStorage3D(_glTexTarget, _levels, _glFormat, _dims.width, _dims.height, _dims.layers);
                    else
                        gl.TexStorage3DMultisample(_glTexTarget, _samples, _glFormat, _dims.width, _dims.height, _dims.layers, GL_TRUE);
                    break;
                case ImageType.d3:
                    gl.TexStorage3D(_glTexTarget, _levels, _glFormat, _dims.width, _dims.height, _dims.depth);
                    break;
                case ImageType.cube:
                    gl.TexStorage2D(_glTexTarget, _levels, _glFormat, _dims.width, _dims.height);
                    break;
                case ImageType.cubeArray:
                    gl.TexStorage3D(_glTexTarget, _levels, _glFormat, _dims.width, _dims.height, _dims.layers*6);
                    break;
                }
            }
            else {

                GLsizei width = _dims.width;
                GLsizei height = _dims.height;
                GLsizei depth = _dims.depth;

                foreach (l; 0.._levels) {

                    final switch (_type) {
                    case ImageType.d1:
                        gl.TexImage1D(_glTexTarget, l, _glFormat, width, 0, 0, 0, null);
                        break;
                    case ImageType.d1Array:
                        gl.TexImage2D(_glTexTarget, l, _glFormat, width, _dims.layers, 0, 0, 0, null);
                        break;
                    case ImageType.d2:
                        if (_samples <= 1)
                            gl.TexImage2D(_glTexTarget, l, _glFormat, width, height, 0, 0, 0, null);
                        else
                            gl.TexImage2DMultisample(_glTexTarget, _samples, _glFormat, width, height, GL_TRUE);
                        break;
                    case ImageType.d2Array:
                        if (_samples <= 1)
                            gl.TexImage3D(_glTexTarget, l, _glFormat, width, height, _dims.layers, 0, 0, 0, null);
                        else
                            gl.TexImage3DMultisample(_glTexTarget, _samples, _glFormat, width, height, _dims.layers, GL_TRUE);
                        break;
                    case ImageType.d3:
                        gl.TexImage3D(_glTexTarget, l, _glFormat, width, height, depth, 0, 0, 0, null);
                        break;
                    case ImageType.cube:
                        gl.TexImage2D(_glTexTarget, l, _glFormat, width, height, 0, 0, 0, null);
                        break;
                    case ImageType.cubeArray:
                        gl.TexImage3D(_glTexTarget, l, _glFormat, width, height, _dims.layers*6, 0, 0, 0, null);
                        break;
                    }

                    if (width > 1) width /= 2;
                    if (height > 1) height /= 2;
                    if (depth > 1) depth /= 2;
                }
            }
            gl.BindTexture(_glTexTarget, 0);
            break;

        case GlType.renderBuf:
            gl.BindRenderbuffer(GL_RENDERBUFFER, _handle);
            if (_samples > 1) {
                gl.RenderbufferStorageMultisample(GL_RENDERBUFFER, _samples, _glFormat, _dims.width, _dims.height);
            }
            else {
                gl.RenderbufferStorage(GL_RENDERBUFFER, _glFormat, _dims.width, _dims.height);
            }
            gl.BindRenderbuffer(GL_RENDERBUFFER, 0);
            break;
        }
    }

}
