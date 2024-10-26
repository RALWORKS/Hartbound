extends Node2D
@export var mul = 1
@export var offset = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(offset).timeout
	$Wrap/Sprite.play("base")
	for c in get_children():
		if c.has_method("play"):
			c.play("base", c.speed_scale * mul)
