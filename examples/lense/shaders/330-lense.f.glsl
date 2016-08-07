#version 330

in vec3 v_Pos;
in vec3 v_Normal;

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

	vec3 dir = -normal;
	vec3 point = (v_Pos + dir*3/abs(dir.z)) / 8.0;
	//vec3 point = v_Pos/15;
	vec4 sample = texture(t_Sampler, (point.xy / 2.0) + 0.5);
	//if (length(normal) < 0.5) {
		o_Color = vec4((ambient + intensity*light_col) * sample.rgb, sample.a);
	//}
	//else {
	//	o_Color = vec4(0, 0, 1, 1);
	//}
}
