extends Polygon2D

class_name StarRitual

var answers = []

var sequence: Array[Star] = []

var veil: ColorRect

var LINE_WIDTH: int = 10
var LINE_COLOR: Color = Color("white")
var sigil_line: Line2D = Line2D.new()
var tracer_line: Line2D = Line2D.new()

var sigil: TruePath

var vision: StarVision
var StarVision = preload("res://star_ritual/star_vision.tscn")

var HUD = preload("res://star_ritual/hud.tscn")

var seconds_allowed: float = 20.0
var seconds_elapsed: float = 0.0

var active: bool = false

var game: Game

var hud


# Called when the node enters the scene tree for the first time.
func _ready():
	style_line(tracer_line)
	style_line(sigil_line)
	game = $"/root/Game"
	setup_collision()
	sigil.make_stars(self)
	add_loose_stars()
	setup_answers()
	make_veil()
	veil.visible = false
	vision = StarVision.instantiate()
	add_child(vision)
	vision.set_sigil(sigil)

func style_line(l: Line2D):
	add_child(l)
	l.width = LINE_WIDTH
	l.default_color = LINE_COLOR
	l.joint_mode = Line2D.LINE_JOINT_ROUND
	l.end_cap_mode = Line2D.LINE_CAP_ROUND
	l.begin_cap_mode = Line2D.LINE_CAP_ROUND
	l.z_index = 30
	
func setup_collision():
	$Area/Hitbox.polygon = polygon.duplicate()
	$NPCBlock/Hitbox.polygon = polygon.duplicate()
	$Area.connect("body_entered", on_body_entered)
	$Area.connect("body_exited", on_body_exited)

func on_body_entered(body):
	if body != game.player:
		return
	start()

func on_body_exited(body):
	if body != game.player:
		return
	stop()

func add_loose_stars():
	for c in get_children():
		if c is Star:
			add_star(c)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not active:
		return
	seconds_elapsed += delta
	refresh_timer()
	trace()
	if hud != null and vision != null:
		hud.visible = not vision.visible

func refresh_timer():
	if hud:
		hud.set_time_fraction(1 - seconds_elapsed / seconds_allowed)
	if not seconds_elapsed < seconds_allowed:
		die()

func add_star(star: Star):
	star.connect("body_entered", func (body): on_star_cross(star, body))

func setup_answers():
	answers.push_back(sigil.sequence)
	var r = sigil.sequence.duplicate()
	r.reverse()
	answers.push_back(r)


func reset():
	tracer_line.clear_points()
	sigil_line.clear_points()
	sequence.clear()

func trace():
	if not sequence.size():
		return
	tracer_line.clear_points()
	tracer_line.add_point(sequence[-1].position)
	tracer_line.add_point(get_player_position())

func on_star_cross(star, body):
	if body != game.player:
		return
	if sequence.size() and star == sequence[-1]:
		return
	sequence.push_back(star)
	sigil_line.add_point(star.position)
	check_win()

func get_player_position():
	var p = game.player.position
	return p - position

func make_veil():
	veil = ColorRect.new()
	veil.color = Color("black")
	veil.set_size(Vector2(3000, 3000))
	veil.position = Vector2(0, 0)
	veil.z_index = 100
	var outline = Line2D.new()
	for p in polygon + PackedVector2Array([polygon[0]]):
		outline.add_point(p)
	
	outline.width = 5
	outline.default_color = "#ff00ff"
	outline.joint_mode = Line2D.LINE_JOINT_ROUND
	outline.end_cap_mode = Line2D.LINE_CAP_ROUND
	outline.begin_cap_mode = Line2D.LINE_CAP_ROUND
	outline.z_index = 75
	veil.add_child(outline)
	
	

func start():
	vision.show_vision()
	if not veil.get_parent():
		get_parent().add_child(veil)
	seconds_elapsed = 0.0
	active = true
	veil.visible = true
	game.player.z_index = 200
	z_index = 150
	call_higher("daylight_off")
	hud = HUD.instantiate()
	vision.visible = true
	hud.visible = false
	add_child(hud)

func call_higher(meth):
	var p = self
	while (p and meth not in p):
		p = p.get_parent()
	if not p:
		return
	p.call(meth)

func check_win():
	if sequence in answers:
		win()

func win():
	stop()
	queue_free()

func die():
	stop()
	game.respawn_player()

func stop():
	veil.visible = false
	vision.visible = false
	reset()
	active = false
	game.player.z_index = 0
	z_index = 0
	call_higher("daylight_default")
	if hud != null:
		hud.free()
