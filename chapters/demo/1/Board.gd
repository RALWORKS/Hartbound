extends Sprite2D

var game = null

func _get_game():
	if game == null:
		game = $"/root/Game"
	return game

# Called when the node enters the scene tree for the first time.
func _ready():
	call_deferred("_refresh")	

func _refresh():
	var g = _get_game()
	if g.get_state(["micro_progress", "got_board"]) == true:
		call_deferred("free")

func take():
	var g = _get_game()
	g.set_state(["micro_progress", "got_board"], true)
	call_deferred("free")
