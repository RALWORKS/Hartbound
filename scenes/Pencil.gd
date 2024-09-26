extends CharacterBody2D

@export var speed = 200;
@export var line_size = 20;
@export var line_color = "#333344"

var is_pencil = true

@onready var line = Image.create(3508, 2480, false, Image.FORMAT_RGBA8)
@export var bg: Sprite2D = null
@onready var paper = Sprite2D.new()

var line_radius = 2*((line_size/2)**2)
var half_line_radius = ((line_size/2)**2)

# Called when the node enters the scene tree for the first time.
func _ready():
	bg.add_child(paper)
	paper.position = Vector2(0, 0)
	paper.centered = false
	

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
