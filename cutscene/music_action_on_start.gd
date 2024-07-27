extends Node

@export var just_fade_out = false
@export var crossfade_to: AudioStreamPlayer
@export var fade_speed = 2
@export var softstart = false


func on_start():
	if just_fade_out:
		$"/root/Game".fade_music_out()
		return
	$"/root/Game".play_music(crossfade_to, not softstart, fade_speed, softstart)
