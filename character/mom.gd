extends Node2D

@export var skin: Node2D
@export var hair: Node2D


var SKIN_MAP = [6, 0, 3, 4, 5, 6, 5]
var HAIR_MAP = [1, 2, 3, 4, 5, 6, 5, 4]

func _ready():
	var game = $"/root/Game"
	var player_data = game.get_state(["character", "texture"])
	
	var mom_skin = $SkinAndHairData.SKIN_COLOURS[
		SKIN_MAP[player_data["skin-color"]]
	]
	var mom_hair = $SkinAndHairData.HAIR_COLOURS[
		HAIR_MAP[player_data["hair-color"]]
	]
	
	if skin:
		skin.modulate = mom_skin
	
	if hair:
		hair.modulate = mom_hair
