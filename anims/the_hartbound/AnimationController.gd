@tool
extends Node2D

@export var frame_spacing: float = 0.3
@export var animations_refreshing = true
var _refresh_started = false

@export var animation = "down_stopped"
var last_animation = "down_stopped"
var animation_player_command = "down_stopped"

@onready var DIRECTIONS = {
	"left": ["left", false],
	"right": ["left", true],
	"up_left": ["up_left", false],
	"up_right": ["up_left", true],
	"down_left": ["down_left", false],
	"down_right": ["down_left", true],
	"down": ["down", false],
	"up": ["up", false],
	"ride_up": ["ride_up", false],
	"ride_down": ["ride_down", false],
	"ride_left": ["ride_left", false],
	"ride_right": ["ride_left", true],
	"ride_up_left": ["ride_up_left", false],
	"ride_up_right": ["ride_up_left", true],
	"ride_down_left": ["ride_down_left", false],
	"ride_down_right": ["ride_down_left", true],
	"mount_f1": ["mount_f1", false],
	"mount_f2": ["mount_f2", false],
}

var ANIMATIONS = {
	"down": [28, 29, 30, 31, 32, 33, 34, 35],
	"down_stopped": [27],
	"up": [19, 20, 21, 22, 23, 24, 25, 26],
	"up_stopped": [18],
	"left": [1, 2, 3, 4, 5, 6, 7, 8],
	"left_stopped": [0],
	"down_left": [37, 38, 39, 40, 41, 42, 43, 44],
	"down_left_stopped": [36],
	"up_left": [10, 11, 12, 13, 14, 15, 16, 17],
	"up_left_stopped": [9],
	"ride_up": [47],
	"ride_down": [49],
	"ride_left": [45],
	"ride_up_left": [46],
	"ride_down_left": [48],
	"mount_f1": [50],
	"mount_f2": [51],
}

func play(anim):
	animation = anim

func refresh_animation():
	last_animation = animation

	var tok: Array = animation.split("_")
	var d = animation

	var append = ""
	if tok[-1] == "stopped":
		tok.pop_back()
		d = "_".join(tok)
		append = "_stopped"
	
	if not d in DIRECTIONS:
		return
		
	var scalex = 1
	if DIRECTIONS[d][1]:
		scalex = -1
	$".".scale = Vector2(scalex, 1)
	
	animation_player_command = DIRECTIONS[d][0] + append
	$AnimationPlayer.play("movement/" + animation_player_command)



func _animation_from_frames(frames_sequence):
	var animation = Animation.new()
	animation.length = frame_spacing * frames_sequence.size()
	animation.loop_mode = Animation.LOOP_LINEAR
	var track_index = animation.add_track(Animation.TYPE_VALUE)
	animation.track_set_path(track_index, "Character:frame")
	animation.track_set_interpolation_type(track_index, Animation.INTERPOLATION_NEAREST)
	
	var trace = 0
	
	for cur_frame in frames_sequence:
		animation.track_insert_key(track_index, trace, cur_frame)
		trace += frame_spacing

	return animation

func _make_walk_animations():
	_refresh_started = true
	var library = AnimationLibrary.new()
	
	for key in ANIMATIONS.keys():
		var value = ANIMATIONS[key]
		library.add_animation(key, _animation_from_frames(value))

	$AnimationPlayer.remove_animation_library("movement")
	$AnimationPlayer.add_animation_library("movement", library)
	animations_refreshing = false
	_refresh_started = false


# Called when the node enters the scene tree for the first time.
func _ready():
	refresh_animation()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if animations_refreshing and not _refresh_started:
		_make_walk_animations()
	if animation != last_animation:
		refresh_animation()
