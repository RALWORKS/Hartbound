extends Node2D

var InteractButton = preload("res://item/interact_button.tscn")
var PlantCutscene = preload("res://chapters/demo/0/plant_cutscene.tscn")

func show_scent_cutscene():
	$"/root/Game/Chapter".start_cutscene(PlantCutscene)

var options = [
	["Smell plants", show_scent_cutscene]
] # array of pairs: ["label", on_3click]


# Called when the node enters the scene tree for the first time.
func _ready():
	_make_options()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _make_options():
	for pair in options:
		var btn = InteractButton.instantiate()
		btn.text = pair[0]
		btn.onclick = pair[1]
		$Options.add_child(btn)

func interact_range_entered():
	$Options.visible = true

func interact_range_exited():
	$Options.visible = false


func _on_window_close_requested():
	$Window.visible = false
