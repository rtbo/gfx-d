module gfx.backend.gl3.command;

import gfx.backend : unsafeCast;
import gfx.backend.gl3 : GlDeviceContext;
import gfx.backend.gl3.state : setRasterizer;
import gfx.backend.gl3.buffer : GlBuffer, GlVertexBuffer;
import gfx.backend.gl3.program : GlProgram;
import gfx.backend.gl3.pso : GlPipelineState, OutputMerger;
import gfx.core : maxVertexAttribs, maxColorTargets, AttribMask, ColorTargetMask, Rect, Primitive;
import gfx.core.typecons : Option, some, none;
import gfx.core.command : CommandBuffer, ClearColor, Instance;
import gfx.core.rc : Rc, rcCode;
import gfx.core.program : ProgramRes;
import gfx.core.buffer : BufferRes;
import gfx.core.pso : RawPipelineState, VertexBufferSet, PixelTargetSet, VertexAttribDesc;
import gfx.core.state : Rasterizer, Stencil, CullFace;
import gfx.core.view : RawRenderTargetView;
import gfx.core.format : ChannelType, SurfaceType;

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


interface Command {
    void execute(GlDeviceContext context);
}


class SetRasterizerCommand : Command {
    Rasterizer rasterizer;
    this(Rasterizer rasterizer) {
        this.rasterizer = rasterizer;
    }
    void execute(GlDeviceContext context) {
        setRasterizer(rasterizer);
    }
}

class SetDrawColorBuffers : Command {
    ubyte mask;

    static assert(maxColorTargets <= 8*typeof(mask).sizeof);

    this(ubyte mask) {
        this.mask = mask;
    }
    void execute(GlDeviceContext context) {
        GLenum[maxColorTargets] targets;
        GLsizei count=0;
        foreach(i; 0..maxColorTargets) {
            if (mask & (1 << i)) {
                targets[count++] = cast(GLenum)(GL_COLOR_ATTACHMENT0+i);
            }
        }
        glDrawBuffers(count, &targets[0]);
    }
}

class SetViewportCommand : Command {
    Rect rect;
    this(Rect rect) { this.rect = rect; }
    void execute(GlDeviceContext context) {
        glViewport(rect.x, rect.y, rect.w, rect.h);
    }
}

class SetScissorsCommand : Command {
    Option!Rect rect;
    this(Option!Rect rect) { this.rect = rect; }
    void execute(GlDeviceContext context) {
        if (rect.isSome) {
            auto r = rect.get();
            glEnable(GL_SCISSOR_TEST);
            glScissor(r.x, r.y, r.w, r.h);
        }
        else {
            glDisable(GL_SCISSOR_TEST);
        }
    }
}

class BindProgramCommand : Command {
    Rc!GlProgram prog;

    this(GlProgram prog) { this.prog = prog; }

    void execute(GlDeviceContext context) {
        prog.bind();
        prog.nullify();
    }
}

class BindAttributeCommand : Command {
    Rc!GlVertexBuffer buf;
    VertexAttribDesc desc;

    this(GlVertexBuffer buf, VertexAttribDesc desc) {
        this.buf = buf;
        this.desc = desc;
    }

    void execute(GlDeviceContext context) {
        buf.bindWithAttrib(desc, context.caps.instanceRate);
    }
}

class BindPixelTargetsCommand : Command {
    PixelTargetSet targets;
    GLuint fbo;

    this(PixelTargetSet targets, GLuint fbo) {
        this.targets = targets;
        this.fbo = fbo;
    }

    void execute(GlDeviceContext context) {
        info("impl bind targets");
    }
}

class ClearCommand : Command {
    Option!ClearColor color;
    Option!float depth;
    Option!ubyte stencil;

    this(Option!ClearColor color, Option!float depth, Option!ubyte stencil) {
        this.color = color; this.depth = depth; this.stencil = stencil;
    }

    void execute(GlDeviceContext context) {
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
}


class DrawCommand : Command {
    GLenum primitive;
    GLint start;
    GLsizei count;

    this(GLenum primitive, GLint start, GLsizei count) {
        this.primitive = primitive; this.start = start; this.count = count;
    }

    void execute(GlDeviceContext context) {
        glDrawArrays(primitive, start, count);
    }
}



struct GlCommandCache {
    GLenum primitive;
    GLenum indexType;
    AttribMask attribMask;
    VertexAttribDesc[maxVertexAttribs] attribs;
    bool scissors;
    Option!Stencil stencil;
    CullFace cullFace;
}


class GlCommandBuffer : CommandBuffer {
    mixin(rcCode);

    GLuint _fbo;
    GLuint _vao;
    GlCommandCache _cache;
    Command[] _commands;

    this() {
        glGenVertexArrays(1, &_vao);
        glGenFramebuffers(1, &_fbo);
        glBindVertexArray(_vao);
    }

    void drop() {
        glDeleteFramebuffers(1, &_fbo);
        glDeleteVertexArrays(1, &_vao);
    }

    Command[] retrieve() {
        auto cmds = _commands;
        _commands = [];
        _cache = GlCommandCache.init;
        return cmds;
    }

    void bindPipelineState(RawPipelineState pso) {
        auto glPso = unsafeCast!GlPipelineState(pso.res);
        auto output = glPso.output;
        _cache.primitive = primitiveToGl(pso.primitive);
        _cache.attribMask = glPso.inputMask;
        _cache.attribs = glPso.input;
        _cache.cullFace = pso.rasterizer.cullFace;
        _cache.stencil =  output.stencil;
        _cache.scissors = pso.scissors;
        _commands ~= new BindProgramCommand(unsafeCast!GlProgram(pso.program.res));
        _commands ~= new SetRasterizerCommand(pso.rasterizer);
        // TODO depth stencil
        foreach(i; 0 .. maxColorTargets) {
            if ((output.mask & (1<<i)) != 0) {
                // TODO: set blend state
            }
        }
    }

    void bindVertexBuffers(VertexBufferSet set) {
        foreach (slot; 0 .. maxVertexAttribs) {
            if (_cache.attribMask & (1<<slot)) {
                if (!set.entries[slot].buffer.assigned) {
                    errorf("No vertex input provided for slot %s and attrib %s", slot, _cache.attribs[slot]);
                }
                else {
                    VertexAttribDesc attrib = _cache.attribs[slot];
                    attrib.field.offset += set.entries[slot].offset;
                    assert(attrib.slot == slot);
                    _commands ~= new BindAttributeCommand(
                            unsafeCast!GlVertexBuffer(set.entries[slot].buffer.obj),
                            attrib
                    );
                }
            }
        }
    }

    void bindPixelTargets(PixelTargetSet targets) {

    }

    void clearColor(RawRenderTargetView view, ClearColor color) {
        // TODO handle targets
        PixelTargetSet targets;
        targets.colors[0] = view;
        bindPixelTargets(targets);
        _commands ~= new ClearCommand(some(color), none!float, none!ubyte);
    }

    void callDraw(uint start, uint count, Option!Instance) {
        // TODO instanced drawings
        _commands ~= new DrawCommand(_cache.primitive, start, count);
    }
}