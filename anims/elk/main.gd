@tool
extends CharacterBody2D

signal transition_ended

@export var SWITCH_DELAY = 0.1

@export var partner: CharacterBody2D

@export var mode: status.MODE = status.MODE.RIDER

var last_mode = status.MODE.RIDER
var mounting = false

@export var speed = 150
@export var base_speed_scale = Vector2(1.0, 1.0)
@export var cur_speed_mul = 1.0
var speed_scale = base_speed_scale * cur_speed_mul


func update_mode():
	if mode == last_mode:
		return
	
	var _last_mode = last_mode
	last_mode = mode
	
	if _last_mode == status.MODE.RIDER:
		dismount()
		return
	
	if mode == status.MODE.RIDER:
		mount()
		return

	if mode == status.MODE.ELK:
		start_leading()
		return
	
	start_following()



func start_leading():
	$DirectionControls.is_active = true

func start_following():
	$DirectionControls.is_active = false

func mount():
	#$ElkSpriteAnimationController.hide_rider()
	if mounting:
		return
	mounting = true
	$DirectionControls.is_active = false
	velocity = Vector2(0.0, 0.0)
	$ElkSpriteAnimationController.play("up_left_stopped")
	$ElkSpriteAnimationController/UpLeft/TESTMOUNT/Anim.play("up")

func dismount():
	#$ElkSpriteAnimationController.hide_rider()
	if mounting:
		return
	mounting = true
	$DirectionControls.is_active = false
	velocity = Vector2(0.0, 0.0)
	$ElkSpriteAnimationController.play("up_left_stopped")
	$ElkSpriteAnimationController/UpLeft/TESTMOUNT/Anim.play("down")


func _physics_process(delta):
	update_mode()
	speed_scale = cur_speed_mul * base_speed_scale

func _ready():
	pass


func on_mount_completed(_anim_name):
	mounting = false
	if mode == status.MODE.RIDER:
		$ElkSpriteAnimationController/UpLeft/TESTMOUNT.visible = false
		emit_signal("transition_ended")
		get_tree().create_timer(SWITCH_DELAY)
		$ElkSpriteAnimationController.show_rider()
		start_leading()
		return
	$ElkSpriteAnimationController/UpLeft/TESTMOUNT.visible = false
	emit_signal("transition_ended")
	get_tree().create_timer(SWITCH_DELAY)
	$ElkSpriteAnimationController.hide_rider()

	
	
	if mode == status.MODE.ELF:
		start_following()
		return
	
	start_leading()
	
	
