#version 330

in vec3 v_Normal;
in vec2 v_TexCoord;

out vec4 o_Color;

uniform Light {
	vec4 u_Direction;		// world space, pre-normalized
	vec4 u_Color;
};

uniform sampler2D t_Sampler;


void main() {
	vec3 ambient = vec3(0.05, 0.05, 0.05);
	vec3 light_col = u_Color.rgb;
	vec3 to_light = -u_Direction.xyz;
	vec3 normal = normalize(v_Normal);
	float intensity = max(dot(normal, to_light), 0.0);
	vec4 sample = texture(t_Sampler, v_TexCoord);
	o_Color = vec4((ambient + intensity*light_col) * sample.rgb, sample.a);
}
