extends Node

@onready var cutscene = $"..".get_parent()

var next = null

# Called when the node enters the scene tree for the first time.
func _ready():
	next = $"..".next
	$"..".next = null
	$"../Skip".to = next
	$"../ConceptMapSearcher".npc_name = cutscene.npc_name


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_concept_map_visualizer_concept_chosen(concept):
	if $"..".just_clicked:
		return
	cutscene.talk_about(concept)
	#$"../ConceptMapVisualizer".teardown()

func on_start():
	#$"../ConceptMapVisualizer".setup()
	$"../ConceptMapSearcher".setup()
	pass


func _on_concept_map_searcher_concept_chosen(concept):
	if $"..".just_clicked:
		return
	cutscene.talk_about(concept)
	$"../ConceptMapSearcher".teardown()
