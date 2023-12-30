extends Node

@export var quest_to_remove: Node
@export var quest_to_complete: Node
@export var quest_to_start: Node

func mutate():
	if quest_to_remove and quest_to_remove.is_active():
		quest_to_remove.stop()
	if quest_to_complete and quest_to_complete.is_active():
		quest_to_complete.complete()
	if quest_to_start and not quest_to_start.is_active():
		quest_to_start.start()

func rerun():
	pass
