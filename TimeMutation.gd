extends ChapterEventMutation

enum TIME_MUTATION_TYPE {
	JUMP_OVER,
	JUMP_TO,
	STOP_IN,
	RESTART,
	JUMP_TO_MORNING,
	JUMP_TO_USING_RELATIVE_DAYS,
}


@export var time_mutation: TIME_MUTATION_TYPE
@export var n_days: float


func mutate():
	var game: Game = $".".get_tree().get_root().get_node("Game")
	
	if time_mutation == TIME_MUTATION_TYPE.JUMP_OVER:
		return game.jump_over_time(n_days)
	if time_mutation == TIME_MUTATION_TYPE.JUMP_TO:
		return game.jump_to_time(n_days)
	if time_mutation == TIME_MUTATION_TYPE.STOP_IN:
		return game.stop_time_in(n_days)
	if time_mutation == TIME_MUTATION_TYPE.RESTART:
		return game.restart_time()
	if time_mutation == TIME_MUTATION_TYPE.JUMP_TO_MORNING:
		return game.jump_to_morning()
	if time_mutation == TIME_MUTATION_TYPE.JUMP_TO_USING_RELATIVE_DAYS:
		return game.jump_to_time_using_relative_days(n_days)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
