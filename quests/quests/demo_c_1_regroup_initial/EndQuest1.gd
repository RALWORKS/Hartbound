extends Node2D

func on_start():
	$"../../../..".npc.start_following($"/root/Game")
	$DemoC1RegroupInitial.complete()
