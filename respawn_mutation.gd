extends Node

func rerun():
	pass

func mutate():
	var game = $".".get_tree().get_root().get_node("Game")
	game.player.respawn()
