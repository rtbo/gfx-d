module gfx.gl3.error;

import gfx.bindings.opengl.gl : Gl;
import gfx.graal.pipeline : ShaderStage;
import gfx.graal.error : GfxException;

string prependLineNumbers(string code) {
    import std.string : splitLines, strip, KeepTerminator;
    import std.format : format;
    import std.algorithm : joiner, map;
    import std.conv : to;
    import std.math : log10;

    auto lines = code.splitLines(KeepTerminator.yes);
    immutable width = 1 + cast(int)log10(lines.length);
    string res;
    foreach(i, l; lines) {
        res ~= format("%*s. %s", width, i+1, l);
    }
    return res;
}

unittest {
    string code =
        "#version 120\n" ~
        "\n" ~
        "attribute vec2 a_Pos;\n" ~
        "attribute vec3 a_Color;\n" ~
        "varying vec4 v_Color;\n" ~
        "\n" ~
        "void main() {\n" ~
        "    v_Color = vec4(a_Color, 1.0);\n" ~
        "    gl_Position = vec4(a_Pos, 0.0, 1.0);\n" ~
        "}";

    string expected =
        " 1. #version 120\n" ~
        " 2. \n" ~
        " 3. attribute vec2 a_Pos;\n" ~
        " 4. attribute vec3 a_Color;\n" ~
        " 5. varying vec4 v_Color;\n" ~
        " 6. \n" ~
        " 7. void main() {\n" ~
        " 8.     v_Color = vec4(a_Color, 1.0);\n" ~
        " 9.     gl_Position = vec4(a_Pos, 0.0, 1.0);\n" ~
        "10. }";

    assert(prependLineNumbers(code) == expected);
}


class Gl3ShaderCompileException : GfxException {
    ShaderStage stage;
    string code;
    string errorMsg;

    this(ShaderStage stage, string code, string errorMsg) {
        import std.format : format;
        import std.conv : to;
        super(format("%s shader compilation error", stage.to!string),
                format("\n%s\nshader code:\n%s\n", errorMsg, prependLineNumbers(code)));

        this.stage = stage;
        this.code = code;
        this.errorMsg = errorMsg;
    }
}

class Gl3ProgramLinkException : Exception {
    string errorMsg;

    this(string errorMsg) {
        import std.format : format;
        super(format("Shading program link error"), errorMsg);

        this.errorMsg = errorMsg;
    }
}

void glCheck(Gl gl, in string operation)
{
    import gfx.bindings.opengl.gl : GL_NO_ERROR, GL_INVALID_ENUM,
                                    GL_INVALID_VALUE, GL_INVALID_OPERATION,
                                    GL_STACK_OVERFLOW, GL_STACK_UNDERFLOW,
                                    GL_OUT_OF_MEMORY,
                                    GL_INVALID_FRAMEBUFFER_OPERATION,
                                    GL_CONTEXT_LOST;
    const code = gl.GetError();
    if (code != GL_NO_ERROR) {
        string glErr;
        switch (code) {
        case GL_INVALID_ENUM:
            glErr = "GL_INVALID_ENUM";
            break;
        case GL_INVALID_VALUE:
            glErr = "GL_INVALID_VALUE";
            break;
        case GL_INVALID_OPERATION:
            glErr = "GL_INVALID_OPERATION";
            break;
        case GL_STACK_OVERFLOW:
            glErr = "GL_STACK_OVERFLOW";
            break;
        case GL_STACK_UNDERFLOW:
            glErr = "GL_STACK_UNDERFLOW";
            break;
        case GL_OUT_OF_MEMORY:
            glErr = "GL_OUT_OF_MEMORY";
            break;
        case GL_INVALID_FRAMEBUFFER_OPERATION:
            glErr = "GL_INVALID_FRAMEBUFFER_OPERATION";
            break;
        case GL_CONTEXT_LOST:
            glErr = "GL_CONTEXT_LOST";
            break;
        default:
            glErr = "(unknown error)";
            break;
        }

        import gfx.gl3 : gfxGlLog;

        gfxGlLog.errorf("OpenGL error %s during %s", glErr, operation);
    }
}
