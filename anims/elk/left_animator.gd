@tool
extends AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if animations_refreshing and not _refresh_started:
		_make_walk_animations()

@export var animations_refreshing = true
var _refresh_started = false

func _animation_from_data(data):
	var animation = Animation.new()
	animation.length = data["length"]
	animation.loop_mode = Animation.LOOP_LINEAR
	for path in data["tracks"]:
		var track_index = animation.add_track(Animation.TYPE_VALUE)
		animation.track_set_path(track_index, path)
		animation.track_set_interpolation_type(track_index, Animation.INTERPOLATION_NEAREST)
		var track = data["tracks"][path]
		for i in range(track["times"].size):
			animation.track_insert_key(
				track_index, track["times"][i], track["values"][i]
			)

	return animation

func _make_walk_animations():
	_refresh_started = true
	var library = AnimationLibrary.new()
	
	for key in ANIMATIONS.keys():
		var value = ANIMATIONS[key]		
		library.add_animation(key, _animation_from_data(value))

	add_animation_library("movement", library)
	animations_refreshing = false
	_refresh_started = false


var RESET = {
	"length": 0.001,
	"loop_mode": 0,
	"tracks": {
		"LeftFront:frame": {
		"times": [0],
		"values": [2]
		},

		"LeftBack:frame": {
		"times": [0],
		"values": [3]
		},

		"RightFront:frame": {
		"times": [0],
		"values": [14]
		},

		"RightBack:frame": {
		"times": [0],
		"values": [15]
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
		"values": [Vector2(-136, -16)]
		},

		"Skeleton2D/Hip/Neck/Ear:rotation": {
		"times": [0],
		"values": [0.0]
		},

		"LeftBack:position": {
		"times": [0],
		"values": [Vector2(381, 306)]
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
		"values": [Vector2(-135, -12), Vector2(-136, -16), Vector2(-135, -12), Vector2(-136, -16), Vector2(-135, -12)]
		},


		"Skeleton2D/Hip/Neck/Ear:rotation": {
		"times": [0, 0.6, 2, 2.5, 3.6],
		"values": [-0.0523599, 0.0, -0.0523599, 0.0, -0.0523599]
		},

		"LeftBack:position":
		{
		"times": [0, 0.6, 1.7, 2.5, 3.6],
		"values": [Vector2(381, 306), Vector2(381, 303), Vector2(381, 306), Vector2(381, 303), Vector2(381, 306)]
		}
	}
}


var ANIMATIONS = {
"RESET": RESET,
"walk": WALK
}
