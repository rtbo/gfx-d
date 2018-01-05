/// Reference counting module
module gfx.core.rc;

/// definition of how the gfx package itself implements reference counting
version(GfxRcAtomic)
{
    alias GfxRefCounted = AtomicRefCounted;
    enum gfxRcCode = atomicRcCode;
}
else version(GfxRcMixed)
{
    alias GfxRefCounted = AtomicRefCounted;
    enum gfxRcCode = mixedRcCode;
}
else {
    alias GfxRefCounted = RefCounted;
    enum gfxRcCode = rcCode;
}


/// A resource that can be disposed
interface Disposable
{
    /// Dispose the underlying resource
    void dispose();
}

/// A non-atomic reference counted resource.
/// Objects implementing this interface should have exterior locking if used
/// as shared.
interface RefCounted : Disposable
{
    /// The number of active references
    @property size_t refCount() const;

    /// Increment the reference count.
    void retain();

    /// Decrement the reference count and dispose if it reaches zero.
    void release()
    in { assert(refCount > 0); }

    /// Get a copy of this RefCounted instance if the refCount >= 1.
    /// This increases the refCount by 1. This should only be used to keep
    /// weak reference and ensures that the resource is not disposed.
    RefCounted rcLock()
    out(res) { assert((res && refCount >= 2) || (!res && !refCount)); }

    override void dispose()
    in { assert(refCount == 0); } // add this additional contract
}

/// A atomic reference counted resource.
/// Objects implementing this interface can be safely used as shared.
///
/// Important note: AtomicRefCounted extends RefCounted (non-atomic).
/// If it is implemented using mixedRcCode, then the following statements apply
///   - When the object is shared, the atomic reference count is used.
///   - When the object is not shared, the non-atomic reference count is used.
///
/// Although this sounds neat, it makes certain things quite difficult to implement
/// Eg. having some rc in a parallel loop. (parallel spawns threads without any guard or lock
/// - see the gfx-d:shadow example)
/// For that reason, the atomicRcCode enum is available that implements both
/// RefCounted and AtomicRefCounted atomically.
interface AtomicRefCounted : RefCounted
{
    /// Atomically load the number of active references.
    shared @property size_t refCount() const;

    /// Atomically increment the reference count.
    shared void retain();

    /// Atomically decrement the reference count and dispose if it reaches zero.
    /// The object is locked using its own mutex when dispose is called.
    shared void release()
    in { assert(refCount > 0); }

    /// Get a copy of this RefCounted instance if the refCount >= 1.
    /// This increases the refCount by 1. This should only be used to keep
    /// weak reference and ensures that the resource is not disposed.
    /// The operation is atomic.
    shared shared(AtomicRefCounted) rcLock();
    // out(res) {
    //     assert((res && this.refCount >= 1) || (!res && !this.refCount));
    // }
    // this contract create a failure on ldc2:
    // cannot implicitely convert shared(T) to const(AtomicRefCounted)
}

/// compile time check that T can be ref counted non-atomically.
enum isNonAtomicRefCounted(T) = is(T : RefCounted) && !is(T == shared);
/// compile time check that T can be ref counted atomically.
enum isAtomicRefCounted(T) = is(T : shared(AtomicRefCounted));
/// compile time check that T can be ref counted (either shared or not)
enum isRefCounted(T) = isNonAtomicRefCounted!T || isAtomicRefCounted!T;


/// A string that can be mixed-in a class declaration to implement RefCounted.
enum rcCode = nonSharedNonAtomicMethods ~ q{
    private size_t _refCount=0;
};

/// A string that can be mixed-in a class declaration to implement AtomicRefCounted.
/// The RefCounted methods (non-shared) are implemented without atomicity.
/// The AtomicRefCounted methods (shared) are implemented atomically.
enum mixedRcCode = nonSharedNonAtomicMethods ~ sharedAtomicMethods ~ q{
    private size_t _refCount=0;
};

/// A string that can be mixed-in a class declaration to implement AtomicRefCounted.
/// Both shared and non-shared methods are implemented atomically.
/// This is useful for things such as a parallel loop
enum atomicRcCode = nonSharedAtomicMethods ~ sharedAtomicMethods ~ q{
    private shared size_t _refCount=0;
};

