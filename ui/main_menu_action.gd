extends Node


var game

func _get_game():
	if game == null:
		game = get_tree().get_root().get_node("Game")
	return game

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func action():
	var g = _get_game()
	if not $"..".keep_music:
		g.play_music($Music)
	g.main_menu()
