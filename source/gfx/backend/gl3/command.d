module gfx.backend.gl3.command;

import gfx.backend.gl3 : GlDevice;
import gfx.backend.gl3.state : setRasterizer, bindBlend, bindBlendSlot;
import gfx.backend.gl3.buffer : GlBuffer, GlVertexBuffer;
import gfx.backend.gl3.program;
import gfx.backend.gl3.pso : GlPipelineState, OutputMerger;
import gfx.core : maxVertexAttribs, maxColorTargets, AttribMask, ColorTargetMask, Rect, Primitive;
import gfx.core.typecons : Option, some, none;
import gfx.core.draw : CommandBuffer, ClearColor, Instance;
import gfx.core.rc : Rc, rcCode;
import gfx.core.program : Program;
import gfx.core.buffer : RawBuffer, IndexType;
import gfx.core.texture : RawTexture, ImageSliceInfo;
import gfx.core.pso :   RawPipelineState, VertexBufferSet, ConstantBlockSet,
                        ResourceViewSet, SamplerSet, PixelTargetSet,
                        VertexAttribDesc, ConstantBlockDesc;
import gfx.core.state : Rasterizer, CullFace;
import gfx.core.view : RawShaderResourceView, RawRenderTargetView, RawDepthStencilView;
import gfx.core.format : ChannelType, SurfaceType;
import gfx.core.state : Comparison, Depth, Stencil, StencilOp, StencilSide;

import derelict.opengl3.gl3;

import std.experimental.logger;


GLenum primitiveToGl(in Primitive primitive) {
    final switch (primitive) {
        case Primitive.Points:          return GL_POINTS;
        case Primitive.Lines:           return GL_LINES;
        case Primitive.LineStrip:       return GL_LINE_STRIP;
        case Primitive.Triangles:       return GL_TRIANGLES;
        case Primitive.TriangleStrip:   return GL_TRIANGLE_STRIP;
    }
}

GLenum comparisonToGl(in Comparison fun) {
    final switch (fun) {
        case Comparison.Never:          return GL_NEVER;
        case Comparison.Less:           return GL_LESS;
        case Comparison.LessEqual:      return GL_LEQUAL;
        case Comparison.Equal:          return GL_EQUAL;
        case Comparison.GreaterEqual:   return GL_GEQUAL;
        case Comparison.Greater:        return GL_GREATER;
        case Comparison.NotEqual:       return GL_NOTEQUAL;
        case Comparison.Always:         return GL_ALWAYS;
    }
}

GLenum operationToGl(in StencilOp op) {
    final switch (op) {
        case StencilOp.Keep:            return GL_KEEP;
        case StencilOp.Zero:            return GL_ZERO;
        case StencilOp.Replace:         return GL_REPLACE;
        case StencilOp.IncrementClamp:  return GL_INCR;
        case StencilOp.IncrementWrap:   return GL_INCR_WRAP;
        case StencilOp.DecrementClamp:  return GL_DECR;
        case StencilOp.DecrementWrap:   return GL_DECR_WRAP;
        case StencilOp.Invert:          return GL_INVERT;
    }
}


interface Command {
    void execute(GlDevice device);
    void unload();
}


class SetRasterizerCommand : Command {
    Rasterizer rasterizer;
    this(Rasterizer rasterizer) {
        this.rasterizer = rasterizer;
    }

    final void execute(GlDevice device) {
        setRasterizer(rasterizer);
    }

    final void unload() {}
}

class SetDrawColorBuffersCommand : Command {
    ColorTargetMask mask;

    this(ColorTargetMask mask) {
        this.mask = mask;
    }

    final void execute(GlDevice device) {
        GLenum[maxColorTargets] targets;
        GLsizei count=0;
        foreach(i; 0..maxColorTargets) {
            if (mask & (1 << i)) {
                targets[count++] = cast(GLenum)(GL_COLOR_ATTACHMENT0+i);
            }
        }
        glDrawBuffers(count, &targets[0]);
    }
    final void unload() {}
}

class SetViewportCommand : Command {
    Rect rect;
    this(Rect rect) { this.rect = rect; }
    final void execute(GlDevice device) {
        glViewport(rect.x, rect.y, rect.w, rect.h);
    }
    final void unload() {}
}

