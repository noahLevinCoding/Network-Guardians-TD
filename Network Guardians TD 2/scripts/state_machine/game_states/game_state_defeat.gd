extends State
class_name GameStateDefeat

@export var defeat_node : Defeat = null

func _ready():
	defeat_node.back_to_titlescreen.connect(_on_back_to_titlescreen)
	defeat_node.restart.connect(_on_restart)

func enter():
	print("Enter GameState Defeat")
	defeat_node.visible = true
	GameManager.is_paused = true
	
	
func _on_back_to_titlescreen():
	state_transition.emit(self, "Titlescreen")
	
func _on_restart():
	state_transition.emit(self, "ResetGame")	
	
func exit():
	print("Enter GameState Defeat")
	defeat_node.visible = false
	
	
