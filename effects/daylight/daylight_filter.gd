class_name DaylightFilter

extends Node2D

@export var daylight_darken: Curve
@export var daylight_saturate: Curve
@export var daylight_contrast: Curve
@export var dalyight_warmth: Curve

@export var daylight_shader: ShaderMaterial

var mask: Node

var game: Node

# Called when the node enters the scene tree for the first time.
func _ready():
	mask = get_child(0)
	if not mask:
		return
		
	mask.material = daylight_shader
	mask.visible = true
	
	var g = _get_game()
	
	var t = g._init_time_if_needed()
	var l = g.day_length
	
	modulate_daylight(t, l)
	

func _get_game():
	if game == null:
		game = $"/root/Game"
	return game


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func modulate_daylight(cur_time: int, day_length: int):
	if not mask:
		return

	var r = float(cur_time) / float(day_length)
	var d = daylight_darken.sample(r)
	var s = daylight_saturate.sample(r)
	var c = daylight_contrast.sample(r)
	var w = dalyight_warmth.sample(r)
	
	mask.material.set_shader_parameter("saturate", s)
	mask.material.set_shader_parameter("contrast", c)
	mask.material.set_shader_parameter("darken", d)
	mask.material.set_shader_parameter("warmth", w)
