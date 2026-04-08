extends ColorRect


# Called when the node enters the scene tree for the first time.
func _ready():
	material.set_shader_parameter("blend_mode", 2)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
