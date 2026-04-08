shader_type canvas_item;

uniform sampler2D screen_texture: hint_screen_texture;

void fragment() {
	vec4 color = texture(screen_texture, UV);
	float bright = (color.r + color.g + color.b) / 3.0;
	
	COLOR = vec4(bright, bright, bright, 1.0);
}
