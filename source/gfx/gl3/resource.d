module gfx.gl3.resource;

package:

import gfx.graal.buffer : Buffer;
import gfx.graal.image : Image, ImageView, Sampler, SamplerInfo;
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
    private GLuint _name;
    private GLbitfield _accessFlags;
    private Rc!GlDeviceMemory _mem;

    this(GlShare share, in BufferUsage usage, in size_t size) {
        import gfx.gl3.conv : toGl;
        gl = share.gl;
        exts = share.exts;
        _usage = usage;
        _size = size;
        gl.GenBuffers(1, &_name);
    }

    override void dispose() {
        gl.DeleteBuffers(1, &_name);
        _name = 0;
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

        gl.BindBuffer(GL_ARRAY_BUFFER, _name);

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

        gl.BindBuffer(GL_ARRAY_BUFFER, _name);
        auto ptr = gl.MapBufferRange(GL_ARRAY_BUFFER, cast(GLintptr)offset, cast(GLsizeiptr)size, flags);
        gl.BindBuffer(GL_ARRAY_BUFFER, 0);
        return ptr;
    }

    private void unmap() {
        gl.BindBuffer(GL_ARRAY_BUFFER, _name);
        gl.UnmapBuffer(GL_ARRAY_BUFFER);
        gl.BindBuffer(GL_ARRAY_BUFFER, 0);
    }
}

private enum GlImgType {
    tex, renderBuf
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

    private ImageType _type;
    private ImageDims _dims;
    private Format _format;
    private ImageUsage _usage;
    private ImageTiling _tiling;
    private uint _samples;
    private uint _levels;

    private GlImgType _glType;
    private GLuint _name;
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
            _glType = GlImgType.renderBuf;
            enforce(
                _type == ImageType.d2,
                "Gfx-GL3: ImageUsage indicates the use of a RenderBuffer, which only supports 2D images"
            );
            gl.GenRenderbuffers(1, &_name);
        }
        else {
            _glType = GlImgType.tex;
            gl.GenTextures(1, &_name);
        }

        import gfx.gl3.conv : toGlImgFmt, toGlTexTarget;
        _glFormat = toGlImgFmt(format);
        _glTexTarget = toGlTexTarget(type, samples > 1);
    }

    override void dispose() {
        final switch(_glType) {
        case GlImgType.tex:
            gl.DeleteTextures(1, &_name);
            break;
        case GlImgType.renderBuf:
            gl.DeleteRenderbuffers(1, &_name);
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

    ImageView createView(ImageType viewType, ImageSubresourceRange isr, Swizzle swizzle)
    {
        return new GlImageView(this, viewType, isr, swizzle);
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
        case GlImgType.tex:
            gl.BindTexture(_glTexTarget, _name);
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
                        gl.TexStorage2DMultisample(
                            _glTexTarget, _samples, _glFormat, _dims.width, _dims.height, GL_TRUE
                        );
                    break;
                case ImageType.d2Array:
                    if (_samples <= 1)
                        gl.TexStorage3D(_glTexTarget, _levels, _glFormat, _dims.width, _dims.height, _dims.layers);
                    else
                        gl.TexStorage3DMultisample(
                            _glTexTarget, _samples, _glFormat, _dims.width, _dims.height, _dims.layers, GL_TRUE
                        );
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
                            gl.TexImage3DMultisample(
                                _glTexTarget, _samples, _glFormat, width, height, _dims.layers, GL_TRUE
                            );
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

        case GlImgType.renderBuf:
            gl.BindRenderbuffer(GL_RENDERBUFFER, _name);
            if (_samples > 1) {
                gl.RenderbufferStorageMultisample(
                    GL_RENDERBUFFER, _samples, _glFormat, _dims.width, _dims.height
                );
            }
            else {
                gl.RenderbufferStorage(GL_RENDERBUFFER, _glFormat, _dims.width, _dims.height);
            }
            gl.BindRenderbuffer(GL_RENDERBUFFER, 0);
            break;
        }
    }
}

final class GlImageView : ImageView
{
    import gfx.bindings.opengl.gl : Gl, GLenum, GLuint;
    import gfx.core.rc : atomicRcCode, Rc;
    import gfx.gl3 : GlExts;
    import gfx.graal.image : ImageBase, ImageDims, ImageSubresourceRange,
                             ImageType, Swizzle;

    mixin(atomicRcCode);

    private Gl gl;
    private GlExts exts;
    private Rc!GlImage img;
    private ImageDims imgDims;
    private ImageType type;
    private ImageSubresourceRange isr;
    private Swizzle swzl;

