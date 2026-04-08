extends Line2D

class_name TruePath

var Star = preload("res://star_ritual/star.tscn")

var sequence: Array[Star] = []

@export var is_sigil = false


# Called when the node enters the scene tree for the first time.
func _ready():
	if "sigil" in get_parent():
		get_parent().sigil = self
	visible = is_sigil


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func make_stars(ritual: StarRitual):
	for p in points:
		var s: Star = Star.instantiate()
		s.position = p - position
		ritual.add_child(s)
		ritual.add_star(s)
		sequence.push_back(s)
		

func make_sparkles():
	var ret: Array[Star] = []
	for p in points:
		var s: Star = Star.instantiate()
		s.position = p - position
		s.home = s.position
		ret.push_back(s)
	return ret

func corners():
	if not points.size():
		return Vector2(0, 0)
	var x = Vector2(points[0].x, points[0].x)
	var y = Vector2(points[0].y, points[0].y)
	
	for p in points:
		if p.x < x[0]:
			x[0] = p.x
		if p.x > x[1]:
			x[1] = p.x
		if p.y < y[0]:
			y[0] = p.y
		if p.y > y[1]:
			y[1] = p.y
	
	return [x, y]

func dimensions():
	var c = corners()
	var x = c[0]
	var y = c[1]
	return Vector2(abs(x[1] - x[0]), abs(y[1] - y[0]))

func top_right():
	var c = corners()
	return Vector2(c[0][0], c[1][0])

func fit_to_square(s: int):
	var d: Vector2 = dimensions()
	var mul = 1.0

	if d.y > d.x:
		mul = s / d.y
	else:
		mul = s / d.x

	var offset = top_right()
	
	var cls = load("res://star_ritual/true_path.tscn")
	
	var ret = cls.instantiate()
	for p in points:
		ret.add_point((p - offset) * mul)
	
	return ret
	
