extends State
class_name GameStateDifficultySelection

func enter():
	print("Enter GameStateDifficultySelection")
		
func update(_delta : float):
	if Input.is_action_just_pressed("ui_accept"):
		stateTransition.emit(self, "GameStateInitGame")
	
func physics_update(_delta : float):
	pass
	
func exit():
	print("Exit GameStateDifficultySelection")
