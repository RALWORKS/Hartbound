extends Node2D

@export var animation: String

# Called when the node enters the scene tree for the first time.
func _ready():
	if not animation:
		return
	$AbstractModularCharacter.play(animation)


