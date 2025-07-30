extends Node2D

var game: Node = null
@export var pencil: CharacterBody2D
var chapter: Node = null

var default_biome = null
const Biome = preload("res://scenes/demo/3/biome.gd")
const MapArea = preload("res://scenes/demo/3/map_area.gd")
var areas = []
var going = false

var active_area: MapArea = null

# Called when the node enters the scene tree for the first time.
func _ready():
	_init_children()
	_init_areas()
	$"/root/Game".show_clock = false
	$"/root/Game".set_context(ContextType.MAP)

func _init_children():
	for c in get_children():
		if c is Biome:
			default_biome = c
		elif c is MapArea:
			areas.push_back(c)

func _init_areas():
	for a in areas:
		a.connect("entered", activate_area)
		a.connect("exited", deactivate_area)
	
func activate_area(area):
	active_area = area

func deactivate_area(area):
	if active_area == area:
		active_area = null

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
	if Input.is_action_just_released("cancel"):
		cancel()

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

func save_position(position=null):
	var g = _get_game()
	g.set_outer_position(position if position else pencil.position)

func get_biome():
	if active_area:
		return active_area.biome
	return default_biome

func _go_to_pencil():
	save_position()
	#game.jump_over_moves($bg/MapGrid.time_expended())
	
	var biome = get_biome()
	biome.get_parent().remove_child(biome)
	$"/root/Game/Chapter".close_map(biome)

func get_time_expended():
	return $bg/MapGrid.time_expended()

func _go_to_encounter(e: MapEncounter, time_at: int):
	save_position(e.position)
	#game.jump_over_moves(time_at)
	e.get_parent().remove_child(e)
	game.save_map_encounter(e)
	var biome = get_biome()
	biome.get_parent().remove_child(biome)
	$"/root/Game/Chapter".close_map_to_encounter(e, biome)
	

func get_moves_used():
	var encounter_data = $bg/MapGrid.get_encounter()
	if encounter_data["e"] == null:
		return $bg/MapGrid.time_expended()
	return encounter_data["time_at"]

func go():
	if going:
		return
	going = true
	
	var encounter_data = $bg/MapGrid.get_encounter()
	if encounter_data["e"] == null:
		return _go_to_pencil()
	return _go_to_encounter(
		encounter_data["e"], encounter_data["time_at"]
	)
	

func cancel():
	$"/root/Game/Chapter".close_map(null)
