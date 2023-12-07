extends Node

var game

func _get_game():
	if game == null:
		game = get_tree().get_root().get_node("Game")
	return game

@export var id = ""
@export var headline = ""
@export var on_start_modal_maker: Node
@export var on_done_modal_maker: Node
@export var on_done_script_node: Node
@export var on_start_script_node: Node
@export var initial_concepts_container: Node
@export var next_quest: Node
## When the quest is used as data, this resource holds additional info, such as a cutscene
@export var data_resource: Resource

var concepts = []

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(id.length() > 0)
	assert(headline.length() > 0)
	for c in initial_concepts_container.get_children():
		concepts.push_back(c)


func start():
	if on_start_modal_maker != null:
		if not on_start_modal_maker.title.length():
			on_start_modal_maker.title = "New Quest: " + self.headline
		on_start_modal_maker.make()
	if on_start_script_node != null:
		on_start_script_node.action()
	var g = _get_game()
	g.start_quest(self)
	for c in initial_concepts_container.get_children():
		add_concept(c)

func complete():
	remove_all_concepts()
	print("complete?????")
	if on_done_modal_maker != null:
		if not on_done_modal_maker.title.length():
			on_done_modal_maker.title = "Quest Complete: " + self.headline
		on_done_modal_maker.make()
	if on_done_script_node != null:
		on_done_script_node.action()

	if next_quest != null:
		next_quest.start()
		print("next?")
	
	var g = _get_game()
	g.complete_quest(self)

func remove_all_concepts():
	var g = _get_game()
	var cmap = g.get_node("ConceptMap")
	cmap.remove_quest_concepts(concepts)

func add_concept(concept):
	var g = _get_game()
	var cmap = g.get_node("ConceptMap")
	cmap.add_concept(concept, $QuestConceptCategory)
