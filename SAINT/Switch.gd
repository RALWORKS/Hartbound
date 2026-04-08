extends Node2D

@export var on_off_script: Node = null
@export var extend_on_switch: Area2D = null
@export var extend_off_switch: Area2D = null

@export var on = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if extend_off_switch != null:
		extend_off_switch.connect("area_entered", _on_off_area_entered)
	if extend_on_switch != null:
		extend_off_switch.connect("area_entered", _on_on_area_entered)
#	if on_off_script != null:
#		on = on_off_script.get_state()
#		print("turn", on)
#		if on:
#			on_off_script.turn_on()
#		else:
#			on_off_script.turn_off()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_on_area_entered(body):
	if body.name != "InteractBox":
		return
	if not on and on_off_script != null:
		on_off_script.turn_on()
	on = true


func _on_off_area_entered(body):
	if body.name != "InteractBox":
		return
	if on and on_off_script != null:
		on_off_script.turn_off()
	on = false


func _on_on_area_exited(area):
	_on_on_area_entered(area)


func _on_off_area_exited(area):
	_on_off_area_entered(area)
