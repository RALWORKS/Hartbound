extends Button

@export var chapter = "2segue"


func _on_pressed():
	$"../..".new_from_chapter(chapter)
	$"..".queue_free()
