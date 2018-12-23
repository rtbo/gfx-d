/// synchronization module
module gfx.graal.sync;

import core.time : dur, Duration;
import gfx.core.rc;

interface Semaphore : IAtomicRefCounted
{
    import gfx.graal.device : Device;

    /// Get the parent device
    @property Device device();
}

interface Fence : IAtomicRefCounted
{
    import gfx.graal.device : Device;

    /// Get the parent device
    @property Device device();

    @property bool signaled();
    void reset();
    void wait(Duration timeout=dur!"seconds"(-1));
}
