extends Node


@export var trigger_name: String

func on_start():
	$"/root/Game/Chapter".trigger(trigger_name)


func _on_tree_exiting():
	pass # Replace with function body.
