extends Line2D

@export var elk: CharacterBody2D

@export var turn_threshold = 10

var reverse = false

@export var speed = 300
var warmup = false


var ix = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_released("next") and not elk:
		await jump(glob.g.player.ELK)

	if warmup or not elk:
		return
	
	if elk.position.distance_to(points[ix]) < turn_threshold:
		iterate()
	
	if ix > points.size() - 1 or ix < 0:
		elk.velocity = Vector2(0, 0)
		if reverse:
			elk.land_main_room()
		else:
			elk.land_sub_room()
		elk = null
		reverse = not reverse
		return
	
	var d = elk.position.direction_to(points[ix]).normalized()
	elk.velocity = d * speed


func jump(some_elk):
	ix = 0
	if reverse:
		ix = points.size() - 1
	elk = some_elk
	elk.fly()
	elk.position = points[ix]
	warmup = true
	await get_tree().create_timer(elk.jump_warmup).timeout
	warmup = false

func iterate():
	if reverse:
		ix -= 1
		return
	ix += 1
