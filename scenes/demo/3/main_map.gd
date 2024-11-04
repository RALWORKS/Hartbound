extends Node2D

var game: Node = null
@export var pencil: CharacterBody2D
var chapter: Node = null

var MountainBiome = preload("res://scenes/demo/3/mountain_biome.tscn")

@onready var tmp_biome = MountainBiome.instantiate()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if pencil == null:
		return
	if pencil.grid == null:
		return
	if not pencil.grid.moved:
		return
	if Input.is_action_just_released("next"):
		go()

func _get_game():
	if game:
		return game
	game = $"/root/Game"
	return game

func load_position(g):
	#var g = _get_game()
	var p = g.get_outer_position()
	if p == null:
		return
	pencil.position = p

func save_position():
	var g = _get_game()
	g.set_outer_position(pencil.position)

func get_biome():
	return tmp_biome

func go():
	save_position()
	var biome = get_biome()
	$"/root/Game/Chapter".close_map(biome)
