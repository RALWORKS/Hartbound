extends Node2D

@onready var concepts: Node = get_tree().get_root().get_node("Game/ConceptMap")

var RoundButton = preload("res://ui/round_button.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	load_codex()


func load_codex():
	$Searchbar.text = ""
	for c in $ScrollContainer/Data.get_children():
		c.free()
	for id in concepts.categories:
		if id in ["You", "Insult"]:
			continue
		for data in concepts.categories[id]:
			_make_btn(data)


func _on_to_reflections_pressed():
	$".".visible = false
	$"../CodexDetail".visible = false
	$"../Reflections".visible = true

func _make_btn(concept):
	var btn = RoundButton.instantiate()
	btn.text = $"../../StateTagReplacer".replace(concept.flex_title)
	#btn.position = Vector2(x, y)
	btn.pressed.connect(func(): _show_detail(concept))
	$ScrollContainer/Data.add_child(btn)
	#y += 70

func _make_btn_array(data):
	for d in data:
		_make_btn(d)

func _set_results(data):
	for c in $ScrollContainer/Data.get_children():
		c.free()
	_make_btn_array(data)

func search(query):
	var data = concepts.search(query, concepts._index)
	_set_results(data)

func _on_searchbar_text_changed():
	var query = $Searchbar.text
	
	if query.length() == 0:
		load_codex()
	
	elif query.length() > 0:
		search(query)
	
	else:
		_set_results([])

func _show_detail(c):
	$"../CodexDetail".visible = true
	$".".visible = false
	$"../CodexDetail/DetailTitle".text = $"../../StateTagReplacer".replace(c.flex_title)
	$"../CodexDetail/Data".text = $"../../StateTagReplacer".replace(c.description)

func _on_ok_pressed():
	$"../CodexDetail".visible = false
	$".".visible = true
	load_codex()
