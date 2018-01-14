/// Presentation module
module gfx.graal.presentation;

import gfx.core.rc;
import gfx.graal.format;
import gfx.graal.image;

import std.typecons : Tuple;

struct SurfaceCaps
{
    uint minImages;
    uint maxImages;
    uint[2] minSize;
    uint[2] maxSize;
    uint maxLayers;
    ImageUsage usage;
}

enum PresentMode {
    immediate,
    fifo,
    mailbox,
}

interface Surface : AtomicRefCounted
{
}
