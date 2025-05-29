extends Sprite2D
class_name StandardBg

#@export var default_scale = Vector2(2, 2)
#@export var default_position = Vector2(-300, -300)

var daylight = preload("res://effects/daylight/daylight_filter_standard_size.tscn")

@export var standard_bg_offset = Vector2(0, 0)
@export var relative_scale = Vector2(1, 1)

# Called when the node enters the scene tree for the first time.
func _ready():
	load_texture()
	var f = daylight.instantiate()
	f.scale = Vector2(1/scale.x, 1/scale.y)
	f.position = Vector2(0, 0) - (position / 2.0)
	f.page = get_parent()
	add_child(f)

func load_texture():
	var game = $"/root".get_node_or_null("Game")
	if not game:
		return
	#var img: Texture = game.get_standard_bg()
	#if not img:
		return
	#texture = img
	var bg = game.get_standard_bg()
	if not bg:
		return
	texture = null
	bg.position = Vector2(200, 0)
	# bg.modulate = "#ffffff88"
	add_child(bg)
	bg.scale = game.get_standard_bg_scale() * relative_scale
	bg.position = game.get_standard_bg_position() + standard_bg_offset
