extends Node

@export var player: AnimationPlayer
@export var animation_name = "base"
@export var speed = 1.00

# Called when the node enters the scene tree for the first time.
func _ready():
	if player != null:
		player.play(animation_name, -1, speed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
