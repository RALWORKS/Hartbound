extends Area2D

var game
var chapter

func _get_game():
	if game == null:
		game = get_tree().get_root().get_node("Game")
	return game

func _get_chapter():
	if chapter == null:
		var g = _get_game()
		chapter = g.get_node("Chapter")
	return chapter
	

@export var wall_area_node: CollisionPolygon2D
@export var blockade_quests_container: Node
@export var threshold_quests_container: Node
@export var trigger_name: String

var triggering = false
var threshold_quests = []
var blockade_quests = []

func _ready():
	#trigger_name = "LeaveCamp1"
	#assert(trigger_name == "LeaveCamp1")
	wall_area_node.get_parent().remove_child(wall_area_node)
	$Wall.add_child(wall_area_node)
	
	if threshold_quests_container != null:
		for c in threshold_quests_container.get_children():
			threshold_quests.push_back(c)
	if blockade_quests_container != null:
		for c in blockade_quests_container.get_children():
			blockade_quests.push_back(c)

func _filter_active_quests(quest):
	var g = _get_game()
	return g.is_quest_active(quest)

func _active_blockades():
	return blockade_quests.filter(_filter_active_quests)

func _active_thresholds():
	return threshold_quests.filter(_filter_active_quests)

func _active_any():
	return _active_thresholds() + _active_blockades()

func _on_body_entered(body):
	if not body.has_method("is_player") or not body.is_player():
		return
	if triggering:
		return
	triggering = true
	
	
	var blocks = _active_blockades()
	if blocks.size() == 0:
		$Wall.process_mode = Node.PROCESS_MODE_DISABLED
		if trigger_name.length() > 0:
			_get_chapter().trigger(trigger_name)
	else:
		$Wall.process_mode = Node.PROCESS_MODE_INHERIT
		
	var quests = _active_any()
	if quests.size() == 0:
		return
	var g = _get_game()
	for q in quests:
		if q.data_resource == null:
			return
		g.get_node("Chapter").start_cutscene(q.data_resource, self)




func _on_body_exited(body):
	if not body.has_method("is_player") or not body.is_player():
		return
	var g = _get_game()
	if g.chapter == null or g.chapter.cutscene != null:
		return
	triggering = false
