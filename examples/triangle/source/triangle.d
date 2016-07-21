module triangle;

import gfx.backend.gl3 : GlContext, createGlDevice;
import gfx.core : Primitive;
import gfx.core.rc : Rc, rc, makeRc;
import gfx.core.typecons : Option, none, some;
import gfx.core.format : Rgba8;
import gfx.core.buffer : createVertexBuffer;
import gfx.core.program : ShaderSet, Program;
import gfx.core.pso.meta;
import gfx.core.pso : PipelineDescriptor, PipelineState, VertexBufferSet;
import gfx.core.state : Rasterizer;
import gfx.core.command : clearColor, Instance;

import derelict.glfw3.glfw3;
import derelict.opengl3.gl3;

import std.stdio : writeln;


struct Vertex {
    @GfxName("a_Pos")   float[2] pos;
    @GfxName("a_Color") float[3] color;
}

struct PipeMeta {
                        VertexBuffer!Vertex input;
    @GfxName("o_Color") RenderTarget!Rgba8 output;
}

alias PipeState = PipelineState!PipeMeta;

static assert(isMetaStruct!PipeMeta);

alias PipeInit = PipelineInit!PipeMeta;
alias PipeData = PipelineData!PipeMeta;



immutable triangle = [
    Vertex([-0.5, -0.5], [1.0, 0.0, 0.0]),
    Vertex([ 0.5, -0.5], [0.0, 1.0, 0.0]),
    Vertex([ 0.0,  0.5], [0.0, 0.0, 1.0]),
];

immutable float[4] backColor = [0.1, 0.2, 0.3, 1.0];


class GlfwContext : GlContext {
    private GLFWwindow* window;

    this(GLFWwindow *window) {
        this.window = window;
    }

    void makeCurrent() {
        glfwMakeContextCurrent(window);
    }

    void doneCurrent() {
        glfwMakeContextCurrent(null);
    }

    void swapBuffers() {
        glfwSwapBuffers(window);
    }
}

extern(C)
void handleError(int code, const(char)*str) nothrow {
    try {
        import std.stdio : writeln;
        import std.string : fromStringz;
        writeln("GLFW error: ", code, ":\n - ", fromStringz(str), "\n");
    }
    catch(Throwable th) {}
}


int main()
{

    DerelictGLFW3.load();
    DerelictGL3.load();

    /* Initialize the library */
    if (!glfwInit())
        return -1;

    glfwSetErrorCallback(&handleError);

    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
    glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);

    /* Create a windowed mode window and its OpenGL context */
    auto window = glfwCreateWindow(640, 480, "gfx-d - Triangle", null, null);
    if (!window) {
        glfwTerminate();
        return -1;
    }

    auto context = new GlfwContext(window);
    {
        auto vbuf = rc(createVertexBuffer!Vertex(triangle));
        auto prog = makeRc!Program(ShaderSet.vertexPixel(
            import("130-triangle.v.glsl"),
            import("130-triangle.f.glsl"),
        ));
        auto pipe = makeRc!PipeState(prog.obj, Primitive.Triangles, Rasterizer.newFill());

        context.makeCurrent();
        DerelictGL3.reload();
        auto device = createGlDevice(context);
        auto cmdBuf = rc(device.context.makeCommandBuffer());


        vbuf.pinResources(device.context);
        prog.pinResources(device.context);
        pipe.pinResources(device.context);

        VertexBufferSet vbs;
        vbs.entries[0] = VertexBufferSet.Entry(rc(vbuf.res), 0);
        vbs.entries[1] = VertexBufferSet.Entry(rc(vbuf.res), 0);

        import std.datetime : StopWatch;

        size_t frameCount;
        StopWatch sw;
        sw.start();

        /* Loop until the user closes the window */
        while (!glfwWindowShouldClose(window)) {

            cmdBuf.clearColor(null, clearColor(backColor));
            cmdBuf.bindPipelineState(pipe.obj);
            cmdBuf.bindVertexBuffers(vbs);
            cmdBuf.callDraw(0, cast(uint)vbuf.count, none!Instance);

            device.context.submit(cmdBuf);

            /* Swap front and back buffers */
            context.swapBuffers();

            /* Poll for and process events */
            glfwPollEvents();
            frameCount += 1;
        }

        auto ms = sw.peek().msecs();
        writeln("FPS: ", 1000.0f*frameCount / ms);
    }
    context.doneCurrent();
    glfwTerminate();
    return 0;
}