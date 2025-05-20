extends "ChapterEvent.gd"

enum ACTION_TYPE {
	HI,
	TOPIC,
	ROOM_CHANGE,
	START_TRIP,
	END_TRIP,
}

@export var action_type: ACTION_TYPE
@export var profile_pairs: Array[String]
@export var required_count: int

var count = 0
# TODO: save count

func _make_keypairs():
	var pairs = []
	var i = 0
	while i < profile_pairs.size():
		pairs.push_back([profile_pairs[i], profile_pairs[i+1]])
		i = i + 2

func iterate():
	count = count + 1
	if count >= required_count:
		$"/root/Game".chapter.next()

func receive_action(type, data):
	if not type == action_type:
		return
	
	for pair in _make_keypairs():
		if not pair[0] in data:
			return
		if data[pair[0]] != pair[1]:
			return
	
	iterate()
	
