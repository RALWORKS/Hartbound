extends Node2D

@export var paused = false

# Called when the node enters the scene tree for the first time.
func _ready():
	var parent = get_parent()
	if "paused" in parent:
		paused = parent.paused
	if paused:
		return
	$AnimationPlayer.play_backwards("base")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
