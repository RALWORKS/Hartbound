extends Node2D

@export var sprite: Node2D

## Use InteractableArea
@export var mouseover_area: Area2D
@export var extended_walk_zone: Area2D
@export var child_depth = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	mouseover_area.child_depth = child_depth


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
