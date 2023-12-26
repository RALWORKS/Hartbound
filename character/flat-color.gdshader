shader_type canvas_item;

uniform vec4 color;

uniform float angle = -0.9;
uniform float divisions = 100.0;
uniform float stripe_bias = 2;

uniform float contrast = 0.03;
uniform float opacity = 1.0;
uniform float fade = 0.0;


void fragment() {
	vec2 distal = UV - vec2(0.5, 0.5);
	float dist_x = abs(distal.x);
	float dist_y = abs(distal.y);
	float dist = sqrt(dist_x*dist_x + dist_y*dist_y);
	float dissolve = (dist*dist) * fade;
	vec4 c = color;
	vec4 orig = texture(TEXTURE, UV);
	
	float w = (cos(angle) * UV.x + sin(angle) * UV.y);
	
	if (orig.a == 0.0) {
		c.a = 0.0;
	}
	else if (orig.a < opacity) {
		c.a = orig.a - dissolve;
	}
	else {
		c.a = opacity - dissolve;
	}
	
	float half_contrast = contrast / 2.0;
	
	if (floor(mod(w * divisions, stripe_bias)) < 0.0001) {
		c.r = c.r - half_contrast;
		c.b = c.b - half_contrast;
		c.g = c.g - half_contrast;
	} else {
		c.r = c.r + half_contrast;
		c.b = c.b + half_contrast;
		c.g = c.g + half_contrast;
	}
	
	COLOR = c;
}
