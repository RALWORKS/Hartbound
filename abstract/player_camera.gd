class_name PlayerCamera extends CharacterBody2D

var threshold = 100
var speed = 10
var stuck = false

var NOSORT = true

var last_pos
var jumped = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	try_centering_player(delta)

func try_centering_player(delta):
	var p: Node2D = glob.g.player
	if not p:
		return

	var distance = p.get_actor_position().distance_to(position)
	var angle_to = position.direction_to(p.get_actor_position()).normalized()
	
	velocity = angle_to * distance * speed
	
	#if distance < threshold:
	#	jumped = false
	#velocity = p.get_actor_velocity()
	
	print(velocity)
		
	#else:
	#	position = p.get_actor_position()
		

	move_and_slide()

	
	
	
