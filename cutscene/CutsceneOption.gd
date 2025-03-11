extends Button

class_name CutsceneOption

@export var raise_to_ui_layer = true
@export var to: CutsceneNode
@export var to_cutscene: Resource
@export var get_action_from: Node
@export var sub_node_parent: Node

@export var data: Node

@export var avatar: Node
@export var smile = false
@export var frown = false
@export var scowl = false
@export var neutral = false

var _real_parent: Node

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func real_parent():
	if _real_parent != null:
		return _real_parent
	return get_parent()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_pressed():
	click()

func click():
	if disabled:
		return
	if real_parent().just_clicked:
		return
	if get_action_from != null:
		get_action_from.action()
	real_parent().leave()
	if to_cutscene != null:
		$"/root/Game/Chapter".cutscene.next_cutscene = to_cutscene
	if to != null:
		to.start()
	else:
		$"/root/Game/Chapter".end_cutscene()
	
func react():
	if avatar == null:
		return
	if neutral:
		return avatar.neutral()
	if smile:
		return avatar.smile()
	if frown:
		return avatar.frown()
	if scowl:
		return avatar.scowl()

func unreact():
	if avatar == null:
		return
	#avatar.neutral()

func _on_mouse_entered():
	react()
	
func _on_mouse_exited():
	unreact()
