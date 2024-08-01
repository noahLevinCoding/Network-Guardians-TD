class_name InfiniteVideo
extends Node2D

@export var video_stream_player : VideoStreamPlayer 

@export var video_60fps : String
@export var video_30fps : String

func _ready():
	if OS.get_name() == "Web":
		video_stream_player.stream.file = video_30fps
	else:
		video_stream_player.stream.file = video_60fps
		
	video_stream_player.play()


