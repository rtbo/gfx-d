#version 450

#extension GL_ARB_shading_language_420pack : enable

layout(location = 0) in vec3 i_Position;

layout(std140, set = 0, binding = 1) uniform Model {
    mat4 modelViewProjMat;
    vec4 lightPos;
    vec4 lightColAndLum;
} model;

out gl_PerVertex {
    vec4 gl_Position;
};

void main() {
    gl_Position = model.modelViewProjMat * vec4(i_Position, 1.0);
}
