extends Node2D

class_name SigilPlace

@export var LINE_WIDTH: int = 30
@export var LINE_COLOR: Color = Color("white")

var sparkles: Array[Star]
var sigil: TruePath
var sparkle_time: float = 0.0
@export var delay_sparkle_time: float = 1.0
@export var max_sparkle_time: float = 1.0
var ritual: StarRitual

# Called when the node enters the scene tree for the first time.
func _ready():
	var p = get_parent()
	if "sigil_place" in p:
		p.sigil_place = self
		ritual = p
	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	mod_sparkles(delta)
	

func style_line(l: Line2D):
	l.width = LINE_WIDTH
	l.default_color = LINE_COLOR
	l.joint_mode = Line2D.LINE_JOINT_ROUND
	l.end_cap_mode = Line2D.LINE_CAP_ROUND
	l.begin_cap_mode = Line2D.LINE_CAP_ROUND

func set_sigil(sigil: TruePath):
	var s = sigil.fit_to_square(500)
	s.is_sigil = true
	style_line(s)
	add_child(s)
	
func show_sigil():
	$AnimationPlayer.play("show")
	sparkles = sigil.make_sparkles()

func clear():
	for s in sparkles:
		s.free()
	sparkles = []
	sparkle_time = 0.0

func mod_sparkles(delta):
	if not sparkles.size():
		return
	if sparkle_time < delay_sparkle_time:
		sparkle_time += delta
		return
	if sparkle_time > delay_sparkle_time + max_sparkle_time:
		clear()
		sparkle_time = 0.0
		return

	var o = ritual.get_middle()
	var q = float(delta) /float(max_sparkle_time)
	for s in sparkles:
		mod_sparkle(s, q, o)
	
	sparkle_time += delta

func mod_sparkle(sparkle: Star, q: float, o: Vector2):
	if not sparkle.get_parent():
		add_child(sparkle)
	var a = Vector2.from_angle((sparkle.home + position).angle_to_point(o)).normalized()
	var d = (sparkle.home + position).distance_to(o)
	sparkle.position += (q * d * a)
	sparkle.scale = sparkle.scale - (sparkle.scale * q)
