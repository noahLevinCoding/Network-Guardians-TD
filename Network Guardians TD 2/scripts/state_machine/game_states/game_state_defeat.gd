extends State
class_name GameStateDefeat

@export var defeat_node : Defeat = null
@export var playing_node : Playing = null

func _ready():
	defeat_node.back_to_titlescreen.connect(_on_back_to_titlescreen)
	defeat_node.restart.connect(_on_restart)

func enter():
	print("Enter GameState Defeat")
	playing_node.visible = true
	playing_node.pause_button.visible = false
	defeat_node.visible = true
	GameManager.is_paused = true
	GameManager.delete_save_file()
	
	if GameManager.wave_index > GameManager.highscore:
		GameManager.save_highscore()
		
	
	defeat_node.set_score(GameManager.wave_index)
	defeat_node.set_highscore(GameManager.highscore)

	
func _on_back_to_titlescreen():
	state_transition.emit(self, "Titlescreen")
	
func _on_restart():
	state_transition.emit(self, "ResetGame")	
	
func exit():
	print("Enter GameState Defeat")
	defeat_node.visible = false
	playing_node.visible = false
	playing_node.pause_button.visible = true
	
