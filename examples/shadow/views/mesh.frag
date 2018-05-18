#version 450

#extension GL_ARB_separate_shader_objects : enable
#extension GL_ARB_shading_language_420pack : enable

// inputs from vertex shader
layout(location = 0) in vec3 v_Position;
layout(location = 1) in vec3 v_Normal;

// color output
layout(location = 0) out vec4 o_Color;

// uniforms
const int MAX_LIGHTS = 5;

struct Light {
    vec4 pos;	// world position
    vec4 color;
    mat4 proj;	// view-projection matrix
};

layout(std140, binding = 1) uniform Material {
    // material color
    vec4 color;
} mat;

layout(std140, binding = 2) uniform Lights {
    // active number of lights
    int numLights;
    // lights
    Light  lights[MAX_LIGHTS];
} lights;


// an array of shadows, one per light
layout(binding = 3) uniform sampler2DArrayShadow shadowSampler;


void main() {
    vec3 normal = normalize(v_Normal);
    vec3 ambient = vec3(0.05, 0.05, 0.05);
    // accumulated color
    vec3 color = ambient;
    for (int i=0; i<lights.numLights && i<MAX_LIGHTS; ++i) {

        Light light = lights.lights[i];

        // compute Lambertian diffuse term
        const vec3 lightDir = normalize(light.pos.xyz - v_Position);
        const float diffuse = max(0.0, dot(normal, lightDir));

        // project into the light space
        const vec4 lightLocal = light.proj * vec4(v_Position, 1.0);
        // compute texture coordinates for shadow lookup
        const vec4 shadowCoord = vec4(
            ( lightLocal.xy / lightLocal.w + 1.0 ) / 2.0,
            float(i),
            lightLocal.z / lightLocal.w
        );
        // do the lookup, using HW PCF and comparison
        const float shadow = texture(shadowSampler, shadowCoord);

        // add light contribution
        color += shadow * diffuse * light.color.xyz;
    }
    // multiply the light by material color
    o_Color = vec4(color, 1.0) * mat.color;
}
