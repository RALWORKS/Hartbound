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
	var taker = $"../../MO-Car-Hood-C-Yes-2/Actions/Harvest/MakeHarvest/Options/Take/TMPTake"
	var collection = g.get_state(taker.COLLECTION_STATE_PATH)
	if (collection != null and taker.item_id in collection):
		$"../../MO-Car-Hood-C-Yes-2/Actions/Harvest".enabled = false
	else:
		$"../../MO-Car-Hood-C-Yes-2/Actions/Harvest".enabled = true
