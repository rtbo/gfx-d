/// synchronization module
module gfx.graal.sync;

import gfx.core.rc;

interface Semaphore : AtomicRefCounted
{}

interface Fence : AtomicRefCounted
{
    @property bool signaled();
}
