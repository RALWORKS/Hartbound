@tool
extends CharacterBody2D

signal transition_ended
signal start_mounting

@export var SWITCH_DELAY = 0.1
@export var mount_timeout = 0.85
@export var hold_position = false

@export var partner: CharacterBody2D

@export var mode: status.MODE = status.MODE.RIDER

@onready var follower_target = $FollowerTarget

var last_mode = status.MODE.RIDER
var mounting = false

@export var speed = 150
@export var walk_speed = 150
@export var run_speed = 300
@export var base_speed_scale = Vector2(1.0, 1.0)
@export var cur_speed_mul = 1.0
@export var jump_warmup = 0.5
var speed_scale = base_speed_scale * cur_speed_mul


func update_mode():
	if mode == last_mode:
		return
	
	var _last_mode = last_mode
	last_mode = mode
	$DirectionControls.trying_to_mount = false
	$DirectionControls.reset_direction()
	
	if _last_mode == status.MODE.RIDER:
		$ElkSpriteAnimationController.default_cycle = "walk"
		speed = walk_speed
		dismount()
		return
	
	if mode == status.MODE.RIDER:
		#mount()
		$ElkSpriteAnimationController.default_cycle = "run"
		speed = run_speed
		$DirectionControls.trying_to_mount = true
		start_following()
		return

	if mode == status.MODE.ELK:
		start_leading()
		return
	
	start_following()


func fly():
	$DirectionControls.proxied = true
	$DirectionControls.reset_direction()
	$ElkSpriteAnimationController.default_cycle = "jump"
	set_collision_layer_value(glob.UNIVERSAL_COLLISION_LAYER, false)
	set_collision_layer_value(glob.ELK_COLLISION_LAYER, false)
	set_collision_layer_value(glob.SUB_ROOM_COLLISION_LAYER, false)
	
	set_collision_mask_value(glob.UNIVERSAL_COLLISION_LAYER, false)
	set_collision_mask_value(glob.ELK_COLLISION_LAYER, false)
	set_collision_mask_value(glob.SUB_ROOM_COLLISION_LAYER, false)
	z_index = 1
	return

func land_sub_room():
	$DirectionControls.proxied = false
	$DirectionControls.reset_direction()
	$ElkSpriteAnimationController.default_cycle = "walk"
	#set_collision_layer_value(glob.SUB_ROOM_COLLISION_LAYER, true)
	#set_collision_mask_value(glob.SUB_ROOM_COLLISION_LAYER, true)

func land_main_room():
	$DirectionControls.proxied = false
	$DirectionControls.reset_direction()
	z_index = 0
	$ElkSpriteAnimationController.default_cycle = "walk"
	set_collision_layer_value(glob.UNIVERSAL_COLLISION_LAYER, true)
	set_collision_layer_value(glob.ELK_COLLISION_LAYER, true)
	set_collision_mask_value(glob.UNIVERSAL_COLLISION_LAYER, true)
	set_collision_mask_value(glob.ELK_COLLISION_LAYER, true)


func start_leading():
	$DirectionControls.reset_direction()
	$DirectionControls.leader = null

func start_following():
	$DirectionControls.reset_direction()
	$DirectionControls.leader = partner

func mount():
	if mounting:
		return
	$DirectionControls.trying_to_mount = false
	$DirectionControls.reset_direction()
	start_leading()
	emit_signal("start_mounting")
	set_mount_state()
	velocity = Vector2(0.0, 0.0)

	$ElkSpriteAnimationController.mount()

func dismount():
	if mounting:
		return
	set_mount_state()
	velocity = Vector2(0.0, 0.0)
	$ElkSpriteAnimationController.dismount()

func set_mount_state():
	if Engine.is_editor_hint():
		mounting = true
	elif not get_tree():
		return
	else:
		start_mount_timeout()

func start_mount_timeout():
	mounting = true
	await get_tree().create_timer(mount_timeout).timeout
	if mounting:
		on_mount_completed()

func _physics_process(delta):
	update_mode()
	speed_scale = cur_speed_mul * base_speed_scale

func _ready():
	if mode == status.MODE.RIDER:
		$ElkSpriteAnimationController.has_rider = true
		$ElkSpriteAnimationController.default_cycle = "run"
		speed = run_speed
	else:
		$ElkSpriteAnimationController.has_rider = false
		$ElkSpriteAnimationController.default_cycle = "run"
		speed = walk_speed


func on_mount_completed():
	mounting = false
	$ElkSpriteAnimationController.mounting = false
	$DirectionControls.is_active = true
	if mode == status.MODE.RIDER:
		#$ElkSpriteAnimationController/UpLeft/TESTMOUNT.visible = false
		emit_signal("transition_ended")
		get_tree().create_timer(SWITCH_DELAY)
		$ElkSpriteAnimationController.has_rider = true
		start_leading()
		return
	#$ElkSpriteAnimationController/UpLeft/TESTMOUNT.visible = false
	emit_signal("transition_ended")
	get_tree().create_timer(SWITCH_DELAY)
	$ElkSpriteAnimationController.has_rider = false

	
	
	if mode == status.MODE.ELF:
		start_following()
		return
	
	start_leading()
	
func hitbox_detects_body(body):
	if body == partner:
		$DirectionControls.bump(partner)

func hitbox_body_leaving(body):
	if body == partner:
		$DirectionControls.stop_pushing()
