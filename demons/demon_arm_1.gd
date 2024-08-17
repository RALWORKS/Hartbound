extends Sprite2D

@export var animation_offset = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(animation_offset).timeout
	$arm/AnimationPlayer.play("base")
