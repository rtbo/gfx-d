module gfx.graal.queue;

import gfx.core.rc;
import gfx.graal.cmd;
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

struct StageWait {
    Semaphore sem;
    PipelineStage stages;
}

struct Submission {
    StageWait[] stageWaits;
    Semaphore[] sigSems;
    CommandBuffer[] cmdBufs;
}

struct PresentRequest {
    Swapchain swapChain;
    uint imageIndex;
}

interface Queue
{
    void waitIdle();
    void submit(Submission[] submissions, Fence fence);
    void present(Semaphore[] waitSems, PresentRequest[] prs);
}
