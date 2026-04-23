class_name PlayerCamera extends CharacterBody2D

var threshold = 500

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Add camera!")
	print("cam: ", $Camera)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	try_centering_player(delta)

func try_centering_player(delta):
	var p: Node2D = glob.g.player
	if not p:
		return

	var distance = p.position.distance_to(position)
	var angle_to = position.direction_to(p.position).normalized()
	
	if distance < threshold:
		velocity = p.velocity
	else:
		velocity = angle_to*p.speed
		

	move_and_slide()

	
	
	
