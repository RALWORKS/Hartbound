extends Line2D

@export var spacing = 350

var MapNode = preload("res://scenes/map_node.tscn")

@onready var parent = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	var last_point = null
	for p in points:
		if not last_point:
			last_point = p
			continue
		
		var intermediate = last_point
		
		var radius = Vector2((p.x - last_point.x), (p.y - last_point.y))
		
		var direction = radius.normalized()
		
		var last_trace = sqrt((intermediate.x - p.x)**2 + (intermediate.y - p.y)**2)
		intermediate = intermediate + (direction * spacing * 1)
		make_node(intermediate)
		var trace = sqrt((intermediate.x - p.x)**2 + (intermediate.y - p.y)**2)
		var sign = (trace - last_trace) > 0
		while sign == ((trace - last_trace) > 0):
			last_trace = trace
			trace = sqrt((intermediate.x - p.x)**2 + (intermediate.y - p.y)**2)
			intermediate = intermediate + (direction * spacing)
			make_node(intermediate)
		
		last_point = p


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func make_node(point: Vector2):
	var mn = MapNode.instantiate()
	mn.position = point
	parent.call_deferred("add_child", mn)
