extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func get_state():
	return not $"../YSort/UpperRegionDetector".detected

func turn_off():
	$"../Background/StaticBody2D/GROUND-side-overhang".set_deferred("disabled", true)
	$"../Background/StaticBody2D/ROOF-side-overhang".set_deferred("disabled", false)
	$"../YSort/front-ledge-1".visible = false
	$"../YSort/front-ledge-2".visible = false
	$"../YSort/front-ledge-3".visible = false
	$"../YSort/front-ledge-4".visible = false
	$"../YSort/NorthRoof".disabled = false

func turn_on():
	$"../Background/StaticBody2D/GROUND-side-overhang".set_deferred("disabled", false)
	$"../Background/StaticBody2D/ROOF-side-overhang".set_deferred("disabled", true)
	$"../YSort/front-ledge-1".visible = true
	$"../YSort/front-ledge-2".visible = true
	$"../YSort/front-ledge-3".visible = true
	$"../YSort/front-ledge-4".visible = true
	$"../YSort/NorthRoof".disabled = true
