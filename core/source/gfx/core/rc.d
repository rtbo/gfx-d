/// Reference counting module
module gfx.core.rc;

import gfx.core.log : LogTag;
import std.typecons : Flag, No, Yes;

enum gfxRcMask = 0x4000_0000;
immutable gfxRcLog = LogTag("GFX-RC", gfxRcMask);

/// A resource that can be disposed
interface Disposable
{
    /// Dispose the underlying resource
    void dispose();
}

/// A atomic reference counted resource.
/// Objects implementing this interface can be safely manipulated as shared.
/// Implementing class should mixin atomicRcCode to use the provided implementation.
interface IAtomicRefCounted
{
    /// Atomically loads the number of active references.
    final @property size_t refCount() const {
        return (cast(shared(IAtomicRefCounted))this).refCountShared;
    }
    /// ditto
    shared @property size_t refCountShared() const;

    /// Atomically increment the reference count.
    final void retain() {
        return (cast(shared(IAtomicRefCounted))this).retainShared();
    }
    /// ditto
    void retainShared() shared;

    /// Atomically decrement the reference count.
    /// If refCount reaches zero, and disposeOnZero is set,
    /// the object is locked with its own mutex, and dispose is called.
    /// In most cases, the calling code should set disposeOnZero, unless it
    /// is intended to release the object to give it away.
    /// (such as at the end of a builder function)
    /// Returns: true if the object was disposed during this call, false otherwise.
    final bool release(in Flag!"disposeOnZero" disposeOnZero = Yes.disposeOnZero)
    in {
        assert(
            refCount > 0,
            "inconsistent ref count for "~(cast(Object)this).classinfo.name
        );
    }
    body {
        return (cast(shared(IAtomicRefCounted))this).releaseShared(disposeOnZero);
    }
    /// ditto
    bool releaseShared(in Flag!"disposeOnZero" disposeOnZero = Yes.disposeOnZero) shared
    in {
        assert(
            refCountShared > 0,
            "inconsistent ref count for "~(cast(Object)this).classinfo.name
        );
    }

    /// Returns whether the refCount >= 1.
    /// This increases the refCount by 1. rcLock should be used to keep
    /// weak reference and ensures that the resource is not disposed.
    /// The operation is atomic.
    final bool rcLock()
    out(res) {
        assert(
            (res && refCount >= 2) || (!res && !refCount),
            "inconsistent ref count for "~(cast(Object)this).classinfo.name
        );
    }
    body {
        return (cast(shared(IAtomicRefCounted))this).rcLockShared();
    }
    /// ditto
    shared bool rcLockShared();
    // out(res) {
    //     assert(
    //         (res && refCountShared >= 2) || (!res && !refCountShared),
    //         "inconsistent ref count for "~(cast(Object)this).classinfo.name
    //     );
    // }
    // this contract compiles with dmd but create a failure on ldc2:
    // cannot implicitely convert shared(T) to const(IAtomicRefCounted)

    /// Dispose the underlying resource
    void dispose()
    in { assert(refCount == 0); }
}

/// Abstract class that implements IAtomicRefCounted.
/// Should be used over IAtomicRefCounted when practicable to avoid code
/// duplication in the final executable.
abstract class AtomicRefCounted : IAtomicRefCounted
{
    mixin(atomicRcCode);

    abstract override void dispose();
}

/// compile time check that T can be ref counted atomically.
enum isAtomicRefCounted(T) = is(T : shared(IAtomicRefCounted)) || is(T : IAtomicRefCounted);


/// A string that can be mixed-in a class declaration to implement IAtomicRefCounted.
/// dispose is not implemented of course, but is called by release while the object is locked.
/// Classes implementing it are free to do it in a non-thread safe manner as long
/// as dispose does not manipulate external state.
enum atomicRcCode = sharedAtomicMethods ~ q{
    private size_t _refCount=0;
};

/// Counts the number of references of a single object.
size_t countObj(T)(T obj) if (isAtomicRefCounted!T)
{
    static if (is(T == shared)) {
        return obj.refCountShared;
    }
    else {
        return obj.refCount;
    }
}

/// Retains a single object.
T retainObj(T)(T obj) if (isAtomicRefCounted!T)
{
    static if (is(T == shared)) {
        obj.retainShared();
    }
    else {
        obj.retain();
    }
    return obj;
}

