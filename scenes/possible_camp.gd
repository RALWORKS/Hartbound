extends Node2D


var game

var is_night = false
var was_night = false

# Called when the node enters the scene tree for the first time.
func _ready():
	set_day()
	$Wrap/Circle.position = global_position
	$Wrap/Circle.scale = scale * $Wrap/Circle.scale


func set_night():
	$Wrap/Circle.visible = true
	$InteractionArea.process_mode = Node.PROCESS_MODE_INHERIT
	$AnimationPlayer.play("blink")

func set_day():
	$Wrap/Circle.visible = false
	$InteractionArea.process_mode = Node.PROCESS_MODE_DISABLED
	$AnimationPlayer.stop()

func update_state():
	if is_night:
		return set_night()
	return set_day()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	is_night = _get_game().is_night()
	if is_night != was_night:
		update_state()
	was_night = is_night

func _get_game():
	if game == null:
		game = $"/root/Game"
	return game

func action():
	_get_game().bedtime()
	set_day()
