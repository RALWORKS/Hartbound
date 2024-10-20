extends CharacterBody2D

@export var speed = 200;
@export var line_size = 20;
@export var line_color = "#333344"

var is_pencil = true
var grid = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func throttle(v):
	if not grid:
		$Star.set_deferred("visible", false)
		return v
	
	var throttled = grid.throttle_pencil(v)
	if throttled:
		$Star.set_deferred("visible", true)
		return Vector2(0, 0)
	
	$Star.set_deferred("visible", false)
	return v

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction = Input.get_vector("left", "right", "up", "down")
	
	if direction == Vector2(0,0):
		velocity = direction
	else:
		velocity = throttle(direction) * speed
	
	move_and_slide()
