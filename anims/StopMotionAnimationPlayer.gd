@tool
extends AnimationPlayer

@export var step = 0.1


var timer = 0.0
var started = false


func _ready() -> void:
	playback_process_mode = ANIMATION_PROCESS_MANUAL
	connect("animation_changed", reset)

func reset():
	started = false
	timer = 0.0

func _process(delta: float) -> void:
	if not is_playing():
		return
	var adjusted = step / abs(speed_scale)
	timer += delta
	while timer >= adjusted:
		advance(adjusted)
		timer -= adjusted
