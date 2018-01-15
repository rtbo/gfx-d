module gfx.graal.queue;

import gfx.core.rc;
import gfx.graal.presentation;
import gfx.graal.sync;

enum QueueCap {
    graphics    = 0x01,
    compute     = 0x02,
}

struct QueueFamily
{
    QueueCap cap;
    uint count;
}

struct PresentRequest {
    Swapchain swapChain;
    uint imageIndex;
}

interface Queue
{
    void waitIdle();
    void present(Semaphore[] waitSems, PresentRequest[] prs);
}
