extends Node2D
@export var vein_node: Node
@export var vein_alpha: float

@onready var line = $Leyline
@onready var dark = $Darkness


var animation_length = 5

var game

func _get_game():
	if game == null:
		game = $"/root/Game"
	return game

# Called when the node enters the scene tree for the first time.
func _ready():
	set_vein_node(vein_node)
	if vein_alpha != null:
		$Leyline.material.set_shader_parameter("bg_alpha", float(vein_alpha))
	

func run(parent):
	var g = _get_game()
	if g == null:
		return
	g.leyline_showing = true
	raise(parent)
	dark.get_node("AnimationPlayer").play("show")
	line.get_node("AnimationPlayer").play("show")
	await get_tree().create_timer(animation_length).timeout
	line.free()
	dark.free()

	queue_free()
	g.leyline_showing = false
	

func set_vein_node(n):
	if n == null:
		return
	vein_node = n.duplicate()
	vein_node.visible = true
	#vein_node.get_parent().remove_child(vein_node)
	$Texture.add_child(vein_node)

func raise(parent):
	remove_child(dark)
	parent.add_child(dark)
	parent.move_child(dark, -1)
