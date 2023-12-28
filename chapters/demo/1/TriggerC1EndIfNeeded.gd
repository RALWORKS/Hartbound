extends Node
@export var cutscene: Node
var next_cutscene = preload("res://chapters/demo/1/c_1_end.tscn")

const COLLECTION_STATE_PATH = ["micro_progress", "collected"]

var game

func _get_game():
	if game == null:
		game = $"/root/Game"
	return game

func on_start():
	assert(cutscene != null)
	
	var g = _get_game()
	var prog = g.get_state(COLLECTION_STATE_PATH)
	if prog == null:
		return
	if prog.size() < 3:
		return
	
	cutscene.next_cutscene = next_cutscene
	
