shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform float strength = -0.05;
uniform float size = 0.5;

void fragment() {
    vec2 center = vec2(0.5, 0.5);
    vec2 dir = UV - center;
    float dist = length(dir);

    float mask = smoothstep(size, 0.0, dist);

    vec2 offset = dir * strength * mask;

    COLOR = texture(SCREEN_TEXTURE, SCREEN_UV - offset);
}