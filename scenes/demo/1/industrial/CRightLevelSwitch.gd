extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func turn_on():
	pass

func turn_off():
	$"../../../Background/StaticBody2D/EdgeFromFloor".set_deferred("disabled", false)
	$"../../../Background/StaticBody2D/EdgeFromRoof".set_deferred("disabled", true)
	$"../../../FrontOverhang".set_deferred("visible", true)
	$"../../SouthRoof".set_deferred("disabled", true)
	$"../../Tunnel".set_deferred("disabled", false)
