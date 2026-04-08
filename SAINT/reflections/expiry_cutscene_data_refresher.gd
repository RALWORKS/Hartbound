extends Node

func on_start():
	var data = ""
	for r in $"../..".input_data:
		data += ("-   " + r.title + "\n\n")
	
	$"../Data".text = data
	
	$"../Data".replace()
