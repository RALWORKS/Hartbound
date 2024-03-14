extends Button

@export var title: String
@export var description: String

func refresh():
	$Title.text = title
	$Description.text = description