    private GlImgType glType;
    private GLuint name;

    this(GlImage img, ImageType type, ImageSubresourceRange isr, Swizzle swizzle) {
        this.img = img;
        this.gl = img.gl;
        this.exts = img.exts;
        this.imgDims = img.dims;
        this.type = type;
        this.isr = isr;
        this.swzl = swizzle;

        glType = img._glType;
        name = img._name;
    }

    override void dispose() {
        img.unload();
    }

    override @property ImageBase image() {
        return img.obj;
    }
    override @property ImageSubresourceRange subresourceRange() {
        return isr;
    }
    override @property Swizzle swizzle() {
        return swzl;
    }

    void attachToFbo(GLenum target, ref uint colorNum) {
        import gfx.bindings.opengl.gl : GLint,
                GL_RENDERBUFFER, GL_COLOR_ATTACHMENT0,
                GL_DEPTH_ATTACHMENT, GL_STENCIL_ATTACHMENT,
                GL_DEPTH_STENCIL_ATTACHMENT, GL_TEXTURE_CUBE_MAP_POSITIVE_X,
                GL_TEXTURE_1D, GL_TEXTURE_2D, GL_TEXTURE_3D;
        import gfx.graal.image : ImageAspect;

        GLenum glAttachment;
        final switch (isr.aspect) {
        case ImageAspect.color:
            glAttachment = GL_COLOR_ATTACHMENT0 + colorNum++;
            break;
        case ImageAspect.depth:
            glAttachment = GL_DEPTH_ATTACHMENT;
            break;
        case ImageAspect.stencil:
            glAttachment = GL_STENCIL_ATTACHMENT;
            break;
        case ImageAspect.depthStencil:
            glAttachment = GL_DEPTH_STENCIL_ATTACHMENT;
            break;
        }

        final switch(glType) {
        case GlImgType.tex:
            if (imgDims.layers > 1 && isr.layers == 1) {
                gl.FramebufferTextureLayer(
                    target, glAttachment, name, cast(GLint)isr.firstLevel, cast(GLint)isr.firstLayer
                );
            }
            else {
                final switch (type) {
                case ImageType.d1:
                case ImageType.d1Array:
                    gl.FramebufferTexture1D(
                        target, glAttachment, GL_TEXTURE_1D, name, cast(GLint)isr.firstLevel
                    );
                    break;
                case ImageType.d2:
                case ImageType.d2Array:
                    gl.FramebufferTexture2D(
                        target, glAttachment, GL_TEXTURE_2D, name, cast(GLint)isr.firstLevel
                    );
                    break;
                case ImageType.d3:
                    gl.FramebufferTexture3D(
                        target, glAttachment, GL_TEXTURE_3D, name,
                        cast(GLint)isr.firstLevel, cast(GLint)isr.firstLayer
                    );
                    break;
                case ImageType.cube:
                case ImageType.cubeArray:
                    const layer = GL_TEXTURE_CUBE_MAP_POSITIVE_X+cast(GLenum)isr.firstLayer;
                    gl.FramebufferTexture2D(
                        target, glAttachment, layer, name, cast(GLint)isr.firstLevel
                    );
                    break;
                }
            }
            break;
        case GlImgType.renderBuf:
            gl.FramebufferRenderbuffer(target, glAttachment, GL_RENDERBUFFER, name);
            break;
        }
    }
}


final class GlSampler : Sampler
{
    import gfx.bindings.opengl.gl : Gl, GLenum, GLint, GLfloat, GLuint;
    import gfx.core.rc : atomicRcCode;
    import gfx.graal.image : BorderColor, isInt, SamplerInfo;
    import gfx.graal.pipeline : CompareOp;
    import gfx.gl3 : GlExts, GlShare;
    import gfx.gl3.conv : toGl, toGlMag, toGlMin;

    mixin(atomicRcCode);

    private Gl gl;
    private GlExts exts;
    private SamplerInfo _info;
    private GLuint _name;

    this(GlShare share, in SamplerInfo info)
    {
        gl = share.gl;
        exts = share.exts;
        _info = info;

        if (exts.samplerObject) {
            gl.GenSamplers(1, &_name);

            setupSampler!(
                (GLenum pname, GLint param) { gl.SamplerParameteri(_name, pname, param); },
                (GLenum pname, GLfloat param) { gl.SamplerParameterf(_name, pname, param); },
                (GLenum pname, const(GLint)* param) { gl.SamplerParameteriv(_name, pname, param); },
                (GLenum pname, const(GLfloat)* param) { gl.SamplerParameterfv(_name, pname, param); },
            )(info);
        }
    }

