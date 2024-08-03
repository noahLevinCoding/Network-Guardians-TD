extends State
class_name GameStateResetGame

@export var game_node : Node = null
@export var infinite_video : InfiniteVideo = null


func enter():
	print("Enter GameState ResetGame")
	
	infinite_video.visible = false
	infinite_video.video_stream_player.stop()
	
	for child in game_node.get_children():
		game_node.remove_child(child)
		child.queue_free()
	
	GameManager.reset()
	SignalManager.reset_game.emit()
	state_transition.emit(self, "InitGame")
	
	
func exit():
	print("Exit GameState ResetGame")
	
	
