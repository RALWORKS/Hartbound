extends SubViewportContainer

var demon_vignette: Shader = preload("res://effects/demon-vignette.gdshader")

var game: Node

var cur_material: ShaderMaterial

@export var daylight_darken: Curve
@export var daylight_saturate: Curve
@export var daylight_contrast: Curve
@export var dalyight_warmth: Curve

func run_black():
	post_shader(demon_vignette)
	

func post_shader(s):
	cur_material = ShaderMaterial.new()
	cur_material.shader = s
	cur_material.set_shader_parameter("screen_texture", $World.get_texture())
	
	$PostProcessing/Filter.material = cur_material
	$PostProcessing/Filter.visible = true

func clear_postprocessing():
	cur_material = null
	$PostProcessing/Filter.material = null
	$PostProcessing/Filter.visible = false


func modulate_daylight(cur_time: int, day_length: int):
	var r = float(cur_time) / float(day_length)
	var d = daylight_darken.sample(r)
	var s = daylight_saturate.sample(r)
	var c = daylight_contrast.sample(r)
	var w = dalyight_warmth.sample(r)
	
	$Daylight/Filter.material.set_shader_parameter("saturate", s)
	$Daylight/Filter.material.set_shader_parameter("contrast", c)
	$Daylight/Filter.material.set_shader_parameter("darken", d)
	$Daylight/Filter.material.set_shader_parameter("warmth", w)

func _process(_delta):
	if get_parent() == null:
		return
	
	if get_parent().chapter == null:
		return
	
	if (
		(get_parent().chapter.cutscene == null and get_parent().chapter.active_map == null)
		or get_parent().cur_modal != null
	):
		$Menu2/ColorRect.visible = true
		$PostProcessing/Filter.modulate = "#ffffffff"
		if not $PostProcessing/Filter.material:
			$PostProcessing/Filter.material = cur_material
	else:
		$Menu2/ColorRect.visible = false
		$PostProcessing/Filter.modulate = "#ffffff00"
		$PostProcessing/Filter.material = null
	
	if get_parent().cur_modal:
		$PostProcessing.visible = false
	else:
		$PostProcessing.visible = true
