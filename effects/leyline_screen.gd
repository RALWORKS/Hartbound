extends Node2D
@export var vein_node: Node

@onready var line = $Leyline
@onready var dark = $Darkness

var animation_length = 5


# Called when the node enters the scene tree for the first time.
func _ready():
	set_vein_node(vein_node)
	

func run(parent):
	raise(parent)
	dark.get_node("AnimationPlayer").play("show")
	line.get_node("AnimationPlayer").play("show")
	await get_tree().create_timer(animation_length).timeout
	line.free()
	dark.free()

	queue_free()
	

func set_vein_node(n):
	vein_node = n
	if vein_node == null:
		return
	vein_node.visible = true
	vein_node.get_parent().remove_child(vein_node)
	$Texture.add_child(vein_node)

func raise(parent):
	remove_child(dark)
	parent.add_child(dark)
	parent.move_child(dark, -1)
