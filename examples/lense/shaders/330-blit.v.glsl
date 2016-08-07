#version 330

in vec3 a_Pos;
in vec2 a_TexCoord;

out vec2 v_TexCoord;

void main() {
	v_TexCoord = a_TexCoord;
    gl_Position = vec4(a_Pos, 1.0);
}
