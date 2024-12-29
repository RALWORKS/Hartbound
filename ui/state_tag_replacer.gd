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
	
	var tag: String
	var value
	var key: String
	var state_key: Array[String]
	
	for match_obj in state_matches:
		tag = match_obj.get_string()
		if tag == null:
			continue
		if not t.contains(tag):
			continue
		state_key = str(tag).replace("{", "").replace("}", "").split(",")
		if state_key.size() < 1:
			continue
		value = g.get_state(state_key)
		if value == null or not value or value.size == 0:
			push_error("No replacement data at state:", state_key)
			continue
		t = t.replace(tag, value)

	for match_obj in name_matches:
		tag = str(match_obj.get_string())
		if tag.length() == 0:
			continue
		if not t.contains(tag):
			continue
		key = str(tag)
		key = key.replace("<", "").replace(">", "")
		if key.length() == 0 or key == null or key=="null": # reparsing bug 
			continue
		value = g.name_of(key)
		if value == null:
			push_error("Invalid replacement name:", key, " (TYPE=", typeof(key), ")")
			continue

		t = t.replace(tag, value)
	
	return t
