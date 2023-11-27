extends Area2D

var game

func _get_game():
	if game == null:
		game = get_tree().get_root().get_node("Game")
	return game

@export var wall_area_node: CollisionPolygon2D
@export var quest: Node
@export var cannot_pass_cutscene: Resource

var triggering = false

func _ready():
	wall_area_node.get_parent().remove_child(wall_area_node)
	$Wall.add_child(wall_area_node)

func _on_body_entered(body):
	var g = _get_game()
	if !g.is_quest_active(quest):
		if get_node_or_null("Wall") != null:
			$Wall.free()
		return
	if not body.has_method("is_player") or not body.is_player():
		return
	if triggering:
		return
	triggering = true
	if cannot_pass_cutscene != null:
		g.get_node("Chapter").start_cutscene(cannot_pass_cutscene, self)




func _on_body_exited(body):
	if not body.has_method("is_player") or not body.is_player():
		return
	var g = _get_game()
	if g.chapter == null or g.chapter.cutscene != null:
		return
	triggering = false
