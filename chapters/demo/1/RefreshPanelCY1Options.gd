extends Node

var game

@export var taker: Node
@export var btn: Node

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _get_game():
	if game == null:
		game = $"/root/Game"
	return game

func on_open():
	var g = _get_game()
	
	var collection = g.get_state(taker.COLLECTION_STATE_PATH)

	if (collection != null and taker.item_name in collection):
		btn.enabled = false
	else:
		btn.enabled = true
