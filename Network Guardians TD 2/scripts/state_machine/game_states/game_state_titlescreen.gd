extends State
class_name GameStateTitlescreen

@export var titlescreen_node : Titlescreen = null
	
func _ready():
	titlescreen_node.play.connect(_on_play)
	titlescreen_node.exit.connect(_on_exit)

func enter():
	print("Enter GameState Titlescreen")
	titlescreen_node.visible = true
	
func exit():
	print("Exit GameState Titlescreen")
	titlescreen_node.visible = false
	

func _on_play():
	state_transition.emit(self, "MapSelection")
	
func _on_exit():
	get_tree().quit()
