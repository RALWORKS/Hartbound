extends Node

func on_start():
	var data = get_children()[0]
	$"/root/Game".add_reflection(data.id)
