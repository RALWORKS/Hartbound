extends Node2D

@export var baseline: Line2D

var xpoints = []

# Called when the node enters the scene tree for the first time.
func _ready():
	sort_points()
	if baseline:
		baseline.visible = false


func sortx(a, b):
	return a.x < b.x

func sort_points():
	if not baseline:
		return
	if xpoints and xpoints.size():
		return

	for p in baseline.get_points():
		xpoints.push_back(p)
	xpoints.sort_custom(sortx)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func default_check_should_be_behind(mob: Node2D):
	return position.y <= mob.position.y


func check_should_be_behind(_item: Node2D, mob: Node2D):
	if baseline == null or xpoints.size() == 0:
		return default_check_should_be_behind(mob)
	return check_is_under_line(mob)


func global_pt(pt):
	return (pt * scale + position + baseline.position)


func get_bounds(trace: int):
	var lix = 0
	var rix = 1
	
	var l = global_pt(xpoints[lix])
	var r = global_pt(xpoints[rix])
	
	while trace > r.x:
		lix = lix + 1
		rix = rix + 1
		
		if rix > xpoints.size() - 1:
			break
		
		l = global_pt(xpoints[lix])
		r = global_pt(xpoints[rix])
	
	return [l, r]


func interpolate_x(l: Vector2, r: Vector2, x: int):
	var ang = r.direction_to(l)
	var xq = (r.x - x) / (r.x - l.x)  
	var d = xq * r.direction_to(l) * abs(r.distance_to(l))
	return r + d


func check_is_under_line(mob: Node2D):
	var trace = mob.position.x
	if trace < xpoints[0].x or trace > xpoints[-1].x:
		default_check_should_be_behind(mob)
	
	var bounds = get_bounds(trace)
	
	var vertical = interpolate_x(bounds[0], bounds[1], trace)
	
	return vertical.y < mob.position.y
	
	
		
