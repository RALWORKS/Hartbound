extends Node

@export var id = ""
@export var as_verb_object: String = ""
@export var title = ""
@export var flex_title = ""
@export var hide_for_npc_name = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(id.length() > 0)
	
	if as_verb_object == "":
		as_verb_object = title
	
	if flex_title == "":
		flex_title = title


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
