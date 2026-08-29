extends Node2D

@export var is_active = true
@export var proxied = false

@export var autonomous = true
@export var disable_all = false
@export var paused = false
@export var character: Node2D
@export var speed = 100
@export var follow_distance = 200
@export var rest_time = 1.0
@export var speed_scale = Vector2(1.0, 1.0)
@export var leader: CharacterBody2D

@onready var navigation_agent = $NavigationAgent2D

var unreachable = false
var resting = false

var being_pushed = false

var cur_collision = null
var last_collision = null


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func get_speed():
	if "speed" in character:
		return character.speed
	return speed

func get_speed_scale():
	if "speed_scale" in character:
		return character.speed_scale
	return speed_scale

func rest():
	resting = true
	await get_tree().create_timer(rest_time).timeout
	resting = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if not is_active:
		return
	if proxied:
		move_proxied(delta)
		return
	if being_pushed and leader:
		leader_repels()
		return
	if leader and character.position.distance_to(leader.position) > follow_distance and not resting:
		var follow = leader.position
		if "follower_target" in leader:
			follow = leader.follower_target.get_target()
		set_destination(follow)
	elif leader and character.position.distance_to(leader.position) < follow_distance:
		rest()
		set_destination(null)
		set_v(Vector2(0, 0))
	elif autonomous and not leader:
		_handle_input_autonomously(delta)
	var input_direction = refresh_walk_direction()
	if input_direction != null:
		go_direction(body_delta(), input_direction)


func move_proxied(delta):
	var collision = get_body().move_and_collide(get_v() * body_delta())
	_handle_collisions(body_delta(), collision, get_v().normalized())


func go_direction(delta, input_direction):
	if not is_active:
		return
	if disable_all:
		return

	set_v(_modulate_velocity(input_direction))

	var collision = get_collision()
	_handle_collisions(body_delta(), collision, input_direction)

func get_collision():
	return get_body().move_and_collide(get_v() * body_delta() * get_speed_scale())

func _handle_collisions(_delta, collision, input_direction):
	if not collision:
		cur_collision = null
		return
	
	if collision: #and last_collision and not _near(last_collision, position):
		last_collision = cur_collision
		cur_collision = position
		
		var normal = collision.get_normal()
#		normal.y = normal.y * (1/0.655)
#		normal = normal.normalized()
		#get_body().move_and_slide()
		var slide = input_direction.slide(normal).normalized()
		set_v(_modulate_velocity(slide))
		get_body().move_and_slide()
		return

	set_v(Vector2(0, 0)) # 'cause here, we lose the direction

func bump(v: Vector2):
	being_pushed = true
	if not is_active:
		return
	if not leader:
		return
	set_destination(position)
	leader_repels()

func leader_repels():
	var d = leader.position.direction_to(character.position)
	go_direction(body_delta(), d)
	

func stop_pushing():
	being_pushed = false
	
func no_input():
	if not is_active:
		return
	if navigation_finished():
		set_v(Vector2(0, 0))

func set_v(v):
	character.velocity = v

func get_v():
	return character.velocity

func body_delta():
	return get_body().get_physics_process_delta_time()

func get_body():
	return character

func _modulate_velocity(direction):
	return direction * get_speed() #* get_speed_scale()

func _near(a, b):
	if null in [a, b]:
		return false
	var THRESHOLD = 1
	return abs(
		a.x - b.x
	) < THRESHOLD and abs(
		a.y - b.y
	) < THRESHOLD + 1


func _target_in_range():
	if not glob.g.staged_action_node:
		return false
	if glob.g.staged_action_node.cur_cursor == null:
		return false
	return glob.g.staged_action_node.in_range

func set_destination(d):
	if d == null:
		navigation_agent.target_position = global_position
		return
	navigation_agent.target_position = d
	unreachable = not navigation_agent.is_target_reachable()

func navigation_finished():
	#print("finish")
	return navigation_agent.is_navigation_finished()

func refresh_walk_direction():
	if navigation_finished() or (
		leader and character.position.distance_to(leader.position) < follow_distance
	):
		#Vector2(0, 0)
		set_destination(null)
		return null
	
	var cur_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()
	
	var new_velocity: Vector2 = next_path_position - cur_agent_position
	new_velocity = new_velocity.normalized()

	return new_velocity

func arrow_keys_pressed(_delta, arrow_keys):
	if not navigation_agent.is_navigation_finished():
		set_destination(null)
	unreachable = false
	go_direction(body_delta(), arrow_keys)

func destination_clicked(_delta):
	if disable_all or paused:
		return
	set_destination($"..".get_global_mouse_position())

func _handle_input_autonomously(delta):

	var arrow_keys = Input.get_vector("left", "right", "up", "down")
	var click = Input.is_action_just_released("click")

	if click and glob.g.mouse_in_world():
		destination_clicked(delta)
		return
	
	if arrow_keys.x != 0 or arrow_keys.y != 0:
		arrow_keys_pressed(delta, arrow_keys)
		return
	
	no_input()

func reset():
	set_destination(null)
	set_v(Vector2(0, 0))
