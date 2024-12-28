extends Node2D

@onready var Back = $Back
@onready var Middle = $Middle
@onready var Front = $Front
@onready var Skeleton = $Skeleton2D

@onready var PlayerSkin = [
	$BackArm,
	$Torso,
	$BackLeg,
	$FrontLeg,
	$FrontArm,
]

@export var skin_tone = "#ff9988"

var ShoulderCape = "res://character/big_player/shoulder_cape.tscn"
var Ruana = "res://character/big_player/ruana.tscn"
var DressAndCoat = "res://character/big_player/dress_and_coat.tscn"
var GreatKilt = "res://character/big_player/great_kilt.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	load_design()
	$AnimationPlayer.play("base")


func load_design():
	#load_outfit(ShoulderCape)
	#load_outfit(Ruana)
	#load_outfit(DressAndCoat)
	load_outfit(GreatKilt)
	colour_skin()

func colour_skin():
	for s in PlayerSkin:
		s.color = skin_tone

func load_outfit(res):
	var cls: Resource = load(res)
	var outfit = cls.instantiate()
	_load_layers(outfit)
	outfit.free()

func _load_layers(outfit: Node2D):
	for dest in [Back, Middle, Front]:
		var old: Node2D = outfit.get_node_or_null(str(dest.name))
		if not old:
			continue
		#dest.position = old.position
		#dest.rotation = old.rotation
		_load_sub_layers(dest, old, old.get_children())

func _load_sub_layers(dest: Node2D, old: Node2D, layers: Array[Node]):
	for l in layers:
		old.remove_child(l)
		print(l)
		l.set_skeleton("../../Skeleton2D")
		dest.add_child(l)
		
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