/// Releases and nullify a single object. The object may be null.
/// Returns: whether the object was disposed.
bool releaseObj(T)(ref T obj, in Flag!"disposeOnZero" disposeOnZero = Yes.disposeOnZero)
if (isAtomicRefCounted!T)
{
    if (!obj) return false;

    static if (is(T == shared)) {
        const res = obj.releaseShared(disposeOnZero);
        obj = null;
        return res;
    }
    else {
        const res = obj.release(disposeOnZero);
        obj = null;
        return res;
    }
}

/// Locks a single object.
T lockObj(T)(T obj) if (isAtomicRefCounted!T)
in {
    assert(obj, "locking null object");
}
body {
    static if (is(T == shared)) {
        if (obj.rcLockShared()) {
            return obj;
        }
    }
    else {
        if (obj.rcLock()) {
            return obj;
        }
    }
    return null;
}

/// Decreases the reference count of a single object without disposing it.
/// Use this to move an object out of a scope (typically return at the end of a function)
T giveAwayObj(T)(ref T obj) if (is(T : IAtomicRefCounted))
in {
    assert(obj, "giving away null object");
}
body {
    auto o = obj;
    releaseObj(obj, No.disposeOnZero);
    return o;
}

/// Dispose and nullify a single object, that might be null
void disposeObj(T)(ref T obj) if (is(T : Disposable))
{
    if (obj) {
        obj.dispose();
        obj = null;
    }
}

/// Retain GC allocated array of ref-counted resources
void retainArr(T)(ref T[] arr) if (isAtomicRefCounted!T)
{
    import std.algorithm : each;
    arr.each!(el => retainObj(el));
}

/// Release GC allocated array of ref-counted resources
void releaseArr(T)(ref T[] arr) if (isAtomicRefCounted!T)
{
    import std.algorithm : each;
    arr.each!(el => releaseObj(el));
    arr = null;
}

/// Dispose GC allocated array of resources
void disposeArr(T)(ref T[] arr) if (is(T : Disposable))
{
    import std.algorithm : each;
    arr.each!(el => el.dispose());
    arr = null;
}

/// Retain GC allocated associative array of ref-counted resources
void retainAA(T, K)(ref T[K] arr) if (isAtomicRefCounted!T)
{
    import std.algorithm : each;
    arr.each!((k, el) => retainObj(el));
}
/// Release GC allocated associative array of ref-counted resources
void releaseAA(T, K)(ref T[K] arr) if (isAtomicRefCounted!T)
{
    import std.algorithm : each;
    arr.each!((k, el) => releaseObj(el));
    arr.clear();
    arr = null;
}

/// Dispose GC allocated associative array of resources
void disposeAA(T, K)(ref T[K] arr) if (is(T : Disposable))
{
    import std.algorithm : each;
    arr.each!((k, el) { el.dispose(); });
    arr = null;
}

/// Reinitialises a single struct
/// Useful if the struct release resource in its destructor.
void reinitStruct(T)(ref T t) if (is(T == struct))
{
    t = T.init;
}

/// Reinitialises a GC allocated array of struct.
/// Useful if the struct release resource in its destructor.
void reinitArr(T)(ref T[] arr) if (is(T == struct))
{
    foreach(ref t; arr) {
        t = T.init;
    }
    arr = null;
}
/// Reinitialises a GC allocated associative array of struct.
/// Useful if the struct release resource in its destructor.
void reinitAA(T, K)(ref T[K] arr) if (is(T == struct))
{
    foreach(k, ref t; arr) {
        t = T.init;
    }
    arr.clear();
    arr = null;
}

/// Helper that build a new instance of T and returns it within a Rc!T
template makeRc(T) if (isAtomicRefCounted!T)
{
    Rc!T makeRc(Args...)(Args args)
    {
        return Rc!T(new T(args));
    }
}

/// Helper that places an instance of T within a Rc!T
template rc(T) if (isAtomicRefCounted!T)
{
    Rc!T rc(T obj)
    {
        if (obj) {
            return Rc!T(obj);
        }
        else {
            return (Rc!T).init;
        }
    }
}

