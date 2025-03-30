shader_type canvas_item;

uniform sampler2D screen_texture: hint_screen_texture;
uniform float mul_r = 0.7;
uniform float mul_g = 0.3;
uniform float mul_b = 0.1;
uniform float base_mod = 0.2;
uniform float gradient_mod = 3;
uniform float gradient_mul = 2.3;
uniform vec2 top_left = vec2(0, 0);
uniform vec2 size = vec2(1800, 1080);
uniform vec2 screen_size = vec2(1920, 1080);

void fragment() {
	float sx = ((screen_size.x) / (size.x));
	float sy = ((screen_size.y) / (size.y));
	float tx = (top_left.x/screen_size.x);
	float ty = (top_left.y/screen_size.y);
	float nuvx = ((UV.x) / sx) + tx;
	float nuvy = ((UV.y) / sy) + ty;
	vec2 NUV = vec2(nuvx, nuvy);
	vec4 color = texture(screen_texture, NUV);
	float bright = color.r + color.g + color.b;
	
	float dist = pow(sqrt(pow((UV.x - 0.5), 2) + pow((UV.y - 0.5), 2)), gradient_mul);
	
	color.r = color.r * mul_r + (base_mod * bright) - gradient_mod*dist;
	color.g = color.g * mul_g + (base_mod * bright) - gradient_mod*dist;
	color.b = color.b * mul_b + (base_mod * bright) - gradient_mod*dist;
	
	COLOR = color;
}
