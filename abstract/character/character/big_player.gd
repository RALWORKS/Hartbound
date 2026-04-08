extends Node2D

@export var char_id: String = ""

@onready var Back = $Back
@onready var Middle = $Middle
@onready var Front = $Front
@onready var Hair = $Hair
@onready var Skeleton = $Skeleton2D

@onready var PlayerSkin = [
	$BackArm,
	$Torso,
	$BackLeg,
	$FrontLeg,
	$FrontArm,
]

@export var skin_tone = "#ff9988"
@export var outfit_base_color = "#88aa66"
@export var hair_color = "#999966"
@export var anim = "quantized_walk"

var ShoulderCape = "res://character/big_player/shoulder_cape.tscn"
var Ruana = "res://character/big_player/ruana.tscn"
var DressAndCoat = "res://character/big_player/dress_and_coat.tscn"
var GreatKilt = "res://character/big_player/great_kilt.tscn"
var Chiton = "res://character/big_player/chiton.tscn"
var HairLocks = "res://character/big_player/hair_locks.tscn"
var HairLongBun = "res://character/big_player/hair_long_bun.tscn"
var HairLongBraid = "res://character/big_player/hair_long_braid.tscn"
var HairShortBraid = "res://character/big_player/hair_short_braid.tscn"

var SkinAndHairData = preload("res://character/skin_and_hair_data.tscn").instantiate()
var OutfitColor1 = preload("res://character/outfit_color_1.tscn").instantiate()

var HAIR = [HairLocks, HairLongBun, HairLongBraid, HairShortBraid]
var OUTFIT = [Ruana, DressAndCoat, ShoulderCape, Chiton, GreatKilt]
var HAIR_COLOR = SkinAndHairData.HAIR_COLOURS
var SKIN_COLOR = SkinAndHairData.SKIN_COLOURS
var OUTFIT_BASE_COLOR = OutfitColor1.OPTIONS

# Called when the node enters the scene tree for the first time.
func _ready():
	var game = get_game()
	if not game:
		load_default()
		$AnimationPlayer.play(anim)
		return
	load_game(game)
	
func get_game():
	return get_tree().root.get_node_or_null("Game")

func load_game(game):
	var tex = game.get_state(["character", "texture"])
	var outfit = OUTFIT[tex["outfit"]]
	var hair = HAIR[tex["hair"]]
	outfit_base_color = OUTFIT_BASE_COLOR[tex["outfit-color-1"]]
	hair_color = HAIR_COLOR[tex["hair-color"]]
	skin_tone = SKIN_COLOR[tex["skin-color"]]
	load_outfit(outfit)
	load_hair(hair)
	colour_skin()
	if anim:
		$AnimationPlayer.play(anim)
	
func play(some_anim):
	$AnimationPlayer.play(some_anim)

func load_default():
	load_outfit(ShoulderCape)
	#load_outfit(Ruana)
	#load_outfit(DressAndCoat)
	#load_outfit(GreatKilt)
	#load_outfit(Chiton)
	load_hair(HairShortBraid)
	colour_skin()

func colour_skin():
	for s in PlayerSkin:
		s.color = skin_tone

func load_outfit(res):
	var outfit = load_item(res)
	for l in outfit:
		l.color = outfit_base_color

func load_hair(res):
	var hair = load_item(res)
	for l in hair:
		l.color = hair_color

func load_item(res):
	var cls: Resource = load(res)
	var item = cls.instantiate()
	var ret = _load_layers(item)
	item.free()
	return ret

func pre_free():
	for dest in [Back, Middle, Hair, Front]:
		for c in dest.get_children():
			#assert(is_instance_valid(c.owner))
			pass
		dest.free()

func _load_layers(outfit: Node2D):
	var ret = []
	for dest in [Back, Middle, Hair, Front]:
		var old: Node2D = outfit.get_node_or_null(str(dest.name))
		if not old:
			continue
		#dest.position = old.position
		#dest.rotation = old.rotation
		ret += _load_sub_layers(dest, old, old.get_children())
	return ret

func _load_sub_layers(dest: Node2D, old: Node2D, layers: Array[Node]):
	var ret = []
	for l in layers:
		old.remove_child(l)
		l.set_skeleton("../../Skeleton2D")
		dest.add_child(l)
		l.owner = dest
		ret.push_back(l)
	return ret
		
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
