extends State
class_name GameStateTitlescreen

@export var titlescreen_node : Titlescreen = null
@export var infinite_video : InfiniteVideo = null
@export var game_node : Node = null

	
func _ready():
	titlescreen_node.play.connect(_on_play)
	titlescreen_node.exit.connect(_on_exit)
	titlescreen_node.options.connect(_on_options)
	

func enter():
	print("Enter GameState Titlescreen")
	infinite_video.visible = true
	titlescreen_node.visible = true
		
	infinite_video.video_stream_player.paused = false
	if not infinite_video.audio_stream_player_titlescreen.playing:
		infinite_video.audio_stream_player_titlescreen.play()
	infinite_video.audio_stream_player_game.stop()
	
	for child in game_node.get_children():
		for node in child.get_children():
			node.queue_free()
	
func exit():
	print("Exit GameState Titlescreen")
	titlescreen_node.visible = false
	

func _on_play():
	state_transition.emit(self, "MapSelection")
	
func _on_exit():
	get_tree().quit()

func _on_options():
	state_transition.emit(self, "Options")
	

