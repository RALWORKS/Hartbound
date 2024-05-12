extends Node

func action():
	var data = $"..".get_children().filter(func (i): return "id" in i)
	var resolution = data[0]
	#var resolution = $"..".data
	$"/root/Game".add_resolution(resolution.id)
	if resolution.reflection_id != "":
		$"/root/Game".resolve_reflection(resolution.reflection_id)
