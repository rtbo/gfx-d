module gfx.bindings.opengl;

string[] splitExtString(const(char)* str) {
    import std.array : split;
    import std.string : fromStringz;
    return fromStringz(str).idup.split();
}
