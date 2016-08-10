#version 330

in vec2 v_TexCoord;

out vec4 o_Color;

uniform sampler2D t_BlitTex;


void main() {
	o_Color = texture(t_BlitTex, v_TexCoord);
}
