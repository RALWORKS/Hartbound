shader_type canvas_item;

uniform sampler2D mask_texture;
uniform float scale_x = 1.0;
uniform float scale_y = 1.0;

void fragment() {
    vec4 colour = texture(TEXTURE, UV);
    colour.a *= texture(mask_texture, vec2(UV.x/scale_x, UV.y/scale_y)).a;

    COLOR = colour;
}