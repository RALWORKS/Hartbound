extends Node
@export var cutscene: Node
var next_cutscene = preload("res://chapters/demo/1/c_1_end.tscn")

const INV_STATE_PATH = ["inventory"]
const REQUIRED_ITEMS = ["pcb", "wire", "alternator"]

func check_done():
	var g = _get_game()
	var items = g.get_state(INV_STATE_PATH)
	for i in REQUIRED_ITEMS:
		if i not in items:
			return false
	return true

var game

func _get_game():
	if game == null:
		game = $"/root/Game"
	return game

func on_start():
	assert(cutscene != null)
	
	if not check_done():
		return
	
	cutscene.next_cutscene = next_cutscene
	
