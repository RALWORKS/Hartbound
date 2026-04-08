extends Node2D

@export var open_them = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func on_start():
	if open_them:
		$AnimationPlayer.play("close", -1, 0.5, true)
	else:
		$AnimationPlayer.play("close", -1, 0.5)
