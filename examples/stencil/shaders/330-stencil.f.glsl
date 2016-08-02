#version 330

in vec2 v_TexCoord;
out vec4 o_Color;

uniform sampler2D u_Sampler;

void main() {
    vec4 color = texture(u_Sampler, v_TexCoord);
    if (color.r < 0.5) {
        discard;
    }
    o_Color = texture(u_Sampler, v_TexCoord);
}