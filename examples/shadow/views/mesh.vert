#version 450

#extension GL_ARB_separate_shader_objects : enable
#extension GL_ARB_shading_language_420pack : enable

layout(location = 0) in vec3 i_Position;
layout(location = 1) in vec3 i_Normal;

layout(std140, binding = 0) uniform Matrices {
    mat4 mvp;
    mat4 model;
} matrices;

layout(location = 0) out vec3 v_Position;
layout(location = 1) out vec3 v_Normal;


void main() {
    v_Normal = mat3(matrices.model) * i_Normal;
    v_Position = (matrices.model * vec4(i_Position, 1.0)).xyz;
    gl_Position = matrices.mvp * vec4(i_Position, 1.0);
}
