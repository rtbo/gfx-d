#version 450

#extension GL_ARB_separate_shader_objects : enable
#extension GL_ARB_shading_language_420pack : enable

layout(location = 0) in vec3 v_Normal;
layout(location = 1) in vec4 v_Color;

layout(location = 0) out vec4 o_Color;

const int MAX_LIGHTS = 5;

struct Light {
    vec4 direction;		// world space, prenormalized
    vec4 color;
};

layout(binding = 1) uniform Lights {
    Light lights[MAX_LIGHTS];
    // active number of lights
    // some alignment may apply, so I place it at the end
    int num;
} lig;


layout(binding = 2) uniform sampler2D texSampler;

void main() {
    vec3 normal = normalize(v_Normal);
    vec4 col = v_Color;

    vec3 bright = vec3(0.0, 0.0, 0.0);
    for (int i=0; i<lig.num && i<MAX_LIGHTS; ++i) {
        vec3 to_light = -lig.lights[i].direction.xyz;
        vec3 light_col = lig.lights[i].color.rgb;
        float d = max(dot(normal, to_light), 0.0);
        bright += d * light_col;
    }
    o_Color = vec4(bright*col.rgb, col.a);
}
