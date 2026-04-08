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
	$"../YSort/NorthRoof".disabled = false
	$"../YSort/SouthRoof".disabled = false
	$"../Background/StaticBody2D/wall-GROUND".set_deferred("disabled", true)
	$"../Background/StaticBody2D/wall-ROOF".set_deferred("disabled", false)
	$"../YSort/back-ledge-a".set_deferred("visible", false)
	$"../YSort/front-ledge".set_deferred("visible", false)
	$"../YSort/far-back-edge".set_deferred("visible", false)
	$"../YSort/Tunnel".set_deferred("disabled", true)
