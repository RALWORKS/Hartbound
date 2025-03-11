class_name DaylightFilter

extends Node2D

@export var daylight_darken: Curve
@export var daylight_saturate: Curve
@export var daylight_contrast: Curve
@export var dalyight_warmth: Curve

@export var daylight_shader: ShaderMaterial

var last_cur_time = null

var mask: Node

var game: Node

var day_length = null

# Called when the node enters the scene tree for the first time.
func _ready():
	if not self.visible:
		process_mode = Node.PROCESS_MODE_DISABLED
		return
	mask = get_child(0)
	if not mask:
		return
		
	mask.material = daylight_shader
	mask.visible = true
	
	var g = _get_game()
	
	var t = g.get_time()
	day_length = g.day_length
	
	modulate_daylight(t, day_length)
	

func _get_game():
	if game == null:
		game = $"/root/Game"
	return game


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if last_cur_time == null:
		return
	
	var g = _get_game()
	var t = g.get_time()
	
	if t == last_cur_time:
		return
	
	modulate_daylight(t, day_length)

func modulate_daylight(cur_time: int, day_length: int):
	last_cur_time = cur_time
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
