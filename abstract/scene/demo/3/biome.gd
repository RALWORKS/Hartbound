class_name Biome

extends Node2D


@export var trigger_name: String
@export var background: Resource
@export var travel_stretch: Resource


var game
var camp

func _get_game():
	if game != null:
		return game
	return $".".get_tree().get_root().get_node("Game")

# Called when the node enters the scene tree for the first time.
func _ready():
	game = _get_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func get_camp(g=null):
	if g == null:
		g = _get_game()
	var camps: Array = $Camps.get_children()
	var r = int(g.get_date() + g.get_time())
	
	
	var i = r % camps.size()
	
	return camps[i].scene.instantiate()
