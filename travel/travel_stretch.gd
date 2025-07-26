extends Node2D

class_name TravelStretch

@export var travel_length_in_atoms: int
@export var atoms_per_turn: int = 5
@export var max_turns = 3

var turns_total = 0
var biome: Biome
var encounter: MapEncounter
var background: Node2D

var closing_notification = "" # TODO

var chapter

var CHARACTERS = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	$"/root/Game".set_context(ContextType.TRAVEL)
	setup_characters()
	if travel_length_in_atoms:
		set_clock()

func set_biome(new_biome: Biome):
	biome = new_biome
	if new_biome.background != null:
		var bg_position
		for c in $BG.get_children():
			bg_position = c.position
			c.queue_free()
		background = biome.background.instantiate()
		background.position = bg_position
		$BG.add_child(background)
	else:
		background = $BG.get_child(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func setup_characters():
	for c in $Characters.get_children():
		if "char_id" in c:
			CHARACTERS[c.char_id] = c

func end_travel():
	chapter.close_travel_stretch()

func start_turn():
	$MainTravelMenu.start()

func show_end_screen():
	$WalkDistanceNotification.visible = true
	$MainTravelMenu.stop()
	
func get_camp(g=null):
	if encounter != null:
		return encounter.destination_scene.instantiate()
	return biome.get_camp(g)

func start(g, travel_time, new_biome, new_encounter):
	encounter = new_encounter
	if encounter != null:
		closing_notification = encounter.arrival_notification
		g.save_map_encounter(encounter)
		
	travel_length_in_atoms = travel_time
	turns_total = travel_length_in_atoms / atoms_per_turn
	turns_total = turns_total if turns_total < max_turns else max_turns
	set_clock()
	set_biome(new_biome)
	play_opening(g)

func set_clock():
	$WalkDistanceNotification/Panel/data.text = $TimeUtils.moves_to_h_min(travel_length_in_atoms)

func play_opening(g):
	start_turn_if_needed(g)

func start_turn_if_needed(g):
	var turn = g.get_state(["active_travel", "turn"])
	turn = turn if turn else 0
	if turns_total - turn <= 1:
		return show_end_screen()
	start_turn()

func iterate_turn():
	var turn = $"/root/Game".get_state(["active_travel", "turn"])
	$"/root/Game".set_state(["active_travel", "turn"], turn + 1)


func _on_end_button_pressed():
	end_travel()
