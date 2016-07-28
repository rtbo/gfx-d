#version 330

in vec3 a_Pos;
in vec3 a_Normal;
in vec2 a_TexCoord;

out vec3 v_Normal;
out vec2 v_TexCoord;

uniform Matrices {
	mat4 u_mvpMat;
	mat3 u_normalMat;
};

void main() {
	v_Normal = normalize(u_normalMat * a_Normal);
	v_TexCoord = a_TexCoord;
    gl_Position = u_mvpMat * vec4(a_Pos, 1.0);
}
