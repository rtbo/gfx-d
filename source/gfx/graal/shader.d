module gfx.graal.shader;

import gfx.core.rc;

enum ShaderLanguage {
    spirV       = 0x01,
    glsl        = 0x02, // TODO: glsl versions
}

enum ShaderStage {
    vertex                  = 0x01,
    tessellationControl     = 0x02,
    tessellationEvaluation  = 0x04,
    geometry                = 0x08,
    fragment                = 0x10,
    compute                 = 0x20,

    allGraphics             = 0x1f,
    all                     = allGraphics | compute,
}

struct ShaderInfo {
    ShaderStage stage;
    ShaderModule shader;
    string entryPoint;
}

interface ShaderModule : AtomicRefCounted
{}
