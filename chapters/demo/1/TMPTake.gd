extends Node

var InteractionModal = preload("res://item/interaction_modal.tscn")

@export var option_to_disable: Node
@export var item_name: String

const COLLECTION_STATE_PATH = ["micro_progress", "collected"]

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
	if option_to_disable != null:
		option_to_disable.enabled = false
	var g = _get_game()
	g.set_state_push_to_key(COLLECTION_STATE_PATH, item_name)
	
	if g.get_state(COLLECTION_STATE_PATH).size() < 3:
		return
	
	var cur_window = InteractionModal.instantiate()
	cur_window.title = "Quest Complete: Salvaging Components"
	cur_window.set_description("You did it! That's all there is for puzzles for now.")
	cur_window.open(g)
