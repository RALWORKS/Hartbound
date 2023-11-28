extends Node2D

@export var is_under_concept = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func on_start():
	var p = $"../.."
	if is_under_concept:
		p = $"../../../.."
	p.npc.start_following($"/root/Game")
