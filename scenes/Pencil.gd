extends CharacterBody2D

@export var speed = 200;
@export var line_size = 20;
@export var line_color = "#333344"

var is_pencil = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func measure():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	
	if velocity != Vector2(0, 0):
		measure()
	
	move_and_slide()
