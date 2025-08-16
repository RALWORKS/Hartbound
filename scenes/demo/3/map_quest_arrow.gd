extends Sprite2D

@export var pencil: Node
#@export var target: Vector2
@export var active_mod: Color = "#d87c0097"
@export var inactive_mod: Color = "#dddddd97"


func set_mod(mod):
	self_modulate = mod
	get_child(0).self_modulate = mod


# Called when the node enters the scene tree for the first time.
func _ready():
	pencil.arrow = self

func start_drawing_mode():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = pencil.position
	
	for c in get_children():
		c.rotation = position.angle_to_point(c.target)
