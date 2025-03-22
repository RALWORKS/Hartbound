shader_type canvas_item;
uniform sampler2D profile;

void fragment() {
	if (COLOR.a != 0.0) {
		vec4 color = texture(profile, UV);
		color.a = COLOR.a;
		COLOR = color;
	}
}

