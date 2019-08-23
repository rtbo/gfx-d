#version 450

layout(location = 0) in vec2 i_Position;
layout(location = 1) in vec2 i_TexCoord;

layout(location = 0) out vec2 v_TexCoord;

out gl_PerVertex {
    vec4 gl_Position;
};

void main() {
    gl_Position = vec4(i_Position, 0.0, 1.0);
    v_TexCoord = i_TexCoord;
}
