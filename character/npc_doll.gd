extends Node2D

@onready var Back = $Back
@onready var Middle = $Middle
@onready var Front = $Front
@onready var Hair = $Hair
@onready var Skeleton = $Skeleton2D

@export var char_id = ""

@export var anim = "quantized_walk"


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play(anim)

	
func get_game():
	return get_tree().root.get_node_or_null("Game")

func load_game(game):
	pass
	

func load_default():
	pass

func load_item(res):
	var cls: Resource = load(res)
	var item = cls.instantiate()
	var ret = _load_layers(item)
	item.free()
	return ret

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
		ret.push_back(l)
	return ret
		
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
