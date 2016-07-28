module gfx.core.encoder;

import gfx.core.rc : Rc;
import gfx.core.command : CommandBuffer;
import gfx.core.buffer : ConstBuffer;

struct Encoder {

    Rc!CommandBuffer _cmdBuf;

    this (CommandBuffer cmdBuf) {
        _cmdBuf = cmdBuf;
    }

    void updateConstBuffer(T)(ConstBuffer!T buf, in T value) {
        auto bytes = cast(const(ubyte)*)&value;
        _cmdBuf.updateBuffer(buf, bytes[0 .. T.sizeof].dup, 0);
    }
    void updateConstBuffer(T)(ConstBuffer!T buf, in T[] slice) {
        auto bytes = cast(const(ubyte)*)slice.ptr;
        _cmdBuf.updateBuffer(buf, bytes[0 .. slice.length*T.sizeof], 0);
    }

}
