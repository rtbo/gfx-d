module gfx.graal.memory;

import gfx.core.rc;
import gfx.graal.device;

/// Properties of memory allocated by the device
enum MemProps {
    none            = 0x00,
    /// Memory resides on the device.
    deviceLocal     = 0x01,
    /// Memory is visible from cpu and therefore mappable.
    hostVisible     = 0x02,
    /// Memory seen from cpu is coherent with device memory.
    hostCoherent    = 0x04,
    /// Memory is cached on host. read/write is very fast, but flush operation is necessary after writing.
    hostCached      = 0x08,
    lazilyAllocated = 0x10,
}

/// Structure representing all heaps and types of memory from a device.
/// A device can have different heaps each supporting different types.
struct MemoryProperties {
    MemoryHeap[] heaps;
    MemoryType[] types;
}

struct MemoryHeap {
    size_t size;
    bool deviceLocal;
}

struct MemoryType {
    MemProps props;
    uint heapIndex;
}

struct MemoryRequirements {
    /// minimal allocation requirement
    size_t size;
    /// alignment required when binding the resource to a memory with offset
    size_t alignment;
    /// mask where each bit is set if the corresponding memory type is supported.
    /// For example if the resource supports types 0 and 2 from MemoryProperties,
    /// memTypeMask will be 00000101
    uint memTypeMask;
}

/// Holds a memory mapping to host visible memory.
/// Memory is unmapped when object goes out of scope.
/// It also acts as a void[], and allows to get a typed slice view on the data.
struct MemoryMap
{
    import std.traits : isDynamicArray;

    private DeviceMemory dm;
    private size_t offset;
    private void[] data;
    private void delegate() unmap;

    package(gfx) this(DeviceMemory dm, in size_t offset, void[] data, void delegate() unmap)
    {
        this.dm = dm;
        this.offset = offset;
        this.data = data;
        this.unmap = unmap;
    }

    @disable this(this);

    ~this()
    {
        // should handle dtor of MemoryMap.init
        if (unmap) unmap();
    }

    void addToSet(ref MappedMemorySet set)
    {
        set.addMM(MappedMemorySet.MM(dm, offset, data.length));
    }

    /// Get a typed view on the memory map that support slice and indexing operations.
    /// Params:
    ///     offset =   the offset to the requested memory in bytes
    ///     count =    the number of elements of type T.init[0] to be mapped
    /// Warning: offset and count are not in the same units.
    /// This is necessary in order to allow a memory block to hold several arrays
    /// of different element types.
    auto view(T)(in size_t offset=0, in size_t count=size_t.max)
    if (isDynamicArray!T)
    {
        alias Elem = typeof(T.init[0]);
        const len = count == size_t.max ? data.length-offset : count*Elem.sizeof;
        return MemoryMapArrayView!Elem(cast(T)(data[offset .. offset+len]));
    }

    size_t opDollar() {
        return data.length;
    }

    size_t[2] opSlice(size_t beg, size_t end) {
        return [beg, end];
    }

    void[] opIndex() {
        return data;
    }
    void[] opIndex(in size_t[2] slice) {
        return data[ slice[0] .. slice[1] ];
    }

    void opIndexAssign(in void[] vals) {
        data[] = vals;
    }
    void opIndexAssign(in void[] vals, size_t[2] slice) {
        data[slice[0] .. slice[1]] = vals;
    }
}

private struct MemoryMapArrayView(T)
{
    private T[] data;

    @property size_t opDollar(size_t dim : 0)() {
        return data.length;
    }

    @property size_t[2] opSlice(size_t dim : 0)(size_t beg, size_t end) {
        return [beg, end];
    }

    T[] opIndex() {
        return data;
    }
    T[] opIndex(in size_t[2] slice) {
        return data[ slice[0] .. slice[1] ];
    }

    void opIndexAssign(in T[] vals) {
        data[] = vals;
    }
    void opIndexAssign(in T[] vals, size_t[2] slice) {
        data[slice[0] .. slice[1]] = vals;
    }

    static if (!is(T == void)) {
        T opIndex(size_t index) {
            return data[index];
        }
        void opIndexAssign(in T val, size_t ind) {
            data[ind] = val;
        }
        void opIndexAssign(in T val, size_t[2] slice) {
            data[slice[0] .. slice[1]] = val;
        }
    }
}


