@tool
extends Node2D


@export var root: Node2D

@export var use_thick_lines = false

@export var line_width_thick: Array[Node2D]

@export var animation: String = "left_stopped"
var last_animation = "left_stopped"
@export var animation_switching: ANIMATION_SWITCHING = ANIMATION_SWITCHING.ULTRA_SMOOTH

enum ANIMATION_SWITCHING {
	ULTRA_SMOOTH,
	CONSERVE_MEMORY
}

var UNIVERSAL_MODES = ["stop", "walk", "ride"]


func refresh_line():
	for l in line_width_thick:
		l.visible = bool(use_thick_lines)


@onready var DIRECTIONS = {
	"left": [$Left, false],
	"right": [$Left, true],
	"up_left": [$UpLeft, false],
	"mount": [$UpLeft, false],
	"dismount": [$UpLeft, false],
	"up_right": [$UpLeft, true],
	"down_left": [$DownLeft, false],
	"down_right": [$DownLeft, true],
	"down": [$Down, false],
	"up": [$Up, false],
}

var ALIASES = {
	"down_left_ride": "left_ride",
	"down_right_ride": "right_ride"
}

# Called when the node enters the scene tree for the first time.
func _ready():
	refresh_line()

func _convert_names(anim):
	var tok: Array = anim.split("_")
	if tok[0] != "ride":
		return anim
	tok.pop_front()
	return  "_".join(tok) + "_ride"

func play(anim: String):
	var reverse = false
	anim = _convert_names(anim)
	if anim in ALIASES:
		anim = ALIASES[anim]

	var tok: Array = anim.split("_")
	
	if not tok:
		return
	var d = anim
	var cycle = "walk"
	if tok[-1] == "stopped":
		tok.pop_back()
		d = "_".join(tok)
		cycle = "stop"
	elif tok[-1] == "ride":
		tok.pop_back()
		d = "_".join(tok)
		cycle = "ride"
	elif tok[-1] == "mount":
		d = anim
		cycle = "mount"
	elif tok[-1] == "dismount":
		d = anim
		cycle = "dismount"
		#reverse = true
	
	if not d in DIRECTIONS:
		return
		
	
	play_params(DIRECTIONS[d][0], DIRECTIONS[d][1], cycle, reverse)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if root != null and "animation" in root:
		animation = root.animation
	if animation != last_animation:
		play(animation)
		last_animation = animation

func play_params(group: Node2D, mirror:bool, anim: String, reverse:bool):
	group.process_mode = Node.PROCESS_MODE_INHERIT
	scale = Vector2(abs(scale.x), scale.y)
	if mirror:
		scale = Vector2(-1.0 * abs(scale.x), scale.y)
	var anims:AnimationPlayer = get_animator(group)
	if not anims:
		return
	if reverse:
		anims.play_backwards(anim)
	else:
		anims.play(anim)
	reset(group, anim)
	group.visible = true

func reset(focus, mode):
	if mode not in UNIVERSAL_MODES:
		mode = "stop"
	var anims: AnimationPlayer
	for c in get_children():
		if c.get_class() != "Node2D" or c == focus:
			continue
		if animation_switching == ANIMATION_SWITCHING.CONSERVE_MEMORY:
			c.visible = false
			c.process_mode = Node.PROCESS_MODE_DISABLED
			continue
		c.process_mode = Node.PROCESS_MODE_INHERIT
		anims = get_animator(c)
		if anims.has_animation(mode):
			anims.play(mode)
		c.visible = false

func get_animator(c):
	return c.get_node_or_null("AnimationPlayer")
