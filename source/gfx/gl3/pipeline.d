module gfx.gl3.pipeline;

package:

import gfx.bindings.opengl.gl : Gl, GLenum, GLint, GLuint;
import gfx.graal.pipeline;

final class GlShaderModule : ShaderModule
{
    import gfx.bindings.opengl.gl : GLuint;
    import gfx.core.rc : atomicRcCode;
    import gfx.gl3 : GlShare;

    mixin(atomicRcCode);

    private Gl gl;
    private GLuint _name;
    private string _code;

    this (GlShare share, in ShaderLanguage sl, in string code) {
        gl = share.gl;
        _code = code;

        import std.exception : enforce;
        enforce(sl == ShaderLanguage.glsl);
    }

    override void dispose() {
        if (_name != 0) {
            gl.DeleteShader(_name);
        }
    }

    override @property string entryPoint() {
        return "main";
    }

    GLuint compile(in ShaderStage stage)
    {
        assert(_name == 0, "already compiled this shader");

        import gfx.bindings.opengl.gl : GLchar, GLint;
        import gfx.gl3.conv : toGl;

        const target = toGl(stage);
        _name = gl.CreateShader(target);

        const GLint len = cast(GLint)_code.length;
        const GLchar* str = cast(const(GLchar)*)_code.ptr;
        gl.ShaderSource(_name, 1, &str, &len);

        gl.CompileShader(_name);

        const log = getShaderLog(gl, _name);
        if (!getShaderCompileStatus(gl, _name)) {
            import gfx.gl3.error : Gl3ShaderCompileException;
            throw new Gl3ShaderCompileException(stage, _code, log);
        }
        else if (log.length) {
            import std.conv : to;
            import std.experimental.logger : logf;
            logf("%s shader compile message: %s", stage.to!string, log);
        }
        return _name;
    }

}

private GLint getShaderInt(Gl gl, in GLuint name, in GLenum pname) {
    GLint res;
    gl.GetShaderiv(name, pname, &res);
    return res;
}

private bool getShaderCompileStatus(Gl gl, in GLuint name) {
    import gfx.bindings.opengl.gl : GL_COMPILE_STATUS, GL_FALSE;
    return getShaderInt(gl, name, GL_COMPILE_STATUS) != GL_FALSE;
}

private string getShaderLog(Gl gl, in GLuint name) {
    import gfx.bindings.opengl.gl : GL_INFO_LOG_LENGTH;
    auto len = getShaderInt(gl, name, GL_INFO_LOG_LENGTH);
    if (len > 0) {
        auto msg = new char[len];
        gl.GetShaderInfoLog(name, len, &len, msg.ptr);
        return msg[0 .. len-1].idup;
    }
    else {
        return null;
    }
}



private GLint getProgramInt(Gl gl, in GLuint name, in GLenum pname) {
    GLint res;
    gl.GetProgramiv(name, pname, &res);
    return res;
}

private bool getProgramLinkStatus(Gl gl, in GLuint name) {
    import gfx.bindings.opengl.gl : GL_FALSE, GL_LINK_STATUS;
    return getProgramInt(gl, name, GL_LINK_STATUS) != GL_FALSE;
}


private string getProgramLog(Gl gl, in GLuint name) {
    import gfx.bindings.opengl.gl : GL_INFO_LOG_LENGTH;
    auto len = getProgramInt(gl, name, GL_INFO_LOG_LENGTH);
    if (len > 0) {
        auto msg = new char[len];
        gl.GetProgramInfoLog(name, len, &len, msg.ptr);
        return msg[0 .. len-1].idup;
    }
    else {
        return null;
    }
}
