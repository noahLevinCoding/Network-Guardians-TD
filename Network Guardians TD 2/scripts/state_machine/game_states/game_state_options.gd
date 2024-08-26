class_name GameStateOptions
extends State

@export var options_node : Options
@export var infinite_video : InfiniteVideo


func _ready():
	options_node.back.connect(_on_back)
	options_node.wiki.connect(_on_wiki)
	options_node.credits.connect(_on_credits)
	
func enter():
	print("Enter GameStateOption")
	options_node.visible = true
	
	infinite_video.video_stream_player.paused = false
	infinite_video.visible = true
	
func exit():
	print("Exit GameStateOption")
	options_node.visible = false
	infinite_video.visible = false
	infinite_video.video_stream_player.paused = true

func _on_back():
	back_transition.emit(self)
	
func _on_wiki():
	pass
	
func _on_credits():
	pass
