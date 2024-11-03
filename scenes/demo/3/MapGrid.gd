extends Sprite2D

@export var pencil: Node
var camera: Camera2D

var nodes = {}

var active_path = []
var lines = []

var final_line: Line2D

var start_mark = null

var LINE_COLOR =  "#992211"
var LINE_WIDTH = 20

var distance = 0
var base_distance = 0

var moved = false

@onready var counter = $Counter
@onready var travel_tip = $Counter/TravelTip
@onready var travel_tip_animation = $Counter/TravelTip/AnimationPlayer
@onready var counter_max = $Counter/Max
@onready var counter_data = $Counter/Data

@export var PX_PER_HOUR = 200
@export var MAX_HOURS = 12

var StartMark = preload("res://scenes/demo/3/start_mark.tscn")
var MapNode = preload("res://scenes/demo/3/map_node.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	remove_child(counter)	
	pencil.add_child(counter)
	pencil.grid = self
	counter.position = Vector2(150, 100)
	travel_tip_animation.play("base")

	counter_max.text = str(MAX_HOURS)

	make_starting_node()
	for c in get_children():
		if "MapNode" not in c.name:
			print(c)
			continue
		nodes[c.name] = c
		c.connect("crossed", on_node_crossed)
	
	final_line = Line2D.new()
	final_line.width = LINE_WIDTH
	final_line.default_color = LINE_COLOR
	final_line.joint_mode = Line2D.LINE_JOINT_ROUND
	final_line.end_cap_mode = Line2D.LINE_CAP_ROUND
	final_line.begin_cap_mode = Line2D.LINE_CAP_ROUND
	add_child(final_line)

func make_starting_node():
	var node = MapNode.instantiate()
	node.name = "InitialPosition"
	node.is_starting_node = true
	node.position = pencil.position
	add_child(node)
	active_path.push_back(node.name)
	
	start_mark = StartMark.instantiate()
	start_mark.position = pencil.position
	add_child(start_mark)
	nodes[node.name] = node

func on_node_crossed(node):
	if node.is_starting_node:
		return
	if node.name in active_path:
		remove_nodes_since(node)
		return
	add_node(node)

func add_node(node):
	var last_line = Line2D.new()
	last_line.joint_mode = Line2D.LINE_JOINT_ROUND
	last_line.width = LINE_WIDTH
	last_line.default_color = LINE_COLOR
	last_line.end_cap_mode = Line2D.LINE_CAP_ROUND
	final_line.begin_cap_mode = Line2D.LINE_CAP_ROUND
	last_line.add_point(nodes[active_path[-1]].position)
	active_path.push_back(node.name)
	last_line.add_point(nodes[active_path[-1]].position)

	base_distance += line_length(last_line)

	add_child(last_line)
	lines.push_back(last_line)
	

func remove_last_node():
	active_path.pop_back()
	var last_line = lines.pop_back()
	if not last_line:
		return
	base_distance -= line_length(last_line)
	last_line.free()

func remove_nodes_since(node):
	while active_path[-1] != node.name:
		remove_last_node()
	remove_last_node()

func trace_final_line():
	final_line.clear_points()
	final_line.add_point(nodes[active_path[-1]].position)
	final_line.add_point(pencil.position)

func line_length(line):
	return line.points[0].distance_to(line.points[-1])

func count_last_stretch():
	return line_length(final_line)

func count_distance():
	distance = base_distance + count_last_stretch()

func refresh_distance_display():
	var d = distance / PX_PER_HOUR
	
	var d_round = int(d)
	counter_data.text = str(d_round)
	
	moved = d > 0.8;
	travel_tip.set_deferred("visible", moved)
	

func imagine_distance(v):
	var next_pencil = pencil.position + 10 * v
	return base_distance + next_pencil.distance_to(nodes[active_path[-1]].position)

func throttle_pencil(v):
	if imagine_distance(v) > distance and distance > (MAX_HOURS * PX_PER_HOUR):
		return true
	return false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	trace_final_line()
	count_distance()
	refresh_distance_display()
