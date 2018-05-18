/// synchronization module
module gfx.graal.sync;

import core.time : dur, Duration;
import gfx.core.rc;

interface Semaphore : AtomicRefCounted
{}

interface Fence : AtomicRefCounted
{
    @property bool signaled();
    void reset();
    void wait(Duration timeout=dur!"seconds"(-1));
}
