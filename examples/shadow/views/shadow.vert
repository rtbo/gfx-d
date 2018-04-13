#version 450

#extension GL_ARB_separate_shader_objects : enable
#extension GL_ARB_shading_language_420pack : enable

layout(location = 0) in vec3 i_Position;

layout(std140, binding = 0) uniform Locals {
    mat4 shadowProj;
} ubo;

out gl_PerVertex {
    vec4 gl_Position;
};

void main() {
    gl_Position = ubo.shadowProj * vec4(i_Position, 1.0);
}
