extends Node

@export var day_length = 16
@export var night_threshold = 0.6
@export var day_starts_at = 6
@export var MORNING = 0.0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_state(p):
	return  state.get_state(p)

func set_state(p, v):
	return  state.set_state(p, v)

func _init_moves_if_needed():
	var data = get_state(["moves"])
	if data != null:
		return data
	return set_state(["moves"], 0)

func _init_timers_if_needed():
	var data = get_state(["timers"])
	if data != null:
		return data
	return set_state(["timers"], [])

func add_timer(n, trigger_name):
	var m = _init_moves_if_needed()
	var timers = _init_timers_if_needed()
	set_state(["timers"], timers + [[m + n, trigger_name]])

func check_timers():
	var m = get_moves()
	var timers = get_timers()
	var remaining = []
	for t in timers:
		if t[0] <= m:
			g.chapter.trigger(t[1])
			continue
		remaining.push_back(t)
	set_state(["timers"], remaining)

func move():
	var m = _init_moves_if_needed()
	set_state(["moves"], m + 1)
	status.check_timers()
	advance_time()

func get_moves():
	return _init_moves_if_needed()

func get_timers():
	return _init_timers_if_needed()

func advance_time():
	var t = _init_time_if_needed()
	t += 1
	
	var cap = get_state(["timecap"])
	
	if cap != null and t > cap:
		return
	
	set_state(["timestamp"], t)

func timestamp():
	return _init_time_if_needed()
	

func is_night():
	var t = proportional_time()
	if t > night_threshold:
		return true
	return false
	
	
func _init_time_if_needed():
	var data = get_state(["timestamp"])
	if data != null:
		return data
	return set_state(["timestamp"], 0.0)

func get_time():
	var dt = timestamp()
	return int(dt) % int(day_length)

func proportional_time():
	var t = get_time()
	return float(t) / float(day_length)

func get_date():
	var dt = timestamp()
	return int(float(dt) / float(day_length))


func stop_time_in(day_quotient):
	set_state(["timecap"], timestamp() + (day_quotient * day_length))

func restart_time():
	set_state(["timecap"], null)

func jump_over_time(days):
	set_state(["timestamp"], timestamp() + days * day_length)

func jump_over_moves(moves):
	set_state(["timestamp"], timestamp() + moves)

func jump_to_time(date_in_days):
	set_state(["timestamp"], date_in_days * day_length)

func jump_to_time_using_relative_days(date_in_days: float):
	var target_d = int(date_in_days)
	var target_t = abs(float(date_in_days) - float(target_d))
	var target = float(get_date() + target_d) + target_t
	set_state(["timestamp"], target * day_length)

func jump_to_morning():
	var d = get_date() + 1
	var t = MORNING
	var dt = (d * day_length) + t
	set_state(["timestamp"], dt)
