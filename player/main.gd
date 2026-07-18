@tool
extends Node2D

@export var mode: status.MODE = status.MODE.RIDER

@export var chain_length = 1600
@export var damp_zone = 350

var in_transition = false

var last_mode = null


@onready var SPRITES = {
	status.MODE.ELK: [$Elk, $TheHartbound],
	status.MODE.RIDER: [$Elk, null],
	status.MODE.ELF: [$TheHartbound, $Elk],
}

func _ready():
	pass
		

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
	$Elk.mode = mode
	$TheHartbound.mode = mode
	
	

func trigger_mount_transition():
	$TheHartbound.mode = status.MODE.RIDER
	$TheHartbound.visible = false
	$Elk.mode = mode
	in_transition = true

func on_mount_transition_ended():
	if mode != status.MODE.RIDER:
		$TheHartbound.mode = mode
		$TheHartbound.visible = true
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
	if mode == status.MODE.RIDER:
		$TheHartbound.position = $Elk.position + Vector2(100, 100)
	update_mode()
	chain()




