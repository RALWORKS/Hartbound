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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _move_to(dest: Node):
	$"..".staged_action_node = null
	var old = current
	current = dest
	var contents = null
	if chapter:
		contents = chapter.get_node_or_null(dest.name + "Contents")
	dest.contents_node = contents
	$"../MainScreen/World".call_deferred("add_child", dest)
	if not old:
		return
	assert(old != $"..")
	old.call_deferred("free")
	
func traverse(dest, entrance):
	#var dest = load(dest_resource).instantiate()
	#dest.spawn_at = dest_edge
	_move_to(dest)
#	dest.add_chapter_contents()
	dest.get_node("YSort").get_node(entrance).spawn($"..")
