extends State
class_name GameStatePause

@export var pause_node : Pause = null

func _ready():
	pause_node.back_to_titlescreen.connect(_on_back_to_titlescreen)
	pause_node.restart.connect(_on_restart)
	pause_node.resume.connect(_on_resume)

func enter():
	print("Enter GameState Pause")
	pause_node.visible = true
	GameManager.is_paused = true
	
	
func exit():
	print("Exit GameState Playing")
	pause_node.visible = false
	
func _on_back_to_titlescreen():
	state_transition.emit(self, "Titlescreen")
	
func _on_restart():
	state_transition.emit(self, "ResetGame")
	
func _on_resume():
	state_transition.emit(self, "Playing")
