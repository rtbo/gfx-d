#version 450

layout(location = 0) in vec2 v_TexCoord;
layout(location = 1) out vec4 o_Color;

layout(binding = 0) uniform sampler2D texSampler;

void main() {
    vec4 color = texture(texSampler, v_TexCoord);
    if (color.r < 0.5) {
        discard;
    }
    o_Color = color;
}
