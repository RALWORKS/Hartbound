extends CharacterBody2D

@export var speed = 200;
@export var line_size = 20;
@export var line_color = "#333344"

var is_pencil = true

@onready var line = make_line()
@export var bg: Sprite2D = null
@onready var paper = Sprite2D.new()

@onready var map_lines = [
	$"../WalkLine1",
	$"../WalkLine2",
	$"../WalkLine3",
	$"../WalkLine4",
	$"../WalkLine5",
	$"../WalkLine6",
	$"../WalkLine7",
]

var line_radius = 2*((line_size/2)**2)
var half_line_radius = ((line_size/2)**2)

var trail = []
var trail_map = {}

func make_line():
	return Image.create(3508, 2480, false, Image.FORMAT_RGBA8)

# Called when the node enters the scene tree for the first time.
func _ready():
	bg.add_child(paper)
	paper.position = Vector2(0, 0)
	paper.centered = false
	paper.visible = false
	for l in map_lines:
		l.connect("cross", cross_node)

var old_paper = []
var old_line = []

func set_paper(mn):
	old_paper.push_back(paper)
	paper = mn.paper
	old_line.push_back(line)
	line = mn.line

func draw():
	#line.unlock()
	for x in range(-line_size/2, line_size/2):
		for y in range(-line_size/2, line_size/2):
			if (line_radius - (x**2 + y**2)) < half_line_radius:
				continue
			line.set_pixel(position.x + x, position.y + y, line_color)

	#line.lock()
	var tx = ImageTexture.new()
	tx.set_image(line)
	paper.texture = tx #fakeimg

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	
	if velocity != Vector2(0, 0):
		draw()
	
	move_and_slide()

func cross_node(mn):
	if mn.ix in trail:
		var first = trail.find(mn.ix)
		var gone = trail.slice(first)
		print(trail, gone)
		for key in gone:
			print(trail_map[key])
			trail_map[key].erase()
		trail = trail.slice(0, trail.find(mn.ix))
	else:
		set_paper(mn)
	
	trail.push_back(mn.ix)
	trail_map[mn.ix] = mn
