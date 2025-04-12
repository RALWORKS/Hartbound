extends CharacterBody2D

@export var speed = 110
@export var speed_mul = 1.7
@export var osc_rate = 0.2
@export var is_demo_instance = false
@export var turning_timeout = 0.05
@export var is_profile = false
@export var footstep_interval = 0.7
@export var wobbly = false
@export var collapsing = false
@export var fallen = false
@export var personal_space = 70

@export var animation_proxy: Node = null
@export var next_static_animation = ""

var direction_threshold = 10

var stagger_quotient = 1.5
var stagger_amplitude = 1

signal fell

var spawner = null

var current_static_animation = null
var party = []
var omit_party_members = []
var id = "player"

var footstep_waiting = false

var disable_all = false
var paused = false

var immune = false

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

var DestinationMarker = preload("res://ui/destination_arrow.tscn")

var destination_marker = null

var last_collision = null
var last_facing = null
var turning = false
var cur_collision = null
var osc_origin = Time.get_ticks_msec()
var game = null
var world = null
var unreachable = false

@export var follower_call_interval = 0.05
@export var has_follower = false

var last_input_direction = null

var follower_to_positions = []
var next_follower_position = null
var wait_to_call_follower = false
var arrived_with_player = false
var footsteps_on = false


func respawn():
	get_parent().remove_child(self)
	spawner.spawn(game, position.x, position.y)
	var party_map = {}
	for p in party:
		party_map[p.id] = p.position
		p.free()
	for p in game.player.party:
		if  p.id not in party_map:
			continue
		p.position = party_map[p.id]
	queue_free()

func verb(base):
	if base in ["is", "are"]:
		return 

var PRONOUNS = {
	"M": PRONOUNS_M,
	"F": PRONOUNS_F,
	"NB": PRONOUNS_NB,
}

func ghost_mode():
	$char.modulate = "#ffffff88"

func wobbly_no_canes():
	wobbly = true
	collapsing = true
	speed_mul = 0.4
	stagger_quotient = 1.5
	stagger_amplitude = 1.0
	$"img/canes-back".visible = false
	$"img/canes-front".visible = false

func wobbly_with_canes():
	wobbly = true
	collapsing = false
	speed_mul = 0.7
	stagger_quotient = 2
	stagger_amplitude = 0.5
	$"img/canes-back".visible = true
	$"img/canes-front".visible = true

func clear_follower_data():
	follower_to_positions = []
	next_follower_position = null

func taylor_carries_you():
	print("taylor_carries_you")
	var asset = preload("res://character/taylor_carries_you.tscn")
	var rep = asset.instantiate()
	get_parent().add_child(rep)
	rep.position = Vector2(position.x, position.y)
	rep.set_player(self)
	speed_mul = 0.6
	personal_space = 100
	follower_to_positions = []
	next_follower_position = null
	omit_party_members = ["taylor"]

func is_player():
	return true

var TEXTURES = null

var PRONOUNS_M = {
	"they": "he",
	"them": "him",
	"their": "his",
	"theirs": "his",
	"they're": "he's",
	"they are": "he is",
	"are": "is",
	"were": "was",
	"have": "has",
	"had": "had",
	"they were": "he was",
	"[present tense]": "s",
}

var PRONOUNS_F = {
	"they": "she",
	"them": "her",
	"their": "her",
	"theirs": "her",
	"they're": "she's",
	"they are": "she is",
	"they were": "she was",
	"are": "is",
	"were": "was",
	"have": "has",
	"had": "had",
	"[present tense]": "s",
}
var PRONOUNS_NB = {
	"they": "they",
	"them": "them",
	"their": "their",
	"theirs": "theirs",
	"they're": "they're",
	"they are": "they are",
	"they were": "they were",
	"are": "is",
	"were": "were",
	"have": "have",
	"had": "had",
	"[present tense]": "",
}

func emote_question():
	$Emote/Emote.play("Question")

func init_default_texture(gender):
	$char.init_default_texture(gender)

func randomize_features():
	$char.randomize_features()

func next_hair():
	$char.next_hair()

func next_outfit_color():
	$char.next_outfit_color()

func next_outfit_pattern():
	$char.next_outfit_pattern()

func next_accent_color():
	$char.next_accent_color()

func next_hair_color():
	$char.next_hair_color()

func next_skin_color():
	$char.next_skin_color()

func set_skin(ix):
	$char.set_skin(ix)

func set_hair_color(ix):
	$char.set_hair_color(ix)

func set_outfit_color(ix):
	$char.set_outfit_color(ix)

func set_accent_color(ix):
	$char.set_accent_color(ix)

func texture_updated():
	$char.texture_updated()


