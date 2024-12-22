extends Node2D

@onready var Back = $Back
@onready var Middle = $Middle
@onready var Front = $Front
@onready var Skeleton = $Skeleton2D

var ShoulderCape = "res://character/big_player/shoulder_cape.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	load_design()
	$AnimationPlayer.play("base")


func load_design():
	load_outfit(ShoulderCape)

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
