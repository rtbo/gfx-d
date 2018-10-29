/// Reference counting module
module gfx.core.rc;

import std.typecons : Flag, No, Yes;

/// A resource that can be disposed
interface Disposable
{
    /// Dispose the underlying resource
    void dispose();
}

/// A atomic reference counted resource.
/// Objects implementing this interface can be safely manipulated as shared.
interface AtomicRefCounted
{
    /// Atomically loads the number of active references.
    final @property size_t refCount() const {
        return (cast(shared(AtomicRefCounted))this).refCountShared;
    }
    /// ditto
    shared @property size_t refCountShared() const;

    /// Atomically increment the reference count.
    final void retain() {
        return (cast(shared(AtomicRefCounted))this).retainShared();
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
        return (cast(shared(AtomicRefCounted))this).releaseShared(disposeOnZero);
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
        return (cast(shared(AtomicRefCounted))this).rcLockShared();
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
    // cannot implicitely convert shared(T) to const(AtomicRefCounted)

    /// Dispose the underlying resource
    void dispose()
    in { assert(refCount == 0); }
}

/// compile time check that T can be ref counted atomically.
enum isAtomicRefCounted(T) = is(T : shared(AtomicRefCounted)) || is(T : AtomicRefCounted);


/// A string that can be mixed-in a class declaration to implement AtomicRefCounted.
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
/// Use this to move an object out of a scope (typically return at the end of a return function)
T giveAwayObj(T)(ref T obj) if (is(T : AtomicRefCounted))
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
            releaseObj(_obj, Yes.disposeOnZero);
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
struct Weak(T) if (is(T : AtomicRefCounted))
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

