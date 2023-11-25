extends Area2D

@export var enabled = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func interact_range_entered():
	if not enabled:
		return
	$"../../InteractionArea".interact_range_entered()

func interact_range_exited():
	if not enabled:
		return
	$"../../InteractionArea".interact_range_exited()
