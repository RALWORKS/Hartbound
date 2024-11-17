extends Node

var game = null

# Called when the node enters the scene tree for the first time.
func _ready():
	game = $".".get_tree().get_root().get_node("Game")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func on_start():
	game.live_change_player_mode(["taylor_carries_you"])
	print(game.get_active_player_display_modes())
