module gfx.core.rc;

import std.format : format;
import std.traits : fullyQualifiedName;


interface RefCounted {
    // the reference count
    @property int refCount() const
    out(res) { assert(res >= 0); }

    // increment the reference count
    void addRef();

    // decrement the reference count
    // and call `drop` if it reaches zero
    void release();

    // drop the underlying resource
    void drop()
    in { assert(refCount == 0); }
}


public enum rcCode = buildRcCode();



Rc!T makeRc (T, Args...)(Args args) if (is(T:RefCounted)) {
    return Rc!T(new T(args));
}

Rc!T rc (T)(T obj) if (is(T:RefCounted)) {
    return Rc!T(obj);
}


template Rc(T) if (is(T:RefCounted)) {

    struct Rc {
        private T _obj;

        this(T obj) {
            assert(obj !is null);
            _obj = obj;
            _obj.addRef();
        }

        this(this) {
            if (_obj) _obj.addRef();
        }

        ~this() {
            if(_obj) _obj.release();
        }

        void opAssign(T obj) {
            if(_obj) _obj.release();
            _obj = obj;
            if(_obj) _obj.addRef();
        }

        bool opCast(T : bool)() const {
            return loaded;
        }

        @property bool loaded() const {
            return _obj !is null;
        }

        void unload() {
            if(_obj) {
                _obj.release();
                _obj = null;
            }
        }

        @property inout(T) obj() inout { return _obj; }

        alias obj this;

    }

}