func load_texture():
	return $char.load_texture()
	
func set_v(v):
	if animation_proxy:
		animation_proxy.velocity = v
		return
	velocity = v

func get_v():
	if animation_proxy:
		return animation_proxy.velocity
	return velocity

func get_p():
	if animation_proxy:
		return animation_proxy.position
	return position

func get_body():
	if animation_proxy:
		return animation_proxy
	return self

func body_delta():
	return get_body().get_physics_process_delta_time()

func _ready():
	game = $"/root".get_node_or_null("Game")
	world = game.get_node_or_null("MainScreen/World")
	TEXTURES = $char.TEXTURES
#	texture_settings = $char.texture_settings
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0


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

func follower_arrived():
	while follower_to_positions.size() > 0:
		follower_to_positions.pop_back()

func turn():
	turning = true
	await get_tree().create_timer(turning_timeout).timeout
	turning = false

func call_follower():
	if wait_to_call_follower or not has_follower:
		return
	if next_follower_position and next_follower_position.distance_to(get_p()) > 1:
		follower_to_positions.push_front(next_follower_position)
	next_follower_position = get_p()
	wait_to_call_follower = true
	await get_tree().create_timer(follower_call_interval).timeout
	wait_to_call_follower = false

func _near(a, b):
	if null in [a, b]:
		return false
	var THRESHOLD = 1
	return abs(
		a.x - b.x
	) < THRESHOLD and abs(
		a.y - b.y
	) < THRESHOLD + 1

var ISO_ANGLES = [0, 60, 90, 120, 180, 240, 270, 300, 360]

func _radians(x):
	return x * (3.14159265/180)

func _mouse_in_range():
	var mouse = $"..".get_global_mouse_position()
	if not world:
		return true
	if mouse.x > world.size.x - 100:
		return false
	if mouse.y > world.size.y:
		return false
	return true

func _target_in_range():
	if not game.staged_action_node:
		return false
	if game.staged_action_node.cur_cursor == null:
		return false
	return game.staged_action_node.in_range

func set_destination(d):
	if d == null:
		navigation_agent.target_position = global_position
		return
	navigation_agent.target_position = d
	unreachable = not navigation_agent.is_target_reachable()

func navigation_finished():
	return navigation_agent.is_navigation_finished()

func refresh_walk_direction():
	if world and world.is_input_disabled():
		return null

	if navigation_finished():
		return null
	
	var cur_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()
	
	var new_velocity: Vector2 = next_path_position - cur_agent_position
	new_velocity = new_velocity.normalized()

	return new_velocity

func no_input():
	if navigation_finished():
		set_v(Vector2(0, 0))

func destination_clicked(_delta):
	if disable_all or paused:
		return
	set_destination($"..".get_global_mouse_position())

func arrow_keys_pressed(_delta, arrow_keys):
	if not navigation_agent.is_navigation_finished():
		set_destination(null)
	unreachable = false
	go_direction(body_delta(), arrow_keys)

func _extreme_shuffle_footsteps():
	if not wobbly:
		return speed_mul
	return speed_mul * (1.5 - _shuffle_footsteps())

func walk():
	#$Sprite2D/AnimatedSprite2D.play(anims[facing]["on"])
	$char.play(anims[facing]["on"], _extreme_shuffle_footsteps())
	if animation_proxy:
		animation_proxy.play(anims[facing]["on"])
	if wobbly:
		$Sway.play("base")
	if collapsing and $char.scale.x < 0:
		$char.scale = Vector2($char.scale.x * -1, $char.scale.y)

func stop_walking():
	#$Sprite2D/AnimatedSprite2D.play(anims[facing]["off"])
	stop_footsteps()
	$Sway.play("RESET")
	if fallen:
		return
	$char.play(anims[facing]["off"])
	if animation_proxy:
		animation_proxy.play(anims[facing]["off"])
	if not navigation_finished():
		# set_destination(null)
		emote_question()

func _shuffle_footsteps():
	if not wobbly:
		return 0
	return randf() / stagger_quotient

func _footstep():
	footstep_waiting = false
	if disable_all:
		stop_footsteps()
		return
	if not footsteps_on:
		return
	$Footsteps.playing = false
	$Footsteps.playing = true
	footstep_waiting = true
	await get_tree().create_timer((footstep_interval / speed_mul) - _shuffle_footsteps()).timeout
	_footstep()

func stop_footsteps():
	footsteps_on = false

func start_footsteps():
	footsteps_on = true
	if not footstep_waiting:
		_footstep()

func set_anim():
	if is_demo_instance:
