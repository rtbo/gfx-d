#version 450

layout(input_attachment_index = 0, binding = 0) uniform subpassInput hdrInput;

layout(location = 0) out vec4 o_Color;

#define exposure 0.5
#define gamma 2.2

void main() {
    vec3 hdrColor = subpassLoad(hdrInput).rgb;

    // tone mapping
    vec3 result = vec3(1.0) - exp(-hdrColor * exposure);

    // gamma correction
    result = pow(result, vec3(1.0 / gamma));

    o_Color = vec4(result, 1.0);
}
