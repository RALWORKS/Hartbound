extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	$ToolTip.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_mouse_entered():
	if $ToolTip.visible:
		return
	$ToolTip.visible =  true


func _on_mouse_exited():
	if not $ToolTip.visible:
		return
	$ToolTip.visible = false
