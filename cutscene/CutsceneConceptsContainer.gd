extends Node

@export var next: Node = null

# Called when the node enters the scene tree for the first time.
func _ready():
	for concept in get_children():
		for cnode in concept.get_children():
			cnode.visible = false
			if cnode.next == null and not cnode.end:
				cnode.next = next