class SetScissorCommand : Command {
    Option!Rect rect;
    this(Option!Rect rect) { this.rect = rect; }

    final void execute(GlDevice device) {
        if (rect.isSome) {
            auto r = rect.get();
            glEnable(GL_SCISSOR_TEST);
            glScissor(r.x, r.y, r.w, r.h);
        }
        else {
            glDisable(GL_SCISSOR_TEST);
        }
    }
    final void unload() {}
}

class SetDepthStateCommand : Command {
    Rc!RawPipelineState pso;

    this(RawPipelineState pso) {
        this.pso = pso;
    }
    final void execute(GlDevice device) {
        import gfx.core.util : unsafeCast;
        assert(pso.loaded);
        if (!pso.pinned) pso.pinResources(device);
        auto depth = unsafeCast!GlPipelineState(pso.res).output.depth;
        if (depth.isSome) {
            glEnable(GL_DEPTH_TEST);
            glDepthFunc(comparisonToGl(depth.fun));
            glDepthMask(depth.write ? GL_TRUE : GL_FALSE);
        }
        else {
            glDisable(GL_DEPTH_TEST);
        }
        unload();
    }
    final void unload() {
        pso.unload();
    }
}

class SetStencilTestCommand : Command {
    Rc!RawPipelineState pso;
    ubyte[2] stencilRef;

    this(RawPipelineState pso, ubyte[2] stencilRef) {
        this.pso = pso; this.stencilRef = stencilRef;
    }

    final void execute (GlDevice device) {
        import gfx.core.util : unsafeCast;
        assert(pso.loaded);
        if (!pso.pinned) pso.pinResources(device);
        auto stencil = unsafeCast!GlPipelineState(pso.res).output.stencil;
        if (stencil.isSome) {
            glEnable(GL_STENCIL_TEST);
            void bindSide(GLenum face, StencilSide side, ubyte refVal) {
                glStencilFuncSeparate(face, comparisonToGl(side.fun), refVal, side.maskRead);
                glStencilMaskSeparate(face, side.maskWrite);
                glStencilOpSeparate(
                    face, operationToGl(side.opFail), operationToGl(side.opDepthFail), operationToGl(side.opPass)
                );
            }
            immutable cull = pso.descriptor.rasterizer.cullFace;
            if (cull != CullFace.Front) bindSide(GL_FRONT, stencil.front, stencilRef[0]);
            if (cull != CullFace.Back) bindSide(GL_BACK, stencil.back, stencilRef[1]);
        }

        unload();
    }

    final void unload() {
        pso.unload();
    }
}


class SetBlendStateCommand : Command {
    Rc!RawPipelineState pso;
    this(RawPipelineState pso) {
        this.pso = pso;
    }
    final void execute(GlDevice device) {
        assert(pso.loaded);
        if (!pso.pinned) pso.pinResources(device);

        if (device.caps.separateBlendSlots) {
            foreach (ct; pso.descriptor.colorTargets) {
                bindBlendSlot(ct.info, ct.slot);
            }
        }
        else {
            foreach (ct; pso.descriptor.colorTargets) {
                if (ct.slot == 0) {
                    bindBlend(ct.info);
                    break;
                }
            }
        }

        unload();
    }
    final void unload() {
        pso.unload();
    }
}


class BindProgramCommand : Command {
    Rc!Program prog;

    this(Program prog) { this.prog = prog; }

    final void execute(GlDevice device) {
        assert(prog.loaded);
        if (!prog.pinned) prog.pinResources(device);
        prog.res.bind();

        unload();
    }

    final void unload() {
        prog.unload();
    }
}

class BindVertexBuffersCommand : Command {
    VertexBufferSet set;
    Rc!RawPipelineState pso;

    this(VertexBufferSet set, RawPipelineState pso) {
        this.set = set;
        this.pso = pso;
    }

    final void execute(GlDevice device) {
        import gfx.core.util : unsafeCast;
        assert(pso.loaded);
        if (!pso.pinned) pso.pinResources(device);
        foreach (i, vbuf; set.buffers) {
            if (!vbuf.pinned) vbuf.pinResources(device);
            unsafeCast!GlVertexBuffer(vbuf.res).bindWithAttrib(
                    pso.descriptor.vertexAttribs[i],
                    device.caps.instanceRate);
        }
        unload();
    }

