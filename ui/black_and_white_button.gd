extends Button


var is_on = false

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("mouse_entered", hover)
	connect("mouse_exited", unhover)
	unhover()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func toggle():
	if is_on:
		off()
		return
	on()

func on():
	$Indicator.visible = true
	$Icon.modulate = glob.BLACK
	is_on = true

func off():
	$Indicator.visible = false
	$Icon.modulate = glob.WHITE
	is_on = false

func hover():
	$ToolTip.visible = true

func unhover():
	$ToolTip.visible = false
