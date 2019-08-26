module gfx.gl3.resource;

package:

import gfx.bindings.opengl.gl : Gl, GLenum, GLuint;
import gfx.graal.buffer : Buffer;
import gfx.graal.device : Device;
import gfx.graal.image : Image, ImageView, Sampler, SamplerInfo;
import gfx.graal.memory : DeviceMemory;

final class GlDeviceMemory : DeviceMemory
{
    import gfx.core.rc : atomicRcCode, Rc;
    import gfx.graal.memory : MemProps;

    mixin(atomicRcCode);

    private Rc!Device _dev;
    private uint _typeIndex;
    private MemProps _props;
    private size_t _size;
    private GlBuffer _buffer;


    this (Device dev, in uint typeIndex, in MemProps props, in size_t size) {
        _dev = dev;
        _typeIndex = typeIndex;
        _props = props;
        _size = size;
    }

    override void dispose() {
        _dev.unload();
    }

    override @property Device device() {
        return _dev;
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

    override void* mapRaw(in size_t offset, in size_t size) {
        import std.exception : enforce;
        enforce(_buffer, "GL backend does not support mapping without bound buffer");
        return _buffer.map(offset, size);
    }

    override void unmapRaw() {
        import std.exception : enforce;
        enforce(_buffer, "GL backend does not support mapping without bound buffer");
        _buffer.unmap();
    }
}


final class GlBuffer : Buffer
{
    import gfx.bindings.opengl.gl;
    import gfx.core.rc : atomicRcCode, Rc;
    import gfx.gl3 : GlInfo, GlShare;
    import gfx.graal.buffer : BufferUsage, TexelBufferView;
    import gfx.graal.format : Format;
    import gfx.graal.memory : DeviceMemory, MemoryRequirements;

    mixin(atomicRcCode);

    private Rc!Device _dev;
    private GlInfo glInfo;
    private Gl gl;
    private BufferUsage _usage;
    private size_t _size;
    private GLuint _name;
    private GLbitfield _accessFlags;
    private Rc!GlDeviceMemory _mem;

    this(Device dev, GlShare share, in BufferUsage usage, in size_t size) {
        import gfx.gl3.conv : toGl;
        _dev = dev;
        gl = share.gl;
        glInfo = share.info;
        _usage = usage;
        _size = size;
        gl.GenBuffers(1, &_name);

        import gfx.gl3.error : glCheck;
        glCheck(gl, "generating buffer");
    }

    override void dispose() {
        gl.DeleteBuffers(1, &_name);
        _name = 0;
        _mem.unload();
        _dev.unload();
    }

    override @property Device device() {
        return _dev;
    }

    @property GLuint name() const {
        return _name;
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
        import gfx.gl3.error : glCheck;
        _mem = cast(GlDeviceMemory)mem;
        _mem._buffer = this;

        const props = mem.props;

        gl.BindBuffer(GL_ARRAY_BUFFER, _name);

        if (glInfo.bufferStorage) {
            GLbitfield flags = 0;
            if (props.hostVisible) flags |= (GL_MAP_READ_BIT | GL_MAP_WRITE_BIT);
            // if (props.hostCoherent) flags |= GL_MAP_COHERENT_BIT;
            gl.BufferStorage(GL_ARRAY_BUFFER, cast(GLsizeiptr)_size, null, flags);
            glCheck(gl, "buffer storage");
        }
        else {
            const glUsage = GL_STATIC_DRAW; //?
            gl.BufferData(GL_ARRAY_BUFFER, cast(GLsizeiptr)_size, null, glUsage);
            glCheck(gl, "buffer data");
        }


        gl.BindBuffer(GL_ARRAY_BUFFER, 0);
    }

    override @property DeviceMemory boundMemory() {
        return _mem.obj;
    }

    override TexelBufferView createTexelView(Format format, size_t offset, size_t size) {
        assert(false, "not implemented");
    }

    private void* map(in size_t offset, in size_t size) {
        import gfx.gl3.error : glCheck;
        const props = _mem.props;

        GLbitfield flags = 0;
        if (props.hostVisible) flags |= (GL_MAP_READ_BIT | GL_MAP_WRITE_BIT);
        // if (props.hostCoherent) flags |= GL_MAP_COHERENT_BIT;
        // else flags |= GL_MAP_FLUSH_EXPLICIT_BIT;

        gl.BindBuffer(GL_ARRAY_BUFFER, _name);
        auto ptr = gl.MapBufferRange(GL_ARRAY_BUFFER, cast(GLintptr)offset, cast(GLsizeiptr)size, flags);
        glCheck(gl, "buffer map");
        gl.BindBuffer(GL_ARRAY_BUFFER, 0);

        return ptr;
    }

