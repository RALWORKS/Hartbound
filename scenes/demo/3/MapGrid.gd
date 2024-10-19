extends Sprite2D

@export var pencil: Node

var nodes = {}

var active_path = []
var lines = []

var final_line: Line2D

var LINE_COLOR =  "#992211"
var LINE_WIDTH = 20

var MapNode = preload("res://scenes/demo/3/map_node.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	make_starting_node()
	for c in get_children():
		nodes[c.name] = c
		c.connect("crossed", on_node_crossed)
	
	final_line = Line2D.new()
	final_line.width = LINE_WIDTH
	final_line.default_color = LINE_COLOR
	final_line.joint_mode = Line2D.LINE_JOINT_ROUND
	final_line.end_cap_mode = Line2D.LINE_CAP_ROUND
	add_child(final_line)

func make_starting_node():
	var node = MapNode.instantiate()
	node.name = "InitialPosition"
	node.is_starting_node = true
	node.position = pencil.position
	add_child(node)
	active_path.push_back(node.name)

func on_node_crossed(node):
	if node.is_starting_node:
		return
	if active_path[-1] == node.name:
		remove_last_node()
		return
	add_node(node)

func add_node(node):
	var last_line = Line2D.new()
	last_line.joint_mode = Line2D.LINE_JOINT_ROUND
	last_line.width = LINE_WIDTH
	last_line.default_color = LINE_COLOR
	last_line.end_cap_mode = Line2D.LINE_CAP_ROUND
	last_line.add_point(nodes[active_path[-1]].position)
	active_path.push_back(node.name)
	last_line.add_point(nodes[active_path[-1]].position)

	add_child(last_line)
	lines.push_back(last_line)
	

func remove_last_node():
	active_path.pop_back()
	var last_line = lines.pop_back()
	if not last_line:
		return
	last_line.free()

func trace_final_line():
	final_line.clear_points()
	final_line.add_point(nodes[active_path[-1]].position)
	final_line.add_point(pencil.position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	trace_final_line()
