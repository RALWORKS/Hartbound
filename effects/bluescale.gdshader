shader_type canvas_item;

uniform vec4 tint = vec4(0.6, 0.83, 0.97, 1.0);
uniform vec4 highlight = vec4(0.8, 0.85, 0.6, 1.0);
uniform float alpha = 1.0;

void fragment() {
    vec4 colour = texture(TEXTURE, UV);
    
	float shade = (colour.x + colour.y + colour.z) / 2.0;
	
	vec4 cell = tint;
	if (shade > 0.9) {
		cell = highlight;
	}
	
	vec4 result = vec4(cell.r * shade, cell.g * shade, cell.b * shade, colour.a * alpha);

    COLOR = result;
}
