#version 450

#extension GL_ARB_shading_language_420pack : enable

layout(location = 0) in vec3 v_worldPos;
layout(location = 1) in vec3 v_Normal;
layout(location = 2) in vec4 v_Color;

layout(location = 0) out vec4 o_worldPos;
layout(location = 1) out vec4 o_Normal;
layout(location = 2) out vec4 o_Color;

void main() {
    o_worldPos = vec4(v_worldPos, 1.0);
    o_Normal = vec4(normalize(v_Normal), 1.0);
    o_Color = v_Color;
}
