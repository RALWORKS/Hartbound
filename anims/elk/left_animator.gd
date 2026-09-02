@tool
extends AnimationPlayer

@export var neck_base: Vector2 = Vector2(-136, -16)

@export var back_left_base: Vector2 = Vector2(381, 306)
@export var back_right_base: Vector2
@export var front_left_base: Vector2
@export var front_right_base: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not get_node_or_null(".."):
		return
	if animations_refreshing and not _refresh_started:
		remove_animation_library("movement")
		make_walk_animations()

@export var animations_refreshing = true
var _refresh_started = false

func _animation_from_data(data, loop_mode):
	var animation = Animation.new()
	animation.length = data["length"]
	animation.loop_mode = loop_mode
	for path in data["tracks"]:
		var track_index = animation.add_track(Animation.TYPE_VALUE)
		animation.track_set_path(track_index, path)
		animation.track_set_interpolation_type(track_index, Animation.INTERPOLATION_NEAREST)
		var track = data["tracks"][path]
		for i in range(track["times"].size()):
			animation.track_insert_key(
				track_index, track["times"][i], track["values"][i]
			)

	return animation

func _make_walk_animations(anims):
	_refresh_started = true
	var library = AnimationLibrary.new()
	
	for key in anims.keys():
		var value = anims[key]
		var loop_mode = Animation.LOOP_LINEAR
		if key in ["jump"]:
			loop_mode = Animation.LOOP_NONE
		library.add_animation(key, _animation_from_data(value, loop_mode))

	add_animation_library("movement", library)
	animations_refreshing = false
	_refresh_started = false


