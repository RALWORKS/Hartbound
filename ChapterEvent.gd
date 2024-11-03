extends Node

@export var cutscene: Resource
@export var to_scene: Resource
@export var effect: String
@export var played = false
@export var reusable = false
var cutscene_input_data = null

var game

func _get_game():
	if game == null:
		game = $".".get_tree().get_root().get_node("Game")	
	return game

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _play(save=true):
	var g = _get_game()
	if not reusable:
		played = true
	if save:
		g.set_state_push_to_key(["micro_progress", "events"], get_index())

func _mutate():
	for mutation in get_children():
		mutation.mutate()

func _re_mutate():
	for mutation in get_children():
		mutation.rerun()

func _cutscene():
	if cutscene != null:
		await get_tree().create_timer(0.2).timeout
		$"../..".start_cutscene(cutscene, null, null, null, cutscene_input_data)

func _effect():
	var g = _get_game()
	if effect != null:
		g.get_node("MainScreen/Effects").play(effect)

func _teleport():
	var g = _get_game()
	if to_scene != null:
		var scene0 = to_scene.instantiate()
		g.get_node("Map").move_to(scene0, false)
		scene0.spawn(g)
	

func rerun():
	_re_mutate()
	_play(false)

func _side_effect():
	pass


func play():
	_side_effect()
	_mutate()
	_teleport()
	_cutscene()
	_effect()
	_play(true)