    final void unload() {
        set = VertexBufferSet.init;
        pso.unload();
    }
}

class BindConstantBuffersCommand : Command {
    ConstantBlockSet set;
    Rc!RawPipelineState pso;

    this(ConstantBlockSet set, RawPipelineState pso) {
        this.set = set;
        this.pso = pso;
    }

    final void execute(GlDevice device) {
        import gfx.core.util : unsafeCast;
        assert(pso.loaded);
        if (!pso.pinned) pso.pinResources(device);
        foreach (i, buf; set.blocks) {
            if (!buf.pinned) buf.pinResources(device);
            immutable bufName = unsafeCast!GlBuffer(buf.res).name;
            glBindBufferBase(GL_UNIFORM_BUFFER, pso.descriptor.constantBlocks[i].slot, bufName);
        }

        unload();
    }

    final void unload() {
       	set = ConstantBlockSet.init;
        pso.unload();
    }
}


class BindResourceViewsCommand : Command {
    Rc!RawPipelineState pso;
    ResourceViewSet set;

    this(RawPipelineState pso, ResourceViewSet set) {
        this.pso = pso; this.set = set;
    }

    final void execute(GlDevice device) {
        assert(pso.loaded);
        if (!pso.pinned) pso.pinResources(device);
        foreach(i, srv; set.views) {
            if (!srv.pinned) srv.pinResources(device);
            glActiveTexture(cast(GLenum)(GL_TEXTURE0+pso.descriptor.resourceViews[i].slot));
            srv.res.bind();
        }
        unload();
    }
    final void unload() {
        pso.unload();
        set = ResourceViewSet.init;
    }
}


class BindSamplersCommand : Command {
    Rc!RawPipelineState pso;
    SamplerSet set;

    this (RawPipelineState pso, SamplerSet set) {
        this.pso = pso; this.set = set;
    }

    final void execute(GlDevice device) {
        import gfx.backend.gl3.texture : GlSampler;
        import gfx.core.util : unsafeCast;
        assert(pso.loaded);
        if (!pso.pinned) pso.pinResources(device);
        foreach (i, sampler; set.samplers) {
            if (!sampler.pinned) sampler.pinResources(device);
            unsafeCast!GlSampler(sampler.res).bind(pso.descriptor.samplers[i].slot);
        }
        unload();
    }
    final void unload() {
        pso.unload();
        set = SamplerSet.init;
    }
}

class BindPixelTargetsCommand(bool withPSO) : Command {
    PixelTargetSet targets;

    static if (withPSO) {
        Rc!RawPipelineState pso;
        this(PixelTargetSet targets, RawPipelineState pso) {
            this.targets = targets;
            this.pso = pso;
        }
    }
    else {
        this(PixelTargetSet targets) {
            this.targets = targets;
        }
    }

    final void execute(GlDevice device) {
        import gfx.backend.gl3.view : GlTargetView;
        import gfx.core : ResourceHolder;
        import gfx.core.util : unsafeCast;

        enum point = GL_DRAW_FRAMEBUFFER;

        void bindTarget(T)(T obj, GLenum attachment) if (is(T : ResourceHolder)) {
            assert(obj !is null);
            if (!obj.pinned) obj.pinResources(device);
            unsafeCast!(GlTargetView)(obj.res).bind(point, attachment);
        }

        static if (withPSO) {
            assert(pso.loaded);
            if (!pso.pinned) pso.pinResources(device);
            assert(targets.colors.length == pso.descriptor.colorTargets.length);
            foreach(i, rtv; targets.colors) {
                bindTarget(rtv, GL_COLOR_ATTACHMENT0+pso.descriptor.colorTargets[i].slot);
            }
        }
        else {
            foreach(i, rtv; targets.colors) {
                bindTarget(rtv, cast(GLenum)(GL_COLOR_ATTACHMENT0+i));
            }
        }

        if (targets.depth.loaded) {
            bindTarget(targets.depth.obj, GL_DEPTH_ATTACHMENT);
        }
        if (targets.stencil.loaded) {
            bindTarget(targets.stencil.obj, GL_STENCIL_ATTACHMENT);
        }

        unload();
    }

