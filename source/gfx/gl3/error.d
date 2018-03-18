module gfx.gl3.error;

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
