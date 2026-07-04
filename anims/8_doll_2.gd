@tool
extends Node2D

@export var frame_spacing: float = 0.3
@export var animations_refreshing = true
var _refresh_started = false

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

	$AnimationPlayer.add_animation_library("movement", library)
	animations_refreshing = false
	_refresh_started = false

var ANIMATIONS = {
	"down": [28, 29, 30, 31, 32, 33, 34, 35],
	"down-stopped": [27],
	"up": [19, 20, 21, 22, 23, 24, 25, 26],
	"up-stopped": [18],
	"left": [1, 2, 3, 4, 5, 6, 7, 8],
	"left-stopped": [0],
	#"right": [13, 12, 14, 12],
	#"right-stopped": [12],
	#"down-right": [10, 9, 11, 9],
	#"down-right-stopped": [9],
	"down-left": [37, 38, 39, 40, 41, 42, 43, 44],
	"down-left-stopped": [36],
	#"up-right": [7, 6, 8, 6],
	#"up-right-stopped": [6],
	"up-left": [10, 11, 12, 13, 14, 15, 16, 17],
	"up-left-stopped": [9],
	#"Rotate": [0, 9, 12, 6, 3, 23, 17, 20]
}


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if animations_refreshing and not _refresh_started:
		_make_walk_animations()
