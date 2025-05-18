extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func refresh():
	$MomLaughing1.get_node("Mom").refresh()
	$DadPraying1.get_node("Dad").refresh()

func on_start():
	refresh()
