extends Node2D
var topics = []
@export var texture: ResourcePreloader
@export var hframes = 1
@export var vframes = 1

@onready var NON_TOPIC_CHILDREN = [
	$CollisionShape2D,
	$Sprite2D,
	$InteractionArea,
]

func set_frame(frame):
	$Sprite2D.frame = frame

func _child_is_probably_a_topic(child):
	return not NON_TOPIC_CHILDREN.has(child)

func _setup_sprite():
	$Sprite2D.texture = texture
	$Sprite2D.hframes = hframes
	$Sprite2D.vframes = vframes

# Called when the node enters the scene tree for the first time.
func _ready():
	_setup_sprite()
	topics = get_children().filter(_child_is_probably_a_topic)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _get_initial_topic():
	pass
	

func _say_topic(topic):
	pass

func action():
	return _say_topic(
		_get_initial_topic()
	)
