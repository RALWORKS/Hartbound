extends Node2D

var game = null

func _get_game():
	if game == null:
		game = $"/root/Game"
	return game

func _ready():
	call_deferred("_refresh")

func _refresh():
	var g = _get_game()
	var got_key = g.get_state(["micro_progress", "got_key"])
	if got_key:
		$InteractionArea/Actions/Open.enabled = true
