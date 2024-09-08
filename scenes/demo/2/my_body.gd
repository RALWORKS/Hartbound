extends Node

@onready var cut = preload("res://chapters/demo/2/return_to_your_body.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	$"..".title = $"/root/Game".get_state(["character", "name", "short"])

func action():
	$"/root/Game/Chapter".start_cutscene(cut)
