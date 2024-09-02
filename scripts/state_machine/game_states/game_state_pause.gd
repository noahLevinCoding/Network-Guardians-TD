extends State
class_name GameStatePause

@export var pause_node : Pause = null
@export var infinite_video : InfiniteVideo = null

func _ready():
	pause_node.back_to_titlescreen.connect(_on_back_to_titlescreen)
	pause_node.restart.connect(_on_restart)
	pause_node.resume.connect(_on_resume)
	pause_node.options.connect(_on_options)

func on_escape():
	SignalManager.on_button_click.emit()
	_on_resume()


func enter():
	print("Enter GameState Pause")
	pause_node.visible = true
	GameManager.is_paused = true
	infinite_video.video_stream_player.paused = false
	infinite_video.visible = true
	
	pause_node.set_highscore(GameManager.highscore)
	
	
func exit():
	print("Exit GameState Pause")
	pause_node.visible = false
	infinite_video.visible = false
	infinite_video.video_stream_player.paused = true
	
func _on_back_to_titlescreen():
	state_transition.emit(self, "Titlescreen")
	
func _on_restart():
	GameManager.delete_save_file()
	state_transition.emit(self, "ResetGame")
	
func _on_resume():
	state_transition.emit(self, "Playing")

func _on_options():
	state_transition.emit(self, "Options")
