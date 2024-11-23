extends Node


func on_start():
	var game = $".".get_tree().get_root().get_node("Game")
	game.get_node("Chapter").to_map()
	game.set_state(["party"], [])
	game.set_state(["micro_progress", "player_display_modes"], ["wobbly_no_canes"])
	await get_tree().create_timer(0.2).timeout
	game.get_node("Chapter").end_cutscene(true)
	
