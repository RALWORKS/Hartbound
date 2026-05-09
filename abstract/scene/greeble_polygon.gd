@tool
extends Polygon2D

@export var start_at = 0
@export var length_scale = 1.5
@export var deviation_scale = 1.5

var GREEBLE_SEQ_X = [1, 1, 1, -2, 5, 5, -4, 1, -5, 0, -5, -4, 3, -2, -1, 0, -4]
var GREEBLE_SEQ_Y = [3, 3, 1, -2, -4, 0, 5, 5, 3, 5, 4, -1, 5, 1, 1, -5, 3, 4, 3, 0, 3, -4, -5]
var GREEBLE_SEQ_SP = [9, 8, 9, 8, 8, 5, 8, 8, 8, 3, 3, 6, 6]

@onready var i = start_at

var loading = false
@export var reload = false

# Called when the node enters the scene tree for the first time.
func _ready():
	#greeble()
	pass

func _draw():
	#greeble()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if reload and not loading:
		greeble()

func get_x():
	return _get_coord(GREEBLE_SEQ_X) * deviation_scale

func get_y():
	return _get_coord(GREEBLE_SEQ_Y) * deviation_scale

func get_sp(ix):
	return _get_coord_at(GREEBLE_SEQ_SP, ix) * length_scale

func get_point(orig, direction, displacement):
	return snapped(orig + (direction * displacement), Vector2(1, 1))

func greeble_point(pt):
	return Vector2(pt.x + get_x(), pt.y + get_y())

func _get_coord(data: Array):
	return data[i % data.size()]

func _get_coord_at(data: Array, ix: int):
	return data[ix % data.size()]
	

func get_greeble_points(new_poly, i0, i1):
	var d = new_poly[i0].distance_to(new_poly[i1])
	var angle = new_poly[i0].direction_to(new_poly[i1])
	var p = get_sp(i)
	var orig = new_poly[i0]
	var l = p
	
	var pts = []
	
	var j = 0
		
	while l + get_sp(i + j) < d:
		p = get_sp(i + j)
		l = l + p
		pts.push_back(get_point(orig, angle, l))
		j += 1
	
	return pts

func greeble_segment(new_poly, i0: int, i1: int):
	print("gr", i0, i1)
	var pts = get_greeble_points(new_poly, i0, i1)
	
	print("MYPTS", pts)
	
	var prev = i0
	var nxt = i0 + 1
	
	if pts.size() == 0:
		return prev + 1
	
	for p_old in pts:
		var pt = snapped(greeble_point(p_old), Vector2(1, 1))
		new_poly.insert(nxt, pt)
		prev = nxt
		nxt += 1
		i += 1
	
	return prev

func greeble():
	loading = true
	var prev = 0
	var new_poly = polygon.duplicate()
	while prev + 1 < new_poly.size():
		prev = greeble_segment(new_poly, prev, prev + 1) + 1
	prev = greeble_segment(new_poly, prev, 0)
	loading = false
	reload = false
	
	var child: Polygon2D = get_child(0)
	child.polygon = new_poly
	child.queue_redraw()
	child.texture = texture
	child.color = color
	child.texture_scale = texture_scale

	self_modulate.a = 0.0
