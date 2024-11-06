extends Area2D

signal entered
signal exited

var is_active = false

var biome: Node = null
const Biome = preload("res://scenes/demo/3/biome.gd")

# Called when the node enters the scene tree for the first time.
func _ready():
	for c in get_children():
		if c is Biome:
			biome = c



func _on_body_entered(body):
	if not "is_pencil" in body:
		return
	emit_signal("entered", self)
	is_active = true


func _on_body_exited(body):
	if not "is_pencil" in body:
		return
	emit_signal("entered", self)
	is_active = false
