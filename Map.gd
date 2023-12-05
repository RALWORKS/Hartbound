extends Node


var destinations = {}

var current = null
var chapter: Node = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func start(initial, next_chapter):
	chapter = next_chapter
	_move_to(initial)

func move_to(place):
	_move_to(place)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func set_contents_node(dest: Node):
	var contents = null
	if chapter:
		contents = chapter.get_node_or_null(dest.name + "Contents")
	dest.contents_node = contents
	$"../MainScreen/World".call_deferred("add_child", dest)
	

func _move_to(dest: Node):
	$"..".staged_action_node = null
	var old = current
	current = dest
	dest.position = Vector2(0, 0)
	set_contents_node(dest)
	if not old:
		return
	assert(old != $"..")
	old.call_deferred("free")
	
func traverse(dest, entrance):
	#var dest = load(dest_resource).instantiate()
	#dest.spawn_at = dest_edge
	_move_to(dest)
	dest.get_node("YSort").get_node(entrance).spawn($"..")
