extends State
class_name GameStateTitlescreen

@export var titlescreen_node : Titlescreen = null
@export var infinite_video : InfiniteVideo = null
@export var game_node : Node = null

	
func _ready():
	titlescreen_node.play.connect(_on_play)
	titlescreen_node.exit.connect(_on_exit)
	

func enter():
	print("Enter GameState Titlescreen")
	infinite_video.visible = true
	titlescreen_node.visible = true
	
	if not infinite_video.video_stream_player.is_playing():
		infinite_video.video_stream_player.play()
	
	for child in game_node.get_children():
		game_node.remove_child(child)
		child.queue_free()
	
func exit():
	print("Exit GameState Titlescreen")
	titlescreen_node.visible = false
	

func _on_play():
	state_transition.emit(self, "MapSelection")
	
func _on_exit():
	get_tree().quit()
