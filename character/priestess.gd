extends CharacterBody2D

@export var speed = 100
@export var leader: CharacterBody2D
@export var follow_distance = 150

var last_collision = null
var cur_collision = null

var last_input_direction = null

@export var follow_player = false
@export var show_self = true

var waiting = false
var going = false

var direction = Vector2(0, 0)

var next_position = null
var last_position = null

var anims = {
	"up": {"on": "up", "off": "up-stopped"},
	"down": {"on": "down", "off": "down-stopped"},
	"left": {"on": "left", "off": "left-stopped"},
	"right": {"on": "right", "off": "right-stopped"},
	"up_left": {"on": "up-left", "off": "up-left-stopped"},
	"up_right": {"on": "up-right", "off": "up-right-stopped"},
	"down_left": {"on": "down-left", "off": "down-left-stopped"},
	"down_right": {"on": "down-right", "off": "down-right-stopped"},
}

var facing = "down_right"
var stopped = false
var turning = false
var arrived_with_player = false

func _ready():
	if (
		$"/root/Game".get_state(["micro_progress", "priestess_follows"])
		and not arrived_with_player
	):
		queue_free()

func _near(a, b):
	if null in [a, b]:
		return false
	var THRESHOLD = 1
	return abs(
		a.x - b.x
	) < THRESHOLD and abs(
		a.y - b.y
	) < THRESHOLD + 1

func walk():
	#$Sprite2D/AnimatedSprite2D.play(anims[facing]["on"])
	$char_anims.play(anims[facing]["on"])

func stop_walking():
	#$Sprite2D/AnimatedSprite2D.play(anims[facing]["off"])
	$char_anims.play(anims[facing]["off"])
	waiting = true
	await get_tree().create_timer(0.5).timeout
	waiting = false

func _go():
	going = true
	await get_tree().create_timer(0.05).timeout
	going = false

func _turn():
	turning = true
	await get_tree().create_timer(0.2).timeout
	turning = false

func set_anim():
	if turning:
		return
	_turn()
	if (velocity.x**2 + velocity.y**2) < (speed*0.75):
		stop_walking()
		return
	if velocity.y < 0 and abs(velocity.x) < 15:
		facing = "up"
	elif velocity.y > 0 and abs(velocity.x) < 15:
		facing = "down"
	elif velocity.x < 0 and abs(velocity.y) < 15:
		facing = "left"
	elif velocity.x > 0 and abs(velocity.y) < 15:
		facing = "right"
	elif velocity.y < 0 and velocity.x < 0:
		facing = "up_left"
	elif velocity.y < 0 and velocity.x > 0:
		facing = "up_right"
	elif velocity.y > 0 and velocity.x < 0:
		facing = "down_left"
	elif velocity.y > 0 and velocity.x > 0:
		facing = "down_right"
	walk()

func _handle_collisions(delta, collision, input_direction):
	if not collision:
		cur_collision = null
		return
	
	if collision and not _near(last_collision, position):
		last_collision = cur_collision
		cur_collision = position
		
		var normal = collision.get_normal()
#		normal.y = normal.y * (1/0.655)
#		normal = normal.normalized()
		var slide = input_direction.slide(normal).normalized()
		velocity = slide * speed
		move_and_collide(velocity * delta)
		return

	set_anim() # needed in order to face the right way when stopping
	velocity = Vector2(0, 0) # 'cause here, we lose the direction

func follow():
	_go()
#	if abs(position.distance_to(leader.position)) > follow_distance and not waiting:

	if (
#		waiting
#		or 
		abs(position.distance_to(leader.position)) < follow_distance
	):
		if (
			abs(position.distance_to(leader.position)) < 70
			and abs(leader.get_angle_to(position) - leader.velocity.angle()) < 1 
		):
			leader.follower_arrived()
			return leader.velocity.normalized()

		leader.follower_arrived()
		return Vector2(0, 0)

	if (
		next_position == null
		or abs(position.distance_to(next_position)) < speed*0.05
		# below, to get around corners
		or (last_position and position.distance_to(last_position) < 1)
		
	):
#		var input_direction = position.direction_to(leader.position)
		if leader.follower_to_positions.size() > 0:
			next_position = leader.follower_to_positions.pop_back()
		else:
			next_position = null
		
#		var input_direction = position.direction_to(next_position)

	
	last_position = position

	if next_position == null:
		return Vector2(0, 0)

	
	var input_direction = position.direction_to(next_position)
	
	return input_direction

	

func _physics_process(delta):
	if not leader:
		return
	
	if not going:
		direction = follow()
		#direction.y = direction.y * 0.568
		
	velocity = speed * direction
	var collision = move_and_collide(velocity * delta)
	_handle_collisions(delta, collision, direction)
	set_anim()

func start_following(g):
	leader = $"../Character"
	leader.has_follower = true
	leader.follower_arrived()
	g.set_state(["micro_progress", "priestess_follows"], true)

func interact_range_entered():
	start_following($"/root/Game")

	return


func interact_range_exited():
#	if body.has_method("interact_range_exited"):
#		body.interact_range_exited()
	return
