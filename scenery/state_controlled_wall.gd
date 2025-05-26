extends Node2D

@export var block_state_micro_tag: String
@export var block_if = false
@export_multiline var notification = ""

var is_blocking = true
var was_blocking = true

var wall: CollisionPolygon2D
var sensor: CollisionPolygon2D

var game

func refresh():
	var _state = game.get_state(["micro_progress", block_state_micro_tag])
	var state = _state == true

	var is_blocking = state

	if not block_if:
		is_blocking = not state
	
	if is_blocking == was_blocking:
		return
	
	was_blocking = is_blocking

	if is_blocking:
		enable()
		return

	disable()

func enable():
	$WallContainer.process_mode = Node.PROCESS_MODE_INHERIT
	$SensorContainer.process_mode = Node.PROCESS_MODE_INHERIT
	wall.process_mode = Node.PROCESS_MODE_INHERIT
	sensor.process_mode = Node.PROCESS_MODE_INHERIT

func disable():
	$WallContainer.process_mode = Node.PROCESS_MODE_DISABLED
	$SensorContainer.process_mode = Node.PROCESS_MODE_DISABLED
	wall.process_mode = Node.PROCESS_MODE_DISABLED
	sensor.process_mode = Node.PROCESS_MODE_DISABLED

# Called when the node enters the scene tree for the first time.
func _ready():
	game  = $"/root/Game"
	setup()
	enable()

func setup():
	wall = get_child(2)
	remove_child(wall)
	$WallContainer.add_child(wall)
	sensor  = get_child(2)
	remove_child(sensor)
	$SensorContainer.add_child(sensor)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	refresh()



func _on_sensor_container_body_entered(body):
	if not body.has_method("is_player"):
		return
	if notification.length() == 0:
		return
	$"/root/Game".notify(notification)
