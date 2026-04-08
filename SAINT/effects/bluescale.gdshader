shader_type canvas_item;

uniform vec4 tint = vec4(0.6, 0.83, 0.97, 1.0);
uniform vec4 highlight = vec4(0.8, 0.85, 0.6, 1.0);
uniform float alpha = 1.0;

float _get_shade(vec4 colour) {
	return (colour.x + colour.y + colour.z) / 2.0;
}

float _get_avg(sampler2D t) {
	float total = 0.0;
	float count = 0.0;
	
	float inc = 0.2;
	float x = 0.0;
	float y = 0.0;
	
	while (y < 1.0) {
		while (x < 1.0) {
			vec4 c = texture(t, vec2(x, y));
			if (c.w > 0.0) {
				count += 1.0;
				total += _get_shade(c);
			}
			
			x += inc;
		}
		x = 0.0;
		y += inc;
	}
	
	return total / count;
}

void fragment() {
    vec4 colour = texture(TEXTURE, UV);
    
	float shade = _get_shade(colour);
	float avg = _get_avg(TEXTURE);
	
	vec4 cell = tint;
	//if (shade > 0.9) {
	if (shade > (1.3 * avg)) {
		cell = highlight;
	}
	
	vec4 result = vec4(cell.r * shade, cell.g * shade, cell.b * shade, colour.a * alpha);

    COLOR = result;
}
