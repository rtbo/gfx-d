module gfx.decl.store;

import gfx.core.rc : IAtomicRefCounted, Disposable;
import gfx.graal.format : Format;
import std.variant : Algebraic;

class NoSuchKeyException : Exception
{
    string key;

    private this(in string key, in Store store)
    {
        import std.format : format;
        this.key = key;
        super(format("no such key in %s store: %s", store, key));
    }
}

class WrongTypeException : Exception
{
    string type;
    string key;

    private this(in string type, in string key, in Store store)
    {
        import std.format : format;
        this.type = type;
        this.key = key;
        super(format("key \"%s\" in store %s did not find the expected type: %s", key, store, type));
    }
}

class DeclarativeStore : Disposable
{
    private IAtomicRefCounted[string] _rcStore;
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
        T val = void;
        if (tryLookUp!(T, store)(key, val)) {
            return val;
        }
        else {
            throw new NoSuchKeyException(key, store);
        }
    }

    T get(T)(in string key, T def=T.init)
    {
        enum store = storeOf!T;
        T val = void;
        if (tryLookUp!(T, store)(key, val)) {
            return val;
        }
        else {
            return def;
        }
    }

    private bool tryLookUp(T, Store store)(in string key, out T val)
    {
        static if (store == Store.rc) {
            auto pval = key in _rcStore;
            if (pval) {
                val = cast(T)(*pval);
                if (val) return true;
                else throw new WrongTypeException(T.stringof, key, store);
            }
        }
        else static if (store == Store.value) {
            auto pval = key in _valueStore;
            if (pval) {
                if (pval.convertsTo!T) {
                    val = pval.get!T();
                    return true;
                }
                else throw new WrongTypeException(T.stringof, key, store);
            }
        }
        else static if (store == Store.obj) {
            auto pval = key in _objStore;
            if (pval) {
                static if (is(T : Object)) {
                    val = cast(T)(*pval);
                    if (val) return true;
                }
                else {
                    auto vo = cast(ValueObject!T)(*pval);
                    if (vo) {
                        val = vo.payload;
                        return true;
                    }
                }
                throw new WrongTypeException(T.stringof, key, store);
            }
        }
        else static assert(false);
        return false;
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
        import gfx.core.rc : releaseAA;
        releaseAA(_rcStore);
        _valueStore.clear();
        _objStore.clear();
    }

}

private:

alias Variant = Algebraic!(int, uint, long, ulong, float, double, Format);

enum fitsVariant(T) = Variant.allowed!T;

enum Store {
    rc, value, obj,
}

template storeOf(T)
{
    static if (is(T : IAtomicRefCounted)) {
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