/// Dispose GC allocated array of resources
void disposeArray(T)(ref T[] arr) if (is(T : Disposable) && !isRefCounted!T)
{
    import std.algorithm : each;
    arr.each!(el => el.dispose());
    arr = null;
}

/// Dispose GC allocated associative array of resources
void disposeArray(T, K)(ref T[K] arr) if (is(T : Disposable) && !isRefCounted!T)
{
    import std.algorithm : each;
    arr.each!((k, el) { el.dispose(); });
    arr = null;
}

/// Cast hack to get around a bug in DMD front-end.
/// Cast non shared atomic rc interfaces when calling retain or release.
/// See https://issues.dlang.org/show_bug.cgi?id=18138
template RcHack(T) if (isRefCounted!T) {
    static if (is(T == interface) && is(T : AtomicRefCounted) && !is(T == shared)) {
        alias RcHack = RefCounted;
    }
    else {
        alias RcHack = T;
    }
}

/// Retain GC allocated array of ref-counted resources
void retainArray(T)(ref T[] arr) if (isRefCounted!T)
{
    import std.algorithm : each;
    arr.each!(el => (cast(RcHack!T)el).retain());
}
/// Retain GC allocated associative array of ref-counted resources
void retainArray(T, K)(ref T[K] arr) if (isRefCounted!T)
{
    import std.algorithm : each;
    arr.each!((k, el) { (cast(RcHack!T)el).retain(); });
}

/// Release GC allocated array of ref-counted resources
void releaseArray(T)(ref T[] arr) if (isRefCounted!T)
{
    import std.algorithm : each;
    arr.each!(el => (cast(RcHack!T)el).release());
    arr = null;
}
/// Release GC allocated associative array of ref-counted resources
void releaseArray(T, K)(ref T[K] arr) if (isRefCounted!T)
{
    import std.algorithm : each;
    arr.each!((k, el) { (cast(RcHack!T)el).release(); });
    arr = null;
}

/// Reinitialises a GC allocated array of struct.
/// Useful if the struct release resource in its destructor.
void reinitArray(T)(ref T[] arr) if (is(T == struct))
{
    foreach(ref t; arr) {
        t = T.init;
    }
    arr = null;
}
/// Reinitialises a GC allocated associative array of struct.
/// Useful if the struct release resource in its destructor.
void reinitArray(T, K)(ref T[K] arr) if (is(T == struct))
{
    foreach(k, ref t; arr) {
        t = T.init;
    }
    arr = null;
}

/// Helper that build a new instance of T and returns it within a Rc!T
template makeRc(T) if (isRefCounted!T)
{
    Rc!T makeRc(Args...)(Args args)
    {
        return Rc!T(new T(args));
    }
}

/// Helper that places an instance of T within a Rc!T
template rc(T) if (isRefCounted!T)
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

@property Rc!T nullRc(T)() if (isRefCounted!T) {
    return Rc!T.init;
}

/// Helper struct that manages the reference count of an object using RAII.
struct Rc(T) if (isRefCounted!T)
{
    private T _obj;

    private alias HackT = RcHack!T;

    /// Build a Rc instance with the provided resource
    this(T obj)
    {
        _obj = obj;
        if (obj) {
            (cast(HackT)_obj).retain();
        }
    }

    /// Postblit adds a reference to the held reference.
    this(this)
    {
        if (_obj) (cast(HackT)_obj).retain();
    }

    /// Removes a reference to the held reference.
    ~this()
    {
        if(_obj) (cast(HackT)_obj).release();
    }

    /// Assign another resource. Release the previously held ref and retain the new one.
    void opAssign(T obj)
    {
        if(_obj) (cast(HackT)_obj).release();
        _obj = obj;
        if(_obj) (cast(HackT)_obj).retain();
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
            (cast(HackT)_obj).release();
            _obj = null;
        }
    }

    /// Access to the held resource.
    @property inout(T) obj() inout { return _obj; }

    alias obj this;
}

/// Helper struct that keeps a weak reference to a Resource.
struct Weak(T) if (is(T : Disposable))
{
    private T _obj;
    static if (is(T == interface) && is(T : AtomicRefCounted) && !is(T == shared)) {
        // see https://issues.dlang.org/show_bug.cgi?id=18138
        private alias HackT = RefCounted;
    }
    else {
        private alias HackT = T;
    }

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
        rc._obj = _obj ? cast(T)((cast(HackT)_obj).rcLock()) : null;
        if (!rc._obj) _obj = null;
        return rc;
    }
}

