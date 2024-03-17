extends Node2D

@export var npc_name = ""
var RoundButton = preload("res://ui/round_button.tscn")

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
	

func make_quest_buttons():
	var data = concepts.get_node("Quest").get_children()
	quest_nodes = _make_btn_array($Body/QuickBG/Quick/Data, data)
	
	
func setup():
	make_quest_buttons()

func teardown():
	for c in quest_nodes:
		c.queue_free()
	_set_results([])
	$Body/Searchbar.text = ""


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _set_results(data):
	for c in result_nodes:
		c.queue_free()
	
	result_nodes = _make_btn_array($Body/Search/Data, data)

func _make_btn_array(parent, data):
	var nodes = []
	for concept in data:
		if concept.hide_for_npc_name == npc_name:
			continue
		var btn = RoundButton.instantiate()
		btn.text = $StateTagReplacer.replace(concept.flex_title)
		btn.pressed.connect(func(): concept_chosen.emit(concept))
		parent.add_child(btn)
		nodes.push_back(btn)

	return nodes

func search(query):
	var data = concepts.search(query, _index)
	_set_results(data)


func _on_searchbar_text_changed():
	var query = $Body/Searchbar.text
	if "\n" in query:
		$Body/Searchbar.clear()
	
	
	if query.length() > 1:
		search(query)
	
	else:
		_set_results([])
