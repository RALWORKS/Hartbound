extends Node2D
@export var is_active = true
@export var facing = "down"
var turning = false
var anim = "down_stopped"
var last_anim = "down_stopped"
@export var player: Node2D

signal animation_changed(anim: String)

@export var root: Node2D

@export var latency = 0.2
var refreshing = false
@export var speed_threshold = 10
@export var direction_threshold = 10
@export var turning_timeout = 0.05

var last_facing = null

var moving = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func get_v():
	return root.velocity


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not is_active:
		return
	refresh()
	

func check_movement(v):
	var next = not (v.x**2 + v.y**2) < speed_threshold
	return next
	
func wait():
	refreshing = true
	await get_tree().create_timer(latency).timeout
	refreshing = false
	

func refresh():
	if refreshing:
		return

	var v = get_v()
	
	facing = get_facing(v)	
	
	if last_facing==null:
		last_facing = facing
	
	anim = facing
	if not check_movement(v):
		anim = facing + "_stopped"
	if anim != last_anim:
		switch()
	wait()

func get_facing(v):
	if v.x == 0 and v.y == 0:
		return facing
	if v.y < -10 and v.x < -1 * direction_threshold:
		return "up_left"
	if v.y < -10 and v.x > direction_threshold:
		return "up_right"
	if v.y > 10 and v.x < -1 * direction_threshold:
		return "down_left"
	if v.y > 10 and v.x > direction_threshold:
		return "down_right"
	if v.y < -10:
		return "up"
	if v.y > 10:
		return "down"
	if v.x < 0:
		return "left"
	return "right"

func switch():
	if player:
		player.play(anim)
	emit_signal("animation_changed", anim)
	last_anim = anim
