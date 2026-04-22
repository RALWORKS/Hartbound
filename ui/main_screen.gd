extends SubViewportContainer

var demon_vignette: Shader = preload("res://effects/demon-vignette.gdshader")

var game: Node

var cur_material: ShaderMaterial

enum UI_HINTS {
	CODEX,
}

var pending_ui_hints = []

@onready var UI_HINT_FNS = {
	UI_HINTS.CODEX: [$LeftMenu, "hint_codex"]
}
	
func send_hint(type: int):
	var pair = UI_HINT_FNS[type]
	pair[0].call(pair[1])

func send_all_hints():
	if not pending_ui_hints.size():
		return
	for type in pending_ui_hints:
		send_hint(type)
	pending_ui_hints.clear()

func _process(_delta):
	if get_parent() == null:
		return
	
	if get_parent().chapter == null:
		return
	
	if (
		(
			get_parent().chapter.cutscene == null
			and get_parent().chapter.pending_event == null
		) or get_parent().cur_modal != null
	):
		$LeftMenu.show = true
	else:
		$LeftMenu.show = false
	
	send_all_hints()
