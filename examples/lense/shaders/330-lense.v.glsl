#version 330

in vec3 a_Pos;
in vec3 a_Normal;

out vec3 v_Pos;
out vec3 v_Normal;

uniform Matrices {
	mat4 u_mvpMat;
	mat4 u_normalMat;
};

void main() {
	v_Normal = (u_normalMat * vec4(a_Normal, 0.0)).xyz;
	vec4 pos = u_mvpMat * vec4(a_Pos, 1.0);
	v_Pos = pos.xyz;
	gl_Position = pos;
}
