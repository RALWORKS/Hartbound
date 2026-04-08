extends Line2D

@export var spacing = 350

var MapNode = preload("res://scenes/map_node.tscn")

@onready var parent = get_parent()

var segments = []

var moves = []

signal cross(mn: Node)

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	var last_point = null
	var seg_ix = 0
	for p in points:
		if not last_point:
			last_point = p
			continue
		
		var intermediate = last_point
		
		var radius = Vector2((p.x - last_point.x), (p.y - last_point.y))
		
		var direction = radius.normalized()
		
		var last_trace = sqrt((intermediate.x - p.x)**2 + (intermediate.y - p.y)**2)
		intermediate = intermediate + (direction * spacing * 1)
		var ix = 0
		segments.push_back(make_node(intermediate, str(seg_ix) + "-" + str(ix)))
		var trace = sqrt((intermediate.x - p.x)**2 + (intermediate.y - p.y)**2)
		var sign = (trace - last_trace) > 0
		while sign == ((trace - last_trace) > 0):
			ix+=1
			last_trace = trace
			trace = sqrt((intermediate.x - p.x)**2 + (intermediate.y - p.y)**2)
			intermediate = intermediate + (direction * spacing)
			segments.push_back(make_node(intermediate, str(seg_ix) + "-" + str(ix)))
		
		last_point = p
		seg_ix += 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func make_node(point: Vector2, ix: String):
	var mn = MapNode.instantiate()
	mn.ix = name + "-" + str(ix)
	mn.position = point
	parent.call_deferred("add_child", mn)
	
	mn.connect("reverse_move", func(): emit_signal("cross", mn))
	mn.connect("forward_move", func(): emit_signal("cross", mn))
	
	return mn
