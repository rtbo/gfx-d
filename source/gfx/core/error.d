module gfx.core.error;

import gfx.core.typecons : Option;
import gfx.core.program : ShaderStage;
import gfx.core.format : SurfaceType, ChannelType;


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


class ShaderCompileError : Exception {
    ShaderStage stage;
    string code;
    string errorMsg;

    this(ShaderStage stage, string code, string errorMsg) {
        import std.format : format;
        import std.conv : to;
        super(format("%s shader compilation " ~
            "yielded error(s):\n%s\nshader code:\n%s\n",
                stage.to!string, errorMsg,
                prependLineNumbers(code)));

        this.stage = stage;
        this.code = code;
        this.errorMsg = errorMsg;
    }
}

class ProgramLinkError : Exception {
    string errorMsg;

    this(string errorMsg) {
        import std.format : format;
        super(format("shading program linking " ~
            "yielded error(s):\n%s\n",
                errorMsg));

        this.errorMsg = errorMsg;
    }
}

class TextureCreationError : Exception {
    this (string msg) {
        super(msg);
    }
}

class SizeTextureCreationError : TextureCreationError {
    size_t size;
    this(size_t size) {
        import std.format : format;
        super(format("wrong texture size at creation: %s", size));
        this.size = size;
    }
}

class DataTextureCreationError : TextureCreationError {
    size_t size;
    this(size_t size, string msg) {
        super(msg);
        this.size = size;
    }
}

class FormatTextureCreationError : TextureCreationError {
    import std.conv : to;

    SurfaceType format;
    Option!ChannelType channel;

    this(SurfaceType format) {
        import std.conv : to;
        this.format = format;
        super("unsupported format: " ~ this.format.to!string);
    }
    this(SurfaceType format, ChannelType channel) {
        this.format = format;
        this.channel = channel;
        super("unsupported format: " ~ this.format.to!string ~
                " ; with channel: " ~ channel.to!string);
    }
}

class SamplesTextureCreationError : TextureCreationError {

    this(ubyte samples) {
        import std.conv : to;
        super("unsupported texture sampling: " ~ samples.to!string);
    }
}