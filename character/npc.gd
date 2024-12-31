extends CharacterBody2D

@export var disabled = false

@export var id = ""
@export var flip_h = false
@export var show_even_if_following = false
@export var starting_animaton = "down-stopped"
var last_starting_animation = "down-stopped"
@export var speed = 150
@export var speed_mul = 1
@export var leader: CharacterBody2D
@export var follow_distance = 150
@export var personal_space = 100

var last_collision = null
var cur_collision = null
var disable_all = false

@export var base_dialogue: Resource = null
var triggering_interact = false

@export var character_name: String = ""
@export var reference_id: String = ""

var last_input_direction = null

@export var follow_player = false
@export var show_self = true
@export var texture: Resource = null
@export var frame_spacing: float = 0.3

var waiting = false
var going = false
var paused = false
var stuck_counter = 0

var direction = Vector2(0, 0)

var next_position = null
var last_position = null

@export var follower_call_interval = 0.05
@export var has_follower = false
var follower_to_positions = []
var next_follower_position = null
var wait_to_call_follower = false
var footsteps_on = false


@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

var ANIMATIONS = {
	"down": [1, 0, 2, 0],
	"down-stopped": [0],
	"up": [4, 3, 5, 3],
	"up-stopped": [3],
	"left": [15, 17, 16, 17],
	"left-stopped": [17],
	"right": [13, 12, 14, 12],
	"right-stopped": [12],
	"down-right": [10, 9, 11, 9],
	"down-right-stopped": [9],
	"down-left": [18, 20, 19, 20],
	"down-left-stopped": [20],
	"up-right": [7, 6, 8, 6],
	"up-right-stopped": [6],
	"up-left": [21, 23, 22, 23],
	"up-left-stopped": [23],
	"Rotate": [0, 9, 12, 6, 3, 23, 17, 20]
}

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
@export var arrived_with_player = false
@export var footstep_interval = 0.7
var footstep_waiting = false

var last_few_paces: Array[Vector2] = [position]
@export var n_paces_saved: int = 3
var meaningfully_moving: bool = false
@export var movement_threshold: float = 0.6
@export var pace_interval: float = 0.3

func refresh_meaningfully_moving():
	var tree = get_tree()
	if not tree or not pace_interval:
		return
	await tree.create_timer(pace_interval).timeout
	last_few_paces.push_back(position)
	if last_few_paces.size() > n_paces_saved:
		last_few_paces.pop_front()
	
	var travelled = last_few_paces[0].distance_to(last_few_paces[-1])
	var expected = speed * pace_interval * last_few_paces.size()
	
	meaningfully_moving = travelled > expected * movement_threshold
	
	refresh_meaningfully_moving()
	

func force_enter_range():
	$InteractionArea.in_range = true

func _animation_from_frames(frames_sequence):
	var animation = Animation.new()
	animation.length = frame_spacing * frames_sequence.size()
	animation.loop_mode = Animation.LOOP_LINEAR
	var track_index = animation.add_track(Animation.TYPE_VALUE)
	animation.track_set_path(track_index, "char:frame")
	animation.track_set_interpolation_type(track_index, Animation.INTERPOLATION_NEAREST)
	
	var trace = 0
	
	for cur_frame in frames_sequence:
		animation.track_insert_key(track_index, trace, cur_frame)
		trace += frame_spacing

	return animation

func _make_walk_animations():
	if $AnimationPlayer.has_animation_library("movement"):
		return
	var library = AnimationLibrary.new()
	
	for key in ANIMATIONS.keys():
		var value = ANIMATIONS[key]		
		library.add_animation(key, _animation_from_frames(value))

	$AnimationPlayer.add_animation_library("movement", library)

func _ready():
	$char.flip_h = flip_h
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0
	
	if texture:
		$char.texture = texture
	$InteractionArea.title = my_name()
	$InteractionArea.setup_label()
	$InteractionArea.reference_id = reference_id
	if $char.hframes == 6 and $char.vframes == 4:
		_make_walk_animations()
	play_starting_animation()
	refresh_meaningfully_moving()

func play_starting_animation():
	play(starting_animaton)
	last_starting_animation = starting_animaton

func my_name():
	var data = $"/root/Game".name_of(id)
	if data == null:
		return character_name
	return data

func refresh_name():
	$InteractionArea.title = my_name()

func _near(a, b):
	if null in [a, b]:
		return false
	var THRESHOLD = 1
	return abs(
		a.x - b.x
	) < THRESHOLD and abs(
		a.y - b.y
	) < THRESHOLD + 1

func play(animation_title):
	$AnimationPlayer.play("movement/" + animation_title)

func walk():
	#$Sprite2D/AnimatedSprite2D.play(anims[facing]["on"])
	play(anims[facing]["on"])

func stop_walking():
	#$Sprite2D/AnimatedSprite2D.play(anims[facing]["off"])
	stop_footsteps()
	play(anims[facing]["off"])
	waiting = true
	await get_tree().create_timer(0.5).timeout
	waiting = false
	
