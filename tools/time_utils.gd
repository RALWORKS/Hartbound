extends Node

class_name TimeUtils

var day_starts_at: int
var day_length: int

func _ready():
	day_starts_at = $"/root/Game".day_starts_at
	day_length = $"/root/Game".day_length

func format_moves_24h(moves):
	return format_time_24h(float(moves) / day_length)

func format_time_24h(days):
	var d = float(int(days))
	var t = days - d
	
	var raw = t * 24
	var hours = int(raw)
	var frac = raw - float(hours)
	var min = int(frac * 60)
	
	return z_pad((hours + day_starts_at) % 24, 2) + ":" + z_pad(min, 2)

func hours_to_native_fraction(hours: float):
	return hours / 24.0

func native_fraction_to_hours(frac: float):
	return frac * 24.0

func moves_to_hours(moves: int):
	return native_fraction_to_hours(float(moves) / float(day_length))

func hours_to_moves(hours: float):
	return int(hours * (float(day_length) / 24.0))

func z_pad(orig: int, len: int):
	var ret = str(orig)
	
	while ret.length() < len:
		ret = "0" + ret
	
	return ret
