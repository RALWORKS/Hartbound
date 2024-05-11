extends Node2D
class_name CutsceneNode

@export var next: CutsceneNode
@export var previous: CutsceneNode
@export var on_start: Callable
@export var is_option_node: bool
@export var use_on_start_fn_from: Node
@export var tag: String = ""
@export var override_pause = false
@export var end = false

var just_clicked = false
var cutscene

func _input(event):
	if (
		event.is_action_pressed("click") 
		or event.is_action_pressed("next")
	) and not just_clicked and self.visible:
		flip()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func leave():
	self.visible = false

func _pause_next():
	if override_pause:
		return
	just_clicked = true
	await get_tree().create_timer(0.3).timeout
	just_clicked = false

func start():
	self.visible = true
	_pause_next()
	$"/root/Game/Chapter".update_cutscene_page(self)
	if on_start:
		on_start.call()
	elif use_on_start_fn_from:
		use_on_start_fn_from.on_start.call()
	for c in get_children():
		if "on_start" in c:
			c.on_start()
func flip():
	if is_option_node:
		return
	self.leave()
	if next != null:
		next.start()
	else:
		$"/root/Game/Chapter".end_cutscene()

func back():
	if previous:
		self.leave()
		previous.start()
