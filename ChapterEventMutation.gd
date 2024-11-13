extends Node

@export var state_path_slash_delineated: String
@export var data: String
@export var parse_data_as_int: bool
@export var current_plus_data: bool
@export var parse_data_as_bool: bool
@export var data_as_slash_sep_list: bool

func _parse_path(p: String):
	return p.split("/")
	
func rerun():
	pass

func mutate():
	var game = $".".get_tree().get_root().get_node("Game")
	var path = _parse_path(state_path_slash_delineated)
	var d = data
	if parse_data_as_int:
		d = int(data)
	elif parse_data_as_bool:
		d = data == "true"
	elif data_as_slash_sep_list:
		d = data.split("/")
	if current_plus_data:
		var cur = game.get_state(path)

		if typeof(cur) == TYPE_ARRAY:
			cur.append(d)
			game.set_state(path, cur)
		else:
			game.set_state(path, d + cur)
	else:
		game.set_state(path, d)
	game.refresh_data()
	
	

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
