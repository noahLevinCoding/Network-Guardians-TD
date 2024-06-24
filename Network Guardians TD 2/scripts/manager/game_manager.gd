extends Node

var map_scene_path : String = ""
var difficulty : int = 1
var is_paused : bool = true :
	set(value):
		is_paused = value
		Engine.time_scale = 0 if value else 1.0

func reset():
	is_paused = true