/// Produces an Rc!T holding a null object
@property Rc!T nullRc(T)() if (isAtomicRefCounted!T) {
    return Rc!T.init;
}

/// Helper struct that manages the reference count of an object using RAII.
struct Rc(T) if (isAtomicRefCounted!T)
{
    private T _obj;

    /// Build a Rc instance with the provided resource
    this(T obj)
    {
        _obj = obj;
        if (obj) {
            retainObj(_obj);
        }
    }

    /// Postblit adds a reference to the held reference.
    this(this)
    {
        if (_obj) retainObj(_obj);
    }

    /// Removes a reference to the held reference.
    ~this()
    {
        if(_obj) {
            debug {
                import core.exception : InvalidMemoryOperationError;

                try {
                    releaseObj(_obj, Yes.disposeOnZero);
                }
                catch(InvalidMemoryOperationError error)
                {
                    import core.stdc.stdio : stderr, printf;

                    enum fmtString = "InvalidMemoryOperationError thrown when releasing %s."
                        ~ " This is almost certainly due to release during garbage"
                        ~ " collection through field destructor because the object"
                        ~ " was not properly released before.\n";

                    printf(fmtString, T.stringof.ptr);

                    throw error;
                }
            }
            else {
                releaseObj(_obj, Yes.disposeOnZero);
            }
            _obj = null;
        }
    }

    /// Assign another resource. Release the previously held ref and retain the new one.
    void opAssign(T obj)
    {
        if (obj is _obj) return;

        if(_obj) releaseObj(_obj, Yes.disposeOnZero);
        _obj = obj;
        if(_obj) retainObj(_obj);
    }

    /// Check whether this Rc is assigned to a resource.
    bool opCast(T : bool)() const
    {
        return loaded;
    }

    /// Check whether this Rc is assigned to a resource.
    @property bool loaded() const
    {
        return _obj !is null;
    }

    /// Reset the resource.
    void unload()
    {
        if(_obj) {
            releaseObj(_obj);
        }
    }

    /// Decrease the ref count and return the object without calling dispose
    T giveAway()
    in {
        assert(_obj, "giving away invalid object");
    }
    out(obj) {
        assert(obj);
    }
    body {
        auto obj = _obj;
        releaseObj(_obj, No.disposeOnZero);
        return obj;
    }

    /// Access to the held resource.
    @property inout(T) obj() inout { return _obj; }

    alias obj this;
}

/// Helper struct that keeps a weak reference to a Resource.
struct Weak(T) if (is(T : IAtomicRefCounted))
{
    private T _obj;

    /// Build a Weak instance.
    this(T obj)
    {
        _obj = obj;
    }

    /// Reset the internal reference.
    void reset()
    {
        _obj = null;
    }

    /// Check whether the resource has been disposed.
    @property bool disposed() const
    {
        return !_obj || (_obj.refCount == 0);
    }

    /// Return a Rc that contain the underlying resource if it has not been disposed.
    Rc!T lock()
    {
        Rc!T rc;
        rc._obj = _obj ? lockObj(_obj) : null;
        if (!rc._obj) _obj = null;
        return rc;
    }
}

debug(rc) {
    __gshared string rcTypeRegex = ".";
    __gshared bool rcPrintStack = false;
}

private enum sharedAtomicMethods = q{

    import std.typecons : Flag, Yes;
    import std.traits : Unqual;

    debug {
        ~this() {
            // no gc operation allowed during gc pass
            import std.stdio : stderr;
            enum phrase = rcTypeName ~ " was not properly disposed\n";
            if (refCount != 0) {
                stderr.write(phrase);
                stderr.flush();
            }
        }
        enum rcTypeName = Unqual!(typeof(this)).stringof;
    }

    debug(rc) {
        private final shared void rcDebug(Args...)(string fmt, Args args)
        {
            import gfx.core.rc : gfxRcLog, rcPrintStack, rcTypeRegex;
            import gfx.core.util : StackTrace;
            import std.algorithm : min;
            import std.regex : matchFirst;

            if (!matchFirst(rcTypeName, rcTypeRegex)) return;

            gfxRcLog.debugf(fmt, args);
            if (rcPrintStack) {
                const st = StackTrace.obtain(13, StackTrace.Options.all);
                const frames = st.frames.length > 2 ? st.frames[2 .. $] : [];
                foreach (i, f; frames) {
                    gfxRcLog.debugf("  %02d %s", i, f.symbol);
                }
            }
        }
    }


