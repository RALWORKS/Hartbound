extends CharacterBody2D

@export var speed = 95
@export var osc_rate = 0.2
@export var is_demo_instance = false
@export var turning_timeout = 0.05
@export var is_profile = false

var DestinationMarker = preload("res://ui/destination_arrow.tscn")

var destination = null
var destination_marker = null

var last_collision = null
var last_facing = null
var turning = false
var cur_collision = null
var osc_origin = Time.get_ticks_msec()
var game = null
var world = null

@export var follower_call_interval = 0.05
@export var has_follower = false

var last_input_direction = null

var follower_to_positions = []
var next_follower_position = null
var wait_to_call_follower = false
var arrived_with_player = false

func verb(base):
	if base in ["is", "are"]:
		return 

var PRONOUNS = {
	"M": PRONOUNS_M,
	"F": PRONOUNS_F,
	"NB": PRONOUNS_NB,
}

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

func texture_updated():
	$char.texture_updated()


func load_texture():
	return $char.load_texture()

func _ready():
	game = $"/root".get_node_or_null("Game")
	world = game.get_node_or_null("MainScreen/World")
	TEXTURES = $char.TEXTURES
#	texture_settings = $char.texture_settings

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
	while follower_to_positions.size() > 0.5/0.05:
		follower_to_positions.pop_back()

func turn():
	turning = true
	await get_tree().create_timer(turning_timeout).timeout
	turning = false

func call_follower():
	if wait_to_call_follower or not has_follower:
		return
	if next_follower_position and next_follower_position.distance_to(position) > 1:
		follower_to_positions.push_front(next_follower_position)
	next_follower_position = position
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

func get_input():
	var arrow_keys = Input.get_vector("left", "right", "up", "down")
	var click = Input.is_action_just_released("click")
	
	if world and world.is_input_disabled():
		return Vector2(0, 0)

	if click and _mouse_in_range() and not _target_in_range():
		destination = $"..".get_global_mouse_position()

	var input_direction = arrow_keys
	input_direction.y = input_direction.y * 0.568

	if arrow_keys.x != 0 or arrow_keys.y != 0:
		destination = null
	if _near(position, destination):
		destination = null
	if destination != null:
		input_direction = Vector2.from_angle(get_angle_to(destination))
	

	input_direction = input_direction.normalized()
	
	if input_direction != last_input_direction:
		last_collision = null
		cur_collision = null
	
	last_input_direction = input_direction
	
	#velocity = input_direction * speed
	return input_direction

func walk():
	#$Sprite2D/AnimatedSprite2D.play(anims[facing]["on"])
	$char.play(anims[facing]["on"])

func stop_walking():
	#$Sprite2D/AnimatedSprite2D.play(anims[facing]["off"])
	$char.play(anims[facing]["off"])
	if destination != null:
		destination = null
		emote_question()

func set_anim():
	if is_demo_instance:
#		$char_anims.play("Rotate")
		return
	if (velocity.x**2 + velocity.y**2) < (speed*0.5)**2:
		stop_walking()
		return
	if velocity.y < 0 and velocity.x < 0:
		facing = "up_left"
	elif velocity.y < 0 and velocity.x > 0:
		facing = "up_right"
	elif velocity.y > 0 and velocity.x < 0:
		facing = "down_left"
	elif velocity.y > 0 and velocity.x > 0:
		facing = "down_right"
	elif velocity.y < 0:
		facing = "up"
	elif velocity.y > 0:
		facing = "down"
	elif velocity.x < 0:
		facing = "left"
	elif velocity.x > 0:
		facing = "right"
	if last_facing==null:
		last_facing = facing
	if facing != last_facing and turning:
		facing = last_facing
		if destination != null:
			destination = null
			emote_question()
	elif facing != last_facing:
		turn()
		last_facing = facing
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
		velocity = _modulate_velocity(slide)
		move_and_collide(velocity * delta)
		return

	set_anim() # needed in order to face the right way when stopping
	velocity = Vector2(0, 0) # 'cause here, we lose the direction

func _modulate_velocity(direction):
	return direction * speed
#	var mul = (
#		1 - (cos(
#			((Time.get_ticks_msec() - osc_origin) - (0 * osc_rate)) / (250 * osc_rate))
#		)
#	)
#	#return speed * direction
#	if mul < 0.35:
#		return direction * speed * 0.35
#	return direction * speed * mul

func _refresh_destination_marker():
	if destination_marker == null:
		destination_marker = DestinationMarker.instantiate()
		destination_marker.make_destination_marker($"../..")
	
	if destination == null:
		destination_marker.hide_marker()
		return
	destination_marker.move_marker(destination)
	destination_marker.show_marker()
	if game.staged_action_node == null:
		destination_marker.marker_walk_mode()
	else:
		destination_marker.marker_x_mode()

func _physics_process(delta):
	_refresh_destination_marker()
	if is_demo_instance:
		return
	var input_direction = get_input()
	velocity = _modulate_velocity(input_direction)

	var collision = move_and_collide(velocity * delta)
	_handle_collisions(delta, collision, input_direction)
	
	set_anim()
	call_follower()

func _clear_staged_action_node():
	game.unstage_action_node(game.staged_action_node)
	destination = null

func _on_interact_box_body_entered(body):
	if body.has_method("interact_range_entered"):
		body.interact_range_entered()
	
	if body == game.staged_action_node:
		_clear_staged_action_node()


func _on_interact_box_body_exited(body):
	if body.has_method("interact_range_exited"):
		body.interact_range_exited()



func _on_char_anims_animation_changed(_old_name, _new_name):
	osc_origin = Time.get_ticks_msec()


func _on_interact_box_area_entered(area):
	_on_interact_box_body_entered(area)


func _on_interact_box_area_exited(area):
	_on_interact_box_body_exited(area)
