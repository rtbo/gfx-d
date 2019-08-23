#version 450

layout(location = 0) in vec2 v_TexCoord;
layout(location = 0) out vec4 o_Color;

layout(binding = 0) uniform sampler2D bloomInput;

layout(push_constant) uniform PushConsts {
    int horizontal;
} pushConsts;

void main() {
    float weight[5] = float[] (0.227027, 0.1945946, 0.1216216, 0.054054, 0.016216);

    vec2 tex_offset = 1.0 / textureSize(bloomInput, 0);
    vec3 result = texture(bloomInput, v_TexCoord).rgb * weight[0];
    if (pushConsts.horizontal == 1) {
        for (int i=1; i<5; ++i) {
            vec2 offset = vec2(tex_offset.x * i, 0.0);
            result += texture(bloomInput, v_TexCoord + offset).rgb * weight[i];
            result += texture(bloomInput, v_TexCoord - offset).rgb * weight[i];
        }
    }
    else {
        for (int i=1; i<5; ++i) {
            vec2 offset = vec2(0.0, tex_offset.y * i);
            result += texture(bloomInput, v_TexCoord + offset).rgb * weight[i];
            result += texture(bloomInput, v_TexCoord - offset).rgb * weight[i];
        }
    }

    o_Color = vec4(result, 1.0);
}
