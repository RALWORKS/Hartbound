extends Node

@export var character_id: String
@export var new_name: String


func on_start():
	$"/root/Game".change_name_of(character_id, new_name)
