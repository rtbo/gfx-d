#version 450

layout(input_attachment_index = 0, set = 0, binding = 0) uniform subpassInput inputs[2];

layout(location = 0) out vec4 o_Color;

#define exposure 0.5
#define gamma 2.2

void main() {
    vec3 hdrColor = subpassLoad(inputs[0]).rgb;
    vec3 bloom = subpassLoad(inputs[1]).rgb;

    // additive blend
    vec3 result = hdrColor + bloom;

    // tone mapping
    result = vec3(1.0) - exp(-result * exposure);

    // gamma correction
    result = pow(result, vec3(1.0 / gamma));

    o_Color = vec4(result, 1.0);
}
