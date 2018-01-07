module gfx.graal.queue;


enum QueueCap {
    graphics    = 0x01,
    compute     = 0x02,
}

struct QueueFamily
{
    QueueCap cap;
    uint count;
}
