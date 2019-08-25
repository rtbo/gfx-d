#version 450

#extension GL_ARB_shading_language_420pack : enable

layout(std140, set = 0, binding = 0) uniform Frame {
    vec4 viewPos;
} frame;

layout(std140, set = 0, binding = 1) uniform Model {
    mat4 modelViewProjMat;
    vec4 lightPos;
    // color in RGB, luminosity in A
    vec4 lightColAndLum;
} model;

layout(input_attachment_index = 0, set = 1, binding = 0) uniform subpassInput inputs[3];

layout(location = 0) out vec4 o_Color;
layout(location = 1) out vec4 o_BloomBase;

void main() {
    vec4 worldPosA = subpassLoad(inputs[0]).rgba;

    if (worldPosA.a <= 0.0) {
        // area of cleared image, no light need to get shaded
        discard;
    }

    vec3 worldPos = worldPosA.rgb;
    vec3 normal = subpassLoad(inputs[1]).rgb;
    vec4 colorShininess = subpassLoad(inputs[2]);
    vec3 color = colorShininess.rgb;
    float shininess = colorShininess.a * 64.0;

    vec3 to_light = model.lightPos.xyz - worldPos;
    float dist = length(to_light);
    to_light = normalize(to_light);

    vec3 to_viewer = normalize(frame.viewPos.xyz - worldPos);

    float atten = model.lightColAndLum.a / (dist * dist + 1.0);

    // diffuse part
    float diff_factor = max(0.0, dot(normal, to_light));
    vec3 diff = model.lightColAndLum.rgb * color * diff_factor * atten;

    // specular part
#if true
    // blinn-phong
    vec3 halfway = normalize(to_light + to_viewer);
    float spec_factor = pow(max(0.0, dot(normal, halfway)), shininess);
#else
    // phong
    vec3 reflection = reflect(-to_light, normal);
    float spec_factor = pow(max(0.0, dot(reflection, to_viewer)), shininess);
#endif
    vec3 spec = model.lightColAndLum.rgb * spec_factor * atten;

    o_Color = vec4(diff + spec, 1.0);

    float brightness = dot(o_Color.rgb, vec3(0.2126, 0.7152, 0.0722));
    if(brightness > 1.0) {
        o_BloomBase = o_Color;
    } else {
        o_BloomBase = vec4(0.0, 0.0, 0.0, 1.0);
    }
}