    final void unload() {
        targets = PixelTargetSet.init;
        static if (withPSO) {
            pso.unload();
        }
    }
}


class BindFramebufferCommand : Command {
    GLenum access;
    GLuint fbo;

    this(GLenum access, GLuint fbo) {
        this.access = access;
        this.fbo = fbo;
    }

    final void execute(GlDevice device) {
        glBindFramebuffer(access, fbo);
    }

    final void unload() {}
}


class BindBufferCommand : Command {
    Rc!RawBuffer buf;

    this(RawBuffer buf) {
        this.buf = buf;
    }

    final void execute(GlDevice device) {
        assert(buf.loaded);
        if (!buf.pinned) buf.pinResources(device);

        buf.res.bind();

        unload();
    }

    final void unload() {
        buf.unload();
    }
}

class UpdateBufferCommand : Command {
    Rc!RawBuffer buf;
    const(ubyte)[] data;
    size_t offset;

    this(RawBuffer buf, const(ubyte)[] data, size_t offset) {
        this.buf = buf; this.data = data; this.offset = offset;
    }

    final void execute(GlDevice device) {
        assert(buf.loaded);
        if (!buf.pinned) buf.pinResources(device);
        buf.res.update(offset, data);
        unload();
    }

    final void unload() {
        buf.unload();
    }
}

class UpdateTextureCommand : Command {
    Rc!RawTexture tex;
    ImageSliceInfo info;
    const(ubyte)[] data;

    this(RawTexture tex, in ImageSliceInfo info, const(ubyte)[] data) {
        this.tex = tex;
        this.info = info;
        this.data = data;
    }

    final void execute(GlDevice device) {
        assert(tex.loaded);
        if (!tex.pinned) tex.pinResources(device);
        tex.res.update(info, data);
        unload();
    }

    final void unload() {
        tex.unload();
        data = [];
    }
}

class GenerateMipmapCommand : Command {
    Rc!RawShaderResourceView view;

    this(RawShaderResourceView view) {
        this.view = view;
    }

    final void execute(GlDevice device) {
        import gfx.backend.gl3.view : GlShaderResourceView;
        import gfx.core.util : unsafeCast;

        assert(view.loaded);
        if (!view.pinned) view.pinResources(device);
        auto res = unsafeCast!GlShaderResourceView(view.res);
        immutable target = res.target;
        immutable name = res.texName;
        glBindTexture(target, name);
        glGenerateMipmap(target);
        unload();
    }

    final void unload() {
        view.unload();
    }
}

class ClearCommand : Command {
    Option!ClearColor color;
    Option!float depth;
    Option!ubyte stencil;

    this(Option!ClearColor color, Option!float depth, Option!ubyte stencil) {
        this.color = color; this.depth = depth; this.stencil = stencil;
    }

    final void execute(GlDevice device) {
        if (color.isSome) {
            auto col = color.get();
            glColorMask(GL_TRUE, GL_TRUE, GL_TRUE, GL_TRUE);
            final switch (col.tag) {
                case ClearColor.Float:
                    auto fc = col.getFloat();
                    glClearBufferfv(GL_COLOR, 0, &fc[0]);
                    break;
                case ClearColor.Int:
                    auto ic = col.getInt();
                    glClearBufferiv(GL_COLOR, 0, &ic[0]);
                    break;
                case ClearColor.Uint:
                    auto uc = col.getUint();
                    glClearBufferuiv(GL_COLOR, 0, &uc[0]);
                    break;
            }
        }
        if (depth.isSome) {
            auto d = depth.get();
            glDepthMask(GL_TRUE);
            glClearBufferfv(GL_DEPTH, 0, &d);
        }
        if (stencil.isSome) {
            GLint s = stencil.get();
            glStencilMask(GLuint.max);
            glClearBufferiv(GL_STENCIL, 0, &s);
        }
    }

    final void unload() {}
}


class DrawCommand : Command {
    GLenum primitive;
    GLint start;
    GLsizei count;
    Option!Instance instances;

    this(GLenum primitive, GLint start, GLsizei count, Option!Instance instances) {
        this.primitive = primitive; this.start = start; this.count = count; this.instances = instances;
    }

