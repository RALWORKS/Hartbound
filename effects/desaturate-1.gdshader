shader_type canvas_item;

uniform sampler2D screen_texture;
uniform float mul_r = 1.0;
uniform float mul_g = 1.0;
uniform float mul_b = 1.0;
uniform float base_mod = 0.1;
uniform float gradient_mod = 0.0;
uniform float gradient_mul = 1.0;

void fragment() {
	vec4 color = texture(screen_texture, UV);
	float bright = color.r + color.g + color.b;
	
	float dist = pow(sqrt(pow((UV.x - 0.5), 2) + pow((UV.y - 0.5), 2)), gradient_mul);
	
	color.r = color.r * mul_r + (base_mod * bright) - gradient_mod*dist;
	color.g = color.g * mul_g + (base_mod * bright) - gradient_mod*dist;
	color.b = color.b * mul_b + (base_mod * bright) - gradient_mod*dist;
	
	COLOR = color;
}