func make_walk_animations():
	var RESET = {
		"length": 0.001,
		"loop_mode": 0,
		"tracks": {
			"LeftFront:frame": {
			"times": [0],
			"values": [0]
			},

			"LeftBack:frame": {
			"times": [0],
			"values": [1]
			},

			"RightFront:frame": {
			"times": [0],
			"values": [0]
			},

			"RightBack:frame": {
			"times": [0],
			"values": [1]
			},

			"LeftBack:rotation": {
			"times": [0],
			"values": [0.0]
			},

			"LeftFront:rotation": {
			"times": [0],
			"values": [0.0]
			},

			"RightFront:rotation": {
			"times": [0],
			"values": [0.0]
			},

			"Skeleton2D/Hip/Bum:rotation": {
			"times": [0],
			"values": [0.0]
			},

			"Skeleton2D/Hip/Neck:position": {
			"times": [0],
			"values": [neck_base]
			},

			"Skeleton2D/Hip/Neck/Ear:rotation": {
			"times": [0],
			"values": [0.0]
			},

			"LeftBack:position": {
			"times": [0],
			"values": [back_left_base]
			}
		}
	}

	var WALK = {
		"length": 3.6,
		"loop_mode": 1,
		"tracks": {
			"LeftFront:frame": {
			"times": [0, 0.3, 0.6, 0.9, 1.2, 1.5, 1.8, 2.1, 2.4, 2.7, 3, 3.3, 3.6],
			"values": [26, 24, 22, 20, 18, 16, 14, 12, 10, 8, 6, 4, 2]
			},

			"LeftBack:frame": {
			"times": [0, 0.2, 0.5, 0.8, 1.1, 1.4, 1.7, 2, 2.3, 2.6, 2.9, 3.2, 3.5],
			"values": [3, 27, 25, 23, 21, 19, 17, 15, 13, 11, 9, 7, 5]
			},

			"RightFront:frame": {
			"times": [0, 0.3, 0.6, 0.9, 1.2, 1.5, 1.8, 2.1, 2.4, 2.7, 3, 3.3],
			"values": [14, 12, 10, 8, 6, 4, 26, 24, 22, 20, 18, 16]
			},

			"RightBack:frame": {
			"times": [0, 0.2, 0.5, 0.8, 1.1, 1.4, 1.7, 2, 2.3, 2.6, 2.9, 3.2, 3.5],
			"values": [19, 17, 15, 13, 11, 9, 7, 5, 27, 25, 23, 21, 19]
			},

			"LeftBack:rotation": {
			"times": [0, 1.5, 2.7, 3.6],
			"values": [0.0, 0.0, 0.261799, 0.0]
			},

			"LeftFront:rotation": {
			"times": [0, 1.2, 2.4, 3.6],
			"values": [0.0, 0.0, -0.122173, 0.0]
			},

			"RightFront:rotation": {
			"times": [0, 0.6, 1.8, 3.3, 3.6],
			"values": [-0.0925025, -0.122173, 0.0, 0.0, -0.0925025]
			},

			"Skeleton2D/Hip/Bum:rotation": {
			"times": [0, 0.6, 1.7, 2.5, 3.6],
			"values": [0.0523599, 0.0, 0.0523599, 0.0, 0.0523599]
			},

			"Skeleton2D/Hip/Neck:position": {
			"times": [0, 0.6, 2, 2.5, 3.6],
			"values": [
				neck_base + Vector2(1, 4),
				neck_base,
				neck_base + Vector2(1, 4),
				neck_base,
				neck_base + Vector2(1, 4),
				],
			},


			"Skeleton2D/Hip/Neck/Ear:rotation": {
			"times": [0, 0.6, 2, 2.5, 3.6],
			"values": [-0.0523599, 0.0, -0.0523599, 0.0, -0.0523599]
			},

			"LeftBack:position":
			{
			"times": [0, 0.6, 1.7, 2.5, 3.6],
			"values": [
				back_left_base,
				back_left_base + Vector2(0, -3),
				back_left_base,
				back_left_base + Vector2(0, -3),
				back_left_base,
				]
			}
		}
	}
	
	var RUN = {
		"length": 3.6,
		"loop_mode": 1,
		"tracks": {
			"LeftFront:frame": {
			"times": [0, 0.3, 0.6, 0.9, 1.2, 1.5, 1.8, 2.1, 2.4, 2.7, 3, 3.3, 3.6],
			"values": [26, 24, 22, 20, 18, 16, 14, 12, 10, 8, 6, 4, 2]
			},

			"LeftBack:frame": {
			"times": [0, 0.2, 0.5, 0.8, 1.1, 1.4, 1.7, 2, 2.3, 2.6, 2.9, 3.2, 3.5],
			"values": [3, 27, 25, 23, 21, 19, 17, 15, 13, 11, 9, 7, 5]
			},

			"RightFront:frame": {
			"times": [0, 0.3, 0.6, 0.9, 1.2, 1.5, 1.8, 2.1, 2.4, 2.7, 3, 3.3, 3.6],
			"values": [24, 22, 20, 18, 16, 14, 12, 10, 8, 6, 4, 2, 26]
			},

			"RightBack:frame": {
			"times": [0, 0.2, 0.5, 0.8, 1.1, 1.4, 1.7, 2, 2.3, 2.6, 2.9, 3.2, 3.5],
			"values": [25, 23, 21, 19, 19, 17, 15, 13, 11, 9, 7, 5, 27]
			},

			"LeftBack:rotation": {
			"times": [0, 1.5, 2.7, 3.6],
			"values": [0.0, 0.0, 0.261799, 0.0]
			},

			"LeftFront:rotation": {
			"times": [0, 1.2, 2.4, 3.6],
			"values": [0.0, 0.0, -0.122173, 0.0]
			},

			"RightFront:rotation": {
			"times": [0, 0.6, 1.8, 3.3, 3.6],
			"values": [0.0, -0.0925025, -0.0925025, -0.122173, 0.0]
			},

			"Skeleton2D/Hip/Bum:rotation": {
			"times": [0, 1.7],
			"values": [0.0523599, 0.0]
			},

			"Skeleton2D/Hip/Neck:position": {
			"times": [0, 2],
			"values": [
				neck_base + Vector2(1, 4),
				neck_base,
				],
			},


			"Skeleton2D/Hip/Neck/Ear:rotation": {
			"times": [0, 2.0],
			"values": [-0.0523599, 0.0]
			},

			"LeftBack:position":
			{
			"times": [0, 0.6, 1.7, 2.5, 3.6],
			"values": [
				back_left_base,
				back_left_base + Vector2(0, -3),
				back_left_base,
				back_left_base + Vector2(0, -3),
				back_left_base,
				]
			}
		}
	}
	
	var JUMP = {
		"length": 3.6,
		"loop_mode": 1,
		"tracks": {
			"LeftFront:frame": {
			"times": [ 2.4, 2.7, 3, 3.3, 3.6, 0, 0.3, 0.6, 0.9, 1.2, 1.5, 1.8, 2.1],
			"values": [26, 24, 22, 20, 18, 16, 14, 12, 10, 8, 6, 4, 2]
			},

			"LeftBack:frame": {
			"times": [2.3, 2.6, 2.9, 3.2, 3.5, 0, 0.2, 0.5, 0.8, 1.1, 1.4, 1.7, 2],
			"values": [3, 27, 25, 23, 21, 19, 17, 15, 13, 11, 9, 7, 5]
			},

			"RightFront:frame": {
			"times": [2.4, 2.7, 3, 3.3, 3.6, 0, 0.3, 0.6, 0.9, 1.2, 1.5, 1.8, 2.1],
			"values": [24, 22, 20, 18, 16, 14, 12, 10, 8, 6, 4, 2, 26]
			},

			"RightBack:frame": {
			"times": [2.3, 2.6, 2.9, 3.2, 3.5, 0, 0.2, 0.5, 0.8, 1.1, 1.4, 1.7, 2],
			"values": [25, 23, 21, 19, 19, 17, 15, 13, 11, 9, 7, 5, 27]
			},

			"LeftBack:rotation": {
			"times": [2.7, 3.6, 0, 1.5],
			"values": [0.0, 0.0, 0.261799, 0.0]
			},

			"LeftFront:rotation": {
			"times": [0, 1.2, 2.4, 3.6],
			"values": [0.0, 0.0, -0.122173, 0.0]
			},

			"RightFront:rotation": {
			"times": [3.3, 3.6, 0, 0.6, 1.8],
			"values": [0.0, -0.0925025, -0.0925025, -0.122173, 0.0]
			},

			"Skeleton2D/Hip/Bum:rotation": {
			"times": [0, 1.7],
			"values": [0.0523599, 0.0]
			},

			"Skeleton2D/Hip/Neck:position": {
			"times": [0, 2],
			"values": [
				neck_base + Vector2(1, 4),
				neck_base,
				],
			},


			"Skeleton2D/Hip/Neck/Ear:rotation": {
			"times": [0, 2.0],
			"values": [-0.0523599, 0.0]
			},

			"LeftBack:position":
			{
			"times": [0, 0.6, 1.7, 2.5, 3.6],
			"values": [
				back_left_base,
				back_left_base + Vector2(0, -3),
				back_left_base,
				back_left_base + Vector2(0, -3),
				back_left_base,
				]
			}
		}
	}


	var ANIMATIONS = {
	"RESET": RESET,
	"run": RUN,
	"jump": JUMP,
	"walk": WALK
	}
	
	_make_walk_animations(ANIMATIONS)
