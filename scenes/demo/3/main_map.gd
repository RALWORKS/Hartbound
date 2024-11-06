extends Node2D

var game: Node = null
@export var pencil: CharacterBody2D
var chapter: Node = null

var default_biome = null
const Biome = preload("res://scenes/demo/3/biome.gd")
const MapArea = preload("res://scenes/demo/3/map_area.gd")
var areas = []

var active_area: MapArea = null

# Called when the node enters the scene tree for the first time.
func _ready():
	_init_children()
	_init_areas()

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
	if active_area:
		return active_area.biome
	return default_biome

func go():
	save_position()
	var biome = get_biome()
	biome.get_parent().remove_child(biome)
	$"/root/Game/Chapter".close_map(biome)
