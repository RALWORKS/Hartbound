extends Node2D

var active = false
var was_active = false

@export var page: Node

# Called when the node enters the scene tree for the first time.
func _ready():
	mod_active()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	mod_active()
	

func mod_active():
	active = visible
	if page:
		active = active and page.visible
	if active == was_active:
		return
	was_active = active
	if active:
		$DaylightFilter.visible = true
		$DaylightFilter.process_mode = Node.PROCESS_MODE_INHERIT
		$DaylightFilter.refresh()
		return
	$DaylightFilter.visible = false
	$DaylightFilter.process_mode = Node.PROCESS_MODE_DISABLED
