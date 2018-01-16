/// command buffer module
module gfx.graal.cmd;

import gfx.core.rc;


interface CommandPool : AtomicRefCounted
{
    void reset();
}