    final void execute(GlDevice device) {
        if (instances.isSome) {
            assert(device.caps.instanceDraw);
            glDrawArraysInstancedBaseInstance(
                primitive, start, count, instances.count, instances.base
            );
        }
        else {
            glDrawArrays(primitive, start, count);
        }
    }

    final void unload() {}
}

class DrawIndexedCommand : Command {
    GLenum primitive;
    GLsizei count;
    GLenum indexType;
    size_t offset;
    GLint baseVertex;
    Option!Instance instances;

    this(GLenum primitive, GLsizei count, GLenum indexType,
            size_t offset, GLint baseVertex, Option!Instance instances) {
        this.primitive = primitive;
        this.count = count;
        this.indexType = indexType;
        this.offset = offset;
        this.baseVertex = baseVertex;
        this.instances = instances;
    }

    final void execute(GlDevice device) {

        assert(baseVertex == 0 || device.caps.vertexBase);
        auto offsetp = cast(GLvoid*)offset;

        if (instances.isSome) {
            assert(device.caps.instanceDraw);
            if (baseVertex == 0 && instances.base == 0) {
                glDrawElementsInstanced(
                    primitive, count, indexType, offsetp, instances.count
                );
            }
            else if (baseVertex != 0 && instances.base == 0) {
                glDrawElementsInstancedBaseVertex(
                    primitive, count, indexType, offsetp, instances.count, baseVertex
                );
            }
            else if (baseVertex == 0 && instances.base != 0) {
                glDrawElementsInstancedBaseInstance(
                    primitive, count, indexType, offsetp, instances.count, instances.base
                );
            }
            else {
                glDrawElementsInstancedBaseVertexBaseInstance(
                    primitive, count, indexType, offsetp, instances.count, baseVertex, instances.base
                );
            }
        }
        else {
            if (baseVertex == 0) {
                glDrawElements(
                    primitive, count, indexType, offsetp
                );
            }
            else {
                glDrawElementsBaseVertex(
                    primitive, count, indexType, offsetp, baseVertex
                );
            }
        }
    }
    final void unload() {}
}


struct GlCommandCache {
    Rc!RawPipelineState pso;
    IndexType indexType;
}


class GlCommandBuffer : CommandBuffer {
    mixin(rcCode);

    GLuint _fbo;
    GlCommandCache _cache;
    Command[] _commands;

    this(GLuint fbo) {
        _fbo = fbo;
    }

    final void drop() {
        _cache = GlCommandCache.init;
        import std.algorithm : each;
        _commands.each!(cmd => cmd.unload());
    }

    final Command[] retrieve() {
        auto cmds = _commands;
        _commands = [];
        _cache = GlCommandCache.init;
        return cmds;
    }

    final void bindPipelineState(RawPipelineState pso) {
        _cache.pso = pso;
        _commands ~= new BindProgramCommand(pso.program);
        _commands ~= new SetRasterizerCommand(pso.descriptor.rasterizer);
        _commands ~= new SetDepthStateCommand(pso);
        _commands ~= new SetBlendStateCommand(pso);
    }

    final void bindVertexBuffers(VertexBufferSet set) {
        assert(_cache.pso.loaded, "must bind pso before vertex buffers");
        _commands ~= new BindVertexBuffersCommand(set, _cache.pso.obj);
    }

    final void bindConstantBuffers(ConstantBlockSet set) {
        assert(_cache.pso.loaded, "must bind pso before constant blocks");
        _commands ~= new BindConstantBuffersCommand(set, _cache.pso.obj);
    }

    final void bindResourceViews(ResourceViewSet set) {
        assert(_cache.pso.loaded, "must bind pso before resource views");
        _commands ~= new BindResourceViewsCommand(_cache.pso, set);
    }

    final void bindSamplers(SamplerSet set) {
        assert(_cache.pso.loaded, "must bind pso before samplers");
        _commands ~= new BindSamplersCommand(_cache.pso, set);
    }

    final void bindPixelTargets(PixelTargetSet targets) {
        assert(_cache.pso.loaded, "must bind pso before pixel targets");
        bindPixelTargetsImpl!true(targets);
    }

