extends Node

func action():
	var data = $"..".get_children()
	var resolution = data.filter(func (i): return i.id != null)[0]
	$"/root/Game".add_resolution(resolution.id)
