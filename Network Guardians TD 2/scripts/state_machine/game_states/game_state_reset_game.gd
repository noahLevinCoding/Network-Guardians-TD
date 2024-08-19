extends State
class_name GameStateResetGame

@export var game_node : Node = null
@export var infinite_video : InfiniteVideo = null


func enter():
	print("Enter GameState ResetGame")
	
	infinite_video.visible = false
	infinite_video.video_stream_player.paused = true
	infinite_video.audio_stream_player_titlescreen.stop()
	
	infinite_video.audio_stream_player_game.play()
	
	for child in game_node.get_children():
		for node in child.get_children():
			node.queue_free()
	
	GameManager.reset()
	SignalManager.reset_game.emit()
	state_transition.emit(self, "InitGame")
	
	
func exit():
	print("Exit GameState ResetGame")
	
	
