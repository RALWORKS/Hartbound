extends Button

@export var item: Node


# Called when the node enters the scene tree for the first time.
func _ready():
	set_item(item)


func set_item(some_item):
	item = some_item
	if item == null:
		return
	$Icon.texture = item.icon
	$Label.text = item.title
