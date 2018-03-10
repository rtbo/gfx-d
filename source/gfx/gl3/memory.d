module gfx.gl3.memory;

package:

import gfx.graal.memory : DeviceMemory;

// CPU backed memory, upload on device by glBufferData, glTexImage...
class GlDeviceMemory : DeviceMemory
{
    import gfx.core.rc : atomicRcCode;
    import gfx.graal.memory : MemProps;

    mixin(atomicRcCode);

    private uint _typeIndex;
    private MemProps _props;
    private void[] _data;

    this (in uint typeIndex, in MemProps props, in size_t size) {
        _typeIndex = typeIndex;
        _props = props;
        _data = new void[size];
    }

    override void dispose() {
        _data = null;
    }

    override @property uint typeIndex() {
        return _typeIndex;
    }
    override @property MemProps props() {
        return _props;
    }
    override @property size_t size() {
        return _data.length;
    }

    override void* map(in size_t offset, in size_t size) {
        return &_data[offset];
    }
    override void unmap() {}
}
