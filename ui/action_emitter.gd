extends Node

@onready var game = $"/root/Game"

enum TYPE {
	HI,
	TOPIC,
	ROOM_CHANGE,
	START_TRIP,
	END_TRIP,
}

var SCHEMA = {
	TYPE.HI: {"npc_id": null},
	TYPE.TOPIC: {"npc_id": null, "concept_id": null},
	TYPE.ROOM_CHANGE: {"dest_id": null},
	TYPE.START_TRIP: {},
	TYPE.END_TRIP: {},
}

func send(type: TYPE, data: Dictionary = {}):
	if not game.chapter:
		return
	game.chapter.feed(type, _make_payload(type, data))

func _make_payload(type: TYPE, data: Dictionary):
	var ret = {}
	
	for key in SCHEMA[type]:
		if key in data:
			ret[key] = data[key]
			continue
		ret[key] = null
	
	return ret