private string buildRcCode() {
    version(rcAtomic) {
        enum lockFree = "
            private shared int _refCount=0;

            public @property int refCount() const {
                import core.atomic : atomicLoad;
                return atomicLoad(_refCount);
            }

            public void addRef() {
                import core.atomic : cas;
                int oldRc = void;
                do {
                    oldRc = _refCount;
                }
                while(!cas(&_refCount, oldRc, oldRc+1));
                version(rcDebug) {
                    import std.stdio : writefln;
                    writefln(\"addRef %s: %s\", typeof(this).stringof, oldRc+1);
                }
            }

            public void release() {
                import core.atomic : cas;
                int oldRc = void;
                do {
                    oldRc = _refCount;
                }
                while(!cas(&_refCount, oldRc, oldRc-1));
                version(rcDebug) {
                    import std.stdio : writefln;
                    writefln(\"release %s: %s\", typeof(this).stringof, oldRc-1);
                }
                if (oldRc == 1) {
                    version(rcDebug) {
                        import std.stdio : writefln;
                        writefln(\"drop %s\", typeof(this).stringof);
                    }
                    drop();
                }
            }";
        return lockFree;
    }
    else {
        return "
            private int _refCount=0;

            public @property int refCount() const { return _refCount; }

            public void addRef() {
                _refCount += 1;
                version(rcDebug) {
                    import std.stdio : writefln;
                    writefln(\"addRef %s: %s\", typeof(this).stringof, refCount);
                }
            }

            public void release() {
                _refCount -= 1;
                version(rcDebug) {
                    import std.stdio : writefln;
                    writefln(\"release %s: %s\", typeof(this).stringof, refCount);
                }
                if (!refCount) {
                    version(rcDebug) {
                        import std.stdio : writefln;
                        writefln(\"drop %s\", typeof(this).stringof);
                    }
                    drop();
                }
            }";
    }
}


version(unittest) {

    import std.stdio : writeln;

    int rcCount = 0;
    int structCount = 0;

    class RcClass : RefCounted {
        mixin(rcCode);

        this() {
            rcCount += 1;
        }

        void drop() {
            rcCount -= 1;
        }
    }

    struct RcStruct {
        Rc!RcClass obj;
    }

    struct RcArrStruct {
        Rc!RcClass[] objs;

        ~this() {
            foreach(ref o; objs) {
                o = Rc!RcClass.init;
            }
        }
    }

    struct RcArrIndStruct {
        RcStruct[] objs;

        ~this() {
            foreach(ref o; objs) {
                o = RcStruct.init;
            }
        }
    }

    unittest {
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


    unittest {
        {
            auto obj = makeRc!RcClass();
            assert(rcCount == 1);
        }
        assert(rcCount == 0);
    }

    unittest {
        {
            auto obj = RcStruct(makeRc!RcClass());
            assert(rcCount == 1);
        }
        assert(rcCount == 0);
    }
}


template isRuntimeRc(T) {
    enum isRuntimeRc = is(T : RefCounted) &&
            (is(T == class) || is(T == interface));
}

static assert(isRuntimeRc!RefCounted);

// static Rc interface purpose is to store
// RefCounted object into structs and recursively
// call addRef() or release()
template isStaticRc(T) {
    enum isStaticRc =
        is(T == struct) &&
        is(typeof((inout int = 0) {
            T t = T.init;
            t.membersAddRef();
            t.membersRelease();
        }));
}

static assert(!isStaticRc!RefCounted);


/// evaluates to true if T isStaticRc or isRuntimeRc, but is
/// not wrapped by Rc!T
template isNakedRc(T) {
    enum isNakedRc = isStaticRc!T || isRuntimeRc!T;
}

static assert(!isNakedRc!(Rc!RefCounted));


/// evaluates to true if T isStaticRc or isRuntimeRc, whether or not
/// wrapped by Rc!T
template isRc(T) {
    enum isRc = isNakedRc!T || is(T == Rc!U, U);
}



public mixin template RcMembersRecursCode(RcMembers...) {

    static assert(RcMembers.length != 0);
    static assert(is(typeof(this) == struct));

    private bool owns_ = false;

    this(this) {
        membersAddRef();
    }
    ~this() {
        if(owns_) membersRelease();
    }

    public void membersAddRef() {
        import std.format : format;
        assert(!owns_);
        foreach(m; RcMembers) {
            mixin(format("alias MembT = typeof(%s);", m));
            mixin(RcRecursCode!(MembT, m, RcAddRefCode));
        }
        owns_ = true;
    }


    public void membersRelease() {
        import std.format : format;
        assert(owns_);
        foreach(m; RcMembers) {
            mixin(format("alias MembT = typeof(%s);", m));
            mixin(RcRecursCode!(MembT, m, RcReleaseCode));
        }
        owns_ = false;
    }
}

public mixin template RcMembersDropCode(RcMembers...) {
    static assert(RcMembers.length != 0);
    static assert(is(typeof(this) == class));

    void drop() {
        import std.format : format;
        foreach(m; RcMembers) {
            mixin(format("alias MembT = typeof(%s);", m));
            mixin(RcRecursCode!(MembT, m, RcReleaseCode));
        }
    }
}


template RcRecursCode(MembT, string m, alias Code) {

    static if(isNakedRc!MembT) {
        enum RcRecursCode = Code!(MembT, m);
    }
    else static if(is(MembT == T[], T)) {
        static assert(isNakedRc!T);
        enum RcRecursCode =
            format("foreach(el; %s) {", m) ~
            Code!(T, "el") ~
            format("}");
    }
    else static if(is(MembT == T[N], T, size_t N)) {
        static assert(isNakedRc!T);
        enum RcRecursCode =
            format("foreach(el; %s[]) {", m) ~
            Code!(T, "el") ~
            format("}");
    }
    else static if(is(MembT == T[K], T, K)) {
        static assert(isNakedRc!T);
        enum RcRecursCode =
            format("foreach(k, el; %s) {", m) ~
            Code!(T, "el") ~
            format("}");
    }
    else {
        static assert(false, m~" is not compatible with RcCode");
    }
}



template RcAddRefCode(T, string m) {
    static if(isRuntimeRc!T) {
        enum RcAddRefCode = format("if(%s) %s.addRef();", m, m);
    }
    else static if (isStaticRc!T) {
        enum RcAddRefCode = format("%s.membersAddRef();", m);
    }
    else { static assert(false); }
}


template RcReleaseCode(T, string m) {
    static if(isRuntimeRc!T) {
        enum RcReleaseCode = format("if(%s) %s.release();", m, m);
    }
    else static if (isStaticRc!T) {
        enum RcReleaseCode = format("%s.membersRelease();", m);
    }
    else { static assert(false); }
}

