extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass



func _on_to_codex_pressed():
	$".".visible = false
	$"../Codex".visible = true