    override void dispose() {
        if (exts.samplerObject) {
            gl.DeleteSamplers(1, &_name);
        }
    }

    void bind (GLuint target, GLuint unit) {
        if (exts.samplerObject) {
            gl.BindSampler(unit, _name);
        }
        else {
            setupSampler!(
                (GLenum pname, GLint param) { gl.TexParameteri(target, pname, param); },
                (GLenum pname, GLfloat param) { gl.TexParameterf(target, pname, param); },
                (GLenum pname, const(GLint)* param) { gl.TexParameteriv(target, pname, param); },
                (GLenum pname, const(GLfloat)* param) { gl.TexParameterfv(target, pname, param); },
            )(_info);
        }
    }
}

private void setupSampler(alias fi, alias ff, alias fiv, alias ffv)(in SamplerInfo info)
{
    import gfx.bindings.opengl.gl : GL_TEXTURE_MAX_ANISOTROPY,
                                    GL_TEXTURE_MIN_FILTER,
                                    GL_TEXTURE_MAG_FILTER,
                                    GL_TEXTURE_WRAP_S,
                                    GL_TEXTURE_WRAP_T,
                                    GL_TEXTURE_WRAP_R,
                                    GL_TEXTURE_LOD_BIAS,
                                    GL_TEXTURE_MAX_LOD, GL_TEXTURE_MIN_LOD,
                                    GL_TEXTURE_BORDER_COLOR,
                                    GL_TEXTURE_COMPARE_MODE,
                                    GL_TEXTURE_COMPARE_FUNC,
                                    GL_COMPARE_REF_TO_TEXTURE, GL_NONE;
    import gfx.gl3.conv : toGl, toGlMin, toGlMag;
    import gfx.graal.image : BorderColor, isInt;
    import gfx.graal.pipeline : CompareOp;

    import std.algorithm : each;
    info.anisotropy.save.each!(m => ff(GL_TEXTURE_MAX_ANISOTROPY, m));

    const min = toGlMin(info.minFilter, info.mipmapFilter);
    const mag = toGlMag(info.magFilter);
    fi(GL_TEXTURE_MIN_FILTER, min);
    fi(GL_TEXTURE_MAG_FILTER, mag);

    fi(GL_TEXTURE_WRAP_S, toGl(info.wrapMode[0]));
    fi(GL_TEXTURE_WRAP_T, toGl(info.wrapMode[1]));
    fi(GL_TEXTURE_WRAP_R, toGl(info.wrapMode[2]));

    import std.math : isNaN;
    if (!info.lodBias.isNaN) {
        ff(GL_TEXTURE_LOD_BIAS, info.lodBias);
    }
    if (!info.lodRange[0].isNaN) {
        ff(GL_TEXTURE_MIN_LOD, info.lodRange[0]);
        ff(GL_TEXTURE_MAX_LOD, info.lodRange[1]);
    }

    import gfx.core.typecons : ifNone, ifSome;
    info.compare.save.ifSome!((CompareOp op) {
        fi(GL_TEXTURE_COMPARE_MODE, GL_COMPARE_REF_TO_TEXTURE);
        fi(GL_TEXTURE_COMPARE_FUNC, toGl(op));
    }).ifNone!(() {
        fi(GL_TEXTURE_COMPARE_MODE, GL_NONE);
    });

    if (info.borderColor.isInt) {
        int[4] color;
        switch (info.borderColor) {
        case BorderColor.intTransparent:
            color = [ 0, 0, 0, 0];
            break;
        case BorderColor.intBlack:
            color = [ 0, 0, 0, int.max ];
            break;
        case BorderColor.intWhite:
            color = [ int.max, int.max, int.max, int.max ];
            break;
        default: break;
        }
        fiv(GL_TEXTURE_BORDER_COLOR, &color[0]);
    }
    else {
        float[4] color;
        switch (info.borderColor) {
        case BorderColor.intTransparent:
            color = [ 0f, 0f, 0f, 0f];
            break;
        case BorderColor.intBlack:
            color = [ 0f, 0f, 0f, 1f ];
            break;
        case BorderColor.intWhite:
            color = [ 1f, 1f, 1f, 1f ];
            break;
        default: break;
        }
        ffv(GL_TEXTURE_BORDER_COLOR, &color[0]);
    }
}
