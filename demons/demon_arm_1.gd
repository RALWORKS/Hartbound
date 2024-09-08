extends Sprite2D

@export var animation_offset = 0.0
@export var hazard = true

# Called when the node enters the scene tree for the first time.
func _ready():
	$DemonHazard.active = hazard
	await get_tree().create_timer(animation_offset).timeout
	$arm/AnimationPlayer.play("base")
