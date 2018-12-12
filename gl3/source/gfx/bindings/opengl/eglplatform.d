module gfx.bindings.opengl.eglplatform;

alias EGLNativeDisplayType = void*;
alias EGLNativePixmapType = void*;
alias EGLNativeWindowType = void*;

alias NativeDisplayType = EGLNativeDisplayType;
alias NativePixmapType = EGLNativePixmapType;
alias NativeWindowType = EGLNativeWindowType;

alias EGLint = int;

auto EGL_CAST(T, V)(V value) {
    return cast(T)value;
}
