extends ChapterEventMutation

enum UI_HINTS {
	CODEX,
}


@export var hint_type: UI_HINTS


func mutate():
	var game: Game = $".".get_tree().get_root().get_node("Game")
	game.get_node("MainScreen").send_hint(hint_type)
