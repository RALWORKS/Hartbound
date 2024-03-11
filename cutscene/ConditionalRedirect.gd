extends Node2D

@export var next_if_true: Node
@export var next_if_false: Node
@export var get_condition_from: Node

## specifier data for the conditional, ex. character names, threshold numbers
@export var conditional_subject: String
@export var conditional_predicate: String


func start():
	var is_true = get_condition_from.condition(conditional_subject, conditional_predicate)
	
	if is_true:
		next_if_true.start()
	else:
		next_if_false.start()
