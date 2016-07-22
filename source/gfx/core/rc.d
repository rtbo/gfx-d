module gfx.core.rc;

import std.format : format;
import std.traits : fullyQualifiedName;


interface RefCounted {
    // the reference count
    @property int rc() const
    out(res) { assert(res >= 0); }

    // increment the reference count
    void addRef();

    // decrement the reference count
    // and call `drop` if it reaches zero
    void release();

    // drop the underlying resource
    void drop()
    in { assert(rc == 0); }
}


enum rcCode = "
    private int rc_=0;

    public @property int rc() const { return rc_; }

    public void addRef() {
        rc_ += 1;
    }

    public void release() {
        rc_ -= 1;
        if (!rc_) {
            drop();
        }
    }";


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

