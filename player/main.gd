@tool
extends Node2D

@export var mode: status.MODE = status.MODE.RIDER

@export var chain_length = 1600
@export var damp_zone = 350
var arrived_with_player = true
var spawner: Node

var in_transition = false

var last_mode = null
@export var ELK: CharacterBody2D
@export var HARTBOUND: CharacterBody2D
@export var ELK_INDICATOR: Sprite2D
@export var HARTBOUND_INDICATOR: Sprite2D

@onready var SPRITES = {
	status.MODE.ELK: [ELK, HARTBOUND],
	status.MODE.RIDER: [ELK, null],
	status.MODE.ELF: [HARTBOUND, ELK],
}

func _ready():
	if spawner != null:
		eject_children()
	
	if HARTBOUND_INDICATOR and ELK_INDICATOR:
		HARTBOUND.move_child(HARTBOUND_INDICATOR, 0)
		ELK.move_child(ELK_INDICATOR, 0)

func eject_children():
	var ysort = get_parent()
	var pos_a = ELK.get_global_position()
	var pos_b = HARTBOUND.get_global_position()
	remove_child(HARTBOUND)
	remove_child(ELK)
	ELK.scale = ELK.scale * scale
	HARTBOUND.scale = HARTBOUND.scale * scale
	ELK.position = pos_a
	HARTBOUND.position = pos_b
	ysort.call_deferred("add_mob", HARTBOUND)
	ysort.call_deferred("add_mob", ELK)


func get_followers(_g):
	return []

func get_actor_velocity():
	return SPRITES[mode][0].velocity * SPRITES[mode][0].cur_speed_mul

func get_actor_speed():
	return SPRITES[mode][0].speed
	
func get_actor_position():
	if not is_node_ready():
		return position
	return SPRITES[mode][0].get_global_position()

func poll_mode_switcher():
	if Engine.is_editor_hint():
		return
	if Input.is_action_just_released("Rider"):
		mode = status.MODE.RIDER
	if Input.is_action_just_released("Elf"):
		mode = status.MODE.ELF
	if Input.is_action_just_released("Elk"):
		mode = status.MODE.ELK


func update_mode():
	if mode == last_mode:
		return
	
	var _last_mode = last_mode
	last_mode = mode

	
	if status.MODE.RIDER in [_last_mode, mode]:
		trigger_mount_transition()
		return
	ELK.mode = mode
	HARTBOUND.mode = mode


func update_indicators():
	if not HARTBOUND_INDICATOR or not ELK_INDICATOR:
		return
	if mode in [status.MODE.ELK, status.MODE.RIDER]:
		HARTBOUND_INDICATOR.visible = false
		ELK_INDICATOR.visible = true
		return
	HARTBOUND_INDICATOR.visible = true
	ELK_INDICATOR.visible = false
	
	
	

func trigger_mount_transition():
	HARTBOUND.mode = status.MODE.RIDER
	HARTBOUND.visible = false
	ELK.mode = mode
	in_transition = true

func on_mount_transition_ended():
	if mode != status.MODE.RIDER:
		HARTBOUND.mode = mode
		HARTBOUND.visible = true
	in_transition = false


func chain():
	if mode == status.MODE.RIDER:
		return
	var leader = SPRITES[mode][0]
	var follower = SPRITES[mode][1]
	
	var radius = follower.position.distance_to(leader.position + leader.velocity)
	var buffer = chain_length - radius
	
	if buffer < damp_zone:
		leader.cur_speed_mul = buffer / damp_zone
		return
	leader.cur_speed_mul = 1.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	poll_mode_switcher()
	if not HARTBOUND or not ELK:
		print("missing")
		return
	if spawner:
		position = SPRITES[mode][0].position
	if mode == status.MODE.RIDER:
		HARTBOUND.position = ELK.position + Vector2(0, 100)
	update_mode()
	update_indicators()
	chain()




