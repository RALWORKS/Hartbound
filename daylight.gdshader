shader_type canvas_item;

uniform sampler2D screen_texture;
uniform float darken = 0.0;
uniform float saturate = 1.0;
uniform float contrast = 1.0;
uniform float warmth = 0.5;

const vec4 white = vec4(1.0, 1.0, 1.0, 1.0);
const vec4 blue = vec4(0.0, 0.3, 1.0, 1.0);
const vec4 gold = vec4(1.0, 0.6, 0.0, 1.0);
const vec4 black = vec4(0.0, 0.0, 0.0, 1.0);

vec4 greyish(float brightness, vec4 orig) {
	float bp = 1.0 - saturate;
	return orig * saturate + (white * brightness * bp);
}

vec4 contr(vec4 orig) {
	float cp = 1.0 - contrast;
	return contrast*orig + cp*(white - darken*white);
}

void fragment() {
	vec4 orig = texture(screen_texture, UV);
	
	float brightness = pow(pow(orig.r, 3) + pow(orig.g, 3) + pow(orig.b, 3), 1.0/3.0);
	
	vec4 greyd = greyish(brightness, orig);
	
	vec4 warmer;
	if (warmth < 0.5) {
		warmer = blue;
	}
	else {
		warmer = gold;
	}
	
	float rat = 2.0 * abs(0.5 - warmth);
	
	vec4 res = (rat*warmer*brightness + (1.0-rat)*greyd);
	
	vec4 new = contr(res - (darken * white));
	// vec4 new = greyd - (darken * white);
	
	new.a = 1.0;
	
	COLOR = new;
}