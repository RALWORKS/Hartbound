extends Node

@export var path = ""
@export var data = ""
@export var data_path = ""

func on_start():
	var g = $"/root/Game"
	
	if data_path:
		data = g.get_state(data_path.split(","))
	
	g.set_state(path.split(","), data)
