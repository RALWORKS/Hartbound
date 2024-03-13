extends Node2D

@export var npc_name = ""

@onready var concepts: Node = get_tree().get_root().get_node("Game/ConceptMap")
var SmartLable = preload("res://cutscene/smart_label.tscn")

signal concept_chosen(concept)

var result_nodes = []
var quest_nodes = []

const DEFAULT_BTN_START = 280

const BTN_X = 850

var start_y = DEFAULT_BTN_START

var _index = null

# Called when the node enters the scene tree for the first time.
func _ready():
	set_npc_name(npc_name)

func set_npc_name(n):
	npc_name = n
	if npc_name.length() > 0:
		_index = concepts.make_custom_npc_index(npc_name)
	

func make_default_buttons():
	var data = concepts.get_node("Quest").get_children()
	_set_results(data)
	
func setup():
	make_default_buttons()

func teardown():
	for c in quest_nodes:
		c.queue_free()
	_set_results([])
	$Body/Searchbar.text = ""


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _set_results(data):
	for c in result_nodes + quest_nodes:
		c.queue_free()
		
	var x = BTN_X
	var y = DEFAULT_BTN_START
	
	result_nodes = _make_btn_array(x, y, data)[0]

func _make_btn_array(x, y, data):
	var nodes = []
	for concept in data:
		if concept.hide_for_npc_name == npc_name:
			continue
		var btn = Button.new()
		btn.size = Vector2(705, 50)
		btn.text = $StateTagReplacer.replace(concept.flex_title)
		btn.position = Vector2(x, y)
		btn.pressed.connect(func(): concept_chosen.emit(concept))
		$".".add_child(btn)
		nodes.push_back(btn)
		y += 70

	return [nodes, y]

func search(query):
	var data = concepts.search(query, _index)
	_set_results(data)


func _on_searchbar_text_changed():
	var query = $Body/Searchbar.text
	
	if query.length() == 0:
		make_default_buttons()
	
	elif query.length() > 1:
		search(query)
	
	else:
		_set_results([])
