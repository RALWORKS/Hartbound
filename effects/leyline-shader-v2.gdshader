shader_type canvas_item;

uniform float blur_radius = 100.0;
uniform float n_steps = 100.0;
uniform float bg_alpha = 0.3;

uniform bool invert = false;

vec4 neighbour(vec2 pixel_size, sampler2D cur_texture, vec2 cur_uv, float offset) {
	return texture(cur_texture, cur_uv + pixel_size * offset);
}

vec4 averager(vec2 pixel_size, sampler2D cur_texture, vec2 cur_uv) {
	vec4 total = vec4(0, 0, 0, 0);
	float mag = blur_radius / 2.0;
	float one_step = mag / n_steps;
	for (float i = 0.0; i < mag; i += one_step) {
		total += neighbour(pixel_size, cur_texture, cur_uv, i);
	}
	for (float i = 0.0; i > -1.0 * mag; i -= one_step) {
		total += neighbour(pixel_size, cur_texture, cur_uv, i);
	}
	return total / (n_steps * 2.0);
}

void fragment() {
	vec2 pixel_size = 1.0/vec2(textureSize(TEXTURE, 0));
	
	vec4 avg = (
		averager(pixel_size, TEXTURE, UV)
		+ averager(vec2(pixel_size.x, -1.0*pixel_size.y), TEXTURE, UV)
		) /2.0;
	
	if (invert) {
		COLOR = vec4(0.1, 0.0, 0.1, 1.0);
		COLOR.a = (1.0 - pow(avg.a, 4)) * bg_alpha;
	}
	else {
		COLOR.r = sin((pow(UV.x, 3) + TIME) * 10.0);
		COLOR.g = 1.0 - sin(TIME) * 0.2;
		COLOR.b = 0.5 - cos(TIME) * 0.2;
	
		COLOR.a = pow(avg.a, 4) * bg_alpha;
	}
	
}
