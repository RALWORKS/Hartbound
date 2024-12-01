extends Node


var destinations = {}

var current = null
var chapter: Node = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func start(initial, next_chapter):
	chapter = next_chapter
	_move_to(initial, false)

func move_to(place, as_move=true):
	_move_to(place, as_move)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func set_contents_node(dest: Node):
	var contents = null
	if chapter:
		contents = chapter.get_node_or_null(dest.name + "Contents")
	dest.contents_node = contents
	

func _move_to(dest: Node, as_move: bool = true):
	$"..".get_node("MainScreen").clear_postprocessing()
	
	$"..".staged_action_node = null
	var old = current
	current = dest
	dest.position = Vector2(0, 0)
	set_contents_node(dest)
	$"../MainScreen/World".call_deferred("add_child", dest)
	if not old:
		return
	assert(old != $"..")
	old.call_deferred("free")
	
	if as_move:
		await get_tree().create_timer(0.1).timeout
		$"..".move()
	

func load_position(data):
	var dest = load(data["scene_path"]).instantiate()
	
	if "x" in data and "y" in data:
		traverse(dest, data["entrance_name"], false, false, data.x, data.y)
	else:
		traverse(dest, data["entrance_name"], false, false)
	
func traverse(dest, entrance, save=true, as_move=true, x=null, y=null):
	#var dest = load(dest_resource).instantiate()
	#dest.spawn_at = dest_edge
	_move_to(dest, as_move)
	if not entrance:
		entrance = "DefaultSpawner"
	var next_entrance: Node2D = dest.get_node("YSort").get_node(entrance)
	next_entrance.spawn($"..", x, y)
	if save:
		$"..".save_room(dest.scene_file_path, entrance)
