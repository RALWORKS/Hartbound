extends Node

@export var id: String
@export var title: String
@export var icon: Texture


var game = null


func _get_game():
	if game == null:
		game = $"/root/Game"
	return game


func destroy():
	var g = _get_game()
	g.remove_inventory_item(self)
	queue_free()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
