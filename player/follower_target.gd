extends Area2D

@export var radius = 200

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_follower_position()
	

func get_target():
	var root = get_parent()
	if not root:
		return position
	return global_position

func update_follower_position():
	var root = get_parent()
	if not root:
		return
	if root.velocity == Vector2(0,0):
		return
	position = (-1) * radius * root.velocity.normalized()
