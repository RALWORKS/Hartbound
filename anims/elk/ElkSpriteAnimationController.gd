@tool
extends Node2D

@export var animation: String = "left_stopped"
@export var has_rider = false
@export var speed_scale = 1.0
var last_animation = "left_stopped"


@onready var DIRECTIONS = {
	"left": [$Left, false],
	"right": [$Left, true],
	"up_left": [$UpLeft, false],
	"up_right": [$UpLeft, true],
	"down_left": [$DownLeft, false],
	"test_mount": [$UpLeft, false],
	"down_right": [$DownLeft, true],
	"down": [$Down, false],
	"up": [$Up, false],
}

# Called when the node enters the scene tree for the first time.
func _ready():
	$"UpLeft/TESTMOUNT/1".animation = "ride_up_left"


func play(anim: String):
	var tok: Array = anim.split("_")
	var d = anim
	var cycle = "walk"
	if tok[-1] == "stopped":
		tok.pop_back()
		d = "_".join(tok)
		cycle = "RESET"
	
	if not d in DIRECTIONS:
		return
		
	
	play_params(DIRECTIONS[d][0], DIRECTIONS[d][1], cycle)
	
	if anim == "test_mount":
		pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if animation != last_animation:
		play(animation)
		last_animation = animation

func play_params(group: Node2D, mirror:bool, anim: String):
	hide_all()
	group.visible = true
	group.process_mode = Node.PROCESS_MODE_INHERIT
	if mirror:
		scale = Vector2(-1.0, 1.0)
	var anims:AnimationPlayer = get_animator(group)
	if not anims:
		return
	anims.play("movement/" + anim, -1, speed_scale)
	if has_rider:
		group.get_node("RIDER").visible = true

func hide_rider():
	has_rider = false
	for c in get_children():
		c.get_node("RIDER").visible = false

func show_rider():
	has_rider = true
	for c in get_children():
		c.get_node("RIDER").visible = true

func hide_all():
	scale = Vector2(1.0, 1.0)
	for c in get_children():
		c.visible = false
		#c.process_mode = Node.PROCESS_MODE_DISABLED
		c.get_node("RIDER").visible = false

func get_animator(c):
	var panim = c.get_node_or_null("PARAMETERIZED_ANIMS")
	if panim:
		return panim
	return c.get_node_or_null("ANIMS")
