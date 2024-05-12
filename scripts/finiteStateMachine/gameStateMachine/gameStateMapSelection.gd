extends State
class_name GameStateMapSelection

func enter():
	print("Enter GameStateMapSelection")
		
func update(_delta : float):
	if Input.is_action_just_pressed("ui_accept"):
		stateTransition.emit(self, "GameStateDifficultySelection")
	
func physics_update(_delta : float):
	pass
	
func exit():
	print("Exit GameStateMapSelection")