#		$char_anims.play("Rotate")
		return
	var v = get_v()
	if (v.x**2 + v.y**2) < (speed*speed_mul*0.5)**2:
		stop_walking()
		return
	if not footsteps_on:
		start_footsteps()
		
	if v.y < -10 and v.x < -1 * direction_threshold:
		facing = "up_left"
	elif v.y < -10 and v.x > direction_threshold:
		facing = "up_right"
	elif v.y > 10 and v.x < -1 * direction_threshold:
		facing = "down_left"
	elif v.y > 10 and v.x > direction_threshold:
		facing = "down_right"
	elif v.y < -10:
		facing = "up"
	elif v.y > 10:
		facing = "down"
	elif v.x < 0:
		facing = "left"
	elif v.x > 0:
		facing = "right"
	if last_facing==null:
		last_facing = facing
	if facing != last_facing and turning:
		facing = last_facing
		if not navigation_finished():
			# set_destination(null)
			emote_question()
	elif facing != last_facing:
		turn()
		last_facing = facing
	walk()

func _handle_collisions(_delta, collision, input_direction):
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
		set_v(_modulate_velocity(slide))
		get_body().move_and_collide(get_v() * body_delta())
		return

	set_anim() # needed in order to face the right way when stopping
	set_v(Vector2(0, 0)) # 'cause here, we lose the direction

func _wobble(v:  Vector2):
	if not wobbly:
		return v
	var norm = v.angle() + 90
	var osc = sin(Time.get_ticks_msec() / 250)
	var sway = Vector2.from_angle(norm) * osc * v.length() * stagger_amplitude
	return v + sway

func _modulate_velocity(direction):
	return _wobble(direction * speed * speed_mul)

func _refresh_destination_marker():
	if destination_marker == null:
		destination_marker = DestinationMarker.instantiate()
		destination_marker.make_destination_marker($"../..")

	if navigation_finished():
		destination_marker.hide_marker()
		return
	destination_marker.move_marker(navigation_agent.target_position)
	destination_marker.show_marker()
	if game.staged_action_node == null:
		destination_marker.marker_walk_mode()
	else:
		destination_marker.marker_x_mode()

func refresh_static_animation():
	if next_static_animation and current_static_animation != next_static_animation:
		$char.play(next_static_animation)
		current_static_animation = next_static_animation

func _physics_process(_delta):
	_refresh_destination_marker()
	if is_demo_instance:
		refresh_static_animation()
		return
	var input_direction = refresh_walk_direction()
	if input_direction != null:
		go_direction(body_delta(), input_direction)

	set_anim()
	call_follower()
	
func about_to_fall():
	if collapsing and sin(Time.get_ticks_msec() / 800) > 0.8:
		$char.play("kneel")
		if not fallen:
			emit_signal("fell")
		if not fallen and get_v().x < 0:
			$char.scale = Vector2($char.scale.x * -1, $char.scale.y)
		fallen = true
		set_v(Vector2(0, 0))
		return true
	return false

func go_direction(delta, input_direction):
	if about_to_fall():
		return
	
	if disable_all:
		return
	fallen = false
	set_v(_modulate_velocity(input_direction))

	var collision = get_body().move_and_collide(get_v() * body_delta())
	_handle_collisions(body_delta(), collision, input_direction)
	

func _clear_staged_action_node():
	game.unstage_action_node(game.staged_action_node)

func interact_hit(body):
	if body == game.staged_action_node:
		set_destination(null)
	
	if body.has_method("interact_range_entered"):
		if body == game.staged_action_node:
			unreachable = false
			set_destination(null)
			stop_walking()
		body.interact_range_entered()

func interact_exited(body):
	if body.has_method("interact_range_exited"):
		body.interact_range_exited()
	
	
	if body == game.staged_action_node:
		_clear_staged_action_node()

func _on_interact_box_body_entered(body):
	interact_hit(body)


func _on_interact_box_body_exited(body):
	interact_exited(body)



func _on_char_anims_animation_changed(_old_name, _new_name):
	osc_origin = Time.get_ticks_msec()


func _on_interact_box_area_entered(area):
	_on_interact_box_body_entered(area)


func _on_interact_box_area_exited(area):
	_on_interact_box_body_exited(area)


func _on_navigation_agent_2d_navigation_finished():
	if unreachable:
		emote_question()
		unreachable = false


func _on_tree_exited():
	disable_all = true


func _on_tree_entered():
	disable_all = false
	paused = true
	await get_tree().create_timer(0.2).timeout
	paused = false

func get_followers(g):
	var data = g.get_followers_from_state()
	print(data)
	var followers = []
	for f in data:
		if not f:
			continue
		var n = $AllowedFollowers.get_node(f)
		if not n:
			continue
		followers.push_back(n.resource)
	return followers
