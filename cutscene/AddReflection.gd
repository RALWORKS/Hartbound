extends Node

func action():
	var data = $"..".get_children()
	var reflection = data.filter(func (i): return "id" in i)[0]
	$"/root/Game".add_reflection(reflection.id)