    public final shared override @property size_t refCountShared() const
    {
        import core.atomic : atomicLoad;
        return atomicLoad(_refCount);
    }

    public final shared override void retainShared()
    {
        import core.atomic : atomicOp;
        const rc = atomicOp!"+="(_refCount, 1);
        debug(rc) {
            rcDebug("retain %s: %s -> %s", rcTypeName, rc-1, rc);
        }
    }

    public final shared override bool releaseShared(in Flag!"disposeOnZero" disposeOnZero = Yes.disposeOnZero)
    {
        import core.atomic : atomicOp;
        const rc = atomicOp!"-="(_refCount, 1);

        debug(rc) {
            rcDebug("release %s: %s -> %s", rcTypeName, rc+1, rc);
        }
        if (rc == 0 && disposeOnZero) {
            debug(rc) {
                rcDebug("dispose %s", rcTypeName);
            }
            synchronized(this) {
                // cast shared away
                auto obj = cast(Unqual!(typeof(this)))this;
                obj.dispose();
            }
            return true;
        }
        else {
            return false;
        }
    }

    public final shared override bool rcLockShared()
    {
        import core.atomic : atomicLoad, cas;
        while (1) {
            const c = atomicLoad(_refCount);

            if (c == 0) {
                debug(rc) {
                    rcDebug("rcLock %s: %s", rcTypeName, c);
                }
                return false;
            }
            if (cas(&_refCount, c, c+1)) {
                debug(rc) {
                    rcDebug("rcLock %s: %s", rcTypeName, c+1);
                }
                return true;
            }
        }
    }
};

// private string numberizeCodeLines(string code) {
//     import std.string : splitLines;
//     import std.format : format;
//     string res;
//     auto lines = code.splitLines();
//     foreach (i, l; lines) {
//         res ~= format("%s. %s\n", i+1, l);
//     }
//     return res;
// }

// pragma(msg, numberizeCodeLines(atomicRcCode));

// using version(unittest) instead of private creates link errors
// in test builds in apps/libs depending on gfx-d (??)
private
{
    int rcCount = 0;
    int structCount = 0;

    class RcClass : IAtomicRefCounted
    {
        mixin(atomicRcCode);

        this()
        {
            rcCount += 1;
        }

        override void dispose()
        {
            rcCount -= 1;
        }
    }

    struct RcStruct
    {
        Rc!RcClass obj;
    }

    struct RcArrStruct
    {
        Rc!RcClass[] objs;

        ~this()
        {
            foreach(ref o; objs) {
                o = Rc!RcClass.init;
            }
        }
    }

    struct RcArrIndStruct
    {
        RcStruct[] objs;

        ~this()
        {
            foreach(ref o; objs) {
                o = RcStruct.init;
            }
        }
    }


    unittest
    {
        {
            auto arr = RcArrStruct([makeRc!RcClass(), makeRc!RcClass()]);
            assert(rcCount == 2);
            foreach(obj; arr.objs) {
                assert(rcCount == 2);
            }
            assert(rcCount == 2);
        }
        assert(rcCount == 0);
    }


    unittest
    {
        {
            auto obj = makeRc!RcClass();
            assert(rcCount == 1);
        }
        assert(rcCount == 0);
    }

    unittest
    {
        {
            auto obj = RcStruct(makeRc!RcClass());
            assert(rcCount == 1);
        }
        assert(rcCount == 0);
    }

    unittest
    {
        Weak!RcClass weak;
        {
            auto locked = weak.lock();
            assert(!locked.loaded);
        }
        {
            auto rc = makeRc!RcClass();
            assert(rcCount == 1);
            assert(rc.refCount == 1);
            weak = Weak!RcClass(rc);
            assert(rc.refCount == 1);
            {
                auto locked = weak.lock();
                assert(locked.loaded);
                assert(rc.refCount == 2);
            }
            assert(rc.refCount == 1);
        }
        assert(rcCount == 0);
        assert(weak.disposed);
        {
            auto locked = weak.lock();
            assert(!locked.loaded);
        }
    }
}
