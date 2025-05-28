class_name Biome

extends Node2D


@export var trigger_name: String

var game

# Called when the node enters the scene tree for the first time.
func _ready():
	game = $".".get_tree().get_root().get_node("Game")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func get_background():
	return $Background.get_children()[0]

func get_camp():
	var camps: Array = $Camps.get_children()
	var r = int(game.get_date() + game.get_time())
	
	
	var i = r % camps.size()
	
	return camps[i].scene.instantiate()
