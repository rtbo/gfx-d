module gfx.graal.shader;

import gfx.core.rc;

enum ShaderLanguage {
    spirV       = 0x01,
    glsl        = 0x02, // TODO: glsl versions
}

interface ShaderModule : AtomicRefCounted
{}
