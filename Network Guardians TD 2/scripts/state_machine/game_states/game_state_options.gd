class_name GameStateOptions
extends State

@export var options_scene : PackedScene

var options_scene_instance = null

func enter():
	print("Enter GameStateOption")
	var options_scene_instance = options_scene.instantiate()
	add_child(options_scene_instance)
	
func exit():
	print("Exit GameStateOption")
	remove_child(options_scene_instance)
	options_scene_instance.queue_free()
