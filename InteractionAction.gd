extends Node

## Use for complex modals requiring their own saved scene
@export var to_modal_resource: Resource
## Use with InteractionModalMaker for simple modals
@export var to_modal_maker: Node
@export var to_cutscene: Resource
@export var script_node: Node
@export var title: String
@export var is_close_btn = false
@export var enabled = true
@export var trigger_name = ""

var parent

var game

func _get_game():
	if game == null:
		game = get_tree().get_root().get_node("Game")
	return game
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func action():
	var g = _get_game()
	if script_node != null:
		script_node.action()
		await get_tree().create_timer(0.2).timeout
	if trigger_name.length() > 0:
		g.get_node("Chapter").trigger(trigger_name)
	if to_modal_resource != null:
		var cur_window = to_modal_resource.instantiate()
		cur_window.open(g)
	elif to_modal_maker != null:
		to_modal_maker.make()
	elif to_cutscene != null:
		g.get_node("Chapter").start_cutscene(to_cutscene, self)
	if is_close_btn != null and parent != null:
		parent.close()
