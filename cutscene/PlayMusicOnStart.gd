extends Node

@export var music: AudioStreamPlayer

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

func on_start():
	var g = _get_game()
	if music == null:
		return
	g.play_music(music)
