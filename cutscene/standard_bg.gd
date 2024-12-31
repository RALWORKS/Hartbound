extends Sprite2D
class_name StandardBg

#@export var default_scale = Vector2(2, 2)
#@export var default_position = Vector2(-300, -300)

# Called when the node enters the scene tree for the first time.
func _ready():
	load_texture()

func load_texture():
	var game = $"/root".get_node_or_null("Game")
	if not game:
		return
	var img: Texture = game.get_standard_bg()
	if not img:
		return
	texture = img
	scale = game.get_standard_bg_scale()
	position = game.get_standard_bg_position()
