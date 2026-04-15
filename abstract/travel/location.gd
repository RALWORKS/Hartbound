extends Node

@onready var map: Node = $Map


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func load_position(p):
	map.load_position(p)

func get_travel():
	var data = state.get_state(["active_travel"])
	if data != null:
		return data

	return state.set_state(["active_travel"], {
		"is_active": false,
		"biome_ix": null,
		"encounter_ix": null,
		"time_delta": null,
		"turn": 0,
	})

func start_travel(biome_ix, encounter_ix, time_delta):
	_init_outer_position_if_needed()
	var x = state.get_state(["micro_progress", "outer_position", "x"])
	var y = state.get_state(["micro_progress", "outer_position", "y"])
	state.set_state(["active_travel"], {
		"is_active": true,
		"biome_ix": biome_ix,
		"encounter_ix": encounter_ix,
		"time_delta": time_delta,
		"turn": 0,
		"starting_x": x,
		"starting_y": y,
	})

func end_travel():
	return state.set_state(["active_travel"], {
		"is_active": false,
		"biome_ix": null,
		"encounter_ix": null,
		"time_delta": null,
		"turn": 0,
	})

func _init_map_encounters_if_needed():
	var data = state.get_state(["micro_progress", "map_encounters"])
	if data != null:
		return data
	return state.set_state(["micro_progress", "map_encounters"], [])

func save_map_encounter(e):
	var data = _init_map_encounters_if_needed()
	return state.set_state(["micro_progress", "map_encounters"], data + [e.name])

func check_map_encounter(e):
	var data = _init_map_encounters_if_needed()
	return e.name in data

func _init_outer_position_if_needed():
	var data = state.get_state(["micro_progress", "outer_position"])
	if data != null:
		return data
	state.set_state(["micro_progress", "outer_position", "x"], null)
	state.set_state(["micro_progress", "outer_position", "y"], null)

func get_outer_position():
	_init_outer_position_if_needed()
	var x = state.get_state(["micro_progress", "outer_position", "x"])
	var y = state.get_state(["micro_progress", "outer_position", "y"])
	if x == null or y == null:
		return null
	return Vector2(x, y)

func set_outer_position(p: Vector2):
	_init_outer_position_if_needed()
	state.set_state(["micro_progress", "outer_position", "x"], p.x)
	state.set_state(["micro_progress", "outer_position", "y"], p.y)
	return p

func init_travel_events_if_needed():
	var q = state.get_state(["micro_progress", "travel_events"])
	if q != null:
		return
	state.set_state(
		["micro_progress", "travel_events"],
		{},
	)

func save_room(scene_path, entrance_name=null):
	var data = {"scene_path": scene_path, "entrance_name": entrance_name, "x": null, "y": null}
	
	state.set_state(
		["position"],
		data
	)

func save_position():
	if not glob.g.player:
		return
	var data = state.get_state(["position"])
	var p = glob.g.player.get_p()
	data.x = p.x
	data.y = p.y
	state.set_state(["position"], data)
