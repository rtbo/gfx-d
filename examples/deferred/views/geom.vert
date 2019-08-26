#version 450

#extension GL_ARB_shading_language_420pack : enable

struct ModelData {
    mat4 mat;
    vec4 color;
    vec4 pad;
};

layout(location = 0) in vec3 i_Position;
layout(location = 1) in vec3 i_Normal;

layout(std140, binding = 0) uniform Frame {
    mat4 viewProjMat;
} frame;

layout(std140, binding = 1) uniform Model {
    ModelData[3] data;
} model;

out gl_PerVertex {
    vec4 gl_Position;
};

layout(location = 0) out vec3 v_WorldPos;
layout(location = 1) out vec3 v_Normal;
layout(location = 2) out vec4 v_Color;

void main() {
    ModelData model = model.data[gl_InstanceIndex];

    gl_Position = frame.viewProjMat * model.mat * vec4(i_Position, 1.0);
    v_WorldPos = (model.mat * vec4(i_Position, 1.0)).xyz;
    mat3 normalMat = transpose(inverse(mat3(model.mat)));
    v_Normal = normalMat * i_Normal;
    v_Color = model.color;
    // shininess is stored in alpha channel, divided by 64
    // to avoid clamping to 1.0. 64 is arbitrary higher than max shininess
    v_Color.a /= 64.0;
}
