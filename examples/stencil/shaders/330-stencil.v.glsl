#version 330

in vec2 a_Pos;
in vec2 a_TexCoord;

out vec2 v_TexCoord;

void main() {
    gl_Position = vec4(a_Pos, 0.0, 1.0);
    v_TexCoord = a_TexCoord;
}