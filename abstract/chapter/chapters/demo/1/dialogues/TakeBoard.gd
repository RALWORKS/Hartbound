extends Node
var game

func _get_game():
	if game == null:
		game = $"/root/Game"
	return game

func action():
	var g = _get_game()
	g.set_state(["micro_progress", "got_board"], true)
	g.set_state_push_to_key(["inventory"], "board")