interface DeviceMemory : IAtomicRefCounted
{
    /// Get the parent device
    @property Device device();

    @property uint typeIndex();
    @property MemProps props();
    @property size_t size();

    /// Map device memory to host visible memory.
    /// Params:
    ///     offset =   the offset to the requested memory in bytes
    ///     size =     the size of the mapping in bytes.
    void* mapRaw(in size_t offset, in size_t size);
    void unmapRaw();

    /// Produce a scoped memory map.
    /// The the memory will be unmapped when the object goes out of scope.
    /// The is an untyped memory holder. In order to access the memory, call
    /// view with the right type parameter.
    /// Params:
    ///     offset =   the offset to the requested memory in bytes
    ///     count =    the number of bytes to be mapped
    final auto map(in size_t offset=0, in size_t sz=size_t.max)
    {
        const size = sz==size_t.max ? this.size : sz;
        auto data = mapRaw(offset, size)[0 .. size];
        return MemoryMap(this, offset, data, &unmapRaw);
    }
}



/// cast a typed slice into a blob of bytes
/// (same representation; no copy is made)
void[] untypeSlice(T)(T[] slice) if(!is(T == const))
{
    if (slice.length == 0) return [];
    auto loc = cast(void*)slice.ptr;
    return loc[0 .. slice.length*T.sizeof];
}

/// ditto
const(void)[] untypeSlice(T)(const(T)[] slice)
{
    if (slice.length == 0) return [];
    auto loc = cast(const(void)*)slice.ptr;
    return loc[0 .. slice.length*T.sizeof];
}

/// cast a blob of bytes into a typed slice
T[] retypeSlice(T)(void[] slice) if (!is(T == const))
in {
    assert (!slice.length || (slice.length % T.sizeof) == 0);
}
body {
    if(slice.length == 0) return [];
    auto loc = cast(T*)slice.ptr;
    return loc[0 .. slice.length / T.sizeof];
}

/// ditto
const(T)[] retypeSlice(T)(const(void)[] slice)
in {
    assert (!slice.length || (slice.length % T.sizeof) == 0);
}
body {
    if(slice.length == 0) return [];
    auto loc = cast(const(T)*)slice.ptr;
    return loc[0 .. slice.length / T.sizeof];
}

unittest {
    int[] slice = [1, 2, 3, 4];
    auto bytes = cast(ubyte[])untypeSlice(slice);
    auto ints = retypeSlice!int(bytes);
    assert(bytes.length == 16);
    version(LittleEndian) {
        assert(bytes == [
            1, 0, 0, 0,
            2, 0, 0, 0,
            3, 0, 0, 0,
            4, 0, 0, 0,
        ]);
    }
    else {
        assert(bytes == [
            0, 0, 0, 1,
            0, 0, 0, 2,
            0, 0, 0, 3,
            0, 0, 0, 4,
        ]);
    }
    assert(ints.length == 4);
    assert(ints == slice);
    assert(ints.ptr == slice.ptr);
}

/// cast an array of typed slices to another array of blob of bytes
/// an allocation is performed for the top container (the array of arrays)
/// but the underlying data is moved without allocation
void[][] untypeSlices(T)(T[][] slices) if (!is(T == const)) {
    void[][] res = new void[][slices.length];
    foreach(i, s; slices) {
        res[i] = untypeSlice(s);
    }
    return res;
}

/// ditto
const(void)[][] untypeSlices(T)(const(T)[][] slices) {
    const(void)[][] res = new const(void)[][slices.length];
    foreach(i, s; slices) {
        res[i] = untypeSlice(s);
    }
    return res;
}

unittest {
    int[][] texels = [ [1, 2], [3, 4] ];
    auto bytes = cast(ubyte[][])untypeSlices(texels);
    assert(bytes.length == 2);
    assert(bytes[0].length == 8);
    assert(bytes[1].length == 8);
    version(LittleEndian) {
        assert(bytes == [
            [   1, 0, 0, 0,
                2, 0, 0, 0, ],
            [   3, 0, 0, 0,
                4, 0, 0, 0, ],
        ]);
    }
    else {
        assert(bytes == [
            [   0, 0, 0, 1,
                0, 0, 0, 2, ],
            [   0, 0, 0, 3,
                0, 0, 0, 4, ],
        ]);
    }
}
