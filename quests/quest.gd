extends Node

var game

func _get_game():
	if game == null:
		game = get_tree().get_root().get_node("Game")
	return game

@export var id = ""
@export var headline = ""
@export var on_start_modal_maker: Node
@export var on_done_modal_maker: Node
@export var on_done_script_node: Node
@export var on_start_script_node: Node

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(id.length() > 0)
	assert(headline.length() > 0)


func start():
	if on_start_modal_maker != null:
		if not on_start_modal_maker.title.length():
			on_start_modal_maker.title = "New Quest: " + self.headline
		on_start_modal_maker.make()
	if on_start_script_node != null:
		on_start_script_node.action()
	var g = _get_game()
	g.start_quest(self)

func complete():
	if on_done_modal_maker != null:
		if not on_done_modal_maker.title.length():
			on_done_modal_maker.title = "Quest Complete: " + self.headline
		on_done_modal_maker.make()
	if on_done_script_node != null:
		on_done_script_node.action()
	var g = _get_game()
	g.complete_quest(self)
