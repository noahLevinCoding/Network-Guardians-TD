class_name GameStateOptions
extends State

@export var options_node : Options
@export var infinite_video : InfiniteVideo


func _ready():
	options_node.back.connect(_on_back)
	
func enter():
	print("Enter GameStateOption")
	options_node.visible = true
	
	infinite_video.video_stream_player.paused = false
	infinite_video.visible = true
	
	SignalManager.pause_game.emit()
	
func exit():
	print("Exit GameStateOption")
	options_node.visible = false
	infinite_video.visible = false
	infinite_video.video_stream_player.paused = true

func _on_back():
	back_transition.emit(self)
	
