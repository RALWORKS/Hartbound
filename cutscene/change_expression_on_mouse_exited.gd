extends Area2D

@export var avatar: Node

@export var default_neutral = true
@export var default_frown = false
@export var default_smile = false
@export var default_scowl = false

func unreact():
	if default_frown:
		return avatar.frown()
	if default_scowl:
		return avatar.scowl()
	if default_smile:
		return avatar.smile()
	return avatar.neutral()


func _on_mouse_exited():
	unreact()