    private void unmap() {
        import gfx.gl3.error : glCheck;
        gl.BindBuffer(GL_ARRAY_BUFFER, _name);
        gl.UnmapBuffer(GL_ARRAY_BUFFER);
        glCheck(gl, "buffer unmap");
        gl.BindBuffer(GL_ARRAY_BUFFER, 0);
    }
}

enum GlImgType {
    tex, renderBuf
}

final class GlImage : Image
{
    import gfx.bindings.opengl.gl : Gl, GLenum, GLuint;
    import gfx.core.rc : atomicRcCode, Rc;
    import gfx.graal.cmd : BufferImageCopy;
    import gfx.graal.format : Format, NumFormat;
    import gfx.graal.image;
    import gfx.graal.memory : MemoryRequirements;
    import gfx.gl3 : GlInfo, GlShare;

    mixin(atomicRcCode);

    private Rc!Device _dev;
    private ImageInfo _info;
    private NumFormat _numFormat;

    private GlImgType _glType;
    private GLuint _name;
    private GLenum _glTexTarget;
    private GLenum _glFormat;
    private Gl gl;
    private GlInfo glInfo;
    private Rc!GlDeviceMemory _mem;

    this(Device dev, GlShare share, ImageInfo info)
    {
        import gfx.graal.format : formatDesc;
        import std.exception : enforce;
        _dev = dev;
        _info = info;
        _numFormat = formatDesc(info.format).numFormat;

        gl = share.gl;
        glInfo = share.info;

        const notRB = ~(ImageUsage.colorAttachment | ImageUsage.depthStencilAttachment);
        if ((info.usage & notRB) == ImageUsage.none && info.tiling == ImageTiling.optimal) {
            _glType = GlImgType.renderBuf;
            enforce(
                _info.type == ImageType.d2,
                "Gfx-GL3: ImageUsage indicates the use of a RenderBuffer, which only supports 2D images"
            );
            gl.GenRenderbuffers(1, &_name);
        }
        else {
            _glType = GlImgType.tex;
            gl.GenTextures(1, &_name);
        }

        import gfx.gl3.conv : toGlImgFmt, toGlTexTarget;
        _glFormat = toGlImgFmt(_info.format);
        _glTexTarget = toGlTexTarget(_info.type, _info.samples > 1);
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
        _dev.unload();
    }

    override @property Device device() {
        return _dev;
    }

    @property GLuint name() {
        return _name;
    }

    @property GLenum texTarget() {
        return _glTexTarget;
    }

    @property GlImgType glType() {
        return _glType;
    }

    @property NumFormat numFormat() {
        return _numFormat;
    }

    override @property ImageInfo info() {
        return _info;
    }

    override ImageView createView(ImageType viewType, ImageSubresourceRange isr, Swizzle swizzle)
    {
        return new GlImageView(this, viewType, isr, swizzle);
    }

    override @property MemoryRequirements memoryRequirements() {
        import gfx.graal.format : formatDesc, totalBits;
        import gfx.graal.memory : MemProps;

        const fd = formatDesc(_info.format);

        MemoryRequirements mr;
        mr.alignment = 4;
        mr.size = _info.dims.width * _info.dims.height * _info.dims.depth *
                  _info.layers * fd.surfaceType.totalBits / 8;
        mr.memTypeMask = 1;
        return mr;
    }

