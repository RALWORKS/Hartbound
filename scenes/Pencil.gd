extends CharacterBody2D

@export var speed = 200;
@export var line_size = 20;
@export var line_color = "#333344"
@export_multiline var throttled_message = "That's as far as we can travel today. Let's plan to make camp here."

var is_pencil = true
var grid = null
var arrow = null
var was_throttled = false

var active = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func start_drawing_mode():
	active = true

func throttle(v):
	if not grid:
		$Star.set_deferred("visible", false)
		return v
	
	var throttled = grid.throttle_pencil(v)
	if throttled:
		if not was_throttled:
			$Star.set_deferred("visible", true)
			if arrow:
				arrow.set_mod(arrow.inactive_mod)
			$"/root/Game".notify(throttled_message)
		was_throttled = throttled
		return Vector2(0, 0)
	
	$Star.set_deferred("visible", false)
	if arrow:
			arrow.set_mod(arrow.active_mod)
	
	was_throttled = throttled
	return v

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if not active:
		return

	var direction = Input.get_vector("left", "right", "up", "down")
	
	if direction == Vector2(0,0):
		velocity = direction
	else:
		velocity = throttle(direction) * speed
	
	move_and_slide()
