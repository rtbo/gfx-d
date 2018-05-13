module gfx.decl.store;

import gfx.core.rc : AtomicRefCounted, Disposable;
import std.variant : Algebraic;

class NoSuchKeyException : Exception
{
    string key;

    private this(in string key, in Store store)
    {
        import std.format : format;
        super(format("no such key in %s store: %s", store, key));
    }
}

// class WrongTypeException : Exception
// {
//     string type;
//     string key;

// }

class DeclarativeStore : Disposable
{
    private AtomicRefCounted[string] _rcStore;
    private Variant[string] _valueStore;
    private Object[string] _objStore; // any class, including ObjectValue!T

    T store(T)(in string key, T value) {
        enum store = storeOf!T;
        static if (store == Store.rc) {
            value.retain();
            auto former = key in _rcStore;
            if (former) {
                former.release();
                *former = value;
            }
            else {
                _rcStore[key] = value;
            }
        }
        else static if (store == Store.value) {
            _valueStore[key] = value;
        }
        else static if (store == Store.obj && is(T : Object)) {
            static assert(!is(T : Disposable));
            assert(!cast(Disposable)value);
            _objStore[key] = value;
        }
        else static if (store == Store.obj && !is(T : Object)) {
            _objStore[key] = new ValueObject!T(value);
        }
        else static assert(false);
        return value;
    }

    T expect(T)(in string key)
    {
        enum store = storeOf!T;
        static if (store == Store.rc) {
            auto val = key in _rcStore;
            if (val) {
                auto t = cast(T)*val;
                if (t) return t;
            }
        }
        else static if (store == Store.value) {
            auto val = key in _valueStore;
            if (val) return *val;
        }
        else static if (store == Store.obj) {
            auto val = key in _objStore;
            if (val) {
                static if (is(T : Object)) {
                    return cast(T)(*val);
                }
                else {
                    import gfx.core.util : unsafeCast;
                    auto vo = unsafeCast!(ValueObject!T)(*val);
                    return vo.payload;
                }
            }
        }
        else static assert(false);
        throw new NoSuchKeyException(key, store);
    }

    T get(T)(in string key, T def=T.init)
    {
        enum store = storeOf!T;
        static if (store == Store.rc) {
            auto val = key in _rcStore;
            if (val) return *val;
        }
        else static if (store == Store.value) {
            auto val = key in _valueStore;
            if (val) return *val;
        }
        else static if (store == Store.obj) {
            auto val = key in _objStore;
            if (val) {
                static if (is(T : Object)) {
                    return cast(T)(*val);
                }
                else {
                    import gfx.core.util : unsafeCast;
                    auto vo = unsafeCast!(ValueObject!T)(*val);
                    return vo.payload;
                }
            }
        }
        else static assert(false);
        return def;
    }

    bool remove(in string key)
    {
        bool[3] found;

        auto rc = key in _rcStore;
        if (rc) {
            rc.release();
            _rcStore.remove(key);
            found[0] = true;
        }

        found[1] = _valueStore.remove(key);
        found[2] = _objStore.remove(key);

        return found[0] || found[1] || found[2];
    }

    override void dispose() {
        import gfx.core.rc : releaseArray;
        releaseArray(_rcStore);
        _valueStore.clear();
        _objStore.clear();
    }

}

private:

alias Variant = Algebraic!(int, uint, long, ulong, float, double);

enum fitsVariant(T) = Variant.allowed!T;

enum Store {
    rc, value, obj,
}

template storeOf(T)
{
    static if (is(T : AtomicRefCounted)) {
        enum storeOf = Store.rc;
    }
    else static if (fitsVariant!T) {
        enum storeOf = Store.value;
    }
    else {
        enum storeOf = Store.obj; // either class, interface or ObjectValue
    }
}

enum needValueObject(T) = (storeOf!T == Store.obj) && !is(T : Object);

class ValueObject(T) {
    T payload;
    this(T payload) {
        this.payload = payload;
    }
}
