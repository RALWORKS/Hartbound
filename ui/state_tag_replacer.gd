extends Node

var game

func _get_game():
	if game == null:
		game = $"/root/Game"
	return game

func replace(t):
	var g = _get_game()
	
	var reg = RegEx.new()
	reg.compile("\\{[a-zA-Z,_]+\\}")
	var matches = reg.search_all("m" + t)
	
	for match_obj in matches:
		var tag = match_obj.get_string()
		if not t.contains(tag):
			continue
		var value = g.get_state(tag.replace("{", "").replace("}", "").split(","))
		t = t.replace(tag, value)
	
	return t
