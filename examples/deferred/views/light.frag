#version 450

#extension GL_ARB_shading_language_420pack : enable

layout(std140, set = 0, binding = 0) uniform Frame {
    vec4 viewPos;
} frame;

layout(std140, set = 0, binding = 1) uniform Model {
    mat4 modelViewProjMat;
    vec4 lightPos;
    vec4 lightCol;
    float lightRad;
} model;

layout(input_attachment_index = 0, set = 1, binding = 0) uniform subpassInput inputs[4];

layout(location = 0) out vec4 o_Color;

#define ambient 0.0

void main() {
    vec4 worldPosA = subpassLoad(inputs[0]).rgba;

    if (worldPosA.a <= 0.0) {
        // area of cleared image, no light need to get shaded
        discard;
    }

    vec3 worldPos = worldPosA.rgb;
    vec3 normal = subpassLoad(inputs[1]).rgb;
    vec3 color = subpassLoad(inputs[2]).rgb;
    float shininess = subpassLoad(inputs[3]).r;

    vec3 to_light = model.lightPos.xyz - worldPos;
    float dist = length(to_light);
    to_light = normalize(to_light);

    vec3 to_viewer = normalize(frame.viewPos.xyz - worldPos);
    float atten = model.lightRad / (pow(dist, 2.0) + 1.0);

    // diffuse part
    float diff_factor = max(0.0, dot(normal, to_light));
    vec3 diff = model.lightCol.rgb * color * diff_factor * atten;

    // specular part
    vec3 reflection = reflect(-to_light, normal);
    float spec_factor = max(0.0, dot(reflection, to_viewer));
    vec3 spec = model.lightCol.rgb * pow(spec_factor, shininess) * atten;

    o_Color = vec4(ambient*color + diff + spec, 1.0);
}
