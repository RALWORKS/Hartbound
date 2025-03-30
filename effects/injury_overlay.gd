extends Node2D


var daylight_darken: Curve = preload("res://effects/daylight/darken.tres")
var last_cur_time

var game
var day_length

func _get_game():
	if game == null:
		game = $"/root/Game"
	return game

# Called when the node enters the scene tree for the first time.
func _ready():
	setup_shader()
	var g = _get_game()
	
	#var t = g.get_time()
	day_length = g.day_length


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func setup_shader():
	$Filter.material.set_shader_parameter("size", $Filter.size)
	$Filter.material.set_shader_parameter("top_left", $Filter.global_position)# + Vector2(18, 0))

func start():
	visible = true
	process_mode = Node.PROCESS_MODE_INHERIT
	$AnimationPlayer.play("pulse")

func stop():
	visible = false
	process_mode = Node.PROCESS_MODE_DISABLED
	$AnimationPlayer.stop()
