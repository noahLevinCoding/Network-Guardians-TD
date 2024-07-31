extends Node2D

@onready var video_stream_player = $VideoStreamPlayer

func _process(delta):
	print(delta)
	
	
func _input(event):
	if Input.is_action_just_pressed("left_mouse_button"):
		video_stream_player.visible = false
		video_stream_player.paused = true


