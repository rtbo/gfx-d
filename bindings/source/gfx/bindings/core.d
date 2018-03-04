module gfx.bindings.core;

// Dynamic bindings facility

/// A handle to a shared library
alias SharedLib = void*;
/// A handle to a shared library symbol
alias SharedSym = void*;

/// Opens a shared library.
/// Return null in case of failure.
SharedLib openSharedLib(string name);

/// Load a symbol from a shared library.
/// Return null in case of failure.
SharedSym loadSharedSym(SharedLib lib, string name);

/// Close a shared library
void closeSharedLib(SharedLib lib);


/// Generic Dynamic lib symbol loader.
/// Symbols loaded with such loader must be cast to the appropriate function type.
alias SymbolLoader = SharedSym delegate (in string name);


version(Posix)
{
    import std.string : toStringz;
    import core.sys.posix.dlfcn;

    SharedLib openSharedLib(string name)
    {
        return dlopen(toStringz(name), RTLD_LAZY);
    }

    SharedSym loadSharedSym(SharedLib lib, string name)
    {
        return dlsym(lib, toStringz(name));
    }

    void closeSharedLib(SharedLib lib)
    {
        dlclose(lib);
    }
}
version(Windows)
{
    import std.string : toStringz;
    import core.sys.windows.winbase;

    SharedLib openSharedLib(string name)
    {
        return LoadLibraryA(toStringz(name));
    }

    SharedSym loadSharedSym(SharedLib lib, string name)
    {
        return GetProcAddress(lib, toStringz(name));
    }

    void closeSharedLib(SharedLib lib)
    {
        FreeLibrary(lib);
    }
}

/// Utility that open a shared library and load symbols from it.
class SharedLibLoader
{
    import std.typecons : Flag, Yes, No;
    private SharedLib _lib;
    private string _libName;

    /// Load the shared libraries and call bindSymbols if succesful.
    void load (string[] libNames)
    {
        foreach (ln; libNames)
        {
            _lib = openSharedLib(ln);
            if (_lib)
            {
                _libName = ln;
                break;
            }
        }
        if (!_lib)
        {
            import std.conv : to;
            throw new Exception(
                "Cannot load one of shared libs " ~ libNames.to!string
            );
        }
        bindSymbols();
    }

    /// Direct handle access
    public @property SharedLib handle()
    {
        return _lib;
    }

    /// Returns whether the shared library is open.
    public @property bool loaded() const
    {
        return _lib !is null;
    }

    /// Returns the name of the shared library that was open.
    /// Empty string if not loaded.
    public @property string libName() const
    {
        return _libName;
    }

    /// Bind a symbol, using the function pointer symbol name.
    void bind(alias f)(Flag!"optional" optional = No.optional)
    {
        immutable name = f.stringof;
        if (f !is null)
        {
            throw new Exception("Tentative to bind already bound symbol "~ name);
        }
        auto sym = loadSharedSym(_lib, name);
        if (!sym && !optional)
        {
            throw new Exception("Cannot load symbol "~name~" from "~_libName~".");
        }
        f = cast(typeof(f)) sym;
    }

    /// Subclasses can override this to bind all the necessary symbols.
    /// Default implementation does nothing.
    void bindSymbols()
    {}
}
