extends Sprite2D

@export var target: Vector2
var ico: Node2D
var arrow: Node2D

func _ready():
	arrow = get_parent()
	if get_children().size() > 0:
		ico = get_child(0)

func _process(_delta):
	if arrow and ico and ico.rotation != -rotation:
		ico.rotation = -rotation
