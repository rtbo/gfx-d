/// Image module
module gfx.graal.image;

import gfx.core.rc;
import gfx.graal.memory;

enum ImageType {
    d1, d1Array,
    d2, d2Array,
    d3, cube, cubeArray
}

bool isCube(in ImageType tt) {
    return tt == ImageType.cube || tt == ImageType.cubeArray;
}

enum CubeFace {
    none,
    posX, negX,
    posY, negY,
    posZ, negZ,
}

/// an array of faces in the order that is expected during cube initialization
immutable cubeFaces = [
    CubeFace.posX, CubeFace.negX,
    CubeFace.posY, CubeFace.negY,
    CubeFace.posZ, CubeFace.negZ,
];

struct ImageDims
{
    uint width;
    uint height;
    uint depth;
    uint layers;

    static ImageDims d1 (in uint width) {
        return ImageDims(width, 1, 1, 1);
    }
    static ImageDims d2 (in uint width, in uint height) {
        return ImageDims(width, height, 1, 1);
    }
    static ImageDims d3 (in uint width, in uint height, in uint depth) {
        return ImageDims(width, height, depth, 1);
    }
    static ImageDims cube (in uint width, in uint height) {
        return ImageDims(width, height, 6, 1);
    }
    static ImageDims d1Array (in uint width, in uint layers) {
        return ImageDims(width, 1, 1, layers);
    }
    static ImageDims d2Array (in uint width, uint height, in uint layers) {
        return ImageDims(width, height, 1, layers);
    }
    static ImageDims cubeArray (in uint width, in uint height, in uint layers) {
        return ImageDims(width, height, 6, layers);
    }
}

enum ImageUsage {
    none = 0,
    transferSrc             = 0x01,
    transferDst             = 0x02,
    sampled                 = 0x04,
    storage                 = 0x08,
    colorAttachment         = 0x10,
    depthStencilAttachment  = 0x20,
    transientAttachment     = 0x40,
    inputAttachment         = 0x80,
}

interface Image : AtomicRefCounted
{
    @property ImageDims dims();
    @property MemoryRequirements memoryRequirements();

    void bindMemory(DeviceMemory mem, in size_t offset);
}


