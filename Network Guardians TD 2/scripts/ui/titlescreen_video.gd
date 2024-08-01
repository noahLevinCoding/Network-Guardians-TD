extends Node2D

@onready var video_stream_player = $VideoStreamPlayer
@onready var label = $Label

@export var video_60fps : String
@export var video_30fps : String


	
func _ready():
	label.text = OS.get_name()
	
	if OS.get_name() == "Web":
		video_stream_player.stream.file = video_30fps
		print("30fps")
	else:
		video_stream_player.stream.file = video_60fps
		print("60fps")
		
	video_stream_player.play()


