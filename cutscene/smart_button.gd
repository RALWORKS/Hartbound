extends "CutsceneOption.gd"

class_name SmartButton


# Called when the node enters the scene tree for the first time.
func _ready():
	text = $StateTagReplacer.replace(text)
