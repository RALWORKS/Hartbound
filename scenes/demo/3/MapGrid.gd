extends Sprite2D

@export var pencil: Node
var camera: Camera2D

var nodes = {}

var active_path = []
var lines = []

var final_line: Line2D

var start_mark = null

var LINE_COLOR =  "#aa3322"
var LINE_WIDTH = 8

var distance = 0
var base_distance = 0

var moved = false

var MOD_COUNTER_OK = "#ffffffff"
var MOD_COUNTER_BLOCKED = "#ff4444ff"

@onready var counter = $CanvasLayer/Counter
@onready var travel_tip = $CanvasLayer/Counter/TravelTip
@onready var travel_tip_animation = $CanvasLayer/Counter/TravelTip/AnimationPlayer
@onready var counter_data = $CanvasLayer/Counter/Data

@export var PX_PER_HOUR = 75
var latest_time: int

var projected_time: int
var encounters: Array[MapEncounter]
var encounter_times: Array[int]

var StartMark = preload("res://scenes/demo/3/start_mark.tscn")
var NewMapNode = preload("res://scenes/demo/3/map_node.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	#remove_child(counter)	
	#pencil.add_child(counter)
	pencil.grid = self
	counter.position = Vector2(50, 50)
	travel_tip_animation.play("base")
	latest_time = int($"/root/Game".day_length * (0.04 + $"/root/Game".night_threshold))

	make_starting_node()
	for c in get_children():
		if not c is MapNode and not c is MapEncounter:
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

func start_drawing_mode():
	pass

func pop_encounter():
	encounters.pop_back()
	encounter_times.pop_back()

func push_encounter(e: MapEncounter):
	if $"/root/Game".check_map_encounter(e):
		return
	encounters.push_back(e)
	encounter_times.push_back(time_expended())
	print(encounters)


func start_time():
	return $"/root/Game".get_time()

func max_distance():
	var allowed_time = latest_time - start_time()
	if allowed_time < 0.0:
		return 0.0
	return $TimeUtils.moves_to_hours(allowed_time) * PX_PER_HOUR

func make_starting_node():
	var node = NewMapNode.instantiate()
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
	
	print(node)
	
	if node is MapEncounter:
		push_encounter(node)
	

func remove_last_node():
	var node_name = active_path.pop_back()
	var node = get_node(NodePath(node_name))
	if node is MapEncounter:
		pop_encounter()
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
	
func time_expended():
	var d = distance / PX_PER_HOUR
	return $TimeUtils.hours_to_moves(d)

func end_time():
	return time_expended() + start_time()

func refresh_distance_display():
	var d = distance / PX_PER_HOUR
	
	projected_time = end_time()
	
	counter_data.text = $TimeUtils.format_moves_24h(projected_time)
	
	moved = d > 0.3
	
	travel_tip.set_deferred("visible", moved)
	

func imagine_distance(v):
	var next_pencil = pencil.position + 10 * v
	return base_distance + next_pencil.distance_to(nodes[active_path[-1]].position)

func throttle_pencil(v):
	if imagine_distance(v) > distance and distance > max_distance():
		$CanvasLayer/Counter/Data.modulate = MOD_COUNTER_BLOCKED
		return true
	$CanvasLayer/Counter/Data.modulate = MOD_COUNTER_OK
	return false

func get_encounter():
	if encounters.size() == 0:
		return {"e": null, "time_at": null}
	return {"e": encounters[0], "time_at": encounter_times[0]}

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	trace_final_line()
	count_distance()
	refresh_distance_display()
