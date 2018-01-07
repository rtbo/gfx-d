module gfx.graal.memory;

import gfx.core.rc;
import gfx.graal.device;

/// Properties of memory allocated by the device
enum MemProps {
    deviceLocal     = 0x01,
    hostVisible     = 0x02,
    hostCoherent    = 0x04,
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
    MemProps props;
    bool deviceLocal;
}

struct MemoryType {
    uint index;
    uint heapIndex;
    size_t heapSize;
    MemProps props;
}

struct MemoryMap(T)
{
    private Rc!DeviceMemory dm;
    private size_t offset;
    private T[] data;

    private this(DeviceMemory dm, in size_t offset, T[] data)
    {
        this.dm = dm;
        this.offset = offset;
        this.data = data;
    }

    @disable this(this);

    ~this()
    {
        // should handle dtor of MemoryMap.init
        if (dm) dm.unmap();
    }

    void addToSet(ref MappedMemorySet set)
    {
        set.addMM(MappedMemorySet.MM(dm.obj, offset, data.length*T.sizeof));
    }

    // TODO: opSlice, opIndex, opDollar...
}



/// Map device memory to host visible memory.
/// Params:
///     dm =       the device memory to be mapped
///     offset =   the offset to the requested memory in bytes
///     count =    the number of elements of type T to be mapped
/// Warning: offset and count are not in the same units.
/// This is necessary in order to allow a memory block to hold several arrays
/// of different element types.
auto mapMemory(T)(DeviceMemory dm, in size_t offset, in size_t count)
{
    const size = count * T.sizeof;
    auto slice = dm.map(offset, size)[0 .. size];
    return MemoryMap!T(dm, offset, retypeSlice!(slice));
}

interface DeviceMemory : AtomicRefCounted
{
    @property uint typeIndex();
    @property size_t size();

    void* map(in size_t offset, in size_t size);
    void unmap();
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
