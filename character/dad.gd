extends Node2D

@export var skin: Node2D
@export var hair: Node2D


var SKIN_MAP = [0, 1, 2, 3, 4, 5, 6]
var HAIR_MAP = [0, 1, 2, 3, 4, 5, 6, 7]

func _ready():
	refresh()

func refresh():
	var game = $"/root/Game"
	var player_data = game.get_state(["character", "texture"])
	
	var dad_skin = $SkinAndHairData.SKIN_COLOURS[
		SKIN_MAP[player_data["skin-color"]]
	]
	var dad_hair = $SkinAndHairData.HAIR_COLOURS[
		HAIR_MAP[player_data["hair-color"]]
	]
	
	if skin:
		skin.modulate = dad_skin
	
	if hair:
		hair.modulate = dad_hair