    debug(rc) {
        private final shared @property string rcTypeName()
        {
            import std.traits : Unqual;

            return Unqual!(typeof(this)).stringof;
        }

        private final shared void rcDebug(Args...)(string fmt, Args args)
        {
            import gfx.core.log : debugf;
            import gfx.core.rc : rcPrintStack, rcTypeRegex;
            import gfx.core.util : StackTrace;
            import std.algorithm : min;
            import std.regex : matchFirst;

            if (!matchFirst(rcTypeName, rcTypeRegex)) return;

            debugf("RC", fmt, args);
            if (rcPrintStack) {
                const st = StackTrace.obtain(13, StackTrace.Options.all);
                const frames = st.frames.length > 2 ? st.frames[2 .. $] : [];
                foreach (i, f; frames) {
                    debugf("RC", "  %02d %s", i, f.symbol);
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
                import std.traits : Unqual;
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

    class RcClass : AtomicRefCounted
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

static if(false)
{
    /// Creates a new instance of $(D T) and returns it under a $(D Uniq!T).
    template makeUniq(T)
    if (is(T : Disposable))
    {
        Uniq!T makeUniq(Args...)(Args args)
        {
            return Uniq!T(new T (args));
        }
    }

    debug(Uniq)
    {
        import std.stdio;
    }

    /// A helper struct that manage the lifetime of a Disposable using RAII.
    /// Note: dlang has capability to enforce a parameter be a lvalue (ref param)
    /// but has no mechanism such as c++ rvalue reference which would enforce
    /// true uniqueness by the compiler. Uniq gives additional robustness, but it is
    /// up to the programmer to make sure that the values passed in by rvalue are
    /// not referenced somewhere else in the code
    struct Uniq(T)
    if (is(T : Disposable) && !hasMemberFunc!(T, "release"))
    {
        private T _obj;
        alias Resource = T;

        // prevent using Uniq with Refcounted
        // (invariant handles runtime polymorphism)
        static assert(!is(T : RefCounted), "Use Rc helper for RefCounted objects");
        invariant()
        {
            // if obj is assigned, it must not cast to a RefCounted
            assert(!_obj || !(cast(RefCounted)_obj), "Use Rc helper for RefCounted objects");
        }

        /// Constructor taking rvalue. Uniqueness is achieve only if there is no
        /// aliases of the passed reference.
        this(T obj)
        {
            debug(Uniq)
            {
                writefln("build a Uniq!%s from rvalue", T.stringof);
            }
            _obj = obj;
        }

        /// Constructor taking lvalue. Uniqueness is achieve only if there is no
        /// other copies of the passed reference.
        this(ref T obj)
        {
            debug(Uniq)
            {
                writefln("build a Uniq!%s from lvalue", T.stringof);
            }
            _obj = obj;
            obj = null;
        }

        /// Constructor that take a rvalue.
        /// $(D u) can only be a rvalue because postblit is disabled.
        this(U)(Uniq!U u)
        if (is(U : T))
        {
            debug(Uniq)
            {
                writefln("cast building a Uniq from rvalue from %s to %s",
                    U.stringof, T.stringof
                );
            }
            _obj = u._obj;
        }

        /// Transfer ownership from a Uniq of a type that is convertible to our type.
        /// $(D u) can only be a rvalue because postblit is disabled.
        void opAssign(U)(Uniq!U u)
        if (is(U : T))
        {
            debug(Uniq)
            {
                writefln("opAssign a Uniq from rvalue from %s to %s",
                    U.stringof, T.stringof
                );
            }
            if (_obj)
            {
                _obj.dispose();
            }
            _obj = u._obj;
            u._obj = null;
        }

        /// Shortcut to assigned
        bool opCast(U : bool)() const
        {
            return assigned;
        }

        /// Destructor that disposes the resource.
        ~this()
        {
            debug(Uniq)
            {
                writefln("dtor of Uniq!%s", T.stringof);
            }
            dispose();
        }

        /// A view on the underlying object.
        @property inout(T) obj() inout
        {
            return _obj;
        }

        /// Forwarding method calls and member access to the underlying object.
        alias obj this;

        /// Transfer the ownership.
        Uniq release()
        {
            debug(Uniq)
            {
                writefln("release of Uniq!%s", T.stringof);
            }
            auto u = Uniq(_obj);
            assert(_obj is null);
            return u;
        }

        /// Explicitely ispose the underlying resource.
        void dispose()
        {
            // Same method than Disposeable on purpose as it disables alias this.
            // One cannot shortcut Uniq to dispose the resource.
            if (_obj)
            {
                debug(Uniq)
                {
                    writefln("dispose of Uniq!%s", T.stringof);
                }
                _obj.dispose();
                _obj = null;
            }
        }

        /// Checks whether a resource is assigned.
        bool assigned() const
        {
            return _obj !is null;
        }

        // disable copying
        @disable this(this);
    }

    version(unittest)
    {
        private int disposeCount;

        private class UniqTest : Disposable
        {
            override void dispose()
            {
                disposeCount += 1;
            }
        }

        private Uniq!UniqTest produce1()
        {
            auto u = makeUniq!UniqTest();
            // Returning without release is fine?
            // It compiles and passes the test, but not recommended.
            // return u;
            return u.release();
        }

        private Uniq!UniqTest produce2()
        {
            return makeUniq!UniqTest();
        }

        private void consume(Uniq!UniqTest /+u+/)
        {
        }

        unittest
        {
            disposeCount = 0;
            auto u = makeUniq!UniqTest();
            assert(disposeCount == 0);
            static assert (!__traits(compiles, consume(u)));
            consume(u.release());
            assert(disposeCount == 1);

            {
                auto v = makeUniq!UniqTest();
            }
            assert(disposeCount == 2);

            consume(produce1());
            assert(disposeCount == 3);

            consume(produce2());
            assert(disposeCount == 4);

            auto w = makeUniq!UniqTest();
            w.dispose();
            assert(disposeCount == 5);
        }
    }

    private template hasMemberFunc(T, string fun)
    {
        enum bool hasMemberFunc = is(typeof(
        (inout int = 0)
        {
            T t = T.init;
            mixin("t."~fun~"();");
        }));
    }

    static assert(hasMemberFunc!(RefCounted, "retain"));
    static assert(hasMemberFunc!(Disposable, "dispose"));
    static assert(!hasMemberFunc!(Disposable, "release"));
}
