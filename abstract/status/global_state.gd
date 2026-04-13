extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


var INITIAL_STATE = {
	"character": {
		"texture": {
			"skin": 0,
			"skin-color": 1,
			"hair": 1,
			"hair-color": 1,
			"outfit": 2,
			"outfit-color-1": 3,
			"outfit-color-2": 3,
			"build": 1,
			"eyes": 1,
			"face": 0,
			"pattern": 0,
		},
	},
	"micro_progress": {
		"events": [],
		"map_events": [],
	},
	"profile": {
		"job": "salvager",
		"texture": {
			"bg": 0,
			"bg-texture": 3,
			"filter": 0,
			"shot": 0,
		},
	},
	"chapter": "create",
	"story": [],
	"position": {
		"scene_path": null,
		"entrance_name": null,
	},
	"injured": false,
	"moves": 0,
	"timers": [],
	"timestamp": 0.0,
	"timecap": null,
}

var STATE = INITIAL_STATE.duplicate(true)

func get_state_default(ix):
	return _get_state(ix, {
		#"taylor": {
		#	"calls_me": get_state(["character", "name", "elves_call"], false)
		#}
	})

func save():
	if STATE["savefile_name"] and g._null_or_empty(get_state(["savefile_path"])):
		STATE["savefile_path"] = g._clean_name_to_path(STATE["savefile_name"]) + ".sav"
	elif g._null_or_empty(get_state(["savefile_path"])):
		STATE["savefile_path"] = g._rand_path() + ".sav"

	var file = FileAccess.open(
		"user://save/" + STATE["savefile_path"],
		FileAccess.WRITE
	)
	var content = JSON.stringify(STATE)
	file.store_string(content)

func reset_state():
	STATE = INITIAL_STATE.duplicate(true)

func deep_init_state():
	STATE["character"]["texture"] = INITIAL_STATE["character"]["texture"].duplicate()
	STATE["profile"]["texture"] = INITIAL_STATE["profile"]["texture"].duplicate()
	
func _get_state(ix, d):
	if not ix[0] in d:
		return null

	if ix.size() == 1:
		return d[ix[0]]

	return _get_state(ix.slice(1), d[ix[0]])

func get_state(ix, defaults=true):
	var data = _get_state(ix, STATE)
	if data == null and defaults:
		return get_state_default(ix)
	return data

func _deep_set(d, ix, val):
	if not ix[0] in d:
		d[ix[0]] = {}
	if ix.size() == 1:
		d[ix[0]] = val
		return
	_deep_set(d[ix[0]], ix.slice(1), val)

func set_state(ix, val):
	_deep_set(STATE, ix, val)
	return val

func set_state_push_to_key(ix, val):
	var cur = get_state(ix)
	if cur == null:
		set_state(ix, [val])
		return
	set_state(ix, cur + [val])

func push_story(title_, narrative):
	state.STATE["story"].append({
		"title": title_,
		"narrative": narrative
	})

func start(s):
	STATE = s
	status.injured = STATE["injured"] if "injured" in STATE else false
	status.started = true
	return load_chapter()

func load_chapter():
	return g.CHAPTERS[STATE["chapter"]].instantiate()

func start_from_chapter(start_at: String):
	deep_init_state()
	STATE["chapter"] = "create"
	STATE["start_from"] = start_at