    override void bindMemory(DeviceMemory mem, in size_t offset)
    {
        import gfx.bindings.opengl.gl : GL_RENDERBUFFER, GL_TRUE, GLsizei;

        _mem = cast(GlDeviceMemory)mem; // ignored

        final switch(_glType) {
        case GlImgType.tex:
            gl.BindTexture(_glTexTarget, _name);
            if (glInfo.textureStorage || (_info.samples > 1 && glInfo.textureStorageMS)) {
                final switch (_info.type) {
                case ImageType.d1:
                    gl.TexStorage1D(_glTexTarget, _info.levels, _glFormat, _info.dims.width);
                    break;
                case ImageType.d1Array:
                    gl.TexStorage2D(_glTexTarget, _info.levels, _glFormat, _info.dims.width, _info.layers);
                    break;
                case ImageType.d2:
                    if (_info.samples <= 1)
                        gl.TexStorage2D(_glTexTarget, _info.levels, _glFormat, _info.dims.width, _info.dims.height);
                    else
                        gl.TexStorage2DMultisample(
                            _glTexTarget, _info.samples, _glFormat, _info.dims.width, _info.dims.height, GL_TRUE
                        );
                    break;
                case ImageType.d2Array:
                    if (_info.samples <= 1)
                        gl.TexStorage3D(_glTexTarget, _info.levels, _glFormat, _info.dims.width, _info.dims.height, _info.layers);
                    else
                        gl.TexStorage3DMultisample(
                            _glTexTarget, _info.samples, _glFormat, _info.dims.width, _info.dims.height, _info.layers, GL_TRUE
                        );
                    break;
                case ImageType.d3:
                    gl.TexStorage3D(_glTexTarget, _info.levels, _glFormat, _info.dims.width, _info.dims.height, _info.dims.depth);
                    break;
                case ImageType.cube:
                    gl.TexStorage2D(_glTexTarget, _info.levels, _glFormat, _info.dims.width, _info.dims.height);
                    break;
                case ImageType.cubeArray:
                    gl.TexStorage3D(_glTexTarget, _info.levels, _glFormat, _info.dims.width, _info.dims.height, _info.layers*6);
                    break;
                }
            }
            else {

                GLsizei width = _info.dims.width;
                GLsizei height = _info.dims.height;
                GLsizei depth = _info.dims.depth;

                foreach (l; 0.._info.levels) {

                    final switch (_info.type) {
                    case ImageType.d1:
                        gl.TexImage1D(_glTexTarget, l, _glFormat, width, 0, 0, 0, null);
                        break;
                    case ImageType.d1Array:
                        gl.TexImage2D(_glTexTarget, l, _glFormat, width, _info.layers, 0, 0, 0, null);
                        break;
                    case ImageType.d2:
                        if (_info.samples <= 1)
                            gl.TexImage2D(_glTexTarget, l, _glFormat, width, height, 0, 0, 0, null);
                        else
                            gl.TexImage2DMultisample(_glTexTarget, _info.samples, _glFormat, width, height, GL_TRUE);
                        break;
                    case ImageType.d2Array:
                        if (_info.samples <= 1)
                            gl.TexImage3D(_glTexTarget, l, _glFormat, width, height, _info.layers, 0, 0, 0, null);
                        else
                            gl.TexImage3DMultisample(
                                _glTexTarget, _info.samples, _glFormat, width, height, _info.layers, GL_TRUE
                            );
                        break;
                    case ImageType.d3:
                        gl.TexImage3D(_glTexTarget, l, _glFormat, width, height, depth, 0, 0, 0, null);
                        break;
                    case ImageType.cube:
                        gl.TexImage2D(_glTexTarget, l, _glFormat, width, height, 0, 0, 0, null);
                        break;
                    case ImageType.cubeArray:
                        gl.TexImage3D(_glTexTarget, l, _glFormat, width, height, _info.layers*6, 0, 0, 0, null);
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
            if (_info.samples > 1) {
                gl.RenderbufferStorageMultisample(
                    GL_RENDERBUFFER, _info.samples, _glFormat, _info.dims.width, _info.dims.height
                );
            }
            else {
                gl.RenderbufferStorage(GL_RENDERBUFFER, _glFormat, _info.dims.width, _info.dims.height);
            }
            gl.BindRenderbuffer(GL_RENDERBUFFER, 0);
            break;
        }

        import gfx.gl3.error : glCheck;
        glCheck(gl, "bind image memory");
    }

    override @property DeviceMemory boundMemory() {
        return _mem.obj;
    }

    void texSubImage(BufferImageCopy region) {
        import gfx.gl3.conv : toSubImgFmt, toSubImgType;
        gl.TexSubImage2D(
            _glTexTarget, region.imageLayers.mipLevel, region.offset[0],
            region.offset[1], region.extent[0], region.extent[1], toSubImgFmt(_info.format),
            toSubImgType(_info.format), null
        );
    }
}

final class GlImageView : ImageView
{
    import gfx.core.rc : atomicRcCode, Rc;
    import gfx.gl3 : GlInfo;
    import gfx.graal.image : ImageBase, ImageDims, ImageSubresourceRange,
                             ImageType, Swizzle;

    mixin(atomicRcCode);

    private Gl gl;
    private GlInfo glInfo;
    private Rc!GlImage img;
    private ImageDims imgDims;
    private ImageType type;
    private uint layers;
    private ImageSubresourceRange isr;
    private Swizzle swzl;

    private GlImgType glType;
    package GLuint name;
    package GLuint target;

    this(GlImage img, ImageType type, ImageSubresourceRange isr, Swizzle swizzle) {
        this.img = img;
        this.gl = img.gl;
        this.glInfo = img.glInfo;
        this.imgDims = img.info.dims;
        this.type = type;
        this.layers = img.info.layers;
        this.isr = isr;
        this.swzl = swizzle;

        glType = img._glType;
        name = img._name;
        if (glType == GlImgType.tex) {
            import gfx.gl3.conv : toGlTexTarget;
            target = toGlTexTarget(type, img._info.samples > 1);
        }
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
        import std.format : format;

        GLenum glAttachment;
        switch (isr.aspect) {
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
        default:
            assert(false, format("unsupported image aspect: %s", isr.aspect));
        }

        final switch(glType) {
        case GlImgType.tex:
            if (layers > 1 && isr.layers == 1) {
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
    import gfx.core.rc : atomicRcCode, Rc;
    import gfx.graal.image : BorderColor, isInt, SamplerInfo;
    import gfx.graal.pipeline : CompareOp;
    import gfx.gl3 : GlInfo, GlShare;
    import gfx.gl3.conv : toGl, toGlMag, toGlMin;

    mixin(atomicRcCode);

    private Rc!Device _dev;
    private Gl gl;
    private GlInfo glInfo;
    private SamplerInfo _info;
    private GLuint _name;

    this(Device dev, GlShare share, in SamplerInfo info)
    {
        _dev = dev;
        gl = share.gl;
        glInfo = share.info;
        _info = info;

        if (glInfo.samplerObject) {
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
        if (glInfo.samplerObject) {
            gl.DeleteSamplers(1, &_name);
        }
        _dev.unload();
    }

    override @property Device device() {
        return _dev;
    }

    void bind (GLuint target, GLuint unit) {
        if (glInfo.samplerObject) {
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

private void setupSampler(alias fi, alias ff, alias fiv, alias ffv)(in SamplerInfo glInfo)
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
    glInfo.anisotropy.save.each!(m => ff(GL_TEXTURE_MAX_ANISOTROPY, m));

    const min = toGlMin(glInfo.minFilter, glInfo.mipmapFilter);
    const mag = toGlMag(glInfo.magFilter);
    fi(GL_TEXTURE_MIN_FILTER, min);
    fi(GL_TEXTURE_MAG_FILTER, mag);

    fi(GL_TEXTURE_WRAP_S, toGl(glInfo.wrapMode[0]));
    fi(GL_TEXTURE_WRAP_T, toGl(glInfo.wrapMode[1]));
    fi(GL_TEXTURE_WRAP_R, toGl(glInfo.wrapMode[2]));

    import std.math : isNaN;
    if (!glInfo.lodBias.isNaN) {
        ff(GL_TEXTURE_LOD_BIAS, glInfo.lodBias);
    }
    if (!glInfo.lodRange[0].isNaN) {
        ff(GL_TEXTURE_MIN_LOD, glInfo.lodRange[0]);
        ff(GL_TEXTURE_MAX_LOD, glInfo.lodRange[1]);
    }

    import gfx.core.typecons : ifNone, ifSome;
    glInfo.compare.save.ifSome!((CompareOp op) {
        fi(GL_TEXTURE_COMPARE_MODE, GL_COMPARE_REF_TO_TEXTURE);
        fi(GL_TEXTURE_COMPARE_FUNC, toGl(op));
    }).ifNone!(() {
        fi(GL_TEXTURE_COMPARE_MODE, GL_NONE);
    });

    if (glInfo.borderColor.isInt) {
        int[4] color;
        switch (glInfo.borderColor) {
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
        switch (glInfo.borderColor) {
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
