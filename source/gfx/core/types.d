module gfx.core.types;


struct Offset2D {
    uint x;
    uint y;
}
struct Extent2D {
    uint width;
    uint height;
}

struct Rect {
    uint x;
    uint y;
    uint width;
    uint height;
}

struct Viewport {
    float x;
    float y;
    float width;
    float height;
    float minDepth;
    float maxDepth;
}

