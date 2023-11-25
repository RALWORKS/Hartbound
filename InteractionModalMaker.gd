extends Node

var InteractionModal = preload("res://item/interaction_modal.tscn")
var ImageInteractionModal = preload("res://item/image_interaction_modal.tscn")

@export var title: String
@export var description: String
@export var options_container_node: Node
@export var image_texture: Texture2D

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

func make():
	var g = _get_game()
	var cur_window
	if image_texture != null:
		cur_window = ImageInteractionModal.instantiate()
		cur_window.set_image_texture(image_texture)
	else:
		cur_window = InteractionModal.instantiate()
	cur_window.title = title
	cur_window.set_description(description)
	cur_window.set_options(options_container_node)
	
	cur_window.open(g)
