extends Node

@export var title: String
@export var narrative: String

func mutate():
	var game = $".".get_tree().get_root().get_node("Game")
	push(game)
	
func rerun():
	pass

func push(game):
	game.push_story(title, narrative)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
