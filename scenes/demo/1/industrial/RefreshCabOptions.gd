extends Node

var game

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _get_game():
	if game == null:
		game = $"/root/Game"
	return game

func on_open():
	var g = _get_game()
	
	if g.get_state(["micro_progress", "got_key"]) == true:
		$"../Actions/TakeKey".enabled = false
	else:
		$"../Actions/TakeKey".enabled = true
