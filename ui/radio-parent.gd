extends Node2D

var gender = null

var value = null


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
		

func reset():
	for child in $".".get_children():
		child.button_pressed = false

func child_clicked(child):
	reset()
	child.button_pressed = true
	value = child.value
