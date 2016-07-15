module triangle;

import gfx.backend.gl3 : GlContext, createGlDevice;
import gfx.core.rc : rc, makeRc;
import gfx.core.buffer : createVertexBuffer;
import gfx.core.program : ShaderSet, Program;
import gfx.core.pipeline_state : AttribName;

import derelict.glfw3.glfw3;
import derelict.opengl3.gl3;


struct Vertex {
    @Name("a_Pos")    float[2] pos;
    @Name("a_Color")  float[3] color;
}


immutable triangle = [
    Vertex([-0.5, -0.5], [1.0, 0.0, 0.0]),
    Vertex([ 0.5, -0.5], [0.0, 1.0, 0.0]),
    Vertex([ 0.0,  0.5], [0.0, 0.0, 1.0]),
];

immutable float[4] clearColor = [0.1, 0.2, 0.3, 1.0];


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

        auto device = createGlDevice(context);
        context.makeCurrent();

        vbuf.pinResources(device.context);
        prog.pinResources(device.context);

        glClearColor(clearColor[0], clearColor[1],
                clearColor[2], clearColor[3]);

        /* Loop until the user closes the window */
        while (!glfwWindowShouldClose(window)) {
            /* Render here */
            glClear(GL_COLOR_BUFFER_BIT);

            /* Swap front and back buffers */
            context.swapBuffers();

            /* Poll for and process events */
            glfwPollEvents();
        }
    }
    context.doneCurrent();
    glfwTerminate();
    return 0;
}
