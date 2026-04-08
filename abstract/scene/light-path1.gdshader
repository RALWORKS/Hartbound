shader_type canvas_item;

uniform vec2 dimensions = vec2(1700, 1700); // Resolution of ColorRect in pixels

uniform float rows = 80;
uniform float columns = 80;
uniform float vertical_scroll : hint_range(-1.0, 1.0, 0.01) = 0.5;
uniform float horizontal_scroll : hint_range(-1.0, 1.0, 0.01) = 0.1;
uniform float size_min : hint_range(0.1, 1.0, 0.1) = 0.1;
uniform float size_max : hint_range(0.1, 1.0, 0.1) = 1.0; // If 'size_max' is larger than 0.7 the corners of the particles will be clipped if they are rotating.
uniform float wave_min : hint_range(0.0, 1.0, 0.1) = 0.2;
uniform float wave_max : hint_range(0.0, 1.0, 0.1) = 0.6; // If the particles are waving into the neighbouring columns reduce 'wave_max'.
uniform float wave_speed : hint_range(0.0, 2.0, 0.1) = 1;
uniform float wave_rotation : hint_range(-1.0, 1.0, 0.1) = 1.0;

uniform sampler2D particle_texture : source_color, filter_nearest_mipmap;


void fragment(){
  float time = (10000.0 + TIME)/5.0;
  float row_rn = fract(sin(floor((UV.y - vertical_scroll * time) * rows)));
  float column_rn = fract(sin(floor((UV.x + row_rn - horizontal_scroll * time) * columns)));
  float wave = sin(wave_speed * time + column_rn * 90.0);
  vec2 uv = (vec2(fract((UV.x + row_rn - horizontal_scroll * time + (wave * (wave_min + (wave_max - wave_min) * column_rn) / columns / 2.0)) * columns), fract((UV.y - vertical_scroll * time) * rows)) * 2.0 - 1.0) * vec2(dimensions.x / dimensions.y * rows / columns, 1.0);
  float size = size_min + (size_max - size_min) * column_rn;
  vec4 particle_texture_pixel = texture(particle_texture, (uv / size + 1.0) / 2.0);
  COLOR.rgb = mix(vec3(1.0, 1.0, 1.0), particle_texture_pixel.rgb, particle_texture_pixel.a);
  COLOR.a = particle_texture_pixel.a;
}

void start() {
}

void process() {
	// Place process code here.
}
