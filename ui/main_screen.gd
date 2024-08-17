extends SubViewportContainer

var game: Node

func _process(_delta):
	if get_parent() == null:
		return
	
	if get_parent().chapter == null:
		return
	
	if get_parent().chapter.cutscene == null:
		$Menu2/ColorRect.visible = true
	else:
		$Menu2/ColorRect.visible = false
	
	if get_parent().cur_modal:
		$PostProcessing.visible = false
	else:
		$PostProcessing.visible = true
