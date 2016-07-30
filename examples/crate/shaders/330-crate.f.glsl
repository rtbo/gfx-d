#version 330

in vec3 v_Normal;
in vec2 v_TexCoord;

out vec4 o_Color;


const int MAX_LIGHTS = 5;

uniform NumLights {
	// active number of lights
	int u_NumLights;
};

struct Light {
	vec4 direction;		// world space, prenormalized
	vec4 color;
};

layout (std140) uniform Lights {
	Light u_Lights[MAX_LIGHTS];
};

uniform sampler2D t_Sampler;


void main() {
	vec3 normal = normalize(v_Normal);
	vec4 sample = texture(t_Sampler, v_TexCoord);

	vec3 bright = vec3(0.0, 0.0, 0.0);
	for (int i=0; i<u_NumLights && i<MAX_LIGHTS; ++i) {
		vec3 to_light = -u_Lights[i].direction.xyz;
		vec3 light_col = u_Lights[i].color.rgb;
		float d = max(dot(normal, to_light), 0.0);
		bright += d * light_col;
	}
    o_Color = vec4(bright*sample.rgb, sample.a);
}
