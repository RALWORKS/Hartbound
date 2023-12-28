extends Node

@export var cutscene: Resource
@export var to_scene: Resource
@export var effect: String
@export var played = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func play():
	print(name)
	var game = $".".get_tree().get_root().get_node("Game")	
	
	if effect != null:
		game.get_node("MainScreen/Effects").play(effect)
	if to_scene != null:
		var scene0 = to_scene.instantiate()
		game.get_node("Map").move_to(scene0)
		scene0.spawn(game)
	if cutscene != null:
		await get_tree().create_timer(0.2).timeout
		$"../..".start_cutscene(cutscene)
	for mutation in get_children():
		mutation.mutate()
	
	game.set_state(["micro_progress", "event"], get_index() + 1)
	played = true
