extends Sprite2D

signal crossed

var point_entered = null

var crossed_threshold = 30

var is_starting_node = false

var crossed_direction = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func mark_entry(pencil: CharacterBody2D):
	point_entered = pencil.position
	

func mark_exit(pencil: CharacterBody2D):
	if crossed_direction:
		if pencil.position.distance_to(crossed_direction) < crossed_threshold:
			crossed_direction = null
			mark_crossing()
	elif pencil.position.distance_to(point_entered) > crossed_threshold * 2:
		crossed_direction = point_entered
		mark_crossing()
	point_entered = null

func mark_crossing():
	emit_signal("crossed", self)
	

func _on_hit_body_entered(body):
	if not "is_pencil" in body:
		return
	mark_entry(body)


func _on_hit_body_exited(body):
	if not "is_pencil" in body:
		return
	mark_exit(body)