    private void bindPixelTargetsImpl(bool withPSO)(PixelTargetSet targets) {
        import gfx.core : MaybeBuiltin;
        bool bltin(T)(in T obj) if (is(T : MaybeBuiltin)) {
            return !obj || obj.builtin;
        }
        immutable isBuiltin =
                (targets.colors.length == 0 || (targets.colors.length == 1 && targets.colors[0].builtin)) &&
                bltin(targets.depth.obj) && bltin(targets.stencil.obj);
        if (isBuiltin) {
            _commands ~= new BindFramebufferCommand(GL_DRAW_FRAMEBUFFER, 0);
        }
        else {
            _commands ~= new BindFramebufferCommand(GL_DRAW_FRAMEBUFFER, _fbo);
            static if (withPSO) {
                _commands ~= new BindPixelTargetsCommand!withPSO(targets, _cache.pso);
            }
            else {
                _commands ~= new BindPixelTargetsCommand!withPSO(targets);
            }
            immutable num=cast(ubyte)targets.colors.length;
            immutable mask = 0x0f && ((1 << num) - 1);
            _commands ~= new SetDrawColorBuffersCommand(mask);
        }
    }

    final void bindIndex(RawBuffer buf, IndexType ind) {
        assert(ind != IndexType.None);
        _cache.indexType = ind;
        _commands ~= new BindBufferCommand(buf);
    }

    final void setViewport(Rect r) {
        _commands ~= new SetViewportCommand(r);
    }

    final void setScissor(Rect r) {
        Option!Rect or;
        if (_cache.pso.loaded && _cache.pso.descriptor.scissor) {
            or = r;
        }
        _commands ~= new SetScissorCommand(or);
    }

    final void setRefValues(float[4] blend, ubyte[2] stencil) {
        assert(_cache.pso.loaded);
        _commands ~= new SetStencilTestCommand(_cache.pso, stencil);
        _commands ~= new class Command {
            final void execute(GlDevice device) {
                glBlendColor(blend[0], blend[1], blend[2], blend[3]);
            }
            final void unload() {}
        };
    }

    final void updateBuffer(RawBuffer buffer, const(ubyte)[] data, size_t offset) {
        _commands ~= new UpdateBufferCommand(buffer, data, offset);
    }

    final void updateTexture(RawTexture tex, ImageSliceInfo info, const(ubyte)[] data) {
        _commands ~= new UpdateTextureCommand(tex, info, data);
    }

    final void generateMipmap(RawShaderResourceView view) {
        _commands ~= new GenerateMipmapCommand(view);
    }

    final void clearColor(RawRenderTargetView view, ClearColor color) {
        // TODO handle targets
        PixelTargetSet targets;
        targets.addColor(view);
        bindPixelTargetsImpl!false(targets);
        _commands ~= new ClearCommand(some(color), none!float, none!ubyte);
    }

    final void clearDepthStencil(RawDepthStencilView view, Option!float depth, Option!ubyte stencil) {
        PixelTargetSet targets;
        if (depth.isSome) {
            targets.depth = view;
        }
        if (stencil.isSome) {
            targets.stencil = view;
        }
        bindPixelTargetsImpl!false(targets);
        _commands ~= new ClearCommand(none!ClearColor, depth, stencil);
    }

    final void draw(uint start, uint count, Option!Instance instances) {
        // TODO instanced drawings
        assert(_cache.pso.loaded, "must bind pso before draw calls");
        _commands ~= new DrawCommand(primitiveToGl(_cache.pso.descriptor.primitive), start, count, instances);
    }

    final void drawIndexed(uint start, uint count, uint base, Option!Instance instances) {
        // TODO instanced drawings
        assert(_cache.pso.loaded, "must bind pso before draw calls");
        assert(_cache.indexType != IndexType.None, "must bind index before indexed draw calls");
        GLenum index;
        size_t offset;
        switch(_cache.indexType) {
            case IndexType.U16:
                index = GL_UNSIGNED_SHORT;
                offset = start*2;
                break;
            case IndexType.U32:
                index = GL_UNSIGNED_INT;
                offset = start*4;
                break;
            default: assert(false);
        }
        _commands ~= new DrawIndexedCommand(
            primitiveToGl(_cache.pso.descriptor.primitive), count, index, offset, base, instances
        );
    }
}