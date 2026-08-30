@tool
extends Node2D

@export var animation: String = "left_stopped"
@export var has_rider = false
@export var speed_scale = 1.0
var last_animation = "left_stopped"
var mounting = false

signal mount_transition_ended


@onready var DIRECTIONS = {
	"left": [$Left, false],
	"right": [$Left, true],
	"up_left": [$UpLeft, false],
	"up_right": [$UpLeft, true],
	"down_left": [$DownLeft, false],
	"mount": [$UpLeft, false],
	"dismount": [$UpLeft, false],
	"down_right": [$DownLeft, true],
	"down": [$Down, false],
	"up": [$Up, false],
}

# Called when the node enters the scene tree for the first time.
func _ready():
	#$"UpLeft/TESTMOUNT/1".animation = "ride_up_left"
	pass

func play(anim: String):
	print("play, ", anim)
	animation = anim

func _play(anim: String):
	var tok: Array = anim.split("_")
	var d = anim
	var cycle = "walk"
	if tok[-1] == "stopped":
		tok.pop_back()
		d = "_".join(tok)
		cycle = "RESET"
	
	if not d in DIRECTIONS:
		return
		
	
	if anim == "mount":
		play_mount("up")
		return
	if anim == "dismount":
		play_mount("down")
		return
	
	play_params(DIRECTIONS[d][0], DIRECTIONS[d][1], cycle)


func play_mount(anim):
	play_params($UpLeft, false, "RESET")
	$UpLeft/TESTMOUNT/Anim.play(anim)

func mount():
	play_mount("up")
	mounting = true

func dismount():
	play_mount("down")
	mounting = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if mounting:
		return
	if animation != last_animation:
		_play(animation)
		last_animation = animation
	if has_rider:
		show_rider()
	if not has_rider:
		hide_rider()

func play_params(group: Node2D, mirror:bool, anim: String):
	hide_all()
	group.visible = true
	group.process_mode = Node.PROCESS_MODE_INHERIT
	if mirror:
		scale = Vector2(-1.0 * abs(scale.x), scale.y)
	var anims:AnimationPlayer = get_animator(group)
	if not anims:
		return
	anims.play("movement/" + anim, -1, speed_scale)
	if has_rider:
		group.get_node("RIDER").visible = true

func hide_rider():
	#has_rider = false
	for c in get_children():
		c.get_node("RIDER").visible = false

func show_rider():
	#has_rider = true
	for c in get_children():
		c.get_node("RIDER").visible = true

func hide_all():
	scale = Vector2(abs(scale.x), scale.y)
	for c in get_children():
		c.visible = false
		#c.process_mode = Node.PROCESS_MODE_DISABLED
		c.get_node("RIDER").visible = false

func get_animator(c):
	var panim = c.get_node_or_null("PARAMETERIZED_ANIMS")
	if panim:
		return panim
	return c.get_node_or_null("ANIMS")




func _on_anim_animation_finished(anim_name):
	if anim_name in ["up", "down"]:
		emit_signal("mount_transition_ended")
		mounting = false
