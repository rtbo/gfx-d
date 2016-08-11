#version 330

in vec3 a_Pos;
in vec3 a_Normal;

out vec3 v_Position;
out vec3 v_Normal;

uniform VsLocals {
	mat4 u_MVP;
	mat4 u_Model;
};

void main() {
	v_Normal = mat3(u_Model) * a_Normal;
	v_Position = (u_Model * vec4(a_Pos, 1.0)).xyz;
    gl_Position = u_MVP * vec4(a_Pos, 1.0);
}
