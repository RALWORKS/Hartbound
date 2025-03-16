extends Polygon2D

class_name StarRitual

var answers = []

var sequence: Array[Star] = []

var LINE_WIDTH: int = 10
var LINE_COLOR: Color = Color("white")
var sigil_line: Line2D = Line2D.new()
var tracer_line: Line2D = Line2D.new()

var sigil: TruePath

var seconds_allowed: float = 20.0
var seconds_elapsed: float = 0.0

var active: bool = false

var game: Game


# Called when the node enters the scene tree for the first time.
func _ready():
	style_line(tracer_line)
	style_line(sigil_line)
	game = $"/root/Game"
	setup_collision()
	sigil.make_stars(self)
	add_loose_stars()
	setup_answers()

func style_line(l: Line2D):
	add_child(l)
	l.width = LINE_WIDTH
	l.default_color = LINE_COLOR
	l.joint_mode = Line2D.LINE_JOINT_ROUND
	l.end_cap_mode = Line2D.LINE_CAP_ROUND
	l.begin_cap_mode = Line2D.LINE_CAP_ROUND
	
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

func refresh_timer():
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

func start():
	seconds_elapsed = 0.0
	active = true

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
	reset()
	active = false
