extends Node2D
class_name CutsceneNode

@export var next: CutsceneNode
@export var previous: CutsceneNode
@export var on_start: Callable
@export var is_option_node: bool
@export var use_on_start_fn_from: Node

var just_clicked = false

func _input(event):
	if (
		event.is_action_pressed("click") 
		or event.is_action_pressed("next")
	) and not just_clicked and self.visible:
		flip()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func leave():
	self.visible = false

func _pause_next():
	just_clicked = true
	await get_tree().create_timer(0.3).timeout
	just_clicked = false

func start():
	self.visible = true
	_pause_next()
	if on_start:
		on_start.call()
	elif use_on_start_fn_from:
		use_on_start_fn_from.on_start.call()

func flip():
	if is_option_node:
		return
	self.leave()
	if next:
		next.start()
	else:
		$"/root/Game/Chapter".end_cutscene()

func back():
	if previous:
		self.leave()
		previous.start()
