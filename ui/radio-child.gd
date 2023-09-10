extends CheckBox
@export var value: String = ""


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass



func _on_pressed():
	if get_parent().has_method("child_clicked"):
		get_parent().child_clicked(self)
