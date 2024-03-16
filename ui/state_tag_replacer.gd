extends Node

var game


func _get_game():
	if game == null:
		game = $"/root/Game"
	return game

func replace(t):
	var g = _get_game()
	
	var state_tag = RegEx.new()
	state_tag.compile("\\{[a-zA-Z,_]+\\}")
	var state_matches = state_tag.search_all("m" + t)
	
	var name_tag = RegEx.new()
	name_tag.compile("\\<[a-zA-Z_]+\\>")
	var name_matches = name_tag.search_all("m" + t)
	
	var tag
	var value
	
	for match_obj in state_matches:
		tag = match_obj.get_string()
		if not t.contains(tag):
			continue
		value = g.get_state(tag.replace("{", "").replace("}", "").split(","))
		t = t.replace(tag, value)

	for match_obj in name_matches:
		tag = match_obj.get_string()
		if not t.contains(tag):
			continue
		value = g.name_of(tag.replace("<", "").replace(">", ""))
		if value == null:
			push_error("Invalid replacement name:", tag)

		t = t.replace(tag, value)
	
	return t
