extends Node2D

func on_start():
	$"/root/Game".set_state(["party"], [$"../../../..".npc_name])
	$DemoC1RegroupInitial.complete()