private enum nonSharedNonAtomicMethods = q{

    public final override @property size_t refCount() const { return _refCount; }

    public final override void retain()
    {
        _refCount += 1;
        debug(rc) {
            import std.experimental.logger : tracef;
            tracef("retain %s: %s", typeof(this).stringof, refCount);
        }
    }

    public final override void release()
    {
        _refCount -= 1;
        debug(rc) {
            import std.experimental.logger : tracef;
            tracef("release %s: %s", typeof(this).stringof, refCount);
        }
        if (!_refCount) {
            debug(rc) {
                import std.experimental.logger : tracef;
                tracef("dispose %s", typeof(this).stringof);
            }
            dispose();
        }
    }

    public final override typeof(this) rcLock()
    {
        if (_refCount) {
            ++_refCount;
            debug(rc) {
                import std.experimental.logger : tracef;
                tracef("rcLock %s: %s", typeof(this).stringof, _refCount);
            }
            return this;
        }
        else {
            debug(rc) {
                import std.experimental.logger : tracef;
                tracef("rcLock %s: %s", typeof(this).stringof, _refCount);
            }
            return null;
        }
    }
};

private enum nonSharedAtomicMethods = q{

    public final override @property size_t refCount() const
    {
        import core.atomic : atomicLoad;
        return atomicLoad(_refCount);
    }

    public final override void retain()
    {
        import core.atomic : atomicOp;
        immutable rc = atomicOp!"+="(_refCount, 1);
        debug(rc) {
            import std.experimental.logger : logf;
            logf("retain %s: %s", typeof(this).stringof, rc);
        }
    }

    public final override void release()
    {
        import core.atomic : atomicOp;
        immutable rc = atomicOp!"-="(_refCount, 1);

        debug(rc) {
            import std.experimental.logger : logf;
            logf("release %s: %s", typeof(this).stringof, rc);
        }
        if (rc == 0) {
            debug(rc) {
                import std.experimental.logger : logf;
                logf("dispose %s", typeof(this).stringof);
            }
            synchronized(this) {
                this.dispose();
            }
        }
    }

    public final override typeof(this) rcLock()
    {
        import core.atomic : atomicLoad, cas;
        while (1) {
            immutable c = atomicLoad(_refCount);

            if (c == 0) {
                debug(rc) {
                    logf("rcLock %s: %s", typeof(this).stringof, c);
                }
                return null;
            }
            if (cas(&_refCount, c, c+1)) {
                debug(rc) {
                    logf("rcLock %s: %s", typeof(this).stringof, c+1);
                }
                return this;
            }
        }
    }
};

private enum sharedAtomicMethods = q{

    public final shared override @property size_t refCount() const
    {
        import core.atomic : atomicLoad;
        return atomicLoad(_refCount);
    }

    public final shared override void retain()
    {
        import core.atomic : atomicOp;
        immutable rc = atomicOp!"+="(_refCount, 1);
        debug(rc) {
            import std.experimental.logger : logf;
            logf("retain %s: %s", typeof(this).stringof, rc);
        }
    }

    public final shared override void release()
    {
        import core.atomic : atomicOp;
        immutable rc = atomicOp!"-="(_refCount, 1);

        debug(rc) {
            import std.experimental.logger : logf;
            logf("release %s: %s", typeof(this).stringof, rc);
        }
        if (rc == 0) {
            debug(rc) {
                import std.experimental.logger : logf;
                logf("dispose %s", typeof(this).stringof);
            }
            synchronized(this) {
                import std.traits : Unqual;
                // cast shared away
                auto obj = cast(Unqual!(typeof(this)))this;
                obj.dispose();
            }
        }
    }

    public final shared override shared(typeof(this)) rcLock()
    {
        import core.atomic : atomicLoad, cas;
        while (1) {
            immutable c = atomicLoad(_refCount);

            if (c == 0) {
                debug(rc) {
                    logf("rcLock %s: %s", typeof(this).stringof, c);
                }
                return null;
            }
            if (cas(&_refCount, c, c+1)) {
                debug(rc) {
                    logf("rcLock %s: %s", typeof(this).stringof, c+1);
                }
                return this;
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

    class RcClass : RefCounted
    {
        mixin(rcCode);

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
