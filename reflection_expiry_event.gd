extends "res://ChapterEvent.gd"


func _side_effect():
	get_children()[0].expire()
