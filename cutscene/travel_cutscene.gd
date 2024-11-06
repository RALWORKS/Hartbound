extends "Cutscene.gd"

var biome: Node

func _ready():
	biome = input_data
	super._ready()
	teleport_to = biome.get_camp()
	biome.free()
