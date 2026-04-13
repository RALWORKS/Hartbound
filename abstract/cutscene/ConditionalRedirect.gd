extends "res://abstract/cutscene/CutsceneNode.gd"

@export var next_if_true: Node
@export var next_if_false: Node
@export var get_condition_from: Node

## specifier data for the conditional, ex. character names, threshold numbers
@export var conditional_subject: String
@export var conditional_predicate: String
@export var bool_predicate: bool


func start():
	var p = conditional_predicate
	if bool_predicate:
		p = _str_to_bool(p)
	
	var is_true = get_condition_from.condition(conditional_subject, p)
	
	if is_true:
		next_if_true.start()
	else:
		next_if_false.start()

func _str_to_bool(d):
	return d == "true"
