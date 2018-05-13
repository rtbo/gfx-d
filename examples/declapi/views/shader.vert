#version 450

#extension GL_ARB_separate_shader_objects : enable
#extension GL_ARB_shading_language_420pack : enable

layout(location = 0) in vec3 i_Position;
layout(location = 1) in vec3 i_Normal;
layout(location = 2) in vec4 i_Color;

layout(std140, binding = 0) uniform Matrices {
	mat4 mvpMat;
	mat4 normalMat;
} ubo;

out gl_PerVertex {
    vec4 gl_Position;
};

layout(location = 0) out vec3 v_Normal;
layout(location = 1) out vec4 v_Color;

void main() {
    gl_Position = ubo.mvpMat * vec4(i_Position, 1.0);
    v_Normal = mat3(ubo.normalMat) * i_Normal;
    v_Color = i_Color;
}
