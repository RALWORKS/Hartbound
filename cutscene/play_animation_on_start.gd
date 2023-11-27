extends Node

@export var player: AnimationPlayer
@export var animation_name = "base"
@export var speed = 1.00
@export var repeat = -1
@export var from_end = false

func on_start():
	if player != null:
		player.play(animation_name, repeat, speed, from_end)
