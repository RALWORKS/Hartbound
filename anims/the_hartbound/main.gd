@tool
extends CharacterBody2D

@export var animation = "down_stopped"
@export var animations: Node2D

@export var partner: CharacterBody2D

@export var mode: status.MODE = status.MODE.ELF

@export var speed = 150
@export var base_speed_scale = Vector2(1.0, 1.0)
@export var cur_speed_mul = 1.0

@onready var follower_target = $FollowerTarget

var last_mode = null
var speed_scale = base_speed_scale * cur_speed_mul


func update_mode():
	if mode == last_mode:
		return
	var _last_mode = last_mode
	last_mode = mode
	$DirectionControls.reset()
	
	if mode == status.MODE.RIDER:
		mount()
		return

	if _last_mode == status.MODE.RIDER:
		dismount()
	
	$DirectionSensor.is_active = true
	$CollisionShape2D.disabled = false

	if mode == status.MODE.ELF:
		start_leading()
		return
	
	start_following()


func mount():
	passify()

func dangerously_call_animation(anim: String):
	animations.play(anim)

func passify():
	$DirectionSensor.is_active = false
	$CollisionShape2D.disabled = true
	$DirectionControls.is_active = false

func dismount():
	pass

func start_leading():
	$DirectionControls.is_active = true
	$DirectionControls.leader = null

func start_following():
	$DirectionControls.is_active = true
	$DirectionControls.leader = partner

func _physics_process(delta):
	update_mode()
	speed_scale = cur_speed_mul * base_speed_scale



func _ready():
	if mode == status.MODE.RIDER:
		passify()

func hitbox_detects_body(body):
	if body == partner:
		$DirectionControls.bump(partner.velocity)

func hitbox_body_leaving(body):
	if body == partner:
		$DirectionControls.stop_pushing()