func _footstep():
	footstep_waiting = false
	if disable_all:
		stop_footsteps()
		return
	if not footsteps_on:
		return
	var tree = get_tree()
	if tree == null:
		return
	$Footsteps.playing = false
	$Footsteps.playing = true
	footstep_waiting = true
	
	await tree.create_timer(footstep_interval).timeout
	_footstep()

func stop_footsteps():
	footsteps_on = false

func start_footsteps():
	footsteps_on = true
	if not footstep_waiting:
		_footstep()

func _throttle(delta):
	going = true
	var tree = get_tree()
	if tree == null:
		return
	await tree.create_timer(leader.follower_call_interval).timeout
	going = false
	
	if last_position and last_position.distance_to(position) < (speed * delta * 0.6):
		stuck_counter += 1
	last_position = position

func _turn():
	turning = true
	await get_tree().create_timer(0.2).timeout
	turning = false

func set_anim():
	if turning:
		return
	_turn()
	if (velocity.x**2 + velocity.y**2) < (speed*speed_mul*0.75):
		stop_walking()
		return
	if not footsteps_on:
		start_footsteps()
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
		velocity = slide * speed * speed_mul
		move_and_collide(velocity * delta)
		return

	set_anim() # needed in order to face the right way when stopping
	velocity = Vector2(0, 0) # 'cause here, we lose the direction
	#navigation_agent.target_position = global_position

func get_p():
	return position

func follow(delta):
	_throttle(delta)
	if (
		abs(position.distance_to(leader.get_p())) < follow_distance
	):
		stuck_counter = 0
		waiting = true
		leader.follower_arrived()
		if (position.distance_to(leader.get_p()) < leader.personal_space):
			# get out of the way
			return Vector2.from_angle(get_angle_to(leader.get_p()) + 180)
		return Vector2(0, 0)
	waiting = false
	if not navigation_agent.is_navigation_finished() and stuck_counter < 3 and meaningfully_moving:
		return

	if (
		next_position == null
		or abs(position.distance_to(next_position)) < speed*speed_mul*leader.follower_call_interval
		# below, to get around corners
		or (last_position and position.distance_to(last_position) < 1)
		
	):
		if leader.follower_to_positions.size() > 0:
			next_position = leader.follower_to_positions.pop_back()
		else:
			next_position = null

	if next_position == null:
		navigation_agent.target_position = global_position
		return
	
	navigation_agent.target_position = next_position
	return

func _process(_delta):
	if not leader:
		if $"/root/Game".check_state_for_follower(self) and not show_even_if_following:
			process_mode = Node.PROCESS_MODE_DISABLED
			visible = false
			return
		elif process_mode == PROCESS_MODE_DISABLED:
			process_mode = Node.PROCESS_MODE_INHERIT
			visible = true
		if starting_animaton != last_starting_animation:
			play_starting_animation()

func call_follower():
	if wait_to_call_follower or not has_follower:
		return
	if next_follower_position and next_follower_position.distance_to(position) > 1:
		follower_to_positions.push_front(next_follower_position)
	next_follower_position = position
	wait_to_call_follower = true
	await get_tree().create_timer(follower_call_interval).timeout
	wait_to_call_follower = false

func _physics_process(delta):
	if not leader:
		return
		
	
	if not going:
		direction = follow(delta)
	
	if direction != null:
		velocity = speed * speed_mul * direction

	elif not navigation_agent.is_navigation_finished():
		var cur_agent_position: Vector2 = global_position
		var next_path_position: Vector2 = navigation_agent.get_next_path_position()
	
		direction = next_path_position - cur_agent_position
		direction = direction.normalized()

	else:
		direction = Vector2(0, 0)
	
	var collision = move_and_collide(velocity * delta)
	_handle_collisions(delta, collision, direction)

	set_anim()
	call_follower()

func follower_arrived():
	while follower_to_positions.size() > 0:
		follower_to_positions.pop_back()

func start_following(g, custom_leader=null):
	leader = custom_leader if custom_leader else g.player
	leader.has_follower = true
	leader.follower_arrived()
	speed_mul = leader.speed_mul
	if custom_leader:
		return
	var party = g.get_state(["party"])
	follow_distance = leader.personal_space * 2
	if not self.id in party:
		g.set_state(["party"], [self.id] + party)

func get_dialogue():
	var glob = $"/root/Game".get_character_dialogue(id)
	if glob:
		return glob
	return base_dialogue

func action():
	if process_mode == Node.PROCESS_MODE_DISABLED or disabled:
		return
	var dialogue = get_dialogue()
	if not paused and dialogue != null:
		$"/root/Game/Chapter".start_cutscene(dialogue, self)

	return
	
func clear_follower_data():
	follower_to_positions = []
	next_follower_position = null




func _on_tree_exited():
	pass


func _on_tree_entered():
	$"/root/Game".add_character(self)
	refresh_name()
	paused = true
	await get_tree().create_timer(0.2).timeout
	paused = false


func _on_tree_exiting():
	$"/root/Game".remove_character(self)
