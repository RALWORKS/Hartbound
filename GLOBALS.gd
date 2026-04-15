extends Node

@onready var g: Game = $"/root/Game"



func null_or_empty(s):
	return s == null or s.is_empty()


func not_null(item):
	if item == null:
		return false
	return true
