extends Node2D

@export var title: String
@export var offset: Vector2 = Vector2(15, 15)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func set_title(t):
	title = t
	$Wrap/Title.text = title
	print($"..")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$Wrap/Title.position = get_global_mouse_position() + offset
