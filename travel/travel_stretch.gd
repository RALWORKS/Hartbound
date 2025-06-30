extends Node2D

class_name TravelStretch

@export var travel_length_in_atoms: int
@export var atoms_per_turn: int = 30

var turns_left = travel_length_in_atoms / atoms_per_turn
var biome: Biome
var encounter: MapEncounter
var background: Node2D

var closing_notification = "" # TODO

var chapter

var CHARACTERS = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	setup_characters()
	if travel_length_in_atoms:
		set_clock()
	#play_opening()

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
	pass

func show_end_screen():
	$WalkDistanceNotification.visible = true
	
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
	set_clock()
	set_biome(new_biome)
	play_opening()

func set_clock():
	$WalkDistanceNotification/Panel/data.text = $TimeUtils.moves_to_h_min(travel_length_in_atoms)

func play_opening():
	start_turn_if_needed()

func start_turn_if_needed():
	if turns_left < 1:
		return show_end_screen()
	start_turn()


func _on_end_button_pressed():
	end_travel()
