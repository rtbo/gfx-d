module gfx.backend.dummy;

import gfx.core : Device;
import gfx.core.context : Context;
import gfx.core.rc : RcCode;
import gfx.core.format : Format;
import gfx.core.buffer;
import gfx.core.texture;
import gfx.core.program;


class DummyDevice : Device {
    @property Context context() {
        return new DummyContext();
    }
}


class DummyContext : Context {
    TextureRes makeTexture(TextureCreationDesc, const(ubyte)[][]) {
        return new DummyTexture();
    }
    BufferRes makeBuffer(BufferCreationDesc, const(ubyte)[]) {
        return new DummyBuffer();
    }
    ShaderRes makeShader(ShaderStage, string) {
        return new DummyShader();
    }
    ProgramRes makeProgram(ShaderRes[], out ProgramInfo) {
        return new DummyProgram();
    }
}


class DummyTexture : TextureRes {
    mixin RcCode!();
    void drop() {}
    void bind() {}
    void update(ImageSliceInfo slice, const(ubyte)[] data) {}
}

class DummyBuffer : BufferRes {
    mixin RcCode!();
    void drop() {}
    void bind() {}
    void update(BufferSliceInfo slice, const(ubyte)[] data) {}
}

class DummyShader : ShaderRes {
    mixin RcCode!();
    void drop() {}
}

class DummyProgram : ProgramRes {
    mixin RcCode!();
    void drop() {}
    void bind() {}
}