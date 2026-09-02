@tool
extends Node2D

@export var animation: String = "left_stopped"
@export var has_rider = false
@export var speed_scale = 1.0

@export var default_cycle = "walk"
var last_default_cycle = "walk"

var last_animation = "left_stopped"
var mounting = false

signal mount_transition_ended

var SPEEDS = {
	"walk": 1.0,
	"RESET": 1.0,
	"run": 1.5,
	"jump": 1.5,
}

var CYCLE_TAGS = {
	"run": "run",
	"jump": "jump",
	"walk": null,
}


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
	animation = modulate_animation_cycle(anim)

func modulate_animation_cycle(anim_name):
	var tok: Array = anim_name.split("_")
	if tok[-1] == last_default_cycle and tok[-1] != default_cycle:
		tok.pop_back()
		anim_name = "_".join(tok)
	if tok[-1] in ["stopped", "run", "jump"] or not CYCLE_TAGS[default_cycle]:
		return anim_name

	return anim_name + "_" + CYCLE_TAGS[default_cycle]
	
	

func _play(anim: String):
	var tok: Array = anim.split("_")
	var d = anim
	var cycle = "walk"
	if tok[-1] == "stopped":
		tok.pop_back()
		d = "_".join(tok)
		cycle = "RESET"
	elif tok[-1] == "run":
		tok.pop_back()
		d = "_".join(tok)
		cycle = "run"
	elif tok[-1] == "jump":
		tok.pop_back()
		d = "_".join(tok)
		cycle = "jump"
	
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
	$UpLeft/TESTMOUNT/Anim.play(anim, -1)

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
	if default_cycle in CYCLE_TAGS and default_cycle != last_default_cycle:
		play(animation)
		last_default_cycle = default_cycle
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
	anims.play("movement/" + anim, -1, speed_scale * SPEEDS[anim])
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
