class_name DaylightFilter

extends Node2D

@export var daylight_darken: Curve
@export var daylight_saturate: Curve
@export var daylight_contrast: Curve
@export var dalyight_warmth: Curve

@export var daylight_shader: ShaderMaterial

var last_cur_time = null
var was_injured = false

var mask: Node

var game: Node
@export var scene: Node

var day_length = null

# Called when the node enters the scene tree for the first time.
func _ready():
	mask = get_child(1)
	
	if scene and scene.as_background:
		visible = false
	
	if not visible:
		process_mode = Node.PROCESS_MODE_DISABLED
	
	refresh()

func refresh():
	if mask != null:
		mask.material = daylight_shader
		mask.visible = true
	
	if not visible:
		return
	var g = _get_game()
	var inj = g.injured
	
	var t = g.get_time()
	day_length = g.day_length
	
	if not inj:
		modulate_daylight(t, day_length)
		return
	modulate_injury_filter(inj)
	

func _get_game():
	if game == null:
		game = $"/root/Game"
	return game


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not visible:
		return
	if last_cur_time == null:
		return
	
	var g = _get_game()
	var t = g.get_time()
	var inj = g.injured
	
	if t == last_cur_time and inj == was_injured:
		return

	if not inj:
		modulate_daylight(t, day_length)
		return
	modulate_injury_filter(inj)


func modulate_injury_filter(injured: bool):
	was_injured = injured

	if injured:
		$InjuryOverlay.start()
		if mask:
			mask.process_mode = Node.PROCESS_MODE_DISABLED
			mask.visible = false
		return true
	
	$InjuryOverlay.stop()
	if mask:
		mask.process_mode = Node.PROCESS_MODE_INHERIT
		mask.visible = true
	return false

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
